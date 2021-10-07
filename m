Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 183ABC433FE
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Oct 2021 00:26:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA30461177
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Oct 2021 00:26:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232532AbhJGA2p (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Oct 2021 20:28:45 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:47142 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232248AbhJGA2o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Oct 2021 20:28:44 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 196NMFAx018604;
        Thu, 7 Oct 2021 00:26:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=jXRWR+g1LUxbO1G+p5Cu+D4FyIzwGK2x98eRuD7Apt4=;
 b=eO6ZD4opA5zYTbj2XDXrxgJUsh2wgNvkjBLW7mXt1slcmIKeY3B00LkiYnI8KruwDAWG
 He1/dviQam12D3ByYbyWdI65ESTSmGFVeuXbCUAb7OBdeM5x4kRHQcUVFluC6CKHxtB8
 /9eyKDfxy7GRYSFES8ajYJdpDGlkjefIt+bfkapVl3rUi8/bAveCfXskxptzvYHobLRq
 RFITHCBmcHUgnIOcQp//l05JALxkKT18IkTpNZuSV0Zm8DOVvsJCXmz6Xz/JniKADEeL
 9DFzesbUfyWCpWGtBYcOJYoM+u/2vcC9CTcGdh5syog3MkCGMwftY0ga0NGo5cFlg1sP mw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bh1ds0g2w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Oct 2021 00:26:51 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1970AkGB192858;
        Thu, 7 Oct 2021 00:26:49 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by userp3020.oracle.com with ESMTP id 3bf16vya41-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Oct 2021 00:26:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YxeZ0gzC4wNBEObU1SK0FEVfKofr7iwd6axinuZ6r6RHi8+ZziCWlBlgGMVimjHVpXXlQyDcqJQpwb9nNlFpfa6rJQWh+qXTUHY9q5ep/V+oU4EqPxBVEx60tC02cYRFUTJcTHyqY9aihmPRY25+J0/dwf9BmKF4e/lumhwduVfggL7mcW8CGIfE/zaIcqZVCDAyBs9m/5IcLeepFmbZGGCZE0PqKjIiCsNfro8S9VWfhKhgM9cQ3F5zMCzMfQ88badiT5bm7ytN0gzPC8smHadOwzhYZF1KYN4Bzb/fSA3BzRmkm0JPPXdeqiiFSnIog0fZ5aYj5qiMZPvhIEpPGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jXRWR+g1LUxbO1G+p5Cu+D4FyIzwGK2x98eRuD7Apt4=;
 b=eczSi7unXxY/guARWYhFDPTaq++f8Aqkk2N5rfycjKSx9x3KUGv49Jm3sameN2odDwN1LgiaYHc2uRQpwk0VLRYQyATo2SUk7X5icXpIElGnTEZZXGEmuZqHr1RpOIAEvxYABEnz+bvPqKJZ2nmyXOgJ/z7NO8tR6DQiKD3VwS99EJBNUz6pu9BkaiKTugoL0uTPOGto0SRtqf1QHgSwEhJqTTsve0At8rOdMkGa6eznBRczN+jy4bzKovO8oxD6h6f/X3+Q4UN9o2YcdFOerhFsLfTDW5GMpbJ64RmAZDuhB4/XVZtNg973p1XSiyFjfR+bib63TiIRoT+JNHHisQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jXRWR+g1LUxbO1G+p5Cu+D4FyIzwGK2x98eRuD7Apt4=;
 b=SHWLGICKWfTOp065UiH31m5SwaX3OQFblMnz98GGXbZSo2smh0zQMeUnIT+NBMEHv4mtvC/OcT4YYff7Q5gD0cCFC17Y/YP+KQvF+fg+7oPiYHAQdX09NRjmUfN8Rkyjz5Zr7/f7cg8AAEiXreGzAU0h3tag1jTd1JARuk9/o70=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB2795.namprd10.prod.outlook.com (2603:10b6:5:70::21) by
 DS7PR10MB5118.namprd10.prod.outlook.com (2603:10b6:5:3b0::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.18; Thu, 7 Oct 2021 00:26:47 +0000
Received: from DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::a59b:518a:8dc9:4f72]) by DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::a59b:518a:8dc9:4f72%6]) with mapi id 15.20.4566.023; Thu, 7 Oct 2021
 00:26:47 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc:     allison.henderson@oracle.com
Subject: [PATCH v2 0/4] Dump log cleanups
Date:   Thu,  7 Oct 2021 00:26:37 +0000
Message-Id: <20211007002641.714906-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR05CA0019.namprd05.prod.outlook.com
 (2603:10b6:208:c0::32) To DM6PR10MB2795.namprd10.prod.outlook.com
 (2603:10b6:5:70::21)
