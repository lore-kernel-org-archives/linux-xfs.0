Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EA8BB7F57
	for <xfs@oss.sgi.com>; Fri,  1 Aug 2014 09:59:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D94778F807A
	for <xfs@oss.sgi.com>; Fri,  1 Aug 2014 07:59:23 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id T9B1mcDpzxqQwGl1 for <xfs@oss.sgi.com>;
	Fri, 01 Aug 2014 07:59:23 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 6/6] xfs_db: free flist on error in write_struct()
Date: Fri,  1 Aug 2014 09:59:19 -0500
Message-Id: <1406905159-12415-7-git-send-email-sandeen@redhat.com>
In-Reply-To: <1406905159-12415-1-git-send-email-sandeen@redhat.com>
References: <1406905159-12415-1-git-send-email-sandeen@redhat.com>
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

One error path in write_struct() wasn't freeing
the flist_t *fl which was allocated, so it leaks.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 db/write.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/db/write.c b/db/write.c
index 0157a44..a0f14f4 100644
--- a/db/write.c
+++ b/db/write.c
@@ -652,6 +652,7 @@ write_struct(
 	buf = convert_arg(argv[1], bit_length);
 	if (!buf) {
 		dbprintf(_("unable to convert value '%s'.\n"), argv[1]);
+		flist_free(fl);
 		return;
 	}
 
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
