Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B8B6FA3741
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Oct 2022 22:30:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbiJUWaR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Oct 2022 18:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbiJUWaN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Oct 2022 18:30:13 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A2C21A3E1B
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 15:30:12 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29LLDZSJ029908
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:30:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=2x655BnxhB2xpc4pGSrT4r0BlVuNIps50xGtUiTSRWk=;
 b=MqiBOw09qKFDJAIQgL1hD42NVetGlP07/AEWidE4hXNR7ukngAstcVxGF+Gq0It0GLgk
 +w1cQoBy7y7UTudNSOdHD/NukjgSlYHN7WEv4Y74J8awHpLufn/+3wdKeYdyTm2Qo0w0
 wb8Lprsszdq/cSI3Egx19tJRB0EDzfMQPWr4zgf2ihkBWONWFic8iITJu3ECwCKM1VqK
 8Q3Wl0JbInvwpcxjKy4BbNdXm7SdEbrrkPohek7Ci3v2iSMxpagnkAftWQixlNCR9p9K
 sF18dRMk/lPYZ8ZKS4TeQEDTpc1zYtCAPdO5sKMdBbWh0seBURHBeUDZe3SfORvIM9sZ mg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k7mw3tc2q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:30:11 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29LJRvR4014690
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:30:10 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3k8hua4xk6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:30:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cZqlrLmV1mAbZ+vU2kqn+w1XYAAURyY1mbLkhIZ6qtvsyzmaJEflOu6Sclb6x2vCnL/Vu6UOLtUJSsO5IXducjcmoGAGghW/WMkS/rSG83d1leshwopD2hSdE3X/jIaekd6r6NrwCsRWHvTSeVyCpMK+nqYa31jgcQEwCwzByXj6hdqdpYsrHYaFemmY6dl314/nh2CNCUdJslK66VKjJLNBtgBHWu8lu99D+FwQVKh+zueDUi0Ah6jmIBfMotlsP49NWrbWkIRkDsgEt9onKgOUopn0/yHep2WsnH5sPEZjQ7PRG3/s32iXKkiV9grB4P2Te0S9W2HsV7TEhjTqEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2x655BnxhB2xpc4pGSrT4r0BlVuNIps50xGtUiTSRWk=;
 b=YMj5L133ssIZ7oTREaSQZETZoYY1BWpNLJ1oVaxjV9AO23j23Wb1RIg0Ru3bYMyLQuEwOqNg01SisSx+gytdQNF/lsh3HInad2Z0y8/hyDpD5gqjAFkto1pPjeps0aLjY9G5zkRoA+glltJ/W0MNwJ0ls6xketWrv1FC7jcGDlPfs2y2v+K4pbJCFFja8K05HM3veLNiGy3e2YJZXMbsyiqEOdou/PESIjVaexiZQOAlXxOETBB5z/5Wbm6p71eRfMX/92H8YfZAB/tErQvGtf5OwBxpDzr13l6ucHY3t9sLcfs6FZ+TA38qriFHUSw1p3RRWIeotSel82EXFPcJ/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2x655BnxhB2xpc4pGSrT4r0BlVuNIps50xGtUiTSRWk=;
 b=JH1CamQUeWQgRoos8bhaeybL509vo3850G1K4As7I0df5JhltGM/8tpIo8Vl1PpLpIiag+OUkxoMExzwm0GgKCxhIrhrcF3AIUJT5fsttf8MwYG3+wEz/kWMAkP/6QSdVtmg8qcvoUY/lLCBTZWW6V2eBkb0+PjT5HawC1Rk7OU=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DS7PR10MB5213.namprd10.prod.outlook.com (2603:10b6:5:3aa::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.35; Fri, 21 Oct
 2022 22:30:08 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5723.035; Fri, 21 Oct 2022
 22:30:08 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 19/27] xfs: Add parent pointers to xfs_cross_rename
