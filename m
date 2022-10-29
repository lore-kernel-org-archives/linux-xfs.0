Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4EEAC38A02
	for <linux-xfs@archiver.kernel.org>; Sat, 29 Oct 2022 13:58:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbiJ2N6P (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 29 Oct 2022 09:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbiJ2N6O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 29 Oct 2022 09:58:14 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 221D952468
        for <linux-xfs@vger.kernel.org>; Sat, 29 Oct 2022 06:58:13 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29T7BVCL023464;
        Sat, 29 Oct 2022 13:58:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=qV5q/Ew1gVUFn50f7sw4YQ+lKLCnJQEsh5n2iBqP1l4=;
 b=Rm7Vj7u2QAkmcljIAAiDElkBIciIjo78b3Nm+nKH7dnQO2eTIKtmQ5j9GGrO8dRLOVz4
 gQTuZNEDYVpsgKwvJOdGgWJKGW70gxq/wpwKCx8i2eXto4cvVf2zCabBB37aXRWisULc
 rz1J7w0SWpM5JF87eBupp2EaEWB3K/9UUdSk57TF+/JrokF0iWU5sCyKJoOfD2XvLAJK
 r/wpA+4uPtWn8lkNUzbpy2EhXanl9QZwSsj9PmUxdY0Ux+7xslkC7KpZDjZR6ylwBI8A
 F+t2UUbenOowFGnHa88t2alAYVhT+ehPIUC4+KplYSz6fkhnCxGB8wQlo72f20/nT/T+ Yw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgvqt8h9b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 29 Oct 2022 13:58:08 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29T9LoIE023884;
        Sat, 29 Oct 2022 13:58:08 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2040.outbound.protection.outlook.com [104.47.51.40])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kgtm1v0js-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 29 Oct 2022 13:58:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O2CbZHYf/SaJHshM9QYKGQF+aTXT10txG82GM3EN8jKOEOsPOc2nvV/45YlypiwRhcfN1iSE8euqRI4KoUcrFY1woKFDqhH43JKMy4VBApjMVjb6be1jHE6+cLbxEQUVuIIVpaxXntjsoYuq9wRKbSe/v/Qx3kx6wc05+Nk10CHdinbciJxCzgfxurXa01vxBThl67a5zkbrtjSTLdmsOY2r3MTmjCy63NIvKiR9YLfHLaosFhjcX7N+dKGVNwsHXhGQtHvqBrb0fJorvQU9kEYQBha2OlEf177zsQ5mrODuv4E285Ke+PSrPWpIs7EHMnyxLrIKotSOLAQweJMoKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qV5q/Ew1gVUFn50f7sw4YQ+lKLCnJQEsh5n2iBqP1l4=;
 b=MbfGK1Ds6EU1fdaet8gb/gB6d1a+lAcFuTYYA6mlyxV4keEXNqyz4Fz02qw9d9cappkcraEL/QbJoxl4o5+3dbpnhhlpToLDVsti/KxeYjPfKN3eM6qP69a5HajNKXqQOMJPXqmSPfFcKZv9qNOaccp3pY8CHpfOa2nRIXiQ33deh+iYTBnWgC0UIqbdsgIi/ltnxQH/qpc53dLtIv1Ul7m/OEpXhKbDEgKeM4i+58Eh3kKqyq89oCBfbDQgIvzeqO7GrbMr8IAT8FO3e5Q4pYks9UP1GATGkjQ+fLcdt+XFAKk7j9RWlikOnzp1bsqWWLQo+Jj1KWpahz8e6qxMGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qV5q/Ew1gVUFn50f7sw4YQ+lKLCnJQEsh5n2iBqP1l4=;
 b=wRNn4/6MnNU5hKb6dyYe18i/+QJ3SgNdodY8xZ4MJpthyhuYpJAuiO/bPb+OjNm8N4dZ0OUStyHLO/524WeGDvklF6mhjWmxPPNnwVFFjPL8fOO4wVVt+r5J3L0NOb5bcBk1vAf5YFPXt3lC35oG8X/d+IXNPVFAaPCXttqulQI=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by SA1PR10MB5843.namprd10.prod.outlook.com (2603:10b6:806:22b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.29; Sat, 29 Oct
 2022 13:58:06 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::4b19:b0f9:b1c4:c8b1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::4b19:b0f9:b1c4:c8b1%3]) with mapi id 15.20.5769.015; Sat, 29 Oct 2022
 13:58:06 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 2/3] xfs: clear XFS_DQ_FREEING if we can't lock the dquot buffer to flush
