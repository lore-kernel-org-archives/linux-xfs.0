Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F01DDC43216
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:19:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D557B61107
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:19:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235508AbhG0GTx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 02:19:53 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:24694 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235558AbhG0GTs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 02:19:48 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R6G3ao022414
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=kR432GBfiR8VhtMwV+h8aDCBcKV5kPlaLIGN2Oc/t4M=;
 b=OcgVj5zK/qF2MiXCcKFh84LisbSI+V8jo10XOS/YStK36CqsvodlPIYYHyTycZFhsQfo
 GUZDkvJL+RWXuUEUCxIWL5tyRw+Y8X6zIBviUYMVg8ew5JJ3jymQWg2CdWoXd9JoXIb2
 Ulf0FR3YU6j/33C5dkuYk1tbmgvcl1Hs1wkpqZlxF9PU/YHkEmaXQ/E1LaJ8qJMQ7SYD
 XwtOeN1/cjXxiBVqBPXe36ArW3F9w/i0LUSTJWIWtGn2cCNW+7y0He8MbCN7yzgSJmb+
 XjRLH2UsPvLFC4ChYkhTM8OLV8K0VRm3YeSY7x16TPG8R7V77BXn9ZCJLFbQnkUBgkPn 0g== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=kR432GBfiR8VhtMwV+h8aDCBcKV5kPlaLIGN2Oc/t4M=;
 b=saV/poR+8HAL3VqXpdLvxrnezwxonfmUQ763duxgTuKWt3ornT1L/JZvkPf/NmeCOVJa
 ZBm8wXP72iFJ1jNa8DHZ3oE0UL2xYp6D3/9EvrMReuJysH8QHnpOSpD8IKbwB+KNPBbg
 VQZDR/TvSHA/mBeKIOwjrrwInhLGLiF1gjiMConOI535S/Oid2jO7M2S1F+Y7hfECuL1
 DOG8xg8Z/kOhF+SmYzCSyp81p/x7AK1MwCozA6rJpwMA2M+vgZQmEW/Q7D6rTbL6wo+m
 YMr5hMb8nq+SsdqjWk7vv4c8QnjD+NQyEmKUVlzSIl3RyE25hbTW7zxGNuF3Dc8z3cP1 vQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a23588umu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:48 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16R6EiaA065026
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:47 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by userp3020.oracle.com with ESMTP id 3a234uvntm-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mVRhgSRnPz4eWcLjxF2EptVsM+WgI3VHEr4JIu3uepY6CWijGxy+xajkJkkA0nrU/OSJ8mZ0plTKhl2pMUs2bG1n/eXBQYDVJHP0Noi+oq/K8vCJL8YBKzvnPtU8Bf6D2YncPMjrvva/eEdEXRt7Hy+OwQofxpKjs+aogisIJstRSPOEv5A0aTRVCfl74rrKs417uvqnhd5YHthGlU4mzNn4qOypVUza9H2HguTK8Ta2JAsbXtZp7ABFGdv8vlYgayo1QJqhC22oHPNO4xCuZvOtwVuDD7XPjm7mp0WSqmPmP+L1VJDx+LP2crmkKZWhmD3pvV9J55d2cjGhrr0UlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kR432GBfiR8VhtMwV+h8aDCBcKV5kPlaLIGN2Oc/t4M=;
 b=XAhJAqt8QIiQkPoN8DpwwNBvsdyADfwUUJy7kbkaPHCOxO6RLGsBku4icCLfBPNdrzky2qXMQ0I4ogg1Akle6i+pfSGE9xu4gPPqrSKATf+4Nd9++3t2+6aGX4Dt038Prx0I3wKIG7f1SkhEo8lPilKbyZ+6K/xepdWXBeIDLhn6/29h7zj0Y1JB2as7pjEYv4FXBn20VXke/96duh9NPqFmAzA3i9kHFDAsKlFcQM0fc7EukY/d0uccCqoGRDfGoBRmJ38YMsl2rxKyz7YFPIUY8R6GEet7HYkjE2ghGRLqkxy/HYKfbBHCvpvMOGw6FSMux0VAvF6YSCYS8Ud+UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kR432GBfiR8VhtMwV+h8aDCBcKV5kPlaLIGN2Oc/t4M=;
 b=swfj90dlRCBJUltjKAiYtcNRYugsIjaMtneOb67cv/Sm4sZVweVspo0rxxw2Bya/CS6GkJ7sS3wbQH6DuBaOq1t/y2Exjv5NLQPNczdqJPJYB2L9cf/ce02TSJrUrudAbPEb+TORTyq5TLDLcZKkFwXdpJHDSEfNgg1XdJyxFwo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3669.namprd10.prod.outlook.com (2603:10b6:a03:119::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17; Tue, 27 Jul
 2021 06:19:41 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 06:19:41 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v22 05/27] xfsprogs: Add helper xfs_attr_node_addname_find_attr
