Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 04 Aug 2008 23:26:28 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m756Q0Fu015064
	for <xfs@oss.sgi.com>; Mon, 4 Aug 2008 23:26:00 -0700
Message-ID: <4897F434.2010309@sgi.com>
Date: Tue, 05 Aug 2008 16:33:24 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: [PATCH] Don't release root inode until finished using it
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, xfs-dev <xfs-dev@sgi.com>

During unmount we're releasing the last reference on the root inode
before we've finished using it so move it after the XFS_SEND_UNMOUNT
hook.

--- a/fs/xfs/linux-2.6/xfs_super.c	2008-08-05 13:12:39.000000000 +1000
+++ b/fs/xfs/linux-2.6/xfs_super.c	2008-08-04 14:34:56.000000000 +1000
@@ -1132,8 +1132,6 @@ xfs_fs_put_super(
 	error = xfs_unmount_flush(mp, 0);
 	WARN_ON(error);
 
-	IRELE(rip);
-
 	/*
 	 * If we're forcing a shutdown, typically because of a media error,
 	 * we want to make sure we invalidate dirty pages that belong to
@@ -1149,6 +1147,8 @@ xfs_fs_put_super(
 				unmount_event_flags);
 	}
 
+	IRELE(rip);
+
 	xfs_unmountfs(mp);
 	xfs_icsb_destroy_counters(mp);
 	xfs_close_devices(mp);
