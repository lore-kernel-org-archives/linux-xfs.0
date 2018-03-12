Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:42175 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932826AbeCLSR0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Mar 2018 14:17:26 -0400
Received: by mail-oi0-f65.google.com with SMTP id c18so13102762oiy.9
        for <linux-xfs@vger.kernel.org>; Mon, 12 Mar 2018 11:17:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180312141721.GB4214@redhat.com>
References: <152066488891.40260.14605734226832760468.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152066492680.40260.6843692416565308005.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180312141721.GB4214@redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 12 Mar 2018 11:17:25 -0700
Message-ID: <CAPcyv4jdOdvUZHS43Q18h3yTNzmiVJceEcVN5XSKstTkQHfDFQ@mail.gmail.com>
Subject: Re: [PATCH v5 07/11] mm, dev_pagemap: introduce CONFIG_DEV_PAGEMAP_OPS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jerome Glisse <jglisse@redhat.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Michal Hocko <mhocko@suse.com>, david <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>, Ross Zwisler <ross.zwisler@linux.intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Mon, Mar 12, 2018 at 7:17 AM, Jerome Glisse <jglisse@redhat.com> wrote:
> On Fri, Mar 09, 2018 at 10:55:26PM -0800, Dan Williams wrote:
>> The HMM sub-system extended dev_pagemap to arrange a callback when a
>> dev_pagemap managed page is freed. Since a dev_pagemap page is free /
>> idle when its reference count is 1 it requires an additional branch to
>> check the page-type at put_page() time. Given put_page() is a hot-path
>> we do not want to incur that check if HMM is not in use, so a static
>> branch is used to avoid that overhead when not necessary.
>>
>> Now, the FS_DAX implementation wants to reuse this mechanism for
>> receiving dev_pagemap ->page_free() callbacks. Rework the HMM-specific
>> static-key into a generic mechanism that either HMM or FS_DAX code paths
>> can enable.
>
> Why EXPORT_SYMBOL_GPL and not EXPORT_SYMBOL like it was prior to this
> patch ? Not i care that much about that, just wondering. Maybe keep it
> EXPORT_SYMBOL() ?

HMM has significant integrations and useful hacks within the mm
sub-system, I think we should go further than just these symbols and
also include devm_memremap_pages() as EXPORT_SYMBOL_GPL. It was simply
an oversight that these were EXPORT_SYMBOL previously.

> In any case
> Reviewed-by: "J=C3=A9r=C3=B4me Glisse" <jglisse@redhat.com>

Thanks!
