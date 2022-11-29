Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DCBAC433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Nov 2022 21:13:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237147AbiK2VNX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Nov 2022 16:13:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236899AbiK2VMt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2022 16:12:49 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32A7323BE9
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 13:12:48 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ATInVah022634
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:12:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=5mCJe4cuHAbhNv1MvWhk/RKGMEAbW1TfzW8Kgk38ni8=;
 b=WO1DTEtypPHElG192I/RqkbxQQ+aGX6/l4z+p5vb6yJeuscvX0A7+t4gACtOYCZmZhpO
 zXOAgZkVno2keOSIeIImkorOrKTyagy5GsJdq67AoPmYxboB36dv00x9Fv5fIn6QLdk+
 pzbA5C+tZAtfW03UHOXL23RIVQpHUxuu9xZ/z4GSWgRHuWEFu4DiTEp7nFedbngAq35X
 iZixlasa7PY3WfcZU0LTJpWCIBv0ozimQvEs7enb3GhH0exT+TpJvs52Y5KGsuGDv11w
 1SgLm1EKf5Dl/YfrKgQPzAWMdC/dPqEO1p2Vdth0vJhA2UdBP6FiqwMYsllj3tW2Bmuq JQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m397fg5fh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:12:47 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2ATKQP9v027961
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:12:46 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3m4a2hj0us-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:12:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eK6dFDuyGcV2SfJbFyJ9KxuzjXVHPN2FAEqCAVEr8w6SxJ2HWq4YhyBe+UvJQbdFSCftPUBtlbZivSa7FZ3c6oFfbA7hGnlv2w5IFFuDGJ6HXqW1qHtwQj8p09gUFRztKJ8WcaGoF6xZRNCDVaYFOvTB/HaKss7cpMV+NpflbZWQQRSwBClXEg21JN7KHOILDLRsMiEB0BcRA8LI495/fp2phgJ5RznqnRdm9AtqN0V2iGQmJgm3RXGCoNkosX7MMytH4VUykBRfBGdClAsBmaprbeqbgMN9OuQc0BQIljycKR+0YFJuEsxao2xIub3IT+X8JOMT3fRGEQW+tlVtBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5mCJe4cuHAbhNv1MvWhk/RKGMEAbW1TfzW8Kgk38ni8=;
 b=eCjR1BpVB/Es86RsxUqjjeS1puI0BlCEmfzPDDoYMPsTUMNui028ybwUD36hYgHLRo6Y5rBAH2GwzizBD0Wl1PjszFjZhdxLzc3RZTzX7FqIAwg7wOVwpll1ogK+Ba72BQ6Q4oyFKuR/F4juc92LrCOWhk/vuuDeGkK3HZJps/makrdRPwvnDKu/FCvCaaNki16rYLs3xFuzRM2alzZ/27ZBtngsJwwWOBEGWdFA6c9BpaEhfkmLOt96Xzms8doU0zsjfKMqeyWHyyTK3IiZYoRcQCT7jv08K3qxC8sRRVzBByTqdHRNsnnoCIgrm0OgriuTBcYVtOhEWgT5A3aW0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5mCJe4cuHAbhNv1MvWhk/RKGMEAbW1TfzW8Kgk38ni8=;
 b=MCcEVGPGCwt9OpoowV8Z7lpOBX18amopXOcSApXfzSbSaDCkL6NP7cRiWiMVm95fP8r3uDQNVVaQvDXCS/R1v+6dQiQSm1p5O4giOZKvWn+G5bLxv2pAG/cFX1qARbFlbOyOGEVuOfGb24Lk2Knc7LZP4gM5z8cPjPC9GzQGWz8=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4259.namprd10.prod.outlook.com (2603:10b6:a03:212::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 21:12:43 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c%4]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 21:12:43 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v6 00/27] Parent Pointers
Date:   Tue, 29 Nov 2022 14:12:15 -0700
Message-Id: <20221129211242.2689855-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0032.namprd08.prod.outlook.com
 (2603:10b6:a03:100::45) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|BY5PR10MB4259:EE_
