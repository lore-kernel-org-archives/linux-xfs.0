Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 821757F37
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 03:08:56 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 71B788F8033
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 01:08:53 -0800 (PST)
Received: from mail-wm0-f46.google.com (mail-wm0-f46.google.com
	[74.125.82.46]) by cuda.sgi.com with ESMTP id Bye6G0eaNvDwP4lx
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 01 Dec 2015 01:08:49 -0800 (PST)
Received: by wmec201 with SMTP id c201so194840123wme.0
	for <xfs@oss.sgi.com>; Tue, 01 Dec 2015 01:08:49 -0800 (PST)
Subject: Re: sleeps and waits during io_submit
References: <CAD-J=zZh1dtJsfrW_Gwxjg+qvkZMu7ED-QOXrMMO6B-G0HY2-A@mail.gmail.com>
	<20151130141000.GC24765@bfoster.bfoster>
	<565C5D39.8080300@scylladb.com>
	<20151130161438.GD24765@bfoster.bfoster>
From: Avi Kivity <avi@scylladb.com>
Message-ID: <565D639F.8070403@scylladb.com>
Date: Tue, 1 Dec 2015 11:08:47 +0200
MIME-Version: 1.0
In-Reply-To: <20151130161438.GD24765@bfoster.bfoster>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: Glauber Costa <glauber@scylladb.com>, xfs@oss.sgi.com

On 11/30/2015 06:14 PM, Brian Foster wrote:
> On Mon, Nov 30, 2015 at 04:29:13PM +0200, Avi Kivity wrote:
>>
>> On 11/30/2015 04:10 PM, Brian Foster wrote:
>>>> 2) xfs_buf_lock -> down
>>>> This is one I truly don't understand. What can be causing contention
>>>> in this lock? We never have two different cores writing to the same
>>>> buffer, nor should we have the same core doingCAP_FOWNER so.
>>>>
>>> This is not one single lock. An XFS buffer is the data structure used to
>>> modify/log/read-write metadata on-disk and each buffer has its own lock
>>> to prevent corruption. Buffer lock contention is possible because the
>>> filesystem has bits of "global" metadata that has to be updated via
>>> buffers.
>>>
>>> For example, usually one has multiple allocation groups to maximize
>>> parallelism, but we still have per-ag metadata that has to be tracked
>>> globally with respect to each AG (e.g., free space trees, inode
>>> allocation trees, etc.). Any operation that affects this metadata (e.g.,
>>> block/inode allocation) has to lock the agi/agf buffers along with any
>>> buffers associated with the modified btree leaf/node blocks, etc.
>>>
>>> One example in your attached perf traces has several threads looking to
>>> acquire the AGF, which is a per-AG data structure for tracking free
>>> space in the AG. One thread looks like the inode eviction case noted
>>> above (freeing blocks), another looks like a file truncate (also freeing
>>> blocks), and yet another is a block allocation due to a direct I/O
>>> write. Were any of these operations directed to an inode in a separate
>>> AG, they would be able to proceed in parallel (but I believe they would
>>> still hit the same codepaths as far as perf can tell).
>> I guess we can mitigate (but not eliminate) this by creating more allocation
>> groups.  What is the default value for agsize?  Are there any downsides to
>> decreasing it, besides consuming more memory?
>>
> I suppose so, but I would be careful to check that you actually see
> contention and test that increasing agcount actually helps. As
> mentioned, I'm not sure off hand if the perf trace alone would look any
> different if you have multiple metadata operations in progress on
> separate AGs.
>
> My understanding is that there are diminishing returns to high AG counts
> and usually 32-64 is sufficient for most storage. Dave might be able to
> elaborate more on that... (I think this would make a good FAQ entry,
> actually).
>
> The agsize/agcount mkfs-time heuristics change depending on the type of
> storage. A single AG can be up to 1TB and if the fs is not considered
> "multidisk" (e.g., no stripe unit/width is defined), 4 AGs is the
> default up to 4TB. If a stripe unit is set, the agsize/agcount is
> adjusted depending on the size of the overall volume (see
> xfsprogs-dev/mkfs/xfs_mkfs.c:calc_default_ag_geometry() for details).

We'll experiment with this.  Surely it depends on more than the amount 
of storage?  If you have a high op rate you'll be more likely to excite 
contention, no?

>
>> Are those locks held around I/O, or just CPU operations, or a mix?
> I believe it's a mix of modifications and I/O, though it looks like some
> of the I/O cases don't necessarily wait on the lock. E.g., the AIL
> pushing case will trylock and defer to the next list iteration if the
> buffer is busy.
>

Ok.  For us sleeping in io_submit() is death because we have no other 
thread on that core to take its place.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
