Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B0DCC4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Nov 2022 21:06:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231668AbiKJVF7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Nov 2022 16:05:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231433AbiKJVF4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Nov 2022 16:05:56 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1EB54AF25
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 13:05:54 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAL0b6a006965
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:05:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=3e7Ph4WK2JmD9/7Ey0f16DPDXEWNWiNfX3P6azs+q6k=;
 b=LwbRLS/EniAVFitvjXE89ya/ycEmDt9hD2vrZwqSemORP+J4c9QFIEE9BjbyEyv7pI04
 kvJolLPw1uyX8RL+WjrDD0+r2Wod6Kb7REw3kOPhnCdDBnGYN57rZ8Th0JjH0msoyWMA
 /96+1ovQYZ9dV/VaEnOkUReMEYVrZ/YhISJwZyL3vV6vXvz65iwLX3UG/tbsuORTZ3ib
 x0leay/rBTXBn6KT44T11bas2ztwPuI1dB+gcsoJkGxzq20PKbyUZgaaCDZGoD7njldd
 Y3Pz8dcUUkxEq71CkGUC5dqPJ3px2ZJhYpf3LrjBN6+VrAC0EdFuPF2WW3kO80M9sZjv 2Q== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ks8u5r125-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:05:50 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAKTUmG019793
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:05:32 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcqkmngh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:05:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h397UgL10iVDbwiPt/CHLp2cxMgVYx/JuHoKFfEye+12760+3CuHP130N1j8LGWJ0s3RBfS8ZgK8lRhGLogDm4OYSRCosxX2ZzS40NdF2pObW0JpCLWehh5DIvkdw3bd5CV9XOV2gbw0ZnAhjfOtwdcF8WV2qKruZCje6H9eXk8lv2/Uw/mhIFcsNC5h/6ytngZSXdIkZFvb9B/BkjiNP03Tg1TfbIWfg97/vLwJuIb4gnjU2UcgM++kY1yqv7Dy0K2ATxIc6aliXlrQZLizuF7i5+fGrjNscG5v23NPSBobPa6sBITYjSPiqZ5ejLqivP1An98gMpXssgIIzZJCkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3e7Ph4WK2JmD9/7Ey0f16DPDXEWNWiNfX3P6azs+q6k=;
 b=F0yN/8nGIKTwEcZUs1ttMahJuFMWE7WDfH1WKAwDqFfnBfvRVF/wQAC8Jo0CBflpnYkLfGt6bBOo2rD/gsBmA3EziHs2bU2n92GQDWNMdijlGFPGpRr8UJvJk2FE6ptV5hjzT08qMcWsl3oRk5O6+59YixDZ9JJbuEpgQWFGva5n9P/rQcCKjcyHGxqclL62bHtqmcv1lXIPdOXfO5EpA/9s7E9jm18fCoOvU3jShOKkTNdyP0Eoo6/L8nVVrzRKZ+Oyh/nivxuWwXQ2MxKe1/HBwBExXkXmIiBiBxRZOT/n+EPhudtQRDMpGQ/Mxpn4RnQ/FK/0FZzSSOV5GwqGBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3e7Ph4WK2JmD9/7Ey0f16DPDXEWNWiNfX3P6azs+q6k=;
 b=LVACTlj1NQbvFZGIdsoTDWsg3oQm9V4Pctc7Krok7G4JJgDPC15v2WMASEr6Q2iyJzgkAe1gKE8vVStiCYFeq8xKe8RO5qtK2KkJh9FGbnDHI9UdsiVJxXxr0YJ42Kj41FQ5uprPTuFQOobd3ku/JsY9Z6M8AEKggp2ifjCPhJY=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CO6PR10MB5553.namprd10.prod.outlook.com (2603:10b6:303:140::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Thu, 10 Nov
 2022 21:05:30 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5813.013; Thu, 10 Nov 2022
 21:05:29 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 00/25] xfsprogs: parent pointers for v5                      