Date:   Mon, 26 Jul 2021 23:18:42 -0700
Message-Id: <20210727061904.11084-6-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210727061904.11084-1-allison.henderson@oracle.com>
References: <20210727061904.11084-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0074.namprd05.prod.outlook.com
 (2603:10b6:a03:332::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.112.125) by SJ0PR05CA0074.namprd05.prod.outlook.com (2603:10b6:a03:332::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend Transport; Tue, 27 Jul 2021 06:19:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e93f8752-0ced-45d8-ffe1-08d950c684a1
X-MS-TrafficTypeDiagnostic: BYAPR10MB3669:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3669B15C9485DCDDF32EDF2295E99@BYAPR10MB3669.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HQcSvDibb+JLIRRk/3nozR/slBbJl4VYbDOlS9yvhwZRQctWJvztEqk5DzB17Ug2VxYF1zhYm+aNKbvlU0LVzgki0TcSADGK1i0zhEEehuvD8wDFieQOFWszdB+rH+RV+cw0h5RMRFLrOOSnYGstro299pHUs6iGFkwM/u5PxP4MJ+gnVMqg/OqrG4TMuAhmo7/El9TA/g2zNFDQ3GxGw51JieIehyQnWdnsXxGl2NlyzjoK64GO58aU4X3ncW5t/LMomSo3vwni2gBLXr9+hYZ7AW+v2UHCAlna+O+OoKNIb+ktLutTH303jWlXQDE032KCsZ8GYkcdIbSX1N6Q5tXoHOPbD75hLuYm9OqYcssljpo4feQ4NZsZLynbaqkf0VSv+Drub9180fXMxSKhp0WmvNmK/rVAz+SEyDnS0NWYlbaGUdzZFfVFR0/tLseLU4k1sNIIlmRELnsdFTJCwIvaBNnwDQKs/qf7Fpc92HsDUbFG/HWxX0n+2Ntq0sfv0aA4+s1oj2B2bVOV3rsvtGZFqjsvrDb1OU2dmkz9l6AcdIG3JltxDsZHSBu6eyuYiwSNxG1N1y2xZGU8mb6kEhoGDNplz+TrlLite7/34RJH2OSAUAs1oVDnL95dMeHIVMe71p6eIUOItU7+MpBkuFGYcHCS6hLPcdTlz3jL1VimBDUazDDvSLdwae5Rfn/mymorEEkMncapuI4NpEogiQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(136003)(39860400002)(366004)(44832011)(478600001)(38100700002)(38350700002)(52116002)(2906002)(6486002)(186003)(6512007)(26005)(1076003)(8936002)(8676002)(83380400001)(6506007)(5660300002)(36756003)(6916009)(86362001)(956004)(2616005)(316002)(66556008)(66946007)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?V4BS01h6U66KnZWuiURoC5f3/G+o43p7OKG8g1EavcxJRTva8sMowjdUyRA3?=
 =?us-ascii?Q?p5cm1zQzAuv4IMCXEnflcyxWNfTLX1IkfwZYD03Dg7/o5KTgrXOzDmnHul74?=
 =?us-ascii?Q?6x+RrKl5qJM0bS4pksfMDzaRA5f13ImZRjJ7d620CQzCAO8DpjIwkilmpzKj?=
 =?us-ascii?Q?RIVbbEeCr7UquOW6PNMHN98OMqK6h2XFtn2ukwensSliWiOxJsGWtO8+IPB3?=
 =?us-ascii?Q?g7ZkLVpfo+ewQ+wLqdszsvxaPkQ1uj0abZuGyYIfr6yMLVZ2R0dCmvARPgMj?=
 =?us-ascii?Q?C7NBXXJTycEZv4/eA/QCwkkileTK2FXWgbxYmPd3T2avUbsK3zOXaEusczDU?=
 =?us-ascii?Q?h9gbVQ8vz+Czr8PdeiiKPLSxMI7oFv8+P0kNK10owK04v5a1aSjrwnSh/aNc?=
 =?us-ascii?Q?TwkMIJukj8KXeD4muyLM1Qj29kyB5e2pmRbphZk4c3HXGyos11PC7CG2vCoW?=
 =?us-ascii?Q?H2wMrfX9+jH0+XiFTYe87YyNb+PwgMx3XV8kkqrxQAdDDLFE6CBq6oRVutq2?=
 =?us-ascii?Q?QadN8plOtexbz5bFeUemxIJZEQW2zP+21CwvAd55yRzrrQQ62b0II4GKVLQx?=
 =?us-ascii?Q?6DLUOap6Sn2Mbg4AeSidILNn/vw07jsDDV016+3x2dUQwWncQAfdMEwf2o49?=
 =?us-ascii?Q?x5oAy9SdQZ5mFFR/j8WOS4VxwquhoK6JWdeHLZSaxMgSQZ7A7QpZXBl4G0Oe?=
 =?us-ascii?Q?2KLjGz7k7jPZP4aOtmmqBObvu8NU0ZyuuvK8vE8Dl03YBca9R+lVpuJZoJvA?=
 =?us-ascii?Q?1IIwPUYlohxRhyadyDVBbY5VwKVLJKZ/4xQ8V3dCwrDE8tszjjgigMaUBBi0?=
 =?us-ascii?Q?1BN5uRHBHO5hy4ex3ba1NDbpTruyO5Z+YN1SYH2pxXuERaIv67paCwkjSFm6?=
 =?us-ascii?Q?8Y2R9xtJdBPFSfXT651AqpYj3cQjur0H6yhHFae8Jjp5vs3qSWrHk8FO9bIg?=
 =?us-ascii?Q?KEAgYwTFdvUbL/jOHGnnUcFiPeBsYSNqWBjOQLq7sS0vnZ5oddU7EEU9KVVx?=
 =?us-ascii?Q?6l07O5ZYtrRgttiDOxY1vGKxTTwSlcFLtarNw5MtF91NVAbpBh0F19jYs/QV?=
 =?us-ascii?Q?pl60RFGMjvGU5J+BBQy4x7XbK9CYCZ2g+aOhMRWnvoJuf8lH04QZDGpAbTZs?=
 =?us-ascii?Q?AnoevRzrvqLY1/5O0GeFpwBecmB18f4T4/IunZ94xB8RhH2031VcDpFmIkHB?=
 =?us-ascii?Q?8iMAloQ/iVwMSuySZBS7uzpomS7XKQhBd2i/76TONoFEx5xMYzjJ/7IUoo6B?=
 =?us-ascii?Q?+zZlnqX6+0L6ncibf6tI8hU3cuiDM2oaQAgVZDMX6O1aw7/EY59YlrMocpqo?=
 =?us-ascii?Q?l+ML1KJTvDgwfYYeHGjZ3GL5?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e93f8752-0ced-45d8-ffe1-08d950c684a1
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 06:19:41.0981
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P5QaQssLQfv3KA1PqhqB3J/HaOrzXKuhKxS/BkOiZNK///sQyNWKky0zFs/Mcejup5RYmdowwlrcMVXH1N8Exnjc3Uyju5I7aesJoJGIeyU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3669
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107270037
X-Proofpoint-GUID: nXcqZ6Qt43kKC9Z0oINlsZcY26sNNM5_
X-Proofpoint-ORIG-GUID: nXcqZ6Qt43kKC9Z0oINlsZcY26sNNM5_
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: 1aeec98c3f70bff14cc0e65ef898e91c2c554d41

This patch separates the first half of xfs_attr_node_addname into a
helper function xfs_attr_node_addname_find_attr.  It also replaces the
restart goto with an EAGAIN return code driven by a loop in the calling
function.  This looks odd now, but will clean up nicly once we introduce
the state machine.  It will also enable hoisting the last state out of
xfs_attr_node_addname with out having to plumb in a "done" parameter to
know if we need to move to the next state or not.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 libxfs/xfs_attr.c | 87 ++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 54 insertions(+), 33 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 158149a..32a51d5 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -52,7 +52,10 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
  * Internal routines when attribute list is more than one block.
  */
 STATIC int xfs_attr_node_get(xfs_da_args_t *args);
-STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
+STATIC int xfs_attr_node_addname(struct xfs_da_args *args,
+				 struct xfs_da_state *state);
+STATIC int xfs_attr_node_addname_find_attr(struct xfs_da_args *args,
+				 struct xfs_da_state **state);
 STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
 STATIC int xfs_attr_node_addname_clear_incomplete(struct xfs_da_args *args);
 STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
@@ -287,6 +290,7 @@ xfs_attr_set_args(
 	struct xfs_da_args	*args)
 {
 	struct xfs_inode	*dp = args->dp;
+	struct xfs_da_state     *state;
 	int			error;
 
 	/*
@@ -332,7 +336,14 @@ xfs_attr_set_args(
 			return error;
 	}
 
-	return xfs_attr_node_addname(args);
+	do {
+		error = xfs_attr_node_addname_find_attr(args, &state);
+		if (error)
+			return error;
+		error = xfs_attr_node_addname(args, state);
+	} while (error == -EAGAIN);
+
+	return error;
 }
 
 /*
@@ -896,48 +907,26 @@ xfs_attr_node_hasname(
  * External routines when attribute list size > geo->blksize
  *========================================================================*/
 
-/*
- * Add a name to a Btree-format attribute list.
- *
- * This will involve walking down the Btree, and may involve splitting
- * leaf nodes and even splitting intermediate nodes up to and including
- * the root node (a special case of an intermediate node).
- *
- * "Remote" attribute values confuse the issue and atomic rename operations
- * add a whole extra layer of confusion on top of that.
- */
 STATIC int
-xfs_attr_node_addname(
-	struct xfs_da_args	*args)
+xfs_attr_node_addname_find_attr(
+	struct xfs_da_args	*args,
+	struct xfs_da_state     **state)
 {
-	struct xfs_da_state	*state;
-	struct xfs_da_state_blk	*blk;
-	struct xfs_inode	*dp;
-	int			retval, error;
-
-	trace_xfs_attr_node_addname(args);
+	int			retval;
 
 	/*
-	 * Fill in bucket of arguments/results/context to carry around.
-	 */
-	dp = args->dp;
-restart:
-	/*
 	 * Search to see if name already exists, and get back a pointer
 	 * to where it should go.
 	 */
-	error = 0;
-	retval = xfs_attr_node_hasname(args, &state);
+	retval = xfs_attr_node_hasname(args, state);
 	if (retval != -ENOATTR && retval != -EEXIST)
-		goto out;
+		goto error;
 
-	blk = &state->path.blk[ state->path.active-1 ];
-	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
 	if (retval == -ENOATTR && (args->attr_flags & XATTR_REPLACE))
-		goto out;
+		goto error;
 	if (retval == -EEXIST) {
 		if (args->attr_flags & XATTR_CREATE)
-			goto out;
+			goto error;
 
 		trace_xfs_attr_node_replace(args);
 
@@ -955,6 +944,38 @@ restart:
 		args->rmtvaluelen = 0;
 	}
 
+	return 0;
+error:
+	if (*state)
+		xfs_da_state_free(*state);
+	return retval;
+}
+
+/*
+ * Add a name to a Btree-format attribute list.
+ *
+ * This will involve walking down the Btree, and may involve splitting
+ * leaf nodes and even splitting intermediate nodes up to and including
+ * the root node (a special case of an intermediate node).
+ *
+ * "Remote" attribute values confuse the issue and atomic rename operations
+ * add a whole extra layer of confusion on top of that.
+ */
+STATIC int
+xfs_attr_node_addname(
+	struct xfs_da_args	*args,
+	struct xfs_da_state	*state)
+{
+	struct xfs_da_state_blk	*blk;
+	struct xfs_inode	*dp;
+	int			retval, error;
+
+	trace_xfs_attr_node_addname(args);
+
+	dp = args->dp;
+	blk = &state->path.blk[state->path.active-1];
+	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
+
 	retval = xfs_attr3_leaf_add(blk->bp, state->args);
 	if (retval == -ENOSPC) {
 		if (state->path.active == 1) {
@@ -980,7 +1001,7 @@ restart:
 			if (error)
 				goto out;
 
-			goto restart;
+			return -EAGAIN;
 		}
 
 		/*
-- 
2.7.4

