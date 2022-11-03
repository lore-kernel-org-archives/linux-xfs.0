Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AED5EC4332F
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Nov 2022 11:54:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbiKCLyz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Nov 2022 07:54:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231433AbiKCLyu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Nov 2022 07:54:50 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32B8A1106
        for <linux-xfs@vger.kernel.org>; Thu,  3 Nov 2022 04:54:48 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A39O8Fi013485;
        Thu, 3 Nov 2022 11:54:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=A4z26YEfuER0HX8CiU3mPrhjRNX+ONG7l+hBf7FprHA=;
 b=QZK9Zb5vTMVozBzG/qXOR/TvlJFYDZmBLSKRllraZmljXPWNd2+kZrv5XHNoZ2We7KhX
 l6WzNViWg2x7nxo6xsAlqx+cxODg8roqoFh7hFM16+Ckv6V6yx08XiFGfNsbXzQumMq1
 Vkpi+ztisxg4BXmE61tdCiuScSarbwBA/kHKlBlRpE+XT6IoKaqefLbVMIas7njjgJbs
 WMCihZBpSSDPpMn9L/N1MB7m0YVMGDLBPaNTn7O0QawdfB+MXcoXl4S7C76DHMw1ytoe
 VbnGeXfwRK/oawPpMMYsq4b5EDPbvrvdPBXgKq0Hk5wZgaXsFk7jlBUrrxNBbTXTGBHD Ng== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgvqtmqmk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Nov 2022 11:54:45 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A38oPIt035564;
        Thu, 3 Nov 2022 11:54:43 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kgtmcmkah-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Nov 2022 11:54:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kOH969Qn0yNWV4QKiVG/l8Evg8p5PF8nTVuM2JsAqvFC1g3dnP0CpqGtbxZqMew35XkdjuYGC0l37ubjDe7Bm44g8wDfH7xnI2s1y8lwH3/AIvybIPJ1C39GWk2wyaumOFgFgyhVoAW9jieb2pgP7v8vPNvuUtCygKpWButbJZPa3Xs22YjIoANduigMo+aU3t8FxcpaGH5iECRtNseqkW48ar4FYxTCH0Qc5XYaTf3U7AkLWsJG8mu+CdPG/PS0sgMIGRc5xhBJ26d5dGTr8b5lBvYDkhdZFx8fu2A5NDV4L9k0EfmhH6a2GycsX0m+Rq0tEKpp3vY11DoEdxFkVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A4z26YEfuER0HX8CiU3mPrhjRNX+ONG7l+hBf7FprHA=;
 b=MQ4lkjGUtk5blb8uve3Nj2/36ecBGFgW0jgBdnhXZSy3iBl4zjfP1Xn0W3DiH/QzvpbZWP0XurW66ki+Oxaz04wEFnVwa266cPNAiwjEi/r+yVFKJuDy6Rjph9S/60YLimBlxIotxrlEl4Dfqtrcb0jsR9MwPgT+cd0up0HQp9EMR/4Gmt6xpdBtzN9cWcO6Aa/E5vKPC8TvotsHCD7LZgMMdWU+p6xGiCPXBOKO2JytbNtsl5FAE0X/dT42BbBqQ15XFjiwznYsrZabGvLk+1Ze02XDBUxPoOp4VSCgNYIl+FxJLUwCrXwvfrnA0PYDvP/44tKYtM4XCYaheT+KXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A4z26YEfuER0HX8CiU3mPrhjRNX+ONG7l+hBf7FprHA=;
 b=nh9FJVaRoyOpy+Wu7ypBwJ24CY8BwW57X1XcxsEo8LZuhofBNOTcCyGDjUwrZvBLQvWgfeU4I2pM4nCv/ZpubJ3SvF/MfI1DyMOcGByhIImCdbkv2oiOqAnf/pNR9gHdl597lowvDUU12VjgRQylyMk2RT2qBBhzpxDaKWJ1YX0=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CO6PR10MB5619.namprd10.prod.outlook.com (2603:10b6:303:14a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.21; Thu, 3 Nov
 2022 11:54:42 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::4b19:b0f9:b1c4:c8b1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::4b19:b0f9:b1c4:c8b1%3]) with mapi id 15.20.5769.019; Thu, 3 Nov 2022
 11:54:42 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 5/6] xfs: don't fail unwritten extent conversion on writeback due to edquot
