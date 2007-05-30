Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 29 May 2007 19:41:17 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4U2fCWt026397
	for <xfs@oss.sgi.com>; Tue, 29 May 2007 19:41:14 -0700
Message-ID: <465CE447.1080608@sandeen.net>
Date: Tue, 29 May 2007 21:41:11 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_fsr 2.2.38 bug/kernel 2.6.21.3 cannot defrag volume
References: <Pine.LNX.4.64.0705291404430.2944@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0705291404430.2944@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: xfs@oss.sgi.com, apiszcz@solarrain.com

Justin Piszcz wrote:
> # uname -a
> Linux boxname 2.6.21.3 #2 SMP Sun May 27 11:34:21 EDT 2007 i686 GNU/Linux
> # xfs_fsr -V
> xfs_fsr version 2.2.38
> # xfs_db -V
> xfs_db version 2.8.18
> # xfs_db -c frag -f /dev/md1
> actual 449, ideal 403, fragmentation factor 10.24%
> # xfs_fsr /dev/md1
> /d2 start inode=0
> # xfs_db -c frag -f /dev/md1
> actual 449, ideal 403, fragmentation factor 10.24%
> #

So you have on average 1.114 extents per file.

Relax.  Have a homebrew.  :)

-Eric
