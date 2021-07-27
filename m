Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B367EC43214
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:21:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97E5661009
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:21:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235657AbhG0GVW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 02:21:22 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:42268 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234349AbhG0GVS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 02:21:18 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R6HBMk010846
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:21:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=fxjf+/7fiE86mhJ/oh4hYH5W+yfrsEVTD4r4FYetK50=;
 b=DX2gEP1X68LDSvQV9FxyxhPxldEnnIiP7NjyOHbEK7MkxmhZCh4EAYeJpcAuBlxTrXct
 T1s9Et0nT9W6uuR6eNxPs+ff5aaZFiFT2xgIzYUhVmqa1C3/9YZaWsX3/joWc5A+J4eY
 Y1cjDi+TXJy/hAOA93KuPy8o3jcHesIy7WBb43Wqk3yXNazzd25MnmSVUQ5ULjWCzJ9S
 sJPESAKc9O1K0i4MdiFqVx4N3q4L4ZY4jpdbTa9ODshjrvR6iSbrE2GHm1kJPujfflnE
 3BcqJraExsQHJf3vZ1zkVKMd7LmLC2nIG8Gl6w2xPW/by785EasYMXsz4SCX56+iH7nR +g== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=fxjf+/7fiE86mhJ/oh4hYH5W+yfrsEVTD4r4FYetK50=;
 b=nrd+CG9O4NAmQmRGwubXllq1aHnyQjH5QZlGUd6bamnTAU+QgA3HRkYErlfWUBxT5VWt
 yHRZVWr01iHW77A1DMi6h9wHVvb1qSO86CaD4PY6DAPvX1M2KzMIaTvtmHHcMfVeGJbB
 YKeKc1d0y9XihBoP4WxxU9rT3saJApKCPA60OkszVBju+wZZ1XhwoxG9RusEhJ7fCA6J
 kpIKKHTAGfL9/kKCapi8z8tDBs2VUepO3fIyfx6fXrFn6lIcyaZikmd5ZQ5xu65cF3ku
 Mbx7HaEFhWcsogR7KZaQdLNgoHnoAzGe9/Zg0W2mGR5khiGHND/k43MWvwlsJih1/OYU cg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a234w0v9n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:21:18 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16R6FT21019894
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:21:17 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2042.outbound.protection.outlook.com [104.47.57.42])
        by aserp3020.oracle.com with ESMTP id 3a2347k0as-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:21:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=etpLjKeOrtzmNbkxhuvDD0afRHEZq/v/q+1/p3j6ouxwkOfVY3Taa90lSY7Ku5f6nMbnbSVF5z1V+9NaG6juwoJFEZrpAUP0a5fZM8zllW4Owit2EFlJLS5sN8s/IOVGw2Zaz6NlfUce9T1iwdFkkGhM+gf5trpZVLK0+UV0VXNgGheY2NhEh6/4Ab46R9fqqqC3SrSjEy7uCennfmW7H3vf1m3hucbujPHvP9p+RNgAb+apTHybn5JDvpbSTtTouPZ4WvAYZUt1cMZ+jVcUP1p56APv9FUKPJ/yaIZs1LxMpJXFL9gkumdTMy8S69PZzEHFqQEX4OJx/Gf/vypUmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fxjf+/7fiE86mhJ/oh4hYH5W+yfrsEVTD4r4FYetK50=;
 b=HXudJJ1UX8TnhU95KH0UmvByUAA0Flm77Dk1UMoTxZ9UDk/hhC6O4YKnGdAoygMk0VJyxmDImkcTyR9lMEnoFP7ReERC4G17smCPNuBUvc3r9+Zag/L/TIYvKbw6U1AFlJflMBISMAHXi7yXEif7LuyVv61AeBuixwfGK/nlezmdczXg6yZxYHfko9zk6fiQr4yJkB4Q4XlTreOgEksjFQZSojUHW2xX9++DRzeJd5u77RJLVt36XYdqjPU7wKRQHivtmUG8OGMVM9TI1hTc9nUp8JpwZmIRa5xtbRf/G1UN/6hNaloSvIhYfZyxrhTqhJ/0MAhy/BvcMvM+qJwJqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fxjf+/7fiE86mhJ/oh4hYH5W+yfrsEVTD4r4FYetK50=;
 b=MGoK0uGteHQb6Cr0bEbRDitJbJXZ5352hczizBymdMPE6id1KRLi2ry4RRS3S2SiSEiC6XPopFYv6pRA4klAPlrwPBzcNDL7aRK3nYjVYdlhimtAzYkoU63zeO5/VC89FxjUazwnBUusA+2MO3ETd2y9uswTNLGTW5oNc4updeM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3383.namprd10.prod.outlook.com (2603:10b6:a03:15c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Tue, 27 Jul
 2021 06:21:14 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 06:21:14 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v22 16/16] xfs: Add helper function xfs_attr_leaf_addname