MIME-Version: 1.0
Received: from instance-20210819-1300.osdevelopmeniad.oraclevcn.com (209.17.40.39) by MN2PR05CA0019.namprd05.prod.outlook.com (2603:10b6:208:c0::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.9 via Frontend Transport; Thu, 7 Oct 2021 00:26:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b0199738-124c-4e4c-64e9-08d9892925ff
X-MS-TrafficTypeDiagnostic: DS7PR10MB5118:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DS7PR10MB511837BF9BD810F58AB198CA89B19@DS7PR10MB5118.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ps1q3wYNbOLAcFdXL3Dg5PLYsHlA4wZA545Dhw4cfRgs2qRqG0KBDMJXLSDbBNNZcXCke6ZWW8yQzRXuB8qIvzDW9s73QnCnYZKe18AZdcGzD32KEnULorXwd6lDin6n0WDbtPJKdjWfzaB4KVwjJSGGmqf3is7V+fkys6ShoGdPEQEGdfX0jAZ7YDpWzoRFUeQ1HSCVYSJ9YWuZFz5lD+et6lFvq2NgfFo/N83x6boxCG773QDBZruLwNUbwis83q30fiybZetbnCkCSykvAN6B1YseniPIy3yZ1ElH9pZz4yQ48v9cvxjPnxSX18wwoG16R52ALxCtpfx4cARCHyqYs2XI+OuHAWlohFsZgE0cSNq/dROWh0FIg/DLiHyV6UanAQsvKYdfjLUJMt5vvoqTCt21rY0KvviIKnXz3El5qXBZQ1yiq5MfTXGxCYAxZ3VkraWZQF6ACPiQN0zVh+ZwGj1yAZzEvZfMxQMFyaFMdIUAsE7CljaSBRrWbvpsEhCaV38yKdgNRCEb+mVwlz6vMJQ98/TdaYYkp5lfbw+w/Iq7V9rz+Pmzon47MQlgTQgmHgR0OUMrcb13aKGw5H2wF2VJBiAovb61KXxg2ZY38/CnE2/bwrrltnMR5iYgMr0EjToTwPJ31NqhrMFxeaBq7sYGGfKL1B+/Se40ZobB+OoaxGtJygkxrewabjowyxSMQEs4hYuOo5Iz1QHpeXDknvyg3xuHmgpQE7FQVP9knAxFQRxYQAn8ZQT5hU+sW8MF21GHyGDAGl7p/9aXOnl/s5Gm7tBhchhC6qG56o4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB2795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6512007)(966005)(508600001)(6666004)(38350700002)(186003)(2906002)(38100700002)(36756003)(107886003)(5660300002)(44832011)(83380400001)(8676002)(450100002)(316002)(26005)(6506007)(52116002)(66556008)(66946007)(956004)(1076003)(8936002)(4326008)(6486002)(2616005)(86362001)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hd1t/r1zaJVu3gDwxcY6znMZBBAcqq4R6fvG50HKHEQcXONypORRTQnf2VnE?=
 =?us-ascii?Q?p8jjmDOiE9+krQWuz8c4gO+2FiiIjcic9J/I77UL+7+JJzpkaXOmNNxxYlMR?=
 =?us-ascii?Q?j+J8Whs2polheuhd6UN9KOnAScaqn9e75AIvUEA9Z+zaRF3w6+H2Fcd6jdtR?=
 =?us-ascii?Q?xx3DALkrkmWaQHOnOx9nlW7h3NeO89V976GXNN7muZMm1TzDfMEAw0ikCIDQ?=
 =?us-ascii?Q?OD28svf/yiGlFzMd3qrakH1bHRJzqw5zGOHTnwTpD9PlCaoMyQBAYGbZ2BuZ?=
 =?us-ascii?Q?78qIiyTxF00vaMbBv8gIOsIyZp9cEYzxPT8NYdG3bD+shnUzKUfr4cfXfe2Q?=
 =?us-ascii?Q?MqG7itlMaQ+qDoIFkhLSPBXxY2JthxjzNGn0ZgeG6u+sVJKygWf+sGtuBgW/?=
 =?us-ascii?Q?9ygRbg2Q+vnkzdZLltUIfghJg1OR+9Y6j2q6gw6d+riUoHbZZhakRX+J/CFQ?=
 =?us-ascii?Q?9kMVf/idzdH6JpqXhagkNGNm5DP81tj//cP5LGNS6S88G95iM3EE7+IJZs+d?=
 =?us-ascii?Q?hpwsWrTdGOZrav97REJOyfKyb+fQbmBKxqS4KrzyAEWmBo91X3RyOCyTeTKA?=
 =?us-ascii?Q?Ed20dsh6iUBWqDGPHsjGtRz8XTHl4kc+0jIMfN6KAp2otiI1bc9GBSF5RhjL?=
 =?us-ascii?Q?qtp8lwv5TcLKZJtDbXf2OR/0Fm9lSpH6XFcGUexwXRXPFm9Ugd5759pP86mw?=
 =?us-ascii?Q?a146cji5NrvZ+68p674RFmwd3T0WvD0+YXzJDAiUaliDwFmEHZ++PT71kSdR?=
 =?us-ascii?Q?EjlP5biuJyu1tN8hQqdsEH9eMK0LgYia+937BLr7O2jjncefHFzdRIgXzO4h?=
 =?us-ascii?Q?QoYis125S/bvJJd41G3TlJsIE+hdi+c1bfIs1o/qlWnEDNE6ui+UFQjPAHR5?=
 =?us-ascii?Q?VkNrHtfs/HSUJ9yEmx/FOSknl1rkddn25oWhyvJ9+8aK8zI85RqL+VvNJhfY?=
 =?us-ascii?Q?kPOhaZHV1KA0CnBPN501TKPj6dxp5/jbnlhrvAHP0mKvsLRTSU8lkRJd7UCp?=
 =?us-ascii?Q?uwgCohHvE8aUTOPFzv9Mnj7wGC5Qp/rP0vogUgqgV4A7BphAjS7C8E/LgxXP?=
 =?us-ascii?Q?FMxtIpaartRujPlJBNoxDiLUs6BkY8KMdjaaOLIXwsSBYIzxeJW4t5a3kBYt?=
 =?us-ascii?Q?m9Ybg1i2cUEGs4mYwZ6EUDiawWQniskVvmQc6OoM2Iz+FsjzMPjZ8qxHToF8?=
 =?us-ascii?Q?93SA1vTWK0ovumMHfLSsszbZz4bJ+jU6+AKwlZkPlueGLz14coZjyTfH31z1?=
 =?us-ascii?Q?GWFXhw82GS3KQSs8zcBga0VKlmG9CVPP7lpDO3EWiaxBI4+t4LkQ3S7738xs?=
 =?us-ascii?Q?6KRdpw0ZecA3k7vOjrbTP84O?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0199738-124c-4e4c-64e9-08d9892925ff
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB2795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2021 00:26:47.5733
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /c1nZ+ebtskE8w8qH825MaRKZcHKBVflQp2NXkPHvKfBwJdFQ4f75A1hvoje2+MSTLr73m6XkuSWqhHJ5XM2fKiFDDWYN82lL749Ou5PcIU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5118
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10129 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=888 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110070000
X-Proofpoint-GUID: dEVSzPhpGhidjjsvJYPTqcdX1pTdgq7V
X-Proofpoint-ORIG-GUID: dEVSzPhpGhidjjsvJYPTqcdX1pTdgq7V
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This cleanup set is a followup to the log attribute replay test that was
posted here:

