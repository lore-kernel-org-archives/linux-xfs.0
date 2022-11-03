Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1090EC433FE
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Nov 2022 11:54:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiKCLyv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Nov 2022 07:54:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231392AbiKCLys (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Nov 2022 07:54:48 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0818412AD4
        for <linux-xfs@vger.kernel.org>; Thu,  3 Nov 2022 04:54:41 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A39OAnZ008308;
        Thu, 3 Nov 2022 11:54:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=x4yNHtm9KVb5dcmJFL5E//fwD5cjK2RzyXdOh8zHomg=;
 b=LRC9LcnrWpq9scTItHp4JPbgtqQOQbTMm6HDnE/F77lnarmJ9u3vXaQNRp9PBp9+PCaD
 P6ezHQnR7o/pUk5Vua7cEQfnsf+sMtBUjrvJ+G9f0HKv0p/JgGdH+TaW/BBeJQfKVp+Z
 fsqAjtEEwbhpAOmeRarbw0m5ivlhU9sQz24EIqhaE4DEsL3NujcJRuqF57xcjbOllusr
 PdoQZG3WxM9kgvpveDqUIco2/DwOTSbwI7jCfaXE45khrPIBQ+ZWXcXsBWbXOfJGh+SZ
 mCl3lBIuxeD2qQCXiXG1KdSb1BASa1BfLX12AOyBqYCTvE5NRIwayOsiARrfzJ+K1kPJ tw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgts1cr1a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Nov 2022 11:54:38 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A3BsARo029772;
        Thu, 3 Nov 2022 11:54:37 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kgtm6hhgt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Nov 2022 11:54:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ka2qtoeVJ619xwhpoB3KOA7/fe3SLfR+4qTRc+Drj7Xt0DQSL88mqjMV9Us0NVTvj6myG9wgUvsVl3Oyr4TPsmXzp5DOApB1+b+Y5OP6fLhFgYf0mrrYBV0antT3+z3h07ALfd24nUXIGwNUAMD8zlEK1vYqjcKRB/zeQ3gwG9RyKDXNzYVoxvq5Egh8a71Id8QWYjqNBVsLFth9RjnOw9VlHKaDjMXqSlSCVNqP9+eNMO2Uv4R8cjbMxKHauqDWWMJa4iKivTLXEieWud3WY827r84WVo3MlhPs7VLl3AsJ4svurflWdAFD5VioownkKg7UBqYrVSNQNZu2Y5Ntkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x4yNHtm9KVb5dcmJFL5E//fwD5cjK2RzyXdOh8zHomg=;
 b=C7ZoRpYvgen7Ge9cRCVhDWvNghICImUgw1HvIgql9VRdJFuQnasd0ZQHAMotQ1CXqWFEQIo8gZrixgATVdunZpx/70LT7wTDGtC3Wht6og7Gnjaj5OIKLH06s4znNSaIF3kSPxQn6jgEUTcNRzndslJagACFvBsbocyZLhvjW0qHHP5vEhW3FXLA5cyPY6YOM7s70r68pRkiE4vGpZlfPHK+8RFc3dWx14ZTvy1o9l9GNac9dSj1iY0WRJb5cGBQYdFL4VqxO4E0uWoBxJEkF5lqgdj2XZYUC5IX1ISaHAakFbHvXxXEa8zI0IiQJPmQdH+5TXv2v4aqBWaEhgd+nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x4yNHtm9KVb5dcmJFL5E//fwD5cjK2RzyXdOh8zHomg=;
 b=x9MMJNP4V+rw6AXeb3I5UNUkxXWAuv/jdJb7Q/u4+1roxWDOcPzDAQ30LtzOyTLuEuzDZgldL+2oEoeMgQ4YMPGPli0ZZsnvwx4jFYOpr+A8VUmv7HmSi8bhneH2YH8Ga7XnX1+/Tc5/eXTFtQql25tCZe13axnlfAybXFQV8XE=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CO6PR10MB5619.namprd10.prod.outlook.com (2603:10b6:303:14a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.21; Thu, 3 Nov
 2022 11:54:35 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::4b19:b0f9:b1c4:c8b1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::4b19:b0f9:b1c4:c8b1%3]) with mapi id 15.20.5769.019; Thu, 3 Nov 2022
 11:54:35 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 4/6] xfs: group quota should return EDQUOT when prj quota enabled
