Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Jul 2008 22:09:20 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6A59HTe000829
	for <xfs@oss.sgi.com>; Wed, 9 Jul 2008 22:09:18 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7E11DDE2D4B
	for <xfs@oss.sgi.com>; Wed,  9 Jul 2008 22:10:22 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id yq28ENG8xegpG2EE for <xfs@oss.sgi.com>; Wed, 09 Jul 2008 22:10:22 -0700 (PDT)
Message-ID: <487599BD.2040003@sandeen.net>
Date: Thu, 10 Jul 2008 00:10:21 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] re-remove xfs custom bitops
References: <480EB397.1040304@sandeen.net> <4829C360.5060500@sandeen.net> <482BF841.8050704@sgi.com> <48669A45.1050104@sandeen.net> <4868A114.9080106@sgi.com> <486C322D.7080203@sandeen.net> <486C75DD.2040109@sgi.com> <48759813.2080601@sgi.com>
In-Reply-To: <48759813.2080601@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Donald Douwsma <donaldd@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Donald Douwsma wrote:
> Donald Douwsma wrote:
>> Eric Sandeen wrote:
>>> Donald Douwsma wrote:
>>>
>>>> First time round I hit an Oops on xfstests/177 while running the auto 
>>>> group
>>>> on ppc32. I dont seem to hit it running the single test, its 
>>>> intermittent.
>>> Funky.  Do you ever hit it w/ the patch reverted?
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
> Eric, am I ok to add yours too since you kept this on the radar?

That's fine by me, thanks.

-Eric
