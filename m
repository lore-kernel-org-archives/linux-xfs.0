Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6KE3acb232742 for <xfs@oss.sgi.com>; Wed, 20 Jul 2011 09:03:36 -0500
Received: from mail-iy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B43CFEE3DF8
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2011 07:03:34 -0700 (PDT)
Received: from mail-iy0-f181.google.com (mail-iy0-f181.google.com
	[209.85.210.181]) by cuda.sgi.com with ESMTP id
	bDNy2jp7kLvvQLEt for <xfs@oss.sgi.com>;
	Wed, 20 Jul 2011 07:03:34 -0700 (PDT)
Received: by iyf40 with SMTP id 40so210376iyf.26
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2011 07:03:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOJJ1Zp821vD0JbGf5PuNGcW4VX4E_3SfcWYxVA4es2o0pyJXQ@mail.gmail.com>
References: <CAOJJ1Zp821vD0JbGf5PuNGcW4VX4E_3SfcWYxVA4es2o0pyJXQ@mail.gmail.com>
Date: Wed, 20 Jul 2011 22:03:33 +0800
Message-ID: <CAOJJ1ZpL89-3xrhJTQgO97AebSSgnmfyM+mah75XOWiyi-wHwQ@mail.gmail.com>
Subject: 1 Gb Ethernet based HPC storage deployment plan
From: Lee Eric <openlinuxsource@gmail.com>
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

Hi all,

I got 20 nodes cluster(1 Gb Ethernet connected) and gonna build a
small storage system with it. Because of the low budget I'm thinking
to use 1 Gb Ethernet as physical layer for the storage part. Here's
what I planed.

There 8 SATA hard drivers so I wanna use AoE or iSCSI to export the
block devices to the master node over Ethernet. Then the master node
will use NFS to export block devices to compute nodes. The upper layer
file system I will use XFS.

I know it would be better if I can use Lustre but my interconnection
is a little slow. I suspect if it is feasible if using such parallel
file system.

Does anyone has good idea on this deployment?

Thanks very much.

Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
