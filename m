Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33930 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751717AbdHaQj4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 31 Aug 2017 12:39:56 -0400
Date: Thu, 31 Aug 2017 12:39:54 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: fix incorrect log_flushed on fsync
Message-ID: <20170831163954.GH21939@bfoster.bfoster>
References: <1504100302-3297-1-git-send-email-amir73il@gmail.com>
 <20170831134722.GA6912@lst.de>
 <CAOQ4uxgrdijqVpFm+rZ4JE_ZY0A_CZdSPHQEb8S1_R_dyJYzSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgrdijqVpFm+rZ4JE_ZY0A_CZdSPHQEb8S1_R_dyJYzSg@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J . Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Josef Bacik <jbacik@fb.com>, "stable [v4.9]" <stable@vger.kernel.org>

On Thu, Aug 31, 2017 at 05:37:06PM +0300, Amir Goldstein wrote:
> On Thu, Aug 31, 2017 at 4:47 PM, Christoph Hellwig <hch@lst.de> wrote:
> > I think something like the following patch (totally untested,
> > just an idea) should fix the issue, right?
> 
> I think that is not enough.
> 
> >
> > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > index c4893e226fd8..555fcae9a18f 100644
> > --- a/fs/xfs/xfs_file.c
> > +++ b/fs/xfs/xfs_file.c
> > @@ -135,7 +135,7 @@ xfs_file_fsync(
> >         struct xfs_inode        *ip = XFS_I(inode);
> >         struct xfs_mount        *mp = ip->i_mount;
> >         int                     error = 0;
> > -       int                     log_flushed = 0;
> > +       unsigned int            flushseq;
> >         xfs_lsn_t               lsn = 0;
> >
> >         trace_xfs_file_fsync(ip);
> > @@ -143,6 +143,7 @@ xfs_file_fsync(
> >         error = file_write_and_wait_range(file, start, end);
> >         if (error)
> >                 return error;
> > +       flushseq = READ_ONCE(mp->m_flushseq);
> 
> imagine that flush was submitted and completed before
> file_write_and_wait_range() but m_flushseq incremented  after.
> maybe here READ m_flush_submitted_seq...
> 
> >
> >         if (XFS_FORCED_SHUTDOWN(mp))
> >                 return -EIO;
> > @@ -181,7 +182,7 @@ xfs_file_fsync(
> >         }
> >
> >         if (lsn) {
> > -               error = _xfs_log_force_lsn(mp, lsn, XFS_LOG_SYNC, &log_flushed);
> > +               error = _xfs_log_force_lsn(mp, lsn, XFS_LOG_SYNC, NULL);
> >                 ip->i_itemp->ili_fsync_fields = 0;
> >         }
> >         xfs_iunlock(ip, XFS_ILOCK_SHARED);
> > @@ -193,8 +194,9 @@ xfs_file_fsync(
> >          * an already allocated file and thus do not have any metadata to
> >          * commit.
> >          */
> > -       if (!log_flushed && !XFS_IS_REALTIME_INODE(ip) &&
> > -           mp->m_logdev_targp == mp->m_ddev_targp)
> > +       if (!XFS_IS_REALTIME_INODE(ip) &&
> > +           mp->m_logdev_targp == mp->m_ddev_targp &&
> > +           flushseq == READ_ONCE(mp->m_flushseq))
> 
> ... and here READ m_flush_completed_seq
> if (m_flush_completed_seq > m_flush_submitted_seq)
> it is safe to skip issue flush.
> Then probably READ_ONCE() is not enough and need smb_rmb?
> 

IIUC, basically we need to guarantee that a flush submits after
file_write_and_wait() and completes before we return. If we do something
like the above, I wonder if that means we could wait for the submit ==
complete if we observe submit was bumped since it was initially sampled
above (rather than issue another flush, which would be necessary if a
submit hadn't occurred))..?

If we do end up with something like this, I think it's a bit cleaner to
stuff the counter(s) in the xfs_buftarg structure and update them from
the generic buffer submit/completion code based on XBF_FLUSH. FWIW, I
suspect we could also update said counter(s) from
xfs_blkdev_issue_flush().

Brian

> >                 xfs_blkdev_issue_flush(mp->m_ddev_targp);
> >
> >         return error;
> > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > index bcb2f860e508..3c0cbb98581e 100644
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -2922,6 +2922,8 @@ xlog_state_done_syncing(
> >                 iclog->ic_state = XLOG_STATE_DONE_SYNC;
> >         }
> >
> > +       log->l_mp->m_flushseq++;
> 
> I recon this should use WRITE_ONCE or smp_wmb()
> and then also increment m_flush_submitted_seq *before*
> issueing flush
> 
> If state machine does not allow more than a single flush
> to be in flight (?) then the 2 seq counters could be reduced
> to single seq counter with (m_flushseq % 2) == 1 for submitted
> and  (m_flushseq % 2) == 0 for completed and the test in fsync
> would be (flushseq % 2) == (READ_ONCE(mp->m_flushseq) % 2)
> 
> ... maybe?
> 
> Amir.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
