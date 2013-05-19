Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5F7F229E10
	for <xfs@oss.sgi.com>; Sun, 19 May 2013 18:51:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 400AF304043
	for <xfs@oss.sgi.com>; Sun, 19 May 2013 16:51:49 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	IEkWIJUtCtH6APbA for <xfs@oss.sgi.com>;
	Sun, 19 May 2013 16:51:47 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UeDOC-00069w-SB
	for xfs@oss.sgi.com; Mon, 20 May 2013 09:51:44 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UeDO2-0003yy-Pd
	for xfs@oss.sgi.com; Mon, 20 May 2013 09:51:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 10/14] xfs: remote attribute read too short
Date: Mon, 20 May 2013 09:51:17 +1000
Message-Id: <1369007481-15185-11-git-send-email-david@fromorbit.com>
In-Reply-To: <1369007481-15185-1-git-send-email-david@fromorbit.com>
References: <1369007481-15185-1-git-send-email-david@fromorbit.com>
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

Reading a maximally size remote attribute fails when CRCs are
enabled with this verification error:

XFS (vdb): remote attribute header does not match required off/len/owner)

There are two reasons for this, the first being that the
length of the buffer being read is determined from the
args->rmtblkcnt which doesn't take into account CRC headers. Hence
the mapped length ends up being too short and so we need to
calculate it directly from the value length.

The second is that the byte count of valid data within a buffer is
capped by the length of the data and so doesn't take into account
that the buffer might be longer due to headers. Hence we need to
calculate the data space in the buffer first before calculating the
actual byte count of data.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_attr_remote.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_attr_remote.c b/fs/xfs/xfs_attr_remote.c
index aad95b0..bcdc07c 100644
--- a/fs/xfs/xfs_attr_remote.c
+++ b/fs/xfs/xfs_attr_remote.c
@@ -52,9 +52,11 @@ xfs_attr3_rmt_blocks(
 	struct xfs_mount *mp,
 	int		attrlen)
 {
-	int		buflen = XFS_ATTR3_RMT_BUF_SPACE(mp,
-							 mp->m_sb.sb_blocksize);
-	return (attrlen + buflen - 1) / buflen;
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		int buflen = XFS_ATTR3_RMT_BUF_SPACE(mp, mp->m_sb.sb_blocksize);
+		return (attrlen + buflen - 1) / buflen;
+	}
+	return XFS_B_TO_FSB(mp, attrlen);
 }
 
 static bool
@@ -206,8 +208,9 @@ xfs_attr_rmtval_get(
 
 	while (valuelen > 0) {
 		nmap = ATTR_RMTVALUE_MAPSIZE;
+		blkcnt = xfs_attr3_rmt_blocks(mp, valuelen);
 		error = xfs_bmapi_read(args->dp, (xfs_fileoff_t)lblkno,
-				       args->rmtblkcnt, map, &nmap,
+				       blkcnt, map, &nmap,
 				       XFS_BMAPI_ATTRFORK);
 		if (error)
 			return error;
@@ -227,8 +230,8 @@ xfs_attr_rmtval_get(
 			if (error)
 				return error;
 
-			byte_cnt = min_t(int, valuelen, BBTOB(bp->b_length));
-			byte_cnt = XFS_ATTR3_RMT_BUF_SPACE(mp, byte_cnt);
+			byte_cnt = XFS_ATTR3_RMT_BUF_SPACE(mp, BBTOB(bp->b_length));
+			byte_cnt = min_t(int, valuelen, byte_cnt);
 
 			src = bp->b_addr;
 			if (xfs_sb_version_hascrc(&mp->m_sb)) {
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
