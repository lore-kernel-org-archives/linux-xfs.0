Return-Path: <SRS0=euis=5T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0167DC2BA18
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Apr 2020 22:10:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CAB5F2078C
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Apr 2020 22:10:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="f1n23MVs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727829AbgDCWKI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Apr 2020 18:10:08 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38378 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727842AbgDCWKH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Apr 2020 18:10:07 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033M91XO019200
        for <linux-xfs@vger.kernel.org>; Fri, 3 Apr 2020 22:10:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=iydhf0LB5YIEF9EBBSOiFHX9VFA4DhbfPRT/qsdcfNY=;
 b=f1n23MVsW1RESNy8vg6+O5P0V87ZHrl/0p+Qc+vlLRKDQ7iqnbR9XMpvXi1JcRnHb1Rn
 7RlQ8tbj3qS1ka+mfDdmMzCkXC/cUMMWaGWS79N+Dj52YZtxAAYP+6dsuoBRg8oRqcp+
 35Fm8eZ3FJqo/L/0Ip6AE2BzE49PimQeI/hiEXuv62eHYmhDQeYy6+YxzTmFBmCuKYcQ
 yoXUs+F4EEy9uFSCaU93EZCtU5kp5U5bfn0YedgCfgsDkVGYqJHCiJ9WJpPelmhxDm5p
 t7RjUdS4kwPdmQJRRaY7S1eAFP37M3PCr/ZIzF+o+KD05sKuFsCcqw1lmDYiqnkh6REH eA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 303aqj3w4b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 03 Apr 2020 22:10:06 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033M8Njh062283
        for <linux-xfs@vger.kernel.org>; Fri, 3 Apr 2020 22:10:06 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 302ga611td-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 03 Apr 2020 22:10:06 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 033MA5rZ009845
        for <linux-xfs@vger.kernel.org>; Fri, 3 Apr 2020 22:10:05 GMT
Received: from localhost.localdomain (/67.1.1.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Apr 2020 15:10:05 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v8 05/39] xfsprogs: turn xfs_da_args.value into a void pointer
Date:   Fri,  3 Apr 2020 15:09:24 -0700
Message-Id: <20200403220958.4944-6-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200403220958.4944-1-allison.henderson@oracle.com>
References: <20200403220958.4944-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9580 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004030171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9580 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 mlxlogscore=999 spamscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030171
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The xattr values are blobs and should not be typed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 libxfs/xfs_da_btree.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libxfs/xfs_da_btree.h b/libxfs/xfs_da_btree.h
index 0f4fbb0..0967d1b 100644
--- a/libxfs/xfs_da_btree.h
+++ b/libxfs/xfs_da_btree.h
@@ -57,7 +57,7 @@ typedef struct xfs_da_args {
 	const uint8_t		*name;		/* string (maybe not NULL terminated) */
 	int		namelen;	/* length of string (maybe no NULL) */
 	uint8_t		filetype;	/* filetype of inode for directories */
-	uint8_t		*value;		/* set of bytes (maybe contain NULLs) */
+	void		*value;		/* set of bytes (maybe contain NULLs) */
 	int		valuelen;	/* length of value */
 	int		flags;		/* argument flags (eg: ATTR_NOCREATE) */
 	xfs_dahash_t	hashval;	/* hash value of name */
-- 
2.7.4

