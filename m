Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3DF1C433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Apr 2022 09:37:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358398AbiDFJjf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Apr 2022 05:39:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1585723AbiDFJgp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Apr 2022 05:36:45 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D8781A8C03
        for <linux-xfs@vger.kernel.org>; Tue,  5 Apr 2022 23:20:32 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 235NpcNn006381;
        Wed, 6 Apr 2022 06:20:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=8BDNo2YTngyIwp7dSudpc0HkXlXCy9it+V3BSAD6C9k=;
 b=Lk5qjxSgR9j52mBQxy3/WbWoZUBQT/7hp/flbPnrvKZ9KCID+k+dh6k/s2jtidWB9VBG
 yK14TjlhB+ciWNq6Yt0OCckeOu03ij4+LhA744n8kAk0W82cJ019pI3z8J13+g/cxkE+
 XlI2Q4ndU/wPGK23L94JrK/w1e4EI9k7nne0xXEkwp2fDpk5s/jbFrGF4hmu+oYc5Om6
 2g+43sAZ+On2qFB0CG8oTnUEHhvDPrtg7KFPkCygVSj12zoFMajcsuB0qqYauV1qnB6f
 fcSPok4noO1HanLbtvY5qU4UxELkBgnUvC7TEQHoEITK7qVJOedZzmTg+pE2fGmG90w8 og== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6d31fyf7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Apr 2022 06:20:28 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2366ARMV036403;
        Wed, 6 Apr 2022 06:20:27 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f6cx473gx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Apr 2022 06:20:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IfGj9zTv7+JcFTkHFbw1LEbHU2STxjpGLhm5G7ISwKzvScsiVQduoHP29JfILfB0tySc9deXCuFnwhyabzODAXdHSpDeOqbzRPHQdGEqEl/k6cJxbH7/dp4I+V0IHrqPh+9C4eykMLyR4v2fQs4VNBwKAuAPGyUNktcz0uk0H1TIVnPJwqKBugQIWtFO4Tt7K+hicNq+0UiAB8wssv4pcKB/hvdaU4LOTfgPsKfZC2SCJkET2KjHcJF+LNPGdf6qllFpoygbvjKRGmGBY/KBqDWY98rPKygaUeTU4g5gsfPBp0jSwxYuHMVQcP1BP+DG7z7ROgIX2HJMkRYkXdSsfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8BDNo2YTngyIwp7dSudpc0HkXlXCy9it+V3BSAD6C9k=;
 b=ALEnVVtk/+HNBupcKUmAMVka1F8oy6ZlxG/d7AL/jWntzkKfqoBPjrCKeZcWMjv8ceyjL8ES5cmfSCXLZ5vKcMGJdRu3jyzhA23RJdPBeQAXCvASebOTZFvwFd4icJJ3Cjl+T9O+mL3+vKq8TMU/Tq8uk83n+a/r6tYkqKUpz0rkUwCnJjTreQRWnq7iXwHUC4NNOO+S97Mw8oMe1UFz00MAhJzbM7gNOF8GZgzG+QGMoN9D5TJa5rfXQZrFeqwA6vdT68qU0YNoAcEBfrRdvSQKNIaZrPuriuC5UViPL2ytEQCsiINKzadyBQ0cyNa2w9wCNN4zFBMRAuq64AIAEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8BDNo2YTngyIwp7dSudpc0HkXlXCy9it+V3BSAD6C9k=;
 b=NlXch0/DApkx1koD6hnl2Y0mBwNhe6fnwfCvERwhTHZglSY6PXjlhSeK6Z/cgUIZZ8Lg54oVJI9uDSI891BNndRbnSk2cOq0DUmUuqagH698MCuSyJ0+a33OrprpsWWgMXqaQS0nIqlsjMwA0LZ7kbXlWvDqcPEfSGiHIUbRQEk=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by PH0PR10MB5564.namprd10.prod.outlook.com (2603:10b6:510:f3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Wed, 6 Apr
 2022 06:20:26 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::15c9:aed1:5abc:a48d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::15c9:aed1:5abc:a48d%8]) with mapi id 15.20.5144.021; Wed, 6 Apr 2022
 06:20:25 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com, Dave Chinner <dchinner@redhat.com>
