Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10441C433EF
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jun 2022 12:41:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237494AbiFFMlc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Jun 2022 08:41:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237486AbiFFMl3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Jun 2022 08:41:29 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B967625DF9E;
        Mon,  6 Jun 2022 05:41:26 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 256BIbEG011625;
        Mon, 6 Jun 2022 12:41:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=xTEZXqmsW8pfOOMh7vqp2RvZf8EK0/BN5x0DpN08ziM=;
 b=svHvhBA0nL0okwM02T62nOD7ZezlGD4ftuEZXR916k1PTm2+IGM6EjmZlE516Tr9GS7k
 AUV51G0AKi0EhfrxL5uHjFUmVycQoYVmrFJaU7HDsQi0KTkBIuqxbasdKmK+CiGIIFjr
 gpGs8GrSDMaM3lHDvWuqi7IX5LzusU/lwYArhzF7XqGRkcxp54DnHN4ubfPC/1Pw5Raw
 FBDtt5VHCBT3ezEMBcuIZjd3dDz0DJxyWvMHEdilsYm+yOISrZzJUfFr3KeRFN1Wovre
 bZ9OxN4z6naYSAYuBqe6WS0pmD7xZ2Y281djdaBqpJmI0GSKjnWgJHO86138Rsq0olNN 9w== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gfydqjyms-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Jun 2022 12:41:23 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 256CGDYe005014;
        Mon, 6 Jun 2022 12:41:22 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gfwu7mb07-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Jun 2022 12:41:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fXFGnmkvQEvF25AfE1uxi1cqvthBiAjvEZODfePzhx6QQ4E0PTmf6wjf8lMP+p1mRiD9qfK7RdmXngTV3DqUQuOg2ulXcPufGi4vbtzggJ4aOE+w49zP4lErFuX37UgkTwnb1YqmKzfySQFONytm71iLzUpFn7GzGmWMC9R1UyBdJ8kBoI7f/2osFta2UHHC3qfapPU21QO2iU83foMcjoWPbSvAHppNhsSGTsnozxigm+PaFfGNMeBBI8fv4Xn0S8r4b0lLdWPQZRhGtF324UxvjQXi3Eg8wn9SE+TV/7EegQj3LDCdtWfdZHLB22BC5L2YaVGiUOgGAHQcA/ONbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xTEZXqmsW8pfOOMh7vqp2RvZf8EK0/BN5x0DpN08ziM=;
 b=g6bWROSaUjQ5nvOksJpAuWZKschCxSRW/lUjpZtRcQzTuCv/tcrS/5NJUULLMOLU4y2CqXep+WWGFyityhzqHSlMOPnWLbHesIUUgciPlWCWTSaS8rUH4Y4Juc+AdR9Xj5kdFsUlmNsDTfMPZZ1vpVaCy0iOfNRng86SKEvCgMeUIiYlgEDoshN9hJ+J8mCRoDydId9dzCg0P4kwH87FcG8CAaP4mtKLGamh6gfJmXviAo6O/H7iYPnXTWprA+UvnK607miunI/Y97VS7yutyR6x4v+9IsDgpscdgUKF58mxVb77SRCZohZOaqQDbUzg3XcpJEaBESPNZWOTv/lj6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xTEZXqmsW8pfOOMh7vqp2RvZf8EK0/BN5x0DpN08ziM=;
 b=rP4SHguBJDLSe2w8fzPJs5DykghVTYIVW3FGqh5278EfR43+5TDHzV+vk5u0nNjXWJSpeABuVofud1gMl8o6/Zskf3/rjnwfgtoBJF79NyxSCMFcDTZBlkTLFX6o2Hd1Ct0OIa4zPy5nP0irSU7FbOZnpQ50mNunWwLIpxrqAZ4=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by DM6PR10MB2523.namprd10.prod.outlook.com (2603:10b6:5:b2::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Mon, 6 Jun
 2022 12:41:21 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::5476:49e9:e3eb:e62]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::5476:49e9:e3eb:e62%5]) with mapi id 15.20.5314.019; Mon, 6 Jun 2022
 12:41:20 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, zlang@kernel.org,
        linux-xfs@vger.kernel.org
Subject: [PATCH 0/4] Large extent counters tests
Date:   Mon,  6 Jun 2022 18:10:57 +0530
Message-Id: <20220606124101.263872-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2P153CA0031.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::18)
 To SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b661280e-caf2-4d4b-6507-08da47b9db89
