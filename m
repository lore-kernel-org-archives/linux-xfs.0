Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A370C678D5
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Mar 2023 22:38:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbjCHWiy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Mar 2023 17:38:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbjCHWiw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Mar 2023 17:38:52 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98C1969CFB
        for <linux-xfs@vger.kernel.org>; Wed,  8 Mar 2023 14:38:49 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 328Jwth4021240
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:38:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=0HDc5oSRZUZiwCZrUG1G6lMOEEvHfQHLGVwhC+kxeKs=;
 b=FMFZzNlUciC1q1tDNsOHAP4N8Beas64UvkLAnDU8CdgNHCIPGL+P0FFVMbI9koW0vc+o
 H6sLro2fbW3GWiAxjNILfOUeWvwcPOLuw5UH7mkyTdLImOkqdUpVnTLyv3T2cx0GuQmr
 MOvuZkVLxS4U27YnoECz/OhdlC3I/aCfS4cl2gbnHuedK9fff7Mx5Oblu21yHjtQGKd+
 +MnmdFyzogFxum6VTNhVbpkbff4kLZsQa9voe3rc68ibXrDhxVsmda4qNEFSfYKqgt5r
 iKgEehqYituOElrjgAycAckJwVNOIUVeoblxA6iD1cJTApEGEfdvgCGvBchDjhYjKqrY rg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p41811a3t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:38:48 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 328MNwmM026505
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:38:47 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2040.outbound.protection.outlook.com [104.47.51.40])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p6g9uc28k-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:38:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=odyH1fco0oL+IKFuAMnXGMSLePUOr0iR7aCZAB9vb1bMkL2RNdWnHkAZUkxGugljyHrWqTmKFeuH5bdzyOL/XhGKjMttavytz6balniKccIqhF85i6J2MAQcJP3Tqrw1OqVuWkdTo1AN+IfdznRBnWD3pFBEJXxPzphtUaQVZrcwFRO8nxc0y15VEc24GnAiOOGxSBrilO5BWyBwpwLPBx0HqW/px5Nh1TSNeum8s3nDJzRVaWbBIUStm27YFFkVbKQIDrII929M+eKV8bxW26X/5WoTkpnIBc7MZ/MPF4hhut62MCXn18x00uJO1wt14gTcHQA67gM8B0TSMCZsdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0HDc5oSRZUZiwCZrUG1G6lMOEEvHfQHLGVwhC+kxeKs=;
 b=T6Gr6fUeGcvorWTlaLBK8+BLRGaygZIzo5fmNIJC4acaJ+FG4CmEOY7TIyCkgZI72vyRzCzXA0dJwjchieFEtOG1KruAiTCYiZGvDTx+znrQ+dkb7hnQFienX1kyPevYxWJIf9IKht5pOaN7aO+ED3dDhYucXtfBY3KXBmmlhHMY+yCfL4WqvqpDhJvQpgT9hNS11TkLh5G9pGtOdvFCpDVVBvsSr+YH6SgBkc94HTp3nFVG07WH6OMrK4Vq4Jt0CeQ18LH1KF0/0AAp7PHaFKOiRC+cElqsUcE2or1hMEz+S8XQ4tjCVpH5kY3ks1cPwmLB3BnwQbe2rlTzRL82Zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0HDc5oSRZUZiwCZrUG1G6lMOEEvHfQHLGVwhC+kxeKs=;
 b=NKPqnNbuD70unbe+wXCHAbdPB7oN8xopOkxWMo+OoAXDlSXmcqyj5EUd71WJJWvpboBTxhHxAzri4tpFOrxXcuVWYM48Ev+34lT9BnkpLKxom8VqUoqPvzYBm+j/qk6wo16ascBLfa/WcN4JjR7oPAZDQxO2CoI1pl7fdouwdjc=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4162.namprd10.prod.outlook.com (2603:10b6:a03:20c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17; Wed, 8 Mar
 2023 22:38:46 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06%8]) with mapi id 15.20.6178.017; Wed, 8 Mar 2023
 22:38:46 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v10 27/32] xfs: fix unit conversion error in xfs_log_calc_max_attrsetm_res
Date:   Wed,  8 Mar 2023 15:37:49 -0700
Message-Id: <20230308223754.1455051-28-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230308223754.1455051-1-allison.henderson@oracle.com>
References: <20230308223754.1455051-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR22CA0006.namprd22.prod.outlook.com
 (2603:10b6:510:2d1::10) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|BY5PR10MB4162:EE_
