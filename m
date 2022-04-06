Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 251C7C433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Apr 2022 09:37:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350739AbiDFJji (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Apr 2022 05:39:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1585124AbiDFJgQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Apr 2022 05:36:16 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD8252A62E6
        for <linux-xfs@vger.kernel.org>; Tue,  5 Apr 2022 23:20:22 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2362V0xw012451;
        Wed, 6 Apr 2022 06:20:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=Cz2oFqvLZBSZ3ng0nJT7XxaGFiySp5beQaVKwLcPsiY=;
 b=q2l8EJLczKtsgsS0Yzw7XFCQKfyDVo8FyvwABrV15ry/j2TDa+UL4b9nMOmE0MV210R5
 nlr6FKeUmqzoTPL8Kp9ZzY9t3im1XRJF2dklQhOhuZzhe+C1+lMmIlWREEuQEYe7WQfc
 ErdPfgxju8Lch3hkUysPKKSXZxXBB3qIDJbJ2+mVSB0P381kMZvwEwVLayeWjapjK+CL
 6ynNDTROA8CfG+3bFg2HmZ8QHCO1eyPHfkpbyOFsqiuv8OOxbWC4V/W/Loz+qeU9dk/2
 LC05Oh/F/iUbZ/1KSxAXz90MarQegsi8qxOfiR4lTvdCw5s1Drxdq26g2trJRkXyOObx fw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6cwcfr3a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Apr 2022 06:20:17 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2366AnnG024299;
        Wed, 6 Apr 2022 06:20:17 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2108.outbound.protection.outlook.com [104.47.55.108])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3f6cx48pea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Apr 2022 06:20:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XhVl4rJdwiODw+BU4HtH1lOjCEX/QK6zPqKuqlYDwzFDshAOkPPGR2iVCeI6mXE5bT8YdEC7t3JZ77+PqZH5/kJh0nRpsF/ZAws/5tPSDcerVh8EMUaPxtIeqLfag1tL51HzCX80DK8PJbVt1BSmpsqRQawaN6vzK3eyot/fjaSJmAzDowdOHSsiCFT5wftROVOSwitcqmu7bf21EYWhhJ+wPG/x6QB9K9DYt94XalbWIR9pF96LIyfZNun5PJjJsFgd9G9iPQCLFUkD7IzYx0nPYddbZ3Kqm/I+LVPPvTGWw22JuArwhaBZW0JsbBsJj7/8W8W2RIDJjL/YRlWFhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cz2oFqvLZBSZ3ng0nJT7XxaGFiySp5beQaVKwLcPsiY=;
 b=k4JxqBEK3p5q6bdKMhPAVAre0w/WQ1xn3/hveSqp6D88g1Tem5K2ZbRKnRz9viw86UfhYzo+ScJB6Ut0gzCUofSadPJNXsJlGezALjQaZ167FEFD+bS8dbhCUSaRPxyBV7jBrFkVslCOGGq00Ugj6ZHGWa0WMWwIa6uPvdUe6nSBi87JZmZh91D6pA7EHYIWq+GXCs/EgvVvYUicnBVesgr8PEc502sHniOZPGuxAo117lD8pFjXnHvKkrYRrO6U+1WUaS2iWDk1yHeguIDchKNewQFVtgLyMYkGbNJdu3zp5aNx0pA4OzW0RhykPE1EAmf9aMRU+aXFJwdhUf+VtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cz2oFqvLZBSZ3ng0nJT7XxaGFiySp5beQaVKwLcPsiY=;
 b=vu25MQ7y+o8YxGay+UAcUYwiWIwVDS+2rS2pLzurL74sLCO7ifIqsGlx8vk/JfX6YEHgqi7A4u/ClaL5qS2IlLrFmvIIqbdG1yag3YK5/ukYUKw94rCdKlCC7JGS+y1iJoqWKmfGQ3tK01KK/LGyeHph2LyX6jHXWRqmuA4MRRA=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by PH0PR10MB5564.namprd10.prod.outlook.com (2603:10b6:510:f3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Wed, 6 Apr
 2022 06:20:14 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::15c9:aed1:5abc:a48d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::15c9:aed1:5abc:a48d%8]) with mapi id 15.20.5144.021; Wed, 6 Apr 2022
 06:20:14 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com, Dave Chinner <dchinner@redhat.com>
