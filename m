Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 718667CA6
	for <xfs@oss.sgi.com>; Tue,  3 May 2016 18:39:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 446598F8033
	for <xfs@oss.sgi.com>; Tue,  3 May 2016 16:39:57 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id vBm1uq5ie79aZYL5 for <xfs@oss.sgi.com>;
	Tue, 03 May 2016 16:39:54 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 1D0669E
	for <xfs@oss.sgi.com>; Tue,  3 May 2016 18:39:54 -0500 (CDT)
Subject: Re: [PATCH 13/19] mkfs: encode conflicts into parsing table
References: <1461231593-31294-1-git-send-email-jtulak@redhat.com>
	<1461231593-31294-14-git-send-email-jtulak@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <a3f5f830-27e9-26b4-9ffd-1fbdf5ca7952@sandeen.net>
Date: Tue, 3 May 2016 18:39:53 -0500
MIME-Version: 1.0
In-Reply-To: <1461231593-31294-14-git-send-email-jtulak@redhat.com>
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
To: xfs@oss.sgi.com

Sorry, updated fixup patch; missed removal of "\" chars:



Remove now-encoded conflict under case L_FILE

The .conflicts handle this now, no need to keep it around.



Remove unneccesary continuation chars "\"

Eric Sandeen <sandeen@redhat.com>: remove explicit L_FILE conflict
---

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 963545b..e19181c 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -975,8 +975,7 @@ sb_set_features(
 	 */
 	if (fp->spinodes) {
 		sbp->sb_spino_align = sbp->sb_inoalignmt;
-		sbp->sb_inoalignmt = \
-			XFS_INODES_PER_CHUNK * \
+		sbp->sb_inoalignmt = XFS_INODES_PER_CHUNK *
 			sbp->sb_inodesize >> sbp->sb_blocklog;
 		sbp->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_SPINODES;
 	}
@@ -1090,7 +1089,7 @@ main(
 		.lazy_sb_counters = true,
 		.projid16bit = false,
 		.crcs_enabled = true,
-		.dirftype = false,
+		.dirftype = true,
 		.parent_pointers = false,
 	};
 
@@ -1109,7 +1108,6 @@ main(
 	liflag = laflag = lsflag = lsuflag = lsunitflag = ldflag = lvflag = 0;
 	loginternal = 1;
 	logagno = logblocks = rtblocks = rtextblocks = 0;
-	sb_feat.dirftype = 1;		/* inode type information in the dir */
 	Nflag = nlflag = nsflag = nvflag = 0;
 	nftype = 0;
 	dirblocklog = dirblocksize = 0;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
