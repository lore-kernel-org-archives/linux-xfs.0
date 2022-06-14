Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BEEDC43334
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jun 2022 22:01:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234419AbiFNWBp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Jun 2022 18:01:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbiFNWBo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jun 2022 18:01:44 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B3BD2182C;
        Tue, 14 Jun 2022 15:01:44 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25EKTDTj007777;
        Tue, 14 Jun 2022 22:01:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=Q+BU+huRPG42X0WipjZ0xE/qn/LC6vVDF+NxXqqci6o=;
 b=akSoZOqHDSqKaBzHJPUFCRasqXXKP6Ig8LhnpiJ8AcRcb/KOSyo5HD4YRIvPTV4l+HhG
 gsGMEXMDbENfySZR1AOQVZcNRUdObPG35niVEyGGKliMXaPSz/Zboo3n7KW4X4JTIxTM
 BwSZeXOap77vKsKM6TFsEPSNNjQptqpmENVqrAqEyp+gqxRx5SYJUyKPcrOP2e6pLSTG
 67b+u6uQSAILZFIVYDVUx1I6L514ANgn5SWyYD4Gr1Flf/4v4eLH9PW5rApwoIJY6lV7
 0P4mnKrTuyFnJBqKTEaRYFZRI0J12XsVRMuHgO8LYRCpUiwvkn+muPmZ9Vfugzmma2Tu mA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmhn0f0k4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jun 2022 22:01:43 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25ELu9jD017023;
        Tue, 14 Jun 2022 22:01:43 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gpqq0n5vf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jun 2022 22:01:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VccC5lC05ec+uHYVvPQa+XwJg3KzwZw77CS56iECdE45Leb6xaLjflkvHmPkiSwgxh2k9D0U7yFBBHfesiHcJyCZEY5gJ6XYrZHHCSuPp7YwJknESCy9+AkrynH2Caqg7cZgjUqD9rTuRlQDvGnO3jdz6XMSjX6rng/IV+dGsqR2QoXFwPZCWu6LJ5JBchMM/QkU1E0IRX6Zcan6J0m3CK8Y5lxqZrcfahYgHgPN328z8okkGAvDkpnS8PtFbJbZpZHhAP3nmVwugEn01/vs5fp1PVNVrl9hWyoXwRVPCi2j9yA1V/eOCT2isu00o44fPxaGMPgCNzP5fzVxogI2/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q+BU+huRPG42X0WipjZ0xE/qn/LC6vVDF+NxXqqci6o=;
 b=SKEt9a6UAyFscU6l6XYWlyCMLcCoMyW1p5EG7kd/n0da1uYRio+qIfmHfEJQwSsIlcWbI9lzHPnXC7YXXFLj5svsGOmnTIQe10ZdoqmcMQtr9v6Pp6SWOjnPgpmKC2bFHV1qM5kG8PVJDgbMvdvR7qAX6u/zO1M3LTsETmTf2g5npG0hloMCzgVkRjO6I4QVN7Lw45gZssTHmHOtxhxgiSaJyePOOhU6CtJ0PMXtsRzT+Eknw8JVmi+VGrPafbc48aqu7m++HkUgqeZEflGKTaNOz0Ld55FYMQMVbMiSkSBMqYYCbywzVBWJWR8J64jw7yYpgWR/0oEor1HKIKrLcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q+BU+huRPG42X0WipjZ0xE/qn/LC6vVDF+NxXqqci6o=;
 b=sQH6Y+8HEKIGyovghapipoRCUPUCrmqcc4EM0zX5UUgaiFIbQFDUfWvXX4X8Z2vtjPaTEfWJN13/SDedelT+8+cIPbYGKkZNZrXDQ6KacWx5TsDLjhs6h1YZKfv3fB23aweSEAX1bEG8491QmGhbds8PcGV3/7dqHT2gQ0eoHSs=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BY5PR10MB3810.namprd10.prod.outlook.com (2603:10b6:a03:1fb::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.12; Tue, 14 Jun
 2022 22:01:41 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::13c:eb32:74ef:25b8]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::13c:eb32:74ef:25b8%7]) with mapi id 15.20.5332.022; Tue, 14 Jun 2022
 22:01:39 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH v1 0/1] parent pointer tests
