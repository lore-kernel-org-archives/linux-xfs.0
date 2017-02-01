Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39794 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750858AbdBAXOZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 1 Feb 2017 18:14:25 -0500
Subject: Re: xfsprogs build broken on armv7l
References: <8cbc97e0-de81-658c-d6b6-b7d65b9f83c6@nod.at>
 <8b29ebc8-203b-5a6c-8428-fa835e647d5c@sandeen.net>
 <a123dfb3-45ac-9671-9940-7311ebde309a@nod.at>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <d32d3a29-a0bf-6ae3-7b96-01c187120914@sandeen.net>
Date: Wed, 1 Feb 2017 17:14:23 -0600
MIME-Version: 1.0
In-Reply-To: <a123dfb3-45ac-9671-9940-7311ebde309a@nod.at>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Richard Weinberger <richard@nod.at>, linux-xfs@vger.kernel.org, gwendal@chromium.org
Cc: "vapier@gentoo.org" <vapier@gentoo.org>, hch@lst.de, David Oberhollenzer <goliath@sigma-star.at>, David Gstir <david@sigma-star.at>

On 2/1/17 5:12 PM, Richard Weinberger wrote:
> Eric,
> 
> Am 01.02.2017 um 23:31 schrieb Eric Sandeen:
>> On 2/1/17 4:19 PM, Richard Weinberger wrote:
>>> Hi!
>>>
>>> On my armv7 box, current xfsprogs fail to build:
>>>     [TEST]    CRC32
>>> In file included from crc32.c:37:0:
>>> ../include/xfs.h:53:12: error: size of array ‘xfs_assert_largefile’ is too large
>>
>> neat ;)
>>
>> Does this fix it?
> 
> Yes, it does. :-)

Cool (and just realized that patch was sent earlier today by
Eric Biggers as well, so I guess that's dual-confirmation) :)

-eric
