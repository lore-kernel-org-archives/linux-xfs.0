Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAOK28aT154437 for <xfs@oss.sgi.com>; Wed, 24 Nov 2010 14:02:10 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C42B01A5E70
	for <xfs@oss.sgi.com>; Wed, 24 Nov 2010 12:03:47 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id d8AeFWjv0ty8FGs0 for
	<xfs@oss.sgi.com>; Wed, 24 Nov 2010 12:03:47 -0800 (PST)
Date: Wed, 24 Nov 2010 15:03:41 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS reclaim lock order bug
Message-ID: <20101124200341.GA2493@infradead.org>
References: <20101123121802.GA4785@amd>
 <20101123211258.GY22876@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101123211258.GY22876@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Nick Piggin <npiggin@kernel.dk>, xfs@oss.sgi.com

On Wed, Nov 24, 2010 at 08:12:58AM +1100, Dave Chinner wrote:
> It is supposed to be handled by the re-initialisation of the
> ip->i_iolock in ->evict_inode (xfs_fs_evict_inode). An inode found
> in the reclaim state must have passed through this reinitialisation,
> so from a lockdep perspective the iolock in the vfs path is a
> different context to the iolock in the reclaim path. That fixed all
> the non-reclaim state related lockdep false positives, so Perhaps
> there is an issue with the lockdep reclaim state checking that does
> not interact well with re-initialised lock contexts?

I've been looking through this again, and I think it's indeed not
enough.  We don't just need to re-initialize it, but also set a
different lockclass for it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
