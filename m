Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 29 May 2007 17:41:55 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4U0fnWt028343
	for <xfs@oss.sgi.com>; Tue, 29 May 2007 17:41:51 -0700
Date: Wed, 30 May 2007 10:41:40 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: xfs_fsr 2.2.38 bug/kernel 2.6.21.3 cannot defrag volume
Message-ID: <20070530004140.GX85884050@sgi.com>
References: <Pine.LNX.4.64.0705291404430.2944@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705291404430.2944@p34.internal.lan>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: xfs@oss.sgi.com, apiszcz@solarrain.com

On Tue, May 29, 2007 at 02:05:44PM -0400, Justin Piszcz wrote:
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

Try xfs_db -c "frag -v" -f /dev/md1 to see which inodes are
fragmented, then run xfs_db -c "inode <num>" -c bmap -f /dev/md1
to see whether it is a sparse file or not....

Remember - xfs_fsr does best effort defrag - if it can't make
progress, it does nothing, and it can't defrag directories...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
