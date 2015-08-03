Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 418807F59
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 02:41:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2D1068F811E
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 00:41:16 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	rNdCVqIxlcwflGOc for <xfs@oss.sgi.com>;
	Mon, 03 Aug 2015 00:41:15 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1ZMAMH-0000AS-LR
	for xfs@oss.sgi.com; Mon, 03 Aug 2015 17:40:29 +1000
Received: from dave by disappointment with local (Exim 4.86_RC4)
	(envelope-from <dave@disappointment.disaster>) id 1ZMAMH-0008Cc-Km
	for xfs@oss.sgi.com; Mon, 03 Aug 2015 17:40:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/4] xfs: growfs not aware of sb_meta_uuid
Date: Mon,  3 Aug 2015 17:40:23 +1000
Message-Id: <1438587625-31437-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1438587625-31437-1-git-send-email-david@fromorbit.com>
References: <1438587625-31437-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Adding this simple change to xfstests:common/rc::_scratch_mkfs_xfs:

+       if [ $mkfs_status -eq 0 ]; then
+               xfs_admin -U generate $SCRATCH_DEV > /dev/null
+       fi

triggers all sorts of errors in xfstests. xfs/104 is an example,
where growfs fails with a UUID mismatch corruption detected by
xfs_agf_write_verify() when trying to write the first new AG
headers.

Fix this problem by making sure we copy the sb_meta_uuid into new
metadata written by growfs.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_fsops.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 9b3438a..ee3aaa0a 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -250,7 +250,7 @@ xfs_growfs_data_private(
 		agf->agf_freeblks = cpu_to_be32(tmpsize);
 		agf->agf_longest = cpu_to_be32(tmpsize);
 		if (xfs_sb_version_hascrc(&mp->m_sb))
-			uuid_copy(&agf->agf_uuid, &mp->m_sb.sb_uuid);
+			uuid_copy(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid);
 
 		error = xfs_bwrite(bp);
 		xfs_buf_relse(bp);
@@ -273,7 +273,7 @@ xfs_growfs_data_private(
 		if (xfs_sb_version_hascrc(&mp->m_sb)) {
 			agfl->agfl_magicnum = cpu_to_be32(XFS_AGFL_MAGIC);
 			agfl->agfl_seqno = cpu_to_be32(agno);
-			uuid_copy(&agfl->agfl_uuid, &mp->m_sb.sb_uuid);
+			uuid_copy(&agfl->agfl_uuid, &mp->m_sb.sb_meta_uuid);
 		}
 
 		agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, bp);
@@ -309,7 +309,7 @@ xfs_growfs_data_private(
 		agi->agi_newino = cpu_to_be32(NULLAGINO);
 		agi->agi_dirino = cpu_to_be32(NULLAGINO);
 		if (xfs_sb_version_hascrc(&mp->m_sb))
-			uuid_copy(&agi->agi_uuid, &mp->m_sb.sb_uuid);
+			uuid_copy(&agi->agi_uuid, &mp->m_sb.sb_meta_uuid);
 		if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
 			agi->agi_free_root = cpu_to_be32(XFS_FIBT_BLOCK(mp));
 			agi->agi_free_level = cpu_to_be32(1);
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
