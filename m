Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D705CC4320A
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:19:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6D1561108
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:19:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235550AbhG0GT6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 02:19:58 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:49084 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235041AbhG0GTt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 02:19:49 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R6HkJ0023079
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=gn1M8AqWsHvy+9oWTouqTbCJtSesijYbIkjXp9ijIyU=;
 b=LofR6UgXzOzO/xuWLNd/g6JiEhYS0WjTrLcGLlp2634mNk4ULbn0oXVYIvfL5qErR8Nw
 LzeKM8Pvyc1CyOJHhq7DAMJ92k6+FbQULZnj9MU9CXrrffk2ZdRRzE9Z+KI0XXs4+3Tn
 FZZ1Jz8xo6F2hlzZbhU/YTA7L830DJc/CPtBTZvHnQreLgJDd9prNuYr7sEmBgDTFU0r
 ht44Hbahzlos3CjpFPFrE/RRrQJgCaZosCF+/ppdCUBmyoHKedkK5MDXAwKcGd6NiBij
 5qrazKYIvWgPXQ57al/NYnTNm/E6Fz5X2qjiCRjYpFCvr8slmxH6q8pKZ861L8g4VXO3 TQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=gn1M8AqWsHvy+9oWTouqTbCJtSesijYbIkjXp9ijIyU=;
 b=rA01rKZABjBbUm6Q8InGE0sLX5Og3VvgSfMvh1oB1k3wdP9EUT5eg5FK/aJG7mI6vKCE
 6tlSkj6euPAlxDHUmZZxq5YRZLGu+hrV1BklFdNt/nu4ghKPwQyi6wTkoSa7QhYcd1kJ
 RvggOcTQfZiPDJOC8+xjvj4E38CUeklOhftYDW7o8GsVYQwURQJZeVaOtLtyd7MPaaCH
 rXo18MRRPP1x9r7ze9Vbj/iO4o0kI9a9855YmWQrATJ9Ne92eYG5WupE+mXg20/zpR56
 j/Zsrkq/GxijGOnTyTU6dthssQ/O4mixcXkcIwDhJaM5z7HdkDgoMkN/SdcLAbKvTIZf iQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a23538uw9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:48 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16R6FjJ6114851
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:48 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by aserp3030.oracle.com with ESMTP id 3a2349tqqb-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aUAHQa2rRqXIPlIhU3/IrT6HjVCd12v+x3wQHTPOwKTz3ql/TqU+G5IX9xBrZpGAP+ahjZrRxWjlRvsggZXiT/FaRrusFq/0SzmFBiZ8T6WEPcfeH4sTfM630t06AqTThPcsitxRXqqMmx7/E/xV0BFkvrVMRCNAdAt/m1G08rgZbX7heoxYrAveL5t8ZmRrlei+9R+7EVwuJk33vm2eDCulRH22ibc+6ld/tz2fd3CSceiozKAlwa2XTfMW9vDwQwVap6TpzEN3CniIvBwzZaJfS8BEkKjy2KnBYJn5l9PGyLX0CC4TSqEe0pDMXvbjdEYwfiACVulWQGr9CqZagw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gn1M8AqWsHvy+9oWTouqTbCJtSesijYbIkjXp9ijIyU=;
 b=W62iK6QRP3pk7tmoA6ghYLMIRpBim+Tl4YyyWGevwNbyO3ddLkYilBt7C5iA5UYU/Epg2CC22WHRTcbodc1RBifVnCM2/lldKtZOMm/cQtI8XyDLtGgce0pv+ono72VX/903RUe/8Ni3wrcIs4a+mIYRZ5X+7c23jgiEkwo+0O0bKGBYDGrWr40E952lHCzeeam946qpuqWkhIo6mFeZm8AT9f1nJhDbpwbbuSWq6uuh18aPlgN62YIGRAc//NhipUPm9EPZaRg0VbFUVLxiqlrs9gujS6sjKgKUyQWL0Lm7uwRnxnaiGemqCM/+it6Ku4xI68x1TjOOmQxwADF3tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gn1M8AqWsHvy+9oWTouqTbCJtSesijYbIkjXp9ijIyU=;
 b=QRLQwrS5iWUTBzzu3NKiaxZ+MHpXS/km/nf98U9pkHYuM3lFuOZAw04VfHFx+OojLv2olFdHLEcNM31rABt2+3Gqd0lyChAzoOn7KpsDAkAfUoCMwqbw9ignwQgtFVWhE2SgiOL+eLwCL0WoSZfh6eI1e2sx4ndrQ8FfK86MDhg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2709.namprd10.prod.outlook.com (2603:10b6:a02:b7::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Tue, 27 Jul
 2021 06:19:46 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 06:19:46 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v22 18/27] xfsprogs: Rename __xfs_attr_rmtval_remove
