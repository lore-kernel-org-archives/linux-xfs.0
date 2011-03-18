Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2IK8oUt053641 for <xfs@oss.sgi.com>; Fri, 18 Mar 2011 15:08:55 -0500
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9CBC514A4CD6
	for <xfs@oss.sgi.com>; Fri, 18 Mar 2011 13:11:45 -0700 (PDT)
Received: from moutng.kundenserver.de (moutng.kundenserver.de [212.227.17.9])
	by cuda.sgi.com with ESMTP id CeO9owBtB45I4EfI for
	<xfs@oss.sgi.com>; Fri, 18 Mar 2011 13:11:45 -0700 (PDT)
From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: 2.6.38: XFS/USB/HW issue, or failing USB stick?
Date: Fri, 18 Mar 2011 21:11:43 +0100
References: <alpine.DEB.2.02.1103181104020.30018@p34.internal.lan>
	<201103182033.02793.arnd@arndb.de>
	<alpine.DEB.2.02.1103181547590.21715@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.02.1103181547590.21715@p34.internal.lan>
MIME-Version: 1.0
Message-Id: <201103182111.43126.arnd@arndb.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Tim Soderstrom <tim@moocowproductions.org>, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, flashbench-results@lists.linaro.org, Alan Piszcz <ap@solarrain.com>

On Friday 18 March 2011 20:51:47 Justin Piszcz wrote:
> Disk /dev/sda: 8220 MB, 8220835840 bytes
> 154 heads, 56 sectors/track, 1861 cylinders, total 16056320 sectors
> Units = sectors of 1 * 512 = 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk identifier: 0x99df019d
> 
>     Device Boot      Start         End      Blocks   Id  System
> /dev/sda1            2048    16056319     8027136   83  Linux

Ok, so it has the normal 1 MB alignment. That is not too
bad then, no immediate reason to reformat, because ext2
doesn't understand the concept of erase blocks.

If the partition was completely misaligned (old fdisk would
start the first partition at sector 63 instead of 2048),
that would be a much more significant problem.

> >>> Also, what is the output of 'lsusb' for this stick? I'd like to add the
> >>> data to https://wiki.linaro.org/WorkingGroups/KernelConsolidation/Projects/FlashCardSurvey
> >> Sure,
> >> Bus 001 Device 002: ID 0325:ac02 OCZ Technology Inc ATV Turbo / Rally2 Dual Channel USB 2.0 Flash Drive
> >>
> >
> > Added now, thanks!
> >
> > Do you also have the product name for this?
> 10007937 OCZ OCZUSBR2TDC-8GB 8GB Rally2 Turbo USB 2.0 Flash Drive Retail
> Was $116.99 on 01-05-2009.
> 
> Was purported (at the time) to be one of the fastest USB sticks available,
> according to benchmarks.
> 
Ok, thanks for the detailed information.

	Arnd

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
