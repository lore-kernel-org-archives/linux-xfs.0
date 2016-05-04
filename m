Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6F30D7CA1
	for <xfs@oss.sgi.com>; Tue,  3 May 2016 19:48:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 33D868F8033
	for <xfs@oss.sgi.com>; Tue,  3 May 2016 17:48:47 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id OKvd7yf3Ixdvna8u for <xfs@oss.sgi.com>;
	Tue, 03 May 2016 17:48:40 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id EB5099E
	for <xfs@oss.sgi.com>; Tue,  3 May 2016 19:48:39 -0500 (CDT)
Subject: Re: [PATCH 03/19] mkfs: Sanitise the superblock feature macros
References: <1461231593-31294-1-git-send-email-jtulak@redhat.com>
	<1461231593-31294-4-git-send-email-jtulak@redhat.com>
	<295ccd50-c22e-59d0-71d9-b07b438f63cd@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5b5ae3c1-ce75-9146-cff2-5103130f2460@sandeen.net>
Date: Tue, 3 May 2016 19:48:39 -0500
MIME-Version: 1.0
In-Reply-To: <295ccd50-c22e-59d0-71d9-b07b438f63cd@sandeen.net>
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

Patch 03/19 fixup V2:

sb_feat.dirftype should be initialized as true, not initialized
as false and then reset to 1 (sic - true)

V2: Remove unnecessary continuation chars "\"

Eric Sandeen <sandeen@redhat.com>: Properly initialize sb_feat.dirftype
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
