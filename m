Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7C6567F50
	for <xfs@oss.sgi.com>; Tue,  8 Sep 2015 12:50:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 12C6CAC005
	for <xfs@oss.sgi.com>; Tue,  8 Sep 2015 10:50:18 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id T8lcBjU7psPZdXiI (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 08 Sep 2015 10:50:18 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id A4D2D8EA21
	for <xfs@oss.sgi.com>; Tue,  8 Sep 2015 17:50:17 +0000 (UTC)
Received: from localhost.localdomain.com (vpn-57-55.rdu2.redhat.com
	[10.10.57.55])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t88HoHBX022169
	for <xfs@oss.sgi.com>; Tue, 8 Sep 2015 13:50:17 -0400
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: [PATCH 0/4 V5] xfs: new global stats in sysfs
Date: Tue,  8 Sep 2015 12:49:50 -0500
Message-Id: <1441734594-4175-1-git-send-email-billodo@redhat.com>
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

Here is another pass at the series to add new global stats to sysfs.
----------history---------------
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

Once again, comments and questions are welcome.

Thanks-
Bill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
