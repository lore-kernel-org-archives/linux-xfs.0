Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AEE5C4332F
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Nov 2023 07:09:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233576AbjKGHJH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Nov 2023 02:09:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233556AbjKGHJG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Nov 2023 02:09:06 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3AC6FC
        for <linux-xfs@vger.kernel.org>; Mon,  6 Nov 2023 23:09:02 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A72NnTU031384
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2023 07:09:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-03-30;
 bh=l0pNoZ59fm0VaFkivCF4gquo1FAAkx+AV4XSeRzAT64=;
 b=oMYSwpTbcnKMfqusIbqftLcUyMkWZSUqS0mhc/7zXTjYItaQ4GJrLGHD4N9xteGvBY+P
 tOhvT/n0bAQhmtNkc14ZtJbG0CGnD8N9uDCwThbAWNP/YDLfm++Hwgy8rvwdTnbqSu0s
 gUERmlVhEiHCtDWrEjIUHsxFxAiEkAEOG22A3uWTRRrSfu7DGBzQpKThNKDk/pC0Ru9h
 Jjib9RqTy6FervPpDr8dO8hGPcqNvcwbyT/YcbdrnbLcFObkI/0ddcajyB2aA+5x1Zy2
 vq/shpzU23YRdUvU9dwBGaa4mECdDUDzh1WTyDOtChWOxnXi/JeD6b2CKSXjKIWCLdlI cg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u5ccdw9xc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 07 Nov 2023 07:09:01 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A76PYwI030550
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2023 07:09:01 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3u5cd63fev-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 07 Nov 2023 07:09:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=foeEhIwm0V/tcZbrRWnWe47A5xVsLNxSsCB7wKYfvwE9b39qgGVEPizMa1xNVzu3PPWSwDYSBYyjpKIQmUk8YJEZvR+lOZOb32AEtTzTUqYQ2mW0H9uqLGurdBlhV2Nq5kV6FT1CeTIHdSDuCrutVVyyU5zyrCGl09vwENN3PsCE9z7VsjcC+mwd4gfft3Lpz+yTtHhU1t/sSwO/Ms4pMkxcxD70rLLn1E1s1YBNgmwwiUS/e9eOEjq8m5702YbB6oB0Y09RWYVM3+CKi/wDmFZNRHL+SvimKQ0+Hb0K2FLRk4jOJ5EDSKYBVmWpe3YtPG8tVRqR8dt2EZOT9cP63g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l0pNoZ59fm0VaFkivCF4gquo1FAAkx+AV4XSeRzAT64=;
 b=LpXkCUWtFG9aRoyPljsIGiRjkR0H0rbUCrV+Lt0vjs4fkvXIiPd28Ky1Pyh1cLTvEOfzwtzbFuC48b+6sYgrCs7iJJ7TXQNdWSN/e/XuA5VPfADuC/ghF2bNaYPPfSHC7Y0jbtQZVJ6yb6nymZ0bqTf40gdlAfPDxW1AR5r1Py+Ir5Y/SLWy7lxxSS+Comcrm6uWd7DjJIWnQa/U0XTLi551wzPHgfdiu4linY/q6iJd5tERiXrLkJfxl15p2hVuR0sjQ2UYNEV84GgX+xO8OAM7105Z8Y+wk/JYiPZXj++CoxVNnM7Jl265+zTwxW23ox+CNma1BUB3eL6hNXpw6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l0pNoZ59fm0VaFkivCF4gquo1FAAkx+AV4XSeRzAT64=;
 b=gtFAGkr/8OYi+c8ZQ018YttLAl2MgWCwHcBzdLp05UIbKMLh6sfnkJVimnTW5s2sxbpyHmJRjd8yBe1Nw1etjIxbz+cgdE/qZs9Ne2yMS0jBTF6rmarHIdEB8tAucFQ/z65XsfgYMyGe42o90rxBUQHEXz9hg06lcFJRE8ZLtV4=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by CO1PR10MB4770.namprd10.prod.outlook.com (2603:10b6:303:96::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.29; Tue, 7 Nov
 2023 07:08:54 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d%3]) with mapi id 15.20.6954.028; Tue, 7 Nov 2023
 07:08:54 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH V5 16/21] mdrestore: Add open_device(), read_header() and show_info() functions
