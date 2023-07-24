Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD8B1EB64DD
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Jul 2023 04:36:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbjGXEgp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jul 2023 00:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbjGXEgo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jul 2023 00:36:44 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B96B21A1
        for <linux-xfs@vger.kernel.org>; Sun, 23 Jul 2023 21:36:43 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36NKlNkB003163;
        Mon, 24 Jul 2023 04:36:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=5sF550dpaQoiszjKP4QVc8CaDyyVb7656y+9Wv50MQg=;
 b=sU8qQhWKdjCpEVYiX1CFZ5C0iozxpxwlG1Pyu49Tm6krVRzCDGkVjTmc306ozIGxQtWS
 dp+pVxVoUTicWezvUHxzQhHmMi+uovxVeZi1nrYdEDrZ108rLxleWCDA7YGGo5uUg+OE
 QJqkTQYRLUK/SvJrFoQwQxQmTtXBWX2VY3rvgiUqzk17U+cksZNxSgHe2Ac6K3OHGfZP
 ps6Nzw7XNKKaxeeYcK5k6EYElJhyW5P6yzlc+jQWxQy6AgdALpENuQYqJ6htEUJ65BsY
 D+rtuiqlazMWEzTOqwMYyMToUFVQUlvsxnd9VFY8Cbyqq2V9cWi1Txx+5qy+JppootzP UA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s070astey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jul 2023 04:36:41 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36O4CAEE027586;
        Mon, 24 Jul 2023 04:36:39 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j96bkb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jul 2023 04:36:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lc5AhecrkaByXzYfz8IMoXotONWyQeIvwPQaiyoB4pKMq/KtCdbyE+L3NzxukFXdpOrIB05NX1MJXhPW17fgGYZS00VWq/sFO9UVCV2whp9Cndr8+ZHAOYUUAhHQov4Z9v+BwzapGhoztEPQs4OoFU6i6C0/dRNNrbz4rodjyNA3Cr4vR3eTy2KIXqj8JLLycCaU/EORyKOHAiwi//WV34zsPHzHAt2SVGJx0QQKQd8dvHP9jXSwLrBn03T7jRtYRrHkuv8bf+KcFLnuZld/Qps4xq9wiVFCimTKwLEZ9yRL6CMVHsq6ib+2boWHpFcIIoxkAhEetRGVz78B+p3kNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5sF550dpaQoiszjKP4QVc8CaDyyVb7656y+9Wv50MQg=;
 b=gFedKz8GunQbpoEAVD/icajRSOKk9+tgDN/GzNgYSPbPHdxvJPhu3xeq+/4VjQJpvFgD16wPnrAHvsV+G5SAKQvOcBvhs7Pwie7UoLXhJTV+HUhBx1MG10vvRLzoEDB0a2uQbfEu9iVEuBxpMN+n6K3QUGvuoPFLf9hRxWQSi0l93eCn+1y1FkrTrgxPWoT9AhxkmQN6QlnHw/o3Rg6qa82TZ+KppnZ5PKaw2BL8Sm97E/qXh+tB8tTcCK3uGMhsrfNVmQZn+vX/9t/JHVPe5tm26fXdxPiBu5gR+BvWcX0KPZje43g759lsQ68zX3LXYqfkv/u5U6CjD5debx7VYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5sF550dpaQoiszjKP4QVc8CaDyyVb7656y+9Wv50MQg=;
 b=vQ9GGSAGCAYtHkF8j2KITDf2FxgrHOM4XB+mXH7WQopOmunutoa2DeCT0QqrEDyTrGzC1TwzgtYJ/TxTM6UVmjxQJBQAzkYLLudpL1SJNBTsPj+PU5tIrZvIHnt83ZwVCSUnHVKJSV/sDm6B9os2iq2A7D+CMWsSx6vBUF8BsKs=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by PH0PR10MB4774.namprd10.prod.outlook.com (2603:10b6:510:3b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.32; Mon, 24 Jul
 2023 04:36:38 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0%3]) with mapi id 15.20.6609.031; Mon, 24 Jul 2023
 04:36:37 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V3 03/23] metadump: Declare boolean variables with bool type
Date:   Mon, 24 Jul 2023 10:05:07 +0530
Message-Id: <20230724043527.238600-4-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230724043527.238600-1-chandan.babu@oracle.com>
References: <20230724043527.238600-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP301CA0022.JPNP301.PROD.OUTLOOK.COM
 (2603:1096:400:381::7) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH0PR10MB4774:EE_
