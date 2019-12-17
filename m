Return-Path: <SRS0=4VMi=2H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2FFAC43603
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Dec 2019 02:35:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9EE6A218AC
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Dec 2019 02:35:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="M9fKZePI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbfLQCf5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Dec 2019 21:35:57 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:57768 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbfLQCf5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Dec 2019 21:35:57 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBH2XwCS089373;
        Tue, 17 Dec 2019 02:35:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=FQx9uUCzwjNEqSFRgtQ7vYbGxbtz0wLXjTHssqdLiXI=;
 b=M9fKZePI3GPe1kHwVkG539A/QQaQt2eM86KVeLRhzpcd+5ThDEtDQHcPm+Z87Au3pXSc
 WxMIUYVucH5NhZneVcgqmzNTQUKUwyekzvV+owfX1OU1FnKcQTrxJYjyOwR2jtotymju
 BFeZueSLwl28vO2xKuHmB0awuAhKNKHT1yMAT2RJXYK17BBP4XpaDVXTat9tlc9m/Mdg
 mpD58CNzSLl2HJWgQu2yChW9XNKt6I2XSSLsWFJ4ua4hCAM+/Li9mwSayfMwlUDRtd7b
 Qi5vt1T7uk1lUhmZHA+BDCFS3KcNqt8o6TmkfCZ5VgiwrITZQV+a7huWvls3AZNR4FYw FA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2wvq5ubn7p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Dec 2019 02:35:43 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBH2Sc18141391;
        Tue, 17 Dec 2019 02:35:42 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2wxm6xt70j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Dec 2019 02:35:42 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBH2ZecH006698;
        Tue, 17 Dec 2019 02:35:41 GMT
Received: from localhost (/10.159.159.234)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Dec 2019 18:35:40 -0800
Date:   Mon, 16 Dec 2019 18:35:35 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] libxfs: make resync with the userspace libxfs easier
Message-ID: <20191217023535.GA12765@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9473 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912170021
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9473 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912170022
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Prepare to resync the userspace libxfs with the kernel libxfs.  There
were a few things I missed -- a couple of static inline directory
functions that have to be exported for xfs_repair; a couple of directory
naming functions that make porting much easier if they're /not/ static
inline; and a u16 usage that should have been uint16_t.

None of these things are bugs in their own right; this just makes
porting xfsprogs easier.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c      |    2 +-
 fs/xfs/libxfs/xfs_dir2.c      |   21 +++++++++++++++++++++
 fs/xfs/libxfs/xfs_dir2_priv.h |   29 +++++++++--------------------
 fs/xfs/libxfs/xfs_dir2_sf.c   |    6 +++---
 4 files changed, 34 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 4a802b3abe77..4c2e046fbfad 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4561,7 +4561,7 @@ xfs_bmapi_convert_delalloc(
 	struct xfs_mount	*mp = ip->i_mount;
 	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
 	struct xfs_bmalloca	bma = { NULL };
-	u16			flags = 0;
+	uint16_t		flags = 0;
 	struct xfs_trans	*tp;
 	int			error;
 
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 0aa87cbde49e..dd6fcaaea318 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -724,3 +724,24 @@ xfs_dir2_namecheck(
 	/* There shouldn't be any slashes or nulls here */
 	return !memchr(name, '/', length) && !memchr(name, 0, length);
 }
+
+xfs_dahash_t
+xfs_dir2_hashname(
+	struct xfs_mount	*mp,
+	struct xfs_name		*name)
+{
+	if (unlikely(xfs_sb_version_hasasciici(&mp->m_sb)))
+		return xfs_ascii_ci_hashname(name);
+	return xfs_da_hashname(name->name, name->len);
+}
+
+enum xfs_dacmp
+xfs_dir2_compname(
+	struct xfs_da_args	*args,
+	const unsigned char	*name,
+	int			len)
+{
+	if (unlikely(xfs_sb_version_hasasciici(&args->dp->i_mount->m_sb)))
+		return xfs_ascii_ci_compname(args, name, len);
+	return xfs_da_compname(args, name, len);
+}
diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
index c031c53d0f0d..01ee0b926572 100644
--- a/fs/xfs/libxfs/xfs_dir2_priv.h
+++ b/fs/xfs/libxfs/xfs_dir2_priv.h
@@ -175,6 +175,12 @@ extern int xfs_dir2_sf_lookup(struct xfs_da_args *args);
 extern int xfs_dir2_sf_removename(struct xfs_da_args *args);
 extern int xfs_dir2_sf_replace(struct xfs_da_args *args);
 extern xfs_failaddr_t xfs_dir2_sf_verify(struct xfs_inode *ip);
+int xfs_dir2_sf_entsize(struct xfs_mount *mp,
+		struct xfs_dir2_sf_hdr *hdr, int len);
+void xfs_dir2_sf_put_ino(struct xfs_mount *mp, struct xfs_dir2_sf_hdr *hdr,
+		struct xfs_dir2_sf_entry *sfep, xfs_ino_t ino);
+void xfs_dir2_sf_put_ftype(struct xfs_mount *mp,
+		struct xfs_dir2_sf_entry *sfep, uint8_t ftype);
 
 /* xfs_dir2_readdir.c */
 extern int xfs_readdir(struct xfs_trans *tp, struct xfs_inode *dp,
@@ -194,25 +200,8 @@ xfs_dir2_data_entsize(
 	return round_up(len, XFS_DIR2_DATA_ALIGN);
 }
 
-static inline xfs_dahash_t
-xfs_dir2_hashname(
-	struct xfs_mount	*mp,
-	struct xfs_name		*name)
-{
-	if (unlikely(xfs_sb_version_hasasciici(&mp->m_sb)))
-		return xfs_ascii_ci_hashname(name);
-	return xfs_da_hashname(name->name, name->len);
-}
-
-static inline enum xfs_dacmp
-xfs_dir2_compname(
-	struct xfs_da_args	*args,
-	const unsigned char	*name,
-	int			len)
-{
-	if (unlikely(xfs_sb_version_hasasciici(&args->dp->i_mount->m_sb)))
-		return xfs_ascii_ci_compname(args, name, len);
-	return xfs_da_compname(args, name, len);
-}
+xfs_dahash_t xfs_dir2_hashname(struct xfs_mount *mp, struct xfs_name *name);
+enum xfs_dacmp xfs_dir2_compname(struct xfs_da_args *args,
+		const unsigned char *name, int len);
 
 #endif /* __XFS_DIR2_PRIV_H__ */
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 8b94d33d232f..7b7f6fb2ea3b 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -37,7 +37,7 @@ static void xfs_dir2_sf_check(xfs_da_args_t *args);
 static void xfs_dir2_sf_toino4(xfs_da_args_t *args);
 static void xfs_dir2_sf_toino8(xfs_da_args_t *args);
 
-static int
+int
 xfs_dir2_sf_entsize(
 	struct xfs_mount	*mp,
 	struct xfs_dir2_sf_hdr	*hdr,
@@ -84,7 +84,7 @@ xfs_dir2_sf_get_ino(
 	return get_unaligned_be64(from) & XFS_MAXINUMBER;
 }
 
-static void
+void
 xfs_dir2_sf_put_ino(
 	struct xfs_mount		*mp,
 	struct xfs_dir2_sf_hdr		*hdr,
@@ -145,7 +145,7 @@ xfs_dir2_sf_get_ftype(
 	return XFS_DIR3_FT_UNKNOWN;
 }
 
-static void
+void
 xfs_dir2_sf_put_ftype(
 	struct xfs_mount	*mp,
 	struct xfs_dir2_sf_entry *sfep,
