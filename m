Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72480C4320A
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:19:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5241F61108
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:19:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235711AbhG0GTv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 02:19:51 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:47930 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235474AbhG0GTs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 02:19:48 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R6G8Po024355
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=YxfjybZ23+zIY62NOnafDEhCL+2jKFKsa15z3nkqoUA=;
 b=THACtVBW7AIw8jAlu80PmoxTICyQBMm+oIaBGD2HIWIdmUilyEjrQgA9Nis6Qxc/cM0W
 UD8yF6AgSn5Vc/sLyU9rgQkjTt0/lHSmpYSRjXSfob90gy0d0KzOR8CPr1JFWanWhCQd
 n1uvMNzCX5oycHo2YWCPEKHF+Ic3WTK6bDRgX3T3vzHs1UieKbY7evmOxGgHmaPDJO+k
 Z3r0EZgdYu79L+dqotzxEldaKEBuqg60xU0fuRfOb68t83lb/u++mFMA6E59qcyyYBD+
 07si3rfO/clYXZ52HCwdUo7fgXKar88+LnDzQ8XEebidTTe1WVLrydwlJvs/UNXenG7B ig== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=YxfjybZ23+zIY62NOnafDEhCL+2jKFKsa15z3nkqoUA=;
 b=FR28ZZE3HTTNxinY5cKjkRxHuKq6ftcaJJcBlZRjSGfACbTU/UNtKA8Iv58Z+EdQCpUy
 qOg3kYlxGa3I1lbtd5MtDlyXXUowSPG1ctE93ReO3msTDQuXqljPYB+bmxszk5VAMcVy
 vxeRW4V7hmAIy1jb7C6WzWszhnHI7uoZ1qjXyFq/lSXyQCTSBzb1cG4E5JjXJopUgQ99
 nsof4MyLPV/g1O7B+o8e6r43kb6oVyenXektzhF121HqBYzBujq8FiuRGtol/8/YmRlZ
 7C2YTlGwzQAGECGKBcQRGLeQfIj8sGB8CYCCk4Iv7Km0U2hmV8YMzVMPzBstvsBtipja wA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a235drun3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:47 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16R6FUJ6019917
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:46 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by aserp3020.oracle.com with ESMTP id 3a2347jxeb-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k/8dnkFRkDom8Gf15uxzXw9xRCmOsVRKeHpvL2H0NuoCH3sreadBDGvOiDqkmSTBnLUFJJrwn8KveD1UC73FN+2O2q6miYDPbheB9eF00Ilha5vmaLQROQyw5645Br6u238bJRksGji1G9040oq+JzhOfFoeIV6VZ7sGD8qTYePRqgEZQCEoj6Q5sFb5ON6CyRhZx5ZguhTMv+NCZLH8WxjUIOhq9cPZMFFJpT83lMlPzhsYu5aZoiRMogTlgaTblHFh6vMJFdQm+URCd6/mlM3EpyJgBTg8szy0KvMkdu8wU8MvvkOgwG+zBy3qh/CkFzIiS2jG/VRGl7zryU57KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YxfjybZ23+zIY62NOnafDEhCL+2jKFKsa15z3nkqoUA=;
 b=jzZEIitSLPyzqlB7c0hy8iW57ijNYbgudMPqjcgaCNHfcOMtMXmDAXe3JkEShFicFmifK2Jq+YFdqhjsJDNfic+xqjkg4ciJIs6h8SNQTjBiqR+nAD76+u0awpDgOxOVj9r4EsZgvy2I5d0zucbyp8ify8uKrtFJ5ippQkYcL5UTlMRiMfYEgF+E8Hz4MqciPcqbYlhfBD1ObIgWMLZolCG/pCNFkB9Lo6HS0A5P9Sgr/Kq9fgYBL6Tr1t6eSwI+Tg2w+Ydqua/QKHssDLm07+o+GGI1CTIAez96JdqZtmqZ+FE03gkYMGzfR7YrW4bE1OPAEuk2jjRXFBsY4A8UXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YxfjybZ23+zIY62NOnafDEhCL+2jKFKsa15z3nkqoUA=;
 b=MRS3s3EEDAldvXUNdHV3D0oKvDxi2TRzKhlOW6JHzvEOMLgksOAibbXAvVQli+Bl6me6xl/7VlD3pvgQiIlRAnlEsLgQDw56Dc/DKte5vFeceNbjb0/WpdKBA+UH8bits4YDT0f1cTZ7PmD3SvRlwf2oRkAqjoMaRPHZkqXvepo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2791.namprd10.prod.outlook.com (2603:10b6:a03:83::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Tue, 27 Jul
 2021 06:19:44 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 06:19:44 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v22 15/27] xfs: allow setting and clearing of log incompat feature flags
