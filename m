Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B47D1C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jan 2022 05:20:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234069AbiAUFUr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jan 2022 00:20:47 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:52264 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233792AbiAUFUn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jan 2022 00:20:43 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20L04398001131;
        Fri, 21 Jan 2022 05:20:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=eG1UUx2hhRPQCTPzgYqGJoZzV8SkDuelaInw7bp2ZoM=;
 b=rRv31T/R/r6HHiXNYS/43usREluzbv8ZctAqx+8IMdITTq8+X2wTnEU5uDCKPRtQExcq
 OLUcW30OFEB2CZWRYBu00lvI6IRCQX6CPZVosDCH1Kg+FKSIZ3L4UJeHQ3hQth04IaXX
 Q9iRxn+04zMfh93CKh+3HetCXucrDZCbibj0YxcnmLHFRIUIxZbYynDO+FfrknOeNmcx
 u/UNy6ih4VtTly3TMgu8Db7xedzRNSdvHQIS5OsNLhHJUKivXn/xmlLqd87KtbUdZddn
 BDuAmOx3H8s1dHe/eyMX5iyfowt8RbsimZujmWc1bKVvItClEFMREITSHwqppt1+hUri og== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dqhy9rcp6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:20:39 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20L5H1c8018823;
        Fri, 21 Jan 2022 05:20:39 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by aserp3030.oracle.com with ESMTP id 3dqj05h3jd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:20:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZlJmp0uHJQEBMjA5woWgdlICxr1QHohxIRtNXbe8/fha7qq9+yJNZ1IyHOEtDhkEZALuJ6MZUZmLrxGtnh7DgmQIOgY9AKE8SGhE/28BuIQL/6/2PohsIYi9hWcQQxD0Gv3F5rvTLoqlFFaL9QVGId7WyfFO3fpj1LOBnSWKNW9Di6szhHRqcol9WsJ0pJZvG0azNWYRbpiWE+4TmVWdlAeZsdjfbcRs1IvAiCouGLjdCijHutfdTQPrKgq9h2Z+8YVY5U5pq373TOKeFuOeC2xUrHshILXKIQhci+Btp0CwWizHX5hSSZ0Ip1ifz29Fcp/guQdKBSFfpTPeUKNbXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eG1UUx2hhRPQCTPzgYqGJoZzV8SkDuelaInw7bp2ZoM=;
 b=fIvfQXJ6la9B8gCqle++BAv6qfOKkoPbx53E6ZG/l2bH9VkYWZEcA+4r0HYkjnnUEoEjVUufkC580iV9rpjD19OsuFCyUXf8BEgiN5D24FSKPOO7cXMh1AyNjgagmFAaDsytBkHX7dJlWS043+NaIdK4zMe+RMNxzV43ffFqYn9XyvcIye4SoNFCLfB73KVnpK/uDV3hBvBInIWuLw9BwmpLqL63CePEUOr8QwvLe7fKDW1kw4G63Ec4sTCLonaZ50IKO/BcUbf35eRwsyIQL8UfGCno7mtW3U6lA9qPRq3je4HQj9zuIqVC4rIyipYYxj/DYa7zk/Rkm5sJsl32TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eG1UUx2hhRPQCTPzgYqGJoZzV8SkDuelaInw7bp2ZoM=;
 b=DEumozqluCzKBNaicDSOIZFV6h8VO2kJhbpwu8UFLeAQ1yfnzKK5grOHNaXKy40cqJnz9IiBHmxqdCXZFEJFbztGn+MRpASYUy8ANH1x2ywe7sWZ0qtYzi5pc1iyPT2PcIrBsN4mHmwHITMvuvsz1nKcbZmV4AMx04TKL85KfMk=
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com (2603:10b6:a03:2d0::16)
 by CY4PR10MB1287.namprd10.prod.outlook.com (2603:10b6:903:2b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.12; Fri, 21 Jan
 2022 05:20:37 +0000
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b]) by SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b%3]) with mapi id 15.20.4909.011; Fri, 21 Jan 2022
 05:20:37 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V5 00/20] xfsprogs: Extend per-inode extent counters
