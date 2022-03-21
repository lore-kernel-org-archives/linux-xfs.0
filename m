Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25983C4332F
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Mar 2022 05:19:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344382AbiCUFU3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Mar 2022 01:20:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344384AbiCUFUW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Mar 2022 01:20:22 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61196344FD
        for <linux-xfs@vger.kernel.org>; Sun, 20 Mar 2022 22:18:57 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22KH3BEY001841;
        Mon, 21 Mar 2022 05:18:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=N16OB0Xp2eKmhrj0ndiIKcKQLA+YCTgApHuvR72LOtk=;
 b=mKNqRuGniqbFFGLMdY4nkTE02zEmDwKeSGMq1mbf0q9a3vaysNZ57pAUxUtKE4UinG4N
 HBsDPD0rTj7CvRC4kbAoMpKZ4UX9mWXN8M+vzPZ4mx6xWDNMvojQPo4qsBEFy3tySMl9
 wAuyUX7+kSTrisYdzJxMLtD+pDrbD1GHA/DlqO+Fh109pxOVgTLg/QyVazdasn9Q9cGx
 FAVbLdO9p4Aap+tqOpQERZy+ONIdxgj0tZCNjOC7FjHXN63FAhfmih80gj2ULf+wW24E
 dZEBFhIpquvmEo0ETTnNV/WopFmfkrmNoJWw0HbmXd3mG0ss2S8UPSwXH6c0NT//n/vS ZQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew5s0j514-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:18:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22L5Fvc0057867;
        Mon, 21 Mar 2022 05:18:50 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2047.outbound.protection.outlook.com [104.47.56.47])
        by userp3020.oracle.com with ESMTP id 3exawgev4c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:18:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mtSTduRAgXWkEIOyzHwjC1eOAp64rs/5QYumqMQkXgxoJFStriarJmDKM8jnpCk1edDkxonC4StPZUYIxMMlBN2RbrugP1Cbt7A382uA/gsuyT3VmrMFea2XDhQ4+oCYbVDAySBT8orra8EQQ/XLAABPQu6+qStWs2M9LM5gTZhYMHwBiZj+VHeg6xVyCjchaG34LEDJuVyix5pR6VUKznnpQCQCkQ0ol7WnlAWYXnHftklpAQiDEQObFDRbosj61jUzxCE7rONmI7V7Dj+QIgXA8chf0VpHIkw/bPfjo9WyOtELIpCI3K4oNrimR0TE1r415RtGeF3ubejFjRxFkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N16OB0Xp2eKmhrj0ndiIKcKQLA+YCTgApHuvR72LOtk=;
 b=nrmWvJbCgCaVDzLcZLT4M5tNLjmrYpufSuT3crWqMaBLQ5EoaPWcarGXVSpoXtJ4MLPJ50v+W2tMXfhzmrACGFbH2yhvd7Vxlx1VFQHiLQ+fRBKYyh0/numyBi9oSxqqDM53mJGUQ6i/pk6o5hQs0o6uTfXnegUHM9/rTn5OWl0PZNxGzLo2jkmIN70LZiI+96Wb3eLxu47+rIYkUxl5wfL/HWANmHH0caMkjRdidNEAb8ipolLRcP+I9NJw7g1hCmBM2IETah4X3uaRr+zn16+BuGWLarb5UYyBgQtJ124g53gl434PT1MrKw7jTqzY/KfCYfHi6zIFCuwggowa+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N16OB0Xp2eKmhrj0ndiIKcKQLA+YCTgApHuvR72LOtk=;
 b=Ryb7sI2V+/kEd4a0/AObqQKZQRCtAfgeYjnDeNXYoX53iLFNZnycYve11C/BYpkwpl5LNHYjYvVjHyz2aG+6clZSIJ/TfhDoE3Q1Wd28qjzSfUyewwHxm29cbf+jdlLDdFCMltoJPHf2USZUMODRr93XlIzYvJLtk5MU+OKN35Q=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by CO6PR10MB5537.namprd10.prod.outlook.com (2603:10b6:303:134::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.22; Mon, 21 Mar
 2022 05:18:48 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f%9]) with mapi id 15.20.5081.022; Mon, 21 Mar 2022
 05:18:48 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V8 17/19] xfs: Decouple XFS_IBULK flags from XFS_IWALK flags
Date:   Mon, 21 Mar 2022 10:47:48 +0530
Message-Id: <20220321051750.400056-18-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220321051750.400056-1-chandan.babu@oracle.com>
References: <20220321051750.400056-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0120.jpnprd01.prod.outlook.com
 (2603:1096:405:4::36) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: db125314-ba91-44e1-2ceb-08da0afa4757
