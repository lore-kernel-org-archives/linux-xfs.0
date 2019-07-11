Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from egyptian.birch.relay.mailchannels.net ([23.83.209.56]:15329
        "EHLO egyptian.birch.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728111AbfGKHK1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Jul 2019 03:10:27 -0400
Date: Thu, 11 Jul 2019 10:10:12 +0300
From: Andrey Zhunev <a-j@a-j.ru>
Message-ID: <438631176.20190711101012@a-j.ru>
Subject: Re: Need help to recover root filesystem after a power supply issue
In-Reply-To: <cebdb77b-e175-06a8-a78d-525f86d10457@telefonica.net>
References: <958316946.20190710124710@a-j.ru>
  <CAJCQCtTpdGxB4r04wPNE+PRV5Jx_m95kShwvLJ5zxdmfw2fnEw@mail.gmail.com>
  <1373677058.20190710182851@a-j.ru>
  <CAJCQCtSpkAS086zSDCfB1jMQXZuacfE-SfyqQ2td4Ven4GwAzg@mail.gmail.com>
  <1015034894.20190710190746@a-j.ru>
  <CAJCQCtSTPaor-Wo6b1NF3QT_Pi2rO7B9QMbfudZS=9TEt-Oemw@mail.gmail.com>
  <CAJCQCtQn17ktjatXU5vvFjfsfEJx8EDrq1+b8+O1yvAf7ij96w@mail.gmail.com>
  <816157686.20190710201614@a-j.ru>
  <CAJCQCtQ08-hu7Cr2Li4v07r8v1isxZu=_hP3aQpHqJw4D2jCmg@mail.gmail.com>
  <e1dea87a-a2d8-4f4c-8807-4027a1a03a41@telefonica.net>
  <CAJCQCtS0EfAghBGoL-YVTEANfAXV4Oy7Q+4Q0Jp3xOF-uQhixA@mail.gmail.com>
  <18310556842.20190711024340@a-j.ru>
  <cebdb77b-e175-06a8-a78d-525f86d10457@telefonica.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Carlos E. R." <robin.listas@telefonica.net>
Cc: xfs list <linux-xfs@vger.kernel.org>


Thursday, July 11, 2019, 5:47:36 AM, you wrote:

> On 11/07/2019 01.43, Andrey Zhunev wrote:
>> 
>> Ok, the ddrescue finished copying whatever it was able to recover.
>> There were many unreadable sectors near the end of the drive.
>> In total, there were over 170 pending sectors reported by SMART.
>> 
>> I then ran the following commands:
>> 
>> # smartctl -l scterc,900,100 /dev/sda
>> # echo 180 > /sys/block/sda/device/timeout
>> 
>> But this didn't help at all. The unreadable sectors still remained
>> unreadable.
>> 
>> So I wiped them with hdparm:
>> # hdparm --yes-i-know-what-i-am-doing --write-sector <sector_number> /dev/sda

> This has always eluded me. How did you know the sector numbers?


When you use ddrescue (or any other tool) to try and read the data
and there is a read error, an error message is added to your kernel
log. You can find the sector number there:

Jul 10 11:56:01 mgmt kernel: blk_update_request: I/O error, dev sda, sector 157804112

You can then try to re-read that specific sector with:

# hdparm --read-sector 157804112

If that one still gives an error - then you're sure you can wipe it.


> At this point, I typically take the brutal approach of overwriting the
> entire partition (or disk) with zeroes using dd, which works as a
> destructive write test ;-)

> Previous to that, I attempt to create an image with ddrescue, of course.

>> 
>> I then re-read all these sectors, and they were all read correctly.
>> 
>> The number of pending sectors reported by SMART dropped down to 7.
>> Interestingly, there are still NO reallocated sectors reported.

> I suspect that the figure SMART reports only starts to rise after some
> unknown amount of sectors have been remapped, so when the numbers
> actually appear there, it is serious.

Hmmm, this is an interesting thought!
Everybody lies... :)




---
Best regards,
 Andrey
