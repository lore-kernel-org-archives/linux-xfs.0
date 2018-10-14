Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:53296 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726327AbeJOBZM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 14 Oct 2018 21:25:12 -0400
Date: Sun, 14 Oct 2018 10:43:24 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 18/25] vfs: hide file range comparison function
Message-ID: <20181014174324.GC6400@infradead.org>
References: <153938912912.8361.13446310416406388958.stgit@magnolia>
 <153938927103.8361.6327676425188043040.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153938927103.8361.6327676425188043040.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, sandeen@redhat.com, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

> +static struct page *vfs_dedupe_get_page(struct inode *inode, loff_t offset)
> +{
> +	struct address_space *mapping;
> +	struct page *page;
> +	pgoff_t n;
> +
> +	n = offset >> PAGE_SHIFT;
> +	mapping = inode->i_mapping;
> +	page = read_mapping_page(mapping, n, NULL);
> +	if (IS_ERR(page))
> +		return page;
> +	if (!PageUptodate(page)) {
> +		put_page(page);
> +		return ERR_PTR(-EIO);
> +	}
> +	lock_page(page);
> +	return page;
> +}

Might be worth to clean ths up a bit while you are at it:

+static struct page *vfs_dedupe_get_page(struct inode *inode, loff_t offset)
{
	struct page *page;

	page = read_mapping_page(inode->i_mapping, offset >> PAGE_SHIFT, NULL);
	...

Otherwise looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
