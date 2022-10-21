Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE3A6FA3741
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Oct 2022 22:29:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbiJUW35 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Oct 2022 18:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbiJUW3y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Oct 2022 18:29:54 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CFDC3B72B
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 15:29:48 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29LLDdhJ019107
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:29:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=KHkQ0haQzYm7/5sjh1XrcUa4mHEKMkieVFTehDDIy40=;
 b=KPJcRY7VEUlCUEd/QS6jiF8D3kgmJ9Z4UqJ4G8hHbIkwiYlYQa/Wjuzb8YhvxJ9L0Huu
 ksILArx9GQtKXx4ZhQpFH2KxzkfWHY6TC3Tc3mWSTbGoW2P2CYoTI4zIqvrEzULoaF4X
 aVkMSunoBs44Wk5u0Sad+Y0vjxHgmeI/9LVlDEjEjdJwPVoiqrUI9CksKTKlTNOyrWP8
 PzHlXyA0SEQuO2GlQIQ+9ysM3FfBk7000jXxhrc7uSIrQ3I/nXIMdFjfK43PeHXYbV1m
 xNcPBmMxNQiLBpOPtHmJIm9x5SJ9iuZUvgnetdjZSZMXxe79QlsgmRZPpyT+BNXIoGzJ gw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k9b7swa0q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:29:46 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29LLZsAT007322
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:29:45 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3k8hre870m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:29:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OCyHlE9yeGfNHLZdg5M/psbT4jJubUOJ2nePdXswXSW/xKgsuokhD2RUglnOYep5xe/a5JPoCsygAiKG9PfCYj9724ZyfrH+/j+vICgJ9w3qoMxu8XHhzqWFGsQt2cJUhy+iRcJe0c4ZMZ3AtUbjHtnZz5bckSBPzD9EPlS+2mXp4AhC6ESg3B+O3FWCLRFz+MJUTN2+hsLURwNrDoqlHoiDUkjMqe6bVF15xuZPRYnENZ1IuezTo+Ni6jSq+RMIeTJbfsdMxZk6dmHAF2xdA4g/uSfFEUEOaVcMv4KQHR0ClXjapWbCJa7v+6cIXnFgHHCXdYQGlk5Y4we7N4KUAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KHkQ0haQzYm7/5sjh1XrcUa4mHEKMkieVFTehDDIy40=;
 b=LUEXtE/jQQu6V6iW9zlJwNeXetGdo8qcE1t40Ixx8RvhlN2jwEv1K5/xW9cZwrWY8ZIcdYbFag0UIKnZGZFTBoq5txteM/UNw7xzqKYJJ7Muj2n5a/jGRhxFFWs8wOdm6AtMNsovceXuCuHMHh9VvlH6h/lvsLDFRzcRgV1sNIADHUYbb7kQDHFIQlY0HmF+/NiOaQxz1tTO/PgxPycZ+Ur8ajjSMG9Jv6m5CbPDepend3SdHOAz3uCZ4r3MRp+smpYf7th0rIyjQZnxv5CJw7oGpkCwDuTZ11lPkfhgYUoVrxN8xBItxWrucowT+lgdw5rb8qEVaQ3joEeTd33+7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KHkQ0haQzYm7/5sjh1XrcUa4mHEKMkieVFTehDDIy40=;
 b=wlHMnD+ERswB5RhLuQ/yh2Wjf/XPh0NXE7kumbicsf1H9JGaGPsDuOyF6/Lodu/sm8fddE9+YJQJpvOtYqHc13zeALtj3ND/NKNoUhNDTL9a0zq6ADGYSPlyADCMNXU438i/rra114NsA0EYDQ/HHAqZ11AXMu45WGjsIisloX8=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CO1PR10MB4433.namprd10.prod.outlook.com (2603:10b6:303:6e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Fri, 21 Oct
 2022 22:29:44 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5723.035; Fri, 21 Oct 2022
 22:29:43 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 04/27] xfs: Hold inode locks in xfs_trans_alloc_dir
