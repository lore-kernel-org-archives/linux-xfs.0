Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EDD9C4332F
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Dec 2022 10:03:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbiLRKDg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 18 Dec 2022 05:03:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbiLRKDd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Dec 2022 05:03:33 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADEF25F79
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 02:03:31 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BI5KweD015523
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=H3b8ZQhjDsQS/OiU2IYq+79S7oUoBWJn26hBtJprubE=;
 b=jshyaDu2LUkpJCUHzjYWGs4nARupubvzBSe+5rYqvkaGLQ4nq6xe9bR5v4mswhFTCIKF
 rK4xABKwn5UwMOTFdNS6wBaXfoq76PpgwnNC/cfQwsAjvZF1/JollsTLPJq/StNbQyji
 5Lqum6z2ybuaf7mLrMK/V1gB9SUzsF4850dbsA3P18oIoKg8LZ+xn9C1efs/TG7FXMMs
 Kyd6CJNqbGhnFu+7eJq9eDlZg3+ozwBcK7KqvcEVGymwxJo+TYNelHHQWKyeieFa78CV
 U7kUakK6gfkWKVKiy+r7zYVirbAq+2cPneem3rW5MoR3vMFkzrKtOBYUQSR9ctGVJjCn Lg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mh6tss9my-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:30 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BI8B7Eq006852
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:30 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mh478n3tp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kho00Ttoo2r9TW7+f5XSS8udp27TsDhOYsdklT/iGL4hwoIgRzUecyZW6rKUADLBRCUZvg4rCDhkBYaYxwivfY8qI46oo55Bc6zEBijNEm3MADBmOpy9bEh3qcNmGg6tuoEK7Z//xhNyUNZY+xy/zWAU7UHhgkd24+OgVE4EdUeCoXatR0BHetIyvk6wZAf8c2OPo2yOyMGFKXnxexomp6/L2CG3UgdjWhsAdrXaJuteMga4bBOuUPsGISByLDsE4wpWpwcu4pTNCiScXG89mLCjPQWhN7daf1hOw8d7EcnHnrtX8AsBQhuXfYmdlQu3XzEWfEbeMT31GnSxKAQNIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H3b8ZQhjDsQS/OiU2IYq+79S7oUoBWJn26hBtJprubE=;
 b=Ze5h0tZ3RsNSfWU6fO/QVHiEBxoQIlU0AMX1qkbRwiap7dspfRmrjBNqnxgLr6IFJHM7T0s0fkWpqyOnBT3ylFXL3lIJGIkgviSed+1lnbtgkvr+PAnUl0M2N3mvKm/81EBByRWW4BnoE7ODa7o18i8PzQt3ToyI3luwcGs3XSX2pB5+qrpibX22Ac13eNn6uzodqDkgVhDMHWnP2uXJ7zZnRdqb8U0e8zGLkASZF5c7Ly9AlmdDWyye2MxwqZh2rWgP9PClXD/hr6nIMGg3kDg7WXnlGTqVG55KFRR+ZTBL9A57wNhcmVWa3lXtJk57MNnL0Jo2eogylUSBrrKK3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H3b8ZQhjDsQS/OiU2IYq+79S7oUoBWJn26hBtJprubE=;
 b=ycudqvo88eAV7U2qnkupjg5gZycpBxOjoPGWydrh+VEVSwsYG23wgnfFW1gH8g1lRHyN1B6EtevFLurI7RE1JORECzA+IGS2sM+RWX3TStbQUbvIv+RuHDZYLq0MLCBcZZ/rhPvC15YYz9/fj/vC5ZiPVjI0IwYhg0qTy1RTB64=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB4536.namprd10.prod.outlook.com (2603:10b6:510:40::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Sun, 18 Dec
 2022 10:03:28 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c%4]) with mapi id 15.20.5924.016; Sun, 18 Dec 2022
 10:03:28 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v7 13/27] xfs: Add xfs_verify_pptr
