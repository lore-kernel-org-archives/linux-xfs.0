Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA3CFC05027
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Jan 2023 01:36:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbjAXBg3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Jan 2023 20:36:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjAXBg2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Jan 2023 20:36:28 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D705D11EBD
        for <linux-xfs@vger.kernel.org>; Mon, 23 Jan 2023 17:36:25 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30O04Hgq013021
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=oeRQ3WQPzOibj3HgmyqQ1X5FHRQz3qQUvJA7mz3Q9UE=;
 b=bUsx0n20IKb3lCkArx0AbqSOzyhO4fTDW0hK7yGZTMg1r79iaUl9jChtIdTGfJ9C1Ivt
 88Sa7ZKefXA5szkdhkeywSUjDbYw82RR25K2VOtO5nual79oub/JX/h3XJ/Nq9HZnTPQ
 pYLmdTZwAz7uEcAqMC/Nb3wm142tQdncRYNRL8kFVsHc/kBgucEhvA8bkmLXnRjISREm
 cyfGwESF66HrVAUgw9Chf/WtdjZfR2NEyJlRj9r6TsUmTsfbPJBBEkEwJifKh1MHex1Q
 y59YtXJGruZnEjDzZHtrv71nzo4PIRQznkb0iw7xF330xxhWvYZo/VCty7Z7FO8SYRbx WQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n86fccbxt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:24 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30NNMbNU039566
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:24 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n86gb4apr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TPEVd7hGr28De/77lXXsbxfH1lcBG1e+UX9crfii+ZRYWlfSep0dYUY0HVOWnSKVELalHdjK1l+OXsAi0MRv0ADnMrdb3XLldmXjlylEVUigTNWCfBaI4JRx31STUygnFXQ6UIC4TkrwnrF3+oKITomBCW3AaEomTziuERfSxjBNbzAI0OjZa/D49Ld9zGIDEEt6ZV3Y1AKrnJXhCozFAAVEu7aSXbAmGsKvazA9MFI54zCw95JgjD2uQ9vuZ9ojBVK4pWAC0c+JgEOGUPR+VjBf/Dmwv3Es4LY/zxkTE5P19JRs9TbK2PQW0PU+2wN6m4ePrWZvrXWq1WKvZPz8aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oeRQ3WQPzOibj3HgmyqQ1X5FHRQz3qQUvJA7mz3Q9UE=;
 b=YY6vTQvMLC4McenNCPkASnoXvTeMdoTCqkcYORkFXRTcQ0VgSjB1pEl6KhSXf76E9LKfECfzjmIu2jemBBcrzx3Wipgxu4f1JYH25uEE/ShfNN8Vo6HKawJe5TRF0HWmTV/sdf1G6GrMtZYgzF/G0zJLLdMPbstZRaL4vu8wl0Ov611aQKxGpcfkPxUVwX9nt1UrTut1legpiez0KfLv0n8LqJ9zc5H7d9c3PCqS/Li01IN5F4+pA5UhqrRTydGpG94qatkifLrTYdPdtnU3VDYZ5musyyreXFJTMeyWHgobU8lkgNYqwL5ByVngbIycSTQX1jjzaeyLgAvxaZwBNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oeRQ3WQPzOibj3HgmyqQ1X5FHRQz3qQUvJA7mz3Q9UE=;
 b=lvo6n10K7uFzbAWcGm08xvfGm+ZNrEe+VibHW8qIqiKVO9h3UG0FxTZ7WW/XK4/MlN4jh4sy1w87jXcUnLwIHW1ZcP3gwjpNWWnqmyZDT98Narw2WC6nxBKu2iF68SOpkA+ehMPMBlc9VES354/ALcQtA58qHu/2boAjQndu3Vo=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CH0PR10MB5052.namprd10.prod.outlook.com (2603:10b6:610:de::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.16; Tue, 24 Jan
 2023 01:36:22 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%4]) with mapi id 15.20.6043.016; Tue, 24 Jan 2023
 01:36:22 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v8 00/27] Parent Pointers
