Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60BC5C25B50
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Jan 2023 01:36:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbjAXBg3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Jan 2023 20:36:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbjAXBg2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Jan 2023 20:36:28 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7DA51258F
        for <linux-xfs@vger.kernel.org>; Mon, 23 Jan 2023 17:36:26 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30O04avJ021868
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=p+Mj2o48KZIU06tjOsGJKlU3MX9+qMBJYtvtML+DC1k=;
 b=nhSI6huIlD9ZNgl5RD/vevRSf9YPfM62Dy6MDujMcB5Oe1mfWopO4jUBuR4tLoJs5o7c
 bRLIgSa5VCi+LVoUnnDVL/I7/YzDv77Gy2SEEQqiHoOYD6J9tJdUclNURKOBlXUw0WIj
 KRqPVC7BuC/xPRqGvweyXcYto5uXbzDp8v59NeSBmvV8qAGnFsz8kUfSwYK2Ss0uhIsf
 dlsjwVtExgLoCCK3QlfxGJ4hw2xN1i89MpaPUi9LufQJFevod3PL+KoKd7dyeON+QP6N
 0UmeCsvCmXtTP5BXbuvOdMpzfNxeekhW39SKdRhodvAcNNbBmq28hivdHZZdfzm4wphX 6A== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n88ktv8ch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:26 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30NN5GwA040221
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:25 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g4a7rb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hX62WwmJNDFB08JwjTOdL655dhM9QibxMemTmYrSs3lXr9OdXQmRaAg885LFnmlmtnhegpJ3SJe4xJp+IPM1SlPVZ2klkvs8u/bwWwKzej/uzQwsGX4ojUp6uocKh/K++3REh6PmMHHnMOLejJPpF/ooluVPmvchBTxr0c0y8AEp/XFZBut7idTdNUtRhf2BW1MML8xNt20OlRLMwotmpWvzBECQgZosdsJW7XOR0AvikjSFaf2YvY4chI4Nlt8clMFBh+fdI1c8oT6IMEyNJv2SMEKZNd4LHaE9fsd1kqpeVUEC5SFVPlTzF8QsOb+/6qlJ8tNzX6n0LIBPwD6ubA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p+Mj2o48KZIU06tjOsGJKlU3MX9+qMBJYtvtML+DC1k=;
 b=P8h3+5KXA+BA7x1aU42YaDuUQXagoEfjw53NhdJL7MIMvG+ZXRbRk2BAtVi5drXRqOS8nMR5pGSMB5B2ndH0R+Xh33DFgY8AP12RogEBw9UZEYQbs4gceZ4twtdBms7MUsG1lh3oGTv6eqSj1nZvauO2VtnXWbdSp+u4gvmzMeNipwv7QllVbeIQzVHB0BRetZ0MVgB0dKBJ+JR32nwKTrKgSurwhgvfpU0nogJzs4TH3mmPKUpnRi13GJW1ibnSjMedrOGU0SePFYOhmRoAT7pcvS25nUXyKLWiu6+Nq+GbNhJKTsGAkPJ3XFS+q4KZKd7FD/z8Tx98Hi31PHMOZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p+Mj2o48KZIU06tjOsGJKlU3MX9+qMBJYtvtML+DC1k=;
 b=iUI+Z6hwRXoTPYfWZWDPt7kh+Ul9h+xDaRIPiyqQDi9gNnKkbXFIEVd7fTAqXxGSDpIs/oY+yJRnBR32th5qtGrV78Nm+b8KkQPoGtM2Q7Qe+WLNquFkX2JWoEIOzAxB+IJuiEMMYeAZEyu699PYjlo0KF0O01RlBrqHclO3JSE=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CH0PR10MB5052.namprd10.prod.outlook.com (2603:10b6:610:de::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.16; Tue, 24 Jan
 2023 01:36:23 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%4]) with mapi id 15.20.6043.016; Tue, 24 Jan 2023
 01:36:23 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v8 01/27] xfs: Add new name to attri/d
