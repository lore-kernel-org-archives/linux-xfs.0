Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 04 Jun 2008 22:48:21 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m555mFSN021516
	for <xfs@oss.sgi.com>; Wed, 4 Jun 2008 22:48:15 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 982CA1783482
	for <xfs@oss.sgi.com>; Wed,  4 Jun 2008 22:49:09 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id 1zXtNRrfd0iKX51a for <xfs@oss.sgi.com>; Wed, 04 Jun 2008 22:49:09 -0700 (PDT)
Message-ID: <48477E54.9090309@sandeen.net>
Date: Thu, 05 Jun 2008 00:49:08 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] fix dir2 shortform structures on ARM old ABI
References: <47DB4181.7040603@sandeen.net> <480E89B5.8070006@sandeen.net> <481B7FD1.3030107@sandeen.net> <20080505070847.GH155679365@sgi.com> <481FDCD1.2010905@sgi.com> <4820609C.9090306@sandeen.net> <48477BD6.2020909@sandeen.net> <48477DA3.8090602@sgi.com>
In-Reply-To: <48477DA3.8090602@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: markgw@sgi.com
Cc: Timothy Shimmin <tes@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Mark Goodwin wrote:
> 
> Eric Sandeen wrote:
>> Eric Sandeen wrote:
>>> Timothy Shimmin wrote:
>>>> David Chinner wrote:
>>>>> On Fri, May 02, 2008 at 03:55:45PM -0500, Eric Sandeen wrote:
>>>>>> Eric Sandeen wrote:
>>>>>>> Eric Sandeen wrote:
>>>>>>>> This should fix the longstanding issues with xfs and old ABI
>>>>>>>> arm boxes, which lead to various asserts and xfs shutdowns,
>>>>>>>> and for which an (incorrect) patch has been floating around
>>>>>>>> for years.  (Said patch made ARM internally consistent, but
>>>>>>>> altered the normal xfs on-disk format such that it looked
>>>>>>>> corrupted on other architectures):
>>>>>>>> http://lists.arm.linux.org.uk/lurker/message/20040311.002034.5ecf21a2.html
>>>>>>> ping again...
>>>>>> ping #3...
>>>>> <sigh>
>> Guys, this is SIMPLE, SAFE, and it fixes a CORRUPTION BUG.
>> is it EVER going to get checked in?
> 
> Please take it in Tim, that nasty CORRUPTION word caught my attention :)
> 
> Cheers

heh, thanks Mark.  Even though it's only CORRUPTION ON ARM I guess the
shouting worked.  :)

Seriously though if you guys have any problems with it please let me
know but I don't want it to just get dropped.

-Eric
