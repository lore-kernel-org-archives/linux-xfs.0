Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F87BC7619A
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Apr 2023 03:36:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjDKDgL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Apr 2023 23:36:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbjDKDgJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Apr 2023 23:36:09 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75E69EB
        for <linux-xfs@vger.kernel.org>; Mon, 10 Apr 2023 20:36:07 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33AJwC66021476;
        Tue, 11 Apr 2023 03:35:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=ugq+J9T5InfZYiPDlipZ2AvvmCO9KsdKv8MWE/fw/ao=;
 b=vqEZttjBoaxr6qxoZJq31izDilYAPU8xhvFuPtxJSzX3BBIF6H6+BcSPf5HL/rBzFg8q
 1YzVixeLt2YveF7pqo45cgU9sHa3aumgaelNubYhPWDAUFrwUM906hE3EjLzZ5s4xOZj
 HIKQTjtseGFsP/aaiephGf1lCVQWccog22JuKgbBx2cySv8ExkfGQxRI9KpV3Rwq3Zof
 g78fQ1m87Q+9wceoktBmd1SHY83TQz52m69RqW6WU9fcbQK8ffZQFa2QVY56yXbkSwIh
 cNrVdeJF79FxIPhve3Es9FylXDPKOxK3pxeFWE8D1AS/Mo0ynkPVl2DGlHVdj2DRPu8g XQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0etm9a7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 03:35:57 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33B3PbDW001948;
        Tue, 11 Apr 2023 03:35:56 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3puwe699px-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 03:35:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PaKlt44p+I3hPBPBd+qmPliR2IAKweeOZvkixNCkphgX8O/w7ZSiqipPfbCtnetEqXTz6uqDwL3Zi6VSVpATKfkST2a7Tfph9ML2cLUQFKL5lHiecBgr2yjwSsIivHq1pjGE2MnlOc7B34GPAVM4flwfksbJRa9R4gWqju+Ubu8MxjF/6Fn2Z5emAlxjTAUOvvO6wL8TV+o1b/sgKqk+TkdNMFiXxmt9qVW95FHnAgzVMaWrwdXpm/6y3cd0JyPpJhQ5pyh0JeXtx1/aVHVfmLcr3vQvka3phJ4SbGuz0fa7zT93089F/GtUN2+PD8pVTgzvad+e4Nr5N22sp5McUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ugq+J9T5InfZYiPDlipZ2AvvmCO9KsdKv8MWE/fw/ao=;
 b=kJ2UYzytH9upXZpkAMSVJ8gfoOfU4AJLbUNtETcgpSYM8nq9FDqKScGGsECu0OTU0a8ZR+BVO9MyfE5pyR5tFL7EQF/hYyK81rVXzekLjSHAYQevgQrOa7Ih1O+PMVy+uvfJKbhT8vKIIt8Rudh+biLqEESyvcwQu0asXMY4OJhD2hi8im3KKx6C9jZBMgqefYs/pVN0onigy05Vb93ud4/XjPGm7pynMuuiL0TM9+OL2nzPPfGXTi/p7iLLKBw6j2iCEGjM+oWfIg6wZ7JuwYc3YnXcyu1/nGnvBPn3qaikn2KYMj+qdg0qExrX1NwixKbIMXdPJRRfvaLHgtGF0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ugq+J9T5InfZYiPDlipZ2AvvmCO9KsdKv8MWE/fw/ao=;
 b=vzYOkI9tW1DlBpAUaaZBVVqVjDoQqZFoViRDY6r2K78OfE3OHsrbaJ2GjMPibXlWXXr7TZACMUg90QFQ9qVNQzaEKNkeJjdJQav/9K4vB7miKkWDhF7gxJc6gpNMkr+pnHRo6ofJSmrlO9coVfob2Sub6udIMKQ0Zlo/gEBb3k4=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CO1PR10MB4563.namprd10.prod.outlook.com (2603:10b6:303:92::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.34; Tue, 11 Apr
 2023 03:35:54 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7%3]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 03:35:54 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 04/17] xfs: remove the icdinode di_uid/di_gid members