Date:   Tue,  7 Nov 2023 12:37:17 +0530
Message-Id: <20231107070722.748636-17-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20231107070722.748636-1-chandan.babu@oracle.com>
References: <20231107070722.748636-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR04CA0005.apcprd04.prod.outlook.com
 (2603:1096:4:197::16) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CO1PR10MB4770:EE_
X-MS-Office365-Filtering-Correlation-Id: 2659e2a6-28fd-4ad4-d280-08dbdf60671b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lnJHFUn/meodeAND+RrPs3i4mFoOIC7a8sO24qMBMB/TaBE5h1fM/iA9Coy+o/xHARnKDRKQMPmfVu9rz1rn+yJpIYN8R+Vk7Ep2gvRH4K1h5YKPQWMmqSSJYMKLnEIN50MuCu3Hktg6uFjN+GJ8wk5u4vvH9aoJ/XhlXvE8WOfGsnVwUuefJEIcvENBknDt2MYpY+uCi+i8QVKOjQyw3aEcE1PW2/5iIYJ0Urodi9763iUcen8lVsv8lptW1pUpwC/sTgL9LasNonPGKHQwrkQug7KBO9/W1EfmZjle3KRdaBTM0ffy1OXXGknoa3wywbGZefo8O7McJMsoM4np+j6kEic3PfHs31kWCz0fdpKKh9qqKafH1BwKU/jRqbvmTvSwRws+0kGwcuiC1vbKmhkzezlXKwrBpJGCbpO24incZDLixyB2OlF9jx5E/P9u259Tvlft/3xf7QOiXmiHKU09nZw5pKM4HzRqFAzBg8DaWi4NeIpwVP10IS/Fi6jV/I0lJjt8x+eENRs5myGQkio5M3UUI4tk/Obl1UUfFRpxVqA+qKpIp9IkY8N1Zr//bQt6MRXgYjHDBVU6D64qz1ZGLwtTtLEfZ8AIyv5Ml+XLnitKOQSNLNl43qs3HdJ2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(39860400002)(366004)(376002)(136003)(230922051799003)(230173577357003)(230273577357003)(186009)(1800799009)(64100799003)(451199024)(6486002)(478600001)(6666004)(66946007)(66556008)(66476007)(6916009)(316002)(26005)(1076003)(2616005)(6506007)(6512007)(8676002)(8936002)(5660300002)(2906002)(41300700001)(36756003)(86362001)(83380400001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IOhIXhbHWD9bU20fsWeoiHttXe3KNEv/QV8xQaa6C1zFOV8VEWiu4i9hs4uE?=
 =?us-ascii?Q?ZMtJ7JKT+DO1g28iGo9ejFV6wkmEwBn0skpRU0mTNErd9m3oVwOktGHZ2zzS?=
 =?us-ascii?Q?DyOGH1L222iwxn3rhxBRnPvwDVG6RHJxUHt0sogka9GwiK3FORfToU+jgREq?=
 =?us-ascii?Q?ceMx5luTQTun+pjeVgOMZjq635sNCaR+KgQN/06W98paXUFOhCeeI0rqOslX?=
 =?us-ascii?Q?BkPqNLUS/CzFOky4UfoClDnDgScAOB5CJyHGdKmGHKfnvs7b0jiM8ZLZE0xg?=
 =?us-ascii?Q?siT3eA735kNK9QpIsfa8257mX0VfBuO+cgi4H6M+ylL65ANs9NrlruMmgpVl?=
 =?us-ascii?Q?NLGbR5tlYiPuwWAsBA9dCyE9EeBb+3bnUKcGOdveKJ3klhQfUq/IQGeBEPox?=
 =?us-ascii?Q?gEKKKDWS8OujDHFpnIbcsnyu0OzvIXMU2/B2NAiqMsON/+BtmyAHnOIM8qDb?=
 =?us-ascii?Q?8ruv6vsUS3yjIW4LiIi5Jtzzfdz8wkexYg6foZ5C8TPcYQowFg7M1KEPpaI8?=
 =?us-ascii?Q?qRarwl5MUGJLYlB5fgq6qsDB8R/7yLa6dJj2Ew4jH9KoCJ99J2ACXaCdOhas?=
 =?us-ascii?Q?mUopDviEwHMFHpR1p7EXJCCaTqHmE28RAE8byXkRHkorUGy2wHTC0y+Dwnb5?=
 =?us-ascii?Q?hVtQA7VFWnBSS4Lc3ieASJGdzTknULUx4/PyEuNxboq+yzGW61fVnDe4NqPT?=
 =?us-ascii?Q?um+FMmRUsVfUGCwcT6hYzLPduLu2i4THZgDXqY8x5XhH26xNPGsTXWOistyE?=
 =?us-ascii?Q?wx/FL8Xuyyx1helq40r/zU80NlrE83PrqwHyBTOpTZXdq030uu8BlW3ZeK0d?=
 =?us-ascii?Q?0tzmKeFRQ2li8+Kc8DDdQ9Fr0rCF2bO0eZp99bhlipJtpAuCSInb+p4dCYbI?=
 =?us-ascii?Q?NGIwJ+ARCZFFbeqfp4NNA5fm6yxQ2A/pfFXLmFleLmzi+eXn8XCYUAYcjSCN?=
 =?us-ascii?Q?czRui1LHXcRf7v4YYvyutfzZ0OI+WYMbTaxoPg6wMy4Vh4GNyMXanvffULjA?=
 =?us-ascii?Q?4BtiUEHqUGApvPX6qTATuxPEqfXOh0UFfhOhxThtttNcBt9OCFX3u2uWjjD9?=
 =?us-ascii?Q?Y0JYLnlUZ0cZzJCKESu8/sKmhQZwsePkbMrFCRCgiBMVhg0QzT3cNfyCOi3t?=
 =?us-ascii?Q?yP42Kp/8dgocxvF+9Zk9rFZsdB3AQq2SDHv+MI1OGET3cMOVwhllZ5QlvbDY?=
 =?us-ascii?Q?VKDq4NGKK56Qz+WXbF9wA7R1r0BMVC47uLqQnzCkX8TGT+BfTuelf9pNthtN?=
 =?us-ascii?Q?UGwmJukENCIDV1J3Y0SzQs0iH2DaRMIP4kW+sEdtjWULr0YnzVOajsXrnAKu?=
 =?us-ascii?Q?sUMihVh/7vjcN1Xv0jj915XXT0jsNs0HFAf92PhG+YHxL2UiDUIJoHO/kFA9?=
 =?us-ascii?Q?BbEKRb03DIds/gIAcHXjrpTAc4VKUnXxoB2Y1xIqn3gsntcJf07vbmVdCZ+H?=
 =?us-ascii?Q?zdauR5egro4wnGVyd2K8LPg//jVQBY7KFlcrMhQOq3fR5qBplGCRkeNEK/9V?=
 =?us-ascii?Q?hYVMSgFXmoLRtJFf0rQV3tNfAnJRkr0ay/SNDPYhCrlzqRRVh+HBF5TiDWte?=
 =?us-ascii?Q?3HcwyspPvsFg956V7CBgkQdp+BL4zyxBauNxFf/dbTYWVarHUybJ+lA5rO56?=
 =?us-ascii?Q?6A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: wKt4Fxb1kVTuQNKrbDnL4+xn3NipxOwXYqrvE+dSZ1B34pacnNwNqthv37qRS8oRruRvz1apJs9S7Y/eUsz8bzXGofI+s78ycAkgO0uShWkkQ7ImJeFZnxOL+M+f0xCOT3EBG5CVOmCthNxYe4d+p5/LWLqRJ5ZpTfCAtJjS9dfOcG/G0KDM4gMmZ2iCh2A2nfuPgg+Lkk0qktILqFb3TgD+CIzK4gTsE957Rqy34Skpe6Tk403YPOhItOjjvOYNrdqDK3NqAl3hi8gA6VcZq2Hw5t8lziE2Ap9YkBHQ7btuEr/SwKiz/Wn335B08+Xv7+0Sn0N5W/WGG5tA78QTXCrfnhpBWJBImpUr4NPJitoHhdm/J9S0yeK0En2VodYDnm6HZzAJs4hwBFaMpPrIq3EJkcLrw0H8IkGZFORVYqaHhy1SNEwk96Zumvh5J+Adbg0sOB1BZD+mwgLKETsTaaPz/IJztQ+n+ctiWHb8Ae0hdHzBIfdGG5b2z6Gxh3UyMibyScEzR3sOSyelbpCVY5n1cshEvxgcDOhQOR85tOPlv5AsYlg74vWpGaHJrdjaBMzbYc9U6cm1MEoipmaX/FymmGbpvWbypiNB78UvGU7fVEyPjmIGhfKFmwKv3YqF/kOcXBsdNthcicVkHMuBWQJyxtifUk1T7uxBf4sxGrGjWYTHsa2uwhyLNTgkngJQp5KR2D/NjTGk432RZCgjGp+Mh4jRhKxAQxD+4qOaF0jlycBoIiIFnavuFO2LT/wJk45MTp7MoxdURQECI1ADIQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2659e2a6-28fd-4ad4-d280-08dbdf60671b
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2023 07:08:54.5441
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x7RLJ9XSoGuKMDA7Zx3wIW144951jY4pD1tkov9d9IfmlR8JqwQQcv7j9h4qzYEibgTuV6UwYyOpJLXAQtN4pQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4770
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_15,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 phishscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310240000
 definitions=main-2311070058
