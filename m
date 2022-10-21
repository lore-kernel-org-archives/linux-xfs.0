Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEBC5C38A2D
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Oct 2022 22:30:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbiJUWac (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Oct 2022 18:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbiJUWab (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Oct 2022 18:30:31 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEE3D26C1A9
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 15:30:29 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29LLDrSZ001722
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:30:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=c6Xm3lW8sY33JJtfNEuvfhnDZfcC17xESsb28pYxFIg=;
 b=MAbo9T+8cwHAbQ+8MIpildbADaM6uGBvlGpo741YLSPzsHhyZ/FM2Xb9x95ttizXUfnd
 tFXdi70IYD3C080GnNn1sO9+/DbC25Gp3dAqaOCcMDhBC9Qz+0QPolqRSWJLF3A0pd6z
 ZzZrmCGvYRgGGubf5XvqzdVqOTN/e192nCnHcfq6g0elVniop3O1lMvNYAs0oqNDtdEP
 XYzceHa0x2XAfQ2AOIn4jLb3HFHT+cmRmfLm7SLXFvqHShb125CG8ufRQGig35kS/ZQE
 daP8F+W3EGupuNsFBQoCGlSndcGSRVhqxU/3Prm16qmYzHU8reaRUQUKgDRnsq/ecLaB 7A== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k9awwdjpb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:30:29 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29LLkXZf017072
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:30:28 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3k8hub8jys-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:30:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VnNs1Lx9G/1FdMZdEAKFGWYFozMUyjGaC4Paj+dQA2TMrxoLab6/TcnZqY2xOXJth4rMiEKgDDQv61blgX3yBqv0G5DD/PHxjjV3veExmPSXORX/XumQeAmQKs5TIEycjpaolDFJ78FdyL96DilgA7r2rlIqKELpjZw2B4EcyO1RejbU+ixiiFusi/LcupG4fHAGjww+zC5x7z8zTQC4FmBoiPhwSmPfsZCFqlWcABcLisqt9J9NbGnyHk1b2I720vATyYvSJ1Ta8j6tLrgnJ1ABId04/WGkUzmo3XIXH+Vrvi0tq1RRq4jlJcWH4hRBrMUmiHlAR1Z0h1mQWQB7Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c6Xm3lW8sY33JJtfNEuvfhnDZfcC17xESsb28pYxFIg=;
 b=DRf8G8X25isUPgZ5n20sl0zxCL67jsn19/eCQJ/KPp25ErO5YXLLZ4AwjC9DqeJ6Nq475kRX+J0GnHhUYeOY/s0TZ6WvIuybRA8UiL5UVpI1tSY/eXa+v9ZSsb8FBb6YHswXmkIp4emhQjlWYmLYuFvMcAZCz6ze/Z3A503pb5DZEhs9+p1/fJwxI+at7ZN3DKQ5qjliZn6ZOut5JiSttF4Bly+YqhOn8w3sohXJEnFK5/YudslQ4VwFmmEQ4SlEJpg5F2gtETY5f2umxru3DQJQvuGwE6D0ftGLfQhh0LrFzvgxnEM30YoBJzEtaCI0V4RdSTZAr2rJ7Y24MInv6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c6Xm3lW8sY33JJtfNEuvfhnDZfcC17xESsb28pYxFIg=;
 b=VLR4FelbDi0j3Kme/TyOtY0gxP5Viv3BiWe8JoC0rMw1wHMyRcGcdTXnLS4devMXMg7GQzzAGtOApqnctmcPnpzKYCpi2yHXLXE1V8G1QZe8gyHHhpww/uo/XS/0y4NdF9OzZ3hk+V6rcNGGes9NadzimJjZpEw3LCQBxSg3q2Y=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DS7PR10MB5213.namprd10.prod.outlook.com (2603:10b6:5:3aa::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.35; Fri, 21 Oct
 2022 22:30:26 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5723.035; Fri, 21 Oct 2022
 22:30:26 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 27/27] xfs: drop compatibility minimum log size computations for reflink
Date:   Fri, 21 Oct 2022 15:29:36 -0700
Message-Id: <20221021222936.934426-28-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221021222936.934426-1-allison.henderson@oracle.com>
References: <20221021222936.934426-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0161.namprd03.prod.outlook.com
 (2603:10b6:a03:338::16) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|DS7PR10MB5213:EE_
X-MS-Office365-Filtering-Correlation-Id: 427f2649-cb9e-4e7e-80eb-08dab3b3d9de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E0yRrm2xV97uXFlrEp8FlYTSr6oyQq5TnL53rv8Dl62p1Gky05ZoKS5OKvWPqmWfZELb1iEPBxBjpbqP3vbeXitrtBY61gRpQf3AsxJ0XQ8w2pj+kpRLZuQ7IBLYsgOOAZPIPK9pWIh7z+wSWiy2EoNj8x0mQPmcDU1Dgv8hORUEYQZR+l34okfLCOUcvFbhDXiqiDSwHD5//QyIjSb76wSgTLgIUf+qcFN7zEnFhXsFq3OvAWr/jOq8i0oEVfHed+JACreog8naaOL5xdXZKq0tSVUE1w/PIU9K8+Z0F5xUyEK/39LC+9AWhSGzH3gBiDGo0IIkkFNjHGYqO4YO1+WpJYjvWBGjN3wB1+SgaekityPkCXcTVoCkeeYcW1pqWHhQzfL/Xssy1LnhZPvk7fRm0Uu6jgrM6P05+PK+oqtooGQ7ENOOWJlXXSPTlt/kmRxGoJpuecBntlxjQxOujJ9L5yX6T53pFZZ9u+eOtnCRSvNpj95WPIHB3PK2TzR4KpmyH1/LiBU8B5TGTjzkW+mv4xAIYJlHo1WdihKMk4ca2Mn54FpKLtr5BpYrvlZz7KDLjzHT73dP44b+3wr9o9YtTvTncPVaqYguZkMoFNNDRF3hx6bMPkfZmHysOo8TOUmvBBCZ7uus3b7Y/EY/ZpLPz5Au/Iq5avMWw9k9r2eirKOfKvnVxG1jwl4NCMrA1fi3AZAnkqhnBUxoQeCz2Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(376002)(39860400002)(346002)(136003)(451199015)(66556008)(8676002)(6916009)(66946007)(316002)(2906002)(66476007)(8936002)(36756003)(41300700001)(6506007)(6666004)(6486002)(38100700002)(1076003)(186003)(9686003)(6512007)(26005)(2616005)(83380400001)(86362001)(478600001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mS/feiLgpkMnF+q6USOlwfQqZdfDZEU49gL8SEbnO28HJB/s8zZsoB5ugZp0?=
 =?us-ascii?Q?ss/xUJGk0ZDRLJi4jXrBKo5fS1yTCnn23cXFKQY/pUqAQk91CD/bXFCt2apY?=
 =?us-ascii?Q?GR+ooqkoxoBd20Grsd4vaJhMm33BTxBBJpHaoXLwxdE8uuxCAY0Pfs7sDSDr?=
 =?us-ascii?Q?Ax/DYm02lRQZV2cYPEiL+ptaNidC7DMGxUu/cEefezC7YhVUxR6+IoFvamEX?=
 =?us-ascii?Q?yKw/0hs4hvuxKrHFI2dTkT9flSnkU3rQurP5YXulgjWZCCMe4Tf7Hvi3lcb0?=
 =?us-ascii?Q?C2J26qAPnPPjoAh2EMLmtDh+7/GKT/yWbC0panqiO7Db5QrYdlMpOduAosyR?=
 =?us-ascii?Q?PZ/pzQI/GfiAqMJbC0KcsPRZJWyEwg2/CxReXKNOaXPLn6c3F7pXBnSpHwb5?=
 =?us-ascii?Q?sqqj2/vBJRV7f0R/Lz0MUGae2DD40IzwAtgJmJo4AcD/dIIrZJ8GTDsPj7ch?=
 =?us-ascii?Q?aL/mTHGembPUvGufqMieestTDcSWvN26wv6N3O/Vg6Pf0fvSNnEJFlJVRAWh?=
 =?us-ascii?Q?60jJTFNVCmzHf3fIJbRw6y42SP/m2w4djFeZZm5BKYFLKwN8/x6m2qbqvkgx?=
 =?us-ascii?Q?Jfsepw7ep5OJHPYnWMrSXK01S379ynOGK+rv7OlC7MZeMU0Pvu/TVP0PiSvo?=
 =?us-ascii?Q?K9S+AS9TO/VZTpSEedj8d1Vtta+l/6KcS+eFGwiXbJyoSzXB+s690HP6KZW5?=
 =?us-ascii?Q?YQgdcX2bHwsFsj0TZvWWKfZL7BXEDw+WIYHYJUhXND9hx1IbxyGoJepXw+BN?=
 =?us-ascii?Q?cYISkzYbHytFOcdGI7cmCaTGp4GJY0XSOzQ+ALxTF1SdoiE+7nkymr4WtY96?=
 =?us-ascii?Q?/pw0Tn4kkO9SMoENQvTHgPnF3Nfj94hC3kia9bZP/50aXrqmrWYc+WL1PErE?=
 =?us-ascii?Q?DmEsZ1ILRp+l2Uz82TfU0YFCHkPwUaN3DRr2DHJlAi9Z/GC3hiAzNoArHjGH?=
 =?us-ascii?Q?cIGs3ba/6lhms0B3c6y0S2aIre64utqWuPOIEN+S0Hc8C1J0f9LpUJja6xar?=
 =?us-ascii?Q?7WZhPTJOzm3gLpyZbxGDP3rSIm3/pvlmEeK46EmtZBfWF0vK/By3o8FOo237?=
 =?us-ascii?Q?fq4TXz6PDJwIvtfkOUPAKvXSnvyzIVTxLPOL3anTNkowhSJCcej2tqt9liN/?=
 =?us-ascii?Q?TCVjq8kQWLrhzB7jBhMibUrnWOfhtz9j8OV6tMy17DHvDdVpjJpFfHSotHP4?=
 =?us-ascii?Q?fijiSUbv6Ffq3BeW4PVoQF9jT2IHZ/MMBa2AZq2mzSS8JJU8p/TNmmB0KvcA?=
 =?us-ascii?Q?uL2jKOY5bqzlGqsZRG+4yKo+Tgvq11D9nH3adXKIM8rJxtWzFkoSx/q4/Pl0?=
 =?us-ascii?Q?dG3YISUBmfBjr8vxscfxIn3lSISCo/QXOH1Sw+RXhpzcRF50xwewduWRya+j?=
 =?us-ascii?Q?arDAlzCdRgNH4JnlDaVB7r+atZUnmHCeGwLWsYCUkip/e17cnDTFtVbSrIwv?=
 =?us-ascii?Q?fPGy5M3E+MCBUcOWYWX0eP8hxlyhpHc2X0jwbKer7+t5sG2iKvRCRrIXOarW?=
 =?us-ascii?Q?AlDWA4mh6wLb2mj3IwhXM6weUGyo/KaGVV/WpQG8HBVsgxCjI9UTe4oyTyda?=
 =?us-ascii?Q?hQ1SUvfKtTj4dSC0lS1cW+2PXG7dTGdBF8TJV9UzvhmyTPioaSi7r3DdQdd5?=
 =?us-ascii?Q?LA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 427f2649-cb9e-4e7e-80eb-08dab3b3d9de
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2022 22:30:26.3508
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IA481ib4F70tWgXcda0KQ5+62Vvjsxkxt+oP9ftpcUf4jyUS4yddoB2Tdh7tOWIc/K4pM8cvM8BaiA+/X+fFmCpFZVjJgFNcY66omGFH9js=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5213
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 mlxscore=0
 spamscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210210131
X-Proofpoint-GUID: MQXTeX30xHGehtaEUzzAQNh7Ep3guLhB
X-Proofpoint-ORIG-GUID: MQXTeX30xHGehtaEUzzAQNh7Ep3guLhB
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Having established that we can reduce the minimum log size computation
for filesystems with parent pointers or any newer feature, we should
also drop the compat minlogsize code that we added when we reduced the
transaction reservation size for rmap and reflink.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_log_rlimit.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_log_rlimit.c b/fs/xfs/libxfs/xfs_log_rlimit.c
index e5c606fb7a6a..74821c7fd0cc 100644
--- a/fs/xfs/libxfs/xfs_log_rlimit.c
+++ b/fs/xfs/libxfs/xfs_log_rlimit.c
@@ -91,6 +91,16 @@ xfs_log_calc_trans_resv_for_minlogblocks(
 {
 	unsigned int		rmap_maxlevels = mp->m_rmap_maxlevels;
 
+	/*
+	 * Starting with the parent pointer feature, every new fs feature
+	 * drops the oversized minimum log size computation introduced by the
+	 * original reflink code.
+	 */
+	if (xfs_has_parent_or_newer_feature(mp)) {
+		xfs_trans_resv_calc(mp, resv);
+		return;
+	}
+
 	/*
 	 * In the early days of rmap+reflink, we always set the rmap maxlevels
 	 * to 9 even if the AG was small enough that it would never grow to
-- 
2.25.1

