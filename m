Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0604C636D7
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Feb 2023 04:07:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbjBMEHP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 12 Feb 2023 23:07:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbjBMEHO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Feb 2023 23:07:14 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50D97EC57
        for <linux-xfs@vger.kernel.org>; Sun, 12 Feb 2023 20:07:12 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31D1ipdM026534;
        Mon, 13 Feb 2023 04:07:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=JfYCvhRw5M7kfNVVfhxoZ3n3xeLGPVu/dk6zQd3jrEE=;
 b=qt1K4mMYO9w+TZyL/iiQ9V/qWyzwOgs4THddLKnuQgRFUImL3Mw4ztGB4gVghwyxWbla
 1rtcSaQDhUUKRAuBsi+2n0OODFRP92FTZh3kujfAgcsmJPROJmYHMIeu37UNfTGF74L0
 6OyeBGDEWH7eJTTYacbo+FyMNM0u5KaOMHdkVMZ1WB9+9B90k0eGf5V+MnTLSct8CGa2
 7wqZMw80Sp0jU26qqxFRBaXJj5dDJfL2D0JpUvN3nXO1/2Z/+EMXlOLd7eDE7XjufrQg
 e6p3IJTX7rVKQi/njgOHO25PVbmT3V1yKJz6iSrnScYNkRwGfdHu7hZJERklBOUDc72E Hg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np1ed9w2m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Feb 2023 04:07:08 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31D2UNRX011581;
        Mon, 13 Feb 2023 04:07:08 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f3k1by-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Feb 2023 04:07:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S+gtmyOiLfyY5VgbL2wg6/bOkxCJ9u88Iqxq/eT2ydaSGedEaQM6ATObooDAepviS1uEIWWVBdEy4dGJ0vkMNTC3bOj5NXTaXP1VrRCjGLvRzBkQ+kiEyPfUQu5XDam6ljCPl0wFY+btlOgoUegefpmrp0/AXIsGEjHtrGrZiQiK+gPg0aOgWhMiwaOjkN3gHYfHAZWrQZzE06XHS2krnoVtmI771JtTTFzPcgOrct2j6lU725QXYOSZxxxGaT9pISXPyld8Mt1mjBf8bgFqCieBUWoqaZDRTubTivk8d21sHW01HLfGLNyAZbGtw2kklVZCWACzsGaEc3Vd0pltpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JfYCvhRw5M7kfNVVfhxoZ3n3xeLGPVu/dk6zQd3jrEE=;
 b=MCenpDbgvYcuevGvNFK6N5j9MLIWX8LoRMkwmVKTrB0IQk+Yy5v2coczyRpfHAkpBdY106k4pVU5xJvtq5kOnTef2zwf3NTWQYmK10y5i5BVyZnV+j7HxgafNJgoxE5jVoXCzr8JYhvh+yNJFm7sdd27h8SoO9Igydpbgqla/gWHhz/x3wNfJLnNnExYtKkHV2MqetxUAPS92aod2zmr6HWUYd5o/2fTtVBjv9g8s7Bg56BuSmO10/lWl12SG9fwudJAJbHWSLZX0lMA3X00ctyCYpabvkwGt3nit/NaLoF/Uyg4OjJkwbGw+9gS4u8jMqpVGd40XrEIqMBi2jKufw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JfYCvhRw5M7kfNVVfhxoZ3n3xeLGPVu/dk6zQd3jrEE=;
 b=lcf40b6Qgtl66Gx0aWKBiOagBK1CNuU/Z4m/rkq/wxGHtEXpJ2rsPbnheOgYdPqdgwfdHuAt2J1h/jiS+ZusaxD9+YbqDnsGYqeFaYXKcVWfSqj/cg056xI5MXnecnIj8H1Lglb8VVLDFEBY269r/Z+rUThc3jIPU7AvKLXG7gM=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CH0PR10MB5225.namprd10.prod.outlook.com (2603:10b6:610:c5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.10; Mon, 13 Feb
 2023 04:07:06 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c%3]) with mapi id 15.20.6111.009; Mon, 13 Feb 2023
 04:07:06 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 17/25] xfs: change the order in which child and parent defer ops are finished
