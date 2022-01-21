Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F50BC433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jan 2022 05:19:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbiAUFTn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jan 2022 00:19:43 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:41182 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231447AbiAUFTm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jan 2022 00:19:42 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20L04F66016439;
        Fri, 21 Jan 2022 05:19:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=2e4letPu/8X48bk2LnFYZ85vi0veWBapY+gWpBAvNIU=;
 b=UVKFUdBZJLNmc3V9tUPaFxoEBZ4WgUlIB+IhQNEd7FQq/VO4/XkpZJGh/P9kLo+VcCcH
 WOFLvur3t438mkBHpSDbA688AswI+at5fgn+4wqkqPK/rqIKimL67pl//B+zTjvMa5l0
 OT9HrG1aBbMfAMPCkroeaGd+yl5f50IB5BHATjx1YyyzKyKu+B015DykmIt03X5HAKDN
 3CR4Wh/WZcL1WU7/P0kxOkRbhku5HhjWlGt/byL3B2UWQSu6P/Emphe1LaiM4IfyauC1
 NJ87Y3g68n1VCgfRx3zgltXuheAY7pPWT3j2caOwoNOxhmP+xbfwq35Ax94vL1/O+82z zA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dqhydrc6r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:19:40 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20L5H10N018873;
        Fri, 21 Jan 2022 05:19:39 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by aserp3030.oracle.com with ESMTP id 3dqj05h2tn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:19:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BwF6WVSvudg3tH+iLsYApV5Vhbgvr8bye6vqB7KAJuP5q2gIkzLQQUS2kWtxtn4UQKq4wFvBq78YnM7m2lyPFUXC/N3oqTzmpq0+YKS1BBpp94duQvdIeigoJ1jNWNOM4K+28nBjPZRBK1jSUL0zwLDnmPPj//Frf5ELCXwVrZUgF7xdtywtuiMNUg4MdyMzwaQh8Z6g/wBYAJ+p9E5Nk1Rohqk6iZj6j23dLt8Slxlat4WQpqgHuX7BtDzIqwYdH5gBsvnILoI91DyBU/vwI+JuFuQ5ROS+0dfIQkpPnjLb1ouHIZTbMorsGQL8V18xotRTDOenwAWmhPXtQSws5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2e4letPu/8X48bk2LnFYZ85vi0veWBapY+gWpBAvNIU=;
 b=mBZWjyInkEGPPLb443l3MgNV+/OvdDfXJBKwxqjAclWCdCc7dcQavgOhVEZiJ7Pgw/x6ITXrpWTIELsnIVeeZDZ5U5IaXk1VvirpCl5kRG5o5MR5Dhw9iWcLH44AxXy5o5/4nZv7j3t5X1Sm5J+Yh/qSo5N4LFhyIASL/2McKMeNFbGPID9MH8Wd5QoDQeNMsYM9A2j4XHZQS97PCfyxn0g/CbCu8BKb+ciTP88DV3S7zVcq/p6MfWB959bp+Rc8Sa4kGUfqD05wzHE6Ah23CR7h4bj7IxrNmBIFUbCQaRZr8Y5IeI4MrSS7shaL6Zr96HAh52Od26EU7inQSeG/Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2e4letPu/8X48bk2LnFYZ85vi0veWBapY+gWpBAvNIU=;
 b=x6YZhMJU+b0zboOJymWI5lwcHF5GhplYBOrRBFE9HsB7v4pZ2kmTcn38afrXOqh/4gE6ajDvEnMt2fBnS0ns9jlzKN736Tt3NJR9AWwufMHHshmR5W8Wf29fNPZJq6YhNKYARU3Jfuv5kwgAkzaKFrTdXa6edSZ7dfttW2ozsug=
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com (2603:10b6:a03:2d0::16)
 by BN6PR10MB1236.namprd10.prod.outlook.com (2603:10b6:405:11::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8; Fri, 21 Jan
 2022 05:19:37 +0000
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b]) by SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b%3]) with mapi id 15.20.4909.011; Fri, 21 Jan 2022
 05:19:37 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V5 05/16] xfs: Use basic types to define xfs_log_dinode's di_nextents and di_anextents
