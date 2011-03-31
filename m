Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2V4QA6P110603 for <xfs@oss.sgi.com>; Wed, 30 Mar 2011 23:26:10 -0500
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E2FC5AC005
	for <xfs@oss.sgi.com>; Wed, 30 Mar 2011 21:29:18 -0700 (PDT)
Subject: [ANNOUNCE] xfsprogs v3.1.5
From: Alex Elder <aelder@sgi.com>
Date: Wed, 30 Mar 2011 23:29:17 -0500
Message-ID: <1301545757.2824.11.camel@doink>
Mime-Version: 1.0
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

Version 3.1.5 of xfsprogs has been released.

A gzipped tar archive of the source code is available here:

    ftp://oss.sgi.com/projects/xfs/cmd_tars/xfsprogs-3.1.5.tar.gz

The source code can be accessed via git using this URL:

    git://oss.sgi.com/xfs/cmds/xfsprogs.git

Below is a summary (from the doc/CHANGES file) of changes
since release 3.1.4:

xfsprogs-3.1.5 (30 March 2011)
	- Polish translation update, thanks to Jakub Bogusz
	- xfs_repair now warns if running in low memory mode
	- Phase 2 of xfs_repair is now multithreaded
	- xfs_quota no longer attempts to get quota information if
	  not enabled
	- Inode flags are now properly validated by xfs_repair
	- Metadump now obfuscates all file names reliably
	- xfs_io now supports the "fiemap" command, a more generic
	  form of the "bmap" command
	- xfs_io now supports the "fpunch" command, as well as a
	  "-p" flag to the "fallocate command.  Both implement hole
	  punching.  Thanks to Josef Bacik
	- A number of other bug fixes thanks to Ajeet Yadav




_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
