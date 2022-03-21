Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 150DDC433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Mar 2022 05:21:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242087AbiCUFWr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Mar 2022 01:22:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344399AbiCUFWp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Mar 2022 01:22:45 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2091D3B554
        for <linux-xfs@vger.kernel.org>; Sun, 20 Mar 2022 22:21:19 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22KJNiEx019422;
        Mon, 21 Mar 2022 05:21:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=zdGyEC5/oPROdA3TXjcy4dnwdbJFaJX8vhp2pJR2CUs=;
 b=iY1xqJhopxpCIP9o9yT5w7ySwApOKH7AmL1Y3Ml8oT/t1gmmRRpv9WLH91DjdD1jQ/kg
 zSr3eNvnx7qJ21+zT5mrOomf9W7aEcuAGs3zxSBgX1lTSQ7nsZPMoCEj/DSxfxjT4QKV
 RXc7Vn4t7C8JQQHzzBuPTWcECJMoiugNcHgnPoyrxnrt+XH+lVPTC9VEFbZYnVSuVnkv
 5c3meb+fQy1QIL1SD2fsddW0bFo54rY6sRNmDCkEuQE2psIaetfL1pbhJqFUhkmEoaIN
 2MXQAJRs37Fn8DWIaExV1JwRvYaddGbsDtsEPfnFnIP93+NznC3e2VpqRTP5rt04waHG 3Q== 
Received: from aserp3030.oracle.com ([141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew6ss23jt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:21:13 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22L5LDjq125310;
        Mon, 21 Mar 2022 05:21:13 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by aserp3030.oracle.com with ESMTP id 3ew578rnve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:21:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I1JQdfvP9qHccwTeZzadYOmHt00fgGH/iWYOxscrTYGP6lZd+zcKxvHLj52kRKkv8c8IeK1B6MyQqRpk6N3EwZkWvMmFxKaOUvESAdyMaNKHqj3My/UKHbbgLaFzcbFH4wkq+O5JsKC0gaj5L1PSvVILL5OvaHO97Qjp7pTO5bfLTXXZXvdYI0KFfgpYfK9prsh+AQw3MUCF8lcGtdhorTYCF5Sl+lxrj+IqTc+TCqTa1IZRv9LxpMqv2hphB8VajdQbeeBxhF007gLTr6DUOsmoX8FuR5Z+FfHbyJ6C6P5gmZa8wR04XRs36ZWn8EMs8I+EmIRs4ORd2+b4x06jgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zdGyEC5/oPROdA3TXjcy4dnwdbJFaJX8vhp2pJR2CUs=;
 b=NFWw8EBph2kpiNBXEjMelzwyOhmEqkb8cz6JmEcm0UNzL2hZSKguJIn+mV+8JTsE6To9bL+M9Ko5bIfLmrYnDLyWoZe7BUalglTcuFef41Ysrz5GuwuAMPp3aoOqx30kyBxrSXBo2/xlJIwXrxFYKirdaKC1qPK3zq+oFqtUOZLCgSSVvyWoFM0PCjOkGlzDG5VOqWFs/IK6JRBZvwEk1f5CvVOGtA7ai8piIRXK4JYwKdIaKU2UNn8+u8Y+EW6ur1/a9DojsKqC6cCcOt4MbUCPxC8YAsvGuNOYMw5BPu7Sh1HQro07Ev5+pvlRyumukn/oLZnTMheWgP0Y+1DMLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zdGyEC5/oPROdA3TXjcy4dnwdbJFaJX8vhp2pJR2CUs=;
 b=OtDVVzkicR/n2JRc9sCv2k2NsbCYCG6y35Yp2TZrIj+0J74u5QKI57O0mWCKHgxaf1eIt6OruA8EIJn/4REvG8o+9mgvkYfYcKCwUvZ9X7xzpyyY4F1iudAnpFZAtd10IvK7FEj6Py4eUwYghg0xqitMOQhPa1LsKvcjc5IqrnI=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by PH0PR10MB5563.namprd10.prod.outlook.com (2603:10b6:510:f2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.19; Mon, 21 Mar
 2022 05:21:11 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f%9]) with mapi id 15.20.5081.022; Mon, 21 Mar 2022
 05:21:11 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V7 14/18] xfsprogs: Enable bulkstat ioctl to support 64-bit extent counters
