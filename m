Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E981CEB64DC
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Jul 2023 00:58:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbjGRA6k (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Jul 2023 20:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjGRA6j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Jul 2023 20:58:39 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3202C0
        for <linux-xfs@vger.kernel.org>; Mon, 17 Jul 2023 17:58:38 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36HKOfOX026249
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jul 2023 00:58:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-03-30;
 bh=mak46UXcilkj417dCDa9Mtr3u0tRdkRpXxnvZ70z1lw=;
 b=RryvHrJ6qdmOSmTeQK9x5dNy0VMve05jNw41+lcQBn3O/DEwGJdWR1yXOe0/naX9uyP6
 zfdPBw9awQQ2y1crrQYfDJfQ0imaWg9iAzqBbEM2atTGA6ddtPjU9844p1thCGMqoyfC
 Yq7amlh0TAWT8I+mKMoSRGKqrYYQvrMGusjyD8ogE7yqRzAKdiQG1LaKwp2nAbJL+xUA
 D4dovSdp3Av1dh3sDTnnih6MUdfJ+UC1RhlFf9fVwGxub+qA/gpwB6SGHculf9fKVx2d
 eelYv+16d1EPVyMnM42fvp7AnwcoVfmOz37mM1AhhXMhawMfqC9Ls7hfNlIKiXgDhydV zw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3run76uykt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jul 2023 00:58:38 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36HNZRZt038158
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jul 2023 00:58:37 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ruhw4dep5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jul 2023 00:58:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BlBJy3pAytJVtIdhyu5dFmM1bA9+FGfSD0IsndWFK9sIG5egS1NFHqmLDip3J7xAsacMYjtC5bjugKuc177nB5TIEkZv5A+43CJdnIY0dqlkBIejjApSyFCsnZ4pVu3vAxFKBZwTrki2H3MM3Sa83B965vfZaiDKpEuoZm5mUVyeFT26bDezMZh2tB6dO8+AeUep8rwk6BnLK/RVl3UJJrfrptaUMBwDzeSBW6HTElO5QyDpMFlflXhAh59oM+8Lt8JmsCJom5MU+qZtl5b4g/bHMpAnFUmdYrAtsFERIQ7eLWYbYGenCu4hks6JnNyjmNwoAzb2tkuE1EcrztVTUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mak46UXcilkj417dCDa9Mtr3u0tRdkRpXxnvZ70z1lw=;
 b=mzHO0rRFjcPvwbFCXL2a7QwiCnsVV/hv3dH5kEtG5qX60+lMh4I9uwUI9wwOib9vESNZaz7iGm4b1VeBNG6oQRKexfKfyxOjFww1HFbWvA8x5JT134QgVGx1XPI0YH1Z5o2DTtyR9W8lzFpSDv8m3Hx2i39jqLzDBZCjr9KdwVLu2++UJSLb6KjZr2p+EkR03bIwd+v3yTfBzSqpk6qfRGJ5dSn4/Ob0lTREUKx2gSn+oL9xWDC5yZ/peC1JQvgtkUI5xq1XcYwBgdrrHNk4UGN0jYEb/aCioXn+aJFpryIYrJMGT9wf75wlVkoByuZzPjz5h7Ts9nAS42Dx6naE+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mak46UXcilkj417dCDa9Mtr3u0tRdkRpXxnvZ70z1lw=;
 b=JD7WqbVNZV1bURW8uBGDu/d2Rf9LG/oejXU0LfpMTkq/P+gfxurpzUgHhpRGBoOdRF3loJvOURt25QB3emy4zmdJaJ9PAMFRIH44QQL8pfaTJMPylfKk1XVWu1v7GOA3R6nXrSCZIpGHBPGEr7cytXTo2CGy6jAvj2+JUkuqV3E=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CY5PR10MB6012.namprd10.prod.outlook.com (2603:10b6:930:27::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.32; Tue, 18 Jul
 2023 00:58:35 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::c1df:c537:ecc:4a6b]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::c1df:c537:ecc:4a6b%4]) with mapi id 15.20.6588.031; Tue, 18 Jul 2023
 00:58:35 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v1 0/2] xfs_db: add command to copy out files
Date:   Mon, 17 Jul 2023 17:58:31 -0700
Message-Id: <20230718005833.97091-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0179.namprd03.prod.outlook.com
 (2603:10b6:a03:338::34) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CY5PR10MB6012:EE_
