Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 29 Jul 2007 13:23:33 -0700 (PDT)
Received: from isp.becroft.co.nz (isp.becroft.co.nz [202.89.33.33])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6TKNSbm024713
	for <linux-xfs@oss.sgi.com>; Sun, 29 Jul 2007 13:23:30 -0700
Received: from server.ak.quickcircuit.co.nz (gateway.quickcircuit.co.nz [210.55.214.217])
	by isp.becroft.co.nz (8.12.11.20060308/8.12.9) with ESMTP id l6TJWIK9010873
	for <linux-xfs@oss.sgi.com>; Mon, 30 Jul 2007 07:32:18 +1200
Subject: Proper method of snapshotting XFS with external log using LVM2
From: Mario Becroft <mb@gem.win.co.nz>
Content-Type: text/plain
Date: Mon, 30 Jul 2007 07:32:18 +1200
Message-Id: <1185737538.12064.44.camel@server.ak.quickcircuit.co.nz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

I am using XFS and LVM2 under Linux. My XFS filesystems have an external
log.

What is the correct method of creating an LVM2 snapshot of volumes
containing an XFS filesystem with external log?

Do I need to snapshot the main filesystem volume and the log volume?

Should I be using xfs_freeze to ensure that the filesystem is not
modified between when I create the filesystem snapshot and the log
snapshot?

Or is there a special procedure for atomically creating both snapshots?

Or should I not be using an external log? If not, won't this decrease
performance?

In the past I have successfully used xfs_freeze and created separate
snapshots of the filesystem and log volumes. However, I am not sure
whether this is the recommended approach.

Thanks for any help.

-- 
Mario Becroft <mb@gem.win.co.nz>
