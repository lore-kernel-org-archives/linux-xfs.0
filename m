Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 555BCC6FA82
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Sep 2022 05:45:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbiIVFpH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Sep 2022 01:45:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbiIVFpG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Sep 2022 01:45:06 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D663F57260
        for <linux-xfs@vger.kernel.org>; Wed, 21 Sep 2022 22:45:04 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28M3DwSa022580
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=PCg43059bb/F0MfwljiRDfwi6I/Hijgr2U2qx17RX/0=;
 b=JFnDwvMrXiRXQTwY564kx04Q5CPAdN+MRgw8VyQl8Ge7EBmdtjRoqtA4qiZonBIyKMuT
 nUObOnbCereYYDAWKr37ONGgxP38Se2SgrIPszfKKBPtVPLvyC3oxUMRYPiHfclE5YOO
 ytzCrI0FnE7b8ktJ2I3nSEr05Q21yUzbz2rwHmACMn+8mQRzZfsVQIkYaTftBtUjZpUB
 u873w0WIKLu3m31KhI5HP6vQuVQAUe0YS6jQ+PVDXo93coDF2oWYWBFov4PogDNQLM8o
 p+DRHl+EwfdYyyi40pmaFUpykFsGx+0TVvuFJanAKok+jscjR01LnAbx+1q/ljZ97i9P vw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn6stmkr9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:04 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28M5Qb98007161
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:03 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jp3cq703h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HWjQNSjuWbvSN/mZCMdDaY3/H+4kYgJOcg33r8tRs/J2WjBqtaMe2HiL8IYMVLgjV78xgEx5qyJ3yLBj/iV6Kd5gKMGDucRGUhumqmMxLsCaEgJoMu0NFkOORgw5XHO6EudJQFhJ7ANg40Db4AajAwugp7+C5oNQrwMncyXtVtlZFUvYnc+H5E7hOQfaqPpxSkis2EXpbDU0bQ0xUs+3i2X3fv9LmV9IFAUyVb7+O8sW+t52yM1L1ylcPuia0qWJvBkFTMyrQ3LfEZfVFY7wxvOssVvgccMuByvrbQg7ZB6nnn+bPA+qNmspe6EzhLnbBewUgW8yTvOvvJejHFd+/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PCg43059bb/F0MfwljiRDfwi6I/Hijgr2U2qx17RX/0=;
 b=kY3KZsqVk4vN3FZhEb7t6EPmd3IElwx+qWS2j6dgJizy4M0jwB5NZQxeLaGWETXyU9c+xfvRL9WCxsbF/9ScU3DY3WV1Ymf8jT0ENDmUdvczFd3FmgdKoLfE9GClUyIEp9YRmNujj2OpYZIcoj8QbatOihfi99T/f5zYwYcm6GvZD5/NOBloCDeebt6Uz2k9gW7KW+rrdjNQq/SD6ecOd1vKBaZ05XBV482RtpEVDWZk1bWE6xUeAJUSFUcoTnvEAwXI6tBON5bmcmp81INK1g6Z/yM2VXYxQQ7DIEQlhZe7Cn23SXR7i/AEpYKlTThMDfa6picZYajM9aYAAr2QlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PCg43059bb/F0MfwljiRDfwi6I/Hijgr2U2qx17RX/0=;
 b=glQjdyxb0K9Qnp4Jm85mF/MRH8NCxSEHM5UCT7wtzupAE3sbW2EnAaZYIpzY6ZG3yAFFKTTHn4aIxdjGJbRTDrFCORuNvv/StEuLYC4HIO7C59HCJT71mnMd192OG34BbT42kh1p7+d68Wc4cv49WMfvbtTABV3XUX/FJp+arhE=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH7PR10MB6627.namprd10.prod.outlook.com (2603:10b6:510:20a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.14; Thu, 22 Sep
 2022 05:45:01 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9%3]) with mapi id 15.20.5654.017; Thu, 22 Sep 2022
 05:45:01 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 00/26] Parent Pointers
