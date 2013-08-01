Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1010A7F3F
	for <linux-xfs@oss.sgi.com>; Wed, 31 Jul 2013 20:13:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CCE498F8037
	for <linux-xfs@oss.sgi.com>; Wed, 31 Jul 2013 18:13:12 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Ti3pw4uyD3zZx8zN for
	<linux-xfs@oss.sgi.com>; Wed, 31 Jul 2013 18:13:12 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r711DBSY011483
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-xfs@oss.sgi.com>; Wed, 31 Jul 2013 21:13:11 -0400
Received: from Liberator.local (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r711DAIS015538
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-xfs@oss.sgi.com>; Wed, 31 Jul 2013 21:13:11 -0400
Message-ID: <51F9B626.4010707@redhat.com>
Date: Wed, 31 Jul 2013 20:13:10 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfsprogs: fix unint var in repair phase6
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
To: "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>

2 calls to libxfs_bmapi_write exist in repair's phase6
where "first" is uninitialized, but is accessed
in that function.

Normally we call xfs_bmap_init() first to initialize
both the free list and the first block, but in these
cases, the free list var is sent as NULL.

So in these 2 cases, explicitly initialize the "first"
variable to NULLFSBLOCK as xfs_bmap_init() does
elsewhere.

Coverity caught this.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/repair/phase6.c b/repair/phase6.c
index 5c33797..119ec3b 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -536,6 +536,7 @@ fill_rbmino(xfs_mount_t *mp)
 			error);
 	}
 
+	first = NULLFSBLOCK;
 	while (bno < mp->m_sb.sb_rbmblocks)  {
 		/*
 		 * fill the file one block at a time
@@ -605,6 +606,7 @@ fill_rsumino(xfs_mount_t *mp)
 			error);
 	}
 
+	first = NULLFSBLOCK;
 	while (bno < end_bno)  {
 		/*
 		 * fill the file one block at a time

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
