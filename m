Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 12 Nov 2008 02:11:06 -0800 (PST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mACAAxn2002491
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 02:10:59 -0800
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C3EB5154AC07
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 02:10:59 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id 2Y92GJcGBsHFIYO1 for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 02:10:59 -0800 (PST)
Date: Wed, 12 Nov 2008 05:09:58 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] XFS: random cleanups of xfs_swap_extents
Message-ID: <20081112100958.GB32567@infradead.org>
References: <20081107230054.GH26208@josefsipek.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081107230054.GH26208@josefsipek.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
Cc: XFS Mailing List <xfs@oss.sgi.com>

On Fri, Nov 07, 2008 at 06:00:54PM -0500, Josef 'Jeff' Sipek wrote:
> XFS: random cleanups of xfs_swap_extents
> 
> From: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
> 
> 1) remove lock_flags var since it's never modified and only obfuscates the
> code
> 
> 2) calling kfree/vfree on a NULL is valid

Looks good to me, but I'd go even further and kill the stupid locked
variable by having the exit path structured as:

 out_trans_cancel:
	xfs_trans_cancel(tp, 0);
 out_unlock:
	xfs_iunlock(ip,  XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
	xfs_iunlock(tip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
 out_free:
	kmem_free(tempifp);
 out:
	return error;
}

With the one case that does a trans_cancel with partially unlocked
inodes handcoding most of it.
