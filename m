Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 27 Jul 2006 06:25:44 -0700 (PDT)
Received: from server077.de-nserver.de (server077.de-nserver.de [62.27.12.245])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6RDPHDW005648
	for <xfs@oss.sgi.com>; Thu, 27 Jul 2006 06:25:18 -0700
Message-ID: <44C8B08F.8020603@profihost.com>
Date: Thu, 27 Jul 2006 14:24:47 +0200
From: ProfiHost - Stefan Priebe <s.priebe@profihost.com>
MIME-Version: 1.0
Subject: XFS / Quota Bug in  2.6.17.x and 2.6.18x
References: <44C8A5F1.7060604@profihost.com> <20060727120425.GB6825@martell.zuzino.mipt.ru>
In-Reply-To: <20060727120425.GB6825@martell.zuzino.mipt.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: nathans@sgi.com
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

Hello!

The crash only occurs if you use quota and an IDE Drive without barrier 
support.

The Problem is, that on a new mount of a root filesystem - the flag 
VFS_RDONLY is set - and so no barrier check is done before checking 
quota. With this patch barrier check is done always. The partition 
should not be mounted at that moment, so it could not be READ ONLY. For 
mount -o remount, rw or something like this - XFS uses another function 
where VFS_RDONLY is checked.

Error Message:
ns2 Wed Jul 26 14:22:58 2006 "I/O error in filesystem ("hda6") meta-data dev
hda6 block 0x23db5ab       ("xlog_iodone") error 5 buf count 1024"
ns2 Wed Jul 26 14:22:58 2006 "xfs_force_shutdown(hda6,0x2) called from line
959 of file fs/xfs/xfs_log.c.  Return address = 0xc0211535"
ns2 Wed Jul 26 14:22:58 2006 "Filesystem "hda6": Log I/O Error Detected.
Shutting down filesystem: hda6"
ns2 Wed Jul 26 14:22:58 2006 "Please umount the filesystem, and rectify the
problem(s)"
ns2 Wed Jul 26 14:22:58 2006 "xfs_force_shutdown(hda6,0x1) called from line
338 of file fs/xfs/xfs_rw.c.  Return address = 0xc0211535"
ns2 Wed Jul 26 14:22:58 2006 "xfs_force_shutdown(hda6,0x1) called from line
338 of file fs/xfs/xfs_rw.c.  Return address = 0xc0211535"

Patch:
--- fs/xfs/xfs_vfsops.c.orig    2006-07-27 14:22:25.185949750 +0200
+++ fs/xfs/xfs_vfsops.c 2006-07-27 14:22:28.246141000 +0200
@@ -523,7 +523,7 @@ xfs_mount(
         if (error)
                 goto error2;

-       if ((mp->m_flags & XFS_MOUNT_BARRIER) && !(vfsp->vfs_flag & 
VFS_RDONLY))
+       if (mp->m_flags & XFS_MOUNT_BARRIER)
                 xfs_mountfs_check_barriers(mp);

         error = XFS_IOINIT(vfsp, args, flags);

Best regards,
Stefan
Ihr ProfiHost Team
------------------------------------------
ProfiHost e.K.
Lindener Str 15
38300 Wolfenbüttel

Tel.: 05331 996890
Fax: 05331 996899
URL: http://www.profihost.com
E-Mail: support@profihost.com
