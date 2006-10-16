Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 16 Oct 2006 06:50:14 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9GDo3aG017289
	for <xfs@oss.sgi.com>; Mon, 16 Oct 2006 06:50:05 -0700
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D968AD198454
	for <xfs@oss.sgi.com>; Mon, 16 Oct 2006 06:49:20 -0700 (PDT)
Message-ID: <45338DDE.8020903@sandeen.net>
Date: Mon, 16 Oct 2006 08:49:18 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] Make stuff static
References: <20060929032856.8DA9C18001A5E@sandeen.net> <23F15D6AE8566A54B81188AC@timothy-shimmins-power-mac-g5.local>
In-Reply-To: <23F15D6AE8566A54B81188AC@timothy-shimmins-power-mac-g5.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: xfs@oss.sgi.com

Timothy Shimmin wrote:
> Okay, started looking :-)
> 
> Some comments below...
> 
> --Tim

Thanks Tim! :)

>> --- xfs-linux.orig/linux-2.4/xfs_vnode.c
>> +++ xfs-linux/linux-2.4/xfs_vnode.c
>> @@ -17,7 +17,7 @@
>>  #include "xfs.h"
>>
>>  uint64_t vn_generation;        /* vnode generation number */
>> -spinlock_t vnumber_lock = SPIN_LOCK_UNLOCKED;
>> +static spinlock_t vnumber_lock = SPIN_LOCK_UNLOCKED;
>>
> 
> Not STATIC? Curious.

Yeah, probably should be; IIRC there were other "statics" in that file, was just 
following the convention.  I'll make sure it builds OK w/ STATIC and send an 
updated patch (need to do that anyway).

> Yep for all xfs_iext_ funcs.
> 
> Well actually it looks like xfs_bmap.c uses these:
> --------------------
> xfs_iext_add
> xfs_iext_bno_to_ext
> xfs_iext_get_ext
> xfs_iext_insert
> xfs_iext_remove
> ---------------------
> 
> So I'm not sure why some are still here...
> xfs_iext_destroy

Exported... maybe you can tell me why? :)

> xfs_iext_idx_to_irec

Same deal.

> xfs_iext_realloc  (only exists in header???)

Odd, missed that one, guess it can go too?  Maybe others lurk as well.

Thanks!

-Eric

> --Tim
> 
> 
> 
