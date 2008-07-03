Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 02 Jul 2008 23:46:01 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m636jtJP013215
	for <xfs@oss.sgi.com>; Wed, 2 Jul 2008 23:45:57 -0700
Received: from cxfsmac10.melbourne.sgi.com (cxfsmac10.melbourne.sgi.com [134.14.55.100]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id QAA20116; Thu, 3 Jul 2008 16:46:53 +1000
Message-ID: <486C75DD.2040109@sgi.com>
Date: Thu, 03 Jul 2008 16:46:53 +1000
From: Donald Douwsma <donaldd@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] re-remove xfs custom bitops
References: <480EB397.1040304@sandeen.net> <4829C360.5060500@sandeen.net> <482BF841.8050704@sgi.com> <48669A45.1050104@sandeen.net> <4868A114.9080106@sgi.com> <486C322D.7080203@sandeen.net>
In-Reply-To: <486C322D.7080203@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

Eric Sandeen wrote:
> Donald Douwsma wrote:
> 
>> First time round I hit an Oops on xfstests/177 while running the auto group
>> on ppc32. I dont seem to hit it running the single test, its intermittent.
> 
> Funky.  Do you ever hit it w/ the patch reverted?

That's the question. So far no, the QA guys said they hit it a while
ago, but the time frame still matches last time. I dont think this
is related but I need to get some more ppc32 runs without.

I'm probably being over cautious but I'd like to avoid the
inagain/outagain/inagain/outagain approach we keep using with
some of these cleanups.

Don
