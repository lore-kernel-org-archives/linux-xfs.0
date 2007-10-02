Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 02 Oct 2007 02:27:14 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l929R81R027851
	for <xfs@oss.sgi.com>; Tue, 2 Oct 2007 02:27:09 -0700
Date: Tue, 2 Oct 2007 10:02:16 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: REVIEW: xfs_reno
Message-ID: <20071002090216.GA22721@infradead.org>
References: <op.tzj549h63jf8g2@pc-bnaujok.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.tzj549h63jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

On Tue, Oct 02, 2007 at 05:08:59PM +1000, Barry Naujok wrote:
> 
> The attached tool allows an inode64 filesystem to be converted to inode32.
> For this to work, the filesystem has to be mounted inode32 before it's run.
> 
> I'm not sure if there is any packaging changes required.

Together with the stop allocating from specific AGs patch this should be
90% towards an xfs_shrinkfs, right?