X-MS-Office365-Filtering-Correlation-Id: 42108495-d7ff-4fae-64c7-08db2025e0d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QM58/DFG6m4KwdOUrVXV83WLS8tDfo4PKZ4qYH/jsCEt9FOyw0ZtbeX3BT0uKjygrqD8He7+0YLe7C0Nyd84ugIu1zdLnvK3Z3lFSRgOqnkDdTxSudwqeU80waeCp6upOCMdfjDsCTb8SRDC5qvEQH7XOfUEUF8PeXc0wtvdVBZa4u07P8h89vtfXJplBoW2v/BZG4TrpRTHfgjFO4PfJDYClKfEdjTmd2wsgQDdaJliOrYSUgdarmMJmQkbukFMOW2aPQ2hKNygMVvYcENXsa/B7Waq8SyvfBSS6e80aPQzPewF7HWIxF9wi+MhCipa82Znb+5A+ebkbZsvMISVqz2W23g0C/g2OHcyGr+HIu+56ih45WgxNvWgV6JsL09bec2i9CrAUKEkeOqrLUFv5dtzBBO/2pbmhqDhBwoFyH1czMLRMwBcjXt2FEj+SUOs093kRNTpJIJCvn+T5aJ8MjcqFivdKqLREp6gVMMqg/g5Ndon+5uiySDxQsDsy0mFen7WBRUDZaiSlD6dB+ZFdqcB06sXlB/Vv2qkeaPltV8X4XFO60A8K4+hh6PIS7uxEIpdsL2ncKCDzf36KNQEfI7NKz+gTTCBKRutlBwDPVFvgB0LJg6tiEwbPmtFSF2onuKNHMnVZ6kzj41rTSFrmQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(376002)(346002)(136003)(39860400002)(366004)(451199018)(5660300002)(8936002)(8676002)(66946007)(66556008)(86362001)(66476007)(36756003)(478600001)(83380400001)(316002)(41300700001)(6486002)(6916009)(2906002)(186003)(38100700002)(6512007)(26005)(9686003)(6506007)(1076003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?c09ACDzT/YuesFTJibgY8dAhsCbk7W2Zhz67lthEx8najZGtidaiGcP/63Ec?=
 =?us-ascii?Q?pofC5M4Og8dPelARPVWG47ENU1DASR/NNSaf9Tnez1iM1AG74jfon9VEcp7Z?=
 =?us-ascii?Q?KUPhUazOijAZ1aQdDqI97jrBjx/rv8Bsd0K/hfKB3VCTKgNpQoi0mp6pyk4/?=
 =?us-ascii?Q?Zrb4qy35w0SvKsR7ix6T5AiZoDu2xpwKv5FIPl8oyzQylHMQANglooWb2ta1?=
 =?us-ascii?Q?zPWW8qqhXUkDdDG4sGcNwf8Mp2XoyOmqZ/VBqd03NsyuzOP5DAo0bUjMpl2O?=
 =?us-ascii?Q?GI7Cf5q16PXEX9sc26JiluFNUnE2sgDFqkEw9oAiVpEymJfXi84RkqdtVgKM?=
 =?us-ascii?Q?mP+LG/p1JbKX5COkjCXEu0wnxYYoGGOt8EQUelCPsEpcLjWXmGe9S/QfGavP?=
 =?us-ascii?Q?dRIZdwX0gC2+iuss685TEudYse38J2os5a9d/LHAUzWSLfDtw6WODxPwyhc4?=
 =?us-ascii?Q?2If2R1kGfo/GT28WcT65XPMrZK4/nL4Hpz56LEQOnsM71ABtps3q85HkhZ6q?=
 =?us-ascii?Q?nva2ODynLqsGxMUIW2L45jX80/IOO/NRcwB9IOkoR2PguAJZxhSqk07nMBMO?=
 =?us-ascii?Q?h+iMXtXOVeImzLrgIUzkdg24KkjeiL0TUXzn0RE5vY6yZkMzd7qlGkG6axd+?=
 =?us-ascii?Q?lrs0a3rrQFzAJ7OPIloeFdsdcC8ytPBDPFykcdN8y5xBf7mSxyj1li1BdZ1w?=
 =?us-ascii?Q?LvFFI6XD8YIOfN7Lyu7/VHXFuAhpbqfEdCIVcSXWYE/GIbNr8tfuZ1aXWEKt?=
 =?us-ascii?Q?1PnQ8d4S5/jPdd+vDbG76qma2XT8beN87a84ZzAr/TWyGtNYJSNOwXQBgqpB?=
 =?us-ascii?Q?y/EICITLUy/1LTjh0uGG2IDo+gQdUTnt0xfe4boU0r06tcJTPbAL4RX/oG0H?=
 =?us-ascii?Q?yMsLGQ/OMh0sXX9as9huFwVkkQevFUqUR5IROhycH28jpv8EE3YPwMYHqC3n?=
 =?us-ascii?Q?UDnVClwXkn0wBTdIRsKsKLRyYWpsVjN3hh/gsfEL1M2U90tMMQAM/WzC3jYz?=
 =?us-ascii?Q?QbaORlUNwhwdUxuDylHXJlW+tuhwl4VqBvct8mCPMXBO60JUHR+BiDO3wj3s?=
 =?us-ascii?Q?C5oeF6M7B4JKZfotnbV1NbaSl1j08Uodzj+AFmQsOeqm5NSwnc6mfin8+vwe?=
 =?us-ascii?Q?mmxzfG50p9IDAf0iDB5ul86z1fnH9MUsXayIRGpE7vsgwk7DUEGnHQQD/U1B?=
 =?us-ascii?Q?3DvxV4Hq7IKzk6lvw2JhbUoZdwkVYNbMy0NHpTJQ4rBd9VAX/3kTLgdvHLN3?=
 =?us-ascii?Q?LrAV2i8qzIZOyDOtJ8EbRnXRq52N6QV1KRWPgeDUiZZk49wRtRoZPWWt/GZ7?=
 =?us-ascii?Q?vJEc/4rxjQ4s3DRpx50XqwVq7joIRXe0kjwuHKEvp1MRCZjFQJe4T77MF5RU?=
 =?us-ascii?Q?D5CtCYjh8C2Qaa97XXjFrUOWDUr5er4iXsHAbXQFU+E66q9ZAmhupvLk0YIZ?=
 =?us-ascii?Q?jhEyalk+YS24NFcNY0/IXG3HM+YTZ8y3ig9bsd0szajDh2dxmWQ3LcY1Bd5B?=
 =?us-ascii?Q?mv2RUw0dDom72XduvSDaCtg6OK1UYWLxh8fJ+sCFKNTUcditniCfUDYeOyc6?=
 =?us-ascii?Q?ZCvcIKCOl011pKtQg/axDMVRSqCto0KXM/m/HUEv0rA6ELcElFMRcxqnUW3N?=
 =?us-ascii?Q?yg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: IXIe+h0NqjtjPiT3dET4soF3cRiXzyDxufaVt3FDCuQ6iqCQdYLEAiR7HqeLJ865wW6g/UMnTtzyQTs1VrX8YGsmMjQP581kzaPkbAdDRUYFhqQlXWes5uGxXjcpsZZr0hldImvSE9oBo8luIQpDzv2a9hI0sUVadvyMCFo6fNQIVhodEmAiIWRMAjUw2IdEP5BNvqyw0xd/AnmMxEDFVMmOwGtvAiVMjMGA0tEQYRJTlHnDy599nrS6lOPa7ioKaKxWNmJ0iwC1QfLDz313MpfGQK8pUVk1hFR95eGCYjCKElYjm7JZXnWLU5bt4RUJZkLNFwMndHK9kcemHciqazujjOKoIJq9qZ8ZtK9pdBG/HL/MRbUqbPAerOIPuXjXUtZsZ7zOSqcNNmbhCIE9Ioh6umnTedhjv1+w0xVAidXLetDkgDqlhCMxfNsFu0RcLNBIkaqiDXNxeJD7k5xYCOSGfR0ZF2+K0L+UqBFX4DulyyH4jQOlAKsLKX9+KzRqM8T+dY6mfmroiDgD5m/4tUV0OO/ItH5PvP2C+KXHxlGE7amPTnItbYal6mOKycO6DvhVkJz2Ci0SKQGaoT4aNeWO2YdmiWlpN7vXE0zCQf5upt3LjAdf8n6SwYZZoYc1cDztnZSA3o5xCB7+LtcqzZ1QUSFOHMmlJEfyj+0bcrzxXbc4YB/1PMDBH0IROmHIflWlLQH/TcKaSS0Wtkkjcnp/kxIiJ8A33jF1+VPs1N9HYCfpOJZKr0aA8ajUCRYtn397cOqHpYWaSd5+SFuGQw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42108495-d7ff-4fae-64c7-08db2025e0d7
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 22:38:46.2398
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2naAYrPuM7ORuzcvr2G1bDPoB/VtVtREWgYQrGzwRDUi/iBayQTIOaFCj6quqKyTRc1D/tVcx6dtqCnZbZD6VqBaJJGZLHcrwSGE9jNmJYA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4162
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-08_15,2023-03-08_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 spamscore=0 malwarescore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303080190
X-Proofpoint-ORIG-GUID: fL0u5IikXKynuFUZNaAQRjbj0jrT9qO3
X-Proofpoint-GUID: fL0u5IikXKynuFUZNaAQRjbj0jrT9qO3
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Dave and I were discussing some recent test regressions as a result of
me turning on nrext64=1 on realtime filesystems, when we noticed that
the minimum log size of a 32M filesystem jumped from 954 blocks to 4287
blocks.

Digging through xfs_log_calc_max_attrsetm_res, Dave noticed that @size
contains the maximum estimated amount of space needed for a local format
xattr, in bytes, but we feed this quantity to XFS_NEXTENTADD_SPACE_RES,
which requires units of blocks.  This has resulted in an overestimation
of the minimum log size over the years.

We should nominally correct this, but there's a backwards compatibility
problem -- if we enable it now, the minimum log size will decrease.  If
a corrected mkfs formats a filesystem with this new smaller log size, a
user will encounter mount failures on an uncorrected kernel due to the
larger minimum log size computations there.

However, the large extent counters feature is still EXPERIMENTAL, so we
can gate the correction on that feature (or any features that get added
after that) being enabled.  Any filesystem with nrext64 or any of the
as-yet-undefined feature bits turned on will be rejected by old
uncorrected kernels, so this should be safe even in the upgrade case.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_log_rlimit.c | 43 ++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_log_rlimit.c b/fs/xfs/libxfs/xfs_log_rlimit.c
index 9975b93a7412..e5c606fb7a6a 100644
--- a/fs/xfs/libxfs/xfs_log_rlimit.c
+++ b/fs/xfs/libxfs/xfs_log_rlimit.c
@@ -16,6 +16,39 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_trace.h"
 
+/*
+ * Decide if the filesystem has the parent pointer feature or any feature
+ * added after that.
+ */
+static inline bool
+xfs_has_parent_or_newer_feature(
+	struct xfs_mount	*mp)
+{
+	if (!xfs_sb_is_v5(&mp->m_sb))
+		return false;
+
+	if (xfs_sb_has_compat_feature(&mp->m_sb, ~0))
+		return true;
+
+	if (xfs_sb_has_ro_compat_feature(&mp->m_sb,
+				~(XFS_SB_FEAT_RO_COMPAT_FINOBT |
+				 XFS_SB_FEAT_RO_COMPAT_RMAPBT |
+				 XFS_SB_FEAT_RO_COMPAT_REFLINK |
+				 XFS_SB_FEAT_RO_COMPAT_INOBTCNT)))
+		return true;
+
+	if (xfs_sb_has_incompat_feature(&mp->m_sb,
+				~(XFS_SB_FEAT_INCOMPAT_FTYPE |
+				 XFS_SB_FEAT_INCOMPAT_SPINODES |
+				 XFS_SB_FEAT_INCOMPAT_META_UUID |
+				 XFS_SB_FEAT_INCOMPAT_BIGTIME |
+				 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR |
+				 XFS_SB_FEAT_INCOMPAT_NREXT64)))
+		return true;
+
+	return false;
+}
+
 /*
  * Calculate the maximum length in bytes that would be required for a local
  * attribute value as large attributes out of line are not logged.
@@ -31,6 +64,16 @@ xfs_log_calc_max_attrsetm_res(
 	       MAXNAMELEN - 1;
 	nblks = XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK);
 	nblks += XFS_B_TO_FSB(mp, size);
+
+	/*
+	 * Starting with the parent pointer feature, every new fs feature
+	 * corrects a unit conversion error in the xattr transaction
+	 * reservation code that resulted in oversized minimum log size
+	 * computations.
+	 */
+	if (xfs_has_parent_or_newer_feature(mp))
+		size = XFS_B_TO_FSB(mp, size);
+
 	nblks += XFS_NEXTENTADD_SPACE_RES(mp, size, XFS_ATTR_FORK);
 
 	return  M_RES(mp)->tr_attrsetm.tr_logres +
-- 
2.25.1

