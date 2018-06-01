Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:43540 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750724AbeFAVQe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Jun 2018 17:16:34 -0400
Received: by mail-ot0-f196.google.com with SMTP id i19-v6so299745otk.10
        for <linux-xfs@vger.kernel.org>; Fri, 01 Jun 2018 14:16:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180601204604.GB1144@redhat.com>
References: <20180529195106.14268-1-ross.zwisler@linux.intel.com>
 <20180529195106.14268-4-ross.zwisler@linux.intel.com> <20180601201924.GA1144@redhat.com>
 <20180601204604.GB1144@redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 1 Jun 2018 14:16:33 -0700
Message-ID: <CAPcyv4j2Mi6p4xQ+m7dqcEpAF4aCEk3pEU8zAwGdnNJ8pVquVw@mail.gmail.com>
Subject: Re: [PATCH v2 3/7] dm: fix test for DAX device support
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Mike Snitzer <snitzer@redhat.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Fri, Jun 1, 2018 at 1:46 PM, Mike Snitzer <snitzer@redhat.com> wrote:
> On Fri, Jun 01 2018 at  4:19P -0400,
> Mike Snitzer <snitzer@redhat.com> wrote:
>
>> On Tue, May 29 2018 at  3:51P -0400,
>> Ross Zwisler <ross.zwisler@linux.intel.com> wrote:
>>
>> > Currently device_supports_dax() just checks to see if the QUEUE_FLAG_DAX
>> > flag is set on the device's request queue to decide whether or not the
>> > device supports filesystem DAX.  This is insufficient because there are
>> > devices like PMEM namespaces in raw mode which have QUEUE_FLAG_DAX set but
>> > which don't actually support DAX.
>>
>> Isn't that a PMEM bug then?
>>
>> What is the point of setting QUEUE_FLAG_DAX if it cannot be trusted?
>>
>> > This means that you could create a dm-linear device, for example, where the
>> > first part of the dm-linear device was a PMEM namespace in fsdax mode and
>> > the second part was a PMEM namespace in raw mode.  Both DM and the
>> > filesystem you put on that dm-linear device would think the whole device
>> > supports DAX, which would lead to bad behavior once your raw PMEM namespace
>> > part using DAX needed struct page for something.
>>
>> The PMEM namespace in raw mode shouldn't be setting QUEUE_FLAG_DAX, if
>> it didn't then the stacked-up linear DM wouldn't
>>
>> > Fix this by using bdev_dax_supported() like filesystems do at mount time.
>> > This checks for raw mode and also performs other tests like checking to
>> > make sure the dax_direct_access() path works.
>>
>> Sorry "This" does those things where?
>
> I see you meant bdev_dax_supported() does these additional checks.
>
> My previous question stands though.  Why is QUEUE_FLAG_DAX getting set
> if the device hasn't already passed these checks?  Shouldn't setting
> QUEUE_FLAG_DAX on request_queue depend on bdev_dax_supported() passing?
>
> But looking at the drivers that do set QUEUE_FLAG_DAX: they
> don't have the bdev readily available.  Anyway, just strikes me as
> bizarre that a driver can set QUEUE_FLAG_DAX without having to have
> ensured bdev_dax_supported() passes (even if not programatically, but
> that the developer has verified the hooks, et al exist).
>
> But I'll give up on this line of questioning..
>
> My dilemma now is: how do I take these changes without first rebasing
> linux-dm.git ontop of Darrick's xfs tree?
>
> I probably should've reviewed faster and been the one to take the entire
> set (with appropriate acks obviously).

I'd say just make a topic branch on top of xfs and merge it... with
Darrick's permission of course. It might also mean you should wait for
the xfs pull request to go to Linus first during the window.
