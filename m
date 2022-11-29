Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81304C46467
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Nov 2022 21:14:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236895AbiK2VOK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Nov 2022 16:14:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237107AbiK2VNs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2022 16:13:48 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 808BD1571C
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 13:13:22 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ATIXUhh031406
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=lIC8fdeyODQX4149WUoke6Xnl+AOfMDBbJODIBnqukw=;
 b=BNQV6tItedUSCi5FuvE5c6lUMjQ4BT4e0kq0hP8pYtV+K4u9vz6fdbWzupI1aT5LhL3p
 zf27LE6rlvebODh32YKtGVNkYY09qX7Ayuqb/iibMM8P5X6URybvrp1idKK9g9RvyWKa
 oMz7U3+Ma2Z2SMjpvixZoNbk7gwQyz4S5mwmiO6qOy1al07Cak2nSW+8ddc1HBTvnLtE
 Dfd1c0/GluNaJ4s6KSfFTlRNpBtv3ECTuII2vE+fTCEOzBT7/MhG7qQBHU8H97UghT6x
 DnzB+oiZDnw5mdxCxvyPzxLbL3MCV2Lvuz80PYldC7JtgniIX/AoWO2WpR6kJQEp6wHO AQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m40y3y5qs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:22 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2ATK1NVv011552
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:20 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3m398e6xxx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mwm93v3NH2XqR8J5ykOQXBiJY3f8ye7eUiiqTpDhgOY4xdi9I9XVgQAu3MtkvJeJH7c/j+xsI4ScfRW92Nw6hHRVqEFi+hyJTfPUkuy40du1wuTEnlqEkSYg4Ze8Gl5ksa2tZrgzo8T6i2uwyrzE0nutPcCiP6Z3OUqA1UbBk8/NuF01NKEs+QsDqaIqhtIkVoJC2juo7kcWdhK5Reh2Kjj4dmZD2xlmezQwAjep0sBFmTWGlYLXvQkThaXIk6SX5BNZ4Ip3MSLN47EOXiqm7W7lBiyfIMHzhezZvpRdxnGi8Hf+IEc8p+2iN/xnuCT/EhJS74D8CuXXbZ8lfEGLNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lIC8fdeyODQX4149WUoke6Xnl+AOfMDBbJODIBnqukw=;
 b=ifiBkEQ/fWfmIOxFp14925qvdKt9Tftnfg5IV7zaUUBiJh+nZuXM23FdDVLev2dbHEB6ZvjmEgbjjJdGGx2DZASU5wtknnYQFecodCaKnpn4PDZ1SPLzg5Fhi+86exK3UXsQmwSwu035wMVXSuEgPMuWQh5HTRfbUig22ze4i/PGhRCJ2G+LoyjOVUIDx4UiFppA/yZZC7UoiFKjIvEyPPShQveowyOHAcJ++VmYC1a45TZEtypHvUu6yKieqCHQ6QnYP9hk5ebQ0BWn4p6iQcY0fC12b4gPhnOjwbSQzbxNjAAMOkbRR/fn/eL+2bP9BdjNqPLm9LfPDiKePRLsYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lIC8fdeyODQX4149WUoke6Xnl+AOfMDBbJODIBnqukw=;
 b=rjU89UlRl1eabwgCU1t9GNJSpXdR5n1Z+okW6bb0H9rcrCzc1YlyIScwJ3lMTE/TWGWZKSlUi1O8ObNpALO8dvLkk0u59BxPQ0eBCxWb71btUFouLLPzQaDLmUVvHB4cRMRWmYqdlklD+o5W0L8mf4dRfFazBSsTP7RtHdDLSbI=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DM4PR10MB6205.namprd10.prod.outlook.com (2603:10b6:8:88::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.23; Tue, 29 Nov 2022 21:13:19 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c%4]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 21:13:19 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v6 22/27] xfs: Add the parent pointer support to the  superblock version 5.
