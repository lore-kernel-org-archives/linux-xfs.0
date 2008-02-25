Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 25 Feb 2008 00:42:26 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1P8gMDT011883
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2008 00:42:23 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A4471EA7D88
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2008 00:42:49 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id UkkteeqQ9MUFGYCC for <xfs@oss.sgi.com>; Mon, 25 Feb 2008 00:42:49 -0800 (PST)
Message-ID: <47C27F63.8070909@sandeen.net>
Date: Mon, 25 Feb 2008 02:42:11 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [REVIEW] User-space support for bad_features2 patch
References: <op.t6w1h5f53jf8g2@pc-bnaujok.melbourne.sgi.com> <47BF0963.6020809@sandeen.net> <op.t611gf1q3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <op.t611gf1q3jf8g2@pc-bnaujok.melbourne.sgi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Barry Naujok wrote:
> On Sat, 23 Feb 2008 04:41:55 +1100, Eric Sandeen <sandeen@sandeen.net>  
> wrote:

...

>> My only thought here is that if you repair it, then use an older kernel
>> w/o the fix, suddenly your fs behavior changes, whereas before you often
>> got lucky, and both userspace & kernelspace swapped the same way, and
>> you found the bits you were looking for out of luck :)  (same goes for
>> the recent kernel fix too, I guess)
> 
> I believe the kernel code never tried to access "bad_features2" part
> of the superblock, it always did the correct thing (correct me if I'm
> wrong of course :).

I'm fairly sure that it did; both userspace & kernelspace were doing the
same thing, and endian-flipping "too much" ... but I'd have to test
again to be sure.

-Eric
