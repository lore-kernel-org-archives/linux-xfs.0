Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50B73C433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Mar 2022 10:40:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232735AbiCAKlR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Mar 2022 05:41:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233233AbiCAKlN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Mar 2022 05:41:13 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5446F90263
        for <linux-xfs@vger.kernel.org>; Tue,  1 Mar 2022 02:40:33 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2218Ukhb018833;
        Tue, 1 Mar 2022 10:40:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=xdRskXVGCVOaL3lxIr5p+PcbV+ng2c7t6kqV+9nSIgk=;
 b=r4b2gWaPmUSaRVg13ppe2hdeFN53uZ7l6oTjf9h1rSRaGeaomsjvXJFoLEwyQWsHjKhL
 6X7Qlh/59o3Kxbl4FX1U2kfM76O4ouAAnKWIWqEbwgG7Dn8UBo7AfHsqmXWuHBiqSgKx
 4vJ+TmE54HU1vRy/PE3VWacxQnny3qptX8GW9UDn/JEmJHEUpDYiNZNo7J7EQN7pq58+
 DIHv+J/Q4csgb1bhuM/wOEh61tbB0hdICpn8HBJ5Vq76nQyUApRlm/jbzwGalsg1rriw
 S4AsT5OOs94i9ffUQB38/8A+z67LE8HJt9o/eXLKTl9sqg7MAv6SZ+diyHocZgHwike/ AA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eh15ajam1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Mar 2022 10:40:29 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 221AZacC134519;
        Tue, 1 Mar 2022 10:40:27 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by userp3020.oracle.com with ESMTP id 3efdnm9rtf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Mar 2022 10:40:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MMFa8FnINzWSQYPJJoYn2QqcO3DkIHgf6cWfGKFMYd3A9EfvY4tIJ/iUzpl6lNxDwGMU3aEEKmuT6UFtenpYK/abiGpNWB3csLTYfbpPb2FXL5dRD09s4wIza9u+FqUI0I3tAE8RD7Zehy5dJQwcHNZD2WXB8M/0NP1GjwK2hOUcopxVfw7Qv3lrVn3CPfeFs3BJkdMmXDmeYakBW0muPtXwxgkW9GsVE4/KnsMSi3aRoO3vRTUnwsyUf0cwEkwWtqC4hK2AF+loCD3YmFJrzFwB/O6M0744BaMRcr/IxSNMi18Fsc7Q7jYuGMieU7lu1NFXQTB0VIosKqrwAVba6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xdRskXVGCVOaL3lxIr5p+PcbV+ng2c7t6kqV+9nSIgk=;
 b=KWF+7kvb2mjykNJmiue4d5VpgxN/XhGBPhp6jnMJnbcgfjgUgU43BUaVpr4ESwtTUZefqjuMtUCpAw2c1jX0VPgLL2yZEgsHRDoGxuCrBejrmBUJXGvjLpX/JgzvUD+xFujqfYxjE66J7d6Amu2W/bd9ckQWLaDxdpRsMQSxS3lPO/Mo1o3bGEokr1CZL4vj+lBeNbystkG9EbBz7Semr2/x5+MVBMt2j0umxJSFhpVVBLnXX3sQkwQNYvMXD3mnBhbtIU2aXXqfZIBEmxM8uuDp+AxP2ygIueOR/GQblPr5PN2EKCUHMUyqyfrBvebMEF90g8FU8DulIcfSYUD5Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xdRskXVGCVOaL3lxIr5p+PcbV+ng2c7t6kqV+9nSIgk=;
 b=ggdmwqbPeDDgdEuiz3Pe15H328lOAnLWYPM5dgW1sQKP7qg6US9omorsOICd1tkZideBP5G0UOTY7qwvdN1Nlzd59OiNbS7wWkZmPZLHKCTITZMRYEjrctSbKhXGmRIapM2ZEzwlAnIyAhuF6PLfmuJSZa/OpBpPElcUzZBRBlk=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by MN2PR10MB4160.namprd10.prod.outlook.com (2603:10b6:208:1df::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Tue, 1 Mar
 2022 10:40:24 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%7]) with mapi id 15.20.5017.027; Tue, 1 Mar 2022
 10:40:24 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com, kernel test robot <lkp@intel.com>
Subject: [PATCH V7 10/17] xfs: Use xfs_rfsblock_t to count maximum blocks that can be used by BMBT
Date:   Tue,  1 Mar 2022 16:09:31 +0530
Message-Id: <20220301103938.1106808-11-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220301103938.1106808-1-chandan.babu@oracle.com>
References: <20220301103938.1106808-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0022.apcprd02.prod.outlook.com
 (2603:1096:4:195::23) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ea5e875-5a3d-477a-73c0-08d9fb6fe499
