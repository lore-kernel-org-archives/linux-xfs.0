Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A43FC6FD19
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Mar 2023 22:38:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbjCHWin (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Mar 2023 17:38:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbjCHWih (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Mar 2023 17:38:37 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2602C29429
        for <linux-xfs@vger.kernel.org>; Wed,  8 Mar 2023 14:38:29 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 328JxuSh028471
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:38:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=l7DL2VDUVdmbsXooSJJPToMM44GocX1HAJKrS546fW8=;
 b=r3Z5HDvTwxHJ1Zhj+UdIgoWh+5hNI5rhT8EamNJ78GDFlHH1GD5W7c70H6ol+r5xKxwA
 k2ofmzyTJdOCFOPf9NWvUua6OK/bgjk6m8YQr5wxGdHZjzCgA8tTprVdl3fx0bK5kgOd
 STLHlEjpWYtUSSQtY0CSBhHpxEQia1+VWc861hZhjkBvS3DnJ/ipaoa70UuBaBHT0rUv
 SdsH5l8ER8/ni+Zx8kfD5li88lsCkqb2tvAF79JHpaHn9uxZZyqO2Mzw/+hAlohfu3Ti
 MTvg554V1zW/V5hZrc2jpPzl3HUDzcSpyJC7eX4LZx8a53qKUGUPFBBruMsTTNXDAJFG 8g== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p418y1efa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:38:28 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 328MQ9bQ036420
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:38:27 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p6g464wd7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:38:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=An5lKCe1ewWD24c2wQrABCRZkKAsoigAageBgg4hc/wIO+Ni8vtj5jLDSfhfCo78HwbScTPjn89JBdnb/jsNsm8vw9iq3bo6lEyYNXNtp9lmJTJcsQ7yG20XTVliJuslwfBSo1djVMPm0/FjtyHIIo9xsQ6vGW76XumxOmn3KWsFqTsj8P+bUv8wlqloUqkKQcr01yvoi5XSqbH8HreesxztRET7kPz+YMkUVx4rSJ9jpM1xwM+gawtkCr04PMy/XEGNwwE+j8ciBd7aHVzXTyh8m0IZAcJAViOz1pQ5EMztWEDq7aGnFy/Q/cdrSqzRGddE3IQTb/1nrjjojXaRxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l7DL2VDUVdmbsXooSJJPToMM44GocX1HAJKrS546fW8=;
 b=TciXOh+MpULotYWwf9fruFlp4IXLtdiUZENRXJtg7rxyanHIutsxxx4c0Goi7bB8lSlPX/T0QzonFndTpl5+Mex+PeUkzxSs257xDdYyIapKmjEXxWus/ouV0WfAFbk4Qv9lTiUf4WzlwOXEgzhjjGEHxBIqAZAWeDwnAE4CTeCLfbQuRirSODPdMZmOBP8I8d4nZl3ow+JfCEyV3Y1wpxixA4gJ9q+nPPjU5jrbQXwZNEQT2m2gPT5qBhxtKvZhn/J8da1I/BoLcgPctAN0TovbnpTivP6WM/cmOXHVByxQWChzIkO6jdGLGfNzzJCvd3LjUAHYYiAf9CTNHDtQQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l7DL2VDUVdmbsXooSJJPToMM44GocX1HAJKrS546fW8=;
 b=f2TdN1Hwk7bgCSUN8ZFrpjitUcZvApNXgJzxF8BVtF9iUvQGqVTF9GM/3Citmp2QjoaHnyqYTVW1kDo4BEJ4rkOJ6dTB5tQg5aXSIxEf7i5umcp/fWzOWv0pKQWoMncKOsRsWIyJEztGNMn9rbTlTkv4S6SjwComecpjbzmf7B8=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SN7PR10MB7102.namprd10.prod.outlook.com (2603:10b6:806:348::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Wed, 8 Mar
 2023 22:38:26 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06%8]) with mapi id 15.20.6178.017; Wed, 8 Mar 2023
 22:38:25 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v10 16/32] xfs: add parent attributes to link