Date:   Sun, 18 Dec 2022 03:02:52 -0700
Message-Id: <20221218100306.76408-14-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221218100306.76408-1-allison.henderson@oracle.com>
References: <20221218100306.76408-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0050.prod.exchangelabs.com (2603:10b6:a03:94::27)
 To BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB4536:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ca719ad-d719-4e6d-7e50-08dae0df1c54
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ByXfqUPqko7C9jnYyfwq665rW0x8lvArJGBvms2QKbIYpo72O9mdZSYrstNHAxtP72D4KbyD7bKjswfVBmW8O7TNA1RvZgkOfD+h8Rk5U+k9wXk7n6RKUOf+b7jUA0zhqzIBHsxFx3gr+ii6Klt4AB31iFIloUkUE4TZqEuI6Yiqo3OwuqtvGz0RahS04HWHFSxSMS0eWN064rji9o3hKCxf8agi6yQtn4EpY0VMYRulhWVSV3/2jFUWAfcAcIaLrvc/54fOeRHbQnfs586NvcA4F3mBiHsNrX2jKPBqYK7MlxcOmkXnHpRAwx7aNYnYYYRTHQAb0wT48Ce5io90oameqWxXwmryc0a7pMl3ibFMeQD6jH0/km5If3RtTrsY5FWuzM9K62caPN3patsW0M2vxg15knlHT8x1ZgTb2Cd2tDD1z8SVLa9Aqawmt0zJF5gmZI/j0L5dpT030K78DDYN+ktJ3/+Uaru8QWdw/dOVUUunkWkZ/Zquv0T8iEc4pqXg0njDEfHuuTDDBtD4D3xTnJroC8aKR/aIGd//5JUXoUnbVqfn4Eqx8Dcmj/A3fhNpaVlOOXNaMagzAO+BqfNNpHushGMEuA3+G4l9TEg252fsThezAnCUb0HRQcKkLk/GgK61681INqszqd2wUQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(136003)(346002)(366004)(376002)(451199015)(83380400001)(38100700002)(86362001)(66476007)(2906002)(8676002)(66556008)(5660300002)(66946007)(8936002)(41300700001)(1076003)(9686003)(26005)(186003)(6512007)(6506007)(6666004)(2616005)(6916009)(316002)(478600001)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KzrzG8cHGYog+Lo5q3MCSToAgWYMGBw6UGIfcjEKUkxfAiCWQtrT/BApwQFi?=
 =?us-ascii?Q?fjASBNGIdGx9SX5iONIvVkjUyEEYvHkyYZjkaBHWV6A29hf3YbojYhFse9ps?=
 =?us-ascii?Q?S/k/F0c0AHp6G5cB6MrXin8rGruLdSR/AJN/KuCchllSdno1qxE1umSS+su/?=
 =?us-ascii?Q?HdhE/FSd3nCs7ITxczITlN1plPykCbtCHnEKupQj6IIAkM8C6fMqJwE2b87a?=
 =?us-ascii?Q?vPvAlee9ogXSCXtL7F2IyOA9kZdMpUEDOXRgRCElq+LIj5Crgq+YN7js6iYx?=
 =?us-ascii?Q?7w047aj3RRbVyNwyqzalsfuuuTJwJlgiEGdxvmpStCre5B/EhVZjUlbVn+od?=
 =?us-ascii?Q?M4ZiP1Rosl1Imw7jg6RAtpCfhnpgUiPr6Hmfsxm0j0i/ZZKx1IbBHRvTngHx?=
 =?us-ascii?Q?usMOTtJzgstzpPBPYPxjgluIv2dHdMhapEdPh10/ZjDDySr2hX+OIcn5S9dP?=
 =?us-ascii?Q?Qy2i9XRF55TePrutDpAZUmBFOoaT30xKbwk2Wd+mGZ50LXoszVoceutd2a81?=
 =?us-ascii?Q?jm16UbIuBlzzqs/HqC2xEGnDP0TGQFHATFwC3eEB/uik+5QnA6sCqPh5WhrS?=
 =?us-ascii?Q?+WRn5vM5joyOzIu9fXQ0qQdafjm0Iozk8Dm8yKALCvgm/gq39uKKonYJ+ZH2?=
 =?us-ascii?Q?VumP57/aDOCX1S+s0rgD+BeSmm+HxTV0ByHNUKieVGcRdoISkwaER4VyPsy5?=
 =?us-ascii?Q?UxGqlV5/zkLwISOUT3cAHzkB9B0T49nPkm0BWNADtRdPmbjcaGHPypEYDGYz?=
 =?us-ascii?Q?ze+tf8XThPX513CYrZoPOF89H92go3j0QWkQ1EDCJSJghFidl/RVGj64LhKT?=
 =?us-ascii?Q?wa7KZ+BsEYD/Tahw7JoeaSHsuPsRibDHtGiRVorgtvJLp9jA9EmRNrdEvHnd?=
 =?us-ascii?Q?Isfv0CbMUrEHjtNjqXZmGF5gJGlWAHCJWOtFKFlp8Rls+GnIIjvQ+dDtYPyj?=
 =?us-ascii?Q?zAc2UyEq5H0YFuwclEGt1b76T19rTiqTIkOmF4VPVs19erp4Hrkm0E5sPgPd?=
 =?us-ascii?Q?pyVRCuE8298TUq3KxzrYVq/z6CyJLGvY2pse4JnPhvS+zI42HOpK/vPdfrOU?=
 =?us-ascii?Q?Dq0UD6uBYREG/g0JhFSOqZM27N4YH14EaAv8yy3e9M1m8OrYGP5d+ktM+nXf?=
 =?us-ascii?Q?gGiPnajaMjT3PowmdNswNy23GTnqFu+1I9aydEpv+ZMZa/WjTt296DJMDNbQ?=
 =?us-ascii?Q?L1vlCnFjfLvSKbuji6yCHlTtuiTWNkgn4kB42cTydoGGVZT6FDk2S3NDVbpt?=
 =?us-ascii?Q?Kllo8V1MeiHViITrEbdHmxq6X20CFBH7eblUFgMphvyRTLd97k3++dERII3Z?=
 =?us-ascii?Q?/txXodVpxHg15HmoEyDbkiBwerPDt60YaNoKE9QabNQ4hm2WPBZo2tACMDDv?=
 =?us-ascii?Q?s+EpVZ8mTTBur2YY0kQtZDkigQHJKehX56I0E/Zgf/CYkQh0DWzWuZatk/9u?=
 =?us-ascii?Q?rbu2BGz6QJmy4O7iLEqWIl/j3re8DQ8wnAs9HR03TRHHHmMXgoLjb/kyxgig?=
 =?us-ascii?Q?vjaK+SDn/FBDgxDqOyqlq9OcLIS/5OnBQv+9nAWY9L4+V+5/nMPlAlr1kE+y?=
 =?us-ascii?Q?ELq77WxAhhGYIoht1nk6qe8zUkY5lA5gPWcdEe5VkoPZ3FG6FCtM+dAdLfcL?=
 =?us-ascii?Q?dw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ca719ad-d719-4e6d-7e50-08dae0df1c54
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2022 10:03:28.4768
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yqbf/cM6FGd1Z3pcETeCblNE5qRgKyDi9h/wvt1t/apTKcItRhAStn71n5hZZk089woPHetbtCSnSaTmwR2YNUpmHWMfc/i0RI8KbJbA1DM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4536
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-18_02,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212180095
X-Proofpoint-ORIG-GUID: 5YCcPr7_Bgu8gCSJrsvPW5lvbIp7KHOU
X-Proofpoint-GUID: 5YCcPr7_Bgu8gCSJrsvPW5lvbIp7KHOU
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Attribute names of parent pointers are not strings.  So we need to modify
attr_namecheck to verify parent pointer records when the XFS_ATTR_PARENT flag is
set.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c      | 47 ++++++++++++++++++++++++++++++++---
 fs/xfs/libxfs/xfs_attr.h      |  3 ++-
 fs/xfs/libxfs/xfs_da_format.h |  8 ++++++
 fs/xfs/scrub/attr.c           |  2 +-
 fs/xfs/xfs_attr_item.c        | 11 +++++---
 fs/xfs/xfs_attr_list.c        | 17 +++++++++----
 6 files changed, 74 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 101823772bf9..711022742e34 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1577,9 +1577,33 @@ xfs_attr_node_get(
 	return error;
 }
 
