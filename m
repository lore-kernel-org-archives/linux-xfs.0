Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01044C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 25 May 2022 05:37:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231952AbiEYFhF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 May 2022 01:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244009AbiEYFhE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 May 2022 01:37:04 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 112FC28725
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 22:37:03 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24P01xtN023380;
        Wed, 25 May 2022 05:36:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=BT5QaUbIM1djCy3EtrYKTZs9qJIHBq8ECVUF7GLuxSU=;
 b=RInnCsWWTOWnTMkI649p+PozMRq/X0rWN6Zbk2KwMziUhd+xG7hcO2WS9adAK0fwlBm8
 r4yoQHe/dlImcu5b8JpWhUsR04l4VZkSpQArvF2jBRqTAcHhHoGC9cj4yRJ8bXU4CCUu
 WVRe0/FQpLn+4UUOwqL8RRJSdPRSxolXZ6+1FKfYhTuMEZZCLDqfd6n6yhL8y/YIoW9b
 PIVQHFAtcrBvKS6tlZ+F8K5C+UU+xUy+Fe1YiuzTw6jG8su0amqTETcg7YvRM+K+v5f5
 qsywD3zHcf99h868Cv9LRF/j3N8mh3HLyphIvDvQ9Ikle8F7rsuiHjd4N+EdjirtguP7 tg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g93tbs3u7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 May 2022 05:36:58 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24P5aNiO021496;
        Wed, 25 May 2022 05:36:58 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g93x05ru0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 May 2022 05:36:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M4v5YX/1NHoGgKg5XMgqff4p1djuktnGScg3sXEzK/zVCZmuaegXd68qqX9JGVbl/TaYJoCkGko0JwcTkNPpe/lHZ8fGHzmkj0tg8joscoiGWOEl5qMWcTDo+48liHYvlteFvxnLyZr7Q3hBis21K5FXrP/r53S2zZFVcNIGKubTNXqYxdYPWAiXX0vL/ryb+8Q2uE99oPQ/q2dpYn6nmFBXTled3slX1iCpEb7J0Oo5hMq89IxQoXMpT/PSCtV4pGlOra6ljpC/JmPA5/1yviBosvCJU8+lngr/lLixQxQXcLDh7/PI/82cdGw/wk+/veRBtmy9xloLT0AqQgmlNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BT5QaUbIM1djCy3EtrYKTZs9qJIHBq8ECVUF7GLuxSU=;
 b=IlGiP2+6Ul4zr0lG7AlKozjBnYGkEc+r+vkv3EUiCFsefi3JiSHWeMxplHf0sdRPiBW/KiKc84+cOTD7drkHmlVlsGPYeS2zySF+ViT3Cbn7TBdwkcLec4Jsvn+6t5WDGPJeRp80IeIQWf+lYFaVRJr5lYQ+zscY6RXLZuHEsYeEq4W49qvWiyhyA19XTuy6tgZe3EZzQMsOG6yCsO+9wASYkE/sUe0G+IMhPbvSBr4zvVwe/wIjuX4hmWmdyW8JWmLVE/XnF+qmUhUBKu0ZHMEjV/YksCxp37hiiYPi8xE8xX5Rwj75LD0g1vvx7zLYHsj/rbixzVf2eqwlHTfMOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BT5QaUbIM1djCy3EtrYKTZs9qJIHBq8ECVUF7GLuxSU=;
 b=SYSouodqzL++OFSDAUP3rxjinCJF1CuVU5DiDNXHC/iPWMu+axUuYK2QZuOENJ1fLTIpSVJlFq+VeVoPghrLzxr0hbbzh6g/hUZxEWq9KsIXT3hAf19sCZkCfCuB4UjfDrHNtkb6tcTBBP+kAkH9n0v8Iai7SnZzeaT9teNA4/Y=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BLAPR10MB4817.namprd10.prod.outlook.com (2603:10b6:208:321::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Wed, 25 May
 2022 05:36:56 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::5476:49e9:e3eb:e62]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::5476:49e9:e3eb:e62%5]) with mapi id 15.20.5273.023; Wed, 25 May 2022
 05:36:56 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, david@fromorbit.com,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 2/5] xfsprogs: Invoke bulkstat ioctl with XFS_BULK_IREQ_NREXT64 flag
