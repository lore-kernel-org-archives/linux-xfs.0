Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CA4EC433FE
	for <linux-xfs@archiver.kernel.org>; Thu,  5 May 2022 01:18:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233344AbiEEBWG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 May 2022 21:22:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235175AbiEEBWF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 May 2022 21:22:05 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3201454F8C
        for <linux-xfs@vger.kernel.org>; Wed,  4 May 2022 18:18:28 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24501C45018676
        for <linux-xfs@vger.kernel.org>; Thu, 5 May 2022 01:18:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=XOFqEtgr8UshzvLqxNIxsmSXZ71VsM2vD1kuubkt6EA=;
 b=aLPvV7zbH+RpKBeUz41fDnqXOUijZkSzsownnQn0BXrbSztOpcOcdr6nepoBq+Ml4+WS
 +Z5cvWX9f2ub/x9oxzY3/WK7cWlvi/B+T8xSs51pHBTgfOs90TGZufsewyVBdP+EFQU9
 k6S61+B9g0AOtf9Z8LhS2nEOwQdLUDJr18e7MoUFKO/3F5EFUjOrW7RFE5srJrggvIsd
 vZC7UeoWOpHzEarC/BjoFmTj3j5EiyBN7rb23fBu8lvsgCdYUYmZtxoE/djMOyEcaj4w
 aoL4/8VPrXQ/wewuJ3UnPseotInud4a2jesqq99Whle5ldWKsDUZ7FGAT0oYEZKh3xpz Aw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3frwnta2gp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 May 2022 01:18:27 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2451AgXQ006894
        for <linux-xfs@vger.kernel.org>; Thu, 5 May 2022 01:18:26 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fus8xd1t6-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 May 2022 01:18:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LidBaEBRoIOKBLsRsSi2lulbo9CSVgDiB/Y/Tk/4YusiEPGgiPocJ+ZxtUw5Jnsb7WpopTuaUHpzjgX5SiY0ZdFAI+d6PmjOS5KcbxeBD4Sx0j9Bc4hcJsAzY50vXnuXaV2c1XAL4OynQGuHFsY+XKFa+uBKf0mMvlzi9ek5yJFFMlG0lNJe0LCvtZKJevi8LEl72otyw+TTx3rPD8+WThT24ICjahcB5U5ggyRNfJzoiXYQ+4wyFdL2OnpYJtL7DPmI2ATAeX0s4Uk1wDYusQzg+P6qAh8qPb1M9C1uvMtu3XqsoxavkqdF1OHZq96WqiGrHXRajne+V5alIEiXJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XOFqEtgr8UshzvLqxNIxsmSXZ71VsM2vD1kuubkt6EA=;
 b=JpeYBLrMi236loDJr7E/R3lnet3VeZHP77KcX/uVX8aA1FhaMtRkjgCIKGXZ5YqiAm5SCvtbXl/4MIgZEyKuK3yLbsuky5Isripi0WI/JGlO4Imz5kiQKajHB2pQ33GPWyp58TKlWkvOlAGnwN48MYNknFTBBeJwCdKXgS3vzpyL3S2A38fVe5eseH8RGFq3yFWGLrTXtGsJyaxGS7accImHrFx2mcJ8zRcqRjjo4IW5FHqzaqXhWaYe+m02IPIhuI8+A7Nb97T5F/e9Qo5mIpoH0bAF+rJd0PakdNeT3t3N3qGX7Ap5dQuDJIfMzcQURHuT5YrLvKT8197SeFEdyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XOFqEtgr8UshzvLqxNIxsmSXZ71VsM2vD1kuubkt6EA=;
 b=GksND4/MsEkLb8qnVkXGlHe/w8sB58T3eexnYfSfRYZTdRT2s9mp35JqH/4eTqkQSZX1zIL4WdAlg54Bo/k9Ss3CshtP/3ckPuIX329TUFVR1IgRCCOzC3Eo7Bc7UaoLrZmGl9u6P8h0enHVdb9dt1+sDQ7bTEtpanX9dfvFIPQ=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DM6PR10MB3193.namprd10.prod.outlook.com (2603:10b6:5:1a6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Thu, 5 May
 2022 01:18:24 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::8433:507c:9751:97b0]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::8433:507c:9751:97b0%3]) with mapi id 15.20.5206.025; Thu, 5 May 2022
 01:18:24 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 2/3] xfs: remove warning counters from struct xfs_dquot_res
