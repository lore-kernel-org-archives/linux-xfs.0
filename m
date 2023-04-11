Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF3ACC76196
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Apr 2023 03:35:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbjDKDfe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Apr 2023 23:35:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjDKDfd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Apr 2023 23:35:33 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15382EB
        for <linux-xfs@vger.kernel.org>; Mon, 10 Apr 2023 20:35:31 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33AJvRd6014257;
        Tue, 11 Apr 2023 03:35:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=r0pl69zyyTPCPfyejNd01/hp3JCJMNjsam5ehEhhhEg=;
 b=zeCauSI4MVipvSSNV10nMKnJnEmn4DJJIB4ptMmT8IfBf+4AD7ARG3lpUhRLUzRsrBfs
 WnGq+BkYoI5jpbOjXd9jKwR5uo9+9MO52JchamtlwlUyUMYTrW7McgzOVP5JoYAhBazs
 W0eBpdvv0GNUHLaVrfJSTaatmSDEvLzchFwQOywoXvRKwB/KUhT2+umZ0yie1eSHpB95
 9u8mfwv0QI9+EzSOMndK2EDhzy7xPh8t+PzN1nWXfWnuhv9dObsqh/B1he0ufUtZcvDe
 3ZPAntZZTerpK0L2ywqUo3+zqaQLyBgajp63B5UxNhhQkEBFqD5BhHDzalQCIlgAo5kL Nw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0b2v9tc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 03:35:27 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33B3UZqg039058;
        Tue, 11 Apr 2023 03:35:26 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3puw861j7d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 03:35:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Luh3tvt7G3Bcahc5/myR04njocmPmF6xkbcgpbWhNDB6r7IkxcRnqzc5rPiKYVaHFNjSbNOQSpKakX2azyaQ5iaMlfSBWNQYq85UloP4sWl1Pr2qKjThncx6Sv0l1//mMZ/cA7+deNqkdJzBGGzkUaV7BZ84EhWJgBY26PUIYdrxxeotxNEywgShtUapM209i+8VpcOwy3ZgHivZyygz/LGJTfX07sXp6cx6IWLWgIUO14MX/cVMQ2dqgLiljZGw/Ul4NfOAKHxGH49AKkI65b3UwkWg+oBQvXmaw2qWs37NtJ3rU53PdvWTrHSz5Bg9itMtlnJsYL60yS/bgMbMZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r0pl69zyyTPCPfyejNd01/hp3JCJMNjsam5ehEhhhEg=;
 b=GcW6P6z1Dj+PFf2OnaSs2XSDDVvygElT5ZQzLStY8rV6BN7SHXC8DsnOfYicN0eiC4/JfCUVsKBymx7V9ndnKfqf+nDZ3qSrBz1L4rW+7kL99vMmv5j5jP3R0QAPI7D1nAbiSnq8SLVKnOQTkzjQo2MbVPO7v0oyVRBWIuPHTIVMXjgHtQ4ImrbigbakDx98ryDPPQSGVNnn8w2sb5ewva8zAqopaFT0xTQDMGBAsseFfZxuxPC6fkv/DMF/o9hdbfcDTEB65cP88kb7rem/PJwVXdwBMSsryb7ujchBOAJUTORi0uDomuBYWK92/pWGakhhdkdY1ypJgcQ6V2qgYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r0pl69zyyTPCPfyejNd01/hp3JCJMNjsam5ehEhhhEg=;
 b=TObk3D5OEwCm7/cfq2BpYTtREh4y575M0+7qf95QNC5BznyA9966Gtr+eUuseNAJk7y2qkMWopUR6reCZr11pN6JSvkxPByKqlmwkMsdP7AA4HmXsWbiGT6Jr6nrEhiJr9Hlq6T1jgmZkCHXZf5rMrV3wLTRCKHT6fmV2L8rBvY=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CO1PR10MB4563.namprd10.prod.outlook.com (2603:10b6:303:92::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.34; Tue, 11 Apr
 2023 03:35:24 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7%3]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 03:35:24 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 00/17] xfs stable candidate patches for 5.4.y (from v5.11 & v5.12)
Date:   Tue, 11 Apr 2023 09:04:57 +0530
Message-Id: <20230411033514.58024-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0103.apcprd02.prod.outlook.com
 (2603:1096:4:92::19) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CO1PR10MB4563:EE_
