Return-Path: <SRS0=euis=5T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04188C43331
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Apr 2020 22:12:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC17E207FF
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Apr 2020 22:12:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lUw0H7bu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727924AbgDCWMH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Apr 2020 18:12:07 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46980 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727829AbgDCWMH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Apr 2020 18:12:07 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033M9h1t082585
        for <linux-xfs@vger.kernel.org>; Fri, 3 Apr 2020 22:12:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=J7weyPy+kIAaPev1PRsv9g8oTOryjuDEs9kXNMtq4tg=;
 b=lUw0H7buUigZHiny7CR1w/cC6D7X2nCKpjlBy+vL6VU4mFnr3bSHDokYHyx/jft74NBW
 HiT8QHb7FlS68pWGxwNLpi4fIK7Vtul1XMcRzGOJjaduYYQNunuVJkM8hoMaooFOA4sU
 hUQ+eToC3p3z1ssFLS40Cu5gWkYe4nkUVaF80/D4o1qBk8nQ+kw0KTMM9poaa5mrXm7w
 /LQACNFyeLdW34sLORL5AED1DIFAw/1FfSA/DIT+vNeLSn1ZS3YiSZFSOWasKYgMFtQ3
 AXdMujkIsLiJW6EfkalXfirAmIzzuO3qodIj7VzdiENCnu9SlG7d6Ez2ZcNSpUnbG89i Rg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 303cevkdp3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 03 Apr 2020 22:12:05 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033M8Now062337
        for <linux-xfs@vger.kernel.org>; Fri, 3 Apr 2020 22:10:05 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 302ga611r0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 03 Apr 2020 22:10:05 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 033MA4oX015869
        for <linux-xfs@vger.kernel.org>; Fri, 3 Apr 2020 22:10:04 GMT
Received: from localhost.localdomain (/67.1.1.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Apr 2020 15:10:04 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v8 01/39] xfsprogs: remove the ATTR_INCOMPLETE flag
Date:   Fri,  3 Apr 2020 15:09:20 -0700
Message-Id: <20200403220958.4944-2-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200403220958.4944-1-allison.henderson@oracle.com>
References: <20200403220958.4944-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9580 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004030171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9580 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 adultscore=0
 clxscore=1015 phishscore=0 lowpriorityscore=0 spamscore=0 malwarescore=0
 suspectscore=1 mlxscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030171
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Replace the ATTR_INCOMPLETE flag with a new boolean field in struct
xfs_attr_list_context.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 4243b22..71bcf12 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -36,11 +36,10 @@ struct xfs_attr_list_context;
 #define ATTR_KERNOTIME	0x1000	/* [kernel] don't update inode timestamps */
 #define ATTR_KERNOVAL	0x2000	/* [kernel] get attr size only, not value */
 
-#define ATTR_INCOMPLETE	0x4000	/* [kernel] return INCOMPLETE attr keys */
 #define ATTR_ALLOC	0x8000	/* [kernel] allocate xattr buffer on demand */
 
 #define ATTR_KERNEL_FLAGS \
-	(ATTR_KERNOTIME | ATTR_KERNOVAL | ATTR_INCOMPLETE | ATTR_ALLOC)
+	(ATTR_KERNOTIME | ATTR_KERNOVAL | ATTR_ALLOC)
 
 #define XFS_ATTR_FLAGS \
 	{ ATTR_DONTFOLLOW, 	"DONTFOLLOW" }, \
@@ -51,7 +50,6 @@ struct xfs_attr_list_context;
 	{ ATTR_REPLACE,		"REPLACE" }, \
 	{ ATTR_KERNOTIME,	"KERNOTIME" }, \
 	{ ATTR_KERNOVAL,	"KERNOVAL" }, \
-	{ ATTR_INCOMPLETE,	"INCOMPLETE" }, \
 	{ ATTR_ALLOC,		"ALLOC" }
 
 /*
@@ -123,6 +121,7 @@ typedef struct xfs_attr_list_context {
 	 * error values to the xfs_attr_list caller.
 	 */
 	int				seen_enough;
+	bool				allow_incomplete;
 
 	ssize_t				count;		/* num used entries */
 	int				dupcnt;		/* count dup hashvals seen */
-- 
2.7.4

