Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57A71C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Jan 2022 05:27:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240913AbiAXF1b (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jan 2022 00:27:31 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:39908 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240955AbiAXF10 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jan 2022 00:27:26 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20NJ0Sx1007794
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jan 2022 05:27:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=yluYH/y/nDVVHizcZZ9R5ja+IfwuIadclopKpGEkWOg=;
 b=mHCMAHAH4Qdh2zqjWeaf5Cl91u2X9hWeFet6SktfxrDuPPavfozsWRL4cvYKkkpekFIo
 mvpDRWktsZZ4NhPs3XRz/eXkCwl9w2Wkc36KtRGM7OcYhddPPQpfWudTQTK+K3W4vT5Y
 9jfqf7wSnUH4pni1qGl5adZY0C2LVyMK7MaE1mjwJQjl7LEGZw5cDeAZq/Okp08bQNPe
 GfuX0EmzIcO4khmneeQJdE7P/MnUTn01v3CSlYwBcMjqMMWEEjLMZzAhHpW6bcuCqUtF
 EzkVQv45McVdbeq+bPhhZhZMXygCPqustw7YbGnURU1w79udOsrBToemdr03Xzco9gXv sw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dr8bdk30d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jan 2022 05:27:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20O5REWB139905
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jan 2022 05:27:25 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by aserp3030.oracle.com with ESMTP id 3dr7yd4xn2-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jan 2022 05:27:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mk5nK/VqiiFo1FxTrSHiT/HhnGNzzaW32sAc1/YoL78N/Xr4qy5CyEuLvd+q96Kk8EyieTtgpdiWYjeuU2B0iGyArivqeVI8ERHe+Ytbra2Ljr1+dXB8vrac01kmdcyWkFM1LhR5MSK8WZH+vJPlOM+QmovPTG4hq+11EG8xWCGi9737KlYxkyuVioEKq4B64a3rDdlAB2UGRw+75mKapbwb9vDVO/3eY1rDnYjKQwX3Pcr3/PjxZf3dG19icXkDQuBuodgq85J3aRX/1VdlGCIjenAun6goTCammPEiuT59+6IvGWYMUE4pVHeA0IWusqFCc2ih4pG0+XW/4svVng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yluYH/y/nDVVHizcZZ9R5ja+IfwuIadclopKpGEkWOg=;
 b=jxyJMtg5km0jVHp1bdWyiZL3SYz7BINIzj39QxU8P9B3g0EZkUKFUnUB9xjCqlUikC3cMMZT0/R+6P8KHERjldtB9lOqz9g3qqFFZ91Z1sF/Si1HAwgWBE9AjbmGchtoL8J/gaiPGBFOvxx9CpWd54s0caY/939CDMptwAQRaZQLsX4ojh64094eArIUlJ/AEV4iTgdHN1DCXXgk8J8ljb/zl8VBpacHRPxetXRkvfyXLpNMphbx3AE+iwv7WdxtKcziE17aIua37leKAvTw/QjaESuCBRGTOLlM1z95xddHNj8GbKixwT1gwdL+jyCj+dgvA65sxNzXzLCjV31vTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yluYH/y/nDVVHizcZZ9R5ja+IfwuIadclopKpGEkWOg=;
 b=n1t1p80/DeYRNUWQcCcHfAL0XUGN+BKZQTvaiAE/P1x8sX/ADhPrPhlXRjkNwXi7vcugMy2QWonUiMhfoH35xxl6vbxXaaBgTQanYMRHfhXqraEnXxS6LnLVXUTrodkQeMSSk3KHUIm+LgSDbUTUk8VbSHTRUUr8zCm/YCQfTFM=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BN0PR10MB4821.namprd10.prod.outlook.com (2603:10b6:408:125::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Mon, 24 Jan
 2022 05:27:23 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3c8d:14a4:ffd3:4350]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3c8d:14a4:ffd3:4350%6]) with mapi id 15.20.4909.017; Mon, 24 Jan 2022
 05:27:23 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v26 12/12] xfs: Add helper function xfs_attr_leaf_addname
Date:   Sun, 23 Jan 2022 22:27:08 -0700
Message-Id: <20220124052708.580016-13-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220124052708.580016-1-allison.henderson@oracle.com>
References: <20220124052708.580016-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0008.namprd05.prod.outlook.com
 (2603:10b6:a03:254::13) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0afe8ae3-bd77-4b81-31b5-08d9defa30f7
