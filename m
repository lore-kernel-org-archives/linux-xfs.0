Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 19 Aug 2007 12:29:13 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7JJT9bm014263
	for <xfs@oss.sgi.com>; Sun, 19 Aug 2007 12:29:10 -0700
Date: Sun, 19 Aug 2007 20:07:32 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] optimize dmapi event tests w/o dmapi config
Message-ID: <20070819190732.GA2929@infradead.org>
References: <46C7DD96.6030001@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46C7DD96.6030001@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Sun, Aug 19, 2007 at 01:05:10AM -0500, Eric Sandeen wrote:
> Defining XFS_DM_EVENT* macros to 0 in the absence of 
> CONFIG_XFS_DMAPI allows gcc to optimize away tests that 
> should never be true. Also wrap one hunk of xfs_unmount 
> in #ifdef CONFIG_XFS_DMAPI

Sounds useful, especially as dmapi is not in mainline at all.
