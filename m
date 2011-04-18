Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3ICe4Hb251588 for <xfs@oss.sgi.com>; Mon, 18 Apr 2011 07:40:04 -0500
Received: from mail-vw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D33B63ED5A3
	for <xfs@oss.sgi.com>; Mon, 18 Apr 2011 05:43:29 -0700 (PDT)
Received: from mail-vw0-f53.google.com (mail-vw0-f53.google.com
	[209.85.212.53]) by cuda.sgi.com with ESMTP id zBepIaR8t3pTolWS
	for <xfs@oss.sgi.com>; Mon, 18 Apr 2011 05:43:29 -0700 (PDT)
Received: by vws13 with SMTP id 13so4863570vws.26
	for <xfs@oss.sgi.com>; Mon, 18 Apr 2011 05:43:28 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 18 Apr 2011 18:13:28 +0530
Message-ID: <BANLkTikBSadR7K2RfiS2k60nEOPncaDfyw@mail.gmail.com>
Subject: [patch] xfsprogs: fixes a regression hang in xfs_repair phase 4
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

xfsprogs: fixes a regression hang in xfs_repair phase 4

Hang in phase 4 of xfs_repair (This hang is not easily reproducable),
that occur because of corruption in btree that xfs_repair uses.
Scenerio: This problem was in for loop of phase4.c:phase4():line 232
that never completes that reason was that in a very rare scenerio the
btree get corrupted so that the key in current node is greater than
the next node.

ex: current key = 2894 next key = 2880, and evaluate the for loop when j=2894
for (j = ag_hdr_block; j < ag_end; j += blen) {
        bstate = get_bmap_ext(i, j, ag_end, &blen);
}

get_bmap_ext() with j=2894 will return blen=-14
j += blen -> j=2880
get_bmap_ext() with j=2880 will return blen=14
j += blen -> j=2894
endless toggeling to j

Solution: btree for fast performance caches the last accessed node at each
level in struct btree_cursor during btree_search, it will research the new
key in btree only if the given condition fails

if (root->keys_valid && key <= root->cur_key && (!root->prev_value ||
key > root->prev_key))

Now consider the case: 2684 3552 3554
A> cur_key=3552 and prev_key=2684
B> In btree 3552 key is updated to 2880 with btree_update_key() but the cache is
   not invalidated therefore cur_key=3552 still.
C> Insert a new key in btree=2894 with btree_insert()
   btree_insert() first calls the btree_search() to get the correct
node to insert
   the new key 2894 but since above if condition is still true it will
not research
   the btree and will insert new key node between 2684 2894 3552 3554,
but in reality
   cur_key=3552 is pointing to key=2880 which is less than 2894, so
the btree get
   corrupted to 2684 2894 2880 3554.
D> Solution would be to invalidate cache after updating the old
key=3552 to new key=2880,
   so that btree_search() researches in that case 2894 will be
inserted after 2880,
   i.e 2684 2880 2894 3554.
   or
E> Update the cache cur_key=new key this would be better in term of performance
   as it will prevent researching of btree during next btree_search().
F> The btree was corrupted in phase 3 but hang was produced in phase 4.

Signed-off-by: Ajeet Yadav <ajeet.yadav.77@gmail.com>

diff -Nurp xfsprogs-3.1.5/repair/btree.c xfsprogs-3.1.5-dirty/repair/btree.c
--- xfsprogs-3.1.5/repair/btree.c       2011-03-31 12:11:25.000000000 +0900
+++ xfsprogs-3.1.5-dirty/repair/btree.c 2011-04-17 16:04:14.000000000 +0900
@@ -520,6 +520,7 @@ btree_update_key(
                return EINVAL;

        btree_update_node_key(root, root->cursor, 0, new_key);
+       root->cur_key = new_key;

        return 0;
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
