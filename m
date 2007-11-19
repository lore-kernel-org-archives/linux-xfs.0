Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 19 Nov 2007 05:07:04 -0800 (PST)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lAJD7079023651
	for <xfs@oss.sgi.com>; Mon, 19 Nov 2007 05:07:01 -0800
Date: Mon, 19 Nov 2007 12:39:18 +0000
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: REVIEW: xfs_reno #2
Message-ID: <20071119123918.GA15942@infradead.org>
References: <op.tznnweh23jf8g2@pc-bnaujok.melbourne.sgi.com> <473D32D9.2020500@sgi.com> <473D36AC.7040507@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <473D36AC.7040507@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: Vlad Apostolov <vapo@sgi.com>, Barry Naujok <bnaujok@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

On Fri, Nov 16, 2007 at 05:20:28PM +1100, Timothy Shimmin wrote:
> Vlad Apostolov wrote:
> >
> >When the XFS parent pointers feature is released we would need to find
> >out to update the EA to point to the new inode parent directory. This may
> >not be that easy though.
> >
> Really?
> Apart from the swapping of extents, reno uses standard calls doesn't it,
> in which case any movement of inodes will have the parent pointers
> updated by the normal vnode ops (e.g. mkdir, rename) in the kernel.

What parent pointers?
