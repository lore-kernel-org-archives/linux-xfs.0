Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 09 Nov 2008 14:42:08 -0800 (PST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mA9MfwaF032528
	for <xfs@oss.sgi.com>; Sun, 9 Nov 2008 14:41:59 -0800
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 384DB1B7CB50
	for <xfs@oss.sgi.com>; Sun,  9 Nov 2008 14:41:57 -0800 (PST)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id ZJRpP0IZxbkx0sDI for <xfs@oss.sgi.com>; Sun, 09 Nov 2008 14:41:57 -0800 (PST)
Date: Mon, 10 Nov 2008 09:41:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_repair hanging
Message-ID: <20081109224151.GR4985@disturbed>
References: <alpine.DEB.1.10.0811091026030.6319@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0811091026030.6319@p34.internal.lan>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: xfs@oss.sgi.com

On Sun, Nov 09, 2008 at 10:28:21AM -0500, Justin Piszcz wrote:
> p34:~# xfs_repair -V
> xfs_repair version 2.9.8
>
> Hangs with xfs_repair as shown below or with -L option.
....
> pread(4, "Driver\n------\n\nInformations about"..., 4096, 10944512) = 4096
> write(2, "bad magic # 0x44726976 in btbno b"..., 45bad magic # 0x44726976 in btbno block 0/2672
> ) = 45
> pread(4, "00-INDEX\n\t- this file (info on so"..., 4096, 188416) = 4096
> write(2, "bad magic # 0x30302d49 in btbno b"..., 43bad magic # 0x30302d49 in btbno block 0/46
> ) = 43
> futex(0x185d098, FUTEX_WAIT_PRIVATE, 2, NULL

Try disabling prefetch mode (-P)?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
