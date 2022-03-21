Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2E93C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Mar 2022 05:18:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344383AbiCUFUT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Mar 2022 01:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344382AbiCUFUO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Mar 2022 01:20:14 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C357344FD
        for <linux-xfs@vger.kernel.org>; Sun, 20 Mar 2022 22:18:48 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22L3PwE3017596;
        Mon, 21 Mar 2022 05:18:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=dA8ckTZYeyH8fFY/l+eZKljKQm6XrCNBN06stTvfM7Q=;
 b=TDPrC/wR1tLEweM+GeXnULci40+l0M4q+ZS3YOYVdxycqW6Fuh+HIPUL9bw9mbjmJQZ/
 H9bPJ1E/NYnPFjX4QDIDDbD6Oai0dgZC/1INDF6saXvT23b9jWOOC2MXjs0nA+mWiCib
 Q+wwuEC6O7v/mSuyNctYO/PKm6m+TxbAEhfizdlW2+KzLzfo5fgKu5/Zew/TCQ+lyh0q
 6stQfo2CwCm+WMjAcvU1edYwMsG/wdCnXZAnWaIp9Kwu90CHUqMwPADS/1tZJ5PzgHyY
 cMiyEggngLqlL5yywJFJYrOzaUNJXTWb7csz4NHAAUxKXDQB8GoVpTgd+CKloGRCNsak /w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80] (may be forged))
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew72aa3jf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:18:43 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22L5Iffj094842;
        Mon, 21 Mar 2022 05:18:41 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2046.outbound.protection.outlook.com [104.47.56.46])
        by userp3030.oracle.com with ESMTP id 3ew49r2h07-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:18:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kem78ZEgfBW1W8qM+/xOPfJCbTtCcfWgJ1Rig4wN3NCVaxYRWQXzRpQPp86udpYtF/y4j76JX6AxaHNKfrkAZ41dK739DZUzPMXs41X77dD7EfaL2qcxfWyNsf/lqkePNm7ooPnboSR3q7SlnK7LxkrO8Cx+BKdoxTA0hZvA5hYMOdwrn+f/HOlolhCHJOWQpqIkO8pdMcOB4VchozvmsN+v/FN3DLH0FDDor/mYS10v8y8cWFZVCN/KM219o2WjmqM4igE2mDRgIqBH7UdXqfwpRaor8s5NYs0sbWsbF16Ji0SZofmv28RJxJU7Y1rZhyL61X+bBUmyGtKdgUHHPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dA8ckTZYeyH8fFY/l+eZKljKQm6XrCNBN06stTvfM7Q=;
 b=L8uynjmfNsnCFaoLBSwasK5QBC4YaMR3V1NZyKT5w4QDhTXcgmsF0AbrgCWxeLoOCcWDTPDWoxdaoc5QRG4WrxCwDLoa+VPUYGStOADvbtyCxFhgc0Y3EkB5mWjSxuui7JejCk3F+zSGMV1snNoCZjhUKH+LNDmSB+VBLQdB2pIkeYCypnIgMDQRbOrehtsLjf+V0U1zzgLJGGbncRwO7M4WV9sYK/oww6XMPGoLZMxZZkLekuHhtA0YeN2Y8RKvIcjz3L1OlmdcKLOphP6UJC5ikxp2l6kLxdaTDrwIW6OdUOmRTsvY8avyOx6Uuzam4J+NlT8yc+hYA+4YLndScg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dA8ckTZYeyH8fFY/l+eZKljKQm6XrCNBN06stTvfM7Q=;
 b=QQYchvD6+H/7Z3Hs5YKpghU5JERUl6VUWxk+zm4lgR0m+gdUhf1jHV4i8UAI4nlkwTBjqvasDvOWBkWyRa/aAEPUn5RRC2yXzKePe7fBMfZ+UGQTSpZLWw5WoHKPkkqjds2E2oyMK15y5YN+12cejUKinQPFXtbkl/tNvLOI/jU=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by CO6PR10MB5537.namprd10.prod.outlook.com (2603:10b6:303:134::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.22; Mon, 21 Mar
 2022 05:18:39 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f%9]) with mapi id 15.20.5081.022; Mon, 21 Mar 2022
 05:18:39 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com, Dave Chinner <dchinner@redhat.com>
