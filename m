Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C3B0C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Feb 2022 13:02:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232102AbiBXNDO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Feb 2022 08:03:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233821AbiBXNDO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Feb 2022 08:03:14 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 028D41B0BE4
        for <linux-xfs@vger.kernel.org>; Thu, 24 Feb 2022 05:02:43 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21OCYFnR007314;
        Thu, 24 Feb 2022 13:02:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=sEFiqA1y+FCvD1InvplWD/Zz0OJ54+v2E8oURdEDS4U=;
 b=E10Hlqd+tjHV/HTr+OuAJmsOSrq2849Xc+HQXH/yAYxUC2YHUjzokr7Ia5hx55pR5JKO
 QYD1dyvBiZb3XpcOHKlpqQEFZagEjsfShfld5QTrsiOi6f356XtX2f8xhPSZj4NETQVJ
 UAN72ISksZhVugMJpUFKA1N66OxQ5uDJFD13uhpn4IegRq98K7R7g3Nz0fU6CJ4s7d+V
 gYrf5l64DDF3W+mcGw7zn4/LbkC0Ne4QX/iDtLw+Yow/5zytoWRv6Fuo1W8KjlsMSLAC
 TSZW+WeTk0duvrYE+NM5yxkCWQUwABzT14GsoXGY8KFqgVixDzk+WFkPqS9pKFk+6saR kA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ectsx7b25-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:02:38 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21OD0XBT120494;
        Thu, 24 Feb 2022 13:02:37 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by aserp3020.oracle.com with ESMTP id 3eb483k701-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:02:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z5riqOpJKhsdNb7tiC8iaXwv0xSkgYYS7u8TPXqVLsjiSgsPqNYo0qPpH1vTes9SM7ahasC/yRyoBM7bEUBR4soUoFBzjM5YQ2ofapLaejl/1qV30x3HKp78IwSDQjuzBEbIiSCg7cYKBmg3zjrF9KyCKRa83+rhpKGUnLgAf2QgGUXcA2Vr7yjkjDfLeVHc1GzKiFyfA8UIGGEgXqzlP0kSfBc0j1NUuquljjr426fo3pq0ffV2Y6eY8Md1d0yFrGhiUUKdg67VX9+QZX545fYiqNaUBRt61Ua+ra31QMTnIvKpHI1ETGFUUL/0BPENTG+0evwOKQGmO5WtXfnFDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sEFiqA1y+FCvD1InvplWD/Zz0OJ54+v2E8oURdEDS4U=;
 b=lfRnMDradNrucS6MwY/Uzv6y+RQwKvEaUI1m4zLFDZ9y8KG1LhKOHbe+0IP4SetDzqEskBuGkgBD5kPNFjaZpzkObkgfZ1k0oim1zy3aQvL+cfvQPw42cYr+9a9GrPBChleOQTOdt+S4nC8Nxs5RvmDmtDFsfA+JH6FgipRw4Pv5BrSQJdzCEFYMmkf0fC0ae15KEqNIQe9jg1FCl6IkGeeE7Q4Nocm9yey35bMZR52QyR0u+RoMCbbk4+3FhJ7GKnwKUwlh5jdOLi65g6WDRUdCGUpZw2q32KegDxCrY7ELs/qs08Kro8bXI6qIEB9q/uBQIh3uBun6GL8KUR0lDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sEFiqA1y+FCvD1InvplWD/Zz0OJ54+v2E8oURdEDS4U=;
 b=mPgKs0Bj1j9CxqSLnZKbV1XHbCotreDXrAlJnUS6rP/MgBetbeCIzKMV7JQ67hEpW5bt8foTRfB+2ebobOqf13csH6il2dbDUQlj9oD23FnnMmvPxtseSP3Z1LUxzLZ2N6PHhrttRg13Pq3kvuT+RcV6f9/1vbuDeJtM1GxlAeo=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BN8PR10MB3665.namprd10.prod.outlook.com (2603:10b6:408:ba::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Thu, 24 Feb
 2022 13:02:34 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%7]) with mapi id 15.20.5017.024; Thu, 24 Feb 2022
 13:02:34 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V6 00/17] xfs: Extend per-inode extent counters
