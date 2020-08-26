Return-Path: <SRS0=J8xT=CE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A4CAC433E1
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 22:05:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F24C42087C
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 22:05:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PGxmP4LG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbgHZWFl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Aug 2020 18:05:41 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52698 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726753AbgHZWFk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Aug 2020 18:05:40 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07QM04k0028625;
        Wed, 26 Aug 2020 22:05:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=SUz1iNMnXhqfF8ld9OUqWIqec+y1O4E8vv1miqf/bEw=;
 b=PGxmP4LGHY8UUW+BjdtUjyt4W4ZpNQ1JtZtESLi3DtCsEr6/UjkVIzCcyUjLcWCGusVy
 Jr4wffxXY/HUBuTsMaxb+ZU1UJcjwa2+aqu7bLGGL/K06m4I6bmefbPLmzgAnWiq5wOM
 bm6ug5+uu6OTVd23VREE4I2yW7SPN2WBUi5/M++Mwupn6vpjpmPI42/PYgCTQjpAShta
 rYpmKvXr700a50xM/h4EW9zdtysMSLAau/6BdGM7cWnz1T3sCwlY+lq3Z5aNUaWP3DAS
 YKMlNs7psnavje66tnB/ffBjQrkJ2oRMJ9zK4IXAfG6eT/lWpLZDVH35+BUpLgxasIn9 ig== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 333dbs31k9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 26 Aug 2020 22:05:34 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07QM5NOU117595;
        Wed, 26 Aug 2020 22:05:34 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 333r9mfvcg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Aug 2020 22:05:33 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07QM5VWh001646;
        Wed, 26 Aug 2020 22:05:31 GMT
Received: from localhost (/10.159.146.4)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Aug 2020 15:05:31 -0700
Subject: [PATCH 05/11] xfs: move xfs_log_dinode_to_disk to the log recovery
 code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, david@fromorbit.com, hch@infradead.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com, sandeen@sandeen.net
Date:   Wed, 26 Aug 2020 15:05:30 -0700
Message-ID: <159847953041.2601708.2391074537438610709.stgit@magnolia>
In-Reply-To: <159847949739.2601708.16579235017313836378.stgit@magnolia>
References: <159847949739.2601708.16579235017313836378.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008260170
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008260169
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move this function to xfs_inode_item_recover.c since there's only one
caller of it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c   |   52 ---------------------------------------
 fs/xfs/libxfs/xfs_inode_buf.h   |    2 --
 fs/xfs/xfs_inode_item_recover.c |   52 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 52 insertions(+), 54 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 8d5dd08eab75..fa83591ca89b 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -310,58 +310,6 @@ xfs_inode_to_disk(
 	}
 }
 
