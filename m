Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B5F227F55
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2014 13:05:37 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A403C8F8033
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2014 11:05:34 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id a9EGHLq02BpKcPrm for <xfs@oss.sgi.com>;
	Wed, 12 Nov 2014 11:05:31 -0800 (PST)
Message-ID: <5463AF7A.8040006@sandeen.net>
Date: Wed, 12 Nov 2014 13:05:30 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 2/9 V2] xfsdump: Fix overflow of "question" string in
	Media_prompt_erase()
References: <1415818638-32700-1-git-send-email-sandeen@redhat.com>
	<1415818638-32700-3-git-send-email-sandeen@redhat.com>
In-Reply-To: <1415818638-32700-3-git-send-email-sandeen@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>, xfs@oss.sgi.com

The string we were sprintf'ing is trivially longer than the array
we allocated for it.

Use asprintf instead, as suggested by Christoph.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: use asprintf

diff --git a/dump/content.c b/dump/content.c
index ac19021..43756e3 100644
--- a/dump/content.c
+++ b/dump/content.c
@@ -6174,7 +6174,7 @@ static bool_t
 Media_prompt_overwrite( drive_t *drivep )
 {
 	fold_t fold;
-	char question[ 100 ];
+	char *question;
 	char *preamblestr[ PREAMBLEMAX ];
 	size_t preamblecnt;
 	char *querystr[ QUERYMAX ];
@@ -6201,9 +6201,8 @@ retry:
 
 	/* query: ask if overwrite ok
 	 */
-	sprintf( question,
-		 "overwrite data on media in "
-		 "drive %u?\n",
+	asprintf( &question, 
+		 "overwrite data on media in drive %u?\n",
 		 (unsigned int)drivep->d_index );
 	querycnt = 0;
 	querystr[ querycnt++ ] = question;
@@ -6250,6 +6249,8 @@ retry:
 	dlog_end( postamblestr,
 		  postamblecnt );
 
+	free(question);
+
 	if ( responseix == sigintix ) {
 		if ( cldmgr_stop_requested( )) {
 			return BOOL_FALSE;


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
