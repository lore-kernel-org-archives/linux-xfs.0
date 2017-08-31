Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:37223 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750968AbdHaTUU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Aug 2017 15:20:20 -0400
MIME-Version: 1.0
In-Reply-To: <20170831163954.GH21939@bfoster.bfoster>
References: <1504100302-3297-1-git-send-email-amir73il@gmail.com>
 <20170831134722.GA6912@lst.de> <CAOQ4uxgrdijqVpFm+rZ4JE_ZY0A_CZdSPHQEb8S1_R_dyJYzSg@mail.gmail.com>
 <20170831163954.GH21939@bfoster.bfoster>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 31 Aug 2017 22:20:19 +0300
Message-ID: <CAOQ4uxisPbcoNp8N8Y4yGdWDBfZ=PR7CgkKGbLGS6cbU6bx2rw@mail.gmail.com>
Subject: Re: [PATCH] xfs: fix incorrect log_flushed on fsync
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J . Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Josef Bacik <jbacik@fb.com>, "stable [v4.9]" <stable@vger.kernel.org>

On Thu, Aug 31, 2017 at 7:39 PM, Brian Foster <bfoster@redhat.com> wrote:
> On Thu, Aug 31, 2017 at 05:37:06PM +0300, Amir Goldstein wrote:
>> On Thu, Aug 31, 2017 at 4:47 PM, Christoph Hellwig <hch@lst.de> wrote:
>> > I think something like the following patch (totally untested,
>> > just an idea) should fix the issue, right?
>>
>> I think that is not enough.
>>
>> >
>> > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
>> > index c4893e226fd8..555fcae9a18f 100644
>> > --- a/fs/xfs/xfs_file.c
>> > +++ b/fs/xfs/xfs_file.c
>> > @@ -135,7 +135,7 @@ xfs_file_fsync(
>> >         struct xfs_inode        *ip = XFS_I(inode);
>> >         struct xfs_mount        *mp = ip->i_mount;
>> >         int                     error = 0;
>> > -       int                     log_flushed = 0;
>> > +       unsigned int            flushseq;
>> >         xfs_lsn_t               lsn = 0;
>> >
>> >         trace_xfs_file_fsync(ip);
>> > @@ -143,6 +143,7 @@ xfs_file_fsync(
>> >         error = file_write_and_wait_range(file, start, end);
>> >         if (error)
>> >                 return error;
>> > +       flushseq = READ_ONCE(mp->m_flushseq);
>>
>> imagine that flush was submitted and completed before
>> file_write_and_wait_range() but m_flushseq incremented  after.
>> maybe here READ m_flush_submitted_seq...
>>
>> >
>> >         if (XFS_FORCED_SHUTDOWN(mp))
>> >                 return -EIO;
>> > @@ -181,7 +182,7 @@ xfs_file_fsync(
>> >         }
>> >
>> >         if (lsn) {
>> > -               error = _xfs_log_force_lsn(mp, lsn, XFS_LOG_SYNC, &log_flushed);
>> > +               error = _xfs_log_force_lsn(mp, lsn, XFS_LOG_SYNC, NULL);
>> >                 ip->i_itemp->ili_fsync_fields = 0;
>> >         }
>> >         xfs_iunlock(ip, XFS_ILOCK_SHARED);
>> > @@ -193,8 +194,9 @@ xfs_file_fsync(
>> >          * an already allocated file and thus do not have any metadata to
>> >          * commit.
>> >          */
>> > -       if (!log_flushed && !XFS_IS_REALTIME_INODE(ip) &&
>> > -           mp->m_logdev_targp == mp->m_ddev_targp)
>> > +       if (!XFS_IS_REALTIME_INODE(ip) &&
>> > +           mp->m_logdev_targp == mp->m_ddev_targp &&
>> > +           flushseq == READ_ONCE(mp->m_flushseq))
>>
>> ... and here READ m_flush_completed_seq
>> if (m_flush_completed_seq > m_flush_submitted_seq)
>> it is safe to skip issue flush.
>> Then probably READ_ONCE() is not enough and need smb_rmb?
>>
>
> IIUC, basically we need to guarantee that a flush submits after
> file_write_and_wait() and completes before we return.

Yeh. unless we check if file_write_and_wait() submitted anything
at all.

> If we do something
> like the above, I wonder if that means we could wait for the submit ==
> complete if we observe submit was bumped since it was initially sampled
> above (rather than issue another flush, which would be necessary if a
> submit hadn't occurred))..?
>
> If we do end up with something like this, I think it's a bit cleaner to
> stuff the counter(s) in the xfs_buftarg structure and update them from
> the generic buffer submit/completion code based on XBF_FLUSH. FWIW, I
> suspect we could also update said counter(s) from
> xfs_blkdev_issue_flush().
>

I think what you are suggesting is to optimize more cases which are
not optimized now. That is probably possible, but also more complicated
to get right and not sure if the workloads that gain from this are important
enough.

If I am not mistaken the way to fix the current optimization is to record
the last SYNC_DONE lsn (which is sort of what Christoph suggested)
and the last WANY_SYNC|ACTIVE lsn.
After  file_write_and_wait() need to save pre_sync_lsn and before
return need to make sure that post_sync_lsn >= pre_sync_lsn or
issue a flush.

Amir.
