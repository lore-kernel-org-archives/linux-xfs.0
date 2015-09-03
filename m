Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4774929DF5
	for <xfs@oss.sgi.com>; Thu,  3 Sep 2015 11:38:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 265908F8059
	for <xfs@oss.sgi.com>; Thu,  3 Sep 2015 09:38:40 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 2CTUlIeHFwCgIzix (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 03 Sep 2015 09:38:39 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id C7E38C0AAB02
	for <xfs@oss.sgi.com>; Thu,  3 Sep 2015 16:38:38 +0000 (UTC)
Received: from localhost.localdomain.com (unused [10.10.50.102] (may be
	forged))
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t83GccRf013867
	for <xfs@oss.sgi.com>; Thu, 3 Sep 2015 12:38:38 -0400
From: billodo <billodo@redhat.com>
Subject: [PATCH 0/3] xfs: new global stats in sysfs
Date: Thu,  3 Sep 2015 11:36:24 -0500
Message-Id: <1441298187-29064-1-git-send-email-billodo@redhat.com>
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
Here is a first pass at a series to add new global stats to sysfs.
As a part of that, the /proc/fs/xfs/stat file becomes a symlink to
the sysfs stats entry. The patch provides the beginnings of the
infrastructure for per-fs stats (in addition to global accumulative
stats).

Patch 1 handles the bring-up and tear down of xfs/stats directory
structure in sysfs when an fs is mounted. The directory contains
the stats file and the stats_clear file. The stats file contents mimic
those of /proc/fs/xfs/stat. The stats_clear file is empty, and much
like the current stat_clear command, handles the zeroing of the stats
file when a "1" is echoed to the stats_clear file.

Patch 2 creates the symlink for stats from procfs to sysfs.

Patch 3 removes the now unused portions of procfs for stat.

Comments and questions are welcome.

Thanks-
Bill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
