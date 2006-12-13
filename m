Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 12 Dec 2006 22:47:54 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kBD6ljqw024435
	for <xfs@oss.sgi.com>; Tue, 12 Dec 2006 22:47:47 -0800
Received: from pcbnaujok (pc-bnaujok.melbourne.sgi.com [134.14.55.58]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id RAA25351 for <xfs@oss.sgi.com>; Wed, 13 Dec 2006 17:46:54 +1100
Message-Id: <200612130646.RAA25351@larry.melbourne.sgi.com>
From: "Barry Naujok" <bnaujok@melbourne.sgi.com>
Subject: xfsprogs 2.8.18 source tarball available on ftp
Date: Wed, 13 Dec 2006 17:52:38 +1100
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


ftp://oss.sgi.com/projects/xfs/cmd_tars/xfsprogs_2.8.18-1.tar.gz

CHANGES since 2.8.16:

- Fix "pointer targets in assignment differ in signedness" warnings
- Update Debian packaging.
- Fix up two issues with xfs_db and bmap. If the data/attr fork is
  local, it either infinite loops or crashes. If both are displayed,
  the attrs are wrong.
- Fix up xfs_io mmap read that read from the wrong offset.
- Updated xfs_io man page.
- Fix up libxfs SEGV when attempting to mount a non-XFS filesystem.
  Thanks to Utako Kusaka <utako@tnes.nec.co.jp> for the above four
  fixes.
- Fix up xfs_repair aborting if it finds an inode with an invalid 
  inode type.
- Fix up mkfs.xfs default realtime extent size for large block sizes.