Date:   Thu, 24 Feb 2022 18:31:54 +0530
Message-Id: <20220224130211.1346088-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0009.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::18) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7d5b9a91-0dd7-4b87-c993-08d9f795ec70
X-MS-TrafficTypeDiagnostic: BN8PR10MB3665:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB36656108B79B362FBCD76780F63D9@BN8PR10MB3665.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cRrcpJaxS90YO2Q0+wKjoO/fxwxbwP9KxCoBpdcae/Uk+1ww2Ri2KbOO8OmUevrmysd/NBozvkPir7s0hhaIMnSQHCi+XIEEhjxMaAK0etoiSMIDLZ/DqTa/FiBHiv5z3U2DXh5KCWywNroDjXHTOQx6AiS558nFL6JCLi+9jmjDonP0nKrxzn1DK+KiSZKde+yBUc+e1ZFD8/qKNWWpNumK2oBWooJBwMEEEFvAK3CKtb20JngIoxOB5FpToj/StLPoAeWuQqcgccmtZW4yRpHhVtBTANZ9bj/+VCq4NIvRCJFSJhugL41iBNAp2YDFeZu9cWnmXCvFphgHQpFy67aS/Y8KNgU0EXXMI3gMQI8fwY+aPJ4BbGS3c2wEv3OdPtjkPkGWB1iKSgHpR5hUVAtV09jBcLU0CR/+Qd3Ah81uQm9uhkcoKPboQga9ofxvBIA0DhlJg6DE5QZb6L5Ek8KoasTFXhfh03pBi2g35BfKvkIJUch07bjndyMZa8EeOszecr1M3E3z37tvVLuczNcf+NLS7VpDArT5LgPPrHwRfUf5gWP/zCXZSb2mwtlFzrU77x+8UaPPWAe/s7EoKI+kzrimyrytNmyNp2BS4skd1LamZlyuVToTURL7PvZ9alJ8HHJ5LA6ko4+yvQ7TsiH3Af+4IsQnKa/oALpMBGS4GedadEQ3c9e1o5PHLjyzIEV0Ccx2pCP6VhMJzWOL7znlsmHhoxD/NdJes5bufgSz4DUssvElUd+tmBd9hMTu6VBIfuwq6xvS9eMkXctnlxd8Q1yiLe7849MuWCh4Em8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6916009)(6512007)(8676002)(316002)(6486002)(52116002)(508600001)(6666004)(2906002)(966005)(8936002)(66946007)(66556008)(66476007)(6506007)(5660300002)(4326008)(83380400001)(1076003)(36756003)(38100700002)(38350700002)(186003)(86362001)(2616005)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Erz0wAPmekHUYcF29+C8tvFK32Pa0+eNa3LD+2xqoZhnF/5v0WFWyBuXFRlA?=
 =?us-ascii?Q?eGKS5qStY9pOWFxeR0xPPeRaAHtwTFSrJ67PH3dBRq4DKH/6u00uAGh/yoxu?=
 =?us-ascii?Q?D5+RUbWBBl098qchqf8rPCWeuIfWykDe5ZBRxxuo8A6xb2A2wuk+ld9W7Hfa?=
 =?us-ascii?Q?fKoLk1licLHaWidEdoI5LTanak2CD48h6LRyl1ySoWvk2kRJDx6IjeKorWtv?=
 =?us-ascii?Q?GAsWYX2sIZqjd4mrn4r8hEX6+JTh/q+DP0SwakhH/c823opYsIf4o65cM+EM?=
 =?us-ascii?Q?R4dHUDU2Lj3gYUsyWw9eDASUnFNu/P+hhDAVALCgjdxCLp6K9mbYYQ/P46th?=
 =?us-ascii?Q?f68ZalT0ENXJi8xXi1Qtvi4BH2JjYxPk3TVEWEFNO/j7s68ADPrKh0myqAVc?=
 =?us-ascii?Q?U/ofxAwUNsEEhczUPBeGa+FE56Jndz3aW39Z3NXDBf/QUWq/AmjLIR+UzkMz?=
 =?us-ascii?Q?ogZzw+Ax0WXGfEYdQwiOf+5/m8EG846M8ijrFNEaT6z6g/ZTsZ8rkdUCpGT1?=
 =?us-ascii?Q?hHcxE9kDdqgribypcOorEf6kOhhkAHnkfGZrfmPXsOWGEL0eVRsK+t1ocG3b?=
 =?us-ascii?Q?+tHF/f60IbPC06KFWr5Pb/Znvl/OeMgoyzTYtHaJ5B3RrHs7mpWQgYZWhgV1?=
 =?us-ascii?Q?nYnO1Bd+5zS672AczHcTtE/ajU/JYYLOB1YbZ9YyiPDAk4lhh903ddJvTPZ4?=
 =?us-ascii?Q?4/Q9D4pIvF3wkG/CJLPmY8hN/6NP+uZVTNraVNGbfMStKpkp8jXiahK7bv6d?=
 =?us-ascii?Q?Z09XluuP1L1/EvOWp+PXVKaAogLs7x30tUAjMk4QPPUBbPBbFjkG1b24321q?=
 =?us-ascii?Q?IZzd3AfLaAJX7NI5y+j9rhCRu40GRbVcqxhQiSErmWviBRmt1e48aIpUY76F?=
 =?us-ascii?Q?OC4Z9+jAD1O4J5Qn8pDCFojkyKL84hz8tFtqkphMRSRyeSaZtTqh2ykNaErj?=
 =?us-ascii?Q?wYHr8eg4lqxSH6Qk31GLjX9dMEOH8Q9tOBLjzbZm6upVMZ6XefKS+E+s/EAi?=
 =?us-ascii?Q?/6nAEOrqYcPWnh6BPzZThzVtVY0EIt6/8niBuXdKIVfyokCw4AK+v+/FaI52?=
 =?us-ascii?Q?fVgSsmoDbnUq5G00/4ZdH1TfFAMwOO5Z518eiP+l6u7EgVufIKrDlLvffQmO?=
 =?us-ascii?Q?HzbemDSKb5MN4fZzL3tomFtkxlbseMS8zZ/mUCcMX5bw7Vf0Rej1jlHfSEe3?=
 =?us-ascii?Q?dO3QALkGtXhljiVdwbVYbwP+wkgJDHQRZgmwd2TFz3M89p9yAmBm6dhGbEvc?=
 =?us-ascii?Q?qJhV3V0BLTeES2cizWNZ6YVy7QIXsqD9hgAttMv+WWMpvveh1WdHYUEaRmpB?=
 =?us-ascii?Q?Vypmn83kfB3fSS312Q2EU46oCpjcaTu7/CjR6Q/oGzPlExAT5kH6nTHSdsaU?=
 =?us-ascii?Q?0ufVbK8Yo+LQHCsWwiwSeShCZEYxHBy9eDYUfLmeF7JAuZ8Lf8Ij7Dh2oTkH?=
 =?us-ascii?Q?fiJVWek1JGtUOBtpTSNtWUNOBLaepmprUd5k1OrBBLygo2uNra6KXfrSno36?=
 =?us-ascii?Q?kZxGMFEiu2Tjw3OVpmWEgeLMZ8wOf1+M2xanKoewJHOM3Ycm2DgR8Bg622fQ?=
 =?us-ascii?Q?i+6L8NhDOXvqiv5b2PQiUrBnmQRW0sv0s8/PcBIjGttgEFj/hUblfEzukBf0?=
 =?us-ascii?Q?YddA8+Nkx7nokc2rEboXPjU=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d5b9a91-0dd7-4b87-c993-08d9f795ec70
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 13:02:34.0981
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4faQkOHmu3vCgdoUHpKlmlXQDejiZ4zJIR0349gHu8fVuG0LWvT85ADc+Chpgmzu67QktOtVUJ/PosgUTCrXdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3665
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10267 signatures=681306
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202240078
X-Proofpoint-ORIG-GUID: bOEW4MtlOIARh6gOR1ovCLvBzhUOGt9e
X-Proofpoint-GUID: bOEW4MtlOIARh6gOR1ovCLvBzhUOGt9e
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The commit xfs: fix inode fork extent count overflow
(3f8a4f1d876d3e3e49e50b0396eaffcc4ba71b08) mentions that 10 billion
data fork extents should be possible to create. However the
corresponding on-disk field has a signed 32-bit type. Hence this
patchset extends the per-inode data fork extent counter to 64 bits
(out of which 48 bits are used to store the extent count).