Date:   Sat, 29 Oct 2022 19:27:31 +0530
Message-Id: <20221029135732.574729-3-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221029135732.574729-1-chandan.babu@oracle.com>
References: <20221029135732.574729-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR06CA0009.apcprd06.prod.outlook.com
 (2603:1096:404:42::21) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|SA1PR10MB5843:EE_
X-MS-Office365-Filtering-Correlation-Id: 3db76a3f-48cc-4858-f9d9-08dab9b59ab4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VibRU0Eh31X9KUaASbp3ishyMxWDUZhXXeLm04bWayUuk4Hx7764k9FRUtQ4lTBMdNiE+2jaEYqSOeUnjuRSvckBl4ie9YvfaaCDNRMKStYgkhOaa+R/7jJng0Hn09n33bTyk5AkE5p4mR6EofuUHJoyAjqEtDoDU1J1VD/UXulVZC85YlEXeAWuUMD2hUSeuhD+8JJi3TvJmKHSzCothzUBN3In8NAY0VR99wFtYXRhh0IfnUTlgN91TSFPm4tTsmYRKhTYSpyhtzHFIFO1dQHx+R4I5bHrWs+J7JcN3hLGpa9UzcQ6Xuo6IV0/jITQPVhpXPyRNIGEmo5EC6pKRpkSgAgI1PQ6V78u63JvWaO4zmdTYkUww1fScFtDuCcyXqfK+/uk+lV4ptG1wjP8f1mtsboVSH9xW4fBd1qaRjykatw0KEczrDoLSumBQi6/LjqSai12jXR9W5Th8Or29EtDoZJod649JrgTl4a/l404fxX3mDv5p7xg5GgTDcfwuTR2ZKqn9/yUpXxwwhsaMPPFMapIeB2px4JJ5dMH/ozE6ixTgT4wUDzENiH+vF3AOmtGU866ahwYC/fDVDVk4BFY83Sh4d+QagODS7qjc8sIIyNutgqWrfYadFTcVZ6FX6x61VF80dyyuPv2eFDoNUQDWv9S+qvqB7veo+ymtA0eJNWrFmHqGWiSdmim9YUBWxMezQTCyitszfuuqrolGg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(376002)(136003)(396003)(346002)(451199015)(1076003)(83380400001)(66946007)(66476007)(2616005)(86362001)(6486002)(38100700002)(316002)(6916009)(186003)(6506007)(66556008)(41300700001)(478600001)(6666004)(5660300002)(6512007)(2906002)(8676002)(26005)(8936002)(36756003)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?P6QDXbUiHrKAyfzxDs/oyz10ROopQpdicjtSHQYhlVf15ZL72i9f7Y22vcvB?=
 =?us-ascii?Q?iidvdDL2U5eJvVbTBfSCxnKGSm2EeaCmQXFE+7iCcno3Xtpv3SNMkjUDTXxW?=
 =?us-ascii?Q?8yTd1wBp+f5K8gDHM7W6+hGDXDI/tb1GUSUDkn7x2b9190Ll0KtyEp13NMeq?=
 =?us-ascii?Q?xN8zq+Pmvq0IiUNTCN1L4xyNNylnIX/4wvk6DNwo1mBdWb8r7c3MH4qQvkNp?=
 =?us-ascii?Q?PEMZ7CkKk1Gc7s42kN6IjU/FvnFiC6rS1+PgectNf7mdlNtmV1GHqfDx3Qyz?=
 =?us-ascii?Q?vd035YXM6l79L+Cv/PG035ybtXyKGj1WtsAqeiTWqzT85R+txhEWB+4rObtn?=
 =?us-ascii?Q?BhkRGk62/zjbxVRaB6whACm8DsmEgWpmpU5j3Lg4BubZ1gERgSjBKfXWyfv+?=
 =?us-ascii?Q?04kJne4JewkxW5Cj/4lGHQbKLfXDylKfFqPcCm2OwQLBK5aftOyMadKCCAWu?=
 =?us-ascii?Q?Bz9wCTm7PRKJWU1dE2feH1BDQqzHpFBLNoznxcrFzE1+HOz+7H4cb3Bmf8cX?=
 =?us-ascii?Q?Gd8SQtuA6Hze73jcGvxo6WOcdkZuP4L+EEXePichF7p5Lz+kD8ViwGuSckcv?=
 =?us-ascii?Q?92MWnI3CVYo1uN+JthlfvXoralCZGJ5bbHoEzKKtJaJ7fCJ59Mr4eqW8TwHH?=
 =?us-ascii?Q?vqaNd9QgKKGxpfLNj2StBDThVDyNJpVwYPNec/LaG53b1IcCn6A+N/qZ4d0K?=
 =?us-ascii?Q?JlqjeHYp1PpQQtbqDJVyDumrTE3Lr4uYMXghaKHPW2Hp7BaZmd/Q/oKRfl7J?=
 =?us-ascii?Q?ZOc8jW60ru7/cajNILYZDVQDwysgdtFhn7wpXpE/EmZbvhCQyJrvMcU1OE9G?=
 =?us-ascii?Q?cFjhghemFt8I0Lzxmao3DCsE/hdbeKrU88sj6SmLI/6+dxdaK6plMOsmNDKa?=
 =?us-ascii?Q?otm6EiWwhoYUtmyFfKYd3swNPuhXJ1UqjA3wHBXj3uMFkDDTd2xbh0VG8HkM?=
 =?us-ascii?Q?BNg11KmFRM17wYS37Vn+vBngSuo/XnJ5ZdyAGEOkpokrcdRMFKfDavrgVwlF?=
 =?us-ascii?Q?N828BX1RnmeCSI0WIL2Wt29m/2dSnJxobfJvHUA231dMBM6DCdPR1dhWTTZX?=
 =?us-ascii?Q?hxVjJkVKF+/KTHBeibV5hYMQ7gbDUpIwAaKZRGiLVyLYpBE+RNBv9iXai+W/?=
 =?us-ascii?Q?kQN9EevBLAgGyVMi64DT1kt3wCC/ECK+d70/FSd7rMqFPVfba0ZKpsV/vb9/?=
 =?us-ascii?Q?w4lWpe5W52302SO7aCLbwA8AfmHWTfNOfUmL2St3a6o6nPifrNizzwq9vqSo?=
 =?us-ascii?Q?BceITSPSy/dxiA2qmRrs2KdsMacrfVEmhSzvFhN8RlyTNjb1Th93zNtGx1ay?=
 =?us-ascii?Q?/vEstunTZ0zauiy7W1lg8MQzvReNvcyBVJAj/L6LnkR7ffU+/+9QpGZwWaQ9?=
 =?us-ascii?Q?Zs9IBU0Gbv91MW5VLwO+HQ6ftUhFkCM3Yy8bvvS8WDDSYeKyirTYMl60QMut?=
 =?us-ascii?Q?fvshlSOmE7iaHRapvivuRMF6G1xCjo4vd9nvF7adyBYnItPMf2UJefLFCHxx?=
 =?us-ascii?Q?jIywg2ZDtPduXAR/PKz5VRjxCMScvRNds04Br6OKtw/gzXDsYT/fPgAJVwS6?=
 =?us-ascii?Q?ln4dAgKPmngFqNpWro+5CNKbJjsBdlPINtXMZXcZ5830aiuqHH46ns5qz8oF?=
 =?us-ascii?Q?5w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3db76a3f-48cc-4858-f9d9-08dab9b59ab4
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2022 13:58:06.3054
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f5PRN2Oq6fChilt9icYZG+WjVA62xEfhfD2HR1WpDqS2244bCq7VXqkMXPVvycYGT/Sq7FmQwogADSJNW2z/Zw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5843
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-29_08,2022-10-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2210290098
X-Proofpoint-GUID: taNoJVyi44VmK5_3Uf1eyslJd7JC-dJq
X-Proofpoint-ORIG-GUID: taNoJVyi44VmK5_3Uf1eyslJd7JC-dJq
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit c97738a960a86081a147e7d436138e6481757445 upstream.

