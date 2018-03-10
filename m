Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:44754 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751012AbeCJJ4A (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 10 Mar 2018 04:56:00 -0500
Date: Sat, 10 Mar 2018 10:55:58 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v5 11/11] xfs, dax: introduce xfs_break_dax_layouts()
Message-ID: <20180310095558.GC31604@lst.de>
References: <152066488891.40260.14605734226832760468.stgit@dwillia2-desk3.amr.corp.intel.com> <152066494840.40260.6478694186268933246.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152066494840.40260.6478694186268933246.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

> +static int xfs_wait_dax_page(
> +		atomic_t                *count,
> +		unsigned int            mode)
> +{

Normal XFS style would be:

static int
xfs_wait_dax_page(
	atomic_t		*count,
	unsigned int		mode)
{

> +	struct page             *page = refcount_to_page(count);
> +	struct address_space    *mapping = page->mapping;
> +	struct inode            *inode = mapping->host;
> +	struct xfs_inode        *ip = XFS_I(inode);

Looks we don't really need the mapping and inode variables:

	struct page		*page = refcount_to_page(count);
	struct xfs_inode	*ip = XFS_I(page->mapping->host);

> +	do {
> +		if (flags & XFS_BREAK_REMOTE)
> +			ret = xfs_break_leased_layouts(inode, iolock);
> +		if (ret)
> +			return ret;
> +		if (flags & XFS_BREAK_MAPS)
> +			ret = xfs_break_dax_layouts(inode, *iolock);
> +		/*
> +		 * EBUSY indicates that we dropped locks and waited for
> +		 * the dax layout to be released. When that happens we
> +		 * need to revalidate that no new leases or pinned dax
> +		 * mappings have been established.
> +		 */
> +	} while (ret == -EBUSY);

Maybe instead of the flags argument this should be a type argument
of something like

enum layout_break_reason {
	BREAK_WRITE,		/* write to file */
	BREAK_TRUNCATE,		/* truncate or hole punch */
};

as that makes the intent more clear?
