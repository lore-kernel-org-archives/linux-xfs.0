Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EF51C7EE24
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jun 2023 09:29:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236651AbjFFJ27 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 05:28:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235977AbjFFJ25 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Jun 2023 05:28:57 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A169F126
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 02:28:56 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3565vYdt017460;
        Tue, 6 Jun 2023 09:28:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=Unsf/ykaBVUIqyu9RujVmDC5LVSI23vO9ARiq+Ht130=;
 b=tP0ys05eDp7ghIAM/YZC2T/3sWGXb1+Hj30Uq9aqnnl8H+cvuDubNoBplvHoEcJUrDu4
 6LwSBWMcCZFtJ2jBvldIdCVTkVei0OtXB9K69EgoeV92Rr35fsDJosaVLdcZqgOzBYo9
 yRxuQkRQ5mqDBCAaq4nV+iD8ilRx0m1Q2tfmPPtCAnenTYBGdKMMNVJavUxGIG8pWb5g
 iti/o42+FHaKi7Xj2TQ350ysQF4NdMSfjk5P1FWavTMhNmagYLF3l5dVfbCpGXJiyvKJ
 nV0wBk/TXdnRyahHK6oXWs5MNGqOzycp9YlM7GWMtlAHYp3wvHGHq4AEgZISbENVQ7H3 bA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qyx2c512m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Jun 2023 09:28:53 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3569Rj0S023676;
        Tue, 6 Jun 2023 09:28:48 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r0tq8wkc2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Jun 2023 09:28:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fPm4C9tre6ZslMq4eB/VEv2m1V/EA0eBjyIhGCrgM9OLL5y/C1/fW8tSqCi5ugQQ8MTf5D8CCZM97IFXlAp85lcTliY/A5x9dtRgwC7a0ZBZOWZQD7L6ZdK4W6O3yY8ZQkxf9GiECfmDwDOAeuB2kMxNxw5JU0XRq6kzt33Z2lvbtbOM791H4WkJ7l2NK+6H6qxWy3VuOGEs5l/TVT92cz2LWLK42uAKO0jOyQkSaJacEDoYxfmjVIIuxlxEoX2LVlVnrs1CUllC5JZvzA+J9yfAuDUU9x4B5iprXgjKwrb2tBtCL+hj5jg8KWidxz4NNVcbJUKhR/Gu2XH8p0pIag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Unsf/ykaBVUIqyu9RujVmDC5LVSI23vO9ARiq+Ht130=;
 b=E+iwsFx9DUM9oTA7glAGJZ9Hs1k8WEGsv1WRsL42pPSm1AMREyqHdLYPhfEeHF4H4myToB08iXzLXwd+4RZBXVnpczQvwbIF7MoQLYy7Pb40knX2AMQ5jOcwyS+MqrpTQH8w6+tON1joMDswmid3QeVQVvBH0drbfGYG3PwRS+uDqtl54FJdRe3plW0uqIT+WrUZhXIbpecGtME0P54i+l6TvPsABjxM9XU2CrHyjI5VRClJGdGj0+AQkvdcUc3Lc/hv1Yq6GnKptSsGT7uJjim23h3veZVGj1c3yNtaFlJj3ud4ivqVV/pKXeY41XkT0SY8nQPJmV6yCR8xF2XOJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Unsf/ykaBVUIqyu9RujVmDC5LVSI23vO9ARiq+Ht130=;
 b=ZkmO09HoSQqHNGBQpceEa5SYRHG5/y58w/sTGKyQZ8oQvfA30AO33Jrpa6p2BDIo8/zwK9gbxFxy+VkiQBM88fOV6pYbIoKYZvrsl0U+tIfBau3HTTUOiup5i2rR1K0KCtV9dC9SEQtdwA+884lXzLAuUS2hKvP1+AiUeXNZHbI=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by LV3PR10MB7747.namprd10.prod.outlook.com (2603:10b6:408:1b0::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 6 Jun
 2023 09:28:45 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1%7]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 09:28:45 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V2 03/23] metadump: Declare boolean variables with bool type
