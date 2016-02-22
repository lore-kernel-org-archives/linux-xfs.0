Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 755DB7F6F
	for <xfs@oss.sgi.com>; Mon, 22 Feb 2016 17:56:47 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 17EC0304039
	for <xfs@oss.sgi.com>; Mon, 22 Feb 2016 15:56:41 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Shgu3E1NaK0CsC3q for <xfs@oss.sgi.com>;
	Mon, 22 Feb 2016 15:56:31 -0800 (PST)
Date: Tue, 23 Feb 2016 10:56:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs resize: primary superblock is not updated immediately
Message-ID: <20160222235628.GK25832@dastard>
References: <3685DFAD20214109878873CF81232704@alyakaslap>
	<20160222212019.GI25832@dastard>
	<CAOcd+r1XY2kcp+qJ=mPOAQSmb90QUnLfmT3-FkMjQN_+Ejmt8A@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAOcd+r1XY2kcp+qJ=mPOAQSmb90QUnLfmT3-FkMjQN_+Ejmt8A@mail.gmail.com>
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
To: Alex Lyakas <alex@zadarastorage.com>
Cc: Christoph Hellwig <hch@infradead.org>, Danny Shavit <danny@zadarastorage.com>, xfs@oss.sgi.com

On Tue, Feb 23, 2016 at 12:38:48AM +0200, Alex Lyakas wrote:
> Hi Dave,
> Thanks for your response.
> 
> I am not freezing the filesystem before the snapshot.

There's your problem. A mounted filesystem is not consistent on disk
without flushing the entire journal and all the dirty metadata to
disk.

> However, let's assume that somebody resized the XFS, and it completed
> and got back to user-space. At this moment the primary superblock
> on-disk is not updated yet with the new agcount. And at this same
> moment there is a power-out. After the power comes back and the
> machine boots, if we mount the XFS, the same problem would happen, I
> believe.

Log recovery will run and update the superblock buffer with the correct
values. But the in-memory superblock that log recoery is working
with does not change, and so if there were accesses beyond the
current superblock ag/block count you'd see messages like this:

XFS (sda1): _xfs_buf_find: Block out of range: block 0xnnnnn EOFS 0xmmmmm

and log recovery should fail at that point because it can't pull in
a buffer it needs for recovery to make further progress. At which
point, you have an unmountable filesystem.

If log recovery succeeds, then yes, I can see that there is a
problem here because the per-ag tree is not reinitialised after the
superblock is re-read. That's a pretty easy fix, though (3-4 lines
of code in xlog_do_recover() to detect a change in filesystem block
count and call xfs_initialize_perag() again.

> Taking a block-level snapshot is exactly like a power-out from XFS
> perspective.

It's similar, but it's not the same. e.g. there are no issues like
volatile storage cache loss that have to be handled.

> And XFS should, in principle, be able to recover from
> that.

For some definition of recover. There is no guarantee that any of
the async transactions in memory will make it to disk, so the point
to which XFS can recover is undefined.

> The snapshot will come up as a new block device, which exhibits
> identical content as the original block device had at the moment when
> the snapshot was taken (like a boot after power-out).

The block device might be identical, but it's not identical to what
the filesystem is presenting the user. Any user dirty data cached in
memory, or metadata changes staged in the CIL will not be in the
snapshot. Hence the snapshot block device is not identical to the
original user visible state and data. You only get that if you
freeze the filesystem before taking the snapshot.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
