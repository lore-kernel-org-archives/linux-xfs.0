Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D1DEE732D0
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Sep 2023 09:55:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232905AbjI2JzC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 29 Sep 2023 05:55:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232746AbjI2JzA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 Sep 2023 05:55:00 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A261199
        for <linux-xfs@vger.kernel.org>; Fri, 29 Sep 2023 02:54:59 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38SK8mYg013119;
        Fri, 29 Sep 2023 09:54:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-03-30;
 bh=AxblYY9xyGrGc0zL7uVmhwR5VcTELR/bRXflEjsaH+E=;
 b=eTd7/SdoFlit+sE8qdTG4chh7kBNUfHzu8X6qpNzLZSwtuzonsbTPxYtDp5IhlNuVEoR
 OiXbhsyAMCmxK6KSGOQkSJW3VThUuFc1b6tYOKaAhUy9+fSfLm5v8//o88ALihvEpmUa
 TWBFTW6g7upwYqgUs7ja8wUIRYEd/XKTLopc05AL2kwBt8+8idykBnh+7GQMrgvoAxow
 zpqXsi7miQ6fGQZGsct+VyOlTyPmAxfijC7Lcf4qiSgWRHBjv0yrnhXMpfxGh7oC4DXE
 3MC6VI+c6RQEhbehgUBnSunLoNckA+bcQCYbAj4OF5ut5u+335tgqOBxvWvdwlBcW9xQ HQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t9qmupcec-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Sep 2023 09:54:54 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38T7bmIb025296;
        Fri, 29 Sep 2023 09:54:14 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2170.outbound.protection.outlook.com [104.47.73.170])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3t9pfh231p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Sep 2023 09:54:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hJ5VEjnx5NT7OuBIEDuiixN6tjm/NtxUsQx8L60m5mWr7Gguu2uWD0Lb4qsj+qukxpTSsjnX7UPK+5jOG3L9nVybshbykSRkA4gpX4xiXXbekGzav3RKnHptWUqA+fUI//lNRXMJookxeN//HkPOui9X7VWQd5w1x92PW3fx3wZkKDgy1PN3Mi+9oTeyM6q96zFR2Hr2LnqKGXUjzCUq/pQJft/dStDY1zlY8Cd6WVDrT90T290nrLpEJcyc2f2lqpDWIizpOPXtrL7gJwDRZtfNdVn6wVxjkbUHXO/tLeMm/U38WvYZEKdZhJR1zfQKvg1rJo3pDmJy2KNTRy+tVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AxblYY9xyGrGc0zL7uVmhwR5VcTELR/bRXflEjsaH+E=;
 b=jX8vQQKkpVY+1wc9H4wVU4Z17odtGWgZhJczWBKWt4TRY5ZE6CKkjtCDk8E1f9/BPsAP1HgEnb4qstTllb8ap1HsS9Ib3w3sOx0QGXKzHlKVSwftCxNGg4KcNmhhmu0WTCBF4n2/BqL0+5AVfno0+v7+19v7HBiVNBY2rRnwogAevDHqWqTFiZt+8Lgzvp4MqXno4gEXI2pOjecDB+vWxW1XqpTGy1+VyqFzIDP9ONQBuRg7s0rhxcilWeTQu5QqsRB00Lqc/a+VFdPbv5FpuFXl+4sZ5DTDrVdEpOfHrucmLHTr1FaPjr5NGShsAkilLd3stVEUvW4WYVdQ+egzpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AxblYY9xyGrGc0zL7uVmhwR5VcTELR/bRXflEjsaH+E=;
 b=z1o0krDVbT60x6Bz/4KFmrH2EtRWnvbYGYZz5cbtuPnZX5p2cTuWNS7fvucwllH1e1xULqikjJgb41jjYGgGMctfQ+e49xXBn8lgqRLJmpTW46PS5ETOkMMD7jXCo9ZVRd64kcVawkpven+f5j3SG/RFcs/kOFvSAWlk6WhLnU8=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ0PR10MB5742.namprd10.prod.outlook.com (2603:10b6:a03:3ed::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.21; Fri, 29 Sep
 2023 09:54:12 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce%7]) with mapi id 15.20.6813.027; Fri, 29 Sep 2023
 09:54:06 +0000