-/* Returns true if the attribute entry name is valid. */
-bool
-xfs_attr_namecheck(
+/*
+ * Verify parent pointer attribute is valid.
+ * Return true on success or false on failure
+ */
+STATIC bool
+xfs_verify_pptr(
+	struct xfs_mount			*mp,
+	const struct xfs_parent_name_rec	*rec)
+{
+	xfs_ino_t				p_ino;
+	xfs_dir2_dataptr_t			p_diroffset;
+
+	p_ino = be64_to_cpu(rec->p_ino);
+	p_diroffset = be32_to_cpu(rec->p_diroffset);
+
+	if (!xfs_verify_ino(mp, p_ino))
+		return false;
+
+	if (p_diroffset > XFS_DIR2_MAX_DATAPTR)
+		return false;
+
+	return true;
+}
+
+/* Returns true if the string attribute entry name is valid. */
+static bool
+xfs_str_attr_namecheck(
 	const void	*name,
 	size_t		length)
 {
@@ -1594,6 +1618,23 @@ xfs_attr_namecheck(
 	return !memchr(name, 0, length);
 }
 
+/* Returns true if the attribute entry name is valid. */
+bool
+xfs_attr_namecheck(
+	struct xfs_mount	*mp,
+	const void		*name,
+	size_t			length,
+	int			flags)
+{
+	if (flags & XFS_ATTR_PARENT) {
+		if (length != sizeof(struct xfs_parent_name_rec))
+			return false;
+		return xfs_verify_pptr(mp, (struct xfs_parent_name_rec *)name);
+	}
+
+	return xfs_str_attr_namecheck(name, length);
+}
+
 int __init
 xfs_attr_intent_init_cache(void)
 {
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 3e81f3f48560..b79dae788cfb 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -547,7 +547,8 @@ int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_iter(struct xfs_attr_intent *attr);
 int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
-bool xfs_attr_namecheck(const void *name, size_t length);
+bool xfs_attr_namecheck(struct xfs_mount *mp, const void *name, size_t length,
+			int flags);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
 void xfs_init_attr_trans(struct xfs_da_args *args, struct xfs_trans_res *tres,
 			 unsigned int *total);
diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index b02b67f1999e..75b13807145d 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -731,6 +731,14 @@ xfs_attr3_leaf_name(xfs_attr_leafblock_t *leafp, int idx)
 	return &((char *)leafp)[be16_to_cpu(entries[idx].nameidx)];
 }
 
+static inline int
+xfs_attr3_leaf_flags(xfs_attr_leafblock_t *leafp, int idx)
+{
+	struct xfs_attr_leaf_entry *entries = xfs_attr3_leaf_entryp(leafp);
+
+	return entries[idx].flags;
+}
+
 static inline xfs_attr_leaf_name_remote_t *
 xfs_attr3_leaf_name_remote(xfs_attr_leafblock_t *leafp, int idx)
 {
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 31529b9bf389..eed743adb0cc 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -129,7 +129,7 @@ xchk_xattr_listent(
 	}
 
 	/* Does this name make sense? */
-	if (!xfs_attr_namecheck(name, namelen)) {
+	if (!xfs_attr_namecheck(sx->sc->mp, name, namelen, flags)) {
 		xchk_fblock_set_corrupt(sx->sc, XFS_ATTR_FORK, args.blkno);
 		return;
 	}
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 95e9ecbb4a67..da807f286a09 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -593,7 +593,8 @@ xfs_attri_item_recover(
 	 */
 	attrp = &attrip->attri_format;
 	if (!xfs_attri_validate(mp, attrp) ||
-	    !xfs_attr_namecheck(nv->name.i_addr, nv->name.i_len))
+	    !xfs_attr_namecheck(mp, nv->name.i_addr, nv->name.i_len,
+				attrp->alfi_attr_filter))
 		return -EFSCORRUPTED;
 
 	error = xlog_recover_iget(mp,  attrp->alfi_ino, &ip);
@@ -804,7 +805,8 @@ xlog_recover_attri_commit_pass2(
 	}
 
 	attr_name = item->ri_buf[i].i_addr;
-	if (!xfs_attr_namecheck(attr_name, attri_formatp->alfi_name_len)) {
+	if (!xfs_attr_namecheck(mp, attr_name, attri_formatp->alfi_name_len,
+				attri_formatp->alfi_attr_filter)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 				item->ri_buf[i].i_addr, item->ri_buf[i].i_len);
 		return -EFSCORRUPTED;
@@ -822,8 +824,9 @@ xlog_recover_attri_commit_pass2(
 		}
 
 		attr_nname = item->ri_buf[i].i_addr;
-		if (!xfs_attr_namecheck(attr_nname,
-				attri_formatp->alfi_nname_len)) {
+		if (!xfs_attr_namecheck(mp, attr_nname,
+				attri_formatp->alfi_nname_len,
+				attri_formatp->alfi_attr_filter)) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 					item->ri_buf[i].i_addr,
 					item->ri_buf[i].i_len);
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 99bbbe1a0e44..a51f7f13a352 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -58,9 +58,13 @@ xfs_attr_shortform_list(
 	struct xfs_attr_sf_sort		*sbuf, *sbp;
 	struct xfs_attr_shortform	*sf;
 	struct xfs_attr_sf_entry	*sfe;
+	struct xfs_mount		*mp;
 	int				sbsize, nsbuf, count, i;
 	int				error = 0;
 
+	ASSERT(context != NULL);
+	ASSERT(dp != NULL);
+	mp = dp->i_mount;
 	sf = (struct xfs_attr_shortform *)dp->i_af.if_u1.if_data;
 	ASSERT(sf != NULL);
 	if (!sf->hdr.count)
@@ -82,8 +86,9 @@ xfs_attr_shortform_list(
 	     (dp->i_af.if_bytes + sf->hdr.count * 16) < context->bufsize)) {
 		for (i = 0, sfe = &sf->list[0]; i < sf->hdr.count; i++) {
 			if (XFS_IS_CORRUPT(context->dp->i_mount,
-					   !xfs_attr_namecheck(sfe->nameval,
-							       sfe->namelen)))
+					   !xfs_attr_namecheck(mp, sfe->nameval,
+							       sfe->namelen,
+							       sfe->flags)))
 				return -EFSCORRUPTED;
 			context->put_listent(context,
 					     sfe->flags,
@@ -174,8 +179,9 @@ xfs_attr_shortform_list(
 			cursor->offset = 0;
 		}
 		if (XFS_IS_CORRUPT(context->dp->i_mount,
-				   !xfs_attr_namecheck(sbp->name,
-						       sbp->namelen))) {
+				   !xfs_attr_namecheck(mp, sbp->name,
+						       sbp->namelen,
+						       sbp->flags))) {
 			error = -EFSCORRUPTED;
 			goto out;
 		}
@@ -465,7 +471,8 @@ xfs_attr3_leaf_list_int(
 		}
 
 		if (XFS_IS_CORRUPT(context->dp->i_mount,
-				   !xfs_attr_namecheck(name, namelen)))
+				   !xfs_attr_namecheck(mp, name, namelen,
+						       entry->flags)))
 			return -EFSCORRUPTED;
 		context->put_listent(context, entry->flags,
 					      name, namelen, valuelen);
-- 
2.25.1

