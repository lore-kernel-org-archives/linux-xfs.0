Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23FE6C43460
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Apr 2021 09:18:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED4BE61006
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Apr 2021 09:18:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241585AbhDPJTN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Apr 2021 05:19:13 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48332 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241635AbhDPJTD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Apr 2021 05:19:03 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G9BBHK167726
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:18:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=nwlU5NwW5MbQ23DKe3EcmqNB5Oim+SZh3b3Op41CnQ4=;
 b=PrxHo+TzCU/kd23UpXWtfM7iClOzSqenyeB8b7niGwx4TOyiPoqcGZdbUF3qyR8iyP9T
 Gl2fjeEblh4JKOlxMuv3/bEQEgwJjeyX38qV1Wkkzm7AgvhJnTo7byq6Z4B7mEdshBQo
 uMMfbAqsg7/TmFmdzNO6xi8ki87qdJdCXCiQhJJbiVw7zx9PnJmd8jYjXbB66kJlH068
 +iVFZO6YC8DEX0ECIrac7f8sdJCKL683+bPHTxUeP36NbXrOSYm22rthuBliD9vlUbTp
 sQgyksnyNWaXsoL2wHcSIRYzWNK0WYcmBAWiTzpDZ4PVY5Q4F7Ci9bSb1pcccjKK70hY bA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 37u3errkg1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:18:38 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G9AXpZ077087
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:18:38 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by userp3030.oracle.com with ESMTP id 37uny2cbx1-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:18:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hNuxB5eTGDetXx5PtwxWoiw0+hz80EoHmw+NABD7/BRIF1YquASpQr8ScTX8F4ps1hZ6GYo7kgt7089RIeqcNbZwGpAtyPj2H5/7GMUNrDj4FlV83j8loZdZsvKq6bUOLorj58lGI2q+a4LFxgFeWuHQB6At3wYs1by8r6MmHjYi9ZP4YhUqLGc8zmau2IT9vT+CDdaIvdaDIRMJcwziA6H7L1pHP8d2txR2RQVYopQiL00KKRbyMYLRxKskTGp+8/ZOBQ6vaVsrzuZ/ff7BqPwnFKE5tpvnmeNYkPvW4pjNVnt4Dki4uawSlOZZJKMI2n+kXBIsn9t76ypgI3RGJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nwlU5NwW5MbQ23DKe3EcmqNB5Oim+SZh3b3Op41CnQ4=;
 b=mANuhrr+kAzjbLGcoihn/mab7idaV8LXTrSRCpz22OixRax4kbew2ViRGTc65sJXD6BBcq9ZhxrJk8Edb5u+Olm/FiJmMG2MxXI9oS/N1vcAH3pSPKm2x6ZyC63NFEwqKoCGs0Le2FXYvFoqj/0HpgWQ/oNPwdBU4u5CBaamOYUeBHmgpaG6IyKbueWP3BHIFHMK+2s8xUzH2J5KpZ1KURsmCv0y0uNhe3uqKN4a1SVLVtG0L6OcZh3cRw/PXXXDQUHiHQ+607o0n1mu5bO1FEJ7Cz564WRrf7vg7CYIMO9Z3KYclZD0sQXpHiWql2pC0pr3Eygg9J5hkdGSXwXGeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nwlU5NwW5MbQ23DKe3EcmqNB5Oim+SZh3b3Op41CnQ4=;
 b=PkVchgI+x3aohaF1KagMoiB+8+HV0jtfvWnDW6bhl63RSgn8xBMuHgUH9xpw6zfhPE0h9Xp2oaN/MHCW9nHH7e390tQ2PHNgW653AJ2HglNEPghP7w70jIRmOKOHTvOGFSMyQxcymi1DIyQtRsK9DYj5QgUrjCDeblFWEnKJ9oI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2486.namprd10.prod.outlook.com (2603:10b6:a02:b8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19; Fri, 16 Apr
 2021 09:18:35 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4042.019; Fri, 16 Apr 2021
 09:18:35 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v17 10/12] xfsprogs: Hoist node transaction handling
