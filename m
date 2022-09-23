Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA493ECAAD8
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Sep 2022 07:22:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbiIWHWH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Sep 2022 03:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbiIWHWG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Sep 2022 03:22:06 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB93612B49A
        for <linux-xfs@vger.kernel.org>; Fri, 23 Sep 2022 00:22:04 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28N5naN3022223;
        Fri, 23 Sep 2022 07:21:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=KNqAQCLLRDG3M49po0KjE98dMYprLqrWgvHYzmGeHLQ=;
 b=FhD20pN+0l3oGZw02PdILFLB6kNLkg5DWF7+8JLQDNztgOGxM6ybx4b549yEEaTxBEXe
 kGfIr7uFZ9TmPDNWjNeAFPUeILibIzg04ekHOT+aDuegKT33pGZOzOVNzN1POGP4bhHP
 weU0pwxfYOib6QCZ2I3HlWTTM4Op7BhNrWdw4W+q2a/9I7a9t042QuWKDd3jpccsgq5R
 jmxO6PBhHSpyeUm9lqv5lXl8C23aOx92f0NdyH4S1UHn2LDoczO4CkGcZ8YN9V1z+7Su
 JmYYuUI8zeH4/o0n8mfxLgkl1FrZMFRw1vdaAxRt0vBDMKCPKgTZOyHe//3Ubty6ufHh Bw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn688q2yv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Sep 2022 07:21:59 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28N6p0KD005876;
        Fri, 23 Sep 2022 07:21:58 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2043.outbound.protection.outlook.com [104.47.73.43])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jp3crfuqe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Sep 2022 07:21:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=clMv/amoQynDKRdwhjv3lUzK341gLZVHAacEBObEUFbyj9X0dDxDI5014bDjzl5yXqCbIizPcrrUdfpCVuJWg7cp+7Kl/vQN4btUXhekE5xYrK+/eCQI6cjmY3duvm6sirccrmDyfVMLyPd9ZEhAKF0XYlJIvigw9Ia0Of8kJKCHWKJC7tMYmWOywHQEHaYopj0D0QWWqfPw36mq+yTViJf/WLJkx9Ld/QB2Eo3FMSNWILspHmgLyAAMdUHSwRvImblpOFYkypobhCaYrgs4mEQdBR/X+f4M/A091FOitayIAzCOiO2FhdeYm/e2vbuaCN/2rx4Ichvq/gZdKHbbqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KNqAQCLLRDG3M49po0KjE98dMYprLqrWgvHYzmGeHLQ=;
 b=e86U9+I/85+9do2P+gg2aUdGOcfemSbx8kEg8mH2GYBnnit0jbx1FfW9rUOQ+hm2jNIZVRaplUdlWEuWI077eVaL2NOMVC+/ZyW/yBHZ8+h3Tedw7YedT8cbJp3nQezsdgzXrDZEXEw7uXte1S1CRpiZjNnzLIqk6RQnGdqBrTmR6nhHKfdPpRfj50f2eaSSpEjMR49CoQQP3u36DFFEjiJQFM1LagCQKl8U2tlyv1t4JCcxtSMSOcF57tEvpm+NYVZuiiFVL8YIUROceJGGcB1PBQs7qVPbKPUZ+CqfoxnpN688xBv5DsB+I+KRDlucKU1LzdbkJEks6caI+FqfTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KNqAQCLLRDG3M49po0KjE98dMYprLqrWgvHYzmGeHLQ=;
 b=Av0p0XEwXK79Y4V1sIOk3I3fvQ4BEtTsVM7e1+cak23mvenlUlExCzK5JnkJQuIMFZJRtAf+Wvybn7+uEtTsxHkTAUXkZdotj+36Iv99Xz0B/SMEVk8+eUSHsY2FqVqSBBtJIaRoXQzERvKgmSeQ686gDIwjwM1CQm9Lg3vaY7c=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS7PR10MB5264.namprd10.prod.outlook.com (2603:10b6:5:3a7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.20; Fri, 23 Sep
 2022 07:21:56 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%7]) with mapi id 15.20.5654.014; Fri, 23 Sep 2022
 07:21:56 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 0/2] xfs stable candidate patches for 5.4.y
