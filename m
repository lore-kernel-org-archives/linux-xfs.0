Return-Path: <SRS0=kcSc=DG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71C26C4727C
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Sep 2020 15:35:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 087B3207C4
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Sep 2020 15:35:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GwOrZff7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728396AbgI2PfM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Sep 2020 11:35:12 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42842 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727864AbgI2PfM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Sep 2020 11:35:12 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08TFT3NT166389;
        Tue, 29 Sep 2020 15:35:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=6dc2RMuxVznNc6DR74+tU5ToZ4dHbTynagsYOzkXgHc=;
 b=GwOrZff7O84EHX8194RTXtIJ6JSU8Ho0ZD7ZllIOsHZ+2eOElZOmVb5hWtEnXoOUUxx/
 VeVOZJHerIdJHkt3uSr3co9xA6ka8svtr2gq7tDVuMeu0/3m2N9pRpqTNC8Sy6x4jHxE
 yd1TztGK7kKgicFYGx2z4ld7jIemDVlNd/GkYfnKX55cAr/+4Ic8KaVA57Gmv8WgsUEt
 cNeq/fJMrjFpb9HwqbygVNr+U1Wt79mXlx3dL59JG3P5ChQrszxYbPokcTjWYQVfBvJB
 2NFQFDVsnuBXRnYiv5kshbtVw6hN9gKnKlJjv1zr7VJxnYHwb/UhRa1nQdkqZ0dastU0 kg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 33sx9n3k4c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 29 Sep 2020 15:35:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08TFUQs9015136;
        Tue, 29 Sep 2020 15:35:06 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 33tfhxtnp8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Sep 2020 15:35:06 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08TFZ5wF021045;
        Tue, 29 Sep 2020 15:35:06 GMT
Received: from localhost (/10.159.140.96)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 29 Sep 2020 08:35:05 -0700
Date:   Tue, 29 Sep 2020 08:35:05 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v2 6/7] xfs_repair: throw away totally bad clusters
Message-ID: <20200929153505.GH49547@magnolia>
References: <159950111751.567790.16914248540507629904.stgit@magnolia>
 <159950115513.567790.16525509399719506379.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159950115513.567790.16525509399719506379.stgit@magnolia>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9759 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 malwarescore=0 adultscore=0 suspectscore=10 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009290135
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9759 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=10
 phishscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015
 spamscore=0 impostorscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009290135
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
v2: drop repair/rmap.c paste error
---
 repair/dino_chunks.c |   35 ++++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

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
