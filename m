Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1149CC433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jan 2022 05:21:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348528AbiAUFV1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jan 2022 00:21:27 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:9222 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348547AbiAUFVC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jan 2022 00:21:02 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20L045wW018299;
        Fri, 21 Jan 2022 05:21:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=bbnVSjWQ5vIZjv/Kmci+CR6uVPV4wwbcoX7gQnj0lyo=;
 b=P0N8vayxI43jtyNkKXzco54AZCGEM398ExnKRCk+6ty7EnM1tegD1qRrdvnNXolVvA6+
 +1+1Sw/o1RxjpMYKUeAFWyGPohgDZMXTA1PQkiab6Fx7DC/V4zp91L02epd8G/aH32Jd
 G8PgYiZfyJ6qYQ/HDlcR0IJvVtCclxuQgwYnLUe1g858+uSQGnUxTec8FpZ/0DUYqbxK
 Us1TVIiWzcGCLuwvgoQ5nyshjR5A5ihoTLYWMS8lruh9euAMc8e1P80OMZ6fdbnhQ05P
 sX4RckUudXCj5d9tCloSZK1lhDZhUE9p3MAjHMZR4aEsy5EsXzdODqMvlNqyGBJsK+io Ew== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dqhycgcs4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:20:59 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20L5KW4Q007087;
        Fri, 21 Jan 2022 05:20:58 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2170.outbound.protection.outlook.com [104.47.73.170])
        by aserp3020.oracle.com with ESMTP id 3dqj0sh12u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:20:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZMQwtKz0kctvc568UdjTtKPIu4fIgcUcmKqro0IHiuUObaOF+V/HiuXiY7aXLAE8NW90KEv5eSgn3SCD9EahzlxjkMVcQXknk4VfRnj2TNu85WUH/3XIHE7eBkphymkb+ddR0+c8FBEr/jo1VJOB7PrgfJxEo0uFAVSYBvgAAx42tAVGE/mPQEFTwleK7GihOqkHojlurD6W0ToN1sD253AI1QMAaTKXcZ6l1gq9U++0Pgnnu9n7cnXS+slWhrpFjOb5rYbvL4GUjym8osaYeeZGj6+Wmyo30NcYb6atzNDyCX2Dj4jwtiYG9/LeLu8Gch/NaNA9TDKV3ON6Tx/reA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bbnVSjWQ5vIZjv/Kmci+CR6uVPV4wwbcoX7gQnj0lyo=;
 b=Ln5YCKYRqUoqn24ur0DaqHDHmKpJ0CYgnn64AmVfpXyfQKnXHgtTOhFLllCCLxodbfY0j5J2cq3AgUtAmiUk2k3Bpoa1HmvZY0GEtFw9KNiuGG691a7Q5OztnrIQSCt6LQDHl07HgeNWl+qjJAk7s0bnP/C6XfwApB4iOBwssY7aja5RufQXKsCQxHr9Wk+1xBvpVYbFK3yKrpTHhArnx1aoldHzyAdc7E0XWFfK4X68Ah59exs8LI7d+mMmn1VF6okG1uYs2dKcqxpBF3gmgHffcqstAmzhIXFU9cQ34O3zXdsywjY/opaoawEsCZhpQrV5uIwIMGhdunDJcnrhkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bbnVSjWQ5vIZjv/Kmci+CR6uVPV4wwbcoX7gQnj0lyo=;
 b=nB8P4/OrKGmWxsVzUazRCDQFp8QmW48RbHcvA38IEA/goVQVsJiYdqD7xLGWkxlMxpIZJLFhdpU+92jihslyH6pT6QVPYRfRTZ01W8ZLODAHnDmWXU/f4pbOJAU0dkxpwOqRxJG3kIpXcuQZHcdBY/ysjQhz6aRpCHUPTLAkuz4=
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com (2603:10b6:a03:2d0::16)
 by CH0PR10MB5322.namprd10.prod.outlook.com (2603:10b6:610:c1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Fri, 21 Jan
 2022 05:20:56 +0000
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b]) by SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b%3]) with mapi id 15.20.4909.011; Fri, 21 Jan 2022
 05:20:56 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V5 08/20] xfsprogs: Introduce XFS_SB_FEAT_INCOMPAT_NREXT64 and associated per-fs feature bit
