Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C97ABC433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:45:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FB7464EB3
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:45:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232409AbhBRSoz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 13:44:55 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:60362 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231537AbhBRQq3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 11:46:29 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGVsHV060594
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=M7UDffSieqXwtLTNPcCI0BD47cs1QUj044aJ5M3HE5w=;
 b=QYhPuI5x6WPufvOfQjEYx5gNK9qbEFjLotj2nBaKtuRSLUi3B39ZURzV2GMpKBa+tb2V
 hyOlPKVNEi0NOGS8C3/iWx6ekoeXxheAgQFp2Ut+NwmM+LtjLUhYckv5qndj+3SY1UPq
 c/uzY1L4rEL0nQv/ZI01E0zZNyPpxu5ReDWvRj9kIE2PC4AGpc62000EJxJSfk8FnYSq
 wt8SsnbpRaKDTgUjFXuyAKBDr6HluMPp3BzHG87IiSLM2gECIk1YuTXEgmXyaiunqVhv
 SMGeagvtpXzPaYcNbMaMq00Y+64kI9zKlopFw2U+ZDc+VnFi6q3jPsCs5lMQQ797hQBH lA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 36p49bersc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGUHT3067740
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:31 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by aserp3020.oracle.com with ESMTP id 36prp1rjuh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iVfnZPCjQab7Vi4XShF67Ubs0C3FS6zLLWFKKaePKRQqaEoyF/550DW8IjiMfTzHZ0GP8g/Bnih24beJHQWhB2etpoRQyKM3vn7skck1+mELXSdghuza1Dj2B6tbH6ZlhPWdLpMcQVp9hXkZkMVYh9c/TaLwIpmzPhJuPVMNvVNSW3i6DNTnWhkU5Uk4+CPWSMFjgCBsYtxiA06abEq9D9bCv/BlYhSkf8K/xEW5amMFRLqi7Al2DG/Pl7+ZXqw6YqS70AoJklq4RmMKd1d6rsXQLGb1wzoJhoyfmS7bllGZM9MyzF75doL63xnJh0bge7MuKyjyx+TN3dfYair25A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M7UDffSieqXwtLTNPcCI0BD47cs1QUj044aJ5M3HE5w=;
 b=iyaj4EQn6KeydBdAbhTFWuQF05AZmDk3mpd+8JbDfB1ElOKVv2UTeRRwjtP/NVthSYtsmpEqNyXywKd49SsdBmHC701oICQJMes7y5FGOTXhCOFRQQDhn3vlKSSdkBRNeOAk0SENDD4OGAEFWm1EgpWz6tlSUx4dMgEivKSogq5lzHVB8mausmp1SPyRKM0H4lrdXN/y/+WZ1LU6VNPH0XDrmourXuaTurN5VehJ+sc6LjPDQmQ8vrR10V+SV8Z4bPajmk89hpHl2+kcumk86mWo2/sI5wtZfw7U7bAjbbj7x7ahXmK9KfvuRBT/cdR6aEnjHIv/gZcBpLqu7seRrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M7UDffSieqXwtLTNPcCI0BD47cs1QUj044aJ5M3HE5w=;
 b=ODpgxjoylUF+exjl7TfrebUn5k9biYUZj73rQg0KrhVNRZeuLGM/hg6qb2lP2U9sHgVAlmSrXyjYTyZonDWI4D9IbVfaBWEtMrl/P/9oOlLl9XpPtlOLfZy0jxFPknhUQfLHPwEVKptEI9W39q7yV7zWJfQ+LgkJjZZ/HkMWhBk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3461.namprd10.prod.outlook.com (2603:10b6:a03:11e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Thu, 18 Feb
 2021 16:45:29 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 16:45:29 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v15 00/37] xfsprogs: Delayed Attributes
