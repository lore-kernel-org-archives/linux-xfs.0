Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 25 Feb 2008 01:54:53 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1P9sh72016784
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2008 01:54:47 -0800
Received: from ccerelbas03.cce.hp.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 88141EAF971
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2008 01:55:09 -0800 (PST)
Received: from ccerelbas03.cce.hp.com (ccerelbas03.cce.hp.com [161.114.21.106]) by cuda.sgi.com with ESMTP id Ov9QAHEkW5nChegw for <xfs@oss.sgi.com>; Mon, 25 Feb 2008 01:55:09 -0800 (PST)
Date: Mon, 25 Feb 2008 10:55:06 +0100 (CET)
From: Jan Derfinak <ja@mail.upjs.sk>
Subject: Re: [REVIEW] User-space support for bad_features2 patch
In-Reply-To: <47C27F63.8070909@sandeen.net>
Message-ID: <Pine.LNX.4.63.0802251042530.4548@alienAngel.home.sk>
References: <op.t6w1h5f53jf8g2@pc-bnaujok.melbourne.sgi.com>
 <47BF0963.6020809@sandeen.net> <op.t611gf1q3jf8g2@pc-bnaujok.melbourne.sgi.com>
 <47C27F63.8070909@sandeen.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Barry Naujok <bnaujok@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, 25 Feb 2008, Eric Sandeen wrote:

> Barry Naujok wrote:
> > On Sat, 23 Feb 2008 04:41:55 +1100, Eric Sandeen <sandeen@sandeen.net>  
> > wrote:
> 
> ...
> 
> >> My only thought here is that if you repair it, then use an older kernel
> >> w/o the fix, suddenly your fs behavior changes, whereas before you often
> >> got lucky, and both userspace & kernelspace swapped the same way, and
> >> you found the bits you were looking for out of luck :)  (same goes for
> >> the recent kernel fix too, I guess)
> > 
> > I believe the kernel code never tried to access "bad_features2" part
> > of the superblock, it always did the correct thing (correct me if I'm
> > wrong of course :).
> 
> I'm fairly sure that it did; both userspace & kernelspace were doing the
> same thing, and endian-flipping "too much" ... but I'd have to test
> again to be sure.

In my case (x86_64, both kernel and userspace 64-bit), kernel accessed the
right place (features2), but userspace (mkfs.xfs) accessed wrong place
(bad_features2).

After patching mkfs.xfs with your patch, kernel began to use lazy-count
without additional bad_features2 changes.

There seems to be problem with sb_fdblocks count but kernel really look for
features2 and behaves differently if lazy-count is sets on right place.


jan


-- 
