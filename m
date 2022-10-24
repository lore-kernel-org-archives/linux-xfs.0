Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2283C38A2D
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Oct 2022 04:56:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbiJXE41 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Oct 2022 00:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbiJXE4Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Oct 2022 00:56:25 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F87E3136C
        for <linux-xfs@vger.kernel.org>; Sun, 23 Oct 2022 21:56:24 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29NNSDxp016765;
        Mon, 24 Oct 2022 04:56:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=tvVy/Ug3q4bviRn1+mTW3LKx2H8tQb/S75gp8nXq1ho=;
 b=WNTcgheN3+a7YRPk6S4ckrnxUaSV+6FX4Oq4jFhqf16JhQQDIzLl4vkPRe6m6txnJsbL
 EeexAeSSC9CtMlJQpT76xo5YFCfNltu6NDTQModRcQfuodFPS8Emk0PFO5U9WMRxf0UU
 AxMBqdNKnA8zfi2poc6I5937yNf8tnZQWTKuZo/na7L/zJLiitmOwszq7Ig9kWyFSXJz
 Cba4O2aBktuS+r6G+ZpGOuSycUACssd+lM1l+WPAA5IdaJhi4k53WJwzV5pFv/J8scJv
 di776siUNi4MMtHoY2Zbw+kZla8HVw8hx2gLnIWr+8bice+Yw1aFdIh/RDaJXAKwMKW8 gQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc8dbasbd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 04:56:20 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29NLTuW3015427;
        Mon, 24 Oct 2022 04:56:20 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y33783-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 04:56:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lv3L7eL1RHATmPOVIxN18iJzy/rJjZ8qvbvLYLleNQnqkvValMjzVyM6cbya6swjwa96JkG7cdO0zbs4PbYj5NOyYYC9Heg3RdQoZKheNzTRCpSFmfkUr4sVkj7gzzNFJIGo0Otw0B2n8Y1oNODfuud0jGY9b/cv5Xjfv9fCfi/8jA8/2zHIWe19gJeZTb638gzazcFfrwcaFCbe3Bs8AJqa5M0HHihVf546t0DpddCQwzaJVsTnz7ZhDN0+qURLexHQHdYC7kI5383TGhFmwq24m6RiIQaD8JnC2ecSl4nMzQfNk6X87oMhFJ9ICcMPpAGCF+yq0Ju7/r7cHm3zcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tvVy/Ug3q4bviRn1+mTW3LKx2H8tQb/S75gp8nXq1ho=;
 b=fMZVfGYaNWNZ+8SySnwdDhzeQOkkeAmup6m1fmRhPcC0DULOT/MfhDj/99PKtyKJELsEcDCP0pcVFZJ22lKVKWKI31Rc9J//kn9IjVpbFdlvrhI4CeqgE8/5s8jQzlKNLjLqS4GAuyQk1oIflClg7cmjJ66MSFqR0d61fqQgC99dQeJ7DK5RqsArphQzlG2pPvnJT0xqWSUmrxY7xygON78j0VplAD3m89uonbRcthworhTTb5IVTjF6QDiGOk9hYuMvlD+chMxVEMWCPVKl/HsqcimBabQPnuKdoFzB+DMHm+k///eSFyFQVFTN0bKHN4VyxKNGzUdQJCja6Pd7HQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tvVy/Ug3q4bviRn1+mTW3LKx2H8tQb/S75gp8nXq1ho=;
 b=POJR1dK+SzzKhqQEyaaSj3QzzSMHOf3Dj3f74v4eFGajVliFWe0FuPr3AEgQHVikx8eY9kzltVxO6pFqAeQlVPsV05fIsW+ye2R5JrMrrL/dB+gDgln6U/Al3Nd3QwZ7L6CMrauSUKMK7cKY6wyLUfusCF38JEHRtueKdJYgj4w=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CH0PR10MB4906.namprd10.prod.outlook.com (2603:10b6:610:c6::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Mon, 24 Oct
 2022 04:56:18 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c%6]) with mapi id 15.20.5723.033; Mon, 24 Oct 2022
 04:56:18 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 24/26] xfs: reflink should force the log out if mounted with wsync
