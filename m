Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDA8AECAAD8
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Sep 2022 12:49:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbiITMth (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Sep 2022 08:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbiITMtf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Sep 2022 08:49:35 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D883265F
        for <linux-xfs@vger.kernel.org>; Tue, 20 Sep 2022 05:49:35 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28KAQUMU011862;
        Tue, 20 Sep 2022 12:49:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=LfKCjnXZxrf0uR5Mbk+cw84x4gy9INpnirLB6WqTshQ=;
 b=XTMpGX0Mdoqjpm5L/UJVsqUtUrhAH+/+7Betwd21jrn6ix+8lxbbF4PMjLQ3WSpf5pQM
 6nGFA7/jU5Yx4JLsPvxrvOg3xmzPMEDIl4OylLMSN35rL+Ok7/KxuBGjkVQzJn8DDdA4
 G41yRtnYAjdQKz9M3uYTwmrGtyOUcz3T9hnThJ2cxJ6+2pFuqV3hw9gcieJblF+/qgVC
 0FTfzRcwFdaBnfxgPhZr9mDjWeOZY5JrWfYwrQ2WRIC/sO+iqigwM397YbMUdNbw7fNE
 8djUXyvoVSD8axIU4V49tP76aKG1iU4irfFdEla5iP/99X3ByyeIucWCSSKwavzYnBng dw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn68m6swu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Sep 2022 12:49:31 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28KAroJO007996;
        Tue, 20 Sep 2022 12:49:30 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jp39k9s6x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Sep 2022 12:49:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ff6lEzytxE3Kx9t3aCPJoKaWIftbr7VDylddrgMzhSAiNXVOklxY1T2W6Uzn0ataoKYxy7X+AlnyF5Q6aRV3mUQ3FPD8FvznGNLQrvHLBJHqZtQt3xQHuAQAWUpzIEX0Mfv5fQLCQRwjP9VzeR2U3CuOxRK4MpSjOmudfdi960zgX5aEuiDItfrQ5AyodPbqLT+5fy+lOWzX3FJThAEmZxukFDJxvQyd8QdPezBF1yXkSOdiS/R2Xu+8FxFgetel+irrBcYzwUw89qgtL2uCXcJ4Otn87kNQEsTkenddMkBMlKGyT5UDqQTQePiTuBdftg0ZsD6Or+AYHVVpKy1OQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LfKCjnXZxrf0uR5Mbk+cw84x4gy9INpnirLB6WqTshQ=;
 b=iyk/3ojs0CS/vE2Y07holFC/Ol3t0BOB4z/dqjV65t1r5Dty/4N3YQvAXo7NESpBX7pEcSnxLFaBoV8S8lNavkcmdT6w6qBvQb936PvK4gb7XdQW6fZUdoFtMRmBNEkqgni2g80RNiSVRQZ3uAS1WIWwkqKbETCmg9yGQLiTJdt+NoE/jjr9dDgkaYGi7I09tWe5eeUsWBXi4VPJR+Y6r2Znkb6OHfWE0JX8VLQaujlK3rWxtuHj1IzaWOaVkLM8iSw3OMv0SXFyYfoRHVWVM3jLfaT0dce5fXfVxuBJdHlLRbF7Tja380KmHRnF22y+J58IxUnFFJSR6fRm6XIfjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LfKCjnXZxrf0uR5Mbk+cw84x4gy9INpnirLB6WqTshQ=;
 b=HEBGXFf1oET9M2eP5YUg6x6mfq7Kpjtfme3RyM01zip5cq+SwZ+E9x5TJU4hB/G/L70Mbo03t8D8/YlNuXFwPjjNQ+mIDHbQ+Fe3H3UsfaYV1VkNeW6E3w8tCCShPwuRSbIu2kAYSB/55jDs7n5EtUZXG/tlp9TasZDd/uKpROw=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by SA1PR10MB5784.namprd10.prod.outlook.com (2603:10b6:806:23f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.18; Tue, 20 Sep
 2022 12:49:28 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%7]) with mapi id 15.20.5654.014; Tue, 20 Sep 2022
 12:49:28 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE V2 07/17] xfs: attach dquots and reserve quota blocks during unwritten conversion
