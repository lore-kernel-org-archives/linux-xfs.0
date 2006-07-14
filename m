Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 14 Jul 2006 14:16:52 -0700 (PDT)
Received: from mail.g-house.de (ns2.g-housing.de [81.169.133.75])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6ELFeDW030821
	for <linux-xfs@oss.sgi.com>; Fri, 14 Jul 2006 14:15:40 -0700
Received: from [82.41.152.154] (helo=vaio.housecafe.de)
	by mail.g-house.de with esmtpsa (TLS-1.0:DHE_RSA_AES_256_CBC_SHA:32)
	(Exim 4.50)
	id 1G1U2J-0001Tl-CA
	for linux-xfs@oss.sgi.com; Fri, 14 Jul 2006 22:13:19 +0200
Date: Fri, 14 Jul 2006 21:13:05 +0100 (BST)
From: christian <evilninja@gmx.net>
Subject: 2.6.18-rc1: XFS internal error
Message-ID: <Pine.NEB.4.64.0607142100580.4054@vaio.testbed.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Hello xfs,

today one of my xfs partitions has been shutdown with the folowing 
errors:

Filesystem "md0": XFS internal error xfs_da_do_buf(1) at line 1992 of file fs/xfs/xfs_da_btree.c.  Caller 0xc02172f0
Filesystem "md0": XFS internal error xfs_trans_cancel at line 1138 of file fs/xfs/xfs_trans.c.  Caller 0xc024b7c7

This fs has been running for quite a while now, it's xfs on top of a
(soft)RAID-1 mounted with "noatime,nodev,nosuid".

I noticed that I was getting strange io errors when ls'ing the 
mountpoint and then I saw the xfs errors in the kernel.log. 
I've unmounted the fs, mounted it again  and can now access the fs again 
(although i suspect that I have more "free space" than yesterday)

I've put together logs, the exact error message, xfs_check run output 
and more here: http://nerdbynature.de/bits/2.6.18-rc1/

The only thing I did was upgrading from 2.6.17.1 to 2.6.18-rc1...

Thank you for your comments,
Christian.
-- 
BOFH excuse #179:

multicasts on broken packets
