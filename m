Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2A1AC433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Nov 2022 21:13:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236979AbiK2VNa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Nov 2022 16:13:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236974AbiK2VMx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2022 16:12:53 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94D732D1
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 13:12:51 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ATIhsFu013826
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:12:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=kjnJXb4QLTI/gC6onLA0jkmfXuy0GCZXIVbvceEUfO0=;
 b=z/EewMIHP3J4kS7dc6I1cX9LEuv00JbdXqgRJ89cjaAUgkXUiWywoDgnx6a3PjgdcQMD
 eV1z+ZqZM2xFYVG/OghVa5ujUlVfTq/t6bY8koGVkWo+aohs2oA/0OijEAYStdIDfU+O
 T3uXOuDAo2G4oKgwe2HUsytwIMAV0GEV93LQ9zDLeiLDhQgj+w2mdb3WUzyRVqKAU1zL
 e/PXd9p84SGmMFB5z89dsK2EU7pP2PrATbmsZUODYpDiQlmldeJhR+CMUzz0RXPdcs7N
 E/Eh2oJZMY0AYF4OelX2KdIpNMHsuEBHiVQuSM16KnxHuI0P9oGwrm8rAefco9X8DpgH Pg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m3adt889u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:12:50 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2ATJhwtq030987
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:12:49 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3m3987na4r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:12:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c1ybtAhUdXAt70vSHSgO6j938TGWm57eV/hykhZlL+cSrtoSB7ygjejDqfWnpvZ6hgMJgvEog1yHFtilC7WA5HuJuOKw2QV2p1eZf68BhJOEyHa2LPyXLoj8R+UAikhXd7sTk/ceiwcNcTknA7eNo0+ftcbt406z5k0fR8M98gUpM8ixdKPJ4AUt+pC3I96rYp2ec7cq6SJC8vP7Dmf+AqlW7GgH8Hb3elCsL//IJ8j5mGtx5yrHi3mZX6q+q7x+EhYiWJFBG1i7/oDl2Lw3k9zDgvx/JIm1fxVIOGyhDft1CCI6KgxEQpQZA2pdh0ZH9fpxcNO4dEmqXSToMdGCjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kjnJXb4QLTI/gC6onLA0jkmfXuy0GCZXIVbvceEUfO0=;
 b=IKGGfLL3Z9WfCSBC4vIrsLXDsBfdr6oEVxKUtSqMTQfkU2C4RgSws8LmEtgRNC2OFtOdQrPtczsn9s1miLiwQRfQIhz3GbqNFSw2AiExh4PYScg2bLMj7Ncry2uupbjCZ4IURND00FqhpDdhswDBthgixTAqWMzS5ysu/9dHYzRHT6ZtkQCtbrX4rwFKz3Yk24t0fLa6tp+UuH5S0k1iWNe1aWMg+To0oZx/2KjmrNgAY7fSDJFrzmZo68y+DsQxZbX+SjYMTdSCRmzo/jGmCiSrQtpb60hVrsAN+m102WB9olfxvyYFYEZVSnHqceZpwei281gZ6z/G4SSzG1d+2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kjnJXb4QLTI/gC6onLA0jkmfXuy0GCZXIVbvceEUfO0=;
 b=lC1jGyS9sV+vQYGUqQFA+DOOJojh7M70+swU+EoldHAfSSj4wOraP5m1jS8HhUzrI8TmvHzwRYdZMANesfZrZl7r3H9xKdI0fWR1rNB8/6YsDyQL1BXHOydtiLBUpbHa6gPLADTvIqtgcsi2jf8e/N/2ETn7imv0TTRJDFktmwk=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4259.namprd10.prod.outlook.com (2603:10b6:a03:212::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 21:12:47 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c%4]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 21:12:47 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v6 02/27] xfs: Increase XFS_DEFER_OPS_NR_INODES to 5