Date:   Tue, 11 Apr 2023 09:05:01 +0530
Message-Id: <20230411033514.58024-5-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230411033514.58024-1-chandan.babu@oracle.com>
References: <20230411033514.58024-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR02CA0065.apcprd02.prod.outlook.com
 (2603:1096:404:e2::29) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CO1PR10MB4563:EE_
X-MS-Office365-Filtering-Correlation-Id: f8e7f7bd-5e04-4e5c-458e-08db3a3ddaac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xl8x9dU5qJ21dzlsimYmXQB5I79ZTv0fTjMHT5+5PQ4qVMFg5l8++Rye5Y8Uk847I8ohxwD2CoGpbhfktKgeq3SQHgVT+/XGcNE74kd0ziovR4xyI+IsBVuLHFkhY/PXEv+i6rjjjLAOawhBm86DCmoXQBHYaIyrJKrlbLSHq1ZwAD7b1wGV3vp2uTg+bYLM2drX/gonxillPpeDtxP2OMqyq2Gg1bdPsZeSN8fk9n1uGfJqpVy6JKn2hnkhx4BIqbKxupU1g+Wln3GhRWI6oDS55U3OwqF0hzi5pJg3n43n8x+DyZtZ4g7xgwyoE+T1tO8H4gtghRH2+ARf0XkdnI82x5jF/38MTnBMsq0K2K6nMbpoFoQHuDwpqimSfAyadhfjFA38S4OTecv2Ll9Dc9zrHK0TbzXuf7EMCgGIz1mDxpQ+P4s1lImqFcMXfVqmG5qJ+dMFz4YZGR7gCSs6g/yNRQAm42Iqbv9eQT7wR20pwZofkJ15VSU+rotuRwj4n+n7WSZXW9SCS3DTQUChmG+Brsb0rbmWV5jZlytXzZ3tqgZLDiIMLhgQ8clpRfCC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(396003)(136003)(346002)(366004)(451199021)(6486002)(4326008)(66556008)(66476007)(478600001)(66946007)(8676002)(6916009)(41300700001)(83380400001)(316002)(36756003)(86362001)(2616005)(6506007)(1076003)(26005)(6512007)(6666004)(8936002)(2906002)(5660300002)(186003)(38100700002)(30864003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?C+4vQM+cV289onv9WcCcZF4JsU5vbjLMc0Ah2V/9WfAXwe5wDTbM+4RtbhUY?=
 =?us-ascii?Q?zk/m7aDu3szVPj1XPmcPyGr30Gwxrizh5JFGP3/wmW9dQhUt7+VSCJ0U2MWL?=
 =?us-ascii?Q?2MtyUuO3/hrYNK+AuRU/NOfRkWR24ePh7ffbDR9SlZxukGWlXkYTI4/1mGHb?=
 =?us-ascii?Q?jk4wlZqXU3Eb8qJjWNdMJK3WPIKJhoaG75aUPUgz6/GDVEMjcWZE0KoX5YIK?=
 =?us-ascii?Q?NFovoQsBR1m0xC8wnKJ2zNN48VmZOUWLfq/qd/uuApML0Yqq4dIY/052GtFS?=
 =?us-ascii?Q?tWvoi+4x3CqaC9v7EmUHP7hfy7Z1pWRFOGanK7bZgQJ5vsvNN/+cFfIxnVea?=
 =?us-ascii?Q?wLOwh9HiJEXU+CELqMj6E+6jnVp1hVCGKDrigrHkyf32p7un0Bu8Zj7HiN66?=
 =?us-ascii?Q?1IkotDesJDCk1NTRMYlrhbFjNmy6gGdIgrbDrYGA7F6bMP7veOYLv1k8Z7ti?=
 =?us-ascii?Q?Q1FSjg3J4nWgZ8J4qgqjiOGBvCxP5ACfcUnBmIpXHtcWsc/t8JlTMWEJxhVd?=
 =?us-ascii?Q?WVepYVgF93Vr7vg1Dj6+GZKuDpOtz1K5yXxm/XXXkghIA1NyWhLObfAyiS4L?=
 =?us-ascii?Q?71rYQVSuHUEEhirTE0fIGK9NrtusaclAb5WEqhFfEFCCIqy9yIbd+83STtLV?=
 =?us-ascii?Q?JN+FwlSU1b/VrOTNTUPECPXLhAduuLIkpaDLJ9O/xwnUvPj78f9S4450vVfN?=
 =?us-ascii?Q?v0MJLMhyzr97CDuQwNjEdp2BibQxbg85WRu+2Cz15SU2kJnfrjUtH95z7H4y?=
 =?us-ascii?Q?ui6A78a1Vumt+YCFTo1VHxa2lf/0mNLisrCrqdlTtLnpEhk62ripXP82rz5P?=
 =?us-ascii?Q?qoUInqzNMU9YG8lRbtN1ogdjCHpklp1D+gemaizfd0HSY8DUMlotv/bAiMx/?=
 =?us-ascii?Q?Tsdl3LzT9AUtE4KGi+3byw3QxVrS3syq5164at55rHa2tOJmAmYs5vgNuhV6?=
 =?us-ascii?Q?FDgapudV1GA5GoV/mtb7Oddj/vQX/75Q/dj0xfLmwc4rMGRsqctrAb+9PN0c?=
 =?us-ascii?Q?Iow69opLkcV5n5rRg747Nl+o4SemXkSxXAfupc0+dC8QMm8m6ih1HS18X8Zg?=
 =?us-ascii?Q?LXXC4/cCPJ6FPXOFiXyezLhf/ZXj+yBvpsjHVNAQkxl4FJMmGNsQbV3MOZ1t?=
 =?us-ascii?Q?OOhrk2fQ5dGMqiCCCPwNbk52UIgui7I1Cum/BML8IPkCNPrrWJyfwBg5+Fe/?=
 =?us-ascii?Q?nHrutJDFY2cl2vs/Pg5eXzu4SI4FIlx5Mh/RS39TQLaxlvhQtVixwkhIxWFf?=
 =?us-ascii?Q?mce0uctMRKGmdkbzAhsxDvezQ+cW2uKUMEQXVzJKUFn2I81yc9At8iRVHrZG?=
 =?us-ascii?Q?giG3GP0JSVUFOMr6cwVABXf/h08gIrQCo1C1kAgtqbY3SHWCeEtpg39fcQSx?=
 =?us-ascii?Q?WYdV1t7mn3w5sHUZVOx8wC9YOXIbxcLR4HaWB9X44PDfndaheYV4yHiNvPDY?=
 =?us-ascii?Q?ULPZ6F0sUlptXmqDOPbgv/DxvoFun6FDL4LBacR14tJdJ5bmE6g0d5/WHmBL?=
 =?us-ascii?Q?rBioV685zSMsEWlvIr5uEYRZ9o5lbNKYKVFzKs1Pp62or5NU8SQPWVbBK9xF?=
 =?us-ascii?Q?bF6dguBaKNZVxA/5icaD/iZLOmeHOD/9owU8MMou?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: jHT26yb/HC2PhBwjY1zUiMQfm9ZuxgE/mjseu9zH1o/gmP6zwg7QqLEVZ22SIQu4XzJKe2YnNSLplC8zJsQMC1MMfg12iVKxh1ccfn3NFKzmxFGKPiEO2pUDbX17NO5DhxkPdp2tcXOFJ0StiW+oIosQzWmz7lXYFAeOI8yp1Ixff26MPG8f2pNDgBkhGPMEYHw2hvlA3dAsnMiwc3IwrTvs8g2TSQW7QLHE1bc/WDCmdcIlz4a7N9ihpoLD6PJT1Di9w789e8CUj3czw5trCHlGcb9gKvaqumf4ZXGUXtTdHfQXHVyW8hZuihuiM2gaTjPmaAqhTHuevJR2CCN/Q82+SOt9Zae/3m+EKCEzSHgL6P855fPJPaXV4IMq79USxpz789sSrfzBbdlqNC9QmUdczRLzcb4dm+VKb9NNC+CmEOM/7k8vWjtehKjhqJO+vJ+5mixh55uDgN9Eqr6JR42dqfUtbPMqaUtDap7qUy0n/yCbSJrt4xCrtJqyPyIJs++6Wch8vz5S1bL7jB/y8fTNgZ+Qfi11VKgsHAR5wzWul8QbmUGk/a7FOu7a7K76H+mOTBdwZz70sX76ckjTO1xokU5tuCliX0cKPkJU4TDg6L7D+Dzea7EK/dlOcbcrb5Jiv5alTeMKzik/efjjUexHIzgBYwQ6/y3HcFVySem4Ts3uW11TFZUlYj8E+VaGjIl5BOajcg2ay39rubBjl43pCViaNbp4XGFbxSWjj6GfyikBycJxn+QjBWMIHzKDbeCrlnsVyu+jgz8Lj/DHt/Hm19iJH85kCpCDMA5DNZkW13z0U76Uz/qKe53aGCPJ
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8e7f7bd-5e04-4e5c-458e-08db3a3ddaac
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 03:35:54.1637
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k3wknZcQ2dtdiWZdYAv/81kVUmcRZZYgc7pFC6MsYy9asflS7AEU1RtZiUSx0+VRzozda9kB+40HPySS9ekEeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4563
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-10_18,2023-04-06_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 adultscore=0 spamscore=0 suspectscore=0 bulkscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304110032
X-Proofpoint-GUID: TpYdV8D3s0OPLxJGiOT0aoPG6oufOKNF
X-Proofpoint-ORIG-GUID: TpYdV8D3s0OPLxJGiOT0aoPG6oufOKNF
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 542951592c99ff7b15c050954c051dd6dd6c0f97 upstream.

Use the Linux inode i_uid/i_gid members everywhere and just convert
from/to the scalar value when reading or writing the on-disk inode.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c | 10 ++++-----
 fs/xfs/libxfs/xfs_inode_buf.h |  2 --
 fs/xfs/xfs_dquot.c            |  4 ++--
 fs/xfs/xfs_inode.c            | 14 ++++--------
 fs/xfs/xfs_inode_item.c       |  4 ++--
 fs/xfs/xfs_ioctl.c            |  6 +++---
 fs/xfs/xfs_iops.c             |  6 +-----
 fs/xfs/xfs_itable.c           |  4 ++--
 fs/xfs/xfs_qm.c               | 40 ++++++++++++++++++++++-------------
 fs/xfs/xfs_quota.h            |  4 ++--
 fs/xfs/xfs_symlink.c          |  4 +---
 11 files changed, 46 insertions(+), 52 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index c7e4d51fe975..94cd6ec666a2 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -222,10 +222,8 @@ xfs_inode_from_disk(
 	}
 
 	to->di_format = from->di_format;
-	to->di_uid = be32_to_cpu(from->di_uid);
-	inode->i_uid = xfs_uid_to_kuid(to->di_uid);
-	to->di_gid = be32_to_cpu(from->di_gid);
-	inode->i_gid = xfs_gid_to_kgid(to->di_gid);
+	inode->i_uid = xfs_uid_to_kuid(be32_to_cpu(from->di_uid));
+	inode->i_gid = xfs_gid_to_kgid(be32_to_cpu(from->di_gid));
 	to->di_flushiter = be16_to_cpu(from->di_flushiter);
 
 	/*
@@ -278,8 +276,8 @@ xfs_inode_to_disk(
 
 	to->di_version = from->di_version;
 	to->di_format = from->di_format;
-	to->di_uid = cpu_to_be32(from->di_uid);
-	to->di_gid = cpu_to_be32(from->di_gid);
+	to->di_uid = cpu_to_be32(xfs_kuid_to_uid(inode->i_uid));
+	to->di_gid = cpu_to_be32(xfs_kgid_to_gid(inode->i_gid));
 	to->di_projid_lo = cpu_to_be16(from->di_projid & 0xffff);
 	to->di_projid_hi = cpu_to_be16(from->di_projid >> 16);
 
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index af3ff02b4a8d..0cb11fcc74b6 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -19,8 +19,6 @@ struct xfs_icdinode {
 	int8_t		di_version;	/* inode version */
 	int8_t		di_format;	/* format of di_c data */
 	uint16_t	di_flushiter;	/* incremented on flush */
-	uint32_t	di_uid;		/* owner's user id */
-	uint32_t	di_gid;		/* owner's group id */
 	uint32_t	di_projid;	/* owner's project id */
 	xfs_fsize_t	di_size;	/* number of bytes in file */
 	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index f59c3265dae7..14f4d2ed87db 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -859,9 +859,9 @@ xfs_qm_id_for_quotatype(
 {
 	switch (type) {
 	case XFS_DQ_USER:
-		return ip->i_d.di_uid;
+		return xfs_kuid_to_uid(VFS_I(ip)->i_uid);
 	case XFS_DQ_GROUP:
-		return ip->i_d.di_gid;
+		return xfs_kgid_to_gid(VFS_I(ip)->i_gid);
 	case XFS_DQ_PROJ:
 		return ip->i_d.di_projid;
 	}
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 99f82bdb3db9..9d6ad669adc5 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -807,18 +807,15 @@ xfs_ialloc(
 	inode->i_mode = mode;
 	set_nlink(inode, nlink);
 	inode->i_uid = current_fsuid();
-	ip->i_d.di_uid = xfs_kuid_to_uid(inode->i_uid);
 	inode->i_rdev = rdev;
 	ip->i_d.di_projid = prid;
 
 	if (pip && XFS_INHERIT_GID(pip)) {
 		inode->i_gid = VFS_I(pip)->i_gid;
-		ip->i_d.di_gid = pip->i_d.di_gid;
 		if ((VFS_I(pip)->i_mode & S_ISGID) && S_ISDIR(mode))
 			inode->i_mode |= S_ISGID;
 	} else {
 		inode->i_gid = current_fsgid();
-		ip->i_d.di_gid = xfs_kgid_to_gid(inode->i_gid);
 	}
 
 	/*
@@ -826,9 +823,8 @@ xfs_ialloc(
 	 * ID or one of the supplementary group IDs, the S_ISGID bit is cleared
 	 * (and only if the irix_sgid_inherit compatibility variable is set).
 	 */
-	if ((irix_sgid_inherit) &&
-	    (inode->i_mode & S_ISGID) &&
-	    (!in_group_p(xfs_gid_to_kgid(ip->i_d.di_gid))))
+	if (irix_sgid_inherit &&
+	    (inode->i_mode & S_ISGID) && !in_group_p(inode->i_gid))
 		inode->i_mode &= ~S_ISGID;
 
 	ip->i_d.di_size = 0;
@@ -1157,8 +1153,7 @@ xfs_create(
 	/*
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
-	error = xfs_qm_vop_dqalloc(dp, xfs_kuid_to_uid(current_fsuid()),
-					xfs_kgid_to_gid(current_fsgid()), prid,
+	error = xfs_qm_vop_dqalloc(dp, current_fsuid(), current_fsgid(), prid,
 					XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
 					&udqp, &gdqp, &pdqp);
 	if (error)
@@ -1308,8 +1303,7 @@ xfs_create_tmpfile(
 	/*
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
-	error = xfs_qm_vop_dqalloc(dp, xfs_kuid_to_uid(current_fsuid()),
-				xfs_kgid_to_gid(current_fsgid()), prid,
+	error = xfs_qm_vop_dqalloc(dp, current_fsuid(), current_fsgid(), prid,
 				XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
 				&udqp, &gdqp, &pdqp);
 	if (error)
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index a3df39033c00..91f9f7a539ae 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -308,8 +308,8 @@ xfs_inode_to_log_dinode(
 
 	to->di_version = from->di_version;
 	to->di_format = from->di_format;
-	to->di_uid = from->di_uid;
-	to->di_gid = from->di_gid;
+	to->di_uid = xfs_kuid_to_uid(inode->i_uid);
+	to->di_gid = xfs_kgid_to_gid(inode->i_gid);
 	to->di_projid_lo = from->di_projid & 0xffff;
 	to->di_projid_hi = from->di_projid >> 16;
 
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index fd40a0644b75..6d3abb84451c 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1572,9 +1572,9 @@ xfs_ioctl_setattr(
 	 * because the i_*dquot fields will get updated anyway.
 	 */
 	if (XFS_IS_QUOTA_ON(mp)) {
-		code = xfs_qm_vop_dqalloc(ip, ip->i_d.di_uid,
-					 ip->i_d.di_gid, fa->fsx_projid,
-					 XFS_QMOPT_PQUOTA, &udqp, NULL, &pdqp);
+		code = xfs_qm_vop_dqalloc(ip, VFS_I(ip)->i_uid,
+				VFS_I(ip)->i_gid, fa->fsx_projid,
+				XFS_QMOPT_PQUOTA, &udqp, NULL, &pdqp);
 		if (code)
 			return code;
 	}
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 838acd7f2e47..757f6f898e85 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -666,9 +666,7 @@ xfs_setattr_nonsize(
 		 */
 		ASSERT(udqp == NULL);
 		ASSERT(gdqp == NULL);
-		error = xfs_qm_vop_dqalloc(ip, xfs_kuid_to_uid(uid),
-					   xfs_kgid_to_gid(gid),
-					   ip->i_d.di_projid,
+		error = xfs_qm_vop_dqalloc(ip, uid, gid, ip->i_d.di_projid,
 					   qflags, &udqp, &gdqp, NULL);
 		if (error)
 			return error;
@@ -737,7 +735,6 @@ xfs_setattr_nonsize(
 				olddquot1 = xfs_qm_vop_chown(tp, ip,
 							&ip->i_udquot, udqp);
 			}
-			ip->i_d.di_uid = xfs_kuid_to_uid(uid);
 			inode->i_uid = uid;
 		}
 		if (!gid_eq(igid, gid)) {
@@ -749,7 +746,6 @@ xfs_setattr_nonsize(
 				olddquot2 = xfs_qm_vop_chown(tp, ip,
 							&ip->i_gdquot, gdqp);
 			}
-			ip->i_d.di_gid = xfs_kgid_to_gid(gid);
 			inode->i_gid = gid;
 		}
 	}
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index f1f4c4dde0a8..a0ab1c382325 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -86,8 +86,8 @@ xfs_bulkstat_one_int(
 	 */
 	buf->bs_projectid = ip->i_d.di_projid;
 	buf->bs_ino = ino;
-	buf->bs_uid = dic->di_uid;
-	buf->bs_gid = dic->di_gid;
+	buf->bs_uid = xfs_kuid_to_uid(inode->i_uid);
+	buf->bs_gid = xfs_kgid_to_gid(inode->i_gid);
 	buf->bs_size = dic->di_size;
 
 	buf->bs_nlink = inode->i_nlink;
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 8867589bfc3c..c036c55739d8 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -331,16 +331,18 @@ xfs_qm_dqattach_locked(
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
 	if (XFS_IS_UQUOTA_ON(mp) && !ip->i_udquot) {
-		error = xfs_qm_dqattach_one(ip, ip->i_d.di_uid, XFS_DQ_USER,
-				doalloc, &ip->i_udquot);
+		error = xfs_qm_dqattach_one(ip,
+				xfs_kuid_to_uid(VFS_I(ip)->i_uid),
+				XFS_DQ_USER, doalloc, &ip->i_udquot);
 		if (error)
 			goto done;
 		ASSERT(ip->i_udquot);
 	}
 
 	if (XFS_IS_GQUOTA_ON(mp) && !ip->i_gdquot) {
-		error = xfs_qm_dqattach_one(ip, ip->i_d.di_gid, XFS_DQ_GROUP,
-				doalloc, &ip->i_gdquot);
+		error = xfs_qm_dqattach_one(ip,
+				xfs_kgid_to_gid(VFS_I(ip)->i_gid),
+				XFS_DQ_GROUP, doalloc, &ip->i_gdquot);
 		if (error)
 			goto done;
 		ASSERT(ip->i_gdquot);
@@ -1630,8 +1632,8 @@ xfs_qm_dqfree_one(
 int
 xfs_qm_vop_dqalloc(
 	struct xfs_inode	*ip,
-	xfs_dqid_t		uid,
-	xfs_dqid_t		gid,
+	kuid_t			uid,
+	kgid_t			gid,
 	prid_t			prid,
 	uint			flags,
 	struct xfs_dquot	**O_udqpp,
@@ -1639,6 +1641,7 @@ xfs_qm_vop_dqalloc(
 	struct xfs_dquot	**O_pdqpp)
 {
 	struct xfs_mount	*mp = ip->i_mount;
+	struct inode		*inode = VFS_I(ip);
 	struct xfs_dquot	*uq = NULL;
 	struct xfs_dquot	*gq = NULL;
 	struct xfs_dquot	*pq = NULL;
@@ -1652,7 +1655,7 @@ xfs_qm_vop_dqalloc(
 	xfs_ilock(ip, lockflags);
 
 	if ((flags & XFS_QMOPT_INHERIT) && XFS_INHERIT_GID(ip))
-		gid = ip->i_d.di_gid;
+		gid = inode->i_gid;
 
 	/*
 	 * Attach the dquot(s) to this inode, doing a dquot allocation
@@ -1667,7 +1670,7 @@ xfs_qm_vop_dqalloc(
 	}
 
 	if ((flags & XFS_QMOPT_UQUOTA) && XFS_IS_UQUOTA_ON(mp)) {
-		if (ip->i_d.di_uid != uid) {
+		if (!uid_eq(inode->i_uid, uid)) {
 			/*
 			 * What we need is the dquot that has this uid, and
 			 * if we send the inode to dqget, the uid of the inode
@@ -1678,7 +1681,8 @@ xfs_qm_vop_dqalloc(
 			 * holding ilock.
 			 */
 			xfs_iunlock(ip, lockflags);
-			error = xfs_qm_dqget(mp, uid, XFS_DQ_USER, true, &uq);
+			error = xfs_qm_dqget(mp, xfs_kuid_to_uid(uid),
+					XFS_DQ_USER, true, &uq);
 			if (error) {
 				ASSERT(error != -ENOENT);
 				return error;
@@ -1699,9 +1703,10 @@ xfs_qm_vop_dqalloc(
 		}
 	}
 	if ((flags & XFS_QMOPT_GQUOTA) && XFS_IS_GQUOTA_ON(mp)) {
-		if (ip->i_d.di_gid != gid) {
+		if (!gid_eq(inode->i_gid, gid)) {
 			xfs_iunlock(ip, lockflags);
-			error = xfs_qm_dqget(mp, gid, XFS_DQ_GROUP, true, &gq);
+			error = xfs_qm_dqget(mp, xfs_kgid_to_gid(gid),
+					XFS_DQ_GROUP, true, &gq);
 			if (error) {
 				ASSERT(error != -ENOENT);
 				goto error_rele;
@@ -1827,7 +1832,8 @@ xfs_qm_vop_chown_reserve(
 			XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS;
 
 	if (XFS_IS_UQUOTA_ON(mp) && udqp &&
-	    ip->i_d.di_uid != be32_to_cpu(udqp->q_core.d_id)) {
+	    xfs_kuid_to_uid(VFS_I(ip)->i_uid) !=
+			be32_to_cpu(udqp->q_core.d_id)) {
 		udq_delblks = udqp;
 		/*
 		 * If there are delayed allocation blocks, then we have to
@@ -1840,7 +1846,8 @@ xfs_qm_vop_chown_reserve(
 		}
 	}
 	if (XFS_IS_GQUOTA_ON(ip->i_mount) && gdqp &&
-	    ip->i_d.di_gid != be32_to_cpu(gdqp->q_core.d_id)) {
+	    xfs_kgid_to_gid(VFS_I(ip)->i_gid) !=
+			be32_to_cpu(gdqp->q_core.d_id)) {
 		gdq_delblks = gdqp;
 		if (delblks) {
 			ASSERT(ip->i_gdquot);
@@ -1937,14 +1944,17 @@ xfs_qm_vop_create_dqattach(
 
 	if (udqp && XFS_IS_UQUOTA_ON(mp)) {
 		ASSERT(ip->i_udquot == NULL);
-		ASSERT(ip->i_d.di_uid == be32_to_cpu(udqp->q_core.d_id));
+		ASSERT(xfs_kuid_to_uid(VFS_I(ip)->i_uid) ==
+			be32_to_cpu(udqp->q_core.d_id));
 
 		ip->i_udquot = xfs_qm_dqhold(udqp);
 		xfs_trans_mod_dquot(tp, udqp, XFS_TRANS_DQ_ICOUNT, 1);
 	}
 	if (gdqp && XFS_IS_GQUOTA_ON(mp)) {
 		ASSERT(ip->i_gdquot == NULL);
-		ASSERT(ip->i_d.di_gid == be32_to_cpu(gdqp->q_core.d_id));
+		ASSERT(xfs_kgid_to_gid(VFS_I(ip)->i_gid) ==
+			be32_to_cpu(gdqp->q_core.d_id));
+
 		ip->i_gdquot = xfs_qm_dqhold(gdqp);
 		xfs_trans_mod_dquot(tp, gdqp, XFS_TRANS_DQ_ICOUNT, 1);
 	}
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index efe42ae7a2f3..aa8fc1f55fbd 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -86,7 +86,7 @@ extern int xfs_trans_reserve_quota_bydquots(struct xfs_trans *,
 		struct xfs_mount *, struct xfs_dquot *,
 		struct xfs_dquot *, struct xfs_dquot *, int64_t, long, uint);
 
-extern int xfs_qm_vop_dqalloc(struct xfs_inode *, xfs_dqid_t, xfs_dqid_t,
+extern int xfs_qm_vop_dqalloc(struct xfs_inode *, kuid_t, kgid_t,
 		prid_t, uint, struct xfs_dquot **, struct xfs_dquot **,
 		struct xfs_dquot **);
 extern void xfs_qm_vop_create_dqattach(struct xfs_trans *, struct xfs_inode *,
@@ -109,7 +109,7 @@ extern void xfs_qm_unmount_quotas(struct xfs_mount *);
 
 #else
 static inline int
-xfs_qm_vop_dqalloc(struct xfs_inode *ip, xfs_dqid_t uid, xfs_dqid_t gid,
+xfs_qm_vop_dqalloc(struct xfs_inode *ip, kuid_t kuid, kgid_t kgid,
 		prid_t prid, uint flags, struct xfs_dquot **udqp,
 		struct xfs_dquot **gdqp, struct xfs_dquot **pdqp)
 {
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index ed66fd2de327..97336fb9119a 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -191,9 +191,7 @@ xfs_symlink(
 	/*
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
-	error = xfs_qm_vop_dqalloc(dp,
-			xfs_kuid_to_uid(current_fsuid()),
-			xfs_kgid_to_gid(current_fsgid()), prid,
+	error = xfs_qm_vop_dqalloc(dp, current_fsuid(), current_fsgid(), prid,
 			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
 			&udqp, &gdqp, &pdqp);
 	if (error)
-- 
2.39.1

