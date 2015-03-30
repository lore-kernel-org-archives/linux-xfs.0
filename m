Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 018AE7F3F
	for <xfs@oss.sgi.com>; Mon, 30 Mar 2015 09:53:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D295E8F8037
	for <xfs@oss.sgi.com>; Mon, 30 Mar 2015 07:53:29 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id vjj0rJjpc1DCkJdB (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 30 Mar 2015 07:53:28 -0700 (PDT)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfsprogs/repair: only check secondary sb->sb_pquotino for v5
	superblocks
Date: Mon, 30 Mar 2015 10:53:26 -0400
Message-Id: <1427727206-14280-1-git-send-email-bfoster@redhat.com>
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
Cc: gux.fnst@cn.fujitsu.com

xfs_repair scans for garbage data beyond the last valid superblock field
for the particular sb version in secondary_sb_wack(). If any non-zero
data is detected, the entire range is reset to zero. Subsequently,
various valid superblock fields are checked for valid/expected data.

The sb_pquotino field is checked unconditionally as part of this
sequence even though it is a v5 only field. As a result, repair
complains about a non-null project quota field if any garbage data
exists for a v4 secondary sb. This is reproduced by xfs/070 against a v4
superblock and is also easily reproduced manually as follows:

$ mkfs.xfs -f -m crc=0 <dev>
$ xfs_db -x -c "sb 3" -c "write lsn 1" <dev>
$ xfs_repair <dev>
...
zeroing unused portion of secondary superblock (AG #3)
non-null project quota inode field in superblock 3
...

This occurs because the garbage data detection mechanism has reset
sb->sb_pquotino to 0 while the validity check expects a value of
NULLFSINO.

Update secondary_sb_wack() to only check sb->sb_pquotino for validity on
supers where it is a valid field. If it is anything other than 0 on
pre-v5 superblocks, it is explicitly reset to 0 by the garbage data
checks earlier in the function.

Reported-by: Xing Gu <gux.fnst@cn.fujitsu.com>
Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 repair/agheader.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/repair/agheader.c b/repair/agheader.c
index 416dbd8..5dbf992 100644
--- a/repair/agheader.c
+++ b/repair/agheader.c
@@ -377,7 +377,13 @@ secondary_sb_wack(
 			rval |= XR_AG_SB_SEC;
 	}
 
-	if (sb->sb_inprogress == 1 && sb->sb_pquotino != NULLFSINO)  {
+	/*
+	 * Note that sb_pquotino is not considered a valid sb field for pre-v5
+	 * superblocks. If it is anything other than 0 it is considered garbage
+	 * data beyond the valid sb and explicitly zeroed above.
+	 */
+	if (xfs_sb_version_has_pquotino(&mp->m_sb) &&
+	    sb->sb_inprogress == 1 && sb->sb_pquotino != NULLFSINO)  {
 		if (!no_modify) {
 			sb->sb_pquotino = 0;
 			dsb->sb_pquotino = 0;
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
