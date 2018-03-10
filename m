Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:44699 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750884AbeCJJqf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 10 Mar 2018 04:46:35 -0500
Date: Sat, 10 Mar 2018 10:46:33 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v5 02/11] xfs, dax: introduce xfs_dax_aops
Message-ID: <20180310094633.GA31604@lst.de>
References: <152066488891.40260.14605734226832760468.stgit@dwillia2-desk3.amr.corp.intel.com> <152066489984.40260.2215636951958334858.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152066489984.40260.2215636951958334858.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, Jeff Moyer <jmoyer@redhat.com>, Christoph Hellwig <hch@lst.de>, Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

> +int dax_set_page_dirty(struct page *page)
> +{
> +	/*
> +	 * Unlike __set_page_dirty_no_writeback that handles dirty page
> +	 * tracking in the page object, dax does all dirty tracking in
> +	 * the inode address_space in response to mkwrite faults. In the
> +	 * dax case we only need to worry about potentially dirty CPU
> +	 * caches, not dirty page cache pages to write back.
> +	 *
> +	 * This callback is defined to prevent fallback to
> +	 * __set_page_dirty_buffers() in set_page_dirty().
> +	 */
> +	return 0;
> +}

Make this a generic noop_set_page_dirty maybe?

> +EXPORT_SYMBOL(dax_set_page_dirty);
> +
> +void dax_invalidatepage(struct page *page, unsigned int offset,
> +		unsigned int length)
> +{
> +	/*
> +	 * There is no page cache to invalidate in the dax case, however
> +	 * we need this callback defined to prevent falling back to
> +	 * block_invalidatepage() in do_invalidatepage().
> +	 */
> +}

Same here.

> +EXPORT_SYMBOL(dax_invalidatepage);

And EXPORT_SYMBOL_GPL for anything dax-related, please.

> +const struct address_space_operations xfs_dax_aops = {
> +	.writepages		= xfs_vm_writepages,

Please split out the DAX case from xfs_vm_writepages.

This patch should probably also split into VFS and XFS parts.