Date:   Fri, 16 Apr 2021 02:18:12 -0700
Message-Id: <20210416091814.2041-11-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210416091814.2041-1-allison.henderson@oracle.com>
References: <20210416091814.2041-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.222.141]
X-ClientProxiedBy: BYAPR07CA0070.namprd07.prod.outlook.com
 (2603:10b6:a03:60::47) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.222.141) by BYAPR07CA0070.namprd07.prod.outlook.com (2603:10b6:a03:60::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 09:18:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1710690f-0d11-474a-0858-08d900b89c7e
X-MS-TrafficTypeDiagnostic: BYAPR10MB2486:
X-Microsoft-Antispam-PRVS: <BYAPR10MB24860A0BD02FDA192C8B335B954C9@BYAPR10MB2486.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:765;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WGWwc8GgZ/cP585G5eywkwyPqNE1qn5KdJGikbD2t0KdqDom8Y4yoNkA1df4mMEH/gaqwduoS8G3jbbwna2uFZWQ4X0kuU8rCohUDSY/AFSJLV4BHc2/lCIAPOPcP8t3NZ4X+Y8qdDD4MmXj01BfCuyOl2G7XOwNCEy073i8x8oUudvz8bJue9XCYIaYtsaLM6RHzUFTTAXyiNPa9/eQeRD/eD4qxMoOXDnamyyk5Nvp35dTRoP49elDjZlIj7cmJNdCYu6G7gkD2En3cMukkh7AQAelD6eRWbpOYhXqkCgyzZAMqzhIaS8ISXZQ2xz4UAl1MPJNkaI+RBZJX73I0L6cO9x8Iq91zRFOUKfT1c55S0AMX1httOcv6VbzmbNITQ1riQv+KWRYjrEGQG8AoBfGMDnCc+6Wcf71iJ0cnZYpkLA1SUqWq4dHj9HGP+aSPqchrC/A8ZObLdalIDvOZzO+HyYroLAPQia7S5/dBwN9OGUDXYFbjUjU4Nie1j+Meog/69YJ3ukWfFMWhzm0Ud337oWMzwt/rB44CKKLPcpIHigpZ3ERSGplCZGEc12kJlVbGd8gYTMryq7N4Lolz1t3ZLr+5jdlMdmNicgI8k0v69c2/Gq5Ab7R4iK+LYDxv1dqc4EuPXaSbBMsCD8hYDrX21+AP4RtpUwAuJSRPt5878So7t4L51qR9jrn53nK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(366004)(136003)(39860400002)(346002)(8676002)(36756003)(8936002)(38100700002)(508600001)(38350700002)(6486002)(66556008)(66946007)(66476007)(956004)(52116002)(6506007)(6512007)(316002)(86362001)(44832011)(83380400001)(1076003)(26005)(2906002)(6916009)(6666004)(16526019)(186003)(69590400012)(5660300002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?DWlMST8EAlPe4002TSthhnfMBpC/GosSRwI3BiC9abWyQLl7SEYkEjIbDX2w?=
 =?us-ascii?Q?2hfxe++mRBcbZ5vtiBZ7K1nfMyMiPqyXi5Tb+2KM7pd5iPNAhoItZhJETuq6?=
 =?us-ascii?Q?i/rGpshprtM8n5pl1kuUy9jzU0InZtaTYSDfnpxHu1/iuwgLVhXt44BbJ4D6?=
 =?us-ascii?Q?ZYB0iMtjZTTMmpUiQZhiTR86R+CHBePUgjuZGeYT+4pQEP7xQVU6Dt09TWQR?=
 =?us-ascii?Q?+g3YIob2xjUdQ3r1SUTNDMjmnAWACVPctdJ2mUlBykfO9j7IQeJXC4pwZvI4?=
 =?us-ascii?Q?gfBfTxeHjpNsyIs94hWtdxeZjaPYZ7vqY9z+LYADNqVlV7eJrviu9HOG8lJs?=
 =?us-ascii?Q?BRvhA8+/Ve4fAz2IfVlwCOeUcMvfKAS8oZdJ81fYhFdBRPllMu68LsUUy5jp?=
 =?us-ascii?Q?O19fL1gb1h0sGdLfOtmDhgTfd+FvCPQ2HcrnCp+GKc+5Rar2qxFEZSqlRTf/?=
 =?us-ascii?Q?/EbehroO4JGykUxyAHg0S9qGsQo/BnDzvRG4VmK/jTmJ80WGssZ9YCaJEZaO?=
 =?us-ascii?Q?GPHO5JPv/7zKU3/GHX6xCqH3QqfR/tQymZF0yx08OKd7v96r6he7WJ7sl5hn?=
 =?us-ascii?Q?K/O/RoA6mhC3PiSTQvJxzsLeAqndDChJMmloP+f8NQXFzwTHkW7InSMfwwSh?=
 =?us-ascii?Q?WgnTbDwB8RvEuoWMFX2Owp1VdpazL4D6jS80eCxSKPYXtlLBbkjOjsbqixCo?=
 =?us-ascii?Q?E7s2CXtDNHqhjzodfADOUYOpiJTQyrJ0e/Ix5v1YfxqDFz1qO5PIU1sMNZIn?=
 =?us-ascii?Q?7bWzXRETwA4zjpH3KT53AfvRppchhb2UmfTgtTZDDko3p1kXHvGB0nSFHvZO?=
 =?us-ascii?Q?ln7VCsRO1a57ypORb+9gZP7O/PlyxxteJ/mYYtyUwyvnI6f4LTlXrCnoK7s+?=
 =?us-ascii?Q?o9tMG7FK566zI+b0U+6jxTbifBvwN99Xult8KbeBiLD+rF6nV9c9mqPXY0Vb?=
 =?us-ascii?Q?0MuNMPF5sXUVwnmAHTz5g/FJMJ9ssC3JSAmr1HOb6Cz08Hy6d3Bm2j8FTvir?=
 =?us-ascii?Q?MTA7mkT9wnoFIObArN8R1maqTOZYPjO/f76xU0lYIzq7dIc0CVzFlQOJodEx?=
 =?us-ascii?Q?41eK78gKYm1Zy+yCBtMAcPPhjOCktoHVa8KigCPStIThLNJZvLR4SGM0fgCG?=
 =?us-ascii?Q?WgjGFaWU8lQ7dMODgshSxViYQ8ZTdQMy98ZsPHAX/FoRuGsPxJ7UqNY9eNq+?=
 =?us-ascii?Q?KWlz8zZJrSFHbg7Mg6fGvRFfFMlPDm/hcJ20IAMGWUbDFJiE6fD301/m0BlO?=
 =?us-ascii?Q?Zb3dDxe+/Q4KdvdXLbt1dMJAu3S/S39Slq+6PcXEjb3HrAZcCM0/vw1jFXQD?=
 =?us-ascii?Q?nMs90fIb0dWUojdpmCg94BM+?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1710690f-0d11-474a-0858-08d900b89c7e
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 09:18:35.1801
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DYB9HR4KLqySynW0axnEdbGSS5NmP8MWUCixipNDihnq6B1k7JDfuViFpxl13TzfcnkqBURHHE+Syubd4PhppfY8XD+NQfrGntyVWYpJyZA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2486
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160070
X-Proofpoint-ORIG-GUID: q00w28ObuFB8Tu6pi7KBdu2KabsVqywO
X-Proofpoint-GUID: q00w28ObuFB8Tu6pi7KBdu2KabsVqywO
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1015
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 impostorscore=0 suspectscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160070
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: cb9e8e1fb89d84c77c8035b2391359f9cbf209e6

This patch basically hoists the node transaction handling around the
leaf code we just hoisted.  This will helps setup this area for the
state machine since the goto is easily replaced with a state since it
ends with a transaction roll.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 libxfs/xfs_attr.c | 55 +++++++++++++++++++++++++++++--------------------------
 1 file changed, 29 insertions(+), 26 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 18a465dd..b3a8202 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -289,10 +289,36 @@ xfs_attr_set_args(
 
 	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
 		error = xfs_attr_leaf_try_add(args, bp);
-		if (error == -ENOSPC)
+		if (error == -ENOSPC) {
+			/*
+			 * Promote the attribute list to the Btree format.
+			 */
+			error = xfs_attr3_leaf_to_node(args);
+			if (error)
+				return error;
+
+			/*
+			 * Finish any deferred work items and roll the transaction once
+			 * more.  The goal here is to call node_addname with the inode
+			 * and transaction in the same state (inode locked and joined,
+			 * transaction clean) no matter how we got to this step.
+			 */
+			error = xfs_defer_finish(&args->trans);
+			if (error)
+				return error;
+
+			/*
+			 * Commit the current trans (including the inode) and
+			 * start a new one.
+			 */
+			error = xfs_trans_roll_inode(&args->trans, dp);
+			if (error)
+				return error;
+
 			goto node;
-		else if (error)
+		} else if (error) {
 			return error;
+		}
 
 		/*
 		 * Commit the transaction that added the attr name so that
@@ -382,32 +408,9 @@ xfs_attr_set_args(
 			/* bp is gone due to xfs_da_shrink_inode */
 
 		return error;
+	}
 node:
-		/*
-		 * Promote the attribute list to the Btree format.
-		 */
-		error = xfs_attr3_leaf_to_node(args);
-		if (error)
-			return error;
-
-		/*
-		 * Finish any deferred work items and roll the transaction once
-		 * more.  The goal here is to call node_addname with the inode
-		 * and transaction in the same state (inode locked and joined,
-		 * transaction clean) no matter how we got to this step.
-		 */
-		error = xfs_defer_finish(&args->trans);
-		if (error)
-			return error;
 
-		/*
-		 * Commit the current trans (including the inode) and
-		 * start a new one.
-		 */
-		error = xfs_trans_roll_inode(&args->trans, dp);
-		if (error)
-			return error;
-	}
 
 	do {
 		error = xfs_attr_node_addname_find_attr(args, &state);
-- 
2.7.4