X-MS-TrafficTypeDiagnostic: DM6PR10MB2523:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB2523CFF99A86DE2613DEEF5CF6A29@DM6PR10MB2523.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LmlGoQH29eaVYRdVrJGT1c/xAu3CsJTCelfCj2ohD4oWyQPy3oq1UrdXUkiNR4AwXG1PHOKEsjuy+4ahH7oGGPpxTn2zbaSBTKUul/FwmIxIroSp4844jfKizWCrthzF31EWZJU/HKGnEfpsqUTRJI1XeZUXnHv/YzFNv1kWij7SOTuY2p5jlEybPBnaucwXjWs7zBRL4G69RChsCbzuULjCbBIKuSDLIudmJ24oHtCagxXBp8bhFX49SkFKXlfOGdv81rHFSIdTrWMy5e4LJwFRj59yrSS7MfDa0rX0iavIUYia7PEoFH10bVXo6Y8CMvSATW5VOS75W82JcROqrvS6QCRmW6Gw/sz0dy3XS67snkkPPAGL1RpI8pb2WnEZkDH0Bs8RvCJkgDyJI/lFTtbv+Rh4rqFJs0wf4WOrWOPM4cDvxMc85TFLh7lvd18Iy5PgKaM8mpruZnWis9tHtZqDQmA3CiHjVNZhZnYUdMjaHSyoQsk0Bs8e0OmoV1JbObnXu4YDLOSNqz6qQyoa50BeRHPzrrXnZgrXtLNDLNk8iHi7Dq66mycKEsNWvjdKcBny5IB7Q+wv7kTYKv9Tp/5A1pwCiXbyKUu6doEoXOfC8sV+1nxYqaAzoVYfuqwiY2gDcdvKfMAnttAjKThY3z1kvSoLgnSLXcbbe1jPP/KFTyRFvHBus8uTA2vkeTLwi0CSbebVAWZvtq6lhvucwg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(6916009)(2616005)(66476007)(66946007)(66556008)(1076003)(316002)(6666004)(6506007)(2906002)(6512007)(83380400001)(52116002)(508600001)(36756003)(8936002)(4744005)(4326008)(26005)(6486002)(5660300002)(8676002)(38100700002)(38350700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QcV80jOSlqkgJXVUIBWvptyVsBwxM0EFHSCZxlLIfQlT8ARnbXloGXDTrg2v?=
 =?us-ascii?Q?xH5KccItRj6jsEG6FpXFhHurPClF/oeAAA+4GVbwPvuSz9lW/BJeXK9uPkQm?=
 =?us-ascii?Q?5RV0EEMP052a1sPSrrHOWxA+CKclUysPy1kSjhmMzyG7VPKJbLpWHG4r6m6e?=
 =?us-ascii?Q?E223HKiA8+r0zvggejJTL8wcIJpPCYOnupZk+hPWzW0sbOVMFpRLOBbR+9c2?=
 =?us-ascii?Q?FVmzIuVYYF9wYyKD+3AixCJp0Xdgt5mVroNfYp9nOp7d/iW1netHPSYFBVxf?=
 =?us-ascii?Q?HlgvrfLVsZjthw+SyXzCIom3Q+7V/zr9daxjtwPlDMCcq+6cOne1YhPfP0kq?=
 =?us-ascii?Q?oTMaLVUM5NgWGSnqDzhwcU4JoUMkEMxRAO+AqcgqoNwJ5AclK+ADdTE4gWI+?=
 =?us-ascii?Q?pbkgSQUYjvGfbbHFGvbQpkQCAxIcYL96E74yE0EO/OFPJHZJc48yJZHlGClf?=
 =?us-ascii?Q?3Ju+VZB8gQ4zkSOIPPcK55eCeHcHv5jEiFVvdKu8rZWXpcHmxeDBc824kzbX?=
 =?us-ascii?Q?wh6kTmi6RevoO+qADKKmBSGK62IIQjNIemxqIq3ASskqcOmr5IurR4JqsAjn?=
 =?us-ascii?Q?V4qFYwKGlaWZgkgDra2Ji9/6MkRXuM4fdQicRJWcqmj/vHS1OVUkIQcPExPP?=
 =?us-ascii?Q?eWu1pnwBiaQlKqSkekcyqc+k0L1x2qjJSXfnPh3JgdBhtiLLtbBB+wjX1qhL?=
 =?us-ascii?Q?iBfctnYmoZPt+O8S1fP4XDmwTexPbqIeh5711O3WQOpoNLlzUUUPdYUuaOwM?=
 =?us-ascii?Q?eGSWSKfheVQK6WxXyiDkmNjBmev97aBElrPvIudMx26UvTUYnkDIgYfiXpan?=
 =?us-ascii?Q?muSLl70x8ZXGammPv9XuQpVJQmUiaFz7yaqgLU/wedAsmxVvc2j5oKYUZ1Ys?=
 =?us-ascii?Q?qR9KQWEi1HAAg2FYJ7fG7JbDuklO6rByiwhR5CYSn7ai3rld7RVkV/dyzvuq?=
 =?us-ascii?Q?TsTaAutDOU5K0P4cxIbt+0PVdB0zJgnN6AZTdgsGXtjgfrZCE3gpPgS9orgC?=
 =?us-ascii?Q?OLDpIWN6mV/lVxy5FAP6mY3+iNw+qoZrdn0GpRBsDBg5mr07j9aJjdUfEyf9?=
 =?us-ascii?Q?U0BUR+jJxRd1yLmrKm2bInzPPpmE8UYh6jUNck4gjrYw6b4nYqTci63EWVB5?=
 =?us-ascii?Q?crhwm+gGIP6oNdiVZZnmq9fc45eHAXsKF7mkFkWHkM1EEjoPAW3RHryMeJ9F?=
 =?us-ascii?Q?m2lYJexK+yqDO8b+0oB8yhoSCUi1YQwU6Q76Qd+s4mFKLjr6Gyw2exJApKeg?=
 =?us-ascii?Q?i8sD8FcSFoSgbu5sRXi4vF0eWvgOBCUV6toFb+P3b8XVgBPEYX3f8QWbTO/p?=
 =?us-ascii?Q?Nz/tEBV/4Y97RGECXzuQH2kddSmNWdavN2RiI0C7IS7k4oK0yPvvA0PcoFRe?=
 =?us-ascii?Q?SavTPlHr3bo4HTp2lH8oUkG3Dwjosf8UtHgap/0aeS0KvWasJG9xp2PWnwPK?=
 =?us-ascii?Q?jcSHJvfBtOsRD0PvdUOr5qg3dg1ooyglFu7wBD+uX0MTkfXGW4l+H3B1acn3?=
 =?us-ascii?Q?q2GpTvrIlNYQzYfXCltb419PkNMZYDVknpS5gPewz+WZnVE+FUsV64r3i0+L?=
 =?us-ascii?Q?TJFEU396si9d5Qfg6plbWxw+ZjuAHPskeiqE7XwkLOc8HxP1vSzgiFa+guzv?=
 =?us-ascii?Q?6uNpI8NoffdICrjIEF9Y/Fn4BExyINe4oQ48TeOyx+XzK2ECznP/QpcvnI39?=
 =?us-ascii?Q?4qupD6yTynl3wzCYEbEukOZpg1EpkCFI6zhauavlD36fT5dINWqif+EL+DFP?=
 =?us-ascii?Q?4lHGg9qN6GmzZrNTcSqYIGiSY5zA/N0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b661280e-caf2-4d4b-6507-08da47b9db89
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2022 12:41:20.8925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NsdmIrqRXSXS2t6/3GqWpAki3uFdSpjwCgQ05QztT1FS5cxSPeN/FkKQK7KjV60O4KD/4kwXUnmkh06WMzP0Qg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2523
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-06_04:2022-06-02,2022-06-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=809
 adultscore=0 bulkscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206060057
X-Proofpoint-GUID: WNVaNh8KszAeXiuR8N_bbl55ZvEb1kPh
X-Proofpoint-ORIG-GUID: WNVaNh8KszAeXiuR8N_bbl55ZvEb1kPh
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

This patchset adds two tests for verifying the behaviour of Large
extent counters feature. It also fixes xfs/270 test failure when
executed on a filesystem with Large extent counters enabled.

Chandan Babu R (4):
  xfs/270: Fix ro mount failure when nrext64 option is enabled
  common/xfs: Add helper to check if nrext64 option is supported
  xfs/547: Verify that the correct inode extent counters are updated
    with/without nrext64
  xfs/548: Verify correctness of upgrading an fs to support large extent
    counters

 common/xfs        |  13 ++++++
 tests/xfs/270     |  16 ++++++-
 tests/xfs/270.out |   1 -
 tests/xfs/547     |  91 ++++++++++++++++++++++++++++++++++++++
 tests/xfs/547.out |  13 ++++++
 tests/xfs/548     | 109 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/548.out |  12 +++++
 7 files changed, 252 insertions(+), 3 deletions(-)
 create mode 100755 tests/xfs/547
 create mode 100644 tests/xfs/547.out
 create mode 100755 tests/xfs/548
 create mode 100644 tests/xfs/548.out

-- 
2.35.1

