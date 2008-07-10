Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Jul 2008 23:04:18 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6A64Dwa004266
	for <xfs@oss.sgi.com>; Wed, 9 Jul 2008 23:04:15 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0D0F02D330B
	for <xfs@oss.sgi.com>; Wed,  9 Jul 2008 23:05:18 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id VrG1OBe1vPbU3GPJ for <xfs@oss.sgi.com>; Wed, 09 Jul 2008 23:05:18 -0700 (PDT)
Date: Thu, 10 Jul 2008 16:05:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] re-remove xfs custom bitops
Message-ID: <20080710060506.GW11558@disturbed>
References: <480EB397.1040304@sandeen.net> <4829C360.5060500@sandeen.net> <482BF841.8050704@sgi.com> <48669A45.1050104@sandeen.net> <4868A114.9080106@sgi.com> <486C322D.7080203@sandeen.net> <486C75DD.2040109@sgi.com> <48759813.2080601@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48759813.2080601@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Donald Douwsma <donaldd@sgi.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On Thu, Jul 10, 2008 at 03:03:15PM +1000, Donald Douwsma wrote:
> Donald Douwsma wrote:
>> Eric Sandeen wrote:
>>> Donald Douwsma wrote:
>>>
>>>> First time round I hit an Oops on xfstests/177 while running the 
>>>> auto group
>>>> on ppc32. I dont seem to hit it running the single test, its  
>>>> intermittent.
>>>
>>> Funky.  Do you ever hit it w/ the patch reverted?
>>
>> That's the question. So far no, the QA guys said they hit it a while
>> ago, but the time frame still matches last time. I dont think this
>> is related but I need to get some more ppc32 runs without.
>>
>> I'm probably being over cautious but I'd like to avoid the
>> inagain/outagain/inagain/outagain approach we keep using with
>> some of these cleanups.
>>
>> Don
>>
>
> Ok I hit the Oops again last weekend without the patch.
> Which means I have a patch to checkin and another bug to fix Yea!
>
> Dave, Eric said this should still be considered signed-off-by you,
> You ok with that?

Yeah, no problems there.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
