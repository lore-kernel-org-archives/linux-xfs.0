Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE52BC3A59D
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Oct 2022 04:55:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbiJXEzD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Oct 2022 00:55:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbiJXEzC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Oct 2022 00:55:02 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F38D2BB26
        for <linux-xfs@vger.kernel.org>; Sun, 23 Oct 2022 21:55:00 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29O2dTKt015964;
        Mon, 24 Oct 2022 04:54:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=u/Pa0ES28dtI9d845RCATxEqZfyyN9uVdznAr4X+jGI=;
 b=J0t/cGAi+NLZnUiNelnMfuwSeIwcR3M88CoGajHG1rP4bmj1ZYTpwS5OBK/v/nA3UGu+
 v96ELvgBrBgzEW7muK8QBrNicQhWmPYXKitTTLIlIQiQ9Y4kn1cJkxOCr1LZEanXrrR6
 IdbOoJRv2LoN6MIbVSqNZZIGT9K6FDnk4LzrtA5si49407UPfWF3m21aCusP+xAjcf2S
 kmwi94m2PFOtqQ2uYPdJoRGJLUQmyKdHZk4uV1hZn9qEXB1vAlXpYAAA8iGO+24DFhxJ
 2+yxgr+Njwpzn+Kq1W/fNP0cNKEt0/PWi8Rd1b1jUUohmDZGFz/14hh/r6bxSfJ4zf5s kg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc84stmy8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 04:54:56 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29O44lfC015392;
        Mon, 24 Oct 2022 04:54:55 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y336qg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 04:54:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E2CTPPA4ENMaUIisa6SMAtJgIgUcOcHT7yK5nU1/NDzXT6j5Z0anwFPNHNdExRfYmHNOeCInYNvlt4CvqCI2It3e0HsAr+zMrCk81OzXKs08PmmQ69pXCMKAr0D/oETwqYXsuC/zYLmb3caa+y6+IsDbjU2okw+xyB88jIm8dYXk96z85cFvAh0wKgVDpbYHF5bkB+HngYDzRZoOj/8ibZwUEamMRBpwFUM2sLWWe3XnXVUXAv7swhUZYVL9j8Al7EC/Oy/NbUaarypOHRPfzWOTQGIPt37PDdsgC+GrGdIw3TGCYTnr2ykpyKCP1c1OghPZ1vEfXMorEZsPMtakbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u/Pa0ES28dtI9d845RCATxEqZfyyN9uVdznAr4X+jGI=;
 b=c9HsyOJxYWrryw73L32cZo10xU7hvtMg55Q6Qn4SMZHuslPkXHuWJ32MV4ViROcm72yfEzHYM35pKVzrl0LMPGfdiLaggYtuFEEI4xtQ/k6Mu8v1KmGjRzH5/b9uy4lMnqEFQrk3RMS+GsjQbf6J9B89cMshsch5HvNpNMU1qRe0OO+HEbC/D8eztDlW4mShCS5mxXQX+9cCKbAx1xuBrSrqEOmX9iojvv+6wni+XaOOQ8Z13QK8InUhbazmDdP1gIjUSFK+brcIZipYP424U339MpsEWkucxzeG2y+bK1W3WtnJhZJBucfN9vHuvEqrF+BEN6TpfnRxY050JSH5Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u/Pa0ES28dtI9d845RCATxEqZfyyN9uVdznAr4X+jGI=;
 b=om+IjpLek67todO6wJ1U0ecqD6uXzPGreJA6xcbUAWMZE91A2D00ySmyOvWTaeEXdEFp9LusnL0/W64bb8G6ahO+ppUIAy2MsHrIDthPqSc5zq8rJVY5SZOUIgGX2ZO/6s6Umf+4suermyMTltp4AXZmcwrk3+qjjSVXgEsT0t0=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS7PR10MB5374.namprd10.prod.outlook.com (2603:10b6:5:3aa::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Mon, 24 Oct
 2022 04:54:53 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c%6]) with mapi id 15.20.5723.033; Mon, 24 Oct 2022
 04:54:53 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 13/26] xfs: Replace function declaration by actual definition
