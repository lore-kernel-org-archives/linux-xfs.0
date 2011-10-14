Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9EETX6u004805 for <xfs@oss.sgi.com>; Fri, 14 Oct 2011 09:29:33 -0500
Received: from xmail.sgi.com (pv-excas1-dc21.corp.sgi.com [137.38.102.116])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 26253AC006
	for <xfs@oss.sgi.com>; Fri, 14 Oct 2011 07:29:30 -0700 (PDT)
Subject: [ANNOUNCE] xfsprogs v3.1.6
From: Alex Elder <aelder@sgi.com>
Date: Fri, 14 Oct 2011 09:29:28 -0500
Message-ID: <1318602568.3827.16.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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

Version 3.1.6 of xfsprogs has been released.

The source code can be accessed via git using this URL:

    git://oss.sgi.com/xfs/cmds/xfsprogs.git

A gzipped-tar archive of the source code is available here:

    ftp://oss.sgi.com/projects/xfs/cmd_tars/xfsprogs-3.1.6.tar.gz

The development tree for this code (not available at
the moment) is normally published here as well:

    git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

Below is a summary (from the doc/CHANGES file) of changes
since release 3.1.5:

xfsprogs-3.1.6 (14 October 2011)
	- Re-synch of the header and libxfs files with the kernel
	  code as of Linux 2.6.37, including reviving xfs_repair
	  radix tree code.
	- Fix a xfs_repair phase 4 hang, thanks to Ajeet Yadav.
	- Subcommand names within various programs are no longer
	  translated/localized, thanks to Arkadiusz Mi?kiewicz.
	- Build system fixes, thanks to Ted Ts'o.
	- Updates to teh xfs_info(8)/xfs_growfs(8) man page, thanks
	  to Roman Ovchinnikov.
	- xfs_quota "df" no longer reports values twice what they
	  should have been for project quotas.
	- mkfs.xfs now requires that sub-options are non-empty
	  strings; thanks to Chris Pearson for reporting.
	- Better handling of short reads in libxfs.
	- xfs_quota now prints "N/A" rather than a large number for
	  the quota file inode number for disabled quota types.
	- Bogus (unrelated) mount point entries no longer cause
	  xfs_growfs, xfs_quota, and xfs_io to quit early.
	- xfs_repair no longer fails when the sector size of an
	  underlying device is larger than the sector size in a
	  hosted filesystem image.
	- Various other internal improvements, including refactoring
	  and eliminating more build warnings.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