X-Proofpoint-ORIG-GUID: Rr4uF-1b2a_j4XoEKz5VrUdx9IdTRLPH
X-Proofpoint-GUID: Rr4uF-1b2a_j4XoEKz5VrUdx9IdTRLPH
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit moves functionality associated with opening the target device,
reading metadump header information and printing information about the
metadump into their respective functions. There are no functional changes made
by this commit.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 mdrestore/xfs_mdrestore.c | 141 +++++++++++++++++++++++---------------
 1 file changed, 84 insertions(+), 57 deletions(-)

diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index ffa8274f..d67a0629 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -6,6 +6,7 @@
 
 #include "libxfs.h"
 #include "xfs_metadump.h"
+#include <libfrog/platform.h>
 
 static struct mdrestore {
 	bool	show_progress;
@@ -40,8 +41,71 @@ print_progress(const char *fmt, ...)
 	mdrestore.progress_since_warning = true;
 }
 
+static int
+open_device(
+	char		*path,
+	bool		*is_file)
+{
+	struct stat	statbuf;
+	int		open_flags;
+	int		fd;
+
+	open_flags = O_RDWR;
+	*is_file = false;
+
+	if (stat(path, &statbuf) < 0)  {
+		/* ok, assume it's a file and create it */
+		open_flags |= O_CREAT;
+		*is_file = true;
+	} else if (S_ISREG(statbuf.st_mode))  {
+		open_flags |= O_TRUNC;
+		*is_file = true;
+	} else if (platform_check_ismounted(path, NULL, &statbuf, 0)) {
+		/*
+		 * check to make sure a filesystem isn't mounted on the device
+		 */
+		fatal("a filesystem is mounted on target device \"%s\","
+				" cannot restore to a mounted filesystem.\n",
+				path);
+	}
+
+	fd = open(path, open_flags, 0644);
+	if (fd < 0)
+		fatal("couldn't open \"%s\"\n", path);
+
+	return fd;
+}
+
+static void
+read_header(
+	struct xfs_metablock	*mb,
+	FILE			*md_fp)
+{
+	mb->mb_magic = cpu_to_be32(XFS_MD_MAGIC_V1);
+
+	if (fread((uint8_t *)mb + sizeof(mb->mb_magic),
+			sizeof(*mb) - sizeof(mb->mb_magic), 1, md_fp) != 1)
+		fatal("error reading from metadump file\n");
+}
+
+static void
+show_info(
+	struct xfs_metablock	*mb,
+	const char		*md_file)
+{
+	if (mb->mb_info & XFS_METADUMP_INFO_FLAGS) {
+		printf("%s: %sobfuscated, %s log, %s metadata blocks\n",
+			md_file,
+			mb->mb_info & XFS_METADUMP_OBFUSCATED ? "":"not ",
+			mb->mb_info & XFS_METADUMP_DIRTYLOG ? "dirty":"clean",
+			mb->mb_info & XFS_METADUMP_FULLBLOCKS ? "full":"zeroed");
+	} else {
+		printf("%s: no informational flags present\n", md_file);
+	}
+}
+
 /*
- * perform_restore() -- do the actual work to restore the metadump
+ * restore() -- do the actual work to restore the metadump
  *
  * @src_f: A FILE pointer to the source metadump
  * @dst_fd: the file descriptor for the target file
@@ -51,9 +115,9 @@ print_progress(const char *fmt, ...)
  * src_f should be positioned just past a read the previously validated metablock
  */
 static void