Date:   Fri, 21 Oct 2022 15:29:13 -0700
Message-Id: <20221021222936.934426-5-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221021222936.934426-1-allison.henderson@oracle.com>
References: <20221021222936.934426-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0001.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::14) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|CO1PR10MB4433:EE_
X-MS-Office365-Filtering-Correlation-Id: 29a5ed25-0f3d-4572-a0d7-08dab3b3c085
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gTNwpIM7OAGfWBSQ/G+a4QoIZ8Pl5uZlD7lQQg7dbIqJ8EV5nuQYWPxtxGMikNsMWK7R/vxWiqQR2Fi1nO5AU1xKi2Z+n6JwqBOvRu0pT4DkaY5F0QRs1VTCmTasQfRJwON3nvjLP/fjEAb7jvjPRYVAqveCtmwT8RDXeEtPBq86ViO7OIf1jhjWrV3EaTPs2YiSGtkuqFbwg0sgx+MkToKLje8bxiDZ5Kq9ETQVGmAjeZWdPTH95pDwqyIK0DIy45TXcFPM4BF197nEQDb2+iIJSR5V13WSLaaYH5h3aHUCwIWkizOCXd2WhfVeHj5reACs3IJdMHFv9B12yiSUcv4l21HZE3DOp+PSe5vrrBecXzgHBr4vbPujaFuiABhET2YojE4jmumWUsX+fwQgLuFUs0Sz0652gHUNKQW9vlrzWOS0OJMyFavhDuzXE0GMpWlqQtyu9ZGs2KeDT+YvpC2rPgJVEL0+5CXPyd1Wk4sj/hnUglx8hmjA2RpOc90gz7o+v5VFJeGte/fvjgFACRR4JxQL+NogyLCaIPyid4BlYEKAS/rYvH2alK6k5TyKvGN1e9o3BVgJH1U+RslHnBIHVPwdWFuz4J4vrH0LExJjgzgSUx5Z+BxxeOFPaeYdt1w9GSioqIV+FWJcTpQ3cTe7ELwpCJoxTuaziryvLTeEuhRaMr/r2uSCK3nSrex/1EcUC9F9dDNzVQtpFvGzUA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(39860400002)(136003)(366004)(376002)(451199015)(36756003)(38100700002)(5660300002)(86362001)(6666004)(8936002)(83380400001)(6916009)(2616005)(6512007)(316002)(8676002)(6506007)(66946007)(478600001)(6486002)(66556008)(2906002)(1076003)(9686003)(41300700001)(66476007)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hIjDuFU/su11BD/kH9gYoSTw+sY+dR45RWj1LU8BZqRR/Wo7pGMPSCr/DFZX?=
 =?us-ascii?Q?Rakk689QRBp+HJixy8JX4QqNVRGgPJpcjLU6h1r7b3gXHrv03hpUImJdA9d8?=
 =?us-ascii?Q?HSR2alYNcwUX31QEWDs0+MjSq3T94u8C/t5fQ9nErCXi3ZSGmQiF2aMT1IXc?=
 =?us-ascii?Q?ztmgGNF+V47QyTSGx2h3/DJ8++VXeMB9vbjCJ23OhftNLg0WGmwZiC0dgxmS?=
 =?us-ascii?Q?W/tyxfIUOlSyNURrgMCW+gkcTa06YftoiBasfW6+c2AdY59wfnKunUrymUiJ?=
 =?us-ascii?Q?QdB+NxuUxRSqBDvIKF7bAUaU/qMv+fhueuP5wgK6RHH/Z6piA/0jN90j2bZ/?=
 =?us-ascii?Q?+RNfYU/omOhWYq98XKEZ4sYIS3S4gEXULg8NoJ+KQPGs4G51pwPBbSpGN1bz?=
 =?us-ascii?Q?nYcfHLnctad/By7dBAxYaUSNbkBJa4GyIKEud4AE9aKn3WxdrTehdECuHtOT?=
 =?us-ascii?Q?zFZY4IdqPO7nCc80qBoQ6WEimcqDVpnq7DCP5WK1KaYuZmfjqOdf7MkYdLCc?=
 =?us-ascii?Q?tBhy0F7PFjBMzbr8SAAEHytdjCagRI0NlWBC2tUS1g0wnyd/umqL7Y7/QzGd?=
 =?us-ascii?Q?kp/Rn8ZmPG8Uq0aNMSdxJYCso3XZjA+hDVUI20wWGMiw807F1jgcdeHXMKhy?=
 =?us-ascii?Q?GJ61FwRHSksy/R7ufgnjQ3qClFtqOHeeZazsZ8shffJMCC6SwM1L3utT4+BY?=
 =?us-ascii?Q?y2aw0AOXqhniw5hUfq/L1TgMa9dep9A6qP5vnL+8y0OWEyqNZEKPLli+C14e?=
 =?us-ascii?Q?5JSXk0lvdBo0SdfqMQNUKDdXxz8+OTU4Sdn2p8p1p2lQ3s4CbXdfCwmSuAqz?=
 =?us-ascii?Q?CdNTlr8A2ZVBv8G3p/if+dnufGWkGHEpRhgofTA/X9nx0QX/6SzlVJ5xq1/t?=
 =?us-ascii?Q?VOCwqABABOvq7pSUdFCzjvUMbIrwpt3MeQt0It87kTYBp56/WOBV95ZUbXRP?=
 =?us-ascii?Q?aMMPEWq/VYQW9Srg/ZSPSTQl6L31yftoJUznKM7mor0YJAEXAT55sfRMNNDM?=
 =?us-ascii?Q?UBK+c3P+PAC+WvaOp3Btrm69q0MQ+6Tjqx71WjNZXre8RARSDCrtgzKGIWah?=
 =?us-ascii?Q?ZVsARPi51iVWlXKVeAnWx+aYWVIgQa4U+JurBGm5PeKnw4WPbv+4RZkZJ0hn?=
 =?us-ascii?Q?6t4Z4Dc34QxUIblAAG5cQd/Fe3/1LOt2nfVF9IXV2P6N3YZgk7QMF6LSzwoD?=
 =?us-ascii?Q?SSIrcl1mYgAo0mVKgMPPuVTnnWJWnLSuK4+fFVyTY3Zn0GZOob+iliznOIKs?=
 =?us-ascii?Q?vbR6zvh404Z970+wOe1Q88S9r2L41mcWggkd7UJ2/t9aHcwA0PVx9wfMgeJS?=
 =?us-ascii?Q?qQ4Op8yw3XyiG+hyK7oT0qT//LORtUjlgFiGLHhGo9CaJV69ZSnpkFRim2MW?=
 =?us-ascii?Q?pff9qq4ugSWaE3nIwct0cvBaEgPNYIRumP0mTUOXa3UO97O6p7tCaMK6UVHr?=
 =?us-ascii?Q?Kx2mrmcH0fH9zZN1TFA4CPDJPcOXkO2mK4oWO20ENhs+1o2yuGUl0kPjDjtW?=
 =?us-ascii?Q?GYGJNoijXFwyDEJW/wpKC+sRfbY1cnghFS8bcI8Gxj/nmz2JcOtq4paxwZjT?=
 =?us-ascii?Q?WT5XD8EXmrvFozgTZucADwtEEoUjDfHF2uwPDVkhHsM+ktdtuDQgzRZtE4bR?=
 =?us-ascii?Q?ew=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29a5ed25-0f3d-4572-a0d7-08dab3b3c085
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2022 22:29:43.8721
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hWMXt24Ts6zgxWDCeAkVJeSdG3kcD6GnJxrjBoBU16tRMGIZuYUoqIb+iP0QXHCRi9zQY9H61kBBDpygc641LMBC66LIA9YmwClyYsOIerE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4433
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210210131
X-Proofpoint-GUID: Qbd4zCZZCRaG4u-iMthrwUQX-tdRezza
X-Proofpoint-ORIG-GUID: Qbd4zCZZCRaG4u-iMthrwUQX-tdRezza
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Modify xfs_trans_alloc_dir to hold locks after return.  Caller will be
responsible for manual unlock.  We will need this later to hold locks
across parent pointer operations

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c | 14 ++++++++++++--
 fs/xfs/xfs_trans.c |  6 ++++--
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index f21f625b428e..9a3174a8f895 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1277,10 +1277,15 @@ xfs_link(
 	if (xfs_has_wsync(mp) || xfs_has_dirsync(mp))
 		xfs_trans_set_sync(tp);
 
-	return xfs_trans_commit(tp);
+	error = xfs_trans_commit(tp);
+	xfs_iunlock(tdp, XFS_ILOCK_EXCL);
+	xfs_iunlock(sip, XFS_ILOCK_EXCL);
+	return error;
 
  error_return:
 	xfs_trans_cancel(tp);
+	xfs_iunlock(tdp, XFS_ILOCK_EXCL);
+	xfs_iunlock(sip, XFS_ILOCK_EXCL);
  std_return:
 	if (error == -ENOSPC && nospace_error)
 		error = nospace_error;
@@ -2516,15 +2521,20 @@ xfs_remove(
 
 	error = xfs_trans_commit(tp);
 	if (error)
-		goto std_return;
+		goto out_unlock;
 
 	if (is_dir && xfs_inode_is_filestream(ip))
 		xfs_filestream_deassociate(ip);
 
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(dp, XFS_ILOCK_EXCL);
 	return 0;
 
  out_trans_cancel:
 	xfs_trans_cancel(tp);
+ out_unlock:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(dp, XFS_ILOCK_EXCL);
  std_return:
 	return error;
 }
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 7bd16fbff534..ac98ff416e54 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1356,6 +1356,8 @@ xfs_trans_alloc_ichange(
  * The caller must ensure that the on-disk dquots attached to this inode have
  * already been allocated and initialized.  The ILOCKs will be dropped when the
  * transaction is committed or cancelled.
+ *
+ * Caller is responsible for unlocking the inodes manually upon return
  */
 int
 xfs_trans_alloc_dir(
@@ -1386,8 +1388,8 @@ xfs_trans_alloc_dir(
 
 	xfs_lock_two_inodes(dp, XFS_ILOCK_EXCL, ip, XFS_ILOCK_EXCL);
 
-	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, dp, 0);
+	xfs_trans_ijoin(tp, ip, 0);
 
 	error = xfs_qm_dqattach_locked(dp, false);
 	if (error) {
-- 
2.25.1