Date:   Mon, 21 Mar 2022 10:50:23 +0530
Message-Id: <20220321052027.407099-15-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220321052027.407099-1-chandan.babu@oracle.com>
References: <20220321052027.407099-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0004.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::22) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 440d29ab-e3e1-46c3-8974-08da0afa9c8a
X-MS-TrafficTypeDiagnostic: PH0PR10MB5563:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB556338736D4177D9C1D66889F6169@PH0PR10MB5563.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wai9YK10httCBGM7dXa68SPYXnA+JYrx2+1z35T53rqVgXrLZg7pZzJLPrw9wXcOW8Tvme2Km+rzjPn8a4CjCwKLWNRuaL9qKIrDRhKzm/WQK2y7w/5mw9YFw8n1M+0qFoFlhK4hRI21n/XhRie8k7mvsbl7IJnGRN+Cg/GC/CFr0tZjW/XwZzRWtiGUo+OReLyVzH0FtDpsprYolhbctpmX6yjgGeu0mWbuq/MnqFKz/Cg4CVYazfKGTTWC2LBW5u29S8R1citHP5Q3tzG0pHCzeBBkH+6teLCXcLZn39mqYsy1VnQzTpM2FEj0bnzhJV8qN41IUmZIU+GUgHpv2rNFJo0jt2qzbw2WXw0QQnMQMw7WGkZWmQw8/yTdqM9/LV2QSOJkJa/ecU38lz4Z/Acmkk4/T3G/wCYJ70odgmC7+MZ/+IN5t18iPZIH39gq1CJwCF/nvfJXL7BKyu9vlcK7mMakcWpDp8zrUdkGDkYjUYo2cG+pz4P0s4d+9ygcuKopqMNZ/gwohO4Zroxq2xsnUwlwVlhfJrgN9o5pVd4DDeX3dT9nMou4ArHH+lZiz6Zd+FDH93ZFrpF2KAwOI+vVfls+T/vKYaci0zLp8uLnBWaSBj9hZ+BLfsDqzP3LqvgP1oLnlrN3e36VTNRV7xzWfgftOD1sa1YIEiXIl4nqK0vNm3uL7tCl9/UMMOyljS6Odke7W717Z4MtWkLO/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6666004)(6506007)(6512007)(86362001)(52116002)(2906002)(38100700002)(38350700002)(6486002)(6916009)(316002)(5660300002)(8936002)(508600001)(8676002)(4326008)(66946007)(66556008)(66476007)(26005)(2616005)(1076003)(186003)(36756003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4lbrS0R6vExYuALp+EXSC93IsU1nrbfRS9iInGX3OxLnUhHcvSQAfQRFdJ9X?=
 =?us-ascii?Q?kacuMxSLf3rS6efwVrcQOPsji6VyJ/eppGZOlSlNh6BcAfkqNzWp7hLRztD9?=
 =?us-ascii?Q?QKB941RcZmXz0i4teOs8tv0Rl2vHViIOOEsnLTmf9WCn6RrRVxqlEZDCSKxU?=
 =?us-ascii?Q?dO32Xsu7EyRNo2BlyxHz4I/NtE2dTWaQhu0Sa4uc4OMu561eUU+iSllokAj8?=
 =?us-ascii?Q?Y44LdP1BSMT0QLTNFyBqFzL1oyjg6KlHK5uJLk90yG9PLNv5flddJUaLVMwq?=
 =?us-ascii?Q?pdmayjKN/oTRXu9FlnHb0FRX5oaOeVaMg8XvLF3SZDtaXey7Tx/Dby6LxqZX?=
 =?us-ascii?Q?0ecHhb0I9vzWOpZCqwJpXCuHtXpXblYt1R76vSovABH1Cxs/hbfASQfdK/et?=
 =?us-ascii?Q?MvjvPmoQJdlhH2WWQK5eoRDvYUp8W0JDRmWNiT6NnAnn9ugEE4GEO3NjOm0O?=
 =?us-ascii?Q?64F6zUQM5uhnNVLK8O+HdsV+Tv0RWMJkJqVhBXTJfS/2vXIvsUeUnschJ9h7?=
 =?us-ascii?Q?eSuSMwqKN0tr5UdP/Nn/lw/fGg8bB3afkAV8bYW4dIfvp8qi2xCjjJ3fti0k?=
 =?us-ascii?Q?s3uCTeaPh+3oTV2ACWNx38eBwi92TAbaRdxum71+5HPLr8UNQeUYqaXbqcjC?=
 =?us-ascii?Q?v9IlH4lwuhKTRRYYlLz9PKtAO4mNb/PgoZuft9wWgAQTbSTIW0mz81pxmYHw?=
 =?us-ascii?Q?xGjMO30yU8noyMSV6t8pjc5I3P5vtywENhNMaozchegIicpMyZTLY81iMQOy?=
 =?us-ascii?Q?xa/4jvfvkMPyr9vos6oTC9pH1rdt0BzHr8oIEAd05YZPDyvHQfXVaahLCCny?=
 =?us-ascii?Q?po+FfrK8RjhN3GBVkaqPGNrWqFUjT1VKjc3cMmBJ6MLxyW5/Bziov7CwBsdQ?=
 =?us-ascii?Q?3i7D37LNW2U4DhjBZkjTzmu1SxhBTWWw0AdSCMndmfaWtWL3SWBYMpd776cG?=
 =?us-ascii?Q?ASxgn/S/blphGRJOoLpBqsx2XAzsfqwq2UH62mVcf/jdfeMP+Lt7QzR6RdKF?=
 =?us-ascii?Q?zs9+hUSQMdmcGnjb0G26abG5ga9z0jJP7JdwyjR6DiPNoT7Dy9GHdHl7ZRN8?=
 =?us-ascii?Q?L8LXy6lbl/gVJGlb5d3ONPXhM37zKOlQjSISBv6DgqpAKZ7zoILow8all/xB?=
 =?us-ascii?Q?hybYYg53zGollCYLZiLIwFl98d+gse1wHcCV+oaaz2/yUyITL8fVHmYI1onP?=
 =?us-ascii?Q?KtdW9oBw8G6NMWbfoaYcyjDAuZljEk0bqeCnVjxlaTIO66Ouclee7aIaQecF?=
 =?us-ascii?Q?5FuqdFyO6JzVrNSDByAS8eaDaROYqeOkeyG6adVMwXxa4j7pwzsOE673dpVk?=
 =?us-ascii?Q?hlvxA0CEbA3Y5Jp/n/EujsfT6oKozbG4ptqV/PSxIctIe0snmsPgojN7ZGfi?=
 =?us-ascii?Q?ZIYfTJHvEJ0gTVvJl9pp5WY9IMX8/iJyYO89NxjyNzF3eRabzPG+ZJJtsym3?=
 =?us-ascii?Q?Kw9P+BIVLWWnFYVBXXwn9kYQMcTsfgO3P2vezEJxp3ANyjOv/+ErUg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 440d29ab-e3e1-46c3-8974-08da0afa9c8a
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 05:21:11.3272
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5WAOKci6Q1egKGg00/8JBD+SuGmT8jgq1gifSH6KwaolvRQsoCF8daLGVbdBf0mWrvF0BHdDGZTr8ojk5xeB8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5563
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10292 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203210034
X-Proofpoint-ORIG-GUID: SLvHP6hybGoaX3wT_2ral6sVsp1NYvJ1
X-Proofpoint-GUID: SLvHP6hybGoaX3wT_2ral6sVsp1NYvJ1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds support to libfrog to enable reporting 64-bit extent counters
to its users. In order to do so, bulkstat ioctl is now invoked with the newly
introduced XFS_BULK_IREQ_NREXT64 flag if the underlying filesystem's geometry
supports 64-bit extent counters.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fsr/xfs_fsr.c                 |  4 ++--
 io/bulkstat.c                 |  1 +
 libfrog/bulkstat.c            | 29 +++++++++++++++++++++++++++--
 libxfs/xfs_fs.h               | 20 ++++++++++++++++----
 man/man2/ioctl_xfs_bulkstat.2 | 11 ++++++++++-
 5 files changed, 56 insertions(+), 9 deletions(-)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 6cf8bfb7..ba02506d 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -590,7 +590,7 @@ cmp(const void *s1, const void *s2)
 		(bs1->bs_version == XFS_BULKSTAT_VERSION_V5 &&
 		bs2->bs_version == XFS_BULKSTAT_VERSION_V5));
 
