Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD78BC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Apr 2022 16:58:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232178AbiDURBT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Apr 2022 13:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348340AbiDURBR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Apr 2022 13:01:17 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78E0A3F89E
        for <linux-xfs@vger.kernel.org>; Thu, 21 Apr 2022 09:58:27 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23LFSRQ1020622
        for <linux-xfs@vger.kernel.org>; Thu, 21 Apr 2022 16:58:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=yFlV+mspXR1UWs2jMXsxGn4UBYuzqvBsyjLgl5xqH2I=;
 b=wj/FHkWUboduoVXVT9LkuHOxoHVc+UEz9UVFE03A7VIY/hd94il+uo5c2+Lmxc89kD05
 6sOMYZMDh33dJ8XDOufKOvmXYpfT5X0XWYDTI5V690+p3dLfYXCY93bZL/Ud2PjQCCv0
 vv0MP17S3gt+mNa08IU9XaB0ed19JR8w364Fy/bmb7M3eRrJe3WOL3yfHc1Ypt2t9PRy
 TGPqKBdtTloyq/PWSYMoSOCqx/eJHjwTg4hCoh0kMM8lmu4nG+XrFpvKkjDmnphfRJgg
 AMRSEFriwNPgPzmJits3tdWXduM/ZKTf0paIfFbkpRR+5JtCSB2G5zdNEty+dG/0trBP Sw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ffmd1cqb0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 21 Apr 2022 16:58:27 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23LGqDqp018189
        for <linux-xfs@vger.kernel.org>; Thu, 21 Apr 2022 16:58:26 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3ffm8c86yj-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 21 Apr 2022 16:58:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pz7leUV5zgMX7Bngifkxf+bTjZDK6jb3BAP5FD2P/Y2qDPWHByFNkxxTUL/gKmYQDBt/8W28vCaDz2dwCGRc8HR4cdyEP2SyBNI0OgoOFdDpzCMYhacf+bYfTYX2eX8qHGJL/ijZQ2NGTKv+mB14rrmxmcP2qYkQtCF4SbovVmCF/QTknOwPMzSECyKcVVk20NE31TQ9F1t2hzIdeUJVrRt9fMiQM7RMkEiOTEJLFjtPzIlzgNj2FHzWa+VGmMDWZmau2uZqapWs2crFJw7Xo8VSTfPFD0pK/aPSA6KBl4/SBQGla9XQkZfILaxg6vhJxWviNx8NsT/sKbmLB8zowg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yFlV+mspXR1UWs2jMXsxGn4UBYuzqvBsyjLgl5xqH2I=;
 b=HdkGgbvTdbCiPVNebYCizhkdIpYkFMMB9LR67j0DwjEHfoNWwxRmYUvAso4jpuPULp5r/yPL0LpA115KJHv7APjgh0uJjIo1JvEzxdmgh6e42TG637b1OzLT9hm4YaznSMQjUkdXNzlerUvk89/WYha9bxndIzRn1Qps8d9ERqA96He5k+UsfIA+Gku7A5pFspmVbbG1sFus59rq1WHGewW1L9ov/staL1pjqBHCY4g3cFJwsJJH1aYBOxycac46E15tbiJKt0zwmAxERY1qIdc2qAMct6JoUAfE1QeKu0bA4rhli9Ptvm0TNqg4wc3PSDnYLz7gA5Z9KASUF+Oxtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yFlV+mspXR1UWs2jMXsxGn4UBYuzqvBsyjLgl5xqH2I=;
 b=HX/2YZprVRWB+cv1SSpZCDaMKn1a62zpzHi6Tl5Emkrt0KqpBoLEq+AGpdFwCaRZfv2RPGZcpSpWNnwB9y6jhzbG56PRMIFYbY7UIIkyMn+NJO9hDg5DDbJ+49qaNioCpm1rLbKQEe7cWgXWxESgfQrvEEYCLNZ+OQIYGegA20Y=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DM6PR10MB2537.namprd10.prod.outlook.com (2603:10b6:5:b1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.26; Thu, 21 Apr
 2022 16:58:24 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::8433:507c:9751:97b0]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::8433:507c:9751:97b0%3]) with mapi id 15.20.5164.025; Thu, 21 Apr 2022
 16:58:24 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [RFC PATCH v1 2/2] xfs: don't set warns on the id==0 dquot
