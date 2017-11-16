Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ot0-f182.google.com ([74.125.82.182]:54951 "EHLO
        mail-ot0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750750AbdKPC3N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Nov 2017 21:29:13 -0500
Received: by mail-ot0-f182.google.com with SMTP id w8so21330141otw.11
        for <linux-xfs@vger.kernel.org>; Wed, 15 Nov 2017 18:29:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTm0DkG+knfbbiLZPXTUBMvRo6wQhGf9VVZZtk5=RR1CA@mail.gmail.com>
References: <CAJCQCtR1eLc3n-19po0z8eF3tcmj6rxuPK6fcJft=swuCGSVwA@mail.gmail.com>
 <20171116000703.GG4094@dastard> <CAJCQCtTm0DkG+knfbbiLZPXTUBMvRo6wQhGf9VVZZtk5=RR1CA@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 15 Nov 2017 19:29:12 -0700
Message-ID: <CAJCQCtRoHA1mSomvqPMm94hVyW452Xx0Jtn7V9Ab1TQPCbC4Eg@mail.gmail.com>
Subject: Re: LVM thinp, mkfs "device is not properly aligned"
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Murphy <lists@colorremedies.com>
Cc: Dave Chinner <david@fromorbit.com>, xfs list <linux-xfs@vger.kernel.org>

On Wed, Nov 15, 2017 at 7:19 PM, Chris Murphy <lists@colorremedies.com> wrote:
> On Wed, Nov 15, 2017 at 5:07 PM, Dave Chinner <david@fromorbit.com> wrote:
>> On Wed, Nov 15, 2017 at 04:20:59PM -0700, Chris Murphy wrote:
>>> # mkfs.xfs /dev/mapper/vg-timemachine
>>> warning: device is not properly aligned /dev/mapper/vg-timemachine
>>> Use -f to force usage of a misaligned device
>>
>> That is emitted when blikid tells XFS that the device it is about to
>> format is not correctly aligned.
>>
>> The check that is failing:
>>
>>          if (blkid_topology_get_alignment_offset(tp) != 0)
>>
>> From here:
>>
>> https://www.kernel.org/pub/linux/utils/util-linux/v2.21/libblkid-docs/libblkid-Topology-information.html
>>
>> ALIGNMENT_OFFSET: indicates how many bytes the beginning of the
>> device is offset from the disk's natural alignment.
>>
>> ....
>>> $ lsblk -t
>>>
>> (Trimmed for brevity and readability)
>> .....
>>> NAME                      ALIGNMENT MIN-IO   OPT-IO
>>> sda                               0   4096        0
>>>   sda1                            0   4096        0
>>>   sda2                            0   4096        0
>>>     brick1                      512   4096        0
>>>   sda3                            0   4096        0
>>>   sda4                            0   4096        0
>>>   sda5                            0   4096        0
>>>     vg-cryptoswap               512   4096        0
>>>       swap                      512   4096        0
>>>     vg-thintastic_tmeta         512   4096        0
>>>       vg-thintastic-tpool       512 524288   524288
>>>         vg-thintastic           512 524288   524288
>>>         vg-timemachine          512 524288   524288
>>>     vg-thintastic_tdata         512   4096        0
>>>       vg-thintastic-tpool       512 524288   524288
>>>         vg-thintastic           512 524288   524288
>>>         vg-timemachine          512 524288   524288
>>>
>>
>> What you can see here is that all the volume groups have a non-zero
>> alignment - they are all off by one sector - and that's what
>> mkfs.xfs is warning you about. i.e. something's not quite right at
>> the LVM layer....
>
>
> Something else is screwy here. Look under sda2/brick1 which is a
> dm-crypt volume created with cryptsetup, not lvm. It also has this
> alignment value of 512.


OK this hard drive was originally inside some kind of USB enclosure.
And it's giving off information that's confusing libblkid, resulting
in this problem. I've done a tear down of the LVM stuff, and as I've
built it back up again, this 512 byte offset is not present. I'll file
a bug report and see if there's a way to figure out whether there's a
software work around or if this is broken hardware.

-- 
Chris Murphy