Date:   Wed,  8 Mar 2023 15:37:38 -0700
Message-Id: <20230308223754.1455051-17-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230308223754.1455051-1-allison.henderson@oracle.com>
References: <20230308223754.1455051-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0136.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::21) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|SN7PR10MB7102:EE_
X-MS-Office365-Filtering-Correlation-Id: cc94a595-6537-4b6a-cde5-08db2025d487
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PEwRgJ+ZKxDVqwEuYW/QyV8am/VrWbzQJvYdfRjbkf30NBmWsGhYv4maWt8pnYnJ89JYcigE80za4k5eEvAJWd6wgVLHIideGZl7Bn5TmZwqCzRAZX+2IPYomcKxPaPK69999jnn4JxJUwPxk2galUGVBCSTjtp/dFH1j77hdKUCdov09P2aUIJFEJ5N66PVBEp+EO78LHhfwAVxIsbfBf9s54PMmep/PQYdIuaQdFcd+HDHy2n3k9rDY1ju3ZO0salMUSaFeTM9ZzTI6d784qDvUeEqDc7ShyPncGsn2Dp+hR7Suu0/5B4NUpAC9fFXhthytU8s+BzkD5+QpIkMkesI0DLH7qOxAeS3qnuSgQy556JqGeopCpKbJ2HlC+SP1sckksMvnNqTgGgjr77XVkHZONgg7lwb6DyBT49vlp7Zr0t19UfV9YlBdFSnDpz1OWAli6BG8zgbM4eAqzyaY4mtptQyoRwj+MhRcfPoicgjUqKLvYCEE5QEItR4np8/WQEQ3MpLPkG9J48KxRDNyuYXNH24YpN6vGQTJ7UkGgXBXkdbbN2Ah7qqDsgnowK1TFez9rXKp9kAwSlTauBFr6POURLgivPGJm06rLFgnVAqbXP6DTimS8GuWEKA91lwgdDoGNZ3pniVjMrWaCNfBQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(366004)(346002)(136003)(396003)(451199018)(36756003)(6666004)(8936002)(6916009)(41300700001)(8676002)(66476007)(66946007)(5660300002)(66556008)(6506007)(2906002)(38100700002)(86362001)(6486002)(1076003)(6512007)(316002)(478600001)(83380400001)(9686003)(186003)(26005)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hEpbl1DoU8vc9M8dKI8FZM2+X/H0zQxLjPRwxmW/p/D+Ha1i8LGVuqftupcR?=
 =?us-ascii?Q?lSgMV3nMZfC9OLNQXbuVeWdJJsbJl3/vVFRt2uvcwUZmoEqAFWFxtddGeGas?=
 =?us-ascii?Q?78WHoefunZdH68XRBSi+QOEQZ3IbYgFfVuaMZSHE8kWUlhIX5gFbu5CIaIQD?=
 =?us-ascii?Q?iwwGUTbfTPy07Wo1t89rVG1is8e/QDWZq5V1LkSwSHANmVEvxGQ3uSiaWnfI?=
 =?us-ascii?Q?poK8alWsT1kf+elI/fppi/v0p2ZWPivZX501VUe5ybVZ52Ufsjet5lMP6hht?=
 =?us-ascii?Q?Fix6zyQeR8Q/H0R4GOfHDFEFw68QlQbxlUnx2Ll7MIeTzEZFBwVCrgnzRPwP?=
 =?us-ascii?Q?tTpWtPchsYZyk1BU9GXJua4TMV8I1dM8AgOlt3Daj/0So5vcYAM7sPtdRS6u?=
 =?us-ascii?Q?Z9KOuR6HTWcBab/szX2yv2oZIXKRAXDls0urzfSn411tWquXWqxl15hmK9S/?=
 =?us-ascii?Q?K2LFcmZ5jyjxnAPMaPlW2vN4yLeZPGcV3pGbBA5ITfa6YFKwDwrMWxSmcD7+?=
 =?us-ascii?Q?RGIRghshZIlG+71oPRbmz7GW60NqIhBXi7OvQMg1nnnFse80iPX11blfQV7L?=
 =?us-ascii?Q?USYJ84APMAwOXLXVIEo+JdMdDOjqRSSJZYD9M54goc0QDaijjbzq8QkmvecO?=
 =?us-ascii?Q?w3kLil1tJajY396Rn85piOCEPyT1pG4urHbfLw6AwoIjHrsSvg6ljEhn8MFZ?=
 =?us-ascii?Q?nGBPqVWHql0M7uvEfZnWjgEvTqx0vQkhLK46n0IVc7XkJeMLDjuXoIQnV5Bi?=
 =?us-ascii?Q?VjP5HDVL/Op16QiS5+mQkShbZs08KttTIt1YUYjFdNBUb8X+xJc0bfhaNoCO?=
 =?us-ascii?Q?bmecn/pCvrSoBuxOqSae/H7pmjHiiZWhWwJccjQWFrHRb5FLgxExgD8PnWom?=
 =?us-ascii?Q?YQUJWEYMUj9KtkPW7sS19MasxXAyF9J7p0HevNUggbTwGxyqWk0D7LXvu5sN?=
 =?us-ascii?Q?PZR7QM1xi5OiY++VBX31fYmvFXdAFeLGrwSdvv/lAyKH2nidfeBvnk1salB+?=
 =?us-ascii?Q?IgqKKTQTUXe8mMlwpvdHGKcGO3vjdFf5VX8Z8141DKymdGyt9yyrykVV95QG?=
 =?us-ascii?Q?dPXxfnCThCHnTSkHkxJAWofVhr4bfykSu6C6RrfUxXHTQO1sYEHHlU71TB8R?=
 =?us-ascii?Q?04XiQs7+qwouH0KshaT89mXtoom25jAcbASQVHl8X0Rdg27Fwzkp5vs00Umi?=
 =?us-ascii?Q?GZ0KERkIYz/j91IxhNtUvFdKfdAW0wfGz/8DdpMGwNXaQaQCnf+PHCLPcLFT?=
 =?us-ascii?Q?TowzD886O7skimiV0pEGqEvnhgWh9DjyfaZHVi9flUbvy/CsirMhXUf0yhWP?=
 =?us-ascii?Q?GP5GGdBB3hCcxEmscqLXaUCUgHagJkyiBE7Sc8fIYDDs2PTd5d/ua225+miN?=
 =?us-ascii?Q?H4Qf8RfPEhzV43DXxIou67U7VWJ1TmSgvVTlhdEXbZytxVpHiugXpZ+aAQfL?=
 =?us-ascii?Q?vjMQdyYh0cnOrlSibqaB+88biEvEi0XNIazSp7gcWiRzI/4dB5yma+FRU87i?=
 =?us-ascii?Q?/qYwzCQ6CQjHMRhVW1aDPrgAmotIuBJESobRrNjtWIit/dh49aYQtIXxajmm?=
 =?us-ascii?Q?mLGW7hJTTcral3ja6I5o7C+YQp5E4c3NaJy0PDwMNcTOEFGVYcPlw+0NwdX0?=
 =?us-ascii?Q?yA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: LUCW5VeU+42yjPHAoFrOzPQlm6h69hfTD0Iid8p+TRFEkd8wIGSai9CQ0kU43Q90cbUb9EYVUHJ9w6blhTDuJhIQQb71nrLB5Ed6HRTqFERzMCHbG3AxTHE2+uC+2az+Sk4go4EkuJ255Ue8PZJgur9hmMWEo+82JAQSjRfI+gJO4L4R0toZ9tWnhw8Xn/ueUlXZqdeE+bbhBRUlhmi2ToiTsBsIVNPmwO/ncQx70aExv05NBV+pwuMaPozP8ONKdZ6XNhllLBHIy53DmJeuE8uNll3ZMhUE/8jsU0PCCrsJ8WAU58UUypVnVaMUygfNbkq0W85qZlZs0MCdIfOkWlLOxcGoOlWJOvnrf8Avy4zSpZETgEAL1OBBsE/Q8uhaVUldrbPRjG3r+mmUkbdhB51ggTmMoS7SsyAFAbUr3F5r6HqYLrRx7f6WwD4C/pqqltrAFEFOx2LRBOrFou9RHvmaYRpKI6Sr4gMfBvn7JpKPfR3yfCvxvoEbG8qH6+WBhMj4EHFlcPbnKoxF6XPIdv5m+jtJ1Tjh4sjePn5lgZ4MuWTXbt62/KduVX1pAXzOtad/XZ62ODtXjNCVMFdHS1y6z5An21uGn/2vFa5PEPEY/BYIH1LBq+ME8HyEuqy3llSFzK4wEmV8IGwd0KgBZ/eoFG04ixYSWtCDEEsLfGPSFCM9bjkWMV/3qXsXwrkfVn/VsetsSm5UzW+Z5XcNQnlBFtcf3vyRiQT4wKQrhPAqN9cJ9uk5NI442JQf5lYsj5rDECBfdwhAi3NevpPDFw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc94a595-6537-4b6a-cde5-08db2025d487
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 22:38:25.6011
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DVyfE8gN64VUjwtsnKuhimDUjwL5en23zQTshQWOwLdBNL4Q7DmnnTGYFk5aaGj0ZzdyJPm0NrrPlh6PLLglA2LshtL6MSX5cSKW5xq3NzA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7102
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-08_15,2023-03-08_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303080190
X-Proofpoint-GUID: vO0rzVZ1FrzhNUc6tpWRebQbLm-YnNq9
X-Proofpoint-ORIG-GUID: vO0rzVZ1FrzhNUc6tpWRebQbLm-YnNq9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch modifies xfs_link to add a parent pointer to the inode.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_trans_space.h |  2 --
 fs/xfs/xfs_inode.c              | 60 +++++++++++++++++++++++++++++----
 2 files changed, 53 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
