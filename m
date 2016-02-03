Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 468197CA1
	for <xfs@oss.sgi.com>; Wed,  3 Feb 2016 15:52:03 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A55B9AC006
	for <xfs@oss.sgi.com>; Wed,  3 Feb 2016 13:52:02 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	nrbCFYHzU0h3vNpl for <xfs@oss.sgi.com>;
	Wed, 03 Feb 2016 13:51:59 -0800 (PST)
Date: Thu, 4 Feb 2016 08:51:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Request for information on bloated writes using Swift
Message-ID: <20160203215144.GE459@dastard>
References: <CAFHL4X1JU02LFYntkqhYg1N++ZU46ML3v5higo1nRsPyoZxL5A@mail.gmail.com>
	<56B16A3C.1030207@sandeen.net>
	<CAFHL4X0QBtFpz3=HMVMrp6NoaW5BRkDSoTE1yJQvQ=0JrW5+YQ@mail.gmail.com>
	<20160203063705.GB459@dastard>
	<CAFHL4X0m8Ov+zJxteUJJxzEHVXpJsfe=9mtapRmWkhT6VRkDxg@mail.gmail.com>
	<20160203083016.GD459@dastard> <56B21690.2070304@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56B21690.2070304@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Dilip Simha <nmdilipsimha@gmail.com>, xfs@oss.sgi.com

On Wed, Feb 03, 2016 at 09:02:40AM -0600, Eric Sandeen wrote:
> 
> 
> On 2/3/16 2:30 AM, Dave Chinner wrote:
> > On Tue, Feb 02, 2016 at 11:09:15PM -0800, Dilip Simha wrote:
> >> Hi Dave,
> >>
> >> On Tue, Feb 2, 2016 at 10:37 PM, Dave Chinner <david@fromorbit.com> wrote:
> >>
> >>> On Tue, Feb 02, 2016 at 07:40:34PM -0800, Dilip Simha wrote:
> >>>> Hi Eric,
> >>>>
> >>>> Thank you for your quick reply.
> >>>>
> >>>> Using xfs_io as per your suggestion, I am able to reproduce the issue.
> >>>> However, I need to falloc for 256K and write for 257K to see this issue.
> >>>>
> >>>> # xfs_io -f -c "falloc 0 256k" -c "pwrite 0 257k" /srv/node/r1/t1.txt
> >>>> # stat /srv/node/r1/t4.txt | grep Blocks
> >>>>   Size: 263168     Blocks: 1536       IO Block: 4096   regular file
> >>>
> >>> Fallocate sets the XFS_DIFLAG_PREALLOC on the inode.
> >>>
> >>> When you writing *past the preallocated area* and do delayed
> >>> allocation, the speculative preallocation beyond EOF is double the
> >>> size of the extent at EOF. i.e. 512k, leading to 768k being
> >>> allocated to the file (1536 blocks, exactly).
> >>>
> >>
> >> Thank you for the details.
> >> This is exactly where I am a bit perplexed. Since the reclamation logic
> >> skips inodes that have the XFS_DIFLAG_PREALLOC flag set, why did the
> >> allocation logic allot more blocks on such an inode?
> > 
> > To store the data you wrote outside the preallocated region, of
> > course.
> 
> I think what Dilip meant was, why does it do preallocation, not
> why does it allocate blocks for the data.  That part is obvious
> of course.  ;)
> 
> IOWS, if XFS_DIFLAG_PREALLOC prevents speculative preallocation
> from being reclaimed, why is speculative preallocation added to files
> with that flag set?
> 
> Seems like a fair question, even if Swift's use of preallocation is
> ill-advised.
> 
> I don't have all the speculative preallocation heuristics in my
> head like you do Dave, but if I have it right, and it's i.e.:
> 
> 1) preallocate 256k
> 2) inode gets XFS_DIFLAG_PREALLOC
> 3) write 257k
> 4) inode gets speculative preallocation added due to write past EOF
> 5) inode never gets preallocation trimmed due to XFS_DIFLAG_PREALLOC
>
> that seems suboptimal.

So do things the other way around:

1) write 257k
2) preallocate 256k beyond EOF and speculative prealloc region
3) inode gets XFS_DIFLAG_PREALLOC
4) inode never gets preallocation trimmed due to XFS_DIFLAG_PREALLOC

This is correct behaviour.

How do you tell them apart, and in what context can we actually
determine that we need to remove the inode flag?

Consider the fact that the 'write 257k' doesn't actually do any
modification to the extent list. i.e. we still have 256k of
persistent preallocation as unwritten extents. These do not
converted to written extents until writeback *completes*, so if we
crash before writeback, the inode remains with only 256k of
preallocated, unwritten extents. speculative prealloc in memory occurs in the
write() context, physical allocation occurs in the writeback
context, and inode size updates occur at IO completion.

i.e. none of these contexts have enough information to be able to
determine whether the XFS_DIFLAG_PREALLOC needs to be removed,
because it cannot be removed until all the persistent prealloc has
been written over *and* the new EOF is stable on disk.

Further, what about persistent preallocation in the middle of the
file? Do we remove the XFS_DIFLAG_PREALLOC while that still exists
as unwritten extents? This gets especially interesting once we
consider the behaviour reflink, COW and dedupe should have on such
extents....

As I said: This is anything but simple, and it's not going to get
any simpler any time soon.

> Never doing speculative preallocation on files with XFS_DIFLAG_PREALLOC
> set, regardless of file offset, would seem sane to me.  App asked
> to take control via prealloc; let it have it, and leave it at that.

We don't do speculative prealloc on inodes that already have blocks
beyond EOF. We already detect that case and don't do speculative
prealloc. But when there aren't blocks beyond EOF, extending
writes should use speculative preallocation.

But if we decide that we don't do speculative prealloc when
XFS_DIFLAG_PREALLOC is set, then workloads that mis-use fallocate
(like swift), or use fallocate to fill sparse holes in files are
going fragment the hell out of their files when they extending
them.

In reality, if swift is really just writing 1k past the prealloc'd
range it creates, then that is clearly an application bug. Further,
if swift is only ever preallocating the first 256k of each file it
writes, regardless of size, then that is also an application bug.

If such users don't like the fact their application is badly written
and interacts badly with a filesystem feature that is, in general,
the best behaviour to have, then they can either (1) get the
application fixed, or (2) set mount options to turn off the feature
that the application bugs interact badly with.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
