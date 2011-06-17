Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5HBaFZD116215 for <xfs@oss.sgi.com>; Fri, 17 Jun 2011 06:36:16 -0500
Received: from nm8.bullet.mail.sg1.yahoo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 11F0C1EDD8C3
	for <xfs@oss.sgi.com>; Fri, 17 Jun 2011 04:36:13 -0700 (PDT)
Received: from nm8.bullet.mail.sg1.yahoo.com (nm8.bullet.mail.sg1.yahoo.com
	[115.178.12.208]) by cuda.sgi.com with SMTP id h8Hg0o419sGmhX0w
	for <xfs@oss.sgi.com>; Fri, 17 Jun 2011 04:36:13 -0700 (PDT)
Message-ID: <385532.69322.qm@web77719.mail.sg1.yahoo.com>
Date: Fri, 17 Jun 2011 19:36:12 +0800 (SGT)
From: Gim Leong Chin <chingimleong@yahoo.com.sg>
Subject: Warning: AG size is a multiple of stripe width?
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
To: xfs@oss.sgi.com

Hi,


I have a Sun workstation with eight Cheetah 15K.5 SAS 300 GB on RAID 1E (RAID 10) on LSI SAS3081E-R.

I am installing SLED 11 SP1 on it and I thought I will do a thorough optimization right down to the partition boundaries.

Since the default for XFS is to create four aggregation groups, and with the reasoning that Cheetah can do double the seeks of normal 7200 RPM drives, I have four aggregation groups per drive for a total of 16 for 70 GB /dev/sda2 partition, and eight per drive for total of 32 for /dev/sda3 partition (1011 GB).

I have aligned the partition start and end with the stripe width boundaries.
The stripe size is 64 kB, stripe width is 4*64 kB = 256 kB, in terms of 512 byte sectors:

70 GB /

No      Start           End             Number
1       512             67109375        32 GB = 67108864 sectors = 131072 stripe sets

2       67109376        213910015       70 GB = 146800640 sectors = 286720 stripe sets

3       213910016       2335932415      Left = 2335932416 - 213910016 = 2122022400 sectors = 4144575 stripe sets


When I do the following:

mkfs.xfs -f -b size=4k -d agcount=16,su=64k,sw=4 -i size=256,align=1,attr=2 -l version=2,su=64k,lazy-count=1 -n version=2 -s size=512 -L / /dev/sda2

Warning: AG size is a multiple of stripe width.  This can cause performance problems by aligning all AGs on the same disk.  To avoid this, run mkfs with an AG size that is one stripe unit smaller, for example 1146864

agcount=16 agsize=1146880 blks
bsize=4096
sunit=16 swidth=64 blks

mkfs.xfs -f -b size=4k -d agcount=32,su=64k,sw=4 -i size=256,align=1,attr=2 -l version=2,su=64k,lazy-count=1 -n version=2 -s size=512 -L /home /dev/sda3

Warning: AG size is a multiple of stripe width.  This can cause performance problems by aligning all AGs on the same disk.  To avoid this, run mkfs with an AG size that is one stripe unit smaller, for example 8289136

agcount=32 agsize=8289152 blks
bsize=4096
sunit=16 swidth=64 blks

I am really puzzled since I thought all I am doing is distributing 4 aggregation groups per drive for sda2 and 8 per drive for sda3.

What have I done wrong and what is the flaw with my understanding?

Thank you!


Chin Gim Leong


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