Date:   Fri, 23 Sep 2022 12:51:47 +0530
Message-Id: <20220923072149.928439-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYWPR01CA0010.jpnprd01.prod.outlook.com
 (2603:1096:400:a9::15) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS7PR10MB5264:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d3a5769-edf4-4a00-8b6c-08da9d344c0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 41hG/mp1p6sjFSRRU/4WXgyilgErWbRh36paHHmt999R5pHqrI8ukxaNrl0zcDdL4Bj5DEYt4NdrT4EtTLwplAlSsuWR7zL/wOZMo1Yl/7mnj3BZMtiUWAmFb+OTP8zvAXPX4K73OaoulyEKymrpwiW3i3JQQAE144GFOzh9/eUu9r1c8XZ5EMF58EE/7Zq2t30p7pELTBeGb54bL6scajExIO2mf5P/wGloRpL6zBpiNwApKpy+1QyF3/KGqYCkweRJBnyFG25ogtjQHIAMgb/yqGG7GrAjRW7Djje/BxU+miqtGvfpSuwE9/4/JLbkN7PR9DTcvcrTPkI0wgyQIJknW8HopPTmOZcbHmXzQ3xu/oQPKDl9Rinmc6Emo7BgC7c2tuKoF6a7VwpZpB4TOquTnTg2Ho3vdX2o2TEs63HyurYWgdzKVQUajqA+f/LE409jhbdh/b2r73cGhpVlcIJ9wA+fMCo2jtCqJ3PMzqf+AxONIZPzx67tk5lX0IzmoRqGMuJipkf+aXimu+NI51XYqkEvQAlArmvEYyk+R3JdhvT9yGL8QqYqx7SXRn/nRims2qLcU+4nWkCu7vb6eQSGaVBI8vjzwaavhZZSQ3jEM1MgaVX1aA4dW37bAzXDliTdCob/+E6L4cqnsuHLPuJZlQ9j7BCpza1YE5dIvdssfwhnOXRZ16cUSf8pdtLkVYNMtnRNZ/+BYN6WTSGsSYob5/Edlx8E+8yPR0EPYjI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(396003)(136003)(39860400002)(366004)(451199015)(4326008)(8936002)(66556008)(66476007)(66946007)(38100700002)(36756003)(86362001)(5660300002)(2906002)(6506007)(186003)(83380400001)(6512007)(6666004)(6486002)(26005)(478600001)(1076003)(2616005)(8676002)(41300700001)(6916009)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?j9Xvnd/uvkcf/uUP+KHvEn4RNZBl8usCEpDWYc9k8YtnwhwDeWGb4Sjf0ldi?=
 =?us-ascii?Q?urzaeCwh82dNSb5SMgeSGSqw3xTInEr3chOIGcQL+4a7xiFsrH6SGPkK+qmA?=
 =?us-ascii?Q?yYzdGXdWayBioaOMEBbruSDYi96E9N1a07Gdra5jxEe3oiu3edkOC8GewSsm?=
 =?us-ascii?Q?o/FEgYGbXK7rJgwznAJ5YB0b6uj2/0cYiChelUGkMTQwC1vY3bL5u06CMh7d?=
 =?us-ascii?Q?D2zjT08+JuQaM2d+w1auMtNEuKO5HL+OCFLCQyD/1dUxKEM/7gIdrGAjIvW0?=
 =?us-ascii?Q?u0PPVmXfT8xemFc0P437faSJI+6ViEhLPDqXQi84aVCvqN++s4QY+GFvKc/s?=
 =?us-ascii?Q?LRKZmfXLWWhfUnTZrULwGiZd5YZF1BX4V2sHMJOuLGawAIHvjuIjQ+PPQ34+?=
 =?us-ascii?Q?fK3mluW4mTryuuin8EJojOHl/rSBaT1uF54XX/GPC4WXU9sbg0+SZ9KSow6K?=
 =?us-ascii?Q?n+PfKS9FIpU/gC9KbgCabbnG5+JCaYUKlgRp9pGbGNH/gjdtlVznGL/E3bzc?=
 =?us-ascii?Q?kaZ5KX4TnzhJFU41iAX0kSi4nSemm2KaRyJqQJLjGJRRN8vqZbFGSmtUwmum?=
 =?us-ascii?Q?eFkztpNi6bY1tfrKFnQVM8yDTsW1lHYw+74zNjeLaG1wTPw/Bz5upU6cUMB3?=
 =?us-ascii?Q?NcJAcFxaU2I2in2I27oFMoIGQnxK9YhdOwpYuw+noK093ryYvZQcKhY2L1zD?=
 =?us-ascii?Q?HTvTFW00eBrVYepbTCti9f3Kp+R8oxZgvk7MX5v+aAYA2Re14mSe2YEeX8cg?=
 =?us-ascii?Q?aMPFXa7/hRUrRfHRMUfKxCQB72aB256xXvLV8G+lFShQ2FqVzq49HMJ8gEDo?=
 =?us-ascii?Q?2AlrQGZ3z8HKwq1+D8Bw3GYeo8oWz05rPrHF6MS3L10bCAB/Su4zl6uM+jtz?=
 =?us-ascii?Q?qO8yp+Nqj5M4jdODHkI0e7P+pXX/8DStI/gsK6XXq8z/IVThZOdv51H2xuiH?=
 =?us-ascii?Q?Ker5VowKwfh9MVWyOG++/A2B8JhRHiGSPQUC7yj/JmQFrMCidQ+H9ulJ/f60?=
 =?us-ascii?Q?jsBkWcS39TDdSzDCY3VmXUVq/9uAEVCnBVBJkevxYh0ov2oaDZ7F5oYnOB/0?=
 =?us-ascii?Q?ORu/3g4Kz4Pi8GGT43RxOZZi3jEXRUEMdWTIXlfbQmht9iKhlwm4Y2XVPy0T?=
 =?us-ascii?Q?jgnXFisg+k6qLX06R4JycmTXhGH7tZGHyj+GQ/pO4y7owBMGIBkHVti8hxv5?=
 =?us-ascii?Q?pG6gz+2x4/mrKvO18bVMHUv2+XVdoOeeWFoIe4tSeoU9EsBJr8ZFWBV6XjKg?=
 =?us-ascii?Q?kPivDLbGzBhmIVlFrj6ezykdJZEIESeAPgaPsvWVgJq8rLzTa4qxJGaD6Mze?=
 =?us-ascii?Q?2vKh+AKRGnWey7Ac3IMrcmA3mMr73FpmVi3I45lY41h0B3flZWvH1XPf95WV?=
 =?us-ascii?Q?zNjcDc5/ZEzQ8LjnfPVXfubgW+UVrjzSoMN8ML9BRNOAcpt08cSgrfunHnNo?=
 =?us-ascii?Q?rV/094nz4psNiwFrAihSScxMxYM0Wc5Yf0WKTaP8VtwAfHw6sZzIk4mN7580?=
 =?us-ascii?Q?6jFAnP07zQmW/0Gae9ACZUABenAu33kExrgX6YjnVvrsYEg6r/ZIZnIlspC3?=
 =?us-ascii?Q?Uh+DRgMUl5hNfOwiDWY8ExOXxrscZoi+wqo0g/Ba?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d3a5769-edf4-4a00-8b6c-08da9d344c0f
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 07:21:56.7386
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 26B7iHujTpXWhhRaQjNMfcMeHifkI5oS7ZEFziYq8jzJT/xUy1+4tXPJNWtjqDe49oM3xzCDZKHbfm9gvT/5WA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5264
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-23_02,2022-09-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 spamscore=0 adultscore=0 mlxscore=0 malwarescore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209230046
X-Proofpoint-GUID: uGo1SQJyJKzD0Kbp9iISYEv7oBAxJEbr
X-Proofpoint-ORIG-GUID: uGo1SQJyJKzD0Kbp9iISYEv7oBAxJEbr
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