Date:   Thu, 21 Apr 2022 09:58:15 -0700
Message-Id: <20220421165815.87837-3-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
In-Reply-To: <20220421165815.87837-1-catherine.hoang@oracle.com>
References: <20220421165815.87837-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0193.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::18) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0f0cb9e2-a10a-43eb-52db-08da23b825f0
X-MS-TrafficTypeDiagnostic: DM6PR10MB2537:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB25378A173BD298C2B3E94ED889F49@DM6PR10MB2537.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 96cYCDRjDwtk3b+WUEQ1zX9YvSZgXgWK3zNH8UmzvhRI4a28DKb8dqVCGJ2IvUJDb/dkwIlIPqzMM9MVCbPgL0jgyYGXwVEBWz3/JlmxDLZoh0wOG2R95KojaS27bMjCb9q2NxijWUKVZ28zSdE4/DNyah9s6SAYQ0WaMCNE2Ockql4vm+0ZOhgD/U9ZSUXgB+nRRARyjHL8HXlQaM5Lc9YP1fVkixswfT9BgaA0pPhgCtUUCBPIHM4Do2Ye8P1Inl2eOB2gnGQ9JfxV1JfLBOd/FXW4crMfm8jyDhkd4+N7oF7InfwgoUwLPVPuMH406YKKzPoIi2NTrAp9ssdlB7HT2TbMnXvSQgA5gs0W3aTZX14A7vCQPwl0i25LF/0u7JeVmVpqOZX7aS/1YrsPXhPVtByGlVcCWn0Sh1vWL3reFxh+I7RX4a9uejF1Q4gXeTHLs13ay6QiMyUcmIu6AFaKnhc3w3XWrteZh01yLGU1MRBa3SsklhrrAzRqTOn7KNyycbhkPLqMIeDoLBQmwfWJgzY+ONfecxblIxsnVMxiPHNqiSHeEVIkyttbZiCZyjh9zwAgTHoW+qMYnrSO17VddDEKs30s/pVa0rFqr2CvEVWriMq9qKzadowNEj+WNcJ9MpFY35mcb/RYJ3ATCg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66476007)(66946007)(6512007)(316002)(4744005)(38100700002)(66556008)(8676002)(6916009)(83380400001)(52116002)(508600001)(86362001)(1076003)(36756003)(6666004)(6506007)(44832011)(6486002)(186003)(8936002)(5660300002)(2616005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CexMbAe8RtukNturvLNlZCuucPaQvYD6K6hGQdBd9LaMTbTDntpO37fQsKk9?=
 =?us-ascii?Q?otDkCKKuetrczbkHDwz7WWHC148oM2Sn+G5KshUNXvJ+TBMDH6Vf+599dWk+?=
 =?us-ascii?Q?CLd3CXQD0rL1+xIuKbHW/70ai5M8HKJUfJ/VtowZXEMzQfcuKEYgGdu84zJU?=
 =?us-ascii?Q?aJrYFadfxFAC3+tFO98xIDU4TimRXDLdh5lUcp3T8Hvz7M0kTP60eXVtj0aM?=
 =?us-ascii?Q?CbguV7EJ0i2nW/WPq6AiFPm9fbBIS/t4i04N3TxJ5ezM+Pf1Oy4QpOFN+fhY?=
 =?us-ascii?Q?OPwSto9QuyLXxo/5m9JZ8vCfK/jtwUuaLDPUhCa1sviTMERew+YhNtr3QIti?=
 =?us-ascii?Q?o6mttyimdm7vp9HUOEH18u+bBBAB2Zuv1ogDcNMBX/4TtsIJjEePeV0PF7N/?=
 =?us-ascii?Q?ocAnW89eN+vrf3lsszEeSJjHNf4N7LB8CY5FWu93lk1NLprUPvJhukPx5ihV?=
 =?us-ascii?Q?2IrtNZaQlYCla/Y1tb5kRrKULsMY6CDildzxLUHhnNcESuYFy4HpCfXvrd/4?=
 =?us-ascii?Q?T2luRufhDTtM+tf6Z8ViKGV70jvZwiS7TpN2rx23oMlDITFG9pXfQBEJaF4C?=
 =?us-ascii?Q?FziwbwI3g8iXXGs5q8YIUp6r16chfRqUqfgxJGjlNIKnvJHOGOplJ6OJ1Vni?=
 =?us-ascii?Q?Bm7e4n4AQU9PgYGjG+RFZK3YWwYSiTmHEe3CrzSeeksv9cjsQfDKGRV74iXH?=
 =?us-ascii?Q?zBORWp1dE+d50oO3EUFohoz/Eq54s314dKZARodl+dhk6C5ooflJAV0yr4YH?=
 =?us-ascii?Q?5dusnzmHgqOy0Tm/BrTqqZbinS1PdPJ5UyHomr8E0vrf2C7R9o9P6UfCPVh2?=
 =?us-ascii?Q?Vt8OWGB1JDigzCrk7+vveV0LGzGESmQDwKAh4/eHaDDReEUR0dknVKM6P+bh?=
 =?us-ascii?Q?xFd/XXrZLLViFJhsmNLUPIzT+EuuwUK5sQ+rS/B6zshVv2MDS/OpuMJ3JN5g?=
 =?us-ascii?Q?+FrKTOYVXJaEw1jZX/yEO32pzV0cj75M8yq+m91XFJF3mP6C/x74gqFclGoR?=
 =?us-ascii?Q?M+kMn2JWZLLwHch7IVCs4yZ1AFjah2GxxI6Hs30RtLWEIs89ngR66jpe+N1k?=
 =?us-ascii?Q?kTkekrNUpoxZYPsoBJBwTsuQMD5RjRl40Xi/CjQW6Wd9aJzOi1luMOeLezzF?=
 =?us-ascii?Q?TSMqD+ZAejALdCNvceFmQ27xb0A2RpKIMbcMRUGeJPEsD/iqFfsqkQ72D79Z?=
 =?us-ascii?Q?RR7AKk08h/snf4E+gwU+3oeeRDBGnmDj3XPqYpXgoj/Vra61Q/9QFefruuFr?=
 =?us-ascii?Q?7rEPCIb8m9nCS17kGavxUNmNusVn3E1mKcPTZ02yHYdP4Yah9b68y8CWQCDy?=
 =?us-ascii?Q?XLxWsBzbdQPHs/am3TOOTk18JgzNZVymRnY8IzNxMyQmFJbxTgYYftoL2CPv?=
 =?us-ascii?Q?RKssnBufndgVlJ70iErOgQptK/Ez6OW8lQCZEIMoBpKZUZDBBNbXZpgznrFp?=
 =?us-ascii?Q?5t045Lmc4vHwHhzjTDTNpIWoDl42n/HlEGgq63BibFV1jVClgZR87Kv6qD2M?=
 =?us-ascii?Q?uFq7qqOsAIyfsUXIHwd+FXPqR4/L+NC8WT7i7KflMvdHU0F3O2L2s1ND9BLa?=
 =?us-ascii?Q?Efp2SIoZq8QKMEkqi/3SPGRdh3Pf9n5iRrvE4SElpDTIWDAs3zBpwcUjcykb?=
 =?us-ascii?Q?QH+lNp47e67B8pKv/jhKbCuEZJ2lqflYhpZwLtFewmKJ6y1J6Trjt8XbTHZu?=
 =?us-ascii?Q?7wr0nf6+NaZRp18+Wilf74NJIvw4evjX9akPfPnwyWZl0m/mwu9yr+pjlaH4?=
 =?us-ascii?Q?cj1ENAt68RoHoTjExS/yK2xCzVkmgbGpa2ogU9iuKZFl0OdNfZLfv69SS4iX?=
X-MS-Exchange-AntiSpam-MessageData-1: UXSjgio5vKtm33xwdwy3fr0NjNikXQcZSeo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f0cb9e2-a10a-43eb-52db-08da23b825f0
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2022 16:58:24.5995
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0cLF8lxnDkRxrZr6QV91WEJ8vKzD+BB3iaXDJCw7O50vp+RVLcgnfz8z8E0LCIqhVdhPn/ji9dz8mUdqC9jVnnhqF3NcByezlLrL6ZaJeAk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2537
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-21_03:2022-04-21,2022-04-21 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 malwarescore=0 mlxlogscore=825 suspectscore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204210089
X-Proofpoint-ORIG-GUID: ieJpdCT8P-EyTuQM2Z9sTWlcRCPbRtRM
X-Proofpoint-GUID: ieJpdCT8P-EyTuQM2Z9sTWlcRCPbRtRM
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Quotas are not enforced on the id==0 dquot, so the quota code uses it
to store warning limits and timeouts.  Having just dropped support for
warning limits, this field no longer has any meaning.  Return -EINVAL
for this dquot id if the fieldmask has any of the QC_*_WARNS set.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_qm_syscalls.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index e7f3ac60ebd9..bdbd5c83b08e 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -290,6 +290,8 @@ xfs_qm_scall_setqlim(
 		return -EINVAL;
 	if ((newlim->d_fieldmask & XFS_QC_MASK) == 0)
 		return 0;
+	if ((newlim->d_fieldmask & QC_WARNS_MASK) && id == 0)
+		return -EINVAL;
 
 	/*
 	 * Get the dquot (locked) before we start, as we need to do a
-- 
2.27.0