Date:   Fri, 21 Jan 2022 10:50:07 +0530
Message-Id: <20220121052019.224605-9-chandan.babu@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 5c05f6f2-c3f8-48ad-f30e-08d9dc9dcd0f
X-MS-TrafficTypeDiagnostic: CH0PR10MB5322:EE_
X-Microsoft-Antispam-PRVS: <CH0PR10MB5322B6B14C5B646B5DAA828EF65B9@CH0PR10MB5322.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:52;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FQ0SbU9veoChQFmWT3S88uaIhZh8xUiK2iLIlQpOsEooO/t/RI++ufpsa8pxEPG1PExOREocFOx3A5C8koaOMq6rSetE8bqjG7NgGikpfMozukYcw5WQKUNIot7yPEQ/NTfe96yNxme2C2Jh+uTqtCziIxLzmkB/8euZ1T1Q6DNfD1qcRR5FZ/uXiIAGjCtC2jKv1UNBh4HdqTw1yn2iwnwTPCxwDNgfP7A+HpLsiAQR1uhPnrY50riv9hWl1h2+7cMsVgIsKJdWPKFJ86MjF0DwJYofgFg0gBkQda2QBxNO7T6Di96sVr/HlYV7q/FesX1P8dToNnM5PsRWHoHlcyf13EIZl1GnO3H5AJsgYr3HawWh5cHlWDERlmz+J+JfU5dmm6k4eLakHygFaZvpTIJWjkBHtXAISsPnF/uausy3xX8WibAbvnGHywesWtazlSfec4HWmf94NNjuXnbaoJQrEthjJCyGDf/NyTVPoFNY9hL1MTNztl+hGedevb+95Dw5RVfNaKsauAQlOMNwQOPZvEjQfnVlTay3tSDVfeRxVUDDMEt7CA/zWu36mp1OGNOJ/mrIb7r48a05a9RrtEWFYRaomPiPY9vghLmyHNe01wm4owEtEwyx4wqLz34l3bqRgcDDGPVt9UuvDhAVqGx8ssB4SfJG7O3djrsYvtBtABjhAFERf6lTUmVG+GW2hgnHrF4h6yVLipK5UhLTgQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4589.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(4326008)(316002)(8936002)(36756003)(38350700002)(38100700002)(6916009)(1076003)(2906002)(508600001)(6506007)(66946007)(66556008)(66476007)(83380400001)(5660300002)(6512007)(8676002)(6486002)(86362001)(52116002)(6666004)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XoqzfdsNQquHkBPlcDbxtXsySQjo0P8dLhoJsSWKDzPFww0GB1jEUpSs1+NV?=
 =?us-ascii?Q?TLdsff+NHXM/0ZsHCiYTcYb4JuYuH+HKo6hQScRpBhOFCw5FTgpwtd5Vs9co?=
 =?us-ascii?Q?yrC16qEssNItMtMPz75eH46iMbcJVpYYkuAUnS1Cf82gMbsrOlQM8cMuKQ/d?=
 =?us-ascii?Q?M+SFURDWuZS3DOPcJOMM5P8rZDJcCavbzK4o64i2hdXU6Q+M/pm4bAjSjOHo?=
 =?us-ascii?Q?TFcNSx2+chEBCsR3/XbiSYZh1AOvh4VfRjy2mSI9NE+Te5TOxpb6E8ARrzGH?=
 =?us-ascii?Q?KKaduZ7BCR6Xtl5rkN2caSOBfAmzWxzfCV0xaBYMjXXWdwlw9xYRjjcm9pOX?=
 =?us-ascii?Q?dWiW7VUxzLkJD4r7HgrKaIubaK7br+LS/OHtlee2Pp8vbbAms3tmwi3Uvm94?=
 =?us-ascii?Q?hjgZ/t/nrXIGdx8vDi/hZ8N2PeVBhGsNSMblD3ZS9hutuLwW38JOLRbvnAla?=
 =?us-ascii?Q?mZGTMVyXvUeOWrVdGe5QvNRhR8etKesqrQUuseJUk/9iaH48CEXioeXt8suA?=
 =?us-ascii?Q?KghWiwUl09oEtSxA7YrjrWK6mQg31ivYk08UZtBIzxbShtR8wtGXjPkgVt+5?=
 =?us-ascii?Q?X/Fe92T3dQqtXfwjD9FSF6R4u2G6UGszcw63Gm9Pu+aHbH0oc/lWHqb3zxdX?=
 =?us-ascii?Q?8Pq0KCCgpILqk7ivYCmo/0QQsfQuVXfxGoociero1I2/25bx+f+fqHZqiR63?=
 =?us-ascii?Q?fDgxS6Y8oK0+HiwEZ1ogEujX5r6bavWsLOYuBld65c8HhvdnnxIA2d8hntcd?=
 =?us-ascii?Q?XA8UYCC1cXSx6seyrlAsRHsaXsIW6PwTpnVzvT7MIi5RuivOfP9TivtIOVzM?=
 =?us-ascii?Q?l43hW7jzIrQpYrDVdb6LdmZfQxz7YC9/OInp+xg+YwMZuL0/0U89UmE/cN2J?=
 =?us-ascii?Q?ePa2c8QiTfjFWPJ7rf47tmiS1nBLWm8DIKK0VS4qkSQiL6fFB/Coo3mj8NVl?=
 =?us-ascii?Q?hkNOmMSa/qqXtJa7NdOwMhNAToAzdNrBmkuXKbgkfwYLipoFt24su7SZoUNa?=
 =?us-ascii?Q?2Qm2wp7viDdPbc67ioXL3mBchEk07YAUMde6/ACv9waZi+fjT0otSekYV/1Q?=
 =?us-ascii?Q?IVjUp6/K8149W/getqYioUOSwEFpODIXTk5x5TJ0itMdWeGXnK3dAGG6Fv9D?=
 =?us-ascii?Q?IGyaKH/CEG1zqcUPVt5TY9FJtcbHhhZsig9ClnbFoQwZ1JhV5XhUmLNM89MY?=
 =?us-ascii?Q?GklpFpCjsiP/AJCe70p2XyCWcjlWdtkM1zZS3zo7LB38iJQVQ5lmQ03IY9iz?=
 =?us-ascii?Q?vOnAfVKjI35RxQt8KLfQPmSzY3cneaRP9KnKANK/CLRrW2H6e2/CqHjywl0R?=
 =?us-ascii?Q?5Yvkbjy7qQt3X9TnY7QJfbmWBFr7whWuGYpchNbQeqy+Xky+zQjruuRPdPlE?=
 =?us-ascii?Q?/Z3YNx1gCrRf4IRvus4gkEECEDzqERf+0g9mJuHalOCMGFc75Gr96ooHfom1?=
 =?us-ascii?Q?OjhJkDpqarX9omZJTQw2gyth90ib0lyz5He4gX2dplycrZMqYlhbnfcWCsny?=
 =?us-ascii?Q?+Ht/xQ1/rjCirpqoPD5+05i3l7rhDjnyv3RO1seDfZ1o5/TwjhaKWAWB/irD?=
 =?us-ascii?Q?NyGcIrAZ6GsxOe9T08hFgS1zy7u7PS3zQLHGPZuHw/ndcoDzBuaiTEzzRPYQ?=
 =?us-ascii?Q?dNubq/FmjddokgjuL6NOxQk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c05f6f2-c3f8-48ad-f30e-08d9dc9dcd0f
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4589.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2022 05:20:56.0654
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2Io1dpvhin4A6HuRaFKaev1lrh3DI9L5g4cDUGnRDLNt9gkqjWFe5mlSe2YJnL34270rqnfzKZ/XOjqAO1WdwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5322
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10233 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201210038
X-Proofpoint-ORIG-GUID: HTrxlwHWwbiVJcDE1wCuf6MH2Br6NYhX
X-Proofpoint-GUID: HTrxlwHWwbiVJcDE1wCuf6MH2Br6NYhX
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