X-MS-TrafficTypeDiagnostic: MN2PR10MB4160:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB4160B06F09410B1C223433A0F6029@MN2PR10MB4160.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZNliKO+8VQDcLGBxZ49OoC1XbZXL+St+LoSkNQl97jtmhG+I+ZXp8nKCmqE4tbfc7ikxPpEckY7FlNDseEHTMt5FB0bMvfYWvLgWsvqr8dAEPBYnNWtxJ2QtcV0zq8SM8JGWepfKb6wf6ovonC9bTnuaRD+JAsGIBVbGvxWyeJCVt+3ysWYvPz13ptrEfEkFI1Mp+K8Mifs01oSy2qv5wgqT42iHFBnAT+CC+rv5z36tO08qcN8R1MVxrweFdKRIqunQHURoGHhd/gPtb7Uri8MyGgFUnMhQE91DJZblxNjXxa09hwmkJaFWbWLWnseWyEXleb/9r715WOiWXlDrgBjVGxDs95pjw8wx4ievK6MS+AA3DEQqr4TyPJJ7GwS/oSEjF3HTmYo9QKILewQ6c+NCvkfy9u78cZ4vDXCmL85ilqbG4zT7ATjXBszmpQ2GOzBTZXqZtRH0Fb5GNWwk89kiZYZyJgquOhxrszVYKRDrJXdmSf+3VKg4oPR5N1oRyrMJNrHs+akNmVlDPBfvuZQ2jho3TsGUMd/kb4N6l3bjRAR2pZubJ6EjauUb8Tr4pGxqrXaH5XLULy52UUaQy4chwYRBZZeLSMjNavQy1P7O+9EKNTfmkJYj814r0S3JNfzbRe1D3Ua5QMCZnvldk6Xd2jgVl0je1PRNeSFNBlRg1ZosT/3DZK68Ik+vjKRskFMvw4iFrXtrsAEV2/NIVg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(38100700002)(38350700002)(186003)(83380400001)(1076003)(2616005)(8936002)(36756003)(2906002)(5660300002)(66946007)(6512007)(6486002)(508600001)(6506007)(52116002)(54906003)(6916009)(316002)(8676002)(4326008)(66476007)(86362001)(66556008)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Lgs8f+Cn0bUoW5VaqutgpGKVmYrfMxzTFyYshMcXkpQ1NzG1T0cwIlkokpst?=
 =?us-ascii?Q?E2uH0zToa5EQI/uBYU43f3Bxobs4OLe7aj8pNk1LQHtxSPoezJ7QBxwA5NA0?=
 =?us-ascii?Q?2YW5v2NOHhvdb97h88zbafdXTkYFnsc6vKSRmyvwpUJlpkVRbVbpj7w5n+Xk?=
 =?us-ascii?Q?uZy8ZUtU4AZEA+0vR/Vo0a5+mwcv5kU2M3d9BrT+9DNHYG7tNYbOGQvAXSSe?=
 =?us-ascii?Q?2xMYvgUHJFbS+/qbwWU98DXLMPeVvwBl1y6bVWks9JuGKNEpXNk5t1Pv4Tqi?=
 =?us-ascii?Q?gPgwQwqpYcfgo2TZiyEuUt0bbrK44yt5huiVNmiPem0GhBTGEEYT4bpGqr2m?=
 =?us-ascii?Q?c0o8iGQCdNJj2FHUZDMjdCj8VbCaToLAekrmJszToCokZBUiaslu65hOwZYO?=
 =?us-ascii?Q?Bo9KZVYYZh4pzdTEytIrfFB1QXK6QQacTthF13Jct6qDcZaaE4g+/YzMTGES?=
 =?us-ascii?Q?OGkMyQLRsImvQLY5h0Yzhgt2e/vIGm4xkqhFAqoIhiM4U/VNXlnJMfGYUU/D?=
 =?us-ascii?Q?slzbvqx8zqRIz+U1E7gCuJQB0HVxzOB4fLutKZJUP9iQWnRIkbpucJ6oP43N?=
 =?us-ascii?Q?NiZYQQXDxrm1Hi5jbzx7xd85AP5DHXf41Mb0jgWlT7ED1Zlv2oHvVu0hbzYX?=
 =?us-ascii?Q?hZctFRRCOUln3ZSUhGngNIun81IPeatTbq2kw+VWrSvbCJvfRvO6UjoBdSfq?=
 =?us-ascii?Q?gnhQt6hgo1wMMCRKOHhkrCx7EgKg0zgc05k30CV5jdjKy6dhG/927QEk2bkC?=
 =?us-ascii?Q?1LJMaGx/6/dqkiH70FeeJD5gesyupBB854pDFpuoocn+xRO2sCwq543aryKC?=
 =?us-ascii?Q?8jymGjLogzj91rTCmsOgww3t1EFxKI+RxdkL/Xg+1RxRVByAnr482DdDCnTX?=
 =?us-ascii?Q?2+XshHMktaZoH3IJxuC2i22ToTwh6Q75Z/tMOQ8uM/TjDHOD4jvoM9y1rbHa?=
 =?us-ascii?Q?2/kVEoGk+HHl38wxepiQ1KE/xxZwggr0SJlNxV1LjJPMhA023781SOKwEXuC?=
 =?us-ascii?Q?CE5Po3d/KrNlpxjkjdPd8BKnvS24JSAefFMHAOnjU7S5hWYowZBmA6g1cqbQ?=
 =?us-ascii?Q?v7fxeNpqRWCClzKr9ZuMJN604KXhgZutumFYTRqavJj5a8Y7K3XJj12la4TU?=
 =?us-ascii?Q?9Igx2Pck1Xa6xrbdVoG8D3UBh+rPnxwDACQXPrueony/6DV00g2RalgjnKdL?=
 =?us-ascii?Q?fXYc8WAdZTPlkMJjVL4F+q6m0ZQxLniY6slhX3bYqugyMN0s6r/v5J6Oh20n?=
 =?us-ascii?Q?5DnMguQK8OpwzICV04YAx1nyfUPxLjWU3Kn8FD2TfqLqD7i1LtBidB2YtUqo?=
 =?us-ascii?Q?uqi4vSAvSpvE9/yFhEDuO+gNgPbDZjJlqNMGXXHTKreH4osos0FJ/gfO2Z8J?=
 =?us-ascii?Q?5gGyqpiKK/R7wislHTaO1WZ9W13v/YHiZpihnECpHbzQl3QtCxaXtL428bDx?=
 =?us-ascii?Q?eVr1goKIPaL6fNCc0sBY/UK0BSIbGUzYA1rtG/fTh0mFggBJ9IGhOOqKY4G/?=
 =?us-ascii?Q?2OLUAVBs/lvBnixhH8v+3RLxMjFLRtXxYhusDHddkiQAQArf0Ac4pru70rKT?=
 =?us-ascii?Q?VszLY9cJ9U2O00lvqfunozEpqrYFNbYbteeckUGeAqA7x8R50GkuyW5l4GYO?=
 =?us-ascii?Q?w/240vyTPparcARHn3G7QF0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ea5e875-5a3d-477a-73c0-08d9fb6fe499
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 10:40:24.7807
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X01uNhJk/2C3AqPupLq+FChSKThnhJRpxQNLD7Zr2mFa6KIn28uawqp9806yKGvyEyq13d8jB6LsdJnHO/vAaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4160
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10272 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=982 bulkscore=0
 adultscore=0 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2203010056
