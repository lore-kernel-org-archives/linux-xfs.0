Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2LAoGIZ198164
	for <linux-xfs@oss.sgi.com>; Mon, 21 Mar 2011 05:50:21 -0500
Received: from sam.nabble.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0274136498A
	for <linux-xfs@oss.sgi.com>; Mon, 21 Mar 2011 03:53:04 -0700 (PDT)
Received: from sam.nabble.com (sam.nabble.com [216.139.236.26]) by
	cuda.sgi.com with ESMTP id TwMd0wuWtpCANy2B for
	<linux-xfs@oss.sgi.com>; Mon, 21 Mar 2011 03:53:04 -0700 (PDT)
Received: from isper.nabble.com ([192.168.236.156])
	by sam.nabble.com with esmtp (Exim 4.69)
	(envelope-from <lists@nabble.com>) id 1Q1cjQ-0004v5-3B
	for linux-xfs@oss.sgi.com; Mon, 21 Mar 2011 03:53:04 -0700
Message-ID: <31199414.post@talk.nabble.com>
Date: Mon, 21 Mar 2011 03:53:04 -0700 (PDT)
From: stress_buster <leo1783@yahoo.com>
Subject: umount fails with device is busy
MIME-Version: 1.0
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
To: linux-xfs@oss.sgi.com


I'm trying to run xfs_repair on my filesystem:
Firstly to unmount the fs

Quote:
umount /myfs
umount: /myfs: device is busy
umount: /myfs: device is busy  

Quote:
lsof /dev/sda  

-show none ie nothing seems to be 'touching' the disk.
confused why its still showing device is busy

i did a force unmount then 

Quote:
#umount -l /dev/sda  

but then when I try to run xfs_repair

Quote:
xfs_repair -n /dev/sda, it 
xfs_repair: /dev/sda contains a mounted and writable filesystem

fatal error -- couldn't initialize XFS library  

lsof /dev/sda
shows nothing ie nothing seems to be 'touching' the disk.
makes me wonder whether this is a xfs issue now??


Any thoughts???

Thanks 
David 

-- 
View this message in context: http://old.nabble.com/umount-fails-with-device-is-busy-tp31199414p31199414.html
Sent from the linux-xfs mailing list archive at Nabble.com.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
