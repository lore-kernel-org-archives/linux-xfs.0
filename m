Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Feb 2008 20:13:13 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1M4DAjU003565
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 20:13:11 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9B8426050E3
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 20:13:36 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id BSSHEuLDg2iTghCn for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 20:13:36 -0800 (PST)
Message-ID: <47BE4BEE.4050907@sandeen.net>
Date: Thu, 21 Feb 2008 22:13:34 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [REVIEW] Fix end of device zeroing with > 1K sector sizes
References: <op.t6wqj6zq3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <op.t6wqj6zq3jf8g2@pc-bnaujok.melbourne.sgi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Barry Naujok wrote:
> It has been found that mkfs with big sector sizes and devices/partitions
> that aren't aligned to the sector size can cause short writes when zeroing
> the end of the device. As mkfs.xfs didn't complete, the filesystem is
> unmountable.
> 
> Eg:
> 
> # mkfs.xfs -f -L fs_1 -s size=4096 -l size=64m,sunit=512 /dev/hdd1
> mkfs.xfs: error - wrote only 130048 of 131072 bytes
> 
> 
> The attached patch rounds down the device size to either 1K or
> the sector size, whichever is greater.

Hopefully to a multiple thereof ;)

Looks good to me... and strangely familiar!

-Eric

> Barry.
> 