X-Proofpoint-ORIG-GUID: AMo6QRO3Cgtg3CUJ8HP14LvQwrRjxUze
X-Proofpoint-GUID: AMo6QRO3Cgtg3CUJ8HP14LvQwrRjxUze
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 9df98339a43a..a01d9a9225ae 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -53,8 +53,8 @@ xfs_bmap_compute_maxlevels(
 	int		whichfork)	/* data or attr fork */
 {
 	xfs_extnum_t	maxleafents;	/* max leaf entries possible */
+	xfs_rfsblock_t	maxblocks;	/* max blocks at this level */
 	int		level;		/* btree level */
-	uint		maxblocks;	/* max blocks at this level */
 	int		maxrootrecs;	/* max records in root block */
 	int		minleafrecs;	/* min records in leaf block */
 	int		minnoderecs;	/* min records in node block */
@@ -88,7 +88,7 @@ xfs_bmap_compute_maxlevels(
 		if (maxblocks <= maxrootrecs)
 			maxblocks = 1;
 		else
-			maxblocks = (maxblocks + minnoderecs - 1) / minnoderecs;
+			maxblocks = howmany_64(maxblocks, minnoderecs);
 	}
 	mp->m_bm_maxlevels[whichfork] = level;
 	ASSERT(mp->m_bm_maxlevels[whichfork] <= xfs_bmbt_maxlevels_ondisk());
-- 
2.30.2