Date:   Tue, 14 Jun 2022 15:01:28 -0700
Message-Id: <20220614220129.20847-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0099.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::40) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 87f4ae71-90e8-4807-1a7b-08da4e517560
X-MS-TrafficTypeDiagnostic: BY5PR10MB3810:EE_
X-Microsoft-Antispam-PRVS: <BY5PR10MB3810F87091381D95866D52C289AA9@BY5PR10MB3810.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z4l2lNdT9gcoSTRbpuxvj+s7rLqRqJIdsDpJ74xOrPNBoyJb6W5dRX2UVCU2J+bVJg8jijSssIvh7B0Hte+9ehjKqRoK+HWgW1yx/NP6KraIiivyXHopDBVzEXiVv5DXtHlhTcRW6ko0EzAO2omMajjHc3HDGR+Hzt2lBcUgbIVPaSkyQqsChVn75fz7SwCj7haa22Q1d0MYRRDBA1/jZ9e5BY+BVohPsqowP6NZFbNOEV64Ejt8nzy6xXp8bTNi5ob6VqCuL6uvjHxQFKMFmPGJOMurCK+U9qM1LGWAM4lt6HCdrz/gb2+HRedKCEEizA1xOT774t6ax3UUJQY+U02FYdszS6Q/36A0I/3HDVQz9LYGhe5ceILtwPXl3aikfmmXPnRxAyf7hvd4MhsPV2ecZl4yfPDAxk9ppLX7VMgU62Mp7YujbkvukINgIKslvYliWK++Q/dbh5YM+gYlXPTO0/9Ym1Hn5gOoCVOInsjlAW9AFzIIl4AQfO0ZKcjzYCrZOwsy8HYc3ylCkub19AxzvKtWVrXiGDre5iXVO4Y+Cq2TbfxeyerMhsilTQ//goJRGanp0pqgrez3/k2WElNBVpyMq4gu3rywgoeyj+6x9J9O0MctMfB7QifFtfKSWGQSr6jiZa+zLOcRxtNqFRPts1PS0Q3IJuWY3dmS5sS3pGGCnPenfsyOzpYEXUErRRRYf0OxUaaPsH1J1UyGGHX0296r0AlFuwVM2YPB80A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(2616005)(6512007)(6486002)(186003)(6506007)(44832011)(36756003)(6666004)(5660300002)(52116002)(8936002)(966005)(508600001)(1076003)(66946007)(86362001)(8676002)(2906002)(66476007)(66556008)(316002)(450100002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?42tM7vgbUX68zw1N+LxPj4rlBe/mLfroh13J2KKoXNItchDRCK6nHsOXblfY?=
 =?us-ascii?Q?9VNepHTE5m7Ac2OK3GAUoW4ASgG7+7L1XqqWoGidhSXMeIDWwQEOFkS+2f6f?=
 =?us-ascii?Q?Dy0u7hANSJEoqaUHRS1xOFb/oSOz/SklUpCFgSs+Iwn30dVylbopZHdr3CMs?=
 =?us-ascii?Q?kh5zq82ZY8Fc+Me6J/bpwy3/hv75olQYY1i3jxK6kTF46b3hxBr9W2oBqGRI?=
 =?us-ascii?Q?dAR0FYCyo97voBpZyo+1xR3mlvbdfBcv0Hc1EtK0wAv2I4AvUNJqv6VFPx0q?=
 =?us-ascii?Q?uKxGpf5Sm2Ak071lYA6YZ+CCaMZSPKV1bMwAiQJCWIlKB0SeYepe6vSOaH56?=
 =?us-ascii?Q?RT1Fi4qfvviBEc4w5wpZKH5sg55NJSly27ETFI4/Bjod2T1F09cFksCeByt1?=
 =?us-ascii?Q?/jqroKwP1vHvm7uhqCoJxIGN5HhGkuWydZ0nOvlLkaH0qfePxo1jwY78DfWd?=
 =?us-ascii?Q?T7FycGXhd/ERz/UOBiy4IIEKc/lB8F36Rqen3cBE8I7f2e4k/xbyPgChZTK6?=
 =?us-ascii?Q?f7Hv+dhCHq1K1bxlVmRZMeMgg/5c0waqECR4oRU8y5cXbxIjGXVfFmlj+VE0?=
 =?us-ascii?Q?KNqi98rtFnzqSZDvOUtBIY43SBd5W+hJVVs4ppIALyKjPboQTZqTmgHFz+J6?=
 =?us-ascii?Q?ITtLlwKN3Ovu/Ckqem0NalEETduKzcwxt9ZjjbGeYBwXWTM3IdDxnUTJ5TPr?=
 =?us-ascii?Q?OmHUoOw84SATrLi3nn05+lYkj2w1QFTPZPb7YbATXgZoN3ETGUkvmf7oCyYG?=
 =?us-ascii?Q?E9dYKhif5XPGU1UHRlcsZxRcO31v/CmDIflYtOCSqiUKTkfg99RWl/E49GRI?=
 =?us-ascii?Q?Narx6rybubtxsmYpMz9F+NLuy/tNAq9IBdZPZmNFx7yYGHefFU+XOiuvjUBY?=
 =?us-ascii?Q?vCleVhx1UrwfY88zPT2V8z0160J8R2hWZ4SbB3eUOj+qlUxj6AdoYSSuT93t?=
 =?us-ascii?Q?YbjAnDJnJYrqYU6tUZSEEuhSEpohe7T+W7YiwXy63nWajA5HwX0ioTIaDDUX?=
 =?us-ascii?Q?oOfjGAChhlUXLqoxhoOnmpt8sAw7hq4lLxQ3U+F4BMPoVme538yGgdW0Ic+1?=
 =?us-ascii?Q?/DSdiFLaZM9mSBLLF1mTV8QPb7aH6G+7C3uCFUcH6VVhdojb195L+pWXNtxB?=
 =?us-ascii?Q?i7jfpTByFpczrOPKIQU57GqLwCTe5o9s/KWlQJnNNLOUDjhfSvVxmF+7R1oi?=
 =?us-ascii?Q?6Zwd06mICDEMx1FsTuqFo4/Sm5dJZ+YKQI/ccAghK6xGI3iFhd2ssgLJzRQj?=
 =?us-ascii?Q?FdHtfsdWLIAc2CZuQciNNMo4OQdYtm0ALaLM5cFqUP9vW/98lGlUrvMAH4SB?=
 =?us-ascii?Q?RakdQoPrrFO/cLMH/l+mp52DrZwv5ltv4MBTNuyoRO3w9rIWau7km8iDyr+M?=
 =?us-ascii?Q?E/37srmhxfUIC5/M8MjV0apAk5bUSXkhyFuz859hvUD6wuwVkCvrgRrN+MAF?=
 =?us-ascii?Q?pfkYAmZnwGJe368dY2p9hu1KX659pAE0dV6FD3Un1/jffvni33//QIrUY6Js?=
 =?us-ascii?Q?bnpKiYM7ElLD4R3N6xO8pefsIHFrvCKpdxc64iy/QM2OxatrisKvLvctlQ8C?=
 =?us-ascii?Q?Uxvr7ZYAc6EoDbGds3tFS0en33DrAFrblaNJhW6Bfz89iBtlpbvgxMWDDZeI?=
 =?us-ascii?Q?+5uHQqOUu2vmIijKlnpyR4yrEqC1ck3HxMP9VFw0n7JklQLRDPI867YR+hoE?=
 =?us-ascii?Q?XNz96Edy/4m0j4LQIwyi1kxGmFIVTLLseMgdB/QRtz3UDHxNxHWTI6jrDcH5?=
 =?us-ascii?Q?qjKFiEkYZi8lnG8d7CRxbNzb0oxwF0Ed2y9s8yLrvdd+4+y0Ug3Q?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87f4ae71-90e8-4807-1a7b-08da4e517560
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2022 22:01:39.7708
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rglx6xUPzSYHsIeEkvr9IEBV9102QS9/YcToIfSwTAWJs5MO1YqtXLGLbqEd39zYSTL9iHnFxotm9jbzQFh6Fa42lAA0v8ojifPhf0SpxX4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3810
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-14_09:2022-06-13,2022-06-14 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=984
 bulkscore=0 spamscore=0 phishscore=0 adultscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206140077