X-MS-Office365-Filtering-Correlation-Id: ce78ac01-5fa6-4460-d638-08db3a3dc8bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fRNy0N0FlGmAbXQjrtJjLKjvhHvuqSenffm/RbA197MfHvY0+AfW/NrnwCcv1u9v3Zs00w/0AD2sGG5yY4NX6idT0IkSqmF3lYCjWqXwjySBQ3daFS/98RPW4xvxEnMBLA/J01o99gJjSEHng0mBsFjSmhyPta1iX2gmZt9Vw+/4Brzi7lAU9Q8twsnbPt49Ne/0pmF65SBF3duZ8ZvzbpTF7VXxQn9LO2gUbCIAJSSDBIN56f8YIcGXpCcOY41LJ9fwY8w+AcLHIgYbFXmARNeMWWKdKWU2/tpTPvakdEfO9BuLDL+DsL3aGCQRxHwzjFviL4VrPPI9MBnikKkeSF43Eh8U3C+9tocRArx9Fh9gXCsibPOGtKio+6sBgjKEokINF4G/Ci7Leu4BXsfhFzhLK89c5phXAExnyarclNwwtCOBBkFArXg6M8sxLrSOhNjCFJ+RoSN+S/fuydjLxSYy1HLviz7imgTx9vVNATpQleW3dz1YTe6vvTC90VxVzCdv2HbOUJN5FL1HiLeAHCqVOXsuHKNfA2fQ9Otz/SiwZVhm1RN5Ytkzg/q9yvs4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(396003)(136003)(346002)(366004)(451199021)(6486002)(4326008)(66556008)(66476007)(478600001)(66946007)(8676002)(6916009)(41300700001)(83380400001)(316002)(36756003)(86362001)(2616005)(6506007)(1076003)(26005)(6512007)(6666004)(8936002)(2906002)(5660300002)(186003)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/B7YWtaKiIRxvyeDDxjv1bytFXulZqgNaVpD19Zp5cZ/Ou1cMk8eOX84pckL?=
 =?us-ascii?Q?7CPiRjtNqDCFnznQqCKuXuO9O5uJTlzGTo1eIkYmX6dzVdUeZx/1VpzQ0L21?=
 =?us-ascii?Q?1Hp05rlM1jHCTTFFlK5uXivES6isgo3OPhH6lgiOubxvK93up5yenVdDZrt7?=
 =?us-ascii?Q?07vfoJVxsI+ys7ZClgOuQ6KOvWcVSPlZlYxqgZGc0ikQrpKdS6UdmOl0Lmak?=
 =?us-ascii?Q?E4F6I56e62LnRe/0JMNRlGb0+BE6lUT589fDAsiAteCAaTBH3luZOWmkiw4d?=
 =?us-ascii?Q?7C6GXf6hcZcowH7seigMtr3IMk5TDG6gNcLyvcKVDCs6wjlmt1/JCQ8YvuMx?=
 =?us-ascii?Q?HEeBaoYjGjFpr0lBvCfJEG8pq0OLMkH7SGolruwC3IuCtcdmiXSDnfZBQhUv?=
 =?us-ascii?Q?iVIhM65fzzDs3/cpa0K8RkJ8+Ebidhp7qOk82ll+zgYU3cb6MgHEPuFQsqTg?=
 =?us-ascii?Q?ZdhhkretlFlbxR2EVnUtKs+9HPDIb62nz6taHkZB0HXo+dGK7PGlG+yRxrMG?=
 =?us-ascii?Q?tV/SGZvu2d+xLd9PKMBuBqqKGvVLKXS0lyh74CvkivfxppBhLYPEO0o983RZ?=
 =?us-ascii?Q?aRQeJx31T/KXL8AW9TB0C4x889coXfwJKB/XapTjA41vXgNEpRwRjjBxd3MS?=
 =?us-ascii?Q?eH1Kclz3bzXngk98AiiDOoujOP/JlttAGfbMGdttVF2kRkvFkfEVgn75H07T?=
 =?us-ascii?Q?8+4m4vUSNQq782NGSvCml6BCaCIYbAJBWCznTlpLVf32FAU5f3CkSL0ktrJ+?=
 =?us-ascii?Q?Vpa8Kcje+CW/9pL+iQc1DeWgC928rgIPgHJBccEfEsMHBvUVupm+pKfKX/oM?=
 =?us-ascii?Q?m1K2GqMUQ/VpCam5EGI2ODrvN2D3wz28i4nB69/IRgiltNOWfQD8oJOKH1id?=
 =?us-ascii?Q?r+oXdUGxRR5I9X5kFq3bMIbMQVj099mHhfOTknVNtoAEs1Pl8yoQvScWTEhM?=
 =?us-ascii?Q?4LJyssWVxKIzyV8N+Mn3m/yTnijNcoqwqjaqNYeMiLB/i5ICoImf6j3Ukuso?=
 =?us-ascii?Q?xTWqMkLBtstp0CVes3v6925HZdByJc+hO9QvFHs0eaA3Ka5Qo9Ym9CLYaQyy?=
 =?us-ascii?Q?56RgE7DjQ95WyjIQi1vz9IVL7L2enQIU2uI81HaeBm+AlK8cffn6TKCPGXSb?=
 =?us-ascii?Q?oMKfstgxkhK6T4o5DEtu82XZJLAjuajfICloHO8bL63PeaY1wiCWvNqne6Vx?=
 =?us-ascii?Q?b2TGYKS1cmghVJyp1OX5wyEPOsL6fh4RVAAjvM+x8L2p0mb43IrpVUpz1tkB?=
 =?us-ascii?Q?rds4geNbVGLlMwk0MAEUl3fOOn0kpaKzVfDAn81XDPYnhxX/JoRLjZsthrtM?=
 =?us-ascii?Q?m4qAq+AVuBj97HKpqsZui5rkSE1J6ABMzNboE2ct1CuN2PouiB+RAXVGS4kr?=
 =?us-ascii?Q?YFaA6ZToRZY38Q0+OVJd0sjpSv6WVponKMeNcwkJ1cYQZniK6r1VoajeYhJs?=
 =?us-ascii?Q?3FzMrQXi2d9p8zT+kR//DCvHbhzkmIF/qkVHJ6EhDOOFJiozoypBNOFt2dXS?=
 =?us-ascii?Q?NOVSrlWWSWp9hDfutK7pvF3BYe3d8u8GQirU0BoAiTjmHPb0jasgWsX1QAvy?=
 =?us-ascii?Q?kLTJdIGE/7KbcG4rhkolYnn9COsGC0aykW0iqaR1?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: A+258etUKTHuBejbRez53zIMm/NccS5lVtxSh917OeJql/mYSWkqHzjuxiPmgEw4SyBu/GcvpbrtbKjFbv6hVKe7ZuamLrr2IA+dCvbFDGCjLZWuSgQ9CjsjLHpOYEkTR2pqqql6xc2pnKkIISfDO5kHDJEiOX+SFzXxzsQAt3k0q+9dnEBEfTimtaqNyXp7uGVe6zgA4oyBge0bn3OtWgp4i4Tfa4CnP0de0UflwGU+LiuJ7POilyy0PxosQPfYWIim/BQiCh8JeCfEx3ub2fTQvZmWKELbCNUj4U3eFr1B9gKSRFKQ2kXApl8OIU80jckv3mBkEhRKBWqIBCVlZuwwOh6fHZ5kSeWXxl5/T7s8wIZa+IkCYs2uOqotezlNtZ8A/2M7DDw/akU4B5a5J+EGrtELZt4sZnfXIZpT6Ct1NGj+O2eE9iSI4Ggfy87+H3IV1Xj8U8hqRPpmgP1UPOYTK5XAZ4lTPvlpqAl2j9eCs+3ppDkLk0VhqckU3pDWdfSJZUjctuWkszwN9ojAb5uFF/G1Fl/feYIzDvyoezQQmINW4CMTF4qLbFnQ5NhVL05pcV+xFLtA5UOksf+o9JSL6r5j1KKcuazjEqmp0eRHHnsvfy3/lG0Y7eOBRNmNbLQLSdmqQusXuom7zN3kWwF/LaPU6o2OQhb+Va0NbQuxkNVcN3AUv9p2pwUF5Z/+RFh3H+tullVcL0kbJ/UGCnLHO3tJ9XWYNV0q7KCcKGcMGkhPQu4uToGeHH3uVEHDnPAitH4rRmmKhTgMokrOu8w8L+69Pj4qAq4WtGw5DjFmY3OD6xmSZy+66qRbsvZI
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce78ac01-5fa6-4460-d638-08db3a3dc8bc
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 03:35:24.1357
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sboFXWL2H3oVzfB77GrSc4PlBNGiIn5XZrRdIxNixpUAVuRGDdvQ+bAqUHA4ie1ofR67+40yWwRU3WFUG7B0mg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4563
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-10_18,2023-04-06_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304110032
X-Proofpoint-GUID: u4aJc9ucm613yEC1JE1iARvRkQD_Lptl
X-Proofpoint-ORIG-GUID: u4aJc9ucm613yEC1JE1iARvRkQD_Lptl
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

