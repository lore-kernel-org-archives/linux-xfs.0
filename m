Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9358C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 20 May 2022 19:01:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353103AbiETTA6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 May 2022 15:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353081AbiETTAu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 May 2022 15:00:50 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDAC65F7F
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 12:00:47 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24KIeRZP022596
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=jpxF76nxvQZdedYr7G37ei0LDFcicP8s7io+/7W3fDQ=;
 b=vuuKCU6hI/QLFcolwQUajxpWtnx9YLIgBTBIkZMUxkfDi14q7zzokintpC2CJM0SdYeT
 x9zJPH66A+mRtaUzoz6igBNOVWxK8856jAod+68FGkePSvY1AQ+UyoRoNetv042VMeUg
 WQ23uLivDO3RXQqBN7/xJgzmllyunSuroUFwV3CgKlS5qgp7uPsW9Y5zAaQkGrVZ1NBH
 sqS1YDpfSbfFqSGFXa6HcGYQOFtC25KJswuXInz7+pLqmrvEaBp9SuhZDit2w56FZu8a
 HOGK0xiRqkmG4IvWR1VRiw532dSzhMOkZwOWO6TQp+mJqOfLsHAbaAPczdHk2Ew7WHd1 /A== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g24ytyx85-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:47 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24KIo9u2034597
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:46 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g22v6mhfm-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k2bulwUFfOjTvGeDKWh5MjXz0dJkD0Up5ObWJSeTa1/Dw0aeRr5denZtKLOHuhevwBViSuBbPTOUufUTD88p9VMYgBA60wrVIPOApObG63UC7vOpwlMnBkfzvODfORpJ5S8eFeL05jlADt2IZqt9vGZ9SEFB2u7Qmo0XngQKAO/BX+xpUIe5JQXT7tuh99RogYIhLj4bz93KaG/CqfaIJkN1NdrP1QaME7RfHyfk3Vcda4IY8NsBhck8DKMouTKZ1WnATCFLfMMtPv3lnrj+MfQEpd7xc2BVrDx/bQDguLGcTEp4kVjMEzXztb/CIlO9udXUmFL1lNj9lDi16q0jng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jpxF76nxvQZdedYr7G37ei0LDFcicP8s7io+/7W3fDQ=;
 b=Eg25jhwMc1gPONoHoa8gVOuo7XIpJph8J9jp7HmE7NLXrF2nIWTbffRWMGmFHz5Ka+H2p5VlLyiEnwhjv2uHuCbKGOufhQvzQoBkmcZAFN8OQbBWHiEbCRj+ZBZCx8P3z7atwa1ue58cE9e7rBucVyTBQS/uRFRWeJKIstPD7pClTqOD+qtCxffmFc/Z2vVf+zcJhLmV36GPqX8+AweRhLZbYAZ2Nzx+46RkNcFzCFaFvaBkkS56BzMpNNhk0Cq/eZXhyR//tkrpS+Hq0Ba1rZvvj6FPvvpZtIkHfOnaC7dr7AXIvKX6gJM4vg4UTliN5OKG8xuhQQHlcSfGyViZYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jpxF76nxvQZdedYr7G37ei0LDFcicP8s7io+/7W3fDQ=;
 b=n6JNj0mDSlOM0BderpbQMXBFyC0Med/idJDXS5PC3x1MiIp1OwcdUcDka75LNZjK0vYCZQFSiABrTFvTbyiiGw4Vt85y62/LwcgWX5fOMQYHP3rSp9H17N/zn1UxXf/JgX7b6wgHQ8xwoTIHO3lLp3rA/jU45avNx8aIdV0IcI0=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3399.namprd10.prod.outlook.com (2603:10b6:a03:15b::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Fri, 20 May
 2022 19:00:43 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311%4]) with mapi id 15.20.5273.018; Fri, 20 May 2022
 19:00:43 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 09/18] xfsprogs: Skip flip flags for delayed attrs
