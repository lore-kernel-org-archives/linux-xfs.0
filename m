Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FF57C0015E
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jul 2023 09:46:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbjGUJqM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jul 2023 05:46:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjGUJqL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2023 05:46:11 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D96DF0
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2023 02:46:09 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36KLMaRs025795;
        Fri, 21 Jul 2023 09:46:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=5sF550dpaQoiszjKP4QVc8CaDyyVb7656y+9Wv50MQg=;
 b=d6qotjzl0HdyQfezd1+zUXAMuTRZtgVC9xsmUv4p1m+DR4MnAG7CvEucrkXISxQyrpeH
 ms769csXhf6NUD4AGoQKF2I4BxwlSH8qKOyNpYh62QWTGv1hihHCOenMIQK4jDSSHdwZ
 HTuBeqfMyFtrGEa7fLC1c53z1pINUZGfhwTl7/CiuHeqoSekK2wo2Kyzjp/8cpgFQ73d
 hDjILuiwk5KlWTDawIEPrz2Z5FHFeu7bF4ERfV2hJEEWKLNJGMDbUnkwV1L0p4KoVSoG
 n/zNQnmnEXh2AVv7WCaw3OfHrNwQmR8UNXjDywD9X5qjfI7IwRLpm4BBdwrn3v11B+jv aw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3run88upbm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jul 2023 09:46:06 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36L7oAe4024039;
        Fri, 21 Jul 2023 09:46:05 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ruhwa27gs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jul 2023 09:46:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SRllcx4qIrh0GT/l0DO4d/056xpowgsWoRMe1NbcI8mAgfMp7RiOUnLWdYtTN3LqFcO5nvRN57aFFXCij1gUD4hRqA//Y5aPM3iLtQFApZ4AhqIpdka7Dm0el/T73MiBtz87W0FaiGauCovUk7kwaY162Wx3i5sAns9AQ1B0vCxgjxhug+dfHQoGIKEvhf7S37P4AwgiB6Y+/ojFH7m4DpSuJGtM0RElkWnbyT0l3OvjoZv6p4HXBXlYEO5N/PKQHejx1HI9ZVgoNoZ76bC6BAupWn4O4BXrnMWu3f+v+QyTb6vl35Ib8c8wwXOxOQCxW52+iS/tz/SRHR0BmMMmpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5sF550dpaQoiszjKP4QVc8CaDyyVb7656y+9Wv50MQg=;
 b=mr2nidFuAfOq7+okVFd+t9c8cLYB0z39M0oGE7X4VHHtSAe3LisxPnNky75FKzlW3dZGKQqxNBnMZrjWlLSklrE4+fdmGSfY52e/DF+kx1wewMiPgY0llUTaLHk6EUvUtEkZGNs9MgY7j5lULuKl58vgdu/pfwLBRxnVCoAvQNIjYwxDl1tdu6PI3tvckiLEkW2lORSayWJHa+rstBXS9IzH3mgp0QiAaTApTv1XzwE3xPl6+oMBS17iPK9PRlfQqr6F7eHz8FBacTUPpCzoLca4E5el9SFjM74W9PVVyy3syzxE3hIrYAid6H9WI5+nQaJnpgS1hBLklfvrcliKfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5sF550dpaQoiszjKP4QVc8CaDyyVb7656y+9Wv50MQg=;
 b=S3jDrw++Bf6dZy6EnWBD7vugWGNiQJ0fe9GiKt6KkEfE4bp+nIpq+pK7KQuJZIXWACIL4sfMzdC6sTTjhe9E86zOF/ZomoUBfxe/nUiOSIOhPuuFhJa54wfb9QRS6u7MxqJEaylglbVkUiEcXVd12x3Kkm6Z/w7mPFGxQLEwlzU=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by SA2PR10MB4412.namprd10.prod.outlook.com (2603:10b6:806:117::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.28; Fri, 21 Jul
 2023 09:46:03 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0%3]) with mapi id 15.20.6609.024; Fri, 21 Jul 2023
 09:46:03 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V3 03/23] metadump: Declare boolean variables with bool type
