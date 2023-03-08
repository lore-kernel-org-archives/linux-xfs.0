Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02735C678D5
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Mar 2023 22:38:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbjCHWiQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Mar 2023 17:38:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbjCHWiN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Mar 2023 17:38:13 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AE402DE7A
        for <linux-xfs@vger.kernel.org>; Wed,  8 Mar 2023 14:38:12 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 328JxvCF026722
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:38:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=MFDtTRhyv01ZEygnq385U+/6cagFIueYX8bTrpBpPBY=;
 b=uczWSQPTYG3C2abUIczm3hQMHM1z8wb51NYU9S04h3BEj33XnUfRWndYu4YVGJ1HV/vf
 moh8Y+CZb423UZDygKucskrJet64WpK8be4HcdxLVAsG+fi8f4UbfpvA5Dh897eyK/Up
 g7cf7JNdF3fIcYRFsqosMqh/2SfNTdKyffcOQW9tzq7LpTOeXurIZHl4NUzc3ucWARW4
 4XdSeqGefPWcVYVYKhIFaifww02vHTHH4JFggcGfEDDd6wrt94HGPaKH6Ta+Q6/ERwSn
 pRgH3FRAxRYu/RqPc1N2JiuSR8aaMB9DdQqj07Hmyj/05Kp1UF51nKf9nUD+7vceBmBp /A== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p5nn95qe6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:38:11 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 328MAF4n036499
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:38:10 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p6g464w1m-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:38:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jufo7AcWlXi357jM3EwFRV+TZjmMM8oCExDFDQFRbAZIIn/q9TZWKXC6s0Ymfky75XR+M6Jgd3Tsugwty4MvF8DQ0dE8Jkj4D6xoU31/4ELyptU04s5xQEqPIfJ1eyB0I6PZwHZwlkVVi4cp3glwNHhvcceLjGqV1reDfCBsyiSsnPcEpkqEEk0kVm4HllLWVI73XvpkAXjF/XLhhgERMgLnPmIBv5vPGstV+djmKdXf1cpDExT6Zumh/mKPIg0GoNQaGDdF559RD6HakXWqRCf5NuIfFJZRncKLUVuhPtVn8/zjrM+PKYMkTwY2nRCAqH2fQD31BqklDtPf65/QzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MFDtTRhyv01ZEygnq385U+/6cagFIueYX8bTrpBpPBY=;
 b=Ql3kyq8ohsmPJ+dr8qONy0r0JLF2OkMRLirpGjf+uFQT1U2yrpI3zbaI4QG8N+c/HhmCLNPnS9x044R357ZSMrA+c9EJELiaI3JQyvhaAWFYAf9C2bFSgysCzUVIn3GffiVjD8BZGoiDthXTuejuh0to4S0FE8pHAIGOm+YzALze1sJck6SXxuzfkRFjqxbY4Sg9fr7VaRueO6vWhAWFvHr28gTSKQ9SlCFvvYH3DvPXhzJwUz3ulJAqGkxBUu8aBryYFYYzA4NFAV1uzJTMhwDN+I4b+KoTzbme8f6RmzBmOUPzp+Bcl7rVGVauvWz7W2qPD/+yssE6utXeQdwCcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MFDtTRhyv01ZEygnq385U+/6cagFIueYX8bTrpBpPBY=;
 b=q1agP6ogtx5vUziHeB+8zr4AwP48SgDJ8IWLZKjGvg1tE9Z+tLfmEK1tVecJDWA1aq4P0+YLZXHreVa+MpVcuqXoMRkwYAAWVjnOwEKcJTogEEp2Clva5ZRZqDpHwNjirLXnDUXnMQvW6uzNa75Rc0VXSXsAXpYwW42urPe8bJw=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SN7PR10MB7102.namprd10.prod.outlook.com (2603:10b6:806:348::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Wed, 8 Mar
 2023 22:38:00 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06%8]) with mapi id 15.20.6178.017; Wed, 8 Mar 2023
 22:38:00 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v10 02/32] xfs: Hold inode locks in xfs_ialloc
