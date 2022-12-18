Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7245EC4332F
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Dec 2022 10:03:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbiLRKDb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 18 Dec 2022 05:03:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbiLRKDZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Dec 2022 05:03:25 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41F7B6333
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 02:03:22 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BI4oS7V013418
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=byIVVGAAl58XChe4HGFCUp1d4qYCSpzWqhqS9GGFqQg=;
 b=w5fjny89kpXDMB5kCiKt1OjwOd+MLYwZhpS+K3N3nCQsUOEYBzfyNCvrVswUPKzDi/w9
 otcRh+q++wW/Y2I52i1Hra1nR+eAmVurwYQs5gULWoKqeRJfezT2aa3tcOBJYfG2hk3g
 aoYfiFmjJNa69RIauFyuWb7/AZWE5XQNSFaOlI/ZG6/QawdzFniSZ5HuCODdNY70A2qw
 oSmMuMVduwtvZJIHCsKkHI6zm5DnVn5hzeNP2P63dg6SMm5AwIho3CCISnoOIzuL1pMG
 CX6RE/55RP4uzs60Bq+yUl859f8VE1r/iwsOo7ZVtaF9hgXhgP/HdRynDI2oh1C6emdj Tg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mh6tms9b5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:21 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BI6oEpM006541
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:20 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mh472m2yf-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=laKo77ckJrTrtQMFAAMkyHAPemK42LH9sy4EvQo4XEcDYg4ZCJN2QTKw2QPogY5jTIv3+V4dCqSIeEVpGBIS3eEubJOL/CWKiDwulEBxIYWxhZVczCvHMaJ0M7FJH3Dle9ntSqkq0dM8BC74LUQNx4UhviisH90g3UkfsLSwffCb/zbXaRM5eF1WLg293a5pKHxfn1T5g+5x4lV0EUW4M+7Gt9wCY/5dhmfNKiaGtyRn9O2nTYCzLwIymXj5taNrEq8Q15X/tNOB8wrM0NpdGuDgJINeVeZzHCwIbUPcYSZScWtGe620UApWGGNSB8YhOyy8v2fyrx1fkui/VxL9gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=byIVVGAAl58XChe4HGFCUp1d4qYCSpzWqhqS9GGFqQg=;
 b=YbJ1M7UhqOv14h1G3taZLKODibw0tGY+uk5LRGfU4f3j3mXEho4XiaN8Mk0IS73SA4AUCdhFAb3HQDRZ0Tv6j3Y6pAjcqQg5Ggwamml+HdFA/NMrE/ltTJfk70fxzFGmvjuLogmtUxkf9a0qmDrjpDzSG5y27pmg2gJTVqm9n8avdzpjvWBxAjm25XOqMCTuBBk0orb9MEB9s+pIeWxcBvwVb19yiYL+gs4m1JAMnQcJEciPeJmzJiB8BnoGz5qODTzAzWSCDvx/6DlIzIfbF1NtqeW6qImkR7gdVFnzGhulwgBVRbbRxTnzwTI/K36Hok+NCswpAWPFfIXt2ZUFJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=byIVVGAAl58XChe4HGFCUp1d4qYCSpzWqhqS9GGFqQg=;
 b=WCwyNQdP7HMe2UVgIOvIbH4cKgLVPxNcRV789mDc4ffxH1FkfTk/lOhjjRVcG6SRzMzf/Ve5zpZHuQPM9Qo3L7GbPOlPg+iZgBaJar4oXArdko9n6pkodcE38ZVMGJBH7vj6gicwBwsekdFY3ZqONh6gQxFg+ctb6ymU2Dc6EU8=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB4536.namprd10.prod.outlook.com (2603:10b6:510:40::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Sun, 18 Dec
 2022 10:03:19 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c%4]) with mapi id 15.20.5924.016; Sun, 18 Dec 2022
 10:03:19 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v7 07/27] xfs: Expose init_xattrs in xfs_create_tmpfile