Two of the commits backported from v5.5
(https://lore.kernel.org/linux-xfs/YywzGEFApUMalXNn@kroah.com/T/#t)
introduced regressions of their own. Hence this patchset includes two
backported commits to fix those regressions.

The first patch i.e. "xfs: fix an ABBA deadlock in xfs_rename" fixes a
regression that was introduced by "xfs: Fix deadlock between AGI and
AGF when target_ip exists in xfs_rename()".

The second patch i.e. "xfs: fix use-after-free when aborting corrupt
attr inactivation" fixes a regression that was introduced by "xfs: fix
use-after-free when aborting corrupt attr inactivation".
   
This patchset has been tested by executing fstests (via kdevops) using
the following XFS configurations,
1. No CRC (with 512 and 4k block size).
2. Reflink/Rmapbt (1k and 4k block size).
3. Reflink without Rmapbt.
4. External log device.

Darrick J. Wong (2):
  xfs: fix an ABBA deadlock in xfs_rename
  xfs: fix use-after-free when aborting corrupt attr inactivation

 fs/xfs/libxfs/xfs_dir2.h    |  2 --
 fs/xfs/libxfs/xfs_dir2_sf.c |  2 +-
 fs/xfs/xfs_attr_inactive.c  |  2 +-
 fs/xfs/xfs_inode.c          | 42 ++++++++++++++++++++++---------------
 4 files changed, 27 insertions(+), 21 deletions(-)

-- 
2.35.1

