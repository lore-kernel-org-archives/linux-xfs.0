Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33264 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727302AbeJFRiS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 6 Oct 2018 13:38:18 -0400
Date: Sat, 6 Oct 2018 03:35:31 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 04/15] xfs: update ctime and remove suid before cloning
 files
Message-ID: <20181006103531.GC25747@infradead.org>
References: <153870027422.29072.7433543674436957232.stgit@magnolia>
 <153870030069.29072.11055871953561649172.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153870030069.29072.11055871953561649172.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, ocfs2-devel@oss.oracle.com, sandeen@redhat.com

>  STATIC int
>  xfs_reflink_remap_prep(
> @@ -1302,6 +1303,30 @@ xfs_reflink_remap_prep(
>  	/* Zap any page cache for the destination file's range. */
>  	truncate_inode_pages_range(&inode_out->i_data, pos_out,
>  				   PAGE_ALIGN(pos_out + len) - 1);
> +
> +	/* If we're altering the file contents... */
> +	if (!is_dedupe) {

Nipick - even a clone might not alter the file content, we just have
no guarantee.  So maybe change the comment to:

	/* If we may alter the file contents.. */

Otherwise looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
