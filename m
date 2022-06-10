Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B48BEC43334
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Jun 2022 08:52:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347824AbiFJIwQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jun 2022 04:52:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348446AbiFJIwH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jun 2022 04:52:07 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69736240A9;
        Fri, 10 Jun 2022 01:52:06 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25A81eFd015600;
        Fri, 10 Jun 2022 08:52:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=1NvjdeRwTo7D0PaBSi3DHjd8raJvHfrJW8CUqqK2kB8=;
 b=QZm6GUbNvzUgd+Nkvf9IzGzp26TOZZbsmQBB34GtYJCvjDMmR+5Kt8EZpcINWgD0d4JP
 RQFh2Q46+Y8xcsNhrrrZoGS27cBNddZHhPUqwj1dOxVkQUEt8cquAP0lNjJguaHziIXX
 kQYdDqWWJgpwQ4r0QXwAK+z72QXlmne6w0emcpVtUPJSc2QJiTqUiDCJA0dMLrHpcqL2
 UhnJonQeGmLXBMS3JHO9YyL5Zzr2haM+KbUTAwBo38t5xoRndvy1ZynzIg/bn8hPGEFq
 kAMbrAG/RPDJd/bPCK+JPvjPJth7lEwbrJcJEFVKqSGUQddA8emi6GVUzuIcZcZHJS3N 0A== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gfydqw2ks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jun 2022 08:52:02 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25A8o6cc016400;
        Fri, 10 Jun 2022 08:52:00 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gfwu5pquh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jun 2022 08:52:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=htNx5tWLcMTHRB7dXjbe3cSmKy0yPsm2Ex67yf74s3Hn40jEdHBmibjtmcnvBaikSyuEAAyHH0eBD01jOGh2ZSvmO/i2f8VeWZHOBl1Xbt//v/96WHFIihPvOGwIKa7GJHaGeIBDFw2fW+gGFnL9Z8jvpvIVhySNI5SnwLBWZQFWZaBwdfOsY+yzXLe0SFsmny55E1t5uajP28D6lTk+kyrnHGEo53v2++xFQgaFo9/4TKqxiQBFArKuObrNazYZiug6pj+S2pB15qofyUE+VTGKTjQyHbP+4XYWWtG/BZa8YGTtEu5R1XSbtzT1i+Mg+LV0HBxN/P7Es9dlMW78UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1NvjdeRwTo7D0PaBSi3DHjd8raJvHfrJW8CUqqK2kB8=;
 b=JKi95YKJ5QL/als+AHWitOAgvwGx4iubKnCmnMEdMjkGDPWa/xI8/zyKB20DX6d7ZmEbiG1M+1SbYWm4wvtqMWHUyPIzt9pK75yadbdrMKdZpNGwetY50Qine+LAY0xCVsESSPRRTobxr7P1Lk33zEXjbcl+QuUeH7qi0MGcJowtM75skLObHtJEdr+h2F0EjeMURShjpb9eUHstSMy0vj/jiDAWklKdt1KyRDFxi9xC8zd2EbZXviowqHEv2WUwpkmeMXko33a3nPVGcAPEkFIXE5m3/IrsX7xhihHKV5GZ1yeoShHO0pV70rPnBFXbEh1dcADStsSnVWOypLKMBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1NvjdeRwTo7D0PaBSi3DHjd8raJvHfrJW8CUqqK2kB8=;
 b=CGSPlbCAdDskb8jsruKtpWuzaqxZQlsjMFLBqw2M1SC+T19fFxNegD2h/Sg6gDL4bLHXaVV6i7C5P+Pl3amP+kPd1XL5gC5hOlmHcK+ME0M21+lWu/JyyonQukYCn7bVOghCoND6gvE2+Q/jRjR8YEtx+Dzvrx94iLdvmr+OLbg=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BYAPR10MB2854.namprd10.prod.outlook.com (2603:10b6:a03:82::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.18; Fri, 10 Jun
 2022 08:51:53 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::ec25:bdae:c65c:b24a]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::ec25:bdae:c65c:b24a%7]) with mapi id 15.20.5332.013; Fri, 10 Jun 2022
 08:51:53 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, zlang@kernel.org,
        david@fromorbit.com, djwong@kernel.org, linux-xfs@vger.kernel.org
Subject: [PATCH V2 0/4] Large extent counters tests
Date:   Fri, 10 Jun 2022 14:21:31 +0530
Message-Id: <20220610085135.725400-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0229.jpnprd01.prod.outlook.com
 (2603:1096:404:11e::25) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eec7f11a-76e9-45d1-c1e6-08da4abe7740
