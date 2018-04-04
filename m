Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:37553 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752080AbeDDVfV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Apr 2018 17:35:21 -0400
Received: by mail-oi0-f66.google.com with SMTP id f63-v6so8801655oic.4
        for <linux-xfs@vger.kernel.org>; Wed, 04 Apr 2018 14:35:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPcyv4jknruAmkPEVx0X6Bd3uRs_FYdPf-W-5cDO1Z+kaG5+uw@mail.gmail.com>
References: <152246898837.36038.26895928842345061.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180404212340.GA12737@outlook.office365.com> <CAPcyv4jknruAmkPEVx0X6Bd3uRs_FYdPf-W-5cDO1Z+kaG5+uw@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 4 Apr 2018 14:35:20 -0700
Message-ID: <CAPcyv4jd+aSzMvGHJ6O8K5vJ+qmH=XU2i2bzsGvZENXnkpM7=g@mail.gmail.com>
Subject: Re: [v8, 11/18] mm, dax: enable filesystems to trigger dev_pagemap
 ->page_free callbacks
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andrei Vagin <avagin@virtuozzo.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Michal Hocko <mhocko@suse.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>, david <david@fromorbit.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Mike Snitzer <snitzer@redhat.com>, Stephen Rothwell <sfr@canb.auug.org.au>

[ adding Stephen ]

On Wed, Apr 4, 2018 at 2:27 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Wed, Apr 4, 2018 at 2:23 PM, Andrei Vagin <avagin@virtuozzo.com> wrote:
>> Hi Dan,
>>
>> I catch the following bug on the linux-next 20180404. git bisect brought me to this commit:
>
> Yes, I will be yanking this functionality out of -next shortly and try
> again for v4.18.

New branch pushed out with this offending commit removed.
