Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 97ED17F6B
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 19:26:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 69B8F30408A
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 17:26:36 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Me8O1NVZSjPLdhUO for <xfs@oss.sgi.com>;
	Thu, 06 Jun 2013 17:26:34 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UkkVg-0003uF-TI
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 10:26:28 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UkkVb-0001Jm-Q6
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 10:26:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 05/48] xfsprogs: Support new AGFL format
Date: Fri,  7 Jun 2013 10:25:28 +1000
Message-Id: <1370564771-4929-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1370564771-4929-1-git-send-email-david@fromorbit.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
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

With the addition of CRCs to the filesystem format, the AGFL has a
new format structure definition. Existing code that pulls freelist
blocks out via dereferencing agfl->agfl_bno no longer works as the
location of the free list is now variable depending on the disk
format in use.

Hence all the users of agfl_bno need ot be converted to extract the
location of the first free list entry from the AGFL and grab entries
relative to that first entry. It's a simple change, but needs to be
made in several places as there is very little code reuse within and
between the different utilities in xfsprogs.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 db/check.c      |    6 +++++-
 db/freesp.c     |    7 ++++++-
 repair/phase5.c |    6 ++++--
 repair/scan.c   |    6 +++---
 4 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/db/check.c b/db/check.c
index 353530b..127e407 100644
--- a/db/check.c
+++ b/db/check.c
@@ -3806,6 +3806,7 @@ scan_freelist(
 	xfs_agblock_t	bno;
 	uint		count;
 	int		i;
+	__be32		*freelist;
 
 	if (XFS_SB_BLOCK(mp) != XFS_AGFL_BLOCK(mp) &&
 	    XFS_AGF_BLOCK(mp) != XFS_AGFL_BLOCK(mp) &&
@@ -3835,9 +3836,12 @@ scan_freelist(
 		return;
 	}
 
+	/* open coded XFS_BUF_TO_AGFL_BNO */
+	freelist = xfs_sb_version_hascrc(&((mp)->m_sb)) ? &agfl->agfl_bno[0]
+							: (__be32 *)agfl;
 	count = 0;
 	for (;;) {
-		bno = be32_to_cpu(agfl->agfl_bno[i]);
+		bno = be32_to_cpu(freelist[i]);
 		set_dbmap(seqno, bno, 1, DBM_FREELIST, seqno,
 			XFS_AGFL_BLOCK(mp));
 		count++;
diff --git a/db/freesp.c b/db/freesp.c
index 472b1f7..228ca07 100644
--- a/db/freesp.c
+++ b/db/freesp.c
@@ -231,6 +231,7 @@ scan_freelist(
 	xfs_agfl_t	*agfl;
 	xfs_agblock_t	bno;
 	int		i;
+	__be32		*agfl_bno;
 
 	if (be32_to_cpu(agf->agf_flcount) == 0)
 		return;
@@ -240,6 +241,10 @@ scan_freelist(
 	agfl = iocur_top->data;
 	i = be32_to_cpu(agf->agf_flfirst);
 
+	/* open coded XFS_BUF_TO_AGFL_BNO */
+	agfl_bno = xfs_sb_version_hascrc(&mp->m_sb) ? &agfl->agfl_bno[0]
+						   : (__be32 *)agfl;
+
 	/* verify agf values before proceeding */
 	if (be32_to_cpu(agf->agf_flfirst) >= XFS_AGFL_SIZE(mp) ||
 	    be32_to_cpu(agf->agf_fllast) >= XFS_AGFL_SIZE(mp)) {
@@ -250,7 +255,7 @@ scan_freelist(
 	}
 
 	for (;;) {
-		bno = be32_to_cpu(agfl->agfl_bno[i]);
+		bno = be32_to_cpu(agfl_bno[i]);
 		addtohist(seqno, bno, 1);
 		if (i == be32_to_cpu(agf->agf_fllast))
 			break;
diff --git a/repair/phase5.c b/repair/phase5.c
index 1f71cac..c7cef4f 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -1208,6 +1208,7 @@ build_agf_agfl(xfs_mount_t	*mp,
 	int			j;
 	xfs_agfl_t		*agfl;
 	xfs_agf_t		*agf;
+	__be32			*freelist;
 
 	agf_buf = libxfs_getbuf(mp->m_dev,
 			XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
@@ -1277,19 +1278,20 @@ build_agf_agfl(xfs_mount_t	*mp,
 				XFS_AG_DADDR(mp, agno, XFS_AGFL_DADDR(mp)),
 				mp->m_sb.sb_sectsize/BBSIZE);
 		agfl = XFS_BUF_TO_AGFL(agfl_buf);
+		freelist = XFS_BUF_TO_AGFL_BNO(mp, agfl_buf);
 		memset(agfl, 0, mp->m_sb.sb_sectsize);
 		/*
 		 * ok, now grab as many blocks as we can
 		 */
 		i = j = 0;
 		while (bno_bt->num_free_blocks > 0 && i < XFS_AGFL_SIZE(mp))  {
-			agfl->agfl_bno[i] = cpu_to_be32(
+			freelist[i] = cpu_to_be32(
 					get_next_blockaddr(agno, 0, bno_bt));
 			i++;
 		}
 
 		while (bcnt_bt->num_free_blocks > 0 && i < XFS_AGFL_SIZE(mp))  {
-			agfl->agfl_bno[i] = cpu_to_be32(
+			freelist[i] = cpu_to_be32(
 					get_next_blockaddr(agno, 0, bcnt_bt));
 			i++;
 		}
diff --git a/repair/scan.c b/repair/scan.c
index 76bb7f1..f79342a 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -1041,12 +1041,12 @@ scan_freelist(
 	xfs_agf_t	*agf,
 	struct aghdr_cnts *agcnts)
 {
-	xfs_agfl_t	*agfl;
 	xfs_buf_t	*agflbuf;
 	xfs_agnumber_t	agno;
 	xfs_agblock_t	bno;
 	int		count;
 	int		i;
+	__be32		*freelist;
 
 	agno = be32_to_cpu(agf->agf_seqno);
 
@@ -1065,7 +1065,7 @@ scan_freelist(
 		do_abort(_("can't read agfl block for ag %d\n"), agno);
 		return;
 	}
-	agfl = XFS_BUF_TO_AGFL(agflbuf);
+	freelist = XFS_BUF_TO_AGFL_BNO(mp, agflbuf);
 	i = be32_to_cpu(agf->agf_flfirst);
 
 	if (no_modify) {
@@ -1080,7 +1080,7 @@ scan_freelist(
 
 	count = 0;
 	for (;;) {
-		bno = be32_to_cpu(agfl->agfl_bno[i]);
+		bno = be32_to_cpu(freelist[i]);
 		if (verify_agbno(mp, agno, bno))
 			set_bmap(agno, bno, XR_E_FREE);
 		else
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
