Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:32864 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751054AbeFZVDB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jun 2018 17:03:01 -0400
Received: by mail-oi0-f67.google.com with SMTP id c6-v6so17361140oiy.0
        for <linux-xfs@vger.kernel.org>; Tue, 26 Jun 2018 14:03:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1530046327.14039.273.camel@hpe.com>
References: <20180626175932.8899-1-ross.zwisler@linux.intel.com>
 <20180626175932.8899-2-ross.zwisler@linux.intel.com> <CAPcyv4iWgPnHmBKhUvhManC6UL9CkLqN_d8vBo6KmcPJdPzuUw@mail.gmail.com>
 <20180626185830.GA7171@redhat.com> <CAPcyv4h6HO6fs6k7QMD77jkz2djCeWCtWomCdNb0-1Q4VKanqw@mail.gmail.com>
 <20180626191346.GA7233@redhat.com> <1530046327.14039.273.camel@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 26 Jun 2018 14:02:59 -0700
Message-ID: <CAPcyv4hP_Y3xdyCa-UkYCMJ5OtnjnkwPZDS2Z2Ge8+5ymBONwQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] pmem: only set QUEUE_FLAG_DAX for fsdax mode
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Kani, Toshi" <toshi.kani@hpe.com>
Cc: "snitzer@redhat.com" <snitzer@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

On Tue, Jun 26, 2018 at 1:54 PM, Kani, Toshi <toshi.kani@hpe.com> wrote:
> On Tue, 2018-06-26 at 15:13 -0400, Mike Snitzer wrote:
>> On Tue, Jun 26 2018 at  3:07pm -0400,
>> Dan Williams <dan.j.williams@intel.com> wrote:
>>
>> > On Tue, Jun 26, 2018 at 11:58 AM, Mike Snitzer <snitzer@redhat.com> wrote:
>> > > On Tue, Jun 26 2018 at  2:52pm -0400,
>> > > Dan Williams <dan.j.williams@intel.com> wrote:
>> > >
>> > > > On Tue, Jun 26, 2018 at 10:59 AM, Ross Zwisler
>> > > > <ross.zwisler@linux.intel.com> wrote:
>> > > > > QUEUE_FLAG_DAX is an indication that a given block device supports
>> > > > > filesystem DAX and should not be set for PMEM namespaces which are in "raw"
>> > > > > or "sector" modes.  These namespaces lack struct page and are prevented
>> > > > > from participating in filesystem DAX.
>> > > > >
>> > > > > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
>> > > > > Suggested-by: Mike Snitzer <snitzer@redhat.com>
>> > > > > Cc: stable@vger.kernel.org
>> > > >
>> > > > Why is this cc: stable? What is the user visible impact of this change
>> > > > especially given the requirement to validate QUEUE_FLAG_DAX with
>> > > > bdev_dax_supported()? Patch looks good, but it's just a cosmetic fixup
>> > > > afaics.
>> > >
>> > > This isn't cosmetic when you consider that stacking up a DM device is
>> > > looking at this flag to determine whether a table does or does _not_
>> > > support DAX.
>> > >
>> > > So this patch, in conjunction with the other changes in the series, is
>> > > certainly something I'd consider appropriate for stable.
>> >
>> > I think this classifies as something that never worked correctly and
>> > is not a regression. It does not identify which commit it is repairing
>> > or the user visible failure mode.
>>
>> So you're taking issue with making stacked dax configs work in older
>> kernels?  That's fine.  We can drop the stable cc if you like.
>>
>> But I mean we intended for this to work.. so the Fixes commit references
>> can easily be added, e.g.: 545ed20e6df68a4d2584a29a2a28ee8b2f7e9547
>> ("dm: add infrastructure for DAX support")
>
> When this dm change was made, the pmem driver supported DAX for both raw
> and memory modes (note: sector mode does not use the pmem driver).  I
> think the issue was introduced when we dropped DAX support from raw
> mode.

Still DAX with raw mode never really worked any way. It was also
something that was broken from day one. So what happens to someone who
happened to avoid all the problems with page-less DAX and enabled
device-mapper on top? That failure mode detail needs to be added to
this changelog if we want to propose this for -stable.