-void
-xfs_log_dinode_to_disk(
-	struct xfs_log_dinode	*from,
-	struct xfs_dinode	*to)
-{
-	to->di_magic = cpu_to_be16(from->di_magic);
-	to->di_mode = cpu_to_be16(from->di_mode);
-	to->di_version = from->di_version;
-	to->di_format = from->di_format;
-	to->di_onlink = 0;
-	to->di_uid = cpu_to_be32(from->di_uid);
-	to->di_gid = cpu_to_be32(from->di_gid);
-	to->di_nlink = cpu_to_be32(from->di_nlink);
-	to->di_projid_lo = cpu_to_be16(from->di_projid_lo);
-	to->di_projid_hi = cpu_to_be16(from->di_projid_hi);
-	memcpy(to->di_pad, from->di_pad, sizeof(to->di_pad));
-
-	to->di_atime.t_sec = cpu_to_be32(from->di_atime.t_sec);
-	to->di_atime.t_nsec = cpu_to_be32(from->di_atime.t_nsec);
-	to->di_mtime.t_sec = cpu_to_be32(from->di_mtime.t_sec);
-	to->di_mtime.t_nsec = cpu_to_be32(from->di_mtime.t_nsec);
-	to->di_ctime.t_sec = cpu_to_be32(from->di_ctime.t_sec);
-	to->di_ctime.t_nsec = cpu_to_be32(from->di_ctime.t_nsec);
-
-	to->di_size = cpu_to_be64(from->di_size);
-	to->di_nblocks = cpu_to_be64(from->di_nblocks);
-	to->di_extsize = cpu_to_be32(from->di_extsize);
-	to->di_nextents = cpu_to_be32(from->di_nextents);
-	to->di_anextents = cpu_to_be16(from->di_anextents);
-	to->di_forkoff = from->di_forkoff;
-	to->di_aformat = from->di_aformat;
-	to->di_dmevmask = cpu_to_be32(from->di_dmevmask);
-	to->di_dmstate = cpu_to_be16(from->di_dmstate);
-	to->di_flags = cpu_to_be16(from->di_flags);
-	to->di_gen = cpu_to_be32(from->di_gen);
-
-	if (from->di_version == 3) {
-		to->di_changecount = cpu_to_be64(from->di_changecount);
-		to->di_crtime.t_sec = cpu_to_be32(from->di_crtime.t_sec);
-		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.t_nsec);
-		to->di_flags2 = cpu_to_be64(from->di_flags2);
-		to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
-		to->di_ino = cpu_to_be64(from->di_ino);
-		to->di_lsn = cpu_to_be64(from->di_lsn);
-		memcpy(to->di_pad2, from->di_pad2, sizeof(to->di_pad2));
-		uuid_copy(&to->di_uuid, &from->di_uuid);
-		to->di_flushiter = 0;
-	} else {
-		to->di_flushiter = cpu_to_be16(from->di_flushiter);
-	}
-}
-
 static xfs_failaddr_t
 xfs_dinode_verify_fork(
 	struct xfs_dinode	*dip,
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index 6b08b9d060c2..89f7bea8efd6 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -49,8 +49,6 @@ void	xfs_dinode_calc_crc(struct xfs_mount *, struct xfs_dinode *);
 void	xfs_inode_to_disk(struct xfs_inode *ip, struct xfs_dinode *to,
 			  xfs_lsn_t lsn);
 int	xfs_inode_from_disk(struct xfs_inode *ip, struct xfs_dinode *from);
-void	xfs_log_dinode_to_disk(struct xfs_log_dinode *from,
-			       struct xfs_dinode *to);
 
 xfs_failaddr_t xfs_dinode_verify(struct xfs_mount *mp, xfs_ino_t ino,
 			   struct xfs_dinode *dip);
diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index 5e0d291835b3..1e417ace2912 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -115,6 +115,58 @@ xfs_recover_inode_owner_change(
 	return error;
 }
 
+STATIC void
+xfs_log_dinode_to_disk(
+	struct xfs_log_dinode	*from,
+	struct xfs_dinode	*to)
+{
+	to->di_magic = cpu_to_be16(from->di_magic);
+	to->di_mode = cpu_to_be16(from->di_mode);
+	to->di_version = from->di_version;
+	to->di_format = from->di_format;
+	to->di_onlink = 0;
+	to->di_uid = cpu_to_be32(from->di_uid);
+	to->di_gid = cpu_to_be32(from->di_gid);
+	to->di_nlink = cpu_to_be32(from->di_nlink);
+	to->di_projid_lo = cpu_to_be16(from->di_projid_lo);
+	to->di_projid_hi = cpu_to_be16(from->di_projid_hi);
+	memcpy(to->di_pad, from->di_pad, sizeof(to->di_pad));
+
+	to->di_atime.t_sec = cpu_to_be32(from->di_atime.t_sec);
+	to->di_atime.t_nsec = cpu_to_be32(from->di_atime.t_nsec);
+	to->di_mtime.t_sec = cpu_to_be32(from->di_mtime.t_sec);
+	to->di_mtime.t_nsec = cpu_to_be32(from->di_mtime.t_nsec);
+	to->di_ctime.t_sec = cpu_to_be32(from->di_ctime.t_sec);
+	to->di_ctime.t_nsec = cpu_to_be32(from->di_ctime.t_nsec);
+
+	to->di_size = cpu_to_be64(from->di_size);
+	to->di_nblocks = cpu_to_be64(from->di_nblocks);
+	to->di_extsize = cpu_to_be32(from->di_extsize);
+	to->di_nextents = cpu_to_be32(from->di_nextents);
+	to->di_anextents = cpu_to_be16(from->di_anextents);
+	to->di_forkoff = from->di_forkoff;
+	to->di_aformat = from->di_aformat;
+	to->di_dmevmask = cpu_to_be32(from->di_dmevmask);
+	to->di_dmstate = cpu_to_be16(from->di_dmstate);
+	to->di_flags = cpu_to_be16(from->di_flags);
+	to->di_gen = cpu_to_be32(from->di_gen);
+
+	if (from->di_version == 3) {
+		to->di_changecount = cpu_to_be64(from->di_changecount);
+		to->di_crtime.t_sec = cpu_to_be32(from->di_crtime.t_sec);
+		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.t_nsec);
+		to->di_flags2 = cpu_to_be64(from->di_flags2);
+		to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
+		to->di_ino = cpu_to_be64(from->di_ino);
+		to->di_lsn = cpu_to_be64(from->di_lsn);
+		memcpy(to->di_pad2, from->di_pad2, sizeof(to->di_pad2));
+		uuid_copy(&to->di_uuid, &from->di_uuid);
+		to->di_flushiter = 0;
+	} else {
+		to->di_flushiter = cpu_to_be16(from->di_flushiter);
+	}
+}
+
 STATIC int
 xlog_recover_inode_commit_pass2(
 	struct xlog			*log,

