Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 12 Jun 2008 23:04:12 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m5D6427H031812
	for <xfs@oss.sgi.com>; Thu, 12 Jun 2008 23:04:08 -0700
Received: from pc-bnaujok.melbourne.sgi.com (pc-bnaujok.melbourne.sgi.com [134.14.55.58]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id QAA14191 for <xfs@oss.sgi.com>; Fri, 13 Jun 2008 16:04:58 +1000
Date: Fri, 13 Jun 2008 16:06:57 +1000
Subject: [REVIEW] Invalidate dentry on unlink/rmdir if using CI mode
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-ID: <op.ucoa9vjb3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Once of the interesting features of vfs_unlink/d_delete functionality
is that if it's the only inode being referenced, it makes the dentry
negative. CI doesn't work with negative dentries, so the following code
invalidate the dentry in CI mode.

--

--- a/fs/xfs/linux-2.6/xfs_iops.c
+++ b/fs/xfs/linux-2.6/xfs_iops.c
@@ -482,6 +482,8 @@ xfs_vn_unlink(
         if (likely(!error)) {
                 xfs_validate_fields(dir);       /* size needs update */
                 xfs_validate_fields(inode);
+               if (xfs_sb_version_hasasciici(&XFS_M(dir->i_sb)->m_sb))
+                       d_invalidate(dentry);
         }
         return -error;
  }
@@ -538,6 +540,8 @@ xfs_vn_rmdir(
         if (likely(!error)) {
                 xfs_validate_fields(inode);
                 xfs_validate_fields(dir);
+               if (xfs_sb_version_hasasciici(&XFS_M(dir->i_sb)->m_sb))
+                       d_invalidate(dentry);
         }
         return -error;
  }
