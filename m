Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAO46D72057015 for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 22:06:13 -0600
Received: from smtp3.clear.net.nz (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E93AF1C6CC78
	for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 20:07:50 -0800 (PST)
Received: from smtp3.clear.net.nz (smtp3.clear.net.nz [203.97.33.64]) by
	cuda.sgi.com with ESMTP id di6WeeJpyerNQVzf for
	<xfs@oss.sgi.com>; Tue, 23 Nov 2010 20:07:50 -0800 (PST)
Received: from [210.246.8.120] (210-246-8-120.paradise.net.nz [210.246.8.120])
	by smtp3.clear.net.nz (CLEAR Net Mail)
	with ESMTP id <0LCD00E8VFGYXF00@smtp3.clear.net.nz> for xfs@oss.sgi.com;
	Wed, 24 Nov 2010 17:07:48 +1300 (NZDT)
Date: Wed, 24 Nov 2010 17:03:45 +1300
From: Richard Scobie <r.scobie@clear.net.nz>
Subject: Re: Xfs delaylog hanged up
Message-id: <4CEC8EA1.8070104@clear.net.nz>
MIME-version: 1.0
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
To: xfs@oss.sgi.com

Spelic wrote:

 > Yep, because I know MD better, I can see the code, it's more flexible 
 > and customizable, can be controlled with scripts more easily... Also
 > parameters to the underlying drives can be controlled if I use MD, 
and > it's easier to align filesystem to stripes. Also my time is better

Slightly off topic, but your previously mentioned xfs_info shows sunit 
and swidth values of zero, so your filesystem is not aligned to stripes.

/# xfs_info /perftest/xfs/
 > meta-data=/dev/mapper/perftestvg-xfslv isize=256    agcount=16,
 > agsize=50331648 blks
 >          =                       sectsz=512   attr=2
 > data     =                       bsize=4096   blocks=805306368, imaxpct=5
 >          =                       sunit=0      swidth=0 blks

Regards,

Richard

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
