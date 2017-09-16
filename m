Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:49550 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751288AbdIPWCA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 16 Sep 2017 18:02:00 -0400
Subject: Re: XFS and sector size on thin volumes
References: <d95f09118ee6cb2fe0562ad35303715c@assyoma.it>
 <20170909231215.GK17782@dastard>
 <0c59ba403f83e571d695a716ccad5d0a@assyoma.it>
 <20170909235323.GL17782@dastard>
 <838841738c3d8ca84328075615f95475@assyoma.it>
 <9d6b72e9-37ca-70f9-a40d-62ceaafc9db6@sandeen.net>
 <e94a47555325c3e87e5d184e1cab20b4@assyoma.it>
 <1357a2ee8280242c68d92cd4aba06f51@assyoma.it>
 <4ca74023-dcaf-9963-1b8f-2c1924866564@sandeen.net>
 <58a80905e97216e37d72e5b7bd9f1643@assyoma.it>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <e15d5e44-e38c-cdde-5893-5455aee04ea8@sandeen.net>
Date: Sat, 16 Sep 2017 17:01:59 -0500
MIME-Version: 1.0
In-Reply-To: <58a80905e97216e37d72e5b7bd9f1643@assyoma.it>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Gionatan Danti <g.danti@assyoma.it>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org



On 9/16/17 2:59 PM, Gionatan Danti wrote:
> Il 16-09-2017 20:33 Eric Sandeen ha scritto:
>>
>> I don't think I said that - this is the first time you've mentioned
>> /alignment/, and I've seen no indication of your alignment one way or
>> another.
>>
>>
>>
>>
>> that specifies a 4k block size, which is already the default.
>>
>> You're conflating a lot of issues here - log alignment, sector size,
>> physical & logical block size presented by both the underlying
>> storage and the zvol ...
>>
>> I cannot speak to zvols, as I have no experience with them.
>>
>> But if the underlying storage is 512e/4k then you may want to specify
>> the 4k /sector/ size with -s size=4k.
>>
>> -Eric
>>
> 
> Hi Eric, you are right: I messed up the terminology. Sorry for the noise.
> 
> I was really speaking about *sector* size. In short, when using ZVOL the physical disk's sector size is not directly announced to the higher layer filesystem. This, in turn, cause mkfs.xfs to automatically select a 512B sector size, even when running on top of 512e/4Kn disks.
> 
> From previous emails/threads, I was under impression that XFS sector size only very marginally affect performance. It that true? Can I stick with default mkfs settings? Or should I manually select 4K sector size ("-s size=4k")?

If you have 512/4k disks and mkfs is not defaulting to 4k sector size,
use "-s size=4k"

-Eric