This 5.4.y backport series contains fixes from v5.11 & v5.12 release.

This patchset has been tested by executing fstests (via kdevops) using
the following XFS configurations,

1. No CRC (with 512 and 4k block size).
2. Reflink/Rmapbt (1k and 4k block size).
3. Reflink without Rmapbt.
4. External log device.

The following is the list of commits along with corresponding
dependent commits.

1. xfs: fix up non-directory creation in SGID directories
   1. xfs: show the proper user quota options
   2. xfs: merge the projid fields in struct xfs_icdinode
   3. xfs: ensure that the inode uid/gid match values match the icdinode ones
   4. xfs: remove the icdinode di_uid/di_gid members
   5. xfs: remove the kuid/kgid conversion wrappers
   6. xfs: add a new xfs_sb_version_has_v3inode helper
   7. xfs: only check the superblock version for dinode size calculation
   8. xfs: simplify di_flags2 inheritance in xfs_ialloc
   9. xfs: simplify a check in xfs_ioctl_setattr_check_cowextsize
   10. xfs: remove the di_version field from struct icdinode
2. xfs: set inode size after creating symlink
3. xfs: shut down the filesystem if we screw up quota reservation
   1. xfs: report corruption only as a regular error
4. xfs: consider shutdown in bmapbt cursor delete assert
5. xfs: don't reuse busy extents on extent trim
6. xfs: force log and push AIL to clear pinned inodes when aborting mount

