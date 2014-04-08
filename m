Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E098A80DD
	for <xfs@oss.sgi.com>; Tue,  8 Apr 2014 18:25:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DA8458F8092
	for <xfs@oss.sgi.com>; Tue,  8 Apr 2014 16:25:24 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id UUKtBEO9VouAvUQ9 for <xfs@oss.sgi.com>;
	Tue, 08 Apr 2014 16:25:16 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 06/14] xfs_quota: fix memory leak in quota_group_type() error
	path
Date: Tue,  8 Apr 2014 18:24:56 -0500
Message-Id: <1396999504-13769-7-git-send-email-sandeen@redhat.com>
In-Reply-To: <1396999504-13769-1-git-send-email-sandeen@redhat.com>
References: <1396999504-13769-1-git-send-email-sandeen@redhat.com>
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

quota_group_type has some rather contorted logic that's
been around since 2005.

In the (!name) case, if any of the 3 calls setting up ngroups fails,
we fall back to using just one group.

However, if it's the getgroups() call that fails, we overwrite
the allocated gid ptr with &gid, thus leaking that allocated
memory.  Worse, we set "dofree" to 1, so will free non-allocated
local var gid.  And that last else case is redundant; if we get there,
gids is guaranteed to be non-null.

Refactor it a bit to be more clear (I hope) and correct.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 quota/quota.c |   20 ++++++++++++--------
 1 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/quota/quota.c b/quota/quota.c
index 7e52ad2..367da8c 100644
--- a/quota/quota.c
+++ b/quota/quota.c
@@ -289,15 +289,19 @@ quota_group_type(
 		}
 		gids = &gid;
 		ngroups = 1;
-	} else if ( ((ngroups = sysconf(_SC_NGROUPS_MAX)) < 0) ||
-		    ((gids = malloc(ngroups * sizeof(gid_t))) == NULL) ||
-		    ((ngroups = getgroups(ngroups, gids)) < 0)) {
-		dofree = (gids != NULL);
-		gid = getgid();
-		gids = &gid;
-		ngroups = 1;
 	} else {
-		dofree = (gids != NULL);
+		if ( ((ngroups = sysconf(_SC_NGROUPS_MAX)) < 0) ||
+		     ((gids = malloc(ngroups * sizeof(gid_t))) == NULL) ||
+		     ((ngroups = getgroups(ngroups, gids)) < 0)) {
+			/* something failed.  Fall back to 1 group */
+			free(gids);
+			gid = getgid();
+			gids = &gid;
+			ngroups = 1;
+		} else {
+			/* It all worked, and we allocated memory */
+			dofree = 1;
+		}
 	}
 
 	for (i = 0; i < ngroups; i++, name = NULL) {
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