Date:   Sun, 18 Dec 2022 03:02:46 -0700
Message-Id: <20221218100306.76408-8-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221218100306.76408-1-allison.henderson@oracle.com>
References: <20221218100306.76408-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0020.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::33) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB4536:EE_
X-MS-Office365-Filtering-Correlation-Id: dd4d5e20-2b6f-4f37-b52d-08dae0df16da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x0OUKvFojg8mHzOcIHbvgu0uXzCULCXzMvnQUDO3SJG8NZMADOyr+1TnR96yH6Zw3ZRmgqLNEUa6bJY++6VTUuXze/lcTi4WPiPHSMvovirH5nh0hMsRLz7RONPtG7uVDm0mDZ/PiuBtGqOyW9wddUn4OTpp6g/U14WXIE9FA8ayNThhqOnsN5+ve+Hqt6saCNDgrDWSt9qHo4PogAXUG6H0rKX/WNvuJjjIdbhW9n3KrOHfAHEBlCHcjkzsqbeJ1NkoNovNkgkuHLrMIbxXw0l2/bYoxjwJ8RduTs6XdXtaRYY40UdkWXCbO67gtJZtOuS6pLtX9kSVoOB5AIFMau5HKiIP3oEIWqc2Fv/2BAgGrV6rWmGjbnRjnKjVBw439iL0aK/orduCtGv1vxet++crKSULIKxz6DhhKduaXEEpbEZZ/9Pa0Gx4vBlYqKvYDYCLxq1x/cTo9xrlQy8t2N5xwSyPaBsbwUlvuvcoRsnCnulQHKT6zJIadET8Wx6aUUpi5p+8ZlUNu5xI7sjLivLg6CN3z9lYSfGIMDBh5q+UFZahT4vrGMzlk+83urhBYvrlq4PbUM59WKpzkpvhdLq8pwE1agknbX0qqHZ86vxnGQxB2HfCRDnz9FeSw9Hh/H/XPvo3AOAs2rAfIN+8NA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(136003)(346002)(366004)(376002)(451199015)(83380400001)(38100700002)(86362001)(66476007)(2906002)(8676002)(66556008)(5660300002)(66946007)(8936002)(41300700001)(1076003)(9686003)(26005)(186003)(6512007)(6506007)(6666004)(2616005)(6916009)(316002)(478600001)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EPEGt4ohmCHM7z41sYaXCGXy8/EDNJIMe7j131zp9/hCWsdqng89/9+TB14t?=
 =?us-ascii?Q?9wtGYACvTASrhsCxjurnarK7d7VMfk2OEXsCOEu+o6Ew8OcPKDb+AQ2QoN7l?=
 =?us-ascii?Q?RW4rrtYZM9aLIzJA7RXVGJ461DxCBa1SaZ6QRV2NMAze8MVtfv04mf+WgAAX?=
 =?us-ascii?Q?CXLIdbRJj0s0/xhnMXa4PXZf8gI7ygcNHInpGzFY8chEvy5q71/4sLEOnKF5?=
 =?us-ascii?Q?MnLzEvU23SZ1J2m4cxkmeTQKNyYcdPW1UihSi7Stg9mYb8ViqiHD6MuyDmpz?=
 =?us-ascii?Q?TKxtq1BtJg+v1mHa5gzj1YpUyv0g4t6R36vLqh/Hqy4Hv6+0O2sTo6xfqzS0?=
 =?us-ascii?Q?y1aBjngV5Ci0JyyhZklUhAWgmDgrqW+H8xvKI6NHtAs3MFd4x9M3pker8SI6?=
 =?us-ascii?Q?1fKwPlhb5YQ3NUVKN2zH3TpN9/ybtIoSDZWvFzJKbPPOXN1xDF3Ai3UowSxb?=
 =?us-ascii?Q?bmE7a5N6wpYHm1H9HUV2Telk2jWobS+IxVMivozdTi/AdMSvVbSXnbZiaSAK?=
 =?us-ascii?Q?Qo4Y5L0nJyOKX4bvwnumLr7tENlzPoQw9+J+DB8JA7nmUYTlK3u8cP1FOJNp?=
 =?us-ascii?Q?xrl3+oc2OTNIZqLnPmG+3m90PUMd8wDjKV5J9SDS+Pm6epGmKpeAAbTT7Kv4?=
 =?us-ascii?Q?r553bfoNL5uKlSA4JfSkdLFEa0PwmOPw3JBtpNN9IiBQSG9xICvyGAkiNCv0?=
 =?us-ascii?Q?byy3nzsFLk7q96ZyWsJ4newrhNmgGplCDdEiEAO7Z28/mhF/wCX2MTC9RK33?=
 =?us-ascii?Q?svMjc/9WvT1d6inPlUSGevj3ayw1h/Y+aFdNgn4L9HRPn+aQkQtFRPRG1QMp?=
 =?us-ascii?Q?jGl7uojsKVYh878xK593HYje7eyQlKeTvrEGb0y/+zchjoEH1Ua03k5b9kTZ?=
 =?us-ascii?Q?3tgkWcvBKxLZP5xICaT/sgeQwQaMJo28z9C3d/kzKycrHPz+7eE77Ji9Fz8S?=
 =?us-ascii?Q?90MXqSrJsTw0I7I5naUyNOI4WqkrwIpc/k/uZLH1USeq1qx5xf8GmqDFVA+0?=
 =?us-ascii?Q?mGwTeSyGSOmGSMuUG5C6XHYuW90fecKmBxzTz0SEEva+b1WqgNAMs24tWIjf?=
 =?us-ascii?Q?fXyu6+adOjgL9BmrD2WYnaRzPyOYdTgTyo98HaYORZ0TxPhp4kNDv6rJqmVc?=
 =?us-ascii?Q?jv+bO8ZvQOAJDx8Dj43//TaY0KAGRY+I9VICP2gBmpd8+yaJImCEt3SHRZ/i?=
 =?us-ascii?Q?7oKCLouzi55lezdvasRoyF1oPgKIx/1cpFm4XoO6KT3oCbdVcViPw1OrofMo?=
 =?us-ascii?Q?D0x8GPL+9U/AI+FICRVzsPakCRD2bUbwV72QETnjoNb103tO27/b48S9GAKx?=
 =?us-ascii?Q?PjvPOya6duJmgW36C+98eXfLWyTncpy/18hYd40EqRX5i4kBDetYxLeM+K2Z?=
 =?us-ascii?Q?LzIaGgc5RNyjumo5xAJqZg6IXnMLakfO92H0sFZLA/kFpi5jeJ8FWVRTsDpi?=
 =?us-ascii?Q?XDciadiz5PBJ8iyii697bYunjxCEWUXfJV6JaWaEUm/dbvO4nqd6lwHQ1sbk?=
 =?us-ascii?Q?Iqgzt0yjiYiEBI+uQLqVJ69UjtSw6rl9cyZyT7Qo0NQtSwh6COi2uIiau4au?=
 =?us-ascii?Q?jHGyHd/kLFZJTF4YtqMX0ccTGLLRAq+P6eBGmea+3MCnvyJhHFHQaMMMsmHk?=
 =?us-ascii?Q?yQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd4d5e20-2b6f-4f37-b52d-08dae0df16da
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2022 10:03:19.2732
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rOv7mp+5YNHNvrewewGUprV8kszV6a0vNEKUzgEmyS1Fq15kZqz84tsTJNTyP3r6Lf8oo/SG9yCY72DDvMmWDq3pw6ujOyMdNEi3qcqbTgo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4536
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-18_02,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 mlxscore=0
 adultscore=0 phishscore=0 suspectscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212180095