Brian Foster (2):
  xfs: consider shutdown in bmapbt cursor delete assert
  xfs: don't reuse busy extents on extent trim

Christoph Hellwig (10):
  xfs: merge the projid fields in struct xfs_icdinode
  xfs: ensure that the inode uid/gid match values match the icdinode
    ones
  xfs: remove the icdinode di_uid/di_gid members
  xfs: remove the kuid/kgid conversion wrappers
  xfs: add a new xfs_sb_version_has_v3inode helper
  xfs: only check the superblock version for dinode size calculation
  xfs: simplify di_flags2 inheritance in xfs_ialloc
  xfs: simplify a check in xfs_ioctl_setattr_check_cowextsize
  xfs: remove the di_version field from struct icdinode
  xfs: fix up non-directory creation in SGID directories

Darrick J. Wong (3):
  xfs: report corruption only as a regular error
  xfs: shut down the filesystem if we screw up quota reservation
  xfs: force log and push AIL to clear pinned inodes when aborting mount

Jeffrey Mitchell (1):
  xfs: set inode size after creating symlink

Kaixu Xia (1):
  xfs: show the proper user quota options

 fs/xfs/libxfs/xfs_attr_leaf.c  |  5 +-
 fs/xfs/libxfs/xfs_bmap.c       | 10 ++--
 fs/xfs/libxfs/xfs_btree.c      | 30 +++++-------
 fs/xfs/libxfs/xfs_format.h     | 33 ++++++++++---
 fs/xfs/libxfs/xfs_ialloc.c     |  6 +--
 fs/xfs/libxfs/xfs_inode_buf.c  | 54 +++++++-------------
 fs/xfs/libxfs/xfs_inode_buf.h  |  8 +--
 fs/xfs/libxfs/xfs_inode_fork.c |  2 +-
 fs/xfs/libxfs/xfs_inode_fork.h |  9 +---
 fs/xfs/libxfs/xfs_log_format.h | 10 ++--
 fs/xfs/libxfs/xfs_trans_resv.c |  2 +-
 fs/xfs/xfs_acl.c               | 12 +++--
 fs/xfs/xfs_bmap_util.c         | 16 +++---
 fs/xfs/xfs_buf_item.c          |  2 +-
 fs/xfs/xfs_dquot.c             |  6 +--
 fs/xfs/xfs_error.c             |  2 +-
 fs/xfs/xfs_extent_busy.c       | 14 ------
 fs/xfs/xfs_icache.c            |  8 ++-
 fs/xfs/xfs_inode.c             | 61 ++++++++---------------
 fs/xfs/xfs_inode.h             | 21 +-------
 fs/xfs/xfs_inode_item.c        | 20 ++++----
 fs/xfs/xfs_ioctl.c             | 22 ++++-----
 fs/xfs/xfs_iops.c              | 11 +----
 fs/xfs/xfs_itable.c            |  8 +--
 fs/xfs/xfs_linux.h             | 32 +++---------
 fs/xfs/xfs_log_recover.c       |  6 +--
 fs/xfs/xfs_mount.c             | 90 +++++++++++++++++-----------------
 fs/xfs/xfs_qm.c                | 43 +++++++++-------
 fs/xfs/xfs_qm_bhv.c            |  2 +-
 fs/xfs/xfs_quota.h             |  4 +-
 fs/xfs/xfs_super.c             | 10 ++--
 fs/xfs/xfs_symlink.c           |  7 ++-
 fs/xfs/xfs_trans_dquot.c       | 16 ++++--
 33 files changed, 248 insertions(+), 334 deletions(-)

-- 
2.39.1

