Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CA3EC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Dec 2021 08:47:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231845AbhLNIrK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Dec 2021 03:47:10 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:56490 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231902AbhLNIrK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Dec 2021 03:47:10 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BE7Av52004564;
        Tue, 14 Dec 2021 08:47:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=xAG1d8TRixnhdYnvd0aA5To97FQCtL8w9PrT5U7/Z2o=;
 b=pgD6ToGVTQV+V/NkOuSoERz21AvtIIAyLrHw9R6Ml7UnWjkfKy/UcNpbGNIBXchQedKG
 vKalE2l/IfSXweEa2uhUaCsOHO27dY7eTlPq55Tlt5lM7wZo7145c00zG0PhWhb1VEfv
 seFrIj7pcXhQ150zNouwTsNaq26qngLdUtthV+tonNIfwdBZr3zheyVksojdG61eX5jo
 xKG0NiTb+1vv9jkuokamH51MEAFBKIVG/jB/+n0eL0VcBFm4E01iT0w0xe72J1wSveoG
 pwJQedWO3ozapW6nwZ2J0mGrdyKZQDjDKcScEvRSL7qWo7+ljIZy5XVs19QY5lZZLstr 8A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cx3mru5vp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:47:07 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BE8fofJ104495;
        Tue, 14 Dec 2021 08:47:06 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by aserp3030.oracle.com with ESMTP id 3cvj1djqd7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:47:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DZ54EhY0v2ISevXfm/pmmY/QxdUAek9Piwf1+a1Wr6fGcbfHgF6wLKVBI3K+/wI0u/yvoGffB1LkiPlwq/ltuxE85fINLpYsCxs6xuFZtuJ9i0UirwslP5UTmI8tCjUOrw67vh6r600RtZOF51YAUVCsdYXB0iMBgz9N5PfNUDpsv1I18K9Q5MrdZvAX8uVY7XJJOY5Fw7ZrTZ5eTHpqtyzIhWimhbORjXIsRl9MJTgJVVE7V74H+AOEPEFf5g2xBgZq8dC9VlgcPIKexT1MkL/ToH/v2Kek/E2iL/RhzJvzi+okfBmmrvX9ZmWBrUmwHlQxelowDxJi8xDplF15/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xAG1d8TRixnhdYnvd0aA5To97FQCtL8w9PrT5U7/Z2o=;
 b=gyUF3NmLTjD3loxlN2ksQiuPwGIxft+AnQwBmJgkoK0mZgCBc2omTlyrftZ4flc5Lou/10enaGe1KSwENOuPXPi+doAwE2xTUfzZUlGVgw/xzl/y9D9FC0YTZ4rib6ZhTIUeiWG1mdTH3PFHylZDP8hw6ACpqUxsg4lBMA8PaxCzBSfaabXtYLJPugdsNxWD+XeM2IOdW0fzGwdoz3MNv5b5kdC+M1jA/wIlyKtvth55421c8ktZj/rkbWCz4SO02IIdTJ7Gtrfj88cMX3yj5zLc7/MrszQln17n1NzCvu0wRlS+AvbNakXnav9Mqa1q/oXRIbuegdTpx2u3Ofibpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xAG1d8TRixnhdYnvd0aA5To97FQCtL8w9PrT5U7/Z2o=;
 b=jVfDIL59U/HZTLYcggXuus+f5BG7LojsA21yHaUm2PLm9fT07ypbzlsMh2OxKklYBbnRKnBqYADUhsfJ0+RLiSosbwMd1A4iywxUEJjxsbpgB6fDkhFYhgZOGEM/1snCaosLdIxBvP3L2CZ02O8IkWwBygUZunhV57XsN/2pqZk=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB3054.namprd10.prod.outlook.com (2603:10b6:805:d1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Tue, 14 Dec
 2021 08:47:04 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d%6]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 08:47:04 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V4 04/16] xfs: Introduce xfs_dfork_nextents() helper
