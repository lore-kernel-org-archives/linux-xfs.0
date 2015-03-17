Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 89C287F5E
	for <xfs@oss.sgi.com>; Tue, 17 Mar 2015 15:33:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 69166304051
	for <xfs@oss.sgi.com>; Tue, 17 Mar 2015 13:33:21 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id kFlQYYcLa2QeqkxU for <xfs@oss.sgi.com>;
	Tue, 17 Mar 2015 13:33:19 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 10/13] xfs_repair: clear need_root_dotdot if we rebuild the
	root dir
Date: Tue, 17 Mar 2015 15:33:12 -0500
Message-Id: <1426624395-8258-11-git-send-email-sandeen@redhat.com>
In-Reply-To: <1426624395-8258-1-git-send-email-sandeen@redhat.com>
References: <1426624395-8258-1-git-send-email-sandeen@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

It's possible to enter longform_dir2_rebuild with need_root_dotdot
set; rebuilding it will add "..", and if need_root_dotdot stays set,
we'll add another ".." entry, causing a second repair to find and
fix that problem.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 repair/phase6.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

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
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
