Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35094 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751382AbdIEPel (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 5 Sep 2017 11:34:41 -0400
Date: Tue, 5 Sep 2017 11:34:39 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2] xfs: fix incorrect log_flushed on fsync
Message-ID: <20170905153439.GB48515@bfoster.bfoster>
References: <1504280365-25354-1-git-send-email-amir73il@gmail.com>
 <20170902131955.GB36492@bfoster.bfoster>
 <CAOQ4uxhLTtMV9FSr4um-dYefmpZ0NJseBiQzykxjy15kLqLsww@mail.gmail.com>
 <20170905144006.GA48515@bfoster.bfoster>
 <20170905145442.GA6869@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170905145442.GA6869@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Amir Goldstein <amir73il@gmail.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Josef Bacik <jbacik@fb.com>, "stable [v4.9]" <stable@vger.kernel.org>

On Tue, Sep 05, 2017 at 04:54:42PM +0200, Christoph Hellwig wrote:
> On Tue, Sep 05, 2017 at 10:40:07AM -0400, Brian Foster wrote:
> > Thanks.. I agree that a rework of the optimization can come later now
> > that the bug is fixed.
> 
> I agree in principle, but I don't think the patch in for-next is enough,
> given that it doesn't take ic_refcnt into account.
> 

Hmm.. Ok, I might be missing something here. In xfs_log_force() at least
it looks like we only set log_flushed if the refcnt has reached zero.

In xfs_log_force_lsn(), the iclog has to be ACTIVE. We switch it to
WANT_SYNC, bump the refcnt and call release_iclog(). The latter may or
may not do anything depending on the refcount. We set log_flushed
immediately after the release before we know whether an xlog_sync() has
actually occurred (is that your concern?). If XFS_LOG_SYNC is set, we
wait on the iclog before _force_lsn() returns, which means the log
buffer I/O has to have completed before we return either way. If the
iclog is still WANT_SYNC, the release didn't do anything, but we wait on
ic_force_wait which is triggered during I/O completion handling. If the
iclog is already DIRTY/ACTIVE, then the I/O has already submitted and
completed.

fsync looks like the only the user of log_flushed and it also uses
XFS_LOG_SYNC. ISTM that the code is probably still bogus in principle,
but in practice the fsync code may be safe. Thoughts? Am I missing
something else?

> > Christoph, are you planning to continue with your flushseq based patch?
> 
> I think it is fundamentally the right thing to do, but given how
> much I've got on my plate I wouldn't mind someone else looking into it :)

Ok, I may be able to take a crack at it...

Brian

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