-	return (bs2->bs_extents - bs1->bs_extents);
+	return (bs2->bs_extents64 - bs1->bs_extents64);
 }
 
 /*
@@ -655,7 +655,7 @@ fsrfs(char *mntdir, xfs_ino_t startino, int targetrange)
 		for (p = buf, endp = (buf + buflenout); p < endp ; p++) {
 			/* Do some obvious checks now */
 			if (((p->bs_mode & S_IFMT) != S_IFREG) ||
-			     (p->bs_extents < 2))
+			     (p->bs_extents64 < 2))
 				continue;
 
 			ret = -xfrog_bulkstat_v5_to_v1(&fsxfd, &bs1, p);
diff --git a/io/bulkstat.c b/io/bulkstat.c
index 201470b2..0c9a2b02 100644
--- a/io/bulkstat.c
+++ b/io/bulkstat.c
@@ -57,6 +57,7 @@ dump_bulkstat(
 	printf("\tbs_sick = 0x%"PRIx16"\n", bstat->bs_sick);
 	printf("\tbs_checked = 0x%"PRIx16"\n", bstat->bs_checked);
 	printf("\tbs_mode = 0%"PRIo16"\n", bstat->bs_mode);
+	printf("\tbs_extents64 = %"PRIu64"\n", bstat->bs_extents64);
 };
 
 static void
