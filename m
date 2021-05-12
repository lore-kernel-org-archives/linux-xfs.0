Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1D2DC433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 17:06:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BA07613C2
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 17:06:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241161AbhELRGU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 May 2021 13:06:20 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48558 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239711AbhELQPj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 May 2021 12:15:39 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14CG8vlI052986
        for <linux-xfs@vger.kernel.org>; Wed, 12 May 2021 16:14:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=9B3JttikW7NWuVWI8toWfIcSinNX3j9FKB4kzTkT9c0=;
 b=NjWQBCBH7TJr3/f3C0O90+DXnkS2H0Fs6gzOZTczGdW0cqk4spG4aOH4yxvaUVfT+rH9
 Z/vu3I3NTmNSFIwZzSCGsz7NFtDapRm5yAPyOVLkHinQuruadbIxTcAU+AT2SquJO6CT
 tqI/plXliLk/kCZsrdAnUSpz7zJFOff9DvJf96V9PM9LLnQy4Bg+HRuMCpWwEz1TC53l
 NT3FYGLlYluU/fvjTZKXd/sLuYxnR9qf0rZ9yevevDA78NE4gCQYOuMDcOrkO6lpUCof
 rsetTUTSLA6cXK+iz2yBzn+3xUybSpaHy9wwcfueEhOidDx3AKbkQ/0ipRX8ucrpyv/U 0Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 38dk9njh8a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 12 May 2021 16:14:28 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14CG9fYU021006
        for <linux-xfs@vger.kernel.org>; Wed, 12 May 2021 16:14:27 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2049.outbound.protection.outlook.com [104.47.57.49])
        by userp3030.oracle.com with ESMTP id 38dfryyw0g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 12 May 2021 16:14:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZOYNfK05/vh88ikOVMERiELbruawTcbKqrMLtPa3jzSw96XWEZrO/HoooaaFK3sDPPebOqpFLYQFdvbW7yvAfkXVWPdClLrRNBFxwcCkWGpEtdXeodg6rAzSqYd0XV+J7sqsvJX1LfVBo5dGV2J9yYer0ORYNud6IZQsrv3x5E44KtUT9JVP6tiGp7dYxyDN1Yv4sIJm+gDHRG3V3ziWVXFs7we4zY21zYhn+xYeaWADZiXyHXkUBX+Z/AMR4xGCgDQn4gC/l0LcRztH4q1heP0LKcA7voXgrG5q83mdsPz4bgVxJw13sWbtHmReSDxKhXJnUkf1Gsh8VtfJ1Y/38Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9B3JttikW7NWuVWI8toWfIcSinNX3j9FKB4kzTkT9c0=;
 b=NZUZN1vSU4eFq8HlyrHv0lyzLRPsg7XPD9feHkXAwjaTfj3EQ1dKglVk8P1dApbvObKlWUSdP+gqQ9fEJbh9uewIqFBHxs+gb6+1NHVQHZULEdyMOhivz6LigYMu0HGldzUcwvTI8SCMgqeocmar79gDnHzkDI9Cgtb1tkFoZuenZR2flb0jk2G1YsWO13MWNdXLPswJ77X9Tgyf24+GHZiwhQFMdsrZKvEuEN5gtKmG0arJ+1keqybtTEZid1iG3GhOYEzW/JYjQgml4OartDId2uwO3XtnTL0OLrhQxv/hOKnt0Do0jz9QO+pjSxWfO/BHYf45nxgPMQjfu5TXhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9B3JttikW7NWuVWI8toWfIcSinNX3j9FKB4kzTkT9c0=;
 b=AUqHVf6y+zZP7eaSIbluhcMKvxCbaMqZ8zIH2plHfGmnNOdx6WL3VupiK6ersdrokTHhabV3e1FYMOrBi7xhq7msad2CNAYI/GmT2soN2vnf1T1FwZi+9+epb3lwp7mZH1g88Fu2/8a3ZIoxY0V9b4/h361eHq5+mQsFRV+mNVA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3112.namprd10.prod.outlook.com (2603:10b6:a03:157::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25; Wed, 12 May
 2021 16:14:22 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4129.027; Wed, 12 May 2021
 16:14:22 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH RESEND v18 01/11] xfs: Reverse apply 72b97ea40d