Date:   Mon, 23 Jan 2023 18:35:53 -0700
Message-Id: <20230124013620.1089319-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0029.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::42) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|CH0PR10MB5052:EE_
X-MS-Office365-Filtering-Correlation-Id: 220c38ae-e40f-40d6-8728-08dafdab65e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0IEVBkM0KjS3TRVZgMI181uTXpzeHwtInJEkAAgB/DhUW9ZC7cHAKeeyMeboFwmsC+a/ofvm3H5/tQNG3DuE3XY+HKBUwvRtTm5/CHAwQk/XvOdz1INMLbjgawMCfO4B1JiGK0YY1ieLGDHxD/5yKB4xX+e9X2dWtiX9stV00okQJKVcPNoZEfV5r0oMsr+gDtLAhf3wKzBeA3K629zUl42rx0/tty/S0+X6zWFFXT0RyNiGJ0JOWMyFmokYf4WI8bgLfCbdPFMuFWGLiQs0UpczgDkU+Oylppbfhu7RRfEzUfO6BpyE880jtbb/910iwa8DREgSN5jB3xEO4gOFYyY7fB2F5ZTyLqmtJ7H+LkrSb6o3jDVU0Imt1+DJ8czD4zp4Dn2SRdL0Si6NF1o4A4//5erx0EPiSLzKYltRXhxR1/jZgm08qyOb6nVZ+0fAoZ0OHu5tEFMT7fv9xJXYknc0eA+pUU4E17BKkkfZFRSBBi6HQZYAprXo2DsySTDwVvuCqhG9vQhZ9MVR12+FgeoUIe2dIrtZyKrV6mv3aMkb9orWR1Lmf5xN0hoiXbyR8T/TgjkJxP7j1eFm8n+8h8hmJRVlqhay5dG+Q6DOu5XTOvzwWTMb7WsBcs30eFTUGTMSOt4csnkHwyY9Zp1qxJOz8SKrjhoRtsWl6QOEj+PVQSAhFJbKVpbq2RYR6Ivm3t5c9kGX4P+ohPR43zsifA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(136003)(376002)(346002)(396003)(451199015)(1076003)(83380400001)(2616005)(86362001)(38100700002)(36756003)(6916009)(8676002)(66476007)(66946007)(66556008)(9686003)(5660300002)(2906002)(41300700001)(8936002)(6666004)(6486002)(966005)(478600001)(186003)(6512007)(26005)(6506007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pIPdtoeVLeTpsEPqA+ID1ESGXpkkmJ4Dd8mjZMJz43HMAVKoThL8S0GYRLIL?=
 =?us-ascii?Q?ArMwVlPBGGbtMUQe0r3JJOG0corn/ihSJgSKDfnMs33BnHbtYU3eP2GHZLNY?=
 =?us-ascii?Q?umxYh8xdif/IynyNPrvi2Oxnyu2e2fwpL1hjxpKB1RvBtDnY8aJiW6xHCxJE?=
 =?us-ascii?Q?KDCQhEB5y66wHUvnT7GESdPeyeHwf45d6ZxESqbjptLLEn3xIBcBTzcAl409?=
 =?us-ascii?Q?+7zYI24CdJsUEMTYPM6OZySCvwiMHE8hRc4aEhvp5XLr9kaPYSIJd4UVOtmP?=
 =?us-ascii?Q?r7WbV+9HUUl45xAXDQQmHrf+H1TdSKphxeo7MncwyVQacIe4g3cE5DVLlwEA?=
 =?us-ascii?Q?7wnLoKxOCychuyE7YWoQlas5diPIEIzJie/ZfPjfFQRLyvH5w4666tpKJy7g?=
 =?us-ascii?Q?uVJnjKq1EeF8lm4HVjNC8ke1K7vZOPCn9QvtoPK/S1WGF96FVjm/53gufPJB?=
 =?us-ascii?Q?YzlLWFN1oonZC8HoKk6khjP87bys9PXC60qr71QyuXpxg1Fe8Plm5Siu9vr4?=
 =?us-ascii?Q?Ds6b9ov2fqm32D2SwMsdGA+Ft/cieZn0WA+Qjs5OonDFF45mTksjh38yOMV4?=
 =?us-ascii?Q?JMKarFPUKZfaKGjLfudMTqaMeQP74HiIom6K7YldNuIaFgob9/871QS6j8eJ?=
 =?us-ascii?Q?w/+kVObnA1xe8hNDzsRal0/eWxwAtfVc3UCWxmX0fo9uvDleuomGpmFRm0tl?=
 =?us-ascii?Q?v/clc4Zu9UOsFKZCO4QCenHkObZKDSGPCwv4BjJg2bwnBUbPD1FXGAM54dKz?=
 =?us-ascii?Q?s3PaEdAf9pIXuUH6u5HA1srWmzH5M2Se5r6LX7KR6bfYqMwLI4gOqEy5R+jK?=
 =?us-ascii?Q?lb51Z1bE1A+BBzdx3HcRVWSuWXx0u28cO/7Qach/1FYBVHpILLMijoIc3QI9?=
 =?us-ascii?Q?diA/kyQsrXajenbyKc/zDxW2QcnSmsGp36UFcYrcIPYLPE8kW/iHWDg5YBi8?=
 =?us-ascii?Q?Uk1onmpTmE8P9mzIxwVi0ikeh4TAfeJ5RP3WXmtGbnuA95zC9b7oGz1LZX9A?=
 =?us-ascii?Q?QpkTf1NzZDDrpOs/YKo2BOytiX62qIi4lB9p/CMJiR+cgjkxUv9n+fq0qsHv?=
 =?us-ascii?Q?MsuMpsQHYCmzgO7Ga8mCAigfYV6zPZuZSzmZRlluFWjWRK+gOaVWLRMpUAWu?=
 =?us-ascii?Q?4fR53c9DHukDhqDtdPq0fMDd4nb024Wym6kAJbFAwLCQQtWrtly/2/32fjzN?=
 =?us-ascii?Q?LJiyBFcDnhf3KiYKNw5IRArABjjecJb1nEZdqEz1J46Bv5dD8Gb/jHI+WBSZ?=
 =?us-ascii?Q?ygDhPfVDlmZSkfetV/ie7QdTVYsvnd68Ird+Dc9A2hfRwNjtwWJNBQOMFtYy?=
 =?us-ascii?Q?Y1CER66DIz+4LJxR2UWV9OVvP6GGj5h56nijd0pIwBrCDB2dDGlMFRhDIWV+?=
 =?us-ascii?Q?MpGegBXl8cKa5kNvJ/RUQ5mQd9PQ3gx5yueaskkPhEDY4U4sOYkJSSQyOJ3Y?=
 =?us-ascii?Q?/56MrRvUU8usAmzqMfb1CI4lpKEDkbco8+K3Ca+1RopN4IZeoaa5IsqHKvPH?=
 =?us-ascii?Q?DGvS2lZTRMkmS0nixT8fdnklpwsyNuEjGGiD8vbcwJmOWG3xRYy3IUaIavWY?=
 =?us-ascii?Q?U9jGCa0218iUhNueV1otlGZe8fs8pLGachYBHQ7dLRuVAaBbPyfoEwAa2OBB?=
 =?us-ascii?Q?bw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: eNbCsznnpjuIeKV3EVPXMRwg3zeQYzfy4hjVoegqc5SJjzPa2ObKTkUk4ArbSYSGd5Yl2+PD4ONDJSW55pj/EJLPWZZUumrz3UufQRLg6YLcE1ivtMA4zE+xfKqkVHVG+4RQUhrI9Tlknzz2JzsAKU42ZKFNvdiDe9EthsX9J5lkgbxgioSFP6OUIVtqJOxrgZFRTJmPM5MMF2I3nSBGMrNOJBh3nWhSqL40LTfvIIeVKnWbsOCyBRtx5c7eOHgC6Oj5TVwxIFwMj95vCCMU0OIKAI6HSSOQw2dDVIrCDCw0Xj6i+DhBVH78yOAHgPxHt0Y7xvjI7O7BFt3O6u8eoJSkQA7fJtpUkhw/LB3NOmGn7GNwBx/J/cm+BiqMpjsGN345gpqTSXci5odYH36M2DlYlbjMhPhGV1wHAmZwqb0ivQtMtfLyO4tlzvFnjKchRSQr42oEPtQG9kyklQGyaY9F2cRIz/SeuhbaNwr5Ch2dFm/EwlGypuc+m0K/h2In8XQcmT3SGhqFMx1Bg7zd2vNvOL+7tlPPpq2Qt/+q1fwpL4zCkktDmqiMKFwNGOGnOXIx8PD0VZjKifDcctYOP9ZlUlviqmGUlOdd/WD6uyHSMx2z6PrRjG8X+Vo8DK2BtPOB5aKvAQwoLOJSHwd4yDr046Be1aTaJbEkcjg/1oktu2tjbaAW073DOMlfAa2wcAla4qvT4TFJyl24kBFva66ssiWyc2le5QhkpbLuC57bF2AN681cIputcgxa25BVVfu9xHVJU8TZylLAMJRAqA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 220c38ae-e40f-40d6-8728-08dafdab65e8
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 01:36:21.9037
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kaNQ3hE6eqExZIldQDWW/sHOgHCn+d/N/9UnFcvtIRnSO3HyKCV0OBu9znqjwRYhskDrJ9Yb2UFV1VkyZcf720awpu37y7+V1sETA8PYa1c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5052
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301240010
X-Proofpoint-GUID: h_YS5E7iJgSSHNx6hHFW-2u9IfLp3N_e
X-Proofpoint-ORIG-GUID: h_YS5E7iJgSSHNx6hHFW-2u9IfLp3N_e
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Hi all,