Date:   Wed, 25 May 2022 11:06:27 +0530
Message-Id: <20220525053630.734938-3-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220525053630.734938-1-chandan.babu@oracle.com>
References: <20220525053630.734938-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR06CA0047.apcprd06.prod.outlook.com
 (2603:1096:404:2e::35) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6b46b452-bbe2-4442-0ae4-08da3e109491
X-MS-TrafficTypeDiagnostic: BLAPR10MB4817:EE_
X-Microsoft-Antispam-PRVS: <BLAPR10MB481729CD82B4419E26CC30BCF6D69@BLAPR10MB4817.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NkGZ+rvcheQzgTh0d6FzilNQWE/4bz4uXaoMtExqc8gzMDfEeQ0jiuUy8lFIlDCikKRl8djv+Moay97a+jivtJbfuBEh1x7dnDJTmrVe/0LbseMikkcLTejHDAWZ+3JO+7xtfiYSxghVj9Q6BSdys3kyiOTZ7WgbC+jZ/DisREQZJWD050vaXRTTVZSkvEai4jo2jIq61GzNHJFE7dqXTWGi87zgkA5bO7Izztisuz9JjOZjAOpgO/rew+i+Z29mSHHzDvUK1E4COJBJXUAFJYv+XIEoIcVgOUpl8K/4Vj2N6T7VzK1BW2KiooujlVUnFqiv/IjaeCtmAW97Dlm35SPVSKkdZImFyPNXaX/Rq7GpzerfOVv4RVGBbab16bFI5rMmhAMNJzfa5s7MBWxVhTFxmjJoLRvlG+lI805c4w4GF9SIt7kWyHJsWb3YE9pW9aHyOOjv1IxZ3ZbomkLCm2y6USauu+rZZjnpTbZGlVQ29OOLYRiktx1t3mtfmNmakGnC+9zQmPKVVepK742vflIFfQNFb71nI/XjsYIpoGtKNbwI7kycImTYnOgIOtSA1KQ+Zb31kdu8PTS/TaOTZO0Xi3dib//MgIs4/MMgu3LhsbbDsfJFkDjZwmB3g4Sfswh3NbC5mfhWpVdH2WvJjU1cnk0l3+4zCiwaYk0G/GDizmW7H7P0xGOVucIy8vijMUBmHlFzSoQlttsNhfMZTA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(66946007)(66556008)(6512007)(4326008)(8676002)(66476007)(83380400001)(8936002)(508600001)(6486002)(6506007)(1076003)(316002)(38100700002)(6666004)(52116002)(86362001)(6916009)(186003)(54906003)(36756003)(2906002)(26005)(38350700002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AZbluQjsE6WbbArwoG4rPo4u272pOpsdqEjC+L6BiNEQYMRB6dPdUmqLzzSv?=
 =?us-ascii?Q?BpBe+IaI1tyHXwDCcNQ+ISCQG0e6Yq+/QD/G08qhrneLGAaWaOaFWlJYGWQX?=
 =?us-ascii?Q?wzVvlejPvQmZK33EMw3dway26ksZgaftTf6E5QDjg7WtJyh6rIHYqkrkZYKD?=
 =?us-ascii?Q?D4KIK2kqRj7K+9iu6ejIMBnkh0ctsCHpTRkn8vGpyZmQgwDLXvLytDx50Ztf?=
 =?us-ascii?Q?37SP8oeHr4QaLL9eHiHQjENjgXa34uFlNIh46wiLPUQLXtS33jxMwu5rThHF?=
 =?us-ascii?Q?avexV/R5Iuvm69Il2EHv+0Sh1iBwEkhF5PnXN4Uz3cw5toe/ZcjJ1j/LVABS?=
 =?us-ascii?Q?O7IqqdejoRw+yxR/PEx68ZqCWxGb++wGXSgPumBENSkqPo8jg95CtMmWaplu?=
 =?us-ascii?Q?KQnKKdSWqooVPa8cB+zSuYirtZYMQtYpsEhtpO2Rz+3WapYkckAozg5SKSx/?=
 =?us-ascii?Q?0XRtE8B9xdGuZc1o2klGFObro1UiqHuSNgZQVMbLEEF26yzcoATDAbfVfEqR?=
 =?us-ascii?Q?1mwvtr19QZaZGqWfuUsYiL3D15gd3jWoH8f/Mg0hktEA4IdkdAzCQ9Fseb/l?=
 =?us-ascii?Q?B0xLvIx/pzOXl3rI4bbYBmRP8k3dVG/tI+5IFvbQRCg0MS0PWbR7HLTf7BQz?=
 =?us-ascii?Q?dr/lV/+iE2X7vGy6MGrs5dAEqaHGXagtwJRAElFEXxt5EC0jvvPHDrdRSlto?=
 =?us-ascii?Q?nexNkJpsrxVgZIT0Ejyyvuv/TFDsglbU8VlclVzmFFq6ObGG9IulBD87CiXn?=
 =?us-ascii?Q?RK9cmjuT0yqz1Tj/FJOHiesBT2NvM4TWPZmPXj8FNzzVjfxn9mrKr2KjImNV?=
 =?us-ascii?Q?GNwOAtsgAYXEGJ+MZPGJWsC3tD9ivXJgFJ4Dh+CI0VeyZC9MgTP9AOROCurD?=
 =?us-ascii?Q?dpZvELJILOPZ7j+BcE6adMK3LnkaEiu/EHGizmuJwny9oJdpRC13UT8YRZ+6?=
 =?us-ascii?Q?p/b99QXTinaGlYv+d5KkATYJuQjPlBtrj9z6eGaMZ2dFjTIM+8LlQotYQAyK?=
 =?us-ascii?Q?UvQ/JvDGA8ApkUk2odgk6mV2o1beEvt46LzU3wQRClHfluoQZfPvzlf1JFOY?=
 =?us-ascii?Q?up5k4VWzoncxT4NRitUSmP1cUgzoIvLbJCmFNrz9lLbZJwVIkLQQ1fER3bpV?=
 =?us-ascii?Q?BTrawXepQjVFUvKxPagzy+2hZJU3KAi1I57O4cWUwLBmU8H1ptMXjTUUgvI+?=
 =?us-ascii?Q?ma90ucDD7jxUwbnkHyU0Wb6vhf1jniO7QSzW8N0MZ/QMpnKq0kVUDN6X7kUH?=
 =?us-ascii?Q?mPvPGJxFtdRQLc5JKR7pVCTlIBNg385e4YVUascHX7ivtn93AcHH0GMlkOqN?=
 =?us-ascii?Q?7sPvGA9hnWdHtOKjTYdcTciKrJwEC4Bzned+rbzYFsjpdezFer/5YT+O1PBd?=
 =?us-ascii?Q?d0n+JAsFZLl2mIVcr76f5vFr6j/dj0ybghLR9hOdgKRdvBv9bxYaRjEOe49q?=
 =?us-ascii?Q?9T3xWxhQbPnqCNgawhj6I/HKMMWm4K1DIFH1tgnCkPDSlGUdMqA8P70srC8q?=
 =?us-ascii?Q?GR0nKYn7qB7cqyBJpq3a9zLEIvAVIAz27Qq7eUvtNN4MKlYKomwjcc27RDSd?=
 =?us-ascii?Q?RxgExvxz7P6Z+PtrtaOYPGpzfJTjb5SUWhu3XK7GXdXWtrhjFC15XuEV6nlu?=
 =?us-ascii?Q?5Eo6k7XfAhpzKEC3d+sb1CZ8+O0PsYJYZg5IrmMrWh1jzOsa4hnAt0hmJ6fN?=
 =?us-ascii?Q?nduS65HVul+/jAN6sc60hpsDXP/QfnJjRA5z0KjmHF28xJJrD8hex/0i4jAj?=
 =?us-ascii?Q?kiHbYGg5+oNFNm11RNGikBHutDVfCbo=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b46b452-bbe2-4442-0ae4-08da3e109491
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2022 05:36:56.0997
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T3HjppKlWImKaseGUAl8hmT9yZlCCZYUGhcDu3n7jF5J4y8fBOzT/Kkiay03jppsJfWmdzNrWGwJYK5Xi16sjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4817
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-25_01:2022-05-23,2022-05-25 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 mlxlogscore=999
 spamscore=0 suspectscore=0 adultscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2205250029
