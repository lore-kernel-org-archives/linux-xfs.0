Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E626C05027
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Jan 2023 01:37:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232519AbjAXBhF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Jan 2023 20:37:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232446AbjAXBhD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Jan 2023 20:37:03 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 748C81ABFA
        for <linux-xfs@vger.kernel.org>; Mon, 23 Jan 2023 17:37:00 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30O04lcx018879
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=SZuvOWx9oe2yo3gJy7a41A0MryTdn5owTk5HVwD2v2U=;
 b=YoogCBkWpVoS1+09ZM4z/54sVwr2g9bn5JenW3By7Zt5b4oWeaYl2wZVMdQb+GderNIF
 QemMQYR4KK8tSMKv/8xPu0X6ayZmWhyIlra1IS9Qm5rInBOeeQSXjrmg4M5o5QmS/hJ3
 fth67sXSY2IE73AjKQr3sMLd6V0zUpS2DVY9K7wLaZgg44FflfAbazRyL4Gpr+OJn79R
 /TmGGwy6APLY8eXfIpm4mvdL3WYD96VyL6qzN+EYlpYyrbT/OPCCWrR6mayasuneGbnJ
 eg+5/3cFjYOQ2kJ936zJqAX4zxPiaowD6gq/JjH9XP/eJaxLvcFJx9kvU6dJMDh1OZhk VA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n87nt4a3m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:59 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30O1ITra039678
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:58 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n86gb4b63-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VmdRnJT6HgrxA69oAwPxLhDZZigxu8AIG2FkcYaTMHwni+C6pwZ10jNpqdp+nAE/BMCk4KYfOTyTPOt3DPfzUqHx/6R7n1hndicUM1CExfEHJCumHuv5V5cBtfB2dSvwN0t9Jr1i3XZ1zYhyQNtHFuUevm0bNVfYKRuXRswIpNrgmFpdaNfsdMLpPNRdSTREiTR7JcGKP1DIQeGwwlVN1OET+J7nJjcC44brIoktJ1R7dslTq8U+WUVovCbvIvW7y0pRr+vtghUtJMDdgbToAYJeczNzpbMXmUN/6oLKxtAgBNNMPK84O3e+Wouu2FdKno0eQAhUREwLkJL7lo9n+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SZuvOWx9oe2yo3gJy7a41A0MryTdn5owTk5HVwD2v2U=;
 b=fqHR8VOE5E+Revuxxgqs/9sM76CDg+ACmmqkulR8n1uaaR3dz1/rDpQGrsG0hyamNEthBhMjyfp0G5YmtFbIX4tseRnwb+oansp+Pe8GsLH2S2c2wvJTC7ul+q3TgS993i9ehxsH+NYl6uQaOqM3geMdLBRVzxbqFp/kQqn5TaNlaeSZvxqkPlPPt2weihhB3sER/z/ad99z+zJLiNi3nUoTr97sYQlAwE9GvYrQMD073Rf7P9AfPc+7OxLfKqsw1lspVV8HqtSNhufdk/7m5KTtH+9/O2d1UMZ/5ZPceXoM8xqUXf4KfhululuEj/MQa9Fk4PwL8Yi4Hg3eu1BqnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SZuvOWx9oe2yo3gJy7a41A0MryTdn5owTk5HVwD2v2U=;
 b=pTAHI/cXHm2MHrXTbA288QhG1ZiT2m0jVYTUrshk+6Mg1pPndcsjsND9LLVAFJG8M+Aesm4ZfoAGc9oZ/cKSjFavI5WnIR1VEGzmQk8A6sQ1p1vtVNFcRF62Q1lYGhhcyQabe333BmLqlsZTw/l/MZzaNV/Yu7Ng9czBwsS1b58=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SN7PR10MB7074.namprd10.prod.outlook.com (2603:10b6:806:34c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.8; Tue, 24 Jan
 2023 01:36:56 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%4]) with mapi id 15.20.6043.016; Tue, 24 Jan 2023
 01:36:56 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v8 21/27] xfs: Add parent pointers to xfs_cross_rename
