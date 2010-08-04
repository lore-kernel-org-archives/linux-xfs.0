Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o747aeJA018065 for <xfs@oss.sgi.com>; Wed, 4 Aug 2010 02:36:40 -0500
Received: from linta.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3C439492C68
	for <xfs@oss.sgi.com>; Wed,  4 Aug 2010 00:36:56 -0700 (PDT)
Received: from linta.de (isilmar-3.linta.de [188.40.101.200]) by cuda.sgi.com
	with ESMTP id iniYJxbYE2Jr3yHu for <xfs@oss.sgi.com>;
	Wed, 04 Aug 2010 00:36:56 -0700 (PDT)
Date: Wed, 4 Aug 2010 09:35:46 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
Subject: How to track down abysmal performance ata - raid1 - crypto - vg/lv
	- xfs
Message-ID: <20100804073546.GA7494@comet.dominikbrodowski.net>
MIME-Version: 1.0
Content-Disposition: inline
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
To: linux-raid@vger.kernel.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org

Hey,

on a production system I run kernel 2.6.35 and

	XFS	(rw,relatime,nobarrier)

on a

	lvdevice of a vgroup 

consisting of five

	dm-crypt devices (cryptsetup -c aes-lrw-benbi -s 384 create)

, each of which runs on a

	md-raid1 device (mdadm --create --level=raid1 --raid-devices=2)

on two

	750 GB ATA devices.


The read performance is abysmal. The ata devices can be ruled out, as hdparm
resulted in acceptable performance:
> Timing cached reads:   9444 MB in  2.00 seconds = 4733.59 MB/sec
> Timing buffered disk reads:  298 MB in  3.02 seconds =  98.73 MB/sec

How can I best track down the cause of the performance problem, 
a) without rebooting too often, and
b) without breaking up the setup specified above (production system)?

Any ideas? perf(1)? iostat(1)?

Thanks & best,

	Dominik

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
