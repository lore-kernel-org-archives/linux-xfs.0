Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48EB9C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 25 May 2022 05:37:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232051AbiEYFhC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 May 2022 01:37:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241230AbiEYFg7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 May 2022 01:36:59 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 410A220F6B
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 22:36:58 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24P0EWGj023375;
        Wed, 25 May 2022 05:36:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=B4fzw3MjwU6/rIhgg0QTs7Qi717DBljLAs8S1HfqoWQ=;
 b=BjAiNbCF8MZ1WunMVSFHmDO9AG6JZBT3S1GF5Uu40b+UL2MRpUwXBBwDM6Ad5qe38lOo
 4yCCLdQzRpcQwoZVDwYNU3an8EaYM5q5Z/v94YYtJGud0OdkLSJz7NEQlKj56fOw/Rv6
 m28zN5jgfBK8ejtGiim7OppAgofRJGuCTuI7MYwM4eux8L62YiWA83knbZFQ1wf/17vB
 8WqjukSRZlKRmkYe8bJY0WYcGDyRjdrhBHGQih2mMRbLhGAOxM7dqjOGTzEWuyfAE9Uc
 cImqQnvWCetCok3VgmIoQJL5UrL4NkOnCofLC6o8eeEtq2MQ7hzCyVGQwDB+sV7+KFJN Kw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g93tbs3u2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 May 2022 05:36:55 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24P5aMWX029862;
        Wed, 25 May 2022 05:36:54 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g93x5d5fp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 May 2022 05:36:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WmUEWc14deBvf0jcId3NcAdTJZhBX4qbH2IXp0582p1hY10PdNHZAsbII6BLvNAFv1adIo8Pk1x1rYmoIUMEWEuMcMfWVUDlu4wciET9T//4GoaOtZ1BCJv/XpWCvaVuUyjLNPJGZYRzs5Q5mzpIvzyU8oxDg9+oOcWrR5PbeYEzKIVpDE0U1vaxIIKmSYF9ZxKlLPVEYlXVBcaDDDc8n7MbII8EXCxz0mSmSA5Sg9HGCQlJIg6uw3TZOVeUcM1z6gjgw+DwiDbJGrSXqfP5nJ9+C/V3kmxJYg5tqSjkmNK+5HqWXVqHQDZ1r+dwdh64WsjF0Td8K1qovQhticmZTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B4fzw3MjwU6/rIhgg0QTs7Qi717DBljLAs8S1HfqoWQ=;
 b=YVXNZMqdkEDD19uth6TFQXVBp8heOGsxdB+o0nJW8zh1YY3zco3d8jAXJIEgrCseu2gKUN4WWXEGqcQgmvGyhI4B7RNCROnqfmRhEtP7UO/yjkdiaR9lAAj8bGYf1dAf76KmnoZo1W22q2Ci5YW6aktgrf1S5oBnKNp5agAwKhqI8MOI4Gyd4D+9EcI0Mxi64LXouJ8cYbpVWxsH+ORZjwygok4J920seYrASkLFKt+Zp0Eaneg1SCImp9fUkTrL7lSLYUPL8K9H9s7dUVEk2BKJQMo0QmbefWwa3EOWvhBJAvvpY5S70HjhC8hoVrnTN1X6eCGZKnWjGwikBb4j7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B4fzw3MjwU6/rIhgg0QTs7Qi717DBljLAs8S1HfqoWQ=;
 b=CqINnUU/quarlyX1FjKAn8BdGoB3DTyECcfYMb5/ImU7ITphAgOoVGPBkFXKHxME4gle3GHigaLC2CRhA4/eExfU9Lh/gLgSBEIYWn4y4hVKKiUqB1eSdiFuPkb/IEfYWUDAksgGErsQWuxPZGRO/+5uXy81VXwlosvPqBsaBqA=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BLAPR10MB4817.namprd10.prod.outlook.com (2603:10b6:208:321::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Wed, 25 May
 2022 05:36:52 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::5476:49e9:e3eb:e62]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::5476:49e9:e3eb:e62%5]) with mapi id 15.20.5273.023; Wed, 25 May 2022
 05:36:52 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, david@fromorbit.com
Subject: [PATCH 0/5] xfsprogs: Large extent counters
Date:   Wed, 25 May 2022 11:06:25 +0530
Message-Id: <20220525053630.734938-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR06CA0047.apcprd06.prod.outlook.com
 (2603:1096:404:2e::35) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 009039dd-049a-4ee6-5af6-08da3e10921b
