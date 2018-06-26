Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:34853 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752620AbeFZV2F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jun 2018 17:28:05 -0400
Received: by mail-ot0-f194.google.com with SMTP id a6-v6so6138792otf.2
        for <linux-xfs@vger.kernel.org>; Tue, 26 Jun 2018 14:28:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1530048093.14039.286.camel@hpe.com>
References: <20180626175932.8899-1-ross.zwisler@linux.intel.com>
 <20180626175932.8899-2-ross.zwisler@linux.intel.com> <CAPcyv4iWgPnHmBKhUvhManC6UL9CkLqN_d8vBo6KmcPJdPzuUw@mail.gmail.com>
 <20180626185830.GA7171@redhat.com> <CAPcyv4h6HO6fs6k7QMD77jkz2djCeWCtWomCdNb0-1Q4VKanqw@mail.gmail.com>
 <20180626191346.GA7233@redhat.com> <1530046327.14039.273.camel@hpe.com>
 <CAPcyv4hP_Y3xdyCa-UkYCMJ5OtnjnkwPZDS2Z2Ge8+5ymBONwQ@mail.gmail.com> <1530048093.14039.286.camel@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 26 Jun 2018 14:28:04 -0700
Message-ID: <CAPcyv4gXAC7imJs5qfsDNLeN545Rqyd2b1M9s5kr4f9y48LXgQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] pmem: only set QUEUE_FLAG_DAX for fsdax mode
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Kani, Toshi" <toshi.kani@hpe.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>

On Tue, Jun 26, 2018 at 2:23 PM, Kani, Toshi <toshi.kani@hpe.com> wrote:
> On Tue, 2018-06-26 at 14:02 -0700, Dan Williams wrote:
>> On Tue, Jun 26, 2018 at 1:54 PM, Kani, Toshi <toshi.kani@hpe.com> wrote:
[..]
>> > When this dm change was made, the pmem driver supported DAX for both raw
>> > and memory modes (note: sector mode does not use the pmem driver).  I
>> > think the issue was introduced when we dropped DAX support from raw
>> > mode.
>>
>> Still DAX with raw mode never really worked any way. It was also
>> something that was broken from day one. So what happens to someone who
>> happened to avoid all the problems with page-less DAX and enabled
>> device-mapper on top? That failure mode detail needs to be added to
>> this changelog if we want to propose this for -stable.
>
> My point is that the behavior should be consistent between pmem and
> device-mapper.  When -o dax succeeds on a pmem, then it should succeed
> on a device-mapper on top of that pmem.
>
> Has the drop of dax support from raw mode made to -stable back to the
> baseline accepted 545ed20e6df6?  It will introduce inconsistency,
> otherwise.

That commit, 569d0365f571 "dax: require 'struct page' by default for
filesystem dax", has not been tagged for -stable.
