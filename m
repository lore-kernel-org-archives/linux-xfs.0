Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6LAUwAT072834 for <xfs@oss.sgi.com>; Wed, 21 Jul 2010 05:30:58 -0500
Received: from mail-fx0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AC8E6460758
	for <xfs@oss.sgi.com>; Wed, 21 Jul 2010 03:33:56 -0700 (PDT)
Received: from mail-fx0-f53.google.com (mail-fx0-f53.google.com
	[209.85.161.53]) by cuda.sgi.com with ESMTP id PXH536VoqDBAGsTZ
	for <xfs@oss.sgi.com>; Wed, 21 Jul 2010 03:33:56 -0700 (PDT)
Received: by fxm19 with SMTP id 19so4078382fxm.26
	for <xfs@oss.sgi.com>; Wed, 21 Jul 2010 03:33:56 -0700 (PDT)
From: Khelben Blackstaff <eye.of.the.8eholder@gmail.com>
Subject: Re: 4k sector drives
Date: Wed, 21 Jul 2010 13:33:48 +0300
MIME-Version: 1.0
Message-Id: <201007211333.48363.eye.of.the.8eholder@gmail.com>
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
To: xfs@oss.sgi.com

> I have these:
> Model=WDC WD20EARS-00MVWB0, FwRev=50.0AB50, SerialNo=WD-WMAZ20035646
> Model=WDC WD20EARS-00MVWB0, FwRev=50.0AB50, SerialNo=WD-WMAZ20028252

> Any chance to get Linux know they are 4k sector drives manually?

Your revision numbers are different than mine, because you have the 2TB drive,
but i guess its the same for these too. You can try "hdparm -I /dev/sdX" (capital i)
or "cat /sys/block/sdX/queue/hw_sector_size" to see what they report.

Mine report "Logical/Physical Sector size:           512 bytes"
There are newer revisions that report "Physical Sector size: 4096 bytes"

Nevertheless, you don't have to get them to report 4k to linux. As long as you
align the partitions its fine. As i said in the other post, newer fdisk doesn't use
"DOS compatibility mode" and uses sectors by default (instead of stupid CHS)
with a 1MB alignment, so every partition will be properly aligned. If you don't
dual boot Windows, you can also use GPT partitioning scheme.
Also, from what i have seen, xfsprogs are quite clever and find most stuff on
their own. I usually mkfs with "-s size=4096" just to be sure.

Slightly offtopic, there is another "problem" with these drives. They park the heads
every 8 seconds, so they _might_ wear prematurely. You can change the 8sec timer
or disable it with the wdidle3 utility from this url
http://support.wdc.com/product/download.asp?groupid=609&sid=113&lang=en

If you want to know more about the problem, there are many forums where
you can read about wdidle3 and i also posted about it on my blog.
http://lordkhelben.wordpress.com/2010/05/15/wd-caviar-green-hard-disks-idle-settings/

I hope i helped.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