Date:   Fri, 21 Jan 2022 10:48:46 +0530
Message-Id: <20220121051857.221105-6-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220121051857.221105-1-chandan.babu@oracle.com>
References: <20220121051857.221105-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0027.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::22) To SJ0PR10MB4589.namprd10.prod.outlook.com
 (2603:10b6:a03:2d0::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6f505fff-0e34-4ff1-d87a-08d9dc9d9e21
X-MS-TrafficTypeDiagnostic: BN6PR10MB1236:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB12364DD923F7AC41E38E4676F65B9@BN6PR10MB1236.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:428;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z7fsyvkpqOKH4uLzscm+mkgZ3aw2tpPtUmepTC94zSwi5RMoZNP1E0+lqAcPxXijKTIZz3LLV+qDAsYMVv5tMwaAYsZI291bpL1jMPpr8q4cyq22kovKknE3wniHGrgpiX+5m/pQ2DSqc79whP4PW9Xh73rmDZewbwJ8/FopOvzn4QRyvczESG6PmDKO3V2mt1Q704JcuyRklWglA35qWq5T/xShZiv+XT/Eh2uxJ+hXtXSmS5dr68iO47pEq8KtrSBD+uR80wFTNPI85FQQa/5yIV26TaaUbzGCOdWxCTPLAjlKAcWEGMXLracFVZBxSpC1KH76c2HokIJcEXKUGtYbGKNjHseDkgeca/2SSYLzbsXSId6diRUxKU8OMAWdmuqAIvU2qwDzYZmIN09uuyZm/mCdJoutxOttlD/5XcgjoQrVwPu2+csnwIaoVYi9HBrN4xtobOsAQo7cgqZLje/RE7p5AF2KGA5N640Degus0hRv1OaGjhjJOowRkiHf4WXCXpXbYWHQx2fs8kGM9vomL1tWpHIRLZR46ptpXPXUYfzljsSE+55a0gUrfPpZ5R+wG9Mi2EwFFesOGJdlZCgt8LWG87tr0qkmCcoO+jd0nw+ID584Pi/3OejxVPU4FeeaKzl5mmqq6em1UnZVgIoCTEzz07EOoO0uuhXNbVuXNAkxT4Jj1jJnhihbh+wHg+WXfOaOAKK6qkGqyl41aA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4589.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6916009)(2616005)(6506007)(186003)(508600001)(36756003)(26005)(83380400001)(6486002)(52116002)(38350700002)(6666004)(38100700002)(86362001)(2906002)(66946007)(66556008)(66476007)(8936002)(316002)(6512007)(1076003)(4326008)(5660300002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GNPm8QyVwkZncf4ZAgGmNN5gawWwud7KD+DlI923f+639F8VYoaICjTC7HfV?=
 =?us-ascii?Q?JQvPr3YGyJeyzmnIvVBy0B+DC5lC9XzLlEXn7Xa4ipAOWnnIhi5K+1Fiv6wf?=
 =?us-ascii?Q?5oK15HV5RJC1MOBf9n47ubQXP6XlS1e/rmbhTbi1EbvNDWMOQOSF8LkYIiYv?=
 =?us-ascii?Q?gBYJMtXZjxcZX4ETC+4ViU9XrlSo0s0ZWzCFTRcyYE9Ump4S0rQHk7b+2neH?=
 =?us-ascii?Q?g5DePo0w0zMBEIaKnF2m2CCvns25EnL8q1WQXlj8a37FGFVn0xfYE8jbEZ/M?=
 =?us-ascii?Q?5hRlHDgAFnzb/bLF4U2kANo6olVlc4y2eSUlJueds1dL1j9yzss30T7VQTNA?=
 =?us-ascii?Q?6/R1ZIg/ro7avdygFFyUvXlIefF8Wt79/yqhML64FMqWWss3rbTOAGId3s1z?=
 =?us-ascii?Q?uGOLv4mIE6CJTLrEFLie0DttPgag5JIKOpYz1Ey5spBS89YbfhHd6tw4gBCD?=
 =?us-ascii?Q?XzzpH7twKvCj82nSSEVQxMbVtwWPipYe3zqCSOsaWZcnC3dCdHhyul0vfhny?=
 =?us-ascii?Q?t59JHkc1Mz+8YA6Vgz4r6bWRwMLlaEfSY8Yrg1K6MwbCwwQPNoZCVqJhtsoN?=
 =?us-ascii?Q?v/94bFem4zCHNe7vpsTFRqMN1TYV48v3zLHwaHBLRfSg0c72kb8OMdrz4TV+?=
 =?us-ascii?Q?3pTgbAYiTHF1lBff3hU/Ivo/CkKB4V1q0sUpPB2kAza4wox1EmUdTyS1qtcc?=
 =?us-ascii?Q?+4ynG3T6eZHp3GTdQ46YfjL5OjKIjdIj2W7eGYnv1wCqFMSL7Q+qjtp3B4ar?=
 =?us-ascii?Q?Ft87vuweJYcRiZge1tRdg7cqMJe7LhKDHLpjXkvt7XQO374rspzHf2qeadfS?=
 =?us-ascii?Q?kHOJwexYptEG67Ho9wbrNa+mlPh7CGD7GsR5wpGaVADDkLEy6pcfbkXVewaY?=
 =?us-ascii?Q?zfzatmLds60r4ages1qo6B9Cll3kWj74NIj1ua3IccHlqcVRWud7cxp5wD2U?=
 =?us-ascii?Q?00uZ9T+SFqkDJgB80U6Z2hzUYMkrMYSdwZ1GYlpRQU8Oof8rIptjYqMhvI92?=
 =?us-ascii?Q?BlLcLvH3l88BVK4mq/1degt9ur9jXTDQQvLteRnLkIqsHhgAMK4bc/0+bpK+?=
 =?us-ascii?Q?rs6M7Tj2AmXyKLtY5A6Y6qJmCjVQD9gdggqPuUDCRvHyjHUfMPfYEw6vqXas?=
 =?us-ascii?Q?qE08Wkjj4hJXCoO5C32qfSKVvGpw7ev6mGbkG2GyCmyqR2YZESrCrAaBsPoL?=
 =?us-ascii?Q?autx7lJqj9pLtFzDn/z/ue22Qe4ee7hLoGFSxmNBaEVldDzHw+aSj6tNvGPj?=
 =?us-ascii?Q?jGLFfNXwF9HVVUFT5IjhCPXfwFGEmvXequc8ho7yMatAgvx1fFc5HJJkfVBu?=
 =?us-ascii?Q?swFYGwGZQnap7UlhKt2orkJHZ2GxQRQBAXwJuFQeL+D4Fx+hQMWTJwlkCHnr?=
 =?us-ascii?Q?c8NpPiI47TDWUEPSq7VQXFcrn9ve1MmB1T0V8IKuFwDiNR/rP5qoEwtk8g8i?=
 =?us-ascii?Q?buBHaSA64KNp8kw1/RJIXapWSCpK+5eIZwzAdIVIWJZxOx/FwWnnRYABh2a0?=
 =?us-ascii?Q?o7aXCTl24y74TIXm8Qdz15SAywL7hfipde5CXBNafqvrpCI1BHYWEXC5HDap?=
 =?us-ascii?Q?9aXVuXijC5dx4fPunFgwEPr9+3TAaXmpYHmJw6Y9xduAzd0j5NNF6GnEV1FW?=
 =?us-ascii?Q?GP9vE6pFk5zQQYJnxjL5+iU=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f505fff-0e34-4ff1-d87a-08d9dc9d9e21
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4589.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2022 05:19:37.2973
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2ZGVImhiectnI3xSYCiaOme2IxezRPmTJZyk0Ec9ssTi1t7HgF/mTDRgTI0C2TZGSyNE9EH32vsUCqNGX3w4Jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1236
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10233 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 suspectscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201210037
X-Proofpoint-GUID: sJCa67fewFqFcodHdx8RFByLnJau-PTo
X-Proofpoint-ORIG-GUID: sJCa67fewFqFcodHdx8RFByLnJau-PTo
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

