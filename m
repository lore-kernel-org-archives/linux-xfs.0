Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9686C7619A
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Apr 2023 03:35:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbjDKDfk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Apr 2023 23:35:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjDKDfi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Apr 2023 23:35:38 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE8CA172C
        for <linux-xfs@vger.kernel.org>; Mon, 10 Apr 2023 20:35:37 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33AJjrCR026583;
        Tue, 11 Apr 2023 03:35:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=A7AYU9m4g33wNtkYBX9ICDexG4DM0VCQBvf0HyXfPrI=;
 b=HaBKEsnlRReuPCKLRxVpMpPIO/dr4Wel/hibNPuVUD6a5epHLyBgV7nCaHy8v4JJ1qW4
 mEBDcdgckqBJx8ppLRnEc9BNWo/+MqU50giaKXHFYagJ/NnyuMrOFAbQJjdeu3SdcchW
 pW9cF1Ow/U1pa4k7lNMkUw7VrgmhyQk4Pv04GtyQBigo378kg5eSwMMo7ErGSFK9W3pX
 KDupfCZqcUfLVfv2KPcc4dxXAr/C8+QWWbf2ODGhp0HOPeghq0MHrpSbkrjkciXuwwpq
 wHj46K06brE7zXo0ufPwha47q8VJ4ATMtHZhByy4wGQ+agNDhX/kCj+wZoRlXflKaFuZ 3w== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0e7c8wv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 03:35:34 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33B0iYSX002335;
        Tue, 11 Apr 2023 03:35:33 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3puwe69977-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 03:35:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mU3N4zPKbMsl33CkbMFBvf+sjjgTP7vAi1T8SXMtbXgkRMBmEDpVUfhE86ntQ8kOdKBqr1BIdPAHdyTHuIb5SoRsN2otBdz8tabpU8mYK7tfTPeXHRglRzSKFn+rDf2/PmeH/osUf0l6umy6hlamCOkLKdVShPmEGQDyv28S1xJWp4Xtn0idlh76bg5GfGQGwCBn13meEDRTAKXBGeqQvQ5N2t24lYL5NcHrxsSVLcm+xQYwbiW5JbuZc3OhVPeIBi5L6fsGhNDoNDA91bVFoq0hlVMB4wePfqjrmJ4NtI/uNUC0EkEqbrDoSqBbkl2cygU7icW4PpfQvltqA6JU7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A7AYU9m4g33wNtkYBX9ICDexG4DM0VCQBvf0HyXfPrI=;
 b=UWndrthUQjeljKfZd/xnUHFxMoKUM6WTkMtiwaaR7Hs8O4ZLchgdgkehZ3dnzBMy0POxLFII5EFMzKQLIXD2xD8htxR5cR7i13rnsl4mQ+w6425XnhFY4s9/hSoxU6m/IDpW0SUDObC1VgdF+070bKqOy7Uu4kkh0jcMzEX92d0w4eIvkQBwisslvb1AOqtEqIOsLcQLSXUhW146tnSQfBygDsxl4GkA9/vyl6eWdHpyYx24zJIRWaJ8KnHuZ/CyilnNqx7ccDv6RkncZaDv1HhbJ0KozZTLgY5qERcvgudBaiPY2iNnzg7Bpp+VCMcL1r57yY74eZ9DfiyxFywPPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A7AYU9m4g33wNtkYBX9ICDexG4DM0VCQBvf0HyXfPrI=;
 b=XYUed/ijZKwY86s91X2s0U9TQJnt7+bWZ1AAdgOvqwjbtOQQ33+BIFTdHps4UJjmueiiQjHTRt3YP9BekZJKt4m12oSETRjPPpnV1nWKr7DfWYLq8X8Fhq9a6w0ecEvw+RHUX0WRJN4bZ7U/+LIDRga0vEUTaMkQfUewJecGw50=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CO1PR10MB4563.namprd10.prod.outlook.com (2603:10b6:303:92::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.34; Tue, 11 Apr
 2023 03:35:32 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7%3]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 03:35:31 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 01/17] xfs: show the proper user quota options
Date:   Tue, 11 Apr 2023 09:04:58 +0530
Message-Id: <20230411033514.58024-2-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230411033514.58024-1-chandan.babu@oracle.com>
References: <20230411033514.58024-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2P153CA0038.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::7)
 To SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CO1PR10MB4563:EE_