Date:   Mon, 13 Feb 2023 09:34:37 +0530
Message-Id: <20230213040445.192946-18-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230213040445.192946-1-chandan.babu@oracle.com>
References: <20230213040445.192946-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0006.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::14) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CH0PR10MB5225:EE_
X-MS-Office365-Filtering-Correlation-Id: fbbab0d6-9e8b-4614-3f68-08db0d77c536
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bFWfJWvA/25iEpghwHJx38nHQ06uNisaVAJgCMl3dsON/8fjQ0/gQ4ftMk5KRG6Cmm9EJcdXRBKz/q2WBJcFV7O6gRDfuBrKkQqOUMvwuIPNqtCm7rSleBSxbvxU2CX4Ak3hhI26BPnJS8gJytXTtkxGK6GYUUtv8esDHSQpcIcLgktqXazEno7bo64LNS0yG1ERrkCJAMH3dUyQsHG7expAv/l/xUo8X7v/3peK88iJwLqEXwyfjE2T1HeHadxZbxZCrTx1YAxeVA1XzPCi6aN/hgSn6PJ4aeVXGf0OTpWJtKCb5+Wbk6s9Cj2z1tQLUftmSIPT38O6XIx/T2oKZHoh7kxU9hAAe8lEYo4mHsojkbRKKi5NXlXbncACB6NXiPB2f0UyuWcsw89JRGq+vsUskazl+3NIglq5v3re2ZOQORnJlbz1DKXR23i3q23j03ygxVBqklb3eA1aZ9Zv4snUXETwaFj9Mv0/TLbCRhpka9m2R9GSriYpsuQagvbxiNGEKmf8usJ0Z/eyfP/aTBL+HUA5iXJTyshjDEqlSmgZBuqKphMKhgHgu9RPlY1Iu73OAn6LFpj+uO4GkHw+w1D2O1wds7wWbf+wTK2SZY3SHgjccnRhQ1e3yXvMP/BFOVPYCwvepVC1dq2oMN4R0A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(346002)(376002)(39860400002)(136003)(451199018)(2906002)(8936002)(36756003)(5660300002)(66574015)(86362001)(2616005)(83380400001)(6916009)(4326008)(316002)(38100700002)(66556008)(66946007)(66476007)(41300700001)(8676002)(6486002)(478600001)(6666004)(6512007)(1076003)(6506007)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ku3sqQpmdkPWqcLCcOXMORXcJixno2p+u8Ntgu7O4F76RGJebnv5shAG6f9t?=
 =?us-ascii?Q?S75PuR6x5i86OFF2xMjBojl6DTjoajyjLGee273lMv8VpZ6pXIksSwSrr9YT?=
 =?us-ascii?Q?cTP4QQDriTD4MRwnjYBjukZ1mHzuDM7PYwO4fy98yohw1pMQvXlQK064vgWv?=
 =?us-ascii?Q?26qCww/E/xHm2pv+TAEWRquzzvmHYM9OWVCjHHzJNoNKzp2Iz/o0IZrs7u6b?=
 =?us-ascii?Q?g9wIzPl9ABAO/jT1poBAc/1oYIdgN48dsZBNNiQ4pU/i3k42SVeR+MXLzesT?=
 =?us-ascii?Q?dBNgxJ1iDRGh7wDXf8zdjF/eb4Nhrbr7Q/LW/kBmsn0seOPN9BfivgD2Idci?=
 =?us-ascii?Q?kwl5QGLf3C/8PUt0ztXaewcF/pq2vSq2vMGYz9rR+sbWsruPz/NxZRnSKds8?=
 =?us-ascii?Q?IhPRgKHYdaNyd8V1fzx00/BfWFsKU5sIhK0IYTT40uWnxDT3HMxOLPUxZMNo?=
 =?us-ascii?Q?hWhuItNnDert3yRYB2UVd+rk+Hcs6RZRN1b3ePAAvI/U2sVmus/qNYJH4tca?=
 =?us-ascii?Q?8LN5mj7aGMUNAIZp6GpHV6G3cRnU/Gc9Y/kNhACUmICq7DPsPDu7UA2FXH3q?=
 =?us-ascii?Q?+YPecfzeEuwESueU0872ZMpU1gf8SRc+OSjmDL2PDUpo8SfVqJ6OUmqZZBkZ?=
 =?us-ascii?Q?WRaKIqaT61aWss+rv7fU4BJf1zXSaum1N1wK8sZHo+ShSZMbxKB+81tRPne0?=
 =?us-ascii?Q?el/1qNEpSruK410SfUiKWSJXVZ28AQGfjhyTRa1IFnvPG4r27w5MQSvtBLKe?=
 =?us-ascii?Q?T4bfKQynbZonfXSchH4O11SAHYuVt57l0zP7DXYuJubaAq33T1ZCah1mU/XI?=
 =?us-ascii?Q?Hk5a6BvRfC2bj3rBTrcG5gdLQHi/5PuC8aqmLBuYbyAq67LTdMygK/fxZ6Rp?=
 =?us-ascii?Q?p5QRlqqL3Dy+AC2X4wVsVgomyA5WCeHBsQAH5xycNIlGfOJmAQRCRAQ2Mklp?=
 =?us-ascii?Q?NM+UKn0/oN7hdMgo/U4+k+wt3OS9e0gIL/xD63vWyVpI6JHeysZckLK4iett?=
 =?us-ascii?Q?lvZYQp84xIBVuY1BqRW+vJhCEqoZxA0pYfdZHd1gtUWiCf8vmeK6SPmy4j83?=
 =?us-ascii?Q?dArGTMp7XdUkPPkFezD2Qys3Fg/vaHzk0VEIkbBtnxriuVbu7SRzumwIVMlG?=
 =?us-ascii?Q?+rejNZ7NHznhnXeSVDjIcrNWo+1ayXbV0fNWMDEVFjopWHLY2JeUyKq0G9xN?=
 =?us-ascii?Q?uAGA4I8vnJXfGQQKIQcLE8+p7t+b5/q6u8t3/X9rLiYvg24u9vAPee8iOtXs?=
 =?us-ascii?Q?1sHVhxgh0pgGv14NsIJTUJN/5MCQeWioz02a7UC8TTcMgWAbsJ/x4nkOxy1O?=
 =?us-ascii?Q?Y+gWf3fh8iKJMGsjCwbvF8IqD2J/L9KPd30a6JEQM3AJLxLm2aYv7R02jUiz?=
 =?us-ascii?Q?a3rsBNzoXn6yDcNFwJRyXfClsjycan+v0LLfSLfQg8p+3I6r3SuH3DrdYMbS?=
 =?us-ascii?Q?eNKV1ERswEsUoBAMcfgTYKHk/OXa4iZfH51jt51/7h80gQaV+Nc2fhsDVJ2R?=
 =?us-ascii?Q?sz2wdLCYLsyTqhvmgCsnef3wZOLUxKud+QjywkAzfC1+jkgAnAqq/6Z34lb/?=
 =?us-ascii?Q?18p70wazC29mwIapfMurX0vlr/ZP65rMrtrnD7Oq7vG6muTc3i6S35bMrEwv?=
 =?us-ascii?Q?4w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: SLgNnrYHDQdPtr1vzUT+A8eyUpamE4X7dCpZJ9kbqFJuK/htPsnL+K5Tl+Kc8vYvmdRkYNrrsXkH9YoA6n+0eWj0c30dOyxMPP+OFrFQS2gwbfzyBYZK02vKgvkXqPN2JoiC0gZN4HQP+3F0bFy0J2AnP7QOs46cAVKZgG8pasP01eQnalnLlLB8R6As6LwfXkifX/+EuG6/5VhNcftsx7jvWQv6JXzqKypLUyoaIe9/Vp3SQjANMVKePg0v9+MVhhyVaolbTZfMf54QVRks5aRy3KrGHXWX4nIEQ6HxJTLNuvIq361vevl7iFQvGfkSuKu46BVkbSqGeyoVpvSubCFgmpYyjA+0mDRT0MLI6QhdSOfgQ6Y942guxVS1ddmcJbJ/vOjZ5ACESy8n8+XWSoiW/gM+jwr6irXnYDptTnvAJs5d0h1JbmYK7Y8Iykm5sprHcPv5qRDCJuoXghb1cORlnsn38JWkUl5LkpZNMPVR/AKeTP4W9lRhaHsd2jC2n3XW7z5N7IIkbL7e65yPNXZwlhTZ65MI5nmc+U6WFTcUrbW14lciV/IyJuzT1wqCH3bAtTYy9M3FOlrU6OP2Z6gfb5b7xuKYapLcJ6mAxv+kbrgC/mJbtd29bzNFSXYTryiObCtD5FGcHBEWLZde6yFqLuZF5fOthk9Dey0urLZ8bM9V5Lk7Ct77nOEEu0Tc00n/wM7gWl9Xl6au005nNO+KFvlst7piFznJMd0q+AlqABn70T6QzUceO1d/gbcIHVvlSL87pc10SHVhZ4fxNqyccmjw9zfJa5JUitZ8mGp8bBJpyHmo+josDiYaTnn0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbbab0d6-9e8b-4614-3f68-08db0d77c536
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 04:07:06.5399
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GP+2mFF7qUZPN087sabVaTrmAV3ba+NI3vzp27dD/RC9BTPXq1HLchZ/eMEu8+WKbhCh33UAME3yDPLUOqewKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5225
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-12_12,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxscore=0 spamscore=0 mlxlogscore=999 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302130036
X-Proofpoint-GUID: Zxg5O8_L_IeUHI5P2dJxHTfp3qHtJrgn
X-Proofpoint-ORIG-GUID: Zxg5O8_L_IeUHI5P2dJxHTfp3qHtJrgn
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 27dada070d59c28a441f1907d2cec891b17dcb26 upstream.

