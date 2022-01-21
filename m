Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80BBAC433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jan 2022 05:22:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236014AbiAUFWG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jan 2022 00:22:06 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:26364 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348385AbiAUFVR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jan 2022 00:21:17 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20L04TlT018499;
        Fri, 21 Jan 2022 05:21:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=n0M5/Q4ppUpGKV3LXPfoNMftjm8s8AXc1pre0rd1EBQ=;
 b=G6EQvjMjSokbnxSeGO+N13DK5tKBrpp4cZzyZ7eKVHbRzjz0xuUeTes276KzJGw6h4YW
 ydqU34JbX2GTiGHlnVpTC162r/sYYXsaAQC3L/t3tyWlpHhDVTGfVd5M/XGGAT4K/nEu
 coAvIeN1etzfXw/rMJAlp+pm58sCRPhCb1TYuIbMdu9nqzQ584zA3ipT53Usp4CK0WGP
 50HuMvs14KWjjq+/wbHEpMFcyz0m12uTtoymPccb1nzTAUtdCvDpCUg4gt6faFF3uI7l
 atJagLfQBR/FWxZGikUgyK6UfAEFSXUbDSma2tuoF69UrI9HraEOjGFAuWmAs++0ixKj nA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dqhycgcsm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:21:12 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20L5K9uZ170148;
        Fri, 21 Jan 2022 05:21:11 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2174.outbound.protection.outlook.com [104.47.73.174])
        by userp3020.oracle.com with ESMTP id 3dqj0mawx6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:21:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fAYnFfminEsOJ0Yn6AO+V5vqNXCJHuEEPLA4k/hSYjMKv9X3/NrqCYwNFUV6tMsWMBZsVdmZ7u1Ug9s2K5sZrY4jIV7BNXi5dvLlIYP1cU4UPLcZ3RgX2XJHuIB24TWIqz3EHUEPKvEt60Kn5J9xFMXIbRVRVHNT5bAiLZh3dEf6+NfnxQJgBk9hGqdpXaQmBmZ07rO4wBFikneb1HKUPmJycgLtkWJB5El5E/kWq6t0M+jyyNA4e46fH4UJ1b4pHL8ZOOzjHmlY8tJaP6HmCMRSOd7THY5S+N44hafErn6l7O3F+y9xhicsjMrDnYiFgaQC+K1dF76Jy+Bq7m6Smg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n0M5/Q4ppUpGKV3LXPfoNMftjm8s8AXc1pre0rd1EBQ=;
 b=oCSSXZpPnvws4jT6J9kcADLD/jyxYTiaqufZg54MFKvN0r+ketMaA1ouWjYMbKJ8HxKuqQ9MwXLEsYnHRX0RHF9I4wd8O9hL/urHjDUVydvp8ZboGWlFABEi/fnk5VS4zBjEDeWubNVN3GSxLHDxZ1CsBp56JT+2TRLfEYeDF14jxVmP6mzyPC3yeO5gP3BT3BQ3N2N7ctb5fAat9ATVpDQPPWNKyyzqB6JUQm08W0w7bJ+/izUWOrWnxVcOS88FXgYCob2fkq4tv5xSP3pdwIDytxLv1cZfOTAf1NOxPFPmWxdpi1KNyHUwdvowqznaegWOmn/0WIKaMjx0Mf7kiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n0M5/Q4ppUpGKV3LXPfoNMftjm8s8AXc1pre0rd1EBQ=;
 b=oFgkoMmPx9PLnqvkPU29JYas/62NJ7xAr2WLW9bPzrKVurReRJQsFiqIwpiyWD9KEGqfisICIZayYkoUadZMRLXcZNZdMoNtCD7Fp3TFqN3KFg0Gxx8aUazOJtR3SrkOLlDT37deC+V9ghNlh3B3NpBDIEV56Y2/+dIrotM7kFg=
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com (2603:10b6:a03:2d0::16)
 by CH0PR10MB5322.namprd10.prod.outlook.com (2603:10b6:610:c1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Fri, 21 Jan
 2022 05:21:08 +0000
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b]) by SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b%3]) with mapi id 15.20.4909.011; Fri, 21 Jan 2022
 05:21:08 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com, Dave Chinner <dchinner@redhat.com>
