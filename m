Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 89E427F55
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2015 11:22:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E785DAC022
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2015 09:22:55 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id VJdfbNAy79AuNIO6 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 02 Oct 2015 09:22:54 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id 1FB472FE84F
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2015 16:22:54 +0000 (UTC)
Received: from localhost.localdomain.com (vpn-48-121.rdu2.redhat.com
	[10.10.48.121])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t92GMqq7005602
	for <xfs@oss.sgi.com>; Fri, 2 Oct 2015 12:22:53 -0400
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: [PATCH 0/7 v10] xfs: per-fs stats in sysfs
Date: Fri,  2 Oct 2015 11:22:33 -0500
Message-Id: <1443802960-26662-1-git-send-email-billodo@redhat.com>
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

Following is the next iteration of the series to add per-fs xfs stats to
sysfs.

----------history---------------
v10:
-style fixups in patches 1,4,5,7

v9:
-adjust individual patch content, so that fixes actually correspond
to reviews accordingly.

-fix xfs_btree.h XFS_BTREE_STATS_ADD macro error made in patch 7.
-fix xfs_stats.h macro style errors made in patch 7


v8: (add patches 6 and 7)
-patch 6: per-filesystem stats in sysfs.
Implement per-filesystem stats objects in sysfs. Stats objects are
instantiated when an xfs filesystem is mounted and deleted on unmount.
With this patch, the stats directory is created and populated with
the familiar stats and stats_clear files.
    Example:
            /sys/fs/xfs/sda9/stats/stats
            /sys/fs/xfs/sda9/stats/stats_clear

With this patch, the individual counts within the new per-fs
stats file(s) remain at zero. Functions that use the the macros
to increment, decrement, and add-to the per-fs stats counts will
be covered in the next patch (7).

-patch 7: per-filesystem stats counter implementation
Modify the stats counting macros and the callers
to those macros to properly increment, decrement, and add-to
the xfs stats counts. The counts for global and per-fs stats
are correctly advanced, and cleared by writing a "1" to the
corresponding clear file.

global counts: /sys/fs/xfs/stats/stats
per-fs counts: /sys/fs/xfs/sda*/stats/stats

global clear:  /sys/fs/xfs/stats/stats_clear
per-fs clear:  /sys/fs/xfs/sda*/stats/stats_clear

v7:
add patch 5/5: incorporate sysfs/kobject in xfsstats: handlers
take kobjects. Allocate & deallocate per-fs stats structures
and set up the sysfs entries for them. Add kobject and a pointer
to a per-cpu struct xfsstats. Modify the macros that manipulate
the stats accordingly.

v6:
-move to_xlog(kobject) to the relevant show/store operations.
This keeps the xfs_sysfs_object_show/store functions generic.
Also, with the change, there can be some cleanup of the
show/store function arguments.

v5:
-optimization of sysfs_ops function.
-style fixups

v4:
-add patch 4 (sysfs ops consolidation - dbg, stats, log)

v3:
-style fixups.

v2:
-style fixups.
v1:
--------------------------------

We already have per-fs information in /sys, so it makes sense to
have per-fs stats there too.  The series moves existing
global stats infrastructure to /sys and reuses that code to
create per-fs stats in /sys.

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

Patch 6 implements per-filesystem stats objects in sysfs. Stats
objects are instantiated when an xfs filesystem is mounted and
deleted on unmount.

Patch 7 modifies the stats counting macros and the callers
to those macros to properly increment, decrement, and add-to
the xfs stats counts. The counts for global and per-fs stats
are correctly advanced, and cleared by writing a "1" to the
corresponding clear file.

Once again, comments and questions are welcome.

Thanks-
Bill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
