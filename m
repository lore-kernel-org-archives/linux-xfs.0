Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A204C4332F
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Dec 2022 10:03:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbiLRKDV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 18 Dec 2022 05:03:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbiLRKDR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Dec 2022 05:03:17 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A35665E4
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 02:03:13 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BI5RW4w005645
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=p+Mj2o48KZIU06tjOsGJKlU3MX9+qMBJYtvtML+DC1k=;
 b=Mk6/e9WWSa8D4Rm7mJF2exnh4tyfMKrl2jwtW/w2zkmbognyBELfZq8GARBpLQOwZNP8
 4v8MAKDuof9lW95mh2xcUr5PNxE2JKC+Cp2RtkW8xrFX8+JTLkPbP8/Wi4DEsztTq1UN
 4OQJATTV89UUuyuGn8xzNjqTJg9HdDsIiXYei7/x3JQwunfJoyz0OgA2h9ndwuAaxnok
 wOtx7ULEHouJgrhyKHNfZWkz5w6k4YtCHqekwvEwK6HxVRcM/pSUsFG2XUKugjt1XBGc
 HHCMnek2doaCCkw6VtjX3yNTg8FkNOSqfpgvo5eRIF0kFoWUTG2Kpre+QuwEkSDgaK8G QA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mh6tph91u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:13 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BI7axvR007083
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:11 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mh479cbhv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J4L4ciukJRLqKU8PgXERSzDUGFLNvN4ZD5yx85Jqgg2KEAMppnlZp+5GG2jhgbGDFzSQiJ3vdp0C+MUQIx3AtdZHMKXMuith8rtTn/NNL6bPZ09feeElpNmVqPmV+aysMmqvgnG5B0JKel9g0OxWei7zVuXXDS/wkFP/B7i2B7fPFRRyfr6tjcrQoik9oeVl8lvhahOJ+VYTyAsIkOlqEEvWV+XYP9HvvjFve5CsKY65xSWJs2WUYstyuaZ1wT7OzAXwb//XR38C8kZt/7Tv6SlbLvQVsipYKz56ObbYMVqV3xK/eHhHD7yPiBTHbOcZ0IpwuGwbuPy6eAivGhO2Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p+Mj2o48KZIU06tjOsGJKlU3MX9+qMBJYtvtML+DC1k=;
 b=jQkq7Q35sWa54ihdCag/ORCRhal/MMNr8hlUFbUU3ak7P96QLMjSB5owWCl0VdpVh/Ts88i494nr3NJEcfok1d+1vuTEq9k/xFsfrif5rsKIltHucYv4sIJAnz3/SQOQP+2uDxu5tF/sfV6se2oyyx6PeEAUmR4lPvKau2ob0jbzlOV+VT8hf8LEGEtcxsc3odiFMqHlc25AW8TFaZdR1kUYAfkh7wJNUTuTY51oA+QlvdJNFfJiq/mFyThzKwW4+Ksddq26N7bEo6E+ekdXT+qQn1BHxxuacnVf+T7AbzMlkZ+kR0SVU9WcPpIrc1ftoqgOiq3s85wgy9lbqua/VA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p+Mj2o48KZIU06tjOsGJKlU3MX9+qMBJYtvtML+DC1k=;
 b=t70zaGUpeqPYdmLCE9NELJ4Wh1nCChPsEgfpxcLQq66/g+7HspkW4ZUttk3UMWI/s45WxRKviQ5UWpVxJ9rxnI7jUPhZy+37uFyto9G/e0fThOpRH09BLnBZvfFxAfJ/XfzB/cM3hgnU8Dtpm2ggTDA0LNUB2nB1rAdnZPOPnO4=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB4536.namprd10.prod.outlook.com (2603:10b6:510:40::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Sun, 18 Dec
 2022 10:03:10 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c%4]) with mapi id 15.20.5924.016; Sun, 18 Dec 2022
 10:03:10 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v7 01/27] xfs: Add new name to attri/d
