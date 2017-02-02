Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:34108 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751224AbdBBRxA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Feb 2017 12:53:00 -0500
Received: by mail-ot0-f195.google.com with SMTP id 73so2643060otj.1
        for <linux-xfs@vger.kernel.org>; Thu, 02 Feb 2017 09:52:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <e117aa51-330e-d181-66a7-e8ab5d7387f3@sandeen.net>
References: <CAL8yqihyYEaCEzWJLqAKsw1BBOQDm-AYR2dCUeN-X-449jCwzQ@mail.gmail.com>
 <e117aa51-330e-d181-66a7-e8ab5d7387f3@sandeen.net>
From: fuser ct1 <fuserct1@gmail.com>
Date: Thu, 2 Feb 2017 17:52:58 +0000
Message-ID: <CAL8yqijAJVjEBxy0aKqkZSHuGWvFJdpW6-xTDNomnECBjUjJcw@mail.gmail.com>
Subject: Re: Safe XFS limits (100TB+)
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

Thanks for the fast reply Eric!

It's good to know I'm not completely off my chop :-)

288T! Wow, OK. Is that safe and workable when it starts to get full?
(say around 70% utilized)

In this case the machine will have 128G memory and a dual E5 Xeon. The
filesystem will have a fair number of files, but they're all going to
be a fair few G.

Regarding xfs_repair/check, thanks for the heads up. I've only had to
use repair once due to some mess caused by unsupported with an
unsupported firmware with an Adaptec 71605 (learned my lesson quickly
there).

I wonder if my eyes are too big for my stomach now? Why have 144TB x2
if you can have one big filesystem...

My fstab options are as such:

rw,nobarrier,inode64

Also, FWIW I didn't partition the device last time, just ended up with...

/dev/sdb: UUID="ccac4134-12a0-4dbd-9365-d2e166d927ed" TYPE="xfs"


On Thu, Feb 2, 2017 at 5:16 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> On 2/2/17 10:46 AM, fuser ct1 wrote:
>> Hello list.
>>
>> Despite searching I couldn't find guidance, or many use cases, regarding
>> XFS beyond 100TB.
>>
>> Of course the filesystem limits are way beyond this, but I was looking for
>> real world experiences...
>>
>> Specifically I'm wondering about the sanity of using XFS with a couple of
>> 144TB block devices (my system will have two 22x8TB R60 in a 44 bay JBOD).
>> My storage is used for video editing/post production.
>>
>> * Has anybody here tried?
>
> XFS has been used well past 100T, sure.
>
>> * What is the likelihood of xfs_repair/check finishing if I ever needed to
>> run it?
>
> xfs_check no, but it's deprecated anyway because it doesn't scale.
>
> xfs_repair yes, though the amount of resources needed will depend on
> the details of how you populate the filesystem.
>
> On my puny celeron with 8g ram, xfs_repair of an empty 288T image file
> takes 2 seconds.  Filling it with files will change this :)
> But if it's for video editing I presume you will actually be fairly
> light on the metadata, with a not-insane number of inodes, and very
> large files.
>
> But you do want to make sure that the machine administering the filesystem
> is fairly beefy, for xfs_repair purposes.
>
> http://xfs.org/index.php/XFS_FAQ#Q:_Which_factors_influence_the_memory_usage_of_xfs_repair.3F
>
>> * Am I nuts?
>
> Probably not.   :)
>
> -Eric
>
>> I know that beyond a certain point I should be looking at a scale out
>> option, but the level of complexity and cost goes up considerably.
>>
>> More info:
>> =======
>>
>> Previously I had an 80TB usable (96TB raw) with an LSI MegaRAID 9361
>> controller. This worked very nicely and was FAST. I was careful to choose
>> the inode64 fstab mount option. The OS was Debian Jessie, which has
>> XFSPROGS version 3.2.1.
>>
>> Thanks in advance and sorry if this is not the right list.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
