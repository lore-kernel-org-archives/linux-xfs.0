Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84A82C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 10:08:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5EB8E60EB6
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 10:08:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236237AbhIPKKP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 06:10:15 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:41914 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236222AbhIPKKP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Sep 2021 06:10:15 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18G8xuwi010995;
        Thu, 16 Sep 2021 10:08:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=1IbgkB9IFM0v+GMnENDVupc5HZxVLS60Suk4vHn81PU=;
 b=kxkw5geojTwYmcpyN+AseRwiltDElYU9/efk6EYkk9NrmfbT1axEapT4j+qLhJsWUT70
 Ny1X70TavRIGYiI7p8n7su11Z9fHaBjIdBB/2bmRRmHJ5zsmeXkrVruyFk67OECjoTBh
 9uC6bJg/biuz0HDWhOEIIKJwQerxwM6GjYWn7ysmEm+iC4DuapmFmEpoUAuf6LAaUxVj
 WU1uY0M3CLC6KQrjRgNa2hkEaGkOitjXn/c6wfckzQJcAlgXlJCa8q3tMuP2vr1aq3zl
 nT7cZCliceI12yDL5wu1sSNCQ0Y6qkFzfZblPtZcF3Mu73S9ZsoY0oL08n2SBVwnONaM Ug== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=1IbgkB9IFM0v+GMnENDVupc5HZxVLS60Suk4vHn81PU=;
 b=NWoa8Svp7eg7WnNVZM2bn+oHzr3F8JPgDNlUbVNIEcO8qyPYOKF8XtI+DxkGDBsekIWd
 oMiesJdijd6cc8JleBh7JTtqv/8vO9fWK8QY1pwXTIpy/A8450iew6wgplYjeWKEXylD
 ktUFnIs1Uo+nEXfluJdvDWp5MdChu2/cv75f41375kjOROYPRhR4q71kNni1NzOccdd7
 BpLuah3B2lV59iB5q0TUsFEVTEpQ/5mOKI1+b0fnzVw0tzTV66r13w8GQDs7TU4vgqfm
 SIiv/E0wkVFye00LioswyWHL/uBx4Jf5hUxo/abqksa7NQSJtN/hoCM/ggObJnO8nBC0 YQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b3jysjvcg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 10:08:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18GA5jIb171695;
        Thu, 16 Sep 2021 10:08:52 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by userp3020.oracle.com with ESMTP id 3b167uxq03-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 10:08:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F3f3XRojEDexitmVr8XUuBFyFmaOR4MtzTuhr8XkPUlbpcX60L1TbrSouT09tBzsBBcB4OfABH77l2m0m7228ECIjN/H3UnFkceqU/0x6NvhwE99lJi/DG1sFvcO2it4ZsTVXFS4YbzRo8+Uzd0q7wLEkJcl2dMILQAfJVT4R4M208tCJpcIB+z9jy00K1URrQqrdqB86aRX5Idip9EyaKgrh8jCp4qZAHjgkL5eJd7eqMxBcxx5Ar0tdRsASGFuHRTtFgFdLLkgrI+NqEgOeJa+2flj4/vvkon3H695QU94v4XZbjonFlOFkTBthJd2sj2NJv9koFpMaokVzWUq8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=1IbgkB9IFM0v+GMnENDVupc5HZxVLS60Suk4vHn81PU=;
 b=UQHZCR/KMWeIYo3Fv00uzS70SE87+d3d0XsPXyOlIbLzDJclDsjdqsrWyOHGZzwkRq1mguzmhGiU7G6rQbxecPGD8JFZkw+cCCvgp20HetTsz2UkWFja5GU9U29EESRtpyoDA5RFfdYswV5rYcpmQ3x0iMflmU4+gol0qG9OEXF6UMhANX3mIf48GXq4Ps4GuX/euzlVmtZXUrpGGNvGwd+JRZBV6hBT0ftqjfNi40rpLe8OBvP3ksNRzWZK2XlAn4W23SWTUbOSSMPQxkQf76DNKJGsRzRzY6niV2b+V2v/+i+pixhyM8kb9pVqERrtUakZ2K1CfbCmQv5eh5JBeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1IbgkB9IFM0v+GMnENDVupc5HZxVLS60Suk4vHn81PU=;
 b=Miiz1v0ND74/pYHNnRvJFgmyEl4ylt2Ep5LcMF62SkJSs6A/DTiP9YoIybEawfHDVpyUHU4IqWSZSbA9wrlXgtb9VBMy5nlI739nLcu4j6lJVluKbiTbnO/eVXSuDaslsVBbYtIT7rPjUpgSGd3BZFZd80ptTjPidOu7CVC4A1M=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2878.namprd10.prod.outlook.com (2603:10b6:805:d6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.16; Thu, 16 Sep
 2021 10:08:50 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%9]) with mapi id 15.20.4523.016; Thu, 16 Sep 2021
 10:08:50 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org
