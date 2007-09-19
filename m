Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Sep 2007 08:53:51 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8JFrkuw004972
	for <xfs@oss.sgi.com>; Wed, 19 Sep 2007 08:53:47 -0700
Date: Wed, 19 Sep 2007 04:47:38 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 2.6.20 (XFS? related) crash after uptime of > 180 days during
 apt-get dist-upgrade on Debian Testing
In-Reply-To: <Pine.LNX.4.64.0709171315210.22156@p34.internal.lan>
Message-ID: <Pine.LNX.4.64.0709190442210.4411@p34.internal.lan>
References: <Pine.LNX.4.64.0709171315210.22156@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-kernel@vger.kernel.org
Cc: xfs@oss.sgi.com

On Mon, 17 Sep 2007, Justin Piszcz wrote:

> Including the XFS mailing list in here too because it may be an XFS bug 
> looking at the call trace.
>
> System: Debian Testing
> Kernel: 2.6.20
> Config: Attached
>
> I was running apt-get dist-upgrade as I always do to get the latest packages 
> upgraded and the kernel OOPS'd when it was upgrading 'tzdata' and the process 
> went into D-state and I had to reboot.
>
> The config file is from 2.6.20 but it had been moved to a 2.6.22 directory 
> for an upgrade, but all of the options have been left unchanged.
>
> Here is the *OOPS I captured via dmesg before I rebooted:
>
>

Also,

Not sure if this helps but when this happened, any file that was open()
for read/write seem to have also been corrupted..

$ /usr/sbin/xfs_bmap -v myconfig.txt.orig
myconfig.txt.orig:
  EXT: FILE-OFFSET      BLOCK-RANGE        AG AG-OFFSET        TOTAL
    0: [0..7]:          64601112..64601119 14 (52040..52047)       8
$ /usr/sbin/xfs_bmap -v myconfig.txt
myconfig.txt:
  EXT: FILE-OFFSET      BLOCK-RANGE        AG AG-OFFSET        TOTAL
    0: [0..7]:          64625720..64625727 14 (76648..76655)       8
$ md5sum myconfig*
db8c50ca2c86d2e757ecef1d6b3fcc69  myconfig.txt
09fb630623b3ae614511cef4c7a21063  myconfig.txt.orig
$ file myconfig.txt myconfig.txt.orig
myconfig.txt:      ASCII text
myconfig.txt.orig: data
$

$ strings -a myconfig.txt.orig
$

$ od -c myconfig.txt.orig
0000000  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0 *
0003500  \0  \0  \0  \0  \0  \0
0003506

Seems like it was NULL'd out?

Justin.
