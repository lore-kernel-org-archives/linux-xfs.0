Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29B0FC74A44
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Mar 2023 22:38:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbjCHWiR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Mar 2023 17:38:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbjCHWiN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Mar 2023 17:38:13 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF9F34F78
        for <linux-xfs@vger.kernel.org>; Wed,  8 Mar 2023 14:38:12 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 328Jxuqe026675
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:38:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=c2vpJvOtq9qJvLcor06pWWGrAIAYm1ZeINLc4MN6fEA=;
 b=Do/y7YHQCrADpuM27+PmcdDfvyhKWbsQ5G9Fq/OPsDRYGaL5DtdEYfxbM4I92E7voFWY
 gsgejYqIjevTUo0UQ5a25me0LSA7uDzfPmBELjWmN4G0/b/q9AnMFkHepdnWrcld3tVh
 OLWhYq9naliVE8MUbaZt1OrPtdi1yMpYpErP/y2BB4sxUf5Ke2Tif6gjq9leIpS4XKCR
 oEDeEm33sTWPjDOfCD4JsfZXZgt+q+UIWz+zwppbdjoGWvce4uEI6JUJHjAY9JFLp1A4
 hMr+voE+xMGiM3cKJ4DSHQOjFeq8lkPpPk2we3fupKGl1bYJYDxEv5cz967GolSPX6Bx PA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p5nn95qe7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:38:12 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 328MAF4o036499
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:38:10 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p6g464w1m-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:38:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=acvvAXNdoamshUGv5sLgLYOrylmadzqh0xh6IMsv3ZPM5I37Uhlv8pUy0UMtaJrxO89vA1lZBmkjRQ5nJaL4s2DZOvGUR9gfcEYNfpOxOb9Ctww+bO+9C9vJo/v6EgGXf5wegQi7XKkXxZfG8oSSCMTThhUiDF2z1PBHLZd4HR6+AyEampVDRLto9kg9kCLuS8JrasvTC4+O8qAON5iMqYgw7ZvuoIBIPKLfupXBwX/MizxI6UifodykgIreCF2TmX/QTEwljtLsgZpVSEC4khlboh5H0o7JTs5XupfXda8X3nJPl0gevEsRcYm+G6wNs8s1Wcv/3Geux1HKynfe/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c2vpJvOtq9qJvLcor06pWWGrAIAYm1ZeINLc4MN6fEA=;
 b=ReGYP+CrLl2zvazmR4QhXCVAp7FbiCtdyksGTI2aR+fhXmC4hYD/5Doa4CJbIMGGX+CQ1QL9otSBmCSabS8WDJBijpq2I+Op7WGzxgJri8arAe+AGfT3NH0qV5OgHjIJfQdZNRUOmMlRxHRhAws+xmlkLmmmGYhspcny9kLoWDnhguhglvmYMqr/8x9ERSP29mUNnjaxzaJevy9VMmLlnmnZrOufpmgeLu0XvriKmexT4EqWUcvYh29et+byF+byiFMP4ckuLKRfF1jI+XqktqeBKthW0BN1SkFs+nYakq0kWBLnzFLt+P7edV4/Qvo6jEmHY2uKYXhXwrD6xeToIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c2vpJvOtq9qJvLcor06pWWGrAIAYm1ZeINLc4MN6fEA=;
 b=qUtQu//pnZvs3r5xXZEEpQNrI9IYc9kQXRVbG8oSlo7N6ZSXodAUWeglWg9q3TBbZ/PsbjoxpAt7vLtVE2jo62//+lazfQ3w9i+K4T9mHNkW30o5cGigte9ni++9+fPynKN4+K0J1513Kr4U5p9WHoqEB/nDjg6+g43pF3j1qDc=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SN7PR10MB7102.namprd10.prod.outlook.com (2603:10b6:806:348::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Wed, 8 Mar
 2023 22:38:02 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06%8]) with mapi id 15.20.6178.017; Wed, 8 Mar 2023
 22:38:02 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v10 03/32] xfs: Hold inode locks in xfs_trans_alloc_dir
Date:   Wed,  8 Mar 2023 15:37:25 -0700
Message-Id: <20230308223754.1455051-4-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230308223754.1455051-1-allison.henderson@oracle.com>
References: <20230308223754.1455051-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR04CA0004.namprd04.prod.outlook.com
 (2603:10b6:a03:40::17) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|SN7PR10MB7102:EE_
