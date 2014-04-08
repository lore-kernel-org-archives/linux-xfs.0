Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 207BA8131
	for <xfs@oss.sgi.com>; Tue,  8 Apr 2014 18:27:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 19D0F8F8081
	for <xfs@oss.sgi.com>; Tue,  8 Apr 2014 16:26:54 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id siocwZOc8k1r0l9k for <xfs@oss.sgi.com>;
	Tue, 08 Apr 2014 16:26:37 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 10/14] xfsprogs: fix too-large memset value in xfs_db's attr
	code
Date: Tue,  8 Apr 2014 18:25:00 -0500
Message-Id: <1396999504-13769-11-git-send-email-sandeen@redhat.com>
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

	memset(value, 0xfeedface, valuelen);

seemed to be trying to fill a new attr with some
recognizeable magic, but of course memset can
only set a single byte; switch this to use 'v'

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 db/attrset.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/db/attrset.c b/db/attrset.c
index 75be72e..762b3bf 100644
--- a/db/attrset.c
+++ b/db/attrset.c
@@ -146,7 +146,7 @@ attr_set_f(
 			dbprintf(_("cannot allocate buffer (%d)\n"), valuelen);
 			goto out;
 		}
-		memset(value, 0xfeedface, valuelen);
+		memset(value, 'v', valuelen);
 	} else {
 		value = NULL;
 	}
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
