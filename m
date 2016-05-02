Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2A55B7CF1
	for <xfs@oss.sgi.com>; Mon,  2 May 2016 18:06:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E4E558F8035
	for <xfs@oss.sgi.com>; Mon,  2 May 2016 16:06:50 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id BwA8KkLGt8WcWSP0 for <xfs@oss.sgi.com>;
	Mon, 02 May 2016 16:06:49 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 0B92F545
	for <xfs@oss.sgi.com>; Mon,  2 May 2016 18:06:49 -0500 (CDT)
Subject: Re: [PATCH 03/19] mkfs: Sanitise the superblock feature macros
References: <1461231593-31294-1-git-send-email-jtulak@redhat.com>
	<1461231593-31294-4-git-send-email-jtulak@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <295ccd50-c22e-59d0-71d9-b07b438f63cd@sandeen.net>
Date: Mon, 2 May 2016 18:06:48 -0500
MIME-Version: 1.0
In-Reply-To: <1461231593-31294-4-git-send-email-jtulak@redhat.com>
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

Patch 03/19 fixup:

sb_feat.dirftype should be initialized as true, not initialized
as false and then reset to 1 (sic - true)

Eric Sandeen <sandeen@redhat.com>: Properly initialize sb_feat.dirftype
---


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 963545b..655b3c0 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1090,7 +1090,7 @@ main(
 		.lazy_sb_counters = true,
 		.projid16bit = false,
 		.crcs_enabled = true,
-		.dirftype = false,
+		.dirftype = true,
 		.parent_pointers = false,
 	};
 
@@ -1109,7 +1109,6 @@ main(
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
