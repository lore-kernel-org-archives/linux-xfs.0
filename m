Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 919E07F5F
	for <xfs@oss.sgi.com>; Fri,  7 Jun 2013 07:25:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 61F558F8059
	for <xfs@oss.sgi.com>; Fri,  7 Jun 2013 05:25:17 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	D1iewnMs6I6vx2br for <xfs@oss.sgi.com>;
	Fri, 07 Jun 2013 05:25:15 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UkvjG-0005TD-IZ
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 22:25:14 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Ukvj6-00031G-FI
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 22:25:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 06/12] xfs: remote attribute read too short
Date: Fri,  7 Jun 2013 22:24:55 +1000
Message-Id: <1370607901-11538-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1370607901-11538-1-git-send-email-david@fromorbit.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<1370607901-11538-1-git-send-email-david@fromorbit.com>
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
 libxfs/xfs_attr_remote.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index 09a168b..b9b2b50 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -29,9 +29,11 @@ xfs_attr3_rmt_blocks(
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
@@ -183,8 +185,9 @@ xfs_attr_rmtval_get(
 
 	while (valuelen > 0) {
 		nmap = ATTR_RMTVALUE_MAPSIZE;
+		blkcnt = xfs_attr3_rmt_blocks(mp, valuelen);
 		error = xfs_bmapi_read(args->dp, (xfs_fileoff_t)lblkno,
-				       args->rmtblkcnt, map, &nmap,
+				       blkcnt, map, &nmap,
 				       XFS_BMAPI_ATTRFORK);
 		if (error)
 			return error;
@@ -204,8 +207,8 @@ xfs_attr_rmtval_get(
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
