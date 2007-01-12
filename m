Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 12 Jan 2007 06:34:56 -0800 (PST)
Received: from hobbit.corpit.ru (hobbit.corpit.ru [81.13.94.6])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0CEYkqw020912
	for <xfs@oss.sgi.com>; Fri, 12 Jan 2007 06:34:48 -0800
Message-ID: <45A794B4.5020608@tls.msk.ru>
Date: Fri, 12 Jan 2007 17:01:24 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
MIME-Version: 1.0
Subject: Re: Linux Software RAID 5 Performance Optimizations: 2.6.19.1: (211MB/s
 read & 195MB/s write)
References: <Pine.LNX.4.64.0701111832080.3673@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0701111832080.3673@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com

Justin Piszcz wrote:
> Using 4 raptor 150s:
> 
> Without the tweaks, I get 111MB/s write and 87MB/s read.
> With the tweaks, 195MB/s write and 211MB/s read.
> 
> Using kernel 2.6.19.1.
> 
> Without the tweaks and with the tweaks:
> 
> # Stripe tests:
> echo 8192 > /sys/block/md3/md/stripe_cache_size
> 
> # DD TESTS [WRITE]
> 
> DEFAULT: (512K)
> $ dd if=/dev/zero of=10gb.no.optimizations.out bs=1M count=10240
> 10240+0 records in
> 10240+0 records out
> 10737418240 bytes (11 GB) copied, 96.6988 seconds, 111 MB/s
[]
> 8192K READ AHEAD
> $ dd if=10gb.16384k.stripe.out of=/dev/null bs=1M
> 10240+0 records in
> 10240+0 records out
> 10737418240 bytes (11 GB) copied, 64.9454 seconds, 165 MB/s

What exactly are you measuring?  Linear read/write, like copying one
device to another (or to /dev/null), in large chunks?

I don't think it's an interesting test.  Hint: how many times a day
you plan to perform such a copy?

(By the way, for a copy of one block device to another, try using
O_DIRECT, with two dd processes doing the copy - one reading, and
another writing - this way, you'll get best results without huge
affect on other things running on the system.  Like this:

 dd if=/dev/onedev bs=1M iflag=direct |
 dd of=/dev/twodev bs=1M oflag=direct
)

/mjt
