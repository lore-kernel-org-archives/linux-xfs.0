Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 30 Aug 2007 06:41:55 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7UDfn4p025257
	for <xfs@oss.sgi.com>; Thu, 30 Aug 2007 06:41:51 -0700
Date: Thu, 30 Aug 2007 14:20:02 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: ZFS, XFS, and EXT4 compared
Message-ID: <20070830132002.GA4086@infradead.org>
References: <1188454611.23311.13.camel@toonses.gghcwest.com> <1188457666.24970.94.camel@edge.yarra.acx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1188457666.24970.94.camel@edge.yarra.acx>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nscott@aconex.com>
Cc: "Jeffrey W. Baker" <jwbaker@acm.org>, zfs-discuss@opensolaris.org, xfs@oss.sgi.com, linux-ext4@vger.kernel.org

On Thu, Aug 30, 2007 at 05:07:46PM +1000, Nathan Scott wrote:
> To improve metadata performance, you have many options with XFS (which
> ones are useful depends on the type of metadata workload) - you can try
> a v2 format log, and mount with "-o logbsize=256k", try increasing the
> directory block size (e.g. mkfs.xfs -nsize=16k, etc), and also the log
> size (mkfs.xfs -lsize=XXXXXXb).

Okay, these suggestions are one too often now.  v2 log and large logs/log
buffers are the almost universal suggestions, and we really need to make
these defaults.  XFS is already the laughing stock of the Linux community
due to it's absurdely bad default settings.