X-MS-TrafficTypeDiagnostic: BN0PR10MB4821:EE_
X-Microsoft-Antispam-PRVS: <BN0PR10MB48215928BE8011C3F18912FA955E9@BN0PR10MB4821.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hzaw7ze26BU6t2BEv3L5+V03sZeW/xQP4e/oLUfbB+magcYO6rCXIlUuQzhPTUQKp1ihLaQQYoDDZ/oeT+CHETE2eABw9kVt/Z95z6tkaayoHOLDKM4WFARvaMvxiqJXCj09a9FzBtt6FnHSwWPVnNGHi/Y4CxdTrN7Tlg+g5rOC/BvKCTzhRdpH99NhbQynbCjwZeaCbb1SxiVYzuWCU/TnmWnC8MiaRHkQ47dts9gcxs01ToZDg3E/2ISfesv7jLOhNcMia8UfbRkKiRFwMcqnVM+ZYhn8OGaT+WtgdSV7gOrLIozeGCmBfBIP1kZgI/xjNMP2UP9qxc3TVHJeYi4hBE8v//NjmWD1WpNkF2SMRNFD2z5owBzNS/mFRLr/P5eOLjWvNQC79aVMzEm3Qy9iXcUPyc36dyfLsNjDJJsKRWsN7Q6FhjKWWjwv5Nf8MovQJP89LpL9/O/6SDUUk2cS87rsEqsl63KcMZ3iTjgxGC+QTjx73Zcy///Mjp7yiE9gYqDbeWiQhH75Jq+qtRPnTHCyrL1fzrMybLq0gDnOpIMz5HfcAc3TR4QwJJIs2e1L6K1Uwd5SygHoWNz9y6w6fo/lza6kUlUWObeqqYXUiCRvGbOVXSxcJIF8NiM0GOiZkHRrMrORkGxaiWu6sVedQg4MfYYHRu43z7uf2Y1bYb3vMvEGPpRp493IsnOiiKVJs1MkrcxMRp7ITm4fIw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(8676002)(186003)(6666004)(52116002)(6512007)(2616005)(83380400001)(66946007)(66476007)(66556008)(38100700002)(5660300002)(26005)(2906002)(36756003)(86362001)(6486002)(1076003)(38350700002)(316002)(44832011)(508600001)(6506007)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hMPW72M2+qgP3MQrKYFUx91yNSptM2KJdJn+nPA25DP3hYyxTlYRo+jFph/Y?=
 =?us-ascii?Q?lQ6Zx8vOLHb477I5vBjK9r91DIJuGXqy6WXq2CM2747ewvrnR57VNhlCU+yG?=
 =?us-ascii?Q?vuQv5o2Z6X2MOuw/afDzBZMDlK1kwfN7VI4SgYeY7sLkiFb5M8ZQcLlWGDnx?=
 =?us-ascii?Q?Tqh9azboFS5YxoqhY5JAeEZH931SWrcx32J50txRo8DyYihEEJNDUI3tvpOZ?=
 =?us-ascii?Q?nubJmgm1PcCHxiK0TeBfRzL3/bmcweC3NZX2Cj5z86MUMbjummXyveyfGclf?=
 =?us-ascii?Q?ISy1chkYjTtaJ3s7C46wGuEIhXzhOg3NG5AdcXpJ8rXEXzoCDbxomob32k1/?=
 =?us-ascii?Q?IYOTEs2o4i+o9gu+8BiN8Tp5qPhjFOgoPtDdd29Z9rLtseSDN8SK2MSD5b26?=
 =?us-ascii?Q?xWQOVbjO6pS2FKzHHL6G17d8TZkh5R5AD/GbxqEyZwcaDuS7HUh7yaqykXDT?=
 =?us-ascii?Q?HHYKMZ5Bh6FMn0a1k9Wvcd9YQ9L6kVo4BqOdQYkpf1O5zhQ+Zw2tteDxN411?=
 =?us-ascii?Q?Y/0t7p89ubIafAB8g+tCpxp9RGTTLzy2lBjS9gBZXrw24sk8IWmnVwlpU2b8?=
 =?us-ascii?Q?Qk7qxgZBF9P75Xf7m1xDhfWzOb2787CNE8Sp8nVVI2i6aaimhiIaoTxee+Hn?=
 =?us-ascii?Q?IMltKLhPNWOl00X1qMI/8d82Wdqfm7VwNpzHliNT6aL8GO8okTfX/BVZN1EW?=
 =?us-ascii?Q?MTHVzD6borkRtwp7s8Mn/UH2Od5Quvck1ZdVxYUTe7gXI0bbxo1hD8TLeL3r?=
 =?us-ascii?Q?0AeqVxrCg3vx/XNw6hk+Q5yGiQhW4dR3o+D+Vcy3IEc09DjWC4Sm7SKki9iB?=
 =?us-ascii?Q?XCag5Bysr+sujB01B+kmlZnEF3gzbXyEjhFwTgjwfVPufiMCOypYJBP80E65?=
 =?us-ascii?Q?oHfPD3wsN6TxizYfr2zryUciSnOCB9jQx4eS8HWP3qoiv89HmojSzAbHXGDv?=
 =?us-ascii?Q?pxP5nOIT2i/UKPGwgr5aJ5y+cMLxLKL1yEa9g7vMuDogeZ+d3DfHsDkAmd+s?=
 =?us-ascii?Q?jiytDRrQRqmD9y7AmqovaPh/P4vh49zeQ272MohoU4xf9mZXg4rO1Ot+CgPY?=
 =?us-ascii?Q?gm2XaU6QnRSDpDpOQbIqCSOVBYx8BWh/l2gO0Tgw960b3cd1D1sFtDmTYwfU?=
 =?us-ascii?Q?w2pGkpB/NY1IwoFtGWo62CQ0WZqemuS5Lj6NH2U03IbeRgduP6fhJn2kSw7h?=
 =?us-ascii?Q?GTKCx6/ts6m+bvF4szwVDfoA+FnxXuxeStQaR+Otdu2wHweRGOwc22xQgjci?=
 =?us-ascii?Q?eQc5ldGMFudCF7Azdh32+6LR2HLMxNuLlte657sFUL69/0Y0TyPMm+OYaDih?=
 =?us-ascii?Q?7kzRge5KEmsEaJtCZ5lVGb0GAJplbKGRalPNldism2rBriqD6e4rcXtjg+TE?=
 =?us-ascii?Q?ClSLUX2h08UTJTbek49NGin+8YhXdPc2QPgQxpGgmIDkRoVsS2rC2+EHMvP8?=
 =?us-ascii?Q?n8dqVAQzL5XWKZyFWS1nn08kqIEdgk+VUGKhuIUDizt6IRVkOOS/1FqHJbCD?=
 =?us-ascii?Q?9zy+67FrcR6QS9CTfAuLIdeh71KzcGe7CvlHUoxCuLMtZsveat+vx4dZNIW5?=
 =?us-ascii?Q?VLAw/jYyolYukt0i5AxO1VvYrGZgNnJu2mMbbp0GFXhljYy3DEShXrpaVP73?=
 =?us-ascii?Q?R3JW47+sI0m02HmsQMzmW2IAnJgxudDkyKE33TBL1aTBg+8DuK4JIHntpY8D?=
 =?us-ascii?Q?wDq3Gw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0afe8ae3-bd77-4b81-31b5-08d9defa30f7
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2022 05:27:19.5582
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7e9kV+EZA3tqvuUUyvn35gZ3itCDAD/tB6pJvdT7dsnFKwIUgrMSN2tKzWppKD5V3pBQ0dZFCHbAcB0ByiUob4Ql+RDPGA5Pa0gtTgWWqvw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4821
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10236 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201240036
X-Proofpoint-ORIG-GUID: O8G-zcZIMe-kzcu54NfMPyqTu0QVZl1P
X-Proofpoint-GUID: O8G-zcZIMe-kzcu54NfMPyqTu0QVZl1P
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds a helper function xfs_attr_leaf_addname.  While this
does help to break down xfs_attr_set_iter, it does also hoist out some
of the state management.  This patch has been moved to the end of the
clean up series for further discussion.

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_attr.c | 110 +++++++++++++++++++++------------------
 fs/xfs/xfs_trace.h       |   1 +
 2 files changed, 61 insertions(+), 50 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 1b1aa3079469..7d6ad1d0e10b 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -287,6 +287,65 @@ xfs_attr_sf_addname(
 	return -EAGAIN;
 }
 
