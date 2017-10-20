Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:49451 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752009AbdJTPXD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Oct 2017 11:23:03 -0400
Received: by mail-oi0-f67.google.com with SMTP id w197so20555454oif.6
        for <linux-xfs@vger.kernel.org>; Fri, 20 Oct 2017 08:23:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171020075735.GA14378@lst.de>
References: <150846713528.24336.4459262264611579791.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150846714747.24336.14704246566580871364.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20171020075735.GA14378@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 20 Oct 2017 08:23:02 -0700
Message-ID: <CAPcyv4hA1nrhDf=DA6_j7s7ezGOBhvEVZ8cu81DNui_p3bhhaA@mail.gmail.com>
Subject: Re: [PATCH v3 02/13] dax: require 'struct page' for filesystem dax
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, Linux MM <linux-mm@kvack.org>, Jeff Moyer <jmoyer@redhat.com>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Gerald Schaefer <gerald.schaefer@de.ibm.com>

On Fri, Oct 20, 2017 at 12:57 AM, Christoph Hellwig <hch@lst.de> wrote:
>> --- a/arch/powerpc/sysdev/axonram.c
>> +++ b/arch/powerpc/sysdev/axonram.c
>> @@ -172,6 +172,7 @@ static size_t axon_ram_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff,
>>
>>  static const struct dax_operations axon_ram_dax_ops = {
>>       .direct_access = axon_ram_dax_direct_access,
>> +
>>       .copy_from_iter = axon_ram_copy_from_iter,
>
> Unrelated whitespace change.  That being said - I don't think axonram has
> devmap support in any form, so this basically becomes dead code, doesn't
> it?
>
>> diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
>> index 7abb240847c0..e7e5db07e339 100644
>> --- a/drivers/s390/block/dcssblk.c
>> +++ b/drivers/s390/block/dcssblk.c
>> @@ -52,6 +52,7 @@ static size_t dcssblk_dax_copy_from_iter(struct dax_device *dax_dev,
>>
>>  static const struct dax_operations dcssblk_dax_ops = {
>>       .direct_access = dcssblk_dax_direct_access,
>> +
>>       .copy_from_iter = dcssblk_dax_copy_from_iter,
>
> Same comments apply here.

Yes, however it seems these drivers / platforms have been living with
the lack of struct page for a long time. So they either don't use DAX,
or they have a constrained use case that never triggers
get_user_pages(). If it is the latter then they could introduce a new
configuration option that bypasses the pfn_t_devmap() check in
bdev_dax_supported() and fix up the get_user_pages() paths to fail.
So, I'd like to understand how these drivers have been using DAX
support without struct page to see if we need a workaround or we can
go ahead delete this support. If the usage is limited to
execute-in-place perhaps we can do a constrained ->direct_access() for
just that case.