Date:   Fri, 21 Jul 2023 15:15:13 +0530
Message-Id: <20230721094533.1351868-4-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230721094533.1351868-1-chandan.babu@oracle.com>
References: <20230721094533.1351868-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0237.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:3c7::15) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|SA2PR10MB4412:EE_
X-MS-Office365-Filtering-Correlation-Id: 8aa2628a-07dc-4c17-1914-08db89cf4c88
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z/TvTGkZN3OtGvbs6HUeoF0hrL6PhTTZFzxo+IYlw25rjXplR/V+HNP5E5x9phhY8mRAfui+RHCgko4MHyzyrFOhJy7FqXZ87DsXNpIOSZMaN31OjnLOZ8o5Mwg5OQMaXA2e1eZ2Ef/mCQrEWIZztg7mM7taoHRB/AYusDaIOCe9xwDOLrMXT2H24D+y8PeDob1aV6BmAjvRtInMCaYYuD+ap6CQb1Le6xsCScPorPeAryawA8bR02bP0ZXjMs7Ugq80G1jfj/ZIDquGDIe7KCHMQKXdS8Rg0mDFXXQSEQuh3EWhuhepvLzZo+d9DISo2nvQ9nrptHuGbscwPkiFDRjCVahKXD4DRWoxyHhpOJy04puF7Xs4q7ACGiDPI/teveaQX5VdOuDMOqAnR4d+jsQUoP79gloU01NiP/8BAvx/2+gKlBa6YmBNnXc1S7ulN51U7reKV0lsGrD3iyLlI2esMVT/jEBWtsRkXl95eb6lmZXYCGHCTU6BXOAmsNYodzDxhVVFkn6QEov54VepnIK7mJC3r2zF3Q33mqEoqK/6M8NHXGgTLNE8Cow3H5aw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(346002)(136003)(396003)(366004)(451199021)(6486002)(6666004)(6512007)(83380400001)(36756003)(2616005)(86362001)(38100700002)(6506007)(186003)(26005)(1076003)(2906002)(8676002)(8936002)(316002)(66946007)(66476007)(66556008)(4326008)(6916009)(478600001)(5660300002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Qwf9QVyrEKs7EBEEpwT6skaFDG7AKXDiv17eBsmZGzvTwF2bu9gagEjaXR7k?=
 =?us-ascii?Q?NCc9eSKEd/l4FHclHVNF4yTsk0dgcd9jzvF+anSPS1WTEuh12XjYGJzYxLUu?=
 =?us-ascii?Q?siv+S3keUsyHxjygDe9vdUKBgUsreDKVa1POunnQL8UXPkVRDhwtaljI/O6+?=
 =?us-ascii?Q?P+oTlerjpQUkTqhNZ5NXdCdm4eHo8l/CFHS1f/oPNg4PERRp7xK1NUFyGvFq?=
 =?us-ascii?Q?kZSbLmwg2Xct9MKgXEwieJ9jkxgP/yNkF5jI15SaVfyrvEnk3UcGfGmm2vcG?=
 =?us-ascii?Q?mMyno15NhMWNJcfHPQcRIu3gpMnqyHI09nc+cUJ4lxfEfeiDkdxyUqjQtUY2?=
 =?us-ascii?Q?uM96HLiULQMgEBzu+M5zC9GwKjxwKV4iz7qZmqPMiqiUK55WV7N+M9gC/I89?=
 =?us-ascii?Q?fUp7+7qRyCypV9fum5b2eCCj057luWRwg62q1PoW+L0qDibhPK5nYXoqxKB4?=
 =?us-ascii?Q?MNXdIJVgMiIYixsxpgWvFGSAtNVVBK9jhtg/1q9N+78y7KbNtrMdi9ScmFsK?=
 =?us-ascii?Q?K/J9f4Xo97hIjvxXU5uAs1ef9xs2NBz6Bf24YG38BVhRChc8ntB1BQO/PE+X?=
 =?us-ascii?Q?t+saFMjbMIyvfFx8Bwfps2HqeqDzrzaG+yVioLjHDryOskWbIhbbMe0NZ5G4?=
 =?us-ascii?Q?F1tYDwd8lvpdi4Qg/SzDch12WBRwXi9RinUTt7PBY7P0bIfjtYUY3LdEeH1k?=
 =?us-ascii?Q?fUrmFUj2D4KDlUfwXhbJYmCq6MMX6UYzZdAUk5bKOHEdoXKCN+9xOHNyocrI?=
 =?us-ascii?Q?TypW2FRL+fPdgQsFNbzB+KB0zEKp38vXEBeOkEsSQeZ81aO0x1Nc03SseUzU?=
 =?us-ascii?Q?TADS4CXFs5gXTN16EXVk89n39kQCtsk/jH36rUgmgWmRCLgMLf/oj2gDOA+W?=
 =?us-ascii?Q?t005FyA6ynDQxizyt72jahXRYp5whFmVNZ/IA5VU7yicQV3SGGjqMQy7U2SA?=
 =?us-ascii?Q?MOhD30l/pKvcHMdixH5uCIfvnFdKb31fgyrJYgXSrl7Mq78V8YJ9oSIKD3Ws?=
 =?us-ascii?Q?+rufccpB8upWBdgJL1dW/ZjNl5oK7how6xe/ovcISJBbMc+e2k2LRBJiRUF1?=
 =?us-ascii?Q?FVongVilHT/jtaLs68phDOfAWdRwTTUXQndSYtLISEZjtoyCg9D1udrWF6d9?=
 =?us-ascii?Q?FNZ+vJya8B9XN4ndfPCUtLuv0WBoJ+y6hsBgZrXW+UB+1tAwbKbzSOiRLBEh?=
 =?us-ascii?Q?Qvlo6njnth+Q8ad4b7ihPZg967uvvVdfYyD+C5uilyfefTp55RIkFKerqzJ4?=
 =?us-ascii?Q?vzB6HGofLs0BxtyG4r3gSKIsF2oeLgQzdKQs64ItSJSk15k6DZQNBG5bY6+b?=
 =?us-ascii?Q?TO71FGWxNq7EBTIVX79cBNcoBc8aqvjoKnzOYhzxvWOXa0Tvgk7HJE/l3dOA?=
 =?us-ascii?Q?kolj/3J0rviTuPAkqMKSODf7CzJUZ26Ekn1q8oqoz5oGwUu/lfEn5+ik6s0w?=
 =?us-ascii?Q?0YO0J94YPMkdfEBo6P/+lLVn+6ZEGc1dAEtcJbV/Gt6B0aRZ/uAodNZvHQ+K?=
 =?us-ascii?Q?Au9nw8vT1K4dXFqgK6artRalTVTgmH0n/lizxF3LFuxZhBuX6T2z6fy3DWSb?=
 =?us-ascii?Q?7SGBBDLl8sKu3uroi5NLBbe1Vp5J+SC80bOTL3Ys?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 49PDd1KTCDW3HPfb7mfhs7eHfMAvqqyPWjbnIjrsuF2rYkH4lJ4yn8eQe5hZl0ALAidTq3EP1U+luUz3gzjMm0khnr11cmjrq3iiubKpHX1Iz1pcZyobzA1VudiJjGDVahMoMv5uHX3WGBDoqh1amxjqi52E2nxqL7xxR2oa9qArHpfziJPJoUlK+1uLJ+byC4Z2hX0gI56mtaresLdNxrNwMezFgchxqdKj1kmafnWQCIcjmj9r/29oMEveCHHHbn5YsCt7KGzjacFpyXP2Ww2jNKbnr9lfU2Pij7hjonSulHCiBohQ+9osa6xZzqzERIiMC4YhbC+WEqJTQiUXKeEs0FeJvY3dzecetJCHsT8Es9Xp+jXTKBxwxM9T06a4mI5H/JO+E9ZZX9Ktay0pr+1wr5Bb9j0Uy/ZHRXosuxjkAxNt9JGz8V+v2HAtZgBXsRNvmwU6XIUZLDjEhm0+vnOMcof//oKb70RnkxgstZ4zMw5O8z8YbI8j5NafSlxHn+kj1TPd4osxOrN364hyYnjNYXdm3LlF1icgb0gO1MdGSV/O74BTRXHLmoGc4qVL7nTGHeNqXRePlziufM/vUxTfa4Bq0x9tsA5FIE5SGAz/Cb+QWSLA0PgztOuXmEl8jvHIlc7uzVvZE72S87tkzY9fPHgXeHoTWH5gwGV03J8H5SoDqKLiq+tXzPMlTCXF+xLmKBAAt772TqqNLEpaPRwadt2fzTq1TMNXKtuoBzYGUTc6bm71uav+B6akhi0LyHe7wl1il7oRYacUidSh4mupqoGKUYoPy+WlPW/ox4c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8aa2628a-07dc-4c17-1914-08db89cf4c88
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2023 09:46:03.9016
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sSmchm7+ziOgvzLnIFGB4QIjX505EeaJQi/BshCeVGwgrknCV9PKBkWMGwbLFWEsmxXH9kenqZBHfsbG+aKUeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4412
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-21_06,2023-07-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 mlxscore=0
 bulkscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307210087
X-Proofpoint-GUID: 1bS0SgR6aEpT77VZ3X9oo9RML7U5k7Pt
X-Proofpoint-ORIG-GUID: 1bS0SgR6aEpT77VZ3X9oo9RML7U5k7Pt
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/metadump.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index 6bcfd5bb..8b33fbfb 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -51,13 +51,13 @@ static int		cur_index;
 
 static xfs_ino_t	cur_ino;
 
-static int		show_progress = 0;
-static int		stop_on_read_error = 0;
+static bool		show_progress = false;
+static bool		stop_on_read_error = false;
 static int		max_extent_size = DEFAULT_MAX_EXT_SIZE;
-static int		obfuscate = 1;
-static int		zero_stale_data = 1;
-static int		show_warnings = 0;
-static int		progress_since_warning = 0;
+static bool		obfuscate = true;
+static bool		zero_stale_data = true;
+static bool		show_warnings = false;
+static bool		progress_since_warning = false;
 static bool		stdout_metadump;
 
 void
@@ -100,7 +100,7 @@ print_warning(const char *fmt, ...)
 
 	fprintf(stderr, "%s%s: %s\n", progress_since_warning ? "\n" : "",
 			progname, buf);
-	progress_since_warning = 0;
+	progress_since_warning = false;
 }
 
 static void