X-MS-Office365-Filtering-Correlation-Id: 66a6ccf2-ede7-4bf5-99e6-08db2025c6a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EDUlBDicFDoBdA0DrfjxEs9mCslwwHwg75tH0qete1JgS2kbwlH9gOuMcGPpqL7uD1OHklhXNSUNnW4U87ClD1t9KP7XQ99AJbhnud/StvHvjicRA+rklwgiDlAuJjmSbhk2vLrouBDbjwpVmcwbW6FdBHYjsJrx+wfQ3FYmPrt/3GKDYmXLsKhPqK8Aayvj16P0q4mrPYE4nwMAkeBIpu18oSGhf21UTuzcFmx1E3Mqb39AJ/ufJe6Ptd4v2j1gFh72bPGipueXfzLix3iY9VUOWqV8LGekUQ/tli59dQp8RnADSaaZZlYigXSPOzTZOclOr+1ktB63bY55acFSESovdIG5kLCwQgfgvw49EaF+xYB2hr6v3M6MZn6l3sUJmW9mbPGX3b8weZSk9DCz2jnHNTZ6M1ksrU90WosqGO4lZc0EBMrBpSdijaGGtzL+txxDifO4jgTbtqnAgn2I4Ti8okdZ/Y+VB3Or/YveDOY7ZB4iqSKa6pJ5yM/lRvlsv+7QndiBQcj3HKRTyvTPtzAv7ngAvrUuOrQwcXRXJOlGTnbngAjH8GWpHwU9CY4m2JUMMLy779U8DeZf3WzXH50mfNecN0OHoB3lEM1eS/3yQ8dB6XPcT6XkSLcVkdhOiRvOdszYHsZujrLzuZYNVQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(366004)(346002)(136003)(396003)(451199018)(36756003)(6666004)(8936002)(6916009)(41300700001)(8676002)(66476007)(66946007)(5660300002)(66556008)(6506007)(2906002)(38100700002)(86362001)(6486002)(1076003)(6512007)(316002)(478600001)(83380400001)(9686003)(186003)(26005)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VJxBhiUCZMZcmXG0NIWxtwt9aGwUpJ/XcU5UTY6VUpbEXWSPicOA+mVezU7W?=
 =?us-ascii?Q?ExXF1u5J4dCXEGgexTthr0HHzGJ5/T5UmvroTUEdSwH0RT5Af+70jNbJ7Roh?=
 =?us-ascii?Q?G9PtWO7OlMhXT6eDNtvP8TIYo7s9ZP4rr0O5nIiKqPdQat5m0BTE3Qm8dNlT?=
 =?us-ascii?Q?ls+0oEvHxqjD2Zcpt/AV6T1lJET9sloIWvQwxwLX7S8fCOSx7933pqlOEjvn?=
 =?us-ascii?Q?llpn/wX5Rfi9jBXm5bVWP0pzrT7l87uIJuB29+IQIhrJA4n0k1oTD6nteBbe?=
 =?us-ascii?Q?kQ7xnjYj2RCxihrRBQFpyosys84fuEIENQp3ypEMErGlRzbclUaRoOYysH+s?=
 =?us-ascii?Q?cri54Kj3fmR1mWd79zm8r5OxFj01+Vr4prngxPqAWFxvtxorVzzBliVoGQDJ?=
 =?us-ascii?Q?fVCyO1WfC+1q5BN7UPkrr+auZxHJ2psnpWfg/4nEiecSxD6+mTSCvcAC0Ms4?=
 =?us-ascii?Q?T1ZYc0iLsjlVfZX+czraLyXfhNcXiMUU5WOQt2FPve+CgsGKyQL7Gw8TTb9A?=
 =?us-ascii?Q?AaNGKT5LgepkW2YFqB4n6gEgnxm6nFMdext+hJZWhP/hgiUYZgiuIPy2RqnY?=
 =?us-ascii?Q?b48xlMa+Nd/GDfE1FwQ4mE8AS0+HIcRv9SSbZOUK83nq9ntUJHgDeDuzrWOq?=
 =?us-ascii?Q?1eHSptYrtb9rs50mxxc9/dCwfNSVby/ZPCb07fsZVXGhjjuYPe5/MAuKlhug?=
 =?us-ascii?Q?KuhAgs/6q70FE1RuowyU7IQu7qLsUIvvE6IWGJC4fKiPPYy1YKmSGSZ3mEy3?=
 =?us-ascii?Q?PsuvO8HweBEA5PCmP4EKVSXc2RLAw2nNcoDAAFPMAvkwxqP6RKWMUIutrLdr?=
 =?us-ascii?Q?h3FwruAkzYsIhbbFX/qJ9uTP735CX7rL+b9hiqd3Nwy875oNTdqiWUA9Ro2P?=
 =?us-ascii?Q?ykdICyV9lW/9IQ5YX1IlkfDSHfQC8Q/uY9J8CXDoX7WK8tFiv5u5pQ8SkXFp?=
 =?us-ascii?Q?vpE79ongZ1tKcJBPDj5OYuHSWvO4oWlWHkW5RbcyRJMY0Rl4AQmildym8jb3?=
 =?us-ascii?Q?69zySi2vR012i9fSvGhO+86g8vNPmjHbO0dafP4yzdTQMduWx6ZwCbfHx60s?=
 =?us-ascii?Q?6aQQ6N0oewucM1x2A83ne6/qdvKdKg0/2rFC3dhyiDW2YjXNUk02hva6W8sb?=
 =?us-ascii?Q?FhmkcQNktPVLPnbos3XxwJtUhxGJsVMyPbBkZUtCit6bAEa+dgwbnNT7pY+m?=
 =?us-ascii?Q?onH1XdP5H6N7qMi7HfZFzcfj/hUWqi8z58qq+WuUhC/8o5Qx3H8Xm/9yYBU5?=
 =?us-ascii?Q?D1V/2Oy6690iMcoTC+F5ebINLdUIgq87mQiiYUOZUkg6KW6iQd6kuj+fCOM+?=
 =?us-ascii?Q?tYoqPcHLxFhAatDk7HPzcejZqJ28bOTHSNJc+3F8D8ZoPPeSiNYg7RFkxJhn?=
 =?us-ascii?Q?KhUxuA9qK14sz5TQUTJdyBgPWf01sZFSuj0sU+BpEf9UZfK3p89wnx+FMH1o?=
 =?us-ascii?Q?ScJvh3bF3gQiFSe/H4t4cI1fPDb/JQxa++oqt5QOgwQu/0hbHbsg3H0Z+zgs?=
 =?us-ascii?Q?tbYBLzmM9hJ/OP8qmO4zveSIGne9Jeegcz1No+EkFen+3NyVAIWTKcIrk6kR?=
 =?us-ascii?Q?9y7d+gIxGW9e1KojJDaZ3dAJjHuaj3Smk/vhKb7yunIHW5cdd9UzY5inotiP?=
 =?us-ascii?Q?dw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: XDWCIOd3INUs7o8EkX+jFEJhv0dsjfiy5mkAds3QT78rLrnlw3gKWQ/HCWEFmaIpHo7iI7CD9dAVflMlB/RVHs3umMGhH+Pe1RT/Vly4oBl4q+XLYFI0MS/Alme9DhfZaZjKiRukVC9EsETkBsD/O2OTCcWhjyGunNEm8u7MebYYi3xIrfXic2TnvRNuJfl9ZoNvxzF4Gye9aptRCcteNCr+ukR2M0PZIYHo6EJ9NMctC37/vwfXE0REC8IMw1d3D81aYUvfI4ULYNLAryDSfAAlzNJwRUqJ0a46kA52egc5zvB9g/PEgFndrlmM/9TSljPZxrFvX/6vV9Y0fRuBrlOGNUoutT2KkYJXIfjBkmUIqwDWyHdiR5+pZZq5tQMQD4Bhh5B71FIPWAeJYVCn06HTQofi89Q9jOK1UKRem/adPA8DgezIqHpz49WyMf/r9K6ry+6n1TAE+pmGgYI0hF6G9766aBPcFfJZ4yb6rDrU3BobaBXaKh/MDah/DBxCJPu3dj0cfAqZ0MNFONw80soUNv7YysYIjD8zVGdtPoclWGH9IAJD7u+kZ2FDF1t3SLNyTWVPkJ0ZpvXZfwyWY6jGVKjzh5gQTEI453N85CO3BxWu+bHOVCiCrXaSfe/uBVn6u7pXL1AnqVO08n3bqx8jzYJKky6TeQ7hQnRct1gMPJeUt1pjqStK42kTWL6UynkGKSodQg19WFmie3HU/n0xRr45IuEFqkfTxtpvKZlJ2YTJ/xEnlD29l4Xf5lrnMC5jbTMda+lo7Gx3YkrZEw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66a6ccf2-ede7-4bf5-99e6-08db2025c6a1
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 22:38:02.2991
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mO370knk0nFr1AMFwfUSU/g/AdhWsAz9R7JwANykE0Y60HuAhZl1uM41yVrHRtRffovQtiBdTgNJc4N5zOmKUsB5IfbHVOwM58TxT4ctGjE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7102
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-08_15,2023-03-08_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303080190
X-Proofpoint-GUID: q_uBHbDzXl-OF2JHVkruDh5GELO11THB
X-Proofpoint-ORIG-GUID: q_uBHbDzXl-OF2JHVkruDh5GELO11THB
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
 fs/xfs/xfs_trans.c |  9 +++++++--
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 16ebe144687c..fc730c573eca 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1279,10 +1279,15 @@ xfs_link(
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
@@ -2518,15 +2523,20 @@ xfs_remove(
 
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
index 8afc0c080861..7e656dd42362 100644
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
@@ -1410,6 +1412,9 @@ xfs_trans_alloc_dir(
 	if (error == -EDQUOT || error == -ENOSPC) {
 		if (!retried) {
 			xfs_trans_cancel(tp);
+			xfs_iunlock(dp, XFS_ILOCK_EXCL);
+			if (dp != ip)
+				xfs_iunlock(ip, XFS_ILOCK_EXCL);
 			xfs_blockgc_free_quota(dp, 0);
 			retried = true;
 			goto retry;
-- 
2.25.1

