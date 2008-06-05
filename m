Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 04 Jun 2008 23:33:32 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m556XPn4025936
	for <xfs@oss.sgi.com>; Wed, 4 Jun 2008 23:33:25 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A248D11C599F
	for <xfs@oss.sgi.com>; Wed,  4 Jun 2008 23:34:19 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id bdePHPLbQgrYZhp7 for <xfs@oss.sgi.com>; Wed, 04 Jun 2008 23:34:19 -0700 (PDT)
Message-ID: <484788E9.8050800@sandeen.net>
Date: Thu, 05 Jun 2008 01:34:17 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] fix dir2 shortform structures on ARM old ABI
References: <47DB4181.7040603@sandeen.net> <480E89B5.8070006@sandeen.net> <481B7FD1.3030107@sandeen.net> <20080505070847.GH155679365@sgi.com> <481FDCD1.2010905@sgi.com> <4820609C.9090306@sandeen.net> <48477BD6.2020909@sandeen.net> <20080605054938.GA17690@puku.stupidest.org>
In-Reply-To: <20080605054938.GA17690@puku.stupidest.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Wedgwood <cw@f00f.org>
Cc: Timothy Shimmin <tes@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Chris Wedgwood wrote:
> On Thu, Jun 05, 2008 at 12:38:30AM -0500, Eric Sandeen wrote:
> 
>> Guys, this is SIMPLE, SAFE, and it fixes a CORRUPTION BUG.
> 
> [...]
> 
>>>> As it only defines __arch_pack for __arm__,
> 
> __arch_pack is a horrible name and not very intuitive, what's wrong
> with __on_disk or something else?
> 
> 

seriously, if you don't like the name or the style of the fix that's
fine, we can fix that up, but I went to enough trouble to track down the
issue and test the fix it seems worth actually... fixing it.

If you want to __on_disk annotate everything and only pack it on arm
OABI that might be less hacky.  cw almost convinced me of this.

I was just going for "least invasive" here.

-Eric
