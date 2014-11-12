Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 35E637F51
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2014 12:57:23 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 248B1304043
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2014 10:57:23 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id cF1w5IKX0jRwc7s1 for <xfs@oss.sgi.com>;
	Wed, 12 Nov 2014 10:57:21 -0800 (PST)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 4/9] xfsdump: remove pointless if (dirty);
Date: Wed, 12 Nov 2014 12:57:13 -0600
Message-Id: <1415818638-32700-5-git-send-email-sandeen@redhat.com>
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

"dirty" seems to be a remnant of unfinished code; other bits of
it are there but commented out, so comment out "if (dirty);" as
well, which is a no-op if statement which can't be true.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 inventory/inv_stobj.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/inventory/inv_stobj.c b/inventory/inv_stobj.c
index becac17..84b15d9 100644
--- a/inventory/inv_stobj.c
+++ b/inventory/inv_stobj.c
@@ -976,7 +976,9 @@ stobj_delete_mobj(int fd,
 
 		}
 		free ( mfiles );
+/*
 		if ( dirty );
+*/
 	}
 
 	free ( strms );
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