Date:   Mon, 24 Oct 2022 10:23:12 +0530
Message-Id: <20221024045314.110453-25-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221024045314.110453-1-chandan.babu@oracle.com>
References: <20221024045314.110453-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0051.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::6) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CH0PR10MB4906:EE_
X-MS-Office365-Filtering-Correlation-Id: d12f535f-c988-4ff2-ee9d-08dab57c163c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WqgWETmjZ2f0vfZ2WhmlGlz/M5+a9Fp7IZTitJ8CJ+6MJC2KMQffnxMQeNNAq1bNuumwq468+j23TX1dDis0Wpvltv6UwlhVL6y+W67VbvPt4koMNQkdtegH04o3wocPwcpGtSM9yfxly15pC7fYumCDpJQKiU75oEzYjxjTnHakA2NJNQRsoftWKrBNON1yXQD0flGRuT9nMtJcXMtJ0Un5GsZFIHsGx8QxB7DsBVnISfJV3VoC7QdR4YFEDCuKbvhJToMxgA3DuujiS9V+3SGg1/LCraCrel7/todbPyr0e8hMajo1E0DXd3Xn6R8KzuX77hkFGFR6mtO0QRNH0NxUnTKGtl3QODw6QcX7pkdYZKLiKQTgT5sglX/E/05R3FElwCR8DXSyzjQBqG+4MWmxo9S6rg1kJVQKk3c8IKXFEpJ3wtl+OvY+MNfqPu8HZOnGSxPZWnf/wUKLcPYAOkDytxZwJYByfgdmDblKy4p1h5mviOIRLwLwyzmD77z71Bcy3pZV2pRGW/c4hPOxVyidQJA+o6Uj83j8tuNrOE8mozKlosqLQeqpgNIY3auoKfSTZomGtMvObrxCoctBSb1c3MIlb5kq/13dvlrirtHYoGqoFYFNBOzgxZ9IFcN7Sn6BR9jKid8Hbw7DRl4zdvwfJtSUQ2LBQsNZBEWsg301wzAWfjTi02npctpNNGNmr/cDRWQTn1UiEYC+nPiDPA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(136003)(346002)(376002)(366004)(451199015)(2616005)(1076003)(66556008)(66946007)(66476007)(5660300002)(6506007)(186003)(6666004)(83380400001)(36756003)(6486002)(4326008)(478600001)(8676002)(38100700002)(86362001)(41300700001)(8936002)(6916009)(2906002)(26005)(6512007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CMO3BR7xiTXrJJrjMgdfI+ofhW1sRXECd65DudHGK5yyBwSC+MFEvBn+ocJX?=
 =?us-ascii?Q?KglPviEulWuWy6XHrU3YZIty+Ku09ht9HZA+xXE3frdNB3dtC4Bbbpg0QyCf?=
 =?us-ascii?Q?5zDUTbfD+GI1ZtAxEKC9EQQ+9A9JcAd22p5PBJB6+iuqkMXdp7cg+z/BcJyr?=
 =?us-ascii?Q?GDKHTWhbwONjAhEY1OkTpKH3tyFz/VLwNhKq1khJoc7ns7IuGsMfdfI+j22c?=
 =?us-ascii?Q?77KAtlMPcLJhru5Z5hJe+tTeVc0292sT41adldIwM7Q6mvhnIiRSNdLr0VkH?=
 =?us-ascii?Q?eQ0NIdXp/fX0fD7v3X5/Quy8Y9t06ISSd/QcHSjcwROo4LhLYACZgLZLdkuv?=
 =?us-ascii?Q?0AXQhQkW7DvzMAsaJZU8SURBuNjo3IhcAS97QuaFdiUHvXn7FJx+iTTEJDRF?=
 =?us-ascii?Q?Tn6muNbghIzjEvjoXFAD70HbSpf8gMbxSjzgMR8tx2n4ZYTASoPiwKU3JLXr?=
 =?us-ascii?Q?PUdT2FJuqkqHH6n2OfcZZ5w1iXyXYNc76YT2JmMM/r0/XFdm3K08vrCn1iaf?=
 =?us-ascii?Q?R3/H/51ZSu+OTI2vXFiizRdD1oNREqW8nOK/Nwvfe9lGh4Abe8+erOQFTJLC?=
 =?us-ascii?Q?0+K/w4GewOx9TWxjz+FAqyEGqnkqFon3Tu9ErvNAkb9UEH14lQWvQ/+ePfiz?=
 =?us-ascii?Q?VpwUeBlU1N89v6kEHhfpVMC6eNV3vJ6cFnM8PmofRD8GeCXSCElrePEqi411?=
 =?us-ascii?Q?y/Pxwcwk9iWOgEFhO3syVNXVj6ui7300mXwPJ9YN1AsJcnpQUlvEw1nxFRgi?=
 =?us-ascii?Q?XeFVVKY5IHwPdZwAHW65Uw+JMw3vcSByoZCZlD/eZd4/TFDdQ5EKkJrnWzSh?=
 =?us-ascii?Q?GU/eUjsbwX3EY5FD+mmmE31kJ5PR3BVE99sf9N6wKHJw9pXDFOu+ZWZMFvga?=
 =?us-ascii?Q?3oAxXp/dlLqxOaGkefrDoFQzLU9SxLB/n/L53TAJA4oPJI7lEUpj5N9vqZu3?=
 =?us-ascii?Q?HcQOlLqF+tnOehFTjGW1zyc3xUMbDIwAkllynyCYxBpq3qOlC5GROVVAUa69?=
 =?us-ascii?Q?Y8iyP9XbJ27YfuFm0VZjFNqFKwMDPYSPaKemweK1Qq3G0M+iVx0IYIPw26Rs?=
 =?us-ascii?Q?MMrvYfaimOJchbTCn3etr5skmzgIvNp3Yc1dCwmqcS9nVuAZsxYSO8MGAYn6?=
 =?us-ascii?Q?vKcApL6PVGnpJR/b3jqP1HmoWfu/rb+v5M3QAC9l+AOEc4JGToCp/Yhf1W+A?=
 =?us-ascii?Q?KOzVtV5zNW7P417h25x7Oe5lX5/6q5R5h5VMmLSPN60PdO5/W3nar2hYB6vW?=
 =?us-ascii?Q?r2i89vv/O/pY8IMqQ2SKpIxLMkC9ezM+z+sd1QeztLEHe/MqRoec2qRO4pta?=
 =?us-ascii?Q?vcLoZC6qlE72FgPns97N6mI5zJ+Arcs9OgSn1plw5QDQ3VIV9yMf93OTQ/Z9?=
 =?us-ascii?Q?SMAyWjYC9zd2S/8Ij3qLboQdlTjo7I8QRVICI5g3q5peoW/tdF4gWCnHJvkg?=
 =?us-ascii?Q?qatkW1stNRy2b0X0CoFciSzODhBuLaqQZVaRbeCD5eST0PUQHEzBz0+S6V33?=
 =?us-ascii?Q?Wgx1K8HsWCB2AA2j6LV0ZxgHJb5wb81x184NKjT88IZ7J5TNP+BaCTSFysNL?=
 =?us-ascii?Q?QwTgpRysTAlsINeXQEOJN6waqETIjgIx/VI+hXfbVE5HC3O2KPTqHNl8IsAH?=
 =?us-ascii?Q?IQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d12f535f-c988-4ff2-ee9d-08dab57c163c
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2022 04:56:18.2665
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qDB1zJkhY/3PhBUF0fOKVhBb1BNDxCokHltRjtAoqsnAUXvRB57luhsGHHsAcyGxqexps4XscE7oTdVjTC0Upw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4906
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-23_02,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210240031
X-Proofpoint-ORIG-GUID: jLHAKd0SSRVoLnZiXbNj-QLCJ9svr058
X-Proofpoint-GUID: jLHAKd0SSRVoLnZiXbNj-QLCJ9svr058
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 5833112df7e9a306af9af09c60127b92ed723962 upstream.

Reflink should force the log out to disk if the filesystem was mounted
with wsync, the same as most other operations in xfs.

[Note: XFS_MOUNT_WSYNC is set when the admin mounts the filesystem
with either the 'wsync' or 'sync' mount options, which effectively means
that we're classifying reflink/dedupe as IO operations and making them
synchronous when required.]

Fixes: 3fc9f5e409319 ("xfs: remove xfs_reflink_remap_range")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
[darrick: add more to the changelog]
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_file.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index ec955b18ea50..cbca91b4b5b8 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1044,7 +1044,11 @@ xfs_file_remap_range(
 
 	ret = xfs_reflink_update_dest(dest, pos_out + len, cowextsize,
 			remap_flags);
+	if (ret)
+		goto out_unlock;
 
+	if (mp->m_flags & XFS_MOUNT_WSYNC)
+		xfs_log_force_inode(dest);
 out_unlock:
 	xfs_reflink_remap_unlock(file_in, file_out);
 	if (ret)
-- 
2.35.1