The defer ops code has been finishing items in the wrong order -- if a
top level defer op creates items A and B, and finishing item A creates
more defer ops A1 and A2, we'll put the new items on the end of the
chain and process them in the order A B A1 A2.  This is kind of weird,
since it's convenient for programmers to be able to think of A and B as
an ordered sequence where all the sub-tasks for A must finish before we
move on to B, e.g. A A1 A2 D.

Right now, our log intent items are not so complex that this matters,
but this will become important for the atomic extent swapping patchset.
In order to maintain correct reference counting of extents, we have to
unmap and remap extents in that order, and we want to complete that work
before moving on to the next range that the user wants to swap.  This
patch fixes defer ops to satsify that requirement.

The primary symptom of the incorrect order was noticed in an early
performance analysis of the atomic extent swap code.  An astonishingly
large number of deferred work items accumulated when userspace requested
an atomic update of two very fragmented files.  The cause of this was
traced to the same ordering bug in the inner loop of
xfs_defer_finish_noroll.

If the ->finish_item method of a deferred operation queues new deferred
operations, those new deferred ops are appended to the tail of the
pending work list.  To illustrate, say that a caller creates a
transaction t0 with four deferred operations D0-D3.  The first thing
defer ops does is roll the transaction to t1, leaving us with:

t1: D0(t0), D1(t0), D2(t0), D3(t0)