Date:   Thu,  3 Nov 2022 17:23:59 +0530
Message-Id: <20221103115401.1810907-5-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221103115401.1810907-1-chandan.babu@oracle.com>
References: <20221103115401.1810907-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0038.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:29d::9) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CO6PR10MB5619:EE_
X-MS-Office365-Filtering-Correlation-Id: 9201cbe0-64e6-4c88-21fc-08dabd922d3f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j6r97AVOI3QiKc2bXhY/cWPa/GFn0fWceU+NAVJi7RjQPr33FhIDwomEtQx2BohfU1aBvMXIzwBgZxU9tmCn/5tVhmG3V5kGqX5VczFFAh3COozQBfrtFYRDR/s9LzNsPRi2IfmCeiesT5Kj+GfRXv9JUKYOqWTQ7+CQFEANGFBe0CW8KNU83QUX6AVkvDFS4D9e93AvtXNWkBBszGSkM+MoxPJReAF1edGmALYisYJQKDX5dxYVPAosV0zrNo29PdXFytFw1xErqr5GGnNN1M1SYPOsryvc5kuVUZf96THSjtU8sE4+O3Q8QW2pROU4ieOLJVaDZKMCuD+eG1AbP8/9mSgcmexTJm9mDK/BFQ/nLuhdiw64j62Tuyh9HvVVfrAzqHGoLK8DUQxF2AEh2/rOkPb3JY61lUtDrLw3uZxOhSzOw+pUgereLFBt9zEijBjGTwkgemBXNN53xlP8vbpKKixSLGfE6Gm9/p6UZ4x7klK111UBMel9y5bAfglzQvmhv9kb3Qx8WoUxTC4o9HORW9B79w1i+9r+LmPCo0a4VLJnLbfEvPwCZrwnpKb2OKZUWxEWceQ9jnKnxM8mfl9Cr5gwEdclB91HzHGAadzG6442jc26fJALEzXQH/8Bm1fg8UPm2qaRBCYP9jcwdc2fHxHVBMaVAVEl1VEYrsRrAscarK7LAIruPjEU8CLBoDMO8qmk7ZflpFVOBObhdg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(346002)(396003)(39860400002)(366004)(451199015)(2906002)(83380400001)(86362001)(5660300002)(38100700002)(15650500001)(6506007)(4326008)(41300700001)(66476007)(66556008)(8676002)(186003)(26005)(2616005)(6512007)(6916009)(6666004)(1076003)(316002)(8936002)(478600001)(6486002)(66946007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qU4l6mdOx0GGQb9RD6VlhPfQ4LpgIOeENsFbOOIRetYvYKm3aYop7nrF+Ije?=
 =?us-ascii?Q?Tyrbm9QtIBjcXyi9aCIhShIyYBOyXCU0R6KB077XX6dVSWjwocUiiuUnA4X4?=
 =?us-ascii?Q?KfPDzTKNvgnkmBOSo63Z15s9mYxpGXjTe4liUdVSPIiTfsVHsRmzmFMCtSU9?=
 =?us-ascii?Q?5mAO57pBDtwDSlSW96Fdk8tTpZZsVl4jxcSlbhPniLnoW+wfgR50dSO072IN?=
 =?us-ascii?Q?JvCY454zy0vMYDDSrPIOFC5x8+TzTLHKTQ6LibgiD7WQeT4Vn0mvXKvCqgS+?=
 =?us-ascii?Q?KCP/BICf9slI3P4+kmWWUR1OBH+QHZDTLOclt67C52pD+3R2OC+JWjSiWD6G?=
 =?us-ascii?Q?04lnkqdQaWtVj2r3c4Bs3gHgPR+SV8hv0ra+qLWlEUdJ2wSNkC+6eNJRaH+e?=
 =?us-ascii?Q?MPv83/k+6RbLuhja6kTqr+2yVDaoBi/nKnE6BGTzLKAwWtvDrEwpgCjtcNPb?=
 =?us-ascii?Q?8goY81pf4FUFwn+76/ihqwmbAPdChs7gpwd406FKW7wg9kce6zCjrPkfz0ub?=
 =?us-ascii?Q?1ofzzYhrT+AvJdFsYj4LaZ/u+iTAPW/vaVqgfZCy9ageDsE3nUrhIEnQbam3?=
 =?us-ascii?Q?mb0EkG27/MuSM17TtFmTKtAtMBmszcTVLYlP5wtCRE3j3QjJmdSRBgBJMgG8?=
 =?us-ascii?Q?1NKP78glpbIPk9GWWf3tiYyV2OdDI0idrR/ewwO2wxSeBxsUgUtjOyusxt+W?=
 =?us-ascii?Q?5ljWwc60frKz6IbVsoXrCFlL+ikcYwpggEGWTDeB+wDfdMnhuJ/fhmidpzWu?=
 =?us-ascii?Q?UAzpZAwoqZQW7vYFUo8K8Om445RUNZFolQRvm2Oc0HvjdCVvev89ZXlT46Qk?=
 =?us-ascii?Q?hGaz/YvbezmlTqIqB0kAeODKwQyIAUmbEQ15bW9EOoJTtkdthUwgD93T9Art?=
 =?us-ascii?Q?HA0aobgLM6X8OUM3rkroznl82rCNxGMVkvk3gM9K9XwougGokdoz2PjdR2F8?=
 =?us-ascii?Q?pLy9df9+gHXeEp8S3v5gjkBuj4hBqmdEH5vjFP0EiX4Bz2n4/6wDB+UCgHn1?=
 =?us-ascii?Q?RVLIpHpWfO006UvJ8TMDdSlSRG0jzHPDMp2hMSS0eR29aWd1zD7QHE4bIE/U?=
 =?us-ascii?Q?8BxRadnmvS9OOxK0a5QMtHUXNwxDdNwKfz+UcqmFPr3fZMHreod8V+shyyrL?=
 =?us-ascii?Q?ZK/L12MgPgDKWMpezSIXjVFuPquHPQTvwGvOBRVBN3nX92ayC69GkLDZe2ZV?=
 =?us-ascii?Q?/jTjihfwymZbW31rM2WFOh0MKbEQArGOmFuHZtJeAFCqTL0/EtnHm0PDkc1V?=
 =?us-ascii?Q?T5UgSEsauHXitglG950gFbc+tmet5L3aGcGpDKmw+9vftQ+ssmo2Q+UDFgBk?=
 =?us-ascii?Q?tCp1rSugkDkpdgHbUCx8SAvVgIqNfxnM5zVuS+3eRrEc2dVp/dfKoN3ZZ133?=
 =?us-ascii?Q?Shaa7Ug+dHIgdFkS7xFPSd4W6YKQ95o8W/jED1i97R4gMptbnLOOy/H5rrU1?=
 =?us-ascii?Q?rIaNLT5OBeSELm0oksGOOKijd/uSMI4BZp3QfAz+CXMH4LDi5esaxvKurIIK?=
 =?us-ascii?Q?gQGmgOaIWjuXa9eaa4KwszqQ9QaZku1vcevS6H2kA652mylF/+YfgzKaf8vN?=
 =?us-ascii?Q?3VnIZ3r1cOiHXNsNO7Ff82XcxbAWVb/9K6iCK5PAdCjiSEQDRuoEBkVIA/2/?=
 =?us-ascii?Q?Tw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9201cbe0-64e6-4c88-21fc-08dabd922d3f
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2022 11:54:35.0377
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LyRy1Ak85TwpN0X9+70UefLOtzK0HhEu68gbRlHWzitg8RDADWM8P/GXBhLr8INHQrpn/fy9i5CLOn3OUPYryg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5619
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-03_02,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 phishscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211030082
X-Proofpoint-GUID: dQ9jauJmd37rduCIDV8JRosw5KE46997
X-Proofpoint-ORIG-GUID: dQ9jauJmd37rduCIDV8JRosw5KE46997
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

commit c8d329f311c4d3d8f8e6dc5897ec235e37f48ae8 upstream.

Long ago, group & project quota were mutually exclusive, and so
when we turned on XFS_QMOPT_ENOSPC ("return ENOSPC if project quota
is exceeded") when project quota was enabled, we only needed to
disable it again for user quota.

When group & project quota got separated, this got missed, and as a
result if project quota is enabled and group quota is exceeded, the
error code returned is incorrectly returned as ENOSPC not EDQUOT.

Fix this by stripping XFS_QMOPT_ENOSPC out of flags for group
quota when we try to reserve the space.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_trans_dquot.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 2a85c393cb71..c1238a2dbd6a 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -756,7 +756,8 @@ xfs_trans_reserve_quota_bydquots(
 	}
 
 	if (gdqp) {
-		error = xfs_trans_dqresv(tp, mp, gdqp, nblks, ninos, flags);
+		error = xfs_trans_dqresv(tp, mp, gdqp, nblks, ninos,
+					(flags & ~XFS_QMOPT_ENOSPC));
 		if (error)
 			goto unwind_usr;
 	}
-- 
2.35.1

