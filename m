Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 26 Aug 2008 12:14:28 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7QJEOU0000663
	for <xfs@oss.sgi.com>; Tue, 26 Aug 2008 12:14:25 -0700
Date: Tue, 26 Aug 2008 15:15:47 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: REVIEW: Remove convert_extent function in xfs_repair
Message-ID: <20080826191547.GA6638@infradead.org>
References: <op.ugg16sju3jf8g2@pc-bnaujok.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.ugg16sju3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Tue, Aug 26, 2008 at 12:21:54PM +1000, Barry Naujok wrote:
> It seems convert_extent is not that useful, so remove it and call
> libxfs_bmbt_disk_get_all() directly and use the xfs_bmbt_irec_t
> structure directly.

Yes, the new code is much more readable.  The patch looks good to m.
