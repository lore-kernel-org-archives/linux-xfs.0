Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:43538 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751113AbeCJRkE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 10 Mar 2018 12:40:04 -0500
Received: by mail-oi0-f67.google.com with SMTP id a207so9317315oii.10
        for <linux-xfs@vger.kernel.org>; Sat, 10 Mar 2018 09:40:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180310094633.GA31604@lst.de>
References: <152066488891.40260.14605734226832760468.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152066489984.40260.2215636951958334858.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180310094633.GA31604@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 10 Mar 2018 09:40:03 -0800
Message-ID: <CAPcyv4iZFW9Lk=KdEy=0iYzM9GmQ4ccoN2imYNDq6XwXDgXsDw@mail.gmail.com>
Subject: Re: [PATCH v5 02/11] xfs, dax: introduce xfs_dax_aops
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Jeff Moyer <jmoyer@redhat.com>, Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Sat, Mar 10, 2018 at 1:46 AM, Christoph Hellwig <hch@lst.de> wrote:
>> +int dax_set_page_dirty(struct page *page)
>> +{
>> +     /*
>> +      * Unlike __set_page_dirty_no_writeback that handles dirty page
>> +      * tracking in the page object, dax does all dirty tracking in
>> +      * the inode address_space in response to mkwrite faults. In the
>> +      * dax case we only need to worry about potentially dirty CPU
>> +      * caches, not dirty page cache pages to write back.
>> +      *
>> +      * This callback is defined to prevent fallback to
>> +      * __set_page_dirty_buffers() in set_page_dirty().
>> +      */
>> +     return 0;
>> +}
>
> Make this a generic noop_set_page_dirty maybe?
>
>> +EXPORT_SYMBOL(dax_set_page_dirty);
>> +
>> +void dax_invalidatepage(struct page *page, unsigned int offset,
>> +             unsigned int length)
>> +{
>> +     /*
>> +      * There is no page cache to invalidate in the dax case, however
>> +      * we need this callback defined to prevent falling back to
>> +      * block_invalidatepage() in do_invalidatepage().
>> +      */
>> +}
>
> Same here.

I guess I'm not sure what you mean. These nops are specific to dax I
don't think they make sense in another context besides dax.

>
>> +EXPORT_SYMBOL(dax_invalidatepage);
>
> And EXPORT_SYMBOL_GPL for anything dax-related, please.
>
>> +const struct address_space_operations xfs_dax_aops = {
>> +     .writepages             = xfs_vm_writepages,
>
> Please split out the DAX case from xfs_vm_writepages.

Will do.

> This patch should probably also split into VFS and XFS parts.

Ok.