Date:   Fri, 21 Jan 2022 10:49:59 +0530
Message-Id: <20220121052019.224605-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0049.apcprd02.prod.outlook.com
 (2603:1096:4:54::13) To SJ0PR10MB4589.namprd10.prod.outlook.com
 (2603:10b6:a03:2d0::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 43cd9b3a-bd1e-4e85-b026-08d9dc9dc1bb
X-MS-TrafficTypeDiagnostic: CY4PR10MB1287:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB12872F378618989F4B0C9D2CF65B9@CY4PR10MB1287.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hJ8WA9vNQ4b0OaQTKFNAALKwchvfjTBd+zQZCLhT5KF6jLzkZhNvgE1V7K2LUUC3P3xqpsDJszOg9U4U3wU7d/OjnAcVUoXa/Ip2LDvgryRmLXtq11lw98j10ddMejaDA4QU2JrgvvtjLXc1/rY1Ip5xINl8g1D2huv34dFq9HwW9l2JmbsfrbrsDZh8pc3Jr+KAnL2JVzqFHcX6dLNN/8h/WPaFyumvPUR61eenOYOFpfVjb9dj1hUiF9zLeCf4a9rrbZwnL9p2muTpJ0FjhPxH54Il0OIv+fsvCC8oNG5b3avKIqhQ5cub+DYAcT6iTqxpfojzw5HeHoDpE4i/F+OHs4rdmy8dgVwxuIyLscKhhXd2ymb8+AHJBtG77tGY8nx32wl79eRi3EnYwAh69k8IH/sM5J/pTLeG2pbhWn1B2Ca/zxua4TZfzIavEf1LbgatrLOn/S6VfboSSj4C7zrETAHShUvOe6xRuxXfd/aQd6O3blJhC/zQfwNpecT83O/JBMCO5AZjmnAwIYfbYhmj5AuOzwvx+2lZtXN8CbAOtSMQG17JJkMacn9xNLODGKdfQdHm5/BYu79Omn0pWqA8H7y05iOOGOWW4ajXgyqk9QKnmyFCeHCW3g5N37by6A23jbKLVfjwIjxVJ0jKb9F/JMgATcfeHMv8jJwnek4xe6dgkVLUkvoRG0a3bOre41IqdH5K6z4NOsUGMRlH7yK5HY5WBCEmJPGTrXG7lXXKRIR1d4qNq24D/g0QqRRyPGkc4bKbiUpwy1WtVW7Ww2/AvfRmCu81HhCo9y6T+KQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4589.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(186003)(52116002)(66556008)(26005)(6916009)(2906002)(8676002)(5660300002)(66946007)(2616005)(6512007)(1076003)(4326008)(38100700002)(83380400001)(66476007)(86362001)(38350700002)(8936002)(966005)(6506007)(316002)(6486002)(6666004)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9Y32C1JTIPdxopgmw30BGJwGtAer/E5lLlWBwxBhSZAoyHNAKYgJrbHqBxNv?=
 =?us-ascii?Q?+wpyOKRHjppm4JleimjLkQ8Ssjy903VNc8ShXSQ5Qt/hrNWOeKmtC4bCTs0m?=
 =?us-ascii?Q?MYBlmBq9Il4aEvMfY9ofUrdDzGJz6aOe3fmpf6tJmrHhPACUDA0ZH96f6gZx?=
 =?us-ascii?Q?CncphbwNQ8XIACDBxp+LHd2HiG2WIn1qVp417KIsT4Bf5BVl9LO47JQANp0j?=
 =?us-ascii?Q?UfvAn+Kxed9s+n68l4r29ld46PO9U40Zp2QTTWOeVyeOTO96K+fuvaEMT8ro?=
 =?us-ascii?Q?a218z7ni+FT//aqc7AeVIwOEFSEunk3n35+V8a2g9hSYZ6lwAmD9ALD2ibnk?=
 =?us-ascii?Q?EZzVd301ujE+sWHHYpMjtsywJF1MpHMdHs2XCP26rey4lFuSwKsIgVpLQZDN?=
 =?us-ascii?Q?2iqbWPJpQ+PNkm1MQDIyUti8D0/H42+eCs2zCx7T2zH5as65bwgTQbZC7ABp?=
 =?us-ascii?Q?jwogXFGfUQtbL/QECTu9vplhnT8G7+hR3GzvGTL1G2vlZ0OgEFvu2fuIcIea?=
 =?us-ascii?Q?z5o3negW3OrqRs4WhnCDekMdl65XAyGuHlp2EDnqQH4fuRSeikx2yj5b2Ly1?=
 =?us-ascii?Q?tftD2pReYlKObsAKES47kEBai9WmanBdnE3dSGDkFeyaut5oMJ3XoAMIKPSc?=
 =?us-ascii?Q?ztE/MEr6xIrIYEjCNa7a6VbxiLf3iHV7PSIFwiywHTsJoWrHXtK4CEC+L7dZ?=
 =?us-ascii?Q?OdWR6GhtrCK+uv5k9LNnUmvxFDFukZO1Ds1jlwoVx/+6lKPdNezeJM/gNQoz?=
 =?us-ascii?Q?Z3ood/MpWrGn1Wkw3GxMyIghqvEzR5oT6VXHKsoKNlKXzPo6gNO543ZUhNpu?=
 =?us-ascii?Q?Gth1mqvBZ5P4ERsqbDBgd5wuyzdqmNfKoSNz0OoQjGHjqStjuc1h+i37sGqC?=
 =?us-ascii?Q?IoAKS0fOPmMnnbPWywbijgBAJr07jIMh6BSL9nSyQ9PPbaSH08B0J/k2dRhV?=
 =?us-ascii?Q?B27wy7tx7pN22faPsssr9w4Mzq0sZkEQ5NE0MLqW3k30fffM74xaiyyhQfV7?=
 =?us-ascii?Q?S7wqtJZCCjvixya3rAF1kiQRfgOLB1Xy3L2SYq7EnKKAKUVZQ27x/z7CC3aR?=
 =?us-ascii?Q?9IbWMhjMcvZjELKzv/o1tzNQvyK5KnNT7/qhx2WHfc3D2tqozqpMUyRcAG1x?=
 =?us-ascii?Q?PmANeQ/ZpzXt3k0czcWzvjGB1qhFTsVjkwWjTF5rswd7b7ILyhOejU856I6+?=
 =?us-ascii?Q?KwYWN3mv5o0WH7uwe93s+k2nS583mQb0VCCIE0wbGLIKtJSeMk62DQeit5+E?=
 =?us-ascii?Q?ClSqyzld53S+cp4cYvVZR8Gaa4/bwkTe4pPmuTYA9efw9QH8GUmtsam2hdKY?=
 =?us-ascii?Q?9RPc9uAIW5kx/908o+Xjo7UI+XrGvB7wmcN00Q4XWX5TJNlgfOJk2CuP8DTg?=
 =?us-ascii?Q?RZpxBTYdkmzhf9NrAh03Bu/85TDD/i7aVHa6+VTSt0nTmgxZdQmH8dS1ydLM?=
 =?us-ascii?Q?C/PiheLzjsMn2v08K0O+IJ4adtZbOvba8hWb2QQl2GQi+kiALbGkkxj+KK3y?=
 =?us-ascii?Q?pKM2sft2IzAcwB6kXwf0TiHWiviZHlSsw+vtNQ4I+T2mplZf0h/CuSAp6dD9?=
 =?us-ascii?Q?mpomf/8TdvNn4yopTGWRJ2/7S9KJo1qjwhFq/yZp1rAmSN7mVmM3Oakly/6Y?=
 =?us-ascii?Q?D+ScdT3FR0TD0O9QcC4ApIs=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43cd9b3a-bd1e-4e85-b026-08d9dc9dc1bb
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4589.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2022 05:20:37.0727
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PIT5f2AMHJw+wZNMEkdjfmoXqZG1ru01hyqZsaOFZckpaWG/5qGIQZXxPe+7Oea7ws7lNdvDk8BMHbWgEAx3nA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1287
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10233 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=916
 malwarescore=0 adultscore=0 suspectscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201210037
X-Proofpoint-GUID: 9bDhbuEN4skgF54-r8EiWAocmM6TWJdq
X-Proofpoint-ORIG-GUID: 9bDhbuEN4skgF54-r8EiWAocmM6TWJdq
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patchset implements the changes to userspace programs that are
required to support extending inode's data and attr fork extent
counter fields. These changes allow programs in xfsprogs to be able to
create and work with filesystem instances with 64-bit data fork extent
counter and 32-bit attr fork extent counter fields.

The patchset can also be obtained from
https://github.com/chandanr/xfsprogs-dev.git at branch
xfs-incompat-extend-extcnt-v5.

Changelog:
V4 -> V5:
1. Rebase on Darrick's upgrade-older-features branch.
2. Recompute transaction reservation values before checking if
   upgrading an fs to a new feature would succeed.
3. xfs_db: Revert back display names of per-inode extent counter
   fields to nextents and naextents. Use the value from the appropriate
   field of disk inode based on whether the inode has nrext64 feature
   bit set or not.
4. Skip nrext64_pad when printing entire inode.   
5. Report nrext64 support through xfs_db's version command.
6. Update xfs_admin's manual page to show that xfs_admin can try to
   upgrade an fs to nrext64 feature.

V3 -> V4:
1. Rebase patchset on top of Darrick's "xfs: kill XFS_BTREE_MAXLEVELS"
   patchset. 
2. Carve out a 64-bit inode field out of the existing di_pad and
   di_flushiter fields to hold the 64-bit data fork extent counter.
3. Use the existing 32-bit inode data fork extent counter to hold the
   attr fork extent counter.
4. Pass XFS_BULK_IREQ_NREXT64 flag to the bulkstat ioctl if the
   underlying filesystem support for large exent counters is detected
   by the presence of XFS_FSOP_GEOM_FLAGS_NREXT64 bit.

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

Chandan Babu R (19):
  xfsprogs: Move extent count limits to xfs_format.h
  xfsprogs: Introduce xfs_iext_max_nextents() helper
  xfsprogs: Use xfs_extnum_t instead of basic data types
  xfsprogs: Introduce xfs_dfork_nextents() helper
  xfsprogs: Use basic types to define xfs_log_dinode's di_nextents and
    di_anextents
  xfsprogs: Promote xfs_extnum_t and xfs_aextnum_t to 64 and 32-bits
    respectively
  xfsprogs: Introduce XFS_SB_FEAT_INCOMPAT_NREXT64 and associated per-fs
    feature bit
  xfsprogs: Introduce XFS_FSOP_GEOM_FLAGS_NREXT64
  xfsprogs: Introduce XFS_DIFLAG2_NREXT64 and associated helpers
  xfsprogs: Use xfs_rfsblock_t to count maximum blocks that can be used
    by BMBT
  xfsprogs: Introduce macros to represent new maximum extent counts for
    data/attr forks
  xfsprogs: Introduce per-inode 64-bit extent counters
  xfsprogs: Conditionally upgrade existing inodes to use 64-bit extent
    counters
  xfsprogs: Enable bulkstat ioctl to support 64-bit extent counters
  xfsprogs: Add XFS_SB_FEAT_INCOMPAT_NREXT64 to the list of supported
    flags
  xfsprogs: xfs_info: Report NREXT64 feature status
  xfsprogs: Add mkfs option to create filesystem with large extent
    counters
  xfsprogs: Add support for upgrading to NREXT64 feature
  xfsprogs: Define max extent length based on on-disk format definition

Darrick J. Wong (1):
  xfs_repair: check filesystem geometry before allowing upgrades

 db/bmap.c                |   8 +-
 db/btdump.c              |   4 +-
 db/check.c               |  28 +++--
 db/field.c               |   4 -
 db/field.h               |   2 -
 db/frag.c                |   8 +-
 db/inode.c               | 224 ++++++++++++++++++++++++++++++++++++--
 db/metadump.c            |   6 +-
 db/sb.c                  |   2 +
 fsr/xfs_fsr.c            |   4 +-
 include/libxfs.h         |   1 +
 include/xfs_inode.h      |   5 +
 include/xfs_mount.h      |   3 +
 io/bulkstat.c            |   1 +
 libfrog/bulkstat.c       |  29 ++++-
 libfrog/fsgeom.c         |   6 +-
 libxfs/init.c            |  24 ++--
 libxfs/libxfs_api_defs.h |   3 +
 libxfs/xfs_bmap.c        |  77 +++++++------
 libxfs/xfs_bmap_btree.c  |   2 +-
 libxfs/xfs_format.h      |  60 ++++++++--
 libxfs/xfs_fs.h          |  13 ++-
 libxfs/xfs_ialloc.c      |   2 +
 libxfs/xfs_inode_buf.c   |  62 ++++++++---
 libxfs/xfs_inode_fork.c  |  13 ++-
 libxfs/xfs_inode_fork.h  |  59 +++++++++-
 libxfs/xfs_log_format.h  |  22 +++-
 libxfs/xfs_sb.c          |   6 +
 libxfs/xfs_trans_resv.c  |  10 +-
 libxfs/xfs_types.h       |  11 +-
 logprint/log_misc.c      |  20 +++-
 logprint/log_print_all.c |  18 ++-
 man/man8/mkfs.xfs.8.in   |   7 ++
 man/man8/xfs_admin.8     |   7 ++
 mkfs/lts_4.19.conf       |   1 +
 mkfs/lts_5.10.conf       |   1 +
 mkfs/lts_5.15.conf       |   1 +
 mkfs/lts_5.4.conf        |   1 +
 mkfs/xfs_mkfs.c          |  29 ++++-
 repair/attr_repair.c     |   2 +-
 repair/dinode.c          |  95 +++++++++-------
 repair/dinode.h          |   4 +-
 repair/globals.c         |   1 +
 repair/globals.h         |   1 +
 repair/phase2.c          | 230 +++++++++++++++++++++++++++++++++++++--
 repair/phase4.c          |   2 +-
 repair/prefetch.c        |   2 +-
 repair/scan.c            |   6 +-
 repair/xfs_repair.c      |  11 ++
 49 files changed, 925 insertions(+), 213 deletions(-)

-- 
2.30.2

