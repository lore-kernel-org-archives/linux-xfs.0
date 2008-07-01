Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 01 Jul 2008 08:14:44 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m61FEerY007384
	for <xfs@oss.sgi.com>; Tue, 1 Jul 2008 08:14:41 -0700
Received: from sovereign.computergmbh.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1498F2A4A08
	for <xfs@oss.sgi.com>; Tue,  1 Jul 2008 08:15:42 -0700 (PDT)
Received: from sovereign.computergmbh.de (sovereign.computergmbh.de [85.214.69.204]) by cuda.sgi.com with ESMTP id DrSSskCD9XhUYagD for <xfs@oss.sgi.com>; Tue, 01 Jul 2008 08:15:42 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by sovereign.computergmbh.de (Postfix) with ESMTP id E19871C0E7213
	for <xfs@oss.sgi.com>; Tue,  1 Jul 2008 17:15:40 +0200 (CEST)
Date: Tue, 1 Jul 2008 17:15:40 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
Subject: grub fails boot after update
Message-ID: <alpine.LNX.1.10.0807011712470.20393@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com



>From Novell Bugzilla, I gather that XFS has a serious problem with grub. 
Since I'd like to keep XFS for the time being, is there any way to fix 
this issue, or make dead sure that a given file is on disk?
Like ioctl(fd, XFS_FLUSH_I_MEAN_IT)?


---------- Forwarded message ----------
https://bugzilla.novell.com/show_bug.cgi?id=223773

--- Comment #39  2008-07-01 08:44:49 MDT ---
I agree with comment #37: XFS really does suck, especially when it comes to
booting Linux on a PC. Fortunately we do not support it any more for new
installations, an ext2 /boot partition is highly recommended.

The problem is that with XFS, sync(2) returns, but the data isn't synced.
The first time yast calls grub install, grub does not find the new stage1.5,
because it is not on the disk yet, despite a successful sync; thus it modifies
stage2 to do the job. On the second invocation, stage1.5 is found and
installed, but stage2 already is modified.

So once again this isn't a grub bug, but an XFS bug with FS semantics.