Date:   Fri, 21 Oct 2022 15:29:28 -0700
Message-Id: <20221021222936.934426-20-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221021222936.934426-1-allison.henderson@oracle.com>
References: <20221021222936.934426-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0047.namprd17.prod.outlook.com
 (2603:10b6:a03:167::24) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|DS7PR10MB5213:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f374ea7-0002-46f7-4274-08dab3b3cf3b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hjdHmAkz7Dalt6NlvLUi+ukmcAM/39o4y+8ipFj33kjyq69bmJs9bwrOf9K3ZScqTcsqQQ9hMbKwXSdxYwhd6livKfHEKa2wTmG9u8jPO9bbid/9OfMK1F+mjA4LDstToOUnE935Y7ADmvvrQLhbojw6OCyxCW7EToobTQd7o/dNz/xnfCPymqoQLZpahUSsqfXfZjpv5XIwQKUaWWPVgRjjqn4BOZdS0PGlVNNcaKiJJHQtgEcwGP6vjx2D3f0J6reQcI/In0zkG9i2ggwW3n25ituhgp2XkiZ2fHd0Jovg8xWliWrmi9w9atpoWnAzkD2+PNZ0DP0eR1mmEz9l7u28fp/YNjb2hoewjDF6u2bypEDAKl83Qd+WD1UCWj7o45G41tccf2Acr2Syr59j4ZAtolUiLLGyZ/fX97kt5jySCRDYDEU+snGtKAxzTB8u24kSL14cg5pvtsMWZHlN46Ys53cb0+QlRfIcgyNxqD/yxpQQagNX7YndtDpa/KtY39aLgSbHTXTqDlVOMhSQCsb+h+UHoZi0NYWE4cqxlqF7k2pVATFQbzihaxn6ZUXzJzVjhlI5pSblJMp4H9wSiIP25SM88EZPgJ+pAIzsncovc1bcrp8JwyCRLjk4hGERehsEBcE40PJh4CPQqM9TuPr2JKNIgeHjw0FkXaefC9o29Rna9kaUkrpfYQ6z5tACV1jcqZrM1T5lOZpl2xCmVQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(376002)(39860400002)(346002)(136003)(451199015)(66556008)(8676002)(6916009)(66946007)(316002)(2906002)(66476007)(8936002)(36756003)(41300700001)(6506007)(6666004)(6486002)(38100700002)(1076003)(186003)(9686003)(6512007)(26005)(2616005)(83380400001)(86362001)(478600001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MtBy8CO/tlh3OHfApIx36fH2Y53ld1JIb4BrwFN/K0u47+xGDEGdjl04l2hW?=
 =?us-ascii?Q?bJQQM0MMYacyqromaSeXUGgdzB3cpvmN5H2dDguVlj3n+EVqD0dZTVjVoqQq?=
 =?us-ascii?Q?g3xvpj4aoBp05E7BVZKSqVBpM7AY31eRY5cHnZVZC0495snVe21WSQXevStW?=
 =?us-ascii?Q?gEP1oAP7LyBAJ5mzBFhjJE4WVPrho86gq7V2r3JApkAokcGRoyJgun0MVoGB?=
 =?us-ascii?Q?h/Ur5HVCXPToXZglFdWW6TvP3VHCgozG4/Nqh1YLE/4fG2NqlIlfsMR5LMSl?=
 =?us-ascii?Q?brW7yKUgKA9WpiVzDx0jlQ926By9sMZdAjblmbDYdqj+c4mRYNdf7wHOtMJL?=
 =?us-ascii?Q?0egBq4LXdZDkn209asaHoqboWe9rBI6pBgZDRM73eNknFT+QsAAK6HQYnAAs?=
 =?us-ascii?Q?3QKnUcsvMnNVkT7poQj50/aNRj1+moSlzwXWdNzkNGRm6VXJ5fJ1Tmc8OPN0?=
 =?us-ascii?Q?Dlsi8z/Y/aCRL/BeAAdMha0foA7KTcUBK//wewsOQKGadJCvWnPO1JV/YPTX?=
 =?us-ascii?Q?oVAzeI4b1c2LV14Kuh98Pg/cwWHOiVZhb+eXq1+FrpD4HWOU8cd1L52XF8WZ?=
 =?us-ascii?Q?769dHy0p1jGzFisjuCinYExCY0nSpM9bQTCdMG3FDdvTxxO2uDRIEkKWr1m6?=
 =?us-ascii?Q?qgVWRHX/aqPWEwyKCbUAJPHwACync2PFQ2ljGmRfxtfoJk3+GSioOWHGeA8i?=
 =?us-ascii?Q?4uM+WTsJUgj3UcGUAIgCH+B/rxJSFH6a5wcb/dKIpJVZIsdgwPwJNKnYtCI8?=
 =?us-ascii?Q?9i6pOFYkNrgUHekh2/TZPdL+52wubiPX6oMg89pN8kgJ6HcpeJ0crcdfiFu2?=
 =?us-ascii?Q?ftP/n/BkcmC4KjFs2dVSQPcY0M/fEGtbBnM2cfeIKEjkNnLqeryb0Gs5Qh3K?=
 =?us-ascii?Q?uoY9GZ361ZhYJjrUFbpCVAiN48XVwUh6BPl3d5TNdOJvpOsaCiyThkonB1+G?=
 =?us-ascii?Q?Gbij5wT0JQCsBob63/1ozT8WsuuLL+1gnNA252QYaDGX+K/mstQ7yHsmtCdQ?=
 =?us-ascii?Q?IcsHCEx25NG1hUFsOxTSFKINWh8zCo3BRtvBnRGkudTZCWDQq/D4EvoKsfoN?=
 =?us-ascii?Q?fi1UugK36SSRYxfBok00YuCHNRCAZFgUTTcrtoycUtj57LR+4Trp5FFEFO+k?=
 =?us-ascii?Q?F4pXKmZZHBvyAKrdOHwFmwX2ybqBJDw92SciIB66sJDf59xT+LNRt5gxTPXO?=
 =?us-ascii?Q?GnCzBFqp+p9wIPB6Nw+bFm6Lf3/tcNYeid5aVggRnSzi81WDCAC4aahowXGp?=
 =?us-ascii?Q?WTfnS+SNA2cD9A23hlQcguWznulvyBlgIvtjL3kBqGbGks1nhAqUrjj4hGWz?=
 =?us-ascii?Q?84k53UiFaL7sRPwYqlXqo7GXfOokQV7Jr3DEjQBCwgPnnZe1bcfr0TiOE5nq?=
 =?us-ascii?Q?DIQUW5EnKNZrXg2flihECrnMCA2+yoJ2g6RW6UWw5Xo4FCY55D+TOrucPfM/?=
 =?us-ascii?Q?S626VkweQQVIhV3oMzE/t/md/MGrGwqaDgA3aLMgCITaF4LxP6+eTi8bnu1S?=
 =?us-ascii?Q?sD0CSkcbX732LvX/5+E6v+UxblTi50ZxrvdtbsC1Mrf5W9jQ+2O4DmShvjjS?=
 =?us-ascii?Q?V6jonApdYtKVOtMZcSXzIo7L8YNVbbSW9e3FmmlIaTHFagwSrfkTEjBpUbaG?=
 =?us-ascii?Q?IA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f374ea7-0002-46f7-4274-08dab3b3cf3b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2022 22:30:08.7068
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xHx5cVkCUTbG5/KKkCys9CnOkXUIfg+NLvgN+FqhkW0nkavrVnhH232BZYI/EkoQRFrMndo16w5G2ybJaXRGFJ8AUvhHkN0yikHcMHujg6I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5213
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 spamscore=0 suspectscore=0 phishscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210210131
X-Proofpoint-ORIG-GUID: nnE5icxvRKC5HvEw-O9wrWlcaz8n0_Po
X-Proofpoint-GUID: nnE5icxvRKC5HvEw-O9wrWlcaz8n0_Po
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Cross renames are handled separately from standard renames, and
need different handling to update the parent attributes correctly.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/xfs_inode.c | 79 ++++++++++++++++++++++++++++++++++++----------
 1 file changed, 63 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 83cc52c2bcf1..c79d1047d118 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2746,27 +2746,49 @@ xfs_finish_rename(
  */
 STATIC int
 xfs_cross_rename(
-	struct xfs_trans	*tp,
-	struct xfs_inode	*dp1,
-	struct xfs_name		*name1,
-	struct xfs_inode	*ip1,
-	struct xfs_inode	*dp2,
-	struct xfs_name		*name2,
-	struct xfs_inode	*ip2,
-	int			spaceres)
-{
-	int		error = 0;
-	int		ip1_flags = 0;
-	int		ip2_flags = 0;
-	int		dp2_flags = 0;
+	struct xfs_trans		*tp,
+	struct xfs_inode		*dp1,
+	struct xfs_name			*name1,
+	struct xfs_inode		*ip1,
+	struct xfs_inode		*dp2,
+	struct xfs_name			*name2,
+	struct xfs_inode		*ip2,
+	int				spaceres)
+{
+	struct xfs_mount		*mp = dp1->i_mount;
+	int				error = 0;
+	int				ip1_flags = 0;
+	int				ip2_flags = 0;
+	int				dp2_flags = 0;
+	int				new_diroffset, old_diroffset;
+	struct xfs_parent_defer		*old_parent_ptr = NULL;
+	struct xfs_parent_defer		*new_parent_ptr = NULL;
+	struct xfs_parent_defer		*old_parent_ptr2 = NULL;
+	struct xfs_parent_defer		*new_parent_ptr2 = NULL;
+
+
+	if (xfs_has_parent(mp)) {
+		error = xfs_parent_init(mp, &old_parent_ptr);
+		if (error)
+			goto out_trans_abort;
+		error = xfs_parent_init(mp, &new_parent_ptr);
+		if (error)
+			goto out_trans_abort;
+		error = xfs_parent_init(mp, &old_parent_ptr2);
+		if (error)
+			goto out_trans_abort;
+		error = xfs_parent_init(mp, &new_parent_ptr2);
+		if (error)
+			goto out_trans_abort;
+	}
 
 	/* Swap inode number for dirent in first parent */
-	error = xfs_dir_replace(tp, dp1, name1, ip2->i_ino, spaceres, NULL);
+	error = xfs_dir_replace(tp, dp1, name1, ip2->i_ino, spaceres, &old_diroffset);
 	if (error)
 		goto out_trans_abort;
 
 	/* Swap inode number for dirent in second parent */
-	error = xfs_dir_replace(tp, dp2, name2, ip1->i_ino, spaceres, NULL);
+	error = xfs_dir_replace(tp, dp2, name2, ip1->i_ino, spaceres, &new_diroffset);
 	if (error)
 		goto out_trans_abort;
 
@@ -2827,6 +2849,20 @@ xfs_cross_rename(
 		}
 	}
 
+	if (xfs_has_parent(mp)) {
+		error = xfs_parent_defer_replace(tp, dp1,
+				old_parent_ptr, old_diroffset, name2, dp2,
+				new_parent_ptr, new_diroffset, ip1);
+		if (error)
+			goto out_trans_abort;
+
+		error = xfs_parent_defer_replace(tp, dp2, new_parent_ptr2,
+				new_diroffset, name1, dp1, old_parent_ptr2,
+				old_diroffset, ip2);
+		if (error)
+			goto out_trans_abort;
+	}
+
 	if (ip1_flags) {
 		xfs_trans_ichgtime(tp, ip1, ip1_flags);
 		xfs_trans_log_inode(tp, ip1, XFS_ILOG_CORE);
@@ -2841,10 +2877,21 @@ xfs_cross_rename(
 	}
 	xfs_trans_ichgtime(tp, dp1, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, dp1, XFS_ILOG_CORE);
-	return xfs_finish_rename(tp);
 
+	error = xfs_finish_rename(tp);
+	goto out;
 out_trans_abort:
 	xfs_trans_cancel(tp);
+out:
+	if (new_parent_ptr)
+		xfs_parent_cancel(mp, new_parent_ptr);
+	if (old_parent_ptr)
+		xfs_parent_cancel(mp, old_parent_ptr);
+	if (new_parent_ptr2)
+		xfs_parent_cancel(mp, new_parent_ptr2);
+	if (old_parent_ptr2)
+		xfs_parent_cancel(mp, old_parent_ptr2);
+
 	return error;
 }
 
-- 
2.25.1