Date:   Tue, 29 Nov 2022 14:12:37 -0700
Message-Id: <20221129211242.2689855-23-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221129211242.2689855-1-allison.henderson@oracle.com>
References: <20221129211242.2689855-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0040.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::15) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|DM4PR10MB6205:EE_
X-MS-Office365-Filtering-Correlation-Id: 01f0c371-aaaa-49b0-f10b-08dad24e8a0d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BgNDiCaCR4n3Y7NaY8opmRSUeGATz/svgSKa994njyt4zA43bNOcE2BnD6hhTBtm4ovY3UYFsNmWOnxrioRqRnrvOP2fO3L5Dr9hFlDXZCAlO0Il5Pq+OL7ofpiTHWrwF2ZVyLnEBlUkosvH8A1wOT8Dvin1RmU6WgBdMMdGs2TXHMPXDcul93Rwtd3nc7EDp5Qs4DXmodrCnviXX/7MMOAFYTsg8U3GLlNVIKSqUeX2ilItnFsGEamFLUVzOLjMELmgC7uNVaNEtDy824NaZmmZVIFfHuvE6laqJtfaV6/tBRzQcOzb+5RwQULquad2NlOfmBhpukyzKwVqOENCCmpZkmUL7TCUxEJtldvXTKKeme1nKG8L7mjcoFNy9wQBcM5P93cQ3OG0IqS1v/EgbWa6dipxpQ2TmoTHlnTY3zaUutXLooiE1tLDH2HQz+ThjdsND7HvZob1Tr9/TcXr280VA8Z3PSub4fQxUgV3ZYUSYICFw93+WviLM9vrCKPyFbDTuRr7IXItbO1q06mI0owI1FfkJNlHmPhLZ1lezY2LBiH1wu+z/s/5llT9BxokZAFFnEdsvkPE2UbGyvbq61i/+Zh2vxRFMSHKrdayRTxZbY747gPgmeTzIRMcukjb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(136003)(376002)(39860400002)(366004)(451199015)(316002)(36756003)(83380400001)(6486002)(6916009)(1076003)(2616005)(186003)(2906002)(41300700001)(66556008)(66946007)(8676002)(66476007)(86362001)(8936002)(38100700002)(6512007)(5660300002)(9686003)(26005)(6666004)(6506007)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?imSPvx/w+ETVcNmm2eIDmIm7DM3j7z3j5orzAAOp/2AjHLnaQiAM4xLhbIZU?=
 =?us-ascii?Q?IemlM43rKl24vFl9sWWoO2D6Yf5fslvjDqLHeBmSCjQ6YVQsWWNySgRPJvkt?=
 =?us-ascii?Q?2McOs7Ak9LmUcV57lTPpht5Lgqul0cgarxq5xcHLkFBeXSfeedO68ahSjAsJ?=
 =?us-ascii?Q?aP27+uKnxBilC+m8uawtSHqi1kXqY2CeYiGyeJNOvhHjxLAt5b4lzU8cG4qb?=
 =?us-ascii?Q?ivFjFKz+wIZd1C7Rq/uW1xTTiI3NXqEshHFlaUNDeSHa9YNJdOHRmCJVONPT?=
 =?us-ascii?Q?P5fRGEH/bR9AMQI3BVhQx8p/c8DjkEH+T8xV2j1lv/k5wZpTTThjK2uthYGa?=
 =?us-ascii?Q?2OBaqeLpRCvw/qqS0W7om/9jq+j64tuUdaJagwniNEdkpnBUdybdAHxW3O5a?=
 =?us-ascii?Q?eDmGmZwGxO+1BeD+ko9IJZpXXQwqsjKqfIklfd++jUCuFDxeOugeX5HmumxF?=
 =?us-ascii?Q?Et/jBvaEs9GuQZ8yTD+R6eYZnkkJNKzxvA0YOpdfj54y056T+ryzWI1LAJs5?=
 =?us-ascii?Q?S2F+KaDFo47dwX1kchV1V++l+fK/TY/l9+3CK6ltXdvnBl138oRajGPwqECW?=
 =?us-ascii?Q?lfTNQnwFgsPyT0r4lvjp5hdMICwUH6l6DVITH5fHYGuhSiuvQxg1jAB8SJbh?=
 =?us-ascii?Q?oGoDHLG85cwlO+lUEwxsZVcqMHGilfqt7apnlowq/8Q7qdB5YK3QIUBCwYm2?=
 =?us-ascii?Q?dVhRc8LgThG8431znE/GvW4msMr5H/tMLzAlkG0UwT5VPU3SLaZ34uWVCYeu?=
 =?us-ascii?Q?gvZ5Yyt6CxjcWpMmT2cpuQshw48GcA4hBgv1z14/06YdBiHm01yagSoEOxwd?=
 =?us-ascii?Q?mS/mhDLxS87rEhodKOpRi4ZdLCSvIKMf3r4GDh6HmHud/4zjbTIY3NPKKb83?=
 =?us-ascii?Q?HeT2Qlsc4YYFQYp9Kh3jGNrC5s3St5L6FGvxyGmxBGryHJ7D2D+8pyQOtq3L?=
 =?us-ascii?Q?b8Z58EEaTMdX3v17V9gyMEK7p8klTJ5M9XLm21HomQQyJjkpFPRsL6/1br9G?=
 =?us-ascii?Q?0bPjVRAZEtZ5OdksqyMDmInMiVFcxnyIo/EGvk2X2XoTAiDlnm8Gtena5T9X?=
 =?us-ascii?Q?d2aA3gLGHuIljxfBCOFsuYxeD3nL+gMX3XBehxYf29zMq/aYupZZh+vZZBAm?=
 =?us-ascii?Q?p9TLLsDZmdQMpLqj5moUqCb2tD0krS/I1XCogjqrzZA9Zl0zJHirIhpYEMCq?=
 =?us-ascii?Q?QXONjEsSuvCrJFM9ii0TH5YNaTfeXmFfbP8wejWRT2ZXEqp3A4jLyzW7ngk/?=
 =?us-ascii?Q?khh6M71KXbXB6sBxmDy8dm1iyPT7Zl0NlY9geURq6xSwgH7AsKT8MJii3QrT?=
 =?us-ascii?Q?0qL5i4EIXyLMaqrykTJGLw4jG+70zqafJNA5Gl8Xc9peuXo53lT0XAPB+urV?=
 =?us-ascii?Q?7dTigXhbzQ/CmnIPZgVOoMs6Jw+YcnfcaYjIIppaf9iJqTisFkvc4XwbQt1L?=
 =?us-ascii?Q?sNPR5D6I00HnvGu+pA/pU8zJsamZMTtDSPftdZfrXK6+Y76T3Q9Fi+xQ58Wk?=
 =?us-ascii?Q?2i/YTRTD2ygv2iF3PNh0r5M9hGnuGRkc31vmh8eXfOTrtMmsVR3eXYAXV7oQ?=
 =?us-ascii?Q?b0xHDlkr5ZPxZEunqJ3jp9cQxVoXSxfQk27MLzVEmY4y0hyY7aEd0tHQOuWl?=
 =?us-ascii?Q?RA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: QKqKtXpSgsDFtAOZTaFk6zjO16YemoTRvZAqk00xT1CN4OmhIdqx0+p1LpGK0v1JogTrnZhOScWQaZ+VfGpM90GCscp0jJD1Wmn3m6/8eLB2wp9tmklOUWCH53ezYi5h9NId+02zNZVPGQSVPHn0Ae6anrD/rIMKilnp+CU/sFhcqm9XPHPpFR2Rri/FBlAHeUChqVwS06tL+C3v478/SqDv1jYr6/eOI1Dc6c3mhz0N0TQ9WMTL9NyNMNuTyvXIKY2JXMkMXAGqgoF2i1WDaH0juL+o2Xy+Yne9cGz4ZKTsjide/Mv5IWNkUuEorVBeVJaXV8D0DRY8xCJv3fRbWapZKdr6Ji9UqoVIm6H7NP5/rR6B+c/YvZIxwm3Ye4TonrBTHzcH88nsEVUTjn1vUT3tdvqQQ20mvpdPT/AjRfzrVObi+IHeoBwAu9n/kK8CM8YL+1J/jT1k0x54uXBpkQWouU4mFxuyUKnA4kuTlUYJUUNu4QeXsP1kcvNnMss9QgGeki2n6exdT80jnWZfYu+oWmLsY5ZH7TLN1yrp5B3iY00Gp5Bhy1gbOOKmXy/Hw0Tf795LIaEdxqyWqt3qwV6rcUIs5P2k+Qc23GFAWEABWeGGUB/ZVwFgEesND583VrIS2cdLWLJUpMtVCSrKJpTQjzQEL3L/2pp3yXR3CVOo85pvxYOJyY8SO4Wj9yJqkVXx3BA3Xt+sBZ18n9Y7c5iwBI3qFYZ7yfwXnDrw7PpAYPlHlC2Jp66Zx9ITTlm6+rKQpX0FnoeQJ4yYl4rZjw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01f0c371-aaaa-49b0-f10b-08dad24e8a0d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 21:13:19.2891
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IUzD4dx+M7p+EROpMWK/cc7VozH7i4Z0uvbGOoQ8cnPoGUPaw9XuGkudxON3Pm1YLSF9Wtf5ri/9D1vRocS6OmKa5sjeSlYlIjVuQUpXfhY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6205
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-29_12,2022-11-29_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 phishscore=0 suspectscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211290125
X-Proofpoint-GUID: 685-6x60Jhmf8uVCWmEJ18yS2M-F98U-
X-Proofpoint-ORIG-GUID: 685-6x60Jhmf8uVCWmEJ18yS2M-F98U-
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h | 4 +++-
 fs/xfs/libxfs/xfs_fs.h     | 1 +
 fs/xfs/libxfs/xfs_sb.c     | 4 ++++
 fs/xfs/xfs_super.c         | 4 ++++
 4 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 371dc07233e0..f413819b2a8a 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -373,13 +373,15 @@ xfs_sb_has_ro_compat_feature(
 #define XFS_SB_FEAT_INCOMPAT_BIGTIME	(1 << 3)	/* large timestamps */
 #define XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR (1 << 4)	/* needs xfs_repair */
 #define XFS_SB_FEAT_INCOMPAT_NREXT64	(1 << 5)	/* large extent counters */
+#define XFS_SB_FEAT_INCOMPAT_PARENT	(1 << 6)	/* parent pointers */
 #define XFS_SB_FEAT_INCOMPAT_ALL \
 		(XFS_SB_FEAT_INCOMPAT_FTYPE|	\
 		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
 		 XFS_SB_FEAT_INCOMPAT_META_UUID| \
 		 XFS_SB_FEAT_INCOMPAT_BIGTIME| \
 		 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR| \
-		 XFS_SB_FEAT_INCOMPAT_NREXT64)
+		 XFS_SB_FEAT_INCOMPAT_NREXT64| \
+		 XFS_SB_FEAT_INCOMPAT_PARENT)
 
 #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
 static inline bool
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 1cfd5bc6520a..b0b4d7a3aa15 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -237,6 +237,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_BIGTIME	(1 << 21) /* 64-bit nsec timestamps */
 #define XFS_FSOP_GEOM_FLAGS_INOBTCNT	(1 << 22) /* inobt btree counter */
 #define XFS_FSOP_GEOM_FLAGS_NREXT64	(1 << 23) /* large extent counters */
