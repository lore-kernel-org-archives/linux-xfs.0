Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA4D9C4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Nov 2022 21:07:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbiKJVHD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Nov 2022 16:07:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231860AbiKJVG4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Nov 2022 16:06:56 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2138EC14
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 13:06:56 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAL0cXw006990
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:06:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=2SrUxQToh4bhD1HtRzafdul34WTLguJdbKICBjrFn8k=;
 b=kImqM945Zca59ZickP/rlBdY6N+LHaqlU6Yp+XjVi+k0/hW/2tmyI1iFR8Kf1MDejhHH
 DXPf3PUyo72xEs+ddCWzG+NFbh8KVNYxRWYANLnc1Ib7fWYD7ADwUh99ME1UHSX44ryX
 FWmcSkY3jypvtOniaQpuTRUpYhxXzkTdih8TFfXPg4x5FM+P4yPgIDNZnhkT8dtHpZwt
 lkxUQTyA6RN009R9jGCT41AYU3PhWdGeqf9gNlNhyXofHKYL2F9msiNH0zDJVZ6wY+JB
 QVSfPTfPIRw/zikCtPzLIkSzYrBP47Y4DgDMqMG1jzFkWLWMcHiORl1ZjEujjPVb3rE1 CA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ks8u5r1ba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:06:53 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAKWeUU038125
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:06:13 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcsh4g43-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:06:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZdhM6bXVQXutLvj+Vy+GyEvdccA8qPVQjbFQrB3reSgGNVAenchmlGWLpeEOqN6UVyUFHwfF3bYilMCSzBFvFD0auoAUzq+m2izCM/madbISkfZOfNSRgYna8MIW54sV3zQYALym3MY/eHS1SDOHQECT30lmtuXT9cVCuYminnl1UWV7At1n268oW3UapAJKXgkut5SatNSQEQ46h10/FCR2GSqe8gkx4ATzTS2HIi5a6T24GWqeG5rTY2CBQWpYGA4w43gRMqB3CoOmBz10yOPX2FhSvhn6HaCYKucOMb798dtlo5qH+WAGXToCrEMJ3Jd9PT92I7wSoQ3YqjRG/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2SrUxQToh4bhD1HtRzafdul34WTLguJdbKICBjrFn8k=;
 b=SV0ZtBfWhLH67/ZajV5wFuk9xgUfSPZwrnu3ZalP5OnGuFzIYCnM5boYjVaDuaCKpk3v1+vnrF5cpBNK7q3HxGMDNuOeRkxQjHugo1HgMWQt8ZvV9ejK7EwKQI69FLJ+wWDDf2L9sB7ggLlptQ/Xg8zkdk9l5D/MBkUQgAS97uHE6S75inEeI0VjpFKhqCdNsdGsRV0otNUap5Khk6zdEwCpHkh6hDX5tRZD54bpcQ9Dx/wSPAB8z2rxEE9Pgx90z9nVZRYiWcXm8uIRgWIi3pn7VG2oHyO8HgDm5OzD26VGTrWyHYqPgdqI4IstVF8bzlTBL8XwfjTOoGXSfA55hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2SrUxQToh4bhD1HtRzafdul34WTLguJdbKICBjrFn8k=;
 b=KqMgiFFfTSy0/kSjR/dD3izQJKPlGm3DPy5ONuWUL9t96YfpZVT4/UcN2DtWQfRh9De8jCuNXfhx9w78cTWSZYxsVf2Ed05fJW4HszyWgRIx0RJdDOe+DzPMYtniUCCiZaTqDp3UE/4silB9/GH9Iqck1yV+WExaw5pZvKuH7hY=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH8PR10MB6527.namprd10.prod.outlook.com (2603:10b6:510:229::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Thu, 10 Nov
 2022 21:06:10 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5813.013; Thu, 10 Nov 2022
 21:06:10 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 21/25] xfsprogs: Add parent pointer flag to cmd
