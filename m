Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 19 Aug 2007 12:29:11 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7JJT7bm014256
	for <xfs@oss.sgi.com>; Sun, 19 Aug 2007 12:29:08 -0700
Date: Sun, 19 Aug 2007 20:10:10 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V2] make xfs stats Kconfigurable
Message-ID: <20070819191010.GC2929@infradead.org>
References: <46C750C9.8040604@sandeen.net> <46C87C05.5040905@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46C87C05.5040905@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Sun, Aug 19, 2007 at 12:21:09PM -0500, Eric Sandeen wrote:
> Oops, typo in Makefile (CONFIG_XFS_STAT vs _STATS).
> 
> ----
> 
> 
> xfs stats are already optional based on CONFIG_PROC_FS, and there
> is already a (never-set) macro XFS_STATS_OFF which can turn them
> off.  Making it a configurable option, if I turn them off I can
> get a little stack savings on x86, gcc 4.1:

Why would we want to disable the statistics?

> +	config XFS_STATS

Everywhere else the config statement is not indented, so it probably
shouldn't be here either.