diff --git a/libfrog/bulkstat.c b/libfrog/bulkstat.c
index 195f6ea0..0a90947f 100644
--- a/libfrog/bulkstat.c
+++ b/libfrog/bulkstat.c
@@ -56,6 +56,9 @@ xfrog_bulkstat_single5(
 	if (flags & ~(XFS_BULK_IREQ_SPECIAL))
 		return -EINVAL;
 
+	if (xfd->fsgeom.flags & XFS_FSOP_GEOM_FLAGS_NREXT64)
+		flags |= XFS_BULK_IREQ_NREXT64;
+
 	ret = xfrog_bulkstat_alloc_req(1, ino, &req);
 	if (ret)
 		return ret;
@@ -73,6 +76,12 @@ xfrog_bulkstat_single5(
 	}
 
 	memcpy(bulkstat, req->bulkstat, sizeof(struct xfs_bulkstat));
+
+	if (!(xfd->fsgeom.flags & XFS_FSOP_GEOM_FLAGS_NREXT64)) {
+		bulkstat->bs_extents64 = bulkstat->bs_extents;
+		bulkstat->bs_extents = 0;
+	}
+
 free:
 	free(req);
 	return ret;
@@ -129,6 +138,7 @@ xfrog_bulkstat_single(
 	switch (error) {
 	case -EOPNOTSUPP:
 	case -ENOTTY:
+		assert(!(xfd->fsgeom.flags & XFS_FSOP_GEOM_FLAGS_NREXT64));
 		xfd->flags |= XFROG_FLAG_BULKSTAT_FORCE_V1;
 		break;
 	}
@@ -259,10 +269,23 @@ xfrog_bulkstat5(
 	struct xfs_bulkstat_req	*req)
 {
 	int			ret;
+	int			i;
+
+	if (xfd->fsgeom.flags & XFS_FSOP_GEOM_FLAGS_NREXT64)
+		req->hdr.flags |= XFS_BULK_IREQ_NREXT64;
 
 	ret = ioctl(xfd->fd, XFS_IOC_BULKSTAT, req);
 	if (ret)
 		return -errno;
+
+	if (!(xfd->fsgeom.flags & XFS_FSOP_GEOM_FLAGS_NREXT64)) {
+		for (i = 0; i < req->hdr.ocount; i++) {
+			req->bulkstat[i].bs_extents64 =
+				req->bulkstat[i].bs_extents;
+			req->bulkstat[i].bs_extents = 0;
+		}
+	}
+
 	return 0;
 }
 
@@ -316,6 +339,7 @@ xfrog_bulkstat(
 	switch (error) {
 	case -EOPNOTSUPP:
 	case -ENOTTY:
+		assert(!(xfd->fsgeom.flags & XFS_FSOP_GEOM_FLAGS_NREXT64));
 		xfd->flags |= XFROG_FLAG_BULKSTAT_FORCE_V1;
 		break;
 	}
@@ -342,6 +366,7 @@ xfrog_bulkstat_v5_to_v1(
 	const struct xfs_bulkstat	*bs5)
 {
 	if (bs5->bs_aextents > UINT16_MAX ||
+	    bs5->bs_extents64 > INT32_MAX ||
 	    cvt_off_fsb_to_b(xfd, bs5->bs_extsize_blks) > UINT32_MAX ||
 	    cvt_off_fsb_to_b(xfd, bs5->bs_cowextsize_blks) > UINT32_MAX ||
 	    time_too_big(bs5->bs_atime) ||
@@ -366,7 +391,7 @@ xfrog_bulkstat_v5_to_v1(
 	bs1->bs_blocks = bs5->bs_blocks;
 	bs1->bs_xflags = bs5->bs_xflags;
 	bs1->bs_extsize = cvt_off_fsb_to_b(xfd, bs5->bs_extsize_blks);
-	bs1->bs_extents = bs5->bs_extents;
+	bs1->bs_extents = bs5->bs_extents64;
 	bs1->bs_gen = bs5->bs_gen;
 	bs1->bs_projid_lo = bs5->bs_projectid & 0xFFFF;
 	bs1->bs_forkoff = bs5->bs_forkoff;
@@ -407,7 +432,6 @@ xfrog_bulkstat_v1_to_v5(
 	bs5->bs_blocks = bs1->bs_blocks;
 	bs5->bs_xflags = bs1->bs_xflags;
 	bs5->bs_extsize_blks = cvt_b_to_off_fsbt(xfd, bs1->bs_extsize);
-	bs5->bs_extents = bs1->bs_extents;
 	bs5->bs_gen = bs1->bs_gen;
 	bs5->bs_projectid = bstat_get_projid(bs1);
 	bs5->bs_forkoff = bs1->bs_forkoff;
@@ -415,6 +439,7 @@ xfrog_bulkstat_v1_to_v5(
 	bs5->bs_checked = bs1->bs_checked;
 	bs5->bs_cowextsize_blks = cvt_b_to_off_fsbt(xfd, bs1->bs_cowextsize);
 	bs5->bs_aextents = bs1->bs_aextents;
+	bs5->bs_extents64 = bs1->bs_extents;
 }
 
 /* Allocate a bulkstat request.  Returns zero or a negative error code. */
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 42bc3950..369c336c 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -393,7 +393,7 @@ struct xfs_bulkstat {
 	uint32_t	bs_extsize_blks; /* extent size hint, blocks	*/
 
 	uint32_t	bs_nlink;	/* number of links		*/
-	uint32_t	bs_extents;	/* number of extents		*/
+	uint32_t	bs_extents;	/* 32-bit data fork extent counter */
 	uint32_t	bs_aextents;	/* attribute number of extents	*/
 	uint16_t	bs_version;	/* structure version		*/
 	uint16_t	bs_forkoff;	/* inode fork offset in bytes	*/
@@ -402,8 +402,9 @@ struct xfs_bulkstat {
 	uint16_t	bs_checked;	/* checked inode metadata	*/
 	uint16_t	bs_mode;	/* type and mode		*/
 	uint16_t	bs_pad2;	/* zeroed			*/
+	uint64_t	bs_extents64;	/* 64-bit data fork extent counter */
 
-	uint64_t	bs_pad[7];	/* zeroed			*/
+	uint64_t	bs_pad[6];	/* zeroed			*/
 };
 
 #define XFS_BULKSTAT_VERSION_V1	(1)
@@ -484,8 +485,19 @@ struct xfs_bulk_ireq {
  */
 #define XFS_BULK_IREQ_SPECIAL	(1 << 1)
 
-#define XFS_BULK_IREQ_FLAGS_ALL	(XFS_BULK_IREQ_AGNO | \
-				 XFS_BULK_IREQ_SPECIAL)
+/*
+ * Return data fork extent count via xfs_bulkstat->bs_extents64 field and assign
+ * 0 to xfs_bulkstat->bs_extents when the flag is set.  Otherwise, use
+ * xfs_bulkstat->bs_extents for returning data fork extent count and set
+ * xfs_bulkstat->bs_extents64 to 0. In the second case, return -EOVERFLOW and
+ * assign 0 to xfs_bulkstat->bs_extents if data fork extent count is larger than
+ * XFS_MAX_EXTCNT_DATA_FORK_OLD.
+ */
+#define XFS_BULK_IREQ_NREXT64	(1 << 3)
+
+#define XFS_BULK_IREQ_FLAGS_ALL	(XFS_BULK_IREQ_AGNO |	 \
+				 XFS_BULK_IREQ_SPECIAL | \
+				 XFS_BULK_IREQ_NREXT64)
 
 /* Operate on the root directory inode. */
 #define XFS_BULK_IREQ_SPECIAL_ROOT	(1)
diff --git a/man/man2/ioctl_xfs_bulkstat.2 b/man/man2/ioctl_xfs_bulkstat.2
index cd0a9b06..59e94fc4 100644
--- a/man/man2/ioctl_xfs_bulkstat.2
+++ b/man/man2/ioctl_xfs_bulkstat.2
@@ -94,6 +94,14 @@ field.
 This flag may not be set at the same time as the
 .B XFS_BULK_IREQ_AGNO
 flag.
+.TP
+.B XFS_BULK_IREQ_NREXT64
+If this is set, data fork extent count is returned via bs_extents64 field and
+0 is assigned to bs_extents.  Otherwise, return data fork extent count via
+bs_extents field and assign 0 to bs_extents64. In the second case, -EOVERFLOW
+is returned and 0 is assigned to bs_extents if data fork extent count is
+larger than 2^31. This flag may be set independently of whether other flags
+have been set.
 .RE
 .PP
 .I hdr.icount
@@ -161,8 +169,9 @@ struct xfs_bulkstat {
 	uint16_t                bs_checked;
 	uint16_t                bs_mode;
 	uint16_t                bs_pad2;
+	uint64_t                bs_extents64;
 
-	uint64_t                bs_pad[7];
+	uint64_t                bs_pad[6];
 };
 .fi
 .in
-- 
2.30.2

