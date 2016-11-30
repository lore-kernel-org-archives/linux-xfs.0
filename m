Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:54258 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754141AbcK3UN1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 30 Nov 2016 15:13:27 -0500
Subject: Re: default mount options
References: <583E1488.7090502@tlinx.org>
 <6ecda11c-a993-3dd7-5b87-1947506953ff@sandeen.net>
 <583F2806.7080102@tlinx.org>
 <e727dd60-777a-60d4-121e-2dd68981e176@sandeen.net>
 <583F30C8.1000206@tlinx.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <90634043-1b10-04e8-a067-1acf304f69d7@sandeen.net>
Date: Wed, 30 Nov 2016 14:13:25 -0600
MIME-Version: 1.0
In-Reply-To: <583F30C8.1000206@tlinx.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: L A Walsh <xfs@tlinx.org>
Cc: linux-xfs@vger.kernel.org

On 11/30/16 2:04 PM, L A Walsh wrote:
> 
> 
> Eric Sandeen wrote:
>>
>>>  But those systems also, sometimes, change runtime
>>> behavior based on the UPS or battery state -- using write-back on
>>> a full-healthy battery, or write-through when it wouldn't be safe.
>>>
>>>     In that case, it seems nobarrier would be a better choice
>>> for those volumes -- letting the controller decide.
>>
>> No.  Because then xfs will /never/ send barriers requests, even
>> if the battery dies.  So I think you have that backwards.
> ---
>     If the battery dies, then the controller shifts
> to write-through and no longer uses its write cache.  This is
> documented and observed behavior.

Ok, right, sorry.

In that case barriers may not be /needed,/ but turning them
off should offer no benefit.

>>
>> If you leave them at the default, i.e. barriers /enabled,/ then the
>> device is free to ignore the barrier operations if the battery is
>> healthy, or to honor them if it fails.
> 
>>
>> If you turn it off at mount time, xfs will /never/ send such
>> requests, and the storage will be unsafe if the battery fails,
>> and you will be at risk for corruption or data loss.
> ---
>     I know what the device does in regards to its battery.
> I don't know that the device responds to xfs-drivers in a way
> that xfs will know to change barrier usage.

xfs does not change its barrier usage.  It is determined solely
at mount time.
 
> 
>>>> Just leave the option at the default, and you'll be fine.  There is
>>>> rarely, if ever, a reason to change it.
>>> ---       Fine isn't what I asked.  I wanted to know if the switch
>>> specified that xfs should add barriers or that barriers were already
>>> handled in the backing store for those file systems.  If the prior
>>> then I would want nobarrier on some file systems, if the latter, I
>>> might want the default.  But it sounds like the switch applies
>>> to the former -- meaning I don't want them for partitions that
>>> don't need them.
>>
>> "barrier" means "the xfs filesystem will send barrier requests to the
>> storage."  It does this at critical points during updates to ensure
>> that data is /permanently/ stored on disk when required - for metadata
>> consistency and/or for data permanence.
>>
>> If the storage doesn't need barriers, they'll simply be ignored.
> ---
>     How can that be determined?  If xfs was able to determine
> the need for barriers or not, then why can't it determine something
> as simple as disk alignment and ensure writes are on optimal boundaries?

xfs does not determine the need for barriers or not, it is governed solely
by the specified mount option.

If they are sent by xfs, the device can choose to ignore them or not.

(ignoring the alignment non-sequitor for now)
 
>> "partitions that don't need them" should be /unaffected/ by their
>> presence, so there's no use in turning them off.
>>
>> Turning them off risks corruption.
> ---
>     The only corrupt devices I've had w/xfs were ones
> that had them turned on.  Those were > 5 years ago.  That
> says to me that there are likely other risks that have had a greater
> possibility for causing corruption than that caused by lack or
> presence of barriers.

*shrug*

You seem to really want to turn barriers off in some cases.  I certainly
can't /make/ you leave it at the safe-and-harmless "on" default.  :)

-Eric
