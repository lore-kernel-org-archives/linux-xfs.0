Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE20BC433B4
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Apr 2021 09:21:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEC946117A
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Apr 2021 09:21:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241668AbhDPJV1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Apr 2021 05:21:27 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50072 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235280AbhDPJVZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Apr 2021 05:21:25 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G99wr7166540
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:21:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=s3y+uXvy6DQ4w6fKL88k7KNxZ7/2mi2Uo096tJlS4oQ=;
 b=e3BwPirMxm6EgLdQoE+cPU9tVputC5Q/1AIdZ7VirAi1l15Tl57/BEwCuL+rG5tltLuL
 6qPAFpj4IpmMI8sZHkWgLmPjrSwuGDSpUUxfm3Pw66eDp3kjMgf8HaZItbIzsqRjODFP
 CVkt7lhS8WMaRmjveslryLGKpaQxziNxITgvhob/GkqDC+0emyfTblqxD7Rqz9qcfrMo
 S1Qyz+/Mo2gJkuPG0E5y/baeipGKvkgf6mz38/Mts66Tyu8qEFfpCvCjeQacHVIPj+hV
 f1tV+FdHXEdvaR3VuyZE/pu3ukrLyYGPqvVfW7O+eSMESYc3D5IGGKUnntLIvta/3K6z Rg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 37u3errkmp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:21:00 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G9AXSw077147
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:21:00 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by userp3030.oracle.com with ESMTP id 37uny2cegt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:21:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q/oKVIzmCcHlOCcC+mt0kGsog+LvkAJEkNRFRqs9LWESfQhs2nnsxLyyrcgMtQ6I4oYsO0oZY4a/tUl/IwBFaX7xmInIxlQRx7EX2i+wZn++RA4Dalk728g+qOryBtgDelKSLA8p7y6FuOdfYP5qXVhnTs4rclu1lfr0fAz1Bu8GyucBUw8wd49EQUlAFM4Yp/0Tau+yLmnbDhjqK8NSTy0tA6rS/3fbE13n7Kj9fSj2w7gU04FXmKQrz6hcmRI9RKz0oMf78AIvdhNP6AW5qSZhdqG9tJwXKwyeh887/8vhEAiXU+okTqxKWyYnOEJ0mkq6AB3wZ+BD8nipU5Bc1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s3y+uXvy6DQ4w6fKL88k7KNxZ7/2mi2Uo096tJlS4oQ=;
 b=UASPWSyuEr/qQPD0jLve+86kPGIa2cXG/IJZ20wdRF0NFkQWjQw7+3Eq8cI3bqPwAM/RN7A/kICgHIynbAnQOQzhRWVRgaKMR/S3/4siu/9t6FQIktIHh0d8+/eBiIMI9Uhxojlqfp3sbCWp51T4B064D6u3wRIrzlb/RtLVhK1Sz/dRZeKXmJ3NtGVZRxd9j0jEu+NAXxemtfyUiTyh4FDXBh9auMJWMfS5dF/zv9NO4I++BZoiPrg3jrcZKMZk4uO23dXgXhNUbH1ebiNALV+ZAviQ+NlyRLQbjqE0bB3BLbHLiiGg1JgYKHG14sFQYKmVTojDxwPzS12LGhNmcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s3y+uXvy6DQ4w6fKL88k7KNxZ7/2mi2Uo096tJlS4oQ=;
 b=gCX3yQoxlZZloEZHMmgRrDfR31ZPgGsoZ2lJMAiZ7ZQp/AjR5yrFDOT0nbatj0zJKWWaF1OvHAzQwe84FiDW22eipmkcSWhOgEiMefIra5Cmz87BZuFixEDvKDJLO9zBzb2WTzwJest4uwIjy+6C7rUAEUdFLfLcYWgdOpanvsc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2567.namprd10.prod.outlook.com (2603:10b6:a02:ab::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Fri, 16 Apr
 2021 09:20:58 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4042.019; Fri, 16 Apr 2021
 09:20:57 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v17 01/11] xfs: Reverse apply 72b97ea40d