Date:   Wed,  4 May 2022 18:18:14 -0700
Message-Id: <20220505011815.20075-3-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
In-Reply-To: <20220505011815.20075-1-catherine.hoang@oracle.com>
References: <20220505011815.20075-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0118.namprd03.prod.outlook.com
 (2603:10b6:a03:333::33) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0ad444b1-db34-4923-ad8f-08da2e352691
X-MS-TrafficTypeDiagnostic: DM6PR10MB3193:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3193C51366DBB5DDB891069489C29@DM6PR10MB3193.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m3Jlt/KJseqtd6OKg80Jk8O8d/NoC7eLhRDF5W3UllocVyVDftTIIfbIsi3XB19zSzBv8zE59tfIu/+DcDtBwu/34bXdWtyiBoIle8/S1kf1CTnlryA4z0jWIf9LQfG5FBA+HA1QAIiDUFmUM5D2JYJZPBgizGja7AydIShGzC0OGsu9gq1/DDDCbW+rsAfkxb+K2sjk4Rp7i4o6Gaa09HrbAYgpWbMUn//6w06xXoTI9pFd38iz5CAOSslGbXh12AXXw4MDdLQ9Xc+POMU0VM7TtTgnXGK/3n3pl0C1g5TwDBSp0nX8GfhRQ50UbJpbN+6DbPTPdhOMDMCqAhYO3gQQKkotefTlXNyk7iV4laX51TwA0wG6y2sM1/wzruF9S9Nzbl0H+/NEQHtHFRfLUvmuTppTKSRgJPy368iV9w7/Z9thtNpTpEwpJM1HVKps9cyk2l8cRWMtyX1uK/SpV5MEAg8hX6ImdI1cLtpce5Qwrg2TBZCOl3eyHQlVthv1PEHmhLchuBz5ZD5Lr2BT9h12ldnOa+PLXsyMUXaWZgvk6K278YzLyXoWZG09UQcZnDcvWOtpHb1eu/BnUYjfHFwpY8JhGJOaS98EDaJ1WQBAReF1U01UiDDZRg+U8ykvK834ay6xXstJGd1IyOs/JQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6916009)(6512007)(6666004)(44832011)(2906002)(38100700002)(86362001)(52116002)(6506007)(508600001)(316002)(5660300002)(83380400001)(1076003)(6486002)(2616005)(36756003)(66946007)(66556008)(66476007)(8936002)(8676002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5GAn8EstxfxePvZt/AGIFx9yuKX3R4QFtB0TNKSB2Ii0cd/npGJZ1fn/bvk9?=
 =?us-ascii?Q?o6IajkwZeXlCnEB4RXV+bpj4nlWVPQL0aOSEh/3RCFGSFs+tLIgqX2OhInEP?=
 =?us-ascii?Q?2tpmsmgaKeFt0uaz98lI1XRYRxsSPEMGWBc/1nNI37Tsw7ZVcOuWG6tjLKM2?=
 =?us-ascii?Q?XvTUTND3LbsBdi3D4DQdUrb+P428o8vaMz0EyDyVsbnvbN/lFl7BTWK1dYCD?=
 =?us-ascii?Q?f4DetgLzVUNqEAwLUY7uFwX6AT5whJhA6y+3Xc8nIdLN01YB59MBowwWxPTG?=
 =?us-ascii?Q?3EorCjLOETuvczuxpuUvXjMLhrRHE3NgSS2UYsUnGfpOUI8DjXBXp+L83+lk?=
 =?us-ascii?Q?9HneE++k24QYVzFCIAtgi6WEybf/ltXGaWjkw5m+6zNpxl89/14JfmjJFftY?=
 =?us-ascii?Q?78+6OcvWs6O7Z5IOdG837bfAm/FpUhLnYQ5baXYX/qZa01m/0fJOE2VBdLD9?=
 =?us-ascii?Q?LoddNY4p7MasPcsbwsSG96OyQaXm+Cmbd6EAB7z14Iqy/fY5UiPO66IGKKbq?=
 =?us-ascii?Q?6heRIWqTQvLpp7h3giVoYgbUv8A6NKD9W7+70yF2ZmrMgQnrH0fo5MZfqntk?=
 =?us-ascii?Q?MnzmvLxyi5Q9CcS4/7kgO2l74aFflyxN+eiWiz04wiTScJO81w4lGHh4uBuX?=
 =?us-ascii?Q?cFR3QNLg3kXZVaGWOByFg72LEvvnDRKiguk1X5RRnGXrVh77LR1BuoFHs01U?=
 =?us-ascii?Q?LTFlIgK9A1Vp71/XknOWoAD6zdOHsszU/2vSXYe9oF6LMUzkSsMUade7sgeT?=
 =?us-ascii?Q?3uomls/IhpjUKnF8IiRaEt9R1yFuOl9Kxszf+OmmY7k+dzI3cWjPxSW8ja3h?=
 =?us-ascii?Q?awjMJ0czM0aox3cc46gUpdkxj8Ozm/PHA63/ONEF3T5LWV1RAbvLEHRLgM1h?=
 =?us-ascii?Q?f4oYH35XZaw5gGMZUfcZELKiFxOaL0u8/4M3TPJEOcdByw56HTjD+LmwgUcO?=
 =?us-ascii?Q?auZ+JJSPa9tBG4tAnfL6KA7e1c+Ku3MKPyzORIKB3GT8dvK3yLi3ibakvP5d?=
 =?us-ascii?Q?/qNpZBnJs/Gg0V5d7EoZ0l3YW7UZgI6/q8Orhk3Sz2aJA39nkZ/hEkyCX8ci?=
 =?us-ascii?Q?5sIbFDvb6fs28lnL0oAKTfoBHOnQehW50yLt4hRbmdzmWVRX5lNalP3Dwyzu?=
 =?us-ascii?Q?AQdtdoctFI7CbvXx2rsgRe7Ajj7CO2XbIpZQPm1Hgn+GcnuU/sVCN9pp4tcA?=
 =?us-ascii?Q?0/DTqwEh5N3hjoqCUOSSZ7nubBIQxmVfP1qn2dxhqUuFmFNuaqPyiNWQ9lPU?=
 =?us-ascii?Q?8V2q0RLMsd53trCXDEevEvutb92ew/j+wShONxWESbHpW1I9n7cByLDmTVh/?=
 =?us-ascii?Q?nij4Geb2q7tWzBmv9Z6XOyW5UbF5i+nUJl+cRkwdmYZZv9xvdqv7cHmXb3UT?=
 =?us-ascii?Q?WTrZfLGkKG93Sb67gPf9BUNYPZDqn6n33MW8GSLrXKfKwzVhQRA+aEGRIVjL?=
 =?us-ascii?Q?zf6/45wMgL8b0424wywYtqKY5g+MZ/mMD6T0GZHjMwFXG7Q+qn7iaQ2af/RZ?=
 =?us-ascii?Q?RBeUWXyruix0ETVk20dLMgDJAv6FWnBnfLCb/ONKLvS9dC6x1+UUe1dNC3l0?=
 =?us-ascii?Q?droOL7TK2FQA1Ryx8e+T09E8vBQrOt4Mwk3WV14vSRvvk2XPE4244vkR2Z0K?=
 =?us-ascii?Q?FU70E/0fljvvXIAeV1ebMgCUZQ+AJypD4Zy9MBm+g5vL4Z2y0rIx7HqHnaAP?=
 =?us-ascii?Q?3kuON8+tVYVLpSOqu6L81vRMyscbgq2dxmJ/vuV1y+qN4FRANoP2gKl640OU?=
 =?us-ascii?Q?rMwTG/C2Oxq9bUxKNXH+2D5WFDFvJ9n6BEi2ogVuPW1Z6AwGMZUNsV2Lp59i?=
