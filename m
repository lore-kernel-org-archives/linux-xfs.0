Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 573F47CBF
	for <linux-xfs@oss.sgi.com>; Wed, 31 Jul 2013 20:19:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C0A43AC003
	for <linux-xfs@oss.sgi.com>; Wed, 31 Jul 2013 18:19:00 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id lp7FHfFGKWlxeiGo for
	<linux-xfs@oss.sgi.com>; Wed, 31 Jul 2013 18:18:57 -0700 (PDT)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r711It9a014112
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-xfs@oss.sgi.com>; Wed, 31 Jul 2013 21:18:56 -0400
Received: from Liberator.local (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r711Is3I025998
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-xfs@oss.sgi.com>; Wed, 31 Jul 2013 21:18:55 -0400
Message-ID: <51F9B77E.2030005@redhat.com>
Date: Wed, 31 Jul 2013 20:18:54 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: avoid double-free in xfs_attr_node_addname
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
To: "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>

xfs_attr_node_addname()'s error handling tests whether it
should free "state" in the out: error handling label:

out:
        if (state)
                xfs_da_state_free(state);

but an earlier free doesn't set state to NULL afterwards; this
could lead to a double free.  Fix it by setting state to NULL
after it's freed.

This was found by Coverity.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Note: Exact same patch should hit xfsprogs - I could send another,
or maybe SGI can just apply it in both trees?

Thanks,
-Eric

diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
index 20fe3fe..aaff8a9 100644
--- a/fs/xfs/xfs_attr.c
+++ b/fs/xfs/xfs_attr.c
@@ -1260,6 +1260,7 @@ restart:
 			 * have been a b-tree.
 			 */
 			xfs_da_state_free(state);
+			state = NULL;
 			xfs_bmap_init(args->flist, args->firstblock);
 			error = xfs_attr3_leaf_to_node(args);
 			if (!error) {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
