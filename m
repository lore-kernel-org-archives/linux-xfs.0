Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 10 Oct 2007 03:04:13 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9AA47gf008289
	for <xfs@oss.sgi.com>; Wed, 10 Oct 2007 03:04:10 -0700
Date: Wed, 10 Oct 2007 10:34:51 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: review: use correct buffer flags when reading superblock
Message-ID: <20071010093451.GA7655@infradead.org>
References: <470C8F5B.90705@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <470C8F5B.90705@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Wed, Oct 10, 2007 at 06:37:47PM +1000, Lachlan McIlroy wrote:
> When reading the superblock during log recovery we are not setting
> the correct buffer flags.  Specifically we are not turning off flags
> we do not need such as XBF_ASYNC that is causing the synchronous
> xfs_iowait() to hang.  We should also turn off XBF_WRITE and remove
> the buffer from the delay write queue just to be safe.

Where are these set up in the first time?  AFAICS the buffer only written
out by xfs_unmountfs_writesb, xfs_syncsub and xfs_trans_log_buf, and all
these should only ever happen after log recovery has finished.