@@ -121,7 +121,7 @@ print_progress(const char *fmt, ...)
 	f = stdout_metadump ? stderr : stdout;
 	fprintf(f, "\r%-59s", buf);
 	fflush(f);
-	progress_since_warning = 1;
+	progress_since_warning = true;
 }
 
 /*
@@ -2979,9 +2979,9 @@ metadump_f(
 	char		*p;
 
 	exitcode = 1;
-	show_progress = 0;
-	show_warnings = 0;
-	stop_on_read_error = 0;
+	show_progress = false;
+	show_warnings = false;
+	stop_on_read_error = false;
 
 	if (mp->m_sb.sb_magicnum != XFS_SB_MAGIC) {
 		print_warning("bad superblock magic number %x, giving up",
@@ -3002,13 +3002,13 @@ metadump_f(
 	while ((c = getopt(argc, argv, "aegm:ow")) != EOF) {
 		switch (c) {
 			case 'a':
-				zero_stale_data = 0;
+				zero_stale_data = false;
 				break;
 			case 'e':
-				stop_on_read_error = 1;
+				stop_on_read_error = true;
 				break;
 			case 'g':
-				show_progress = 1;
+				show_progress = true;
 				break;
 			case 'm':
 				max_extent_size = (int)strtol(optarg, &p, 0);
@@ -3019,10 +3019,10 @@ metadump_f(
 				}
 				break;
 			case 'o':
-				obfuscate = 0;
+				obfuscate = false;
 				break;
 			case 'w':
-				show_warnings = 1;
+				show_warnings = true;
 				break;
 			default:
 				print_warning("bad option for metadump command");
-- 
2.39.1

