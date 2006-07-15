Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 15 Jul 2006 03:08:43 -0700 (PDT)
Received: from mail.g-house.de (ns2.g-housing.de [81.169.133.75])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6FA8RDW014664
	for <linux-xfs@oss.sgi.com>; Sat, 15 Jul 2006 03:08:28 -0700
Received: from [82.41.152.154] (helo=vaio.housecafe.de)
	by mail.g-house.de with esmtpsa (TLS-1.0:DHE_RSA_AES_256_CBC_SHA:32)
	(Exim 4.50)
	id 1G1h4G-0008Sw-KR
	for linux-xfs@oss.sgi.com; Sat, 15 Jul 2006 12:08:12 +0200
Date: Sat, 15 Jul 2006 11:07:54 +0100 (BST)
From: christian <evilninja@gmx.net>
Subject: Re: 2.6.18-rc1: XFS internal error
In-Reply-To: <Pine.NEB.4.64.0607142100580.4054@vaio.testbed.de>
Message-ID: <Pine.NEB.4.64.0607151103400.4054@vaio.testbed.de>
References: <Pine.NEB.4.64.0607142100580.4054@vaio.testbed.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

On Fri, 14 Jul 2006, christian wrote:
> today one of my xfs partitions has been shutdown with the folowing errors:
>
> Filesystem "md0": XFS internal error xfs_da_do_buf(1) at line 1992 of file 
> fs/xfs/xfs_da_btree.c.  Caller 0xc02172f0
> Filesystem "md0": XFS internal error xfs_trans_cancel at line 1138 of file 
> fs/xfs/xfs_trans.c.  Caller 0xc024b7c7

well, it just happened again at approx. the same time when the backups 
are made and rsnapshot/rsync is hammering the fs:

Jul 14 07:09:33 sheep kernel: Filesystem "md0": XFS internal error xfs_da_do_buf(1) at line 1992 of file fs/xfs/xfs_da_btree.c.  Caller 0xc02172f0
Jul 14 07:09:33 sheep kernel: Filesystem "md0": XFS internal error xfs_trans_cancel at line 1138 of file fs/xfs/xfs_trans.c.  Caller 0xc024b7c7
Jul 15 07:06:14 sheep kernel: Filesystem "md0": XFS internal error xfs_da_do_buf(1) at line 1992 of file fs/xfs/xfs_da_btree.c.  Caller 0xc02172f0
Jul 15 07:06:14 sheep kernel: Filesystem "md0": XFS internal error xfs_trans_cancel at line 1138 of file fs/xfs/xfs_trans.c.  Caller 0xc024b7c7

I'll downgrade to 2.6.17.4 now, please tell me it'll go away with 
2.6.18-final ;)

thanks,
Christian.
-- 
BOFH excuse #418:

Sysadmins busy fighting SPAM.