X-MS-Office365-Filtering-Correlation-Id: c91daf91-a2ab-4655-b0ff-08db3a3dcd60
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rrM7jqXAxQt418YE/4ParkufdIRKOMUhdprkn3YrCurv3+uu9mHpbP2OAqv8zGtsl6GL/kbXZYoqxZpNLJ78baNmZ+HISOYkWCIH6mWm63RS1Sd6q3cKUTdtbjh1knDAPVSNMSzjTZt9ldbLxV0KAfcbJJg6oOY4fC9Hrung3BqQHN7K5nPDVAxpJ8qDg3JD+9/Srtz1J/i4oIFjrIl03gmRu/sPPDM0SV5jd3nICX0GADG1HiCJl4l2M2rBG6obeiS+DjdbVpKTidbERE0s8RaMi77XRLD51vtzp85sUM0qwEBH4QXCtDnrfxv/PU2AuG9Gu+6OwnKlgjxwlf9ml5lV/F7FQLcm8tlfkMfRfL8tbfeOjpjSGcd0Cusk6J3sjnEvKlU9dmsIvjrA0XjS+0fJmIhkllsz5GAMHRB6V8jwcT1HWm43N2QXzFj2TdrQsQvs8wCNJ+O2+nvvh4ZiVxi235JIuXWxOugpRHIXyqTbFUTKXHOhwXU2LWZ783zZJ5XkbzBZEeYmCjj89PFhLmBnxih7riDs/nBQ4mBtDJJaZGdbdHEe8h6GSXCRn4qT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(396003)(136003)(346002)(366004)(451199021)(6486002)(4326008)(66556008)(66476007)(478600001)(66946007)(8676002)(6916009)(41300700001)(83380400001)(316002)(36756003)(86362001)(2616005)(6506007)(1076003)(26005)(6512007)(6666004)(15650500001)(8936002)(2906002)(5660300002)(186003)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NhiIcUlToV44NA+nj7/xnAVpNymsM1LMC9PrB6r0+ShjfNNAddVsQV5MUA1t?=
 =?us-ascii?Q?Oy9aMhBeVEqVh+iHa2m9QlCSYwPdIFXumOqClk2yN/y98/++mPREAS62gCd0?=
 =?us-ascii?Q?43DGqyPbcvcfjTswhiEDhYrr3Z/ZEd2okObUn4MJrlSEpZijB0Gzn0nws6W4?=
 =?us-ascii?Q?44w5TeZ0Sy3yVwzFsXa+DDTNnDEU1kp4/ALyg7n6cm3Fw81gHZf9iMdHDrXY?=
 =?us-ascii?Q?1o1LDmEtNCjThuvL5H53AvyiKMG9HLXlEGaZg69CWcWo+GLo2xY5URqwPnQk?=
 =?us-ascii?Q?2TtPguB7XfxvN2Pv9VE7APm0GeXEiGfHRTOnDoOuqiCR34oBwQkKKKU26RLs?=
 =?us-ascii?Q?9MjVloZe817t6+1jeFBY4jPJ1t1diB0hCpYQ1RYTqiopSIx+VC3CJSCDcus9?=
 =?us-ascii?Q?XngfO6WkaWMHN+oigc7af5Nl36kZbQ54iKWd4tjOjIqDrq52cfJ4tMmYDRMG?=
 =?us-ascii?Q?k1GMCO/9rx0XjmFBkT219lXGiI1s2ikA86/nKIihyx7xXDxUj1l7Xu3Wjby2?=
 =?us-ascii?Q?LlPryb3NlGwGXxotcoxxhcsyTKdpcQAmE9fj5zZJP1M2ju6ySQfFqizzXY+w?=
 =?us-ascii?Q?sDK80L9ooR9QeO9QSli96QmvvUWpC8Owk5omagEnSRsn+6Gdbdc3PVzgksNf?=
 =?us-ascii?Q?GLrtvHiYZxGomIjNAVJaEFeWCAzswu0+ot5s8994KkBD4PSPOvM3CRclWdDy?=
 =?us-ascii?Q?vmW7zySrOalfIdSeW76wU+y1ZjxjpGP2hzQWFoA6/3QVywprOKUDkKZFwUzu?=
 =?us-ascii?Q?T9cb9Zpa72HdqTdKvaN2FdFd4Hs21bFL04KEg3b6WGDBIa1vhyWflZ2i20cy?=
 =?us-ascii?Q?qgSIPZpMfnR2VP5qqwSqQkaRuqoAofEj3ePjRtaUEcn11mxphiplEaU7po74?=
 =?us-ascii?Q?7BxX0SgtnLxgH8AC3tQvo6ZCao4xxsOE17oKpwdDyhkVesldK94NCkfMgm8K?=
 =?us-ascii?Q?hiGvRZtqsuvrQs5KNh2x6KTTjzKRaI90M0BP9FYKwCJa723NjLGVX1Ad9hqF?=
 =?us-ascii?Q?O1gUVvBJfWYXdqo4oelYLtyvH8Urwv2cGYRHo2s5uNlgvhDT04faYc7ngWV6?=
 =?us-ascii?Q?R8ljj3wndj1IVTTui/veoBvZdUg0mPgvqnkvnhuDj3k1QSQweEhZxn/8xckZ?=
 =?us-ascii?Q?vBqWU0ZFvjfurEWn71/4D7tZm/uoi600zDdJyYTVxLwCdBuR7ltbMVui/Uvg?=
 =?us-ascii?Q?AdClBPYRhQlpML96TDSVxbO7f5Tj6BalFIMXqZuLuDKpOM6WOVEOBRlBrsrS?=
 =?us-ascii?Q?yN9Az3Xiq3Pc3CULXUB3NA0MuijoV3t/t1+r4XgHCUGNta+Iqu4CxCC0QkZI?=
 =?us-ascii?Q?c9qvgyNCaFcx0nwUd2uTm2vISMJwFgGnPPUTL4zYECzukzUgTrHtbqbBNF5C?=
 =?us-ascii?Q?B4Uuv8JvZm0sHI4jX+CeHD2nLhXq3P5YD/hcu0oL+xRX6OxB8AdGCCXeHDNc?=
 =?us-ascii?Q?ALgUjLHloQXlScDSqUCEab9AcS9y6O4VjRv7Z39eVYvwJZKt7Fe25yChDyR6?=
 =?us-ascii?Q?XzcyPRzmWdYf9yWsor5hoXvNWi0prC1pV0YPQCCRIRgo50p1DjrvntQFjm2r?=
 =?us-ascii?Q?IpWZaXzLeO8Bh1PF+Ex2CH5rVDmrBsb3QL95Zfs2?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: DJ2iZKkCOHjRkmkTjyqnYER4w+oRLAbgLa0YQj29B0tB1JJxB/HLdJ2kZfLFzX91c4gAgFH2JDsWSYDHI6HuCl6PYnayQjrcm7N5lyVpqFDl1G0pB01YBmMWrthRoqzQYinEgcQxwoHZTIPAO/ZAcU9UmxqFFICI+qIzaZUNfpUm3ZsTgNbo+bli92zwkB+EP3C7mm5cujxH50KsIaB8MND/KvGfSgWlWte4L14xr6FZT+SPDu2COOKRHGWNJO3uq32dIUzY1duYGG8LD24xQje26/vvOIDGtaO8yGtNXYE/6bfShIbDDM6W+eFnGrJVkd3uQ/MYEFfje/o674h9L/cZpu8sSs+R2Lk9dFV5Ob1URIGRn850q8PXha1I67MU0ydnUgRftVUkuIw5Yvs5WNWDBZeFA+Fi7pKVm/CsYtITlksog/x6xz/fC+QCosbIL8wM+w9TX2vZjwTpcfdlGCh0+m9C3EGsXN7Zv2eslpcbgEKIGXdxLAVv+dDF6KyFPPTImdEykJuDAo/SesOFx4caHp7nMSfmXrA1w5UWwxUrnt86u6kxu8+pG4i0U8rudAbCt37mAy3JUAI3TR6LaINER4zJCCdx0C2vOo87ksjk+psR2sZtEnVQtjMEFS2Q08G8/uFIOZsOJRVnfTxrzBOX9uDthe9U/c6xknQ+BqWrq29ppau/deDL/KYFstujWkXMtnOHkg/KX3UNU4jHtHP/LYqk0tq02B7W9/gTFXnrQTQ47YB1iHRxGjZPqidScC9bpsNzuoZ0FM29hCos0kuFnEG0TvFe3gIh00cSFMFzkwKPDU8VoG2EWbTo4SaQ
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c91daf91-a2ab-4655-b0ff-08db3a3dcd60
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 03:35:31.8821
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ao4lmE+XgzffNh0/xlVWnFJMIijfBlSjqqE3M7BpzG8UUqqcaZRppNKcCRcAZzTBg4L38SFnQmfdhKxGUzzlVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4563
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-10_18,2023-04-06_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 adultscore=0 spamscore=0 suspectscore=0 bulkscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304110032
X-Proofpoint-ORIG-GUID: 7UDDd03mYQ-hx16pBLJvIZ_LekR1QbjD
X-Proofpoint-GUID: 7UDDd03mYQ-hx16pBLJvIZ_LekR1QbjD
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

