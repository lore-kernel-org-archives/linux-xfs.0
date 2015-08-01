Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D11887F54
	for <xfs@oss.sgi.com>; Sat,  1 Aug 2015 01:02:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8FA8D8F8035
	for <xfs@oss.sgi.com>; Fri, 31 Jul 2015 23:02:03 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id zJKHyERI8NXJeUHh (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 31 Jul 2015 23:02:02 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id 34768A0B68
	for <xfs@oss.sgi.com>; Sat,  1 Aug 2015 06:02:02 +0000 (UTC)
Received: from Liberator.local (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t7161xNE024886
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Sat, 1 Aug 2015 02:02:01 -0400
Message-ID: <55BC60D7.4020102@redhat.com>
Date: Fri, 31 Jul 2015 23:01:59 -0700
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: xfs_repair: Fix malloc size of rt_ext_tree_ptr (harmless)
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
To: xfs-oss <xfs@oss.sgi.com>

rt_ext_tree_ptr points to an avl64tree_desc_t, but we malloc memory
according to the size of avltree_desc_t.  Oddly, the latter happens
to be larger, so we're ok, but may as well make it correct.

Addresses-Coverity-Id: 1297533
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

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
