Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n99F8GTU079052 for <xfs@oss.sgi.com>; Fri, 9 Oct 2009 10:08:16 -0500
Received: from smtp2-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E131D4B40D9
	for <xfs@oss.sgi.com>; Fri,  9 Oct 2009 08:09:41 -0700 (PDT)
Received: from smtp2-g21.free.fr (smtp2-g21.free.fr [212.27.42.2]) by
	cuda.sgi.com with ESMTP id FkpPu7NSZjBwgkhG for
	<xfs@oss.sgi.com>; Fri, 09 Oct 2009 08:09:41 -0700 (PDT)
Received: from smtp2-g21.free.fr (localhost [127.0.0.1])
	by smtp2-g21.free.fr (Postfix) with ESMTP id 708ED4B009F
	for <xfs@oss.sgi.com>; Fri,  9 Oct 2009 17:09:35 +0200 (CEST)
Received: from harpe.intellique.com (labo.djinux.com [82.225.196.72])
	by smtp2-g21.free.fr (Postfix) with ESMTP id 82B404B0131
	for <xfs@oss.sgi.com>; Fri,  9 Oct 2009 17:09:33 +0200 (CEST)
Date: Fri, 9 Oct 2009 17:09:37 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: can't mount XFS from a read-only device
Message-ID: <20091009170937.3938ff7b@harpe.intellique.com>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hello all, 

I'm using a RAID enclosure that provides read-only snapshots. It works
perfectly fine using JFS.
But with XFS, I keep trying and it keeps failing :

XFS mounting filesystem sdb

Ending clean XFS mount for filesystem: sdb

sd 11:0:0:1: [sdc] Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE,SUGGEST_OK

sd 11:0:0:1: [sdc] Sense Key : Data Protect [current] 

sd 11:0:0:1: [sdc] Add. Sense: Write protected
end_request: I/O error, dev sdc, sector 0
Filesystem "sdc": Disabling barriers, trial barrier write failed
XFS mounting filesystem sdc

sd 11:0:0:1: [sdc] Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE,SUGGEST_OK

sd 11:0:0:1: [sdc] Sense Key : Data Protect [current] 

sd 11:0:0:1: [sdc] Add. Sense: Write protected
end_request: I/O error, dev sdc, sector 1953792056
xfs_force_shutdown(sdc,0x1) called from line 420 of file
fs/xfs/xfs_rw.c.  Return address = 0xffffffff80381f89

Filesystem "sdc": I/O Error Detected.  Shutting down filesystem: sdc

Please umount the filesystem, and rectify the problem(s)

I/O error in filesystem ("sdc") meta-data dev sdc block
0x74748038       ("xlog_bwrite") error 5 buf count 262144

XFS: failed to locate log tail
XFS: log mount/recovery failed: error 5
XFS: log mount failed

I don't really grasp what's wrong...

-- 
------------------------------------------------------------------------
Emmanuel Florac     |   Intellique
------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
