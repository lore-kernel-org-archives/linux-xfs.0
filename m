Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8D9897F50
	for <xfs@oss.sgi.com>; Sun,  7 Sep 2014 11:41:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 64B5B8F8035
	for <xfs@oss.sgi.com>; Sun,  7 Sep 2014 09:41:08 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id kAlWteQoyUxGTkl9 for <xfs@oss.sgi.com>;
	Sun, 07 Sep 2014 09:41:07 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 2/5] xfs_repair: preserve error state in process_shortform_attr
Date: Sun,  7 Sep 2014 11:41:02 -0500
Message-Id: <1410108065-18156-3-git-send-email-sandeen@redhat.com>
In-Reply-To: <1410108065-18156-1-git-send-email-sandeen@redhat.com>
References: <1410108065-18156-1-git-send-email-sandeen@redhat.com>
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

process_shortform_attr uses the "junkit" error to
track whether an error was found, but by assigning
it directly to the result of valuecheck, previous
errors are ignored, leading to unrepairable errors
of the form i.e.

"entry has INCOMPLETE flag on in shortform attribute"
or
"entry contains illegal character in shortform attribute name"

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 repair/attr_repair.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index a27a3ec..d60b664 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -914,7 +914,8 @@ process_shortform_attr(
 
 		/* Only check values for root security attributes */
 		if (currententry->flags & XFS_ATTR_ROOT)
-		       junkit = valuecheck(mp, (char *)&currententry->nameval[0],
+		       junkit |= valuecheck(mp,
+					(char *)&currententry->nameval[0],
 					NULL, currententry->namelen, 
 					currententry->valuelen);
 
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