Date:   Mon, 24 Oct 2022 10:23:01 +0530
Message-Id: <20221024045314.110453-14-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221024045314.110453-1-chandan.babu@oracle.com>
References: <20221024045314.110453-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0015.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::15) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS7PR10MB5374:EE_
X-MS-Office365-Filtering-Correlation-Id: 3346f63c-ed55-4a4a-ecb7-08dab57be3e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HlOYJgTvwj1AbTUEYsspR/asxrHf9dxJ8y1sD7bYRKxRhD1j3Lw9wTmHA49O78hBo+XuFB9bRWhEET8WfhAD6qIWv+jEmSuZzgLwu2gY3Zt9ZsbKJlXDqXrQbr2/23a0LrE/ef8TeUwAeHXeZw00PR30axBvFizorkzSIY/yrlkqhRS09cIERuiOzkMUQb0EW9yXB8EENmHo9KJEM1+Q6Cq3m+dpnibj2jYNh7tCAeF8Iefsw5mHkMGa9eO3X3ay1uNeJsB78sjR+JiMYPDzQ7xzPKRNk51PKYH/JxCEZof+Oewc0ATH4Wwjw4KUuT8sf4cyWphC4DE9JhWpKljTsLUwlR80SXxLikyAtLZCWrxXQZv0kNi5C5Nbj7TFM/8viNfJBKmm+OLlKUnlA/FMDS4lyt51ymwI0GcBlmR8NYAN08npoqI8DhExVokVX0XZpPIa3L5PTlMk5Onvdn9dlvxNz7VKXhjAKxmZ5gyn3336c8K7pa1wEIeq8BLNIVPk1QSLv9Z6Dumapj1RA47mTOGw0XEFXaF1Uea1/Fb25EKiSAKK7OlzsfHWdMmDTpERT88oyDafG++afFsAqUXwgPC1zS67PC5lJqj3dYhY2Dta3H8EYYafl/1d1qvTIIjnNUiOMkTqCv6COrMvhwoIl3v/HX6tIZTYonI55o+6zhcQ7cBskDwu9cSZLYUW0AfW130dRQsNJswrq1XzgCRO0w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(376002)(346002)(39860400002)(136003)(451199015)(6916009)(83380400001)(2906002)(5660300002)(6512007)(26005)(6486002)(4326008)(8676002)(8936002)(86362001)(66556008)(66946007)(36756003)(66476007)(2616005)(316002)(1076003)(186003)(478600001)(38100700002)(6506007)(41300700001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ofdb4qXFCeASty7S3EQuauWPgPhEsNZfxfSHwahOMAe1oWXiePN0eL/HBfRM?=
 =?us-ascii?Q?DajZRcvVuO2oFZGRWzmQFyDaLjhM+YBD9BKBtJ00BANf0blCY6N+urbfkFho?=
 =?us-ascii?Q?DJBDeswr5DcHHRNisaCqPu8wDC/EXb1RDGOaw5TxDq79D+7AQmpJgtflOU27?=
 =?us-ascii?Q?HhaSv9bYzrENcLShigWP9Uh0BLDpMq21l534SnYuvRzncJ1jY4PyKIDotdX/?=
 =?us-ascii?Q?bTdsZ6WzGLQke4Oe4/y9fJ6kc4AB96a11mBGn4UTsO+wBcG1ejG41gkbi4c2?=
 =?us-ascii?Q?rB/duDxQVB/EvaBZZi/MmchKFgjJ1fVYbeEka9np5ZVa9xmh62wqOiV/cj2P?=
 =?us-ascii?Q?BASE6u57lZtCTGHaPiPkJSQa/zp3e2h46GLcg66bbMQ41+i0/gmK8h7iAfLt?=
 =?us-ascii?Q?1KWO1OAZbX1oiwBIGlW2stDUiH8z++JQ8RFqBbj1eWi6C391dguDvM27EMw2?=
 =?us-ascii?Q?TJNi2zNxxJHF4ClvZMnoHMs7lV2I0kieW2FlBE4pNEhLkpRd4wCYh1+cAI+r?=
 =?us-ascii?Q?F0u8bsg40O/O1sKG/8MT3i48jCHtxdtny6ZD3HBtjKi5NWw3GwG5PkA2UiS2?=
 =?us-ascii?Q?N0M3SaL3RcJBKJLC8TGcB3/6mlUwsXOCVEe2mT5I2/qzLXqs8QY5WeC0qJHH?=
 =?us-ascii?Q?VOUa2m7lD8jvaUxuoOKFZ53EnpsMaUCRRsX9ijQVtXsfx/LYFUyj7hSSftFP?=
 =?us-ascii?Q?0ad0gs+oppVVCsTPH1S83UEDApCD6cMZROClJttxloRS6RfXZXuZc1LiUAot?=
 =?us-ascii?Q?7SVL5jiNtvzBkFKPH2yzXqL03uZw5mXBcWWOGJe0g4sEcwRcbl4+/4Iok/dm?=
 =?us-ascii?Q?Nl4gcjdEhLFQ4TAFiZJbcvkuuM1Dsnly26Kplov2vteOLs4wnOzHDg9hJDeg?=
 =?us-ascii?Q?akjWtQjRUYWjy65m3nGd5IBVnWZ+/Zq56FACd5tfPxgVwToVltIv7IJpud8I?=
 =?us-ascii?Q?ZONssggtVIuZiKcTz4+0wkhzEpgHn2GRuIvMU5NNAdwKVMP5KeFFCOJQQ6p4?=
 =?us-ascii?Q?BdFTddXQd54BgRJ/oQVIczYaUqAo5eJ1AG5Qc1ZBZwb5l63p3Bj5TspwBH9j?=
 =?us-ascii?Q?QDrR01geGQcj5/9zRZEE1PAw2OFiKfc4ggb/fRlgYvVpgOGTMbHG/1c0Wq5t?=
 =?us-ascii?Q?Zj8CwPNwmWtIUSuSmVWecX1imOJ3QcShQd/zPnVd6F87Q7uy6qDy7QEvcWnP?=
 =?us-ascii?Q?zOHvDjQnRLJZF5a5nJK4QmivQ3SxZowgf9Q8gg1DOjiik+zVjfFAzfLy9F80?=
 =?us-ascii?Q?ifbzy/mdGvl1b5PkW7LSi2NG3Q/jGisSJswRbeANd/VGj7FzlHmnxRJuDby+?=
 =?us-ascii?Q?uFOAmjJHQnuI0IsL0cGpnILW9P8yYyruXirsjiAOd7+1oGm8UWD+YI2scGPq?=
 =?us-ascii?Q?/w+J/eLOvZm0jDl1g04wp36IxYGSLeRI8t/R2KbdkdBrGjTkvY0+0h72aef0?=
 =?us-ascii?Q?I0gLpw4TT2kAGXmsB48V8s44HOrbJnaUh2ODvhNAFqRJAYeCBxXOkEy31kgi?=
 =?us-ascii?Q?u1rJQc2YFYgI+whvNuJvr/yCTl2ZRM0gOwDv5EDBoFa2Tlx1SiJLNPdAQ/TR?=
 =?us-ascii?Q?jjXwXywJ0L/slzkBEzQw98VitOiPWaXfrXsCgCdeC5zQy6Rw8hfB36GARlQc?=
 =?us-ascii?Q?lg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3346f63c-ed55-4a4a-ecb7-08dab57be3e6
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2022 04:54:53.8326
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rmzc+tmJOTwkk8hLVjO4UuONAqK9AJj5yxF1z7alpb0Mn6nsel6H4q0F57qvhBJUUiRDX/u2ih8GbiHCQdmoUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5374
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-23_02,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210240031
X-Proofpoint-ORIG-GUID: Y8VINtZjQwi-4bJFdwAPFaTuL8wxhkCK
X-Proofpoint-GUID: Y8VINtZjQwi-4bJFdwAPFaTuL8wxhkCK
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Pavel Reichl <preichl@redhat.com>

commit 1cc95e6f0d7cfd61c9d3c5cdd4e7345b173f764f upstream.

Signed-off-by: Pavel Reichl <preichl@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
[darrick: fix typo in subject line]
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_qm_syscalls.c | 140 ++++++++++++++++++---------------------
 1 file changed, 66 insertions(+), 74 deletions(-)

diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index e685b9ae90b9..1ea82764bf89 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -19,12 +19,72 @@
 #include "xfs_qm.h"
 #include "xfs_icache.h"
 
-STATIC int xfs_qm_log_quotaoff(struct xfs_mount *mp,
-					struct xfs_qoff_logitem **qoffstartp,
-					uint flags);
-STATIC int xfs_qm_log_quotaoff_end(struct xfs_mount *mp,
-					struct xfs_qoff_logitem *startqoff,
-					uint flags);
+STATIC int
+xfs_qm_log_quotaoff(
+	struct xfs_mount	*mp,
+	struct xfs_qoff_logitem	**qoffstartp,
+	uint			flags)
+{
+	struct xfs_trans	*tp;
+	int			error;
+	struct xfs_qoff_logitem	*qoffi;
+
+	*qoffstartp = NULL;
+
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_quotaoff, 0, 0, 0, &tp);
+	if (error)
+		goto out;
+
+	qoffi = xfs_trans_get_qoff_item(tp, NULL, flags & XFS_ALL_QUOTA_ACCT);
+	xfs_trans_log_quotaoff_item(tp, qoffi);
+
+	spin_lock(&mp->m_sb_lock);
+	mp->m_sb.sb_qflags = (mp->m_qflags & ~(flags)) & XFS_MOUNT_QUOTA_ALL;
+	spin_unlock(&mp->m_sb_lock);
+
+	xfs_log_sb(tp);
+
+	/*
+	 * We have to make sure that the transaction is secure on disk before we
+	 * return and actually stop quota accounting. So, make it synchronous.
+	 * We don't care about quotoff's performance.
+	 */
+	xfs_trans_set_sync(tp);
+	error = xfs_trans_commit(tp);
+	if (error)
+		goto out;
+
+	*qoffstartp = qoffi;
+out:
+	return error;
+}
+
+STATIC int
+xfs_qm_log_quotaoff_end(
+	struct xfs_mount	*mp,
+	struct xfs_qoff_logitem	*startqoff,
+	uint			flags)
+{
+	struct xfs_trans	*tp;
+	int			error;
+	struct xfs_qoff_logitem	*qoffi;
+
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_equotaoff, 0, 0, 0, &tp);
+	if (error)
+		return error;
+
+	qoffi = xfs_trans_get_qoff_item(tp, startqoff,
+					flags & XFS_ALL_QUOTA_ACCT);
+	xfs_trans_log_quotaoff_item(tp, qoffi);
+
+	/*
+	 * We have to make sure that the transaction is secure on disk before we
+	 * return and actually stop quota accounting. So, make it synchronous.
+	 * We don't care about quotoff's performance.
+	 */
+	xfs_trans_set_sync(tp);
+	return xfs_trans_commit(tp);
+}
 
 /*
  * Turn off quota accounting and/or enforcement for all udquots and/or
@@ -541,74 +601,6 @@ xfs_qm_scall_setqlim(
 	return error;
 }
 
-STATIC int
-xfs_qm_log_quotaoff_end(
-	struct xfs_mount	*mp,
-	struct xfs_qoff_logitem	*startqoff,
-	uint			flags)
-{
-	struct xfs_trans	*tp;
-	int			error;
-	struct xfs_qoff_logitem	*qoffi;
-
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_equotaoff, 0, 0, 0, &tp);
-	if (error)
-		return error;
-
-	qoffi = xfs_trans_get_qoff_item(tp, startqoff,
-					flags & XFS_ALL_QUOTA_ACCT);
-	xfs_trans_log_quotaoff_item(tp, qoffi);
-
-	/*
-	 * We have to make sure that the transaction is secure on disk before we
-	 * return and actually stop quota accounting. So, make it synchronous.
-	 * We don't care about quotoff's performance.
-	 */
-	xfs_trans_set_sync(tp);
-	return xfs_trans_commit(tp);
-}
-
-
-STATIC int
-xfs_qm_log_quotaoff(
-	struct xfs_mount	*mp,
-	struct xfs_qoff_logitem	**qoffstartp,
-	uint			flags)
-{
-	struct xfs_trans	*tp;
-	int			error;
-	struct xfs_qoff_logitem	*qoffi;
-
-	*qoffstartp = NULL;
-
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_quotaoff, 0, 0, 0, &tp);
-	if (error)
-		goto out;
-
-	qoffi = xfs_trans_get_qoff_item(tp, NULL, flags & XFS_ALL_QUOTA_ACCT);
-	xfs_trans_log_quotaoff_item(tp, qoffi);
-
-	spin_lock(&mp->m_sb_lock);
-	mp->m_sb.sb_qflags = (mp->m_qflags & ~(flags)) & XFS_MOUNT_QUOTA_ALL;
-	spin_unlock(&mp->m_sb_lock);
-
-	xfs_log_sb(tp);
-
-	/*
-	 * We have to make sure that the transaction is secure on disk before we
-	 * return and actually stop quota accounting. So, make it synchronous.
-	 * We don't care about quotoff's performance.
-	 */
-	xfs_trans_set_sync(tp);
-	error = xfs_trans_commit(tp);
-	if (error)
-		goto out;
-
-	*qoffstartp = qoffi;
-out:
-	return error;
-}
-
 /* Fill out the quota context. */
 static void
 xfs_qm_scall_getquota_fill_qc(
-- 
2.35.1

