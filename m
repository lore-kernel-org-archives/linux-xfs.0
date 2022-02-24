Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0266C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Feb 2022 13:02:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234729AbiBXNDZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Feb 2022 08:03:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234723AbiBXNDY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Feb 2022 08:03:24 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0979B20E58E
        for <linux-xfs@vger.kernel.org>; Thu, 24 Feb 2022 05:02:55 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21OCYJiv000938;
        Thu, 24 Feb 2022 13:02:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=2e4letPu/8X48bk2LnFYZ85vi0veWBapY+gWpBAvNIU=;
 b=NG4FSAzF5T3Rxea9N1hqldhO6Jmko8tldr1v4iXfZGYj9CqenBNi1DH4nDMWmBJ40XMb
 AcbTcMhRQJ6TJ/S9YKn5R9CCN++kt/f4823ny5O/FBaq7GvaroXetBOL/Je0ey6derzc
 ShDKfap/3q0b/oUWtD6SJeeGY/rFaWaKtUXSldfcF/u6rS6d2zaM7hKhSNbW+BhTL/qE
 GXsY2oc151eMTSv2Pgrf6QZ0gShExwFEB4Ll0gFjFubijnfhhxjuncK5jfob4iNGETpT
 bltFCqCtHamaqc8OMOw83TRgB8eKKWLiDH/LI4/z7ofivXq3ExBqIzNfaYIP9ryA8VTL 2Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ect7aqa79-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:02:49 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21OD0X9d120471;
        Thu, 24 Feb 2022 13:02:48 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by aserp3020.oracle.com with ESMTP id 3eb483k75h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:02:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fvmtm4MVE43xsxZYiIv0G4r3Su+cPONygt0zRUGHGmRCbbe+RaeqrQy0vUXkQfBxry5oGJ1xnZ7ZohI3UQNPr9E7hyY/5e7ie9XT8GJ8920xO9XLfDBuQ2Ha0c384b0LHsicTqCkcG9wH+n4tIa3+q7A5Egh6xq2dhX6eC4VVjyqiqfBGU3v5sgdtlalpIJ+BBiV/NPHERcJBRZusf1Yozowl3nipLaJe4oGCX9y9GX2QSHYEhO+eElFNQTRY7Q5b1Jn2FDIC96ZQaptI+1TXX20jle8sgsShshF+N1iz+hd2tTn1GYh1fXN+7CCy6VFbIq0ZCDBB3KlQOnY4II5Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2e4letPu/8X48bk2LnFYZ85vi0veWBapY+gWpBAvNIU=;
 b=UpoqlTBkQXoz7uFyheb/T7OQ5wr7q6/awfbYShID7GyMNHCExmhWpZMz5/sfaWe+LS4KKCUUzT5JMSWti+nH+tG8Giajj9RzOg6YroeHQWZ/36a3Qv04Nk2DrZ/4fEao54+bfHBdmbDWz6xUESZyKsH15FvJqCX77PfL18R6wl6YQCGOKsuZY9oq3A4JovMjUuxN42FvkE61h8ZIhN85yAXY/mYK0jbu1izf+8edvBdpUD8PYwqdTLEA362jn+vsQNj9JpXJ0CpKzjZST2DUgBwAZPTQL3Lu8z9BqbkyWtJV+5hiwvauWoMsnvQ+J07ziT1UAgIclptj6YwcgwUSMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2e4letPu/8X48bk2LnFYZ85vi0veWBapY+gWpBAvNIU=;
 b=tssiAW0ZsWgo6bQW/2dH+SAWyXTqaJxX3YjoU3k4z1Fikgi09/X26NMArp3mG9pr4D8YxkLbg1TS57d2Exsrt2nLN3iiOVKXGGUwX8uWXEbpOwW+WyJqbD3QnrrwRSIzqIRI6rWfbB+z9lvw0vyB2asKvOqlevOL4kwHmHkG9FA=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BN8PR10MB3665.namprd10.prod.outlook.com (2603:10b6:408:ba::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Thu, 24 Feb
 2022 13:02:46 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%7]) with mapi id 15.20.5017.024; Thu, 24 Feb 2022
 13:02:46 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V6 05/17] xfs: Use basic types to define xfs_log_dinode's di_nextents and di_anextents