X-MS-Office365-Filtering-Correlation-Id: 53c4753b-e56c-4300-2c3c-08db872a1d44
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0hc6J6T/Cg9zikiFa9GsIS2VtFrAzeAAF+zleNgr9K5TYkFDIj7J+fPwbhNxjGx0HTzEGqIYdTjdPcccnovfJejDz0wS8c+CsdgMaDZ/msabpUDhDGN5V3u6GpkhQi6GZDRJG0K8NK2f0qnuYWe547mramjG1UHj5XmJyrezk5IGRKyf9m/EZp+QIVqcTTO2SoL1BoBRDvBwB0hWvEDxL4nylY0TaKedW/V4E5JZSdugM3UrRvaJIA7+nDzxyFUBs62sXA+p/bBRkYvvWo1g/Z1qkzSkww1fKpPVOgB3FEfiTshL1asVfvBiXPIWeWJ35V59oCyC3gnnfU1/fvf3uBjO51Z5np18q/0lZhTW9Fg22QG1nscKStn3+cb30nr0sn89GaBhXE/ZBWDmbYV1ezB+3n0N9fvmXTWd6IUqhzXTmlnKsbK6GoeR2XglAJOz3PZz6pCpj5Kjf5YmgrhYSCbx+SpIA8VqVtNG7eGEX0xwaAmU5TnWK8X2n1Xbhw5rU0mxOBpiMsKNNjG3phyTtEIKQnmotzVbP2SauKEqjdzTIxF9a60QUrUpcvprLweU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(39860400002)(396003)(376002)(136003)(451199021)(2616005)(316002)(6506007)(1076003)(6512007)(83380400001)(186003)(41300700001)(6486002)(478600001)(6666004)(6916009)(44832011)(66946007)(66476007)(66556008)(38100700002)(5660300002)(8936002)(86362001)(8676002)(2906002)(36756003)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oDp0bksIoh77TXpoBbnn7St5kznWGObuOHX1joa2em2oTHnkCbzFo7OrIHqW?=
 =?us-ascii?Q?mS/S0Ikevh6lKdhwrQRO6VzarJn/oQpmVk8asgZywRRTB8LQACyiG3UNEBzX?=
 =?us-ascii?Q?+VLWx5R2mEMQ62aGgvubFnndtuxz/NgVGqW4cXExvBIh/1GEjtxjJCfHhASv?=
 =?us-ascii?Q?FOK3SuZa3WeMPhx06vU5WGnZ8oC451Q6Y9ifVs4blxXQc4hAR0j02T1EqDIh?=
 =?us-ascii?Q?JVFAmwPVuYucPIspP9pIqiQbzZ6F8UpK+SkMA0Df7Z3/yYDPxWxFw6cXEjC4?=
 =?us-ascii?Q?7weXZ2QUU0E+V84/o8u9GIV8+zaNhUlx5OBhePWy/ApRqIcZuITc9X+z5BeQ?=
 =?us-ascii?Q?crTdw5LW53DzuD2aFBXldLhDHea2pQ9+a+suDhTvjn7dv7AgKcdDC42FT1Tf?=
 =?us-ascii?Q?Xr99LJU/9UsZyLzZjFIhVLEWuzp/DgiSWZ+v8W9A6sjLBSZGNPaMXgRDfcYk?=
 =?us-ascii?Q?rTDNQEV1hSkBliIBhFZQguFc7v0M2I5pXganrPgyKs+JVlDEziILh7d8owO8?=
 =?us-ascii?Q?RO9ZNucV3mCbru41hoYbHNCahCyXkDyAiCiVha4JhhG0cPVrtboden+hkRb/?=
 =?us-ascii?Q?15mfTQPX4XuA5Vq5eTbsJBgpPkb0bIuu6mxgfVwvNSNZQsj4aRnaTesaEeqC?=
 =?us-ascii?Q?5h1fyjUprgIQY0l4gDbTbxa+pF/HFODj/32jcvKm5FHNRD/s+33/LPngicJb?=
 =?us-ascii?Q?l1pfU14jy+ciHY+kkvb/H+oNlSvkXCHRVE5kRp9uURLV07exF+1y6hoxiRLw?=
 =?us-ascii?Q?DnHBGgr8POrQuuQcgx3/Ws307hGkKYq9W4giseEiJFhl+HlUPUz9pZ2sOD9S?=
 =?us-ascii?Q?Ak/MowV6tTs6Rezh7mL9MR11XBmYw7HGPb3O9nR71clrC5wzwx6Lk8W5UZJw?=
 =?us-ascii?Q?1oDnyi8QlOiJRhIzpM/S5FEmEf7uXNKeF7jB3VgXdGC0tXlQ6lGe65dU3rJE?=
 =?us-ascii?Q?TucNNB15GATN+A54T7obApfjV9zV1jrJRo3dovY3qj86NMCHb4iCu6t6WJ0Z?=
 =?us-ascii?Q?4vk4kuUK3hCyDplH8pgw9XGvNBSwViq4SMFV4PFRLFF9zMG4u3qv9Rl6y01V?=
 =?us-ascii?Q?IpXx9R5OpIgIqS2tY94GbunF0c2rLv43Y/W4JAnVEtVVGXsrPVkz7GmxQOc4?=
 =?us-ascii?Q?V5avGjWo+GEhylHJAQmPtNIUNbegPk+LhUVF6wHY/uWn3qNKu+gKJa1sj0kX?=
 =?us-ascii?Q?ekLvM+CWlqlqXyAl2I1v4iswfdcjwb7cdW8HrbNxfSiTSvNONY9hafZgBvzQ?=
 =?us-ascii?Q?1A5lJtsqCYtHyTXhjt1U9ayUNl51dUU9kS5WAV2BNXonryU9nyqYqXDCoiF7?=
 =?us-ascii?Q?1bbNFuDdSKjCCB5mq1lOY0znBQrFO9vp8oQqgAG5X3bPKO51SxK/8wa5+MGS?=
 =?us-ascii?Q?LNYVdPTLE109mFNjI5VRPnQ0RY6MduwkyQUkIIbknEpvX4ci8c8jqR1QxJhd?=
 =?us-ascii?Q?m2UFNhZesKlDrbl5M5Ggfmn+R8hBuEvO7H8HtZydF5xcSgBCQworjyRjf0ov?=
 =?us-ascii?Q?RcBQdq/V4pzd5LisD2Z3cuugHF7Vm7hIZTo2JCeAWPL7JgL1+NIdxV8igkX8?=
 =?us-ascii?Q?Xx3Dz0HL2RJi8Q/Y5sn33/KjFm7s6/bGZqEtgpujSbCIu2GLIQx3A+mvaYwU?=
 =?us-ascii?Q?+bLTkGBxUK1eUuieKu7m3B8NH42OdP7KaFK8tQQh7LN11sxVXseYSTenFIyb?=
 =?us-ascii?Q?XXdSiA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 3r7g0VDEgfDEkmYoUbXlp71WMva6B7Zpp4/YqMkx0WvZOtW3vwIbb6BlgM2wJl/P79gQV9JMCb6O5R9dzKDlgfGzMoDzZ1cozbxpSSH9DNuGUIG86aeblbFtj2HYno5OZsmtSmZqf0I3SILpGZsudOHQqPWnLYG39J3xXJKdub2qe5PwI1IHK5PVa7q2sE334w21aLzGQYbqJEeRPQboXxgxrlCOZZrarwnYN+cJbbkomItFWQXTXnmzPyRSyuYMY7ImiZsRCzAl3kW3j/4RxCILvqytIEZ+4eZMwbL/ueAAQIGLllxYsKwiwojL4qMVaNNranl98jHi/Dp+Ue+ItYbtqlWe5+sqbFpYJ7MWiPPnN5COpC6lW9tQXd3sC3OT2UpOza92i2geS8ySG3yEiUZ3JtIhQQBG5evSukIfTM9zhb9zWSrEhb1C0tt8nwBaycw7yHI04NKz0tdJ6wRI92F2+z6F5cG3XyqbRJy6+MgIqvryQoBjWxtP+3QQ1pMBZOfzuf1+UJVpOvRZftJai52t7vsWHn0ZrMuEok77/cc1WyzrqpeFPeImuyJKEtilmmA+iukjHuL2RVIRP/iMXKE9t9SxawiS+bCgZOYUbumHsTms8F3P47RKPnMeo+5y257rLW2ZtXSy/8wleID+hsfBeB1B9cfSGGdCbFheWeFO1TbrnI/P93EtPl1a2vdlC+ms4yvcMDbXqpo1MJqksdwmvmSrTFqNifpUMfCKxZGfxnBACtAHm+uG8sQCY24I+NnECP4g7/4lcCxixwZR1A==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53c4753b-e56c-4300-2c3c-08db872a1d44
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2023 00:58:35.3799
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e4EKnDKW75uh+tan0rcyFHF8NI1mvlkNjHG1C7u0kP4dFasuwLyoMUSxPQxW49Fl5Z+7W7FEEvW1jpD1uAJHZfD8ZDcVgfh58nFLtx/6fQ4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6012
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-17_15,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 adultscore=0 spamscore=0 bulkscore=0 malwarescore=0 mlxlogscore=877
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307180007
X-Proofpoint-GUID: sJ_ln52iw5su-ufrhrGeJ_pWk0FMSGxz
X-Proofpoint-ORIG-GUID: sJ_ln52iw5su-ufrhrGeJ_pWk0FMSGxz
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This patchset adds a new xfs_db command that enables users to copy out files
from a block device to a specified destination.

Comments and feedback appreciated!

Catherine

Catherine Hoang (2):
  xfs_db: create header file for directory iteration code
  xfs_db: add a directory copy command

 db/Makefile       |   4 +-
 db/command.c      |   1 +
 db/command.h      |   1 +
 db/copyout.c      | 320 ++++++++++++++++++++++++++++++++++++++++++++++
 db/namei.c        |  48 ++++---
 db/namei.h        |  13 ++
 man/man8/xfs_db.8 |   7 +
 7 files changed, 373 insertions(+), 21 deletions(-)
 create mode 100644 db/copyout.c
 create mode 100644 db/namei.h

-- 
2.34.1

