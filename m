Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DA24C4320E
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:21:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82B6360F94
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:21:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235558AbhG0GVV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 02:21:21 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:6624 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235659AbhG0GVR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 02:21:17 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R6GBw8024367
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:21:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=+KCCeGsAa5FMQjzgNqfVzKfvO39mlM5Fj9fmet01XPk=;
 b=qk8GDdN0Mz4ikcd0FCXWLYNz0gBgovabGGxVe5pEOExArNLxZ5XYf4PU2X+dDisvB06k
 BqTB16veV0RFmDJ5JlhwQg1X/eorHDIu9ljRk/CYkHdLNiVQwm4m0aXvy0k/UsNZrs53
 MAhPwbJoUbynMzEDaqvJ06u2cR5JAMF8JKg3ss3RpndRQ5afuG17vPRwmtfOx2QR95Ls
 ZRkoZPkKwlsvxBDBjRcVeL+S6EnAnuywSiJYRbuxsItZiLb0748BB+L/AO0BAxMH44xw
 MzSpp0VG1w/VZ+cc8GcjCHMHPrFSTU49a+ZjDSRlwPnl1PQZxEkaueJIUeqs7PPIPTwm lQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=+KCCeGsAa5FMQjzgNqfVzKfvO39mlM5Fj9fmet01XPk=;
 b=KGi1JhjcJhIbXXZhcxGlVi66nKwxp8eukiWk1/9kUZ83RSwq1/+XbLM86RlGhpa4m06O
 u0emxb+q1g5kQLpx4Qyf7mjszkmwusX1TtE7KyjZHDDHRjOCO5fH0dslc0k6P4RKGDFM
 ZXplUd1UrWPweqyYTjffFRTZE9kgygfV1vBaZWj2PBCsquMcP8tVL9uJIIgwsNv4isgz
 01o5WqBhFROHfLLRXNyHEZ5rJrI3sF6mOtDiHfu9I9T1wxDpvbXo9SSoGrDs33J6w6eC
 QPmkk4gcFBDPCukR86yYfj+665I2MZgl9I34QK9v/W6R4v3l/52GR3WQ8/yrsye6xycY EA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a235druq0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:21:17 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16R6FT1w019894
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:21:16 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2042.outbound.protection.outlook.com [104.47.57.42])
        by aserp3020.oracle.com with ESMTP id 3a2347k0as-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:21:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NM/QxFecMEbvS7CKP2IGNBVVkXSrk671N/OtH4EeZ7nVVpTHW2peZGS8Ip0NDuqD50GRSYQ/HIQ4WSGiqp/XN2b1+CcK/Icr3Rvqa4+7+Paw72NMcEcjvenvbnswdomT4svL9mTvB/jMWAJZZ6ldTR1Osxajk56eWtvBHy+4jYDkEg+AIFNFK2qg5cESBLhajWviZvv08lnKURd9fRSS9Ba2MQd39u8OAv5Jk4b3go4NEWszyxF7/QhHaS26kYYfS/DjnJf+KqbcEexhleX5gn08/yQtc9t2gWLEoqJqPs7PvSUv+Z3I1Dnz5p49jbP4gSi6srXFCZZKRerPYdGgZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+KCCeGsAa5FMQjzgNqfVzKfvO39mlM5Fj9fmet01XPk=;
 b=MdfmIbsUHRFZ8k0e6sg+9Y3DWq8F07aKNRAp0fO6lcVa0uF/VgairfyLmn1f8OYQDqi21M/sr9URA2+vjHKbZvMuHI0mVxDeaS1abCCYXE8ocpQMGuVef9av+1q3C9paF1TwuwKomUP4W05bseD49YBVupQMIaTU9PMceBmHJdQLxDvY2x1YQXyswugoVpiLmwViCg89kIkRO2xGqgFKSkDeWzr5sKg9vt3KeasiSAjOpaMP1pC0PGd5xXA99ELSt3NZyz3brmD8U17YoXNKtFeRRQG7Oisv6QiLUQ4VOOP8UusRiqLAIgYxy+IkVfjf4KXIbGjK1YZZSv+oAOzJhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+KCCeGsAa5FMQjzgNqfVzKfvO39mlM5Fj9fmet01XPk=;
 b=aZ3aXtxurEpORVbKmu+M0Qt5nKDgAuVkqHoHczuwfI5ewEsP10B4ttFiwpFHMWUXP1U/luUw8hlb2o7duB6H51JSOL9LbZbNOcBq5wyUDEmHexQE8Xn8B9NfpOJ46JmtknAqRLC8AA1oczQK97Wbg2+NxvaRitshdFDuh8z5aQ0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3383.namprd10.prod.outlook.com (2603:10b6:a03:15c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Tue, 27 Jul
 2021 06:21:14 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 06:21:13 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v22 14/16] xfs: Add delattr mount option