Date:   Wed, 21 Sep 2022 22:44:32 -0700
Message-Id: <20220922054458.40826-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0244.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::9) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH7PR10MB6627:EE_
X-MS-Office365-Filtering-Correlation-Id: 31483439-1a09-443f-f36c-08da9c5d9755
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W3bGjHA/PMbsSr/UvAhDEUiTgUjJr5pEa+7liUs+7UHjZqk5hZSMOWENUQKoV1zGRrtTR7FcKkmlhP5xbpsP70TWwz+06r5G+Pzgnrdffy77VcBlcVs4RtWidK6ve6TTFK/Nu1DTEIz19kPz9IaW7beGxIZVYfPt3XCLzzrxpMTlA6wQa3MCnfncCd6vLyFh3FcZidA1AzrtYYRBun+jASLWBb3djFnbnbWcMb5FRiLKBn0VnvemstmyvTFKuNHwP/rfbryWQKX3WVsw7XFYUZxmZJjibQNgXDgvRQ08a/7HHXderuGmLdFavtsQ2nPtvsFvs1+F+LYayvTiSGGINrW0fc+0Pj9CU3Uq/RVOV75dIoajgIjbVBHPp+d1R7iI0DDm6F58K2ZfRKnMmIi7D7Hv/60I2dzjICTy4GfvQ1JC5YzKshV7LFNnRTWLGm9pZ4OJ0jgd29JWjucIcGnBWhla6NJYsN/3VQ4nkAwv4oHPruLHZhOPnm/L0E+DDUkJQlfGdZiqJMCu+0YXW0ZBxg7259AFWWCI+s/xB37+Jj5ViPdqyvujrkMuDJEJrHwR+kGF/cPuQTWvNihXIoSayo0AVEKNa4zRUc6BHllfciyN0Upf6dBx2kw+749EUBtegHAOOwgwFytHBsoaAk7CVMSjzAYxChH7NoDLNx6k/ztN+DKTLxFp6O/joAov88Qkd+FEUjop4dYO1vDY1lcQGta18U3580cyzE/3ohZFCSIeLGl1MLoSDuo8NIucHfMLbqZ5E8c6NxH+t9GbDPJXEw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(136003)(366004)(396003)(376002)(451199015)(316002)(83380400001)(38100700002)(66946007)(36756003)(66476007)(86362001)(2906002)(66556008)(8676002)(966005)(6486002)(478600001)(6512007)(26005)(2616005)(6916009)(186003)(6666004)(1076003)(41300700001)(5660300002)(8936002)(9686003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VjFbWHc87gpKP6LXdaIFNHdKivcB2nKW5b1l+QskJ9CTtDcFWJQg8Z1cVuL0?=
 =?us-ascii?Q?vnGbY68hHUs2F5thrgNB8FCDVyQikMTSMYbiotsfhmyLNsugDZ973maCazQT?=
 =?us-ascii?Q?4FDM70psBAf1Mp7Z+SH42BTlWQBx9EFUGyTH90ygEACvuvYWP5KiGUg7fIig?=
 =?us-ascii?Q?aPwlamM2Nn4HnCw1yp5tx+ps5UcoQfykI6mcrEy8JXibTFcsaczUppeXvedn?=
 =?us-ascii?Q?IFijVLK1FsYJjxeL/Klt3ro1J+WS5UguVK4TCItDLCM4KLtVSc5sOpy3T5qO?=
 =?us-ascii?Q?JrcYt0lJUW0Pr9ztPvHu4ywQfkZRLljUh2ISQeusdCIJjUAsjmxKirlrFtBy?=
 =?us-ascii?Q?T9iiSxmo9Qkx8+xjYbSX53GXcH0DzSrMev+x5LDG17mggeW14gRP7O8SkRdk?=
 =?us-ascii?Q?O4uAtj20rbg/HaynQPPHqdc/Y6KZMIkxgJMpNBczZ7jFCOuF9r6IBCPZjW5j?=
 =?us-ascii?Q?VIUc2t5cRTTwDk4tPRqjH6nrCZTK34jbLRFcVHut1Xs5NcnNtuHZfLRwG5Ke?=
 =?us-ascii?Q?6wDYTBh27oaE5FMmbNcvfLwggg/gEZhbAmmfuw56Eo+c7Hs3nwo5AjbAExFk?=
 =?us-ascii?Q?tQtDEU/E2aF2isVR802B8ZbN3yICFT/ouLxXnqGcw7HUsgUr8F2NEVwhBlQJ?=
 =?us-ascii?Q?GBEQTFW004k9H18+uGGdHUoJLaTWO0xf7OJnc7R8TrpBK/QL0nCzw6PZgTkl?=
 =?us-ascii?Q?z/Qvu5Hl5i0PnaK2FUN0Y2H5N3EhVE5MNe1B/H6bFEL4qHRw/emsHugpyrik?=
 =?us-ascii?Q?OED0JLjDyA9vx38lD2D4ZchwCGdL56OZ21QMSHtsyetgGlTZJMUc9n4aGmeY?=
 =?us-ascii?Q?POCL4dij+0+hpzVtf3lniOsWyKRAIValPv341SKmssMqH9ph+3O2Fkxjw6VJ?=
 =?us-ascii?Q?wA30zQPd1vzWsMxBK3zCktUDKKpSAc++6Q01Tm6nyXyVxX5crsw7DzSMTdC9?=
 =?us-ascii?Q?Er/F9JqAMKW0+Q48qigS8B9atMiyPZ5sfxTTR9JQ9bV9jv3fUFZlN2uAqxJP?=
 =?us-ascii?Q?z/1DNsupdi63RQVI/YtQnqbZRhmgY+SxkhN+KnjQq2lJRoLt7PKtaWhMwY9g?=
 =?us-ascii?Q?srdqgBspMTt98D71iVpwS/hK0M8MN4Qncd4ci7DrajR27dE7ukbXHmZqF4qL?=
 =?us-ascii?Q?cJ8yU+FD92bdhyGn9KfafYeMRODnPKLuqzbsT6539aGij61GdTlNpIhCVU4O?=
 =?us-ascii?Q?IyIbgs/dBtyXdZwIL320d7Aa0wfHR3+bgUEe+XpQtPTjLD7K2KWvNfvD3vDu?=
 =?us-ascii?Q?j5zsZCLEj94dveB+vZxMG8nYMq9wod5qrYN6KHocn1SM2zper6Y4zWBm8VoX?=
 =?us-ascii?Q?5l/xkLF0eAeUa3oL+FtdjquZ/YyOSTgxwrqCc+05FU/RzSFxG59+lyKhV+OS?=
 =?us-ascii?Q?Ekky4kKC3jdFksG2Snv8pVbyjNIkinySQYE0ELML0WRJUySjjCmHWYPDtg5f?=
 =?us-ascii?Q?9wRyyse/IlMMu+71A//e86J/vaHqcbyCVGhPgsIEzksuhBEzwSCBoTUZrTkn?=
 =?us-ascii?Q?w8T5AhB2+BLDK/N2q9A3bYAUw8GUeOhM90TlNamkDAMe52B8ivYbH/6G030O?=
 =?us-ascii?Q?1DF+jl59kNjlVr/fFH4QiKatLs5ucZD6JkUZdV/oEs1fbGEg4iD14mOkCiZR?=
 =?us-ascii?Q?kw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31483439-1a09-443f-f36c-08da9c5d9755
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 05:45:01.2480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JqQuZUqA/1XabYNMyUGDnGoNSi2AqGsgKamllNncddubYMd3j6Y5mM57aWh/1xcdi0eYrhsddnxCinkY3EdZkJoIdzBYjFHsVY/dUfpJHeU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6627
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_02,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 spamscore=0 adultscore=0 mlxscore=0 malwarescore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209220037
X-Proofpoint-GUID: PGQKpdgfFuVNWH1krZkWmJ5Mvni-Lh1-
X-Proofpoint-ORIG-GUID: PGQKpdgfFuVNWH1krZkWmJ5Mvni-Lh1-
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Hi all,

This is the latest parent pointer attributes for xfs.
The goal of this patch set is to add a parent pointer attribute to each inode.
The attribute name containing the parent inode, generation, and directory
offset, while the  attribute value contains the file name.  This feature will
enable future optimizations for online scrub, or any other feature that could
make use of quickly deriving an inodes path from  the mount point.  

This set can be viewed on github here
https://github.com/allisonhenderson/xfs/tree/xfs_new_pptrsv3_rebase4

And the corresponding xfsprogs code is here
https://github.com/allisonhenderson/xfsprogs/tree/xfsprogs_new_pptrs_v3_rebase3

This set has been tested with the below parent pointers tests
https://www.spinics.net/lists/fstests/msg19963.html


Updates since v2:

xfs: Hold inode locks in xfs_rename
  NEW

xfs: Expose init_xattrs in xfs_create_tmpfile
  NEW
  
xfs: Add parent pointers to xfs_cross_rename
  NEW
  
xfs: Indent xfs_rename
  NEW
  
xfs: Add parent pointers to rename
  Added parent pointers for WIP

xfs: Add xfs_verify_pptr
   Fixed indentaion in xfs_verify_pptr
   Updates for new name field

xfs: extend transaction reservations for parent attributes
   Moved/removed stale comments in xfs_calc_parent_ptr_reservations and  xfs_calc_namespace_reservations
   Reduced resp->tr_rename.tr_logres in xfs_calc_parent_ptr_reservations since logged attrs can separate transaction updates
   Updated inode reservation in xfs_calc_rename_reservation

xfs: parent pointer attribute creation
   Moved target id and name parameters from xfs_parent_init to xfs_parent_defer_add

xfs: add parent attributes to link
   Rebase updates to xfs_parent_init and xfs_parent_defer_add
  
xfs: remove parent pointers in unlink
    Rebase updates xfs_parent_init and xfs_parent_defer_remove.
    Renamed ip to dp in xfs_parent_defer_remove
    Simplified xfs_has_parent check in xfs_remove

xfs: Add parent pointers to rename
  Rebase updates to xfs_parent_init, xfs_parent_defer_remove and
     xfs_parent_defer_replace

xfs: Add parent pointers to symlink
   NEW

xfs: Filter XFS_ATTR_PARENT for get_fattr
   NEW

xfs: Add parent pointer ioctl
   Added new XFS_PPTR_FLAG_ALL
   Removed namelen from xfs_parent_ptr.  Added rsvd
   Renamed XFS_IOC_GETPPOINTER to XFS_IOC_GETPARENT
   Added const qualifier to xfs_init_parent
   Added XFS_IOC_ATTR_PARENT check in xfs_attrmulti_attr_set and
      xfs_ioc_attrmulti_one
   Updated SDX headers

   In xfs_ioc_get_parent_pointer:
     Updated kmem_alloc to kmalloc 
     Updated return codes for copy to/from user to -EFAULT
     Updated XFS_PPTR_OFLAG_* handling
     Removed GFP_NOFS | __GFP_NOFAIL from realloc

   In xfs_attr_get_parent_pointer:
     Fixed indentation
     Updated error returns to -EFSCORRUPTED
     Changed xfs_ilock to xfs_ilock_attr_map_shared
     Added inode checking

xfs: drop compatibility minimum log size computations for reflink
   NEW
xfs: Filter XFS_ATTR_PARENT for get_fattr
   NEW

Investigated removeing memset in xfs_attr_get_parent_pointer
  Trips assertion for non-zeroed context
   XFS: Assertion failed: !context->seen_enough, file: fs/xfs/xfs_ioctl.c, line: 317

Questions comments and feedback appreciated!

Thanks all!
Allison

Allison Henderson (26):
  xfs: Add new name to attri/d
  xfs: Increase XFS_DEFER_OPS_NR_INODES to 5
  xfs: Hold inode locks in xfs_ialloc
  xfs: Hold inode locks in xfs_trans_alloc_dir
  xfs: Hold inode locks in xfs_rename
  xfs: Expose init_xattrs in xfs_create_tmpfile
  xfs: get directory offset when adding directory name
  xfs: get directory offset when removing directory name
  xfs: get directory offset when replacing a directory name
  xfs: add parent pointer support to attribute code
  xfs: define parent pointer xattr format
  xfs: Add xfs_verify_pptr
  xfs: extend transaction reservations for parent attributes
  xfs: parent pointer attribute creation
  xfs: add parent attributes to link
  xfs: add parent attributes to symlink
  xfs: remove parent pointers in unlink
  xfs: Add parent pointers to xfs_cross_rename
  xfs: Indent xfs_rename
  xfs: Add parent pointers to rename
  xfs: Add the parent pointer support to the  superblock version 5.
  xfs: Add helper function xfs_attr_list_context_init
  xfs: Filter XFS_ATTR_PARENT for getfattr
  xfs: Add parent pointer ioctl
  xfs: fix unit conversion error in xfs_log_calc_max_attrsetm_res
  xfs: drop compatibility minimum log size computations for reflink

 fs/xfs/Makefile                |   2 +
 fs/xfs/libxfs/xfs_attr.c       |  71 ++++++-
 fs/xfs/libxfs/xfs_attr.h       |  13 +-
 fs/xfs/libxfs/xfs_da_btree.h   |   3 +
 fs/xfs/libxfs/xfs_da_format.h  |  33 ++-
 fs/xfs/libxfs/xfs_defer.c      |  28 ++-
 fs/xfs/libxfs/xfs_defer.h      |   8 +-
 fs/xfs/libxfs/xfs_dir2.c       |  21 +-
 fs/xfs/libxfs/xfs_dir2.h       |   7 +-
 fs/xfs/libxfs/xfs_dir2_block.c |   9 +-
 fs/xfs/libxfs/xfs_dir2_leaf.c  |   8 +-
 fs/xfs/libxfs/xfs_dir2_node.c  |   8 +-
 fs/xfs/libxfs/xfs_dir2_sf.c    |   6 +
 fs/xfs/libxfs/xfs_format.h     |   4 +-
 fs/xfs/libxfs/xfs_fs.h         |  60 ++++++
 fs/xfs/libxfs/xfs_log_format.h |   7 +-
 fs/xfs/libxfs/xfs_log_rlimit.c |  53 +++++
 fs/xfs/libxfs/xfs_parent.c     | 193 +++++++++++++++++
 fs/xfs/libxfs/xfs_parent.h     |  45 ++++
 fs/xfs/libxfs/xfs_sb.c         |   4 +
 fs/xfs/libxfs/xfs_trans_resv.c | 135 +++++++++---
 fs/xfs/scrub/attr.c            |   2 +-
 fs/xfs/xfs_attr_item.c         | 115 ++++++++--
 fs/xfs/xfs_attr_item.h         |   1 +
 fs/xfs/xfs_attr_list.c         |  64 ++++--
 fs/xfs/xfs_file.c              |   1 +
 fs/xfs/xfs_inode.c             | 374 +++++++++++++++++++++++++--------
 fs/xfs/xfs_inode.h             |   3 +-
 fs/xfs/xfs_ioctl.c             | 160 ++++++++++++--
 fs/xfs/xfs_ioctl.h             |   2 +
 fs/xfs/xfs_iops.c              |   3 +-
 fs/xfs/xfs_ondisk.h            |   4 +
 fs/xfs/xfs_parent_utils.c      | 126 +++++++++++
 fs/xfs/xfs_parent_utils.h      |  11 +
 fs/xfs/xfs_qm.c                |   4 +-
 fs/xfs/xfs_super.c             |   4 +
 fs/xfs/xfs_symlink.c           |  35 ++-
 fs/xfs/xfs_trans.c             |   6 +-
 fs/xfs/xfs_xattr.c             |   2 +-
 fs/xfs/xfs_xattr.h             |   1 +
 40 files changed, 1427 insertions(+), 209 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_parent.c
 create mode 100644 fs/xfs/libxfs/xfs_parent.h
 create mode 100644 fs/xfs/xfs_parent_utils.c
 create mode 100644 fs/xfs/xfs_parent_utils.h

-- 
2.25.1