X-MS-Office365-Filtering-Correlation-Id: 4464124f-18c4-4c7b-184c-08dad24e74bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HTkdh7eYfeZAlgNI2Ho9gPJTExNiEUaBKw7L96G1jJDi/rtt8dAX70VGS1DGvQyNBdGh11K+0l13pGQ90rhn9k8dLmxPjcPW1Sw2LuVlXuL1weap4+tzrm2wAhsgcB+uRjERbiDXclyOWmb7GIKb3O341kwfLhDh+BkpyjMpnYno7YfW8z4UYQILfdJ4Zr1YWHTFOPZzQD3WzU0PNysqwmYfqm0oFJtwjk03bQx1q/FeH3FcvahJDt06CNahC/LXJtv72/L3H/hW7AasXpyTQMXbQCQIw9k35xQYTQ6NT4rhLOkKU0qMQ44MvlAHuJ6XHSo0nzI4G1ZgW8s/mivX0ApggnWsIlyHBG+nqZnhwUk3vpKtH9DoOoSHoqFnSukmyLLzVUg4Kpykjm/LpEL+44T7fikLMydOqf4G9c0t7IDRbAHC7tZSr2Ke7lRTKXPEILC+bdRuudlbPDkx9NPA+Lg/HPrb5LoM1rOnQ+20dHMaun6Y+1wyhHZiMlK5uwI0CKJSexAVFiGQDtbjL0Ol2um2KuL884ouf3iLhcw69wvo7pZhRnYQeczizvLah7+WzujrxC64AzgYSq/g69ZI2P8K2SL3SgsVrZixikiY75fdegzP4lCX1Bvh+46sdXXSLPd7Rq0zkJoPFfnO0AGTwH1JfWHn1c8zVR8qRsjEkc2dEeZ17XRtbeIpldJXm2TsluBPhTbcCSu42K/Cpxe5vw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(396003)(376002)(136003)(346002)(451199015)(8936002)(5660300002)(8676002)(36756003)(186003)(66556008)(41300700001)(66476007)(6506007)(6916009)(316002)(38100700002)(83380400001)(2616005)(966005)(6666004)(6486002)(26005)(86362001)(6512007)(478600001)(66946007)(9686003)(1076003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hEwfKskKwNNbsgBcCj3wh7HwnynbMQE879gTRVihK5eKKAUmUzbJ/b5TVMPU?=
 =?us-ascii?Q?Lcz5k2UplpBgkcFo0/unH/A0MpGyI3+oCULuj94FR39v0FhTqKcKmWNTsGan?=
 =?us-ascii?Q?VQZd6Dc8cFL9pV+PCPuGdocMhdXDClYAozU+rrwWQ+hT4GUcS6vuwY89fs/r?=
 =?us-ascii?Q?Kjfn/3JY0kEINMsWQNJ/667qq62kbCkHcrJjTAjDnEfsY3Bpc3Aqy+sFEkFI?=
 =?us-ascii?Q?etDtvta/ez7D7nVbDrf7tL1lE4gpaalGF0wG5IEu6Dk1ZgAcveW0nbh4i7fN?=
 =?us-ascii?Q?An4KIP/luwj3tXjFXE3akPfV14F2Ksm1ovrGUXjvjhm5gt8UD5IvTgsgEwMd?=
 =?us-ascii?Q?KxS3ztmCiYbYHXZ/VwWqwDwgO2obvBURLacgcUWnfuCzDaKm4QHRUAjgXec3?=
 =?us-ascii?Q?eyplkGWGbMi5nyB5EzDcZQvP23eKa3dRWnwlbONWt4XwkTwfno5IJxwPwOAQ?=
 =?us-ascii?Q?dcWXjOkBM2D/ci3qDjZWfPcxsdqfw9ju4a0nIflhRGHRTiYQNTJvHmvfCyGk?=
 =?us-ascii?Q?OV2sEpqaV+1pjXFsLVj4PiZolYTw2h/SOBdLVBW3ffLoohHUjeIZg83QJWTe?=
 =?us-ascii?Q?6QJqlbcVy1/nw8GwnMS7HyOLfoGsDv6Pg9MtF/ENV+Sa3zDLHpHAbI07O3wa?=
 =?us-ascii?Q?m/Y9mTfaUH2G1c3gJoGNj+9Gy0S+ikte1b8axR7NuOXmiJSjVdPzhn71XUOv?=
 =?us-ascii?Q?FJdCO74aM6b1JJg+ZEoZuW05+9hCrxrJ75YdJrXsYJt1/d2aLQS+DjFthNvE?=
 =?us-ascii?Q?YY9DDuQEgJN1YufqZl5JOoDjtzMqPFJ9/Ye3XziWaXzmN5CYUs73uBkmWtda?=
 =?us-ascii?Q?nCEVbwTK9ZUuaHV8A4er3TVEU3R5Z14qXqzEchKVFnyfnZGMKBgF/+erKzfR?=
 =?us-ascii?Q?r8VpIrptPserHk8Fl6jeHh3X/VDTCc7kHlbnLbdf56XxlDWfh3WW5ZSD4DTd?=
 =?us-ascii?Q?qxwynxQGx2fKVf9I19dSxHXaeRgDqM6I31cuCPsS5Xn0KHUyESeRlRah0qty?=
 =?us-ascii?Q?5sEuf32sA2jFXb7SH8Gj1M9wW7kMtdJ5YrZmI76wbyGh6SLqJzKV4c94YMD9?=
 =?us-ascii?Q?UwPfQO5Ys5rMUEsZi9YuXEM+3ORMmuJe771TTDFEMV+jdJTELzEOtgDiQ+Am?=
 =?us-ascii?Q?pbVD22m0WAhlCYIYu44XfB4y4OA53lCcbJCBEZF+ZYNx0qpdzjX6YL7cjnFf?=
 =?us-ascii?Q?i3D8IJKi7gNRqFxRLyuZxauxjQhij8SEpx1L7zVb9NuQ2GsiYJjLR1w8R718?=
 =?us-ascii?Q?0LBw5Lh/qNlDJg4xdaB64ABiC5ontHsUPlnVNIzD8T1/Umu3hDrAq/NQKwp2?=
 =?us-ascii?Q?RtRVfxf+Z3fS+G7A6zzlLKH8inDqVJOetYxeZoCekkwMABnyqW/kWJaGHE7q?=
 =?us-ascii?Q?9wEtFi1gI4Qz8l9BHT7+IZadSMDSJSOMJnCbvKnFLfcefS8a2UgF/yZse8iO?=
 =?us-ascii?Q?34PjDNK8PYxBnE/KbuLnSRBWDdLFUSjAUyxGDdM2AHM8u1xwqgQ73sgGHIgz?=
 =?us-ascii?Q?0YZjdaXUm4QVXt09QAnu9AhtadkKCQ22GaGp1iJEVa5yCnIoggTZ8mLTfyJe?=
 =?us-ascii?Q?qLyOWJs63B/x6Fm76rvpSuFZwY5S+qJN3So1B2ss4T3ApuOHyf31uc/Libvv?=
 =?us-ascii?Q?Zw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: N4FeE9k0bdjg6Nw4Tp8HUmvv5i7KmbBoT4h6DBUYANeUSICPGxqZ/U8NVsC36mgycjhGWYREbpIFsE5mtSHqtl3kO2osHDvLBT0/ZaQaRkV84j6xv5P1P3aol6/RM1X3zBGt/U7oZ9AsR9n5taMQkxj+CKO+vJTushmZHccY3L+lmrp0T1W2OW+RoqAyK1YqJKgs8h47HhN4ZhdanGMmJFlz/pWynjoNyO3tilRKiEco+ZmEuMjM3Ib5v0gBRe+9uSzSSoUdhiSUEY3kyV2LB9h7tpqKOWcUy6lP7f/EX9mzU0rcWQNbBlLzdaBJPfVkZR9JHiEBBKk5UbxhVSG0YL3BSihcGTw3ubtjSREx+WVIf4FgZIrlDzR3CVGsMcdJkPwHIUCSrvpM+8YNq6bARjN46BNNob6pftb7YivHplODbCJqA9aCihs2qDKImQllXwvzwnUg3Srt+ewZeKHNtezjLenNAaksNDadMFT1K5L/EZOe/P1Oe2rV/tAJRhJDFO4bli21ySD5x4gI97qyrnIoWSNn+MOIH6rxn42fzgrEHKMA8fkrIDi7iONRVjleAI1gIOrmRFZOOMv+bJHs45E9q5UQma57PVpSYJV7oufJXSsV0ClsbNYps5iqHYIjM5GYmJQ7HY8g4qcdhsD9eJpDooOCUzjFumh8uFqbykd3CUYqjYpknCHXEMAA+46B84LKFJyxv/6zlgNMvQ1a2gqtME2lm3eJTtOS7y48n3NElqylMd1C0TMmmHY5iN8wTR8O6BqcrrJnM21H9s1jpQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4464124f-18c4-4c7b-184c-08dad24e74bc
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 21:12:43.5361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 66vUc2Y31AJYn0CaB5T1TR9pA1IpDHaI6j2ddhEUqMfiu6tUxCkhhckeI+pwf3Zen6cPsI5xHwmXSlhPUMPemVbjMz8lqJv6bFwmO49/c+c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4259
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-29_12,2022-11-29_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211290124
X-Proofpoint-ORIG-GUID: RjRUm1exIdzqCNAFiJzGwdBF1kFqHp_r
X-Proofpoint-GUID: RjRUm1exIdzqCNAFiJzGwdBF1kFqHp_r
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
https://github.com/allisonhenderson/xfs/tree/xfs_new_pptrsv6

And the corresponding xfsprogs code is here
https://github.com/allisonhenderson/xfsprogs/tree/xfsprogs_new_pptrs_v6

This set has been tested with the below parent pointers tests
https://lore.kernel.org/fstests/20221012013812.82161-1-catherine.hoang@oracle.com/T/#t

Updates since v5:

xfs: Increase XFS_QM_TRANS_MAXDQS to 5
  NEW
xfs: parent pointer attribute creation
  Declare xfs_create_space_res,  xfs_mkdir_space_res static
xfs: add parent attributes to link
  Declare xfs_link_space_res static
xfs: add parent attributes to symlink
  Declare xfs_symlink_space_res static
xfs: remove parent pointers in unlink
  Declare xfs_remove_space_res static
xfs: Add parent pointers to rename
  Declare xfs_rename_space_res static
xfs: Add parent pointer ioctl 
  Added out_unlock goto

Questions comments and feedback appreciated!

Thanks all!
Allison

Allison Henderson (27):
  xfs: Add new name to attri/d
  xfs: Increase XFS_DEFER_OPS_NR_INODES to 5
  xfs: Increase XFS_QM_TRANS_MAXDQS to 5
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
  xfs: Indent xfs_rename
  xfs: Add parent pointers to rename
  xfs: Add parent pointers to xfs_cross_rename
  xfs: Add the parent pointer support to the  superblock version 5.
  xfs: Add helper function xfs_attr_list_context_init
  xfs: Filter XFS_ATTR_PARENT for getfattr
  xfs: Add parent pointer ioctl
  xfs: fix unit conversion error in xfs_log_calc_max_attrsetm_res
  xfs: drop compatibility minimum log size computations for reflink

 fs/xfs/Makefile                 |   2 +
 fs/xfs/libxfs/xfs_attr.c        |  71 +++++-
 fs/xfs/libxfs/xfs_attr.h        |  13 +-
 fs/xfs/libxfs/xfs_da_btree.h    |   3 +
 fs/xfs/libxfs/xfs_da_format.h   |  38 ++-
 fs/xfs/libxfs/xfs_defer.c       |  28 ++-
 fs/xfs/libxfs/xfs_defer.h       |   8 +-
 fs/xfs/libxfs/xfs_dir2.c        |  21 +-
 fs/xfs/libxfs/xfs_dir2.h        |   7 +-
 fs/xfs/libxfs/xfs_dir2_block.c  |   9 +-
 fs/xfs/libxfs/xfs_dir2_leaf.c   |   8 +-
 fs/xfs/libxfs/xfs_dir2_node.c   |   8 +-
 fs/xfs/libxfs/xfs_dir2_sf.c     |   6 +
 fs/xfs/libxfs/xfs_format.h      |   4 +-
 fs/xfs/libxfs/xfs_fs.h          |  75 ++++++
 fs/xfs/libxfs/xfs_log_format.h  |   7 +-
 fs/xfs/libxfs/xfs_log_rlimit.c  |  53 ++++
 fs/xfs/libxfs/xfs_parent.c      | 207 ++++++++++++++++
 fs/xfs/libxfs/xfs_parent.h      |  46 ++++
 fs/xfs/libxfs/xfs_sb.c          |   4 +
 fs/xfs/libxfs/xfs_trans_resv.c  | 324 ++++++++++++++++++++----
 fs/xfs/libxfs/xfs_trans_space.h |   8 -
 fs/xfs/scrub/attr.c             |   2 +-
 fs/xfs/xfs_attr_item.c          | 142 +++++++++--
 fs/xfs/xfs_attr_item.h          |   1 +
 fs/xfs/xfs_attr_list.c          |  17 +-
 fs/xfs/xfs_dquot.c              |  25 ++
 fs/xfs/xfs_dquot.h              |   1 +
 fs/xfs/xfs_file.c               |   1 +
 fs/xfs/xfs_inode.c              | 424 +++++++++++++++++++++++++-------
 fs/xfs/xfs_inode.h              |   3 +-
 fs/xfs/xfs_ioctl.c              | 148 +++++++++--
 fs/xfs/xfs_ioctl.h              |   2 +
 fs/xfs/xfs_iops.c               |   3 +-
 fs/xfs/xfs_ondisk.h             |   4 +
 fs/xfs/xfs_parent_utils.c       | 125 ++++++++++
 fs/xfs/xfs_parent_utils.h       |  11 +
 fs/xfs/xfs_qm.c                 |   4 +-
 fs/xfs/xfs_qm.h                 |   2 +-
 fs/xfs/xfs_super.c              |   4 +
 fs/xfs/xfs_symlink.c            |  54 +++-
 fs/xfs/xfs_trans.c              |   6 +-
 fs/xfs/xfs_trans_dquot.c        |  15 +-
 fs/xfs/xfs_xattr.c              |   5 +-
 fs/xfs/xfs_xattr.h              |   1 +
 45 files changed, 1708 insertions(+), 242 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_parent.c
 create mode 100644 fs/xfs/libxfs/xfs_parent.h
 create mode 100644 fs/xfs/xfs_parent_utils.c
 create mode 100644 fs/xfs/xfs_parent_utils.h

-- 
2.25.1