Date:   Sun, 18 Dec 2022 03:02:40 -0700
Message-Id: <20221218100306.76408-2-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221218100306.76408-1-allison.henderson@oracle.com>
References: <20221218100306.76408-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0071.namprd11.prod.outlook.com
 (2603:10b6:a03:80::48) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB4536:EE_
X-MS-Office365-Filtering-Correlation-Id: 172bc518-4dc8-4a0f-141f-08dae0df1158
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y9idT2krZDezl18AMfke3M3M2qZhNanjqY1XJNsSGpNaVnMo9U9TNyDxvW0Uk9cy0PLkc8bQxEoytXKvDu7dGNT6DXK3YLzNnVg+rrVKGnNujwvvidqL3ilf+3RtIULv4hKvnKv1lkxhk/m/ZJbigAcjYzwVj8LZxi7bCcUCOg4bGohpdNElp+0zzbo6HTWKkzTeCjP78/QBkewU+78kXaq2COqCL6CTKNYT2A6FSwDH3ICqMU5ZTew+xpMEUto5XZX8c9Vq/m/M3TlzWYmupyI6x/EWg1M0t04s8ndPzj9yTqXZDhU6f5upea2pa5HzKHwzQuHinnwYzRWLtkEDM28O9agcnaseyWeqduAc9Wc3pY9OCwFBcJItuus1yARgKw7/tIPWsmdz/wJc9l5gYVh8wZw/A2KAqyrFr0aX8FVjOy1MWwELcXhuY/3ssd/q8nU1eXa8CwFPXd7FEd7l8iypNYBmGmXeZmVR78Qi80c91rBQAt8a4TBCNaxPRlqj36aN2KBZcNFV+8DNnRIG6s0ZQPTW/KBtGR28bUk2IXKYc3D6iL4bTBr6kFeGqZlP/1kGbRNyW8r458te68lpMA+16PEnYGeqOyvpT8ZOChtDvFkEnLT9hJQukMJHtb/07XzE/akYUrH1EfVmoL/mCg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(136003)(346002)(366004)(376002)(451199015)(83380400001)(38100700002)(86362001)(30864003)(66476007)(2906002)(8676002)(66556008)(5660300002)(66946007)(8936002)(41300700001)(1076003)(9686003)(26005)(186003)(6512007)(6506007)(6666004)(2616005)(6916009)(316002)(478600001)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Babv3GNuzyx6ySY4ad5G1iPqLTaxjTU/cbyF/nc1MI68DuguFfRG7gT/oFoP?=
 =?us-ascii?Q?YuSbRuscbU0ufuoxvB/vc7fXXsEk1RhfbiYr6zJvaI7IddtAShfuuivr2zQR?=
 =?us-ascii?Q?qPQ7kgkdYxI6OkoIAzE1HgqKJ8eiYT64Vqxq1vYln/fpRZ4L4TS71/4RVQVX?=
 =?us-ascii?Q?Obzan0L9R5QxQ6TQTw17MnW/7wpcuvYNQzBManBolre+uM5h6rbvS0CBdFHR?=
 =?us-ascii?Q?gR6luxhfp2WJWW71OXVmXTHMaZqIZ1c5X5o5FmgYYO1pVsjhibzUjG5T9mRO?=
 =?us-ascii?Q?rjARgrev4kcv6ItMjlyjUVpgrKzS8n/F9zFxeVq+8rR+PKJB7nZeqBjAtQp9?=
 =?us-ascii?Q?HLM5Mv4ILG4OC4QSGmoOo6lePWkVNRxaeKFKPKLrzarteADOHZFWbhOeMF5O?=
 =?us-ascii?Q?Fdo/4zHBv/iZuifaztV8bGu9nr06DeJqknJXmj5aBZ346Yj2kOLdeKFmYcvE?=
 =?us-ascii?Q?TgrBE7vIT6XNLROl5rmjQCEiQ2vaHTss9oPU9u8pb2ijA/MHa7i0rFTLbMr1?=
 =?us-ascii?Q?q/4cwe9jBQftCBd5PpDVjHpZQ8Ll8vf4v94N7TUf0RwKhBeiua7ZtHO580RY?=
 =?us-ascii?Q?VKprIlNxoztqkDavee68w9GVXp7i8Rj4ks6AnW3AggWVhtxaT9sMd2rDFz9U?=
 =?us-ascii?Q?xIdPdBx+Apme1yg6198rJ+wJK6HuZz/OTOcJboOIbxIb2wnl+C8gIDiLZFsa?=
 =?us-ascii?Q?rmnr6MYdTcxIzBNcSoWsqJYGb1SceXoE4cIeLovjj9ITtrjWkNeQXfdfdvWP?=
 =?us-ascii?Q?LfonY9hovB0w+sGIBQ34CcBfyuSeTbYnJO+l7hrICS2S/1nkI/ley8eSGUKi?=
 =?us-ascii?Q?RWztgvcIJ5kv9yC6z9AbtljTV/iBRloOIAyriwcTBKATRheedtUxgpjz9VVj?=
 =?us-ascii?Q?AG3N8UIfDOUnj0Acv50Gs0WjaqYgpQ477PqBsirEVraMFYH1gYfl9oBWpcMI?=
 =?us-ascii?Q?60CepLz8BMBYRh6LSCypPBlRW5jilFzZnBBSZZaams00vg2I+4wT2wOXy+ar?=
 =?us-ascii?Q?xh4JZ9/M/VG6uPGk9bWcpJ7Hw/9ljgtoYJ9hsEKI0xKPM7IYDgk4AmwY7q2w?=
 =?us-ascii?Q?htTuSLR9VqBKRnkdGJGyhuyYFzHgnB+RUVubr0YYsdqwAAxIWDzLdFB1j0ka?=
 =?us-ascii?Q?NZLhZ7660ZNmB0y8WaJgzm53yWi56QEPqmRGS2T980LqiF1EG7fVrv6jfsd+?=
 =?us-ascii?Q?lnj70LKf+N9+ahKjTkyI4y95DaoeN1eyGjhYXnMmA/1pHgwP9rIJ/+rK0vG/?=
 =?us-ascii?Q?CzKMTFI/ARaPwb94pHgrQOHUsfh3cG7+ZjEVyUZxCQLX5FAMBem8d+p38kHv?=
 =?us-ascii?Q?CMj4cQuoadtzv/ujE5cARgoGO2dU0i0sm4VHtA88SIhJmAi9oHSUDNWNseE4?=
 =?us-ascii?Q?XI4yGdlWpGpx7dl2hw8QjBqfXp6J9fmo6tKKq1JifgnPis0Y25v+GFkthHsD?=
 =?us-ascii?Q?vo2O9LHgFms60uavJ/ltNKDvmG/PeXN5dxExm2+RRqaPtSOrBbcmg4YvS0YJ?=
 =?us-ascii?Q?CR0MeOzS2usWZBfR3RldLGYXEaLsXI7SAAR0fQQcog274ycThFHP6gEZtrUS?=
 =?us-ascii?Q?Jg94+Q8qlTBJ1ADhcTZ4j3a2+L2k3ycmTgvZpOTf4H/L+EpcmqvkgDCB+U7n?=
 =?us-ascii?Q?Ew=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 172bc518-4dc8-4a0f-141f-08dae0df1158
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2022 10:03:10.0753
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pZrlOu308w3TOSk+u93Y9N3kpww+QBXtFx2deUBKdRmmaDxWc5M5vQwy84RRz1kkHjaNfN95Kh0zEdejh8S5yzJiY0HF2gtOsIjoRe8jQ50=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4536
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-18_02,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 spamscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212180095
X-Proofpoint-ORIG-GUID: 2WPub9hSeYBbfZiXp6_h7AM28xOicLUh
X-Proofpoint-GUID: 2WPub9hSeYBbfZiXp6_h7AM28xOicLUh
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

