Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7F4767F4E
	for <xfs@oss.sgi.com>; Mon, 25 Nov 2013 13:35:58 -0600 (CST)
Received: from xmail.sgi.com (pv-excas2-dc21.corp.sgi.com [137.38.106.9])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F05A2AC001
	for <xfs@oss.sgi.com>; Mon, 25 Nov 2013 11:35:54 -0800 (PST)
Message-ID: <5293A699.20908@sgi.com>
Date: Mon, 25 Nov 2013 13:35:53 -0600
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: [ANNOUNCE] xfsprogs v3.2.0-alpha2
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

Alpha version 3.2.0-alpha2 of xfsprogs has been released.

The source code can be accessed via git using this URL:

      git://oss.sgi.com/xfs/cmds/xfsprogs.git

A gzipped-tar archive of the source code is available here:

      ftp://oss.sgi.com/projects/xfs/cmd_tars/xfsprogs-3.2.0-alpha2.tar.gz

The development tree previously hosted on kernel.org for this code has 
been deprecated:

      git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

Below is a summary (from the doc/CHANGES file) of the changes:

xfsprogs-3.2.0-alpha2 (25 November 2013)
         - Alpha release for the purpose of testing the CRC feature in
           kernels 3.10 and newer.
         - Enable xfs_db write support and xfs_metadump support for CRC
           enabled filesystems.
         - Add directory entry filetype support for non-CRC filesystems.
         - Remove experimental warnings for CRC filesystems.
         - Ensure all inodes created by xfs_repair have a proper d_type set.
         - Fix build on big endian machines.
         - Properly handle symlinks to devices on various tool commandlines.
         - Fix xfs_repair's dirty log detection for 4k sector logs, broken
           in Alpha1.
         - Fix a potential segfault in xfs_repair when issuing progress
           reports.
         - Fix potential xfs_fsr failures when running w/ selinux.
         - Update config.guess/config.sub for arm64, thanks to Colin Watson.
         - Stop wasting memory by caching inode structures in xfs_repair -
           they are never re-used.  Thanks to Christoph Hellwig.
         - Fix several Coverity-found defects, thanks to Li Zhong.
         - Fix platform_test_xfs_fd to return false on special files which
           cannot take an xfs ioctl.
         - Sync up libxfs with kernel code.
         - Improved xfs_repair performance on large filesystems
           (always use prefetch and strided AG scanning functionality)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