Date:   Mon, 26 Jul 2021 23:20:53 -0700
Message-Id: <20210727062053.11129-17-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210727062053.11129-1-allison.henderson@oracle.com>
References: <20210727062053.11129-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0191.namprd05.prod.outlook.com
 (2603:10b6:a03:330::16) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.112.125) by SJ0PR05CA0191.namprd05.prod.outlook.com (2603:10b6:a03:330::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend Transport; Tue, 27 Jul 2021 06:21:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d5b8f05e-f030-4796-c26c-08d950c6bc05
X-MS-TrafficTypeDiagnostic: BYAPR10MB3383:
X-Microsoft-Antispam-PRVS: <BYAPR10MB33838FBEB083A80C2B9A317F95E99@BYAPR10MB3383.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M6D/HCFs5WJ+07nbS8fv6o6RQg4/LeIAy1nI+7KhMy7RlZBqJha4hYPyWfOBwKeCrmtZww8JokeaxSKOnyCSyRxSdLfe4Xwse62ouWBR/CKM5CIlw7ODx1x/XR7sSCxcrupaO22fugRVhv2E5M02+S52ENlk5ezU3+bNUOwI+cAJWKSc31687YiyIlhM9mJ9z3mQO2iZ4CRARWYSOcfEty6G0WW0soadIkKqGbRFfRxMEKtSeLPNStjS/hbkop88mrnrjz6VZW085IsGGRhC9H4PNxFx9C+dvkW2k/yyw0JkTzIUI1iMHuU8ZDSvacCqx80P+JHBpY0sUzkQ33DFDzgtlAaKjrS+Y1QebpkQazULn316L8Nv5Hz2nrLi4kfJr8O2celHr0mNXljoSiAZX8kw8c01nvxnJKBcXE9m4zTGyjLO8aehhRt5kZ/xUa98lBriXj63eW5KYZmI61But2mgWGH94MhI/BEy7/AMNXIGAWY55ZKHQVhGzchNnFpxpJwVI1efqzV/Bmmk7wWBl65y2hv6pv0n/9L7+Z6CNtbwU8qupsbvPmEsmjXaFmAupDopOUgKX2EVx51+LcO2U9X3xXScvpAtqorFCnQiYVsCIzpwwMGYgY1f1HsbHrlb6MUH+BLhrx48z9yNJRjg0xqFdRYgP1YarvinQMtPth9ZrqzQp6mI9kHLnFs2F8NiynWzUMHb7ZhJ0TX8/aSTgw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(376002)(39860400002)(136003)(346002)(44832011)(956004)(36756003)(26005)(2616005)(6512007)(6506007)(186003)(6486002)(86362001)(6666004)(2906002)(8936002)(1076003)(6916009)(66946007)(52116002)(83380400001)(66476007)(66556008)(38350700002)(38100700002)(8676002)(316002)(5660300002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vV4Qefz/LRBWQX2uMOaSFd/gO8yjvlJHXybtqPbxXMBaF9bDYzKk67xWai8b?=
 =?us-ascii?Q?OVhXhiTjCoSBJ4PinTiHaI0ItsHszGI2BRUiUty5OA3w7vaGuCvbZnI0iG32?=
 =?us-ascii?Q?mbW/u1wHKx2632qPzXapsswuO+A1aF1oPyH5V5++ntwlu7FbAYLuWi66ibJo?=
 =?us-ascii?Q?d3tMshuKmnEfgZw4xv2ye4A/3PjqC75ETftgTYKZo/5jn/b0f3fzT95veSIY?=
 =?us-ascii?Q?SeaDc3jgo1eCz2EJ1ENYeuBQNjK0Mp0YwYQm8y2YYqldfa+2u7D3ffsvA9fX?=
 =?us-ascii?Q?k3yHIt9IIUeNLj/orQ7kXgnQkpR3eLpjzzth/Sr9ay7D7FD0ufDNyvqHhlAL?=
 =?us-ascii?Q?ASP+ZHWYezYpeR/PSDaN9Tay0dkwNdup5LhFRS74YXrVnGj2mcHpKYSChwBE?=
 =?us-ascii?Q?dwzLXtPxNXVlrneTfhWbSwJF64WRP259LdbBR5t8zgMIn98PT7yGL0SRQTJR?=
 =?us-ascii?Q?T3wqZTwb/OMs/1HX7XmFJjtm8mV+k0UHB2Wb+10R0oJAFymJvJZG5mObgbFh?=
 =?us-ascii?Q?ucFZHETgsor1cUeTWHMcyz7hpd4Y/B69aBiypHg+7iIuk/ShaPIBS8McUyiu?=
 =?us-ascii?Q?0j5JeaBCCmk82WhJZibvS/VRpqPqTHY7MFtQlEHj1HJW5ZnLHpjShmEZkBoQ?=
 =?us-ascii?Q?cWQiaQo/3TGYHieMMDGn0Q2lvgzdxQEzvy0enA14sSJfPqm6gho6g/b4OqDj?=
 =?us-ascii?Q?+6yWywyGJpruldtUGe3Ae4MBUO2tYAADdd9ruwuqxVOfZuvZWOwhrLSdBq3U?=
 =?us-ascii?Q?pwuDAVD/VL0xS65A89hfMDNL4AMbRHCrh0kw9SFsbiSa/BsbaOtgibtvt2+u?=
 =?us-ascii?Q?Jb12HhZhHRZQD32BrZSWV46w6fzF23QCpZJEQHW7fLWZ87L2lFqkpWOz4NBt?=
 =?us-ascii?Q?fpY/jyLNDt8yaUgLM0f9zY9hLpFZH0kGjiiZrQ+vwhWKcwHOaMV9kM9Bimx3?=
 =?us-ascii?Q?SGd7HURsbXrsaNAy2bvhB2pfpJSlmitea0EpXRyxGQ8BjcSIyDJ+p078DZsy?=
 =?us-ascii?Q?nX5EF44DYt9pop0/YS7DN+pMxIEZIgpfeOEuyO7LDeSmt5Z4HKIxdMcUzpFM?=
 =?us-ascii?Q?L3PX7MIQTQ7iOxKdeD8DLF6adFv/e9DMJ6EmOA3kKACZnM6FJYdeF/3SCCVM?=
 =?us-ascii?Q?UdWWYEmDgZqbXyH6ffv1gP6ePm2x4MLfynWc3548l7diu3tgeQENsnKzPibX?=
 =?us-ascii?Q?7qCWjFmPURB/k+m4MbWaRGnux8cCWWXUuKFH+2y7o8iWiZujiJK/b5481OMB?=
 =?us-ascii?Q?luOhth0o9piGJicIVQKU313OxCgjo8Tz7GCLKp4YZqgAeqAZbBxdgoVVkG5F?=
 =?us-ascii?Q?j+aUE2Ww9ucft65nhP4kUQIu?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5b8f05e-f030-4796-c26c-08d950c6bc05
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 06:21:13.9728
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rrxd1Ler5QFxAJ8AdAWuFkaryz3RsxaLSnxU3uao/bEJw2xBFT6Fo21U7UI0CWJx2BDQhRuZViB1Lmb8p/wLYCYSwtrh/at0q1oxiWcTURA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3383
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 suspectscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2107270037
X-Proofpoint-ORIG-GUID: fMBCGFN82wD5P_dNUgfez3t8LYGY6dTa
X-Proofpoint-GUID: fMBCGFN82wD5P_dNUgfez3t8LYGY6dTa
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds a helper function xfs_attr_leaf_addname.  While this
does help to break down xfs_attr_set_iter, it does also hoist out some
of the state management.  This patch has been moved to the end of the
clean up series for further discussion.

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c | 108 ++++++++++++++++++++++++++---------------------
 fs/xfs/xfs_trace.h       |   1 +
 2 files changed, 61 insertions(+), 48 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 811288d..acb995b 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -285,6 +285,65 @@ xfs_attr_sf_addname(
 	return -EAGAIN;
 }
 
+STATIC int
+xfs_attr_leaf_addname(
+	struct xfs_attr_item	*attr)
+{
+	struct xfs_da_args	*args = attr->xattri_da_args;
+	struct xfs_buf		*leaf_bp = attr->xattri_leaf_bp;
+	struct xfs_inode	*dp = args->dp;
+	int			error;
+
+	if (xfs_attr_is_leaf(dp)) {
+		error = xfs_attr_leaf_try_add(args, leaf_bp);
+		if (error == -ENOSPC) {
+			error = xfs_attr3_leaf_to_node(args);
+			if (error)
+				return error;
+
+			/*
+			 * Finish any deferred work items and roll the
+			 * transaction once more.  The goal here is to call
+			 * node_addname with the inode and transaction in the
+			 * same state (inode locked and joined, transaction
+			 * clean) no matter how we got to this step.
+			 *
+			 * At this point, we are still in XFS_DAS_UNINIT, but
+			 * when we come back, we'll be a node, so we'll fall
+			 * down into the node handling code below
+			 */
+			trace_xfs_attr_set_iter_return(
+				attr->xattri_dela_state, args->dp);
+			return -EAGAIN;
+		}
+
+		if (error)
+			return error;
+
+		attr->xattri_dela_state = XFS_DAS_FOUND_LBLK;
+	} else {
+		error = xfs_attr_node_addname_find_attr(attr);
+		if (error)
+			return error;
+
+		error = xfs_attr_node_addname(attr);
+		if (error)
+			return error;
+
+		/*
+		 * If addname was successful, and we dont need to alloc or
+		 * remove anymore blks, we're done.
+		 */
+		if (!args->rmtblkno && !args->rmtblkno2)
+			return 0;
+
+		attr->xattri_dela_state = XFS_DAS_FOUND_NBLK;
+	}
+
+	trace_xfs_attr_leaf_addname_return(attr->xattri_dela_state, args->dp);
+	return -EAGAIN;
+}
+
 /*
  * Set the attribute specified in @args.
  * This routine is meant to function as a delayed operation, and may return
@@ -320,55 +379,8 @@ xfs_attr_set_iter(
 			*leaf_bp = NULL;
 		}
 
-		if (xfs_attr_is_leaf(dp)) {
-			error = xfs_attr_leaf_try_add(args, *leaf_bp);
-			if (error == -ENOSPC) {
-				error = xfs_attr3_leaf_to_node(args);
-				if (error)
-					return error;
-
-				/*
-				 * Finish any deferred work items and roll the
-				 * transaction once more.  The goal here is to
-				 * call node_addname with the inode and
-				 * transaction in the same state (inode locked
-				 * and joined, transaction clean) no matter how
-				 * we got to this step.
-				 *
-				 * At this point, we are still in
-				 * XFS_DAS_UNINIT, but when we come back, we'll
-				 * be a node, so we'll fall down into the node
-				 * handling code below
-				 */
-				trace_xfs_attr_set_iter_return(
-					attr->xattri_dela_state, args->dp);
-				return -EAGAIN;
-			} else if (error) {
-				return error;
-			}
-
-			attr->xattri_dela_state = XFS_DAS_FOUND_LBLK;
-		} else {
-			error = xfs_attr_node_addname_find_attr(attr);
-			if (error)
-				return error;
+		return xfs_attr_leaf_addname(attr);
 
-			error = xfs_attr_node_addname(attr);
-			if (error)
-				return error;
-
-			/*
-			 * If addname was successful, and we dont need to alloc
-			 * or remove anymore blks, we're done.
-			 */
-			if (!args->rmtblkno && !args->rmtblkno2)
-				return 0;
-
-			attr->xattri_dela_state = XFS_DAS_FOUND_NBLK;
-		}
-		trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
-					       args->dp);
-		return -EAGAIN;
 	case XFS_DAS_FOUND_LBLK:
 		/*
 		 * If there was an out-of-line value, allocate the blocks we
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index f9840dd..cf8bd3a 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -4008,6 +4008,7 @@ DEFINE_EVENT(xfs_das_state_class, name, \
 	TP_ARGS(das, ip))
 DEFINE_DAS_STATE_EVENT(xfs_attr_sf_addname_return);
 DEFINE_DAS_STATE_EVENT(xfs_attr_set_iter_return);
+DEFINE_DAS_STATE_EVENT(xfs_attr_leaf_addname_return);
 DEFINE_DAS_STATE_EVENT(xfs_attr_node_addname_return);
 DEFINE_DAS_STATE_EVENT(xfs_attr_remove_iter_return);
 DEFINE_DAS_STATE_EVENT(xfs_attr_rmtval_remove_return);
-- 
2.7.4

