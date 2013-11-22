Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7D5007F37
	for <xfs@oss.sgi.com>; Thu, 21 Nov 2013 18:32:28 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 65BD38F8040
	for <xfs@oss.sgi.com>; Thu, 21 Nov 2013 16:32:25 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id jLXflrVh3To9vkcT for <xfs@oss.sgi.com>;
	Thu, 21 Nov 2013 16:32:24 -0800 (PST)
Received: from Liberator.local (c-98-240-215-156.hsd1.mn.comcast.net
	[98.240.215.156])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id E91FA63C5FC1
	for <xfs@oss.sgi.com>; Thu, 21 Nov 2013 18:32:23 -0600 (CST)
Message-ID: <528EA617.4080004@sandeen.net>
Date: Thu, 21 Nov 2013 18:32:23 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Alpha2 changelog
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

Here's my stab at a changelog.  If you did something since 3.11, and it sho=
uld be highlighted but it's not, now's your chance!

xfsprogs-3.2.0-alpha2 (19 November 2013)
        - Alpha release for the purpose of testing the CRC feature in kerne=
ls
          3.10 and newer
        - Enable xfs_db write support and xfs_metadump support for CRC enab=
led
          filesystems.
        - Add directory entry filetype support for non-CRC filesystems.
        - Remove experimental warnings for CRC filesystems.
        - Ensure all inodes created by xfs_repair have a proper d_type set.
        - Fix build on big endian machines.
        - Properly handle symlinks to devices on various tool commandlines.
        - Fix xfs_repair's dirty log detection for 4k sector logs, broken
          in Alpha1.
        - Fix a potential segfault in xfs_repair when issuing progress repo=
rts.
        - Fix potential xfs_fsr failures when running w/ selinux.
        - Update config.guess/config.sub for arm64, thanks to Colin Watson.
        - Add FALLOC_FL_COLLAPSE_RANGE support to the xfs_io fallocate comm=
and,
          thanks to Namjae Jeon.
        - Stop wasting memory by caching inode structures in xfs_repair -
          they are never re-used.  Thanks to Christoph Hellwig.
        - Fix several Coverity-found defects, thanks to Li Zhong.
        - Fix platform_test_xfs_fd to return false on special files which
          cannot take an xfs ioctl.
        - Sync up libxfs with kernel code.


xfsprogs-3.2.0-alpha1 (26 September 2013)
        - Alpha release for the purpose of testing the CRC feature in kerne=
ls
          3.10 and newer
        - Remove all vestiges of old, unsupported version 1 directory code.
        - Add a =93readdir=94 command to xfs_io, thanks to Brian Foster.
        - Fix potential segfault in xfs_repair when creating lost+found.
        - Zero out unused parts of on-disk superblocks during repair, to av=
oid
          metadata verifier failures at runtime.
        - Add directory entry type support to mkfs.xfs and xfs_db.
        - Add the icreate transaction to xfs_logprint, and fix continuation
          transactions.
        - Print all AGI unlinked buckets in xfs_logprint.
        - Fix mkfs.xfs ENOSPC with protofile which creates a very large
          directory.
        - Fix several Coverity-found defects, thanks to Li Zhong.
        - Do all file reads in xfs_fsr using O_DIRECT.
        - Sync up libxfs with kernel code.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
