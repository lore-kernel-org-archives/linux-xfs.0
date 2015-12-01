Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E05BC7F58
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 07:11:22 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 87800AC003
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 05:11:19 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id IBCbq6mpfkwbry7D (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 01 Dec 2015 05:11:18 -0800 (PST)
Date: Tue, 1 Dec 2015 08:11:16 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: sleeps and waits during io_submit
Message-ID: <20151201131114.GA26129@bfoster.bfoster>
References: <CAD-J=zZh1dtJsfrW_Gwxjg+qvkZMu7ED-QOXrMMO6B-G0HY2-A@mail.gmail.com>
	<20151130141000.GC24765@bfoster.bfoster>
	<565C5D39.8080300@scylladb.com>
	<20151130161438.GD24765@bfoster.bfoster>
	<565D639F.8070403@scylladb.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <565D639F.8070403@scylladb.com>
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

On Tue, Dec 01, 2015 at 11:08:47AM +0200, Avi Kivity wrote:
> On 11/30/2015 06:14 PM, Brian Foster wrote:
> >On Mon, Nov 30, 2015 at 04:29:13PM +0200, Avi Kivity wrote:
> >>
> >>On 11/30/2015 04:10 PM, Brian Foster wrote:
...
> >The agsize/agcount mkfs-time heuristics change depending on the type of
> >storage. A single AG can be up to 1TB and if the fs is not considered
> >"multidisk" (e.g., no stripe unit/width is defined), 4 AGs is the
> >default up to 4TB. If a stripe unit is set, the agsize/agcount is
> >adjusted depending on the size of the overall volume (see
> >xfsprogs-dev/mkfs/xfs_mkfs.c:calc_default_ag_geometry() for details).
> 
> We'll experiment with this.  Surely it depends on more than the amount of
> storage?  If you have a high op rate you'll be more likely to excite
> contention, no?
> 

Sure. The absolute optimal configuration for your workload probably
depends on more than storage size, but mkfs doesn't have that
information. In general, it tries to use the most reasonable
configuration based on the storage and expected workload. If you want to
tweak it beyond that, indeed, the best bet is to experiment with what
works.

> >
> >>Are those locks held around I/O, or just CPU operations, or a mix?
> >I believe it's a mix of modifications and I/O, though it looks like some
> >of the I/O cases don't necessarily wait on the lock. E.g., the AIL
> >pushing case will trylock and defer to the next list iteration if the
> >buffer is busy.
> >
> 
> Ok.  For us sleeping in io_submit() is death because we have no other thread
> on that core to take its place.
> 

The above is with regard to metadata I/O, whereas io_submit() is
obviously for user I/O. io_submit() can probably block in a variety of
places afaict... it might have to read in the inode extent map, allocate
blocks, take inode/ag locks, reserve log space for transactions, etc.

It sounds to me that first and foremost you want to make sure you don't
have however many parallel operations you typically have running
contending on the same inodes or AGs. Hint: creating files under
separate subdirectories is a quick and easy way to allocate inodes under
separate AGs (the agno is encoded into the upper bits of the inode
number). Reducing the frequency of block allocation/frees might also be
another help (e.g., preallocate and reuse files, 'mount -o ikeep,'
etc.). Beyond that, you probably want to make sure the log is large
enough to support all concurrent operations. See the xfs_log_grant_*
tracepoints for a window into if/how long transaction reservations might
be waiting on the log.

Brian

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
