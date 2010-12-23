Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBNCUfDm167342 for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 06:30:42 -0600
Received: from mail-iy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1153C21B337
	for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 04:32:40 -0800 (PST)
Received: from mail-iy0-f181.google.com (mail-iy0-f181.google.com
	[209.85.210.181]) by cuda.sgi.com with ESMTP id
	UH0phAaObmCemkGp for <xfs@oss.sgi.com>;
	Thu, 23 Dec 2010 04:32:40 -0800 (PST)
Received: by iyj18 with SMTP id 18so5669007iyj.26
	for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 04:32:40 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 23 Dec 2010 13:32:40 +0100
Message-ID: <AANLkTi=Xes02L3XfZvUu6Yh2yi2FR8GtpVdOGzngVjJk@mail.gmail.com>
Subject: no rw xfs file systems in mtab: /proc/mounts
From: Honza Fikar <j.fikar@gmail.com>
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

Hi guys,

when I try "xfs_fsr -v -d" on my two computers, it says now:

no rw xfs file systems in mtab: /proc/mounts

while actually there is the LUKS encrypted root:
...
/dev/mapper/root / xfs
rw,noatime,attr2,inode64,logbufs=8,logbsize=256k,noquota 0 0
...

on the third computer it works as expected, there are two xfs file
systems, one of them LUKS encrypted:
...
/dev/root / xfs
rw,noatime,attr2,delaylog,inode64,logbufs=8,logbsize=256k,noquota 0 0
/dev/mapper/encrypted /home xfs
rw,noatime,attr2,delaylog,inode64,logbufs=8,logbsize=256k,sunit=512,swidth=1536,noquota
0 0
...

and it was working some time ago on all the three computers

distribution gentoo
xfsprogs 3.1.4, but I just tried git version and it's the same
kernel 2.6.32, on the third machine 2.6.35

Best regards,
Honza

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