Also, XFS has an attribute fork extent counter which is 16 bits
wide. A workload that,
1. Creates 1 million 255-byte sized xattrs,
2. Deletes 50% of these xattrs in an alternating manner,
3. Tries to insert 400,000 new 255-byte sized xattrs
   causes the xattr extent counter to overflow.

Dave tells me that there are instances where a single file has more
than 100 million hardlinks. With parent pointers being stored in
xattrs, we will overflow the signed 16-bits wide attribute extent
counter when large number of hardlinks are created. Hence this
patchset extends the on-disk field to 32-bits.

The following changes are made to accomplish this,
1. A 64-bit inode field is carved out of existing di_pad and
   di_flushiter fields to hold the 64-bit data fork extent counter.
2. The existing 32-bit inode data fork extent counter will be used to
   hold the attribute fork extent counter.
3. A new incompat superblock flag to prevent older kernels from mounting
   the filesystem.

The patchset has been tested by executing xfstests with the following
mkfs.xfs options,
1. -m crc=0 -b size=1k
2. -m crc=0 -b size=4k
3. -m crc=0 -b size=512
4. -m rmapbt=1,reflink=1 -b size=1k
5. -m rmapbt=1,reflink=1 -b size=4k

Each of the above test scenarios were executed on the following
combinations (For V4 FS test scenario, the last combination was
omitted).
|-------------------------------+-----------|
| Xfsprogs                      | Kernel    |
|-------------------------------+-----------|
| Unpatched                     | Patched   |
| Patched (disable nrext64)     | Unpatched |
| Patched (disable nrext64)     | Patched   |
| Patched (enable nrext64)      | Patched   |
|-------------------------------+-----------|