Subject: [PATCH V3 00/16] xfsprogs: Extend per-inode extent counters
Date:   Thu, 16 Sep 2021 15:38:06 +0530
Message-Id: <20210916100822.176306-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0158.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:71::28) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from localhost.localdomain (122.171.167.196) by MA1PR01CA0158.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:71::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Thu, 16 Sep 2021 10:08:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f4cc19b6-0101-43c1-d32f-08d978f9fad6
X-MS-TrafficTypeDiagnostic: SN6PR10MB2878:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR10MB2878F14983F198C267EEC2D4F6DC9@SN6PR10MB2878.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AhBCVOoYx1FBfBiIN72iszxCGY2M3woEsXNDkEWEryVHBd3p5XKbdgSths9ATwrZfPWZ+cUYfz/CVDnYGPmBdZrDxQpLuowbeUOvciz2yroUHzJvswY4RR7sjNClnOTyDMXJPp2Ow4rOiqnNpeAQxINH7gqrbk+ocoHbAzh1oCMIdGrnlreYbPXqJNX8aGV86JCd7/c0PKa54kMq8zDraUe5xWyUsp2Cj1dgg0TML0T155wDLQOfkzN0Apbr1gdoKANV2YuXzONbiwb9Jgx4H55tbzyTSoj2pEbnVnt+UrV/plEpILJSHGhfccDlIMnGtVXcRWVL9aWKdUl5fkLm2MHJ93imIDpls76jSYLfTkkKik6faF8/pnz8y41MatSXlf2HgngIkCJUnnxykl2s5WdB562dbDuhCH8ByILj3g3PtyuBtzJGElX4zxNw0CYQNbGSE3LCB0mr9QdtBW79C72Yae8Qwv+unzj8e3IGf5bCmb++NjcBVPYRV5TmguH7zvrXmdejClTgV2YKqO1Y2Un+0HiidGYDMYdT2a9ALcmo0UA/NleQ913tENGBr2RWfvALOHErI7JcPruPjw5L8mAxP2aCH+TFDS0uOHxxJbtu5tWOdFHuZMZo5zSW6gqja9m25ef3pUDbCJNWWMNzIOZAQYrAGYfoaTrtwEWCBiZhm+fbLad/wc5TYT2N8qtCRFgeiGWGFSVsiiE5YEPbPnfsoOBYd7C1+Ys4adCs+CQvjPJs/e6+9RUbrcrdMVBIFN1eQK4UM7PvZhJuv/zS3d33z+06KWVZ/wLZFrHnUds=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39860400002)(366004)(136003)(346002)(478600001)(5660300002)(186003)(66946007)(86362001)(66476007)(66556008)(38100700002)(2616005)(83380400001)(6512007)(8676002)(956004)(4326008)(26005)(6916009)(52116002)(38350700002)(6666004)(966005)(6506007)(1076003)(36756003)(8936002)(6486002)(316002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4QT8cy8GUlrfjPKUcbEA0QjTostA+RgjprDUaos7Qi0Pnh0QJex1Na/NZjzh?=
 =?us-ascii?Q?6W2xV5OmhrI/wYEdbI3tbtwiU8vm5lIexPnGwVqUUuxN2awApRBTATKx6mnJ?=
 =?us-ascii?Q?c6b9oCB2dTR6Rx83ji6ZvOmBDnGrup9fSNtXNdLl703Cy+1Uf8ElhGVSoSI9?=
 =?us-ascii?Q?8ahQ5Ga6p888HEfTx2+IU1Mn83hCyhDWHX9UxruHi3LN9Ut/NzCUjHBoxF4q?=
 =?us-ascii?Q?JeuCKIceAi2wAUFi2IwfDt106Gix6Vsj+YCOQcGQcZEqWt8mVFui4v4Q0QAm?=
 =?us-ascii?Q?oTZoFh+EvxMEpAWP4PHVNCieASPFpunv0eVsjK7Bf9uYs5q5XyJ09P2yLUJh?=
 =?us-ascii?Q?3ggfZCM0yhQlvBDeiWnfjlMuDJ0WRtAiN+OFHjA2de6B8u8WHAv5E6n5baoJ?=
 =?us-ascii?Q?yWVoPAKPtnC4MJaiQjksHf8uIy7LjnYl46UthZnOVevsfEOGY8pnro657CRZ?=
 =?us-ascii?Q?0e4jxDv8flfsM63UInT/h4MrwWn0cP07zyZH/JKu9yOIr7VoYcg68prhvQd1?=
 =?us-ascii?Q?YZcw3lyNom+0MzMW6evIVqQ+KnDIxkBshLNfcGsekHDqxzkaF7qAVsLi9aRu?=
 =?us-ascii?Q?84zkTxQhYpWbkMg/t6zdDlRjifxETJ7VrzwtbsJxDta9g6VhqrNXa9x/pefa?=
 =?us-ascii?Q?RZxIOZori1O0OfUPccAodgMglRPViKqkOLtyQb9tJFs/TLiSLePgHKXY0oaQ?=
 =?us-ascii?Q?SQ06c2pwS4hTCD56mWPq9pChEBAMU02gjYLGRpjvgbGbrXMtec8BsrimpKG5?=
 =?us-ascii?Q?Zw/pvZ1FIinAwQum3dMRyiA3eosOSaFRzlfj7cCjO2fvlMirxYxyumj8wJX/?=
 =?us-ascii?Q?4BdCKQiKe5rFFr5ilpMla2TNRs451nL4GV9q4/6qIpabDyEW3ItxV9FP++d0?=
 =?us-ascii?Q?gjPPV76Z+X0mR9KF5UcV1nH4/Xu7Kl8iDa6Wa9ftuYKpiXAxvXuFANALZOIV?=
 =?us-ascii?Q?tuDygDMPLsStU11zQLjcYgwOFoZ0dSAgi+lcFZw1KDJzPUVf7e5xXAL3rP7R?=
 =?us-ascii?Q?C6WdlN8kj27tTYvEd3IXGQ+RR/UNUP8b45i6vU3yFpTAobmN2kVTGlEfv5hx?=
 =?us-ascii?Q?cvwVEapjRVF4/gmTCr37kuiBlDDuO5oxq5aRpxK4yYLMbaWBFigvAVoHXJ8v?=
 =?us-ascii?Q?cN3sMTrIFRkzwebB5gIrTge6YtpO22Hz50vKR7FJlyDJV4iutHkZ8+akEz1J?=
 =?us-ascii?Q?aPL5vL3cd9o4Lla624e8+1aPNOTlhoaQ0t1Czxvzv3jEo3NM+lWRCENVqaMN?=
 =?us-ascii?Q?L4UW67MsIVqrsh9+QXt3K1N5m1dBD58YvjTmaqRvVNNIsesKPeGBcLUXn66b?=
 =?us-ascii?Q?EI3SAVTXfHN04wo5uaiKF6/y?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4cc19b6-0101-43c1-d32f-08d978f9fad6
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2021 10:08:50.3683
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zr7XmkeNxWjwSvfdyl91rYM8zvIGUK4JHEstvL1jw3aa8UTd08LIVp6nd3xEC/4tGjoAiIMWC0+yXib8lb+Ljg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2878
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10108 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 phishscore=0 mlxlogscore=989 malwarescore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109160064
X-Proofpoint-GUID: 9xk7zjElfwNaPd4z3H3_SLlZSsV3N37H
X-Proofpoint-ORIG-GUID: 9xk7zjElfwNaPd4z3H3_SLlZSsV3N37H
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patchset implements the changes to userspace programs that are
required to support extending inode's data and attr fork extent
counter fields. The changes allow programs in xfsprogs to be able to
create and work with filesystem instances with 64-bit data fork extent
counter and 32-bit attr fork extent counter fields.

The patchset is based on Darrick's btree-dynamic-depth branch.
These patches can also be obtained from
https://github.com/chandanr/xfsprogs-dev.git at branch
xfs-incompat-extend-extcnt-v3.

Changelog:
V2 -> V3:
1. Introduce the ability to upgrade existing filesystems to use 64-bit
   extent counters if it is feasible to do so.
2. Report presence of 64-bit extent counters via xfs_info.
3. Add XFS_SB_FEAT_INCOMPAT_NREXT64 to XFS_SB_FEAT_INCOMPAT_ALL in a
   separate patch.
4. Rename mkfs.xfs option from extcnt64bit to nrext64.

V1 -> V2:
1. Rebase patches on top of Darrick's btree-dynamic-depth branch.
2. Add support for using the new bulkstat ioctl version to support
   64-bit data fork extent counter field.

Chandan Babu R (15):
  xfsprogs: Move extent count limits to xfs_format.h
  xfsprogs: Introduce xfs_iext_max_nextents() helper
  xfsprogs: Rename MAXEXTNUM, MAXAEXTNUM to XFS_IFORK_EXTCNT_MAXS32,
    XFS_IFORK_EXTCNT_MAXS16
  xfsprogs: Use xfs_extnum_t instead of basic data types
  xfsprogs: Introduce xfs_dfork_nextents() helper
  xfsprogs: xfs_dfork_nextents: Return extent count via an out argument
  xfsprogs: Rename inode's extent counter fields based on their width
  xfsprogs: Promote xfs_extnum_t and xfs_aextnum_t to 64 and 32-bits
    respectively
  xfsprogs: Enable bulkstat ioctl to support 64-bit extent counters
  xfsprogs: Extend per-inode extent counter widths
  xfsprogs: xfs_info: Report NREXT64 feature status
  xfsprogs: Add XFS_SB_FEAT_INCOMPAT_NREXT64 to XFS_SB_FEAT_INCOMPAT_ALL
  xfsprogs: Add nrext64 mkfs option
  xfsprogs: Add support for upgrading to NREXT64 feature
  xfsprogs: Define max extent length based on on-disk format definition

Darrick J. Wong (1):
  xfsprogs: xfs_repair: allow administrators to add older v5 features

 db/bmap.c                  |  21 ++-
 db/btdump.c                |  11 +-
 db/check.c                 |  44 +++--
 db/field.c                 |   4 -
 db/field.h                 |   2 -
 db/frag.c                  |  11 +-
 db/inode.c                 |  74 +++++++--
 db/metadump.c              |  14 +-
 fsr/xfs_fsr.c              |   4 +-
 include/libxfs.h           |   1 +
 include/libxlog.h          |   6 +-
 include/xfs_inode.h        |   5 +
 include/xfs_mount.h        |   4 +-
 io/bulkstat.c              |   3 +-
 libfrog/bulkstat.c         |  55 ++++++-
 libfrog/fsgeom.c           |   6 +-
 libxfs/libxfs_api_defs.h   |   3 +
 libxfs/xfs_bmap.c          |  74 +++++----
 libxfs/xfs_format.h        |  77 +++++++--
 libxfs/xfs_fs.h            |  20 ++-
 libxfs/xfs_ialloc.c        |   2 +
 libxfs/xfs_inode_buf.c     |  61 +++++--
 libxfs/xfs_inode_fork.c    |  33 ++--
 libxfs/xfs_inode_fork.h    |  23 ++-
 libxfs/xfs_log_format.h    |   7 +-
 libxfs/xfs_rtbitmap.c      |   4 +-
 libxfs/xfs_sb.c            |   5 +
 libxfs/xfs_swapext.c       |   6 +-
 libxfs/xfs_trans_inode.c   |   5 +
 libxfs/xfs_trans_resv.c    |  10 +-
 libxfs/xfs_types.h         |  11 +-
 logprint/log_misc.c        |  23 ++-
 logprint/log_print_all.c   |  31 +++-
 logprint/log_print_trans.c |   2 +-
 man/man8/mkfs.xfs.8        |   7 +
 man/man8/xfs_admin.8       |  30 ++++
 mkfs/xfs_mkfs.c            |  29 +++-
 repair/attr_repair.c       |  11 +-
 repair/bmap_repair.c       |  23 ++-
 repair/dino_chunks.c       |   6 +-
 repair/dinode.c            | 143 ++++++++++++-----
 repair/dinode.h            |   4 +-
 repair/globals.c           |   5 +
 repair/globals.h           |   5 +
 repair/phase2.c            | 319 +++++++++++++++++++++++++++++++++++--
 repair/phase4.c            |   7 +-
 repair/prefetch.c          |   7 +-
 repair/protos.h            |   1 +
 repair/rmap.c              |   4 +-
 repair/scan.c              |   6 +-
 repair/xfs_repair.c        |  55 +++++++
 51 files changed, 1076 insertions(+), 248 deletions(-)

-- 
2.30.2

