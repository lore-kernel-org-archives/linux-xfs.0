Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Feb 2008 15:21:47 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1INLev3003771
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2008 15:21:43 -0800
Received: from ishtar.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8F03FE55D17
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2008 15:22:06 -0800 (PST)
Received: from ishtar.tlinx.org (ishtar.tlinx.org [64.81.245.74]) by cuda.sgi.com with ESMTP id aNSlurqcXTlcAU6x for <xfs@oss.sgi.com>; Mon, 18 Feb 2008 15:22:06 -0800 (PST)
Message-ID: <47BA131A.5080908@tlinx.org>
Date: Mon, 18 Feb 2008 15:22:02 -0800
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: xfsaild causing 30+ wakeups/s on an idle system since 2.6.25-rcX
References: <47B863A9.5070206@gmail.com>
In-Reply-To: <47B863A9.5070206@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: =?UTF-8?B?VMO2csO2ayBFZHdpbg==?= <edwintorok@gmail.com>
Cc: xfs@oss.sgi.com, Linux Kernel <linux-kernel@vger.kernel.org>, Arjan van de Ven <arjan@linux.intel.com>

Not to look excessively dumb, but what's xfsaild?

xfs seems to be sprouting daemons at a more rapid pace
these days...xfsbufd, xfssyncd, xfsdatad, xfslogd, xfs_mru_cache, and
now xfsaild?

Not a complaint if it ups performance, but I do sorta wonder what all
of them are for and why they are needed "now" but not for, say,
kernels before 2.6.18 (arbitrary number picked out of hat).

Like bufd writes out buffers, logd writes/hands the log, datad?  Isn't
the data in buffers? mru_cache? -- isn't that handled by the linux
block layer?  Sorry...just a bit confused by the additions...

Are there any design docs (scribbles?) saying what these do and why
they were added so I can just go read 'em myself?  I'm sure they
were added for good reason...just am curious more than anything.

Thanksd
-lindad