Date:   Thu, 10 Nov 2022 14:05:23 -0700
Message-Id: <20221110210527.56628-22-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221110210527.56628-1-allison.henderson@oracle.com>
References: <20221110210527.56628-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0292.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::27) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH8PR10MB6527:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a5640be-1591-4470-093d-08dac35f64b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mjRrV6CxckgcjZKOcw7OFgQOpcxjGBLQABvQ6HZftIKDTQVV3hbp5DmTll5kOnA+ijS9QD8Ht4XcPpDjyXOXPTFgn/TG5QT0OsTmiScCwGdvBIebW752UdGFly6BZc6dO17fCss7zzna38R/vnTkEpkO6RVA6M4ii7PEgUKqanQXQMhNonAvO7XVFXLRV6Cs65MnZsGZsUR5byioBCPHaqupLNXQovD70/uX/tNBZwreE7BfwgC+ezX6N7PEP60OC2Y1cLnneQuM43II/59WJWailOIVqKAUTbnDTcptWJeUHZGkgfkJt4wpv/hnGzEW1+L0l5vICltzxc/HULEvDrLLT75sQ4rgQJFvDMnQbjIyITDz9EJ4iCbGmmbDL9lurSM/FADyyooNZSjjwUOvKp98bzUswIXKw3WoOAA4XOcGiMWdHGWj3Jcljb49Rfa6yBIwENKipTLex8JwMzxy1prGRYRdCgaaPCrzYoM06RQbHtLtvoA2JJA8lHwz5c1tz0cyrHtgC7D4qfIobosPRZSUw07SdM6fVKdiz4I0hxZRVxRd85WPZTi1yi0WWXFT1bdtyV0Tdulu3ZxqFAid6b/+mSkWbZ+PIqRWusNFiHVlcRFeM6SyHEuqqvOEdsLB/UqhqIp13EyKxS08AQChBhDcyzfuZFVxHsh/FCMt9jR8huFAyNDYAsVPAjdVmn6qPLUBS1nv8nEZtEjcNc6gRZMhRshCl24iSBUOLjMkLX0dY/dT57bPNOz0aLXsu3nc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(376002)(346002)(136003)(39860400002)(451199015)(1076003)(186003)(83380400001)(2616005)(478600001)(6486002)(6506007)(9686003)(26005)(6512007)(6666004)(86362001)(38100700002)(2906002)(66946007)(66556008)(66476007)(8676002)(41300700001)(8936002)(6916009)(5660300002)(316002)(36756003)(21314003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xx6IQHp/5+rD57LCBpOY4VAAZnAiNQ9pWpTIaHTMxNGNr1c1ZjrQmyrtaope?=
 =?us-ascii?Q?F7rw6hEN7uneCkQDhPRgnXghoOShFRJHVEQMbL6w8WdaFT3Ty2W6PhOSeXO5?=
 =?us-ascii?Q?IVZA42zk7z2A8ci3nsrhb+6rTaQ/LfTM+R3M/oNrmFugk/fJPWC1BiSKG0IN?=
 =?us-ascii?Q?fr3oXbrHs95fQkmYm2cfugZLklxd9VNS7QuA9ggD4vftDKFdyutnOFBOjxHb?=
 =?us-ascii?Q?Z2y/sduX+2IRgH3nue3MP3eUmJVFfVKi1J75hR51KE+O7D022CHsaT/7pwY2?=
 =?us-ascii?Q?OyeTko8Wl+5833G7vi1mySTlggf2Ty/ydkvfQC5d5pnZU+8Zdl16js4P2sW5?=
 =?us-ascii?Q?xEYg215CCq4ybXkvk1wA9vHPT4qcb3LylsQz2VwdMdtalWvFS0meJqOT/hJu?=
 =?us-ascii?Q?C3fYBzyWeduq0kywWCsqyEgLPHUi6jzSfjYlzLTSIz88DtiD/s8txp6eEVC5?=
 =?us-ascii?Q?gmMlDFaOcHH9P0xx0IiDYOMFJ1qjS+gbJ3hW6hUEwxVbD603ZUjpMiHiOlHR?=
 =?us-ascii?Q?w/VQommJJ7n6EjE1FxMBHndiEI/5cKkTHnbkhg94KCJANfieaPCkYrWps1Rh?=
 =?us-ascii?Q?d9Hf8wlYYe0zT4xAEWzcBkc4iIdofG/ZAp7OMjgqpT9G6FScbjR0Vc7KUpbm?=
 =?us-ascii?Q?zjaOf/1YukYZwiV2Qa7JcaTlSscY/YFhGwHfjOJHQV/09lCL87tnxJGGJmjF?=
 =?us-ascii?Q?Gf2MSPKuDfxtFERf9iOquBKpGSN9F9/SRloh9/dGdvygNWHK2BB83P48n+A6?=
 =?us-ascii?Q?5ehwwsRGb//MnDLozWCL9fToq6kGx9eDaHLPq8d1O29hboscHVG6D9o0lg74?=
 =?us-ascii?Q?6sdAyuXQslWQbYvG5exRY9YBX3Quf0iI6nrsrLHwMxsYEW51vkz9nwswTxjH?=
 =?us-ascii?Q?NYJbAo1ev5kp8kM/N3r7TJmGIcFs5tTS3UHilEKPupP5xf7dcf9MG7ugkd7z?=
 =?us-ascii?Q?94BvXLZf7OEGikE7zSvk0JTB1mzbRYxhm6Lcmkrldy4p0l/DlPuUEpHN+EGd?=
 =?us-ascii?Q?NTvdVX87gZ0ke5KRCZEM7m2gYacdu4wqQ+u7Nl+F+0I49hpdS14/kUADfBIy?=
 =?us-ascii?Q?+OZ0XfBDZtQ8Ol+V2YRMg/zvEE6+lSMYhmVDagi+BhswY2jVua+/NOVOVRvD?=
 =?us-ascii?Q?iugBl0BAM1qywa4Y6RDtonxM/NlhTXAW0TslI+Gy503qp8TiwgP074USFY2m?=
 =?us-ascii?Q?I4JCvDprdWY49MWOqWX6i5PrTEQEv8Q2Li1AOP/AqsRuT5wnYQYIP6HgvC6H?=
 =?us-ascii?Q?8vEUp46wwXQ7xPdROjQMTdaGjrJeFCb0o7muuPEV+z5mbCwto0uYe4vfTz6G?=
 =?us-ascii?Q?SvhL2ppKJbpZDs4530v8GI8bWWnKsUWn/MpKXC11r2er6k79Q0kJnhf23IS7?=
 =?us-ascii?Q?UUrhm9CweYoAcJsZkAa1uc28Z9zi0NOONaIkk7vhbOlWUoTV8mnquEpJqsTj?=
 =?us-ascii?Q?nCHNOgsX14ERvZQ8+rIGky47sA1ex8n47msVryfoHUZym55geZcrIrLO6tcB?=
 =?us-ascii?Q?gHX5RVwBIBV9c1KN8Ek8bvPMzhE2KlLWkhaJ3DP8uwGtSn753712KUC+B31r?=
 =?us-ascii?Q?Tm7B1EkDUOdd8KbBBLaX2Mph5QlHeotMGAfotJXtSD1vJ99ZwLuYpq1U0fZF?=
 =?us-ascii?Q?zg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a5640be-1591-4470-093d-08dac35f64b9
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 21:06:10.6441
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7yDQZPU6ztzG9sXLqDwU61fueQBIhgXL4WZbTz2QQbbjk3wpZLjDcw40KOgSvyTT0PxRNZhDlUoFWsBYtE7EmmieUsS+l5nsRFyDAVNHfo0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6527
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_13,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211100148
X-Proofpoint-ORIG-GUID: iAV3huPAJsLp69etRYeeTVQ-W5IEnOZK
X-Proofpoint-GUID: iAV3huPAJsLp69etRYeeTVQ-W5IEnOZK
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

mkfs: enable formatting with parent pointers. Enable parent pointer support in mkfs
via the '-n parent' parameter.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 mkfs/xfs_mkfs.c | 29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index e3cd61626186..6926de4695db 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -110,6 +110,7 @@ enum {
 	N_SIZE = 0,
 	N_VERSION,
 	N_FTYPE,
+	N_PARENT,
 	N_MAX_OPTS,
 };
 
@@ -615,6 +616,7 @@ static struct opt_params nopts = {
 		[N_SIZE] = "size",
 		[N_VERSION] = "version",
 		[N_FTYPE] = "ftype",
+		[N_PARENT] = "parent",
 		[N_MAX_OPTS] = NULL,
 	},
 	.subopt_params = {
@@ -638,6 +640,14 @@ static struct opt_params nopts = {
 		  .maxval = 1,
 		  .defaultval = 1,
 		},
+		{ .index = N_PARENT,
+		  .conflicts = { { NULL, LAST_CONFLICT } },
+		  .minval = 0,
+		  .maxval = 1,
+		  .defaultval = 1,
+		},
+
+
 	},
 };
 
