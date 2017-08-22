Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ua0-f179.google.com ([209.85.217.179]:36198 "EHLO
        mail-ua0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752533AbdHVWhJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Aug 2017 18:37:09 -0400
Received: by mail-ua0-f179.google.com with SMTP id w17so256182uaw.3
        for <linux-xfs@vger.kernel.org>; Tue, 22 Aug 2017 15:37:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170822111053.7jypthbydpkn2tj4@breakpoint.cc>
References: <20170821190414.long2535xppcxvvd@breakpoint.cc>
 <CAJCQCtSUS9yZfv9xLe9a5o5x8ZSkOUWC_6QaeUi6oQ_QXg4GRQ@mail.gmail.com> <20170822111053.7jypthbydpkn2tj4@breakpoint.cc>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 22 Aug 2017 16:37:07 -0600
Message-ID: <CAJCQCtTF2bWgB1++v3XOwaPqpPxc7-0Lv+Qc_3bebb0zMDNszA@mail.gmail.com>
Subject: Re: Support for data CRC
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Chris Murphy <lists@colorremedies.com>, xfs list <linux-xfs@vger.kernel.org>

On Tue, Aug 22, 2017 at 5:10 AM, Sebastian Andrzej Siewior
<sebastian@breakpoint.cc> wrote:
> On 2017-08-21 13:52:48 [-0600], Chris Murphy wrote:
>> On Mon, Aug 21, 2017 at 1:04 PM, Sebastian Andrzej Siewior
>> <sebastian@breakpoint.cc> wrote:
>> > Hi,
>> >
>> > my understanding is that only metadata is protected by CRC in the new
>> > on-disk format. Are there any plans to also protect data?
>>
>> See dm-integrity, merged as of 4.12 kernel. I haven't seen any
>> performance benchmarking so far.
>
> So this ensures integrity with the help of crypto algorithms. This is a
> bit much as something like crc32c/crc64 would be sufficient. However
> dm-integrity does not provide a way to recover (as far as I can tell).

If a block fails integrity checking, there's a read error that goes to
the next layer which would need to have replication such as mdadm/lvm
RAID. And that layer would grab a good copy, and fix the bad copy. So
every physical drive would first have dm-integrity applied, which is a
1:1 mapping, and then each dm-integrity logical device is made a PV
for LVM, and then you create raid1/5/6 LV's or whatever you want, and
then format it whatever you want.

Documentation says either crc or hash is possible, including crc32.
https://www.kernel.org/doc/Documentation/device-mapper/dm-integrity.txt


> My idea was that if the "normal" path is faulty (and noticed by the crc
> check) it (xfs or the dm layer) would try to read the data via an
> alternative path if possible (say on RAID1/5/6).

Yes you have to build each layer you want separately with this method.
Otherwise you're looking at ZFS or Btrfs if you want it integrated.


-- 
Chris Murphy
