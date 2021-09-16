Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB8A9C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 10:09:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E24261209
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 10:09:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236489AbhIPKKl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 06:10:41 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:47806 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236222AbhIPKKk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Sep 2021 06:10:40 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18G8xcRG029200;
        Thu, 16 Sep 2021 10:09:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=4ykjl5hKIbiT4u778/XdsV0J8w0QAgaFdRrhHsYE27o=;
 b=fmNromObWGimOPbUAUghqonVURP76Tsw4ny19x3jApBa0I1fy/3NhPB6xJDivg334bS4
 hDg04Z5S6GanFFooyLrZpo5z5C/q/bWqEjIAIIJc6K9sujafetw5uaeYxzjyXGQWBa1M
 f8X/6O8eh7Zugsp/+zmDWIWp4PaGgBnD8lmQ2G/oPb4BJIlxRdBbTr/tpZQrMvXmBgfW
 ccitWtQxbEN0X8jVBLHjovkyVhTJkQ3aOJZIenhTRMegRNC2IQENk7S796vqtgooKsQs
 7IeV5qWCLvaA95Pj9N/Jx6ts468o/s0rAFOPzRIYzw6oSlQ/fGV/SFwP961gZU6lJrRs GA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=4ykjl5hKIbiT4u778/XdsV0J8w0QAgaFdRrhHsYE27o=;
 b=rp/DVAo1CJI5OIxwHHENM1BZ7Se1IsZALnr9OblsT86RVreDpL+nYObyno/Gj1B3MfaV
 14NQNDb+SUA+rOZ7i1EcZajiSQ3STPZmA85aFgZAqszO/ptQz5DSi32oKBpaEAiZqLlE
 enRwxRfvsrxYWrqEDPKzX7GN5CfCug59ggC2LEuB1nUkbAsD/KEtU3ydUfj1ptHWkJhJ
 sjy7s+kQVwQpGUkmQdi0xk/k6fE+sVJ9chpVNZOGnf0MuRGFNaS4coXQGPz7cRNmjJK8
 n+6eYjaq7VXaMu8wuU/APTUuYbXlTGYXxnlHL0JiBg95XN1GoMtZjA9RwIlbavP6DpAb MQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b3tnhsbqa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 10:09:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18GA5jIv171695;
        Thu, 16 Sep 2021 10:09:17 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by userp3020.oracle.com with ESMTP id 3b167uxqdr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 10:09:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g6XATm+fVBURkXgGZeQSjZpGZYt0Oo08JxnJe9yyWuURzbXSqKtPGKyOhoEitEAJwKo892c2XK+BkzenycxUqBQYkYGgGJb2rx0sHqxUuz0jwcyYU/D7rWtjeApuvNXzBw4S7k9ZhnkrZqMGGVlpA9I/aYe6b7negcEma3ykS6sEPiuUdK1xKwMIfLMDHhV0e4VpowSrehJcIZPvDeglZp5MuSscuhAxUM4bKJChNZcjWcozKv8MD4a7EfbT/a7vhboQ9wen5MMyGpmknTvqZAzNGC9ifoIFGTBT1EheCvswjDez0bEbi0G3Rvj5h6TVCDZ0jLPT/NOyTgZpZWrACQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=4ykjl5hKIbiT4u778/XdsV0J8w0QAgaFdRrhHsYE27o=;
 b=NXuXivmgRIcvxC98D9Azgjr9k7tF33V6ak6Ff5v2xDmZ7fhipXZ+ZKLlXYDdP6zv2Fck6SDLc5HzDoCHqOKc7b0+uzJLG6ZN7eOXfA77+GtcxuCzURQ7Ad/dqY/5tr2G1KE3IMbhsB8qB1yUwRz4OK/RGXOiIs4+o3JfrRX72J2Sn9WSo+mPIW4OFGU/FDMijotx0jNI2jC+iB/WiS110R4lxdlsTZ+CBE6v2gNQLuj2inh07Fh2ATGC/eBcKmuwRh3G/IZ2eNIVNzqe4vadovlanC7uspRgI0AtZT3Tb1rAiW2ug5YVYAFv4ijnheLMiZtzdATrG9IgQytXYV9cFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ykjl5hKIbiT4u778/XdsV0J8w0QAgaFdRrhHsYE27o=;
 b=T6rluClaGi7rD0ABUEg94y2HdXRN+VT+1bRDkCNiU0QFLKWigxt5SHvtxI0aDFfqu4h5ev3x+7qxWuxfn34z6+yD+VaYEgwK3mOMGLlToajM0Oo0QAXvT7yW/9PagK0aE1PVx9/LhnEDcOGL0LzpcJsXz7wmRDE12SAEsJ3QUF4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4748.namprd10.prod.outlook.com (2603:10b6:806:112::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Thu, 16 Sep
 2021 10:09:15 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%9]) with mapi id 15.20.4523.016; Thu, 16 Sep 2021
 10:09:15 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org
