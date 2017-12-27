Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:58906 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750895AbdL0F3T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Dec 2017 00:29:19 -0500
Date: Tue, 26 Dec 2017 21:29:10 -0800
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v4 11/18] fs, dax: introduce DEFINE_FSDAX_AOPS
Message-ID: <20171227052910.GE24828@bombadil.infradead.org>
References: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151407701943.38751.8997225433943672290.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151407701943.38751.8997225433943672290.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: akpm@linux-foundation.org, jack@suse.cz, Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>, linux-fsdevel@vger.kernel.org, ross.zwisler@linux.intel.com, hch@lst.de

On Sat, Dec 23, 2017 at 04:56:59PM -0800, Dan Williams wrote:
> +int dax_set_page_dirty(struct page *page)
> +{
> +	/*
> +	 * Unlike __set_page_dirty_no_writeback, dax does all dirty
> +	 * tracking in the radix in response to mkwrite faults.

Please stop saying "in the radix".  I think you mean "in the page cache".

> +EXPORT_SYMBOL(dax_set_page_dirty);
> +EXPORT_SYMBOL(dax_direct_IO);
> +EXPORT_SYMBOL(dax_writepage);
> +EXPORT_SYMBOL(dax_readpage);
> +EXPORT_SYMBOL(dax_readpages);
> +EXPORT_SYMBOL(dax_write_begin);
> +EXPORT_SYMBOL(dax_write_end);
> +EXPORT_SYMBOL(dax_invalidatepage);

Exporting all these symbols to modules isn't exactly free.  Are you sure it
doesn't make more sense to put tests for dax in the existing aops?