Subject: [PATCH V8 13/19] xfs: Replace numbered inode recovery error messages with descriptive ones
Date:   Mon, 21 Mar 2022 10:47:44 +0530
Message-Id: <20220321051750.400056-14-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220321051750.400056-1-chandan.babu@oracle.com>
References: <20220321051750.400056-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0120.jpnprd01.prod.outlook.com
 (2603:1096:405:4::36) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 306207e2-580f-428c-8143-08da0afa424f
X-MS-TrafficTypeDiagnostic: CO6PR10MB5537:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB55372EDDA6E9949EB5F12693F6169@CO6PR10MB5537.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /8cp7PNuzNn0mjhI9jE1kXte+bnhMD1R/+ZrivhhhV7PO1uXYH09w0qn9ocR+TuVfAiw7d49BSsz7Tll89++h8hHadpJwA/TJ/Hy42c8QRVAfKDQnNS+k1xIQlN7LiiIkKpOVHwoi5EwEqxzAc5kS7UEAgF38nweIkQ9YQcUNlAwMJLHljfLSrcunzaBKgmikhUuDhuZ/eBibG98c9sFV/D9Ebv5TwpZQNwwj/ewiGx912U/fEaUn7CKt3iUwEu66i2ED3KaW/vcLt0as2oCdYupv1NLgA+kpvtzL1GZpymeUAsCNY6bILYaaSC3U+CHIzpzF30zypXbzAvUuxhGNfSHxvXepIaNl4NDNuLjiwj2YX+ppfFP/fPfXdZ63Hinon5drhkRuudmNxr8P7TAF+ixDnVKl0srVmDof4AYLeIC7DeC/k4zqbiVztf6n31T57neav+oa3s5H0Wn+38wiUnZqbwpf6A9fsNCA8IuQ9DhRiHS76DTY9LPlFKImoiZtunEsl43E073MYy747CtW4MyhNHawtZHmfAqN49ZI8vUnV+TO9AE7Ap2G5g1PPvMIgBgcTh3p+hqvq2OREc1t9za/ymHxQ6+CBgw1LPlp00pE0gAoaUqPBa99zCt9lqrJbA+tWAqjGXuJNGDubKluM4hSLE6mOeDlxzAxgTNT4xGAw3ySt+7w2LhcQOIzgrant2cRp3efHn/lUsFvoUMBw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(38350700002)(2616005)(4326008)(66476007)(66556008)(66946007)(6512007)(6486002)(54906003)(86362001)(6916009)(8676002)(508600001)(316002)(26005)(36756003)(52116002)(5660300002)(8936002)(186003)(6506007)(83380400001)(2906002)(1076003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PZ//Y6Z4ubSGXOqKxeAtmBhaFoTXMEvi61ynO0uKitHY98BaIcpzBGY07j1f?=
 =?us-ascii?Q?uTLVkeXw7doADfC3xq4IvlEjEanPRkMDxt5iPPUgWP9omUl2G5d/ysKc7NjO?=
 =?us-ascii?Q?DBxwiu75ue2YB7OgWk4vGXZ0ssSYGaZXf+79nRlCWMK9h35vAa1dxvB4ZpvS?=
 =?us-ascii?Q?diN/Ire2LzTh8Ik8k0iElF6XT0rEcUTYKw5TR2irsdn8/QQ+36N718DGffMr?=
 =?us-ascii?Q?lfMaGoWCuqPJPpvtg8k0l36IArIiCrPNW+H3Df84FFnpN2MHPxnbDuY3aYZZ?=
 =?us-ascii?Q?moQqB158PFiiT3CCzAi6M1KjSL8sIhi4O3OqikuHomgy9CSng+OS6+1DEJsf?=
 =?us-ascii?Q?o6qEXLM0UEp/W70oKX6FNW7cjc2qcuLu9Uneu1FVhslcBIULRZh6H2m4Cnl+?=
 =?us-ascii?Q?5rxKeCQ7FVjMk/MxMnJyx94LhlBYN5uZNP4p5w8dt7P9Q7+Ro2576V+18daD?=
 =?us-ascii?Q?+mCJcycDy2vC2SQoqxsdJg6xRRSGD8RfAacVo8WCq1ekfjrsMcrEImTaHjFw?=
 =?us-ascii?Q?GyIgGFxHYW7Kx2F6l3RuijEGQ1L+Qha46g5dfwmZFOiEUF8+AVmAx0kzWGKK?=
 =?us-ascii?Q?GqKNnT6754rhlp6pcjz9BCPN2SmpIVTq5QK3vkJMBJEhy2H1HRrGY+bQDOgo?=
 =?us-ascii?Q?Gg/06chjwZiuO5JBobXRKWVbWBsE6Uayuug9UYJFTrHQ6kAnIC2oNKKeHl4P?=
 =?us-ascii?Q?1KVekh4tgozMj6jjGFmCLa8mngS9tZZ3yaiIq40cPG1vh3dxsE+hWxjqeGUB?=
 =?us-ascii?Q?Yos440OAdWu1s4lDeCINYvp++8pMw6TTy6j8dQnL+l5gDqrTy6lpKzO6fw8Q?=
 =?us-ascii?Q?Bx+2aeUDKY2iW7O1GDH3kLY7QGdGeYzrC5eGCiBgboi3fO+0YOSq2x5wbb7W?=
 =?us-ascii?Q?E4O2XKnnNJxp9x3jUwQeIFHa8pFXikB+ZwgHd44mMdvcdveC7gG0kyv1X7qH?=
 =?us-ascii?Q?18lCAP4A3AXk69nzx1OqAYjObz1uGDKfLiXZ2bl959HTLs7ic1Jy2SnHcrPt?=
 =?us-ascii?Q?+WDxF24+QcifDOMyDj9qUK+di7eYhpiHLk4wJlj9yeYYZRgcuD87SZ1Q2to1?=
 =?us-ascii?Q?jfg0mdXAJCL+s8xiIW3SIdGqI1UPlzqmMXH/0nNfdYeK//5LEZCpSNQBfjTe?=
 =?us-ascii?Q?iw+SNc3ASXj7GuBzC53dIkJFCZMDMBg3YmaBqwxKqt5gujfqFXWcuM53Xk79?=
 =?us-ascii?Q?N2RVxb/phIeBP3x9oyogLs6qs4JNErC0eckOQJ+fQBPKkyDlmEV04yx/3EqW?=
 =?us-ascii?Q?zYOn5xmM4ouUiVk3eAE1c/TNFbefdgEDVv19rb9ptun11xvyhJVAAQ9OF9u8?=
 =?us-ascii?Q?6A5eL1densEYa8v0FTlCZS5oxA8GwEpG5XybcatUC937hkaWCpDKOrrOg1Oz?=
 =?us-ascii?Q?p5OURhCD3GqnqwrJF4oQjiqSSI8gSFLc/C0SHJAmynm/Q53sw7rn5IFkFGjV?=
 =?us-ascii?Q?h8x1IRFm7v9YSF567Cz6Z3poIBP0t3TjNTrX6sruk55476flYbnZmA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 306207e2-580f-428c-8143-08da0afa424f
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 05:18:39.8685
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kK3rcoL8bYYGWEnwgbwcEL9aN5+zOUv6SyeOxwxTZ6Wd4hK7CqRId/TqtSq2HeMwzOv/NVIGFWXXZZXu1MdGdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5537
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10292 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 phishscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203210033
X-Proofpoint-GUID: T1yhU5bpE6x_NIgy2Dplkv11NFsI-IfR
X-Proofpoint-ORIG-GUID: T1yhU5bpE6x_NIgy2Dplkv11NFsI-IfR
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit also prints inode fields with invalid values instead of printing
addresses of inode and buffer instances.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Suggested-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode_item_recover.c | 52 ++++++++++++++-------------------
 1 file changed, 22 insertions(+), 30 deletions(-)

diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index 44b90614859e..96b222e18b0f 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -324,13 +324,12 @@ xlog_recover_inode_commit_pass2(
 	if (unlikely(S_ISREG(ldip->di_mode))) {
 		if ((ldip->di_format != XFS_DINODE_FMT_EXTENTS) &&
 		    (ldip->di_format != XFS_DINODE_FMT_BTREE)) {
-			XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(3)",
-					 XFS_ERRLEVEL_LOW, mp, ldip,
-					 sizeof(*ldip));
+			XFS_CORRUPTION_ERROR(
+				"Bad log dinode data fork format for regular file",
+				XFS_ERRLEVEL_LOW, mp, ldip, sizeof(*ldip));
 			xfs_alert(mp,
-		"%s: Bad regular inode log record, rec ptr "PTR_FMT", "
-		"ino ptr = "PTR_FMT", ino bp = "PTR_FMT", ino %Ld",
-				__func__, item, dip, bp, in_f->ilf_ino);
+				"Bad inode 0x%llx, data fork format 0x%x",
+				in_f->ilf_ino, ldip->di_format);
 			error = -EFSCORRUPTED;
 			goto out_release;
 		}
@@ -338,49 +337,42 @@ xlog_recover_inode_commit_pass2(
 		if ((ldip->di_format != XFS_DINODE_FMT_EXTENTS) &&
 		    (ldip->di_format != XFS_DINODE_FMT_BTREE) &&
 		    (ldip->di_format != XFS_DINODE_FMT_LOCAL)) {
-			XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(4)",
-					     XFS_ERRLEVEL_LOW, mp, ldip,
-					     sizeof(*ldip));
+			XFS_CORRUPTION_ERROR(
+				"Bad log dinode data fork format for directory",
+				XFS_ERRLEVEL_LOW, mp, ldip, sizeof(*ldip));
 			xfs_alert(mp,
-		"%s: Bad dir inode log record, rec ptr "PTR_FMT", "
-		"ino ptr = "PTR_FMT", ino bp = "PTR_FMT", ino %Ld",
-				__func__, item, dip, bp, in_f->ilf_ino);
+				"Bad inode 0x%llx, data fork format 0x%x",
+				in_f->ilf_ino, ldip->di_format);
 			error = -EFSCORRUPTED;
 			goto out_release;
 		}
 	}
 	if (unlikely(ldip->di_nextents + ldip->di_anextents > ldip->di_nblocks)){
-		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(5)",
-				     XFS_ERRLEVEL_LOW, mp, ldip,
-				     sizeof(*ldip));
+		XFS_CORRUPTION_ERROR("Bad log dinode extent counts",
+				XFS_ERRLEVEL_LOW, mp, ldip, sizeof(*ldip));
 		xfs_alert(mp,
-	"%s: Bad inode log record, rec ptr "PTR_FMT", dino ptr "PTR_FMT", "
-	"dino bp "PTR_FMT", ino %Ld, total extents = %d, nblocks = %Ld",
-			__func__, item, dip, bp, in_f->ilf_ino,
-			ldip->di_nextents + ldip->di_anextents,
+			"Bad inode 0x%llx, nextents 0x%x, anextents 0x%x, nblocks 0x%llx",
+			in_f->ilf_ino, ldip->di_nextents, ldip->di_anextents,
 			ldip->di_nblocks);
 		error = -EFSCORRUPTED;
 		goto out_release;
 	}
 	if (unlikely(ldip->di_forkoff > mp->m_sb.sb_inodesize)) {
-		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(6)",
-				     XFS_ERRLEVEL_LOW, mp, ldip,
-				     sizeof(*ldip));
+		XFS_CORRUPTION_ERROR("Bad log dinode fork offset",
+				XFS_ERRLEVEL_LOW, mp, ldip, sizeof(*ldip));
 		xfs_alert(mp,
-	"%s: Bad inode log record, rec ptr "PTR_FMT", dino ptr "PTR_FMT", "
-	"dino bp "PTR_FMT", ino %Ld, forkoff 0x%x", __func__,
-			item, dip, bp, in_f->ilf_ino, ldip->di_forkoff);
+			"Bad inode 0x%llx, di_forkoff 0x%x",
+			in_f->ilf_ino, ldip->di_forkoff);
 		error = -EFSCORRUPTED;
 		goto out_release;
 	}
 	isize = xfs_log_dinode_size(mp);
 	if (unlikely(item->ri_buf[1].i_len > isize)) {
-		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(7)",
-				     XFS_ERRLEVEL_LOW, mp, ldip,
-				     sizeof(*ldip));
+		XFS_CORRUPTION_ERROR("Bad log dinode size", XFS_ERRLEVEL_LOW,
+				     mp, ldip, sizeof(*ldip));
 		xfs_alert(mp,
-			"%s: Bad inode log record length %d, rec ptr "PTR_FMT,
-			__func__, item->ri_buf[1].i_len, item);
+			"Bad inode 0x%llx log dinode size 0x%x",
+			in_f->ilf_ino, item->ri_buf[1].i_len);
 		error = -EFSCORRUPTED;
 		goto out_release;
 	}
-- 
2.30.2