Date:   Tue, 29 Nov 2022 14:12:17 -0700
Message-Id: <20221129211242.2689855-3-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221129211242.2689855-1-allison.henderson@oracle.com>
References: <20221129211242.2689855-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0058.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::33) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|BY5PR10MB4259:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c9f2b7e-3ad2-4c0c-d593-08dad24e774d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ti7zgwHMcAE1qMOXiCCL79z2JHuigWjnIrcFUSv7tC8lFaSFAzu5W9iFTIXDZJQeXdrL/rQ0TMK5Miz5yTZVFjMnoD/6bz0RZacj49RgiYQDzTl42xA6pj2OoXwu4OS2qEXCeHrt244gs/3X3U+N+kLrKTrUWh+rA6foeiTjgpsiBpeFXImTXO63Sq8yzYnbRijjSs/yeYY5q+IvupYsIBxgJ93x69rpyr51lD276h+wvxav4Wri6feb5mJpN036fwqLzcxaBynq79UeDy0PuZ1XO5/DZML/13Hn8bBtIIW/fp12fG1cFVR81A7eabnlIGVU5vNzESQf1i6BptRVX97A8qLrI683EUrCHP5VL+o5SNIbfk5sprxs9XuhbFWoTyFP7Fco1ovJ8pnuFyBny7rIuGUMpVBNm/60wo5m9RjgD/HYuBthsQ88RCM+xL5deeelyaBEgJCyRg5OyUhfGDpKWThYqRIH5T1hmAVxhb42qmc9yTuKFzndj8xunIJzb590Ig0DyX1R+hpULrukrAjDu2H/3VDwsrkGcmftjGZT3dbqF8AOxMJuhb5Hv9z+UhSI/9KYYgorTIpBeOh+wTDjS3wA6ilQqmvK76ywDR69YPPS0KyhU+JEIoqtznvy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(396003)(376002)(136003)(346002)(451199015)(8936002)(5660300002)(8676002)(36756003)(186003)(66556008)(41300700001)(66476007)(6506007)(6916009)(316002)(38100700002)(83380400001)(2616005)(6666004)(6486002)(26005)(86362001)(6512007)(478600001)(66946007)(9686003)(1076003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dSX0F5djufLl8b8R4APtNjsmNGsS2NCxYh27d1M5mQ34Tic5XvTL+VWjdpTE?=
 =?us-ascii?Q?ntysask7epq9+U+Y3jpm2URmxYjyT/qbqmgqruGLA+AVtTpXX/pieKEBryZL?=
 =?us-ascii?Q?zkRCArNprSR9m70zz0hs8j9XROnsib0v1CJe2maYNrNLy5lRa/ZvM0/z5Ikv?=
 =?us-ascii?Q?GvM9NlVCcfjjoFe7aMIOwurGZUhBOxeNln045JlSJk2JZVdHt8QOm+eyhmrk?=
 =?us-ascii?Q?2LBLsdlA96uedSMjCHnUg5+SBGZav9Wepy/j0PK0kgPeNKlYehvnZJ07IyH3?=
 =?us-ascii?Q?UBHlH2suVOFOjLeYjbs6Y4hEfO/uqNLBJHURNtOuMdY06jxZDPcxKgcPiezY?=
 =?us-ascii?Q?RrD9MHVG/K5EPdg8qlnFzZOX0MsHavGU6UM/gduQP0hTq5bemRR3VMtfkUpg?=
 =?us-ascii?Q?35944UGMLZD0RNUd6tMU/qp8VGaolMZ1rcVTWn5mKRIpUpFTnBERu0S3euu0?=
 =?us-ascii?Q?SWcSHIGW0o9JnrRICAwRb1UnluPd5voqwr/GFSyS+jJbBVksZ+geuJCw/EHj?=
 =?us-ascii?Q?XDqSO+gSBbDQStQT2nrk6QITyGemlRv8D0ssLzOb5cwWcnuEGd2H23n3/P29?=
 =?us-ascii?Q?mFXR8/XPY7iqigJXSq6N5PG3AVutYpm5nXlSZ1PDFQPAUdn01hrpmqi4ZrRO?=
 =?us-ascii?Q?y8oGNMqazzkn+8VcJlVlrW6YmQoNHyt2HgWHCqdi50ksO0XJfuPHMvl3WUjv?=
 =?us-ascii?Q?q6HF/nyi+YmNufknKct6olF9byJTlSXs4xgnRbjgDki8ZBjBLe/IFSsSbqRh?=
 =?us-ascii?Q?e2zXpfBXlp3JxaOtL5IgQgHEEwcmt0WZTWyAQKnlDnfUT+B2G5a0SXwEj6tb?=
 =?us-ascii?Q?xydsftdRUbnOM3GXd9mOfk5hTKKNZQliK2H1d+bykfk9cgpFbdkRSokkjTCW?=
 =?us-ascii?Q?3P5z7ruJGaEswYYZcl2O/uQTon1mW9YaTh81J1qbu2G24xQS1aO6fA7Xhlqz?=
 =?us-ascii?Q?Hn8VnRhFomJgO9NSsfFewxx/N57DMpbHth/2XF6KpEj8SL0Mthep3ZuNx8JE?=
 =?us-ascii?Q?U74JufWLSBLVb2stsfJJT5hE6NCLRQJ0eK4UvtyzrAOn1Fk3vueFxCzShwM+?=
 =?us-ascii?Q?ug2vUsBbCBoUFPP0prN0S4gwAvsNsoxMxsNg9FFkqsSnqKq756yZJZk6DbvP?=
 =?us-ascii?Q?PuUGyCO/WbIHXpteQhtRnexnFeIb3ls9vGaMC9tPTDnVQs3NqHsAKMHBo793?=
 =?us-ascii?Q?n1FJunpfBHONFIGd2g1X4A8xxmjv9QNA/vsmEnMohrnppwxJbmdddExXyrpo?=
 =?us-ascii?Q?Wh7HikiFyyDrrMnnf2Ft97Y20EVzK+W6F6DbmrFD7iUBF2fAJQS03V1DS1KV?=
 =?us-ascii?Q?TF2uAvRjCBXS+sxN1Cjh9VdTcv8rBSP6/8S0mV/DnLEn5BUdmtAVlm0LSguv?=
 =?us-ascii?Q?F6uieQeprdBFIGs5IfqKgMIq2HolxJB30PjtwcmEsoIx/jccMEiJv5F0qyfR?=
 =?us-ascii?Q?qylRui6CAgH8BhTE4YFXDqFTwnPwx+ag8fNeNDeZr3r/havTH325oAxyR6Yq?=
 =?us-ascii?Q?TV+TuX6D1Hx9u905MxeQCLrQejsSleHzBjUl33fSKgFgzAx34A8EqCf8/Ej8?=
 =?us-ascii?Q?8ujsqOXhvKnU4kqr6Vod2Ez7u+t0lHAnVOmWI8qQd1lHHVs3QuVgz13/UkWR?=
 =?us-ascii?Q?WA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: zBTniOjfvP8cx88l/xxc0RHQ3LG8owegvh55TOa6uE0ndXYCF02C2pE4o1Sr4Wl05uKlyQwOSRvOK5tqHvsp6kFL6B5AR8Llx+hF/aFv8IsM6N1x7hl8JQiRTEHzVNvb6/sAs6mIRAifnGuzyJA5qhnuF/Rh9J8OuetWXic9pwb+8QOrt1vud2SdSg/jiLbRvSz0wOysMivZqeHdobEGrRPro8yn9CRmFQ9USI3KYY5FNiEOPUM6obpVdqvuS2+FW+4P8ICxR/5BVbSsWcRbu35DXat/lnb7dzFuf46zT1saWKRe51zneHt57gZDERESBtLXHdj7xi/2jofUVYG5Kb6kZ4dt0OHT8pfDj9QAZdDT6CfTC9+1fMOqlSs7n3kpqyejNrEu6fFwjKVmcbqTVFB6nSAW1LZPLFb12P2okW250kQpMIe/BhrjwbJ0i6fyNi1emRA5hTcaNr6WKqq/3pB2vJd71WjfOIyWMzGWQnWT7nvYbTRbYe82lyeZcXogzwZSQ9jtwq/TmURBKYzVWfhNHSg4otXGVfrFbSi3JrHifrE/DOePBg16+3Nt8WqgRPdiC1scfCYzXX8kvncX8yux0wkWjaMk9JkxvZJXDJSVdE5LYTaodmG4T4zU48nhnUQwGWQvb4jFKU4ewC1/TwUsMJgRtlVinGYMuCf6zxz9YkOccvBGHDtHJ1H+51qPA3T8KVeV6tDWR1OMG9zq7tvwY4OnzmPD+FuAT6bZnX4lrWig2H9hWmMxKTQi/LTGYNQU7l1RoXFZ2EMv0q19lw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c9f2b7e-3ad2-4c0c-d593-08dad24e774d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 21:12:47.8311
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8WEhj5cchTuNji/Jdo3Ibh51eHamkbfYDDvzk+RKhHi6/lBKncpbAI/bcMi3vjOI4+ATdI+iPN0yqVuZL8gJl1+642d5t5g/obzAyeH/T44=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4259
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-29_12,2022-11-29_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 mlxscore=0 bulkscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211290124
X-Proofpoint-ORIG-GUID: Ts83K-1WtKyh9nxLFRU7aCvIfz4VNC8e
X-Proofpoint-GUID: Ts83K-1WtKyh9nxLFRU7aCvIfz4VNC8e
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Renames that generate parent pointer updates can join up to 5
inodes locked in sorted order.  So we need to increase the
number of defer ops inodes and relock them in the same way.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_defer.c | 28 ++++++++++++++++++++++++++--
 fs/xfs/libxfs/xfs_defer.h |  8 +++++++-
 fs/xfs/xfs_inode.c        |  2 +-
 fs/xfs/xfs_inode.h        |  1 +
 4 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 5a321b783398..c0279b57e51d 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -820,13 +820,37 @@ xfs_defer_ops_continue(
 	struct xfs_trans		*tp,
 	struct xfs_defer_resources	*dres)
 {
-	unsigned int			i;
+	unsigned int			i, j;
+	struct xfs_inode		*sips[XFS_DEFER_OPS_NR_INODES];
+	struct xfs_inode		*temp;
 
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
 	ASSERT(!(tp->t_flags & XFS_TRANS_DIRTY));
 
 	/* Lock the captured resources to the new transaction. */
-	if (dfc->dfc_held.dr_inos == 2)
+	if (dfc->dfc_held.dr_inos > 2) {
+		/*
+		 * Renames with parent pointer updates can lock up to 5 inodes,
+		 * sorted by their inode number.  So we need to make sure they
+		 * are relocked in the same way.
+		 */
+		memset(sips, 0, sizeof(sips));
+		for (i = 0; i < dfc->dfc_held.dr_inos; i++)
+			sips[i] = dfc->dfc_held.dr_ip[i];
+
+		/* Bubble sort of at most 5 inodes */
+		for (i = 0; i < dfc->dfc_held.dr_inos; i++) {
+			for (j = 1; j < dfc->dfc_held.dr_inos; j++) {
+				if (sips[j]->i_ino < sips[j-1]->i_ino) {
+					temp = sips[j];
+					sips[j] = sips[j-1];
+					sips[j-1] = temp;
+				}
+			}
+		}
+
+		xfs_lock_inodes(sips, dfc->dfc_held.dr_inos, XFS_ILOCK_EXCL);
+	} else if (dfc->dfc_held.dr_inos == 2)
 		xfs_lock_two_inodes(dfc->dfc_held.dr_ip[0], XFS_ILOCK_EXCL,
 				    dfc->dfc_held.dr_ip[1], XFS_ILOCK_EXCL);
 	else if (dfc->dfc_held.dr_inos == 1)
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 114a3a4930a3..fdf6941f8f4d 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -70,7 +70,13 @@ extern const struct xfs_defer_op_type xfs_attr_defer_type;
 /*
  * Deferred operation item relogging limits.
  */
-#define XFS_DEFER_OPS_NR_INODES	2	/* join up to two inodes */
+
+/*
+ * Rename w/ parent pointers can require up to 5 inodes with deferred ops to
+ * be joined to the transaction: src_dp, target_dp, src_ip, target_ip, and wip.
+ * These inodes are locked in sorted order by their inode numbers
+ */
+#define XFS_DEFER_OPS_NR_INODES	5
 #define XFS_DEFER_OPS_NR_BUFS	2	/* join up to two buffers */
 
 /* Resources that must be held across a transaction roll. */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index d354ea2b74f9..27532053a67b 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -447,7 +447,7 @@ xfs_lock_inumorder(
  * lock more than one at a time, lockdep will report false positives saying we
  * have violated locking orders.
  */
-static void
+void
 xfs_lock_inodes(
 	struct xfs_inode	**ips,
 	int			inodes,
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index fa780f08dc89..2eaed98af814 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -574,5 +574,6 @@ void xfs_end_io(struct work_struct *work);
 
 int xfs_ilock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
 void xfs_iunlock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
+void xfs_lock_inodes(struct xfs_inode **ips, int inodes, uint lock_mode);
 
 #endif	/* __XFS_INODE_H__ */
-- 
2.25.1

