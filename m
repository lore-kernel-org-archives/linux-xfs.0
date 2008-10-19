Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 19 Oct 2008 01:06:31 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9J85wtI014743
	for <xfs@oss.sgi.com>; Sun, 19 Oct 2008 01:05:59 -0700
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B9DC7AC6674
	for <xfs@oss.sgi.com>; Sun, 19 Oct 2008 01:07:42 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by cuda.sgi.com with ESMTP id TavZmoKEfF6gzVPz for <xfs@oss.sgi.com>; Sun, 19 Oct 2008 01:07:42 -0700 (PDT)
Date: Sun, 19 Oct 2008 04:07:41 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: kernel 2.6.27.2 (32bit) filesystem is read-only
In-Reply-To: <48FA8C3D.5090202@sandeen.net>
Message-ID: <alpine.DEB.1.10.0810190407370.14982@p34.internal.lan>
References: <alpine.DEB.1.10.0810181926380.20575@p34.internal.lan> <48FA8C3D.5090202@sandeen.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com



On Sat, 18 Oct 2008, Eric Sandeen wrote:

> Justin Piszcz wrote:
>> all 2.6.26.x kernels work ok,
>> make oldconfig on 2.6.27.2, filesystem mounted read-only at boot
>> booted back to 2.6.26.x, back to normal
>> barriers are on by default (single disk system)
>>
>>
>
> You'll need:
>
> http://git.kernel.org/?p=linux/kernel/git/stable/stable-queue.git;a=blob;f=review-2.6.27/xfs-fix-remount-rw-with-unrecognized-options.patch;h=4f93cbab85eb4c3b097065da3e13878d499b0d5a;hb=HEAD
>
> s/b in 2.6.27.3 (pity it took 3 -stable releases, though)
>
> -Eric
>
>

Thanks Eric.

Justin.