Date:   Mon, 26 Jul 2021 23:18:55 -0700
Message-Id: <20210727061904.11084-19-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210727061904.11084-1-allison.henderson@oracle.com>
References: <20210727061904.11084-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0074.namprd05.prod.outlook.com
 (2603:10b6:a03:332::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.112.125) by SJ0PR05CA0074.namprd05.prod.outlook.com (2603:10b6:a03:332::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend Transport; Tue, 27 Jul 2021 06:19:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b858a3b-d683-4ce6-316e-08d950c687b4
X-MS-TrafficTypeDiagnostic: BYAPR10MB2709:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2709A43AE63D9FF27A7AB3D695E99@BYAPR10MB2709.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4feT/IUAzUxqhRIQnYHu5yFldG09phBt7+o7YD3pOu92OOXCZr0P633KLZRQo0rlektH8HwDMXoY/e9l4CLENlSlDbEuDHn3KTyZfq7t4WV/ip8EKKHIgfPtqbki6DJPZloGCHMzR86xVA+whsnbnQ6Yotllsz7Q3ydr0k/Y/YWNxjPxvgR33p7EAt0dnhkVfoplL/K1wpZPej9naqJVOtfS/xRFQHVWlYot4c28VbjEaJ1LoMv2Tjr1rebEXbRSkpCmCnPomUHQkflgpuiYKFr2qz9V2cylMdL+whL/OESCL+benApnaW3laIfqwmKGDSvDKV5E5BAAK8w4eQPHSYD8Anxa4rQOBGGjhCoXuiMq7ruLwBCSxEb/uKgHotVXmbY3LqNAVmS9vfubLZN+3whw4Fl4HIe01ig0NcTor5Vcm+QzmPN6v465YOObvmscrq3yocmoYIJEl3DgmzcQdf4yRVe4MHPQy1M3AIMp5iWGZgSlyhvizdph0ahp2iS44iTUUE8CMpWhFGlS/kK6StFpHg8pB2EzCYxZ779P2QuOreXhBA1uRH79BYzEemwjOaoLStlXfKhJNJo+CRm1LLHd3VNmCcpSm6uJ54iYUhyaBKOC80pLDyNQkWZGrZawuTQfFMOXITbdMaPljMNRsmGWVGKEYtxmo7euWlF4Oc/v69MVZry4425jYkj8ZWjIn0PYQ00+pWANXj95Uj03yg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39860400002)(346002)(366004)(136003)(83380400001)(6486002)(2906002)(44832011)(6666004)(86362001)(6916009)(956004)(38100700002)(2616005)(36756003)(52116002)(38350700002)(478600001)(8936002)(186003)(8676002)(6506007)(5660300002)(66946007)(316002)(6512007)(26005)(1076003)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CpoHy+u2MRQrzaGmnWFyciD83Mhk0ab/jfDzApMiI+1Gx/RW69G3PNWn2dm8?=
 =?us-ascii?Q?TDyfQ0f2X82bAAme2Oxo/IqmkBbNJou7sgplRo1ueDhPkGhmnc004Bu1bv5h?=
 =?us-ascii?Q?eCcVf8KcphbMLkgbf9KLbESYQMtJazYxgpI+2jU4O6qv9pecGsmYfWncX22B?=
 =?us-ascii?Q?7IMnVTP4jZEzxfSl5OuUM5Zei080sz97HuDGR10JI8qLzOYbbpXozHlRTXtM?=
 =?us-ascii?Q?moUWXEAXuvPY+2bWp8nLfVmUYuEWqYjE/+38wqkZKhh3qRJtuoRTjKya39xH?=
 =?us-ascii?Q?eC4y5RYBE5fK9QLQ5cQGhIkuSJAjrwEyWmIPB5Y+BuUzsTiU9mkTkx7BLm1K?=
 =?us-ascii?Q?rD4f3CNDuJ6t0fLcVveb4+ooKsD7i/cPLzOjzRd48upDLfRI4TsDEuBD8oEK?=
 =?us-ascii?Q?mWhG8A8vKEV6PWwDKl8tiphlFXPzqB6m7ik+bmbJnwj9AK0pOEXPKEQzL5kz?=
 =?us-ascii?Q?IBoCrGWPBqHluHFcFYQmyOj04kiFTPvednomiJRtVzZQIU8vO7mJ/RhuB4YR?=
 =?us-ascii?Q?t6/O44b25BdCEZbZUZSZ8YorAfphxYIPFCRrP8Lex9Tar+M7vUdHovwbzXtX?=
 =?us-ascii?Q?t4zCmtzcDv6nPoXcKManIXB8n8agywdPjEQC/JmWCwIrUVxVyDaDAf6qASn5?=
 =?us-ascii?Q?iaFsfbWTzgvaBEPkeTDXFaCV/dL9GuRGuJ28COK5DR2+4rDKAvxSyNNSnaJG?=
 =?us-ascii?Q?tb/+wY6uSZMHdguiBBfj0sIh5FjfZ0E6Q66C8q1hP65/jnpGC/jgdkXOofe/?=
 =?us-ascii?Q?4qkQLeQku9DDAtoiyoZDlzP/hgtWAUFigv+IiRqyDlaLccRqh76Zq6BdAic/?=
 =?us-ascii?Q?O3eJtOCXrzr9i0suQp5axdoT1BQpz4lErs+xCPDVocUvxN+Jvj5yH3SUeI19?=
 =?us-ascii?Q?C12oFzGnfh5uHouXNCuhGM5DF+Cdwwa7TE8m/pvUs0pQP8vOuEpggYaDeyHD?=
 =?us-ascii?Q?SYVDaJ0UbGQQqeqSp+dX61USabys/yAQ4HnWNAR+pXoW+GGGoS8gRhHcPLQu?=
 =?us-ascii?Q?oqrWwjqHTSXq4U5BR3y9R4G4UnawjvLVI9JCJ5e0i6XllGuzdCDTJCltfeIT?=
 =?us-ascii?Q?ttctbezgZ5Y7KUVdBivnVNtsGaB4HA/Dlr27e0HRatBHkbaZj+kIVUeTNhlC?=
 =?us-ascii?Q?QBYsvJMri3fBIdP0g2KWkGe0EJ6yV1QNXX/gSIQ/oNup/cwtsKpl6MrqFAkl?=
 =?us-ascii?Q?QIgzaT5d/1DTrouW6wii0iWA/V2y6iiPy+mtlMpNDVOUXWApchNqzTbE1II5?=
 =?us-ascii?Q?Juhn3bb3Ix00kv0eKSIJg2sNBHWg9W+9WAI5ChhPndqLDVH8Z3uciiK8mNj4?=
 =?us-ascii?Q?Zf2e5j+I8WyLuzdkNRxzcEat?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b858a3b-d683-4ce6-316e-08d950c687b4
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 06:19:46.2057
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1E2kL3TQRiH+Kp08C3RU5IDtWLHgtmabID+MJq1CJiJwrACN3zx5e9WdGqkhxIp8cCxr56TBOc2GaJP7BJfoOABOKJw2Jv1pXhuhoTIMDzo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2709
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107270037
X-Proofpoint-GUID: 2VAeR2lbb7pSrAPgR1n8jNdWhM54r20a
X-Proofpoint-ORIG-GUID: 2VAeR2lbb7pSrAPgR1n8jNdWhM54r20a
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Now that xfs_attr_rmtval_remove is gone, rename __xfs_attr_rmtval_remove
to xfs_attr_rmtval_remove

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_attr.c        | 6 +++---
 libxfs/xfs_attr_remote.c | 2 +-
 libxfs/xfs_attr_remote.h | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 6380cae..f2db0d5 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -502,7 +502,7 @@ xfs_attr_set_iter(
 		/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
 		dac->dela_state = XFS_DAS_RM_LBLK;
 		if (args->rmtblkno) {
-			error = __xfs_attr_rmtval_remove(dac);
+			error = xfs_attr_rmtval_remove(dac);
 			if (error == -EAGAIN)
 				trace_xfs_attr_set_iter_return(
 					dac->dela_state, args->dp);
@@ -615,7 +615,7 @@ xfs_attr_set_iter(
 		/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
 		dac->dela_state = XFS_DAS_RM_NBLK;
 		if (args->rmtblkno) {
-			error = __xfs_attr_rmtval_remove(dac);
+			error = xfs_attr_rmtval_remove(dac);
 			if (error == -EAGAIN)
 				trace_xfs_attr_set_iter_return(
 					dac->dela_state, args->dp);
@@ -1447,7 +1447,7 @@ xfs_attr_remove_iter(
 			 * May return -EAGAIN. Roll and repeat until all remote
 			 * blocks are removed.
 			 */
-			error = __xfs_attr_rmtval_remove(dac);
+			error = xfs_attr_rmtval_remove(dac);
 			if (error == -EAGAIN) {
 				trace_xfs_attr_remove_iter_return(
 						dac->dela_state, args->dp);
diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index 137e569..b781e44 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -671,7 +671,7 @@ xfs_attr_rmtval_invalidate(
  * routine until it returns something other than -EAGAIN.
  */
 int
-__xfs_attr_rmtval_remove(
+xfs_attr_rmtval_remove(
 	struct xfs_delattr_context	*dac)
 {
 	struct xfs_da_args		*args = dac->da_args;
diff --git a/libxfs/xfs_attr_remote.h b/libxfs/xfs_attr_remote.h
index 61b85b9..d72eff3 100644
--- a/libxfs/xfs_attr_remote.h
+++ b/libxfs/xfs_attr_remote.h
@@ -12,7 +12,7 @@ int xfs_attr_rmtval_get(struct xfs_da_args *args);
 int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
 		xfs_buf_flags_t incore_flags);
 int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
-int __xfs_attr_rmtval_remove(struct xfs_delattr_context *dac);
+int xfs_attr_rmtval_remove(struct xfs_delattr_context *dac);
 int xfs_attr_rmt_find_hole(struct xfs_da_args *args);
 int xfs_attr_rmtval_set_value(struct xfs_da_args *args);
 int xfs_attr_rmtval_set_blk(struct xfs_delattr_context *dac);
-- 
2.7.4

