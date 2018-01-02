Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:39956 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750745AbeABUP2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jan 2018 15:15:28 -0500
Received: by mail-ot0-f195.google.com with SMTP id d10so5661475oti.7
        for <linux-xfs@vger.kernel.org>; Tue, 02 Jan 2018 12:15:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171227001705.GA4802@linux.intel.com>
References: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151407699792.38751.2859846645388380112.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20171227001705.GA4802@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 2 Jan 2018 12:15:27 -0800
Message-ID: <CAPcyv4h2Wn6P8_T4F4NS1Xat2G17X8vm14ou5BV1JAr95jxtpA@mail.gmail.com>
Subject: Re: [PATCH v4 07/18] dax: store pfns in the radix
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm@lists.01.org, linux-xfs <linux-xfs@vger.kernel.org>, Jeff Moyer <jmoyer@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>

On Tue, Dec 26, 2017 at 4:17 PM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> On Sat, Dec 23, 2017 at 04:56:38PM -0800, Dan Williams wrote:
>> In preparation for examining the busy state of dax pages in the truncate
>> path, switch from sectors to pfns in the radix.
>>
>> Cc: Jan Kara <jack@suse.cz>
>> Cc: Jeff Moyer <jmoyer@redhat.com>
>> Cc: Christoph Hellwig <hch@lst.de>
>> Cc: Matthew Wilcox <mawilcox@microsoft.com>
>> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>>  drivers/dax/super.c |   15 ++++++++--
>>  fs/dax.c            |   75 ++++++++++++++++++---------------------------------
>>  2 files changed, 39 insertions(+), 51 deletions(-)
> <>
>> @@ -688,7 +685,7 @@ static int dax_writeback_one(struct block_device *bdev,
>>        * compare sectors as we must not bail out due to difference in lockbit
>>        * or entry type.
>>        */
>
> Can you please also fix the comment above this test so it talks about pfns
> instead of sectors?
>
>> -     if (dax_radix_sector(entry2) != dax_radix_sector(entry))
>> +     if (dax_radix_pfn(entry2) != dax_radix_pfn(entry))
>>               goto put_unlocked;
>>       if (WARN_ON_ONCE(dax_is_empty_entry(entry) ||
>>                               dax_is_zero_entry(entry))) {
>> @@ -718,29 +715,11 @@ static int dax_writeback_one(struct block_device *bdev,
>>        * 'entry'.  This allows us to flush for PMD_SIZE and not have to
>>        * worry about partial PMD writebacks.
>>        */
>
> Ditto for this comment ^^^
>

Sure, will do.
