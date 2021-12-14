Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F108C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Dec 2021 08:50:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbhLNIuN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Dec 2021 03:50:13 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:62062 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229577AbhLNIuM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Dec 2021 03:50:12 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BE7mv76005512;
        Tue, 14 Dec 2021 08:50:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=NuY4BFF036boyOImtMYIuMRaRZSoCiHJ1JNEpc0oahM=;
 b=gvYEblRhF7gpc06qLMuxaS1wNr8dSecxsa2hCXf8l5tKAPbSyqsoCGBjpPnN0H0GaB2F
 tt9J8FBPU3EXNIavMjs+EQK6QmAVtYVYZLXQocPUGr4XxMUYvz9NTrMSgBeydODCkB9W
 1owtAr+ObTgpyfVS1t7bJhyHXXxLvJvuLpJHcdG7tDJQtAZHPlZbQuu3A4pyWdPMjBoC
 6Q350iFWENPJQXzL3tXEl7PGzDMSkiK8Ux7k9iwpG3TLROLa86bMh3FN1YXqajnLdy8X
 hlU0NVT1k2oQUCSUxSaemUYrPa4pbtXLG9+4M8kkORRWCb1LF3xaP8/OmQZ+uoInJrS4 yw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cx56u2sxa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:50:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BE8eSHt074180;
        Tue, 14 Dec 2021 08:50:06 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by aserp3020.oracle.com with ESMTP id 3cxmr9yjp8-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:50:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VZtwMH/dSmLYUPieOEkLZlb1rn37RqZVrZ+5MJuh4LprNsCu43fjl+UI73QB8oRVwtlJVLWWDvLfoM/Q5Cci8XUTi7JHKMj/ZU/V40cbQNb0wcom+q7dXuHyXXS/+O8ml77gBh/lS1tzf0yO/pdMFyLbbSBbdvv/Lmw9JF9lvyRDokKoMzvC4Y3R+5X9xlSitbrQXmX7n0g569j7TZEelwRHhUhQ3pVuerQjpcBQYXQcAIjdZIIR8tXDXm8GGQJLdRSPlEPCSTh8gBZUoYoPaJTwnuhm2PNco2ytp9gBUXmKRG9FLvKjYgszEG96M8q2V6IwErG+oEfBBERaE6mmsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NuY4BFF036boyOImtMYIuMRaRZSoCiHJ1JNEpc0oahM=;
 b=Lb7Q2HYDdF3897B5/zn6TjO0OB/wO8EPvQMb2TFJSwzTjo8+xLMIzD0l8pdTfU+BMwNVW59YpR+kZSHuVl4JM7PywHQAGjiR7YPOFlsiT5GhP9PGt0nFPSNCGmorZ6HD3cCtk4Cxth/CFjTiMHp2X6TqSIulGYrC+Kw2cPeF4VoVbcUyOEIFdEqoTG466xTw+G8FDLuc946DCc1XO1YQOPef9Kybxp0LzdWNLISkZk3gQ9lq2of2yoe7ZtNC2GIvakN6mWtoEgFpHPWy23WIUWBIXC/VMx7iDE+O2MbTIxff6iBdw5GWB1HmMBlY5v6+5zYDajuOfgt4z8OskHn8wQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NuY4BFF036boyOImtMYIuMRaRZSoCiHJ1JNEpc0oahM=;
 b=dt2MAWVXi0FB4QNatuJQdJXQYiU3+5rCxYUlXMnP/owDi6lzJ/n1blAgtvcAX/ompR6Bs2baw7XDvVmju00fydUe5W7kBNi48NxioaGGrmJnYAx91a1lrGkIlogjqEfQTzCd0pDrP0I6HY6H9T4QctEAWSt3kxR4v5j84MdW2JE=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2656.namprd10.prod.outlook.com (2603:10b6:805:42::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.16; Tue, 14 Dec
 2021 08:50:04 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d%6]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 08:50:04 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com, Dave Chinner <dchinner@redhat.com>