Date:   Thu, 18 Feb 2021 09:44:35 -0700
Message-Id: <20210218164512.4659-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BYAPR11CA0088.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::29) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.223.248) by BYAPR11CA0088.namprd11.prod.outlook.com (2603:10b6:a03:f4::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 16:45:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 79e99f3c-ecad-4837-517c-08d8d42c99b4
X-MS-TrafficTypeDiagnostic: BYAPR10MB3461:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3461F50E5AB353A37B19C21795859@BYAPR10MB3461.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mQd6UqjI+p64E+4i8od7bKhsP/KKkqInZQf4W/8hBeTy1qb9UoJcko/lB2YDJyOhM4OuoqIulvhSIe9KRPUdtKC0gajPJKLq5ymJnmAxSqOu+kg6E5M1wwgqFFyU/aIsFvBA9GlDnTZlJObptE1Ny1DoNJMPV8xQPdx/yAen2G3EWa4q5KCAZu6xeRidJHcXVGtJtlp8trA5WrISizIgsJ5qUeMJFvPyGIw5gVVULhbmza1SgzQ3n2wKwvXNyrgKz+850Jxrwo30aPJvRpabPJT9yocC2E8sT5mA4Yl2/wVkmRkC5rH+f0hNTQLwLsxpOVNNmvWABjz0f4t6IhSthLrkq1HLSKd9WTK1EvZq0ok/DTIg8Nr8QprlQXG0XDem1znQYIQ55zlAmOxwE4Gcy01ktgJgDLsFqf4dp6svJRu5HSncZsONdI8eFC6QPIoYLsxhrSVc01P5EYHj5flUDchdw6Igr3w52fNFYflCHPI/hLxM3x0zVB7mutSk++SrpKBqFyO751ShLaJ22mEXfKRXs81pBT4+SXAwX73iVgEStsy9l6ZriirMyJ+lnCYogjb14evMJ1vhrxsx20Tse/Vb7lu2P7PaiKTQos2SMe2HFcuZALg2XgG/OCbO2/bUqm+SBlUPPIoEe3Wb1gI2eQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(396003)(376002)(136003)(39860400002)(966005)(8936002)(66476007)(1076003)(69590400012)(6666004)(66556008)(2906002)(86362001)(316002)(26005)(6486002)(52116002)(16526019)(8676002)(6512007)(186003)(36756003)(5660300002)(83380400001)(956004)(2616005)(6916009)(66946007)(44832011)(6506007)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?1B2pZdRftvyKwpDZyPrzIP3NglgucTVZHE6Foxn6obW7yF6Cl8OvgXa9nGLR?=
 =?us-ascii?Q?jsU7lBb0KbUc05OHlj5nQWIE5QqGFZODsrpq4brfZuqoqwMGktL6bEl9XC6G?=
 =?us-ascii?Q?U27H9nZ8u6BZwcZRFJnWJyZnsrC2MrLUW7YgCx/J9GeEpC7PTbRzelf6aA7O?=
 =?us-ascii?Q?ocWr4kY2JU0x7SYZbb3Sbv88jucYbEoQfVFfjviyclCpDNBgaPp2f4s6lF1X?=
 =?us-ascii?Q?HUFTqPKLkllf8aF936bJ+qEF/T7cpOdoA8z+PrvlolQ79I2l8RhLzRt5++Jh?=
 =?us-ascii?Q?LWbSqrbUnFvkQPeuU7Ph1ahDspjtCD1xvpB91yQq2kMviDnd0emSB5nrrNtL?=
 =?us-ascii?Q?bN5pHC1hV49JOLfmh4NtbsP+qwzoE958Svrc6TteEBlfebYg+EiLCdKHXCbq?=
 =?us-ascii?Q?AgcH5t4d8/yC2xWagfTuf7XOcXujCUukDi175Dz+f3YMTgayQonW8AL6epdS?=
 =?us-ascii?Q?oVdAz8EIzp0c3xagIrOFwq9CyTKDnUiFl0czzAuofwp6nbL5BzxR0vWT6noQ?=
 =?us-ascii?Q?ZVfUuBJIi+WvdkGToJhE6VrBhPuTkEB417ibJGl3r2pL7ifW6MGaTs7l2TT+?=
 =?us-ascii?Q?Zy7QZ12Qw6oY9ycR+kAmTmDWTvm/bUvofV+m92VtfLm32Oero4DgOsyNInFA?=
 =?us-ascii?Q?UiksBn4rIVq4Uq5zwZ3+egXAjNEzoUBdrNDAVSAWvaLiIJEwTvsE7fk/Pt2I?=
 =?us-ascii?Q?kxX8yniY4sH7UTWh3dKqBK1lSAdgpWcMJwOIdOTFa3i3UNB1EbQEPywExGQS?=
 =?us-ascii?Q?gqlrSySH6NEZEItFz8T1G/OnvbCSIp17Qucpo55laCxnXQ2yiDV3LPV5jDnR?=
 =?us-ascii?Q?BP1HQDedCsGlnxsA1lKTRPZpF+aS+dBD7RI/0l/OOWU9jBCAdNLWggmc3SWs?=
 =?us-ascii?Q?FofBjb508T0kFiA6afTS/1GZ07d2jVVApsrRQbmw1Ci/dUQCgpmP/S1fqNF4?=
 =?us-ascii?Q?A8dNkey5Fveva70lVN1CrQlLv5hHWZjRVwJXpbwXt+Oy9zAtPPR0TTYtS3Tc?=
 =?us-ascii?Q?WOLmXxr+iHOON9uVXAxygZ9t1+mcgDanH7/TpjV1/a8x+YFDhdoC8DSMYLnS?=
 =?us-ascii?Q?gdYkMUg9Dw6qg5jxArDcDusAPFx6w6nReQEv48AUiHmzHL5rnSQW19HPwJNj?=
 =?us-ascii?Q?DecGIpGp2esaIywdYEiDovvA5dJG5XyR5AaUwD4RjQgVw8dTEsfQEyfDR2T7?=
 =?us-ascii?Q?535EKoobAVDVbI3Sb024dbulFwOeYhOOY0KEwWpcsfk2tZ3IfGCQ4ApMoJp3?=
 =?us-ascii?Q?z7GSQqZhQRVBkneBoHZf8KB0gHXHd0Qs/A6c0uyqgP7eN71rWL295+6cvnPa?=
 =?us-ascii?Q?3kySeLnR5ReZ3fumneSew7GV?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79e99f3c-ecad-4837-517c-08d8d42c99b4
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 16:45:29.6719
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lnpaPuDcPpb3KCTTFptoV5mPTraLzrgn62UcUGvnKcfc3OpP9NbD16ly0am/B2nVi9sZtOgk/Y1S5mPUaT7KWfgL0z/o5FFeAA2BPdzBzNA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3461
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180141
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 impostorscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 phishscore=0 clxscore=1015 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180141
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This set applies the corresponding changes for delayed attributes to
xfsprogs. I will pick up the reviews from the kernel side series and mirror
them here.  This set also includes some patches from the kernel side that have
not yet been ported. This set also includes patches needed for the user space
cli and log printing routines

Lastly, two patches ported from kernel side needed some minor modications to
avoid compile errors:

xfsprogs: Introduce error injection to allocate only minlen size extents for files
  Amended io/inject.c with error tag name to avoid compiler errors

xfsprogs: Introduce error injection to reduce maximum inode fork extent count
  Amended io/inject.c with error tag name to avoid compiler errors


This series can also be viewed on github here:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_xfsprogs_v15

And also the extended delayed attribute and parent pointer series:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_xfsprogs_v15_extended

Thanks all!
Allison

Allison Collins (2):
  xfsprogs: Add helper xfs_attr_node_remove_step
  xfsprogs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred

Allison Henderson (18):
  xfsprogs: Add xfs_attr_node_remove_cleanup
  xfsprogs: Hoist transaction handling in xfs_attr_node_remove_step
  xfsprogs: Hoist xfs_attr_set_shortform
  xfsprogs: Add helper xfs_attr_set_fmt
  xfsprogs: Separate xfs_attr_node_addname and
    xfs_attr_node_addname_work
  xfsprogs: Add helper xfs_attr_node_addname_find_attr
  xfsprogs: Hoist xfs_attr_node_addname
  xfsprogs: Hoist xfs_attr_leaf_addname
  xfsprogs: Hoist node transaction handling
  xfsprogs: Add delay ready attr remove routines
  xfsprogs: Add delay ready attr set routines
  xfsprogs: Add state machine tracepoints
  xfsprogs: Rename __xfs_attr_rmtval_remove
  xfsprogs: Set up infastructure for deferred attribute operations
  xfsprogs: Skip flip flags for delayed attrs
  xfsprogs: Remove unused xfs_attr_*_args
  xfsprogs: Add delayed attributes error tag
  xfsprogs: Merge xfs_delattr_context into xfs_attr_item

Chandan Babu R (15):
  xfsprogs: Add helper for checking per-inode extent count overflow
  xfsprogs: Check for extent overflow when trivally adding a new extent
  xfsprogs: Check for extent overflow when punching a hole
  xfsprogs: Check for extent overflow when adding dir entries
  xfsprogs: Check for extent overflow when removing dir entries
  xfsprogs: Check for extent overflow when renaming dir entries
  xfsprogs: Check for extent overflow when adding/removing xattrs
  xfsprogs: Check for extent overflow when writing to unwritten extent
  xfsprogs: Check for extent overflow when moving extent from cow to
    data fork
  xfsprogs: Check for extent overflow when swapping extents
  xfsprogs: Introduce error injection to reduce maximum inode fork
    extent count
  xfsprogs: Remove duplicate assert statement in xfs_bmap_btalloc()
  xfsprogs: Compute bmap extent alignments in a separate function
  xfsprogs: Process allocated extent in a separate function
  xfsprogs: Introduce error injection to allocate only minlen size
    extents for files

Darrick J. Wong (1):
  xfsprogs: fix an ABBA deadlock in xfs_rename

Zorro Lang (1):
  libxfs: expose inobtcount in xfs geometry

 include/libxfs.h         |   1 +
 include/xfs_trace.h      |   7 +
 io/inject.c              |   3 +
 libxfs/defer_item.c      | 128 +++++++
 libxfs/libxfs_priv.h     |   1 +
 libxfs/xfs_alloc.c       |  50 +++
 libxfs/xfs_alloc.h       |   3 +
 libxfs/xfs_attr.c        | 967 ++++++++++++++++++++++++++++++-----------------
 libxfs/xfs_attr.h        | 366 +++++++++++++++++-
 libxfs/xfs_attr_leaf.c   |   5 +-
 libxfs/xfs_attr_remote.c | 127 ++++---
 libxfs/xfs_attr_remote.h |   7 +-
 libxfs/xfs_bmap.c        | 285 ++++++++++----
 libxfs/xfs_defer.c       |   1 +
 libxfs/xfs_defer.h       |   2 +
 libxfs/xfs_dir2.h        |   2 -
 libxfs/xfs_dir2_sf.c     |   2 +-
 libxfs/xfs_errortag.h    |   8 +-
 libxfs/xfs_fs.h          |   1 +
 libxfs/xfs_inode_fork.c  |  27 ++
 libxfs/xfs_inode_fork.h  |  63 +++
 libxfs/xfs_log_format.h  |  43 ++-
 libxfs/xfs_sb.c          |   2 +
 23 files changed, 1620 insertions(+), 481 deletions(-)

-- 
2.7.4

