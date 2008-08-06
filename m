Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Aug 2008 19:01:09 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m76214T1003680
	for <xfs@oss.sgi.com>; Tue, 5 Aug 2008 19:01:06 -0700
Received: from dolby.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 153163621D1
	for <xfs@oss.sgi.com>; Tue,  5 Aug 2008 19:02:18 -0700 (PDT)
Received: from dolby.com (silver.dolby.com [12.144.165.24]) by cuda.sgi.com with ESMTP id 2z6Hie4Q64teM2PO for <xfs@oss.sgi.com>; Tue, 05 Aug 2008 19:02:18 -0700 (PDT)
MIME-Version: 1.0
Subject: xfs_force_shutdown - file fs/xfs/xfs_rw.c
Date: Tue, 5 Aug 2008 19:02:05 -0700
Message-ID: <05BB196AB3DA6C4BBE11AB6C957581FE0E61DA47@sfo-exch-01.dolby.net>
From: "Martinez, Sergio" <sergio.martinez@dolby.com>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


I'm running into a force shutdown issue on a system running
linux-2.6.25.  The xfs partition is 2 GB and we're using a hardware
RAID-5 for storage.

dmesg shows this error:

xfs_force_shutdown(sda2,0x1) called from line 420 of file
fs/xfs/xfs_rw.c.  Return address = 0xc02ddebc

An XFS_bwrite() calls is failing.

Any suggestions on how to debug this?  I'm suspecting that there's a
problem with the RAID controller firmware, but I'd like to eliminate the
possibility of a file system bug.

Thanks,
Sergio





-----------------------------------------
This message (including any attachments) may contain confidential
information intended for a specific individual and purpose.  If you
are not the intended recipient, delete this message.  If you are
not the intended recipient, disclosing, copying, distributing, or
taking any action based on this message is strictly prohibited.

[[HTML alternate version deleted]]
