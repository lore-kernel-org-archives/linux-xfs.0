Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CEAD77F37
	for <xfs@oss.sgi.com>; Mon, 30 Nov 2015 10:14:44 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6CBB6AC004
	for <xfs@oss.sgi.com>; Mon, 30 Nov 2015 08:14:41 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id U9ZYeuhUCuuXsmnB (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 30 Nov 2015 08:14:40 -0800 (PST)
Date: Mon, 30 Nov 2015 11:14:38 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: sleeps and waits during io_submit
Message-ID: <20151130161438.GD24765@bfoster.bfoster>
References: <CAD-J=zZh1dtJsfrW_Gwxjg+qvkZMu7ED-QOXrMMO6B-G0HY2-A@mail.gmail.com>
	<20151130141000.GC24765@bfoster.bfoster>
	<565C5D39.8080300@scylladb.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <565C5D39.8080300@scylladb.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Avi Kivity <avi@scylladb.com>
Cc: Glauber Costa <glauber@scylladb.com>, xfs@oss.sgi.com

On Mon, Nov 30, 2015 at 04:29:13PM +0200, Avi Kivity wrote:
> 
> 
> On 11/30/2015 04:10 PM, Brian Foster wrote:
> >>2) xfs_buf_lock -> down
> >>This is one I truly don't understand. What can be causing contention
> >>in this lock? We never have two different cores writing to the same
> >>buffer, nor should we have the same core doingCAP_FOWNER so.
> >>
> >This is not one single lock. An XFS buffer is the data structure used to
> >modify/log/read-write metadata on-disk and each buffer has its own lock
> >to prevent corruption. Buffer lock contention is possible because the
> >filesystem has bits of "global" metadata that has to be updated via
> >buffers.
> >
> >For example, usually one has multiple allocation groups to maximize
> >parallelism, but we still have per-ag metadata that has to be tracked
> >globally with respect to each AG (e.g., free space trees, inode
> >allocation trees, etc.). Any operation that affects this metadata (e.g.,
> >block/inode allocation) has to lock the agi/agf buffers along with any
> >buffers associated with the modified btree leaf/node blocks, etc.
> >
> >One example in your attached perf traces has several threads looking to
> >acquire the AGF, which is a per-AG data structure for tracking free
> >space in the AG. One thread looks like the inode eviction case noted
> >above (freeing blocks), another looks like a file truncate (also freeing
> >blocks), and yet another is a block allocation due to a direct I/O
> >write. Were any of these operations directed to an inode in a separate
> >AG, they would be able to proceed in parallel (but I believe they would
> >still hit the same codepaths as far as perf can tell).
> 
> I guess we can mitigate (but not eliminate) this by creating more allocation
> groups.  What is the default value for agsize?  Are there any downsides to
> decreasing it, besides consuming more memory?
> 

I suppose so, but I would be careful to check that you actually see
contention and test that increasing agcount actually helps. As
mentioned, I'm not sure off hand if the perf trace alone would look any
different if you have multiple metadata operations in progress on
separate AGs.

My understanding is that there are diminishing returns to high AG counts
and usually 32-64 is sufficient for most storage. Dave might be able to
elaborate more on that... (I think this would make a good FAQ entry,
actually).

The agsize/agcount mkfs-time heuristics change depending on the type of
storage. A single AG can be up to 1TB and if the fs is not considered
"multidisk" (e.g., no stripe unit/width is defined), 4 AGs is the
default up to 4TB. If a stripe unit is set, the agsize/agcount is
adjusted depending on the size of the overall volume (see
xfsprogs-dev/mkfs/xfs_mkfs.c:calc_default_ag_geometry() for details).

> Are those locks held around I/O, or just CPU operations, or a mix?

I believe it's a mix of modifications and I/O, though it looks like some
of the I/O cases don't necessarily wait on the lock. E.g., the AIL
pushing case will trylock and defer to the next list iteration if the
buffer is busy.

Brian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