-perform_restore(
-	FILE			*src_f,
-	int			dst_fd,
+restore(
+	FILE			*md_fp,
+	int			ddev_fd,
 	int			is_target_file,
 	const struct xfs_metablock	*mbp)
 {
@@ -81,14 +145,15 @@ perform_restore(
 	block_index = (__be64 *)((char *)metablock + sizeof(xfs_metablock_t));
 	block_buffer = (char *)metablock + block_size;
 
-	if (fread(block_index, block_size - sizeof(struct xfs_metablock), 1, src_f) != 1)
+	if (fread(block_index, block_size - sizeof(struct xfs_metablock), 1,
+			md_fp) != 1)
 		fatal("error reading from metadump file\n");
 
 	if (block_index[0] != 0)
 		fatal("first block is not the primary superblock\n");
 
 
-	if (fread(block_buffer, mb_count << mbp->mb_blocklog, 1, src_f) != 1)
+	if (fread(block_buffer, mb_count << mbp->mb_blocklog, 1, md_fp) != 1)
 		fatal("error reading from metadump file\n");
 
 	libxfs_sb_from_disk(&sb, (struct xfs_dsb *)block_buffer);
@@ -111,7 +176,7 @@ perform_restore(
 	if (is_target_file)  {
 		/* ensure regular files are correctly sized */
 
-		if (ftruncate(dst_fd, sb.sb_dblocks * sb.sb_blocksize))
+		if (ftruncate(ddev_fd, sb.sb_dblocks * sb.sb_blocksize))
 			fatal("cannot set filesystem image size: %s\n",
 				strerror(errno));
 	} else  {
@@ -121,7 +186,7 @@ perform_restore(
 		off64_t		off;
 
 		off = sb.sb_dblocks * sb.sb_blocksize - sizeof(lb);
-		if (pwrite(dst_fd, lb, sizeof(lb), off) < 0)
+		if (pwrite(ddev_fd, lb, sizeof(lb), off) < 0)
 			fatal("failed to write last block, is target too "
 				"small? (error: %s)\n", strerror(errno));
 	}
@@ -134,7 +199,7 @@ perform_restore(
 			print_progress("%lld MB read", bytes_read >> 20);
 
 		for (cur_index = 0; cur_index < mb_count; cur_index++) {
-			if (pwrite(dst_fd, &block_buffer[cur_index <<
+			if (pwrite(ddev_fd, &block_buffer[cur_index <<
 					mbp->mb_blocklog], block_size,
 					be64_to_cpu(block_index[cur_index]) <<
 						BBSHIFT) < 0)
@@ -145,7 +210,7 @@ perform_restore(
 		if (mb_count < max_indices)
 			break;
 
-		if (fread(metablock, block_size, 1, src_f) != 1)
+		if (fread(metablock, block_size, 1, md_fp) != 1)
 			fatal("error reading from metadump file\n");
 
 		mb_count = be16_to_cpu(metablock->mb_count);
@@ -155,7 +220,7 @@ perform_restore(
 			fatal("bad block count: %u\n", mb_count);
 
 		if (fread(block_buffer, mb_count << mbp->mb_blocklog,
-								1, src_f) != 1)
+				1, md_fp) != 1)
 			fatal("error reading from metadump file\n");
 
 		bytes_read += block_size + (mb_count << mbp->mb_blocklog);
@@ -172,7 +237,7 @@ perform_restore(
 				 offsetof(struct xfs_sb, sb_crc));
 	}
 
-	if (pwrite(dst_fd, block_buffer, sb.sb_sectsize, 0) < 0)
+	if (pwrite(ddev_fd, block_buffer, sb.sb_sectsize, 0) < 0)
 		fatal("error writing primary superblock: %s\n", strerror(errno));
 
 	free(metablock);
@@ -185,8 +250,6 @@ usage(void)
 	exit(1);
 }
 
-extern int	platform_check_ismounted(char *, char *, struct stat *, int);
-
 int
 main(
 	int 		argc,
@@ -195,9 +258,7 @@ main(
 	FILE		*src_f;
 	int		dst_fd;
 	int		c;
-	int		open_flags;
-	struct stat	statbuf;
-	int		is_target_file;
+	bool		is_target_file;
 	uint32_t	magic;
 	struct xfs_metablock	mb;
 
@@ -231,8 +292,8 @@ main(
 		usage();
 
 	/*
-	 * open source and test if this really is a dump. The first metadump block
-	 * will be passed to perform_restore() which will continue to read the
+	 * open source and test if this really is a dump. The first metadump
+	 * block will be passed to restore() which will continue to read the
 	 * file from this point. This avoids rewind the stream, which causes
 	 * restore to fail when source was being read from stdin.
  	 */
@@ -251,11 +312,7 @@ main(
 
 	switch (be32_to_cpu(magic)) {
 	case XFS_MD_MAGIC_V1:
-		mb.mb_magic = cpu_to_be32(XFS_MD_MAGIC_V1);
-		if (fread((uint8_t *)&mb + sizeof(mb.mb_magic),
-				sizeof(mb) - sizeof(mb.mb_magic), 1,
-				src_f) != 1)
-			fatal("error reading from metadump file\n");
+		read_header(&mb, src_f);
 		break;
 	default:
 		fatal("specified file is not a metadata dump\n");
@@ -263,16 +320,7 @@ main(
 	}
 
 	if (mdrestore.show_info) {
-		if (mb.mb_info & XFS_METADUMP_INFO_FLAGS) {
-			printf("%s: %sobfuscated, %s log, %s metadata blocks\n",
-			argv[optind],
-			mb.mb_info & XFS_METADUMP_OBFUSCATED ? "":"not ",
-			mb.mb_info & XFS_METADUMP_DIRTYLOG ? "dirty":"clean",
-			mb.mb_info & XFS_METADUMP_FULLBLOCKS ? "full":"zeroed");
-		} else {
-			printf("%s: no informational flags present\n",
-				argv[optind]);
-		}
+		show_info(&mb, argv[optind]);
 
 		if (argc - optind == 1)
 			exit(0);
@@ -281,30 +329,9 @@ main(
 	optind++;
 
 	/* check and open target */
-	open_flags = O_RDWR;
-	is_target_file = 0;
-	if (stat(argv[optind], &statbuf) < 0)  {
-		/* ok, assume it's a file and create it */
-		open_flags |= O_CREAT;
-		is_target_file = 1;
-	} else if (S_ISREG(statbuf.st_mode))  {
-		open_flags |= O_TRUNC;
-		is_target_file = 1;
-	} else  {
-		/*
-		 * check to make sure a filesystem isn't mounted on the device
-		 */
-		if (platform_check_ismounted(argv[optind], NULL, &statbuf, 0))
-			fatal("a filesystem is mounted on target device \"%s\","
-				" cannot restore to a mounted filesystem.\n",
-				argv[optind]);
-	}
-
-	dst_fd = open(argv[optind], open_flags, 0644);
-	if (dst_fd < 0)
-		fatal("couldn't open target \"%s\"\n", argv[optind]);
+	dst_fd = open_device(argv[optind], &is_target_file);
 
-	perform_restore(src_f, dst_fd, is_target_file, &mb);
+	restore(src_f, dst_fd, is_target_file, &mb);
 
 	close(dst_fd);
 	if (src_f != stdin)
-- 
2.39.1