index 87b31c69a773..f72207923ec2 100644
--- a/fs/xfs/libxfs/xfs_trans_space.h
+++ b/fs/xfs/libxfs/xfs_trans_space.h
@@ -84,8 +84,6 @@
 	(2 * (mp)->m_alloc_maxlevels)
 #define	XFS_GROWFSRT_SPACE_RES(mp,b)	\
 	((b) + XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK))
-#define	XFS_LINK_SPACE_RES(mp,nl)	\
-	XFS_DIRENTER_SPACE_RES(mp,nl)
 #define	XFS_MKDIR_SPACE_RES(mp,nl)	\
 	(XFS_IALLOC_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl))
 #define	XFS_QM_DQALLOC_SPACE_RES(mp)	\
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index b63d42d2fb23..63d750e547c1 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1247,16 +1247,32 @@ xfs_create_tmpfile(
 	return error;
 }
 
+static unsigned int
+xfs_link_space_res(
+	struct xfs_mount	*mp,
+	unsigned int		namelen)
+{
+	unsigned int		ret;
+
+	ret = XFS_DIRENTER_SPACE_RES(mp, namelen);
+	if (xfs_has_parent(mp))
+		ret += xfs_pptr_calc_space_res(mp, namelen);
+
+	return ret;
+}
+
 int
 xfs_link(
-	xfs_inode_t		*tdp,
-	xfs_inode_t		*sip,
+	struct xfs_inode	*tdp,
+	struct xfs_inode	*sip,
 	struct xfs_name		*target_name)
 {
-	xfs_mount_t		*mp = tdp->i_mount;
-	xfs_trans_t		*tp;
+	struct xfs_mount	*mp = tdp->i_mount;
+	struct xfs_trans	*tp;
 	int			error, nospace_error = 0;
 	int			resblks;
+	xfs_dir2_dataptr_t	diroffset;
+	struct xfs_parent_defer	*parent = NULL;
 
 	trace_xfs_link(tdp, target_name);
 
@@ -1273,11 +1289,25 @@ xfs_link(
 	if (error)
 		goto std_return;
 
-	resblks = XFS_LINK_SPACE_RES(mp, target_name->len);
+	error = xfs_parent_start(mp, &parent);
+	if (error)
+		goto std_return;
+
+	resblks = xfs_link_space_res(mp, target_name->len);
 	error = xfs_trans_alloc_dir(tdp, &M_RES(mp)->tr_link, sip, &resblks,
 			&tp, &nospace_error);
 	if (error)
-		goto std_return;
+		goto out_parent;
+
+	/*
+	 * We don't allow reservationless or quotaless hardlinking when parent
+	 * pointers are enabled because we can't back out if the xattrs must
+	 * grow.
+	 */
+	if (parent && nospace_error) {
+		error = nospace_error;
+		goto error_return;
+	}
 
 	/*
 	 * If we are using project inheritance, we only allow hard link
@@ -1310,7 +1340,7 @@ xfs_link(
 	}
 
 	error = xfs_dir_createname(tp, tdp, target_name, sip->i_ino,
-				   resblks, NULL);
+				   resblks, &diroffset);
 	if (error)
 		goto error_return;
 	xfs_trans_ichgtime(tp, tdp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
@@ -1318,6 +1348,19 @@ xfs_link(
 
 	xfs_bumplink(tp, sip);
 
+	/*
+	 * If we have parent pointers, we now need to add the parent record to
+	 * the attribute fork of the inode. If this is the initial parent
+	 * attribute, we need to create it correctly, otherwise we can just add
+	 * the parent to the inode.
+	 */
+	if (parent) {
+		error = xfs_parent_defer_add(tp, parent, tdp, target_name,
+					     diroffset, sip);
+		if (error)
+			goto error_return;
+	}
+
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * link transaction goes to disk before returning to
@@ -1329,12 +1372,15 @@ xfs_link(
 	error = xfs_trans_commit(tp);
 	xfs_iunlock(tdp, XFS_ILOCK_EXCL);
 	xfs_iunlock(sip, XFS_ILOCK_EXCL);
+	xfs_parent_finish(mp, parent);
 	return error;
 
  error_return:
 	xfs_trans_cancel(tp);
 	xfs_iunlock(tdp, XFS_ILOCK_EXCL);
 	xfs_iunlock(sip, XFS_ILOCK_EXCL);
+ out_parent:
+	xfs_parent_finish(mp, parent);
  std_return:
 	if (error == -ENOSPC && nospace_error)
 		error = nospace_error;
-- 
2.25.1

