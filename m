Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 27 Aug 2006 02:00:13 -0700 (PDT)
Received: from zenon.apartia.fr (zenon.apartia.fr [82.66.93.83])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7R901DW012155
	for <xfs@oss.sgi.com>; Sun, 27 Aug 2006 02:00:03 -0700
Received: from styx.apartia.fr (styx.apartia.fr [10.0.3.109])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "styx.apartia.fr", Issuer "ca.apartia.fr" (verified OK))
	by zenon.apartia.fr (Postfix) with ESMTP id 408CBF5176A06
	for <xfs@oss.sgi.com>; Sun, 27 Aug 2006 09:28:11 +0200 (CEST)
Date: Sun, 27 Aug 2006 09:28:10 +0200
From: Louis-David Mitterrand <vindex+lists-xfs@apartia.org>
Subject: libxfs_initbuf can't memalign 4096 bytes: Cannot allocate memory
Message-ID: <20060827072810.GA4098@apartia.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Package: xfsprogs
Version: 2.8.11-1
Followup-For: Bug #382935

Hello,

Using xfs_repair on a 2TB partition I get:

	Phase 1 - find and verify superblock...
	Phase 2 - using internal log
			- zero log...
			- scan filesystem freespace and inode maps...
			- found root inode chunk
	Phase 3 - for each AG...
			- scan and clear agi unlinked lists...
			- process known inodes and perform inode discovery...
			- agno = 0
			- agno = 1
			- agno = 2
			- agno = 3
			- agno = 4
			- agno = 5
			- agno = 6
			- agno = 7
			- agno = 8
			- agno = 9
			- agno = 10
	xfs_repair: libxfs_initbuf can't memalign 4096 bytes: Cannot allocate memory



-- System Information:
Debian Release: testing/unstable
  APT prefers unstable
  APT policy: (500, 'unstable'), (500, 'testing'), (499, 'experimental')
Architecture: i386 (i686)
Shell:  /bin/sh linked to /bin/bash
Kernel: Linux 2.6.17-6-debian-styx
Locale: LANG=en_CA, LC_CTYPE=fr_FR@euro (charmap=ISO-8859-15)

Versions of packages xfsprogs depends on:
ii  libc6                        2.3.6.ds1-4 GNU C Library: Shared libraries
ii  libreadline5                 5.1-7       GNU readline and history libraries
ii  libuuid1                     1.39-1      universally unique id library

xfsprogs recommends no packages.

-- no debconf information
