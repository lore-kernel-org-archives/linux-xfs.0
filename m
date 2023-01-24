Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2C9EC05027
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Jan 2023 01:36:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232132AbjAXBgj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Jan 2023 20:36:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232235AbjAXBgi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Jan 2023 20:36:38 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E96E71ABFA
        for <linux-xfs@vger.kernel.org>; Mon, 23 Jan 2023 17:36:37 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30O04wbJ020301
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=6V8jvoFTXiqb5KGxOUdyTpyXBvusz0Drjv+6VgVQpKY=;
 b=RY8m3gJCi/0S5sJAGU/rZMhyXmvBtt1YXPeTr9WOInQjCGmLxRZXBgV/ymZ/B5312aLo
 OhauY3yaFEcLmpgXXOv/906qg5c8APCudn6UX2RWADEMvx/kQ7Qk0xBFj8zSzjnfO2vi
 5EHFrEyKoWGOYsGvP8aVNEFCkUI6PdxKezyf6UltVFgMv4O+r5ACidQgHufS8Tmwf7tS
 4ZfrAJ53aaghhLVziVRi34rP4NB60Wk3vgdfHtRgrxAxTO4ZNO3aCc+JXbxmw9Z2RUYg
 QIz8f0fIWMnIhvYklLapTeWedEtRE6u4WWx1GUOp4IYQSrAqi2XyR92WhwU4w+wEIop9 NA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n86ybcbht-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:37 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30NMo5c4023221
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:36 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g4akwp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y2pjOz0Bh809ek46CItz46Xb01B2atawMX12bDJK49nIvwliO5/IQgsF9Xy2rieuEBAAloLvtnbbXym+9/5Ae4WZQketNSnEzugrydHllmILH1xZlFYP2u6rrf3uW+m2jdWYLQVsb8VmAqCeGPB0RvIdY1NJ8wAz9VXtJk4F3YI0X9NG6V+ZSxxUyzWcIcjtG+EdI7awjfEkYNh0JEKg8U4RWTjigxZbC7CRChL+tOQjJuRZAEp86s3X10PjHMNTuNctBJb36WY5uS3/3/Eghhaq6hDKw0hkqto8NtSi6ANaZlNNxuVt/s3slm3LEN3jasRZe3ZeFcEZ2j9zJhw3sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6V8jvoFTXiqb5KGxOUdyTpyXBvusz0Drjv+6VgVQpKY=;
 b=Hlr1IYJo3PqgdUCUj/Vs1rtwAQs9Uut5D/wseh0FAeg0tzLMgusgEKLfDqm9D6B6vhCySY9qmV14nSl0yKeO8a2UMXQDx+9aLs5mVMswIF7MucxofbB+hqq9L9QaCR4vRdAM3xekjEiJgK1j1YfKH1N6y+hutapBSccd1jqP4vEBQwyFueuujTy7/P3/mfmb7OWZwVnpVTB7AGxf9TOycL6+l3JnDIHakl7PbRrjK1pcHcLaJMxstr6v7WmIQindClCGYcW0ANt4tp73uM7jF8ZQQnfPe74blIZyCg+dUEyv9m00AWT3otyDhJ0apcuzwCFNPIsKAHAqKSnaUzkwXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6V8jvoFTXiqb5KGxOUdyTpyXBvusz0Drjv+6VgVQpKY=;
 b=NyiUWjV+X1tmSxiTnGPcpu8QbCvUkQ0pDa0xqA1YTlvhjW4LYWdpEtHjk7T76V2sYZrZ2u7E1yLNARRMe4Cu6MXp6D0zDhifERKABLbKbHN7arF6V5RYVmuSyXruZipXwYRSc6mpKIFhwR+cFB9FvNSBDVT9AD2uSz2+AzT9H0U=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BLAPR10MB5041.namprd10.prod.outlook.com (2603:10b6:208:30e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.17; Tue, 24 Jan
 2023 01:36:34 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%4]) with mapi id 15.20.6043.016; Tue, 24 Jan 2023
 01:36:34 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v8 07/27] xfs: Expose init_xattrs in xfs_create_tmpfile