Let's say that finishing each of D0-D3 will create two new deferred ops.
After finish D0 and roll, we'll have the following chain:

t2: D1(t0), D2(t0), D3(t0), d4(t1), d5(t1)

d4 and d5 were logged to t1.  Notice that while we're about to start
work on D1, we haven't actually completed all the work implied by D0
being finished.  So far we've been careful (or lucky) to structure the
dfops callers such that D1 doesn't depend on d4 or d5 being finished,
but this is a potential logic bomb.

There's a second problem lurking.  Let's see what happens as we finish
D1-D3:

t3: D2(t0), D3(t0), d4(t1), d5(t1), d6(t2), d7(t2)
t4: D3(t0), d4(t1), d5(t1), d6(t2), d7(t2), d8(t3), d9(t3)
t5: d4(t1), d5(t1), d6(t2), d7(t2), d8(t3), d9(t3), d10(t4), d11(t4)

Let's say that d4-d11 are simple work items that don't queue any other
operations, which means that we can complete each d4 and roll to t6:

t6: d5(t1), d6(t2), d7(t2), d8(t3), d9(t3), d10(t4), d11(t4)
t7: d6(t2), d7(t2), d8(t3), d9(t3), d10(t4), d11(t4)
...
t11: d10(t4), d11(t4)
t12: d11(t4)
<done>

When we try to roll to transaction #12, we're holding defer op d11,
which we logged way back in t4.  This means that the tail of the log is
pinned at t4.  If the log is very small or there are a lot of other
threads updating metadata, this means that we might have wrapped the log
and cannot get roll to t11 because there isn't enough space left before
we'd run into t4.

Let's shift back to the original failure.  I mentioned before that I
discovered this flaw while developing the atomic file update code.  In
that scenario, we have a defer op (D0) that finds a range of file blocks
to remap, creates a handful of new defer ops to do that, and then asks
to be continued with however much work remains.

So, D0 is the original swapext deferred op.  The first thing defer ops
does is rolls to t1:

t1: D0(t0)

