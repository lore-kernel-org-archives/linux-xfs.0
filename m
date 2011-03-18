Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2IJU8qQ051848 for <xfs@oss.sgi.com>; Fri, 18 Mar 2011 14:30:13 -0500
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5D03D5065F7
	for <xfs@oss.sgi.com>; Fri, 18 Mar 2011 12:33:04 -0700 (PDT)
Received: from moutng.kundenserver.de (moutng.kundenserver.de
	[212.227.126.186]) by cuda.sgi.com with ESMTP id
	mWytOXfyZlxs78Fg for <xfs@oss.sgi.com>;
	Fri, 18 Mar 2011 12:33:04 -0700 (PDT)
From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: 2.6.38: XFS/USB/HW issue, or failing USB stick?
Date: Fri, 18 Mar 2011 20:33:02 +0100
References: <alpine.DEB.2.02.1103181104020.30018@p34.internal.lan>
	<201103182010.37455.arnd@arndb.de>
	<alpine.DEB.2.02.1103181524400.21715@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.02.1103181524400.21715@p34.internal.lan>
MIME-Version: 1.0
Message-Id: <201103182033.02793.arnd@arndb.de>
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

On Friday 18 March 2011 20:26:46 Justin Piszcz wrote:
> > The numbers are jumping around a bit with the incorrectly guessed erasesize.
> > These values should be more like the ones in the first test. Can you rerun
> > with --erasesize=$[4 * 1024 * 1024]?
> Hi, I put the box back into production with ext2, if it fails again I can 
> re-run.

Ok. Did you make sure to get the partition table right? It's
rather tricky with fdisk, since it normally doesn't align
to 4 MB. You can see this using 'fdisk -l -u /dev/sda'.

> > Also, what is the output of 'lsusb' for this stick? I'd like to add the
> > data to https://wiki.linaro.org/WorkingGroups/KernelConsolidation/Projects/FlashCardSurvey
> Sure,
> Bus 001 Device 002: ID 0325:ac02 OCZ Technology Inc ATV Turbo / Rally2 Dual Channel USB 2.0 Flash Drive
> 

Added now, thanks!

Do you also have the product name for this?

	Arnd

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
