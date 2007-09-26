Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 26 Sep 2007 08:00:28 -0700 (PDT)
Received: from nz-out-0506.google.com (nz-out-0506.google.com [64.233.162.224])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l8QF0CHZ031003
	for <linux-xfs@oss.sgi.com>; Wed, 26 Sep 2007 08:00:17 -0700
Received: by nz-out-0506.google.com with SMTP id x3so1312551nzd
        for <linux-xfs@oss.sgi.com>; Wed, 26 Sep 2007 08:00:12 -0700 (PDT)
Message-ID: <cce360c30709260651k17c80518k555f174af3fafb54@mail.gmail.com>
Date: Wed, 26 Sep 2007 19:21:15 +0530
From: "Manoj Kumar Pradhan" <manojkp80@gmail.com>
Subject: XFS DMAPI support for RHEL4
In-Reply-To: <cce360c30709260650o728bc046ic90fc0e0c726bd78@mail.gmail.com>
MIME-Version: 1.0
References: <cce360c30709260650o728bc046ic90fc0e0c726bd78@mail.gmail.com>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Hi,

I am running RHEL with kernel 2.6.9-42ELsmp x86_64. I got the xfs module
from http://sandeen.net/rhel4_xfs/ and did a rpmbuild as instructed there, I
got the xfs.ko and the module-xfs rpm for the running kernel too but modinfo
shows me that the xfs module hence created is not dmapi enabled.

[root@asher RPMS]# modinfo xfs
filename:       /lib/modules/2.6.9-42.ELsmp/kernel/fs/xfs/xfs.ko
license:        GPL
description:    SGI XFS with ACLs, security attributes, realtime, large
block/inode numbers, no debug enabled
author:         Silicon Graphics, Inc.
depends:
vermagic:       2.6.9-42.ELsmp SMP gcc-3.4

When I run a simple app which tries to init dmapi for XFS it fails with
ENOSYS.
Did I miss anything here? How do I enable DMAPI on this XFS module?

Thanks,
Manoj


[[HTML alternate version deleted]]
