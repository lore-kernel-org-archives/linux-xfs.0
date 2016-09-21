Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 777E67CA0
	for <xfs@oss.sgi.com>; Wed, 21 Sep 2016 12:53:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3C39B8F8040
	for <xfs@oss.sgi.com>; Wed, 21 Sep 2016 10:53:00 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 2oDIBTMG1lsfHLEE (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 21 Sep 2016 10:52:58 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs_repair: fix segfault from uninitialized tp in mv_orphanage
Message-ID: <bb6c5861-23eb-dbd9-bf47-393c9445c9a2@redhat.com>
Date: Wed, 21 Sep 2016 12:52:56 -0500
MIME-Version: 1.0
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
To: linux-xfs@vger.kernel.org
Cc: Consigliere <admin@russenmafia.at>, xfs-oss <xfs@oss.sgi.com>

After 9074815 xfs: better xfs_trans_alloc interface, mv_orphanage
was passing an uninitialized *tp into libxfs_dir_lookup, because
the trans_alloc() call which was present prior to the call got
removed in that commit.

This ultimately led to testing an uninit tp var:

Conditional jump or move depends on uninitialised value(s)
   at 0x434D01: libxfs_trans_read_buf_map (trans.c:554)
   by 0x45152E: libxfs_da_read_buf (xfs_da_btree.c:2610)
   by 0x456ACB: xfs_dir3_block_read (xfs_dir2_block.c:136)
   by 0x4570A8: xfs_dir2_block_lookup_int (xfs_dir2_block.c:675)
   by 0x457DB7: xfs_dir2_block_lookup (xfs_dir2_block.c:623)
   by 0x455F54: libxfs_dir_lookup (xfs_dir2.c:399)
   by 0x421C46: mv_orphanage (phase6.c:1095)
   by 0x4222C2: check_for_orphaned_inodes (phase6.c:3108)
   by 0x423ABD: phase6 (phase6.c:3287)
   by 0x42E4B2: main (xfs_repair.c:933)

and ended with a segfault as we tried to use that tp when
searching for the buffer in xfs_trans_buf_item_match():

        list_for_each_entry(lidp, &tp->t_items, lid_trans) {

I think simply passing in NULL for this tp is sufficient to fix
this; we'll just go read the buffer from disk in
libxfs_trans_read_buf_map rather than trying to find it in an
existing transaction.

Reported-by: Consigliere <admin@russenmafia.at>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/repair/phase6.c b/repair/phase6.c
index 973a5f8..5507af4 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1092,7 +1092,7 @@ mv_orphanage(
 					irec->ino_startnum;
 		nres = XFS_DIRENTER_SPACE_RES(mp, fnamelen) +
 		       XFS_DIRENTER_SPACE_RES(mp, 2);
-		err = -libxfs_dir_lookup(tp, ino_p, &xfs_name_dotdot,
+		err = -libxfs_dir_lookup(NULL, ino_p, &xfs_name_dotdot,
 					&entry_ino_num, NULL);
 		if (err) {
 			ASSERT(err == ENOENT);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