Date:   Mon, 26 Jul 2021 23:18:52 -0700
Message-Id: <20210727061904.11084-16-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210727061904.11084-1-allison.henderson@oracle.com>
References: <20210727061904.11084-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0074.namprd05.prod.outlook.com
 (2603:10b6:a03:332::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.112.125) by SJ0PR05CA0074.namprd05.prod.outlook.com (2603:10b6:a03:332::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend Transport; Tue, 27 Jul 2021 06:19:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 51edfd59-b248-4cdb-dc4c-08d950c686f3
X-MS-TrafficTypeDiagnostic: BYAPR10MB2791:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2791170AF29EF209E4C43C3295E99@BYAPR10MB2791.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:935;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fkNeU7pHRZ7epNnWkqaScLFOQSEZxDTzVrK7sDPmLEwk9+f10pEU32WrBSIrTA74ch1dHCqfLHuXFYK0PwKjK4JU+f8kGefbvMoF5Dmoq8f2wJtXZbO8QdpEKM2cPde3Oum9ix8ak7NCA5GTIQZlT/exRAu5MMekiG/dbbfsTR30yA21abE8oO/4TY+g1M7ZL4enGIesjPItbKq5f1MCw6o5P/IWgHH54xrPv7ZJVFlmEXO1TVYrMhX3mqezZ85a2iJyGCStKzqoQGMq2GghUVkABmojz6mmwEKEcBjTb+fV5oQ3g6urYYBfo2qiBZUGDp+lDS1ECZDuWb1y8zqGSYqlklA74M+l0hcRWzmDuv+1P/M1HNVjomKGjx+atU/+IitmKIQTRAd/vn9I3BS/LFQdoutiBbPkSCtz8QIJeQt1HNBzRXWUKn7xrFuEncLDQwrzpglFkfKe/t6CC3oirmnOgQkgH2KwfPG+5hXz2T0Ca6iMMwODUSefcAGJb2jcrQdZ6/WUco0kD5w3HOJD9EKU22MpurcVTRw2N60pQGXtN2I/A23psiiKC84D18EZesqtHykS+W7B4k2p9fKxcAmZ5pSaBBVcahtb+r+WHK9nuAUN4A7SV7U3J2WJc6U793DXAWQtg5HGZSsI9Hg00Ta31W5l/TK2aNzHoeffKrUe8zTzspaFKQ0zdp+FM+/6MJI6o7sANYVnStM50eoqWw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(376002)(396003)(366004)(346002)(44832011)(2906002)(36756003)(52116002)(86362001)(6916009)(83380400001)(8936002)(478600001)(956004)(1076003)(38350700002)(66476007)(6512007)(66946007)(38100700002)(66556008)(316002)(6506007)(6666004)(6486002)(26005)(5660300002)(8676002)(186003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bwGnCl4mA5UlarQ1G6vatAIki2RjpadUDMj4Y072OYzuXWcizRE1X5UZq1pR?=
 =?us-ascii?Q?Y2taRJNv1dFKEPmqcKK9DtS9d0GDBM3GPoQT8pkauSM36FKuO/wqbavPZ5S7?=
 =?us-ascii?Q?mTwTxhp1WyymVNlH04Ce31wIPdgodlwzY5SE82EXdxaiH7ph00Qg4ydp+xKs?=
 =?us-ascii?Q?xP9aZhO7tIPSqBJ21+6k2LUg93AGLtuWhJS9lqqJPyojP0nSXdJygEiZolBF?=
 =?us-ascii?Q?W+fKIKbm52ZFx0js6BiE28qWd+WZyTenHjVsz1XAdL83QnHGcV6Io+l1Z6c3?=
 =?us-ascii?Q?lEHzNlHI/7E5IaPqhExmBFc4MmbvpYIFZ3qlXPM+rjsk5n8NrJCs56+AaeFR?=
 =?us-ascii?Q?3N5eiMZaRUqnO1Jb9+x0SCg6BynlKaVtzQxfJvWQaGkM1BJUH1Su+JKB9IHd?=
 =?us-ascii?Q?vwf0txEM0R8doMHs6onxEop8j3p3ec5YvKPB+5lsRCw0vxS/7muudwGC2LQi?=
 =?us-ascii?Q?voU/3CHCq9d+7dfnmuFPyXT88z+kZ7KPOpBgBihsCxJyNMwU1gEuc2VQ0O0v?=
 =?us-ascii?Q?NGVhsqxs2PwNC2SIk5QJo/fCJvgh2MSIntlAeXala7DonmahJag9iig/ZGr1?=
 =?us-ascii?Q?AsLEa4b13qdfrvj7cExCtLXiteiepxo/XAn0+yw4f8WOdDFG6UCagDJfWVoA?=
 =?us-ascii?Q?5FeodPWViA10j/9el7PDch7OxMFZhX4zSOhD1qWWbfg1DI23Hz3hO3EsWm7b?=
 =?us-ascii?Q?fTBQ0vfTuVPrOW1kem3NxOHzQQozXWMyzxT7LETgsg/s7KEGBUyrIdKDbOoO?=
 =?us-ascii?Q?P8x+lymcA+oeo9uaBSs46G4biRXBJXckviRfN72i6wSK7ott3t3I6osYft4U?=
 =?us-ascii?Q?Hkgg88QBADfqq9SqCPsF3J32Ri27RQY0tEvbhkeknJySq9VPAygddK6t3EAY?=
 =?us-ascii?Q?HveUlgTxOCiIYDDx9Sv96Y+7UgAJbjvKtaZS4dEo+A8CL3qZKCxnESqubZbu?=
 =?us-ascii?Q?dRwXIHdJtDUk4h76rgPGDnvOvExfDKt0vlpcKZoo+2IPmQrVqT22u9/PLniw?=
 =?us-ascii?Q?0/JHlARnDygGpURcVcIEO9ZxZcQLWKYCD83o3gyVGnzszE8jd3HAnKqG9lj3?=
 =?us-ascii?Q?rVnIeEzNJKEZQd1q/LaMk+mB5P1deoHbymqLqJymXt8VuD+5aFFxh8bQt8cz?=
 =?us-ascii?Q?g5u65YSuj4dX9JsL45QGOxMpD8nCD/8QV9za5WCGABjGbcNczIy/EKHVrcBB?=
 =?us-ascii?Q?MTyfFtRIdqrO6JuETLJbfpJDf+4ZLxQCoTfKHK2gJdO6nEVWeBpsLP6Xi0Ul?=
 =?us-ascii?Q?48DXT0HtcyFqLW/xiltk0RetEdC9krAD8xNspuXhdr+QmrvxH2jDTUYSsKhh?=
 =?us-ascii?Q?aQbkx9gXdMY4oX4ubsz2k562?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51edfd59-b248-4cdb-dc4c-08d950c686f3
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 06:19:44.9203
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 69DU1KTMbZgMDlCqUtGWrECjoG0UWVcdbfhcUN6vFqHnlfCeiI46GAHmm7HFTur+qwttzX6qMkGtjH/Ho+9zlSM8ofnz5q1UAUvNkjmNoLE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2791
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 suspectscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2107270037
X-Proofpoint-GUID: HL6inXvCIfHtO3UNKlirZD-WvpDy1EEZ
X-Proofpoint-ORIG-GUID: HL6inXvCIfHtO3UNKlirZD-WvpDy1EEZ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

Source kernel commit: a9642049d91105c676526817b527a1a62940888f

Log incompat feature flags in the superblock exist for one purpose: to
protect the contents of a dirty log from replay on a kernel that isn't
prepared to handle those dirty contents.  This means that they can be
cleared if (a) we know the log is clean and (b) we know that there
aren't any other threads in the system that might be setting or relying
upon a log incompat flag.

Therefore, clear the log incompat flags when we've finished recovering
the log, when we're unmounting cleanly, remounting read-only, or
freezing; and provide a function so that subsequent patches can start
using this.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_format.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 37570cf..5d8a129 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -495,6 +495,21 @@ xfs_sb_has_incompat_log_feature(
 	return (sbp->sb_features_log_incompat & feature) != 0;
 }
 
+static inline void
+xfs_sb_remove_incompat_log_features(
+	struct xfs_sb	*sbp)
+{
+	sbp->sb_features_log_incompat &= ~XFS_SB_FEAT_INCOMPAT_LOG_ALL;
+}
+
+static inline void
+xfs_sb_add_incompat_log_features(
+	struct xfs_sb	*sbp,
+	unsigned int	features)
+{
+	sbp->sb_features_log_incompat |= features;
+}
+
 /*
  * V5 superblock specific feature checks
  */
-- 
2.7.4