Date:   Mon, 26 Jul 2021 23:20:51 -0700
Message-Id: <20210727062053.11129-15-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210727062053.11129-1-allison.henderson@oracle.com>
References: <20210727062053.11129-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0191.namprd05.prod.outlook.com
 (2603:10b6:a03:330::16) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.112.125) by SJ0PR05CA0191.namprd05.prod.outlook.com (2603:10b6:a03:330::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend Transport; Tue, 27 Jul 2021 06:21:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3d6e344c-4936-40f6-76de-08d950c6bb97
X-MS-TrafficTypeDiagnostic: BYAPR10MB3383:
X-Microsoft-Antispam-PRVS: <BYAPR10MB33835CE675C9E75E81187E7B95E99@BYAPR10MB3383.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9jTuROvSlUNIs3eqHJpuOQ7esHQ4DuQNTCGVUflkfeM//6BAMaTVOgiMSZkhf81kFiTWSMjTcwxSw7YXq2YOkDIG2fohSHix+VzZsnQU/JUAxlnEoXjkIU78Jzg+QPeHoC6bni1BZdBS2rqy+pNzOwfweDbCH5Ea8OAa6bSntwaWSJeG8jGJRAKyrs9uvuBcVdSzTuRyQts3+em22AfvgGg6dwz/NplqfV8XK39w6Frl99O7hCOzTu7jl+yo2gyxADyfhFhXUsKpdF9dp+7wtP5YP2xjYxzvzpRIeAgaxPQGHnTBGVNVRWFhKq2GuLQ4zhMoq41W5MLZG9UCZxOoFENJwq6kC8gRmU9pNkj8qJR1PNM9g8tr5skjEy4j5x49wqrw2uGCfrUAaGJtBEcevO6FQ3Vt23dJhgxUo7gpwppix7H8gjjwIIrAo+efk8MhLvH3a4yfTWWbevX0+YMxR4SoBcmpp0MmknLr7BETrDayLW7vYT0ETRymCemotyu39GKT4LhOlETypBTG8MfkO52cDRwQYlLYiaxgCxjQJeBYQj+Q78x39+vodb1CG8D+VthZt46eadbGgu1KFZuh6oysQecqtj0al75Iz3EoMaflFKUhtDxuYQ4EWc7Y1sJlgegt3PKc/UddUXDKQnFO0MAFET5lCgkKVD1GW7y/fxXBZOms2PkKmsulZeVcLR+Kdw61LV7erhcANhPizKsOGA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(376002)(39860400002)(136003)(346002)(44832011)(956004)(36756003)(26005)(2616005)(6512007)(6506007)(186003)(6486002)(86362001)(6666004)(2906002)(8936002)(1076003)(6916009)(66946007)(52116002)(83380400001)(66476007)(66556008)(38350700002)(38100700002)(8676002)(316002)(5660300002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Nkk/lLqzB9cSvxVn1JYHBH39adK2wcPKV12XtyFZ1hQowQ4iW4nLCkm6VBdp?=
 =?us-ascii?Q?/+YXJ16VwkiZi+u0UWVo3YO44HXPeR5GfNnXOkwjIO3Eh6tfxEPIlsQH3tDU?=
 =?us-ascii?Q?90o0BVfkNFu6IhreXNjwhsZ1MTjil2DimBrVOIfg+h24FLbI1prieRDByHEQ?=
 =?us-ascii?Q?TLpIwhUyjcWANGQjpq8cDeN84Sqtti4UN3TqcQHOyDoAqdgZfaHgdstmUAlM?=
 =?us-ascii?Q?w2OmcFpuka2yQ2NseoOKwCskQ/gXADhd+neRI5AvtT18Wj5/OHuKbuCRpFfJ?=
 =?us-ascii?Q?y6nNWmFJworYxQpBEkmxwMyPQ4/cqhPR0k7hrllas4tmmoyEDWGWsYisMdKo?=
 =?us-ascii?Q?uZQ1LbzEYAqmMf7Q3kCZqMuygDE0cZQwInf7SYtn7H6wGl6zQy3FUcl5VT/a?=
 =?us-ascii?Q?UZXjf1Ca8TnghX+kt+axn+OxamyelX+5vf5j2nPVG6XUF4mOYA2YyyzQ+Vz5?=
 =?us-ascii?Q?Wt3oszhCAIc3RBz1zHEGOrbOjt/Ehy9RHhRNO5AO1gNh7ci0RvJHVsDSBEkw?=
 =?us-ascii?Q?csnpnpLpVciy/PIT+q2gnJuTT6uES4P0W9FSY5KI1pAoh+2YNoXetZsYcUnx?=
 =?us-ascii?Q?swRiIhdgGqngB98s/Xo1z2yoQmJ5iGpJKNT9UJLzVlo6caKM1exBYXnt12EX?=
 =?us-ascii?Q?pDXWNp6F6dk5/B0OT9pP1qV5BFJgNYPQjM4MivsHuauOVZXVtsNxEsWPRXei?=
 =?us-ascii?Q?DY9FcQTJwqTfBgYOG4Cn6Y3iBX07QMyzurvEAjuM3c/Rjx+Uduo3TK5L2Llb?=
 =?us-ascii?Q?UuWVMGbhH8QmFmGJnQCLLGf2njhwG+o15o3vaht8zAxbAezoiPCDtG9kuktx?=
 =?us-ascii?Q?rNM7ATXmRr2FJ7kwDKXCJo/nSWnmY5eLtail93odM2hRKiZX2wDCuKzMg69+?=
 =?us-ascii?Q?GwxaQdxVoqw5jQFwonTo6mpxKgpkREMs2ctsNtZsybmjYdH+SJPBxTQe0BRM?=
 =?us-ascii?Q?7dPtOfia3P58BfFzXE/kYk++gS9FrMZxmoiU6O5+H1GITqiaOkXK1TCfwRoV?=
 =?us-ascii?Q?BhtFNK7dBPKhnvKvAJ7REiZfA94BEOtug/ABIcNtPenfaWc2HIVZmShQ3v/0?=
 =?us-ascii?Q?8izSQkyf8bqay0i7KQXfHU2C36IbDe8ZhauhQlT6245i72z6RCbY0e+xgM/6?=
 =?us-ascii?Q?15SGorD4G5u1AjJEGw3wRVhU75EziDNPR0g3cB1xqs2fTbw3lFZtGrc54iVd?=
 =?us-ascii?Q?is+4na067Sp09Cx/R8NqQop0Ks3SvuuNtwIBZnAfxzESq2nUJLa+HOsRPaDK?=
 =?us-ascii?Q?gmYqRW7n3W9Z+Tv+TGRUSIKQ9X+t8zH+V6gxogK89L1tUs+Te1l8Z8y1QpAX?=
 =?us-ascii?Q?kM067ZvEKDhaNBDs1a8I8uMN?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d6e344c-4936-40f6-76de-08d950c6bb97
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 06:21:13.2012
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HYhaC8HXjNd4bHR4X9S+czij1GWhDAJuxSblM/KL95ME22nWAcgxuIUSTno3iuBp+10Hk2gLy5KBZTLxyTkxBjaQplzEbjRIxZM0brZPAlQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3383
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 suspectscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2107270037
X-Proofpoint-GUID: AphZBbWE6Hv3D9Y-UWqntnTC6HCZeLxK
X-Proofpoint-ORIG-GUID: AphZBbWE6Hv3D9Y-UWqntnTC6HCZeLxK
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds a mount option to enable delayed attributes. Eventually
this can be removed when delayed attrs becomes permanent.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.h |  2 +-
 fs/xfs/xfs_mount.h       |  1 +
 fs/xfs/xfs_super.c       | 11 ++++++++++-
 fs/xfs/xfs_xattr.c       |  2 ++
 4 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index c0c92bd3..d4e7521 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -30,7 +30,7 @@ struct xfs_attr_list_context;
 
 static inline bool xfs_hasdelattr(struct xfs_mount *mp)
 {
-	return false;
+	return mp->m_flags & XFS_MOUNT_DELATTR;
 }
 
 /*
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 66a47f5..2945868 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -257,6 +257,7 @@ typedef struct xfs_mount {
 #define XFS_MOUNT_NOATTR2	(1ULL << 25)	/* disable use of attr2 format */
 #define XFS_MOUNT_DAX_ALWAYS	(1ULL << 26)
 #define XFS_MOUNT_DAX_NEVER	(1ULL << 27)
+#define XFS_MOUNT_DELATTR	(1ULL << 28)	/* enable delayed attributes */
 
 /*
  * Max and min values for mount-option defined I/O
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 2c9e26a..39d6645 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -94,7 +94,7 @@ enum {
 	Opt_filestreams, Opt_quota, Opt_noquota, Opt_usrquota, Opt_grpquota,
 	Opt_prjquota, Opt_uquota, Opt_gquota, Opt_pquota,
 	Opt_uqnoenforce, Opt_gqnoenforce, Opt_pqnoenforce, Opt_qnoenforce,
-	Opt_discard, Opt_nodiscard, Opt_dax, Opt_dax_enum,
+	Opt_discard, Opt_nodiscard, Opt_dax, Opt_dax_enum, Opt_delattr
 };
 
 static const struct fs_parameter_spec xfs_fs_parameters[] = {
@@ -139,6 +139,7 @@ static const struct fs_parameter_spec xfs_fs_parameters[] = {
 	fsparam_flag("nodiscard",	Opt_nodiscard),
 	fsparam_flag("dax",		Opt_dax),
 	fsparam_enum("dax",		Opt_dax_enum, dax_param_enums),
+	fsparam_flag("delattr",		Opt_delattr),
 	{}
 };
 
@@ -1273,6 +1274,14 @@ xfs_fs_parse_param(
 		xfs_mount_set_dax_mode(parsing_mp, result.uint_32);
 		return 0;
 #endif
+#ifdef CONFIG_XFS_DEBUG
+	case Opt_delattr:
+		xfs_warn(parsing_mp,
+			"EXPERIMENTAL logged xattrs feature in use. "
+			"Use at your own risk");
+		parsing_mp->m_flags |= XFS_MOUNT_DELATTR;
+		return 0;
+#endif
 	/* Following mount options will be removed in September 2025 */
 	case Opt_ikeep:
 		xfs_fs_warn_deprecated(fc, param, XFS_MOUNT_IKEEP, true);
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 0d050f8..a4f97e7 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -8,6 +8,8 @@
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
 #include "xfs_da_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
-- 
2.7.4

