Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 56E4D8118
	for <xfs@oss.sgi.com>; Tue,  8 Apr 2014 18:26:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4E64A8F8089
	for <xfs@oss.sgi.com>; Tue,  8 Apr 2014 16:26:47 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id UBMlr7aiEZenmB1l for <xfs@oss.sgi.com>;
	Tue, 08 Apr 2014 16:26:37 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 14/14] xfs_db: don't use invalid index in ring_f
Date: Tue,  8 Apr 2014 18:25:04 -0500
Message-Id: <1396999504-13769-15-git-send-email-sandeen@redhat.com>
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

ring_f() tests for an invalid index which would overrun the
iocur_ring[] array and warns, but then uses it anyway.

Return immediately if it's out of bounds.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 db/io.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/db/io.c b/db/io.c
index 9a787c8..6aba54e 100644
--- a/db/io.c
+++ b/db/io.c
@@ -358,8 +358,10 @@ ring_f(
 	}
 
 	index = (int)strtoul(argv[1], NULL, 0);
-	if (index < 0 || index >= RING_ENTRIES)
+	if (index < 0 || index >= RING_ENTRIES) {
 		dbprintf(_("invalid entry: %d\n"), index);
+		return 0;
+	}
 
 	ring_current = index;
 
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
