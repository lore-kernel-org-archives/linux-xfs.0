Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 03 Jul 2008 08:01:54 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m63F1pVX001143
	for <xfs@oss.sgi.com>; Thu, 3 Jul 2008 08:01:51 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7C18A12D97C8
	for <xfs@oss.sgi.com>; Thu,  3 Jul 2008 08:02:54 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id bQy9oFoRFOqIz93V for <xfs@oss.sgi.com>; Thu, 03 Jul 2008 08:02:54 -0700 (PDT)
Message-ID: <486CEA1D.5010106@sandeen.net>
Date: Thu, 03 Jul 2008 10:02:53 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] re-remove xfs custom bitops
References: <480EB397.1040304@sandeen.net> <4829C360.5060500@sandeen.net> <482BF841.8050704@sgi.com> <48669A45.1050104@sandeen.net> <4868A114.9080106@sgi.com> <486C322D.7080203@sandeen.net> <486C75DD.2040109@sgi.com>
In-Reply-To: <486C75DD.2040109@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Donald Douwsma <donaldd@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Donald Douwsma wrote:
> Eric Sandeen wrote:
>> Donald Douwsma wrote:
>>
>>> First time round I hit an Oops on xfstests/177 while running the auto group
>>> on ppc32. I dont seem to hit it running the single test, its intermittent.
>> Funky.  Do you ever hit it w/ the patch reverted?
> 
> That's the question. So far no, the QA guys said they hit it a while
> ago, but the time frame still matches last time. I dont think this
> is related but I need to get some more ppc32 runs without.
> 
> I'm probably being over cautious but I'd like to avoid the
> inagain/outagain/inagain/outagain approach we keep using with
> some of these cleanups.

Yep, I totally understand, I'd do just the same.  :)

-Eric
