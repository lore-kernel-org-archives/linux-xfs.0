Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 15 Sep 2008 14:10:07 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8FLA5fO031177
	for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 14:10:05 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ED2B112A808B
	for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 14:11:36 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id k9ratlXmPifAuoqB for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 14:11:36 -0700 (PDT)
Date: Mon, 15 Sep 2008 17:11:36 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] XFS: Never call mark_inode_dirty_sync() directly
Message-ID: <20080915211136.GB29743@infradead.org>
References: <1221314627-29065-1-git-send-email-david@fromorbit.com> <1221314627-29065-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221314627-29065-4-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Sun, Sep 14, 2008 at 12:03:47AM +1000, Dave Chinner wrote:
> Once the Linux inode and the XFS inode are combined, we cannot rely
> on just check if the linux inode exists as a method of determining
> if it is valid or not. Hence we should always call
> xfs_mark_inode_dirty_sync() instead as it does the correct checks to
> determine if the liinux inode is in a valid state or not.

Looks good.
