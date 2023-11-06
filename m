Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 822C7C4167D
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Nov 2023 13:12:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232127AbjKFNMS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Nov 2023 08:12:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232120AbjKFNMO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Nov 2023 08:12:14 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 840D6134
        for <linux-xfs@vger.kernel.org>; Mon,  6 Nov 2023 05:12:11 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6D264Z011546;
        Mon, 6 Nov 2023 13:12:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=dXWGwBKOi/IjEjIn3QLJ0Qfk0SqwnjsNke14A7fAt0Q=;
 b=r4lV6I51NH5J8Y4YolGBxmU/s+xid3h+XM7kawV5woiHEXjFuN+YW5nuHljVYOYbW3MN
 bmDslDJMS5ngYv0hriQLhTfcCoU+yN1xah307BwK0pXERcEUJ6JFgxLZkEZ67yIc8K9g
 yKW07Hm4FTWsLsjCySg/L1q38oFYVRxMbBJ4G10rDoGx9MQmsp7z3X6jlQeZ3UPSCDGg
 WcvSMAm8a5M2FeAg06eBVJTpQ1h7lfCZwOgAXwaDhdABRPxHQOY8SaDDp3+tzykbMoVd
 mGOKHimBTWylg7tOftkIUN7vM4WYq3jiZXUKSxi4SgOWYGJluJuYhujj3TIMl67uwP0r IQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u5cj2u01c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Nov 2023 13:12:08 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6CiaFM023587;
        Mon, 6 Nov 2023 13:12:08 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3u5cd4tbau-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Nov 2023 13:12:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dLtsSEsWY12ykg78/xzdMuWYb9xNRzniRUKdLNYnz1bH/dCy9EVmYz3ZVSaa80G+tigYukhjp4oMxhWYOVpcHDqt9vmhudauYqEwPBywVR25wsz1HYwYG76wH3pW/yFHpsSA2O02/146wZN1MbTB7Z5L/Xd3KjRrrU5ofm2r/g6FCRJh/8BDB6TYWt7QsMhhSrGgHcGNumNGUurAEDZZ0rWkTViUrffsJ/h86CSvzOGqju3hCjEY6hYh4ALtn5uU1ZsKmSw7s2oezf0HMOgoom48JZL70Hp4JkbTZFsrjbw3qX+z1qjyc9p9BbQ7x0jWkxU28bvu7b8xD5YG8hoUqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dXWGwBKOi/IjEjIn3QLJ0Qfk0SqwnjsNke14A7fAt0Q=;
 b=etQPZkL/r0UmdsIM0hUG1fQgitzEi8QydUDZXSZnSHkp2ujUHwlfcA0zA/ezDDNWP4r35c2YL96UxGU1BO/FdJpietj7HI0JEXbicqgz8K4eey2K5ExDtdt3FBoktI0XxLAwEqNqFmEnXLxec/sJm7SrxROTiJHUtRD28DXnD2ACu8rPItS7jy90n+85rmBnJFdj1SCKNfTh9BPX7kIWi+jcbzEtR8yQQMgNksafoe12BzOByTZusWUIx9vp9vVpMWkvxvbIU3TztrsjosIILWY8LH3o6HDsWC1+qD8AyKGlk1vI+M7cWZ+UH07AGNFuqIb7fY8LBadx2JrxfOVMug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dXWGwBKOi/IjEjIn3QLJ0Qfk0SqwnjsNke14A7fAt0Q=;
 b=ORGIdRL90ud/1FHILJcSu0Zs4Hg+2e814fwloMNmlSbq1YRLMAhdml2ZvTk9/iosDLRZDknuJhAB6KCLvjA/JXEw3Tz1xdtoPjgtvFaSy0EmM+xfIuvp18FyJnESlIFw9Q3kk2bjDH/RyXTqkjcsyjDLJccDaHt0pHmHZStYrRo=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by MW4PR10MB6534.namprd10.prod.outlook.com (2603:10b6:303:224::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.28; Mon, 6 Nov
 2023 13:12:06 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d%3]) with mapi id 15.20.6954.028; Mon, 6 Nov 2023
 13:12:06 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V4 10/21] metadump: Define metadump v2 ondisk format structures and macros
