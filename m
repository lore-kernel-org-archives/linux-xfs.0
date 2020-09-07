Return-Path: <SRS0=54lF=CQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BB09C433E2
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Sep 2020 17:54:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E08672080A
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Sep 2020 17:54:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NbzZt7sv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729212AbgIGRyG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Sep 2020 13:54:06 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:41594 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729207AbgIGRyB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Sep 2020 13:54:01 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 087HnAlM188301;
        Mon, 7 Sep 2020 17:53:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=BhXAtdgYqRwzYD8gAou3JGotC3hO+ycaWdjIm1S5xqQ=;
 b=NbzZt7sv066e/woFNxVDYOSs7S16FuoIEC918Mjn4mv00rvMXYdeQ+G6V7aQ6VN+iaDS
 7+7rTbhxAXZTkiIDyR9zXlGYannFMmvShuvLkX6tmmEfxFPdFlDub28HVfRU+JgDB+3S
 SnqoyORjNXwNL/Mums9ssUNPElF3WIPm1YJXOfPD/U83MTjb36qiDtve+M1i+zOLc8t+
 /CXw+fMdwXTQSl6ITHVfr7O4SoA5JXS6+LXH9LMp9+dM9B3O/VjI3UVM8JP+6OhlbfBF
 7MFDmHQXGZz5cOO+MhG+QgtYfsNrCAx9ddWyq35Cx8Tiw51FwWJCqu0d92IZEpxaPP5T MQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 33c23qqn9w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 07 Sep 2020 17:53:59 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 087Hov3e017171;
        Mon, 7 Sep 2020 17:53:58 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 33cmk15p1j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Sep 2020 17:53:58 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 087Hrv8g006941;
        Mon, 7 Sep 2020 17:53:57 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Sep 2020 10:52:36 -0700
Subject: [PATCH 6/7] xfs_repair: throw away totally bad clusters
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 07 Sep 2020 10:52:35 -0700
Message-ID: <159950115513.567790.16525509399719506379.stgit@magnolia>
In-Reply-To: <159950111751.567790.16914248540507629904.stgit@magnolia>
References: <159950111751.567790.16914248540507629904.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9737 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 mlxscore=0 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009070171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9737 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 mlxlogscore=999 mlxscore=0 bulkscore=0 suspectscore=2 spamscore=0
 malwarescore=0 phishscore=0 lowpriorityscore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009070171
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If the filesystem supports sparse inodes, we detect that an entire
cluster buffer has no detectable inodes at all, and we can easily mark
that part of the inode chunk sparse, just drop the cluster buffer and
forget about it.  This makes repair less likely to go to great lengths
to try to save something that's totally unsalvageable.

This manifested in recs[2].free=zeroes in xfs/364, wherein the root
directory claimed to own block X and the inobt also claimed that X was
inodes; repair tried to create rmaps for both owners, and then the whole
mess blew up because the rmap code aborts on those kinds of anomalies.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/dino_chunks.c |   35 ++++++++++++++++++++++++++++++++++-
 repair/rmap.c        |    1 +
 2 files changed, 35 insertions(+), 1 deletion(-)


diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index 50a2003614df..e4a95ff635c8 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -601,6 +601,7 @@ process_inode_chunk(
 	xfs_dinode_t		*dino;
 	int			icnt;
 	int			status;
+	int			bp_found;
 	int			is_used;
 	int			ino_dirty;
 	int			irec_offset;
@@ -614,6 +615,7 @@ process_inode_chunk(
 	int			bp_index;
 	int			cluster_offset;
 	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
+	bool			can_punch_sparse = false;
 	int			error;
 
 	ASSERT(first_irec != NULL);
@@ -626,6 +628,10 @@ process_inode_chunk(
 	if (cluster_count == 0)
 		cluster_count = 1;
 
+	if (xfs_sb_version_hassparseinodes(&mp->m_sb) &&
+	    M_IGEO(mp)->inodes_per_cluster >= XFS_INODES_PER_HOLEMASK_BIT)
+		can_punch_sparse = true;
+
 	/*
 	 * get all blocks required to read in this chunk (may wind up
 	 * having to process more chunks in a multi-chunk per block fs)
@@ -700,6 +706,7 @@ process_inode_chunk(
 	cluster_offset = 0;
 	icnt = 0;
 	status = 0;
+	bp_found = 0;
 	bp_index = 0;
 
 	/*
@@ -725,8 +732,10 @@ process_inode_chunk(
 						(agno == 0 &&
 						(mp->m_sb.sb_rootino == agino ||
 						 mp->m_sb.sb_rsumino == agino ||
-						 mp->m_sb.sb_rbmino == agino)))
+						 mp->m_sb.sb_rbmino == agino))) {
 					status++;
+					bp_found++;
+				}
 			}
 
 			irec_offset++;
@@ -749,11 +758,35 @@ process_inode_chunk(
 				irec_offset = 0;
 			}
 			if (cluster_offset == M_IGEO(mp)->inodes_per_cluster) {
+				if (can_punch_sparse &&
+				    bplist[bp_index] != NULL &&
+				    bp_found == 0) {
+					/*
+					 * We didn't find any good inodes in
+					 * this cluster, blow it away before
+					 * moving on to the next one.
+					 */
+					libxfs_buf_relse(bplist[bp_index]);
+					bplist[bp_index] = NULL;
+				}
 				bp_index++;
 				cluster_offset = 0;
+				bp_found = 0;
 			}
 		}
 
+		if (can_punch_sparse &&
+		    bp_index < cluster_count &&
+		    bplist[bp_index] != NULL &&
+		    bp_found == 0) {
+			/*
+			 * We didn't find any good inodes in this cluster, blow
+			 * it away.
+			 */
+			libxfs_buf_relse(bplist[bp_index]);
+			bplist[bp_index] = NULL;
+		}
+
 		/*
 		 * if chunk/block is bad, blow it off.  the inode records
 		 * will be deleted by the caller if appropriate.
diff --git a/repair/rmap.c b/repair/rmap.c
index a4cc6a4937c9..98d2f46fa047 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -399,6 +399,7 @@ rmap_add_fixed_ag_rec(
 			nr = 1;
 		agino = ino_rec->ino_startnum + startidx;
 		agbno = XFS_AGINO_TO_AGBNO(mp, agino);
+		ASSERT(get_bmap(agno, agbno) == XR_E_INO);
 		if (XFS_AGINO_TO_OFFSET(mp, agino) == 0) {
 			error = rmap_add_ag_rec(mp, agno, agbno, nr,
 					XFS_RMAP_OWN_INODES);