Date:   Tue, 20 Sep 2022 18:18:26 +0530
Message-Id: <20220920124836.1914918-8-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220920124836.1914918-1-chandan.babu@oracle.com>
References: <20220920124836.1914918-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0123.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:2b6::11) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|SA1PR10MB5784:EE_
X-MS-Office365-Filtering-Correlation-Id: 07f220e3-9bef-4d7b-8ea5-08da9b068e56
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bO5z9lFedbV4be5HO0cjOf08IR3+UO0ev4Xv4CI58bVK2cCGtnr8Hcpc3Ae2T/T20PwSLI2OlGjjnTtt94Kjoly8JE7/9EBJOe6ZVk+BvPUOY8PmPlJgaoZkuuWrETRaunego3vj7BGmGJxq/hHBQatXnMkQkq68FXrXlAk8VIk6lcfaWQEAxSj85Bg4GyH268vkitXNjCWAGOxxHBCpodFeSH9YZDmZ/ORUivAcMSgfhWwiMfU+29nNXO7Yhq6xiS/oYW2G75IYXhXmswJX/V/bgt+hcKlRYYwQW3NOQkKzJF/Kg+yZ+GvPAn5d7ayB1EbUds5nQUPeIR5NSrdYYktAvXhr1XFsRHdHYyUc7VNSFS98V5RTKgCs2Ui1LhZNgWfP1myefUPL7tQ9aCCTdkMkjSJTOst/dwW5U9eZMKwD0/YCSjniz7kZRpZ7Pu9UZlT2PxBKYdS5jJFeUKpvdQYqdmzhXkOn8SU1FIEygXhnZOns3nxsnig6ghTiVkRRSbjiQSPmhvQLLMjtLyHj5rTw6Q4buGJxXRRYsqtfE0ntYYZ5VAsDWnQmKvOdB3TwWWXYhyDvNmScxdEuBsHuX1orfzf3NSA0fY0SjzKpZbFUvOB1X4VUYQam/doX2WQJNiv0L+qy9hz6TF/Re88F6EfWCIOTukBBiRYaNHmaOWUnGG/mqktoKZkPCOJrRIakqigyunHclpLPB3HOtuF6YQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(346002)(366004)(136003)(396003)(451199015)(8676002)(36756003)(478600001)(66556008)(186003)(6486002)(66946007)(6916009)(6506007)(86362001)(26005)(66476007)(4326008)(41300700001)(8936002)(83380400001)(38100700002)(5660300002)(6512007)(1076003)(316002)(2906002)(15650500001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vfpxXbS4WZGTkWxmlgs2+W9sA+uSOfzA5j+g9R+jO1UtDg8qovlwAy4d57+a?=
 =?us-ascii?Q?FUUZbv1rARvGwtuh0K6Wj1831vI0zBAbona7RWq1qhn9z0GhLNZgFdJQHerm?=
 =?us-ascii?Q?+LpJNH2Ou0uneEKGsfIw369GYL95rM3QmJWm6LRCc1r8IYKp/U01yRHKxM+f?=
 =?us-ascii?Q?y5E385j6VN19rvinikyg+NT5T6FqS7gN/PtFxVr046PfloTikbtC86ma9UzY?=
 =?us-ascii?Q?VUmzb7WkTGhYV7MdKyhNggCDXqzYRuzauhE41JxNrGy0UknU3SJovHkim49j?=
 =?us-ascii?Q?WXEA9xY1kHQZE+yyQCgm1wL/N7//FIzwMewurFVi+lNYE1RTFYvmWUUdMcbl?=
 =?us-ascii?Q?3DL5jPzuaEGlApTg9FnEAKS0oBoNy7GcM2ZZP/Iyj0H641kxj1+QIu8mgmgm?=
 =?us-ascii?Q?kMOu16Okcl6noCLEd3Eh8ZL3EQWOxM1lCq59TyoZXqM7i1YX59P5kneTmmkZ?=
 =?us-ascii?Q?y5kyfcMvYB+9UkJ4yFfhbhjLAgENm/a9ICxLIGLnqJ6NK/4YughyzClXmHA6?=
 =?us-ascii?Q?ab0Is03pKcr8+bDH7ZXkHwbOazomFNzoF5jEWkgHL9UirE93AZWmrovV4Y87?=
 =?us-ascii?Q?9CWItukd7NQSiS/ACrV6kRyXbuSmkzsCEVIM5DMymOBo81f8mKj4ZPAJIJE2?=
 =?us-ascii?Q?m86estMaXK0mdRRawH/qJCNq41sxZrmzux5KB80tnplL5kHvGL4LQL0tkWSa?=
 =?us-ascii?Q?dJGfg7R3yhIyyCX2/XLZB3JodbN6kp2U/S3D7oa+uldKYT9aGlwFq2/LY2h3?=
 =?us-ascii?Q?h/5tiUWQi6i74/gkES9GFO8QDwDZ2TESOs+mwBgGcDcXNiMKnCwVqMg3Lk+l?=
 =?us-ascii?Q?VlO/fE85NxIKBtkwkjoXM2LEY+3/umxhyRij2d6ZHqeXIepInSA3cXYKVwwj?=
 =?us-ascii?Q?MDnvLTrxl0ZNWif36QpP1Ctp5soBnOj6/vbu8BLVdvZ4PZuUd2fpHxT/sV0o?=
 =?us-ascii?Q?rrSgYr/wmZH6bwEph+nrggXGcuU+m2xF2j4tAxkhGDpeeL2LdhfirgfCUidC?=
 =?us-ascii?Q?fYxVlUvTRSBtt/SgZgqdpD/UdY6+ojbdd+GpEQs/uc6NvcoLSpNU1eJQG1LM?=
 =?us-ascii?Q?0H2HtTDInp2ku6uIEORUpRtj+jChpAAWNW+4XjYkUIk/enacUOmTr0T/9+Yw?=
 =?us-ascii?Q?xXZWepWrwvcXtiN2In6RI/ERph3Lfdu8WwzU7IvevAx7SKQXHca3sDkbm+Qw?=
 =?us-ascii?Q?M+4sbUWOkpxQxKQaaUclvur0LU9nEGLTdBtDwH5/KXvon/0S1IWktMHEjCRP?=
 =?us-ascii?Q?pyHOM6eD+fep+V4QuY51vilEkCSS7fCd3zCvPbACsIKoSaYLYlqFweY9KIZx?=
 =?us-ascii?Q?AH/BYIAJWXTcQoIWRrDAHr36l15DzaSs9d3C8/OxPw+j1OSobo7OTZHOCcBR?=
 =?us-ascii?Q?v/enzaT06pjATmFdUCwi1DWassi/8bXKlAhRKJsVLxOOmo/Cai3AjeQoInEq?=
 =?us-ascii?Q?F7GZqpm1XDEwpnZ7kexom4l9IiEvrwsru+lpTOI/ldO0778s9Fv9cX+TPnHc?=
 =?us-ascii?Q?QW9vOQYO+MCX+0mFl553Nr1BZkEeR8Zhtxxe7ZwyX10eNSNVM5NEvbuFqnc1?=
 =?us-ascii?Q?uaKfPMM44VQ/TrX9WClyXd0vIzcAQUb7Rmh/LO60?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07f220e3-9bef-4d7b-8ea5-08da9b068e56
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2022 12:49:28.8836
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yc0TwemZQCMij3zGzKan7pCvg1Mft6+BBP445C9M51uqyisCp44J5IDXrJcdwBFELzM2Oq+7MSKwSLFpdQR39A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5784
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-20_04,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209200076
X-Proofpoint-ORIG-GUID: Nr9SLm-jMhrhTkqSWOf3q6ctu_lWlo3P
X-Proofpoint-GUID: Nr9SLm-jMhrhTkqSWOf3q6ctu_lWlo3P
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 2815a16d7ff6230a8e37928829d221bb075aa160 upstream.

In xfs_iomap_write_unwritten, we need to ensure that dquots are attached
to the inode and quota blocks reserved so that we capture in the quota
counters any blocks allocated to handle a bmbt split.  This can happen
on the first unwritten extent conversion to a preallocated sparse file
on a fresh mount.

This was found by running generic/311 with quotas enabled.  The bug
seems to have been introduced in "[XFS] rework iocore infrastructure,
remove some code and make it more" from ~2002?

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_iomap.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 26cf811f3d96..b6f85e488d5c 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -765,6 +765,11 @@ xfs_iomap_write_unwritten(
 	 */
 	resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0) << 1;
 
+	/* Attach dquots so that bmbt splits are accounted correctly. */
+	error = xfs_qm_dqattach(ip);
+	if (error)
+		return error;
+
 	do {
 		/*
 		 * Set up a transaction to convert the range of extents
@@ -783,6 +788,11 @@ xfs_iomap_write_unwritten(
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
 		xfs_trans_ijoin(tp, ip, 0);
 
+		error = xfs_trans_reserve_quota_nblks(tp, ip, resblks, 0,
+				XFS_QMOPT_RES_REGBLKS);
+		if (error)
+			goto error_on_bmapi_transaction;
+
 		/*
 		 * Modify the unwritten extent state of the buffer.
 		 */
-- 
2.35.1

