Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD535C4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Nov 2022 21:14:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236832AbiK2VN7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Nov 2022 16:13:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237055AbiK2VNm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2022 16:13:42 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94DC770472
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 13:13:16 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ATIg0gT005680
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=wE0ksE5vfgMvUj/Ot5eAoBDk20fgpdZH9uwqmHgcG7Q=;
 b=23BbMMQ/2CFqtqCgL1XyeYVYWUIko9mQt47MIRHP88UqoWYxy2HWtsR7PFLivWGwmoQY
 j+hs2Xf2ApKPmKhOun35jCe2dxhF2WUo0O7sj0nyTbptPO1UXbLV6hWrhH64X0yN/NkM
 U/bB010e2SOeKFAFmWte4pzRexYXb65+k4hHKFLGZuONxD78HSqfWixX7OUIWPX/iXrp
 ckjREyv/7xTcdN09U47+y5cDrQHG7CQjD/mh1/oDacaE4iRaFe4+S0toufD8b9nDXPHA
 bSpB8GnVn6hXKqV12RGj3J8/tNckNmw7nP16FwiTYbRg6wWjgv4OKgICdeuUq0gjVSrj YA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m39k2r9fd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:15 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2ATJo442019311
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:15 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3m398e6h89-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HZ4rJdDcm/RwwM3uvtgHtWRX9N7eghIJaMA4bABdYgrquoGHp4J5/LXhtIeMlaQy2KYjOvaD6nnlXAvV9aAtwLKzKufFJd9nXAHkZn1bl9WUJ1sOqZPYHtL6nFgIrbNDeHrO3Dw7fLs0AeQt9OpGNfXTsG3dzqQ3YEndaD/famkTvYMDbzuExpGTYgQqOoO4lxv7NXc6xvEQUdx72Z5myDTUu56lGEoFi8waGZOdrRSSUmcL3+FDTtoy4aeCu9sw5itekHdL8FVq/+uMv2OI2+6d1R7MlaHJvY614tEcPT1HO/sKe9uXjyuS2mfHiuwieOorSpusWiBOQnSkRNFRBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wE0ksE5vfgMvUj/Ot5eAoBDk20fgpdZH9uwqmHgcG7Q=;
 b=QNXplLNyUx+bNtZjvDuP0G6HxdI1Kh554xt8QG+WQ22//ZYp3bVgfZCuEwYyLRN5KHUJ86Kjtlegm1vhbTxivRT9uEGSKeVb/i+YNb3qpkcbpfolE7ErRxDnuElTUxeLD0pV6TGDv9i+Y5qjavoV54xtvWehCcWAFoyLjn546tw9T59cdoqOZFFi2RW1NXxfaGog1EM3deYFVp7TKsPVTrOHw8+iJkB7YR7sBteVoyTRIB2MMVKiolqlrHJMb+H1R3v5t09JQg1oOhyxSct5fXsPFjo8QOY++DDlyGll9p6wHgVPKyz+SuH+L3dtbFFb5rPk5t+AMdFyX7dOZJ8qfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wE0ksE5vfgMvUj/Ot5eAoBDk20fgpdZH9uwqmHgcG7Q=;
 b=cHXWOL70keRFQNHE4N9IiA/KQmuAxMAok9EN4XVshMXgAqdKuh1JD2CesqEl4Z6IOKUpS8VTYVQpc7sgbbcERW4RLJanC8deDLJnEKKIjKGOsI+Wk3fAoPaGzR5FBK1WI5lRk6ctdqaNyLd5rV5w4bf5y7R4pMWRcUEIJaFpNFU=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SA1PR10MB6496.namprd10.prod.outlook.com (2603:10b6:806:2b2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 21:12:52 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c%4]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 21:12:52 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v6 05/27] xfs: Hold inode locks in xfs_trans_alloc_dir