Date:   Tue,  6 Jun 2023 14:57:46 +0530
Message-Id: <20230606092806.1604491-4-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230606092806.1604491-1-chandan.babu@oracle.com>
References: <20230606092806.1604491-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0035.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::8) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|LV3PR10MB7747:EE_
X-MS-Office365-Filtering-Correlation-Id: f531ce16-2734-49e9-26a3-08db66706cbc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G8SxR99ARUYd54A+wB0ur3lon8ElG+BuPW36/7OjvIR33g5dNxpe0X3wCzS9n417iaoL5A8KUTK+BueoXSazWP2x1ItjCoy1GFEzOSoRLy18IGRTU5agXLKoQH8FiDbPN3Qxg7QqlYiFVtrmLTk1VmnuEkSKZV82/+7zCjkdfQ99zcb0ZbxIHViMGLWJ2WjsyEgict5mb+KE2FQJye1Olvf44Vc+5ahzRjSqdr93Fo+P1yooIjGrmYd1aTz0CawUkmAyEYb/OqQoFJIm2UceS+s9t1dRfwub0eZP/lnDXInyRyvfeX/HxB29OSTcVwZfdPBDGgRgA8lPMxFsAgBXvnnvic0flDXzVAt6CKo7bcladFlNbKtgnfUJrvbgpVZYNNMPe6H3T+/l5JJQqlX26DFq4fqn3P922xa4B4CrMURf5svVDs4rnyjGR7BFjqIsQrh/7lNaHDLTjPq0wpAitbQ7+T/dur4KEdUjiZ++YtoK2nGWm0uJL5l9uDC3VlS9cCveZPtQFJ/x8IqLVnphQsoeiv0O0LVIf3vUZyGMTXhuxTeve/QW9VJnGCJX6Lae
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(136003)(39860400002)(396003)(376002)(451199021)(186003)(478600001)(6916009)(8676002)(8936002)(4326008)(41300700001)(66946007)(38100700002)(316002)(66556008)(66476007)(2616005)(83380400001)(6486002)(1076003)(26005)(6512007)(6506007)(86362001)(5660300002)(2906002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AY34gthZWhciF55nXMBbOUrYQe8ZMPea958teColOr2SPzXIdQ/lBf0avUkn?=
 =?us-ascii?Q?J2v9YvqT0QCX+7PrAIDcsM7/y/nsKS8HIn7/Eb8Jzf3N5E5Udq5SJrtSATmh?=
 =?us-ascii?Q?UmiRmWRgVV2SwUrrUotc/aAxA0WN5k8vZJrbDfzwUmWvh3hCWzcyUYD7KBGN?=
 =?us-ascii?Q?Qlktk8ZmMSr1f4zLPie7s7s3ZCEJX4+mdrnwuD9zEQW4Z6aho8yP4GHZgvLD?=
 =?us-ascii?Q?/7/LxK8D8IAEt2Opz8wHM1tmWhBFGdg8UALxOIp8ZaxOPpJneL8K4TKINK7g?=
 =?us-ascii?Q?tG7/KiWj9HE5EwlwWRzzFXFmNqquUvKafoDGrkVAjJZSts6IYgb/CrH5MVxL?=
 =?us-ascii?Q?aoezYiNk9gQW5a5pKRbj4aIH+5xTTKDu0OaJCMFJvSGhrYAogW5nhnaBZvbv?=
 =?us-ascii?Q?WNJnqkbD4QQ8j4Fecu6Ryn6Q/wdt8ep4K1pCGm59txpKV5vy5ysXxAzTyElf?=
 =?us-ascii?Q?pVExHE7CDieUc7GKjs3o4WeWl7ur69mzNR/mP5XrRk9lfZGnU+8AjUWGHcE6?=
 =?us-ascii?Q?RfKZQ2l6WdAk/ZPqQHIdMPJyqdr7YsV6p52h4FGAOa4IK9nDSNET7nc/GOqP?=
 =?us-ascii?Q?z402QJFGmkn9Ur0w5k/zeQypyr6s3LqzPNH9PcTT+MMzO1tYtDDVvNWZr8iE?=
 =?us-ascii?Q?irSom1cKuQgYv4VxrowOYkRjvei57uqrldc+1B0cFxyDmwXN2FrR1nr7MOJu?=
 =?us-ascii?Q?3oLy9Lx+dtjiH86N71hBS06jV4tuibDUdFyB1lr0+eEZ/QBRIrChknIkZIPo?=
 =?us-ascii?Q?48UMMsVWHPTdhDfOi/strh0HA9XlbqS263zrRgcgZF0Zf7BVCpOrxo7XDe91?=
 =?us-ascii?Q?FsHxMuY8mIKVbxNo/aeS+JbkheSuVgAkyyOhsqOab3goFhfbOkSSP1duB3ja?=
 =?us-ascii?Q?yYFUqhcN3i6E0BOvbo18dUXunSldsL8vxTXXGb0TIsXS0vwgJurSx2PFqvvh?=
 =?us-ascii?Q?UDMqXPLmO7uw0UDk9Q+52sWksX8th+UDw+6S+ibULVQSOjX+wWeA5koR77mn?=
 =?us-ascii?Q?rqpFyEoplRA2sAZKSJUBHyR0AUUJIAh58nw8uDJCkWips9Dg2VAlzT/i2M4v?=
 =?us-ascii?Q?//XBsvNh7MFM527PD6T3U8SGodCdh+S90+IlCguv8m+JyeRPumuEYBse2f2v?=
 =?us-ascii?Q?4FRhV1ECr3DDHXaawv0i62GWrMwAoja+tZv3nxDn4F4Kpg3toRgJiAVjMr1c?=
 =?us-ascii?Q?NCm/rv94H9MZbayM2n6WW3PGBuxMTJc8vxGROcNm9uxg6Y+KuUIHbwRKR8c0?=
 =?us-ascii?Q?mMn5pvpKwBw+5276ThHCEP8yZ12cOrwcmYX+avZZXoaimBVoaN4w2evRX6wa?=
 =?us-ascii?Q?hUt5v6W6JMUYyL+XJ1XDSofFadRvtI4jL9eGcaZQ6cZM2UONSveQtCBxiKSE?=
 =?us-ascii?Q?fCrw04ai7WtK0gLtcsogQB9eqh6ETvSP9ksUbQuhM7AIw1dMAqKOOS61VXhV?=
 =?us-ascii?Q?IgcmYc8yyFM0VqKBpWrOfWAfV8+Zjr2n8VMq0WmIbOQZxp3rNBCFraydAsAX?=
 =?us-ascii?Q?LhfzSYcXx948R6H6Ce98C5+pMaqMBHBPUpDQh0WiPiRmp+3ogRLYTbnO8jRu?=
 =?us-ascii?Q?50RJ5rZ5ttrt3NSn5tCUsNGjuEG9mNpLdfBMzho4?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: MPZSHi4jbd20zPGLlmwRXu556AKAjnVnCxrl4ANPQFlECOLbXcuGlUtFJzwHONQsV2FSKhaD+w5dPRQ/V7J9qHWsetw3phTZluMgwNyt/eEiKvqaXu4NBv/7Le7G3HHHpWU+z7Y/TZ/RrhPf+VNeI9JWq9Vp+Wuj3Q9HKGIWmyMv7bYIJ2BzYWTxGx4/lK+5CFyOzCB37Eaf4undstoohwgM0hMX43Qp3BWuMISy/KGPhxP925iaxGI7oIFWt77eMLdmdLTZAFdSJ5k3zZvDI2mh7tx3XWdw1UvOp8eyyl2nxqZx4UP0wd8afQ2mxEG2yITldtMwPb1VJcmBB1TZBu4Qk4GMiic/Uae7DHr3bWD5WjKMzMiGfXCQUrSXmRO40KZXH4GFhC3M5mt37i6LF6D2ThN1gvpHwQxYV7ve4bI4gBtkzPPckQHLbDKMBGaI3j0I2axJz9LYPo11V83MF4lsAZlCZccjMziDYS//wzDOI826QOKmv98R6XRyYEZA/Q2QGUSlCQDpr4EnUVWfjxTiyv5GgppidsonrAIhL/CzqS01WSJGuuX+mnGEAjeurmN4rOvRhFTp/4+1U9bFmFNI+yjW6C6/ieliG1h/mCmuBcBU/OGervDMbGdMCFwUMmkG8H25+CmpgAgBPUdhMCygD9CInuq6G+iJ5iFFuyKJLp+qjaLXhTyRLJsihmMeyXByb6RiYWcZG6DszWybpjr8+8gpyrVPPq31a/lqv5RtbTUoaT+Z7UkJ7jacGHrPDNTfz8gjh+CJ+T61+SYSzPWFgtrMdX5LCZ3WzS9Tp8E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f531ce16-2734-49e9-26a3-08db66706cbc
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 09:28:45.2595
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QMijPC6XxhZMkY1xLYnRlb0fQ7SCJH+8Z4VIoDgeYuPW+rv+54eKZjKTj5ZWL9afxYg8vGIQSIpIEeqE466z8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7747
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-06_06,2023-06-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 spamscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2306060080
X-Proofpoint-ORIG-GUID: AW9356Gl6zsDZCp10jKPwE4p5NO_xnN8
X-Proofpoint-GUID: AW9356Gl6zsDZCp10jKPwE4p5NO_xnN8
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

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

