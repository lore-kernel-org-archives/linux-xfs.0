Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 202F3C54EE9
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Sep 2022 12:49:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbiITMt0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Sep 2022 08:49:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbiITMtZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Sep 2022 08:49:25 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8430D6AA3E
        for <linux-xfs@vger.kernel.org>; Tue, 20 Sep 2022 05:49:24 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28KAPJmN006020;
        Tue, 20 Sep 2022 12:49:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=PtZk6Md02YUGihWflXrBBk2bAh22V1q3skAQPVFhO4I=;
 b=NZzXVldeb4R9hxxir/xaIbQ3LH719Vl9dyezA3nFtBgC0CTUDb2aq1x1NZx/ft06037X
 ctAxz22EFu7FIBsnXI5sYeD1kpMBgF3KjOtLlXBm0vVcFRPodWoQvTFvd3CVx8ErGK02
 1AppA4ohsa45ly+qxOiZVy7+w796PpJWgMLV1RiATBQG4Pf4S9tw2Fslc5ESSMzMdjwL
 t7ea1gZd7+HSc65WsAU4TP9eoVsx2GMblCmSWsELfS8UN0OS+149OeB5x3j5/X4snxfR
 qKp9+om5sP6grxGbKwt9mjA9eKPpbRPPk6SkSjCqTPZIKz2+hAiQdAwpML9ufnnObV2X jA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn69kpt7j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Sep 2022 12:49:18 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28KAroNO035750;
        Tue, 20 Sep 2022 12:49:17 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jp3d29qrv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Sep 2022 12:49:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G+ombbw2yBGkA/r/Mcu/TkjALuzuVGbGrQmuWsewSw2eoY116t0HgdMmvNSfZvGiUQS5FW2P+459cemaSIilTHb0QSYcV5YOL5386DU9VMe4zle7F0zMP+6hhEAqXv4QOsqtaC/ydJB1X3l4d93/5q5oKcJDHi9epuL3ZpfVYNy8Z8C7VGhkCHFidQJrZJHsPdC7dVDVo+rXTdqOZgzTMvRnD8Xfq5PotgPR9EtORpRSHJYG6eqw8mOUGSPMl7kmWDoiEl72aTCiVWWC0QIL/OXKzNuDOSsoj/0DYQ3wnOYmBykjdKpbkQBudH6P6F0UKAV+yPXRdeYoY3a+/2moIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PtZk6Md02YUGihWflXrBBk2bAh22V1q3skAQPVFhO4I=;
 b=K0gXp4/+f2vLJFFywxg9HrrfTtkobkqNPzAxhTkYVhjyFA09GlHiVOCssh85YRs+sqTrLIfdHQueChzAy9kn3dEWCKZP1EAXcG3FYaZ/cnAl0bH+9GG6jwQdZ9D5DuSv95nIqGwziQ8axu43NJYFOWRS3iegEhZgZCsmUc6DrSd5zqVO8uolxdjSg5zvsAxaBMOOPjqwcuI6luaIhjSNJL0o4WwmFwSgO45j3cTfcXfxt+TWN3eoavZXB0+I/kjq8ZYAR+adhujwgok+7qMdetK3UZtxivd779PHGIK5wr9SrJA9471jfWH203OWPTyrb4uSIlAmAdwEey1+xbI8yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PtZk6Md02YUGihWflXrBBk2bAh22V1q3skAQPVFhO4I=;
 b=GaIOGi2o7SoLqS7Y8u7WK+VV930yeMmN+9PQ4K414JT0/mrDnwyrZjbiaHK1+9L57ryag2L4YYbR7TnAWZJ4BOKbAjZIMCuVB1LkB3SFzLoFHBAzlhbEamdFn6eByCPniatq9zmhiy+3qEN7WGu2xCKug70aa7QUlirXhvdhE6M=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CH0PR10MB4987.namprd10.prod.outlook.com (2603:10b6:610:c1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.21; Tue, 20 Sep
 2022 12:49:15 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%7]) with mapi id 15.20.5654.014; Tue, 20 Sep 2022
 12:49:15 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE V2 05/17] xfs: add missing assert in xfs_fsmap_owner_from_rmap
