Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 19 Oct 2008 04:17:45 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9JBHbCx029423
	for <xfs@oss.sgi.com>; Sun, 19 Oct 2008 04:17:37 -0700
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DA1C51432190
	for <xfs@oss.sgi.com>; Sun, 19 Oct 2008 04:19:19 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by cuda.sgi.com with ESMTP id P3Ri47mpXOkPKMCV for <xfs@oss.sgi.com>; Sun, 19 Oct 2008 04:19:19 -0700 (PDT)
Date: Sun, 19 Oct 2008 07:19:19 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: kernel 2.6.27.2 (32bit) filesystem is read-only
In-Reply-To: <alpine.DEB.1.10.0810190407370.14982@p34.internal.lan>
Message-ID: <alpine.DEB.1.10.0810190709580.26674@p34.internal.lan>
References: <alpine.DEB.1.10.0810181926380.20575@p34.internal.lan> <48FA8C3D.5090202@sandeen.net> <alpine.DEB.1.10.0810190407370.14982@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com



On Sun, 19 Oct 2008, Justin Piszcz wrote:

>
>
> On Sat, 18 Oct 2008, Eric Sandeen wrote:
>
>> Justin Piszcz wrote:
>>> all 2.6.26.x kernels work ok,
>>> make oldconfig on 2.6.27.2, filesystem mounted read-only at boot
>>> booted back to 2.6.26.x, back to normal
>>> barriers are on by default (single disk system)
>>> 
>>> 
>> 
>> You'll need:
>> 
>> http://git.kernel.org/?p=linux/kernel/git/stable/stable-queue.git;a=blob;f=review-2.6.27/xfs-fix-remount-rw-with-unrecognized-options.patch;h=4f93cbab85eb4c3b097065da3e13878d499b0d5a;hb=HEAD
>> 
>> s/b in 2.6.27.3 (pity it took 3 -stable releases, though)
>> 
>> -Eric
>> 
>> 
>
> Thanks Eric.
>
> Justin.
>

Confirmed working, but now it broke my UPS (nut doesn't start anymore) 
(usb issues)

$ uname -a
Linux box 2.6.27.2 #2 SMP PREEMPT Sun Oct 19 06:58:32 EDT 2008 i686 GNU/Linux
