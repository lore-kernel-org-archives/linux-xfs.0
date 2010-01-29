Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0TMWLUa159603 for <xfs@oss.sgi.com>; Fri, 29 Jan 2010 16:32:21 -0600
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E9219AC02F
	for <xfs@oss.sgi.com>; Fri, 29 Jan 2010 14:33:24 -0800 (PST)
Subject: [ANNOUNCE] xfsprogs v3.1.1
From: Alex Elder <aelder@sgi.com>
Date: Fri, 29 Jan 2010 16:33:23 -0600
Message-ID: <1264804403.2872.26.camel@doink1>
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

Version 3.1.1 of xfsprogs has been released.

A gzipped-tar archive of the source code is available here:

    ftp://oss.sgi.com/projects/xfs/cmd_tars/xfsprogs-3.1.1.tar.gz

The source code can be accessed via git using this URL:

    git://oss.sgi.com/xfs/cmds/xfsprogs.git

Below is a summary (from the doc/CHANGES file) of changes
since release 3.0.3 (the last release for which an announcement
was posted, regrettably):

xfsprogs-3.1.1 (29 January 2010)
        - Fix various blkid topology support problems in mkfs.xfs.
        - Fix various build warnings.
        - Add automatic build dependency calculations.
        - Cleaner build system output.
        - Add missing aclocal m4 file to the package generation.
        - Arrange for release tags to be digitally signed.

xfsprogs-3.1.0 (13 January 2010)
        - Reduce memory usage in xfs_repair by using better data
          structures.
        - Add additional checks in xfs_repair to detect freespace
	  btree corruption instead of only rebuilding the btrees.
          Useful for the no-modify mode.
        - Fix libhandle to use the right path to issue by-handle
          ioctls for symbolic links and special files.
        - Use lazy superblock counters by default.  At least kernel
          2.6.22 is needed for this feature.
        - Use physical device sector size if available in mkfs.xfs,
          so 4K sector devices are handed more gracefully.
        - Add a German translation, thanks to Chris Leick.
        - Enable the madvise and mincor commands in xfs_io.
        - Fix unsafe temporary file creation in xfs_fsr.
        - Add support for discarding unused space on SSDs or thin
          provisioned arrays in mkfs.xfs.
        - Allow linking against libblkid for topology information.
        - Add symbol versioning for libhandle.
        - Remove the included RPM and binary tarball built
          infrastructure.
        - Various build system improvements.
        - Small fixes to xfs_db and xfs_io.

xfsprogs-3.0.4 (17 September 2009)
        - Fix a memory leak in xfsprogs.
        - Increase hash chain length in xfsprogs when running out of
          memory.
        - Fix dmsetup invocation in libdisk to avoid warnings during
          mkfs on multipath devices.
        - Fix the -V option to various installed tools.
        - Small internal fixes to please the clang semantical
          analysis tool.
        - Debian packaging updates.
        - Rework Makepkgs and Makefiles to improve deb generation.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
