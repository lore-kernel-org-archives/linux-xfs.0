Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 09 Jan 2007 16:11:33 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l0A0BPqw006749
	for <xfs@oss.sgi.com>; Tue, 9 Jan 2007 16:11:28 -0800
Date: Wed, 10 Jan 2007 11:10:28 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Review: fix mapping invalidation callouts
Message-ID: <20070110001028.GO33919298@melbourne.sgi.com>
References: <20070108040309.GX33919298@melbourne.sgi.com> <20070108090916.GA17121@infradead.org> <20070108230429.GB33919298@melbourne.sgi.com> <45A38332.40506@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45A38332.40506@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: David Chinner <dgc@sgi.com>, Christoph Hellwig <hch@infradead.org>, xfs-dev@sgi.com, xfs@oss.sgi.com

On Tue, Jan 09, 2007 at 11:57:38AM +0000, Lachlan McIlroy wrote:
> 
> This patch fixes fs_tosspages() and fs_flushinval_pages() but will a
> call to fs_flush_pages() with flags including B_INVAL work correctly?

By definition fs_flush_pages() only flushes pages. If you need
to flush and invalidate pages, you use fs_flushinval_pages().

Passing B_INVAL to fs_flush_pages() is broken code.

> I can't see any code that passes B_INVAL into fs_flush_pages()

good ;)

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