Date:   Tue, 14 Dec 2021 14:15:07 +0530
Message-Id: <20211214084519.759272-5-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211214084519.759272-1-chandan.babu@oracle.com>
References: <20211214084519.759272-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR0101CA0052.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::14) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a0e49236-85f7-482f-4caf-08d9bede4d7f
X-MS-TrafficTypeDiagnostic: SN6PR10MB3054:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB305413481D4F1193CAEF2CD9F6759@SN6PR10MB3054.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:265;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KpA6U8U2uEGKkJ5j2VfUPMHo8N4V0ug3u8kQOhODpN3+t/Jf0qHGHFyo9MxgazFafZPSGzpnQBbnqir2oMhdVjYGopGEB+Kr201tqXqc2ffdzbnbJrLXExJ0zU3qhwFLbPdQsn2/mix9XQWLU2wj0SY5YpTOdqKYpgWzsemoleKy34aPdAQgfMkfZF1IPDD8ZG3B2UqAbQfdMDyNyLQwXylv4dakjq1VM96H9kprRlzCvvaCz3y1Uoli2Y06KlI6hl3evnARGrqvH64V/V5D3nE9/MBR0GsazfJkPmNOnVPoBW9iRp5Xx9Qfg0AYItkSywp8TuzFm1X/l9u7CoXTjyST1rRc9vz9M7hqU81cv1i6WZ78UcUVaeqM+hKfB4uVFo9UMnwofwI13XukUii1/sm8WzCidxd5GVufGenLserYZNZaAh70iKPqdhmJYSDNzcy0WkOSy0lXbRSi6zk3f4zWsQ1VtXHVPfBiYBgh4NKu6T4qZ8ss0OF/o0rDx4l9SkW8lvBs0C5ek9V35oa6mgBt6LCf8ZbvY0PoXVdK5+3lEPP3JJgNFP/V1sSk4JDhRrjj2/M30k4+3mOgPQIugVk2KjfIY3HBeREAVLzoHmGZqU+TwgDPebklOUXuNJcnBb/fOf0vjAweeselMrsTsR4lasakbk2bfLN73u4ZpstlMyqHpL56Bm7sdJRFJZkp9f/SYR7SFrITmeCMrD7a9Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(8676002)(66556008)(66476007)(6486002)(316002)(6916009)(6512007)(186003)(5660300002)(2906002)(36756003)(83380400001)(26005)(66946007)(2616005)(1076003)(4326008)(6506007)(508600001)(52116002)(38350700002)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kATbLE9Qr25z//gE5LWJH3z/UQu0jRimML0WhGf2xRPpqLCVJZ4HPz4y6X5w?=
 =?us-ascii?Q?7VTHlgx79r1U691ppkhqa83bfxW0ySuPrh9sPJkfflr36omtPKy7Puj1pKUi?=
 =?us-ascii?Q?YMKx0JyIbZdmwHVIMbc2FPBfTzf7m+XNxJZ3QitwBUKjUb96AJ8sb1Rj3uCL?=
 =?us-ascii?Q?5+fr+IzZ44htKeZzkw0oBrDliQu7QUKq7RoSH8tgnL4kJKzMCTVg2BzsQo6O?=
 =?us-ascii?Q?d2qwqg7SWGe5OTbZI23C3yrfmI9vjvWwdEGSqfnHMt3VbT9AexoEtDlR1Ifz?=
 =?us-ascii?Q?Mui/E/I4Irz/l40vki68A2LAIfweQnh6d3C96Hj6D+2A1usBOdjzB6XKPO+8?=
 =?us-ascii?Q?BFMQOedG46kEvOGIzVonc2dLNmZ5ZdK3zt1tsiRbQVebwqHYIkwMDUH5ZVVS?=
 =?us-ascii?Q?3sE+0WsVC1/PwRKgVVS/vlDRJy+9f5fiBQyBlu34L2pnhus3fmaK4+Fih8RK?=
 =?us-ascii?Q?GchVcKmi2Nci3uJOpaBROB5sYI8MheJBsZacbfYwfaA4dU0EgAm7T2y6bMqx?=
 =?us-ascii?Q?8hcProRxffooUjUGBt8W5J85TYXIy78jwU5AQx3S2BsxMUNYf5iyL+9hgAIr?=
 =?us-ascii?Q?5gZGCLzShNsU0GBc5jYD2yZJDEo4/+/OHM1Q6HWEuk4n9LH+to8mP9oh6HS0?=
 =?us-ascii?Q?vz8An98DhI+8n7UHpUz4eT/EmXnR7d+r0lC0qDp++0EYJ0KtfbLZ2tNQyYH+?=
 =?us-ascii?Q?pDEsjrEiaMTv9svUfojbijqyR5WKgMpMsTu+P7YBXsuqLpDpJuyrZbZ+G7vf?=
 =?us-ascii?Q?j2av60EHN3KkDKLohTNOBi82QT43EdF7EGYuYXKoXICQpjfnlaKHfUrBAPny?=
 =?us-ascii?Q?8w+nYG6RFvBUs4Mc7M4MdIiMa1TsLTztsYzChRE4RGIfcBuc2gNcYJuttUNR?=
 =?us-ascii?Q?YocwF/TfWOugP/p4gMRen82Qudkf6UsfdV7F1L/NTtJ9N013sBnHION18I6q?=
 =?us-ascii?Q?ZxpFEti//Z0A+8sGZvj3UxisnS6Ilkpidy7qL1f79d/ztAAWJrXFPUwlhLWr?=
 =?us-ascii?Q?iJ4lhcjyrUruT4TrZgt1/+33JGikN1vsKfvQg7xe0QX4djV35TZ+xiWQnR5w?=
 =?us-ascii?Q?RXj6cfYAAgfZjUmS2H6CWV4j+lmAgEi7dl7fpOXbqBjwG0c7gf9llHTUgsxB?=
 =?us-ascii?Q?pj5JoB/d4z0S54fmOfEx61XGZVWqf0BxV69t3e6aDHzAF4cvM4rMafXXcgrB?=
 =?us-ascii?Q?n5FzBFx8vpSMALU4Ocj5RZ6N72rJyHVzv12KhKimfTDdiaVDgWGDUER5Wv1m?=
 =?us-ascii?Q?9M/sEJs1AQ0zhwQsokuZyHSW7m0XkBcCRoEeFMygECiXUrViGRq7uU9VWoa5?=
 =?us-ascii?Q?XhJtEnz0cQ37ewK7sVmEbYNKZuHnnN0AfhdE8ZFzZKzdbNHBE9s7ojz/Yfxm?=
 =?us-ascii?Q?HEfsVWMLTTklYuVuKZ9zEAaixq0YGRmMLanYo7atkeZ2cK5ibjbM6oZaiC3v?=
 =?us-ascii?Q?0uVN+g4bPe5S/HQmXcTLWbFq3wx8vmeTMlyXwmSl9jnwizP5FOizZqiwu9DN?=
 =?us-ascii?Q?lc3BPlHPCLxVPPJBkiQlG2i0UCCuZBaMn8IAPwWfCmKYvaBElVBVTikXkaDw?=
 =?us-ascii?Q?TJJd4kDVknqUFgNeC9dWd8bu0DC77ZZj1GzrcJm5WGTFy9ncmXrH6YTQz+96?=
 =?us-ascii?Q?VQgwRHBcK4k+GpB/Wr9Qlbk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0e49236-85f7-482f-4caf-08d9bede4d7f
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 08:47:04.5266
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XN7JrGIZwOOIVFQlY70Nx0YY34But+Sj+JYXeHOAuEM97W/dsNfBuCxbYw0TOFRJSbAH0xLWmAOZMXudXmXXdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB3054
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10197 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112140049
X-Proofpoint-ORIG-GUID: nlBs-sVEA0MaPs2DUmudMY5gBJY8BYs9
X-Proofpoint-GUID: nlBs-sVEA0MaPs2DUmudMY5gBJY8BYs9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit replaces the macro XFS_DFORK_NEXTENTS() with the helper function
xfs_dfork_nextents(). As of this commit, xfs_dfork_nextents() returns the same
value as XFS_DFORK_NEXTENTS(). A future commit which extends inode's extent
counter fields will add more logic to this helper.

