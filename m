Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2821D7CA0
	for <xfs@oss.sgi.com>; Tue, 29 Mar 2016 14:28:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CD582304062
	for <xfs@oss.sgi.com>; Tue, 29 Mar 2016 12:28:30 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 4rGwkFNFd7CZrEXq (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 29 Mar 2016 12:28:30 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id 9D43746201
	for <xfs@oss.sgi.com>; Tue, 29 Mar 2016 19:28:29 +0000 (UTC)
Received: from Liberator.local (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u2TJSR6W015119
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 29 Mar 2016 15:28:29 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs: disallow rw remount on fs with unknown ro-compat features
Message-ID: <56FAD75C.80502@redhat.com>
Date: Tue, 29 Mar 2016 14:28:28 -0500
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

Today, a kernel which refuses to mount a filesystem read-write
due to unknown ro-compat features can still transition to read-write
via the remount path.  The old kernel is most likely none the wiser,
because it's unaware of the new feature, and isn't using it.  However,
writing to the filesystem may well corrupt metadata related to that
new feature, and moving to a newer kernel which understand the feature
will have problems.

Right now the only ro-compat feature we have is the free inode btree,
which showed up in v3.16.  It would be good to push this back to
all the active stable kernels, I think, so that if anyone is using
newer mkfs (which enables the finobt feature) with older kernel
releases, they'll be protected.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Cc: stable@vger.kernel.org
---

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index d760934..ca058a1 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1276,6 +1276,16 @@ xfs_fs_remount(
 			return -EINVAL;
 		}
 
+		if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
+		    xfs_sb_has_ro_compat_feature(sbp,
+					XFS_SB_FEAT_RO_COMPAT_UNKNOWN)) {
+			xfs_warn(mp,
+"ro->rw transition prohibited on unknown (0x%x) ro-compat filesystem",
+				(sbp->sb_features_ro_compat &
+					XFS_SB_FEAT_RO_COMPAT_UNKNOWN));
+			return -EINVAL;
+		}
+
 		mp->m_flags &= ~XFS_MOUNT_RDONLY;
 
 		/*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