Date:   Wed, 12 May 2021 09:13:58 -0700
Message-Id: <20210512161408.5516-2-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210512161408.5516-1-allison.henderson@oracle.com>
References: <20210512161408.5516-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: SJ0PR05CA0200.namprd05.prod.outlook.com
 (2603:10b6:a03:330::25) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.210.54) by SJ0PR05CA0200.namprd05.prod.outlook.com (2603:10b6:a03:330::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.11 via Frontend Transport; Wed, 12 May 2021 16:14:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ab17f7f1-f20d-402d-9f2f-08d9156100e6
X-MS-TrafficTypeDiagnostic: BYAPR10MB3112:
X-Microsoft-Antispam-PRVS: <BYAPR10MB311271365B7CB4154843BB9B95529@BYAPR10MB3112.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:644;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k45HDqNY+tIpq47ktrrSPhFRnSbR5MvbzlP8f/FL3KuU5saciHpUvRNOk6Uwtu/SOmIfeKGYjAI71PWYzyXa0rB2i6uFD9xm96K3A3hTiywJbbIlr9K+cQ0n8FLjmLpvL3tNdIKCYTas5/xrmbAdm63yeOrqA4GHTtlUvve76q7ulIoQfOaHjJF+xOrWQuyDV0yrd5J9Px6VMjeWiaf++ZOkCGPfh0SEn4lUvu6vldtd9y55EfamJ/tVjHwDOOaCw0RL/b5eHQ4ZEBVMaealINPbl0vH1nm2Yw8drPNO0UQ5hS/vJBD48Yi18Wh+48BHoF+CRc07scjIiVlUI45YDbUZRtcpY/hYbyXPYvWNGNsRx9PagdcVRm9cml/kMhMI/sFRY4ALD7p47b+Zb3c1pPn9eTsQK6/Y8ZZ9HDnQ2AQGtNM4MepNM6YR1k0+otfN0/Nfp5Lk/miYx0x2gLh83MlhzNx/mg5Vpy5WmDROc3RUf8SzAZz4Zwhc/Abi66+rumhR2KNBuKeC652iw7dx8tNoJRiSHdQB8IhbvQdYTYfr7eY321mFur325gYzua55BG+6IOzERy7bE4+ZuCk7Xjj4q59mi6WVJ/tzVw5JaNS4bzOnyzH7lLF3K+qPQp0tRCt4cquVjfp4pX+5UrnRgUqaenv1xNFePgi7S9JPt2NT9sdoJ+82nvlOx5pbxto/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(346002)(376002)(39860400002)(366004)(478600001)(316002)(66946007)(38350700002)(1076003)(52116002)(2616005)(5660300002)(36756003)(8676002)(8936002)(66556008)(6486002)(6506007)(83380400001)(44832011)(2906002)(6916009)(186003)(26005)(38100700002)(16526019)(66476007)(6512007)(6666004)(956004)(86362001)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?iI5qPuXCAhOBOrwDbfjUe/uhZDbdKlvu2w3Nr+wEIGJT8igmeZu8b3jxG2WG?=
 =?us-ascii?Q?Sl9dPuhQFlWVOs8oXzuImpNpQh32eDjKHtMHoHqA/mQ0IRY0ZQbYN033E5jb?=
 =?us-ascii?Q?ikKE5KQodB9vzJxBTEiY70DXOzUlU0Y23yy69FIsxERygK2By33nKVhch+hN?=
 =?us-ascii?Q?Y247eJlLZLzJGCdSWWq7IIU1vT/Cd/immMlfSeinY4fRS8xcBdwf0hw+MXvY?=
 =?us-ascii?Q?N+7/vAlsXlm2MdChf7JqVLovOEL+/oIcGP3iIyBpHHUkICApo2WJ0uqNl1J9?=
 =?us-ascii?Q?z6EObBmvLyE1XHYexpjZ/dYCKKiSl6RMHCEF+WcWHZ0T1kuLxaI1tHd44x70?=
 =?us-ascii?Q?1YJuaHLoWHnjg2jN3bfK9qjDQ1sBj7oGxFlE+AHN1SonuRzoPq5bXi7ySxwt?=
 =?us-ascii?Q?bcIU8iMRFODS1LV3Sx03Zn2SVEOD3nfPdE5hHAMgrqo1IMpxYGZIpT4+CL+2?=
 =?us-ascii?Q?MYHiRHNRRaK/O/HauO9r6QqJcWGrNHfhJrHjyILgcl1obf8a6mMWzXsPV4c/?=
 =?us-ascii?Q?v4Eh59RqxsWMBnHyaoWTa6lEUpxyuqT0Yqw2QsflznhWvsbra2AGXwhqE6/F?=
 =?us-ascii?Q?261ABI0Yct8k0TXq1R3h6Hz2O7brVp0i0PhHJI6K5Vd54aXbqvsp8Xw2A+rK?=
 =?us-ascii?Q?yrm8j08qrGeP7MiOkY+/X5e1PaQ5aPOEaT/aKNUq830eOldjThm2dww4U2Nd?=
 =?us-ascii?Q?EiAlkThW2NkW9BgqoxTMJ1qS0AfmQCB8vJLIRPCw4VvIdq3WGUf5AnDX+O2L?=
 =?us-ascii?Q?C1WRJY1+3GowvIiWekhzUAeHCPpMD1uhbIHAcVDtoyjA8CP2XZoaCj/ylsR+?=
 =?us-ascii?Q?1FDu3+VF0Pm6tIfm1R+9Ttl+fJ41tVhoCXzpS+j/X1PvhCbICCyQIZ4ldjn0?=
 =?us-ascii?Q?5GZq6eybCQz1lCfz/gRKLzQLX5zUVELB1g8Dtbk+M5CUz8tkq1lqj6bheFNN?=
 =?us-ascii?Q?EaQOwliP9QzW2JlFVcIrmkboJYK1fV4sYo0Wd2lF5CFIVtO5roJ+v7ES/Lw9?=
 =?us-ascii?Q?dIZS4YpoFJonR7mpgQtRwuNNAQLU8nC+b6XaUyGMD8pjE7tkPZpjfPuW3mro?=
 =?us-ascii?Q?FZR+GqAdoWi9/jJtQaiza1otozNNlF1BU1L6D6K8GezFqO7CsNzK6K7fMStV?=
 =?us-ascii?Q?Lg3gWvH0a1U4mFe/gsCt5hqQ63rCQ9+joxUjbBTaXYd46sWt85wiR4OQbPhb?=
 =?us-ascii?Q?7mpcVM3ouanJv8MFOUITfc/4F6ojyXqeSeTtOro3XLp/oBi98M9Jy0/Wm2Hy?=
 =?us-ascii?Q?i0UaZgGgWWbe7e2eD2cTs3yzJ6qDYjC69iigD6YPCmqYN41g4+kkSRlmoE88?=
 =?us-ascii?Q?OVRmXrHQ2blnSXoaPVPAJ0Jx?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab17f7f1-f20d-402d-9f2f-08d9156100e6
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2021 16:14:22.2503
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YJr6sP6g0AUWhVoXc1fY/XX4xKgSx0tHs0amaj3Dz2VmXpDROz/I1DSh/BRnfGMlDEbmpeseF3OGIxeLTv9/v10JesuoF3IrA1bFjNZ6Dvw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3112
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9982 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 bulkscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105120102
X-Proofpoint-ORIG-GUID: ar4WOAtzkPuxwsJB6NCEAlJrPDbwaCvi
X-Proofpoint-GUID: ar4WOAtzkPuxwsJB6NCEAlJrPDbwaCvi
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9982 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 adultscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 lowpriorityscore=0
 malwarescore=0 priorityscore=1501 clxscore=1015 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105120102
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Originally we added this patch to help modularize the attr code in
preparation for delayed attributes and the state machine it requires.
However, later reviews found that this slightly alters the transaction
handling as the helper function is ambiguous as to whether the
transaction is diry or clean.  This may cause a dirty transaction to be
included in the next roll, where previously it had not.  To preserve the
existing code flow, we reverse apply this commit.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_attr.c | 28 +++++++++-------------------
 1 file changed, 9 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 96146f4..190b46d 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1214,24 +1214,6 @@ int xfs_attr_node_removename_setup(
 	return 0;
 }
 
-STATIC int
-xfs_attr_node_remove_rmt(
-	struct xfs_da_args	*args,
-	struct xfs_da_state	*state)
-{
-	int			error = 0;
-
-	error = xfs_attr_rmtval_remove(args);
-	if (error)
-		return error;
-
-	/*
-	 * Refill the state structure with buffers, the prior calls released our
-	 * buffers.
-	 */
-	return xfs_attr_refillstate(state);
-}
-
 /*
  * Remove a name from a B-tree attribute list.
  *
@@ -1260,7 +1242,15 @@ xfs_attr_node_removename(
 	 * overflow the maximum size of a transaction and/or hit a deadlock.
 	 */
 	if (args->rmtblkno > 0) {
-		error = xfs_attr_node_remove_rmt(args, state);
+		error = xfs_attr_rmtval_remove(args);
+		if (error)
+			goto out;
+
+		/*
+		 * Refill the state structure with buffers, the prior calls
+		 * released our buffers.
+		 */
+		error = xfs_attr_refillstate(state);
 		if (error)
 			goto out;
 	}
-- 
2.7.4

