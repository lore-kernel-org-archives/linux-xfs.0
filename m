Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3EC547F62
	for <xfs@oss.sgi.com>; Sun,  2 Aug 2015 12:32:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 24DC9304064
	for <xfs@oss.sgi.com>; Sun,  2 Aug 2015 10:32:08 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 5PE2jk2DLGVOJUBO for <xfs@oss.sgi.com>;
	Sun, 02 Aug 2015 10:32:06 -0700 (PDT)
Message-ID: <55BE5413.4070106@sandeen.net>
Date: Sun, 02 Aug 2015 10:32:03 -0700
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfs_repair: Fix malloc size of rt_ext_tree_ptr (harmless)
References: <55BC60D7.4020102@redhat.com>
In-Reply-To: <55BC60D7.4020102@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

rt_ext_tree_ptr points to an avl64tree_desc_t, but we malloc memory
according to the size of avltree_desc_t.  Oddly, the latter happens
to be larger, so we're ok, but may as well make it correct.

Addresses-Coverity-Id: 1297533
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

(sorry, missed [PATCH] on the first one, durrr...)
Hm, I thought I sent this already, but don't see it on the list.

diff --git a/repair/incore_ext.c b/repair/incore_ext.c
index 826bf44..6611d5c 100644
--- a/repair/incore_ext.c
+++ b/repair/incore_ext.c
@@ -783,7 +783,7 @@ incore_ext_init(xfs_mount_t *mp)
 		avl_init_tree(extent_bcnt_ptrs[i], &avl_extent_bcnt_tree_ops);
 	}
 
-	if ((rt_ext_tree_ptr = malloc(sizeof(avltree_desc_t))) == NULL)
+	if ((rt_ext_tree_ptr = malloc(sizeof(avl64tree_desc_t))) == NULL)
 		do_error(_("couldn't malloc dup rt extent tree descriptor\n"));
 
 	avl64_init_tree(rt_ext_tree_ptr, &avl64_extent_tree_ops);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
