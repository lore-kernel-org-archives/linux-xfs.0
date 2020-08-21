Return-Path: <SRS0=59Ki=B7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DF2AC433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Aug 2020 02:12:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7234D2076E
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Aug 2020 02:12:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="adRapxdv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbgHUCMJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Aug 2020 22:12:09 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34754 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726969AbgHUCMI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Aug 2020 22:12:08 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07L27fWk043518;
        Fri, 21 Aug 2020 02:12:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=n10cLa3N7Xa/HZmiHoO4zdgDXeug711Rw2tSVyzyDW8=;
 b=adRapxdvU2iaTX+WEHb++6KbfoViDZyfjkhFOZ9RahQjaKktF0v7lxF3as/dUW516hGA
 2YLqEAEbR7dWcrvhRoNhU4YEd3WQ5PD1/bjCNeDU5luNwzQpES9Noch+GX2I335gq3+M
 6qfN/oDq10yvQntwL0YC3GGuwdTQ+2ydz1RiW2DFHKHwTmM8RVu0gCxBJvzUkb+IoIwH
 dRyrAm+CF5tAF76uiCEXnOKc3m6FGAmRw0kq2cTBuqU/bY5/qWPiU6j+wYeeg4DATRl/
 o/b+gdFiJ+cit1ZY7tG1ftVgmCyrTgma8Q0f0yPFbBobR3herSydsof2cQB/J32B/LQi /A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 32x8bnkr7m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 21 Aug 2020 02:12:05 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07L28KvA017732;
        Fri, 21 Aug 2020 02:12:04 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 3325368ame-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Aug 2020 02:12:04 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07L2C3Ie028367;
        Fri, 21 Aug 2020 02:12:03 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 20 Aug 2020 19:12:03 -0700
Subject: [PATCH 05/11] xfs: move xfs_log_dinode_to_disk to the log code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, sandeen@sandeen.net
Date:   Thu, 20 Aug 2020 19:12:02 -0700
Message-ID: <159797592235.965217.10770400527713016921.stgit@magnolia>
In-Reply-To: <159797588727.965217.7260803484540460144.stgit@magnolia>
References: <159797588727.965217.7260803484540460144.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9719 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxscore=0 spamscore=0
 phishscore=0 malwarescore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008210018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9719 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 suspectscore=1 adultscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 clxscore=1015 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008210018
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move this function to xfs_inode_item.c to match the encoding function
that's already there.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c |   52 -----------------------------------------
 fs/xfs/libxfs/xfs_inode_buf.h |    2 --
 fs/xfs/xfs_inode_item.c       |   52 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_inode_item.h       |    3 ++
 4 files changed, 55 insertions(+), 54 deletions(-)


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
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 6c65938cee1c..d95a00376fad 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -295,6 +295,58 @@ xfs_inode_item_format_attr_fork(
 	}
 }
 
+void
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
 static void
 xfs_inode_to_log_dinode(
 	struct xfs_inode	*ip,
diff --git a/fs/xfs/xfs_inode_item.h b/fs/xfs/xfs_inode_item.h
index 048b5e7dee90..dc924a1c94bc 100644
--- a/fs/xfs/xfs_inode_item.h
+++ b/fs/xfs/xfs_inode_item.h
@@ -50,4 +50,7 @@ extern int xfs_inode_item_format_convert(xfs_log_iovec_t *,
 
 extern struct kmem_zone	*xfs_ili_zone;
 
+void	xfs_log_dinode_to_disk(struct xfs_log_dinode *from,
+			       struct xfs_dinode *to);
+
 #endif	/* __XFS_INODE_ITEM_H__ */