Date:   Fri, 20 May 2022 12:00:22 -0700
Message-Id: <20220520190031.2198236-10-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220520190031.2198236-1-allison.henderson@oracle.com>
References: <20220520190031.2198236-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR04CA0014.namprd04.prod.outlook.com
 (2603:10b6:a03:217::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8db8f753-825d-4516-b625-08da3a93084b
X-MS-TrafficTypeDiagnostic: BYAPR10MB3399:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB3399F871D88ABEB7C856EABB95D39@BYAPR10MB3399.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UAI0RsEVjTnvDmRY/Qs+f0DqlkO/cN8X8SU3AGDIUQL3REpaVawNeXZC3cVjEYhkECiaRNz4fAJN7Z3zX077Oauskw+ZH6CcMk+L4jXdbASW8/TcsUcOtxXOZfI1Yy7eNUjaWDTVKfe8OHO3hTXbjYc/9IeyKRMKJYKejN87wF0dGVIIvKojrRzzl7jcw0NPs7EP5oxRQoT2Cx5j8BL/jl0D7SpK8hgd6DjZExChtXSEibmNzs9srbJtNooZL7LnR9aMv5TtumlvCEdMmwyWEw/r3CN2TYKpJVT3++gQQouwIrVLGVE65BBl0ZEOKVMlIH2e8LAG++qrTvgGIIIYq9RCObbks0U3Cl9cKig56N2dF1EaCmsK8jwsTBpVQJ8jpHSPoUKn5+A6IDkbtgy78y32oZrT0/FmaiaX6gBScUdA/KbKNWx035ADfy3cHnQr6iNP0D3R3TeJsWmOBVzeqd68aKXDpOgtO6vr6zj2TbmxPkOhHdPDCXs1C+K6GpnuxK3a6OTeWRy0q0ygyrMHOO652vgHa3KfwZoVKjUtLE1nngLrUHoJQZYe6F9cTQlQJyT4LKLSvvaREVb+p+42Eb0K9eBkRr5KLbczkXY647F2mrE0gfQRSBDiyNuTJXep9/kz+eMqbiBxWrUPoAGJFKZc8JbvETB49ko9FUnddV0gpEy0/gJE2UT7MPTpqykgk10xezc8ytsPMlBDhkmm8Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2616005)(86362001)(6666004)(66556008)(1076003)(2906002)(66476007)(83380400001)(52116002)(26005)(6916009)(316002)(36756003)(6512007)(6506007)(66946007)(6486002)(8936002)(38100700002)(38350700002)(5660300002)(186003)(8676002)(508600001)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zqFRN0wz6Zgk57mJNl44mqr6aZ5Y7ZV9v8jdTHf9M4r6n/EFZ7YCtO/9ZcRw?=
 =?us-ascii?Q?wyg7FhUzOQWcuU+/jLu5qNcfayPsZ28rrtU55QZXOetolQQ9VEy3p3R0AX/P?=
 =?us-ascii?Q?jgzWH3Leri16yAJmM+lyRmFQvC1vx+fW1pRep+n0HlQfVM3UJJ25zn7fwNdG?=
 =?us-ascii?Q?Qv5w0za/y2nJvjHVFoJdDueR0xEoE1/19Aj34V6O8Y/2F63nohA8G2APeT9S?=
 =?us-ascii?Q?ymLOOZNbfCt3bA1gLakFzxEL3HhCpS8wZHe7D3pNpL5xYR+bWgl70Xrwr+XX?=
 =?us-ascii?Q?XfdHVBQGryqIZIan02/aiS1Lrwl1REUaxQ8H3WS38RrclMog6CCv3cJsrtXm?=
 =?us-ascii?Q?DQY3MscLwDPOKQQjMTUSdd34UTtcHV04nde+9wGE8VKmqwxa85NsEkyLmUvn?=
 =?us-ascii?Q?lQM3CNlQ9XW1IeXq2lEuw+9+MQcU7W4arRWxQPMwiurdfDmuWNahCpHWv0Eh?=
 =?us-ascii?Q?oLqjTGzFep8Ql2+0tn8F7cxsf+/rx3aOqYvJrYTx/fC46/y3B0Z26yYkgiAh?=
 =?us-ascii?Q?OYqAlL1EoJIhLVv/CefX1TAesGGm+Z+0lGCPDDO9P22/nGgJCdKcdZ0l2MGH?=
 =?us-ascii?Q?AQmFVF/Xa0QOQzJMRpNJVUiRoapvoDMa59begRtps51756n11tY0eerLNeGI?=
 =?us-ascii?Q?SQ4LQt/9WN5+j3XgqQ4Nj3dEpK70Qg1HB0+VfeCadiaKYbNTQCvRbZAFmzM7?=
 =?us-ascii?Q?+N9VQOwb+hW0Z139BeNy4hi62+L/rgbbCbIVzP9PAPhZ7AJ/E74W7S18PlDG?=
 =?us-ascii?Q?U0NatQtASiL+8LsqAho9OBvSBgzx+zK0M8uV0PLCX17nSnlctT9vacgUf0Yl?=
 =?us-ascii?Q?+uTgRY5X4MZhqcjyWY9XbX9xz0b2eJVfpqIqzmwMBFhGR8UHMTVzetPnHK1z?=
 =?us-ascii?Q?Lvi8grTKxbG4Hr2XL5+PTRkQwsNCIxm/2CvP0Ue5QtU+G9RCW9JOs1iAKq/V?=
 =?us-ascii?Q?M/8FtvjggiaXW4bapvKgQ1K0aPMXbhryK0oCb/98lWsxNzQdcJCMEpwmsnFd?=
 =?us-ascii?Q?xBqtnLO7GhFM2dUyY89s7hS0zRGoFKbniDZXgWb4sE6z1Tddccc/96MApF3N?=
 =?us-ascii?Q?KHBPC5a9nfzsPVorY8XxVtMXFlO2IB2BVi9UBzl6b+d9zE5Ud0h/ZsnvZ3Bu?=
 =?us-ascii?Q?sIOIIxCj1pswPih2RZHvExi3xh8NzvuWVGspy/h/DHYVD4N5N37lzaFEjwVb?=
 =?us-ascii?Q?XkpWRujE5SW15YCWqbss1unStvaRkC+LUQez07Wa+iYy0iV3nYoxvjJmo3tQ?=
 =?us-ascii?Q?Zztyw+qJOGFwo97gRHNmpYg98Pri6zJVNxXcZAuIyNLvh+get0ERq/0gM3OV?=
 =?us-ascii?Q?HgGhaM6VegUM8UjwPpCnUQHqtPWcXikyJTr1UJf3EbZXPxj2ZNkHhRQp2qMH?=
 =?us-ascii?Q?3/Q78lKZRbpQIstaWLCdiyiPQqbDXjAnB0JthTZtJgTL7udkmNI7qNFR3PiC?=
 =?us-ascii?Q?QOFThz2W+DubH2XvnMPhQdm62lDm5ezUrQYiHsHrulfs8X6xOLZXXlm/qkzn?=
 =?us-ascii?Q?uEVuIsO35Gy0NzJrAEhMhOwO8z5yAlBKHZFb3f74NghlRkelxZHQiHBGa6rR?=
 =?us-ascii?Q?rsd8xAiD6Pr/UPnCH9JDJzrUxq+45P3v8DwljZCIe2QP8UYOQue+X/T8X4Jx?=
 =?us-ascii?Q?iQpxjMj+gInMksc9bGeBZKTZEoLq4FPOB87kDrttwWQKVrMHunndQ7qwirxx?=
 =?us-ascii?Q?e32Rymu1G588mfIQ1SJWfeb8WE8lFFeQSDf1pExcnCZnvMQEuQgzcLX5/KLO?=
 =?us-ascii?Q?u+bvZIJDaXo4F+vFqPNk/5eKfAV0mhQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8db8f753-825d-4516-b625-08da3a93084b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 19:00:40.1067
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: unoJeKh3KKpfU2U6Em6XRHanFKCUnNS4nqtfGQzpu179PIeODSRcUpcf2ocGfvsPei0hBiB7c2HIjVnbL1dgrc7uWOfYLywoe0d0/Vob7zg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3399
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-20_06:2022-05-20,2022-05-20 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 malwarescore=0 adultscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205200119
X-Proofpoint-GUID: pisc1wQPtODvh6AwtXC0uKuPDhPp2PeR
X-Proofpoint-ORIG-GUID: pisc1wQPtODvh6AwtXC0uKuPDhPp2PeR
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: f38dc503d366b589d98d5676a5b279d10b47bcb9

