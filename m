Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:37173 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751066AbeABUV3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jan 2018 15:21:29 -0500
Received: by mail-oi0-f68.google.com with SMTP id y75so33981832oie.4
        for <linux-xfs@vger.kernel.org>; Tue, 02 Jan 2018 12:21:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171227052910.GE24828@bombadil.infradead.org>
References: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151407701943.38751.8997225433943672290.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20171227052910.GE24828@bombadil.infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 2 Jan 2018 12:21:28 -0800
Message-ID: <CAPcyv4ibKYi_zE=V2W_aLghtr3LiC30A2ffFq-aPQCrikwgy2w@mail.gmail.com>
Subject: Re: [PATCH v4 11/18] fs, dax: introduce DEFINE_FSDAX_AOPS
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm@lists.01.org, linux-xfs <linux-xfs@vger.kernel.org>, Jeff Moyer <jmoyer@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>

On Tue, Dec 26, 2017 at 9:29 PM, Matthew Wilcox <willy@infradead.org> wrote:
> On Sat, Dec 23, 2017 at 04:56:59PM -0800, Dan Williams wrote:
>> +int dax_set_page_dirty(struct page *page)
>> +{
>> +     /*
>> +      * Unlike __set_page_dirty_no_writeback, dax does all dirty
>> +      * tracking in the radix in response to mkwrite faults.
>
> Please stop saying "in the radix".  I think you mean "in the page cache".

Ok, I'll be more precise and mention the PAGECACHE_TAG_DIRTY vs
PageDirty distinction.

>
>> +EXPORT_SYMBOL(dax_set_page_dirty);
>> +EXPORT_SYMBOL(dax_direct_IO);
>> +EXPORT_SYMBOL(dax_writepage);
>> +EXPORT_SYMBOL(dax_readpage);
>> +EXPORT_SYMBOL(dax_readpages);
>> +EXPORT_SYMBOL(dax_write_begin);
>> +EXPORT_SYMBOL(dax_write_end);
>> +EXPORT_SYMBOL(dax_invalidatepage);
>
> Exporting all these symbols to modules isn't exactly free.  Are you sure it
> doesn't make more sense to put tests for dax in the existing aops?
>

I'd rather have just one global fs_dax_aops instance that all
filesystems could reference, but ->writepages() is fundamentally an
address_space_operation. Until we can rework that I'd prefer the
overhead of the extra exports than sprinkling more IS_DAX checks
around.