X-MS-Exchange-AntiSpam-MessageData-1: ziYsQBsHVIB2+Q==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ad444b1-db34-4923-ad8f-08da2e352691
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2022 01:18:24.3291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N6+ZMB+3iatXdAoKpmrelx8kEHdl7uGPhhrSmpXotQx+j8YVVI5zKh6vN/0URFY3AtpBQU0Be2EatEkjNGgELn4rCe0fIw844ac1tPdoIec=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3193
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-04_06:2022-05-04,2022-05-04 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 mlxscore=0 spamscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205050007
X-Proofpoint-ORIG-GUID: 1hdxzC3WkWxQ-9cClrYWRlgCF_7qVOST
X-Proofpoint-GUID: 1hdxzC3WkWxQ-9cClrYWRlgCF_7qVOST
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Warning counts are not used anywhere in the kernel. In addition, there
are no use cases, test coverage, or documentation for this
functionality. Remove the 'warnings' field from struct xfs_dquot_res and
any other related code.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_quota_defs.h |  1 -
 fs/xfs/xfs_dquot.c             | 15 ++++-----------
 fs/xfs/xfs_dquot.h             |  8 --------
 fs/xfs/xfs_qm_syscalls.c       | 12 +++---------
 4 files changed, 7 insertions(+), 29 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
