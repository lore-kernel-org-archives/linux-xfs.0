Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 04 Sep 2008 20:57:36 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m853vPfV022501
	for <xfs@oss.sgi.com>; Thu, 4 Sep 2008 20:57:27 -0700
Received: from pc-bnaujok.melbourne.sgi.com (pc-bnaujok.melbourne.sgi.com [134.14.55.58]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id NAA24429 for <xfs@oss.sgi.com>; Fri, 5 Sep 2008 13:58:52 +1000
Date: Fri, 05 Sep 2008 14:00:31 +1000
Subject: xfsprogs 2.10.1 source tarball released
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-ID: <op.ugzpe5m53jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

ftp://oss.sgi.com/projects/xfs/cmd_tars/xfsprogs_2.10.1-1.tar.gz

Changelog since 2.9.8:

xfsprogs-2.10.1 (5 September 2008)
	- Improve xfs_repair -P option to disable xfs_buf_t locking.
	- Fix inode cluster I/O size for > 8KB block size filesystems.
	- Fix up ASCII CI output for mkfs.xfs and xfs_growfs.
	- Fix buffer handling in error cases in xfs_db (includes xfs_check
	  and xfs_metadump).
	- Add packed on-disk shortform directory for ARM's old ABI, thanks to
	  Eric Sandeen.
	- Increase default valid block count for a directory extent in
	  xfs_metadump (from 20 to 1000).
	- Fix up mkfs.xfs -N option with "-d file" so it doesn't resize the
	  target file (thanks to Michal Marek).
	- Improve libxfs cache handling with (un)referenced blocks.
	- Check that directory size is not too big in xfs_repair.
	- Improve xfs_repair to restore bad or missing ".." entries.

xfsprogs-2.10.0 (26 May 2008)
	- Add ASCII case-insensitive support to xfsprogs.
