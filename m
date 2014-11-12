Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0323A7F47
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2014 12:57:23 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 94F7CAC00A
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2014 10:57:22 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 4thi5fjtssOx1I5k for <xfs@oss.sgi.com>;
	Wed, 12 Nov 2014 10:57:21 -0800 (PST)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 2/9] xfsdump: Fix overflow of "question" string in
	Media_prompt_erase()
Date: Wed, 12 Nov 2014 12:57:11 -0600
Message-Id: <1415818638-32700-3-git-send-email-sandeen@redhat.com>
In-Reply-To: <1415818638-32700-1-git-send-email-sandeen@redhat.com>
References: <1415818638-32700-1-git-send-email-sandeen@redhat.com>
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

The string we were sprintf'ing is trivially longer than the array
we allocated for it.

Allocate something big enough, and snprintf to avoid overflow

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 dump/content.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/dump/content.c b/dump/content.c
index ac19021..786fc52 100644
--- a/dump/content.c
+++ b/dump/content.c
@@ -6174,7 +6174,7 @@ static bool_t
 Media_prompt_overwrite( drive_t *drivep )
 {
 	fold_t fold;
-	char question[ 100 ];
+	char question[ 110 ];
 	char *preamblestr[ PREAMBLEMAX ];
 	size_t preamblecnt;
 	char *querystr[ QUERYMAX ];
@@ -6201,7 +6201,7 @@ retry:
 
 	/* query: ask if overwrite ok
 	 */
-	sprintf( question,
+	snprintf( question, sizeof(question),
 		 "overwrite data on media in "
 		 "drive %u?\n",
 		 (unsigned int)drivep->d_index );
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
