Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:51636 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbfAQOV1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Jan 2019 09:21:27 -0500
Date: Thu, 17 Jan 2019 06:21:26 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 05/22] xfs: pack inode allocation parameters into a
 separate structure
Message-ID: <20190117142126.GC16270@infradead.org>
References: <154630914104.18437.15354380637179830566.stgit@magnolia>
 <154630917213.18437.11076220872907040413.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154630917213.18437.11076220872907040413.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Dec 31, 2018 at 06:19:32PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Instead of open-coding new inode parameters through xfs_dir_ialloc and
> xfs_Ialloc, put everything into a structure and pass that instead.  This
> will make it easier to share code with xfsprogs while maintaining the
> ability for xfsprogs to supply extra new inode parameters.

I find these ad-hoc arg structures rather cumberssome to be honest.

> +/* Initial ids, link count, device number, and mode of a new inode. */
> +struct xfs_ialloc_args {
> +	struct xfs_inode		*pip;	/* parent inode or null */
> +
> +	uint32_t			uid;
> +	uint32_t			gid;
> +	prid_t				prid;
> +
> +	xfs_nlink_t			nlink;
> +	dev_t				rdev;
> +
> +	umode_t				mode;

And except for the parent inode this is a significant subsystet of
stat data.  Can't we just pass a struct kstat, and a mask of attributes
from the kstat we want to set instead?  That is use a calling convention
similar to ->setattr?