+STATIC int
+xfs_attr_leaf_addname(
+	struct xfs_attr_item	*attr)
+{
+	struct xfs_da_args	*args = attr->xattri_da_args;
+	struct xfs_inode	*dp = args->dp;
+	int			error;
+
+	if (xfs_attr_is_leaf(dp)) {
+		error = xfs_attr_leaf_try_add(args, attr->xattri_leaf_bp);
+		if (error == -ENOSPC) {
+			error = xfs_attr3_leaf_to_node(args);
+			if (error)
+				return error;
+
+			/*
+			 * Finish any deferred work items and roll the
+			 * transaction once more.  The goal here is to call
+			 * node_addname with the inode and transaction in the
+			 * same state (inode locked and joined, transaction
+			 * clean) no matter how we got to this step.
+			 *
+			 * At this point, we are still in XFS_DAS_UNINIT, but
+			 * when we come back, we'll be a node, so we'll fall
+			 * down into the node handling code below
+			 */
+			trace_xfs_attr_set_iter_return(
+				attr->xattri_dela_state, args->dp);
+			return -EAGAIN;
+		}
+
+		if (error)
+			return error;
+
+		attr->xattri_dela_state = XFS_DAS_FOUND_LBLK;
+	} else {
+		error = xfs_attr_node_addname_find_attr(attr);
+		if (error)
+			return error;
+
+		error = xfs_attr_node_addname(attr);
+		if (error)
+			return error;
+
+		/*
+		 * If addname was successful, and we dont need to alloc or
+		 * remove anymore blks, we're done.
+		 */
+		if (!args->rmtblkno &&
+		    !(args->op_flags & XFS_DA_OP_RENAME))
+			return 0;
+
+		attr->xattri_dela_state = XFS_DAS_FOUND_NBLK;
+	}
+
+	trace_xfs_attr_leaf_addname_return(attr->xattri_dela_state, args->dp);
+	return -EAGAIN;
+}
+
 /*
  * Set the attribute specified in @args.
  * This routine is meant to function as a delayed operation, and may return
@@ -322,57 +381,8 @@ xfs_attr_set_iter(
 			attr->xattri_leaf_bp = NULL;
 		}
 
-		if (xfs_attr_is_leaf(dp)) {
-			error = xfs_attr_leaf_try_add(args,
-						      attr->xattri_leaf_bp);
-			if (error == -ENOSPC) {
-				error = xfs_attr3_leaf_to_node(args);
-				if (error)
-					return error;
-
-				/*
-				 * Finish any deferred work items and roll the
-				 * transaction once more.  The goal here is to
-				 * call node_addname with the inode and
-				 * transaction in the same state (inode locked
-				 * and joined, transaction clean) no matter how
-				 * we got to this step.
-				 *
-				 * At this point, we are still in
-				 * XFS_DAS_UNINIT, but when we come back, we'll
-				 * be a node, so we'll fall down into the node
-				 * handling code below
-				 */
-				trace_xfs_attr_set_iter_return(
-					attr->xattri_dela_state, args->dp);
-				return -EAGAIN;
-			} else if (error) {
-				return error;
-			}
-
-			attr->xattri_dela_state = XFS_DAS_FOUND_LBLK;
-		} else {
-			error = xfs_attr_node_addname_find_attr(attr);
-			if (error)
-				return error;
+		return xfs_attr_leaf_addname(attr);
 
-			error = xfs_attr_node_addname(attr);
-			if (error)
-				return error;
-
-			/*
-			 * If addname was successful, and we dont need to alloc
-			 * or remove anymore blks, we're done.
-			 */
-			if (!args->rmtblkno &&
-			    !(args->op_flags & XFS_DA_OP_RENAME))
-				return 0;
-
-			attr->xattri_dela_state = XFS_DAS_FOUND_NBLK;
-		}
-		trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
-					       args->dp);
-		return -EAGAIN;
 	case XFS_DAS_FOUND_LBLK:
 		/*
 		 * If there was an out-of-line value, allocate the blocks we
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 4a8076ef8cb4..aa80f02b4459 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -4132,6 +4132,7 @@ DEFINE_EVENT(xfs_das_state_class, name, \
 	TP_ARGS(das, ip))
 DEFINE_DAS_STATE_EVENT(xfs_attr_sf_addname_return);
 DEFINE_DAS_STATE_EVENT(xfs_attr_set_iter_return);
+DEFINE_DAS_STATE_EVENT(xfs_attr_leaf_addname_return);
 DEFINE_DAS_STATE_EVENT(xfs_attr_node_addname_return);
 DEFINE_DAS_STATE_EVENT(xfs_attr_remove_iter_return);
 DEFINE_DAS_STATE_EVENT(xfs_attr_rmtval_remove_return);
-- 
2.25.1