X-Proofpoint-GUID: jb_gU_-cy2Pq9PKW0idy3MY8HSyGHhPC
X-Proofpoint-ORIG-GUID: jb_gU_-cy2Pq9PKW0idy3MY8HSyGHhPC
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

These are the tests for Allison's parent pointer series:
https://lore.kernel.org/linux-xfs/20220611094200.129502-1-allison.henderson@oracle.com/

These tests cover basic parent pointer operations, including link, unlink,
rename, overwrite, hardlinks and error inject. This patch also adds a new
parent group and parent common functions.

Feedback is appreciated!

Thanks,
Catherine

Allison Henderson (1):
  xfstests: Add parent pointer test

 common/parent       |  196 +++++++++
 common/rc           |    3 +
 doc/group-names.txt |    1 +
 tests/xfs/547       |  126 ++++++
 tests/xfs/547.out   |   59 +++
 tests/xfs/548       |   97 +++++
 tests/xfs/548.out   | 1002 +++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/549       |  110 +++++
 tests/xfs/549.out   |   14 +
 9 files changed, 1608 insertions(+)
 create mode 100644 common/parent
 create mode 100755 tests/xfs/547
 create mode 100644 tests/xfs/547.out
 create mode 100755 tests/xfs/548
 create mode 100644 tests/xfs/548.out
 create mode 100755 tests/xfs/549
 create mode 100644 tests/xfs/549.out

-- 
2.25.1