Date:   Mon,  6 Nov 2023 18:40:43 +0530
Message-Id: <20231106131054.143419-11-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20231106131054.143419-1-chandan.babu@oracle.com>
References: <20231106131054.143419-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0192.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::21) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|MW4PR10MB6534:EE_
X-MS-Office365-Filtering-Correlation-Id: 28fba699-25e8-4fcf-6594-08dbdec9f96b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9XYar4wQHx6VB+4AUTo6U4JLMEU9KgKtOwIUBj++N9CmaOEK+ZPO8IhZChQyGQNjyVv6VnhhUUV2OvcH+5SP0o9DPf2R4SUV8qgYBiv43OP60QsWXkuP2n6EBPKf1u83aiLF24/0lrFWoHZ/YhshLuJb0zeDbxbWK2EElm0UPTdvv0K7hsbUkD+fWvAkrp8OM98DOVM0ES4mZBha8paZBS1DwzMH77K/UlSEfrCP2fVHp1vENAgwadmeFjgcxXMYXyBy5NgyofrJraph2cjBDss6A9jZu9p9mDiBmATzGjweLzBikx9JY8G2AJSrRWvl+g0CBxquigxFffaMFABdQAuxUg6oBp3kzi3aRNYUtjm664vrWgmraCWcw6VdSV5JVHqFBfXCfkdX1JVFF90VIALK4/gL+L6BkZ+BkoeJJm5ODA6lsLVd62P/PCV8Fc1s1AqViJwPJSGG6Xgb/l/sc9zcSQ46gInAN7SAGvBtocqRgS5gC090T6CdIEqDNV2tSiT7aLaemUMcK8jATLWQJ0r0xelGt7rQRKo/wACoFA6riYkftFIk6Ov0olaMULKDARCJQI7tTSYOqImPc064+Et65kkazSqoq8Sdr+sf7d0E/Yvcnb1gIMHzWqDgHYKr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(346002)(39860400002)(376002)(366004)(230173577357003)(230273577357003)(230922051799003)(1800799009)(64100799003)(451199024)(186009)(2616005)(66899024)(6512007)(1076003)(26005)(478600001)(6486002)(5660300002)(8936002)(36756003)(4326008)(8676002)(41300700001)(86362001)(2906002)(66556008)(66476007)(6916009)(66946007)(316002)(6666004)(6506007)(38100700002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iRXj/KS5Ix4DTz4v5AKYwVuy1+6G1hTjU+cQotI6tBnZWP9l6+JLSwMVFIFe?=
 =?us-ascii?Q?78fFJ9Apwh5SBs0EYiVzQfJCPRXWGwgjAufv1CAb6AgYDWrLybksAo1ObkOX?=
 =?us-ascii?Q?yFismsqTUer/NOEInTVYvmbBHPXiuNyKNL4LODVOvFnggEg8zM9jABrhqAWk?=
 =?us-ascii?Q?gpqLOS4JFPF/DEiI2zaEe7aVyv8q+66L+JeYEf6y02jU1bDox12uAc17P3uR?=
 =?us-ascii?Q?syEU7h+1aSPVMakbdMv7x4Zwd4brL/75YDB2UlQ3KpoLbs9ughAYBUwmEHQ+?=
 =?us-ascii?Q?rQcxcycumkQADWy/BKtTkWd7S1TJIs3X4yF+pf2+03J8IN/yS6OKTwXBIdwl?=
 =?us-ascii?Q?kNB9wbKmUW9SNFoOS6BvsWD13nLQx3+zI8r78wK0OCuvh8W8Z1CB+QhyNzfY?=
 =?us-ascii?Q?1xtSLIA5gIz9ioaAr+qo1mlFuMjLdhyp9E2Znz1ebCnBQgnrz0VioYxfDNns?=
 =?us-ascii?Q?CAPvDXVf2/grqq07cvY+e4tZ2BSEoy/AxkbRb2oxUUzrC2HEy9qAoes1T/6M?=
 =?us-ascii?Q?dPqMjrXMya1dXbvkaun5uCxsZZRzMMoPqHTrZnhK8yq+eNjZeN/ZudY8h2BS?=
 =?us-ascii?Q?CPm5Ij0J0a+cNXyL4hkqawzn+giISRu15e+DmVIsmU1K8nEtTTnT3qXoaAMr?=
 =?us-ascii?Q?PozJBh1SGbF4TaGxUnpisaHKc6vNwU2wMhyB7LyLLg9iRObl55zEcfLCpmpo?=
 =?us-ascii?Q?s/40XAJ+dm9mv7BewvOtxUvQEqDGLMKgpO6ZLtAtUueCu8CcIowILsScHvoe?=
 =?us-ascii?Q?Hm1Qjb89KnylV3yvznu65/iKglHTiz/eVyjPykrzQITHJ4uk5/13iiUUgc+z?=
 =?us-ascii?Q?zmNuLIgEq1/eJbKkvC4BuCbRNq7oDapY6SJTh+eM+h/otE7UVE5PbqIAR4rd?=
 =?us-ascii?Q?7uWwbO4aIhn4JHerk2++VlC6f8y0Cp15jisMgxm8XKCGPRkL23FzRaXW3p5n?=
 =?us-ascii?Q?0IqEOMru7pipvF6fiEiLTjjNAPgK4IBMCITYE0zdwp+xtBn8ZhS+HXpb7zm/?=
 =?us-ascii?Q?pg7EmGhoVbV/kHkAEjoOJADuwNqkPPpmxVt11JlsZJJ6hp/l5P9yZMVxrWYO?=
 =?us-ascii?Q?S5qjtTqRqClmC3C5/TDLja3ZbCug/gzi4M/k6p1Py0G2ra4huSeTOraYGPkb?=
 =?us-ascii?Q?RqmYPV0KPNUXtrVHv9xvHE843n6o6PR/Yh5g1kjY1V7OIW3Ctyg5KqwxOvK9?=
 =?us-ascii?Q?89WVzhR05rSvh9gWB7zIjTWuemtG6AloJic/zkXfjIM14t8Vjm5weLGlT8vS?=
 =?us-ascii?Q?O2dwI20Msemvneh/3FQd4bp5ceDIg4Z1mcjXed1jKlbUF8O8IasAutdpOjRM?=
 =?us-ascii?Q?kdqR0aMspsS2S+u5BtZT8gyz79qdpfmyv7U2DwoTIcQL1SrpZ0aNtKdr32+s?=
 =?us-ascii?Q?Ui/hS5dDH2Y63ccmdNSRuSy4X0FAZfxvGC44Rce5Bo77LC8pJN5LfjG9/0F2?=
 =?us-ascii?Q?xVCWu9djna4bd39jZDwHa+1al8Oz74ztm12SXIFYD4DNWKyqiZOlcu1Hry9D?=
 =?us-ascii?Q?X6b5Xyn0r4dq5FS/r3lmJsaqYgjKunwlRk65QR0LgWuXX5KDH3FuL/Nji0VK?=
 =?us-ascii?Q?CLbOIIftNqA1+vaPH1+TD8SWHtvFQy3eXrB/uuBFhX3xfw0CAF7Vpf2EezO+?=
 =?us-ascii?Q?1A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: qGkDA2U89k6x3A/tTv2jdA8LivpyExgY25OhZpSLteo1/LozlIiH3JbanNdPUfRtYugCDrv66C/+YOeS9RytrVQQwOQmglwP5BTp98l5aKlB8+iBiFvVjc+0+E+omZBO17uhvulHDs3BUSMlDKQA7qSvXPIwzASVu0xS6yyvlbpgorDYD9WNyWwbq6yA2GQQPDsbpS83OURbN4RPU2rzajcYcQ41G8LohFMtNN+XHdO3hKZ7z4E73ecrve8cmpSQYbs5/orrSXA17OH/NH3EQkRNXmMsnfWhzweS713lDPZwEIa7kCXmY2EUNSDh9j446kBNbzilJiNZ4Jd/klM1rj2w9WYHEd7W7x7DpSOTLlBh4tAy8ww1Toa5uYo834Q8lvGunI+Utt1I4bK4P8EXF7QqfqXRJMUBKcBgnnD0ZgGIun4c7j1ok1Rjgcp+6xdCh5RywbBGY2U1g/qpwXzYsr5KyUBpC1bj92o8FSG5/UTHTTAi7QHYmKgY6jWbvRrCZczOObXVZs0IsHBRwKxtwZjolEHS1WK98sMc7a0ibAO/KxJatf1GMcdA88LkCPVsb45eV6owPEG8cf+HkoiHJM/mt20sAZchZWAWexKZWMemfEjbXJhq8qtvLHwr/ZYUPPJfFtlVieJyFjgUu0bTwAGZYP0gWZiURPPU0jncOK1fk8+26EYvcjGZk9Z+l2h/if8JZJE0kuDfFnr58O/vr8zM7iBEfRxUX7JHtTCr1vJItSkgq4qVsvlygU1bzZfvHJ3gvcnJU5yFRvIxZ1nIgNOb23vJEDBgQOatT4hDPqc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28fba699-25e8-4fcf-6594-08dbdec9f96b
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2023 13:12:06.0279
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L9zEVd8HGMRQ7LR1lq4XW4cUWBno1O7RGDCCY7yrDhlivPMwkr2V5sdThHPuNHCA3sPlSmYBzd7aOh9sybLgyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6534
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_12,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310240000
 definitions=main-2311060106
X-Proofpoint-ORIG-GUID: 5rUx5Dev_YJ7SlxY3SwWWDHLlVdx1p2n
X-Proofpoint-GUID: 5rUx5Dev_YJ7SlxY3SwWWDHLlVdx1p2n
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The corresponding metadump file's disk layout is as shown below,

     |------------------------------|
     | struct xfs_metadump_header   |
     |------------------------------|
     | struct xfs_meta_extent 0     |
     | Extent 0's data              |
     | struct xfs_meta_extent 1     |
     | Extent 1's data              |
     | ...                          |
     | struct xfs_meta_extent (n-1) |
     | Extent (n-1)'s data          |
     |------------------------------|

The "struct xfs_metadump_header" is followed by alternating series of "struct
xfs_meta_extent" and the extent itself.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 include/xfs_metadump.h | 68 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/include/xfs_metadump.h b/include/xfs_metadump.h
index a4dca25c..e9c3dcb8 100644
--- a/include/xfs_metadump.h
+++ b/include/xfs_metadump.h
@@ -8,7 +8,9 @@
 #define _XFS_METADUMP_H_
 
 #define	XFS_MD_MAGIC_V1		0x5846534d	/* 'XFSM' */
+#define	XFS_MD_MAGIC_V2		0x584D4432	/* 'XMD2' */
 
+/* Metadump v1 */
 typedef struct xfs_metablock {
 	__be32		mb_magic;
 	__be16		mb_count;
@@ -23,4 +25,70 @@ typedef struct xfs_metablock {
 #define XFS_METADUMP_FULLBLOCKS	(1 << 2)
 #define XFS_METADUMP_DIRTYLOG	(1 << 3)
 
+/*
+ * Metadump v2
+ *
+ * The following diagram depicts the ondisk layout of the metadump v2 format.
+ *
+ * |------------------------------|
+ * | struct xfs_metadump_header   |
+ * |------------------------------|
+ * | struct xfs_meta_extent 0     |
+ * | Extent 0's data              |
+ * | struct xfs_meta_extent 1     |
+ * | Extent 1's data              |
+ * | ...                          |
+ * | struct xfs_meta_extent (n-1) |
+ * | Extent (n-1)'s data          |
+ * |------------------------------|
+ *
+ * The "struct xfs_metadump_header" is followed by alternating series of "struct
+ * xfs_meta_extent" and the extent itself.
+ */
+struct xfs_metadump_header {
+	__be32		xmh_magic;
+	__be32		xmh_version;
+	__be32		xmh_compat_flags;
+	__be32		xmh_incompat_flags;
+	__be64		xmh_reserved;
+} __packed;
+
+/*
+ * User-supplied directory entry and extended attribute names have been
+ * obscured, and extended attribute values are zeroed to protect privacy.
+ */
+#define XFS_MD2_COMPAT_OBFUSCATED	(1 << 0)
+
+/* Full blocks have been dumped. */
+#define XFS_MD2_COMPAT_FULLBLOCKS	(1 << 1)
+
+/* Log was dirty. */
+#define XFS_MD2_COMPAT_DIRTYLOG		(1 << 2)
+
+/* Dump contains external log contents. */
+#define XFS_MD2_COMPAT_EXTERNALLOG	(1 << 3)
+
+struct xfs_meta_extent {
+	/*
+	 * Lowest 54 bits are used to store 512 byte addresses.
+	 * Next 2 bits is used for indicating the device.
+	 * 00 - Data device
+	 * 01 - External log
+	 */
+	__be64 xme_addr;
+	/* In units of 512 byte blocks */
+	__be32 xme_len;
+} __packed;
+
+#define XME_ADDR_DEVICE_SHIFT	54
+
+#define XME_ADDR_DADDR_MASK	((1ULL << XME_ADDR_DEVICE_SHIFT) - 1)
+
+/* Extent was copied from the data device */
+#define XME_ADDR_DATA_DEVICE	(0ULL << XME_ADDR_DEVICE_SHIFT)
+/* Extent was copied from the log device */
+#define XME_ADDR_LOG_DEVICE	(1ULL << XME_ADDR_DEVICE_SHIFT)
+
+#define XME_ADDR_DEVICE_MASK	(3ULL << XME_ADDR_DEVICE_SHIFT)
+
 #endif /* _XFS_METADUMP_H_ */
-- 
2.39.1