Date:   Mon, 23 Jan 2023 18:35:54 -0700
Message-Id: <20230124013620.1089319-2-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230124013620.1089319-1-allison.henderson@oracle.com>
References: <20230124013620.1089319-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0011.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::24) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|CH0PR10MB5052:EE_
X-MS-Office365-Filtering-Correlation-Id: 054ef252-a62b-4d6a-bd44-08dafdab6696
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pbc92fXUK7lqwNYnVHP2wdmUG2IYBhtVuSW5r+tGMVZA1h0aeQFlcQXGGqfTwMeZQvWMkK8i2jSZldBEC9obGSz76ghv6fNtm4v5HxWkqrLbxmGmvkSvoicsdcXKlD/Rgr6VPdkK6DP2FImGTA0HAT7O9VMr7SFfuZMo5zo9avl9/oYSKIoH6KzAThDOln+6RR2nraNI6ruwdpsUlRs+2tA/hAylvaZ+lDpI719moGjEZIfTgwVYzcmdYDTPmOJ9gK80yAB3G+bh+3M8IquEiO5kqKf+03FhVCI0DxGtw1UHVg9Abmvp3ir64K+1li0eXGgYjFKd7x7UteUrzkZMetx6ouSHZjgXMLdwMRmUzqjBWNxxoB+fHUm4IQRn24WWSjhfKnHIqL4FXjXmBwgtRjPr0RtWMH/cZPdvjkHQ5FRDgokRkgeR/g/+sO5ncE2Dop1yufpe+UfslPC81xmpluIfFCEN82Al3cO2OAm8Jo6PAZH5zWOMzKypY+YiAATb+xUiKL8CrbiIImFGjWxSq1LEOBOb07aERBvZo+HUpuzz4bT2YRZoaVhdTdi1QWsTItI7v7SRhGeLUqszYgYiluF/hjEIU02MODOKNIa6o6GWcucBiKXBgoC0PBNOx5Qb/Xf09HebApQL6gcsQvex6A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(136003)(376002)(346002)(396003)(451199015)(1076003)(83380400001)(2616005)(86362001)(38100700002)(36756003)(6916009)(8676002)(66476007)(66946007)(66556008)(30864003)(9686003)(5660300002)(2906002)(41300700001)(8936002)(6666004)(6486002)(478600001)(186003)(6512007)(26005)(6506007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6ImZxCQO4+Geoi1ib+9+ve/hbmlKJivGyq3t8QFG5yaVO5ZEjYqs/PCV+QUO?=
 =?us-ascii?Q?61EJAkIb2+oVo1yhJ4lRVDKxzRAllmrWQPbipKeornItPo/XC/h7ujGh40he?=
 =?us-ascii?Q?PCV8r+xQJWK9su1zyqhh/v7WLdjDLfQhshkBzOtahz02BL1vzxIfTIesz64Z?=
 =?us-ascii?Q?1B0vCBC3Tdv95ccZ2+PPg2Qsg+uDbH8X1N6Ew0tvsYpdMPtEG1QTH7Xd4tQc?=
 =?us-ascii?Q?CzNoUuQggoEoo72q3Xx2VbNyl6ZjIu/Cm7egegoUTFCAqtDCI2bB92LM1WN4?=
 =?us-ascii?Q?gsGAegy+TkHjdaFwj1HAtr5Gyh6FNfQOxoWICh0rLKbQraRLwtCOcGIaoNOH?=
 =?us-ascii?Q?tGUmPQ5eMfmkuAlcGARBPo062Mk8rZNt6ip4XSex0xwMhichikaGw14nL2+s?=
 =?us-ascii?Q?h+VXq/9UHcQKrYksCt8sDFI6UnAo25yXYZpqiuqyfFPHr9G3P/346xUeKAba?=
 =?us-ascii?Q?uUEF0sYp7vpFR2SkkUgMsz/d0P6PWfxjxs22q6XbtjT4sy6LtjkweYGV1YHi?=
 =?us-ascii?Q?PA5+v2DuYkOFAq5LGMWufPDUBj6qm60tkteVKw5o0P43aFu/BxQK+XasgA4g?=
 =?us-ascii?Q?KjBkIdodsXJrpdqabjpT2dSL7K1tJYr9XZe9GvI5Rf4HJJDdwB6ugAg1c5Wd?=
 =?us-ascii?Q?GyAMxNJT3U5LNHiA7Npw/1PtE7x5gZo45iK3epNWda//wLW1JIA6y5Kga0tX?=
 =?us-ascii?Q?mUeFN4FDCbFDMJX53QBr5tgTGTv6Ivo74g4kfWf3WVrqFc3XfEuZ3oWKVPzZ?=
 =?us-ascii?Q?8eDmW76MsI7coPVVLTwrGH9j/4R4Oa6QkBAcFKmpUqa7esRkWvcsWgStezSt?=
 =?us-ascii?Q?EleyUF65FEERQe3VUmE+P20nvz6BAKBLWswTaRgeyOXY4GEwsnlX06tnu9Q/?=
 =?us-ascii?Q?fZiQxpFglpn+usDatko0eJ5e6dNUN59O/kPywcB/IGkQkdgDfurY1r0yjGcX?=
 =?us-ascii?Q?WoR65t4IpezZ784U6WHk/Bsek5cKyHEyyOcnTFZzCwZnSmNcESbc0L6kDAOV?=
 =?us-ascii?Q?AoLUD4s1sflAe16ZHuE+Slfr1Oggw7f34ay0ETmlEPZ9QgXlYUYNwvg51PjD?=
 =?us-ascii?Q?3JS6u5d4X5WQ9sESnj6XD0tML1upadZJUUdw3HKpC++mulH9Hjpk+KLGIjwX?=
 =?us-ascii?Q?EcSUET3ueQAtcLwty6lEKFCUyt1i64FQXkuCqCP0TtCPSHdzABRgWSUvxj4l?=
 =?us-ascii?Q?vZtxzQfKKHuTwYHbhD75il6GOirPqCR8Y0QVOSne0Wdu/6B/Z4oozXBNuCiQ?=
 =?us-ascii?Q?ARTqBxNsR9/FHrXd/ZkRL582IbT/wHxXUnqni/YPsBw8f3M1O8f7k2Yxxd3D?=
 =?us-ascii?Q?qmRvAl5jojKIWq9ct+uuo1+dROWxNnA5t6ZRg4372VRcVi+BlZbJwGJiu7Sz?=
 =?us-ascii?Q?gswN7k0FnDDtJT7gzKrbPjgZs8gAxGTO/kSTXVlRAOGCdRBIMnWaM2MKL4OU?=
 =?us-ascii?Q?xi+IHwNo0UcK8OOnfevisJ/0xcTu1f4VQj8OwERSpWvt3BE5UZW1B62aZ7DR?=
 =?us-ascii?Q?HnWlUhKF7bGP4BzyB9T5xMy6N6U1YF2JqoyaGFTN1vHDMlKEVYGRkPIjeEcI?=
 =?us-ascii?Q?IieV97XvVC+C873qhIC3uI+xahgcQekRZagGhQNOJJCTos1Z3csiPkxiRnbj?=
 =?us-ascii?Q?Pg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 0fYbb8NZH/sPulEU5yWsbstxeylYZAAYO2tVlx6QSZ644K4MV1+vQFSZoJUs+rup2aYGSmQbzov8f6tUthNrJO7zOC3QshyLSIn7phU2KwGd9w4y/Pgyc6oLxNUcJ5S3Fy8mL+ZDrlGR7I4nm6WbWeqkP2cC9y5owHEuhe9sb1dBKFOkoC027aQZRm52kZvOdc7uotNxAfljDMW4VjG6qJtbY+Ys4CPxGO11b1hCIe10Bcbw6wG2Q+QfGaIiaVPLBbMlDV5fRrZ8ttnufnqPWcdORhmd43Rt5oeQoUFlLGXp0xxS4CBSlqZ3Kba0A1ySrce3iOihyN/liC4Y1FXR+dIj5+nrqz8KnY9vrjMMTGKETSwzTx55kwsnKKbvQayDQSImQ/QnEJjvS/DauGfO0Lyt+p5DNfPEYMO+DcIUBdVf5D0MeUQ2mKNJSuZ9R6ELXQdH4ZAoXTM/fiuXXCBG/quwJnkSmz83bSGwAaTi2+KocSiKl8x8tFvzIDjPY3NxyArKnHAV3egHw1dFi4c5YbSvXXHVe1YSVaWiSaoD5nYMkBkwLroUKB34ZHL9ehdy52PmEoejU35iri9gugtcrhjIZV2I5Aqk3x6GV/aaJ1PV4Hsfc/BPH+rzto9hK1gfa7Xj7B++j8Y6H8W1lRQPWaoie2y0WtVgNHNHGYoM9zUSc0JUiiIbxc5+5pzUOUEJiYRppEJKCZ/j4Sy2p/FjtXGvhg8ICy6kGBliMjKNvvz6IxMvxVof/AxgqwE3iUPx/r62nAQFQS0tsYqLw3OL3w==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 054ef252-a62b-4d6a-bd44-08dafdab6696
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 01:36:23.0610
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fh6T92LqwZzneyuoq1clsLTvVgHPN7UYCA1Kp9/SeezQANNV3KN4Omdv29dpIhU5c+n7zwbM5UhfVadCI1jfrpgcPUYWSvUG6IhvoqXS26M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5052
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 bulkscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301240010
X-Proofpoint-GUID: 73bO1-PnwynMSDbwJHuPifqg72fuKXIn
X-Proofpoint-ORIG-GUID: 73bO1-PnwynMSDbwJHuPifqg72fuKXIn
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch adds two new fields to the atti/d.  They are nname and
nnamelen.  This will be used for parent pointer updates since a
rename operation may cause the parent pointer to update both the
name and value.  So we need to carry both the new name as well as
the target name in the attri/d.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c       |  12 ++-
 fs/xfs/libxfs/xfs_attr.h       |   4 +-
 fs/xfs/libxfs/xfs_da_btree.h   |   2 +
 fs/xfs/libxfs/xfs_log_format.h |   6 +-
 fs/xfs/xfs_attr_item.c         | 135 +++++++++++++++++++++++++++------
 fs/xfs/xfs_attr_item.h         |   1 +
 6 files changed, 133 insertions(+), 27 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index e28d93d232de..b1dbed7655e8 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -423,6 +423,12 @@ xfs_attr_complete_op(
 	args->op_flags &= ~XFS_DA_OP_REPLACE;
 	if (do_replace) {
 		args->attr_filter &= ~XFS_ATTR_INCOMPLETE;
+		if (args->new_namelen > 0) {
+			args->name = args->new_name;
+			args->namelen = args->new_namelen;
+			args->hashval = xfs_da_hashname(args->name,
+							args->namelen);
+		}
 		return replace_state;
 	}
 	return XFS_DAS_DONE;
@@ -922,9 +928,13 @@ xfs_attr_defer_replace(
 	struct xfs_da_args	*args)
 {
 	struct xfs_attr_intent	*new;
+	int			op_flag;
 	int			error = 0;
 
-	error = xfs_attr_intent_init(args, XFS_ATTRI_OP_FLAGS_REPLACE, &new);
+	op_flag = args->new_namelen == 0 ? XFS_ATTRI_OP_FLAGS_REPLACE :
+		  XFS_ATTRI_OP_FLAGS_NVREPLACE;
+
+	error = xfs_attr_intent_init(args, op_flag, &new);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 81be9b3e4004..3e81f3f48560 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -510,8 +510,8 @@ struct xfs_attr_intent {
 	struct xfs_da_args		*xattri_da_args;
 
 	/*
-	 * Shared buffer containing the attr name and value so that the logging
-	 * code can share large memory buffers between log items.
+	 * Shared buffer containing the attr name, new name, and value so that
+	 * the logging code can share large memory buffers between log items.
 	 */
 	struct xfs_attri_log_nameval	*xattri_nameval;
 
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index ffa3df5b2893..a4b29827603f 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -55,7 +55,9 @@ enum xfs_dacmp {
 typedef struct xfs_da_args {
 	struct xfs_da_geometry *geo;	/* da block geometry */
 	const uint8_t		*name;		/* string (maybe not NULL terminated) */
+	const uint8_t	*new_name;	/* new attr name */
 	int		namelen;	/* length of string (maybe no NULL) */
+	int		new_namelen;	/* new attr name len */
 	uint8_t		filetype;	/* filetype of inode for directories */
 	void		*value;		/* set of bytes (maybe contain NULLs) */
 	int		valuelen;	/* length of value */
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index f13e0809dc63..ae9c99762a24 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -117,7 +117,8 @@ struct xfs_unmount_log_format {
 #define XLOG_REG_TYPE_ATTRD_FORMAT	28
 #define XLOG_REG_TYPE_ATTR_NAME	29
 #define XLOG_REG_TYPE_ATTR_VALUE	30
-#define XLOG_REG_TYPE_MAX		30
+#define XLOG_REG_TYPE_ATTR_NNAME	31
+#define XLOG_REG_TYPE_MAX		31
 
 
 /*
@@ -957,6 +958,7 @@ struct xfs_icreate_log {
 #define XFS_ATTRI_OP_FLAGS_SET		1	/* Set the attribute */
 #define XFS_ATTRI_OP_FLAGS_REMOVE	2	/* Remove the attribute */
 #define XFS_ATTRI_OP_FLAGS_REPLACE	3	/* Replace the attribute */
+#define XFS_ATTRI_OP_FLAGS_NVREPLACE	4	/* Replace attr name and val */
 #define XFS_ATTRI_OP_FLAGS_TYPE_MASK	0xFF	/* Flags type mask */
 
 /*
@@ -974,7 +976,7 @@ struct xfs_icreate_log {
 struct xfs_attri_log_format {
 	uint16_t	alfi_type;	/* attri log item type */
 	uint16_t	alfi_size;	/* size of this item */
-	uint32_t	__pad;		/* pad to 64 bit aligned */
+	uint32_t	alfi_nname_len;	/* attr new name length */
 	uint64_t	alfi_id;	/* attri identifier */
 	uint64_t	alfi_ino;	/* the inode for this attr operation */
 	uint32_t	alfi_op_flags;	/* marks the op as a set or remove */
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 2788a6f2edcd..95e9ecbb4a67 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -75,6 +75,8 @@ static inline struct xfs_attri_log_nameval *
 xfs_attri_log_nameval_alloc(
 	const void			*name,
 	unsigned int			name_len,
+	const void			*nname,
+	unsigned int			nname_len,
 	const void			*value,
 	unsigned int			value_len)
 {
@@ -85,15 +87,25 @@ xfs_attri_log_nameval_alloc(
 	 * this. But kvmalloc() utterly sucks, so we use our own version.
 	 */
 	nv = xlog_kvmalloc(sizeof(struct xfs_attri_log_nameval) +
-					name_len + value_len);
+					name_len + nname_len + value_len);
 
 	nv->name.i_addr = nv + 1;
 	nv->name.i_len = name_len;
 	nv->name.i_type = XLOG_REG_TYPE_ATTR_NAME;
 	memcpy(nv->name.i_addr, name, name_len);
 
+	if (nname_len) {
+		nv->nname.i_addr = nv->name.i_addr + name_len;
+		nv->nname.i_len = nname_len;
+		memcpy(nv->nname.i_addr, nname, nname_len);
+	} else {
+		nv->nname.i_addr = NULL;
+		nv->nname.i_len = 0;
+	}
+	nv->nname.i_type = XLOG_REG_TYPE_ATTR_NNAME;
+
 	if (value_len) {
-		nv->value.i_addr = nv->name.i_addr + name_len;
+		nv->value.i_addr = nv->name.i_addr + nname_len + name_len;
 		nv->value.i_len = value_len;
 		memcpy(nv->value.i_addr, value, value_len);
 	} else {
@@ -147,11 +159,15 @@ xfs_attri_item_size(
 	*nbytes += sizeof(struct xfs_attri_log_format) +
 			xlog_calc_iovec_len(nv->name.i_len);
 
-	if (!nv->value.i_len)
-		return;
+	if (nv->nname.i_len) {
+		*nvecs += 1;
+		*nbytes += xlog_calc_iovec_len(nv->nname.i_len);
+	}
 
-	*nvecs += 1;
-	*nbytes += xlog_calc_iovec_len(nv->value.i_len);
+	if (nv->value.i_len) {
+		*nvecs += 1;
+		*nbytes += xlog_calc_iovec_len(nv->value.i_len);
+	}
 }
 
 /*
@@ -181,6 +197,9 @@ xfs_attri_item_format(
 	ASSERT(nv->name.i_len > 0);
 	attrip->attri_format.alfi_size++;
 
+	if (nv->nname.i_len > 0)
+		attrip->attri_format.alfi_size++;
+
 	if (nv->value.i_len > 0)
 		attrip->attri_format.alfi_size++;
 
@@ -188,6 +207,10 @@ xfs_attri_item_format(
 			&attrip->attri_format,
 			sizeof(struct xfs_attri_log_format));
 	xlog_copy_from_iovec(lv, &vecp, &nv->name);
+
+	if (nv->nname.i_len > 0)
+		xlog_copy_from_iovec(lv, &vecp, &nv->nname);
+
 	if (nv->value.i_len > 0)
 		xlog_copy_from_iovec(lv, &vecp, &nv->value);
 }
@@ -374,6 +397,7 @@ xfs_attr_log_item(
 	attrp->alfi_op_flags = attr->xattri_op_flags;
 	attrp->alfi_value_len = attr->xattri_nameval->value.i_len;
 	attrp->alfi_name_len = attr->xattri_nameval->name.i_len;
+	attrp->alfi_nname_len = attr->xattri_nameval->nname.i_len;
 	ASSERT(!(attr->xattri_da_args->attr_filter & ~XFS_ATTRI_FILTER_MASK));
 	attrp->alfi_attr_filter = attr->xattri_da_args->attr_filter;
 }
@@ -415,7 +439,8 @@ xfs_attr_create_intent(
 		 * deferred work state structure.
 		 */
 		attr->xattri_nameval = xfs_attri_log_nameval_alloc(args->name,
-				args->namelen, args->value, args->valuelen);
+				args->namelen, args->new_name,
+				args->new_namelen, args->value, args->valuelen);
 	}
 
 	attrip = xfs_attri_init(mp, attr->xattri_nameval);
@@ -503,7 +528,8 @@ xfs_attri_validate(
 	unsigned int			op = attrp->alfi_op_flags &
 					     XFS_ATTRI_OP_FLAGS_TYPE_MASK;
 
-	if (attrp->__pad != 0)
+	if (attrp->alfi_op_flags != XFS_ATTRI_OP_FLAGS_NVREPLACE &&
+	    attrp->alfi_nname_len != 0)
 		return false;
 
 	if (attrp->alfi_op_flags & ~XFS_ATTRI_OP_FLAGS_TYPE_MASK)
@@ -517,6 +543,7 @@ xfs_attri_validate(
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
 	case XFS_ATTRI_OP_FLAGS_REMOVE:
+	case XFS_ATTRI_OP_FLAGS_NVREPLACE:
 		break;
 	default:
 		return false;
@@ -526,9 +553,14 @@ xfs_attri_validate(
 		return false;
 
 	if ((attrp->alfi_name_len > XATTR_NAME_MAX) ||
+	    (attrp->alfi_nname_len > XATTR_NAME_MAX) ||
 	    (attrp->alfi_name_len == 0))
 		return false;
 
+	if (op == XFS_ATTRI_OP_FLAGS_REMOVE &&
+	    attrp->alfi_value_len != 0)
+		return false;
+
 	return xfs_verify_ino(mp, attrp->alfi_ino);
 }
 
@@ -589,6 +621,8 @@ xfs_attri_item_recover(
 	args->whichfork = XFS_ATTR_FORK;
 	args->name = nv->name.i_addr;
 	args->namelen = nv->name.i_len;
+	args->new_name = nv->nname.i_addr;
+	args->new_namelen = nv->nname.i_len;
 	args->hashval = xfs_da_hashname(args->name, args->namelen);
 	args->attr_filter = attrp->alfi_attr_filter & XFS_ATTRI_FILTER_MASK;
 	args->op_flags = XFS_DA_OP_RECOVERY | XFS_DA_OP_OKNOENT |
@@ -599,6 +633,7 @@ xfs_attri_item_recover(
 	switch (attr->xattri_op_flags) {
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
+	case XFS_ATTRI_OP_FLAGS_NVREPLACE:
 		args->value = nv->value.i_addr;
 		args->valuelen = nv->value.i_len;
 		args->total = xfs_attr_calc_size(args, &local);
@@ -688,6 +723,7 @@ xfs_attri_item_relog(
 	new_attrp->alfi_op_flags = old_attrp->alfi_op_flags;
 	new_attrp->alfi_value_len = old_attrp->alfi_value_len;
 	new_attrp->alfi_name_len = old_attrp->alfi_name_len;
+	new_attrp->alfi_nname_len = old_attrp->alfi_nname_len;
 	new_attrp->alfi_attr_filter = old_attrp->alfi_attr_filter;
 
 	xfs_trans_add_item(tp, &new_attrip->attri_item);
@@ -710,48 +746,102 @@ xlog_recover_attri_commit_pass2(
 	const void			*attr_value = NULL;
 	const void			*attr_name;
 	size_t				len;
-
-	attri_formatp = item->ri_buf[0].i_addr;
-	attr_name = item->ri_buf[1].i_addr;
+	const void			*attr_nname = NULL;
+	int				op, i = 0;
 
 	/* Validate xfs_attri_log_format before the large memory allocation */
 	len = sizeof(struct xfs_attri_log_format);
-	if (item->ri_buf[0].i_len != len) {
+	if (item->ri_buf[i].i_len != len) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
+				item->ri_buf[i].i_addr, item->ri_buf[i].i_len);
 		return -EFSCORRUPTED;
 	}
 
+	attri_formatp = item->ri_buf[i].i_addr;
 	if (!xfs_attri_validate(mp, attri_formatp)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
+				item->ri_buf[i].i_addr, item->ri_buf[i].i_len);
+		return -EFSCORRUPTED;
+	}
+
+	op = attri_formatp->alfi_op_flags & XFS_ATTRI_OP_FLAGS_TYPE_MASK;
+	switch (op) {
+	case XFS_ATTRI_OP_FLAGS_SET:
+	case XFS_ATTRI_OP_FLAGS_REPLACE:
+		if (item->ri_total != 3) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					     attri_formatp, len);
+			return -EFSCORRUPTED;
+		}
+		break;
+	case XFS_ATTRI_OP_FLAGS_REMOVE:
+		if (item->ri_total != 2) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					     attri_formatp, len);
+			return -EFSCORRUPTED;
+		}
+		break;
+	case XFS_ATTRI_OP_FLAGS_NVREPLACE:
+		if (item->ri_total != 4) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					     attri_formatp, len);
+			return -EFSCORRUPTED;
+		}
+		break;
+	default:
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				     attri_formatp, len);
 		return -EFSCORRUPTED;
 	}
 
+	i++;
 	/* Validate the attr name */
-	if (item->ri_buf[1].i_len !=
+	if (item->ri_buf[i].i_len !=
 			xlog_calc_iovec_len(attri_formatp->alfi_name_len)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
+				attri_formatp, len);
 		return -EFSCORRUPTED;
 	}
 
+	attr_name = item->ri_buf[i].i_addr;
 	if (!xfs_attr_namecheck(attr_name, attri_formatp->alfi_name_len)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[1].i_addr, item->ri_buf[1].i_len);
+				item->ri_buf[i].i_addr, item->ri_buf[i].i_len);
 		return -EFSCORRUPTED;
 	}
 
+	i++;
+	if (attri_formatp->alfi_nname_len) {
+		/* Validate the attr nname */
+		if (item->ri_buf[i].i_len !=
+		    xlog_calc_iovec_len(attri_formatp->alfi_nname_len)) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					item->ri_buf[i].i_addr,
+					item->ri_buf[i].i_len);
+			return -EFSCORRUPTED;
+		}
+
+		attr_nname = item->ri_buf[i].i_addr;
+		if (!xfs_attr_namecheck(attr_nname,
+				attri_formatp->alfi_nname_len)) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					item->ri_buf[i].i_addr,
+					item->ri_buf[i].i_len);
+			return -EFSCORRUPTED;
+		}
+		i++;
+	}
+
+
 	/* Validate the attr value, if present */
 	if (attri_formatp->alfi_value_len != 0) {
-		if (item->ri_buf[2].i_len != xlog_calc_iovec_len(attri_formatp->alfi_value_len)) {
+		if (item->ri_buf[i].i_len != xlog_calc_iovec_len(attri_formatp->alfi_value_len)) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-					item->ri_buf[0].i_addr,
-					item->ri_buf[0].i_len);
+					attri_formatp, len);
 			return -EFSCORRUPTED;
 		}
 
-		attr_value = item->ri_buf[2].i_addr;
+		attr_value = item->ri_buf[i].i_addr;
 	}
 
 	/*
@@ -760,7 +850,8 @@ xlog_recover_attri_commit_pass2(
 	 * reference.
 	 */
 	nv = xfs_attri_log_nameval_alloc(attr_name,
-			attri_formatp->alfi_name_len, attr_value,
+			attri_formatp->alfi_name_len, attr_nname,
+			attri_formatp->alfi_nname_len, attr_value,
 			attri_formatp->alfi_value_len);
 
 	attrip = xfs_attri_init(mp, nv);
diff --git a/fs/xfs/xfs_attr_item.h b/fs/xfs/xfs_attr_item.h
index 3280a7930287..24d4968dd6cc 100644
--- a/fs/xfs/xfs_attr_item.h
+++ b/fs/xfs/xfs_attr_item.h
@@ -13,6 +13,7 @@ struct kmem_zone;
 
 struct xfs_attri_log_nameval {
 	struct xfs_log_iovec	name;
+	struct xfs_log_iovec	nname;
 	struct xfs_log_iovec	value;
 	refcount_t		refcount;
 
-- 
2.25.1