index a02c5062f9b2..c1e96abefed2 100644
--- a/fs/xfs/libxfs/xfs_quota_defs.h
+++ b/fs/xfs/libxfs/xfs_quota_defs.h
@@ -16,7 +16,6 @@
  * and quota-limits. This is a waste in the common case, but hey ...
  */
 typedef uint64_t	xfs_qcnt_t;
-typedef uint16_t	xfs_qwarncnt_t;
 
 typedef uint8_t		xfs_dqtype_t;
 
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 5afedcbc78c7..aff727ba603f 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -136,10 +136,7 @@ xfs_qm_adjust_res_timer(
 			res->timer = xfs_dquot_set_timeout(mp,
 					ktime_get_real_seconds() + qlim->time);
 	} else {
-		if (res->timer == 0)
-			res->warnings = 0;
-		else
-			res->timer = 0;
+		res->timer = 0;
 	}
 }
 
@@ -589,10 +586,6 @@ xfs_dquot_from_disk(
 	dqp->q_ino.count = be64_to_cpu(ddqp->d_icount);
 	dqp->q_rtb.count = be64_to_cpu(ddqp->d_rtbcount);
 
-	dqp->q_blk.warnings = be16_to_cpu(ddqp->d_bwarns);
-	dqp->q_ino.warnings = be16_to_cpu(ddqp->d_iwarns);
-	dqp->q_rtb.warnings = be16_to_cpu(ddqp->d_rtbwarns);
-
 	dqp->q_blk.timer = xfs_dquot_from_disk_ts(ddqp, ddqp->d_btimer);
 	dqp->q_ino.timer = xfs_dquot_from_disk_ts(ddqp, ddqp->d_itimer);
 	dqp->q_rtb.timer = xfs_dquot_from_disk_ts(ddqp, ddqp->d_rtbtimer);
@@ -634,9 +627,9 @@ xfs_dquot_to_disk(
 	ddqp->d_icount = cpu_to_be64(dqp->q_ino.count);
 	ddqp->d_rtbcount = cpu_to_be64(dqp->q_rtb.count);
 
-	ddqp->d_bwarns = cpu_to_be16(dqp->q_blk.warnings);
-	ddqp->d_iwarns = cpu_to_be16(dqp->q_ino.warnings);
-	ddqp->d_rtbwarns = cpu_to_be16(dqp->q_rtb.warnings);
+    ddqp->d_bwarns = 0;
+    ddqp->d_iwarns = 0;
+    ddqp->d_rtbwarns = 0;
 
 	ddqp->d_btimer = xfs_dquot_to_disk_ts(dqp, dqp->q_blk.timer);
 	ddqp->d_itimer = xfs_dquot_to_disk_ts(dqp, dqp->q_ino.timer);
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 6b5e3cf40c8b..80c8f851a2f3 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -44,14 +44,6 @@ struct xfs_dquot_res {
 	 * in seconds since the Unix epoch.
 	 */
 	time64_t		timer;
-
-	/*
-	 * For root dquots, this is the maximum number of warnings that will
-	 * be issued for this quota type.  Otherwise, this is the number of
-	 * warnings issued against this quota.  Note that none of this is
-	 * implemented.
-	 */
-	xfs_qwarncnt_t		warnings;
 };
 
 static inline bool
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index e7f3ac60ebd9..2149c203b1d0 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -343,8 +343,6 @@ xfs_qm_scall_setqlim(
 
 	if (xfs_setqlim_limits(mp, res, qlim, hard, soft, "blk"))
 		xfs_dquot_set_prealloc_limits(dqp);
-	if (newlim->d_fieldmask & QC_SPC_WARNS)
-		res->warnings = newlim->d_spc_warns;
 	if (newlim->d_fieldmask & QC_SPC_TIMER)
 		xfs_setqlim_timer(mp, res, qlim, newlim->d_spc_timer);
 
@@ -359,8 +357,6 @@ xfs_qm_scall_setqlim(
 	qlim = id == 0 ? &defq->rtb : NULL;
 
 	xfs_setqlim_limits(mp, res, qlim, hard, soft, "rtb");
-	if (newlim->d_fieldmask & QC_RT_SPC_WARNS)
-		res->warnings = newlim->d_rt_spc_warns;
 	if (newlim->d_fieldmask & QC_RT_SPC_TIMER)
 		xfs_setqlim_timer(mp, res, qlim, newlim->d_rt_spc_timer);
 
@@ -375,8 +371,6 @@ xfs_qm_scall_setqlim(
 	qlim = id == 0 ? &defq->ino : NULL;
 
 	xfs_setqlim_limits(mp, res, qlim, hard, soft, "ino");
-	if (newlim->d_fieldmask & QC_INO_WARNS)
-		res->warnings = newlim->d_ino_warns;
 	if (newlim->d_fieldmask & QC_INO_TIMER)
 		xfs_setqlim_timer(mp, res, qlim, newlim->d_ino_timer);
 
@@ -417,13 +411,13 @@ xfs_qm_scall_getquota_fill_qc(
 	dst->d_ino_count = dqp->q_ino.reserved;
 	dst->d_spc_timer = dqp->q_blk.timer;
 	dst->d_ino_timer = dqp->q_ino.timer;
-	dst->d_ino_warns = dqp->q_ino.warnings;
-	dst->d_spc_warns = dqp->q_blk.warnings;
+	dst->d_ino_warns = 0;
+	dst->d_spc_warns = 0;
 	dst->d_rt_spc_hardlimit = XFS_FSB_TO_B(mp, dqp->q_rtb.hardlimit);
 	dst->d_rt_spc_softlimit = XFS_FSB_TO_B(mp, dqp->q_rtb.softlimit);
 	dst->d_rt_space = XFS_FSB_TO_B(mp, dqp->q_rtb.reserved);
 	dst->d_rt_spc_timer = dqp->q_rtb.timer;
-	dst->d_rt_spc_warns = dqp->q_rtb.warnings;
+	dst->d_rt_spc_warns = 0;
 
 	/*
 	 * Internally, we don't reset all the timers when quota enforcement
-- 
2.27.0

