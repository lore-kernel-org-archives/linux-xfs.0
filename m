Return-Path: <SRS0=K4IM=45=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DF19C1975A
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 03:44:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0013B206E2
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 03:44:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rfqXkwLu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731596AbgCLDoy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Mar 2020 23:44:54 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40224 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730913AbgCLDoy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Mar 2020 23:44:54 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02C3f9WP168586;
        Thu, 12 Mar 2020 03:44:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=ySBzfgw25LoQmBSnb4zTAzoisc0kyaK/+/66UpjHBEY=;
 b=rfqXkwLuqZA5IGb3QSTBx5WL+scMr8ueAGOvBkLUnDwK8nueUf3uSB5hScR5xcG3aAJN
 YUK6kwmeYkHbistgpcBr9MwOG+6TPvhQi39cOIKY4o43YwYpD/6JI+7agot03RPJmwj0
 IUC7+kJ/pBlQg7I8HwON0M6I3YOpMUjXTomUR7uq6K7K7t7U9ogJ7lPiZQCaTXA3vt7C
 Md2B6eyUIeueFq9GIg8yJ800f8tLNSbhVIck8+ciKCH8r2ByMKRhU5IOPYKYOmB5ssua
 GW43dMN7k8IotB9KRpE90nSOvkcACCHiecNC5YWdWdfdudmTrgHzMV3NDoWK3VCua3iV aw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2yp9v6a9u9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 03:44:49 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02C3cAPD055263;
        Thu, 12 Mar 2020 03:44:49 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2yp8p5qwp5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 03:44:49 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02C3imKq016711;
        Thu, 12 Mar 2020 03:44:48 GMT
Received: from localhost (/10.159.134.61)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 11 Mar 2020 20:44:48 -0700
Subject: [PATCH 1/7] xfs: introduce new private btree cursor names
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        Dave Chinner <dchinner@redhat.com>
Date:   Wed, 11 Mar 2020 20:44:47 -0700
Message-ID: <158398468764.1307855.4576269889532808623.stgit@magnolia>
In-Reply-To: <158398468107.1307855.8287106235853942996.stgit@magnolia>
References: <158398468107.1307855.8287106235853942996.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9557 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 spamscore=0 malwarescore=0 adultscore=0 suspectscore=1 mlxlogscore=911
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003120016
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9557 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 spamscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 mlxlogscore=966
 phishscore=0 adultscore=0 clxscore=1015 impostorscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003120016
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Just the defines of the new names - the conversion will be in
scripted commits after this.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
[darrick: change "bc_bt" to "bc_ino"]
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_btree.h |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 3eff7c321d43..4a1c98bdfaad 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -224,6 +224,8 @@ typedef struct xfs_btree_cur
 #define	XFS_BTCUR_BPRV_INVALID_OWNER	(1<<1)		/* for ext swap */
 		} b;
 	}		bc_private;	/* per-btree type data */
+#define bc_ag	bc_private.a
+#define bc_ino	bc_private.b
 } xfs_btree_cur_t;
 
 /* cursor flags */

