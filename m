Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 29 Jul 2006 20:53:22 -0700 (PDT)
Received: from amanpulo.hosting.qsr.com.ph (amanpulo.hosting.qsr.com.ph [64.34.170.22])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6U3r2DW031184
	for <xfs@oss.sgi.com>; Sat, 29 Jul 2006 20:53:03 -0700
Received: from localhost (localhost [127.0.0.1])
	by amanpulo.hosting.qsr.com.ph (Postfix) with ESMTP id 2BF4DC0DF780
	for <xfs@oss.sgi.com>; Sun, 30 Jul 2006 11:52:38 +0800 (PHT)
Received: from musang.free.net.ph (unknown [203.177.91.252])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by amanpulo.hosting.qsr.com.ph (Postfix) with ESMTP id 4096FC05F0D3
	for <xfs@oss.sgi.com>; Sun, 30 Jul 2006 11:51:50 +0800 (PHT)
Date: Sun, 30 Jul 2006 11:38:02 +0800
From: Federico Sevilla III <jijo@free.net.ph>
Subject: Filesystem Shutdown due to Error 22
Message-ID: <20060730033802.GA3647@free.net.ph>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: XFS Mailing List <xfs@oss.sgi.com>

Hi,

I am running Linux 2.6.17.7 on a Debian GNU/Linux Sarge machine
(xfsprogs 2.6.20 and xfsdump 2.2.27). I was hit recently by the dir2
corruption problem, but already fixed this using the procedure in the
FAQ after upgrading the kernel.

I have a weekly scheduled task that runs xfs_fsr and this morning found
that my server's filesystem (the same one previously hit by the dir2
issue) had been shut down. I don't have console access to this server
but managed to get the following off the logs which are on a separate
filesystem:

    kernel: xfs_inotobp: xfs_imap()  returned an error 22 on md1.  Returning error.
    kernel: xfs_iunlink_remove: xfs_inotobp()  returned an error 22 on md1.  Returning error.
    kernel: xfs_inactive:^Ixfs_ifree() returned an error = 22 on md1
    kernel: xfs_force_shutdown(md1,0x1) called from line 1763 of file fs/xfs/xfs_vnodeops.c.  Return address = 0xc01fa80c

I ran xfs_repair, and found 20 disconnected inodes of which 16 are
filled with nulls. No other problems were found with the filesystem.

I have an identical server (hardware, kernel and core utilities, albeit
different applications) which went through the same upgrade path and
dir2 corruption, but went through today's xfs_fsr without any problems.

Any clues as to what's causing this?

Cheers!

 --> Jijo

-- 
Federico Vicente C. Sevilla III
Information Technology Consultant
Q Software Research Corporation
Website: http://jijo.free.net.ph
