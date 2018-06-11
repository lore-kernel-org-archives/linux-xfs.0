Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:60136 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933267AbeFKQqw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jun 2018 12:46:52 -0400
Subject: Re: [PATCH v1 1/1] xfstests: Add parent pointer test
References: <1528607439-11186-1-git-send-email-allison.henderson@oracle.com>
 <1528607439-11186-2-git-send-email-allison.henderson@oracle.com>
 <CAOQ4uxhxj3hmQsvLtTNKW-e4qvozT8WGoj0Z8v=c=D57FtKOXA@mail.gmail.com>
 <CAOQ4uxgXa7wE42sWF8vTssgrHtq4MEqj-jxqJXtgNAZN4ha6VA@mail.gmail.com>
 <b1ffc34b-b76b-7f19-daa5-9ad5597a83b3@oracle.com>
 <CAOQ4uxhGYe8PhgmM4oJaJdEdK=12yEgCU2DtbR+ac2c2GsVpkg@mail.gmail.com>
From: Allison Henderson <allison.henderson@oracle.com>
Message-ID: <d6ed6a31-567d-b51a-31f8-7b856e942347@oracle.com>
Date: Mon, 11 Jun 2018 09:46:49 -0700
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxhGYe8PhgmM4oJaJdEdK=12yEgCU2DtbR+ac2c2GsVpkg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On 06/10/2018 10:48 PM, Amir Goldstein wrote:
>>>>> diff --git a/tests/xfs/group b/tests/xfs/group
>>>>> index 2319f58..fb74e82 100644
>>>>> --- a/tests/xfs/group
>>>>> +++ b/tests/xfs/group
>>>>> @@ -445,3 +445,4 @@
>>>>>    445 auto quick filestreams
>>>>>    446 auto quick
>>>>>    447 auto mount
>>>>> +448 auto
>>>
>>>
>>> Isn't this test quick?
>>>
>>> Thanks,
>>> Amir.
>>
>>
>> It actually takes about a minute and a half for me, though I guess it would
>> depend on how fast the host is.  Most of the time goes into the loop of 100:
>> create a hard link, and then scan through all the entries to see if the new
>> parent pointer is there.  This was mostly to make sure the attr tree was
>> expanding correctly back when I was trying to get the transaction rolling
>> straightened out.
>>
> 
> That is still a bit surprising to me. I suspect the parent pointer parsing
> code that invokes awk so many times may be the culprit. We soemtimes use
> little C progs to assist in the test (see in src/) in cases where bash scripting
> is insufficient or inefficient.
> 
> Perhaps if you use more bash array tricks instead of awk, parsing code
> will be faster? assuming that parsing code is the slow down factor?
> 
> In any case, a "quick" test gets run more frequently by more people
> so it would be a big benefit IMO if you are able to squeeze that test
> runtime down to "quick".
> 
> Thanks,
> Amir.
Sure, I'll see if I can optimize it a bit and get it running faster.  Thx!

Allison

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  https://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwIBaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=LHZQ8fHvy6wDKXGTWcm97burZH5sQKHRDMaY1UthQxc&m=vWiNIvBeBg202a7NN7X4n0WSHRr-Ei2L-R8EQOBB9VM&s=mzL-0eBB_n9b0bYDeVwM7Kol762OzPzbUbKNG4pT6QY&e=
> 