Subject: [PATCH V3 11/16] xfsprogs: Extend per-inode extent counter widths
Date:   Thu, 16 Sep 2021 15:38:17 +0530
Message-Id: <20210916100822.176306-12-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210916100822.176306-1-chandan.babu@oracle.com>
References: <20210916100822.176306-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0158.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:71::28) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from localhost.localdomain (122.171.167.196) by MA1PR01CA0158.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:71::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Thu, 16 Sep 2021 10:09:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0f17d7ae-16f7-49e9-c8c2-08d978fa0998
X-MS-TrafficTypeDiagnostic: SA2PR10MB4748:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR10MB4748614A09738AC2AE5D67DCF6DC9@SA2PR10MB4748.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P3sV8jHqaWl/JDoamRT5//bmaVOxAzdvDe9YF66f+uairCiMAYhb9avwFfNwmaucLjTGu4rFmigT0yqNrBACVGqirKKGBkhQbJ06IScwIX/yh/cVn7o2dTFmUGfj0L7fRWHxM4TL10xeIKF26iIAAmvLV/unS8aEvsk/hFNfoE3sDa/vk9HliIeCe2S7zWwk2gzRNMI15ssxRGpkn7zssjpjUM2sf/eVMwWvE6rw1/riz6O2KFdZiTANykPI5bgBzrELqJr2RGyZYVAhqt1vRgm6I2YD1VL5V+vk/nYqdzI8i6v1wnRMo9BeDGgQVtOzqyOKoMXYHfYP4izHYz0in+0l/4NaMDOQN+/hBZvfWosqthFM8HhCzgXWSB+Gc6AwCSMoF7zEuOSnYi5ah2vH6/8ara5IquB0cyC/zaO1pEAHaClrvcNmUt5zDSuZ/Tz413rM75xINA5QMdcg31MLaL7detDtTc8BgESxZheCG/phmF55evu9UuDRj6M2eY7haXJHfpFuaemjJDyeUvL+OQhLOg/r7vfTaCe5pU3MDzKvPXm+BXjxAF8LFaTBrNwhDEhTh7bzapQTHVoWX2G2ay9HMC7Xy54CHfSn5gW29FsYfhlB6KW4v3DYpt1DmPLjcQK8roUqQBkuo1dHq+x50tTHHqTu6+u6N61/yAxvfNJLTRkxPBEtOLTLtwSlD5pTAONyc3ip0RCgMXNPWvZbOw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39860400002)(366004)(136003)(346002)(66476007)(2616005)(66556008)(66946007)(6916009)(2906002)(1076003)(4326008)(956004)(6506007)(83380400001)(316002)(8676002)(30864003)(36756003)(478600001)(38100700002)(38350700002)(52116002)(6486002)(8936002)(5660300002)(26005)(86362001)(186003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gUL9VI64EpoDgmIf0MzSigu7AGMpkibTaNnCY/H3iYH9PUx5NQ4S1sC6YF6D?=
 =?us-ascii?Q?1MQ/67Ohh6BBZhkzF7MtU+qMlFN/RwLbHdDd+K8Rmm76sarGXAcd81ax04JS?=
 =?us-ascii?Q?YtzCucli1Dm7M1Stm/bqdZuNFLLPqBGIHEeloUMf6VRHSa2S1MnMGoFtVHSW?=
 =?us-ascii?Q?R50wrrnPF8raSbJd31H9NDX8gJdB+kFI3ONs1uPIkwVinTIbhyGoFesfSjOj?=
 =?us-ascii?Q?vRlvQctA/uWiK8xYAuFhJG9D3bVa+HsEXzAuXmmRpy6QO3qkG0L/6R37yDH5?=
 =?us-ascii?Q?pRLg6I5IuOPa5Kl/f+FMwrRcAC4iXlDXy+818hnC0osZESWj6QSGS23C+E8X?=
 =?us-ascii?Q?/sWtewErIbU9gAKtMKUvnlW+bcsBrZ06s8SAiiP5SZeWRhV5Ew1FaX+DbsnZ?=
 =?us-ascii?Q?UD/RL8qoIaU6mo4AWbvi/+am2v5/WjDlufOTwgo1XFzzS3x1GLsu7di3szpP?=
 =?us-ascii?Q?ahoey4vmZTP+wuBi3czCXGLLY3vqqtP6zf1czpwRbNYPHoz394+wbU8v3/YW?=
 =?us-ascii?Q?zYn5PUo4fO3p+fZAEcmFBJdtzYInxJS5/kxlD9m6GVjouPlI7qtj61aRkGYB?=
 =?us-ascii?Q?rnfe1LAe6UbUsJzBzKKBI7Mr/WdIJpPEuogpwSViKQPBVXKz3BaO/ShpGyGS?=
 =?us-ascii?Q?tXVIHVSEcTrACjhDupLcZn9cF8Gn74YmLr6b3DPZaPqlVMvr7rEUE5VyJE2I?=
 =?us-ascii?Q?8ZlEBQyBDlu7+d5TxIpMihZbrfNSMlYdbWJf1FcT+YXKCMI+uAjlzbgBiJ3i?=
 =?us-ascii?Q?uX/8fuLSHieCTGEq+G7DtM8u+FRvbtMl6Y80ZcORxFN5GEw9UDv4m/5zrmw0?=
 =?us-ascii?Q?ce8iP+01tIGNdiESsdXesvP7+gNJJGzBHotiKutQZoauh0GWaD8AEm2QwtRy?=
 =?us-ascii?Q?gG6GdADVMMO9JPUOEli1y9jR0ReVt9hUfe5X31LQrbUY/pe4edd3etjCrmXE?=
 =?us-ascii?Q?1UVZtO9+g6nmC2sH0bvDIXJokRvWT6wGmFjrEoAd8gF17x5PIquzeKdlvoHo?=
 =?us-ascii?Q?7nXIRngmBuk1zqYRqJIyw4yNGPrrk7WHo2vZD9KUT7mJlOqYCsCVQx+Hzs9i?=
 =?us-ascii?Q?RImmOjzDzJROBoQHphtEt+QJuPAHh9n2tJKQ5j8ergIF7v7ps51gMqHXs06g?=
 =?us-ascii?Q?Nw5XCsgDuKDWt7XQ7xIARhNmgtllzqi1NZNbhnYieB5gSGVHs7AmzDC4abDW?=
 =?us-ascii?Q?uqL4zHM4X7eHZaDUr+wR+9cE05Q26CTH+PFUxxRlApROdNpuG+Lbss28DNKw?=
 =?us-ascii?Q?ehS22BByJXB9snO9X8d3sn3mWkQcLajP200yHXo3x5utYRHxlgZia99wjgHM?=
 =?us-ascii?Q?kvmvtFRusNIKjVGkxWa1rShp?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f17d7ae-16f7-49e9-c8c2-08d978fa0998
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2021 10:09:15.5029
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QzgvzVCft0eqUN8Plv/jvhuIHoajrYDWXuHAjbRnzXxyekXIeFiIefK7HsB/FOzp1s7oOfjqXmTLGVcLbBdGDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4748
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10108 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109160064
X-Proofpoint-GUID: a-tXWQOJeF3U-F8cYZYmMFfV7Jr-8PQX
X-Proofpoint-ORIG-GUID: a-tXWQOJeF3U-F8cYZYmMFfV7Jr-8PQX
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds a new 64-bit per-inode data extent counter. However the
maximum number of extents that a data fork can hold is limited to 2^48
extents. This feature is available only when
XFS_SB_FEAT_INCOMPAT_EXTCOUNT_64BIT feature bit is enabled on the
filesystem. Also, enabling this feature bit causes attr fork extent counter to
use the 32-bit extent counter that was previously used to hold the data fork
extent counter. This implies that the attr fork can now occupy a maximum of
2^32 extents.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/field.c                 |  4 --
 db/field.h                 |  2 -
 db/inode.c                 | 44 +++++++++++++++++--
 include/libxlog.h          |  6 ++-
 include/xfs_inode.h        |  5 +++
 include/xfs_mount.h        |  4 +-
 libxfs/xfs_bmap.c          |  8 ++--
 libxfs/xfs_format.h        | 87 ++++++++++++++++++++++++++------------
 libxfs/xfs_fs.h            |  1 +
 libxfs/xfs_ialloc.c        |  2 +
 libxfs/xfs_inode_buf.c     | 25 ++++++++++-
 libxfs/xfs_inode_fork.h    | 18 ++++++--
 libxfs/xfs_log_format.h    |  3 +-
 libxfs/xfs_sb.c            |  3 ++
 libxfs/xfs_trans_inode.c   |  5 +++
 logprint/log_misc.c        | 23 +++++++---
 logprint/log_print_all.c   | 31 +++++++++++---
 logprint/log_print_trans.c |  2 +-
 repair/bmap_repair.c       | 10 ++++-
 repair/dinode.c            | 15 +++++--
 20 files changed, 229 insertions(+), 69 deletions(-)