Date:   Mon, 23 Jan 2023 18:36:14 -0700
Message-Id: <20230124013620.1089319-22-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230124013620.1089319-1-allison.henderson@oracle.com>
References: <20230124013620.1089319-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0144.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::29) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|SN7PR10MB7074:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b7a6e8f-3809-4e04-34fc-08dafdab7a6d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gOI7ppQFH8+zFCD02NJFubkGwqVmVj809Z/xCbphpmtAaTvNdrNJUcl5TW6BAEtdN4BnG+KSSuBmAbhTkOQzPT2x4lI/zOu9hG9JxWyuAu0YCcqZ85jLwE1vx9u4im70gbodobrkRUPfbIopWmAD51LjDkG0DzVwivyZ2NaWmvOVTT9sJgRL80n8KuuwhfDrNhGKPyQm8FXKGgUyFGiMONGOgAzQrQXXBJzcCxuirDgR/v7UpWzym2+wKo2KSmTD7nguiB/xjOVd51AOAq532LAWFRc7EJWMBHmB6NoEk5KIyTfrIJPiZefhW9g0zc+tBN9TI2LH/p6TJcKOjq0xxh7DToS/6obslreQE2eEFWQ+q4THUvVds9Q3ZM+WW2N1dOBlZLiWCw0asDHSK/rCaLapiG+7ceP37zgbfAqaPOfbwNUsADOJLs6P3gpNx9YwzhtgiCjKWKJw7YUI93bXl/q8fr4EPM4z1zMP/GzqknF3hUGB1VgGNcFdWkaV1dHfJi62o8ollT8Kx+TFR9fr1qT3A3Cj1QSC4GHFKHm9r1EGJdd56X0M+JFDEy02S1/BI05C0xwkpDZBVbs/mZIcky1cJbNe0/xSXEGXEi+bsPfvdnJNKwUd1AstOtWFVT5VskKvP0vrPGFt8EdyI8jagA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(136003)(346002)(366004)(39860400002)(451199015)(66556008)(66476007)(83380400001)(6916009)(8676002)(66946007)(41300700001)(86362001)(36756003)(1076003)(316002)(2616005)(2906002)(38100700002)(5660300002)(8936002)(6512007)(6486002)(26005)(9686003)(186003)(478600001)(6506007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vrrDl+rXhhiVmDt/W7n8WTp/KO7CASY0l7AJHLx13b3WxKySjg0h4VeB1U/c?=
 =?us-ascii?Q?ZGngdrlAZYbcB9qS8cb836o5wbP4NkxBcj4qnOoDXhKKSgxRjZ2l+1zfnOog?=
 =?us-ascii?Q?CJ6sd9MV+dTz8T5udUvIeRbJQCJf5xAt7MWmGoq2dqN5K/pKA+vTzQXivWX7?=
 =?us-ascii?Q?xWDpGstjbDcoT/H01sMi5wCaFFlZEiwAFWbjIMGqbE1Ac6MbXmq3t/x5gCjF?=
 =?us-ascii?Q?oRccfibtffHN9RDkA0nUHsJedsDbTnoyjMleTxrPCuUjTp9ZlR1bBVsScLEh?=
 =?us-ascii?Q?gTKEfOQDHnnNtOL6mSiqsZ9WB9ba/df5SPVCUJOIBX211Hg6qpSxxJzDIlmh?=
 =?us-ascii?Q?aifW55CppRF/bzW+nbRiRU162L1E+Q8yaFBphf1ferScoHFzYHKry41j5n23?=
 =?us-ascii?Q?q1MebvAy0IKD07k+874RMQDBd7QmGQnWWHSIvMZ/z2L9FytxF+jHq4HXVN0I?=
 =?us-ascii?Q?UsbQQn+W7If50H6POEzQ5Ah74bCwvty9I14pWqS+tmXL+bVH403DipMM72VP?=
 =?us-ascii?Q?BL7lEq8GJxcMh2a+xYHK3rsksBNyGVPbuRKF1WueYFGqYoHBkVoohbudJgL7?=
 =?us-ascii?Q?3ENIrbeCzZtXOVEh3BjsmIoP6gamlWUQ707ctXfqnyVlRx71p/GicN3GtUqz?=
 =?us-ascii?Q?i/DtyayT8F+RSXuJQ/u54ACgbVIjIU9S4MUiS/EvVxAvlen80sCkwomgX5DL?=
 =?us-ascii?Q?M0XFqgdP8RB1ele4tqxFFBA3fCW2eFIokRi2CsRm0IfB0qewcFJq9ohPCHU4?=
 =?us-ascii?Q?sIwXQWBStwdElzsVOCTYN25tFdBdVsww5sh+4TEW3Rk97JlmqPBCm1Mt2hBt?=
 =?us-ascii?Q?Ni1wRGbXHyyZvJWOf70roWCB391bhzYcx1R+wUHZT5PUuwD3xLPmFe7VU97C?=
 =?us-ascii?Q?7zURVpT9XnikVzjizR74DpA9hmrA/X5BghR/TWcdTnEljoaU3KpKvLqUWIgK?=
 =?us-ascii?Q?sE8Prt10sQAS5aUtKw2CxrZEQr5y539EQKtgo9XD/1/+4dDAKNVK1HZV1SXy?=
 =?us-ascii?Q?lbLwFEfTBx0AftjfP3y4y/bmFMU0MR12Otc9k1s4pUGY++HHSq7XgAFud3aq?=
 =?us-ascii?Q?JZMY/+lV9d9hpu34KI8VZvMbi42RXL6i0tl9kTvHJLUDnL4ibnI04tqC6j/t?=
 =?us-ascii?Q?uL2zPOn8B7qtPljrtJTr4ogScmd8LunU2pzozZx3j9joiGGbb3urp5WVOl91?=
 =?us-ascii?Q?oBo2nGnlVbLb0parTIHEuYw7tWpfta22BsnS5mQfM8KbwUzamRhe3+SBSnzO?=
 =?us-ascii?Q?BL7fOiE2dprlVfaFwkEy/HS/Zu5kCCYBaC0p0CdJMntMXGEUdr7IzYErNrOR?=
 =?us-ascii?Q?OOETwkn5DXhmyN5dPPQtUQgm/p9yg8RpjMK4wIzy0+MEr9jRYiGtijjVYS1v?=
 =?us-ascii?Q?TlqYp+gT1iv5cfrvgs5TMU9RoEh6Kpc8W3qDkdX3Mbk7vM9FOS1UL/R0IstP?=
 =?us-ascii?Q?KA46sGhk/HHizJFuZOcpYtRkM05aVWhAJ/FeXdqMaUnQfMfUQ8jaAMFE5uTv?=
 =?us-ascii?Q?QUKR+6JC1J0UO21NVvoCkpUzTcdIJyAZte48nIwPpQEuJkvmWKgvp5T9QZlK?=
 =?us-ascii?Q?iKQk5pUYjTviDtg74inkqJYM/4dGBO9BpLEzRAFFhXm3c6Y4oNI49pgtY8Kj?=
 =?us-ascii?Q?mg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: DeUSi1etbzvDIozed1od0aNKWYQ85PkkrLIFeJSu2sc+lXvN3q3JuuKuFsWMdCTuZBqL8N/n76CrooVrz1bgUQnszr1tGSLaiR3qFE48iqfBlDJ9zRqaIg1cA8lyMuG4K/Kom/bVxkWqZaqDj+ZGbu5Ofx+i3xZoZIbcHcIsecKHXqkF45klR9ZMkbsMApx05j8epQSbTqjQyqrGe+7PNSFzpAjafH9WXgwzVdBZaXfVnb45w7DyiUsQIqYnkLZ/idNqR4eSyThrbluhTAW8ki/LsJf3JeTddmS5l3ZInExUpW9t4ZQAp3fXV5Or/tkxNQvDtbtugjt4PZZJ6R3x6EWv10oQ33Nv48kNKl7oTYoHXlqs4l1GOjlZdedYLINiE1XmoNsa2IdaWOsfkY5z4ME/JCt3CL9BwkMylUjskW5FXDnwt7skDDwGo5QpnRxITig2CWr8ng2FinG4efJOPQD6IDPk6rVWBfHkGKHGe03K89JXPC1AijP3kOU9QiW7YxD09M8/cKW9FYfWYCqGc+0dN1n3xkQ49iGAx54jPbA2DqAHvs6CnOZt8bHTefgRurSyOej6qPnyjZeYg+AcTNKa2Iv/3XXD6uM1qsUgLUN0HADz/auQriJUxyKS2WPjsnKGGaMtQJEZSVDL0YlX7U1uWvXKyD1gNaq5ieUP8D4rd620xeC6HSm3W51dEzNbEtSVLOrWqdcl8u9y7pE/k8elJo/RBUo/X8wmdp4f3oXVx+CPw7x1ppkc2sXNEcM2lhTHPCq0iuFXV91TSdyfaQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b7a6e8f-3809-4e04-34fc-08dafdab7a6d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 01:36:56.4539
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kHYkqewRmEUgkNtDT71tjTHX8CUDG35K79hUzkOx4fcSnoR3NzBs0HqwhEYXljv2lRjLLQNOWOKE9JDOrYU7Yruw4PaHvBE1+eVy4zVDr5Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7074
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301240010
X-Proofpoint-ORIG-GUID: SNg9JNBVM-ToNhWriI_3WdAPKeDzAcFs
X-Proofpoint-GUID: SNg9JNBVM-ToNhWriI_3WdAPKeDzAcFs
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Cross renames are handled separately from standard renames, and
need different handling to update the parent attributes correctly.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/xfs_inode.c | 64 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 48 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index a24043804c33..54cfc1a6d629 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2745,27 +2745,40 @@ xfs_finish_rename(
  */
 STATIC int
 xfs_cross_rename(
-	struct xfs_trans	*tp,
-	struct xfs_inode	*dp1,
-	struct xfs_name		*name1,
-	struct xfs_inode	*ip1,
-	struct xfs_inode	*dp2,
-	struct xfs_name		*name2,
-	struct xfs_inode	*ip2,
-	int			spaceres)
-{
-	int		error = 0;
-	int		ip1_flags = 0;
-	int		ip2_flags = 0;
-	int		dp2_flags = 0;
+	struct xfs_trans		*tp,
+	struct xfs_inode		*dp1,
+	struct xfs_name			*name1,
+	struct xfs_inode		*ip1,
+	struct xfs_inode		*dp2,
+	struct xfs_name			*name2,
+	struct xfs_inode		*ip2,
+	int				spaceres)
+{
+	struct xfs_mount		*mp = dp1->i_mount;
+	int				error = 0;
+	int				ip1_flags = 0;
+	int				ip2_flags = 0;
+	int				dp2_flags = 0;
+	int				new_diroffset, old_diroffset;
+	struct xfs_parent_defer		*parent_ptr = NULL;
+	struct xfs_parent_defer		*parent_ptr2 = NULL;
+
+	if (xfs_has_parent(mp)) {
+		error = xfs_parent_init(mp, &parent_ptr);
+		if (error)
+			goto out_trans_abort;
+		error = xfs_parent_init(mp, &parent_ptr2);
+		if (error)
+			goto out_trans_abort;
+	}
 
 	/* Swap inode number for dirent in first parent */
-	error = xfs_dir_replace(tp, dp1, name1, ip2->i_ino, spaceres, NULL);
+	error = xfs_dir_replace(tp, dp1, name1, ip2->i_ino, spaceres, &old_diroffset);
 	if (error)
 		goto out_trans_abort;
 
 	/* Swap inode number for dirent in second parent */
-	error = xfs_dir_replace(tp, dp2, name2, ip1->i_ino, spaceres, NULL);
+	error = xfs_dir_replace(tp, dp2, name2, ip1->i_ino, spaceres, &new_diroffset);
 	if (error)
 		goto out_trans_abort;
 
@@ -2826,6 +2839,18 @@ xfs_cross_rename(
 		}
 	}
 
+	if (xfs_has_parent(mp)) {
+		error = xfs_parent_defer_replace(tp, parent_ptr, dp1,
+				old_diroffset, name2, dp2, new_diroffset, ip1);
+		if (error)
+			goto out_trans_abort;
+
+		error = xfs_parent_defer_replace(tp, parent_ptr2, dp2,
+				new_diroffset, name1, dp1, old_diroffset, ip2);
+		if (error)
+			goto out_trans_abort;
+	}
+
 	if (ip1_flags) {
 		xfs_trans_ichgtime(tp, ip1, ip1_flags);
 		xfs_trans_log_inode(tp, ip1, XFS_ILOG_CORE);
@@ -2840,10 +2865,17 @@ xfs_cross_rename(
 	}
 	xfs_trans_ichgtime(tp, dp1, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, dp1, XFS_ILOG_CORE);
-	return xfs_finish_rename(tp);
 
+	error = xfs_finish_rename(tp);
+	goto out;
 out_trans_abort:
 	xfs_trans_cancel(tp);
+out:
+	if (parent_ptr)
+		xfs_parent_cancel(mp, parent_ptr);
+	if (parent_ptr2)
+		xfs_parent_cancel(mp, parent_ptr2);
+
 	return error;
 }
 
-- 
2.25.1

