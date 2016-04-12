Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1D6FE7CB1
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 01:59:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C44AF304039
	for <xfs@oss.sgi.com>; Mon, 11 Apr 2016 23:59:55 -0700 (PDT)
Received: from mail-wm0-f46.google.com (mail-wm0-f46.google.com
	[74.125.82.46]) by cuda.sgi.com with ESMTP id 4Yvevth7DPn34mxt
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 11 Apr 2016 23:59:49 -0700 (PDT)
Received: by mail-wm0-f46.google.com with SMTP id u206so14550884wme.1
	for <xfs@oss.sgi.com>; Mon, 11 Apr 2016 23:59:49 -0700 (PDT)
From: Shyam Kaushik <shyam@zadarastorage.com>
References: <f049419a2ab10f8e3c4fef0e4f4ca1ba@mail.gmail.com>
	<20160322121922.GA53693@bfoster.bfoster>
	<232dd85fde11d4ef1625f070eabfd167@mail.gmail.com>
	<20160408224648.GD567@dastard>
	<CAOcd+r0s3FfahxaqfJKuZ_D+0FbUHaKqi8b_bwGbXekCN3w_oQ@mail.gmail.com>
	<20160411012127.GF567@dastard>
In-Reply-To: <20160411012127.GF567@dastard>
MIME-Version: 1.0
Date: Tue, 12 Apr 2016 12:29:48 +0530
Message-ID: <0cfd6b7bfb3ef9dbac02a19a1f8fe568@mail.gmail.com>
Subject: RE: XFS hung task in xfs_ail_push_all_sync() when unmounting FS after
	disk failure/recovery
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
To: Dave Chinner <david@fromorbit.com>, Alex Lyakas <alex@zadarastorage.com>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

Hi Dave,

I posted the patch.

After applying this patch & your use-after-free patch,
xfs_ail_push_all_sync() processing intent-logs that are no longer relevant
upon disk failure/recovery doesn't happen anymore. I tried several times
to recreate and the issue doesn't show up.

Thanks.

--Shyam

-----Original Message-----
From: Dave Chinner [mailto:david@fromorbit.com]
Sent: 11 April 2016 06:51
To: Alex Lyakas
Cc: Shyam Kaushik; Brian Foster; xfs@oss.sgi.com
Subject: Re: XFS hung task in xfs_ail_push_all_sync() when unmounting FS
after disk failure/recovery

On Sun, Apr 10, 2016 at 09:40:29PM +0300, Alex Lyakas wrote:
> Hello Dave,
>
> On Sat, Apr 9, 2016 at 1:46 AM, Dave Chinner <david@fromorbit.com>
wrote:
> > On Fri, Apr 08, 2016 at 04:21:02PM +0530, Shyam Kaushik wrote:
> >> Hi Dave, Brian, Carlos,
> >>
> >> While trying to reproduce this issue I have been running into
different
> >> issues that are similar. Underlying issue remains the same when
backend to
> >> XFS is failed & we unmount XFS, we run into hung-task timeout
(180-secs)
> >> with stack like
> >>
> >> kernel: [14952.671131]  [<ffffffffc06a5f59>]
> >> xfs_ail_push_all_sync+0xa9/0xe0 [xfs]
> >> kernel: [14952.671139]  [<ffffffff810b26b0>] ?
> >> prepare_to_wait_event+0x110/0x110
> >> kernel: [14952.671181]  [<ffffffffc0690111>] xfs_unmountfs+0x61/0x1a0
> >> [xfs]
> >>
> >> while running trace-events, XFS ail push keeps looping around
> >>
> >>    xfsaild/dm-10-21143 [001] ...2 17878.555133: xfs_ilock_nowait: dev
> >> 253:10 ino 0x0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
> >
> > Looks like either a stale inode (which should never reach the AIL)
> > or it's an inode that's been reclaimed and this is a use after free
> > situation. Given that we are failing IOs here, I'd suggest it's more
> > likely to be an IO failure that's caused a writeback problem, not an
> > interaction with stale inodes.
> >
> > So, look at xfs_iflush. If an IO fails, it is supposed to unlock the
> > inode by calling xfs_iflush_abort(), which will also remove it from
> > the AIL. This can also happen on reclaim of a dirty inode, and if so
> > we'll still reclaim the inode because reclaim assumes xfs_iflush()
> > cleans up properly.
> >
> > Which, apparently, it doesn't:
> >
> >         /*
> >          * Get the buffer containing the on-disk inode.
> >          */
> >         error = xfs_imap_to_bp(mp, NULL, &ip->i_imap, &dip, &bp,
XBF_TRYLOCK, 0);
> >         if (error || !bp) {
> >                 xfs_ifunlock(ip);
> >                 return error;
> >         }
> >
> > This looks like a bug - xfs_iflush hasn't aborted the inode
> > writeback on failure - it's just unlocked the flush lock. Hence it
> > has left the inode dirty in the AIL, and then the inode has probably
> > then been reclaimed, setting the inode number to zero.
> In our case, we do not reach this call, because XFS is already marked
> as "shutdown", so in our case we do:
>     /*
>      * This may have been unpinned because the filesystem is shutting
>      * down forcibly. If that's the case we must not write this inode
>      * to disk, because the log record didn't make it to disk.
>      *
>      * We also have to remove the log item from the AIL in this case,
>      * as we wait for an empty AIL as part of the unmount process.
>      */
>     if (XFS_FORCED_SHUTDOWN(mp)) {
>         error = -EIO;
>         goto abort_out;
>     }
>
> So we call xfs_iflush_abort, but due to "iip" being NULL (as Shyam
> mentioned earlier in this thread), we proceed directly to
> xfs_ifunlock(ip), which now becomes the same situation as you
> described above.

If you are getting this occuring, something else has already gone
wrong as you can't have a dirty inode without a log item attached to
it. So it appears to me that you are reporting a symptom of a
problem after it has occured, not the root cause. Maybe it is the
same root cause, maybe not. Either way, it doesn't help us solve any
problem.

> The comment clearly says "We also have to remove the log item from the
> AIL in this case, as we wait for an empty AIL as part of the unmount
> process." Could you perhaps point us at the code that is supposed to
> remove the log item from the AIL? Apparently this is not happening.

xfs_iflush_abort or xfs_iflush_done does that work.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