Subject: [PATCH V4 13/20] xfsprogs: Introduce per-inode 64-bit extent counters
Date:   Tue, 14 Dec 2021 14:18:04 +0530
Message-Id: <20211214084811.764481-14-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211214084811.764481-1-chandan.babu@oracle.com>
References: <20211214084811.764481-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MAXPR0101CA0069.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::31) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 18c37830-bffa-47dd-ca1a-08d9bedeb8a1
X-MS-TrafficTypeDiagnostic: SN6PR10MB2656:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB265609646800CD4D617508DCF6759@SN6PR10MB2656.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qNk6CHKPSmZmbFvpIfxYiBIwBj/8qpJT09Csjx5Lzm26L2nIXg5rqVbEZkmYk2kswX5o44bKT1958XgNISLGLap+elU6n7wPgTWVchBf4Hf6xSsyKA4u2VTvYFs9VIRrUhwxTIQEYiUPff1stOyVWd0W0apLbcsLEhj9XimR5puSrrJWqGATk4fjSwTKQyxhvGjI8ZLyeAfRCF8DXKNDRY/FJCFZZl6aGy2hrGOhoSQxqgA70JsS5+Tu3CLmU8FzYABxOxjFTN7I4Yq0rCx/liHq/vOu1TbQMthS4ShBptLWmXv8nFcbgdZftr7Qtec8ttk+NRubJoMTXiA4pPg4Hg49C4FZF5DJu8+OsNjv1PRkovD2oOV7p9XfR0D8NuzZ7MLOYxILJdd0bvqIxs9E9Ym8H5jT9cZ7ss8O0q+c3cUJABgdVCX0usvmscx4TPWPzicu6goK3a59X66QtdZWretxZaet63pBUP8VJBlkIKgeTTRhAClynW4T0ZtbkbH22TGRUFvJpYZPlDgYmUiNL3vNjOV+CNZ6KrhZg+LJqc0TnoZCq+JcFGJ2uoI/pTJua6gGKpJNvcrUPAGe99Y06MtBLEVKSYhLuGhWh0rAIJ2bfw6G9j++cPXBnlHL8xo/QuWzqcOdw3WkI8jYJvQsscSF+cQdXCcEorDZpAFPCzSp3lFx/RwSS0c5GbxWqh7B
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6506007)(54906003)(508600001)(52116002)(86362001)(186003)(6512007)(8936002)(6916009)(66946007)(38100700002)(38350700002)(5660300002)(6486002)(316002)(8676002)(66556008)(66476007)(2906002)(1076003)(83380400001)(2616005)(36756003)(4326008)(30864003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nwmpaS+8JE95npmTwFXiWS1BoMCV2fZlbzVoAEiLpMWNTo5/1fzO3PcvW3Tk?=
 =?us-ascii?Q?XAN6dO6PqX39rC5LTp0yi3RIoyWd/0DfZfFxeRetCbj/xo+hQHuoNyD814io?=
 =?us-ascii?Q?vb/TslDo/lMGRUVcoc4e9IqVrq1ITEeG2bLirqHWS4Kda8kinZ42cOc0VKkA?=
 =?us-ascii?Q?853Nul21n+1sfnoPNTs69QUiN61LCO1PWh9zztBy+Rgw0Jl9tnGT+WO2sgiz?=
 =?us-ascii?Q?CDtAGl0v5+bOYbXfUJnPekJkef90n+0xRD0Gp7WkCd5HvEtLvRYiXRUwSaGZ?=
 =?us-ascii?Q?tydd6kddVgi7ocdjxmgmp1pzB99QeI/DQzVvdDOkt//YvkRzqEAomgKTDdl1?=
 =?us-ascii?Q?hI4Dz1mDazt64Cg/hPvmhHBRFKF7ySE/UoHD4uRsCej18lyrLxgL2k8dsU//?=
 =?us-ascii?Q?g8/1zuq76NrkvtjbNOobRyrqK4omUWV/vySUsRmX1WcoiqMHySO10EKOP5o7?=
 =?us-ascii?Q?BenMiv9EaZdimvlEYYUli/lFk8K4y9reA1uh+7UoXjfA2SY1+t278TlbkJ/C?=
 =?us-ascii?Q?rJaAMZQQIuh53+oyw2YhqG0WkBCzJXXO+jCIhQYb9cEnztVfX2832CX2kY+8?=
 =?us-ascii?Q?GUPrWN5O8rdJNA5UhWAdB+7QEmzahmpuVBuWPwBLBjXzaU9nrlWVUrt+y8RJ?=
 =?us-ascii?Q?89EKtA3IURFTUGoL6Tx4W0mYS+D2opdpV9PDTtUB+E3I7nTHO+5DbnEl+Z0W?=
 =?us-ascii?Q?2APUyBg9aQEoLv4E17a6U89CBaG6kJGtqI49/Yr5+WDZyVt47bwWh+llzIjI?=
 =?us-ascii?Q?EdG9vOd2iVjJZeCwkfL1VRRi3tN2/6Lcj9gwg86FypQlJ+b+yYMVIZ0Ov889?=
 =?us-ascii?Q?svqjq+OQFwxSXl6QE5Fbr+DLqi0v1jiAl7OCYsTDOeA3Ql2U4HZIFrp6bRME?=
 =?us-ascii?Q?KG0/DddbHZ8PJ1aZrebVYyAXsztUBkjmT0v8blPERWGOGXqxm1YtA6q6GnTy?=
 =?us-ascii?Q?OO8nhBOeRdu4xVa9T2k9spAEKL7F86dgSdlhH0Us27g1801JtW8Z+Rq9D4ky?=
 =?us-ascii?Q?TXXVOX1X0GZpFXkZvzkh8Jc9+PzmvsoyH+UE0qXgcu8DnbfDsap21aao/L44?=
 =?us-ascii?Q?2sg3ePJPuJTj8hKShaXHenmuy+V2+YwQbNLGDUY7+db59qxDbHW8blata+Ia?=
 =?us-ascii?Q?/8R04xB3zayzTvy9Hx+vo8bov+CbVqSmi8Ut+oxOhC9qJUKa8ONdoE8U3+Rz?=
 =?us-ascii?Q?x02J0/c/+MrDnISL3y87+ykoI+kwAACykW2fLs6/HRO/sr2Of/XNq5ras0xC?=
 =?us-ascii?Q?5uubRR0zD/caoqWvUA70d/PHT1SEPlnMDVvs2ONczOkdvjQDuEHP3ujhMks6?=
 =?us-ascii?Q?6byfOtlAL70kVz13+c8ZrP+wcYJaHftOygJt6oP1xTOesdnUROSQP+xsD7Z7?=
 =?us-ascii?Q?6agJuucyanyDZVa1wMy0drQB353T14otrCzIq8Fb2+249zLcsdOSOZQp7msn?=
 =?us-ascii?Q?zk4qN4BicLCeoxXAYxRWqMzPU7YtMtQTfcc2N+R/tlf/OInB1FUJiZCuekns?=
 =?us-ascii?Q?Lrh/HaJDENNXbND01/P12QbN7KlvkMd3dBnDj7Vm9Htpo6ikkx6pj2wCdxYN?=
 =?us-ascii?Q?GW71MXdjaxMkpULg3QkommO29eHBwF7EQrofNOs5N7+8p7BH5LRnqrzvD24M?=
 =?us-ascii?Q?nPdMRKU2AtNKDMkaRbzH7NQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18c37830-bffa-47dd-ca1a-08d9bedeb8a1
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 08:50:04.4351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e5Fe9KCcF5mijSvFEB99GGtnmms0SN5uWgl7VDTR/O2DTHm5GF34iiqH79LeN1IfFSRu6b7ufJXlu5r6HBAedg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2656
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10197 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112140049
X-Proofpoint-ORIG-GUID: uSenwqxnhWY69XVxQgtILqKtlR1oMEKD
X-Proofpoint-GUID: uSenwqxnhWY69XVxQgtILqKtlR1oMEKD
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
 db/inode.c               | 170 ++++++++++++++++++++++++++++++++++++++-
 libxfs/xfs_format.h      |  22 ++++-
 libxfs/xfs_inode_buf.c   |  27 ++++++-
 libxfs/xfs_inode_fork.h  |  10 ++-
 libxfs/xfs_log_format.h  |  22 ++++-
 logprint/log_misc.c      |  20 ++++-
 logprint/log_print_all.c |  18 ++++-
 repair/dinode.c          |  18 ++++-
 10 files changed, 279 insertions(+), 34 deletions(-)

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
index b1f92d36..226797be 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -27,6 +27,14 @@ static int	inode_core_nlinkv2_count(void *obj, int startoff);
 static int	inode_core_onlink_count(void *obj, int startoff);
 static int	inode_core_projid_count(void *obj, int startoff);
 static int	inode_core_nlinkv1_count(void *obj, int startoff);
+static int	inode_core_big_dextcnt_count(void *obj, int startoff);
+static int	inode_core_v3_pad_count(void *obj, int startoff);
+static int	inode_core_v2_pad_count(void *obj, int startoff);
+static int	inode_core_flushiter_count(void *obj, int startoff);
+static int	inode_core_big_aextcnt_count(void *obj, int startoff);
+static int	inode_core_nrext64_pad_count(void *obj, int startoff);
+static int	inode_core_nextents_count(void *obj, int startoff);
+static int	inode_core_anextents_count(void *obj, int startoff);
 static int	inode_f(int argc, char **argv);
 static int	inode_u_offset(void *obj, int startoff, int idx);
 static int	inode_u_bmbt_count(void *obj, int startoff);
@@ -90,18 +98,30 @@ const field_t	inode_core_flds[] = {
 	  inode_core_projid_count, FLD_COUNT, TYP_NONE },
 	{ "projid_hi", FLDT_UINT16D, OI(COFF(projid_hi)),
 	  inode_core_projid_count, FLD_COUNT, TYP_NONE },
-	{ "pad", FLDT_UINT8X, OI(OFF(pad)), CI(6), FLD_ARRAY|FLD_SKIPALL, TYP_NONE },
+	{ "big_dextcnt", FLDT_UINT64D, OI(COFF(big_dextcnt)),
+	  inode_core_big_dextcnt_count, FLD_COUNT, TYP_NONE },
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
+	{ "big_aextcnt", FLDT_UINT32D, OI(COFF(big_aextcnt)),
+	  inode_core_big_aextcnt_count, FLD_COUNT, TYP_NONE },
+	{ "nrext64_pad", FLDT_UINT16D, OI(COFF(nrext64_pad)),
+	  inode_core_nrext64_pad_count, FLD_COUNT, TYP_NONE },
+	{ "nextents", FLDT_UINT32D, OI(COFF(nextents)),
+	  inode_core_nextents_count, FLD_COUNT, TYP_NONE },
+	{ "naextents", FLDT_UINT16D, OI(COFF(anextents)),
+	  inode_core_anextents_count, FLD_COUNT, TYP_NONE },
 	{ "forkoff", FLDT_UINT8D, OI(COFF(forkoff)), C1, 0, TYP_NONE },
 	{ "aformat", FLDT_DINODE_FMT, OI(COFF(aformat)), C1, 0, TYP_NONE },
 	{ "dmevmask", FLDT_UINT32X, OI(COFF(dmevmask)), C1, 0, TYP_NONE },
@@ -403,6 +423,148 @@ inode_core_projid_count(
 	return dic->di_version >= 2;
 }
 
+static int
+inode_core_big_dextcnt_count(
+	void			*obj,
+	int			startoff)
+{
+	struct xfs_dinode	*dic;
+
+	ASSERT(startoff == 0);
+	ASSERT(obj == iocur_top->data);
+	dic = obj;
+
+	if (dic->di_version == 3 &&
+		(be64_to_cpu(dic->di_flags2) & XFS_DIFLAG2_NREXT64))
+		return 1;
+	else
+		return 0;
+}
+
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
+		&& !(be64_to_cpu(dic->di_flags2) & XFS_DIFLAG2_NREXT64))
+		return 8;
+	else
+		return 0;
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
+	else
+		return 6;
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
+	else
+		return 1;
+}
+
+static int
+inode_core_big_aextcnt_count(
+	void			*obj,
+	int			startoff)
+{
+	struct xfs_dinode	*dic;
+
+	ASSERT(startoff == 0);
+	ASSERT(obj == iocur_top->data);
+	dic = obj;
+
+	if (dic->di_version == 3 &&
+		(be64_to_cpu(dic->di_flags2) & XFS_DIFLAG2_NREXT64))
+		return 1;
+	else
+		return 0;
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
+	if (dic->di_version == 3 &&
+		(be64_to_cpu(dic->di_flags2) & XFS_DIFLAG2_NREXT64))
+		return 1;
+	else
+		return 0;
+}
+
+static int
+inode_core_nextents_count(
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
+		&& (be64_to_cpu(dic->di_flags2) & XFS_DIFLAG2_NREXT64))
+		return 0;
+	else
+		return 1;
+}
+
+static int
+inode_core_anextents_count(
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
+		&& (be64_to_cpu(dic->di_flags2) & XFS_DIFLAG2_NREXT64))
+		return 0;
+	else
+		return 1;
+}
+
 static int
 inode_f(
 	int		argc,
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index bdd13ec9..d4c962fc 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -980,16 +980,30 @@ typedef struct xfs_dinode {
 	__be32		di_nlink;	/* number of links to file */
 	__be16		di_projid_lo;	/* lower part of owner's project id */
 	__be16		di_projid_hi;	/* higher part owner's project id */
-	__u8		di_pad[6];	/* unused, zeroed space */
-	__be16		di_flushiter;	/* incremented on flush */
+	union {
+		__be64	di_big_dextcnt;	/* NREXT64 data extents */
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
+			__be32	di_big_aextcnt; /* NREXT64 attr extents */
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
index 9bddf790..5c6de73b 100644
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
+		to->di_big_dextcnt = cpu_to_be64(xfs_ifork_nextents(&ip->i_df));
+		to->di_big_aextcnt = cpu_to_be32(xfs_ifork_nextents(ip->i_afp));
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
index 7d5f0015..03036a2c 100644
--- a/libxfs/xfs_inode_fork.h
+++ b/libxfs/xfs_inode_fork.h
@@ -156,14 +156,20 @@ static inline xfs_extnum_t
 xfs_dfork_data_extents(
 	struct xfs_dinode	*dip)
 {
-	return be32_to_cpu(dip->di_nextents);
+	if (xfs_dinode_has_nrext64(dip))
+		return be64_to_cpu(dip->di_big_dextcnt);
+	else
+		return be32_to_cpu(dip->di_nextents);
 }
 
 static inline xfs_extnum_t
 xfs_dfork_attr_extents(
 	struct xfs_dinode	*dip)
 {
-	return be16_to_cpu(dip->di_anextents);
+	if (xfs_dinode_has_nrext64(dip))
+		return be32_to_cpu(dip->di_big_aextcnt);
+	else
+		return be16_to_cpu(dip->di_anextents);
 }
 
 static inline xfs_extnum_t
diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index c13608aa..8f8c9869 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -388,16 +388,30 @@ struct xfs_log_dinode {
 	uint32_t	di_nlink;	/* number of links to file */
 	uint16_t	di_projid_lo;	/* lower part of owner's project id */
 	uint16_t	di_projid_hi;	/* higher part of owner's project id */
-	uint8_t		di_pad[6];	/* unused, zeroed space */
-	uint16_t	di_flushiter;	/* incremented on flush */
+	union {
+		uint64_t	di_big_dextcnt;	/* NREXT64 data extents */
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
+			uint32_t  di_big_aextcnt; /* NREXT64 attr extents */
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
index 35e926a3..721c2eb5 100644
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
+	    nextents = ip->di_big_dextcnt;
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
+	    nextents = ip->di_big_aextcnt;
+    else
+	    nextents = ip->di_anextents;
+    printf(_("naextents 0x%lx forkoff %d dmevmask 0x%x dmstate 0x%hx\n"),
+	   nextents, (int)ip->di_forkoff, ip->di_dmevmask,
 	   ip->di_dmstate);
     printf(_("flags 0x%x gen 0x%x\n"),
 	   ip->di_flags, ip->di_gen);
diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
index c9c453f6..5e387f38 100644
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
+		nextents = di->di_big_dextcnt;
+		anextents = di->di_big_aextcnt;
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
index 0df84e48..3be2e1d5 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -71,7 +71,12 @@ _("would have cleared inode %" PRIu64 " attributes\n"), ino_num);
 	if (xfs_dfork_attr_extents(dino) != 0) {
 		if (no_modify)
 			return(1);
-		dino->di_anextents = cpu_to_be16(0);
+
+		if (xfs_dinode_has_nrext64(dino))
+			dino->di_big_aextcnt = 0;
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
+				dino->di_big_dextcnt = cpu_to_be64(nextents);
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
+				dino->di_big_aextcnt = cpu_to_be32(anextents);
+			else
+				dino->di_anextents = cpu_to_be16(anextents);
+
 			*dirty = 1;
 		} else  {
 			do_warn(
-- 
2.30.2