Date:   Thu, 24 Feb 2022 18:31:59 +0530
Message-Id: <20220224130211.1346088-6-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220224130211.1346088-1-chandan.babu@oracle.com>
References: <20220224130211.1346088-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0009.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::18) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7769e0b2-53cf-417e-9e64-08d9f795f3be
X-MS-TrafficTypeDiagnostic: BN8PR10MB3665:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB3665A4E37C728AA56D0896F7F63D9@BN8PR10MB3665.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bPKGaQouPXSIXwW92eJmw/IZNr8wASepIcp6bxNNIiYgllKoA78qOdx4DBym0Q8+GXiVS1mtTKqydN/73k+GVjz3NIQeLcNWHjj+TuxG2sCqBzmo860U7YZ4hudRMyXgNicULpqN+ksjnLwJZGXAt4WFFO8RYx6JC/tPdRxfwF9D6QumQd9MjUXS4tGSXfU9rsjZ/Re+/vgi01nSGi2z0nbfCD4wLWrmw5pse5k0bDSFLMXZsQy/s6tNnaDnx4l59Z3s9hPwPhtHyPlBJrQeP4wKnLWd9lmss2X+1KMgIPXCwseyUWOdThTqTybLUxf3j/kNH1sG9X8SQL2CwQ5mFYyXOrQQ90RJVJsKyqey5B8Aws0C2EoNuu2nv7hAN/4LRrxIxdIVYmp299Oe6u76Ii2aX/SVlt2QYBe41zQxBS6H/+kceq1Xy4MpxkcAPigxAtLyBLCvN9FiXyTb/Wcj3CGlY3Z03m0tUyfeX5+16eap5LM0BlVcMqNJpqCxajbGnLtsvQnZ8q4ZiP0XPv/ydE2TeeqTx1Xg3OxluXT/TrbPirfPjEKxDI3i9RNnw4OInrzhgdqEe7YHRYw+11L4UBTyXLX+AMz+453VLECUr68UVSIaI3lT5hBdbtWrNnyfV7enLp3NF/7Hu6kyjpdXeHJq0LGZ0Av+SbLQDYbTp2Sn38W1yPBzrsdJQ4Wo2UbEulxmbYN1sjwsKUbBaPGDDg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6916009)(6512007)(8676002)(316002)(6486002)(52116002)(508600001)(6666004)(2906002)(8936002)(66946007)(66556008)(66476007)(6506007)(5660300002)(4326008)(83380400001)(1076003)(36756003)(38100700002)(38350700002)(186003)(86362001)(2616005)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vzEDzMacrEN5x7Mj4Ice0Qi6ml1VT3RNoO3b2ssQBzY83HvJOmzVIzowVHhG?=
 =?us-ascii?Q?o6s7pydlZtZBaMW+jX0Av+5Kucp+gBvsXu4RIZUKXtDVI5MPnEz1X7EkUUgQ?=
 =?us-ascii?Q?+Cr0TvikyHhxD+8XLM2ppu0YlM6/TMx3rYTNrdcmX66BNGhvN/GRyYfRs7aB?=
 =?us-ascii?Q?36SgWjn3Pzu2kOfL0+x1uPKMS3lPR6F9qW8VqfpmPOy4RXNx9JE0Cq72u9pG?=
 =?us-ascii?Q?Nfh3MeeTBls6Op8EP3PxHsPMoMZ63OdShoeXv2Rte1aXoyOwQcHO4muC/esG?=
 =?us-ascii?Q?7YeUlYy8HE3IdYBM6y8C2KBTFSS14hbWoNEDY0FjDoO+rDcS4iCfwLrcEfuw?=
 =?us-ascii?Q?OYUXLb6chF9ja/nhHcVjsfDLwUKAluJcJa7goDkadzAzKqn6YvQUHeHziwro?=
 =?us-ascii?Q?3Bt2kgr7qTOuXsuvRVe8svwyujnfTo+DHLsq7RTMXvEBPT497VQ0raqE4Io+?=
 =?us-ascii?Q?VFlLC8ZwX6nHQRKCkhSSCQVUcnoU7xnF5pBQQsRlvfRMj8qrC/637NBMBxGc?=
 =?us-ascii?Q?/fvaRw24cnMMW8bdROFLnad0nzztGKz/IfkjV2ufDpNVpYmW+ECuL2bkpNMz?=
 =?us-ascii?Q?E3J5HLoZoD1ebAikaY8WhxrD8H76m+XrMrDpntD42YPveBpmch2NQaSieerY?=
 =?us-ascii?Q?daI0K/eRdoZusX0bwTZreE6TD09gU7zkyitjbzLmtvQrTeNY3n7xJVlAk4fy?=
 =?us-ascii?Q?QKepJKEcfwib4rI17bY3Nqi5hV9S2Uy0ok2XNppi9wYIi+jNFyYC7qYMc6OC?=
 =?us-ascii?Q?bkft1fV7ZX1abix8+JN9raQgHg+dtzcMHP4sBZDHN0wp95yjvh1WTbNENey3?=
 =?us-ascii?Q?AfvPcdkG9r4pg42dfdAyCtELEotcFNYd1CblSbueuEAS81YIv7W5HfWbUOSZ?=
 =?us-ascii?Q?WBwW9BtJ56iS+0d2vR0lK0r7Y/nD4Ku/B/XQUnt9gQCJS0ctKtSLUVfGWMHH?=
 =?us-ascii?Q?sBNa8tErFS2UdAPfdFiJZCoFtf8gBnZGLmfEvisqqUz7HxLCNpHIOS3jtsZQ?=
 =?us-ascii?Q?ekSn+osHk1+xMUXPkV2DBlVEF5/fIZcGUIYw+64k5HocledlYxREax32LXTe?=
 =?us-ascii?Q?Te//HlHgKKaD/oL/F9prCeSJEgJcYgYveG0ewUsaW+GxW4JCE8w2canqq5ol?=
 =?us-ascii?Q?vlAjgWXB8PF4M4SRcWKfdty+91fACqPQlV4VcAm/p1jtfAOWExSCnNiFLjQq?=
 =?us-ascii?Q?BEmmfmKzW6uW0Tz8sOiQ3Bmn3tZ7UZmU45k41fatldYhPp9Wh5EIAexx7ybB?=
 =?us-ascii?Q?1SQQj918KZPatrAnLmM6UK5tbRXW2pK3qgNAcG3OYf+u2aYNF6lKY/LwWibc?=
 =?us-ascii?Q?zwhScQkgP86opftqF1mgmPRj+AFadFiu6vkva2c89JkopHgNbblHfSQHIhQ1?=
 =?us-ascii?Q?BXh7Prj3Iq6sSV52+eBKZ+4pH26IyFaebZ8zgzdMtovZNwH1FttjEdblIeje?=
 =?us-ascii?Q?ueNalIgP2mXJT9fIY75Ai88tMIK5qYvBpgSOUxlM2CKnaP1gcxTZhsPchQY2?=
 =?us-ascii?Q?6Ht7StE0lb94I/ZyWJqxooeCx+zRgvDVZ5S12HdbxJn/BKiETHxhgMhfqTj8?=
 =?us-ascii?Q?9WyC8/AGCAxhA4bIu+fEjIQgg0GtC+06Lm077I9QmNQoKUwnHKGDBPsV/KGr?=
 =?us-ascii?Q?JYFxSUvp1D6ACaj/hYQ5PvA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7769e0b2-53cf-417e-9e64-08d9f795f3be
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 13:02:46.1804
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oTlCjwDBVZVuK7MSu1UAbGPkYIrwDQ72HXfpUXh6niMkBedh/h6bPwYyg9YEs0RHhQCM8JubeYjoi7IBAMEQ4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3665
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10267 signatures=681306
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202240078
X-Proofpoint-GUID: Vqk4ia5IAcrGPeo0TStrGuc0bTn3GuPP
X-Proofpoint-ORIG-GUID: Vqk4ia5IAcrGPeo0TStrGuc0bTn3GuPP
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

A future commit will increase the width of xfs_extnum_t in order to facilitate
larger per-inode extent counters. Hence this patch now uses basic types to
define xfs_log_dinode->[di_nextents|dianextents].

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_log_format.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index b322db523d65..fd66e70248f7 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -396,8 +396,8 @@ struct xfs_log_dinode {
 	xfs_fsize_t	di_size;	/* number of bytes in file */
 	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
 	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
-	xfs_extnum_t	di_nextents;	/* number of extents in data fork */
-	xfs_aextnum_t	di_anextents;	/* number of extents in attribute fork*/
+	uint32_t	di_nextents;	/* number of extents in data fork */
+	uint16_t	di_anextents;	/* number of extents in attribute fork*/
 	uint8_t		di_forkoff;	/* attr fork offs, <<3 for 64b align */
 	int8_t		di_aformat;	/* format of attr fork's data */
 	uint32_t	di_dmevmask;	/* DMIG event mask */
-- 
2.30.2

