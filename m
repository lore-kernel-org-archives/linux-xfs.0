Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BA9587F37
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2015 07:08:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 90F8C8F8037
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2015 05:08:05 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Nz8C1lSXtaf1AsWG (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 22 Sep 2015 05:08:03 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id 8531CA2A1A
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2015 12:08:02 +0000 (UTC)
Received: from localhost.localdomain.com (vpn-53-129.rdu2.redhat.com
	[10.10.53.129])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t8MC81nf022782
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2015 08:08:02 -0400
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: [PATCH 0/5 v7] xfs: stats in sysfs
Date: Tue, 22 Sep 2015 07:07:46 -0500
Message-Id: <1442923671-14125-1-git-send-email-billodo@redhat.com>
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

Hello-

Following is the next iteration of the series to add xfs stats to
sysfs. This iteration adds patch 5/5 to incorporate sysfs/kobject
into xfsstats.

----------history---------------
v7:
-add patch 5/5: incorporate sysfs/kobject in xfsstats: handlers
take kobjects. Allocate & deallocate per-fs stats structures
and set up the sysfs entries for them. Add kobject and a pointer
to a per-cpu struct xfsstats. Modify the macros that manipulate
the stats accordingly.

v6:
-add patch 4/4: move to_xlog(kobject) to the relevant show/store
operations. This keeps the xfs_sysfs_object_show/store functions
generic. Also, with the change, there can be some cleanup of the
show/store function arguments.

v5:
-optimization of sysfs_ops function.
-style fixups

v4:
-whitespace fixup of patch 1
-add patch 4 (sysfs ops consolidation - dbg, stats, log)

v3:
-style fixups and removal of extraneous printk.

v2:
-style fixups.

v1:
--------------------------------

The series provides infrastructure for per-fs stats (in addition
to global accumulative stats).

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

Patch 5 allocates and deallocates per-fs stats structures and
sets up the sysfs entries for them. Add kobject and a pointer
to a per-cpu struct xfsstats. Modify the macros that manipulate
the stats accordingly.

Again, comments and questions are welcome.

Thanks-
Bill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
