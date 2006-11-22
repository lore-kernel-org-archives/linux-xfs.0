Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 22 Nov 2006 12:40:44 -0800 (PST)
Received: from mail.groll.co.za (mail.groll.co.za [67.18.176.185])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAMKeYaG018814
	for <xfs@oss.sgi.com>; Wed, 22 Nov 2006 12:40:36 -0800
Date: Wed, 22 Nov 2006 22:08:11 +0200
From: Jonathan Groll <lists@groll.co.za>
Subject: Unexpected inode type 0160000 causes abort of xfs_repair
Message-ID: <20061122200811.GB2493@groll.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

I'm unsuccesfully trying to repair an XFS filesystem 

xfs_repair /dev/md1 and the same with -L both end with
bad (negative) size -2150115811482766770 on inode 1539849750
cleared inode 1539849750
bad magic number 0x859b on inode 1539849751, resetting magic number
bad version number 0xffffff88 on inode 1539849751, resetting version
number
Unexpected inode type 0160000 inode 1539849751
Aborted

OS: debian sarge (stable)
Kernel: 2.6.15.7
xfsprogs       2.8.11-1

Is there anything I can possibly do?

Many thanks,
Jonathan Groll