Date:   Tue, 29 Nov 2022 14:12:20 -0700
Message-Id: <20221129211242.2689855-6-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221129211242.2689855-1-allison.henderson@oracle.com>
References: <20221129211242.2689855-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0024.namprd08.prod.outlook.com
 (2603:10b6:a03:100::37) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|SA1PR10MB6496:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e320530-fd81-4e6b-f6c4-08dad24e7a0e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Un20XNZpIJ7GlBcJmeAAMuMdBX7MnzfnSq1Mxogkm6EU7dVZ0U825tg4/DZy3u82bjjfU8DxyS/lgc5vwWP3kvZXl/0Z5tpCsXXH0SzQ7PxR+f9/+zybn/D39B1dvUQgNejH5y0TxfwbSK0ah+XBtPewpIIegCE0SI0CpIwy2e1wBg3EmICieTp32+ethMPctD1epS/qYWgJNSqu4pPn1JN8DlbribLw19sYbL2xAyUXSZUa4w+5mZbFMI/E3YsK71FpWZfmA4tyDgJePDnOwwKT8fWeOuiL8hvrYdgAhvCH+AwAYvjxJLQf5/w04AmY695hJ+o1crpU7PnbzaAmZZIobdSLgkA+biDGURNavyFgQLHzSq1p2c+rPDnxxC0L17LzahvAzFi9QArPEWHckiwEIpW/a25xfrjHY53NEzakgMwNG3tDrU2ylImsp9AwYjex4cJhbsFLk3VVZ0tDWUIagbcO3TWCrDVBWTYvMLUgrpVuobBEBYPXYyVTWq8649D13e1J0Fsf2CbnzLWLaa+ISt9kHDRGRZKc8r/jcQI5pkxALxyKNTMOBFitLCrL293BfZYPeOC9AGCCLq0pAZQzMmOhXwlstH7rhmJHjKSU9wFZojI3+FSWPov1DEGC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(376002)(39860400002)(136003)(346002)(451199015)(2906002)(6666004)(36756003)(86362001)(6506007)(1076003)(26005)(6512007)(9686003)(2616005)(186003)(38100700002)(83380400001)(66946007)(66476007)(66556008)(8936002)(6486002)(41300700001)(5660300002)(316002)(478600001)(6916009)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?azqKRAh7IAhskXY6+ZXXg5E7EF1WAoIsfkoy5jmVbdU5wn7sAf73iirMLYcZ?=
 =?us-ascii?Q?1/QwpuhZeB0FBJ5wAVq11Ey4n5L7tbfyFXl/j3iJe0uJeeC/oyBslFOiJ6Q2?=
 =?us-ascii?Q?m6eMOLi/AUtsE0L8VvwnIaWb5pSSxRZeum0mJLItdRFC+OMYK+Zwb52TJBl9?=
 =?us-ascii?Q?LoWPwa37cALe4KVbIVm68otF6FGf2qcYyYr2NdM8/LZGJRKovhy2Stp4zgNb?=
 =?us-ascii?Q?B1qke2b/+gMfnjAFeBtcyIx54vjS5sDL97xSjJ6zNwOXd+qFgUkC28519WSQ?=
 =?us-ascii?Q?Ql7M5lwR+Ajx1ZvcmeZJ8Ved8C+gYtcxl/KeNxN1fp+mEBnMd43m0kFxEx6H?=
 =?us-ascii?Q?oKz+bEKf+/PiIBwe8hACcqmso87MBOG/oV3/SF3ZHQQrGMta9jW7J+6CwVTN?=
 =?us-ascii?Q?d+1Y+5DA8rGfeKQ7/jypuQEudB8IOrr9GH424kVhpQ5/GWnOziMibZ2BGic2?=
 =?us-ascii?Q?guHfgt/wt/PPAmPX1atkReIqeDOtQe8dl3JLPJqXzGiYL/EbXZ6d4z1Augwy?=
 =?us-ascii?Q?LesRf7BWBlPFamn1z+YwdexCMAN7CUYrpbI0uZ8kjGrC9NYCCveeWJpj1cj4?=
 =?us-ascii?Q?ufY5jbpX+vMiri5Ud29SBcKQ/o/LmURyoeKgCz1lN2OTP3kA3JCpUWtr9Wi3?=
 =?us-ascii?Q?2Sk/peZBQfpUd8bLI/2jGnSsU4wy8rQ4obvaqdPzsJoYyRUoXKtIJS1hT4SJ?=
 =?us-ascii?Q?GY4h0HcXAP/r12IS+q7MVHnqyGyDDA5J6jk+TDC3Hs++AAN8m9Bc9IL7X9JD?=
 =?us-ascii?Q?i1TUacWp97Mv+n46ZZ5+zx3OucDQHk8/Qg2cZQQMjbpSR2jJBnHYMbCJZTTF?=
 =?us-ascii?Q?HMRXEiEyFouexbeCYs1ncpR2CDWHR7AC7MoVaV4J2XkJo4TlHZch7nencOo4?=
 =?us-ascii?Q?6w64MPw3rs1CLnGC1AAPpFrMVt14BKw1PXnW3u1PlcJ5dr+W0915UBodNG1F?=
 =?us-ascii?Q?5Of6ghErj9mV+CiTYiO6GwYpCqrw4Lb7806RoSX3fv/6OlS1GuYrwi4rkGjS?=
 =?us-ascii?Q?TwJQjQCTblJ0i7gJtz5X2pk+024E/XiZYPC++M5M8brcwpqOcUVuP85ui0gN?=
 =?us-ascii?Q?wnCrIyoom6m7GPFgvsIytXqpJUvsNywKTfpOeZKsVt3FZGAn+yBZw2KUuRt0?=
 =?us-ascii?Q?TD3ZRRWWulpn2OwAMMjWk+v8mn2fvEnnFYmDN4b5ieyc34dtyGQkxBdEXwhC?=
 =?us-ascii?Q?jd84Xt+yAGAhXC2JACfMvL/VasleZg1mfMRyuBhca8Ah/CuLF7/6Qc8Pwt6x?=
 =?us-ascii?Q?vHE9Qky+SHOlBEl8RU8xEs8YXWwU+rfRqadh91d4PF71CDvbYeNoHb3YAouS?=
 =?us-ascii?Q?lAbOXLaAVskKt+9bHZGPnPkbiQMbVHFjzuToMKvFuXYzD8eGD23Z6irUz3jU?=
 =?us-ascii?Q?c5bsF5VBJled/E4s55Lt7H9BKh7v3P8TQSVNereKbuvd6M3JBLQMzTma0pms?=
 =?us-ascii?Q?DuxlFDn5UixZq5sOY3c1LY7Ck4ZduDSSdNbg/0ViX/VEyiaMyqiGzYRdNOh9?=
 =?us-ascii?Q?eiWcMeqt0aLiYF1uLln2J2GSqD4pM+pbLBOyGVVO5ZQSkw3Na3InK9uCd49I?=
 =?us-ascii?Q?qbML5RwhfJGkQAzt7AUyG5miyb3HYFUntrps/dZpnrXYFplJjsC1qeC2SQiX?=
 =?us-ascii?Q?6w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: g/sO8K0AElG29p5fubZtbFyTb4i/YoZS+Trckg7h3OVSCciDavVO2untRZOFHMMGizyPtj8PJYEpzBSehCX01/shQUMC/pKKku/FJUHTOjOkTrvVATb+2GazSJ+9MBMIGuTpQv9xybhsCVBF6v48AkMc3vEIf+sJ1m4GqNJSz/D8tQD5IxPO+WC0qlrzkjzRcH+i/15MTekL67e5lvx2CboyB6For+xfThmJ2ArhyNATzjVlwbfpO6A0hsAZrPKCTbp8ipL/x+Yt0BL0P4VkfBocFp5O9tB2YEs+Ii5rQ1Dqpnr5hMPtr0ygBj+prKVqv1UueO2mJXK3/c7dz9hjvChoElDBSd24VYrYYcwNsUjG0QgfMfjQNFsbp6NwXvNrQz6LJHWQCxOZg+f2aK6SBFrE8tIXU3J0ZKL9sui7tudvscJdXmWBKRQG+YBLlAMMLaEy69FGxCwwN+JbQWXf9bKW2OnbRUGoZsxOcOpgH7eWa5pXa51hv1lQI2vNMVO6Te/03Oc4HjFnclczv2cdfEI+hJKPxYbevpQu63pJlwwcApKSl939Zw+ElNc0sQKNCJpwDFEy4f2ZV2csylMcF2NXPtX+tQCtgrJM2m100kIUW1Nu0Bj7JJj+AFvLxi6Snm+gaDDGgRQTF2buDTEvhdGFJMyBpuAH5WiDawutgXV7nBX6QjcPnIypGuh7+ZE3meFl4Awy3YCV3+wu03TpPiHi9gYu6Xf/0UHh2uhNsWW02IDo/yY0I5ij2ZqJb5D5uRkxnOIjjOwhko8YEH6z0Q==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e320530-fd81-4e6b-f6c4-08dad24e7a0e
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 21:12:52.4679
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0pIdIjIVi/7qcPWcLF26fa2MFvNaHYmh7/wHOYu1IgqKB/Zht1/reO92PCURIC0ufUHQP9B5sKHlwZvwhU6l8DzAObWGzhea+JoQSG1hcn4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6496
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-29_12,2022-11-29_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211290125
X-Proofpoint-GUID: ucbkKQAbra7IwoxW1_8RCrVVIOkDkGyH
X-Proofpoint-ORIG-GUID: ucbkKQAbra7IwoxW1_8RCrVVIOkDkGyH
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Modify xfs_trans_alloc_dir to hold locks after return.  Caller will be
responsible for manual unlock.  We will need this later to hold locks
across parent pointer operations

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_inode.c | 14 ++++++++++++--
 fs/xfs/xfs_trans.c |  6 ++++--
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 68254fc54fc8..74c4ce44f5b8 100644
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

