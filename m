Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44A98C4332F
	for <linux-xfs@archiver.kernel.org>; Thu,  5 May 2022 01:18:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235148AbiEEBWH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 May 2022 21:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbiEEBWF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 May 2022 21:22:05 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B385F54F8F
        for <linux-xfs@vger.kernel.org>; Wed,  4 May 2022 18:18:28 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 244KHMAw019152
        for <linux-xfs@vger.kernel.org>; Thu, 5 May 2022 01:18:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=DXT0YgLorYkNPkFLgwDVxI7ImuYa6nU1wLxtZeeDjr0=;
 b=0/9VrMdSb0e9+o8rCymyXpBgmRliGWcccdcsTDXsgpU5X85TULRebVfdOCiWRUg9iqMM
 VdkdvrGYDkNu7EYbbOfSWWmObLy4DSfANaQri4OEFAtGA8Zs9nEEreNQXfSYx31fqPgz
 m2YLm+oXs8ijtxJKsFVhDhDq1e7ZqLJCEliwcwFG1xQn8FHV5gfTkfEYRKF7f+ptm/ML
 XCfVeTS0fJY4yZnPoWzdzVFp8VPrQQ8O3c7D8zIDo4+ghGF5a5ikS43k1YjoPqfOs5b/
 sAlflGOe7Q51yzJBcfTpx7p03+AhQ/v+FCiIDr7BUdw71kH7s9cGM/Np45vtxkWBa0p3 cw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3frw0asrn1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 May 2022 01:18:28 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2451AgXR006894
        for <linux-xfs@vger.kernel.org>; Thu, 5 May 2022 01:18:26 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fus8xd1t6-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 May 2022 01:18:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VSuCE19Qw6fP3VxArJx+n4JANuKTosK/BU65yxbKTC5Dy/X1lEqZQ4tU6lBfMnFiV9nSgdLIHqjy8SuQYIYnbmJmkN1sMhRqp+XPQsJ5dCS9wkqyXjNVwxuSEBXRd1g8NxQWA6GKAju4vVTSC2t7ZcNqLsUFhCbZp5PvZ7+fQmhjfYVAYimMCi6sRk77rjNmR+K50NJXdwgtvU1B2+cSzTz+SkwMvrmZ9bgU9FBzaBi+nGwqAW8HFJx8YHkDOFk3J0ZaMf0f8GGexOpCinDDXKdDKLe3p4MCd8S24NtKDYW9uwfQ5WyO0UZNgleHXrqosixHV3frey7Xwkxyat1WaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DXT0YgLorYkNPkFLgwDVxI7ImuYa6nU1wLxtZeeDjr0=;
 b=BQVWMoUqRAoD5zyGnVRagSyoFH+k9xADe42WqWDGYtIjVQkr2QXRy7X7spbTWKJveNK95KCjdOfskbjo2oAjIeTQBr2xdmTFcjbMuB+DRjUuNG7OlwUsTPtuAFnE9FxzbniJcUuHRrFCmYFapHSMJc3bZQN+f7oyyjeMKpH+sKQS2oMJEk1ou7j4+W/rHHwffIWwEm72u+Bl+qoLOqbgDz1cEfRGIq1OslPcxgiT2nkW5VhKVG7Zp2zjHkC1TGWCARaUc9tWxLqWzgOH6WxzUufDjq4dgm4wTLT/gA1FbthiJUK0ERKc5ur0bCckHdSWLbekY7JQj4kGFcx5JtyXAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DXT0YgLorYkNPkFLgwDVxI7ImuYa6nU1wLxtZeeDjr0=;
 b=zAGG3FJ8Fj7j32iEcRVL481TfPCgDVpriqO5qCPYrzUlakXpK4hl/eJz/yUvNbMJXBjYS0QgLkO+gpyE7bNb2p+LMJX49EyJQPSijlikqFgdIjtjlJ4ML6hQFrRqeR2qvZVIJ68C2D0/+Z/Se9XDfnyEwtjNuWMORwsEE3AS964=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DM6PR10MB3193.namprd10.prod.outlook.com (2603:10b6:5:1a6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Thu, 5 May
 2022 01:18:25 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::8433:507c:9751:97b0]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::8433:507c:9751:97b0%3]) with mapi id 15.20.5206.025; Thu, 5 May 2022
 01:18:25 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 3/3] xfs: don't set warns on dquots
