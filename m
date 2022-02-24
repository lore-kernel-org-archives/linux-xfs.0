Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13B36C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Feb 2022 13:04:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234751AbiBXNEp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Feb 2022 08:04:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234748AbiBXNEn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Feb 2022 08:04:43 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F062253BCB
        for <linux-xfs@vger.kernel.org>; Thu, 24 Feb 2022 05:04:12 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21OCYST8023288;
        Thu, 24 Feb 2022 13:04:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=bPksiD/kyap1NtxXrZIVk2IijS/xaCGG1A76p4Aoif8=;
 b=a8qJ5EPsXIy2BHA8zSmXQxh3DRuqdPRvq7iFor7/tAGiTEZrxrkEA7tCtQmQq5aCVm9n
 rapZofvdsa8w4eN3JsjcFI13VGqngqDjENsjfBXhMd9l8ZwzEJpW1UtmB6z7JxvFLNRo
 bcnomzVdXM24fMJ1DiEUwd7Lh5LDTZZaI68Elr5rTySYps7dmhGewgKx8U6NFpnIYho6
 mw8+BCJkb7ToUgrhxE4FSV7AQ2LjNZrw8qGJamGz4tC57vO1bcFV+/EoEY9bKqOvYvgO
 hlB+oWCU6O4Ndsek9D/2hy2ss6+xib6gZM/y70YFcSK5+NqTg3GHT7uZIbvx9PwvG4c8 cg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ecxfaxmjb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:04:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21OD0tAF169447;
        Thu, 24 Feb 2022 13:03:58 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by userp3020.oracle.com with ESMTP id 3eat0qs3u4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:03:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uli1rxvWAICxdmM5GrfJ8zurUkUUONDzKCqb7Ec4Wcuc+04N+fJiBLed6lBVlwclJDKwF69Rl6QmxL5PN3Y04yODyb8AYHMdGw2FA2C6rs6sxM2psAuuDEORKEo5tw8F2wKRTtV8kK7ss72+2wTftjUF38L9dHyw6+9ZUWsHVuYKAF79E1xC2jtYZJEK8hyUwNO76EYkYz347A785HRfewwaC61zNXsEK3bxTIyJ/96F2GJPXroHPvCrWrLgOelZELCcAxr6Y+8ytSuDUYEtV4C5d/wiaRFVAHgPhv2tzTqXPEwWb+gAlUT4gooe/Z2AV0cWRfSAcnDW5mlOCpy1mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bPksiD/kyap1NtxXrZIVk2IijS/xaCGG1A76p4Aoif8=;
 b=SJESkToBXCFQECm96pfE0WF5ZlPDaeJJ7n3Rz/ssVy5FwZlO/xbA/pWJS2j2SSywCG+Pvsa4wo7lSfl4IrrDtlJjn98T1I91nFvDSo7TYnMETfjFQgaE++VFNTmZF9gwCroERfi80PMhzkQnHvgSL3kuauTbgnvfawEHtYDa0UnppzHDqULp9AIKahriqg1sH+2kONnHiiXpRR6FiIqAZzKLrxuVMOE5lRCJPLeHQrwtiH8HUxGDtKDu8KXQFgIjalzX/+XP5eKkZ3d3tBG8UADDC9sHU+8PjBNY74yXKStSqNGfxWDXar5fp8eSoiPGD3tVSfq7QrQ/6YXryxK60Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bPksiD/kyap1NtxXrZIVk2IijS/xaCGG1A76p4Aoif8=;
 b=yRT8VaSpM+0DSGWj5Ank3R31wftxyDroSYXR5gB036D4wJhc9BJmJNow0HsoqRBBcqsuEJiS1xpBXpUySY81F/ZMUVw69y+473nH+jZ0amIcwse6XrU02pHaj6HjBN7naWXW0P0hmYg3UPFfoDlbGqLs35njen8hMAvIJXjV1Gw=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4634.namprd10.prod.outlook.com (2603:10b6:806:114::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Thu, 24 Feb
 2022 13:03:56 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%7]) with mapi id 15.20.5017.024; Thu, 24 Feb 2022
 13:03:56 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V6 00/19] xfsprogs: Extend per-inode extent counters