X-MS-TrafficTypeDiagnostic: CO6PR10MB5537:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB5537E780878B89B815FF4A3DF6169@CO6PR10MB5537.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0cyRbP4RjI0K0oFUC8UPCJi9L08Pr+Dh4r2RUXbiFmc22xWwyxrr68R+LNohh8DW5xZXJmfPZ4JJIjD7p95exys5geXUzGKtvtP6LsHVPE8ffvdKKdV/HxVwefSfw/PpkkltRAkI6KblT9UYzVwS3V7te20xUQp83QcdRbbjKVKds1wPFPpvQ9pZVNbFR9L4p5SmGFU38JMgmc3YsSlnNtO0VMiDXxkVJZCQYKYkr55j1grBYKVpr8MGmL4xT1e1ve3vWT02Y8rRW/ouTF8doTlZYkaWN9zKW562ogdk47xdp+8kJ9QIAjRE33Bael7TV1e3ZtH/2DTG1doKG0hq8NACEu/fcHbPmUdq0lEqH7DdKHfpG7GJcCEzgLJhvc81M9Sm51QdB0Bu1g0q5LO9E7O/Gx1fgPsQqDXwo3Ej/dQoHn6NNHUcmMnLFcA4TRxtKyoXVcHQogvchz5yUMyE7ORRr5U3tdjRTe4lyyY3fIBiHXN8rTQ5gSlY/1f0x1sTRgJTU40hG5ikFdkA+CQrCmSEDVTGdCNjzNaiPH8iGhZvYx6vqZJZn+aav1mnmqRGdFI8he8TLtSrdKqgI6Ok2XG/V/WeS4y7NsWHD3+l2xWPSYeIRF7nqnSFe0t+HXs13lIEIoDpB78JgeyxLp7Fl1rXkLun762QTCbW8kkGjNCUdqKzntjOgjFYJ6dmLKHbWIaHMUCeXdgT0g1CagDT1A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(38350700002)(2616005)(4326008)(66476007)(66556008)(66946007)(6512007)(6486002)(86362001)(6916009)(8676002)(508600001)(316002)(26005)(36756003)(52116002)(5660300002)(8936002)(186003)(6506007)(83380400001)(2906002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?e1XQhuoL4YKYjzA219tigrjjQISDbzQ1vgW8EaaIYiyQzltYrR96MAAg0t8j?=
 =?us-ascii?Q?osD9ySgl0PHxynTi2zUNUxw8qnw7K13smQ2oooP+t77SBX6Pvgc8AZCoukvV?=
 =?us-ascii?Q?KsW5bPlX7nmp/+YQ40z8C2qK3RgUHBDvKzB1CE12emDMFupQzFsJ4x/vMA5j?=
 =?us-ascii?Q?bgN5eNaUKr4/jX9v3HGTY9jOGSpXAoJhzhZEzBuOAg7BjuT8UBkkVO02nkfZ?=
 =?us-ascii?Q?ZQFiqaRwAUZEIKrPRGZcjFBtPV3j36sxxcM0DZzaOdfVp0t/VzunbPaF1C2O?=
 =?us-ascii?Q?k3GJyCtmMiE7Z/Mmq/r6hoNfyM4MhP3s5zXoX9o7iJf/rfQMFFINky5WpoEx?=
 =?us-ascii?Q?ltamjDtPQBkI+BMR1EvR6T43gV681MfFXtX4elWmqy5BLX6KXN5NOiwOVSAx?=
 =?us-ascii?Q?WAoehJvtUVfHzp2yDxA2+6Ty7CK3P4zi/IUNBoX2XGaF1nZpGnVicUwahrfM?=
 =?us-ascii?Q?OF98lUKaYcC5vCgbOCYTqqHgXzuA4jId3pxoA9NoOtejYdY98UquaxDQWJaw?=
 =?us-ascii?Q?uN6ih00F48SLIvp5P7eZmhsqGQuZFQBIQy6YNy5QCBgnkCL5zEdjGsw+A61W?=
 =?us-ascii?Q?sEI3xeCZABIb75O0/ncOvKVj+RVPc/jqB2txoCtahuXyAeTcckB0zysx7Y+J?=
 =?us-ascii?Q?fRT42KfL3ysZIR4/9j1bRuCBj7I0jq+vxY9l57uqHYtQu+ZsjlvU7RZ8ABW2?=
 =?us-ascii?Q?nH8kQpNBdYLuiecBiQ6Zm6/9maJLAOFl9OdNEquILQYaXqnbwvcKVEMGq2bq?=
 =?us-ascii?Q?R6eNrfEcNeJ2TRdV+ZRPc5UHg2yDSD2C8VSbaZpDcV4ZJ+oSEH5PEq3mUhLi?=
 =?us-ascii?Q?4yHaWeH6DJl6EDlO8tYRp1G2jov31imIc7xsCVPMSk24qRLLQ5b3oIQe25Kn?=
 =?us-ascii?Q?u3DYlmF0IhJqIYqYUgVnaAAfgZ9KS9xLlLGTxfQnW+xOs7VDKe4ynhINkWcD?=
 =?us-ascii?Q?ZKiwo2hTuAoWFwC7BSvpLIbXzzEIbqkwIWiVUO9Oyxy+ZeFkRTMzpkTvDSHd?=
 =?us-ascii?Q?6JMrH5NkzNGp4TM7jluwjPcJhp3l3mOYZe/A/FtXSocW+XTDMBE5Ll0JDC62?=
 =?us-ascii?Q?rIfLQSPzlNM1Mlai49SYvTwtPqlEO0EIUHzrEB80wCZ10IdTUtDgk/MrshIU?=
 =?us-ascii?Q?EBOKAwtCll+QUpFbRghRDndXHiItq8ElBWG6Npuf3irJpF/KgEqR2zsT5+aa?=
 =?us-ascii?Q?GQBr/vNlsaktlZT6by0D16lmQGv80uFbfgqGb9vSDn2Tvi5zZHzvvpyzQLsR?=
 =?us-ascii?Q?pXMIHJDywFv8nquQY837hba0k5+ZdY1GYBDOQG5dqoB1rD6k58KCh6W8MHpQ?=
 =?us-ascii?Q?rs9Nghh7NACXUhM7+jZeDuwud9JVBMPlaim/cpJvqTUJin5k1QKu5WDMDrKS?=
 =?us-ascii?Q?NUuTkmZos0rKL1jU0NpmoNLHryBY8kXZXgn2jXMYUYUOUaU0T6XUA6N2A24U?=
 =?us-ascii?Q?FX0SYEX0lNkANmJrlQQE+F+xj2P9IZrT6KQCwkg18WdSBKnB+6np5A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db125314-ba91-44e1-2ceb-08da0afa4757
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 05:18:48.3218
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n7BLl5O5Yv5zVTFGe9a4wXxgdfITBjli2G8DPfHgO1bXZ5+7C2G7w9cpS8TEB/D8BMpE2R/f1VCijVS4YP1TPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5537
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10292 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 malwarescore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203210033
X-Proofpoint-GUID: rbknxxiGm_i-0Xb-1rjws29hPlBtgqdm
X-Proofpoint-ORIG-GUID: rbknxxiGm_i-0Xb-1rjws29hPlBtgqdm
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

A future commit will add a new XFS_IBULK flag which will not have a
corresponding XFS_IWALK flag. In preparation for the change, this commit
separates XFS_IBULK_* flags from XFS_IWALK_* flags.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_itable.c | 6 +++++-
 fs/xfs/xfs_itable.h | 2 +-
 fs/xfs/xfs_iwalk.h  | 2 +-
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index c08c79d9e311..71ed4905f206 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -256,6 +256,7 @@ xfs_bulkstat(
 		.breq		= breq,
 	};
 	struct xfs_trans	*tp;
+	unsigned int		iwalk_flags = 0;
 	int			error;
 
 	if (breq->mnt_userns != &init_user_ns) {
@@ -279,7 +280,10 @@ xfs_bulkstat(
 	if (error)
 		goto out;
 
-	error = xfs_iwalk(breq->mp, tp, breq->startino, breq->flags,
+	if (breq->flags & XFS_IBULK_SAME_AG)
+		iwalk_flags |= XFS_IWALK_SAME_AG;
+
+	error = xfs_iwalk(breq->mp, tp, breq->startino, iwalk_flags,
 			xfs_bulkstat_iwalk, breq->icount, &bc);
 	xfs_trans_cancel(tp);
 out:
diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
index 7078d10c9b12..2cf3872fcd2f 100644
--- a/fs/xfs/xfs_itable.h
+++ b/fs/xfs/xfs_itable.h
@@ -17,7 +17,7 @@ struct xfs_ibulk {
 };
 
 /* Only iterate within the same AG as startino */
-#define XFS_IBULK_SAME_AG	(XFS_IWALK_SAME_AG)
+#define XFS_IBULK_SAME_AG	(1 << 0)
 
 /*
  * Advance the user buffer pointer by one record of the given size.  If the
diff --git a/fs/xfs/xfs_iwalk.h b/fs/xfs/xfs_iwalk.h
index 37a795f03267..3a68766fd909 100644
--- a/fs/xfs/xfs_iwalk.h
+++ b/fs/xfs/xfs_iwalk.h
@@ -26,7 +26,7 @@ int xfs_iwalk_threaded(struct xfs_mount *mp, xfs_ino_t startino,
 		unsigned int inode_records, bool poll, void *data);
 
 /* Only iterate inodes within the same AG as @startino. */
-#define XFS_IWALK_SAME_AG	(0x1)
+#define XFS_IWALK_SAME_AG	(1 << 0)
 
 #define XFS_IWALK_FLAGS_ALL	(XFS_IWALK_SAME_AG)
 
-- 
2.30.2

