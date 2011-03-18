Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2IJn1Z9052881 for <xfs@oss.sgi.com>; Fri, 18 Mar 2011 14:49:07 -0500
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C643B14A4727
	for <xfs@oss.sgi.com>; Fri, 18 Mar 2011 12:51:47 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id HL5dPWAKQVetnNuB for
	<xfs@oss.sgi.com>; Fri, 18 Mar 2011 12:51:47 -0700 (PDT)
Date: Fri, 18 Mar 2011 15:51:47 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 2.6.38: XFS/USB/HW issue, or failing USB stick?
In-Reply-To: <201103182033.02793.arnd@arndb.de>
Message-ID: <alpine.DEB.2.02.1103181547590.21715@p34.internal.lan>
References: <alpine.DEB.2.02.1103181104020.30018@p34.internal.lan>
	<201103182010.37455.arnd@arndb.de>
	<alpine.DEB.2.02.1103181524400.21715@p34.internal.lan>
	<201103182033.02793.arnd@arndb.de>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Arnd Bergmann <arnd@arndb.de>
Cc: Tim Soderstrom <tim@moocowproductions.org>, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, flashbench-results@lists.linaro.org, Alan Piszcz <ap@solarrain.com>



On Fri, 18 Mar 2011, Arnd Bergmann wrote:

> On Friday 18 March 2011 20:26:46 Justin Piszcz wrote:
>>> The numbers are jumping around a bit with the incorrectly guessed erasesize.
>>> These values should be more like the ones in the first test. Can you rerun
>>> with --erasesize=$[4 * 1024 * 1024]?
>> Hi, I put the box back into production with ext2, if it fails again I can
>> re-run.
>
> Ok. Did you make sure to get the partition table right? It's
> rather tricky with fdisk, since it normally doesn't align
> to 4 MB. You can see this using 'fdisk -l -u /dev/sda'.

Erm, probably not right then..

Disk /dev/sda: 8220 MB, 8220835840 bytes
154 heads, 56 sectors/track, 1861 cylinders, total 16056320 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x99df019d

    Device Boot      Start         End      Blocks   Id  System
/dev/sda1            2048    16056319     8027136   83  Linux

>
>>> Also, what is the output of 'lsusb' for this stick? I'd like to add the
>>> data to https://wiki.linaro.org/WorkingGroups/KernelConsolidation/Projects/FlashCardSurvey
>> Sure,
>> Bus 001 Device 002: ID 0325:ac02 OCZ Technology Inc ATV Turbo / Rally2 Dual Channel USB 2.0 Flash Drive
>>
>
> Added now, thanks!
>
> Do you also have the product name for this?
10007937 OCZ OCZUSBR2TDC-8GB 8GB Rally2 Turbo USB 2.0 Flash Drive Retail
Was $116.99 on 01-05-2009.

Was purported (at the time) to be one of the fastest USB sticks available,
according to benchmarks.


>
> 	Arnd
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