Date:   Wed,  8 Mar 2023 15:37:24 -0700
Message-Id: <20230308223754.1455051-3-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230308223754.1455051-1-allison.henderson@oracle.com>
References: <20230308223754.1455051-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0011.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::24) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|SN7PR10MB7102:EE_
X-MS-Office365-Filtering-Correlation-Id: bbcdfb90-b1e6-408d-1f15-08db2025c583
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CmFkcTs6ObmLxo83PHyC3IpRIafTTaQMretEkc1Gd1elcGWEubYsi+azNErDK+eWaVKikecEoJJxfY3aNrl6/7k0GZNa4IHesovUn3REFvhfaH6h2m2E8X1Glogpph64kKGejZltG++6D9yrTrluTv5wBnixXCRVFydTLwszQH0jmrLysxvk/Be37grvthxvIA9jUxVSxYDxSZjAblzRfCyScAO3sOOsfmXjDYOudCK5QR0l2Q9VFqQHK397u2I3yjkrTa2GM4Ge40ly8CJjmwK3JLD3nuOuNT9vTrJLfpvDvcpUidJGgC8Jjr4waeWYzLj84ca52b2JwOzya62N9ZWugKihDp/X0KPKk3rlMZQ/cqB0JMUkjvcvlXaukQZaCjVEW5QH5IgfCIGSCKwdrsHjf0URF5EH1jeyaD0MWgxea4JcyIUaalmiWRtt7lQOPRC3l0X3tDnAHEC7H5jZ/S8h6k/NCQNMsVqN6Zz8o64TcoLkn43u2vRiAisshV7G3z2O9o+6xqMMPmnYgtoQi7NLKeZzkveD43MgItYedehIxiGICpf+9L9N5NBNZhM+pt/Tl3G1ryt6Anf/JZLdbA7Leqd7Q+6hbrT9VGVncjNpZ6l0B//IKb1oe9rUV1iYijYZCQgIHqOXC3pJZBFcXw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(366004)(346002)(136003)(396003)(451199018)(36756003)(6666004)(8936002)(6916009)(41300700001)(8676002)(66476007)(66946007)(5660300002)(66556008)(6506007)(2906002)(38100700002)(86362001)(6486002)(1076003)(6512007)(316002)(478600001)(83380400001)(9686003)(186003)(26005)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nEFkY63HfG59B6NfbbkjyOXde5QeHB4hhdE2HAtUpdwo8J1OIKbEkVmHp90P?=
 =?us-ascii?Q?NSB2ByIc69JUUBcwGDxUaAANIkJJDd+O2YWd4G8/S+YIaVqmllAjmVWaOYl0?=
 =?us-ascii?Q?SB0riEDboWmGlgEI6BqquLQByQ9YzG7TxYa4Gr+cSCW00vYS+Yg3DOKQn6L2?=
 =?us-ascii?Q?QQ6DDHwWYxKvtiEDJvBBy9FjTIfN5OeE3/9ptyvtDNyWrS/zvYK497ebh15T?=
 =?us-ascii?Q?UIz3OO8lnjUEmELZmGAphho0Ko4qhiXAeHQU3h7KkRsN8trYP9b392XcB8py?=
 =?us-ascii?Q?bjJRTYnrkF7PNIYPzo9zJ6FOOnjSiHuBOjZdbQvNAHvRDwI+69e8TPvyI3wv?=
 =?us-ascii?Q?S9AmaAwX5q1pRdqzFZ6yGJcSJaDyJuOvjKFa3csZLaNjSE8t1mWoewlcJakQ?=
 =?us-ascii?Q?k4iy3WWcPX3JANfD2cK+6aKgyfJB/NJ5bCIKIPO5Zdy8U2J/rB952YSpeyGI?=
 =?us-ascii?Q?Z8BDkUziagEB0wYXGwpXzk9JiI7E2ugNKbGdG8VR45a31j28L7YkDEerHDn2?=
 =?us-ascii?Q?hXcr05wOHZAkmZK31HiGOBxBDvqzg6jg+BVZEQGiZDhZ7wuXD6+s3peqPD7Z?=
 =?us-ascii?Q?pPWxHsk6SCpdDed4r4JcnLjtSW/tmasDg+KkwCu7i7XEkS+SXfEChyDKgJaq?=
 =?us-ascii?Q?6X33GUf6gXPCEIAO4BMT7DuM+Vz2IV0L8FU4wm5uGNp4DopUiFL9mQp3NN/e?=
 =?us-ascii?Q?vG2Fykl8y5Su4pKuYmhXKrlxQTRQZPD3oCHICHHHbP2IPLUJBgVGK2FkkrM+?=
 =?us-ascii?Q?Ukj/eewFmfQ74NzfnR4pFSmgraUyNse8GEyT57lQUzFjihUB9ZlfqAlEtqzS?=
 =?us-ascii?Q?UqdudKvAkat2X6ol/6wypZuH4x5kjyqneV2Mo3+TbkNgfAI7IZ1lssGkI0RF?=
 =?us-ascii?Q?W2/URCCc+J9j/TbzZBJAN3+4mrl8ySwhVut3kthezETIFygwOdaJosf4POtu?=
 =?us-ascii?Q?2JQeoUPeozUjksXsUrJDkWyjgXeDtIg2swwjw+UEmJfRYAIMCqgsl5baU+hX?=
 =?us-ascii?Q?du94LKencO0RHo4hHeYehSC6xYdJO8sSWmtr3HE/W9HMIuVdRCYmBmFGEdgv?=
 =?us-ascii?Q?wm79rfJ4+tD/tPEY8tfE5utq+Z6Re2nx2ivlLHUBGUJIZ5CCTx4JhE0gN3HY?=
 =?us-ascii?Q?9Pb/RbVogCe4yJ37KW3djLK0m100pTuMh/Hbov61dDcmEhuiCm0W7iPvfD9i?=
 =?us-ascii?Q?T9klunAHufvBmctGrhKe9pRNg2chfsgYN8oiEm5MxsSXyD91cJ/xssEGEV2g?=
 =?us-ascii?Q?iAMv/E3rVUlOPrbtDkWvLiItZSlT/kL2bnS9s36dE1TIGOw15TYVmOFP1TvP?=
 =?us-ascii?Q?qorar14Mq7SIZlv+T1OdasL7Pox7s7RZ53t6mriswN5lV7Nr9AdS2Y9xRzbA?=
 =?us-ascii?Q?SLi1YCwYVGh6DNTfjng8V2L9+Vv18cbj41Z835DdAEXXxWvz23uEZKiLuXhA?=
 =?us-ascii?Q?rpwfnGY+2e/sXGlRbwNXRuhlrrQyFQHOsHlC38a8OmVv4P/wgrVnyikBSImh?=
 =?us-ascii?Q?cYYRoyoT5vYbWcZ5iiQxAAZ8DWLdbNZs88SqiJcMV9kvrwfrfyaoVB4MGl2y?=
 =?us-ascii?Q?Vi0C34w2+PJX32PpU/2Jh6vn4N1Gt7ZqGOMiM7lMVNvVJW1/75mj2hRbLGjP?=
 =?us-ascii?Q?YA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: jfEC1Q+HW4l6q7Cf3sSDDVuV1oy/A3cHYharchB0xVwShdAOtfdekbXB2zpmYvESNMCfZWW7QZAIUa1LSIhDq4PiNlRmesr4W6SslnJ8IYS91MnYbHA5M7bf+uZ9o9Lrw2lPGz2O3XOXmcqT6O8R1UB3jGAK6AXPdVLBpwYUemqt7eFYW8ZjmxFVJznUG+t03vQh/lHeR8dPp9yyPIwJwvxLpulctXwBO5hpf4PJWX+S922++WU7oqKue9MBf0R5FJYS9s2/9PXKT28I/uuiMbIaJRqaPjLGt3BpHD4fa5HCml8iGNO2MCzbQ9R3L43vNvbO33w5uSbjLv9DxzA/5biT9TfMEZaB+8Xdj94q73ctlO3PEurG/JdgFIrfeG0jpekwNqOF+dW045u8KHnuh4TDhW6InAcakMh9X9OhvpN2MxFTMs3W0YlLOeB9U1e0DU0FOZTq2Enm7/aqvQJ2ZBJP/OOGhwMhZtk15b9Y/mK5TlfNZIxSxKFQG0DlynD1p5cZLh7iyOX0C/MfhnCqvhWLCdTCNd29J3Vk7JYAPZRP+7jqN4occ0QysL9or882EmjvzoF4RaPOgQp8kwYilqBZjOOP16PWNNTudlZzVpebx4Ys5yEm3L1yrF5mIkNbBZmV05/VEdVfPETs4i4GVjsYuB8a0glqnzZRht5rSDPl0Iy9zxjmI2drYCF0mgOuQttHoAg8XCJHgKXca6G969ra+bx7PNnw7O5OuMb36UhK/11WexoL/5JILr31sXm5MSuzAlyrFQfu+QUtYuWUmg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbcdfb90-b1e6-408d-1f15-08db2025c583
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 22:38:00.4359
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OioLBggOivBzZrzfyB6WgVaXO25ycpMC0yrHBOo26fBVC6OTJrFJ4gvzpAui+IeJsxOlz3YdJXpRMVXLwovYChyR+9RH+MPA1biwpc5BcnM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7102
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-08_15,2023-03-08_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303080190
X-Proofpoint-GUID: fwD4Qddk7zl8Ahvy0zLH2q9P-1whEGfB
X-Proofpoint-ORIG-GUID: fwD4Qddk7zl8Ahvy0zLH2q9P-1whEGfB
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Modify xfs_ialloc to hold locks after return.  Caller will be
responsible for manual unlock.  We will need this later to hold locks
across parent pointer operations

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_inode.c   | 8 +++++++-
 fs/xfs/xfs_qm.c      | 4 +++-
 fs/xfs/xfs_symlink.c | 3 +++
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 5808abab786c..16ebe144687c 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -774,6 +774,8 @@ xfs_inode_inherit_flags2(
 /*
  * Initialise a newly allocated inode and return the in-core inode to the
  * caller locked exclusively.
+ *
+ * Caller is responsible for unlocking the inode manually upon return
  */
 int
 xfs_init_new_inode(
@@ -899,7 +901,7 @@ xfs_init_new_inode(
 	/*
 	 * Log the new values stuffed into the inode.
 	 */
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, 0);
 	xfs_trans_log_inode(tp, ip, flags);
 
 	/* now that we have an i_mode we can setup the inode structure */
@@ -1076,6 +1078,7 @@ xfs_create(
 	xfs_qm_dqrele(pdqp);
 
 	*ipp = ip;
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return 0;
 
  out_trans_cancel:
@@ -1089,6 +1092,7 @@ xfs_create(
 	if (ip) {
 		xfs_finish_inode_setup(ip);
 		xfs_irele(ip);
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	}
  out_release_dquots:
 	xfs_qm_dqrele(udqp);
@@ -1172,6 +1176,7 @@ xfs_create_tmpfile(
 	xfs_qm_dqrele(pdqp);
 
 	*ipp = ip;
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return 0;
 
  out_trans_cancel:
@@ -1185,6 +1190,7 @@ xfs_create_tmpfile(
 	if (ip) {
 		xfs_finish_inode_setup(ip);
 		xfs_irele(ip);
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	}
  out_release_dquots:
 	xfs_qm_dqrele(udqp);
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 6abcc34fafd8..0e19ad8719af 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -826,8 +826,10 @@ xfs_qm_qino_alloc(
 		ASSERT(xfs_is_shutdown(mp));
 		xfs_alert(mp, "%s failed (error %d)!", __func__, error);
 	}
-	if (need_alloc)
+	if (need_alloc) {
 		xfs_finish_inode_setup(*ipp);
+		xfs_iunlock(*ipp, XFS_ILOCK_EXCL);
+	}
 	return error;
 }
 
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 85e433df6a3f..b96d493b5903 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -337,6 +337,7 @@ xfs_symlink(
 	xfs_qm_dqrele(pdqp);
 
 	*ipp = ip;
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return 0;
 
 out_trans_cancel:
@@ -358,6 +359,8 @@ xfs_symlink(
 
 	if (unlock_dp_on_error)
 		xfs_iunlock(dp, XFS_ILOCK_EXCL);
+	if (ip)
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
 }
 
-- 
2.25.1