From:   John Garry <john.g.garry@oracle.com>
To:     djwong@kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com,
        chandanbabu@kernel.org, cem@kernel.org
Cc:     martin.petersen@oracle.com, John Garry <john.g.garry@oracle.com>
Subject: [PATCH 0/7] xfsprogs: Enable extent forcealign feature
Date:   Fri, 29 Sep 2023 09:53:35 +0000
Message-Id: <20230929095342.2976587-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR13CA0025.namprd13.prod.outlook.com
 (2603:10b6:a03:180::38) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ0PR10MB5742:EE_
X-MS-Office365-Filtering-Correlation-Id: 17f3f4ed-1079-4d4d-d842-08dbc0d204b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3CgoucBCJinvs9SySaOCMD01zV4kJOq1OlNEPi9ZcE2663ZP/g3VN/YTk3Xwhq2y7aUD+xFUFNa7e3zr/O/VQGAPly2GZBd1KtE7Mt+XHpeDSTdQhVOEYaTzgrevKyX0GJZZaOawUhLVGIpeeQeBH28+tkZu0OaAUWkBJ0A0r5E/BNLwjVJXIioD0F9tz1qkz/m/xPcqGuyx06ZvEFTMIfPyi9VhtSwYZqI9M1RHMvZqtF/+7RNpdv3V7ygT/0u34chr3E+n+4jfuNjAtc3avp2/iupU9cCrsqm5CXv6sQIGv6B0Df2TzePvZMFQhwuD4rcTFTMnWYJvm8tOW7vmQ7FrDKVgB3OMOvLGFXvHW8XOowORpmp7LZtvfr7C0YTOaYlEzVs4dxGsF2F9sK1MWNDyLHLaaB/6JU0Za2qmjzzaJsTBmz0NY6fEgOA4FxGgMGiYHqXtN3oIfnQkkDluOs2BreKrilEQyfO4nWbdmMGiIGaeo3Nmj/Z21e6HJShI+I8G0Tr2kyUEHsjKafCmoEM+O2el7lJgiAOMpJyVmyCi2aUzw8hf7Ft6oN9qu461
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(376002)(366004)(39860400002)(346002)(230922051799003)(451199024)(1800799009)(186009)(64100799003)(2616005)(5660300002)(107886003)(4326008)(8936002)(8676002)(6512007)(41300700001)(26005)(6506007)(1076003)(83380400001)(38100700002)(6666004)(478600001)(316002)(66946007)(66556008)(66476007)(36756003)(86362001)(103116003)(2906002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9ZMRr8IENG7ExOlScaKrk05L4AMJQvefHQ0Rg1NI3zvMUgH8K/70BBqDWc0R?=
 =?us-ascii?Q?iiKtI4Q3Q4c55PyCqeYNC7lLOUUz3tFMDDDD17r2JMRN0EdzuJk3FCv0u847?=
 =?us-ascii?Q?Pf/cpF1xDCd+ya9lG0upqeo50mMJ8cjMeoLYE5Q/Ljvyzpc46sC4vCI12myG?=
 =?us-ascii?Q?gRIs+/gXKIzEf/f8jR9bqZQ1EZyLd0iNLC0yYzbEMZFdGWNzczDbAJ/7+9ku?=
 =?us-ascii?Q?olnpHCI9uErTbZQwouhiFQsi5O9XC2+ROdsPmUE2OfTRw10/IiHjqYBPRIy5?=
 =?us-ascii?Q?nPm5A2iDGYkkLZCAvOr48GhltvzaJBcdDfKZsZtKR5UXFZ4XZWlTIMkKs68C?=
 =?us-ascii?Q?I/XKqRP3aqxhMvSbFsGj3sT4It0f9Dx7z66Sh+w+Z7l/tz3PDPyQ6S1BiP7G?=
 =?us-ascii?Q?oC9LxOd3XpGsdn5l0i1DVOVEhFniZuWDjyzV8+wEuJC9UHXqz0DtOm6y0/J3?=
 =?us-ascii?Q?t6YqZcHsX62T/TOB727hsQomYTwuv5oi+MphGO7lhv/LTzOxPYCFtxWWW/k7?=
 =?us-ascii?Q?sG3oLXXVzJE+F7oF54HuVW7ArlmBDfxOJ3R8CXU2PtFI3Eh3GKBEneYkRZJh?=
 =?us-ascii?Q?kttX54TGuP1E+dm22RDIWo9zCzvj70vnhFdhc0U8Dp5ouBruW9SnKks9gIxY?=
 =?us-ascii?Q?t+RMiUUrZxEmlS3GFmDzyIE3O24ZMthh3nW4wXb7NFCEN2dSGlfKt2yzBzGB?=
 =?us-ascii?Q?L/yh49iJS+W6GKvjkZ73WHdu3VPHIHRqBAyxssC5bdQhE8YY+t7KB0OrNLkx?=
 =?us-ascii?Q?S+UtdtrE1qaU2zpmpJ9YD5MsTtem/X+ESvYVK02/ymnQZbAEhtZht7g1Os7Z?=
 =?us-ascii?Q?+HDhshQ6VWAD4kJ3cIcvZaBfu3NXXKlQdCShY+2/JOQE6ZItbWps8uWLAKhD?=
 =?us-ascii?Q?aM8p8es4af75GaDLFeO/jN4vi65xMnzxFn5DnzkAiFWmX5hpbdb6Wbo3aGCa?=
 =?us-ascii?Q?KawfxJCK1itiIQOn1qBvOtwjux3I21Tn9VZKp8z557Q+bCL9tXcPQMKKytG8?=
 =?us-ascii?Q?x0cnSkZ5CT78n8lOrsAcI9qrVtWwlRso63Fi4nWrKFqi99GlHaNvpQroAt0x?=
 =?us-ascii?Q?g+184n0XN/zOypWef8eEuTHjf36bskZ5Ea2/WyOqHVSS96NB8OQTFuOtRQGp?=
 =?us-ascii?Q?cvy5aeXIEXvEF/Bdmz+zzNhBr7s97yx3PHVpwpNv5M7OACTlMrk+fOWbJEsZ?=
 =?us-ascii?Q?OW24zhnTXmJpxV7Re7muf++oWlDXmlP7pPFj/FR4MR8DRLrnbPEdKlFLPKng?=
 =?us-ascii?Q?ShhDrAZKGszQSBqK2HlVocgkfx6zHxgtnGAbWJhoncWb1m7WIIJFL79n1+yK?=
 =?us-ascii?Q?AT3HHjKQthj7XTOWV3yexMBOv2fIw1SFxMRwZD68K6aGGj1ZoVnELVJmpH0O?=
 =?us-ascii?Q?ngwUZE+tM+iPLxdZmhepbNc6GcPv/eAdN5m1fGghddJMcbE2CquxSceuLRAy?=
 =?us-ascii?Q?h3N2Rx7M3b6C6a40tkyEQed4rxyuvQCi5lvGJ0916NG255HrgnaRNEguxT/Q?=
 =?us-ascii?Q?jDha4vrAjirKJnBaCZywrgCX9tgvLGbhXLc6ytLo3Xh2TeMGaRfQtVa6Dpua?=
 =?us-ascii?Q?HcFWse8I9DTMYWffIWSbPPrQb6aXK4SyD4ZXF0cc0dlvDAUky9HOFfyecXy3?=
 =?us-ascii?Q?RA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: ot07Itc7atst8TrtMW9uta0MSkgTeyaNxJjCCnCrExNY8bf0mAn52Voi6OkF9PmAGazpGsNqQ9vZQhdh/So0udWrqFnUgAV7Ujc8fWVsQRaX14GzcbooTdCXv7YIVzBsQypaEvq5MBJjcfHXnkPuhJD+9dSpewM3wf4Op24M5Pbcb1h3RfTnqv4YGo40bzRm0mVNqQBlC99yszAbUvqJU28tjpKVHXNFcpryRlcUjy9JxuH+JRI3NuDAiB29/ZdM83HK8bevDGHUDI6c0DFqE/imcONYzFFx/GVZ0+BUi22FWajGV3VDHX43lPLreKCbPWmcpOVlydG5a2O6PYe73xsmy8Hs1OCvHT9WBxcYD7uUV849akVRNX7RMffZzjhkYd2L9Gpgzfhhwa7whlqz5+z7EsBrHY3MHPUB3HdcU4PfsXlpf48w9bYDbXnmpU0VtC1wEje82DwAwTdYJdQQf+mbIAFXhPAUlweQuO6yX2T32bA+OM6vQh6JNMYxz5aVFXOA8au2PzrJmBA5Xz/VZ+D0mvbk11zJ/qe2fWRR9XmMKd0tyvj/eig6C/kq7cAgv6dyL9VmRGt8SmI8QYydl36jDZUfa6UTIA6bklV2S2fFmv56vnJHRs+3ijeT+5HpNZ4vNlSvkaAqmBABLkBCxyGaRkcuIzW/zb6VF1voVp8ZgswtMTB6lfDI2D+cn9yrH0W8gxqsal+VBlX7TK4EJmwSPNAj54Jbpg1Z3+T6yXkC2qaL+DekvuugYgeTb7Qto3FYyrrYpV8916WO0USSiTMkpSazSBnYnPrS42Wa1h/u+B/aRtBYvZSicBv+rwJ07u2OSp3cO9hTOfz/8nggyQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17f3f4ed-1079-4d4d-d842-08dbc0d204b4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2023 09:54:05.9273
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y/1U+SbAMG5kior9VU2TEedAn87V1T4L5KKF24VSz8OvQQSFXuwsVUU0hnCeDRwrL3xbdpvNgArIFOqDpsJH5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5742
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-29_07,2023-09-28_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 spamscore=0 mlxlogscore=964 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2309290085
X-Proofpoint-GUID: maaaI0Iz30W40Fj0mQ88Y8870q8d7wrk
X-Proofpoint-ORIG-GUID: maaaI0Iz30W40Fj0mQ88Y8870q8d7wrk
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This series enables a new feature to always honour the extent size hint.

It is required for atomic writes support.

It is possible to enable this feature at mkfs time or by changing the
attribute of regular file or directory. For extszhint, it is inherited
by descenent files/directories.

Associated kernel atomic writes patches to follow. We are sending this
support now so that people can try out the kernel support. More testing
is required.

Based on origin/for-next_2023-09-25

Darrick J. Wong (7):
  xfs: create a new inode flag to require extsize alignment of file data
    space
  xfs: allow files to require data mappings to be aligned to extszhint
  xfs_db: expose force_align feature and flags
  xfs_io: implement lsattr and chattr support for forcealign
  xfs_repair: check the force-align flag
  mkfs: add an extsize= option that allows units
  mkfs: enable the new force-align feature

 db/inode.c                      |   3 +
 db/sb.c                         |   2 +
 include/linux.h                 |   5 +
 include/xfs_inode.h             |   5 +
 include/xfs_mount.h             |   2 +
 io/attr.c                       |   5 +-
 libxfs/util.c                   |   2 +
 libxfs/xfs_bmap.c               |  26 ++++-
 libxfs/xfs_format.h             |   9 +-
 libxfs/xfs_inode_buf.c          |  40 ++++++++
 libxfs/xfs_inode_buf.h          |   3 +
 libxfs/xfs_sb.c                 |   3 +
 man/man2/ioctl_xfs_fsgetxattr.2 |   6 ++
 man/man8/mkfs.xfs.8.in          |  29 ++++++
 mkfs/xfs_mkfs.c                 | 175 ++++++++++++++++++++++++++++++--
 repair/dinode.c                 |  66 ++++++++++++
 16 files changed, 367 insertions(+), 14 deletions(-)

-- 
2.34.1

