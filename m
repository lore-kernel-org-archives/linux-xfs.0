Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 Jul 2008 11:36:30 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m67IaSCq013719
	for <xfs@oss.sgi.com>; Mon, 7 Jul 2008 11:36:28 -0700
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 56D77DB15FA
	for <xfs@oss.sgi.com>; Mon,  7 Jul 2008 11:37:32 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by cuda.sgi.com with ESMTP id hDX17cvsb0T2wRsX for <xfs@oss.sgi.com>; Mon, 07 Jul 2008 11:37:32 -0700 (PDT)
Date: Mon, 7 Jul 2008 14:37:31 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 12 Veliciraptors again w/x4 card (~1gbyte/sec aggregate read)!
In-Reply-To: <alpine.DEB.1.10.0807071424100.4694@p34.internal.lan>
Message-ID: <alpine.DEB.1.10.0807071436080.5166@p34.internal.lan>
References: <alpine.DEB.1.10.0807071424100.4694@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com



On Mon, 7 Jul 2008, Justin Piszcz wrote:

> Each PCI-e x1 card has 1 veliciraptor on it now.
> Got an x4 card wit 4 sata ports:
>
> Not quite the > 1 gbyte/sec I was hoping for in regards to the reads
> but pretty close!

Going to remove one of the drives from the x1 card and put it on the x4
card instead, then I will use all 4 SATA ports on the x4 and hopefully get
better bw.

If you look at 7,8,9 there is little improvement: (PCI-e x1)

7 VR
   2  6    160  46744 6599020  44688    0    0 748204    17 3042 9084  0 34 40 26
   3  6    160  46592 6598824  44372    0    0 747520     8 2975 9047  1 33 31 36
8 VR
   2  7    160  46512 6598612  44580    0    0 761184    16 3089 9937  0 36 40 24
   2  7    160  44528 6600392  44360    0    0 759720     8 2993 9522  0 36 36 28
9 VR
   2  8    160  47152 6596824  44572    0    0 767016     0 3075 9730  1 37 39 24
   2  7    160  46576 6597728  44688    0    0 771200     0 3032 9568  0 37 40 23

But once I hit the drives on the x4 card, vroom vroom!

10 VR
   0 10    160  45048 6598240  44428    0    0 889072     8 3599 11561  0 47 20 33
   2 10    160  45232 6598116  44772    0    0 890112     0 3495 11547  0 46 23 31
11 VR
   4  8    160  45536 6594716  44600    0    0 996352     0 3947 12134  1 62 13 25
   2  9    160  45348 6594912  44096    0    0 1009152     0 3949 11949  0 63 10 28
12 VR
   6  8    160  45092 6583136  47016    0    0 1063200     0 4187 12394  1 71  9 21
   3 11    160  47080 6578492  47588    0    0 1058412     0 4224 12547  1 72  8 20


Justin.