Subject: [PATCH V5 13/20] xfsprogs: Introduce per-inode 64-bit extent counters
Date:   Fri, 21 Jan 2022 10:50:12 +0530
Message-Id: <20220121052019.224605-14-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220121052019.224605-1-chandan.babu@oracle.com>
References: <20220121052019.224605-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0049.apcprd02.prod.outlook.com
 (2603:1096:4:54::13) To SJ0PR10MB4589.namprd10.prod.outlook.com
 (2603:10b6:a03:2d0::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b118b5b3-1c13-4ea2-eae9-08d9dc9dd390
X-MS-TrafficTypeDiagnostic: CH0PR10MB5322:EE_
X-Microsoft-Antispam-PRVS: <CH0PR10MB53221249152AE6D647A01FE6F65B9@CH0PR10MB5322.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B1DF6+N+ff4uWhO6Wv2n/zg3ay7xxgiPBY59DUnZ2e17BDfvwTHXyZiaoSvoMSxoTgXC4gP0tvkDHCSlK5ojMQ9zxHmRh/9zAsqi21SosZnSDgTbG5UXa0nDXNVdfFu+dhfJAT3aFcX2mbw9f7+TiOdIyvpAPs3H87Ti73pfBTffk1dT6p+zqI6MHOHuZN0lo6RDIdzJCJrUOn360Za+4vYkohImkQo/OpWMIFFAzlBDvY7eSci2N3vysIysBCGexrLm01mbviGPH5MDKJiKsXc+w3d69OQIW6sJBYSZg/eFY3Gq4FFJCpO+KDkskFtjwOsiRlPTudfaQJTv9RtwdIPcf8miWi0P1eoIxe6gueLNWp7gR/oX1ACLfuifqCyvSWTiepytcH1twmxT82DmeXMnyK8heuGJmm2lr/krq+DEECjAfAVaGF7Nj62LUfInIBnl0aVpysMTvq0IqnfXJvJe1LqN0xYNGXPZ3P4xtqnNlhUrXSJxB5Ob28p9tW9QcFarOynLdGB8j6VxiQNB5iituCEdTQXzQRFkCLwMxixu+24hWM3T/VeJiMHrTrOnfihOuDeufj6br6ER6eF+bB/kb3tmAfqVC8bexGfghBJRs0+yDLz65tqN2VzbEauOLZ8aRgN4GSsqQcxzd9xx1EDiEVdXtC2uUq5iKON58Hc2PnNRYwrOdFRVwsAMQWIGvWy8UJ+Gxywq5BD/j4uejw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4589.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(4326008)(316002)(8936002)(36756003)(38350700002)(38100700002)(6916009)(1076003)(2906002)(508600001)(6506007)(66946007)(30864003)(66556008)(66476007)(83380400001)(5660300002)(54906003)(6512007)(8676002)(6486002)(86362001)(52116002)(6666004)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?W6SOfPW2sST38E8ROg7QWI4121Cv0OtO2K1doGLBtqTZmOUFx67YiBSL9AmP?=
 =?us-ascii?Q?HA3qQ7ChNxJ5VGXISKSROQsZoUZyiudWq/n8FopAWCSqZ9O276A3SamabBCs?=
 =?us-ascii?Q?xT5VsaoJAi9dVz5R7elzI1WdVstvms3r271YQcUd/qK89J/WDDLSsECSpOXg?=
 =?us-ascii?Q?pfY4HX162GZFMrTlSpALn3m1Gff7cy4wjlMbzf0h2FK2jYL4oXAJADeuowj7?=
 =?us-ascii?Q?dvAQFVyGROJ8LWtgWBl7d+28D++9TE0VYMmlIhqWEs+SP1hN3CYhlwdb3iw1?=
 =?us-ascii?Q?2A6FvWpH1S3soSOCjw/gj51AlwSTxSlIwin8XgIENDCgT3b9jWmKGxnAnoy1?=
 =?us-ascii?Q?J31xmnJLEhp7Zpnl7afFBA7SeCNqnM5tdLT5FhGDwO7s5z47K90Mmu5jLpnx?=
 =?us-ascii?Q?PT7SYH8ZQK87Hv8XogZz7PYtWjWOwl3pvVtojQcR4NkaGfxEziFmhX8ocrqs?=
 =?us-ascii?Q?gP7pBKg//OgVhnxS/zmjINl16+aevZC8l3+/LWKkf/zkLR5ZBD4fzHeOooV5?=
 =?us-ascii?Q?dCKBLAxqc98fovzPMwBrWP1V/bJge864/HaqR8oAyZrgOvSMxIEsPRdnkTTP?=
 =?us-ascii?Q?QxAiMwGWq5aBLAI3KIiZhHbftcuLrt0J+UFbT/3ukg1SXcPMfhu52vzbxRX/?=
 =?us-ascii?Q?aou8cxlgwVrpWsxEpn3mh3R53sLW7BUmE3G19Kvym1Fi2F06mpztjEU4iCru?=
 =?us-ascii?Q?i0eq5EdEJ/6nhymlv9IFmz4F6vvkMjkrvsFKTYszFWS0xUgKk4JmZviF5mPB?=
 =?us-ascii?Q?eQb1815tb+3zteHMEaAv7uJyUEIJ4E/IvMwowsBWhISFvF+z1/qRJHMMTe+n?=
 =?us-ascii?Q?W+rGGcqZlG/jQV1x/LODE26i13JOztSzFTO8qzveXQflU40ryKBz8CgXMjqy?=
 =?us-ascii?Q?qv+0VIbSVl2BKfiCxmgCqWmzfGkkxrmH6vxJs53cUKp9SNc5GlvFQTUTrM+u?=
 =?us-ascii?Q?A9R9AgwJrwMnfpkYLrV44XmQMjHPLu/hYFgEFCJ8M8NMUGekcVdVvryfNC7M?=
 =?us-ascii?Q?GvY538RAuDTtddIog+MgBksgMzWMUhgTszglmR9QEEAG2Fv0Y291XRhPZ9Ca?=
 =?us-ascii?Q?Orzz8U4GciGQRhLvbR5LZjt+a7DM/Am5Xp3iIv3QAznvRxLqcmZWyKye85n/?=
 =?us-ascii?Q?gamcovloYk5CIK4RrJOXPwQ0hIzA48B6nNynsvIwZ/x+xx+WUnRSAuiEgjnh?=
 =?us-ascii?Q?U1oo5IVh/Sh5yAP1daaEf9q+xWX4XLKwUWrbGEl5TLpUNsoOylUqzqDA+vdm?=
 =?us-ascii?Q?IpJPUq1r5Q5c9TWsgB+3lA5pP8+IwacdxbKG8GmJWpjdichEFyBF68LU5o8x?=
 =?us-ascii?Q?9Ghv3YL8JCm4UzXvkcxsUBpQvmrSbQaJKsHwEV1MqIPgKggTkRhPLQFpv4Xm?=
 =?us-ascii?Q?KfXHQMvxoSssCPJ0qOriyIFyWA0CBopHO6b/857K10L/7ZS09P2n+5B7XOLW?=
 =?us-ascii?Q?AQvbdc/jqhFChFYjWJyJAFDF2zD/EX2ERS9WJByJyWG5aVdjgFNrh+eFcW8G?=
 =?us-ascii?Q?I93jDBs6M/QvUfMZdDie8xRTXQoOEhHpQ76pbeCNEG40wU1OfsQb7OnIlhZv?=
 =?us-ascii?Q?WxC6JBKsgUoCfVkVOPR/euRnNwBdjgmIGjPR+1QWpsfhVumjAFJIaHFeZ9+d?=
 =?us-ascii?Q?vLEE1p3jj4eNKRGUqIeUYQw=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b118b5b3-1c13-4ea2-eae9-08d9dc9dd390
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4589.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2022 05:21:08.4716
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hXbm6lL+Cp0L/F0V1Z+pR7TxH+1AhFf+NxUgrc8vb1VQPAFKAspfNehfcvWzYQcaxKEEV7lMwZehrHOkQI4O2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5322
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10233 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201210038
X-Proofpoint-ORIG-GUID: dSKAbdNYKYJMuZ6OWCPbqoo4FEBMF_OZ
X-Proofpoint-GUID: dSKAbdNYKYJMuZ6OWCPbqoo4FEBMF_OZ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit introduces new fields in the on-disk inode format to support
64-bit data fork extent counters and 32-bit attribute fork extent
counters. The new fields will be used only when an inode has
XFS_DIFLAG2_NREXT64 flag set. Otherwise we continue to use the regular 32-bit
data fork extent counters and 16-bit attribute fork extent counters.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Suggested-by: Dave Chinner <dchinner@redhat.com>
---
 db/field.c               |   4 -
 db/field.h               |   2 -
 db/inode.c               | 205 ++++++++++++++++++++++++++++++++++++++-
 libxfs/xfs_format.h      |  22 ++++-
 libxfs/xfs_inode_buf.c   |  27 +++++-
 libxfs/xfs_inode_fork.h  |   6 ++
 libxfs/xfs_log_format.h  |  22 ++++-
 logprint/log_misc.c      |  20 +++-
 logprint/log_print_all.c |  18 +++-
 repair/dinode.c          |  18 +++-
 10 files changed, 312 insertions(+), 32 deletions(-)

diff --git a/db/field.c b/db/field.c
index 0a089b56..e2da7a6f 100644
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
index a9e6cc70..45ac1a89 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -27,6 +27,16 @@ static int	inode_core_nlinkv2_count(void *obj, int startoff);
 static int	inode_core_onlink_count(void *obj, int startoff);
 static int	inode_core_projid_count(void *obj, int startoff);
 static int	inode_core_nlinkv1_count(void *obj, int startoff);
+static int	inode_core_v3_pad_count(void *obj, int startoff);
+static int	inode_core_v2_pad_count(void *obj, int startoff);
+static int	inode_core_flushiter_count(void *obj, int startoff);
+static int	inode_core_nrext64_pad_count(void *obj, int startoff);
+static int	inode_core_nextents_offset(void *obj, int startoff, int idx);
+static int	inode_core_nextents32_count(void *obj, int startoff);
+static int	inode_core_nextents64_count(void *obj, int startoff);
+static int	inode_core_anextents_offset(void *obj, int startoff, int idx);
+static int	inode_core_anextents16_count(void *obj, int startoff);
+static int	inode_core_anextents32_count(void *obj, int startoff);
 static int	inode_f(int argc, char **argv);
 static int	inode_u_offset(void *obj, int startoff, int idx);
 static int	inode_u_bmbt_count(void *obj, int startoff);
@@ -90,18 +100,30 @@ const field_t	inode_core_flds[] = {
 	  inode_core_projid_count, FLD_COUNT, TYP_NONE },
 	{ "projid_hi", FLDT_UINT16D, OI(COFF(projid_hi)),
 	  inode_core_projid_count, FLD_COUNT, TYP_NONE },
-	{ "pad", FLDT_UINT8X, OI(OFF(pad)), CI(6), FLD_ARRAY|FLD_SKIPALL, TYP_NONE },
+	{ "v3_pad", FLDT_UINT8X, OI(OFF(v3_pad)),
+	  inode_core_v3_pad_count, FLD_ARRAY|FLD_COUNT|FLD_SKIPALL, TYP_NONE },
+	{ "v2_pad", FLDT_UINT8X, OI(OFF(v2_pad)),
+	  inode_core_v2_pad_count, FLD_ARRAY|FLD_COUNT|FLD_SKIPALL, TYP_NONE },
 	{ "uid", FLDT_UINT32D, OI(COFF(uid)), C1, 0, TYP_NONE },
 	{ "gid", FLDT_UINT32D, OI(COFF(gid)), C1, 0, TYP_NONE },
-	{ "flushiter", FLDT_UINT16D, OI(COFF(flushiter)), C1, 0, TYP_NONE },
+	{ "flushiter", FLDT_UINT16D, OI(COFF(flushiter)),
+	  inode_core_flushiter_count, FLD_COUNT, TYP_NONE },
 	{ "atime", FLDT_TIMESTAMP, OI(COFF(atime)), C1, 0, TYP_NONE },
 	{ "mtime", FLDT_TIMESTAMP, OI(COFF(mtime)), C1, 0, TYP_NONE },
 	{ "ctime", FLDT_TIMESTAMP, OI(COFF(ctime)), C1, 0, TYP_NONE },
 	{ "size", FLDT_FSIZE, OI(COFF(size)), C1, 0, TYP_NONE },
 	{ "nblocks", FLDT_DRFSBNO, OI(COFF(nblocks)), C1, 0, TYP_NONE },
 	{ "extsize", FLDT_EXTLEN, OI(COFF(extsize)), C1, 0, TYP_NONE },
-	{ "nextents", FLDT_EXTNUM, OI(COFF(nextents)), C1, 0, TYP_NONE },
-	{ "naextents", FLDT_AEXTNUM, OI(COFF(anextents)), C1, 0, TYP_NONE },
+	{ "nrext64_pad", FLDT_UINT16D, OI(COFF(nrext64_pad)),
+	  inode_core_nrext64_pad_count, FLD_COUNT|FLD_SKIPALL, TYP_NONE },
+	{ "nextents", FLDT_UINT32D, inode_core_nextents_offset,
+	  inode_core_nextents32_count, FLD_OFFSET|FLD_COUNT, TYP_NONE },
+	{ "nextents", FLDT_UINT64D, inode_core_nextents_offset,
+	  inode_core_nextents64_count, FLD_OFFSET|FLD_COUNT, TYP_NONE },
+	{ "naextents", FLDT_UINT16D, inode_core_anextents_offset,
+	  inode_core_anextents16_count, FLD_OFFSET|FLD_COUNT, TYP_NONE },
+	{ "naextents", FLDT_UINT32D, inode_core_anextents_offset,
+	  inode_core_anextents32_count, FLD_OFFSET|FLD_COUNT, TYP_NONE },
 	{ "forkoff", FLDT_UINT8D, OI(COFF(forkoff)), C1, 0, TYP_NONE },
 	{ "aformat", FLDT_DINODE_FMT, OI(COFF(aformat)), C1, 0, TYP_NONE },
 	{ "dmevmask", FLDT_UINT32X, OI(COFF(dmevmask)), C1, 0, TYP_NONE },
@@ -403,6 +425,181 @@ inode_core_projid_count(
 	return dic->di_version >= 2;
 }
 
+static int
+inode_core_v3_pad_count(
+	void			*obj,
+	int			startoff)
+{
+	struct xfs_dinode	*dic;
+
+	ASSERT(startoff == 0);
+	ASSERT(obj == iocur_top->data);
+	dic = obj;
+
+	if ((dic->di_version == 3)
+		&& !(dic->di_flags2 & cpu_to_be64(XFS_DIFLAG2_NREXT64)))
+		return 8;
+
+	return 0;
+}
+
+static int
+inode_core_v2_pad_count(
+	void			*obj,
+	int			startoff)
+{
+	struct xfs_dinode	*dic;
+
+	ASSERT(startoff == 0);
+	ASSERT(obj == iocur_top->data);
+	dic = obj;
+
+	if (dic->di_version == 3)
+		return 0;
+
+	return 6;
+}
+
+static int
+inode_core_flushiter_count(
+	void			*obj,
+	int			startoff)
+{
+	struct xfs_dinode	*dic;
+
+	ASSERT(startoff == 0);
+	ASSERT(obj == iocur_top->data);
+	dic = obj;
+
+	if (dic->di_version == 3)
+		return 0;
+
+	return 1;
+}
+
+static int
+inode_core_nrext64_pad_count(
+	void			*obj,
+	int			startoff)
+{
+	struct xfs_dinode	*dic;
+
+	ASSERT(startoff == 0);
+	ASSERT(obj == iocur_top->data);
+	dic = obj;
+
+	if (xfs_dinode_has_nrext64(dic))
+		return 1;
+
+	return 0;
+}
+
+static int
+inode_core_nextents_offset(
+	void			*obj,
+	int			startoff,
+	int			idx)
+{
+	struct xfs_dinode	*dic;
+
+	ASSERT(startoff == 0);
+	ASSERT(idx == 0);
+	ASSERT(obj == iocur_top->data);
+	dic = obj;
+
+	if (xfs_dinode_has_nrext64(dic))
+		return COFF(big_nextents);
+
+	return COFF(nextents);
+}
+
+static int
+inode_core_nextents32_count(
+	void			*obj,
+	int			startoff)
+{
+	struct xfs_dinode	*dic;
+
+	ASSERT(startoff == 0);
+	ASSERT(obj == iocur_top->data);
+	dic = obj;
+
+	if (xfs_dinode_has_nrext64(dic))
+		return 0;
+
+	return 1;
+}
+
+static int
+inode_core_nextents64_count(
+	void			*obj,
+	int			startoff)
+{
+	struct xfs_dinode	*dic;
+
+	ASSERT(startoff == 0);
+	ASSERT(obj == iocur_top->data);
+	dic = obj;
+
+	if (xfs_dinode_has_nrext64(dic))
+		return 1;
+
+	return 0;
+}
+
+static int
+inode_core_anextents_offset(
+	void			*obj,
+	int			startoff,
+	int			idx)
+{
+	struct xfs_dinode	*dic;
+
+	ASSERT(startoff == 0);
+	ASSERT(idx == 0);
+	ASSERT(obj == iocur_top->data);
+	dic = obj;
+
+	if (xfs_dinode_has_nrext64(dic))
+		return COFF(big_anextents);
+
+	return COFF(anextents);
+}
+
+static int
+inode_core_anextents16_count(
+	void			*obj,
+	int			startoff)
+{
+	struct xfs_dinode	*dic;
+
+	ASSERT(startoff == 0);
+	ASSERT(obj == iocur_top->data);
+	dic = obj;
+
+	if (xfs_dinode_has_nrext64(dic))
+		return 0;
+
+	return 1;
+}
+
+static int
+inode_core_anextents32_count(
+	void			*obj,
+	int			startoff)
+{
+	struct xfs_dinode	*dic;
+
+	ASSERT(startoff == 0);
+	ASSERT(obj == iocur_top->data);
+	dic = obj;
+
+	if (xfs_dinode_has_nrext64(dic))
+		return 1;
+
+	return 0;
+}
+
 static int
 inode_f(
 	int		argc,
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index d3dfd45c..df1d6ec3 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -792,16 +792,30 @@ struct xfs_dinode {
 	__be32		di_nlink;	/* number of links to file */
 	__be16		di_projid_lo;	/* lower part of owner's project id */
 	__be16		di_projid_hi;	/* higher part owner's project id */
-	__u8		di_pad[6];	/* unused, zeroed space */
-	__be16		di_flushiter;	/* incremented on flush */
+	union {
+		__be64	di_big_nextents;/* NREXT64 data extents */
+		__u8	di_v3_pad[8];	/* !NREXT64 V3 inode zeroed space */
+		struct {
+			__u8	di_v2_pad[6];	/* V2 inode zeroed space */
+			__be16	di_flushiter;	/* V2 inode incremented on flush */
+		};
+	};
 	xfs_timestamp_t	di_atime;	/* time last accessed */
 	xfs_timestamp_t	di_mtime;	/* time last modified */
 	xfs_timestamp_t	di_ctime;	/* time created/inode modified */
 	__be64		di_size;	/* number of bytes in file */
 	__be64		di_nblocks;	/* # of direct & btree blocks used */
 	__be32		di_extsize;	/* basic/minimum extent size for file */
-	__be32		di_nextents;	/* number of extents in data fork */
-	__be16		di_anextents;	/* number of extents in attribute fork*/
+	union {
+		struct {
+			__be32	di_big_anextents; /* NREXT64 attr extents */
+			__be16	di_nrext64_pad; /* NREXT64 unused, zero */
+		} __packed;
+		struct {
+			__be32	di_nextents;	/* !NREXT64 data extents */
+			__be16	di_anextents;	/* !NREXT64 attr extents */
+		} __packed;
+	};
 	__u8		di_forkoff;	/* attr fork offs, <<3 for 64b align */
 	__s8		di_aformat;	/* format of attr fork's data */
 	__be32		di_dmevmask;	/* DMIG event mask */
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index b3f6be93..9db63db9 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -276,6 +276,25 @@ xfs_inode_to_disk_ts(
 	return ts;
 }
 
+static inline void
+xfs_inode_to_disk_iext_counters(
+	struct xfs_inode	*ip,
+	struct xfs_dinode	*to)
+{
+	if (xfs_inode_has_nrext64(ip)) {
+		to->di_big_nextents = cpu_to_be64(xfs_ifork_nextents(&ip->i_df));
+		to->di_big_anextents = cpu_to_be32(xfs_ifork_nextents(ip->i_afp));
+		/*
+		 * We might be upgrading the inode to use larger extent counters
+		 * than was previously used. Hence zero the unused field.
+		 */
+		to->di_nrext64_pad = cpu_to_be16(0);
+	} else {
+		to->di_nextents = cpu_to_be32(xfs_ifork_nextents(&ip->i_df));
+		to->di_anextents = cpu_to_be16(xfs_ifork_nextents(ip->i_afp));
+	}
+}
+
 void
 xfs_inode_to_disk(
 	struct xfs_inode	*ip,
@@ -293,7 +312,6 @@ xfs_inode_to_disk(
 	to->di_projid_lo = cpu_to_be16(ip->i_projid & 0xffff);
 	to->di_projid_hi = cpu_to_be16(ip->i_projid >> 16);
 
-	memset(to->di_pad, 0, sizeof(to->di_pad));
 	to->di_atime = xfs_inode_to_disk_ts(ip, inode->i_atime);
 	to->di_mtime = xfs_inode_to_disk_ts(ip, inode->i_mtime);
 	to->di_ctime = xfs_inode_to_disk_ts(ip, inode->i_ctime);
@@ -304,8 +322,6 @@ xfs_inode_to_disk(
 	to->di_size = cpu_to_be64(ip->i_disk_size);
 	to->di_nblocks = cpu_to_be64(ip->i_nblocks);
 	to->di_extsize = cpu_to_be32(ip->i_extsize);
-	to->di_nextents = cpu_to_be32(xfs_ifork_nextents(&ip->i_df));
-	to->di_anextents = cpu_to_be16(xfs_ifork_nextents(ip->i_afp));
 	to->di_forkoff = ip->i_forkoff;
 	to->di_aformat = xfs_ifork_format(ip->i_afp);
 	to->di_flags = cpu_to_be16(ip->i_diflags);
@@ -320,11 +336,14 @@ xfs_inode_to_disk(
 		to->di_lsn = cpu_to_be64(lsn);
 		memset(to->di_pad2, 0, sizeof(to->di_pad2));
 		uuid_copy(&to->di_uuid, &ip->i_mount->m_sb.sb_meta_uuid);
-		to->di_flushiter = 0;
+		memset(to->di_v3_pad, 0, sizeof(to->di_v3_pad));
 	} else {
 		to->di_version = 2;
 		to->di_flushiter = cpu_to_be16(ip->i_flushiter);
+		memset(to->di_v2_pad, 0, sizeof(to->di_v2_pad));
 	}
+
+	xfs_inode_to_disk_iext_counters(ip, to);
 }
 
 static xfs_failaddr_t
diff --git a/libxfs/xfs_inode_fork.h b/libxfs/xfs_inode_fork.h
index e5680343..8e6221e3 100644
--- a/libxfs/xfs_inode_fork.h
+++ b/libxfs/xfs_inode_fork.h
@@ -156,6 +156,9 @@ static inline xfs_extnum_t
 xfs_dfork_data_extents(
 	struct xfs_dinode	*dip)
 {
+	if (xfs_dinode_has_nrext64(dip))
+		return be64_to_cpu(dip->di_big_nextents);
+
 	return be32_to_cpu(dip->di_nextents);
 }
 
@@ -163,6 +166,9 @@ static inline xfs_extnum_t
 xfs_dfork_attr_extents(
 	struct xfs_dinode	*dip)
 {
+	if (xfs_dinode_has_nrext64(dip))
+		return be32_to_cpu(dip->di_big_anextents);
+
 	return be16_to_cpu(dip->di_anextents);
 }
 
diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index fd66e702..8dcd53fd 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -388,16 +388,30 @@ struct xfs_log_dinode {
 	uint32_t	di_nlink;	/* number of links to file */
 	uint16_t	di_projid_lo;	/* lower part of owner's project id */
 	uint16_t	di_projid_hi;	/* higher part of owner's project id */
-	uint8_t		di_pad[6];	/* unused, zeroed space */
-	uint16_t	di_flushiter;	/* incremented on flush */
+	union {
+		uint64_t	di_big_nextents;/* NREXT64 data extents */
+		uint8_t		di_v3_pad[8];	/* !NREXT64 V3 inode zeroed space */
+		struct {
+			uint8_t	di_v2_pad[6];	/* V2 inode zeroed space */
+			uint16_t di_flushiter;	/* V2 inode incremented on flush */
+		};
+	};
 	xfs_log_timestamp_t di_atime;	/* time last accessed */
 	xfs_log_timestamp_t di_mtime;	/* time last modified */
 	xfs_log_timestamp_t di_ctime;	/* time created/inode modified */
 	xfs_fsize_t	di_size;	/* number of bytes in file */
 	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
 	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
-	uint32_t	di_nextents;	/* number of extents in data fork */
-	uint16_t	di_anextents;	/* number of extents in attribute fork*/
+	union {
+		struct {
+			uint32_t  di_big_anextents; /* NREXT64 attr extents */
+			uint16_t  di_nrext64_pad; /* NREXT64 unused, zero */
+		} __packed;
+		struct {
+			uint32_t  di_nextents;    /* !NREXT64 data extents */
+			uint16_t  di_anextents;   /* !NREXT64 attr extents */
+		} __packed;
+	};
 	uint8_t		di_forkoff;	/* attr fork offs, <<3 for 64b align */
 	int8_t		di_aformat;	/* format of attr fork's data */
 	uint32_t	di_dmevmask;	/* DMIG event mask */
diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index 35e926a3..95fb22a6 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -440,6 +440,8 @@ static void
 xlog_print_trans_inode_core(
 	struct xfs_log_dinode	*ip)
 {
+    xfs_extnum_t		nextents;
+
     printf(_("INODE CORE\n"));
     printf(_("magic 0x%hx mode 0%ho version %d format %d\n"),
 	   ip->di_magic, ip->di_mode, (int)ip->di_version,
@@ -450,11 +452,21 @@ xlog_print_trans_inode_core(
 		xlog_extract_dinode_ts(ip->di_atime),
 		xlog_extract_dinode_ts(ip->di_mtime),
 		xlog_extract_dinode_ts(ip->di_ctime));
-    printf(_("size 0x%llx nblocks 0x%llx extsize 0x%x nextents 0x%x\n"),
+
+    if (ip->di_flags2 & XFS_DIFLAG2_NREXT64)
+	    nextents = ip->di_big_nextents;
+    else
+	    nextents = ip->di_nextents;
+    printf(_("size 0x%llx nblocks 0x%llx extsize 0x%x nextents 0x%lx\n"),
 	   (unsigned long long)ip->di_size, (unsigned long long)ip->di_nblocks,
-	   ip->di_extsize, ip->di_nextents);
-    printf(_("naextents 0x%x forkoff %d dmevmask 0x%x dmstate 0x%hx\n"),
-	   ip->di_anextents, (int)ip->di_forkoff, ip->di_dmevmask,
+	   ip->di_extsize, nextents);
+
+    if (ip->di_flags2 & XFS_DIFLAG2_NREXT64)
+	    nextents = ip->di_big_anextents;
+    else
+	    nextents = ip->di_anextents;
+    printf(_("naextents 0x%lx forkoff %d dmevmask 0x%x dmstate 0x%hx\n"),
+	   nextents, (int)ip->di_forkoff, ip->di_dmevmask,
 	   ip->di_dmstate);
     printf(_("flags 0x%x gen 0x%x\n"),
 	   ip->di_flags, ip->di_gen);
diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
index 182b9d53..73ffc2f0 100644
--- a/logprint/log_print_all.c
+++ b/logprint/log_print_all.c
@@ -240,7 +240,10 @@ STATIC void
 xlog_recover_print_inode_core(
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
@@ -254,10 +257,19 @@ xlog_recover_print_inode_core(
 			xlog_extract_dinode_ts(di->di_mtime),
 			xlog_extract_dinode_ts(di->di_ctime));
 	printf(_("		flushiter:%d\n"), di->di_flushiter);
+
+	if (di->di_flags2 & XFS_DIFLAG2_NREXT64) {
+		nextents = di->di_big_nextents;
+		anextents = di->di_big_anextents;
+	} else {
+		nextents = di->di_nextents;
+		anextents = di->di_anextents;
+	}
+
 	printf(_("		size:0x%llx  nblks:0x%llx  exsize:%d  "
-	     "nextents:%d  anextents:%d\n"), (unsigned long long)
+	     "nextents:%lu  anextents:%u\n"), (unsigned long long)
 	       di->di_size, (unsigned long long)di->di_nblocks,
-	       di->di_extsize, di->di_nextents, (int)di->di_anextents);
+	       di->di_extsize, nextents, anextents);
 	printf(_("		forkoff:%d  dmevmask:0x%x  dmstate:%d  flags:0x%x  "
 	     "gen:%u\n"),
 	       (int)di->di_forkoff, di->di_dmevmask, (int)di->di_dmstate,
diff --git a/repair/dinode.c b/repair/dinode.c
index 54efe571..bf1ee26d 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -71,7 +71,12 @@ _("would have cleared inode %" PRIu64 " attributes\n"), ino_num);
 	if (xfs_dfork_attr_extents(dino) != 0) {
 		if (no_modify)
 			return(1);
-		dino->di_anextents = cpu_to_be16(0);
+
+		if (xfs_dinode_has_nrext64(dino))
+			dino->di_big_anextents = 0;
+		else
+			dino->di_anextents = 0;
+
 	}
 
 	if (dino->di_aformat != XFS_DINODE_FMT_EXTENTS)  {
@@ -1818,7 +1823,10 @@ _("too many data fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
 			do_warn(
 _("correcting nextents for inode %" PRIu64 ", was %lu - counted %" PRIu64 "\n"),
 				lino, dnextents, nextents);
-			dino->di_nextents = cpu_to_be32(nextents);
+			if (xfs_dinode_has_nrext64(dino))
+				dino->di_big_nextents = cpu_to_be64(nextents);
+			else
+				dino->di_nextents = cpu_to_be32(nextents);
 			*dirty = 1;
 		} else  {
 			do_warn(
@@ -1841,7 +1849,11 @@ _("too many attr fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
 			do_warn(
 _("correcting anextents for inode %" PRIu64 ", was %lu - counted %" PRIu64 "\n"),
 				lino, dnextents, anextents);
-			dino->di_anextents = cpu_to_be16(anextents);
+			if (xfs_dinode_has_nrext64(dino))
+				dino->di_big_anextents = cpu_to_be32(anextents);
+			else
+				dino->di_anextents = cpu_to_be16(anextents);
+
 			*dirty = 1;
 		} else  {
 			do_warn(
-- 
2.30.2

