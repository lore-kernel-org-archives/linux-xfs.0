Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 039D67CA0
	for <xfs@oss.sgi.com>; Sun, 10 Apr 2016 13:40:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A2C0E8F8033
	for <xfs@oss.sgi.com>; Sun, 10 Apr 2016 11:40:34 -0700 (PDT)
Received: from mail-yw0-f175.google.com (mail-yw0-f175.google.com
	[209.85.161.175]) by cuda.sgi.com with ESMTP id
	cB82ibu9yBK33DIX (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 10 Apr 2016 11:40:30 -0700 (PDT)
Received: by mail-yw0-f175.google.com with SMTP id o66so94651111ywc.3
	for <xfs@oss.sgi.com>; Sun, 10 Apr 2016 11:40:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160408224648.GD567@dastard>
References: <f049419a2ab10f8e3c4fef0e4f4ca1ba@mail.gmail.com>
	<20160322121922.GA53693@bfoster.bfoster>
	<232dd85fde11d4ef1625f070eabfd167@mail.gmail.com>
	<20160408224648.GD567@dastard>
Date: Sun, 10 Apr 2016 21:40:29 +0300
Message-ID: <CAOcd+r0s3FfahxaqfJKuZ_D+0FbUHaKqi8b_bwGbXekCN3w_oQ@mail.gmail.com>
Subject: Re: XFS hung task in xfs_ail_push_all_sync() when unmounting FS after
	disk failure/recovery
From: Alex Lyakas <alex@zadarastorage.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Shyam Kaushik <shyam@zadarastorage.com>, Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

Hello Dave,

On Sat, Apr 9, 2016 at 1:46 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Fri, Apr 08, 2016 at 04:21:02PM +0530, Shyam Kaushik wrote:
>> Hi Dave, Brian, Carlos,
>>
>> While trying to reproduce this issue I have been running into different
>> issues that are similar. Underlying issue remains the same when backend to
>> XFS is failed & we unmount XFS, we run into hung-task timeout (180-secs)
>> with stack like
>>
>> kernel: [14952.671131]  [<ffffffffc06a5f59>]
>> xfs_ail_push_all_sync+0xa9/0xe0 [xfs]
>> kernel: [14952.671139]  [<ffffffff810b26b0>] ?
>> prepare_to_wait_event+0x110/0x110
>> kernel: [14952.671181]  [<ffffffffc0690111>] xfs_unmountfs+0x61/0x1a0
>> [xfs]
>>
>> while running trace-events, XFS ail push keeps looping around
>>
>>    xfsaild/dm-10-21143 [001] ...2 17878.555133: xfs_ilock_nowait: dev
>> 253:10 ino 0x0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
>
> Looks like either a stale inode (which should never reach the AIL)
> or it's an inode that's been reclaimed and this is a use after free
> situation. Given that we are failing IOs here, I'd suggest it's more
> likely to be an IO failure that's caused a writeback problem, not an
> interaction with stale inodes.
>
> So, look at xfs_iflush. If an IO fails, it is supposed to unlock the
> inode by calling xfs_iflush_abort(), which will also remove it from
> the AIL. This can also happen on reclaim of a dirty inode, and if so
> we'll still reclaim the inode because reclaim assumes xfs_iflush()
> cleans up properly.
>
> Which, apparently, it doesn't:
>
>         /*
>          * Get the buffer containing the on-disk inode.
>          */
>         error = xfs_imap_to_bp(mp, NULL, &ip->i_imap, &dip, &bp, XBF_TRYLOCK, 0);
>         if (error || !bp) {
>                 xfs_ifunlock(ip);
>                 return error;
>         }
>
> This looks like a bug - xfs_iflush hasn't aborted the inode
> writeback on failure - it's just unlocked the flush lock. Hence it
> has left the inode dirty in the AIL, and then the inode has probably
> then been reclaimed, setting the inode number to zero.
In our case, we do not reach this call, because XFS is already marked
as "shutdown", so in our case we do:
    /*
     * This may have been unpinned because the filesystem is shutting
     * down forcibly. If that's the case we must not write this inode
     * to disk, because the log record didn't make it to disk.
     *
     * We also have to remove the log item from the AIL in this case,
     * as we wait for an empty AIL as part of the unmount process.
     */
    if (XFS_FORCED_SHUTDOWN(mp)) {
        error = -EIO;
        goto abort_out;
    }

So we call xfs_iflush_abort, but due to "iip" being NULL (as Shyam
mentioned earlier in this thread), we proceed directly to
xfs_ifunlock(ip), which now becomes the same situation as you
described above.

The comment clearly says "We also have to remove the log item from the
AIL in this case, as we wait for an empty AIL as part of the unmount
process." Could you perhaps point us at the code that is supposed to
remove the log item from the AIL? Apparently this is not happening.

Thanks,
Alex.



>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