Date:   Thu, 10 Nov 2022 14:05:02 -0700
Message-Id: <20221110210527.56628-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0026.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::31) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|CO6PR10MB5553:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ae5ab3c-8bec-4a09-9f83-08dac35f4c2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9rD8zyuH4jOswPwy04ueoxwiCPdJyexcAFT/Mw+W5Do/VwaTHaUIbBKufBEfSMvM0IfIwr6B+AYk6f2h2StYqRTeOSLr2rgFQQUanSoEcZ/gQRkq3Rccrj7WZcV130H88XvcsWcWwcYPJc4WabeQozuGS4+4q5pRxCo473Ss0x2kQLOMZkHRHmxrUPR/k7OJEDo0db7pG88ZxzdLpEDQyWMhRuPxwDXj07t8VibKfo8yfzkYgqQ0Y0HeT6rzjSAAQahbnnLkT+F96DZSkUy3XyfFBmoNT5cSOk/ArOrfA6q/7zB+P7rbHyOcW66DR6pRJPjyclL3qnnOrUoBRtnJoce9dYJcV8wjALFr0slpFV7daeFSothQZEauAyLGrKRtdytxQUFo1FkoH4+unu/qm4V6ngWHM6xQSND0M8KQF/X2jgRko/CLBtNLtAGts4rmct5x899+UEwK03wE5M6XYkAqoqnfw84NIitJC+sfzRfL45AsKT0pFjVfZMXcMRlclKp6Y5S6GUITywpD4FdTRbQp/+ixUVViiiMcrkbmq+qUPg0yEbaeLXmOklXpsceGtGyZPt2Fsrc7HWXI3zbbuj/k5CeXVfN74SchC+s7SchiK13B71HmCQ5CiJBGrNFXH/asZ0w0JcnBKx/2ypGWxqSl/HOJ0tllRtFMOX3efQzrezM/RK3AHJbooWkFcZsLYOBSOS7hqdI2ZxXcBzQApx61N/tNNsrdSxDbVT91GuI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(366004)(39860400002)(346002)(376002)(451199015)(8676002)(6506007)(66556008)(66476007)(316002)(66946007)(2616005)(186003)(1076003)(6916009)(966005)(5660300002)(2906002)(478600001)(86362001)(36756003)(6486002)(41300700001)(26005)(6512007)(9686003)(8936002)(83380400001)(38100700002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pzxmQ8oeEptKAjBRRdrn0AMIfHu93hMIzMTDlhx1F+ghpvuLk3foWYonoNMs?=
 =?us-ascii?Q?QZl4T2lrqjDEbY7EtE3hJkvbnPQ5hOwlJDGI9ZDxtmaGdCXRhlA6vyHS4cIf?=
 =?us-ascii?Q?3YYGYmQyk1Mc6KBDl1HDyMOHaeiJHF35//2estm+gavty9fd2FCRKXdKN447?=
 =?us-ascii?Q?3jL6owwFZGKkFPm/IX0zXypwyCQJfsMn4rKUQQvIXmtuwmnQ4rsn2EMGKFm6?=
 =?us-ascii?Q?qtFQ8w9ADLgZw094/66uZdMV8SG9ru0lPtcmRgMOAHCnpXOO3y3RCOSEKvC5?=
 =?us-ascii?Q?6nxLxh/UsOfMVqJrsJJwm8PmGrtZozCncRwX+hYX1Q5pB3WFO+gTOxBMZ1vs?=
 =?us-ascii?Q?ciiZZbxN1ISc8NPfYD6X5IUC16ZNuDQhB/b+vKt+cfojkKGDNdX1O1L+E58d?=
 =?us-ascii?Q?UOI15O9tM6lhuwRcC1k5aD39pUL+ruYN9WfBp3WvK2ruQKwajS0yodCRz6VA?=
 =?us-ascii?Q?+7TiiV0RjrCEHtbBiTLp9xVdyavVb6etnMryj5QMvvlHl0P+nZDh8Jj6XUZ+?=
 =?us-ascii?Q?xP9ttH/GtEFe2ALFtaUl1oYEBqaBSFzdLMN3tuTGc+JyIlGjJXukklFWpez0?=
 =?us-ascii?Q?uF79iaBU9hYVeb+W4PjMXU4xISBYUnXZjldOQjetWygzYhr4MiYxkXum6U9V?=
 =?us-ascii?Q?dVqkWclqbrfUrtcP3/JNBH4gckpy37f9CWDMoqmUxvS2ztk5m5rptXFvDF3Y?=
 =?us-ascii?Q?cEFL+d69gv/Oy89Mfr4fdveQ9GtP97XylvYPlXh0GLL/WS6xYHVZX8h4O6Ky?=
 =?us-ascii?Q?VUR7YsPh/k9W4q+PgvBLNrsSrE0zMrcPHxJJQNjKG+rzRaovGgzEET7L7lBu?=
 =?us-ascii?Q?TJAakuBDKMKnzqtqDnKG8NiwlrJHGwDml0Wsg67ZxRIhboDHtuIk+ewPmBcq?=
 =?us-ascii?Q?f98agGyQHXcInoJ/U+OaMUkoi1P15fISHagYkH2e93huEHHDB1IiQ1OrEVUL?=
 =?us-ascii?Q?YCTmBoL/hER+EmHJIiZVLmhFR0lzuUhPVN83CjGOdP7D1SHp7mxMYHrsO2Oo?=
 =?us-ascii?Q?F7Qs8KyxQeyG8Uzp8A68f2q6I4Bc9WDDib0dPmGYdoSo/wGrGCYEfAsjBrJP?=
 =?us-ascii?Q?O0QCxHWV+mdUEW38V1ww0sSJezYwdM2rZBwYMue5h/xHCvuRdQxQWVSRqaHz?=
 =?us-ascii?Q?VmYovhEpqJL4jKCvmCJFiaU5ulA5HPCXV41IM8szwDhIv6RhDYBbA72Kbss6?=
 =?us-ascii?Q?tlQqdPXhswtd0j6wqG5LTexfKbxahsc21+STQSGTx0G84mlFr8pQzxCkB3om?=
 =?us-ascii?Q?4vLBYYoeLLm0zuNthGADY9JkSmnrRHqf5cEVxXBG8UDR28lwVqLZz40+TRYU?=
 =?us-ascii?Q?Te5FOgT607p+1bwM64vIS0uBr7fDzWZzpABZFkzrCoDRkUKY1j+YpyTBl5vP?=
 =?us-ascii?Q?wAwRlkZsQMow90JCBhZE5dIb1l89QHeqdkgSJ031LSmRV+nPIa8BpY0XGFSC?=
 =?us-ascii?Q?BHKLEZL5oVjhcgJ8AQZkecBkHVR1zKhhzyU1JbiKAjyuZJN8DOq+h889eFUc?=
 =?us-ascii?Q?ocvNqFX/FJBEBdCVOhug+0rgszMV7OtIMRmz4U7daEfepZViuzTWR62nAJTk?=
 =?us-ascii?Q?rsMG4dKemNrZHGnDX/bK3azNLCvwza322ikPJv94DIwp/dTz++eZ6w3PzsUM?=
 =?us-ascii?Q?vQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ae5ab3c-8bec-4a09-9f83-08dac35f4c2d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 21:05:29.4652
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WV7d9YJJYtzj19w31VxEnMhjgA0lHb0wxt2Z5h911Sb8ycl12aDWFJ9XeK0g4OyFjpp3joE9Gtb8Vbi6Epk7TKPRLN1dbpYhSAd4LTUV15k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5553
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_13,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 suspectscore=0 spamscore=0 malwarescore=0 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211100148
X-Proofpoint-ORIG-GUID: 8xdKDmnkvfNkH2HByyXTAAJt78q0NXpb
X-Proofpoint-GUID: 8xdKDmnkvfNkH2HByyXTAAJt78q0NXpb
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Hi all,

This is corresponding port of the v5 parent pointer patch set for xfsprogs.  The
goal of the set is to enable use of the parent pointer feature on the kernel    
side, and provide basic user space utilities.                                   
                                                                                
The first 20 patches synchronize libxfs with changes seen the kernel space      
series. I will pick up the reviews from the kernel side series and mirror them   
here.  The later patches add the needed changes for printing logged parents,    
adding parents in protofiles, ioctl plumbing and command line flags.            

I dont often send out the usr space side since much of it is the same as the    
kernel space series, and the user space mechanics wont have much use with out   
the kernel support anyway.  So it makes sense to encourage reviewers to focus   
their efforts on getting the kernel series out of the way first.  But I think   
doing an an occasional post is good just so that people can see the whole       
picture to have and idea of where it's going, and also just for archiving       
reasons.   

This set can be viewed on github here:
https://github.com/allisonhenderson/xfsprogs/tree/xfsprogs_new_pptrs_v5_r1                                                      
As always, comments and feedback are appreciated.  Thank you!                   

Allison

Allison Collins (3):
  xfsprogs: get directory offset when adding directory name
  xfsprogs: get directory offset when replacing a directory name
  xfsprogs: implement the upper half of parent pointers

Allison Henderson (22):
  xfsprogs: Fix default superblock attr bits
  xfsprogs: Add new name to attri/d
  xfsprogs: Increase XFS_DEFER_OPS_NR_INODES to 5
  xfsprogs: get directory offset when removing directory name
  xfsprogs: add parent pointer support to attribute code
  xfsprogs: define parent pointer xattr format
  xfsprogs: Add xfs_verify_pptr
  xfsprogs: Increase rename inode reservation
  xfsprogs: extend transaction reservations for parent attributes
  xfsprogs: add parent attributes to link
  xfsprogs: add parent attributes to symlink
  xfsprogs: parent pointer attribute creation
  xfsprogs: remove parent pointers in unlink
  xfsprogs: Add parent pointers to rename
  xfsprogs: Add the parent pointer support to the superblock version 5.
  xfsprogs: Add parent pointer ioctl
  xfsprogs: fix unit conversion error in xfs_log_calc_max_attrsetm_res
  xfsprogs: drop compatibility minimum log size computations for reflink
  xfsprogs: Add parent pointer flag to cmd
  xfsprogs: Print pptrs in ATTRI items
  xfsprogs: Add parent pointers during protofile creation
  xfsprogs: Add i, n and f flags to parent command

 include/handle.h         |   2 +
 include/parent.h         |  25 ++
 include/xfs_trans.h      |   7 +
 io/parent.c              | 505 ++++++++++++---------------------------
 libfrog/fsgeom.c         |   4 +
 libfrog/paths.c          | 136 +++++++++++
 libfrog/paths.h          |  21 +-
 libhandle/Makefile       |   2 +-
 libhandle/handle.c       |   7 +-
 libhandle/parent.c       | 361 ++++++++++++++++++++++++++++
 libxfs/Makefile          |   2 +
 libxfs/libxfs_priv.h     |   2 +
 libxfs/xfs_attr.c        |  71 +++++-
 libxfs/xfs_attr.h        |  13 +-
 libxfs/xfs_da_btree.h    |   3 +
 libxfs/xfs_da_format.h   |  38 ++-
 libxfs/xfs_defer.c       |  28 ++-
 libxfs/xfs_defer.h       |   8 +-
 libxfs/xfs_dir2.c        |  21 +-
 libxfs/xfs_dir2.h        |   7 +-
 libxfs/xfs_dir2_block.c  |   9 +-
 libxfs/xfs_dir2_leaf.c   |   8 +-
 libxfs/xfs_dir2_node.c   |   8 +-
 libxfs/xfs_dir2_sf.c     |   6 +
 libxfs/xfs_format.h      |   4 +-
 libxfs/xfs_fs.h          |  75 ++++++
 libxfs/xfs_log_format.h  |   7 +-
 libxfs/xfs_log_rlimit.c  |  53 ++++
 libxfs/xfs_parent.c      | 208 ++++++++++++++++
 libxfs/xfs_parent.h      |  46 ++++
 libxfs/xfs_sb.c          |   4 +
 libxfs/xfs_trans_resv.c  | 324 +++++++++++++++++++++----
 libxfs/xfs_trans_space.h |   6 -
 logprint/log_redo.c      | 210 ++++++++++++++--
 logprint/logprint.h      |   5 +-
 man/man3/xfsctl.3        |  55 +++++
 mkfs/proto.c             |  50 ++--
 mkfs/xfs_mkfs.c          |  31 ++-
 repair/attr_repair.c     |  19 +-
 repair/phase6.c          |  18 +-
 scrub/inodes.c           |  26 ++
 scrub/inodes.h           |   2 +
 42 files changed, 1931 insertions(+), 506 deletions(-)
 create mode 100644 libhandle/parent.c
 create mode 100644 libxfs/xfs_parent.c
 create mode 100644 libxfs/xfs_parent.h

-- 
2.25.1