I have also written tests to check if the correct extent counter
fields are updated with/without the new incompat flag and to verify
upgrading older fs instances to support large extent counters. I have
also fixed xfs/270 test to work with the new code base.

These patches can also be obtained from
https://github.com/chandanr/linux.git at branch
xfs-incompat-extend-extcnt-v6.

I will be posting the changes associated with xfsprogs separately.

Changelog:
V5 -> V6:
1. Rebase on Linux-v5.17-rc4.
2. Upgrade inodes to use large extent counters from within a
   transaction context.

V4 -> V5:
1. Rebase on xfs-linux/for-next.
2. Use howmany_64() to compute height of maximum bmbt tree.
3. Rename disk and log inode's di_big_dextcnt to di_big_nextents.
4. Rename disk and log inode's di_big_aextcnt to di_big_anextents.
5. Since XFS_IBULK_NREXT64 is not associated with inode walking
   functionality, define it as the 32nd bit and mask it when passing
   xfs_ibulk->flags to xfs_iwalk() function. 

V3 -> V4:
1. Rebase patchset on xfs-linux/for-next branch.
2. Carve out a 64-bit inode field out of the existing di_pad and
   di_flushiter fields to hold the 64-bit data fork extent counter.
3. Use the existing 32-bit inode data fork extent counter to hold the
   attr fork extent counter.
4. Verify the contents of newly introduced inode fields immediately
   after the inode has been read from the disk.
5. Upgrade inodes to be able to hold large extent counters when
   reading them from disk.
6. Use XFS_BULK_IREQ_NREXT64 as the flag that userspace can use to
   indicate that it can read 64-bit data fork extent counter.
7. Bulkstat ioctl returns -EOVERFLOW when userspace is not capable of
   working with large extent counters and inode's data fork extent
   count is larger than INT32_MAX.

V2 -> V3:
1. Define maximum extent length as a function of
   BMBT_BLOCKCOUNT_BITLEN.
2. Introduce xfs_iext_max_nextents() function in the patch series
   before renaming MAXEXTNUM/MAXAEXTNUM. This is done to reduce
   proliferation of macros indicating maximum extent count for data
   and attribute forks.
3. Define xfs_dfork_nextents() as an inline function.
4. Use xfs_rfsblock_t as the data type for variables that hold block
   count.
5. xfs_dfork_nextents() now returns -EFSCORRUPTED when an invalid fork
   is passed as an argument.
6. The following changes are done to enable bulkstat ioctl to report
   64-bit extent counters,
   - Carve out a new 64-bit field xfs_bulkstat->bs_extents64 from
     xfs_bulkstat->bs_pad[].
   - Carve out a new 64-bit field xfs_bulk_ireq->bulkstat_flags from
     xfs_bulk_ireq->reserved[] to hold bulkstat specific operational
     flags. Introduce XFS_IBULK_NREXT64 flag to indicate that
     userspace has the necessary infrastructure to receive 64-bit
     extent counters.
   - Define the new flag XFS_BULK_IREQ_BULKSTAT for userspace to
     indicate that xfs_bulk_ireq->bulkstat_flags has valid flags set.
7. Rename the incompat flag from XFS_SB_FEAT_INCOMPAT_EXTCOUNT_64BIT
   to XFS_SB_FEAT_INCOMPAT_NREXT64.
8. Add a new helper function xfs_inode_to_disk_iext_counters() to
   convert from incore inode extent counters to ondisk inode extent
   counters.
9. Reuse XFS_ERRTAG_REDUCE_MAX_IEXTENTS error tag to skip reporting
   inodes with more than 10 extents when bulkstat ioctl is invoked by
   userspace.