This commit also replaces direct accesses to xfs_dinode->di_[a]nextents
with calls to xfs_dfork_nextents().

No functional changes have been made.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h     |  4 ----
 fs/xfs/libxfs/xfs_inode_buf.c  | 16 +++++++++++-----
 fs/xfs/libxfs/xfs_inode_fork.c | 10 ++++++----
 fs/xfs/libxfs/xfs_inode_fork.h | 32 ++++++++++++++++++++++++++++++++
 fs/xfs/scrub/inode.c           | 18 ++++++++++--------
 5 files changed, 59 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index d75e5b16da7e..e5654b578ec0 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -925,10 +925,6 @@ enum xfs_dinode_fmt {
 	((w) == XFS_DATA_FORK ? \
 		(dip)->di_format : \
 		(dip)->di_aformat)
-#define XFS_DFORK_NEXTENTS(dip,w) \
-	((w) == XFS_DATA_FORK ? \
-		be32_to_cpu((dip)->di_nextents) : \
-		be16_to_cpu((dip)->di_anextents))
 
 /*
  * For block and character special files the 32bit dev_t is stored at the
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 5c95a5428fc7..860d32816909 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -336,9 +336,11 @@ xfs_dinode_verify_fork(
 	struct xfs_mount	*mp,
 	int			whichfork)
 {
-	xfs_extnum_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
+	xfs_extnum_t		di_nextents;
 	xfs_extnum_t		max_extents;
 
+	di_nextents = xfs_dfork_nextents(dip, whichfork);
+
 	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
 	case XFS_DINODE_FMT_LOCAL:
 		/*
@@ -405,6 +407,8 @@ xfs_dinode_verify(
 	uint16_t		flags;
 	uint64_t		flags2;
 	uint64_t		di_size;
+	xfs_extnum_t            nextents;
+	xfs_filblks_t		nblocks;
 
 	if (dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC))
 		return __this_address;
@@ -435,10 +439,12 @@ xfs_dinode_verify(
 	if ((S_ISLNK(mode) || S_ISDIR(mode)) && di_size == 0)
 		return __this_address;
 
+	nextents = xfs_dfork_data_extents(dip);
+	nextents += xfs_dfork_attr_extents(dip);
+	nblocks = be64_to_cpu(dip->di_nblocks);
+
 	/* Fork checks carried over from xfs_iformat_fork */
-	if (mode &&
-	    be32_to_cpu(dip->di_nextents) + be16_to_cpu(dip->di_anextents) >
-			be64_to_cpu(dip->di_nblocks))
+	if (mode && nextents > nblocks)
 		return __this_address;
 
 	if (mode && XFS_DFORK_BOFF(dip) > mp->m_sb.sb_inodesize)
@@ -495,7 +501,7 @@ xfs_dinode_verify(
 		default:
 			return __this_address;
 		}
-		if (dip->di_anextents)
+		if (xfs_dfork_attr_extents(dip))
 			return __this_address;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index a17c4d87520a..829739e249b6 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -105,7 +105,7 @@ xfs_iformat_extents(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	int			state = xfs_bmap_fork_to_state(whichfork);
-	xfs_extnum_t		nex = XFS_DFORK_NEXTENTS(dip, whichfork);
+	xfs_extnum_t		nex = xfs_dfork_nextents(dip, whichfork);
 	int			size = nex * sizeof(xfs_bmbt_rec_t);
 	struct xfs_iext_cursor	icur;
 	struct xfs_bmbt_rec	*dp;
@@ -230,7 +230,7 @@ xfs_iformat_data_fork(
 	 * depend on it.
 	 */
 	ip->i_df.if_format = dip->di_format;
-	ip->i_df.if_nextents = be32_to_cpu(dip->di_nextents);
+	ip->i_df.if_nextents = xfs_dfork_data_extents(dip);
 
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFIFO:
@@ -295,14 +295,16 @@ xfs_iformat_attr_fork(
 	struct xfs_inode	*ip,
 	struct xfs_dinode	*dip)
 {
+	xfs_extnum_t		naextents;
 	int			error = 0;
 
+	naextents = xfs_dfork_attr_extents(dip);
+
 	/*
 	 * Initialize the extent count early, as the per-format routines may
 	 * depend on it.
 	 */
-	ip->i_afp = xfs_ifork_alloc(dip->di_aformat,
-				be16_to_cpu(dip->di_anextents));
+	ip->i_afp = xfs_ifork_alloc(dip->di_aformat, naextents);
 
 	switch (ip->i_afp->if_format) {
 	case XFS_DINODE_FMT_LOCAL:
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 2605f7ff8fc1..7ed2ecb51bca 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -141,6 +141,38 @@ static inline xfs_extnum_t xfs_iext_max_nextents(int whichfork)
 	return MAXAEXTNUM;
 }
 
+static inline xfs_extnum_t
+xfs_dfork_data_extents(
+	struct xfs_dinode	*dip)
+{
+	return be32_to_cpu(dip->di_nextents);
+}
+
+static inline xfs_extnum_t
+xfs_dfork_attr_extents(
+	struct xfs_dinode	*dip)
+{
+	return be16_to_cpu(dip->di_anextents);
+}
+
+static inline xfs_extnum_t
+xfs_dfork_nextents(
+	struct xfs_dinode	*dip,
+	int			whichfork)
+{
+	switch (whichfork) {
+	case XFS_DATA_FORK:
+		return xfs_dfork_data_extents(dip);
+	case XFS_ATTR_FORK:
+		return xfs_dfork_attr_extents(dip);
+	default:
+		ASSERT(0);
+		break;
+	}
+
+	return 0;
+}
+
 struct xfs_ifork *xfs_ifork_alloc(enum xfs_dinode_fmt format,
 				xfs_extnum_t nextents);
 struct xfs_ifork *xfs_iext_state_to_fork(struct xfs_inode *ip, int state);
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index aefdf8fe1372..a601b04fe408 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -233,6 +233,7 @@ xchk_dinode(
 	unsigned long long	isize;
 	uint64_t		flags2;
 	xfs_extnum_t		nextents;
+	xfs_extnum_t		naextents;
 	uint16_t		flags;
 	uint16_t		mode;
 
@@ -377,7 +378,7 @@ xchk_dinode(
 	xchk_inode_extsize(sc, dip, ino, mode, flags);
 
 	/* di_nextents */
-	nextents = be32_to_cpu(dip->di_nextents);
+	nextents = xfs_dfork_data_extents(dip);
 	fork_recs =  XFS_DFORK_DSIZE(dip, mp) / sizeof(struct xfs_bmbt_rec);
 	switch (dip->di_format) {
 	case XFS_DINODE_FMT_EXTENTS:
@@ -394,10 +395,12 @@ xchk_dinode(
 		break;
 	}
 
+	naextents = xfs_dfork_attr_extents(dip);
+
 	/* di_forkoff */
 	if (XFS_DFORK_APTR(dip) >= (char *)dip + mp->m_sb.sb_inodesize)
 		xchk_ino_set_corrupt(sc, ino);
-	if (dip->di_anextents != 0 && dip->di_forkoff == 0)
+	if (naextents != 0 && dip->di_forkoff == 0)
 		xchk_ino_set_corrupt(sc, ino);
 	if (dip->di_forkoff == 0 && dip->di_aformat != XFS_DINODE_FMT_EXTENTS)
 		xchk_ino_set_corrupt(sc, ino);
@@ -409,19 +412,18 @@ xchk_dinode(
 		xchk_ino_set_corrupt(sc, ino);
 
 	/* di_anextents */
-	nextents = be16_to_cpu(dip->di_anextents);
 	fork_recs =  XFS_DFORK_ASIZE(dip, mp) / sizeof(struct xfs_bmbt_rec);
 	switch (dip->di_aformat) {
 	case XFS_DINODE_FMT_EXTENTS:
-		if (nextents > fork_recs)
+		if (naextents > fork_recs)
 			xchk_ino_set_corrupt(sc, ino);
 		break;
 	case XFS_DINODE_FMT_BTREE:
-		if (nextents <= fork_recs)
+		if (naextents <= fork_recs)
 			xchk_ino_set_corrupt(sc, ino);
 		break;
 	default:
-		if (nextents != 0)
+		if (naextents != 0)
 			xchk_ino_set_corrupt(sc, ino);
 	}
 
@@ -499,14 +501,14 @@ xchk_inode_xref_bmap(
 			&nextents, &count);
 	if (!xchk_should_check_xref(sc, &error, NULL))
 		return;
-	if (nextents < be32_to_cpu(dip->di_nextents))
+	if (nextents < xfs_dfork_data_extents(dip))
 		xchk_ino_xref_set_corrupt(sc, sc->ip->i_ino);
 
 	error = xfs_bmap_count_blocks(sc->tp, sc->ip, XFS_ATTR_FORK,
 			&nextents, &acount);
 	if (!xchk_should_check_xref(sc, &error, NULL))
 		return;
-	if (nextents != be16_to_cpu(dip->di_anextents))
+	if (nextents != xfs_dfork_attr_extents(dip))
 		xchk_ino_xref_set_corrupt(sc, sc->ip->i_ino);
 
 	/* Check nblocks against the inode. */
-- 
2.30.2