Date:   Thu,  3 Nov 2022 17:24:00 +0530
Message-Id: <20221103115401.1810907-6-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221103115401.1810907-1-chandan.babu@oracle.com>
References: <20221103115401.1810907-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR04CA0019.apcprd04.prod.outlook.com
 (2603:1096:404:15::31) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CO6PR10MB5619:EE_
X-MS-Office365-Filtering-Correlation-Id: a7b03514-ca18-4b99-b8d9-08dabd92315d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KdFy5NtKf2iz+JyENUowo+b0IgVe7UggS++rRNtaTG0v8ZPtj43zu14iDnHVkQeVe+cuKfdg0mOOVnXf3V7rmcd1Wj4pwD84CRFuXNEyqErkirJbXxjw3mCocjxhGsK88cIr4jErJWyOjSbGI6IMfSBH/wTXk+xCRnkwwEN8bqyAIZCskeZaGYNjIZHNAmssL9vfUtzfkYAaG+0wNMAgvNA4X+cu29CW5f7SUxKZ+Z9VxiX+6gIgVXvQAFEJ2nTdFXc1/qguxSDYyLv7YJOXc/pk3RBzFfTDgGUKrbXnO+Yzg1KJ8z7j8AkLLON6myrbakO+017ykCGsReGw5BErx4euYTTs+OFiA4rJkW6/1owRNN1V1HEKsoGYOuHc8C9Z8gJvu/GPs+BUC4JLoiiX1U5Kr3N/J9WZMUn1gDzQ8jOXtJhZUCIo3zhb4Xst2zuEzeiZV3httNY/PlsPJdHcVzurtLD7Q2rsbFh2rTn8d6I7Qr5AjmkIvK2vm80AkOJ25AAcRHORe+h3CekmtlPIxr73dDIE3CrjGiLutd1Mi6Y4mfRh1hCDu/KlfY/9NJ6Ds6hUS121EsPJFzGA5+2yolWiKhnmDhhU2X55Av9DjYas7IZApLWUmj1e2WiUCc0Oubt1m3SLINEmicByeJSGfJ454+iOVsH2qpTKicIPHAHeCvoaTLrZMEmbjq5IIyOSNUEi8Lbne66G/RFBfatxcQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(346002)(396003)(39860400002)(366004)(451199015)(2906002)(83380400001)(86362001)(5660300002)(38100700002)(6506007)(4326008)(41300700001)(66476007)(66556008)(8676002)(186003)(26005)(2616005)(6512007)(6916009)(6666004)(1076003)(316002)(8936002)(478600001)(6486002)(66946007)(36756003)(34290500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yJfckkVA5Gyiko/1wbcjGxe9sk10GwM08/YfrMQ2l0DDfXvgQYvV6A1F8+Bh?=
 =?us-ascii?Q?taDmMYq1UQ8sNTPINqk779hhg1KluGNkovyiiiloAta4oK5YTEkZNeOKR7II?=
 =?us-ascii?Q?OMhm2I+JD7KoOfXU0b0YTQ4puf089TR6c6ZNLEKg2D8TfR3h528XBp2SY7rW?=
 =?us-ascii?Q?EMPGbVj4RM9+6o4Q6P3O8AMmOgtGyQQ+aX0RpbGmNk4OVFJCM6HhoABF4dZb?=
 =?us-ascii?Q?B9kdHZAh3uy4LBflu7THsRb4yKyRVLLW4sNJBTsbhBTNyJ0ScqC0TjY8HAKq?=
 =?us-ascii?Q?dyBVHqfkTJvlEPwVEGIhHUtEcTfo8Hha/e3u/Ty+SJLTujWoK4OgKGRxelrw?=
 =?us-ascii?Q?/oY0vbMX9LuuNHeYca85xYXhuf7afCyN2tyt9cR725lkqkSu7GR0MgEDM4kB?=
 =?us-ascii?Q?sKxB1uNAYCistklMLOiS211dHoSmFjQuCLu9Xi5HjB0HAx/90eT+N+Nwq21a?=
 =?us-ascii?Q?AxbV1eQUi/+gzpTcnX49eZw/ZCZPV0r+3Cc+2DxbNOEV5lig4jd/pbHFJ4lj?=
 =?us-ascii?Q?HQdYhBIVq1S9ucebKFbisRZtAu2hAHb40paisl7OoBp713cyPHKSz89tJh1k?=
 =?us-ascii?Q?VTPlP4uVwLoeQMbAuiXoob0pfd/byWBKdzdRsX+mdV7DdifLZ2xyrawNJnjd?=
 =?us-ascii?Q?nLDI6uCbEqgcbo8Do+ya39BMnO7kwzdgf98MrloNF4dYHaykjkANN3b/XP8+?=
 =?us-ascii?Q?MYPASLJSh+/Mrs5QrwfvAFs1/YQeO6nnqLYMfg+ntS3AP09ywc8EL7kiJRAU?=
 =?us-ascii?Q?zTComMDuzoVImhjJrf1lyYzkD6sjlPfgvBM8wX3hsz7LoVrybgvvZ0odqI00?=
 =?us-ascii?Q?mLrL89WyUyqK1SuplPCTJ8PoFWYgQ8un3KTy/1NtcaqoP52ZTl9sflhDXxsz?=
 =?us-ascii?Q?F+DTOLfV+HNOi4OjmgrK1QH+v+NXs8ajBFiZuyOGjNsPwIn1X0VV6zQ5SabA?=
 =?us-ascii?Q?s6xAbLkcjnp+0qSfZ9zeKisgKCAbUnsr0ja0eU15f4QBTya2cgVyYx1QRG1q?=
 =?us-ascii?Q?mQenQHjI9R7qf4pYP8wCPdSv8S6Gw0F7IXpcZYDi6bXDVuKKWTTehU6qM9wu?=
 =?us-ascii?Q?fbeGkjmrlTThrSaLIpmm2ESeqfXuhviaAoL0FGS3c/F5NnsfyP+Ay+gcOV0G?=
 =?us-ascii?Q?BXv+FLMMd/WhfbVwvKbw2yGRE+5oC7bYAQR/dttKkEs7Yht9L7LZvJzrFXg4?=
 =?us-ascii?Q?wufPiPIyQoAgCpljZGsubItN59k9iVN5/U1YgTE6GsmuMaofzHRGVNoYY97T?=
 =?us-ascii?Q?sQ2GTxtJSgIHcRobTbb975suWEjTKcLQn0pUkwShHGOLRJxmDPPM+4KQDhQV?=
 =?us-ascii?Q?LbmtdB1dKZohi6OhODL+AahsLq0BLyzqlCtOCsfsrnYbmrCZP9sM30NgtzHK?=
 =?us-ascii?Q?JF6HxaO+8uiYydQ7w5K6R8DZ8pGvTu/tR8DNy8Fl7QSVVTzpvS1EcaR2yc0k?=
 =?us-ascii?Q?MKeUJXxBitVPKO/N9/bNSZpuzAD7e414yLKcVYBrgUbMgTbh8WnC3+55kUMy?=
 =?us-ascii?Q?phXl0xlYDRUJ3OBRNXKkFkxllMoQrRzpWYqPPqkn5+AZv362WtuNT5kcdE3H?=
 =?us-ascii?Q?tuxk8Ncepz9wBMjv6u4Qn42XK9S+Qe8+rxDh9mDARBGdJLdHKJ0dYrzNgJac?=
 =?us-ascii?Q?kA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7b03514-ca18-4b99-b8d9-08dabd92315d
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2022 11:54:41.9627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ysjPo9B8YJRIPiFt936bI0w4v7GhG14nR+/o5OubhyWl/eFcDXPxHN37GbZB/EpZgVdf7irMTeCLQHR0CJmOdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5619
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-03_02,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 malwarescore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211030082
X-Proofpoint-GUID: vm6DlNe0GpHTB7qOXbr0g2D4UOQA_kxz
X-Proofpoint-ORIG-GUID: vm6DlNe0GpHTB7qOXbr0g2D4UOQA_kxz
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 1edd2c055dff9710b1e29d4df01902abb0a55f1f upstream.

During writeback, it's possible for the quota block reservation in
xfs_iomap_write_unwritten to fail with EDQUOT because we hit the quota
limit.  This causes writeback errors for data that was already written
to disk, when it's not even guaranteed that the bmbt will expand to
exceed the quota limit.  Irritatingly, this condition is reported to
userspace as EIO by fsync, which is confusing.

We wrote the data, so allow the reservation.  That might put us slightly
above the hard limit, but it's better than losing data after a write.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_iomap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index b6f85e488d5c..70880422057d 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -789,7 +789,7 @@ xfs_iomap_write_unwritten(
 		xfs_trans_ijoin(tp, ip, 0);
 
 		error = xfs_trans_reserve_quota_nblks(tp, ip, resblks, 0,
-				XFS_QMOPT_RES_REGBLKS);
+				XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_FORCE_RES);
 		if (error)
 			goto error_on_bmapi_transaction;
 
-- 
2.35.1

