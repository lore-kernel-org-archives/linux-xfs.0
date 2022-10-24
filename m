Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F5E8C3A59D
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Oct 2022 04:55:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbiJXEzb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Oct 2022 00:55:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbiJXEz2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Oct 2022 00:55:28 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E89D4685A
        for <linux-xfs@vger.kernel.org>; Sun, 23 Oct 2022 21:55:27 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29NNSDxn016765;
        Mon, 24 Oct 2022 04:55:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=UwQwLGqOq0m5KoocP/9azCmRlWhuMNLPHk63gb0u990=;
 b=mr0Fe1MkIknGnzCik60OiXw71t07uj6tKjxakXzM/1WygX+9zTBQuMOJaiquHtt1DnIv
 dw3uu8UB9E+h0raXf+IGVfhezxfeghRAEVd6gzT2bAQlhDwF7VYR6fNMxj3pgXJyF5Qr
 RgeyTXsKu65GaytpQ8/WFgp37JdBbnyTyXQDZTUVPzE5dvEnTZddLhVFzGPK+eTeT1is
 0p1U6pXgfshs+H/dY7niVLFSIdK5Y5HZTdCdD8hNYLtWXDELxl0qOWEN8he6HDG4DzfM
 gxBm0Px48gOSYsoGRsAiSm29MMvX3xotAcub+GTZFGyP6pMijK3+8I0IBmLTncQI0yNX Bg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc8dbasax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 04:55:24 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29NNj3dS032306;
        Mon, 24 Oct 2022 04:55:23 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y3k8rv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 04:55:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a8Ky22a6Y3agol7x1bPN3Z4x9wdtk0dlFimjLOcvq7oI+MGJF8z+mcY9GjjWnLcvMEsfr/W5JLVJe+lR4ATMUMKrGYEcnSXHEJMlzT/uIorhcxAGa1PMGlmmoiyKdX8hZMN6L21cAkcvoclqR3TAXkLpWN5pZmsdXagp5C+jtO9dM/XVcUd8EJMj/WT7QBiav2DX9IMFXfva04u9+u4JyqaFdtTVu1+EGkSyW5OzTHJiPTSullUsuQvDi73K6pmB1eP3qwzkcyh+qz9pOT+KEaQnbsJz+KH8Zl9TpWd4A1uZqIhMi6VFamllyYx8NBiBOOyQOwffrjUPkxrz8SyzyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UwQwLGqOq0m5KoocP/9azCmRlWhuMNLPHk63gb0u990=;
 b=ZEteuN5K1RkNXroxHs7dCfzw6ZOfNv+DJ/bXZFFGG8dkTJM25IdP8TMXi1aaR+Na/BEJ8oevhNR4DC2/BJWeDH6QpMLqEnfnF00EAglzQwmCHMP1ZEuJiQVVOTQKtseF4ssW8NswVErtbZ6uec8fQylsIo57YZDIMO97FennAH7ifpCW2Vld2ePHULFArT3vew17gnDSTOYn3kOG/ihHZn9sdPfsv04E+4tDsyzPiZq5ezJ0dK+9x9W/JU9g+H7wQM0Wga0P/gmQKRy8qfnUoG41n4NWYe+Xs9Tx0lIlN3pFPUrCgQq4LugrbRM1+w35Ix1oqzLIVle9/1Ytl2xA7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UwQwLGqOq0m5KoocP/9azCmRlWhuMNLPHk63gb0u990=;
 b=TeAE2kl5rSBw2OFVRFrTCIUu60eiX4wS1nLSXBLi0B1qA/tHRuS6wXJmgIw86pZdza5W+5xg4QuSQ03+spmiu2lHwUxkOJZf9ozRfLBBi7ieD+tqUp/cFYeqRKHQgsJaHS5fnpflTJnVQmEgC9iGzfLUlWx0KSNTr23RT8ERqcE=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS7PR10MB5374.namprd10.prod.outlook.com (2603:10b6:5:3aa::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Mon, 24 Oct
 2022 04:55:21 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c%6]) with mapi id 15.20.5723.033; Mon, 24 Oct 2022
 04:55:21 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 16/26] xfs: preserve default grace interval during quotacheck
