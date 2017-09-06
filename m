Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:51993 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752862AbdIFLlS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 6 Sep 2017 07:41:18 -0400
Date: Wed, 6 Sep 2017 13:41:16 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2] xfs: fix incorrect log_flushed on fsync
Message-ID: <20170906114116.GA25884@lst.de>
References: <1504280365-25354-1-git-send-email-amir73il@gmail.com> <20170902131955.GB36492@bfoster.bfoster> <CAOQ4uxhLTtMV9FSr4um-dYefmpZ0NJseBiQzykxjy15kLqLsww@mail.gmail.com> <20170905144006.GA48515@bfoster.bfoster> <20170905145442.GA6869@lst.de> <20170905153439.GB48515@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170905153439.GB48515@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Amir Goldstein <amir73il@gmail.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Josef Bacik <jbacik@fb.com>, "stable [v4.9]" <stable@vger.kernel.org>

On Tue, Sep 05, 2017 at 11:34:39AM -0400, Brian Foster wrote:
> In xfs_log_force_lsn(), the iclog has to be ACTIVE. We switch it to
> WANT_SYNC, bump the refcnt and call release_iclog(). The latter may or
> may not do anything depending on the refcount. We set log_flushed
> immediately after the release before we know whether an xlog_sync() has
> actually occurred (is that your concern?). If XFS_LOG_SYNC is set, we
> wait on the iclog before _force_lsn() returns, which means the log
> buffer I/O has to have completed before we return either way. If the
> iclog is still WANT_SYNC, the release didn't do anything, but we wait on
> ic_force_wait which is triggered during I/O completion handling. If the
> iclog is already DIRTY/ACTIVE, then the I/O has already submitted and
> completed.
> 
> fsync looks like the only the user of log_flushed and it also uses
> XFS_LOG_SYNC. ISTM that the code is probably still bogus in principle,
> but in practice the fsync code may be safe. Thoughts? Am I missing
> something else?

Yes, I think you're right - the extra XFS_LOG_SYNC code papers over
the issue.  But given that the log_flushed indicator makes very
little sene without XFS_LOG_SYNC it should be ok.
