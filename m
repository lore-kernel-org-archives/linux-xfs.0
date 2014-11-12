Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3C0987F63
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2014 12:57:25 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2A43D8F8039
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2014 10:57:25 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id g1QcsMuDFMFGEs2k for <xfs@oss.sgi.com>;
	Wed, 12 Nov 2014 10:57:22 -0800 (PST)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 8/9] xfsdump: children[] is an array of child pointers,
	not of child structures
Date: Wed, 12 Nov 2014 12:57:17 -0600
Message-Id: <1415818638-32700-9-git-send-email-sandeen@redhat.com>
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

node_t      **children;     /* child nodes */

so allocating space to hold nbr_children structures is wrong;
we need to hold nbr_children _pointers_ to child structures.

It's over-allocating, so it's relatively harmless.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 invutil/list.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/invutil/list.c b/invutil/list.c
index 0157102..599e6af 100644
--- a/invutil/list.c
+++ b/invutil/list.c
@@ -34,7 +34,7 @@ parent_add_child(node_t *parent, node_t *child)
     d = parent->data;
 
     d->nbr_children++;
-    d->children = realloc(d->children, d->nbr_children * sizeof(*child));
+    d->children = realloc(d->children, d->nbr_children * sizeof(node_t *));
     d->children[d->nbr_children - 1] = child;
 
     return parent;
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
