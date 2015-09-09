Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8BCF07F37
	for <xfs@oss.sgi.com>; Wed,  9 Sep 2015 12:07:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 68202304059
	for <xfs@oss.sgi.com>; Wed,  9 Sep 2015 10:07:24 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id kgEKSXPniwzeDyqC (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 09 Sep 2015 10:07:23 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id F0530A2C12
	for <xfs@oss.sgi.com>; Wed,  9 Sep 2015 17:07:22 +0000 (UTC)
Received: from localhost.localdomain.com (unused [10.10.52.30] (may be forged))
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t89H7Mv8003396
	for <xfs@oss.sgi.com>; Wed, 9 Sep 2015 13:07:22 -0400
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: [PATCH 0/4 v6] xfs: new global stats in sysfs
Date: Wed,  9 Sep 2015 12:06:31 -0500
Message-Id: <1441818395-11612-1-git-send-email-billodo@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


Hi all-

Here is the sixth iteration of the series to add new global stats to sysfs.
----------history---------------
v6:
-patch 4/4: move to_xlog(kobject) to the relevant show/store operations.
This keeps the xfs_sysfs_object_show/store functions generic. Also,
with the change, there can be some cleanup of the show/store function
arguments.

V5:
-optimization of sysfs_ops function.
-style fixups
V4:
-whitespace fixup of patch 1
-add patch 4 (sysfs ops consolidation - dbg, stats, log)
V3:
-style fixups and removal of extraneous printk.
V2:
-style fixups.
V1:
--------------------------------

The series provides the beginnings of the infrastructure for per-fs
stats (in addition to global accumulative stats).

We already have per-fs information in /sys, so it makes sense to
have per-fs stats there too.  As a first step, moving existing
global stats infrastructure to /sys will allow us to re-use that
sysfs code for per-fs stats as well.

Patch 1 handles the bring-up and tear down of xfs/stats directory
structure in sysfs when an fs is mounted. The directory contains
the stats file and the stats_clear file. The stats file contents mimic
those of /proc/fs/xfs/stat. The stats_clear file is empty, and much
like the current stat_clear command, handles the zeroing of the stats
file when a "1" is echoed to the stats_clear file.

Patch 2 creates the symlink for stats from procfs to sysfs.

Patch 3 removes the now unused portions of procfs for stat.

Patch 4 consolidates the sysfs ops for dbg, stats, log.

Comments/questions welcome.

Thanks-
Bill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