X-Proofpoint-ORIG-GUID: BnLHqbusH7q6nxCdRLFwIt3lrK2EtTcS
X-Proofpoint-GUID: BnLHqbusH7q6nxCdRLFwIt3lrK2EtTcS
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Tmp files are used as part of rename operations and will need attr forks
initialized for parent pointers.  Expose the init_xattrs parameter to
the calling function to initialize the fork.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c | 5 +++--
 fs/xfs/xfs_inode.h | 2 +-
 fs/xfs/xfs_iops.c  | 3 ++-
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 4b39ec7fa5f0..ffe945335bf5 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1109,6 +1109,7 @@ xfs_create_tmpfile(
 	struct user_namespace	*mnt_userns,
 	struct xfs_inode	*dp,
 	umode_t			mode,
+	bool			init_xattrs,
 	struct xfs_inode	**ipp)
 {
 	struct xfs_mount	*mp = dp->i_mount;
@@ -1149,7 +1150,7 @@ xfs_create_tmpfile(
 	error = xfs_dialloc(&tp, dp->i_ino, mode, &ino);
 	if (!error)
 		error = xfs_init_new_inode(mnt_userns, tp, dp, ino, mode,
-				0, 0, prid, false, &ip);
+				0, 0, prid, init_xattrs, &ip);
 	if (error)
 		goto out_trans_cancel;
 
@@ -2750,7 +2751,7 @@ xfs_rename_alloc_whiteout(
 	int			error;
 
 	error = xfs_create_tmpfile(mnt_userns, dp, S_IFCHR | WHITEOUT_MODE,
-				   &tmpfile);
+				   false, &tmpfile);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 2eaed98af814..5735de32beeb 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -478,7 +478,7 @@ int		xfs_create(struct user_namespace *mnt_userns,
 			   umode_t mode, dev_t rdev, bool need_xattr,
 			   struct xfs_inode **ipp);
 int		xfs_create_tmpfile(struct user_namespace *mnt_userns,
-			   struct xfs_inode *dp, umode_t mode,
+			   struct xfs_inode *dp, umode_t mode, bool init_xattrs,
 			   struct xfs_inode **ipp);
 int		xfs_remove(struct xfs_inode *dp, struct xfs_name *name,
 			   struct xfs_inode *ip);
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index bf0495f7a5e1..0ada7d6140b6 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -200,7 +200,8 @@ xfs_generic_create(
 				xfs_create_need_xattr(dir, default_acl, acl),
 				&ip);
 	} else {
-		error = xfs_create_tmpfile(mnt_userns, XFS_I(dir), mode, &ip);
+		error = xfs_create_tmpfile(mnt_userns, XFS_I(dir), mode, false,
+					   &ip);
 	}
 	if (unlikely(error))
 		goto out_free_acl;
-- 
2.25.1

