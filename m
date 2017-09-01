Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:59820 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751719AbdIAJrK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 1 Sep 2017 05:47:10 -0400
Date: Fri, 1 Sep 2017 11:47:09 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs: fix incorrect log_flushed on fsync
Message-ID: <20170901094708.GB24482@lst.de>
References: <1504100302-3297-1-git-send-email-amir73il@gmail.com> <20170831134722.GA6912@lst.de> <CAOQ4uxgrdijqVpFm+rZ4JE_ZY0A_CZdSPHQEb8S1_R_dyJYzSg@mail.gmail.com>
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

It's under l_icloglock, so we shouldn't need a WRITE_ONCE.
If we did we'd need an atomic_t.

> If state machine does not allow more than a single flush
> to be in flight (?) then the 2 seq counters could be reduced
> to single seq counter with (m_flushseq % 2) == 1 for submitted
> and  (m_flushseq % 2) == 0 for completed and the test in fsync
> would be (flushseq % 2) == (READ_ONCE(mp->m_flushseq) % 2)

The state machine allows multiple flushes to in flight.
