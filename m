Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:37422 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752116AbeFZTHl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jun 2018 15:07:41 -0400
Received: by mail-oi0-f67.google.com with SMTP id k81-v6so2993698oib.4
        for <linux-xfs@vger.kernel.org>; Tue, 26 Jun 2018 12:07:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180626185830.GA7171@redhat.com>
References: <20180626175932.8899-1-ross.zwisler@linux.intel.com>
 <20180626175932.8899-2-ross.zwisler@linux.intel.com> <CAPcyv4iWgPnHmBKhUvhManC6UL9CkLqN_d8vBo6KmcPJdPzuUw@mail.gmail.com>
 <20180626185830.GA7171@redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 26 Jun 2018 12:07:40 -0700
Message-ID: <CAPcyv4h6HO6fs6k7QMD77jkz2djCeWCtWomCdNb0-1Q4VKanqw@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] pmem: only set QUEUE_FLAG_DAX for fsdax mode
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Mike Snitzer <snitzer@redhat.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Toshi Kani <toshi.kani@hpe.com>, device-mapper development <dm-devel@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Tue, Jun 26, 2018 at 11:58 AM, Mike Snitzer <snitzer@redhat.com> wrote:
> On Tue, Jun 26 2018 at  2:52pm -0400,
> Dan Williams <dan.j.williams@intel.com> wrote:
>
>> On Tue, Jun 26, 2018 at 10:59 AM, Ross Zwisler
>> <ross.zwisler@linux.intel.com> wrote:
>> > QUEUE_FLAG_DAX is an indication that a given block device supports
>> > filesystem DAX and should not be set for PMEM namespaces which are in "raw"
>> > or "sector" modes.  These namespaces lack struct page and are prevented
>> > from participating in filesystem DAX.
>> >
>> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
>> > Suggested-by: Mike Snitzer <snitzer@redhat.com>
>> > Cc: stable@vger.kernel.org
>>
>> Why is this cc: stable? What is the user visible impact of this change
>> especially given the requirement to validate QUEUE_FLAG_DAX with
>> bdev_dax_supported()? Patch looks good, but it's just a cosmetic fixup
>> afaics.
>
> This isn't cosmetic when you consider that stacking up a DM device is
> looking at this flag to determine whether a table does or does _not_
> support DAX.
>
> So this patch, in conjunction with the other changes in the series, is
> certainly something I'd consider appropriate for stable.

I think this classifies as something that never worked correctly and
is not a regression. It does not identify which commit it is repairing
or the user visible failure mode.