Subject: [PATCH V9 05/19] xfs: Introduce xfs_dfork_nextents() helper
Date:   Wed,  6 Apr 2022 11:48:49 +0530
Message-Id: <20220406061904.595597-6-chandan.babu@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 5f1d9992-7cb1-4d42-bcef-08da17958353
X-MS-TrafficTypeDiagnostic: PH0PR10MB5564:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB55648F7F8CEE5CE770D207EAF6E79@PH0PR10MB5564.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 50bCLZSa3lWse1fxhxTBUaRDWMebW95yx8Afw1irR/Gcg4Eb7C88oxPNzT0KjDAjCpJzbpfUIAFob8UIdn0Hx4tL1+Kj/Y1ZgUvFe03w2sJ2NkmcPhdg0m1ucID3BkGbk4BuBGXZDSVCi5e/jXJVDnMm0rO1oUubzrEgFumq59TZ0oEcqnzFw9+4PR5Ew7mqM0ScV3yx5yMzKABEfV6RS+yWGr+pdkwFs5N6QRHvgHQMEvDUxP5iGKmKh6dntln+MMWZ2RvEOxB0Jcz4VDomcNcQ3CI3itP9lUFws0b5dsqXK2usLEOqSTLGjDK4jn9k5B6H9nwm92LQ5OvOYsWxX7lehMepr4pvq0+6ZBiSMO30EfJcHMBnpFqeskXRrwdTQWiOFB7B3vLV5COoi18DaAsoXPDBg5xOYpgzd0CPnTjKD7cRQoRqCLkM7JZJkTc6Z/yIMgKhL2946zOvhkoryfwTNLBcCBjfQycyRSVP5YHz3lHiXEeuFs3jNDoi6CGaiHO9j0/7GvrQ0iehyy5qqKs2ByTCpkVKG+z7io/GMqA7Av0HcelnncGimU3lP99VV3HtLQw6LbfS24FnyhvyatlsLMuDQc3jHqTCLjW8ACjP5VtVA3AHEwFKU5bm72wbpALhqsSiqwJbqcR9BLTZUa52lZQLd/mVb00jExjOwJhxG8njaOhPKgB0+Ot09q2MsIdyAe282PqNV7YXM3pcyg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(66476007)(66946007)(6506007)(66556008)(52116002)(6512007)(6486002)(54906003)(6916009)(4326008)(8676002)(6666004)(316002)(5660300002)(1076003)(8936002)(2616005)(83380400001)(86362001)(38350700002)(38100700002)(2906002)(26005)(186003)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?idbRMn4abZz9UTOf2kNWm4WzFvY9FQBWNgomJzUAE7UIgNQPo08AqzWzeLyG?=
 =?us-ascii?Q?6ds4hxFqwfBDiVojAL0iekRGOXvWGRkR1/8lh78yW83X8xT7jmhMXFOM6Q1H?=
 =?us-ascii?Q?8l+TQLXcF5viNhGo1qRI+gG6ZDtO0xGY6ObgpqSmgOEdpC6wYxLXTAmYOV0z?=
 =?us-ascii?Q?5aT510d5TWrmbZ3VK3vRkIe7/XLFujk8R22d0Q7lnU4O2tiQDcamVvQHRTUf?=
 =?us-ascii?Q?BFsfks3Coy2gVhUJfUyzOudWkfX/pTHakwHhGegnOxdvB8jt6r6uxsIdjA3L?=
 =?us-ascii?Q?g55VAkTka+kXwS8vpQne6l6JPdzb7SSPVR5txGbUUxkwZPAR1gGBPn159KX2?=
 =?us-ascii?Q?7xDrJS+EttB2YBTuqLVmBeWVI6AicY8zs3gt/GhKalJ9aTw4wgVgx81XDzzK?=
 =?us-ascii?Q?acEZmA9PSVcS7K3w0x7i/Y2Ixjo54xTmCyP9p5trhqeIPL6EXUtQ71tip01G?=
 =?us-ascii?Q?PZg1Lpg+xTSXQiINuhEo9nYP04wQouMz4lu43yYQOBrWydlQWRGVW1g/7jSF?=
 =?us-ascii?Q?m1JmzkKtrQzLBgKtl+U9S/kahCepP8m1TJG1I57d8sXOoaWWMTj3OFRL9k/S?=
 =?us-ascii?Q?a+upH2uKKsuP8z5zeGa6llEI5cgJ/ahhe5NpdLzM+5eNynMZqxznEkjJUN3u?=
 =?us-ascii?Q?kc+35BhHVmP6YVwOIwA1hS7XOuAOJ71jc4giNiV9Azq4N64Qg2v6+RPfAJxz?=
 =?us-ascii?Q?Jt/pL1ehQARwi/TbBtJ8XKIyqnp92073IIkKnLLcUdja3kJFtYBZwq9ftoqt?=
 =?us-ascii?Q?qe69d7u/vEehgGGkhu6EPy1HfLj9vuJ/bjspOqYnJmWlipA629f3smSVfyIE?=
 =?us-ascii?Q?OpHiqt/l3tq4wvj+LvbflxfkVP1rNSuUKzVjdofXRJOOLM5IEY1b0tlxYXJ9?=
 =?us-ascii?Q?1wqydR1qV2VhHNcEybBMVKMnmKi/yFjRt8mZM8YcJw3c9o0kwJxhkPszdCs0?=
 =?us-ascii?Q?w0ee7rur7LRP0tz4UGNV1dIe0Q4xl3yQlCc4cQqAbx+f2IQ84p4wuing8/Wd?=
 =?us-ascii?Q?Weg/znd59Og2vM2MPEOrhB3hkAzQrOGcYVpqhdFoyojHkSDg67UBXdy5e5yh?=
 =?us-ascii?Q?AUjTMfUJhtgAev8P13+Sp6QlsSKz4jZlqlzUtbLZ348R9IVF1Koo2kIUHFaX?=
 =?us-ascii?Q?nTgywrdi0LcCe/49BDzaoYsi3R4wJgvg4lpNx54fzyyiZ11yY3qX5D/gzEbR?=
 =?us-ascii?Q?I5K4+a60uJ2D2c3cyM3+pAckWRErZ+k3ckWWgTbjgjFUJhyWupNppiqECppR?=
 =?us-ascii?Q?M0kqEswoOCKr1t0Ycx1uaPDxrmQX3YagqarPKUnuZCpwRgPw+goVVGAohm9d?=
 =?us-ascii?Q?Yq2p240f5IedDj1lHPXzNwU0/XDUAY7aoMjvod5w3q/zoLS1drO15l2Zu4gW?=
 =?us-ascii?Q?8kWOmDrcOgNRO5QNReFvZF/KabGY21H9YiUS7x0tgi6gzwZaWk1YH723W9Yk?=
 =?us-ascii?Q?agSn6Mff6cJhkRqNVR+kT+Iz8O7xI7inI8AgIjoYK5vAn5xX45JrwgoXmI7P?=
 =?us-ascii?Q?qqbqD9jMyCzHse1KjpqlnOy8rXfbjnFZNP7UAbmNuVJX7I0D2BRLK8nvPFkh?=
 =?us-ascii?Q?/HMT6k60k48K0Wiq4Pt79mfJRPMxuIUFeSJg2Ed1jglNj58Hs5/2coEdviHN?=
 =?us-ascii?Q?dbLEN6B7cqRcWSWVNZB6tCe46o1v5zsrpiirNBHJjDKwEEx30HsYDAeEmwMN?=
 =?us-ascii?Q?uopSOn+yw0B5hFbfCJgC9MDaKvJW1hk6bBd8i2/v3gVHCgml8Nhj+IaSCYxQ?=
 =?us-ascii?Q?jABTrBJBknP0wLmwFoWtjINgahQqCkU=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f1d9992-7cb1-4d42-bcef-08da17958353
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 06:20:14.7840
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KeN6NhP6mMJpcu1bZR/uer32pH0sgIJw2CzTsYveVXs+YsKR5v3V8GUgjc3NuRD7v9fay1ILILuNGtk0DlZw/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5564
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-06_02:2022-04-04,2022-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 adultscore=0 phishscore=0 mlxscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204060027
X-Proofpoint-ORIG-GUID: sPbQ3zbWpTuiHtzZ5JOk-wjgpQvrYiJU
X-Proofpoint-GUID: sPbQ3zbWpTuiHtzZ5JOk-wjgpQvrYiJU
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

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h     |  4 ----
 fs/xfs/libxfs/xfs_inode_buf.c  | 17 ++++++++++++-----
 fs/xfs/libxfs/xfs_inode_fork.c |  8 ++++----
 fs/xfs/libxfs/xfs_inode_fork.h | 32 ++++++++++++++++++++++++++++++++
 fs/xfs/scrub/inode.c           | 18 ++++++++++--------
 5 files changed, 58 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 66594853a88b..b5e9256d6d32 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -924,10 +924,6 @@ enum xfs_dinode_fmt {
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
index 7cad307840b3..f0e063835318 100644
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
@@ -405,6 +407,9 @@ xfs_dinode_verify(
 	uint16_t		flags;
 	uint64_t		flags2;
 	uint64_t		di_size;
+	xfs_extnum_t		nextents;
+	xfs_extnum_t		naextents;
+	xfs_filblks_t		nblocks;
 
 	if (dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC))
 		return __this_address;
@@ -435,10 +440,12 @@ xfs_dinode_verify(
 	if ((S_ISLNK(mode) || S_ISDIR(mode)) && di_size == 0)
 		return __this_address;
 
+	nextents = xfs_dfork_data_extents(dip);
+	naextents = xfs_dfork_attr_extents(dip);
+	nblocks = be64_to_cpu(dip->di_nblocks);
+
 	/* Fork checks carried over from xfs_iformat_fork */
-	if (mode &&
-	    be32_to_cpu(dip->di_nextents) + be16_to_cpu(dip->di_anextents) >
-			be64_to_cpu(dip->di_nblocks))
+	if (mode && nextents + naextents > nblocks)
 		return __this_address;
 
 	if (mode && XFS_DFORK_BOFF(dip) > mp->m_sb.sb_inodesize)
@@ -495,7 +502,7 @@ xfs_dinode_verify(
 		default:
 			return __this_address;
 		}
-		if (dip->di_anextents)
+		if (naextents)
 			return __this_address;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index a17c4d87520a..1cf48cee45e3 100644
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
@@ -295,14 +295,14 @@ xfs_iformat_attr_fork(
 	struct xfs_inode	*ip,
 	struct xfs_dinode	*dip)
 {
+	xfs_extnum_t		naextents = xfs_dfork_attr_extents(dip);
 	int			error = 0;
 
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
index 87925761e174..51820b40ab1c 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -233,6 +233,7 @@ xchk_dinode(
 	unsigned long long	isize;
 	uint64_t		flags2;
 	xfs_extnum_t		nextents;
+	xfs_extnum_t		naextents;
 	prid_t			prid;
 	uint16_t		flags;
 	uint16_t		mode;
@@ -390,8 +391,10 @@ xchk_dinode(
 
 	xchk_inode_extsize(sc, dip, ino, mode, flags);
 
+	nextents = xfs_dfork_data_extents(dip);
+	naextents = xfs_dfork_attr_extents(dip);
+
 	/* di_nextents */
-	nextents = be32_to_cpu(dip->di_nextents);
 	fork_recs =  XFS_DFORK_DSIZE(dip, mp) / sizeof(struct xfs_bmbt_rec);
 	switch (dip->di_format) {
 	case XFS_DINODE_FMT_EXTENTS:
@@ -411,7 +414,7 @@ xchk_dinode(
 	/* di_forkoff */
 	if (XFS_DFORK_APTR(dip) >= (char *)dip + mp->m_sb.sb_inodesize)
 		xchk_ino_set_corrupt(sc, ino);
-	if (dip->di_anextents != 0 && dip->di_forkoff == 0)
+	if (naextents != 0 && dip->di_forkoff == 0)
 		xchk_ino_set_corrupt(sc, ino);
 	if (dip->di_forkoff == 0 && dip->di_aformat != XFS_DINODE_FMT_EXTENTS)
 		xchk_ino_set_corrupt(sc, ino);
@@ -423,19 +426,18 @@ xchk_dinode(
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
 
@@ -513,14 +515,14 @@ xchk_inode_xref_bmap(
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