Subject: [PATCH V9 10/19] xfs: Introduce XFS_DIFLAG2_NREXT64 and associated helpers
Date:   Wed,  6 Apr 2022 11:48:54 +0530
Message-Id: <20220406061904.595597-11-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220406061904.595597-1-chandan.babu@oracle.com>
References: <20220406061904.595597-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0047.jpnprd01.prod.outlook.com
 (2603:1096:405:1::35) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0d906897-67f7-4dd2-51a2-08da179589d9
X-MS-TrafficTypeDiagnostic: PH0PR10MB5564:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB556440DA8EBBAE50EAB4B96DF6E79@PH0PR10MB5564.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XPH+CvK+ild0Zdg8edFFoNPWUBtsjQcC7C9QydPaxJYF//oc1onEH5hw2aN/Lwcmtp31BTDjeYp0Vki6IwKxoYjRImsVXShwjn6UW/vwpMxBASwYoam2TjU6NDb7ZYEuFt9NTUk37wmnIUlVwio78R5YKWggCWmSASR5gWBtMhi9oI6K+p0h21RDOGBwUmcc3Fy7tMPMTPYcqP/6qBbdZnhKmgZkC5xlrKw6OkX/r0nWBjnGQRNxThVCricHwMZy/WG9/pMTYxFdFySSNicZ1IJfc1icG8HkC4Oxwp0GQJ4Qz5Z4vddKOhNB8iCH5cJ0aQFAvktwJOAbtJDoAFKw5BxSqTg3V1dlQ/uPbpZcDnA5t7XJPpmbr5PJuEUzT5G+zkBoO3eI2vd9Md2QvgurARLZJ0HyGEX9sGvc8WZYjv9M2Vj6Fe0mQKXkPGukSFkMIhKLXnM+kt9SIFaH6mnDC6ie6/1c8nPIuiQj643ZCC+O/HWWq+zLY9XII+zzAVlxXcCGaAzAKI6jAORB8bAKj/98HniIv6r59thgHhzfSD7OKNCvJ7Rgi4ZycbXdiwRT5sBTwOQIAMjZPnoh96noGQrRTFJZ3WAK4t1DJ+DiYkUue4WGMrT2fJhqP26YdGYeFJcIAjv+vEluXvqsvgHadH1C+2hhK+rSuPW1KPuWq0hxiXQWIPqM+9ATmyK8Dq47hgON7G4NmX28FjtXK49/3Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(66476007)(66946007)(6506007)(66556008)(52116002)(6512007)(6486002)(54906003)(6916009)(4326008)(8676002)(6666004)(316002)(5660300002)(1076003)(8936002)(2616005)(83380400001)(86362001)(38350700002)(38100700002)(2906002)(26005)(186003)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pDmZBl7Eob1yr/D9HCMUwMPrUfWnHzT0r+dPZwlNWYA0yKQG9HikAjrKG2qz?=
 =?us-ascii?Q?/3+8s5T02ZXJ9xsPv2ioVW8Lb3ymT2w4eJbuitZimD2uwGAq9W5LW/RrQTtt?=
 =?us-ascii?Q?ALtXm4oaNO0QQh+ysrj2PWk7CZp/PRq+Qb7bVxZcNS0lkB6lyMB2RvLhLtyX?=
 =?us-ascii?Q?74BlwY9gRCAMSoqLIdT5lQgoFqlJlYoUlyCble14m0fwTjO4MEUdbd7x0mwd?=
 =?us-ascii?Q?dQlCJllDSeU0Ry7M5H1l5wxAiDyKrok4nlvcBrULxuaa1UZlpUB9AiU+eUzq?=
 =?us-ascii?Q?B/efgWAmfkDXWjGQmefmNxoTOmgneFGXKe7+3SrGLkD6jDXGYqn3p2ZEFpoi?=
 =?us-ascii?Q?O2SebdpmI+a1OxEi/MFELJ4kYf+Qb4KJeTSbYUtbstR8em/6MBiriFCW34rG?=
 =?us-ascii?Q?hP3MfFLVcgLbgM2tXc6/L2vnrWRvSaOo85o1mSMzKkkdAXD4CCmHC200Y6eT?=
 =?us-ascii?Q?FuCF18pM3LpGNT5Z7UpCzvy9yOsMXoqTXKoMprPYePk4ltJ+zcEMsb0XOMhp?=
 =?us-ascii?Q?sZ6UOCD9+tCYdgHmACKUA5X32S8KtRTy1pvg+91KJEYePkxz0X0JM/YHtdMb?=
 =?us-ascii?Q?eaLtkXTPkzy7ISZXkAxl8jUDoyxn3zSIHptEfF1UQZHvzrvMXEusGywbqQ36?=
 =?us-ascii?Q?U5cZFnp2xidWDlJGqYM0nos2zrBJfyUJeS0Rq8/9Vux4C656Ia3JHxQvUlPM?=
 =?us-ascii?Q?kolEpR4bhKUEcIDmwjMWaG4lg3HUfHWhQcMmYzkW3zAx0NHTmm+SpvKSTGq3?=
 =?us-ascii?Q?wnHardW0I4qgKBaqVV7EWEgKHXfn+TWTnhbyocJkiY00GLLHWYjxp2kxAy++?=
 =?us-ascii?Q?7mDPrs/5AgXrrYYd+qfg05CnNQfmBAMq8NTQ8LxhtjIaJSaN+Spr8tuZzbl8?=
 =?us-ascii?Q?LfN/x/9KC3Um7f9Ig7bqMXTqMgP7+En2L7qi933Rl8A0zCsQpE5temwBxd0E?=
 =?us-ascii?Q?7mocKPWoJj0zW8H4a1jMPzH8mEg7B1GyG49YstDDGPQmGGyEv7wOtZRvbdZH?=
 =?us-ascii?Q?ZsuInjKZNeBLRkL2XOcdsWMVe6x53rQYo2tV6gwgOg+L6YGbNEGYQM4DOem8?=
 =?us-ascii?Q?amdml0ZXllG6C29co3KU75aLR+tt9DM69Hjg606/7U2X3DMQpvxxfTjVLLAx?=
 =?us-ascii?Q?hkTETYelUEA9eSZ+1MruJ/8aY76P0oQN3IRMYqgOpDJx9f+ikbZ13dnYXoed?=
 =?us-ascii?Q?7jpjQhsmWuqLprSQUWB7iOU3NobinqQRj7AL9fxyOBn0IHXXCKc8T147kpAt?=
 =?us-ascii?Q?lCbxKP5gX3wc9OAz3ysdo4iA1VOXVI7vByk5Su8UzXKEWfbj+slYRWoo7sDa?=
 =?us-ascii?Q?J+2LDVSS2od43IsaDfn5hRYQJMGzyA8FPJZORzXV9HWXJoIRW+0IYdLlwqFL?=
 =?us-ascii?Q?fr+UfzTEico3YnXimxOY8NFT127Q3E+IamTqXtGY6Q3KlqCbLhMdyktB6Fag?=
 =?us-ascii?Q?H05d0+mlSaUTMG3yeXMFKsldI6viwK8zGIMlfs4DPej+WdWtIHQohNwC0F3m?=
 =?us-ascii?Q?ltI8aWpxJ3Yun05u5grW5O7RN4hz6lsaWYR6xETYyRfzzPCKWRmUBfR0hYbO?=
 =?us-ascii?Q?N9nIA6s5tFfuWvgkpX8KhrnIaPil+r5EaNN4x13GvL/KoEEHV58L+DpTBuEu?=
 =?us-ascii?Q?CM3QF89SjCKY6qTxXN8LOOxlL895u6YaCXaclCQRhxxlJa2MrSK1v5WHcekv?=
 =?us-ascii?Q?c6tH47P5t1L6a4wt7+TNAJUH/NZ4dYWgRksffXJfWUxSCicXF82/FNfPHyF6?=
 =?us-ascii?Q?nGFFsla/l+55ww+h3/0nyHIkYI3Zu0A=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d906897-67f7-4dd2-51a2-08da179589d9
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 06:20:25.8506
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TSW91Cm//usaIzVUG1odYPfnAeNLJUO7OaraQg7uu5NthA/ji5TRDd1foUhFJe5zxf/fY0A6MyUwHYmqdNcbQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5564
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-06_02:2022-04-04,2022-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 adultscore=0 mlxscore=0 phishscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204060027
X-Proofpoint-GUID: -H7qvwDAYh5vF6nuS6GdUf0BQTiN1B3F
X-Proofpoint-ORIG-GUID: -H7qvwDAYh5vF6nuS6GdUf0BQTiN1B3F
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds the new per-inode flag XFS_DIFLAG2_NREXT64 to indicate that
an inode supports 64-bit extent counters. This flag is also enabled by default
on newly created inodes when the corresponding filesystem has large extent
counter feature bit (i.e. XFS_FEAT_NREXT64) set.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h      | 11 ++++++++++-
 fs/xfs/libxfs/xfs_ialloc.c      |  2 ++
 fs/xfs/xfs_inode.h              |  5 +++++
 fs/xfs/xfs_inode_item_recover.c |  7 +++++++
 4 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 64ff0c310696..57b24744a7c2 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -991,15 +991,17 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
 #define XFS_DIFLAG2_REFLINK_BIT	1	/* file's blocks may be shared */
 #define XFS_DIFLAG2_COWEXTSIZE_BIT   2  /* copy on write extent size hint */
 #define XFS_DIFLAG2_BIGTIME_BIT	3	/* big timestamps */
