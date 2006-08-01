Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 01 Aug 2006 05:57:23 -0700 (PDT)
Received: from out2.smtp.messagingengine.com (out2.smtp.messagingengine.com [66.111.4.26])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k71CvADW027534
	for <xfs@oss.sgi.com>; Tue, 1 Aug 2006 05:57:12 -0700
Received: from frontend3.internal (frontend3.internal [10.202.2.152])
	by frontend1.messagingengine.com (Postfix) with ESMTP id 0E1A4D92FEA
	for <xfs@oss.sgi.com>; Tue,  1 Aug 2006 07:55:17 -0400 (EDT)
Message-Id: <1154433320.2160.267361956@webmail.messagingengine.com>
From: "CN" <cnliou9@fastmail.fm>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="GB2312"
MIME-Version: 1.0
Subject: xfs_check refuses to work on readonly fs
Date: Tue, 01 Aug 2006 19:55:20 +0800
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi!

# init 1
# mount -o ro,remount /
# mount
/dev/hda1 on / type xfs (rw)
# xfs_check /dev/hda1
xfs_check: /dev/hda1 contains a mounted and writable filesystem

xfs_check/xfs_repair are willing to work only when I boot from a disk
and check/repair the other unmounted disk.

Why "mount" shows (rw) instead of (ro) even "mount -o ro,remount /" is
issued?

fsck.ext3 works fine given the same sequence of commands for ext3
mounted file system. Did I miss anything with XFS?

Thank you in advance!

CN

-- 
http://www.fastmail.fm - mmm... Fastmail...