@@ -970,7 +980,7 @@ usage( void )
 /* log subvol */	[-l agnum=n,internal,size=num,logdev=xxx,version=n\n\
 			    sunit=value|su=num,sectsize=num,lazy-count=0|1]\n\
 /* label */		[-L label (maximum 12 characters)]\n\
-/* naming */		[-n size=num,version=2|ci,ftype=0|1]\n\
+/* naming */		[-n size=num,version=2|ci,ftype=0|1,parent=0|1]]\n\
 /* no-op info only */	[-N]\n\
 /* prototype file */	[-p fname]\n\
 /* quiet */		[-q]\n\
@@ -1744,6 +1754,9 @@ naming_opts_parser(
 	case N_FTYPE:
 		cli->sb_feat.dirftype = getnum(value, opts, subopt);
 		break;
+	case N_PARENT:
+		cli->sb_feat.parent_pointers = getnum(value, &nopts, N_PARENT);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -2225,6 +2238,14 @@ _("inode btree counters not supported without finobt support\n"));
 		cli->sb_feat.inobtcnt = false;
 	}
 
+	if ((cli->sb_feat.parent_pointers) &&
+	    cli->sb_feat.dir_version == 4) {
+		fprintf(stderr,
+_("parent pointers not supported on v4 filesystems\n"));
+		usage();
+		cli->sb_feat.parent_pointers = false;
+	}
+
 	if (cli->xi->rtname) {
 		if (cli->sb_feat.reflink && cli_opt_set(&mopts, M_REFLINK)) {
 			fprintf(stderr,
@@ -3224,8 +3245,6 @@ sb_set_features(
 		sbp->sb_features2 |= XFS_SB_VERSION2_LAZYSBCOUNTBIT;
 	if (fp->projid32bit)
 		sbp->sb_features2 |= XFS_SB_VERSION2_PROJID32BIT;
-	if (fp->parent_pointers)
-		sbp->sb_features2 |= XFS_SB_VERSION2_PARENTBIT;
 	if (fp->crcs_enabled)
 		sbp->sb_features2 |= XFS_SB_VERSION2_CRCBIT;
 	if (fp->attr_version == 2)
@@ -3266,6 +3285,10 @@ sb_set_features(
 		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_INOBTCNT;
 	if (fp->bigtime)
 		sbp->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_BIGTIME;
+	if (fp->parent_pointers) {
+		sbp->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_PARENT;
+		sbp->sb_versionnum |= XFS_SB_VERSION_ATTRBIT;
+	}
 
 	/*
 	 * Sparse inode chunk support has two main inode alignment requirements.
-- 
2.25.1

