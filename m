Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2MHwnuP007514 for <xfs@oss.sgi.com>; Thu, 22 Mar 2012 12:58:49 -0500
Received: from whiskey.americas.sgi.com (whiskey.americas.sgi.com
	[128.162.233.19])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 85FFE304059
	for <xfs@oss.sgi.com>; Thu, 22 Mar 2012 10:58:46 -0700 (PDT)
Date: Thu, 22 Mar 2012 12:58:55 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [ANNOUNCE] xfsdump 3.1.0
Message-ID: <20120322175855.GM8451@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
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

Version 3.1.0 of xfsdump has been released.

A gzipped tar archive of the source code is available here:

	ftp://oss.sgi.com/projects/xfs/cmd_tars/xfsdump-3.1.0.tar.gz

The source code can be accessed via git using this URL:

	git://oss.sgi.com/xfs/cmds/xfsdump.git

Below is a summary (from the doc/CHANGES file) of changes since release
3.0.6:

xfsdump-3.1.0 (22 March 2012)
	- Fix metadata restore on split files.
	- Add a -D option to skip a recursive scan of the filesystem
	  when dumping.
	- Fix a 1 byte overflow with empty lists, thanks to Mike Frysinger.
	- Enable multi-stream support on Linux using pthreads.
	- Fix handling of Ctrl-D in prompts.
	- Obsolete SGI_XFSDUMP_SKIP_FILE extended attribute for excluding
	  files from dump.
	- Fix restoration of extended attributes on the root directory.
	- Use the full 32-bit inode generation number instead of 12-bit
	  generation number.  Bump the dump format version to 3.
	- Do not create parent directories for orphaned files during
	  list-only (-t option) restore.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