XFS_SB_FEAT_INCOMPAT_NREXT64 incompat feature bit will be set on filesystems
which support large per-inode extent counters. This commit defines the new
incompat feature bit and the corresponding per-fs feature bit (along with
inline functions to work on it).

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/sb.c             | 2 ++
 include/xfs_mount.h | 2 ++
 libxfs/xfs_format.h | 1 +
 libxfs/xfs_sb.c     | 3 +++
 4 files changed, 8 insertions(+)

diff --git a/db/sb.c b/db/sb.c
index 7510e00f..7f83052c 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -704,6 +704,8 @@ version_string(
 		strcat(s, ",BIGTIME");
 	if (xfs_has_needsrepair(mp))
 		strcat(s, ",NEEDSREPAIR");
+	if (xfs_has_nrext64(mp))
+		strcat(s, ",NREXT64");
 	return s;
 }
 
diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 8139831b..b253d1c8 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -154,6 +154,7 @@ typedef struct xfs_mount {
 #define XFS_FEAT_INOBTCNT	(1ULL << 23)	/* inobt block counts */
 #define XFS_FEAT_BIGTIME	(1ULL << 24)	/* large timestamps */
 #define XFS_FEAT_NEEDSREPAIR	(1ULL << 25)	/* needs xfs_repair */
+#define XFS_FEAT_NREXT64	(1ULL << 26)	/* 64-bit inode extent counters */
 
 #define __XFS_HAS_FEAT(name, NAME) \
 static inline bool xfs_has_ ## name (struct xfs_mount *mp) \
@@ -197,6 +198,7 @@ __XFS_HAS_FEAT(realtime, REALTIME)
 __XFS_HAS_FEAT(inobtcounts, INOBTCNT)
 __XFS_HAS_FEAT(bigtime, BIGTIME)
 __XFS_HAS_FEAT(needsrepair, NEEDSREPAIR)
+__XFS_HAS_FEAT(nrext64, NREXT64)
 
 /* Kernel mount features that we don't support */
 #define __XFS_UNSUPP_FEAT(name) \
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index e5654b57..7972cbc2 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -372,6 +372,7 @@ xfs_sb_has_ro_compat_feature(
 #define XFS_SB_FEAT_INCOMPAT_META_UUID	(1 << 2)	/* metadata UUID */
 #define XFS_SB_FEAT_INCOMPAT_BIGTIME	(1 << 3)	/* large timestamps */
 #define XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR (1 << 4)	/* needs xfs_repair */
+#define XFS_SB_FEAT_INCOMPAT_NREXT64	(1 << 5)	/* 64-bit data fork extent counter */
 #define XFS_SB_FEAT_INCOMPAT_ALL \
 		(XFS_SB_FEAT_INCOMPAT_FTYPE|	\
 		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 986f9466..7ab13e07 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -122,6 +122,9 @@ xfs_sb_version_to_features(
 		features |= XFS_FEAT_BIGTIME;
 	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR)
 		features |= XFS_FEAT_NEEDSREPAIR;
+	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_NREXT64)
+		features |= XFS_FEAT_NREXT64;
+
 	return features;
 }
 
-- 
2.30.2