X-MS-TrafficTypeDiagnostic: BYAPR10MB2854:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB285461E71CB45234172D9F46F6A69@BYAPR10MB2854.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Dd54zDruzPaY4jv4iKXwwRj9BU6BLaTWc3BY+LCpZjPSZMln+tixrdIZ/ebiQn8GUhWe/hLSST+U3X25xNhkdNkJw8eRHi6kKcX94+0bKb1miEEZgWlVW/urHLLscUGKGa8qad0DBvRcwW4IkZLhc9rpuSECQsp9KVO/mlo0nPYYuFrZPIOIumosn4hUEifJlkNQWD8bd24Flrz38XkNVRNN1Gl04d/Qtzkz0KaH2ex23GOVsH1dWDlTEVIEl5oj11Fj93QKGT826jXikEZ3fhtdZwHbwv3JoEb3/NuWJfaBftbbIE3SFxIGwBtVqRX0/cTwbfrFOBth5KmTva6nzUOxcXW+wIJNy0iqxggE+73r5dtF+krFQXzixV0pK8qzco1JNkihEE9FOBg0BMiFMZoTISpYTaEX55kttR7A3VQAUv1FOajT16ST5/SfJwVA+l7jWLg2CGU76GiNSRhmJ8dT2wHEkH9GOC4EAkrCYG1aW8AeDlN5XJa88YM7jjjbRUn0pMyyt/h65M/m6Du9Okw/JxDcDiCfN1OfW6l31a8Gs715cZbXwDTtV7L+lNOrelhvj0mKS201xwF5KA09NIYExrm4q7Na1ulRtUek7Fp756r+n/pDpMS5sJkqypj1TWAk1DfLYl3VqlGxdiCDCvrDL35bAZy/D+lySd0Dg6DmNPsh9W5omHK9BzSvTSf5z0yBAYfC8fSdyz8TJXtC3w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(4326008)(66946007)(26005)(83380400001)(6916009)(186003)(5660300002)(8936002)(316002)(8676002)(52116002)(6512007)(66476007)(66556008)(6486002)(6666004)(86362001)(36756003)(2906002)(2616005)(38100700002)(1076003)(38350700002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pfEwIRiClchjhB9I+c9thi6IM3ca4r5pUsVuri//Mi3ouP3lIz0QAwFneb23?=
 =?us-ascii?Q?3/wY/QIAssMdBwuNBCv9OUpshI6Pvs0BvkUTOkqZEteH02bUoukZvEz0LdlX?=
 =?us-ascii?Q?gtDYoSYnLjFwCNr9NK79fHZ7jysk43EwqkHdNezvrqAokXjba42sLNXpV/PB?=
 =?us-ascii?Q?qx6Rc8/kEh0WlKAbeDB1JZn3JXTGpjJBynU9of/b5HurH4B8AHVPjxDIwxTN?=
 =?us-ascii?Q?wo7x+VPJU2acaQ2+sh4MK7AIyJAjkwFFlmwMIfELIe31j8HYzCd52s6oN7v/?=
 =?us-ascii?Q?guqZ6qmgJSRhzifMSe4onacNVr8wbH2BPm2IjzZMtVM5Sy4FUD5sjguAAspE?=
 =?us-ascii?Q?jWrGGwrz5UUTvwWxvk2HEjW5yCf1zAaU2XZ3mDIMEnnv687L7EFq2ainyRC/?=
 =?us-ascii?Q?Nsk0ZRgMwd86TrzU725j7MxwhBsjx1qSQl/kWeepBx0WfEnNTV724yppk/0R?=
 =?us-ascii?Q?xiyeOs5n1WlUBtO7WyJlrGpM4zR8MOs4O6QZvn9JTs4PMQBZ5WCovv/OLRp/?=
 =?us-ascii?Q?64ug5E6WdPnHsepk11JWWw14wlFLnEw3LOlth4HPx1WE9d6KagcSnmWRJHIb?=
 =?us-ascii?Q?T/S4lHYH+iyLtG3geNGRqvq1o3y2muahB7q36GVJaqULzrGjNsWetQtU6BSF?=
 =?us-ascii?Q?LGr9YnRltmm5gyI/CmZ8zmt3RkPNEP2HDV/0BA4vTYqMlue57BHRpQUrdjXw?=
 =?us-ascii?Q?oWWxHg8fqDgcWt4GzWOD96vLY7QSkfVgAUCTppHwBMh2soo7L29cfeG2XeQ+?=
 =?us-ascii?Q?xH8ZBG8k0/ky6P/++DbV/4L5sB9rn1gcJwOKUVEfVqJ4+rz92l07gwNdRR+V?=
 =?us-ascii?Q?mFa3PgXi+0zuPGvrBx23kUzXV302y/ckju0LBFoDpQqeGQTrfPakPQAqMUTK?=
 =?us-ascii?Q?SkUyyaKEdJKso1QJ+zHEQNhxQ6btgjn9OJ305NNOxdMvKMK2fMAcnEiO9Dhy?=
 =?us-ascii?Q?a+sZPTT+pWtR9eiQsiQRP4cfbH1F1mvCTWfjbbcrWFiiqT/JincfzorANRJN?=
 =?us-ascii?Q?VPLKJgjTNuFvzG4K5GnUWytG6trMWaeQW0x2TqBJimVJaj97IjoNA29Wt3TD?=
 =?us-ascii?Q?CEASmUrFXy4IdtJtPUW3qDjN+YzEMUzR1k7JQ8kWLX0pkGyhG0w3AWaDoaEW?=
 =?us-ascii?Q?T6jdsQpW9OTeIPFk4CybyYtx6KSoxS8H1VNUBOEFSqJLHFqv7WomCav5kX74?=
 =?us-ascii?Q?+HF3eVV+6oOzJGvH4v2H3wirr3YFVlIpoa9pOD7SIE7PLAt1wPo8ZNJcJWhz?=
 =?us-ascii?Q?RN9AK70hmGZmFHeNIBmsKXjJCLc2j/3VANZv5DEuuR3HwM9TXQqnmaAMOFg6?=
 =?us-ascii?Q?eEOQ41c6jvz8kfJiMo98yVszzVC1aiA8OcFWysOpX8bOHVOb4lJwL/gZrxK3?=
 =?us-ascii?Q?EwDlSH22BLxFuFGhc9D8RxwKkMz+wb/TOnN8Lo7PnMjblCGMH0egk9MMVuas?=
 =?us-ascii?Q?0gEq+5NGy8KUxLEygopomoqPEIEJdiW7jDcIL7QhQEOjQeayteOQfyzalbyK?=
 =?us-ascii?Q?E++d7htfcBkUe9X6b/i7Ungw9SefogWK3xaDYDgyiOe5X1N0P0Gq6d5fihLn?=
 =?us-ascii?Q?KpmCe4E8rYDQXm8Y3FCow3xQntwHIIqQlonCdlhvWr/DD8uH5DyHL2SD03XM?=
 =?us-ascii?Q?bo/Me27hzCtcq+HIHp6vC5VtE/e49qNHZNo1pescPQf5L6c9HtalArExDC9q?=
 =?us-ascii?Q?Owe+hDGS+zSzG7/1LAdu4gQRrXYBdXw83Hb8dHZiPIn1ALr/V9pfnJSnyGZF?=
 =?us-ascii?Q?h5M49dar4Q7nCGJmaNGumd0nTeU87yQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eec7f11a-76e9-45d1-c1e6-08da4abe7740
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2022 08:51:53.3663
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bd6Ars5rH3GylaLwIxLnf/GKxNbXBwDxD32SVNs2p+joQUVbJOCtN/PzMEc1DlssgeNyJzSlyQsh7xTejG8ZEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2854
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-10_02:2022-06-09,2022-06-10 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 adultscore=0
 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0 mlxlogscore=941
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206100032
X-Proofpoint-GUID: _z45edtZBYHrEEnmvFNMtRV7xXQk3q2J
X-Proofpoint-ORIG-GUID: _z45edtZBYHrEEnmvFNMtRV7xXQk3q2J
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This patchset adds two tests for verifying the behaviour of Large
extent counters feature. It also fixes xfs/270 test failure when
executed on a filesystem with Large extent counters enabled.

Changelog:
V1 -> V2:
   1. xfs/270: Replace bashisms with inline awk scripts.
   2. Use _scratch_mkfs_xfs_supported helper in _require_xfs_nrext64().
   3. Remove invocation of $XFS_INFO_PROG from _require_xfs_nrext64().
   4. Use xfs_db's 'path' command instead of saving test file's inode
      number in the two new tests introduced by the patchset.

Chandan Babu R (4):
  xfs/270: Fix ro mount failure when nrext64 option is enabled
  common/xfs: Add helper to check if nrext64 option is supported
  xfs: Verify that the correct inode extent counters are updated
    with/without nrext64
  xfs: Verify correctness of upgrading an fs to support large extent
    counters

 common/xfs        |  12 +++++
 tests/xfs/270     |  25 ++++++++++-
 tests/xfs/270.out |   1 -
 tests/xfs/547     |  92 +++++++++++++++++++++++++++++++++++++
 tests/xfs/547.out |  13 ++++++
 tests/xfs/548     | 112 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/548.out |  12 +++++
 7 files changed, 264 insertions(+), 3 deletions(-)
 create mode 100755 tests/xfs/547
 create mode 100644 tests/xfs/547.out
 create mode 100755 tests/xfs/548
 create mode 100644 tests/xfs/548.out

-- 
2.35.1

