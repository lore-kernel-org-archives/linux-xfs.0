Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 01 Nov 2007 03:16:10 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lA1AG6bR006267
	for <xfs@oss.sgi.com>; Thu, 1 Nov 2007 03:16:07 -0700
Date: Thu, 1 Nov 2007 10:00:12 +0000
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Turn off XBF_READ_AHEAD in io completion
Message-ID: <20071101100012.GA20065@infradead.org>
References: <47296FF7.8080607@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47296FF7.8080607@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, Nov 01, 2007 at 05:19:35PM +1100, Lachlan McIlroy wrote:
> Read-ahead of an inode cluster will set XBF_READ_AHEAD in the buffer.
> If we don't remove the flag it will still be set when we flush the
> buffer back to disk.  Not sure if leaving this flag set causes any
> serious problems but it does trigger an assert.

It might be better if such temporary flags never actually make it to
bp->b_flags.  Just pass down a flags variable all the way to
_xfs_buf_ioapply and keep the flags just for this I/O separate from
those that are permanent and in bp->b_flags.