Date:   Mon, 24 Oct 2022 10:23:04 +0530
Message-Id: <20221024045314.110453-17-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221024045314.110453-1-chandan.babu@oracle.com>
References: <20221024045314.110453-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0034.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::10) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS7PR10MB5374:EE_
X-MS-Office365-Filtering-Correlation-Id: c0a1e38a-6f25-45bd-20f0-08dab57bf456
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jfW27dfYEeE2F7EKzXgcf/dQvej3SPba7744gLz7JzK0PRD7MNPBlvwGgcXep+qOhT0mTStwu/H/9ENP11zoEsgKsFZFaBT5FtjhQnVQrKOmbLLySA/w40cGe8rvitBPa9hxh4B8yKgK9MDYZSXvS9zsr9upB5DS2SqHP/S3DHxDsZWC44U/CGhtAwK6FhibfmW9Jdji2WQKClOGhynbQWhZ8dwdAJXIGHNC3ID4Mz8RrInod95KPsvGi/K7bj8X8D4qDMFRgVlsjSWg1LDgAq0rKkW1bClb84vh+svWaJ6MBX5qxdrIjOl+RVe77pOda6pxAyeH8PoXtXCm33utP17vc1MVz11BkSbgQdw0g0f8ZGl4IM8/85OXv+KkCuLunGb3CSBRQ0VZNJd7zFqv9q0/6g0BNAu+GsoTKWaDxTgcspE40iWMW059iOlLBLT/JPYhNEOaV4fNiUfJIeu/08wcH07p1qx+3JUK6z/Q/pS+usHOTOd6Z4kqtQCWRIIbpB9Tq9i/797B2GDrROKiW98QQRN80jScvpGrSvf8/cLbQ1FmlGiwoQ4y9YJROUmqj2l+Iw7FVPDIB/yglRJGr+Nh8KhywtGI1SigWJTa9zqcEfVeAfC6zFVry/1yStZX2nWR1Zqo9E8pn58gO0n0b8tnLMw/DBVXNFcr7JI+naMvpA8RdT7VlJtqBxhuEXeY9bjvwCX/Idu1fpkSFu2t4A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(376002)(346002)(39860400002)(136003)(451199015)(15650500001)(6916009)(83380400001)(2906002)(5660300002)(6512007)(26005)(6486002)(4326008)(8676002)(8936002)(86362001)(66556008)(66946007)(36756003)(66476007)(2616005)(316002)(1076003)(186003)(478600001)(38100700002)(6506007)(41300700001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vxwF1ur8V9FplaA03NJvLAC/clfKS79T8sqvrijh+7hb3954yxg4S8i8I+wA?=
 =?us-ascii?Q?Z9NU/ykjq5uLp8MwbWMFH51dYI4aX+Ybma0L/ErL9BUHhN9Pyui85TNikUDV?=
 =?us-ascii?Q?WFYNsy2WaVm9Dq4D3bML9Rbcbc7U+5syWx+5+99Ls3Jr0UbgZBYzusMghCmM?=
 =?us-ascii?Q?s3UqwHuEWzYamu5qpsoFH3LpkQs4gnhBjw/KhvEePXYZhQaOLeIZAFVROyEG?=
 =?us-ascii?Q?2vujfgKQMo4kinM1d+ezL5Ic3KdT3QPNjRJ2Ctkq3xA/q+mcWDjsXUMzqG+y?=
 =?us-ascii?Q?hePn0aqMDGBAgXUSdi1N1K8dCpAOjXhVTuvhz6EQGNCDrQYgvoh38PM0qWAT?=
 =?us-ascii?Q?Ks1swZQMefecvohf92WHqkPelnhXgwnwSLbELiXruNWk2lHWzKVK3deEG7mQ?=
 =?us-ascii?Q?oU1VaZw6bwCDZB+DP5Dnv9JqPR1AZOZCacWzHh3SDT2HGFCPHTMqNp6XhfgE?=
 =?us-ascii?Q?d0+B+eiO3+jWAdti56eCkNhcu5iG9IFvuydGSNwNb0cSVFo5eERRWe/IvikO?=
 =?us-ascii?Q?ERh1RWF0iMogfBo0NdvI572EDqr9GBTOmsfNd6a1oZLLddTSZHcL1vsc7lXP?=
 =?us-ascii?Q?xQOcFHA9ws4ovnDvdsKO7DSBLFTAU7YreO8Y/cG88l8bsOA9sQ+tiwO8xpy8?=
 =?us-ascii?Q?3eJ1vhQFozuew0jqXoMYHSHi5x4fwsEmadluj8iG2fOyA0fgH+uGhIGbyK8n?=
 =?us-ascii?Q?x2WotJryED8Ll6PEr6eAwne7Hf8nPyf+uMHh/uSIta6CanirEyEJcx91SGF6?=
 =?us-ascii?Q?8E+K5jF1hs6/Is2pNaWMENYVJguJmhZ4MiM+TN/mwuCXXI0ggQ6NZKWluYF3?=
 =?us-ascii?Q?6dTQaarqnf9O+Zq8+8Kt7ZNgdb1d5w2MRhRnOlv6z12HX2+pQGomKt4X/8cO?=
 =?us-ascii?Q?8H0mW+xJVZsaNz2r4aT0DcGIWcMiLPRh0G+gVsYBrOKflp3kA+vyCgqeQgZ8?=
 =?us-ascii?Q?huYj3iNRVQk0RShkUENLXHSxFs4yz17IsryWnaFw0HPy6c9D26B+VP5S4lzD?=
 =?us-ascii?Q?FvPJrtaoGUK6jgx+OBIjmlI8DkILYkUDjvykW7EnLX4BsXM2xojGVJWIKWDq?=
 =?us-ascii?Q?qTj223fNhDXunHdM6gjxNTAUj/AkmU2LpEhmxC6HFjTNC1DIZOsNUNjb9oBe?=
 =?us-ascii?Q?RhFEXeWhmm39tB6ueYJnaWZegYF4+oJHaqbYq/Y8LiGcdCLdFDOaf5bh5bzX?=
 =?us-ascii?Q?nEDO1y/D6C8FyIrGVYYUcpXxf5z1/x3Y+CsrrP7/2dSLLDtu8VlCEQlr2XTO?=
 =?us-ascii?Q?i7eJn8eESmB4ZY1N85+EJ2V8o9z3vsxXUdRvLGO3APB47FA17RoqPKFhBiAs?=
 =?us-ascii?Q?QkoOL33LhmTRsLHdH9Zy/l9pd4VYrmB6YLAdR0hXiID9oGE68tGzre7IeMc/?=
 =?us-ascii?Q?Y08E+YtEYPbyj1+KbRSmgiapiwY16+t2jDU2v6xxMfWJs64UtenuF9aWpU7Z?=
 =?us-ascii?Q?JPwC2s+u7O7FoT5rhYTV1ODvCJpzyeHywQDh33JOl5ZN2xmjoSKxS7svcnqD?=
 =?us-ascii?Q?DsyOxpMjW2uDDqAltYA4ixedNOJZQTe5PTTcenu3eMgyd4dSuJSQy66gdU+q?=
 =?us-ascii?Q?DQ2Js/ClT09SYDKPj5RgpsrTtaa8OxPGNWjNjPzMTEfha6U7rQXkik2jPtSE?=
 =?us-ascii?Q?Rw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0a1e38a-6f25-45bd-20f0-08dab57bf456
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2022 04:55:21.4049
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CMobBM0DkYe1OSRPRTC/ioLECmpSaf+dHDpoUPsYqIZ78J3crMjS0KYnXhQS3zO7p/lmy6lsPN0BVasb9JI9Vg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5374
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-23_02,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210240031
X-Proofpoint-ORIG-GUID: w6q0wgn21w2q6QRiEriUJDKDbMuDw_X9
X-Proofpoint-GUID: w6q0wgn21w2q6QRiEriUJDKDbMuDw_X9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 5885539f0af371024d07afd14974bfdc3fff84c5 upstream.

When quotacheck runs, it zeroes all the timer fields in every dquot.
Unfortunately, it also does this to the root dquot, which erases any
preconfigured grace intervals and warning limits that the administrator
may have set.  Worse yet, the incore copies of those variables remain
set.  This cache coherence problem manifests itself as the grace
interval mysteriously being reset back to the defaults at the /next/
mount.

Fix it by not resetting the root disk dquot's timer and warning fields.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_qm.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 035930a4f0dd..fe93e044d81b 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -875,12 +875,20 @@ xfs_qm_reset_dqcounts(
 		ddq->d_bcount = 0;
 		ddq->d_icount = 0;
 		ddq->d_rtbcount = 0;
-		ddq->d_btimer = 0;
-		ddq->d_itimer = 0;
-		ddq->d_rtbtimer = 0;
-		ddq->d_bwarns = 0;
-		ddq->d_iwarns = 0;
-		ddq->d_rtbwarns = 0;
+
+		/*
+		 * dquot id 0 stores the default grace period and the maximum
+		 * warning limit that were set by the administrator, so we
+		 * should not reset them.
+		 */
+		if (ddq->d_id != 0) {
+			ddq->d_btimer = 0;
+			ddq->d_itimer = 0;
+			ddq->d_rtbtimer = 0;
+			ddq->d_bwarns = 0;
+			ddq->d_iwarns = 0;
+			ddq->d_rtbwarns = 0;
+		}
 
 		if (xfs_sb_version_hascrc(&mp->m_sb)) {
 			xfs_update_cksum((char *)&dqb[j],
-- 
2.35.1