Date:   Thu, 24 Feb 2022 18:33:21 +0530
Message-Id: <20220224130340.1349556-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR04CA0013.apcprd04.prod.outlook.com
 (2603:1096:4:197::6) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7eae9590-3e9b-4302-d9b8-08d9f7961d35
X-MS-TrafficTypeDiagnostic: SA2PR10MB4634:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB46347F654F1466841EEC2010F63D9@SA2PR10MB4634.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bgkNpNnbIG/YIiAE6B/Kzxz3teWDAVbs55CFQ74v6HukJIwjqmj8vplasYgCKfLnEe8hI3GIvE0ecyHCx78SVGcMjVyXGqeuyMRjV/eE5tfP3jf5PmQutsP/XI0HD5nwqCo19a9Jvaov1cYha/4l8FIaGeNr5H/MAqOBqxd4ikrgZWOLhWqV/Nw7dg/ANVqwKCFYaWfrsRvExidO8tdjTgQAvmYoKq/TwEI37MxSl5vmxL3kJ7P36eynP9OrBf2hD7Vzgwzg9mt/3IKWVvviygAkBnP1qsutLQsO5D4Jy+jfVnCE+Ak3d7qlDm/yLkZVTH0XBOFZ41kQsi5AjYD2lbtm8EqLqpl+bq15vXxLd/4LUwLrRfEFt1wjFD1AwE9RTKpZH2aIR5z40B6JFQb5xO8xpvDC3DorICeTSETgA2Q2iylWEQCn7hO+Q8i9yFLYbluV9/TaUc7gqcdxG1vTDkWEPAufUDSxFwFLU+sELo8CjdF5ZJPYBTl4l9pK7XqQWIIFmR+s3jq8QWaEcCWkG7veZSte+CBm+d8KmFXd5cwjAmlqqK41N03CJ9yJRZdReJXhrwllFy3UFC7VJtbrFMg6wte9CHemrG1AN+D29Y5uxi1D+BbWj5p6FNoVoykgFYGHoT/6mOlz55UGaE/yuEyoON8vZj5q8A44zZS4XRhTGmzJ/sirrNMucARiXgSO9JKvfX6WKANTWzqjWa9oDanGMmel6ciXpQ/+sJ8pOyksH05oZIgVgPP7NwzVhbPglebTxex9fGtFHcqa4Ot72OdvV3LdGN5CmlE/shvBzYk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(66556008)(6666004)(38100700002)(38350700002)(508600001)(966005)(6486002)(66946007)(8676002)(4326008)(86362001)(66476007)(6916009)(1076003)(316002)(8936002)(36756003)(5660300002)(83380400001)(2616005)(186003)(26005)(6506007)(6512007)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Cmopxkyu/15IOuQLaOT6i9PFBFEeIQHXhWb5E5UCaOYjZN35hYKukntKfOMi?=
 =?us-ascii?Q?5CuzKpBMzP12i6FAzS7H5kt7zNnOerFYVp7AkL236W1yGoVbkhCWzru1i2jk?=
 =?us-ascii?Q?xdGdg5SWaEh+9eA1wNEU3iEGMcHEc0EblOvA7cTx48HXytanjG58pY1fI8BH?=
 =?us-ascii?Q?oU/+YRBW40NkQNpd2nMDzHXiILDo+Jkfl6VMKIeykaqt/TKToYDh6DUecDSY?=
 =?us-ascii?Q?BvT5APPxdd9ux+xS3wT0VLI7Kft3m1nfbINGtrV2B5sCkhTzdDq6huhMrVaQ?=
 =?us-ascii?Q?HJY4S6aWgqyOIRyBC5Kqq5fOydRm0UpMGbJhf+flMX1BMF2/LVi4ZneFSzhF?=
 =?us-ascii?Q?n6QyEDGqrSPs/oRADHZVYZsCuJM9RrHNklHNOFSFUfzyb2ZcWsXlC8vm+1pw?=
 =?us-ascii?Q?/0576WihU8uRnSQzvNbxThCd1iO5WOfeAQmkEn+s89oT9JlbE57owemZs1oP?=
 =?us-ascii?Q?MX06BtspHYKntiZb+WV97KwUCpm1MYYxLSzGRM8t6VpJh1s0M5zYsNrWVvNV?=
 =?us-ascii?Q?nPDzjdTxbCAzlT0fSyk/WzeiigWTJ3piTQiRbQ1NBiMxh7F6lIMilLBt8WBw?=
 =?us-ascii?Q?G19180+03YLztm7bCkpAZsRaaWR6d+gwdfqLdg6Oih6amWjybc9jmG0gG4jH?=
 =?us-ascii?Q?qwunFXBWyv8rJ65PngkYIsnBEhyWgYYjcy6DQlOFNrjis1FkZ1hsOobHtQ++?=
 =?us-ascii?Q?8OSE70YoDXt/+MaHldjt3hToH0sqsURY712YBgzozVcOPHzbN0Cr2UE2muS8?=
 =?us-ascii?Q?rmANWSi6DT6tzUkPFjGGsrp1cnrSAuTpqMBoKcTFDrNMBri1l3+euG9p7aTo?=
 =?us-ascii?Q?jVV5TODHsmygbjC+65uErlaAwM1Tgb2FHBXt6SaQiZJwlpYhdrdAnqWDCLTw?=
 =?us-ascii?Q?5vRlG6NwBlE+okZhRdoqXQ6jujLk8rwuHGcjzlJ1vmpI9VbmVTQgIMTh4vm9?=
 =?us-ascii?Q?/nhYmuxbKq039aLxRqSfW5MQmppFtnoXIpjVVTwGEEjTQeTFJbiTkslm0BhZ?=
 =?us-ascii?Q?vhDSovPZApb82ETVZ8KOA8DYdIChgc7Qq+VOniqW6yByckXhyWP4ATQMBdfM?=
 =?us-ascii?Q?AwrbP0imHBsZKdFoYsKzNh+jJ2AGPDX2A3LkVFVp3TqYVzi74+z/hYp7Jcj+?=
 =?us-ascii?Q?IXlYa9WA4GvwytwyL8ZkCeto+pMiTzm61i8d7kuI2/oGon9ti0VJngBHbd5Z?=
 =?us-ascii?Q?xnE4vzKDIxQKA8UgKzMLslkPkc/WNY1nzqzz5hO+FrCda6hD/Nbky/YiVFem?=
 =?us-ascii?Q?xRBZ1b60rUUHSSY+jCVzDE514zAs/7Nsitv93WYAg3cJd8yqxZ5uTvgx4P8A?=
 =?us-ascii?Q?WZmYC6Enr3HMtYQh3Fc7bHR2/n0toQjdUsGbd2FzKZeSPRGY3xkbe7jBAOnS?=
 =?us-ascii?Q?xcMhZp0Fn64Imepjl8t9RR5Gz5Ucun/EzgCpOXejsxQx4wPFEQizYgjaiQi2?=
 =?us-ascii?Q?/a4WsrhdVgVf9z571UhWqdMOyicEJYo6Jk3NDQryM8UoBrsfQJ7mxMfZwCM5?=
 =?us-ascii?Q?/DXHf0s+77h3Gtwk3lAZ8KmCrUT9r/pTBnTkyOGLcdlPRT6aziJE/CyKBMEb?=
 =?us-ascii?Q?xDIEa2iEbr9G3ZQZcDICBbypHBlAbpaJ14N4lr8CGFW7odG4fYEaBEe6Ps4H?=
 =?us-ascii?Q?qu85Oqhdz7fOaDbaUlkxT+Q=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7eae9590-3e9b-4302-d9b8-08d9f7961d35
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 13:03:55.9515
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Co70cICTXXndj9Xu2InBBuoXuEIZYqgF/v8/h1Lf6KeNT7yRZoTXJew8b/PVB5S9mTdPKV+YftGywtTSBC63rw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4634
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10267 signatures=681306
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202240078
X-Proofpoint-GUID: u33h2jN8FCmGC9Z4C_LdiwYMcpgTSYft
X-Proofpoint-ORIG-GUID: u33h2jN8FCmGC9Z4C_LdiwYMcpgTSYft
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
xfs-incompat-extend-extcnt-v6.

