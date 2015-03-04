Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0EBB97F3F
	for <xfs@oss.sgi.com>; Wed,  4 Mar 2015 14:59:05 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DEF848F8050
	for <xfs@oss.sgi.com>; Wed,  4 Mar 2015 12:59:04 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id ePadBwbsLTNs8P6C for <xfs@oss.sgi.com>;
	Wed, 04 Mar 2015 12:59:03 -0800 (PST)
Message-ID: <54F77216.5030106@sandeen.net>
Date: Wed, 04 Mar 2015 14:59:02 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 2/4] xfs_repair: clear need_root_dotdot if we rebuild the
	root dir
References: <54F77199.8030708@redhat.com>
In-Reply-To: <54F77199.8030708@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

It's possible to enter longform_dir2_rebuild with need_root_dotdot
set; rebuilding it will add "..", and if need_root_dotdot stays set,
we'll add another ".." entry, causing a second repair to find and
fix that newly-introduced problem.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/repair/phase6.c b/repair/phase6.c
index 0ec4f07..1728609 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1354,6 +1354,9 @@ longform_dir2_rebuild(
 
 	libxfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_SYNC);
 
+	if (ino == mp->m_sb.sb_rootino)
+		need_root_dotdot = 0;
+
 	/* go through the hash list and re-add the inodes */
 
 	for (p = hashtab->first; p; p = p->nextbyorder) {


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