X-MS-Office365-Filtering-Correlation-Id: bb5cedcd-ac0c-48c9-7a95-08db8bff9129
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RJujVvmVnC2Ax8GY7NSqs5qzlKxUdFwhnvkzn65LQBPSpwq7eI+IsbZzOwHHrNZUHN/cLBRzWgjYq+iDFj00Apsr1/NNilKZ0ZumgMV+BLEICIuHJ4ERp7UuBYqBy1OQEHKMgOxjIhZevledoukEsjCV0Orn8KakoJ3IA3sUvHSzP7qtzxBjRFfOsuXNvhDkA4r2BNnA163i1H+f6oOyWnjvfUrwqSlf4WQ205yMxahnvUYD4h0lOPxw6M4ykKx8jCZL8/cGcIwntxO2TvcOc62arGgI5RYbyIPEM6WrkcKM6gyV0DJ7h2OFfZ13WuvQTZ0A3QVSJXXzgRwvIraykN/gopnrAl0Ge+OyNlQSjT96mtCUPx/FMrhj0Z+nDhJjFU4EUFOQ9qeVqUTfsjRjIhcAbHC3CSX51P6THrV7IVBWDM+Dpc9Pgi9d4PjOPXSHeJZvYA+pWZcCe0u0xZSQKG9iF7A0nJZO98z0xEZUcahNPtFG/1NXmshIiA1gc4AnPmrVjMv1dfcOBWhTt55mNPQZjhVsM2YsC5Cd5BSoymEHNoR9vWGI8c/w7FR2PazR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(376002)(39860400002)(136003)(366004)(451199021)(2906002)(66946007)(66556008)(66476007)(4326008)(6916009)(6486002)(6666004)(478600001)(86362001)(6512007)(83380400001)(36756003)(186003)(2616005)(26005)(1076003)(6506007)(38100700002)(41300700001)(8936002)(8676002)(5660300002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oS2J3I019tbmY/tZOGUhjcZSPBP4O7q5oOcWmI7IJzKjYflw7KaY0HuuqUoC?=
 =?us-ascii?Q?2MNowMg1EIDFM/YmwQTXCFpMXAxMvkRkAJmHZ71EdfjsGMo710aKA9kDmbG3?=
 =?us-ascii?Q?a3c/PlYHY2M7IiFBYMMCZQSPgHUA3M0j6hIXq9UTwv1p8Z8GYWAqRHlxT6Dj?=
 =?us-ascii?Q?2Nhzf/idvghLWCMTRfA8VQP8v4dAd87bO/eZbtb8bk6Puj/rU9Em00dqsQPR?=
 =?us-ascii?Q?R0wWSUM965GCc2C08WRjFijhyL1HqJ+z2sluR4C1DdUyr455fKm/hgAaoe2M?=
 =?us-ascii?Q?ALHXtPIUfMv3xC9W+kdBxz+5Az7j9+MBkgFxjqoyRNFO/uSRVM6buSxreSD4?=
 =?us-ascii?Q?0MIhBY4+GOmvDctQAlxAHwKeO5WISw/Z2qA7kovPPU59o2k3TsXhgmphCKkV?=
 =?us-ascii?Q?PK5cOlyIn4bicJDFrDK4CX0o5PwQKSzmVRpMN0xGeOkPM0k9gIkoYzvWZWEO?=
 =?us-ascii?Q?FqpnUn16Fxr3RhJUPVlOzOPf3hrZm4BKoGRYjrjxDPTthq9xSOM2iBrXIEwI?=
 =?us-ascii?Q?hkSRdnG8NaPc1Mw0a4UQYiHzHihaF872AdcfmDIpjVPqg+NtYLsUNtshm/Va?=
 =?us-ascii?Q?urbC1ExdMuISVuN4/NqoRr7L5L2YuHyWsKw1KfIUf33hDe2rEuvQrA2q96BZ?=
 =?us-ascii?Q?UNqZFTpSoayYuPl0ImY1mDRzUzrFZ5GFTwFEadUEr6YG+XBvikSXYFfpFzfK?=
 =?us-ascii?Q?5Km0yI+ppDTSei4QGCVKqLpMj2O2FfReqIFPaK9I31FpfA1sBWH8Jsn6pauU?=
 =?us-ascii?Q?fpmXyICK0UqDoVheR+PKm1aCytAVqfO1pyH8YD060QkXzQIIDisvkfWrD7GA?=
 =?us-ascii?Q?67v1Cs2o0elP/2EkO+EyeRWAjRiQWnstRytD/Mp9VWpQ+gLzRAHzAcZvDm30?=
 =?us-ascii?Q?PeynsuO/nNboC8gALbOxwBOqX45kYc9Old03mBMWNecnzbmVo30QQnJvvuMh?=
 =?us-ascii?Q?xaffO5lUSMERWRjFucVsVzdw6+mZuy9wr04cDbsRB0XKrIAKF0kDLmNV1o1P?=
 =?us-ascii?Q?VcgpeagSGzX6TDsD9Wapnh43SPprepvI8uuk2QspGk+2qeZs6zYQCnvKfk3f?=
 =?us-ascii?Q?pu16fxayEAw7FinV2eRvcBg9Hg0EBAyCO0N5KMbG3zW8fBgP5u4s1DsjTijV?=
 =?us-ascii?Q?x3E6hcBXqHq+Vj1KX7WVYFO69Ptg4XNDyri4Ijjhs5ph9eHnY2+w1Ebu2hqo?=
 =?us-ascii?Q?0fsNn8ypYAVOieZor5bHvZO89jFtS7gT0kO9jYB+XVEqsoMqnuvc7hE0y+1/?=
 =?us-ascii?Q?b6PpaW/dDJ3mwIoRus3XbSrqNZfQ15CHMpAGkl8Itu6e/tS3VQD0+wk68tPr?=
 =?us-ascii?Q?WLkrplALDQhaDwIQCyjk9hG/GbemdgOt3rbKo5j90/62EOocPH2LDOrZ8dEh?=
 =?us-ascii?Q?B9U9wD+P4aMQVhq0IOMeAbiZ6Y689R6kj1Im02fs857gH8R3EpjMtvsL+egG?=
 =?us-ascii?Q?dNtN0QGlAmUXRnAUvbNB3r2YtfS6piEqB0utloAGYJ7nhEXwmRL6Tkbczr6T?=
 =?us-ascii?Q?UESMYYp75Nero+4fLsMZ5wjDQRDpPy75FrimZW3rFCnXJHg2uv7YYucBFQIj?=
 =?us-ascii?Q?I/H/td5sPPjXdTDc2OQ1QUko5ZrUEDm0M49Tcw4H?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: +XMDVemAJmZ9ppw24ZYeyscOJ76uKBHZvn1pbgJoe/SlOtH+5/rHQyj7UONizY8Jcehwz/mn+S1nJACS2lgXWLP05Efm7/DGFpQg1+U2fRtqdtW5OqL46fmBh7nX7uk8bsHflIttMFW/vZY10xCK5oy+S1gWc8rqh49Ihym/QL+649Udxfjo3qSz+pspmcrZ7bZ9Ty4N5utXTzTPduVKflY8NrabYhz9qBGYsEImrjYdjoes4v1hvbHtr55hhxFlD0L3GgJ9yl63oO3UhVp3EO6cvtbQ4wgEmIwr1m4jXnf5aZGLh9zMuelNiYdXV105Doauq1I91TEu1IAXUURqToVLDNFsqXKu+j1LV8T7DYK7GjHQaQTPg575Q3bLhNUS+Ou1Au2njAdluXZB6ZtAQlc5+OZRYcrKTH4S/OnaFFgjU2CwVzB+6ta22T0dUSIUhL8cCx2hGvGvbkncFuwX4eUwRxPOSX04biCvq0LephV2JlanY3XmeyhRYC6s5RtAhTZaoMsAvsQB/WgMfp1IdIEnYkH9wwlZM2mWm7JUWCM04tMvTQ/1E9HjWNTTl2RT8o1c7iJo3IANloQCsodEvaRILT/qqbsyAr2RqOGmXPgGEC3zBiVj3FPz0ojBu5J7PdWAMEg39t4VXXBHOL4YBdUCfdwEGD4MU4VXi+O3KeFP9e4xRj5EWwJMDkGFL24WEAqc3a/LBeKVOiOGfGzM0bOAJjhiV4KFdJgYsp0t0WeTJ0F7gtG6jHLwwXUbDGQULLV7ReJpaKDLaXy/acgF7gDO+mimQHKiIaQqAmtBfqA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb5cedcd-ac0c-48c9-7a95-08db8bff9129
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2023 04:36:37.6920
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OlugSwi2sc+79ZTGmK/KBEPYKz832e4XOu3EgLawYjnL5M94tj3ajLjIqfopwd9RY/mua+0/OLTFR4mRBJIUqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4774
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-24_03,2023-07-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307240041
X-Proofpoint-GUID: FsWe_UT5-7pjIRbCgXte-C4Zlzc4d2mK
X-Proofpoint-ORIG-GUID: FsWe_UT5-7pjIRbCgXte-C4Zlzc4d2mK
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