This is a clean up patch that skips the flip flag logic for delayed attr
renames.  Since the log replay keeps the inode locked, we do not need to
worry about race windows with attr lookups.  So we can skip over
flipping the flag and the extra transaction roll for it

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c      | 54 ++++++++++++++++++++++++++----------------
 libxfs/xfs_attr_leaf.c |  3 ++-
 2 files changed, 35 insertions(+), 22 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 76895d3329f8..6cda61adaca3 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -354,6 +354,7 @@ xfs_attr_set_iter(
 	struct xfs_inode		*dp = args->dp;
 	struct xfs_buf			*bp = NULL;
 	int				forkoff, error = 0;
+	struct xfs_mount		*mp = args->dp->i_mount;
 
 	/* State machine switch */
 	switch (dac->dela_state) {
@@ -476,16 +477,21 @@ xfs_attr_set_iter(
 		 * In a separate transaction, set the incomplete flag on the
 		 * "old" attr and clear the incomplete flag on the "new" attr.
 		 */
-		error = xfs_attr3_leaf_flipflags(args);
-		if (error)
-			return error;
-		/*
-		 * Commit the flag value change and start the next trans in
-		 * series.
-		 */
-		dac->dela_state = XFS_DAS_FLIP_LFLAG;
-		trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
-		return -EAGAIN;
+		if (!xfs_has_larp(mp)) {
+			error = xfs_attr3_leaf_flipflags(args);
+			if (error)
+				return error;
+			/*
+			 * Commit the flag value change and start the next trans
+			 * in series.
+			 */
+			dac->dela_state = XFS_DAS_FLIP_LFLAG;
+			trace_xfs_attr_set_iter_return(dac->dela_state,
+						       args->dp);
+			return -EAGAIN;
+		}
+
+		fallthrough;
 	case XFS_DAS_FLIP_LFLAG:
 		/*
 		 * Dismantle the "old" attribute/value pair by removing a
@@ -588,17 +594,21 @@ xfs_attr_set_iter(
 		 * In a separate transaction, set the incomplete flag on the
 		 * "old" attr and clear the incomplete flag on the "new" attr.
 		 */
-		error = xfs_attr3_leaf_flipflags(args);
-		if (error)
-			goto out;
-		/*
-		 * Commit the flag value change and start the next trans in
-		 * series
-		 */
-		dac->dela_state = XFS_DAS_FLIP_NFLAG;
-		trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
-		return -EAGAIN;
+		if (!xfs_has_larp(mp)) {
+			error = xfs_attr3_leaf_flipflags(args);
+			if (error)
+				goto out;
+			/*
+			 * Commit the flag value change and start the next trans
+			 * in series
+			 */
+			dac->dela_state = XFS_DAS_FLIP_NFLAG;
+			trace_xfs_attr_set_iter_return(dac->dela_state,
+						       args->dp);
+			return -EAGAIN;
+		}
 
+		fallthrough;
 	case XFS_DAS_FLIP_NFLAG:
 		/*
 		 * Dismantle the "old" attribute/value pair by removing a
@@ -1232,6 +1242,7 @@ xfs_attr_node_addname_clear_incomplete(
 {
 	struct xfs_da_args		*args = dac->da_args;
 	struct xfs_da_state		*state = NULL;
+	struct xfs_mount		*mp = args->dp->i_mount;
 	int				retval = 0;
 	int				error = 0;
 
@@ -1239,7 +1250,8 @@ xfs_attr_node_addname_clear_incomplete(
 	 * Re-find the "old" attribute entry after any split ops. The INCOMPLETE
 	 * flag means that we will find the "old" attr, not the "new" one.
 	 */
-	args->attr_filter |= XFS_ATTR_INCOMPLETE;
+	if (!xfs_has_larp(mp))
+		args->attr_filter |= XFS_ATTR_INCOMPLETE;
 	state = xfs_da_state_alloc(args);
 	state->inleaf = 0;
 	error = xfs_da3_node_lookup_int(state, &retval);
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 31eddb543308..45d1b0634db4 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -1484,7 +1484,8 @@ xfs_attr3_leaf_add_work(
 	if (tmp)
 		entry->flags |= XFS_ATTR_LOCAL;
 	if (args->op_flags & XFS_DA_OP_RENAME) {
-		entry->flags |= XFS_ATTR_INCOMPLETE;
+		if (!xfs_has_larp(mp))
+			entry->flags |= XFS_ATTR_INCOMPLETE;
 		if ((args->blkno2 == args->blkno) &&
 		    (args->index2 <= args->index)) {
 			args->index2++;
-- 
2.25.1