Date:   Wed,  4 May 2022 18:18:15 -0700
Message-Id: <20220505011815.20075-4-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
In-Reply-To: <20220505011815.20075-1-catherine.hoang@oracle.com>
References: <20220505011815.20075-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0118.namprd03.prod.outlook.com
 (2603:10b6:a03:333::33) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ba9f81c7-0007-4c5c-a550-08da2e3526ee
X-MS-TrafficTypeDiagnostic: DM6PR10MB3193:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3193F71D63F14276333A5C0489C29@DM6PR10MB3193.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2EYhHEdtPDc5C3RsFI5sF54/CgMR7dhdCiPQ3Y7RlI/8TiNzQ7b4TY+no/fpP9HUKlPHJX0pwinmPBwFW7wZz75WuF3xVbFdDT3lLf8PlXLOP8sThtyo8NsYA3O+3gHj2lsrrPdJ4fvv66Cftqm8IhWqdywzKwvP+XijCd27pwSAn+KdW5WT4en6GA08wXG6RUvk4e/wBq1LO11drX/kVX5sHQE+N0XEcP4xHSPWBOuHSG+X/7Ht9kWWQGGeWNUEtRQ2MuE3UVHn7n0BJS/Xfu1vY1JZMG7ZyZbzbE9aMcyG0p7TDZZkCkp1caeTIisPX8I13cTUBB/6EOCO1oEXYVumFGs5K3C25w/r52VW6kQlB7XDMlQKRosIWl2yKgGV3Th1qV1HOusJRxPkRDisvwc7b2hDA3gLTFAef8fImSXWZcwB46/RhlvewntDL49S2aTHxoPfrDeSFmY4cHB+pkhoWHL/tzY3JFDcp4IkiJXcqoOmf128IFePSPNJ3fk6FNnwJ29925oAMV6mXjh78LT737VvIwxOeLCdgyMQRRIOAyZT5taJ9H8McoiomGQr15Dw+pUrlr/T2q/vnogUe+dapFIN+VPbsgV9fzDUz3XXaJaOxhU2oeuf6IcQuLsek7WRh7pqKaDxZYMnc8am0A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6916009)(6512007)(6666004)(4744005)(44832011)(2906002)(38100700002)(86362001)(52116002)(6506007)(508600001)(316002)(5660300002)(83380400001)(1076003)(6486002)(2616005)(36756003)(66946007)(66556008)(66476007)(8936002)(8676002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bpnS/hthMDxovw7mMijdDLl4uix7eoWOCGs7+UNd4+aoEQ5qhC3pREq4jhen?=
 =?us-ascii?Q?4ezxqJVbJ5MXXxjX2xuT3zTTwogiq2RWSowcKm45ia1CrETK2yuDi3vmab8E?=
 =?us-ascii?Q?3WHWgXjF8ysNd//y0Idmp4KgqSpU1xi4MQWE0TCWQn2IrItY48N44yDeTlwb?=
 =?us-ascii?Q?5wxqwEwPKT9gpLSFMpX/VMa0RE+tpcFkBV+Yr8SYpXenLdWbOfzzIUtHq97k?=
 =?us-ascii?Q?9BBE9qLw9EFwlKr8W1EQwSINYAVeKn/0RTll/bOTnpdDCQyS12QwKiJ02+Vl?=
 =?us-ascii?Q?D4nV6RGJLpOXM+UfadFP/0U+3ZgCk8zazA9YVQzCQvO9zE/uNWGxAbblIvR7?=
 =?us-ascii?Q?fEM9lvHfHQXdu2oXUsagKbubFi5Pnjet+A0e5JmYHnvXJd1vYtnhXBDjkH5Y?=
 =?us-ascii?Q?YosBvhd5jTtZ12Y8pViq9ZXruhCtqiYgJsJUyroKvR5N3abPDMyXxXkJ0Uub?=
 =?us-ascii?Q?8+WYBWIxEqGG3/pWtKftUNIWuTo/ImGdQ/IdCDYoI6GOksYEQXWtpTQ9NIks?=
 =?us-ascii?Q?AVHGrJEBDPEEyZNdloNaq0DRrrDaQyuwdH5DNcRjk0qVcXVNKzs6CPmkGpq6?=
 =?us-ascii?Q?fUYR1PNZ3pDOSnHID12o82PYVX6lxdfkMtNOozymilQEH6+cSgxB1JsbYNQG?=
 =?us-ascii?Q?JxNcuGqm+teYHthsW+NZobWDOTTZuHjoNWg6jimHq3gdoYfuiqxeD8wP39AC?=
 =?us-ascii?Q?9TD7qfJJEclx36JI3BHZaIg8vL00boPxdS8K8buYW+NPNgdzuwpwCmz1ukQ1?=
 =?us-ascii?Q?HNSGNq8pMQaTzMrSKnmY6A9Qjj6EZhP0rU4khXsaATNeSJJ4dbkVHLM3wQAK?=
 =?us-ascii?Q?/ebKBlRH/zKFPKcmwgi2eqfwk0yHuesIf0dT0+3m+3kloRfaoZhqEi01VSbO?=
 =?us-ascii?Q?WZ6S72pAQfz6TroGpuK7WvF1qmiMML2QX6MqbKFWSwouqFJ6Q3GPxT244u3I?=
 =?us-ascii?Q?Dd963oRSvvoXZsbG1M0jyV0XsEuA3igWWvRWyBd1tUrdlyUfzI5KkKIBsaAn?=
 =?us-ascii?Q?DwPBxYufrH0be1JzOPwvh9FBqYCTHvpGsFgX5Wz6gDCFj3ZF/UFzAO6hiOBV?=
 =?us-ascii?Q?caazAKXzi3MQOxqCzsjenlsQpr7L4VH30Pn9/3wCZHstnlFyMbHZpeZNCTS3?=
 =?us-ascii?Q?ae+rigr5+Ju3/+HzUOey6pii1qAqd/AUzUzmDZu4AHnH1T8faYGpTWBi8c7x?=
 =?us-ascii?Q?bxVTf0EOm2pAjd/4uVZ6rlw21e7uSz4G2aqJ1Dny77WzJHklPPfcbCDYxrSF?=
 =?us-ascii?Q?JyOj6qP7Ij40VUpq4tzuMM3M3qCBKR3V+FNDcPbTzdW1LkJvtzn1EH+HRrYR?=
 =?us-ascii?Q?JqreRLuKoBYj9PL0fmtKl7TiZPHibD2qULNHsXaJG1w+KiMiHYnD4G22FPs7?=
 =?us-ascii?Q?K+JDqiCNhG3aV/6fi2C59LuA8QBYTaXh6dIjBxaOhvFF4rlWqsqfivz11JQl?=
 =?us-ascii?Q?+NpCVmBbFwW5Q3GhbZxRRovAB0YDY5owz2yubfHCtATlAqFMNKgH3Q2YwWf3?=
 =?us-ascii?Q?6m3Hsz2AsMivo5Rvz7duCho21lRhCvsN1sZg7LqluaNBrKEkmerSo1YQUza/?=
 =?us-ascii?Q?ty3AulB5JcnL1B2CboMdZ8sjmFGOfPLs76XVK/xAYfLE7QikG/8t9rg+NG5I?=
 =?us-ascii?Q?cPc2a66Brgol3jmSQQ1aCuaHX11dlfz9927MM+q8qnLVNKqvuUje7Z+All8C?=
 =?us-ascii?Q?nq0sWsEMP2jX0RRolXeAMGEWvHuhlDRbKUxYugwracbAFaTK5Dap0qSnlEzH?=
 =?us-ascii?Q?oF3wDv36OY/tfAZW+BGjNZ2/PpPDWEmIYDLoELepsRATUmc4wwq7DeCvhbgT?=
X-MS-Exchange-AntiSpam-MessageData-1: Ph+lzspTqO2Dfw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba9f81c7-0007-4c5c-a550-08da2e3526ee
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2022 01:18:25.0008
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JXOVL7A4rNc4NrDj6Edwdo9qKl3Ki1ZPAfxz2yvQp5dybfbK+s8G0RQgUbLzzffCx+znCecIMTZNEd8Bh7SCa7ysBCl4f4/UE4l6Ja76JQA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3193
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-04_06:2022-05-04,2022-05-04 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 mlxscore=0 spamscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205050007
X-Proofpoint-GUID: YRbli004WBedaXEUwxwmoACPQ6oAEoHR
X-Proofpoint-ORIG-GUID: YRbli004WBedaXEUwxwmoACPQ6oAEoHR
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Having just dropped support for quota warning limits and warning counters,
the warning fields no longer have any meaning. Return -EINVAL if the
fieldmask has any of the QC_*_WARNS set.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_qm_syscalls.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 2149c203b1d0..188e1fed2eba 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -290,6 +290,8 @@ xfs_qm_scall_setqlim(
 		return -EINVAL;
 	if ((newlim->d_fieldmask & XFS_QC_MASK) == 0)
 		return 0;
+	if (newlim->d_fieldmask & QC_WARNS_MASK)
+		return -EINVAL;
 
 	/*
 	 * Get the dquot (locked) before we start, as we need to do a
-- 
2.27.0

