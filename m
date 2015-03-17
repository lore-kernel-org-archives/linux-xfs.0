Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D70E47F54
	for <xfs@oss.sgi.com>; Tue, 17 Mar 2015 15:33:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B5B3D8F8049
	for <xfs@oss.sgi.com>; Tue, 17 Mar 2015 13:33:20 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id GB7KxsNYzcKnC5yx for <xfs@oss.sgi.com>;
	Tue, 17 Mar 2015 13:33:19 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 05/13] xfs_repair: dirty inode in process_sf_dir2 if we change
	namelen
Date: Tue, 17 Mar 2015 15:33:07 -0500
Message-Id: <1426624395-8258-6-git-send-email-sandeen@redhat.com>
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

There are two "fix sfep->namelen" cases, but we only mark
*dino_dirty = 1 in one of them.  Add the other to ensure that
the change gets written out.

Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 repair/dir2.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/repair/dir2.c b/repair/dir2.c
index 6b8964d..25793e9 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -881,6 +881,7 @@ _("entry \"%*.*s\" in shortform directory %" PRIu64 " references %s inode %" PRI
 _("zero length entry in shortform dir %" PRIu64 ", resetting to %d\n"),
 						ino, namelen);
 					sfep->namelen = namelen;
+					*dino_dirty = 1;
 				} else  {
 					do_warn(
 _("zero length entry in shortform dir %" PRIu64 ", would set to %d\n"),
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
