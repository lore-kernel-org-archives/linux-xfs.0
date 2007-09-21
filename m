Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Sep 2007 17:16:03 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8L0Frgf013688
	for <xfs@oss.sgi.com>; Thu, 20 Sep 2007 17:15:57 -0700
Date: Fri, 21 Sep 2007 10:15:45 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: 2.6.20 (XFS? related) crash after uptime of > 180 days during apt-get dist-upgrade on Debian Testing
Message-ID: <20070921001544.GB995458@sgi.com>
References: <Pine.LNX.4.64.0709171315210.22156@p34.internal.lan> <Pine.LNX.4.64.0709190442210.4411@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709190442210.4411@p34.internal.lan>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Wed, Sep 19, 2007 at 04:47:38AM -0400, Justin Piszcz wrote:
> On Mon, 17 Sep 2007, Justin Piszcz wrote:
> 
> >Including the XFS mailing list in here too because it may be an XFS bug 
> >looking at the call trace.
> >
> >System: Debian Testing
> >Kernel: 2.6.20
> >Config: Attached
> >
> >I was running apt-get dist-upgrade as I always do to get the latest 
> >packages upgraded and the kernel OOPS'd when it was upgrading 'tzdata' and 
> >the process went into D-state and I had to reboot.
> >
> >The config file is from 2.6.20 but it had been moved to a 2.6.22 directory 
> >for an upgrade, but all of the options have been left unchanged.
> >
> >Here is the *OOPS I captured via dmesg before I rebooted:
> >
> >
> 
> Also,
> 
> Not sure if this helps but when this happened, any file that was open()
> for read/write seem to have also been corrupted..

Is that all files, or just ones that were being changed?

> $ /usr/sbin/xfs_bmap -v myconfig.txt.orig
> myconfig.txt.orig:
>  EXT: FILE-OFFSET      BLOCK-RANGE        AG AG-OFFSET        TOTAL
>    0: [0..7]:          64601112..64601119 14 (52040..52047)       8
> $ /usr/sbin/xfs_bmap -v myconfig.txt
> myconfig.txt:
>  EXT: FILE-OFFSET      BLOCK-RANGE        AG AG-OFFSET        TOTAL
>    0: [0..7]:          64625720..64625727 14 (76648..76655)       8
> $ md5sum myconfig*
> db8c50ca2c86d2e757ecef1d6b3fcc69  myconfig.txt
> 09fb630623b3ae614511cef4c7a21063  myconfig.txt.orig
> $ file myconfig.txt myconfig.txt.orig
> myconfig.txt:      ASCII text
> myconfig.txt.orig: data
> $
> 
> $ strings -a myconfig.txt.orig
> $
> 
> $ od -c myconfig.txt.orig
> 0000000  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0 *
> 0003500  \0  \0  \0  \0  \0  \0
> 0003506
> 
> Seems like it was NULL'd out?

A single block of zeros - its possible that the crash occurred between
the allocation transaction and the data write - the allocation gets
replayed (along with the new file size), but the data write does
not (not journalled). This is one of the rarer "NULL files on crash"
failure modes fixed in 6.5.22.....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