+#define XFS_DIFLAG2_NREXT64_BIT 4	/* large extent counters */
 
 #define XFS_DIFLAG2_DAX		(1 << XFS_DIFLAG2_DAX_BIT)
 #define XFS_DIFLAG2_REFLINK     (1 << XFS_DIFLAG2_REFLINK_BIT)
 #define XFS_DIFLAG2_COWEXTSIZE  (1 << XFS_DIFLAG2_COWEXTSIZE_BIT)
 #define XFS_DIFLAG2_BIGTIME	(1 << XFS_DIFLAG2_BIGTIME_BIT)
+#define XFS_DIFLAG2_NREXT64	(1 << XFS_DIFLAG2_NREXT64_BIT)
 
 #define XFS_DIFLAG2_ANY \
 	(XFS_DIFLAG2_DAX | XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE | \
-	 XFS_DIFLAG2_BIGTIME)
+	 XFS_DIFLAG2_BIGTIME | XFS_DIFLAG2_NREXT64)
 
 static inline bool xfs_dinode_has_bigtime(const struct xfs_dinode *dip)
 {
@@ -1007,6 +1009,13 @@ static inline bool xfs_dinode_has_bigtime(const struct xfs_dinode *dip)
 	       (dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_BIGTIME));
 }
 
+static inline bool xfs_dinode_has_large_extent_counts(
+	const struct xfs_dinode *dip)
+{
+	return dip->di_version >= 3 &&
+	       (dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_NREXT64));
+}
+
 /*
  * Inode number format:
  * low inopblog bits - offset in block
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index b418fe0c0679..cdf8b63fcb22 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2772,6 +2772,8 @@ xfs_ialloc_setup_geometry(
 	igeo->new_diflags2 = 0;
 	if (xfs_has_bigtime(mp))
 		igeo->new_diflags2 |= XFS_DIFLAG2_BIGTIME;
+	if (xfs_has_large_extent_counts(mp))
+		igeo->new_diflags2 |= XFS_DIFLAG2_NREXT64;
 
 	/* Compute inode btree geometry. */
 	igeo->agino_log = sbp->sb_inopblog + sbp->sb_agblklog;
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 740ab13d1aa2..aeab09882702 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -218,6 +218,11 @@ static inline bool xfs_inode_has_bigtime(struct xfs_inode *ip)
 	return ip->i_diflags2 & XFS_DIFLAG2_BIGTIME;
 }
 
+static inline bool xfs_inode_has_large_extent_counts(struct xfs_inode *ip)
+{
+	return ip->i_diflags2 & XFS_DIFLAG2_NREXT64;
+}
+
 /*
  * Return the buftarg used for data allocations on a given inode.
  */
diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index 239dd2e3384e..44b90614859e 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -142,6 +142,13 @@ xfs_log_dinode_to_disk_ts(
 	return ts;
 }
 
+static inline bool xfs_log_dinode_has_large_extent_counts(
+		const struct xfs_log_dinode *ld)
+{
+	return ld->di_version >= 3 &&
+	       (ld->di_flags2 & XFS_DIFLAG2_NREXT64);
+}
+
 STATIC void
 xfs_log_dinode_to_disk(
 	struct xfs_log_dinode	*from,
-- 
2.30.2