X-Proofpoint-GUID: 8X8quxO21xeCykTf00jGPIOJO69J9j0d
X-Proofpoint-ORIG-GUID: 8X8quxO21xeCykTf00jGPIOJO69J9j0d
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds support to libfrog to enable reporting 64-bit extent counters
to its users. In order to do so, bulkstat ioctl is now invoked with the newly
introduced XFS_BULK_IREQ_NREXT64 flag if the underlying filesystem's geometry
supports 64-bit extent counters.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fsr/xfs_fsr.c                 |  4 ++--
 io/bulkstat.c                 |  1 +
 libfrog/bulkstat.c            | 29 +++++++++++++++++++++++++++--
 man/man2/ioctl_xfs_bulkstat.2 | 10 +++++++++-
 4 files changed, 39 insertions(+), 5 deletions(-)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 6cf8bfb7..ba02506d 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -590,7 +590,7 @@ cmp(const void *s1, const void *s2)
 		(bs1->bs_version == XFS_BULKSTAT_VERSION_V5 &&
 		bs2->bs_version == XFS_BULKSTAT_VERSION_V5));
 
-	return (bs2->bs_extents - bs1->bs_extents);
+	return (bs2->bs_extents64 - bs1->bs_extents64);
 }
 
 /*
@@ -655,7 +655,7 @@ fsrfs(char *mntdir, xfs_ino_t startino, int targetrange)
 		for (p = buf, endp = (buf + buflenout); p < endp ; p++) {
 			/* Do some obvious checks now */
 			if (((p->bs_mode & S_IFMT) != S_IFREG) ||
-			     (p->bs_extents < 2))
+			     (p->bs_extents64 < 2))
 				continue;
 
 			ret = -xfrog_bulkstat_v5_to_v1(&fsxfd, &bs1, p);