Changelog:
V5 -> V6:
1. Sync changes made to files under libxfs/.
2. Apply trivial changes suggested during review of V5 patchset.

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

Chandan Babu R (18):
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
  xfsprogs: Enable bulkstat ioctl to support 64-bit extent counters
  xfsprogs: Add XFS_SB_FEAT_INCOMPAT_NREXT64 to the list of supported
    flags
  xfsprogs: xfs_info: Report NREXT64 feature status
  mkfs: add option to create filesystem with large extent counters
  xfsprogs: Add support for upgrading to NREXT64 feature
  xfsprogs: Define max extent length based on on-disk format definition

Darrick J. Wong (1):
  xfs_repair: check filesystem geometry before allowing upgrades

 db/bmap.c                     |   8 +-
 db/btdump.c                   |   4 +-
 db/check.c                    |  28 +++--
 db/field.c                    |   4 -
 db/field.h                    |   2 -
 db/frag.c                     |   8 +-
 db/inode.c                    | 224 +++++++++++++++++++++++++++++++--
 db/metadump.c                 |   6 +-
 db/sb.c                       |   2 +
 fsr/xfs_fsr.c                 |   4 +-
 include/libxfs.h              |   1 +
 include/xfs_inode.h           |   5 +
 include/xfs_mount.h           |   3 +
 io/bulkstat.c                 |   1 +
 libfrog/bulkstat.c            |  29 ++++-
 libfrog/fsgeom.c              |   6 +-
 libxfs/init.c                 |  24 ++--
 libxfs/libxfs_api_defs.h      |   3 +
 libxfs/xfs_bmap.c             |  77 ++++++------
 libxfs/xfs_bmap_btree.c       |   2 +-
 libxfs/xfs_format.h           |  71 +++++++++--
 libxfs/xfs_fs.h               |  21 +++-
 libxfs/xfs_ialloc.c           |   2 +
 libxfs/xfs_inode_buf.c        |  78 +++++++++---
 libxfs/xfs_inode_fork.c       |  13 +-
 libxfs/xfs_inode_fork.h       |  59 ++++++++-
 libxfs/xfs_log_format.h       |  33 ++++-
 libxfs/xfs_sb.c               |   6 +
 libxfs/xfs_trans_resv.c       |  10 +-
 libxfs/xfs_types.h            |  11 +-
 logprint/log_misc.c           |  20 ++-
 logprint/log_print_all.c      |  18 ++-
 man/man2/ioctl_xfs_bulkstat.2 |  11 +-
 man/man8/mkfs.xfs.8.in        |   7 ++
 man/man8/xfs_admin.8          |   7 ++
 mkfs/lts_4.19.conf            |   1 +
 mkfs/lts_5.10.conf            |   1 +
 mkfs/lts_5.15.conf            |   1 +
 mkfs/lts_5.4.conf             |   1 +
 mkfs/xfs_mkfs.c               |  29 ++++-
 repair/attr_repair.c          |   2 +-
 repair/dinode.c               |  95 ++++++++------
 repair/dinode.h               |   4 +-
 repair/globals.c              |   1 +
 repair/globals.h              |   1 +
 repair/phase2.c               | 230 ++++++++++++++++++++++++++++++++--
 repair/phase4.c               |   2 +-
 repair/prefetch.c             |   2 +-
 repair/scan.c                 |   6 +-
 repair/xfs_repair.c           |  11 ++
 50 files changed, 981 insertions(+), 214 deletions(-)

-- 
2.30.2