This is the latest parent pointer attributes for xfs.
The goal of this patch set is to add a parent pointer attribute to each inode.
The attribute name containing the parent inode, generation, and directory
offset, while the  attribute value contains the file name.  This feature will
enable future optimizations for online scrub, shrink, nfs handles, verity, or
any other feature that could make use of quickly deriving an inodes path from
the mount point.  

This set can be viewed on github here
https://github.com/allisonhenderson/xfs/tree/xfs_new_pptrsv8_r1

And the corresponding xfsprogs code is here
https://github.com/allisonhenderson/xfsprogs/tree/xfsprogs_new_pptrs_v8_r1

This set has been tested with the below parent pointers tests
https://lore.kernel.org/fstests/20221012013812.82161-1-catherine.hoang@oracle.com/T/#t

Updates since v7:

xfs: Increase XFS_QM_TRANS_MAXDQS to 5
  Modified xfs_dqlockn to sort dquotes before locking
  
xfs: Hold inode locks in xfs_trans_alloc_dir
   Modified xfs_trans_alloc_dir to release locks before retrying trans allocation
   
xfs: Hold inode locks in xfs_rename
   Modified xfs_rename to release locks before retrying trans allocation

xfs: Expose init_xattrs in xfs_create_tmpfile
   Fixed xfs_generic_create to init attr tree