+#define XFS_FSOP_GEOM_FLAGS_PARENT	(1 << 24) /* parent pointers 	    */
 
 /*
  * Minimum and maximum sizes need for growth checks.
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 1eeecf2eb2a7..a59bf09495b1 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -173,6 +173,8 @@ xfs_sb_version_to_features(
 		features |= XFS_FEAT_NEEDSREPAIR;
 	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_NREXT64)
 		features |= XFS_FEAT_NREXT64;
+	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_PARENT)
+		features |= XFS_FEAT_PARENT;
 
 	return features;
 }
@@ -1189,6 +1191,8 @@ xfs_fs_geometry(
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_BIGTIME;
 	if (xfs_has_inobtcounts(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_INOBTCNT;
+	if (xfs_has_parent(mp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_PARENT;
 	if (xfs_has_sector(mp)) {
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_SECTOR;
 		geo->logsectsize = sbp->sb_logsectsize;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 0c4b73e9b29d..8f1e9b9ed35d 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1663,6 +1663,10 @@ xfs_fs_fill_super(
 		xfs_warn(mp,
 	"EXPERIMENTAL Large extent counts feature in use. Use at your own risk!");
 
+	if (xfs_has_parent(mp))
+		xfs_alert(mp,
+	"EXPERIMENTAL parent pointer feature enabled. Use at your own risk!");
+
 	error = xfs_mountfs(mp);
 	if (error)
 		goto out_filestream_unmount;
-- 
2.25.1

