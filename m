Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 20 Feb 2007 11:13:24 -0800 (PST)
Received: from talk.nabble.com (www.nabble.com [72.21.53.35])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l1KJDKm7005749
	for <linux-xfs@oss.sgi.com>; Tue, 20 Feb 2007 11:13:21 -0800
Received: from [72.21.53.38] (helo=jubjub.nabble.com)
	by talk.nabble.com with esmtp (Exim 4.50)
	id 1HJa9v-0002ZF-Tn
	for linux-xfs@oss.sgi.com; Tue, 20 Feb 2007 10:56:15 -0800
Message-ID: <9068053.post@talk.nabble.com>
Date: Tue, 20 Feb 2007 10:56:15 -0800 (PST)
From: pgf111000 <junkmail@petergfrazier.com>
Subject: mkfs.xfs, lvm, multi-terrabyte hardware array and luks
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com


When I try to format partitions above 2-3gb my opteron experiences heavy io
wait; the mkfs.xfs fails, and I receive the following....

 "mkfs.xfs: libxfs_device_zero write failed: Input/output error"

When I format partions below 2-3gb, there is no problem whatsoever.  I can
mkfs.xfs on a +2-3GB non-luks formated partition without a problem... any
thoughts?


-- 
View this message in context: http://www.nabble.com/mkfs.xfs%2C-lvm%2C-multi-terrabyte-hardware-array-and-luks-tf3262532.html#a9068053
Sent from the linux-xfs mailing list archive at Nabble.com.