https://lore.kernel.org/linux-xfs/20210901221006.125888-2-catherine.hoang@oracle.com/

This set renames the *_inject_logprint functions to *_remount_dump_log
and moves them to common/log. 

Questions and feedback are appreciated!

Catherine

Catherine Hoang (4):
  xfstests: Rename _scratch_inject_logprint to _scratch_remount_dump_log
  xfstests: Rename _test_inject_logprint to _test_remount_dump_log
  common/log: Move *_dump_log routines to common/log
  common/log: Fix *_dump_log routines for ext4

 common/inject | 26 --------------------------
 common/log    | 30 ++++++++++++++++++++++++++++--
 tests/xfs/312 |  2 +-
 tests/xfs/313 |  2 +-
 tests/xfs/314 |  2 +-
 tests/xfs/315 |  2 +-
 tests/xfs/316 |  2 +-
 tests/xfs/317 |  2 +-
 tests/xfs/318 |  2 +-
 tests/xfs/319 |  2 +-
 tests/xfs/320 |  2 +-
 tests/xfs/321 |  2 +-
 tests/xfs/322 |  2 +-
 tests/xfs/323 |  2 +-
 tests/xfs/324 |  2 +-
 tests/xfs/325 |  2 +-
 tests/xfs/326 |  2 +-
 tests/xfs/329 |  2 +-
 18 files changed, 44 insertions(+), 44 deletions(-)

-- 
2.25.1

