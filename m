Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o077ajaL155052
	for <linux-xfs@oss.sgi.com>; Thu, 7 Jan 2010 01:36:45 -0600
Received: from mail-fx0-f212.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3064B1C36D34
	for <linux-xfs@oss.sgi.com>; Wed,  6 Jan 2010 23:37:37 -0800 (PST)
Received: from mail-fx0-f212.google.com (mail-fx0-f212.google.com
	[209.85.220.212]) by cuda.sgi.com with ESMTP id
	NEUH1BxT84OEhuCO for <linux-xfs@oss.sgi.com>;
	Wed, 06 Jan 2010 23:37:37 -0800 (PST)
Received: by fxm4 with SMTP id 4so14981151fxm.12
	for <linux-xfs@oss.sgi.com>; Wed, 06 Jan 2010 23:37:36 -0800 (PST)
MIME-Version: 1.0
From: Raz <raziebe@gmail.com>
Date: Thu, 7 Jan 2010 09:37:16 +0200
Message-ID: <5d96567b1001062337w105194c8u8eff888444709925@mail.gmail.com>
Subject: how does sectsz is determined ?
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

How does sectsz determined to be 512 or 4096 ?
I have an xfs file system over software raid , and sometimes I have
1/2K sector size
and sometimes 4K . Problem is that direct io buffers are aligned to
1/2k and not 4K.
kernel is 2.6.18-8.el5. thank you.
raz


meta-data=/dev/md5               isize=256    agcount=33, agsize=10992384 blks
         =                       sectsz=4096  attr=0
data     =                       bsize=4096   blocks=351780864, imaxpct=25
         =                       sunit=768    swidth=768 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=32768, version=2
         =                       sectsz=4096  sunit=1 blks
realtime =none                   extsz=3145728 blocks=0, rtextents=0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
