Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 29 Mar 2008 18:49:18 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2U1n8vu020405
	for <xfs@oss.sgi.com>; Sat, 29 Mar 2008 18:49:11 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8FDEC8BC72F
	for <xfs@oss.sgi.com>; Sat, 29 Mar 2008 18:49:44 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id fakqoijEjbcjmJ4U for <xfs@oss.sgi.com>; Sat, 29 Mar 2008 18:49:44 -0700 (PDT)
Message-ID: <47EEF198.2060409@sandeen.net>
Date: Sat, 29 Mar 2008 20:49:12 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [patch] detect and correct bad features2 superblock field
References: <20080220054041.GM155407@sgi.com> <47EEED18.9090206@sandeen.net>
In-Reply-To: <47EEED18.9090206@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Eric Sandeen wrote:

> Hm, the other problem here may be that if we zero bad_features2, then
> any older kernel will mount up as attr2... and run into the corruption
> problem I found on F8...
>   
Er, as attr1

> Should we make features2 and bad_features2 match rather than zeroing
> bad_features2?
>   
Maybe like this...?  Though I suppose there's still a minor issue
with older tools modifying flags...

diff -u linux-2.6.24.x86_64/fs/xfs/xfs_sb.h linux-2.6.24.x86_64/fs/xfs/xfs_sb.h
--- linux-2.6.24.x86_64/fs/xfs/xfs_sb.h
+++ linux-2.6.24.x86_64/fs/xfs/xfs_sb.h
@@ -325,7 +325,7 @@
  */
 static inline int xfs_sb_has_bad_features2(xfs_sb_t *sbp)
 {
-	return (sbp->sb_bad_features2 != 0);
+	return (sbp->sb_features2 != sbp->sb_bad_features2);
 }
 
 #define	XFS_SB_VERSION_TONEW(v)	xfs_sb_version_tonew(v)
diff -u linux-2.6.24.x86_64/fs/xfs/xfs_mount.c linux-2.6.24.x86_64/fs/xfs/xfs_mount.c
--- linux-2.6.24.x86_64/fs/xfs/xfs_mount.c
+++ linux-2.6.24.x86_64/fs/xfs/xfs_mount.c
@@ -994,7 +994,7 @@
 		cmn_err(CE_WARN,
 			"XFS: correcting sb_features alignment problem");
 		sbp->sb_features2 |= sbp->sb_bad_features2;
-		sbp->sb_bad_features2 = 0;
+		sbp->sb_bad_features2 = sbp->sb_features2;
 		update_flags |= XFS_SB_FEATURES2 | XFS_SB_BAD_FEATURES2;
 	}
 