diff --git a/db/field.c b/db/field.c
index 51268938..1e274ffc 100644
--- a/db/field.c
+++ b/db/field.c
@@ -25,8 +25,6 @@
 #include "symlink.h"
 
 const ftattr_t	ftattrtab[] = {
-	{ FLDT_AEXTNUM, "aextnum", fp_num, "%d", SI(bitsz(xfs_aextnum_t)),
-	  FTARG_SIGNED, NULL, NULL },
 	{ FLDT_AGBLOCK, "agblock", fp_num, "%u", SI(bitsz(xfs_agblock_t)),
 	  FTARG_DONULL, fa_agblock, NULL },
 	{ FLDT_AGBLOCKNZ, "agblocknz", fp_num, "%u", SI(bitsz(xfs_agblock_t)),
@@ -300,8 +298,6 @@ const ftattr_t	ftattrtab[] = {
 	  FTARG_DONULL, fa_drtbno, NULL },
 	{ FLDT_EXTLEN, "extlen", fp_num, "%u", SI(bitsz(xfs_extlen_t)), 0, NULL,
 	  NULL },
-	{ FLDT_EXTNUM, "extnum", fp_num, "%d", SI(bitsz(xfs_extnum_t)),
-	  FTARG_SIGNED, NULL, NULL },
 	{ FLDT_FSIZE, "fsize", fp_num, "%lld", SI(bitsz(xfs_fsize_t)),
 	  FTARG_SIGNED, NULL, NULL },
 	{ FLDT_INO, "ino", fp_num, "%llu", SI(bitsz(xfs_ino_t)), FTARG_DONULL,
diff --git a/db/field.h b/db/field.h
index 387c189e..614fd0ab 100644
--- a/db/field.h
+++ b/db/field.h
@@ -5,7 +5,6 @@
  */
 
 typedef enum fldt	{
-	FLDT_AEXTNUM,
 	FLDT_AGBLOCK,
 	FLDT_AGBLOCKNZ,
 	FLDT_AGF,
@@ -143,7 +142,6 @@ typedef enum fldt	{
 	FLDT_DRFSBNO,
 	FLDT_DRTBNO,
 	FLDT_EXTLEN,
-	FLDT_EXTNUM,
 	FLDT_FSIZE,
 	FLDT_INO,
 	FLDT_INOBT,
diff --git a/db/inode.c b/db/inode.c
index 33dfffd0..ab825fc3 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -37,6 +37,8 @@ static int	inode_u_muuid_count(void *obj, int startoff);
 static int	inode_u_sfdir2_count(void *obj, int startoff);
 static int	inode_u_sfdir3_count(void *obj, int startoff);
 static int	inode_u_symlink_count(void *obj, int startoff);
+static int	inode_v3_64bitext_count(void *obj, int startoff);
+static int	inode_v3_pad2_count(void *obj, int startoff);
 
 static const cmdinfo_t	inode_cmd =
 	{ "inode", NULL, inode_f, 0, 1, 1, "[inode#]",
@@ -100,8 +102,8 @@ const field_t	inode_core_flds[] = {
 	{ "size", FLDT_FSIZE, OI(COFF(size)), C1, 0, TYP_NONE },
 	{ "nblocks", FLDT_DRFSBNO, OI(COFF(nblocks)), C1, 0, TYP_NONE },
 	{ "extsize", FLDT_EXTLEN, OI(COFF(extsize)), C1, 0, TYP_NONE },
-	{ "nextents32", FLDT_EXTNUM, OI(COFF(nextents32)), C1, 0, TYP_NONE },
-	{ "nextents16", FLDT_AEXTNUM, OI(COFF(nextents16)), C1, 0, TYP_NONE },
+	{ "nextents32", FLDT_UINT32D, OI(COFF(nextents32)), C1, 0, TYP_NONE },
+	{ "nextents16", FLDT_UINT16D, OI(COFF(nextents16)), C1, 0, TYP_NONE },
 	{ "forkoff", FLDT_UINT8D, OI(COFF(forkoff)), C1, 0, TYP_NONE },
 	{ "aformat", FLDT_DINODE_FMT, OI(COFF(aformat)), C1, 0, TYP_NONE },
 	{ "dmevmask", FLDT_UINT32X, OI(COFF(dmevmask)), C1, 0, TYP_NONE },
@@ -162,7 +164,10 @@ const field_t	inode_v3_flds[] = {
 	{ "lsn", FLDT_UINT64X, OI(COFF(lsn)), C1, 0, TYP_NONE },
 	{ "flags2", FLDT_UINT64X, OI(COFF(flags2)), C1, 0, TYP_NONE },
 	{ "cowextsize", FLDT_EXTLEN, OI(COFF(cowextsize)), C1, 0, TYP_NONE },
-	{ "pad2", FLDT_UINT8X, OI(OFF(pad2)), CI(12), FLD_ARRAY|FLD_SKIPALL, TYP_NONE },
+	{ "nextents64", FLDT_UINT64D, OI(COFF(nextents64)),
+	  inode_v3_64bitext_count, FLD_COUNT, TYP_NONE },
+	{ "pad2", FLDT_UINT8X, OI(OFF(pad2)), inode_v3_pad2_count,
+	  FLD_ARRAY|FLD_COUNT|FLD_SKIPALL, TYP_NONE },
 	{ "crtime", FLDT_TIMESTAMP, OI(COFF(crtime)), C1, 0, TYP_NONE },
 	{ "inumber", FLDT_INO, OI(COFF(ino)), C1, 0, TYP_NONE },
 	{ "uuid", FLDT_UUID, OI(COFF(uuid)), C1, 0, TYP_NONE },
@@ -181,6 +186,9 @@ const field_t	inode_v3_flds[] = {
 	{ "metadata", FLDT_UINT1,
 	  OI(COFF(flags2) + bitsz(uint64_t) - XFS_DIFLAG2_METADATA_BIT-1), C1,
 	  0, TYP_NONE },
+	{ "nrext64", FLDT_UINT1,
+	  OI(COFF(flags2) + bitsz(uint64_t) - XFS_DIFLAG2_NREXT64_BIT-1), C1,
+	  0, TYP_NONE },
 	{ NULL }
 };
 
@@ -409,6 +417,36 @@ inode_core_projid_count(
 	return dic->di_version >= 2;
 }
 
+static int
+inode_v3_64bitext_count(
+	void			*obj,
+	int			startoff)
+{
+	struct xfs_dinode	*dic;
+
+	ASSERT(startoff == 0);
+	ASSERT(obj == iocur_top->data);
+	dic = obj;
+	return !!(be64_to_cpu(dic->di_flags2) & XFS_DIFLAG2_NREXT64);
+}
+
+static int
+inode_v3_pad2_count(
+	void			*obj,
+	int			startoff)
+{
+	struct xfs_dinode	*dic;
+
+	ASSERT(startoff == 0);
+	ASSERT(obj == iocur_top->data);
+	dic = obj;
+
+	if (be64_to_cpu(dic->di_flags2) & XFS_DIFLAG2_NREXT64)
+		return 4;
+	else
+		return 12;
+}
+
 static int
 inode_f(
 	int		argc,
diff --git a/include/libxlog.h b/include/libxlog.h
index adaa9963..fe30481c 100644
--- a/include/libxlog.h
+++ b/include/libxlog.h
@@ -89,13 +89,15 @@ extern int	xlog_find_tail(struct xlog *log, xfs_daddr_t *head_blk,
 
 extern int	xlog_recover(struct xlog *log, int readonly);
 extern void	xlog_recover_print_data(char *p, int len);
-extern void	xlog_recover_print_logitem(struct xlog_recover_item *item);
+extern void	xlog_recover_print_logitem(struct xlog *log,
+			struct xlog_recover_item *item);
 extern void	xlog_recover_print_trans_head(struct xlog_recover *tr);
 extern int	xlog_print_find_oldest(struct xlog *log, xfs_daddr_t *last_blk);
 
 /* for transactional view */
 extern void	xlog_recover_print_trans_head(struct xlog_recover *tr);
-extern void	xlog_recover_print_trans(struct xlog_recover *trans,
+extern void	xlog_recover_print_trans(struct xlog *log,
+				struct xlog_recover *trans,
 				struct list_head *itemq, int print);
 extern int	xlog_do_recovery_pass(struct xlog *log, xfs_daddr_t head_blk,
 				xfs_daddr_t tail_blk, int pass);
diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index bf8e68e1..450ea8ff 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -211,6 +211,11 @@ static inline bool xfs_inode_has_bigrtextents(struct xfs_inode *ip)
 	return XFS_IS_REALTIME_INODE(ip) && ip->i_mount->m_sb.sb_rextsize > 1;
 }
 
+static inline bool xfs_inode_has_nrext64(struct xfs_inode *ip)
+{
+	return ip->i_diflags2 & XFS_DIFLAG2_NREXT64;
+}
+
 static inline bool xfs_is_always_cow_inode(struct xfs_inode *ip)
 {
 	return false;
diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 2ee93e37..c8385d16 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -153,8 +153,9 @@ typedef struct xfs_mount {
 #define XFS_FEAT_NEEDSREPAIR	(1ULL << 25)	/* needs xfs_repair */
 #define XFS_FEAT_ATOMIC_SWAP	(1ULL << 26)	/* extent swap log items */
 #define XFS_FEAT_METADIR	(1ULL << 27)	/* metadata directory tree */
+#define XFS_FEAT_NREXT64	(1ULL << 28)	/* 64-bit inode extent counters */
 
-#define __XFS_HAS_FEAT(name, NAME) \
+#define __XFS_HAS_FEAT(name, NAME)			   \
 static inline bool xfs_has_ ## name (struct xfs_mount *mp) \
 { \
 	return mp->m_features & XFS_FEAT_ ## NAME; \
@@ -198,6 +199,7 @@ __XFS_HAS_FEAT(bigtime, BIGTIME)
 __XFS_HAS_FEAT(needsrepair, NEEDSREPAIR)
 __XFS_HAS_FEAT(atomicswap, ATOMIC_SWAP)
 __XFS_HAS_FEAT(metadir, METADIR)
+__XFS_HAS_FEAT(nrext64, NREXT64)
 
 /*
  * Decide if this filesystem can use log-assisted ("atomic") extent swapping.
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 3c23ea30..8a1b94bb 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -48,18 +48,16 @@ xfs_bmap_compute_maxlevels(
 	int		whichfork)	/* data or attr fork */
 {
 	xfs_extnum_t	maxleafents;	/* max leaf entries possible */
+	xfs_rfsblock_t	maxblocks;	/* max blocks at this level */
 	int		level;		/* btree level */
-	uint		maxblocks;	/* max blocks at this level */
 	int		maxrootrecs;	/* max records in root block */
 	int		minleafrecs;	/* min records in leaf block */
 	int		minnoderecs;	/* min records in node block */
 	int		sz;		/* root block size */
 
 	/*
-	 * The maximum number of extents in a file, hence the maximum number of
-	 * leaf entries, is controlled by the size of the on-disk extent count,
-	 * either a signed 32-bit number for the data fork, or a signed 16-bit
-	 * number for the attr fork.
+	 * The maximum number of extents in a fork, hence the maximum number of
+	 * leaf entries, is controlled by the size of the on-disk extent count.
 	 *
 	 * Note that we can no longer assume that if we are in ATTR1 that the
 	 * fork offset of all the inodes will be
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 36c382e7..9971300a 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -388,6 +388,7 @@ xfs_sb_has_ro_compat_feature(
 #define XFS_SB_FEAT_INCOMPAT_BIGTIME	(1 << 3)	/* large timestamps */
 #define XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR (1 << 4)	/* needs xfs_repair */
 #define XFS_SB_FEAT_INCOMPAT_METADIR	(1 << 5)	/* metadata dir tree */
+#define XFS_SB_FEAT_INCOMPAT_NREXT64	(1 << 6)	/* 64-bit data fork extent counter */
 #define XFS_SB_FEAT_INCOMPAT_ALL \
 		(XFS_SB_FEAT_INCOMPAT_FTYPE|	\
 		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
@@ -802,6 +803,15 @@ typedef struct xfs_dinode {
 	__be64		di_size;	/* number of bytes in file */
 	__be64		di_nblocks;	/* # of direct & btree blocks used */
 	__be32		di_extsize;	/* basic/minimum extent size for file */
+	/*
+	 * On a extcnt64bit filesystem, di_nextents64 holds the data fork
+	 * extent count, di_nextents32 holds the attr fork extent count,
+	 * and di_nextents16 must be zero.
+	 *
+	 * Otherwise, di_nextents32 holds the data fork extent count,
+	 * di_nextents16 holds the attr fork extent count, and di_nextents64
+	 * must be zero.
+	 */
 	__be32		di_nextents32;	/* 32-bit extent counter */
 	__be16		di_nextents16;	/* 16-bit extent counter */
 	__u8		di_forkoff;	/* attr fork offs, <<3 for 64b align */
@@ -820,7 +830,8 @@ typedef struct xfs_dinode {
 	__be64		di_lsn;		/* flush sequence */
 	__be64		di_flags2;	/* more random flags */
 	__be32		di_cowextsize;	/* basic cow extent size for file */
-	__u8		di_pad2[12];	/* more padding for future expansion */
+	__u8		di_pad2[4];	/* more padding for future expansion */
+	__be64		di_nextents64;	/* 64-bit extent counter */
 
 	/* fields only written to during inode creation */
 	xfs_timestamp_t	di_crtime;	/* time created */
@@ -875,10 +886,14 @@ enum xfs_dinode_fmt {
 /*
  * Max values for extlen, disk inode's extent counters.
  */
+
 #define	MAXEXTLEN		((xfs_extlen_t)0x1fffff) /* 21 bits */
+#define XFS_IFORK_EXTCNT_MAXU48 ((xfs_extnum_t)0xffffffffffff) /* Unsigned 48-bits */
+#define XFS_IFORK_EXTCNT_MAXU32 ((xfs_aextnum_t)0xffffffff) /* Unsigned 32-bits */
 #define XFS_IFORK_EXTCNT_MAXS32 ((xfs_extnum_t)0x7fffffff) /* Signed 32-bits */
 #define XFS_IFORK_EXTCNT_MAXS16 ((xfs_aextnum_t)0x7fff) /* Signed 16-bits */
 
+
 /*
  * Inode minimum and maximum sizes.
  */
@@ -930,32 +945,6 @@ enum xfs_dinode_fmt {
 		(dip)->di_format : \
 		(dip)->di_aformat)
 
-static inline int
-xfs_dfork_nextents(
-	struct xfs_dinode	*dip,
-	int			whichfork,
-	xfs_extnum_t		*nextents)
-{
-	int			error = 0;
-
-	switch (whichfork) {
-	case XFS_DATA_FORK:
-		*nextents = be32_to_cpu(dip->di_nextents32);
-		break;
-
-	case XFS_ATTR_FORK:
-		*nextents = be16_to_cpu(dip->di_nextents16);
-		break;
-
-	default:
-		ASSERT(0);
-		error = -EFSCORRUPTED;
-		break;
-	}
-
-	return error;
-}
-
 /*
  * For block and character special files the 32bit dev_t is stored at the
  * beginning of the data fork.
@@ -1022,6 +1011,7 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
 #define XFS_DIFLAG2_COWEXTSIZE_BIT   2  /* copy on write extent size hint */
 #define XFS_DIFLAG2_BIGTIME_BIT	3	/* big timestamps */
 #define XFS_DIFLAG2_METADATA_BIT 4	/* filesystem metadata */
+#define XFS_DIFLAG2_NREXT64_BIT 5	/* 64-bit extent counter enabled */
 
 #define XFS_DIFLAG2_DAX		(1 << XFS_DIFLAG2_DAX_BIT)
 #define XFS_DIFLAG2_REFLINK     (1 << XFS_DIFLAG2_REFLINK_BIT)
@@ -1052,10 +1042,11 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
  * - Metadata directory entries must have correct ftype.
  */
 #define XFS_DIFLAG2_METADATA	(1 << XFS_DIFLAG2_METADATA_BIT)
+#define XFS_DIFLAG2_NREXT64	(1 << XFS_DIFLAG2_NREXT64_BIT)
 
 #define XFS_DIFLAG2_ANY \
 	(XFS_DIFLAG2_DAX | XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE | \
-	 XFS_DIFLAG2_BIGTIME | XFS_DIFLAG2_METADATA)
+	 XFS_DIFLAG2_BIGTIME | XFS_DIFLAG2_METADATA | XFS_DIFLAG2_NREXT64)
 
 static inline bool xfs_dinode_has_bigtime(const struct xfs_dinode *dip)
 {
@@ -1063,6 +1054,46 @@ static inline bool xfs_dinode_has_bigtime(const struct xfs_dinode *dip)
 	       (dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_BIGTIME));
 }
 
+static inline bool xfs_dinode_has_nrext64(const struct xfs_dinode *dip)
+{
+	return dip->di_version >= 3 &&
+	       (dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_NREXT64));
+}
+
+static inline int
+xfs_dfork_nextents(
+	struct xfs_dinode	*dip,
+	int			whichfork,
+	xfs_extnum_t		*nextents)
+{
+	int			error = 0;
+	bool			inode_has_nrext64;
+
+	inode_has_nrext64 = xfs_dinode_has_nrext64(dip);
+
+	if (inode_has_nrext64 && dip->di_nextents16 != 0)
+		return -EFSCORRUPTED;
+
+	switch (whichfork) {
+	case XFS_DATA_FORK:
+		*nextents = inode_has_nrext64 ? be64_to_cpu(dip->di_nextents64) :
+			be32_to_cpu(dip->di_nextents32);
+		break;
+
+	case XFS_ATTR_FORK:
+		*nextents = inode_has_nrext64 ? be32_to_cpu(dip->di_nextents32) :
+			be16_to_cpu(dip->di_nextents16);
+		break;
+
+	default:
+		ASSERT(0);
+		error = -EFSCORRUPTED;
+		break;
+	}
+
+	return error;
+}
+
 /*
  * Inode number format:
  * low inopblog bits - offset in block
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index b7690691..3d0b679d 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -254,6 +254,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_INOBTCNT	(1 << 22) /* inobt btree counter */
 #define XFS_FSOP_GEOM_FLAGS_ATOMIC_SWAP	(1 << 23) /* atomic swapext */
 #define XFS_FSOP_GEOM_FLAGS_METADIR	(1 << 24) /* metadata directories */
+#define XFS_FSOP_GEOM_FLAGS_NREXT64	(1 << 25) /* 64-bit extent counter */
 
 /*
  * Minimum and maximum sizes need for growth checks.
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 67dd9060..7fac2c34 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -2831,6 +2831,8 @@ xfs_ialloc_setup_geometry(
 	igeo->new_diflags2 = 0;
 	if (xfs_has_bigtime(mp))
 		igeo->new_diflags2 |= XFS_DIFLAG2_BIGTIME;
+	if (xfs_has_nrext64(mp))
+		igeo->new_diflags2 |= XFS_DIFLAG2_NREXT64;
 
 	/* Compute inode btree geometry. */
 	igeo->agino_log = sbp->sb_inopblog + sbp->sb_agblklog;
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 5909bc26..15690f7f 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -282,6 +282,27 @@ xfs_inode_to_disk_ts(
 	return ts;
 }
 
+static inline void
+xfs_inode_to_disk_iext_counters(
+	struct xfs_inode	*ip,
+	struct xfs_dinode	*to)
+{
+	if (xfs_inode_has_nrext64(ip)) {
+		to->di_nextents64 = cpu_to_be64(xfs_ifork_nextents(&ip->i_df));
+		to->di_nextents32 = cpu_to_be32(xfs_ifork_nextents(ip->i_afp));
+		/*
+		 * We might be upgrading the inode to use wider extent counters
+		 * than was previously used. Hence zero the unused field.
+		 */
+		to->di_nextents16 = cpu_to_be16(0);
+	} else {
+		if (xfs_has_v3inodes(ip->i_mount))
+			to->di_nextents64 = 0;
+		to->di_nextents32 = cpu_to_be32(xfs_ifork_nextents(&ip->i_df));
+		to->di_nextents16 = cpu_to_be16(xfs_ifork_nextents(ip->i_afp));
+	}
+}
+
 void
 xfs_inode_to_disk(
 	struct xfs_inode	*ip,
@@ -310,8 +331,6 @@ xfs_inode_to_disk(
 	to->di_size = cpu_to_be64(ip->i_disk_size);
 	to->di_nblocks = cpu_to_be64(ip->i_nblocks);
 	to->di_extsize = cpu_to_be32(ip->i_extsize);
-	to->di_nextents32 = cpu_to_be32(xfs_ifork_nextents(&ip->i_df));
-	to->di_nextents16 = cpu_to_be16(xfs_ifork_nextents(ip->i_afp));
 	to->di_forkoff = ip->i_forkoff;
 	to->di_aformat = xfs_ifork_format(ip->i_afp);
 	to->di_flags = cpu_to_be16(ip->i_diflags);
@@ -331,6 +350,8 @@ xfs_inode_to_disk(
 		to->di_version = 2;
 		to->di_flushiter = cpu_to_be16(ip->i_flushiter);
 	}
+
+	xfs_inode_to_disk_iext_counters(ip, to);
 }
 
 static xfs_failaddr_t
diff --git a/libxfs/xfs_inode_fork.h b/libxfs/xfs_inode_fork.h
index 4b9df10e..f8a85ba6 100644
--- a/libxfs/xfs_inode_fork.h
+++ b/libxfs/xfs_inode_fork.h
@@ -136,10 +136,22 @@ static inline int8_t xfs_ifork_format(struct xfs_ifork *ifp)
 static inline xfs_extnum_t xfs_iext_max_nextents(struct xfs_mount *mp,
 		int whichfork)
 {
-	if (whichfork == XFS_DATA_FORK || whichfork == XFS_COW_FORK)
-		return XFS_IFORK_EXTCNT_MAXS32;
+	bool has_64bit_extcnt = xfs_has_nrext64(mp);
 
-	return XFS_IFORK_EXTCNT_MAXS16;
+	switch (whichfork) {
+	case XFS_DATA_FORK:
+	case XFS_COW_FORK:
+		return has_64bit_extcnt ? XFS_IFORK_EXTCNT_MAXU48
+			: XFS_IFORK_EXTCNT_MAXS32;
+
+	case XFS_ATTR_FORK:
+		return has_64bit_extcnt ? XFS_IFORK_EXTCNT_MAXU32
+			: XFS_IFORK_EXTCNT_MAXS16;
+
+	default:
+		ASSERT(0);
+		return 0;
+	}
 }
 
 struct xfs_ifork *xfs_ifork_alloc(enum xfs_dinode_fmt format,
diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index 9f352ff4..de4bcb94 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -429,7 +429,8 @@ struct xfs_log_dinode {
 
 	uint64_t	di_flags2;	/* more random flags */
 	uint32_t	di_cowextsize;	/* basic cow extent size for file */
-	uint8_t		di_pad2[12];	/* more padding for future expansion */
+	uint8_t		di_pad2[4];	/* more padding for future expansion */
+	uint64_t	di_nextents64; /* higher part of data fork extent count */
 
 	/* fields only written to during inode creation */
 	xfs_log_timestamp_t di_crtime;	/* time created */
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index ae336f0a..2489f619 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -1173,6 +1173,9 @@ xfs_fs_geometry(
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_ATOMIC_SWAP;
 	if (xfs_has_metadir(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_METADIR;
+	if (xfs_has_nrext64(mp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_NREXT64;
+
 	geo->rtsectsize = sbp->sb_blocksize;
 	geo->dirblocksize = xfs_dir2_dirblock_bytes(sbp);
 
diff --git a/libxfs/xfs_trans_inode.c b/libxfs/xfs_trans_inode.c
index 6fc7a65d..fb069c02 100644
--- a/libxfs/xfs_trans_inode.c
+++ b/libxfs/xfs_trans_inode.c
@@ -141,6 +141,11 @@ xfs_trans_log_inode(
 		flags |= XFS_ILOG_CORE;
 	}
 
+	if ((flags & XFS_ILOG_CORE) &&
+	    xfs_has_nrext64(ip->i_mount) &&
+	    !xfs_inode_has_nrext64(ip))
+		ip->i_diflags2 |= XFS_DIFLAG2_NREXT64;
+
 	/*
 	 * Inode verifiers do not check that the extent size hint is an integer
 	 * multiple of the rt extent size on a directory with both rtinherit
diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index 4e8760c4..56b373f9 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -438,8 +438,11 @@ xlog_print_trans_qoff(char **ptr, uint len)
 
 static void
 xlog_print_trans_inode_core(
+	struct xfs_mount	*mp,
 	struct xfs_log_dinode	*ip)
 {
+    xfs_extnum_t		nextents;
+
     printf(_("INODE CORE\n"));
     printf(_("magic 0x%hx mode 0%ho version %d format %d\n"),
 	   ip->di_magic, ip->di_mode, (int)ip->di_version,
@@ -450,11 +453,21 @@ xlog_print_trans_inode_core(
 		xlog_extract_dinode_ts(ip->di_atime),
 		xlog_extract_dinode_ts(ip->di_mtime),
 		xlog_extract_dinode_ts(ip->di_ctime));
-    printf(_("size 0x%llx nblocks 0x%llx extsize 0x%x nextents 0x%x\n"),
+
+    if (ip->di_flags2 & XFS_DIFLAG2_NREXT64)
+	    nextents = ip->di_nextents64;
+    else
+	    nextents = ip->di_nextents32;
+    printf(_("size 0x%llx nblocks 0x%llx extsize 0x%x nextents 0x%lx\n"),
 	   (unsigned long long)ip->di_size, (unsigned long long)ip->di_nblocks,
-	   ip->di_extsize, ip->di_nextents32);
-    printf(_("naextents 0x%x forkoff %d dmevmask 0x%x dmstate 0x%hx\n"),
-	   ip->di_nextents16, (int)ip->di_forkoff, ip->di_dmevmask,
+	   ip->di_extsize, nextents);
+
+    if (ip->di_flags2 & XFS_DIFLAG2_NREXT64)
+	    nextents = ip->di_nextents32;
+    else
+	    nextents = ip->di_nextents16;
+    printf(_("naextents 0x%lx forkoff %d dmevmask 0x%x dmstate 0x%hx\n"),
+	   nextents, (int)ip->di_forkoff, ip->di_dmevmask,
 	   ip->di_dmstate);
     printf(_("flags 0x%x gen 0x%x\n"),
 	   ip->di_flags, ip->di_gen);
@@ -564,7 +577,7 @@ xlog_print_trans_inode(
     memmove(&dino, *ptr, sizeof(dino));
     mode = dino.di_mode & S_IFMT;
     size = (int)dino.di_size;
-    xlog_print_trans_inode_core(&dino);
+    xlog_print_trans_inode_core(log->l_mp, &dino);
     *ptr += xfs_log_dinode_size(log->l_mp);
     skip_count--;
 
diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
index 403c5637..adc7c79c 100644
--- a/logprint/log_print_all.c
+++ b/logprint/log_print_all.c
@@ -238,9 +238,13 @@ xlog_recover_print_dquot(
 
 STATIC void
 xlog_recover_print_inode_core(
+	struct xlog		*log,
 	struct xfs_log_dinode	*di)
 {
-	printf(_("	CORE inode:\n"));
+	xfs_extnum_t		nextents;
+	xfs_aextnum_t		anextents;
+
+        printf(_("	CORE inode:\n"));
 	if (!print_inode)
 		return;
 	printf(_("		magic:%c%c  mode:0x%x  ver:%d  format:%d\n"),
@@ -254,10 +258,19 @@ xlog_recover_print_inode_core(
 			xlog_extract_dinode_ts(di->di_mtime),
 			xlog_extract_dinode_ts(di->di_ctime));
 	printf(_("		flushiter:%d\n"), di->di_flushiter);
+
+	if (di->di_flags2 & XFS_DIFLAG2_NREXT64) {
+		nextents = di->di_nextents64;
+		anextents = di->di_nextents32;
+	} else {
+		nextents = di->di_nextents32;
+		anextents = di->di_nextents16;
+	}
+
 	printf(_("		size:0x%llx  nblks:0x%llx  exsize:%d  "
-	     "nextents:%d  anextents:%d\n"), (unsigned long long)
+	     "nextents:%lu  anextents:%u\n"), (unsigned long long)
 	       di->di_size, (unsigned long long)di->di_nblocks,
-	       di->di_extsize, di->di_nextents32, (int)di->di_nextents16);
+	       di->di_extsize, nextents, anextents);
 	printf(_("		forkoff:%d  dmevmask:0x%x  dmstate:%d  flags:0x%x  "
 	     "gen:%u\n"),
 	       (int)di->di_forkoff, di->di_dmevmask, (int)di->di_dmstate,
@@ -270,6 +283,7 @@ xlog_recover_print_inode_core(
 
 STATIC void
 xlog_recover_print_inode(
+	struct xlog		*log,
 	struct xlog_recover_item *item)
 {
 	struct xfs_inode_log_format	f_buf;
@@ -291,7 +305,7 @@ xlog_recover_print_inode(
 	ASSERT(item->ri_buf[1].i_len ==
 			offsetof(struct xfs_log_dinode, di_next_unlinked) ||
 	       item->ri_buf[1].i_len == sizeof(struct xfs_log_dinode));
-	xlog_recover_print_inode_core((struct xfs_log_dinode *)
+	xlog_recover_print_inode_core(log, (struct xfs_log_dinode *)
 				      item->ri_buf[1].i_addr);
 
 	hasdata = (f->ilf_fields & XFS_ILOG_DFORK) != 0;
@@ -386,6 +400,7 @@ xlog_recover_print_icreate(
 
 void
 xlog_recover_print_logitem(
+	struct xlog			*log,
 	struct xlog_recover_item	*item)
 {
 	switch (ITEM_TYPE(item)) {
@@ -396,7 +411,7 @@ xlog_recover_print_logitem(
 		xlog_recover_print_icreate(item);
 		break;
 	case XFS_LI_INODE:
-		xlog_recover_print_inode(item);
+		xlog_recover_print_inode(log, item);
 		break;
 	case XFS_LI_EFD:
 		xlog_recover_print_efd(item);
@@ -442,6 +457,7 @@ xlog_recover_print_logitem(
 
 static void
 xlog_recover_print_item(
+	struct xlog		*log,
 	struct xlog_recover_item *item)
 {
 	int			i;
@@ -507,11 +523,12 @@ xlog_recover_print_item(
 		       (long)item->ri_buf[i].i_addr, item->ri_buf[i].i_len);
 	}
 	printf("\n");
-	xlog_recover_print_logitem(item);
+	xlog_recover_print_logitem(log, item);
 }
 
 void
 xlog_recover_print_trans(
+	struct xlog		*log,
 	struct xlog_recover	*trans,
 	struct list_head	*itemq,
 	int			print)
@@ -524,5 +541,5 @@ xlog_recover_print_trans(
 	print_xlog_record_line();
 	xlog_recover_print_trans_head(trans);
 	list_for_each_entry(item, itemq, ri_list)
-		xlog_recover_print_item(item);
+		xlog_recover_print_item(log, item);
 }
diff --git a/logprint/log_print_trans.c b/logprint/log_print_trans.c
index 2004b5a0..c6386fb0 100644
--- a/logprint/log_print_trans.c
+++ b/logprint/log_print_trans.c
@@ -24,7 +24,7 @@ xlog_recover_do_trans(
 	struct xlog_recover	*trans,
 	int			pass)
 {
-	xlog_recover_print_trans(trans, &trans->r_itemq, 3);
+	xlog_recover_print_trans(log, trans, &trans->r_itemq, 3);
 	return 0;
 }
 
diff --git a/repair/bmap_repair.c b/repair/bmap_repair.c
index 847538b1..7d3bb330 100644
--- a/repair/bmap_repair.c
+++ b/repair/bmap_repair.c
@@ -579,7 +579,10 @@ rebuild_bmap(
 		if (nextents == 0)
 			return 0;
 		(*dinop)->di_format = XFS_DINODE_FMT_EXTENTS;
-		(*dinop)->di_nextents32 = 0;
+		if (be64_to_cpu((*dinop)->di_flags2) & XFS_DIFLAG2_NREXT64)
+			(*dinop)->di_nextents64 = 0;
+		else
+			(*dinop)->di_nextents32 = 0;
 		libxfs_dinode_calc_crc(mp, *dinop);
 		*dirty = 1;
 		break;
@@ -590,7 +593,10 @@ rebuild_bmap(
 		if (nextents == 0)
 			return 0;
 		(*dinop)->di_aformat = XFS_DINODE_FMT_EXTENTS;
-		(*dinop)->di_nextents16 = 0;
+		if (be64_to_cpu((*dinop)->di_flags2) & XFS_DIFLAG2_NREXT64)
+			(*dinop)->di_nextents32 = 0;
+		else
+			(*dinop)->di_nextents16 = 0;
 		libxfs_dinode_calc_crc(mp, *dinop);
 		*dirty = 1;
 		break;
diff --git a/repair/dinode.c b/repair/dinode.c
index c995a524..01674443 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -78,7 +78,10 @@ _("would have cleared inode %" PRIu64 " attributes\n"), ino_num);
 	if (anextents != 0) {
 		if (no_modify)
 			return(1);
-		dino->di_nextents16 = cpu_to_be16(0);
+		if (xfs_dinode_has_nrext64(dino))
+			dino->di_nextents32 = 0;
+		else
+			dino->di_nextents16 = 0;
 	}
 
 	if (dino->di_aformat != XFS_DINODE_FMT_EXTENTS)  {
@@ -1872,7 +1875,10 @@ _("too many data fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
 			do_warn(
 _("correcting nextents for inode %" PRIu64 ", was %lu - counted %" PRIu64 "\n"),
 				lino, dnextents, nextents);
-			dino->di_nextents32 = cpu_to_be32(nextents);
+			if (xfs_dinode_has_nrext64(dino))
+				dino->di_nextents64 = cpu_to_be64(nextents);
+			else
+				dino->di_nextents32 = cpu_to_be32(nextents);
 			*dirty = 1;
 		} else  {
 			do_warn(
@@ -1896,7 +1902,10 @@ _("too many attr fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
 			do_warn(
 _("correcting anextents for inode %" PRIu64 ", was %lu - counted %" PRIu64 "\n"),
 				lino, dnextents, anextents);
-			dino->di_nextents16 = cpu_to_be16(anextents);
+			if (xfs_dinode_has_nrext64(dino))
+				dino->di_nextents32 = cpu_to_be32(anextents);
+			else
+				dino->di_nextents16 = cpu_to_be16(anextents);
 			*dirty = 1;
 		} else  {
 			do_warn(
-- 
2.30.2

