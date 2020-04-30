Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17D01C4724C
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 22:47:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8F8620774
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 22:47:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AhMBqPih"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727799AbgD3WrL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Apr 2020 18:47:11 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58868 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727097AbgD3WrK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Apr 2020 18:47:10 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UMhKX8063547
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=5RjMmjJFI/zKbRhht1DkI51waVOQn4KKaQqO7hbSKaw=;
 b=AhMBqPihJZFS8ryhrmj4gnOX22xsEKw+YmFv0Sabe9Yv6lSolZYUmrZyHpzef6dwX+m3
 ps+tf952nFdDF5QTCGgw2G/yvIt/FEq1tZNhnUMC0Poylik0kRm4QL58YaQapKWydv7X
 2JJKTZQCPjgHeenT1gewY6GS0Ynw8jOEKeYCSe/2l4szRUnqTk1s2UVZUYOu2iu0uD9N
 yMpwTs4H6bIW+o5OOdMmviyoqJX/dTLmZIbr13hq3Obovt/i8fZEGQ0EuFcyh/n/dN5S
 q7I+hp8EDjF2wuroP2kNACdHuLo2yUOTMvaM+OYzNUpHjuXb2VraK6e06rsILAjibw01 tw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 30r7f8027y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:09 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UMhP88181131
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:09 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 30r7fes2a6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:09 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03UMl81W012289
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:08 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Apr 2020 15:47:08 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v9 13/43] xfsprogs: cleanup struct xfs_attr_list_context
Date:   Thu, 30 Apr 2020 15:46:30 -0700
Message-Id: <20200430224700.4183-14-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200430224700.4183-1-allison.henderson@oracle.com>
References: <20200430224700.4183-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 suspectscore=1 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300167
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 clxscore=1015 phishscore=0 mlxscore=0
 lowpriorityscore=0 suspectscore=1 adultscore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300167
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Replace the alist char pointer with a void buffer given that different
callers use it in different ways.  Use the chance to remove the typedef
and reduce the indentation of the struct definition so that it doesn't
overflow 80 char lines all over.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.h | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 0f36939..0c8f7c7 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -99,28 +99,28 @@ typedef struct attrlist_cursor_kern {
 typedef void (*put_listent_func_t)(struct xfs_attr_list_context *, int,
 			      unsigned char *, int, int);
 
-typedef struct xfs_attr_list_context {
-	struct xfs_trans		*tp;
-	struct xfs_inode		*dp;		/* inode */
-	struct attrlist_cursor_kern	*cursor;	/* position in list */
-	char				*alist;		/* output buffer */
+struct xfs_attr_list_context {
+	struct xfs_trans	*tp;
+	struct xfs_inode	*dp;		/* inode */
+	struct attrlist_cursor_kern *cursor;	/* position in list */
+	void			*buffer;	/* output buffer */
 
 	/*
 	 * Abort attribute list iteration if non-zero.  Can be used to pass
 	 * error values to the xfs_attr_list caller.
 	 */
-	int				seen_enough;
-	bool				allow_incomplete;
-
-	ssize_t				count;		/* num used entries */
-	int				dupcnt;		/* count dup hashvals seen */
-	int				bufsize;	/* total buffer size */
-	int				firstu;		/* first used byte in buffer */
-	int				flags;		/* from VOP call */
-	int				resynch;	/* T/F: resynch with cursor */
-	put_listent_func_t		put_listent;	/* list output fmt function */
-	int				index;		/* index into output buffer */
-} xfs_attr_list_context_t;
+	int			seen_enough;
+	bool			allow_incomplete;
+
+	ssize_t			count;		/* num used entries */
+	int			dupcnt;		/* count dup hashvals seen */
+	int			bufsize;	/* total buffer size */
+	int			firstu;		/* first used byte in buffer */
+	int			flags;		/* from VOP call */
+	int			resynch;	/* T/F: resynch with cursor */
+	put_listent_func_t	put_listent;	/* list output fmt function */
+	int			index;		/* index into output buffer */
+};
 
 
 /*========================================================================
-- 
2.7.4