commit 237d7887ae723af7d978e8b9a385fdff416f357b upstream.

The quota option 'usrquota' should be shown if both the XFS_UQUOTA_ACCT
and XFS_UQUOTA_ENFD flags are set. The option 'uqnoenforce' should be
shown when only the XFS_UQUOTA_ACCT flag is set. The current code logic
seems wrong, Fix it and show proper options.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_super.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 9e73d2b29911..e802cbc9daad 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -490,10 +490,12 @@ xfs_showargs(
 		seq_printf(m, ",swidth=%d",
 				(int)XFS_FSB_TO_BB(mp, mp->m_swidth));
 
-	if (mp->m_qflags & (XFS_UQUOTA_ACCT|XFS_UQUOTA_ENFD))
-		seq_puts(m, ",usrquota");
-	else if (mp->m_qflags & XFS_UQUOTA_ACCT)
-		seq_puts(m, ",uqnoenforce");
+	if (mp->m_qflags & XFS_UQUOTA_ACCT) {
+		if (mp->m_qflags & XFS_UQUOTA_ENFD)
+			seq_puts(m, ",usrquota");
+		else
+			seq_puts(m, ",uqnoenforce");
+	}
 
 	if (mp->m_qflags & XFS_PQUOTA_ACCT) {
 		if (mp->m_qflags & XFS_PQUOTA_ENFD)
-- 
2.39.1