diff --git a/io/bulkstat.c b/io/bulkstat.c
index 41194200..a9ad87ca 100644
--- a/io/bulkstat.c
+++ b/io/bulkstat.c
@@ -57,6 +57,7 @@ dump_bulkstat(
 	printf("\tbs_sick = 0x%"PRIx16"\n", bstat->bs_sick);
 	printf("\tbs_checked = 0x%"PRIx16"\n", bstat->bs_checked);
 	printf("\tbs_mode = 0%"PRIo16"\n", bstat->bs_mode);
+	printf("\tbs_extents64 = %"PRIu64"\n", bstat->bs_extents64);
 };
 
 static void
diff --git a/libfrog/bulkstat.c b/libfrog/bulkstat.c
index 195f6ea0..0a90947f 100644
--- a/libfrog/bulkstat.c
+++ b/libfrog/bulkstat.c
@@ -56,6 +56,9 @@ xfrog_bulkstat_single5(
 	if (flags & ~(XFS_BULK_IREQ_SPECIAL))
 		return -EINVAL;
 
+	if (xfd->fsgeom.flags & XFS_FSOP_GEOM_FLAGS_NREXT64)
+		flags |= XFS_BULK_IREQ_NREXT64;
+
 	ret = xfrog_bulkstat_alloc_req(1, ino, &req);
 	if (ret)
 		return ret;
@@ -73,6 +76,12 @@ xfrog_bulkstat_single5(
 	}
 
 	memcpy(bulkstat, req->bulkstat, sizeof(struct xfs_bulkstat));
+
+	if (!(xfd->fsgeom.flags & XFS_FSOP_GEOM_FLAGS_NREXT64)) {
+		bulkstat->bs_extents64 = bulkstat->bs_extents;
+		bulkstat->bs_extents = 0;
+	}
+
 free:
 	free(req);
 	return ret;
@@ -129,6 +138,7 @@ xfrog_bulkstat_single(
 	switch (error) {
 	case -EOPNOTSUPP:
 	case -ENOTTY:
+		assert(!(xfd->fsgeom.flags & XFS_FSOP_GEOM_FLAGS_NREXT64));
 		xfd->flags |= XFROG_FLAG_BULKSTAT_FORCE_V1;
 		break;
 	}
@@ -259,10 +269,23 @@ xfrog_bulkstat5(
 	struct xfs_bulkstat_req	*req)
 {
 	int			ret;
+	int			i;
+
+	if (xfd->fsgeom.flags & XFS_FSOP_GEOM_FLAGS_NREXT64)
+		req->hdr.flags |= XFS_BULK_IREQ_NREXT64;
 
 	ret = ioctl(xfd->fd, XFS_IOC_BULKSTAT, req);
 	if (ret)
 		return -errno;
+
+	if (!(xfd->fsgeom.flags & XFS_FSOP_GEOM_FLAGS_NREXT64)) {
+		for (i = 0; i < req->hdr.ocount; i++) {
+			req->bulkstat[i].bs_extents64 =
+				req->bulkstat[i].bs_extents;
+			req->bulkstat[i].bs_extents = 0;
+		}
+	}
+
 	return 0;
 }
 
@@ -316,6 +339,7 @@ xfrog_bulkstat(
 	switch (error) {
 	case -EOPNOTSUPP:
 	case -ENOTTY:
+		assert(!(xfd->fsgeom.flags & XFS_FSOP_GEOM_FLAGS_NREXT64));
 		xfd->flags |= XFROG_FLAG_BULKSTAT_FORCE_V1;
 		break;
 	}
@@ -342,6 +366,7 @@ xfrog_bulkstat_v5_to_v1(
 	const struct xfs_bulkstat	*bs5)
 {
 	if (bs5->bs_aextents > UINT16_MAX ||
+	    bs5->bs_extents64 > INT32_MAX ||
 	    cvt_off_fsb_to_b(xfd, bs5->bs_extsize_blks) > UINT32_MAX ||
 	    cvt_off_fsb_to_b(xfd, bs5->bs_cowextsize_blks) > UINT32_MAX ||
 	    time_too_big(bs5->bs_atime) ||
@@ -366,7 +391,7 @@ xfrog_bulkstat_v5_to_v1(
 	bs1->bs_blocks = bs5->bs_blocks;
 	bs1->bs_xflags = bs5->bs_xflags;
 	bs1->bs_extsize = cvt_off_fsb_to_b(xfd, bs5->bs_extsize_blks);
-	bs1->bs_extents = bs5->bs_extents;
+	bs1->bs_extents = bs5->bs_extents64;
 	bs1->bs_gen = bs5->bs_gen;
 	bs1->bs_projid_lo = bs5->bs_projectid & 0xFFFF;
 	bs1->bs_forkoff = bs5->bs_forkoff;
@@ -407,7 +432,6 @@ xfrog_bulkstat_v1_to_v5(
 	bs5->bs_blocks = bs1->bs_blocks;
 	bs5->bs_xflags = bs1->bs_xflags;
 	bs5->bs_extsize_blks = cvt_b_to_off_fsbt(xfd, bs1->bs_extsize);
-	bs5->bs_extents = bs1->bs_extents;
 	bs5->bs_gen = bs1->bs_gen;
 	bs5->bs_projectid = bstat_get_projid(bs1);
 	bs5->bs_forkoff = bs1->bs_forkoff;
@@ -415,6 +439,7 @@ xfrog_bulkstat_v1_to_v5(
 	bs5->bs_checked = bs1->bs_checked;
 	bs5->bs_cowextsize_blks = cvt_b_to_off_fsbt(xfd, bs1->bs_cowextsize);
 	bs5->bs_aextents = bs1->bs_aextents;
+	bs5->bs_extents64 = bs1->bs_extents;
 }
 
 /* Allocate a bulkstat request.  Returns zero or a negative error code. */
diff --git a/man/man2/ioctl_xfs_bulkstat.2 b/man/man2/ioctl_xfs_bulkstat.2
index cd0a9b06..3203ca0c 100644
--- a/man/man2/ioctl_xfs_bulkstat.2
+++ b/man/man2/ioctl_xfs_bulkstat.2
@@ -94,6 +94,13 @@ field.
 This flag may not be set at the same time as the
 .B XFS_BULK_IREQ_AGNO
 flag.
+.TP
+.B XFS_BULK_IREQ_NREXT64
+If this is set, data fork extent count is returned via bs_extents64 field and
+0 is assigned to bs_extents.  Otherwise, data fork extent count is returned
+via bs_extents field and bs_extents64 is assigned a value of 0. In the second
+case, bs_extents is set to (2^31 - 1) if data fork extent count is larger than
+2^31. This flag may be set independently of whether other flags have been set.
 .RE
 .PP
 .I hdr.icount
@@ -161,8 +168,9 @@ struct xfs_bulkstat {
 	uint16_t                bs_checked;
 	uint16_t                bs_mode;
 	uint16_t                bs_pad2;
+	uint64_t                bs_extents64;
 
-	uint64_t                bs_pad[7];
+	uint64_t                bs_pad[6];
 };
 .fi
 .in
-- 
2.35.1

