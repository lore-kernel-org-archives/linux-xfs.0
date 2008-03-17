Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 17 Mar 2008 13:03:50 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2HK3gdU024022
	for <xfs@oss.sgi.com>; Mon, 17 Mar 2008 13:03:43 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8BD7C6B13EB
	for <xfs@oss.sgi.com>; Mon, 17 Mar 2008 13:04:14 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id Ow7EGSYk5mD6D6hB for <xfs@oss.sgi.com>; Mon, 17 Mar 2008 13:04:14 -0700 (PDT)
Message-ID: <47DECEBD.10604@sandeen.net>
Date: Mon, 17 Mar 2008 15:04:13 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] fix dir2 shortform structures on ARM old ABI
References: <47DB4181.7040603@sandeen.net> <20080315041722.GA25621@josefsipek.net> <47DB4F4F.8030407@sandeen.net> <20080315042703.GA28242@josefsipek.net> <47DB51A3.70200@sandeen.net> <20080315045147.GB28242@josefsipek.net> <47DEB930.7020108@sandeen.net> <20080317195313.GB16500@josefsipek.net>
In-Reply-To: <20080317195313.GB16500@josefsipek.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
Cc: xfs-oss <xfs@oss.sgi.com>

Josef 'Jeff' Sipek wrote:
> On Mon, Mar 17, 2008 at 01:32:16PM -0500, Eric Sandeen wrote:
>> Josef 'Jeff' Sipek wrote:
>>
>>> Josef 'Jeff' Sipek, wondering exactly how passionate one can get about
>>> structure member alignment :)
>> Very.  ;)
>>
>> Tossing packed at all the ondisk stuctures bloats things badly on ia64.
>>
>> cvs/linux-2.6-xfs> wc -l before.dis
>> 166688 before.dis
>> cvs/linux-2.6-xfs> wc -l after.dis
>> 182294 after.dis
>>
>> That's +15606 lines.
>  
> I'm not done yet! :-P
> 
> First of all, the patch I showed you actually breaks a few things that I
> still need to fix.

Oh, I wasn't trying to blame you or our patch specifically, just wanted
to highlight what I consider to be the bad idea of giving gcc a bunch of
directives that IMHO we don't need.

> Second, I need to find out whether all the affected structures are always
> aligned on some boundary (probably 4 or 8 byte). If there indeed is some
> alignment, there might be a way to reduce those 15k extra lines to something
> a whole lot less - I hope.

To what end?  What are you trying to fix?  If it's not reduced to 0 then
your change is introducing regressions, IMHO.

Respectfully, ;)
-Eric