In commit 8d3d7e2b35ea, we changed xfs_qm_dqpurge to bail out if we
can't lock the dquot buf to flush the dquot.  This prevents the AIL from
blocking on the dquot, but it also forgets to clear the FREEING flag on
its way out.  A subsequent purge attempt will see the FREEING flag is
set and bail out, which leads to dqpurge_all failing to purge all the
dquots.

(copy-pasting from Dave Chinner's identical patch)

This was found by inspection after having xfs/305 hang 1 in ~50
iterations in a quotaoff operation:

[ 8872.301115] xfs_quota       D13888 92262  91813 0x00004002
[ 8872.302538] Call Trace:
[ 8872.303193]  __schedule+0x2d2/0x780
[ 8872.304108]  ? do_raw_spin_unlock+0x57/0xd0
[ 8872.305198]  schedule+0x6e/0xe0
[ 8872.306021]  schedule_timeout+0x14d/0x300
[ 8872.307060]  ? __next_timer_interrupt+0xe0/0xe0
[ 8872.308231]  ? xfs_qm_dqusage_adjust+0x200/0x200
[ 8872.309422]  schedule_timeout_uninterruptible+0x2a/0x30
[ 8872.310759]  xfs_qm_dquot_walk.isra.0+0x15a/0x1b0
[ 8872.311971]  xfs_qm_dqpurge_all+0x7f/0x90
[ 8872.313022]  xfs_qm_scall_quotaoff+0x18d/0x2b0
[ 8872.314163]  xfs_quota_disable+0x3a/0x60
[ 8872.315179]  kernel_quotactl+0x7e2/0x8d0
[ 8872.316196]  ? __do_sys_newstat+0x51/0x80
[ 8872.317238]  __x64_sys_quotactl+0x1e/0x30
[ 8872.318266]  do_syscall_64+0x46/0x90
[ 8872.319193]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 8872.320490] RIP: 0033:0x7f46b5490f2a
[ 8872.321414] Code: Bad RIP value.

Returning -EAGAIN from xfs_qm_dqpurge() without clearing the
XFS_DQ_FREEING flag means the xfs_qm_dqpurge_all() code can never
free the dquot, and we loop forever waiting for the XFS_DQ_FREEING
flag to go away on the dquot that leaked it via -EAGAIN.

Fixes: 8d3d7e2b35ea ("xfs: trylock underlying buffer on dquot flush")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_qm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index ef2faee96909..6b23ebd3f54f 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -148,6 +148,7 @@ xfs_qm_dqpurge(
 			error = xfs_bwrite(bp);
 			xfs_buf_relse(bp);
 		} else if (error == -EAGAIN) {
+			dqp->dq_flags &= ~XFS_DQ_FREEING;
 			goto out_unlock;
 		}
 		xfs_dqflock(dqp);
-- 
2.35.1

