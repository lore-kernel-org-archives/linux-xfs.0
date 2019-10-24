Return-Path: <SRS0=feM8=YR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90B2ACA9EAF
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 07:51:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 605072084C
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 07:51:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408747AbfJXHvs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Oct 2019 03:51:48 -0400
Received: from icp-osb-irony-out1.external.iinet.net.au ([203.59.1.210]:26989
        "EHLO icp-osb-irony-out1.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2408743AbfJXHvr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Oct 2019 03:51:47 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2AaAADRVrFd/0e30XYNWBsBAQEBAQE?=
 =?us-ascii?q?BBQEBAREBAQMDAQEBgWkEAQEBCwEBhDqEKI9JBoERiiKFIAGKE4F7CQEBAQE?=
 =?us-ascii?q?BAQEBATcBAYQ7AwICg1k2Bw4CDAEBAQQBAQEBAQUDAYVYgRoBAQQHAYUBAgE?=
 =?us-ascii?q?DIwRSEBgNAiYCAkcQBhOFdbF0dX8zGoowgQ4oAYFkikJ4gQeBETODHYdVgl4?=
 =?us-ascii?q?EjQ6CLzeGQEOWbIIulUUMgi+LcAMQixQtqVgBggpNLgqDJ1CRfWeHPYMZhVg?=
 =?us-ascii?q?BAQ?=
X-IPAS-Result: =?us-ascii?q?A2AaAADRVrFd/0e30XYNWBsBAQEBAQEBBQEBAREBAQMDA?=
 =?us-ascii?q?QEBgWkEAQEBCwEBhDqEKI9JBoERiiKFIAGKE4F7CQEBAQEBAQEBATcBAYQ7A?=
 =?us-ascii?q?wICg1k2Bw4CDAEBAQQBAQEBAQUDAYVYgRoBAQQHAYUBAgEDIwRSEBgNAiYCA?=
 =?us-ascii?q?kcQBhOFdbF0dX8zGoowgQ4oAYFkikJ4gQeBETODHYdVgl4EjQ6CLzeGQEOWb?=
 =?us-ascii?q?IIulUUMgi+LcAMQixQtqVgBggpNLgqDJ1CRfWeHPYMZhVgBAQ?=
X-IronPort-AV: E=Sophos;i="5.68,224,1569254400"; 
   d="scan'208";a="250044054"
Received: from unknown (HELO [192.168.1.222]) ([118.209.183.71])
  by icp-osb-irony-out1.iinet.net.au with ESMTP; 24 Oct 2019 15:51:43 +0800
Subject: [PATCH v7 13/17] xfs: refactor xfs_parseags()
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Thu, 24 Oct 2019 15:51:43 +0800
Message-ID: <157190350372.27074.1238120877796190411.stgit@fedora-28>
In-Reply-To: <157190333868.27074.13987695222060552856.stgit@fedora-28>
References: <157190333868.27074.13987695222060552856.stgit@fedora-28>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Refactor xfs_parseags(), move the entire token case block to a separate
function in an attempt to highlight the code that actually changes in
converting to use the new mount api.

The only changes are what's needed to communicate the variables dsunit,
dswidth and iosizelog back to xfs_parseags().

Signed-off-by: Ian Kent <raven@themaw.net>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_super.c |  290 ++++++++++++++++++++++++++++------------------------
 1 file changed, 155 insertions(+), 135 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 92a37ac0b907..de0ab79536b3 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -164,6 +164,156 @@ match_kstrtoint(
 	return ret;
 }
 
+static int
+xfs_fc_parse_param(
+	int			token,
+	char			*p,
+	substring_t		*args,
+	struct xfs_mount	*mp,
+	int			*dsunit,
+	int			*dswidth,
+	uint8_t			*iosizelog)
+{
+	int			iosize = 0;
+
+	switch (token) {
+	case Opt_logbufs:
+		if (match_int(args, &mp->m_logbufs))
+			return -EINVAL;
+		return 0;
+	case Opt_logbsize:
+		if (match_kstrtoint(args, 10, &mp->m_logbsize))
+			return -EINVAL;
+		return 0;
+	case Opt_logdev:
+		kfree(mp->m_logname);
+		mp->m_logname = match_strdup(args);
+		if (!mp->m_logname)
+			return -ENOMEM;
+		return 0;
+	case Opt_rtdev:
+		kfree(mp->m_rtname);
+		mp->m_rtname = match_strdup(args);
+		if (!mp->m_rtname)
+			return -ENOMEM;
+		return 0;
+	case Opt_allocsize:
+		if (match_kstrtoint(args, 10, &iosize))
+			return -EINVAL;
+		*iosizelog = ffs(iosize) - 1;
+		return 0;
+	case Opt_grpid:
+	case Opt_bsdgroups:
+		mp->m_flags |= XFS_MOUNT_GRPID;
+		return 0;
+	case Opt_nogrpid:
+	case Opt_sysvgroups:
+		mp->m_flags &= ~XFS_MOUNT_GRPID;
+		return 0;
+	case Opt_wsync:
+		mp->m_flags |= XFS_MOUNT_WSYNC;
+		return 0;
+	case Opt_norecovery:
+		mp->m_flags |= XFS_MOUNT_NORECOVERY;
+		return 0;
+	case Opt_noalign:
+		mp->m_flags |= XFS_MOUNT_NOALIGN;
+		return 0;
+	case Opt_swalloc:
+		mp->m_flags |= XFS_MOUNT_SWALLOC;
+		return 0;
+	case Opt_sunit:
+		if (match_int(args, dsunit))
+			return -EINVAL;
+		return 0;
+	case Opt_swidth:
+		if (match_int(args, dswidth))
+			return -EINVAL;
+		return 0;
+	case Opt_inode32:
+		mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
+		return 0;
+	case Opt_inode64:
+		mp->m_flags &= ~XFS_MOUNT_SMALL_INUMS;
+		return 0;
+	case Opt_nouuid:
+		mp->m_flags |= XFS_MOUNT_NOUUID;
+		return 0;
+	case Opt_ikeep:
+		mp->m_flags |= XFS_MOUNT_IKEEP;
+		return 0;
+	case Opt_noikeep:
+		mp->m_flags &= ~XFS_MOUNT_IKEEP;
+		return 0;
+	case Opt_largeio:
+		mp->m_flags &= ~XFS_MOUNT_COMPAT_IOSIZE;
+		return 0;
+	case Opt_nolargeio:
+		mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
+		return 0;
+	case Opt_attr2:
+		mp->m_flags |= XFS_MOUNT_ATTR2;
+		return 0;
+	case Opt_noattr2:
+		mp->m_flags &= ~XFS_MOUNT_ATTR2;
+		mp->m_flags |= XFS_MOUNT_NOATTR2;
+		return 0;
+	case Opt_filestreams:
+		mp->m_flags |= XFS_MOUNT_FILESTREAMS;
+		return 0;
+	case Opt_noquota:
+		mp->m_qflags &= ~XFS_ALL_QUOTA_ACCT;
+		mp->m_qflags &= ~XFS_ALL_QUOTA_ENFD;
+		mp->m_qflags &= ~XFS_ALL_QUOTA_ACTIVE;
+		return 0;
+	case Opt_quota:
+	case Opt_uquota:
+	case Opt_usrquota:
+		mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE |
+				 XFS_UQUOTA_ENFD);
+		return 0;
+	case Opt_qnoenforce:
+	case Opt_uqnoenforce:
+		mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE);
+		mp->m_qflags &= ~XFS_UQUOTA_ENFD;
+		return 0;
+	case Opt_pquota:
+	case Opt_prjquota:
+		mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE |
+				 XFS_PQUOTA_ENFD);
+		return 0;
+	case Opt_pqnoenforce:
+		mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE);
+		mp->m_qflags &= ~XFS_PQUOTA_ENFD;
+		return 0;
+	case Opt_gquota:
+	case Opt_grpquota:
+		mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE |
+				 XFS_GQUOTA_ENFD);
+		return 0;
+	case Opt_gqnoenforce:
+		mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE);
+		mp->m_qflags &= ~XFS_GQUOTA_ENFD;
+		return 0;
+	case Opt_discard:
+		mp->m_flags |= XFS_MOUNT_DISCARD;
+		return 0;
+	case Opt_nodiscard:
+		mp->m_flags &= ~XFS_MOUNT_DISCARD;
+		return 0;
+#ifdef CONFIG_FS_DAX
+	case Opt_dax:
+		mp->m_flags |= XFS_MOUNT_DAX;
+		return 0;
+#endif
+	default:
+		xfs_warn(mp, "unknown mount option [%s].", p);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 /*
  * This function fills in xfs_mount_t fields based on mount args.
  * Note: the superblock has _not_ yet been read in.
@@ -185,7 +335,6 @@ xfs_parseargs(
 	substring_t		args[MAX_OPT_ARGS];
 	int			dsunit = 0;
 	int			dswidth = 0;
-	int			iosize = 0;
 	uint8_t			iosizelog = 0;
 
 	/*
@@ -215,145 +364,16 @@ xfs_parseargs(
 
 	while ((p = strsep(&options, ",")) != NULL) {
 		int		token;
+		int		ret;
 
 		if (!*p)
 			continue;
 
 		token = match_token(p, tokens, args);
-		switch (token) {
-		case Opt_logbufs:
-			if (match_int(args, &mp->m_logbufs))
-				return -EINVAL;
-			break;
-		case Opt_logbsize:
-			if (match_kstrtoint(args, 10, &mp->m_logbsize))
-				return -EINVAL;
-			break;
-		case Opt_logdev:
-			kfree(mp->m_logname);
-			mp->m_logname = match_strdup(args);
-			if (!mp->m_logname)
-				return -ENOMEM;
-			break;
-		case Opt_rtdev:
-			kfree(mp->m_rtname);
-			mp->m_rtname = match_strdup(args);
-			if (!mp->m_rtname)
-				return -ENOMEM;
-			break;
-		case Opt_allocsize:
-			if (match_kstrtoint(args, 10, &iosize))
-				return -EINVAL;
-			iosizelog = ffs(iosize) - 1;
-			break;
-		case Opt_grpid:
-		case Opt_bsdgroups:
-			mp->m_flags |= XFS_MOUNT_GRPID;
-			break;
-		case Opt_nogrpid:
-		case Opt_sysvgroups:
-			mp->m_flags &= ~XFS_MOUNT_GRPID;
-			break;
-		case Opt_wsync:
-			mp->m_flags |= XFS_MOUNT_WSYNC;
-			break;
-		case Opt_norecovery:
-			mp->m_flags |= XFS_MOUNT_NORECOVERY;
-			break;
-		case Opt_noalign:
-			mp->m_flags |= XFS_MOUNT_NOALIGN;
-			break;
-		case Opt_swalloc:
-			mp->m_flags |= XFS_MOUNT_SWALLOC;
-			break;
-		case Opt_sunit:
-			if (match_int(args, &dsunit))
-				return -EINVAL;
-			break;
-		case Opt_swidth:
-			if (match_int(args, &dswidth))
-				return -EINVAL;
-			break;
-		case Opt_inode32:
-			mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
-			break;
-		case Opt_inode64:
-			mp->m_flags &= ~XFS_MOUNT_SMALL_INUMS;
-			break;
-		case Opt_nouuid:
-			mp->m_flags |= XFS_MOUNT_NOUUID;
-			break;
-		case Opt_ikeep:
-			mp->m_flags |= XFS_MOUNT_IKEEP;
-			break;
-		case Opt_noikeep:
-			mp->m_flags &= ~XFS_MOUNT_IKEEP;
-			break;
-		case Opt_largeio:
-			mp->m_flags &= ~XFS_MOUNT_COMPAT_IOSIZE;
-			break;
-		case Opt_nolargeio:
-			mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
-			break;
-		case Opt_attr2:
-			mp->m_flags |= XFS_MOUNT_ATTR2;
-			break;
-		case Opt_noattr2:
-			mp->m_flags &= ~XFS_MOUNT_ATTR2;
-			mp->m_flags |= XFS_MOUNT_NOATTR2;
-			break;
-		case Opt_filestreams:
-			mp->m_flags |= XFS_MOUNT_FILESTREAMS;
-			break;
-		case Opt_noquota:
-			mp->m_qflags &= ~XFS_ALL_QUOTA_ACCT;
-			mp->m_qflags &= ~XFS_ALL_QUOTA_ENFD;
-			mp->m_qflags &= ~XFS_ALL_QUOTA_ACTIVE;
-			break;
-		case Opt_quota:
-		case Opt_uquota:
-		case Opt_usrquota:
-			mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE |
-					 XFS_UQUOTA_ENFD);
-			break;
-		case Opt_qnoenforce:
-		case Opt_uqnoenforce:
-			mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE);
-			mp->m_qflags &= ~XFS_UQUOTA_ENFD;
-			break;
-		case Opt_pquota:
-		case Opt_prjquota:
-			mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE |
-					 XFS_PQUOTA_ENFD);
-			break;
-		case Opt_pqnoenforce:
-			mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE);
-			mp->m_qflags &= ~XFS_PQUOTA_ENFD;
-			break;
-		case Opt_gquota:
-		case Opt_grpquota:
-			mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE |
-					 XFS_GQUOTA_ENFD);
-			break;
-		case Opt_gqnoenforce:
-			mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE);
-			mp->m_qflags &= ~XFS_GQUOTA_ENFD;
-			break;
-		case Opt_discard:
-			mp->m_flags |= XFS_MOUNT_DISCARD;
-			break;
-		case Opt_nodiscard:
-			mp->m_flags &= ~XFS_MOUNT_DISCARD;
-			break;
-#ifdef CONFIG_FS_DAX
-		case Opt_dax:
-			mp->m_flags |= XFS_MOUNT_DAX;
-			break;
-#endif
-		default:
-			xfs_warn(mp, "unknown mount option [%s].", p);
-			return -EINVAL;
-		}
+		ret = xfs_fc_parse_param(token, p, args, mp, &dsunit, &dswidth,
+					 &iosizelog);
+		if (ret)
+			return ret;
 	}
 
 	/*

