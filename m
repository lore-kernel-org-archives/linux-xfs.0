Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 01 May 2008 06:16:52 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m41DGgur032203
	for <xfs@oss.sgi.com>; Thu, 1 May 2008 06:16:46 -0700
Date: Thu, 1 May 2008 09:17:25 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: REVIEW: ASCII CI support in xfsprogs
Message-ID: <20080501131725.GB7435@infradead.org>
References: <op.uagkf9jl3jf8g2@pc-bnaujok.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.uagkf9jl3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

On Thu, May 01, 2008 at 02:37:11PM +1000, Barry Naujok wrote:
> I've reworked xfsprogs userspace tools from scratch with ASCII CI support
> only. Much simpler than previous patches with Unicode CI.
>
> One issue that sort of bugs me a bit is I've maintained the same output as
> the original IRIX mkfs.xfs with CI mode:
> naming   =version 2              bsize=4096   mixed-case=Y|N
>
> where "N" = CI enabled and "Y" = normal case-senstive filesystem.
>
> Should this be changed to something clearer?

I'd prefer something cleaner.  Like case-insensitive=Y|N.  Otherwise
the patch looks fine, but I wonder if you shouldn't better backport the
xfs_dir* files from the kernel completely instead of applying the
changes selectively, otherwise we'll get totoally out of sync codebases.