Date:   Tue, 20 Sep 2022 18:18:24 +0530
Message-Id: <20220920124836.1914918-6-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220920124836.1914918-1-chandan.babu@oracle.com>
References: <20220920124836.1914918-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0117.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:29c::15) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CH0PR10MB4987:EE_
X-MS-Office365-Filtering-Correlation-Id: 02525e42-fd61-471d-a7d1-08da9b068674
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vMYxXxdovbU/xqpK+E5WkE1rgTT99VrqqErEkgfiuNJQCG23BK0Rhog016g3icsdcLBx9oIBL00fJMMdqz4RWMpTRRM3ZtfeP+gnDySS0rYkAhCUF+oSgWt+G/TuvCLW01Ycd/SRkwXcInY9pXELWVy5gT5OsZNgE4xsRWM0IuysoKeRU/+i7ODDGcskXdn9LX6yB1v66nSlB9lEXz8esyMWyX8nHhb546s+RFI/t1Eq/dqvX5AKCDM+KbYXQEsvwPJhS17hpb9Unt3UZ3wmGqKNJHwh+FlhiCETHuwlgD1JL/3AhL9heV3yYXGbuYS3dNSW++JBKRzP8+gUmozgjSbSXoAsj+/hZXdqzkV5TfMgTSWH7BA78tefkpRtrZigmxxWi/acwSjMWryMTvZ0FKD3AQ87CmP2zOLUwqrnQEC06BpN2+InBFSLl0ISC2fv1QctoCG/JrL1ygV6ON/xmBV63vAbd4e64nMnZ7xjojZuTOYyDSKuH8w0r7LpAi5jnzHvDmeJRPsmGWphiz+wAKiBCnEklozzWGZ0VkWZnCBdYSHCXuNg0D7Sguyvs9xXEZ6vuD18CDW8uO6Bw2I0ehAt9rijXRvy3xDE6DG6+IGC1sAjxqVRvM8DeiVtAmLqyPSgbjE7MCHn2R6bF71Mm9UPvyLA1RzCWg5SmIf1McSyZ5hbif78RZWuQhOeZwoqNv3VXi/6mxVbkgrdGRuJXA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(136003)(376002)(366004)(396003)(451199015)(66476007)(66556008)(66946007)(5660300002)(4326008)(86362001)(8936002)(6916009)(316002)(38100700002)(8676002)(41300700001)(6666004)(6506007)(6486002)(2616005)(478600001)(186003)(1076003)(6512007)(26005)(36756003)(4744005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?t3IXwJINPKSIeRSS42MjkLhURD1Jw8v1NEPbgIQvFsKCfmz/0DvfJ7/f8/QP?=
 =?us-ascii?Q?YMzlVAasiylFkyq/BUzB/ggZAEPZ+vQ9kcz/6oBesWfkVIfZVmbN0t6CqhPX?=
 =?us-ascii?Q?A9lyZNgzHqBnwB3Iu5ICJvjbrGFiOdyj40qK6IgH+h/yS/Ae5SQUiHtf/pmL?=
 =?us-ascii?Q?iycSmBVSXrPMwKpnQMWp3vpPioFLNoIattK0MHR1azhgx26rwRZfUOBXaXMh?=
 =?us-ascii?Q?OG/cvTZKIRk6VYvn7PhYWEoYzV+yCDkmCw/Gk2R/IkKQTwbRhpf+E7yPv3+Z?=
 =?us-ascii?Q?OPBjWjvo0kUNtyF+goB/ZwA2ZMVT0T8VInbA+rOx+iwxcDsQ4tO9Gp1K91ZK?=
 =?us-ascii?Q?ZZE4TgILxKCCjg/9IEdoAaNguVboDjZMixHpHcM9pXjZYw5fz9IzinFP8o9l?=
 =?us-ascii?Q?xKejqW1fffRWJ5oB+JToScfx55pHU5g69cHDZ+tPXWRTXG1cvu4vcHSTywvI?=
 =?us-ascii?Q?acp0B2Fyqh+nn22MixHlBV8HAywG1cmMQKz2eie+TaBiMVO1490195WgVEk+?=
 =?us-ascii?Q?/RZnHOHWuxA+NnnN24oCdtHIa99o788jeAACHOTxq+s+2lqq0pUU8kDsBS0G?=
 =?us-ascii?Q?3xszWX1z2vnHJLVziwo9XqWN9pj5YpgV6GuUlLMlApvPuQmRmntN3Sk1gYt2?=
 =?us-ascii?Q?nylwAISGss1PBTPEhisNh4iWIOFG0IkWwY3aHig2vWVWBGmIPDy6Lg5vCOTH?=
 =?us-ascii?Q?Gr2CDJbQPUUe5QHyqJbmamP7PKIm9IZfLgdR0nk7l4/yQ2iSEjtj5+NDMCIK?=
 =?us-ascii?Q?0eTN8IfxbtcQ5SVeCeRH/9gWAvAvA7wBmijKAADi7yDaqY9T5TqKv1v+FQoR?=
 =?us-ascii?Q?xABkaYJ/8NiQxFUBZJDrLoK7RjDQKP0/iPBI8dhw4taME5CT8mGAzHTNz6A0?=
 =?us-ascii?Q?L2QS6ZWT8kUrUmzdHflc8Z/OFpC7oXYvmXmbakcZH2qvXSxNGFx5gC3eRNvF?=
 =?us-ascii?Q?ggkjtkTQbXtD5RXVrx81kmGSzDJ3y/rBiNaudGOAwds+MP5ZCVa0ojdTyRYO?=
 =?us-ascii?Q?NxJsHE76R7DwTpiC+iyaKdxQcL8HWSLbMEhe/1SU7SxDbHpbrzx0qkOOhLGV?=
 =?us-ascii?Q?Ajmwk/ncsAy9f5oxPnisQHEsNTazKo1dVduSYCeggAj2jgZ8ObZDLB8bl0h0?=
 =?us-ascii?Q?PwW3x02Pzg8KGOyK8cMB+HLSAKtTNEeQJgGo6M4AfYPW5+1a3fnlA8coxZLq?=
 =?us-ascii?Q?Twmlc+cYhI1B0SIlFEOb2oljkSKv+KHPgFBoRyvY7SvEUXybFIvHuj4tf5tC?=
 =?us-ascii?Q?Ure8GeCQdVL/eCjTksaYygZ8uPvymFC1Z8vspoZw2iwz+ZIQcXd/Uu8ecRou?=
 =?us-ascii?Q?tf/+3ZXWh/eis8RFR5WVCCHaYj1eN/yLlBMvFyLSiKRDD/xq+fYJ5TPlSolu?=
 =?us-ascii?Q?TvbaC5RqCxuY3XYkujEoCKxDPrZkUWfc+2hX2SGzc7nVEI59AHnfIepnWDeg?=
 =?us-ascii?Q?i8cS7XbuhZJPUr8yADuVOHge0Q8Dbxm2l9cXc8TBQ/tDMTBM/mBqKdb4CwFq?=
 =?us-ascii?Q?lwo/pXybcZFUnjGZmru1WRWS32HXiaeZz6CHZ0uAwIWXfytnFD9GqvkVdf3D?=
 =?us-ascii?Q?e+w6Y6S2HUB8DR3DsPSlZkWGHZNXEE6TzaX2xFOB?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02525e42-fd61-471d-a7d1-08da9b068674
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2022 12:49:15.5028
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IxFidsF4M/cTmMrJQjRjkYm6o/YfZpS7QW76plddqDV+07Yr9WrVkj6vdxenJG1Z/h6vuuZhRuldR8tCohK4NA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4987
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-20_04,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 bulkscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209200076
X-Proofpoint-ORIG-GUID: 748tcnh3X6qSwmwmLePTvjWL8otQH8fH
X-Proofpoint-GUID: 748tcnh3X6qSwmwmLePTvjWL8otQH8fH
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 110f09cb705af8c53f2a457baf771d2935ed62d4 upstream.

The fsmap handler shouldn't fail silently if the rmap code ever feeds it
a special owner number that isn't known to the fsmap handler.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_fsmap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 01c0933a4d10..79e8af8f4669 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -146,6 +146,7 @@ xfs_fsmap_owner_from_rmap(
 		dest->fmr_owner = XFS_FMR_OWN_FREE;
 		break;
 	default:
+		ASSERT(0);
 		return -EFSCORRUPTED;
 	}
 	return 0;
-- 
2.35.1

