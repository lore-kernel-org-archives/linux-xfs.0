Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18DECC7EE24
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jun 2023 09:30:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237481AbjFFJah (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 05:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237474AbjFFJae (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Jun 2023 05:30:34 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A898E5A
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 02:30:32 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 356605lQ023149;
        Tue, 6 Jun 2023 09:30:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=OCK27azeuYHDTsG44+AcffrQ7nMDRFPqzkD6o6M/kv4=;
 b=w66WuWF+kj3tShSbnH4VVOsFZ0PCHswNbeVrRRde5rVAL40qaiLeeZhEi7QLuqO77qAc
 uq60jzbWwOb+z5YGEZA6bsCt0zC4qASbsTrgQO8sKPY4IawgDPaJKDa5PmuBa25EeM9h
 4CoaL3QumII0XRrghiQgGjNvltfTPRfivicZcOWSOggDPY1KdBDAlWm/zidW6y9qzZvC
 1xzLwlk2UyDLCLaX3ZcOK5SCCxrWm4f2TIv0E+YMqt2Sn4Hcu9QW25fUrDkiozH+xgLM
 vQRyYFJDT7e0cz0sfeiQRzRSb0uWVIN5a9BHGcP3qRUdcuvZVFjIeWMCIMWcRTC6CVXj Wg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qyx2wmxqj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Jun 2023 09:30:28 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3569PwiT024059;
        Tue, 6 Jun 2023 09:30:27 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r0tkgvdtc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Jun 2023 09:30:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=exsQISib/UUuUj8jHtAcqqJ18E7tek3kpzDaW9gv2JAeqDtFj0+aELrgZ9wwYQ1TCm+2/0CZaFy5211pB3HtUWgBaSMQKonhon0u704ZyWlo6PfmbBivwmybD1mVOPk13xWdQcI+LGXmJRbf9WuRoNh/8XWJtQcWWwhczxL+iHQQAO/WKPnpq0w5P/Yk/6P/gqRjBxxxQ8UCvP0UX7dKo4X2Ju43829RvUD6DIl6F01BYN93+9+XGxU+/6HOLzMzoTswjHe/ynuU1DHS87HDj2J8ENilDVjBfaLGXWx2XxjnndqdIlx0uV2HNvkFobCaQEnshOHCLhJssWTWPWUY1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OCK27azeuYHDTsG44+AcffrQ7nMDRFPqzkD6o6M/kv4=;
 b=bnEP3cAlXzDJaB19WK3apzBc9PEXtIR3f5xad7d+kjV3iBg7qX5+1iWP8IJzlwzHFNy5vkPzPHP0naA6SJ1isMAoI/wUqmJxX/6zeaTT6uLxPhlm16mUezm9WPZi0jTbR8rfSXgablMjTE+srTabzRog9l24SU13TtZupVFrdXZRR4+0z5sD+OoXnZcasXtR4qicjKeRFIPI1IJHrs09VP6FzsnG+0nInPYbyhAtzj6GG8ZE50WecXCHpxs+fHZetljxDRmxyPvzjLV9ehEJuO7MNwGZ+GcvUvTNosbdTOVpgdew6aZe6uwPonOMna6VB7aFNSFBvGzbGorCCNFPsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OCK27azeuYHDTsG44+AcffrQ7nMDRFPqzkD6o6M/kv4=;
 b=PFyVtZmnTViCrCeETHQ07KWg5xz8cAlPzPd2Pg0HL4LwRKEwcqZeB4ov8W749tlMl6+8gFn3mLWMoTskehHpFQJ0DF1gAk8gu6e83ZFWMji5o8wDtdzRNKPbEm0SGxZNRMKOHN+tTBm9yAS+Wnb4czZa3ofPm7EjYKUVZF3V2Ko=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CO1PR10MB4562.namprd10.prod.outlook.com (2603:10b6:303:93::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Tue, 6 Jun
 2023 09:30:25 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1%7]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 09:30:25 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V2 17/23] mdrestore: Add open_device(), read_header() and show_info() functions
Date:   Tue,  6 Jun 2023 14:58:00 +0530
Message-Id: <20230606092806.1604491-18-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230606092806.1604491-1-chandan.babu@oracle.com>
References: <20230606092806.1604491-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0129.jpnprd01.prod.outlook.com
 (2603:1096:404:2d::21) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CO1PR10MB4562:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d746ac1-5932-4237-dc30-08db6670a883
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3f43vFGdY/kAv8PObG7n+sDp0nmA494pPBOj+C6ZVzh4em9KPIY+iWzEEz8joNOpa5omH/iKho90hDY55oUdZid74ENTUxT3AB9/TozDJNIdAoZ3QjKVhXboqeAk1vuuAFboEmWLZEWujb7KYJkB0E4WNFTS6FtvvumeobT6kkoQZPCMvVwaYJIp/W6iebYgeYG4kY6UhWuETqBUb/XV+TKpo6ZAD4pBu9+QSyqveaRn3DPziAlPAAFnpv/g0hseo5Ig+vkoB4FbohZ4sMILJZHnY+FRSS2b0B9y25cXrHrLHrfg0kQD5B4jPnSnaAGgk8Nh8HxNE5C8UUV6uN1b6xyp0PdTCjAjc7jS6fC+xKhmo1YVcbXw6TzX6vBUZVE9ZxSOfU9k3R190aoZwgC2yo7gDa/Rf8qnAm7ZKJvqUWBwbolku6ZY2genMVAwd2Of4VloELzU5oCYObKNUqLNUSBBuG0N3ITYV0JxoL6dbU3aELWllyORIgpzjl3LWVDk8ydO7+5jqGyATIBTgNHDXCTqVFEVzuScq1dS2hcwlU+iCRzauNUU0I6LN3Wl/okA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(396003)(136003)(366004)(376002)(451199021)(8676002)(4326008)(66556008)(6916009)(66476007)(66946007)(8936002)(5660300002)(316002)(41300700001)(2906002)(478600001)(38100700002)(6512007)(1076003)(6506007)(26005)(86362001)(186003)(36756003)(6486002)(2616005)(83380400001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lnHtLdhVTaGHpZECh2o8tAPkKmm0toORWTwMQFeYXIei1Sp2sCOgEZ1aeAB0?=
 =?us-ascii?Q?axrpLcUq1O3ZxUtMefwcGVCpIYy/MjzmsazKdQvFfhNi665znTVlsNsEj4B9?=
 =?us-ascii?Q?NQGx4Fwr37Lez1fKW3YJLjIefvvDLdrNDYvNBUigDsvC1R+uSZ+rNtQlCP/F?=
 =?us-ascii?Q?m+56gg9lMUriZbyx1Dkq9gPvi/4GfEyGDlH6KfLFfP6GmxdmqDeHgwEBhxkl?=
 =?us-ascii?Q?+MDzIRuKCmuDf9eSLZcYP4xo66YEU2DILYZCstGFXR/3asnAk78ytEwTcCaM?=
 =?us-ascii?Q?JES1vxSA0mHe7mDa4hvwtvYqA7aL7LvZdO43QjqobQQIXpAjUou75bmnbqq0?=
 =?us-ascii?Q?IUrwGW2zSpMTPkW9FaYJakkYWOsg8pCVNddRKXj2YDiql30VPMG695DgCnYz?=
 =?us-ascii?Q?vD3BLPTDjYRJo4shAN3KX30aXEgCDRVU4zBUyW0NQBp+MSD3LryBUHm3q/QG?=
 =?us-ascii?Q?cHleK9AUC9GUUW4ktrER/CDjQ75DySYDVOjfG/xp4FgrhNyc0qQ3xm+KtCDB?=
 =?us-ascii?Q?Rg7Jg+ctRoKUeEukAVSceuah+rVRumWU7HIIIFkNpo4uc5sc38Y2OxWMAzLo?=
 =?us-ascii?Q?EjfwrvyV4TPZ8FNZnJ4miyHyhIH+2siGWot51NKFnEbFk3QqsuBZv7h2wlG7?=
 =?us-ascii?Q?p0XQ91imJP9h3e4AqavddUxR5Pv3JMwbobtrOdyLrHtaezxpMLB4oERLkkKu?=
 =?us-ascii?Q?msvtmQEMlKojdIC2cxSyPNMNWmATFXMRp5lH/KFRPvyIB1EaekfiKmkem+vr?=
 =?us-ascii?Q?54zRRqiWBSDjzLrFdNd52rdjBR9JPKaZuP6ILFx9BdSBREm5mdt0sIS0I8wJ?=
 =?us-ascii?Q?mTpmod48uY3kArOSNeJSzKZiazyJ+K6vplhqde2vS5aHfVDVCZzvRVDJcTMx?=
 =?us-ascii?Q?3mwbRmBQcXLjLDGAxHgOu0OuUtf3LN/n7BrOJdznTaeePakhcrRPTfXgoewq?=
 =?us-ascii?Q?IJIkDBdGir3623p7UM7rQELUIF3BZne+FbhRKDdXBPbiljPq2xHllOo9/KsC?=
 =?us-ascii?Q?4uLya2T4Yn82RPi1Zn49ZWFBkfOsY1RDFT2hHyJqfZ0Ntsv2mYfQ4bh2JxAF?=
 =?us-ascii?Q?TMoKDFuOVGbFhgaleZmIlTjiaWR1sjuEq1L3XZuzYXeV2ta6RO0aBMS8nkdB?=
 =?us-ascii?Q?mZuxdTEB6dErGlvwnIk35W2G3lxo9Xi99TDyYnR2oXFS11eQ8inoEQ+unOk4?=
 =?us-ascii?Q?g/s5RYf821mIbpDViILfrZy4AAXRSq4hywXEddwN6s/v6zjR46qa1Ivyp3IC?=
 =?us-ascii?Q?RNUZ4gEdYXX9aTtrmxeH1UY0UYLVm+UftDN/K/WZmUdyP7ine8qrKbCZCNQt?=
 =?us-ascii?Q?qBcWHau5XE2yKVt+rm9MuDelfeK3JVoegqUgQcOmmWI+lxOx/p1DZbWqJJZK?=
 =?us-ascii?Q?EGavV5cW0tf5Ai405PqPCP/C4ORKPzVD6XnEOIIeijzVSk75iIEQunu6E47h?=
 =?us-ascii?Q?iaVyLCbFe2k3qudvLhQ1rKYrNZBGjIxxPLx4Yj2CeM1+u+/3eeSkCf0fPTSQ?=
 =?us-ascii?Q?Xm7vK0RZgA8WYH7uv5o4Qrh42MuZAxCOI1xoT5IBtUKYMS/ZIPlJWS4CVrc8?=
 =?us-ascii?Q?/ZHdJvwpYbDIH3huGPfDi9XoK1H4Q4KPUz0P75v/59pJpiO0zffFSIEdvEho?=
 =?us-ascii?Q?pw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: UaHEkmQ4S8gDNR0Du688di+PcQAHjd/lOeU3Ls+2kitazL/GIOhfHSWZS2VAP/9gBMp07yP7KDgyckVMoOWpOX62CDfrSORZ3NwIuq3eYX93+JhQkPqBnEuQtq7+mj39SelIGNSzMz9X4rN+hmf1deOl3SKTn5bcM9frEOSIN/vaoXs2ds7vL/T+2gFku6oA1d5NF5Av79ihwFFz8Z6lVhb+YdWVz3uOHpIvH4nKvZxocwcY5HxeVD8Hveh8rtiNvV1vwCIQBM754H8/mD5wnRdJEm8Z5OhZIMXWrT2AUCxeN3FoKn5QXoq2TEDTGEudYTNSh5bN5fLqz7iwhVUnfwz3+HLa7Y2eUybrrWDHwUdmeBDP6t1DTCLlZRYgQqg/DIhp51drmbFAeE0ciM1vF5jSLyAB8hSiAWV/OYyzgP9x5Pzig/YG0RR0mxh/rFdQn0dsACrDo51HxcnL+NRyJEoPSO2OTboGYIw1SEI+bj5ODrXGH4fT9YgGcAnv7KH+U/lpPF2yq0sIl/Sfs8bLqxuvrz64Zt+nGnb3aT/+XzgdSEoy71byBfUSFqFHoYia3ltq2439JGme+UGKsdg+4c+8PE0EEdAjGSSNE4eiFD2DQy48L9iYdUB3UDySOrOwkz+Ag5ezNLjEARAwMSe3xeliBkrt2o42EkJ130iZIFInKTMvNVpaeLYkfocJJsj+e9E9ezp1bASSIAOIfDV9rWj7NYDagFFapT+Cgy6uo6ZWIG3sIo4mGgVvdeRyhpzyCks107qo7K+RCcE9mIRZpQL83BFfHzfugwEY38Z8GJ4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d746ac1-5932-4237-dc30-08db6670a883
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 09:30:25.4615
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jUe3BCkZ7HiIxpFPiSXKJNmX4oO5oDIG3FY81bX8nAN2/TIlKCf/HoEhm/HQQD18c3tHy2fk3/4NOMTqLK9CXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4562
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-06_06,2023-06-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 phishscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306060080
X-Proofpoint-GUID: 3YsQrUeK-Ylo5gqSG9__rMX3jfsMrjj-
X-Proofpoint-ORIG-GUID: 3YsQrUeK-Ylo5gqSG9__rMX3jfsMrjj-
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit moves functionality associated with opening the target device,
reading metadump header information and printing information about the
metadump into their respective functions. There are no functional changes made
by this commit.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 mdrestore/xfs_mdrestore.c | 141 +++++++++++++++++++++++---------------
 1 file changed, 85 insertions(+), 56 deletions(-)

diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 2a9527b9..61e06598 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -6,6 +6,7 @@
 
 #include "libxfs.h"
 #include "xfs_metadump.h"
+#include <libfrog/platform.h>
 
 static struct mdrestore {
 	bool	show_progress;
@@ -40,8 +41,72 @@ print_progress(const char *fmt, ...)
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
+	} else  {
+		/*
+		 * check to make sure a filesystem isn't mounted on the device
+		 */
+		if (platform_check_ismounted(path, NULL, &statbuf, 0))
+			fatal("a filesystem is mounted on target device \"%s\","
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
+		sizeof(*mb) - sizeof(mb->mb_magic), 1, md_fp) != 1)
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
@@ -51,9 +116,9 @@ print_progress(const char *fmt, ...)
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
@@ -81,14 +146,15 @@ perform_restore(
 	block_index = (__be64 *)((char *)metablock + sizeof(xfs_metablock_t));
 	block_buffer = (char *)metablock + block_size;
 
-	if (fread(block_index, block_size - sizeof(struct xfs_metablock), 1, src_f) != 1)
+	if (fread(block_index, block_size - sizeof(struct xfs_metablock), 1,
+		md_fp) != 1)
 		fatal("error reading from metadump file\n");
 
 	if (block_index[0] != 0)
 		fatal("first block is not the primary superblock\n");
 
 
-	if (fread(block_buffer, mb_count << mbp->mb_blocklog, 1, src_f) != 1)
+	if (fread(block_buffer, mb_count << mbp->mb_blocklog, 1, md_fp) != 1)
 		fatal("error reading from metadump file\n");
 
 	libxfs_sb_from_disk(&sb, (struct xfs_dsb *)block_buffer);
@@ -111,7 +177,7 @@ perform_restore(
 	if (is_target_file)  {
 		/* ensure regular files are correctly sized */
 
-		if (ftruncate(dst_fd, sb.sb_dblocks * sb.sb_blocksize))
+		if (ftruncate(ddev_fd, sb.sb_dblocks * sb.sb_blocksize))
 			fatal("cannot set filesystem image size: %s\n",
 				strerror(errno));
 	} else  {
@@ -121,7 +187,7 @@ perform_restore(
 		off64_t		off;
 
 		off = sb.sb_dblocks * sb.sb_blocksize - sizeof(lb);
-		if (pwrite(dst_fd, lb, sizeof(lb), off) < 0)
+		if (pwrite(ddev_fd, lb, sizeof(lb), off) < 0)
 			fatal("failed to write last block, is target too "
 				"small? (error: %s)\n", strerror(errno));
 	}
@@ -134,7 +200,7 @@ perform_restore(
 			print_progress("%lld MB read", bytes_read >> 20);
 
 		for (cur_index = 0; cur_index < mb_count; cur_index++) {
-			if (pwrite(dst_fd, &block_buffer[cur_index <<
+			if (pwrite(ddev_fd, &block_buffer[cur_index <<
 					mbp->mb_blocklog], block_size,
 					be64_to_cpu(block_index[cur_index]) <<
 						BBSHIFT) < 0)
@@ -145,7 +211,7 @@ perform_restore(
 		if (mb_count < max_indices)
 			break;
 
-		if (fread(metablock, block_size, 1, src_f) != 1)
+		if (fread(metablock, block_size, 1, md_fp) != 1)
 			fatal("error reading from metadump file\n");
 
 		mb_count = be16_to_cpu(metablock->mb_count);
@@ -155,7 +221,7 @@ perform_restore(
 			fatal("bad block count: %u\n", mb_count);
 
 		if (fread(block_buffer, mb_count << mbp->mb_blocklog,
-								1, src_f) != 1)
+			1, md_fp) != 1)
 			fatal("error reading from metadump file\n");
 
 		bytes_read += block_size + (mb_count << mbp->mb_blocklog);
@@ -172,7 +238,7 @@ perform_restore(
 				 offsetof(struct xfs_sb, sb_crc));
 	}
 
-	if (pwrite(dst_fd, block_buffer, sb.sb_sectsize, 0) < 0)
+	if (pwrite(ddev_fd, block_buffer, sb.sb_sectsize, 0) < 0)
 		fatal("error writing primary superblock: %s\n", strerror(errno));
 
 	free(metablock);
@@ -185,8 +251,6 @@ usage(void)
 	exit(1);
 }
 
-extern int	platform_check_ismounted(char *, char *, struct stat *, int);
-
 int
 main(
 	int 		argc,
@@ -195,9 +259,7 @@ main(
 	FILE		*src_f;
 	int		dst_fd;
 	int		c;
-	int		open_flags;
-	struct stat	statbuf;
-	int		is_target_file;
+	bool		is_target_file;
 	uint32_t	magic;
 	struct xfs_metablock	mb;
 
@@ -231,8 +293,8 @@ main(
 		usage();
 
 	/*
-	 * open source and test if this really is a dump. The first metadump block
-	 * will be passed to perform_restore() which will continue to read the
+	 * open source and test if this really is a dump. The first metadump
+	 * block will be passed to restore() which will continue to read the
 	 * file from this point. This avoids rewind the stream, which causes
 	 * restore to fail when source was being read from stdin.
  	 */
@@ -251,10 +313,7 @@ main(
 
 	switch (be32_to_cpu(magic)) {
 	case XFS_MD_MAGIC_V1:
-		mb.mb_magic = cpu_to_be32(XFS_MD_MAGIC_V1);
-		if (fread((uint8_t *)&mb + sizeof(mb.mb_magic),
-			sizeof(mb) - sizeof(mb.mb_magic), 1, src_f) != 1)
-			fatal("error reading from metadump file\n");
+		read_header(&mb, src_f);
 		break;
 	default:
 		fatal("specified file is not a metadata dump\n");
@@ -262,16 +321,7 @@ main(
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
@@ -280,30 +330,9 @@ main(
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