We try to finish D0, logging d1 and d2 in the process, but can't get all
the work done.  We log a done item and a new intent item for the work
that D0 still has to do, and roll to t2:

t2: D0'(t1), d1(t1), d2(t1)

We roll and try to finish D0', but still can't get all the work done, so
we log a done item and a new intent item for it, requeue D0 a second
time, and roll to t3:

t3: D0''(t2), d1(t1), d2(t1), d3(t2), d4(t2)

If it takes 48 more rolls to complete D0, then we'll finally dispense
with D0 in t50:

t50: D<fifty primes>(t49), d1(t1), ..., d102(t50)

We then try to roll again to get a chain like this:

t51: d1(t1), d2(t1), ..., d101(t50), d102(t50)
...
t152: d102(t50)
<done>

Notice that in rolling to transaction #51, we're holding on to a log
intent item for d1 that was logged in transaction #1.  This means that
the tail of the log is pinned at t1.  If the log is very small or there
are a lot of other threads updating metadata, this means that we might
have wrapped the log and cannot roll to t51 because there isn't enough
space left before we'd run into t1.  This is of course problem #2 again.

But notice the third problem with this scenario: we have 102 defer ops
tied to this transaction!  Each of these items are backed by pinned
kernel memory, which means that we risk OOM if the chains get too long.

Yikes.  Problem #1 is a subtle logic bomb that could hit someone in the
future; problem #2 applies (rarely) to the current upstream, and problem

This is not how incremental deferred operations were supposed to work.
The dfops design of logging in the same transaction an intent-done item
and a new intent item for the work remaining was to make it so that we
only have to juggle enough deferred work items to finish that one small
piece of work.  Deferred log item recovery will find that first
unfinished work item and restart it, no matter how many other intent
items might follow it in the log.  Therefore, it's ok to put the new
intents at the start of the dfops chain.

For the first example, the chains look like this:

t2: d4(t1), d5(t1), D1(t0), D2(t0), D3(t0)
t3: d5(t1), D1(t0), D2(t0), D3(t0)
...
t9: d9(t7), D3(t0)
t10: D3(t0)
t11: d10(t10), d11(t10)
t12: d11(t10)

For the second example, the chains look like this:

t1: D0(t0)
t2: d1(t1), d2(t1), D0'(t1)
t3: d2(t1), D0'(t1)
t4: D0'(t1)
t5: d1(t4), d2(t4), D0''(t4)
...
t148: D0<50 primes>(t147)
t149: d101(t148), d102(t148)
t150: d102(t148)
<done>

This actually sucks more for pinning the log tail (we try to roll to t10
while holding an intent item that was logged in t1) but we've solved
problem #1.  We've also reduced the maximum chain length from:

    sum(all the new items) + nr_original_items

to:

    max(new items that each original item creates) + nr_original_items

This solves problem #3 by sharply reducing the number of defer ops that
can be attached to a transaction at any given time.  The change makes
the problem of log tail pinning worse, but is improvement we need to
solve problem #2.  Actually solving #2, however, is left to the next
patch.

Note that a subsequent analysis of some hard-to-trigger reflink and COW
livelocks on extremely fragmented filesystems (or systems running a lot
of IO threads) showed the same symptoms -- uncomfortably large numbers
of incore deferred work items and occasional stalls in the transaction
grant code while waiting for log reservations.  I think this patch and
the next one will also solve these problems.

As originally written, the code used list_splice_tail_init instead of
list_splice_init, so change that, and leave a short comment explaining
our actions.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_defer.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 714756931317..c817b8924f9a 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -431,8 +431,17 @@ xfs_defer_finish_noroll(
 
 	/* Until we run out of pending work to finish... */
 	while (!list_empty(&dop_pending) || !list_empty(&(*tp)->t_dfops)) {
+		/*
+		 * Deferred items that are created in the process of finishing
+		 * other deferred work items should be queued at the head of
+		 * the pending list, which puts them ahead of the deferred work
+		 * that was created by the caller.  This keeps the number of
+		 * pending work items to a minimum, which decreases the amount
+		 * of time that any one intent item can stick around in memory,
+		 * pinning the log tail.
+		 */
 		xfs_defer_create_intents(*tp);
-		list_splice_tail_init(&(*tp)->t_dfops, &dop_pending);
+		list_splice_init(&(*tp)->t_dfops, &dop_pending);
 
 		error = xfs_defer_trans_roll(tp);
 		if (error)
-- 
2.35.1