xfs: add parent pointer support to attribute code
   Updated xchk_xattr_rec with new XFS_ATTR_PARENT flag
  
xfs: Add parent pointer ioctl
   Include xfs_parent_utils.h in xfs_parent_utils.c to quiet compiler warnings 
   
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
 fs/xfs/libxfs/xfs_parent.c      | 207 +++++++++++++++
 fs/xfs/libxfs/xfs_parent.h      |  46 ++++
 fs/xfs/libxfs/xfs_sb.c          |   4 +
 fs/xfs/libxfs/xfs_trans_resv.c  | 324 ++++++++++++++++++++----
 fs/xfs/libxfs/xfs_trans_space.h |   8 -
 fs/xfs/scrub/attr.c             |   4 +-
 fs/xfs/xfs_attr_item.c          | 142 +++++++++--
 fs/xfs/xfs_attr_item.h          |   1 +
 fs/xfs/xfs_attr_list.c          |  17 +-
 fs/xfs/xfs_dquot.c              |  38 +++
 fs/xfs/xfs_dquot.h              |   1 +
 fs/xfs/xfs_file.c               |   1 +
 fs/xfs/xfs_inode.c              | 428 +++++++++++++++++++++++++-------
 fs/xfs/xfs_inode.h              |   3 +-
 fs/xfs/xfs_ioctl.c              | 148 +++++++++--
 fs/xfs/xfs_ioctl.h              |   2 +
 fs/xfs/xfs_iops.c               |   3 +-
 fs/xfs/xfs_ondisk.h             |   4 +
 fs/xfs/xfs_parent_utils.c       | 126 ++++++++++
 fs/xfs/xfs_parent_utils.h       |  11 +
 fs/xfs/xfs_qm.c                 |   4 +-
 fs/xfs/xfs_qm.h                 |   2 +-
 fs/xfs/xfs_super.c              |   4 +
 fs/xfs/xfs_symlink.c            |  58 ++++-
 fs/xfs/xfs_trans.c              |   9 +-
 fs/xfs/xfs_trans_dquot.c        |  15 +-
 fs/xfs/xfs_xattr.c              |   5 +-
 fs/xfs/xfs_xattr.h              |   1 +
 45 files changed, 1731 insertions(+), 246 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_parent.c
 create mode 100644 fs/xfs/libxfs/xfs_parent.h
 create mode 100644 fs/xfs/xfs_parent_utils.c
 create mode 100644 fs/xfs/xfs_parent_utils.h

-- 
2.25.1