10. Introduce the new per-inode XFS_DIFLAG2_NREXT64 flag to indicate
    that the inode uses 64-bit extent counter. This is used to allow
    administrators to upgrade existing filesystems.
11. Export presence of XFS_SB_FEAT_INCOMPAT_NREXT64 feature to
    userspace via XFS_IOC_FSGEOMETRY ioctl.

V1 -> V2:
1. Rebase patches on top of Darrick's btree-dynamic-depth branch.
2. Add new bulkstat ioctl version to support 64-bit data fork extent
   counter field.
3. Introduce new error tag to verify if the old bulkstat ioctls skip
   reporting inodes with large data fork extent counters.

Chandan Babu R (17):
  xfs: Move extent count limits to xfs_format.h
  xfs: Introduce xfs_iext_max_nextents() helper
  xfs: Use xfs_extnum_t instead of basic data types
  xfs: Introduce xfs_dfork_nextents() helper
  xfs: Use basic types to define xfs_log_dinode's di_nextents and
    di_anextents
  xfs: Promote xfs_extnum_t and xfs_aextnum_t to 64 and 32-bits
    respectively
  xfs: Introduce XFS_SB_FEAT_INCOMPAT_NREXT64 and associated per-fs
    feature bit
  xfs: Introduce XFS_FSOP_GEOM_FLAGS_NREXT64
  xfs: Introduce XFS_DIFLAG2_NREXT64 and associated helpers
  xfs: Use xfs_rfsblock_t to count maximum blocks that can be used by
    BMBT
  xfs: Introduce macros to represent new maximum extent counts for
    data/attr forks
  xfs: Introduce per-inode 64-bit extent counters
  xfs: xfs_growfs_rt_alloc: Unlock inode explicitly rather than through
    iop_committing()
  xfs: Conditionally upgrade existing inodes to use 64-bit extent
    counters
  xfs: Enable bulkstat ioctl to support 64-bit per-inode extent counters
  xfs: Add XFS_SB_FEAT_INCOMPAT_NREXT64 to the list of supported flags
  xfs: Define max extent length based on on-disk format definition

 fs/xfs/libxfs/xfs_alloc.c       |  2 +-
 fs/xfs/libxfs/xfs_attr.c        |  3 +-
 fs/xfs/libxfs/xfs_bmap.c        | 87 ++++++++++++++++-----------------
 fs/xfs/libxfs/xfs_bmap_btree.c  |  2 +-
 fs/xfs/libxfs/xfs_format.h      | 71 +++++++++++++++++++++++----
 fs/xfs/libxfs/xfs_fs.h          | 21 ++++++--
 fs/xfs/libxfs/xfs_ialloc.c      |  2 +
 fs/xfs/libxfs/xfs_inode_buf.c   | 78 +++++++++++++++++++++++------
 fs/xfs/libxfs/xfs_inode_fork.c  | 51 ++++++++++++++++---
 fs/xfs/libxfs/xfs_inode_fork.h  | 61 ++++++++++++++++++++++-
 fs/xfs/libxfs/xfs_log_format.h  | 33 +++++++++++--
 fs/xfs/libxfs/xfs_sb.c          |  5 ++
 fs/xfs/libxfs/xfs_trans_resv.c  | 11 +++--
 fs/xfs/libxfs/xfs_types.h       | 11 +----
 fs/xfs/scrub/bmap.c             |  2 +-
 fs/xfs/scrub/inode.c            | 20 ++++----
 fs/xfs/xfs_bmap_item.c          |  3 +-
 fs/xfs/xfs_bmap_util.c          | 24 ++++-----
 fs/xfs/xfs_dquot.c              |  2 +-
 fs/xfs/xfs_inode.c              |  4 +-
 fs/xfs/xfs_inode.h              |  5 ++
 fs/xfs/xfs_inode_item.c         | 23 +++++++--
 fs/xfs/xfs_inode_item_recover.c | 85 +++++++++++++++++++++++++++-----
 fs/xfs/xfs_ioctl.c              |  3 ++
 fs/xfs/xfs_iomap.c              | 33 +++++++------
 fs/xfs/xfs_itable.c             | 30 +++++++++++-
 fs/xfs/xfs_itable.h             |  6 ++-
 fs/xfs/xfs_iwalk.h              |  2 +-
 fs/xfs/xfs_mount.h              |  2 +
 fs/xfs/xfs_reflink.c            |  5 +-
 fs/xfs/xfs_rtalloc.c            | 14 ++++--
 fs/xfs/xfs_trace.h              |  4 +-
 32 files changed, 534 insertions(+), 171 deletions(-)

-- 
2.30.2