Date:   Mon, 23 Jan 2023 18:36:00 -0700
Message-Id: <20230124013620.1089319-8-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230124013620.1089319-1-allison.henderson@oracle.com>
References: <20230124013620.1089319-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0093.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::34) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|BLAPR10MB5041:EE_
X-MS-Office365-Filtering-Correlation-Id: a2ed2086-b70f-485d-efbf-08dafdab6d6e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3KRNRO9txWXC41tLXfh2as0moubgdAId859BSWPknWaSd5aIKr2vWdg86Zb1dLi7gEPI6gMXVQbEN5qQ7zCOpYEwoeGcknWqo4TYP/UNhTnDcaaKr5FAIOVKUP33qbD7kAQMTjr+lSj/EwkgWxObvf22Bgf0Lux9PHC1vD47PefNL4dobJ9OOHsJxc7k0AwU2M1yPyH41DBUut/3ldGbeNaCDbJB74O02/Ab+gOKJAbv+n6D4tYI9+rqs1kNUAFWtK9zaJ4o3J7t2lxwOFSuDSI6GJ6/qF00lDEOnmfoQNB2efGjhwkUrA3J+dtAyIiGRZ01aS/6NvVoIqR4dTJ2dwZ5sLMU+F2dxo6TKgkN3tHDAY63DTgS/lPeOzhzobUsK2xR6oJ3qcRYxKm7/ONKp47bedo8MSEzCHTqCUu8/CLC6VHpTt6GbzOLE0ftGloKkmvykJvDjCuFF05b9cnVaIa+qhp+TMpt7X0L+RND/QTIskFB862VNrPzUXc8Cp8mpqGtZoUb8pwjBJgDUXpthsEYPnCR8M6VUlL9lH7r8pZVnQej0utX+T16dMpCvuxFUK8IXk39Jm/hV2a+wP0J8q/q8gFEGwCB7yT770a2XsLs5uYbbUmgE6xe6Zzz030gMCgoo6uwfIq5oRyyv2KUiw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(376002)(366004)(39860400002)(136003)(451199015)(6486002)(478600001)(6666004)(26005)(6506007)(9686003)(6512007)(186003)(2616005)(38100700002)(1076003)(316002)(86362001)(6916009)(41300700001)(83380400001)(8676002)(66946007)(66556008)(36756003)(66476007)(8936002)(5660300002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?B+dIVFmhAtxsh74CHdVxEoCksq+uVljAruPGtIcT4kIF7Wa79lQd/wnSI8uK?=
 =?us-ascii?Q?1olrfO//inIttjFp91KPx+vPiPw9EKyrOE8PED6jDL8pfemxNbJPEfHQmglD?=
 =?us-ascii?Q?h57GXDPG3a7eQRcSY4HNPE3sHhGBu+JIGxS+goKnyWkAXwBa+Ycik7NujiUr?=
 =?us-ascii?Q?UqPYDSxjs/Hc34SmGolHItNqRWoEI2q9YHLRHccBP1FarxmT4M08wklKl3Au?=
 =?us-ascii?Q?e1Z4yWRezO8NCIDtN38Kj5Xs1W5TLgabKE0q6FOCUlk0RFQsIRv8dTJfoiol?=
 =?us-ascii?Q?51a3MKQ8O546k5hE6tHcMyk3a7ZBsc7pFF9cGzQubUcTn6/An2Y0N+KlpL+/?=
 =?us-ascii?Q?U6NJOusW7fMYlRGZC8u5sgiG5q1bNy6w25lxBovJklQ+VE6wuuvKXL7mHkes?=
 =?us-ascii?Q?+VdfYnaY8IfFI6g5xtJtomIanORrtl9rS8UTEWT0cKo6F1+vLdHyVOvUFsOQ?=
 =?us-ascii?Q?6pgKJVbTvtrtc4M3z2+iDDiC6kPujxgOgcyGll+FuXUxfTvmuc/jlsa0wBJm?=
 =?us-ascii?Q?225U3MZtp7EXGeYXxPMUTDp9Uc0PfRMwCStVgAMVh5n01tx3On1ImUfDZZ8b?=
 =?us-ascii?Q?udBgqAD2GV6AkaI/9PBB216xsMpiJJnOsMnplf8rEXATiVnMKBLiC/yt3Hgh?=
 =?us-ascii?Q?VQuDLrYXYPrDByfv3AFCuScRUazo0FP8t8WtSe6CU86GvDIt+R8odXMMctR/?=
 =?us-ascii?Q?L2VqwGX/md8DtVdzh49u8aHDtF092EQ2A2wXEXdUTpo/DE9nYM9rAtxLdzwV?=
 =?us-ascii?Q?GdE0oqkGf+0pWTeYqGd7a7JWPgm4N7ovdoDUQKXluizd7qlNhfbfqRRfsG3A?=
 =?us-ascii?Q?cAimIfl46bSJk2BydkICVc3z0viXzKL1s2/SS1ZncT1l0rkqvL4DTSRugaDg?=
 =?us-ascii?Q?FwoZGdzGo3t2LR2QRWJQNsYiDW+mGUbor6+g/jVp8QS6Nv3Keg1u21vWM+RE?=
 =?us-ascii?Q?vZf+v4T2s+/9lFVymB+ro8JGcKJ3HfeJKMLZf7RcyU/C9PBJgnbuNu48vXI0?=
 =?us-ascii?Q?sFAUUNJNR1fVk9ilk6lncRVuweRkvTXup0eDPVCDvFSxBE2PZplKtQ52H35W?=
 =?us-ascii?Q?opUFgcD4NHQ1sUeMaTRUxBwJ5QNcQokQuwwVqCfRxYJnpNekLCUD+rlqsJd/?=
 =?us-ascii?Q?zbRwSXCOAAu34jrf8A/oVZspXnH7fjF/iUv41gfqLZE6NgKqyflA7jtwT9Qb?=
 =?us-ascii?Q?ILk/DtxylJAxONDhP3XmX4J8ju/BYN30I132qzN4LbUfr9zB8tUrdVc9M7Nc?=
 =?us-ascii?Q?bm7zkKurGHxtIZnuB9UdH2hWNxFy4BR99SRLlD49J+1sp3A3DsRkDBlTGJ27?=
 =?us-ascii?Q?EaiumTHYRzm1P5HNAO9u7mJlKYwHDEZg5Sx9wmSZiZXMF6aRU1aKxogn+gBr?=
 =?us-ascii?Q?4obPaai4do9WNsL+4a6Gju/jB+28N4vSk1frY4hDt5KcG+CMXNIrC1QnkARk?=
 =?us-ascii?Q?mmFHzCQ3EWemrQBBNafN3S1ddxSjWgC5w02u6L+fRplFAGhhkdsvPDV32y/Y?=
 =?us-ascii?Q?lv1w4mZgbiu15IOdtf/tx1Km85Vaot8y/U6ZkTv3j/1/m2xIbCUvIcGEw6jP?=
 =?us-ascii?Q?o5s/OAWsrRAqBvCYoMUBpeEFzo/vijkLQhPub0U7oyCBY61T2ygQd9PSiWTv?=
 =?us-ascii?Q?kA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: g51hU7HH8WtftOCbo0g2shNrsNEAO9k5Lc+x8Nza2TzwMQE9pn4KgaajqOwYgWf6lDXvmJy5dU5U1FSSuFot7PYa55C3JmVLjgjJ8gu+q+7x/HnlblbEWF8X2XxmTAgdRDKxPs+iYWL2zWoyqdUzBjTLKyvXotfy1SpPIlsp+DOYc9hCn6tJ4SljY7yjp8gDJSxcWzqzrar+e3YIERf0PfBX/3gjenO3wdOS4QiAU7R1oXGGtgpi5CT7jzjpShllad+3x5/nOUZu5mIoGlhENuCUU7z+JKeYv1kqTMmqVtrK7N7EVDxUcKtBHEDWbf5GVg2UABy27k28FdGncFR7St3EtDxhn+uykqy0wyYBHYe4MZtozn0oijx6geja86kD8Q++Pyqz1UD0YSEuKVmPCcOLgeYKXavg3IFZLNxlKZ1krPoGVu2gktBietJU2Mda6z/iUs5IdpVYf2Twwi9OXFPc/WpITgZY34c1w+PvPrU17K04o+P1b3nhTeL+cC2Kw3jDLU+b7i5GyWYodzmAr7l45wWqFw2Kw1MbZ2Svdd/antn+2R4PdNU54nyVJTrx7unQw/9tCKJOCHYF5ImishJLXBvk4AJmSio9h1cYj6q6JRyWB/ZX6LsULVxi9+to+YLPRtDiGihmshvkhiVtIL3fksuHrW9nAE68asRlO2WKsEvdAba9hKv2c20csgCNAdBSrMk7+cXxQonWtYiBPQ0v3/aWr0iH39xhvhY2RtHN57f0KOq34Prch3suOH5HBAEAsT2kcCYxZVhiC1YQmw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2ed2086-b70f-485d-efbf-08dafdab6d6e
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 01:36:34.5442
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UxOkQR/+6r8bTMC6HdL8naMBWcDEfYyBTlwTpc0zlGegqYd7J2Ctie9Qu7FkdoqiI8A/ICGOlU8qI3zqEygPwSvZuy5IUinb+mvv7vpJqhI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5041
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301240010
X-Proofpoint-GUID: ms0kZf6XBspGALOb8FQHiRHgvt09vKsl
X-Proofpoint-ORIG-GUID: ms0kZf6XBspGALOb8FQHiRHgvt09vKsl
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
index 131abf84ea87..267d629a33d9 100644
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
index 515318dfbc38..45e66c961829 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -200,7 +200,8 @@ xfs_generic_create(
 				xfs_create_need_xattr(dir, default_acl, acl),
 				&ip);
 	} else {
-		error = xfs_create_tmpfile(mnt_userns, XFS_I(dir), mode, &ip);
+		error = xfs_create_tmpfile(mnt_userns, XFS_I(dir), mode, true,
+					   &ip);
 	}
 	if (unlikely(error))
 		goto out_free_acl;
-- 
2.25.1

