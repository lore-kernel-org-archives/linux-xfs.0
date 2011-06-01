Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p51B5m0t116251 for <xfs@oss.sgi.com>; Wed, 1 Jun 2011 06:05:48 -0500
Received: from server655-han.de-nserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D2B181ED09DB
	for <xfs@oss.sgi.com>; Wed,  1 Jun 2011 04:05:47 -0700 (PDT)
Received: from server655-han.de-nserver.de (server655-han.de-nserver.de
	[85.158.177.45]) by cuda.sgi.com with ESMTP id g0oq7aTPM3FxcGKy
	for <xfs@oss.sgi.com>; Wed, 01 Jun 2011 04:05:47 -0700 (PDT)
Message-ID: <4DE61D09.8010507@profihost.ag>
Date: Wed, 01 Jun 2011 13:05:45 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
Subject: XFS crashes with shrink_slab: xfs_reclaim_inode_shrink+0x0/0x10d
	negative objects to delete nr
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

Hi guys,

we're seeing a really bad behaviour on one of our machines running 
vanilla 2.6.32.40 kernel.

It freezes from time to time or processes starts to hang. At the same 
time the following message appears in the kernel log:

shrink_slab: xfs_reclaim_inode_shrink+0x0/0x10d negative objects to 
delete nr=-274207938304

shrink_slab: xfs_reclaim_inode_shrink+0x0/0x10d negative objects to 
delete nr=-549059303168

shrink_slab: xfs_reclaim_inode_shrink+0x0/0x10d negative objects to 
delete nr=-549500554116

shrink_slab: xfs_reclaim_inode_shrink+0x0/0x10d negative objects to 
delete nr=-549360922112

shrink_slab: xfs_reclaim_inode_shrink+0x0/0x10d negative objects to 
delete nr=-549407219078

shrink_slab: xfs_reclaim_inode_shrink+0x0/0x10d negative objects to 
delete nr=-549480231300

Any ideas? An xfs_repair says everything is fine.

-- 
Regards,
   Stefan Priebe

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
