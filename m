Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37572 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751207AbeACQFF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Jan 2018 11:05:05 -0500
Date: Wed, 3 Jan 2018 17:05:03 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v4 11/18] fs, dax: introduce DEFINE_FSDAX_AOPS
Message-ID: <20180103160503.GM4911@quack2.suse.cz>
References: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151407701943.38751.8997225433943672290.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20171227052910.GE24828@bombadil.infradead.org>
 <CAPcyv4ibKYi_zE=V2W_aLghtr3LiC30A2ffFq-aPQCrikwgy2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4ibKYi_zE=V2W_aLghtr3LiC30A2ffFq-aPQCrikwgy2w@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm@lists.01.org, linux-xfs <linux-xfs@vger.kernel.org>, Jeff Moyer <jmoyer@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>

On Tue 02-01-18 12:21:28, Dan Williams wrote:
> >> +EXPORT_SYMBOL(dax_set_page_dirty);
> >> +EXPORT_SYMBOL(dax_direct_IO);
> >> +EXPORT_SYMBOL(dax_writepage);
> >> +EXPORT_SYMBOL(dax_readpage);
> >> +EXPORT_SYMBOL(dax_readpages);
> >> +EXPORT_SYMBOL(dax_write_begin);
> >> +EXPORT_SYMBOL(dax_write_end);
> >> +EXPORT_SYMBOL(dax_invalidatepage);
> >
> > Exporting all these symbols to modules isn't exactly free.  Are you sure it
> > doesn't make more sense to put tests for dax in the existing aops?
> >
> 
> I'd rather have just one global fs_dax_aops instance that all
> filesystems could reference, but ->writepages() is fundamentally an
> address_space_operation. Until we can rework that I'd prefer the
> overhead of the extra exports than sprinkling more IS_DAX checks
> around.

Just for record I agree with what Dave said about this patch. Generic
address_space_operations are not how aops are commonly defined by
filesystems. Just create one structure for each fs as Dave suggested.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