Date:   Fri, 16 Apr 2021 02:20:35 -0700
Message-Id: <20210416092045.2215-2-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210416092045.2215-1-allison.henderson@oracle.com>
References: <20210416092045.2215-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.222.141]
X-ClientProxiedBy: BY5PR17CA0029.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::42) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.222.141) by BY5PR17CA0029.namprd17.prod.outlook.com (2603:10b6:a03:1b8::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 09:20:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 21741c71-4a23-4b27-3b0e-08d900b8f19d
X-MS-TrafficTypeDiagnostic: BYAPR10MB2567:
X-Microsoft-Antispam-PRVS: <BYAPR10MB256715312B7EE8A4831B2922954C9@BYAPR10MB2567.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:644;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +GoZlT600G31yXyWN9KIrr9ahJ4bDsbOeMPjrbybOxCcOxC+xtOzelI21c0PIEa/rf5R3hI5kH/4g1utSJa07reqOC5fkCImRJeCs60lTfrxgpYaLmDSIgf0FXVedT/z17alIVWLAmDJFvNejeK5EqFLrdRoG7rqQoNn+PnKP4jL+uS7q8Vy0G8UJt58sYxVwDhsZLnbterqE5FKj7jhKAIdtRUh4vVESjX9HQ3NI0w0sp02RbwrGSNNEUTli3qprAbYiuutkJyg/qex+ulpQwwzUsfjALzhW8JKSDGe51np0MFREqdM3mZgv6FBGNIPyJpdctGGDOiH3E39bvbcUjacWSVLCGr6Ov59AVL4vql/X3m4G3tNSm6Mf4v+fd0QBaJrziZaQOmQvfBz2w2SozeUe7gWA1BKWuaCuVnCNOzc2w1VPRolKXcuF9M9gMXexmjIW47R1lCS0b6izoUilF6f0CwGOKRBz3Zt0LOhVZWCcM0QPtBrIWsBeE5zN9v7PhfatS7N4baRMz4yD4jNz6+CSU4bk1vyny+h7otHki+svqMCyopZLRsAaUyv9FRkYcUJVcPtCvYVocljjZ3yNjvSraGgl1r8uy56c1IQiP9sT+4A+gad5bXyhJI6rpljlTmOaR1o9EPkeIfpjvX3JAqb3ATYpo0OiKYq4q0X7cU+0MKwCXdWVzI3tPKWfTFj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(39860400002)(346002)(396003)(376002)(16526019)(8676002)(36756003)(44832011)(8936002)(38350700002)(52116002)(6666004)(69590400012)(83380400001)(2616005)(86362001)(66556008)(26005)(6512007)(6486002)(316002)(186003)(2906002)(1076003)(38100700002)(6506007)(66476007)(6916009)(5660300002)(956004)(508600001)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Q3nV9ZU5iHdCodlp5BIboqGnDE2fOdMWNFg0NmF+Gcsa3P1jagVBlhTcpFp6?=
 =?us-ascii?Q?Cv5Z284iAMbTd5dDlPsrBEbWVcQike1K+cteND7Eyh/g/l7s1HNAJalOsyJq?=
 =?us-ascii?Q?V8NGfGxawN/YRo2xTQiBLbsoCBnZapXxSVmw6h9CM1z5ylYt89fN1vC3M3gf?=
 =?us-ascii?Q?AkwCAx4symnZQzlkVIpCWtAf78wfhLmk62SwyJgnSEpI3g3lpxJiVoiLKVvi?=
 =?us-ascii?Q?jUUHJxmxOjZs1sfc1pD7t1l8qH5bVvQZ/Y+KvzeeKlwtxIooZIb7WPd3J2Pe?=
 =?us-ascii?Q?LEqjY5CBEQiolY/nfNVM8myYWqPTHxg8+VMya0LOEVKsJunfXGQUR0bm7ypg?=
 =?us-ascii?Q?DHO6Z9To12vR5uwvrB7QoEshwnYa5vOM+hNAMmDiP9XwV2zwhooXlMFJ1Vui?=
 =?us-ascii?Q?5tCkCZ23fIwMXjhdsd+7VGId4mMhOova5wfnA8Y7dPIZpxcWWNhjloQwwym1?=
 =?us-ascii?Q?MY43ykkRAcgsXa0omVulBQXVMKvNz9eb/pP4MeDcyZN7cYSdjKj0GiCvlHI9?=
 =?us-ascii?Q?8ayR6+U4pk41eDATlD5knyzii+xrT3R4bgqfcMO+e66CVbpmGrXFVm9BCxuY?=
 =?us-ascii?Q?mGgHS7wBe36gE32q/oZJq4VjOqt/1nx4WUxCWfcWLxkoYmHCFk7XpqFkrgnV?=
 =?us-ascii?Q?4UdIiCKebi/joLYVmMQBKDDgV7U/cy+BPiS7QXtuFnnP6dCpv02oudi9+cOD?=
 =?us-ascii?Q?57QY4uRQdq1WaeB1U0K00V4wXkOqQc2kZvI2fT9J+90vvuGGqeBcHDvqRt0Z?=
 =?us-ascii?Q?CMrmtJ9U+hQuAqWqUP864dXE8Wyb/0ypkIZI/cms6VMwQWfZWVDWZOBwSgiP?=
 =?us-ascii?Q?hgDEM5IqnR/Cz9Y8wki/TzwoNJhK/vNNpSK+cAhxt+3/rC71Gj5xCs0GGlbn?=
 =?us-ascii?Q?Y+qMnt75g5AQwDOXsTAlUGM6SFLoJ9UAmt4fxZx9owvRCL6gc54kzIalY5pN?=
 =?us-ascii?Q?TYMgPCfgTQ3U9q4X/bTP4fqWqRLwItSdgEVt/9ZeelIxehy3QKdRa0TnqcmI?=
 =?us-ascii?Q?XKlxd6PafZaysM5a2YpWv/6zY5dGHjIMMBVhJbw4dsh6OPfOJqCzE2EcAxsr?=
 =?us-ascii?Q?+GFr68rsj9m+VwD0ASjw5t3YF1L7cy3HYNf9AgWU7Ya8qsmOH5EM/qVDLY27?=
 =?us-ascii?Q?H2oEnV3GfCBwrS560lqcc9xD2c6XI64HS9s4VvfMVgYhFctvRM37rLmqk4k7?=
 =?us-ascii?Q?ocHRRujcELGM1l2kJqb/y6RcezjHVAISDGLcRJUeTqb4J81fBJQn230x5Oy4?=
 =?us-ascii?Q?rxaOKuWWf6+EinSpUON1CVb8RBVCZHnoCDHepQE6sAcO694fnNB/XPb8rLc+?=
 =?us-ascii?Q?617CQkknD+OYsE8ws0wM6ItT?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21741c71-4a23-4b27-3b0e-08d900b8f19d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 09:20:57.8705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rObYzlKgr8rFacMmSqbcdkjsY6LhPzo4J7pvySIrB9kfCdOKJZ1ZIKyYbGc50Fq0xjBfbczmyWB7zVHGozUc++P6nkH69ecNBATlVp3Jww0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2567
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160070
X-Proofpoint-ORIG-GUID: juBH3mMyQZBNI6FONO5eB0NCj5l9BGY8
X-Proofpoint-GUID: juBH3mMyQZBNI6FONO5eB0NCj5l9BGY8
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1015
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 impostorscore=0 suspectscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160070
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
index 902e5f7..94729aa 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1203,24 +1203,6 @@ int xfs_attr_node_removename_setup(
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
@@ -1249,7 +1231,15 @@ xfs_attr_node_removename(
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