X-MS-TrafficTypeDiagnostic: BLAPR10MB4817:EE_
X-Microsoft-Antispam-PRVS: <BLAPR10MB481789E196C490359A411624F6D69@BLAPR10MB4817.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zlYdB124RyO+SaJQpu26GdVlu+s6hgAyG392OMhBi2ErX4Wd0wIRxnYmIEtOJJBJDLxLgBlm3gkN96O/sC8UbwcNxjy6zBAG6X93niOqJFqj5Yi4d+EXty20FgOjZZ0nUjp3p7Lkt3IJskOpH2BG+ZTxUm3I7KpfM9kIj+0WUa5yMgj/j7TeKzHEZhG8X32HM4ZOzPouIRc5l26OFx3aOPIRFX5oVLc+RtderZF33a9XfMZUiG88beydt+5ICmDQkp74Jj4QactTJUbaGQeMMQ04V37a6J8udw7LVQdPmavmQh3zYjlzGlNqiq1bWw7WTXTwJqkRByC+zy+gAXyhlFQvlwGk01f6ixmHvX/8MlMAc1OSLeXrM7s8nYvrjQM3psvdfQKNwAX4mvawqGyRlIqFtflC8G0olb4tWtDLr5WwsD6rjs40bEFgDOUHo9iMRuCP8MiSL90sRHc7uXHpZ9Sevzto/KQEfkCw9M9b/mrPBqrRoYm7FL5SpYLMvQJFq4h16Ima8KlbVVXtJicwfKf58JyRLn2LdtitynaH8a3Z+UQgigV3rhW/1zYBv0fu5my6fq8QaXLx4+n+47l+wwMjRamjw3d0R1rJsegYHXaiqGKGA2yePnTXOI1MvkISxi/vgMjKnREUNqscS7jidly8pI1z9FXhYtg71Kd4QG7T9R5s5DD3D5yikShwUd6xbPzFaME4h/3HqRuP5dd30G9T21nJfAUidIP5Jos8LtlTGieoY2AlZjTGD7hBIPYdxMveSgBzu1PP1JdEon1CE8LgJtX+zAErmC2L5U9wri8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(66946007)(66556008)(6512007)(4326008)(8676002)(66476007)(83380400001)(8936002)(508600001)(6486002)(966005)(6506007)(1076003)(316002)(38100700002)(6666004)(52116002)(86362001)(6916009)(186003)(36756003)(2906002)(26005)(38350700002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?q8YvA+vGvU979cSFYkWQj2UOHYs/h6hEtWp4osBQdoQfaRQbkatKqFto2f/+?=
 =?us-ascii?Q?aOpY/NwQa4qwuE+80jqXjgElPnXfab3wPytO2Y9dQ9zbqtEcTEcYAZwEVKGC?=
 =?us-ascii?Q?m4f4ovV+tAIv7vSzPN5h1iH9gJx7hSSnFJjVOgvKa2l5H0jNrunglS8TFns/?=
 =?us-ascii?Q?gLI0cUeIO8h/3dzWYxaCohO3srb89ZqhCpprYyMoQbsDeTMrmZSxRdIr2MKx?=
 =?us-ascii?Q?ELzBejIDvpNWgxYUnOzslWWLCcpxJ0R6MUmuD0ulnzA47yO6/gHXcowG8tO5?=
 =?us-ascii?Q?o8jn9DNvKlF1FrwJMtTuCMoHx7M6+J821dhXwgegnnOIHye2CDhqqsbIJfRj?=
 =?us-ascii?Q?z88dKA9PgxMkPK/N/VDdehCjNw6OM0SAw/wuCKucXnV1vSLfdjL992mSpRcU?=
 =?us-ascii?Q?b2ALojCtb8N2sMDGGNvADGHSHt9l36PTqknq0S3SQzNacRtofXUwTbqJpoRr?=
 =?us-ascii?Q?D1Flsw5WsS/Xomj4SCRgkc2k6XJbfRTdRIHTLNQMqn4bnRfJlXVvfcXBBZVN?=
 =?us-ascii?Q?EYcZi38goH/NaJu/zWqz7iZtBCRiApDl7YhKUeI/NahG2RTCJConUxrO/Gav?=
 =?us-ascii?Q?KSdnXggHizS794fh23dnCwnX8Atrn85lxaIJ307bGJbuS2fQop0qFugc5BON?=
 =?us-ascii?Q?BL47xE3AzjLy1XU3NQhazktS0glsimOxe6UUMxoNyB+dwZrHG6OtSP5m8odR?=
 =?us-ascii?Q?WYX03ezgjl8TQJsfix2QyS+bGkVCsvKyOVEpSD660Kl3y3Bu6akidPrspL4O?=
 =?us-ascii?Q?K3pk3xwWqSqdTdG2KuRm4M1BJlPGkP7n5b3GMBdh1giExJ1jcUbKgMIybTia?=
 =?us-ascii?Q?YHVqVPNxbX3HmDqh0muEqTsnE4XJ0USsN5P5kEKV74bDiLqEVmkWUVCIUoRA?=
 =?us-ascii?Q?oSf7/3U8eA9u42QPvS9qaC6G/36LFuxHNHoaIC22s0Vj2ApKzroOYi2hPylf?=
 =?us-ascii?Q?8xuHXR0xFMKxDuDR69HHBfqbJVas0c/b7PwZyo3Lk3re3y8qajG2IruZFlUz?=
 =?us-ascii?Q?7YaHYRy3FW8eENfKd/kVn65Wd3CkCAcodkRuBBZ1JoyqcnApPZBfgcQBrg+X?=
 =?us-ascii?Q?BUbbGmlg6eyvCV7RmJFUTyu0vVEjWZ2S5JnVKjy4+1NyZTumPswcWimuI/Xx?=
 =?us-ascii?Q?FT7Cdi6bGqib+DQ19D8RzhrVpHVwIMl7mhdHc83MU8E8IcK08VBFbJnYvQGl?=
 =?us-ascii?Q?9jtL2F8iKySNggvGdoLPs8Xm4p04+W5F7aNxgQcPCsvZO1BcsNWSv5AdJLQp?=
 =?us-ascii?Q?gcg/jgGBBkRsBB3vvy/kGnFV5r5tLI3Oh1q1RN1/Dt9uvcpKaJsyECg5umPY?=
 =?us-ascii?Q?e7zGmXqDv4wDGELiVhbFKVRhCOiVXrvHob6w205ps3SAv+974VBVhjf8ZQ6U?=
 =?us-ascii?Q?luO9Lr81OpV0y/dCQH6hBXn6rBpo0qbySeFnA1gFFOZyaukdKogcUoFz/XLj?=
 =?us-ascii?Q?8SDouJC2cpGpQF3/F50jcLJ7pzCngD+fvSqDnFlpbYb4+laHTftigv6fXfbR?=
 =?us-ascii?Q?+caRcPAeQfjWAUfEmVYjPAiIpkpottUN6kyXuDXMbx3WCuD1p5/mWZu986XA?=
 =?us-ascii?Q?a5SBnY8Kag5+ASKtNtAmg3+XFBt8zzLLj6Gd9bhprRz4YKR6OvPxcsUcQUHh?=
 =?us-ascii?Q?Hfle3ne0sKgWjdcYH8SgH2j/tWKVX7P8XRHVaCaRgEEX2T1dNnnC9T39LUED?=
 =?us-ascii?Q?4g2CEEf8FXUL4txqvGFHcv0jf/3Rga1toY2+SwppqIn2ehZD9KwPwuGM8TRa?=
 =?us-ascii?Q?2C8h3VHuAfZFg8mh1qKmFJ5ssE5DtE4=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 009039dd-049a-4ee6-5af6-08da3e10921b
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2022 05:36:52.0354
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DKjkRcQjzm3hWsfFHcMH07wcaRLQ/NE1qELTWXeNt2Hzre/aXUgQk02KqacRNPO3CgvHVnQCO06eFB2KXvJL6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4817
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-25_01:2022-05-23,2022-05-25 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2205250029
X-Proofpoint-GUID: BP7BqCVrunfKYHCzX3JntxouW3Aa5CsJ
X-Proofpoint-ORIG-GUID: BP7BqCVrunfKYHCzX3JntxouW3Aa5CsJ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patchset implements the changes to userspace programs that are
required to support large per-inode extent counters. These changes
allow programs in xfsprogs to be able to create and work with
filesystem instances with 64-bit data fork extent counter and 32-bit
attr fork extent counter fields.

The patchset can also be obtained from
https://github.com/chandanr/xfsprogs-dev.git at branch
large-extent-counters.

PS: Dave, I noticed that xfs/070 is failing during xfstest runs. This
failure is seen on libxfs-5.19-sync branch as well. The bad commit was
"xfs: validate v5 feature fields". I will debug this and find the root
cause.

Chandan Babu R (4):
  xfsprogs: Invoke bulkstat ioctl with XFS_BULK_IREQ_NREXT64 flag
  xfs_info: Report NREXT64 feature status
  mkfs: Add option to create filesystem with large extent counters
  xfs_repair: Add support for upgrading to large extent counters

Darrick J. Wong (1):
  xfs_repair: check filesystem geometry before allowing upgrades

 fsr/xfs_fsr.c                 |   4 +-
 include/libxfs.h              |   1 +
 include/xfs_mount.h           |   1 +
 io/bulkstat.c                 |   1 +
 libfrog/bulkstat.c            |  29 ++++-
 libfrog/fsgeom.c              |   6 +-
 libxfs/init.c                 |  24 ++--
 libxfs/libxfs_api_defs.h      |   3 +
 man/man2/ioctl_xfs_bulkstat.2 |  10 +-
 man/man8/mkfs.xfs.8.in        |   7 ++
 man/man8/xfs_admin.8          |   7 ++
 mkfs/lts_4.19.conf            |   1 +
 mkfs/lts_5.10.conf            |   1 +
 mkfs/lts_5.15.conf            |   1 +
 mkfs/lts_5.4.conf             |   1 +
 mkfs/xfs_mkfs.c               |  23 ++++
 repair/globals.c              |   1 +
 repair/globals.h              |   1 +
 repair/phase2.c               | 230 ++++++++++++++++++++++++++++++++--
 repair/xfs_repair.c           |  11 ++
 20 files changed, 339 insertions(+), 24 deletions(-)

-- 
2.35.1

