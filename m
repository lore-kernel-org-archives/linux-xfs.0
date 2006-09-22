Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Sep 2006 22:41:01 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8M5eqaG004077
	for <linux-xfs@oss.sgi.com>; Thu, 21 Sep 2006 22:40:54 -0700
Received: from cfa.harvard.edu (cfa.harvard.edu [131.142.10.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EAAD0D10E762
	for <linux-xfs@oss.sgi.com>; Thu, 21 Sep 2006 21:32:10 -0700 (PDT)
Received: from titan (titan [131.142.24.40])
	by cfa.harvard.edu (8.13.7/8.13.7/cfunix Mast-Sol 1.0) with ESMTP id k8M4W9ci006928
	for <linux-xfs@oss.sgi.com>; Fri, 22 Sep 2006 00:32:09 -0400 (EDT)
Date: Fri, 22 Sep 2006 00:32:09 -0400 (EDT)
From: Gaspar Bakos <gbakos@cfa.harvard.edu>
Reply-To: gbakos@cfa.harvard.edu
Subject: mkfs.xfs on hw RAID6
In-Reply-To: <Pine.SOL.4.58.0402092229300.4489@antu.cfa.harvard.edu>
Message-ID: <Pine.SOL.4.58.0609212333020.28643@titan.cfa.harvard.edu>
References: <Pine.SOL.4.58.0402092229300.4489@antu.cfa.harvard.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Hi,

I am trying to create an XFS filesystem on a hardware RAID-6 partition
that consists of 12 x 500Gb disks, i.e. the total disk space is 5Tb. All
this is one big partition, created by parted. Typical filesize will
range from 100Kb to 30Mb, but very small files are not typical.

I wonder about the usual magic; with a raid setup the su,sw and log su,size
parameters can be optimized.

The RAID stripe size is 64K in my case.

In other words:

mkfs.xfs -b size=$BS -d su=$SU,sw=$SW -i size=$ISIZE -l su=$LSU,size=$LS -L BIG /dev/sdc1
BS=?
SU=?
SW=?
ISIZE=?
LSU=?
LS=?

I would say:

mkfs.xfs -b size=4k -d su=64k,sw=10 -f -i size=512 -l su=64k,size=32m -L BIG /dev/sdc1

I read somewhere some time ago that
recommended sw = (num_of_disks - 1) with RAID-5 .
The current sw = 10 is intuitive for RAID-6.

I can also imagine that with hardware RAID all this is not that important.

Thanks in advance for suggestions!

Cheers,
Gaspar
