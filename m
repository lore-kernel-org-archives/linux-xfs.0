Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24901C6FA83
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Sep 2022 13:28:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbiILN2t (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Sep 2022 09:28:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiILN2s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Sep 2022 09:28:48 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73A0C2FFEB
        for <linux-xfs@vger.kernel.org>; Mon, 12 Sep 2022 06:28:47 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28CDEU1I030586;
        Mon, 12 Sep 2022 13:28:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=+z8/X9rs5j3MF8996uc4EC+BLi3ffkFv4dRvoXql+VI=;
 b=T3Pz/Deqw/mLbZCau2iRmfJZ/QDRok0w5K9/8iyhnzHLZnfY1gPB2ixd7GkZRhBUyqPP
 NAIwKl6cLKRAfFXmW7jBjOGb2Ruq9K4PKDhl582Rbxvqc8Zc2FrowRXfTgEJbZciFB5u
 M2sXo1SmWPa+5ylfMFTqY2zSRUBa5SM6Yqk7OxO9lMXeqnHuJ3KS5BMtOzRyEo8BxiWI
 AtJWfEMDp9pcaP2bkgCQYIJ16uVdwadHlCjVKTj73th5LPkdJ/LkcaZyOxJZeGJCJezD
 z0LciK8l9uAkjy0aTlQ4FzwDWLZXgdPLOul6EDeiOjicumDmCs71arI9oPBHhCKIOASW ZQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jghc2kgtr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Sep 2022 13:28:43 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28CCEgYQ014596;
        Mon, 12 Sep 2022 13:28:43 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jgk8n7tv4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Sep 2022 13:28:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FuiN3XlCvWOFCTif6RvoWXpnfukfB803mjXpBIz9jjtZ2YcS+ueJ7g+bJztTYAiljk8Y/BO9ptZ5nLQTAzSyq7u2jkNIlv/YwggASh1qQJe62pvkSLkacbMjdQw70MHvwEdTSEPnBAPyBiStPd/dICg5gGQl9xeyy9QJcplT43RfqyEvYfVkryL/pkx3i90+m0riuBvzN+vmN1/o64N5Imkz2QZ6R6xjxezz49M3O8ewArzTRneFp4l/Lgg9ZiD6R2Pe4vDuyKIVKNiNEo+PQvF5x5ZOdZ8qhz864qgf+oZv0vo5Yx1tiRnfTy9A3jLLQiHbhmokZUyTvThzFFoi0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+z8/X9rs5j3MF8996uc4EC+BLi3ffkFv4dRvoXql+VI=;
 b=LVBNfr2VfZeTHWr0a7g/ybgpHNnQMVROQCNC7WgJR5qCrrSeLvYku0qwnmN2XDAHNy+Snk5/4riLExjG9qq/LSKVhAf9bNnDfTGpoHYlZ2+LAuH+XWvyil0mAbEoKolXbZZLSuM052uiCIxcKTsjLT46Yzj1MMcvePGMHDkdRS8c6vQjUZAXoYPRarExFk0iqr6UT7SgrJ8jpC6vHdJp8AEVX4QZekfiPvh7kzowS/OE2KtoPFeLyJp6Y6G6q2Cdx/q6A7yn4oE4iEyXnvxH2MRcb+GY6PFoby3I0tUvOa3keUhEq46Hf+bgqIa3ka3AnvhrG+5sz3JkMA6rfo/Tew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+z8/X9rs5j3MF8996uc4EC+BLi3ffkFv4dRvoXql+VI=;
 b=kxDiE5H47N0UGg2VBrORJEFGRtwaCIjXYVuwutT10MhMqUoR8VoN7ENLqaR4X0F7KbjIpGME6VI6FkV3J7laf7204p+Lc5ShKArZwcG40/cVEtcW6SEoNWJgux+93HNBwAB0jZtZWsoeR2EFyBV0PU7FZ5cj4vVBQsXVvX+QS6s=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by MN2PR10MB4173.namprd10.prod.outlook.com (2603:10b6:208:1d1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Mon, 12 Sep
 2022 13:28:41 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::709d:1484:641d:92dc]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::709d:1484:641d:92dc%4]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 13:28:41 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 07/18] xfs: range check ri_cnt when recovering log items
Date:   Mon, 12 Sep 2022 18:57:31 +0530
Message-Id: <20220912132742.1793276-8-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220912132742.1793276-1-chandan.babu@oracle.com>
References: <20220912132742.1793276-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0047.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::15) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|MN2PR10MB4173:EE_
X-MS-Office365-Filtering-Correlation-Id: 282a9e44-f9d6-4b48-e289-08da94c2b4f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w8Djsvj+29m86vkaWuFksU80cbabJY9xv0qktQEhoylXV51kRxUu+Q0Ri5Fjk2Vpjzp8OFoJwY1FXxa9pop76JbZMAT36oQxlOBkMLYk8dnaF3Px06DDFqQ+Kz1/w4wmPzlPtvk9iscnwwLuo7qC8qnOsV82nAQIRoJUEUGBxvIrZcShLY8A6ZAVUn7Zmr7Jfl0YAoO+ojaOWv3F+FUEROoymQ3Mk449e3jgaH4ZlWY7nK5jn1kAMleSMIGQQvteYADmpVEwy1Ntps7Kv1Ch0O6mw37Y2UAOVEplFjNnDhPjcHKIekZHm7Y6GSWzHI8WO8+eQ9jTexyBkE1nfJgt919D8povyjbQ5FlXoFXgt10/O8ifK5TiIXLrkUL6cAYb4mhe2g+pVAknQuBtcnyuU+fSTyxK4F4rc/6ba9Ja5xPbP8ozfzYYb5KvmwBS5z44t0qACB+emk3oo/+TXVmrIcVLogbXbuFsCzrjmko+4o55cie5sRirjfTtKuZV8KMMPU7WShxWQ2wdcaciMThiXXdA9ZNqm2aKi6n7u1FP6yttzVeNCaVKAEfDl11B+y834wf0vp7Lm7Sjxv5XIJKbRe1AdltC+ZAnFhiLGo+0ppzuJmZbTXQknt/rAAQIg9m32xU+5hqeOq3Jz8DDOPiMVQQ0+7l3N9YDCh9XOOIfJiTd8dUEPIFMLr1buYqRe2EmoXvrnta66ghCUO5zfPCuYA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(396003)(39860400002)(376002)(346002)(136003)(316002)(6916009)(38100700002)(6512007)(2906002)(5660300002)(8936002)(66946007)(66476007)(66556008)(8676002)(4326008)(186003)(6506007)(2616005)(1076003)(478600001)(26005)(83380400001)(41300700001)(6666004)(6486002)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oXvhkLobMyBdU2bQsd2+PhirXwbTEXbHPaK3/0wh6HhI37qjH+2MNW8ZHtqk?=
 =?us-ascii?Q?wqptuFLYEuDhc6dbtCievoYZfTWyWLP3OnL355GdAjMU5zM8mdBwLFso0vcP?=
 =?us-ascii?Q?5dVlCA3yMxQJ00aAkm8CkW2M030Tc2SJDuRzDKCqTjRBhjjaro1hPivlNyKM?=
 =?us-ascii?Q?2jAQEgEYmr2bhH3XWZ//djITpPtnjfE61lByF7F6WT91CvuVt747VCxcgWDH?=
 =?us-ascii?Q?jbw4kPGQLEPeX7PGnmkS/k60RBpdcabU0DnJiyz6e4zXM5eywr7KQBhf3kh/?=
 =?us-ascii?Q?IPVcqLRU3FXSDlnsifeVvdwEU3ZoaQ/4zOnGsss+Uoyywc4aun0QTw6JRLh6?=
 =?us-ascii?Q?/nuumBDVvzI9ql9L8izR2LZmD6g3EpoRk+yYh9ygmMuvPnx1NPwmDorV+XVz?=
 =?us-ascii?Q?LFM0sTbCyF36L9fhEiOHR4yMOts49pDCYHun4SP93B3D7NRdTlY7nIDCKEyH?=
 =?us-ascii?Q?SrECshbFjOUruguvX2OO4h3VPQmfbWBS90WtjHJNVDFJj7fey7mrgYQR5SQx?=
 =?us-ascii?Q?j8RZGlQvCPc8boK0ysWTFhWqqnNvKnjLjgzvd57JW2tobLc5fL4lIqk63+zk?=
 =?us-ascii?Q?TOg0yY7zQeEy2cJ1jTTKt3VK1N9dgvK88z29qEFyEgulJ581zGl1KhyR8OwL?=
 =?us-ascii?Q?VNKpjhgNUpAzrmGHu9nM57OKfq5snZM8Y1Anv2Nsp4x0LpzXOEeC4hHyJckt?=
 =?us-ascii?Q?hNKM7uVpccrkV0W0E3yuAWNy5nIysQ9HBmR0cBR7rv0uASnNFNdu88JqsTV1?=
 =?us-ascii?Q?YdB6iEnHbx+F1bx18Y3aVjhuw6FWG8gC8Q4/NpoHuWY6rMfOxaXyLlAtO8R6?=
 =?us-ascii?Q?2NKZxVdi+2V+mDFenCnYNtdjsjtoBFNoz7zUwwNnZeEpEHSGXhkioiKLdjFu?=
 =?us-ascii?Q?VLA5Bx+Uw95RRGkJB/lTIl6Ib1YMZMcvkvAGZRweo85uo43z2AS3lrN3yY2Y?=
 =?us-ascii?Q?Y/fKEhnjvVopXIo3Xwqf9+1NtoXeOTnYp2wfDcwC8EwX4p7OC9oTpyDPJl+Y?=
 =?us-ascii?Q?C7BYE9lb5cclKQpc9SU8VI4FHjDu+nCAssgoiGZC1Rb+CQcYM7XbzhkXifOU?=
 =?us-ascii?Q?+IdOqgSr/sydnRJGCWzmJQb8RmGpJvGYI8rE8T85kxsLpW0i9axgkXGWA9MA?=
 =?us-ascii?Q?ujX6VYges+alpbqfQsem40JkngJc72V2DYT1vKr0saeHYc8zLfWTjEk0W20L?=
 =?us-ascii?Q?fAxg8zxx5FLEsosnqQD+CvEyRswKIrA2wSngJbMQhVloXH19ORTwo6Bbn0tC?=
 =?us-ascii?Q?nEQMU/5MtLzC0OzH/dWqu0WhMvMue8/EdprkANSYJ+h6/9YwzcB/xHsNZUFk?=
 =?us-ascii?Q?dsD52+TNVDC3hY07Zd3tyrYjk9YfRYt7e13arqBQ3yrGgA4EQpzK/2opyg07?=
 =?us-ascii?Q?c+wgjezDo68/GddaSm8FROvOpRUN2t/Eoaw1771iYYgQthOueInJNwZKXnoG?=
 =?us-ascii?Q?VS+ze3YZcBQwKwPV6RMepvVa8G8eyeZ3DlhBZ6mWAcZRoxixmiMOJSWpFmPZ?=
 =?us-ascii?Q?trmJ0mYlBPaveZe0404OXaiaYHwgZO5/IyqRaSQez+BvH6i+Qj+jFw3viPSI?=
 =?us-ascii?Q?zeMBbmHZqxCbGRhWt+u9gsEiWi4zaxrXR3EGxTyiA7MdZ6BWK9qpxvId8bYI?=
 =?us-ascii?Q?ew=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 282a9e44-f9d6-4b48-e289-08da94c2b4f6
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 13:28:40.9959
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l5olEWovi50Kwpm8+Zxau/x/E+abWymjr2TxELOSICGLgbgQI89fnMPcA6gVN29XVjlaIo17FYDElqnqsB+yyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4173
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-12_08,2022-09-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209120045
X-Proofpoint-ORIG-GUID: 5Pv4VUv9Av9UHyxZwsl0RW32rXXRcdVg
X-Proofpoint-GUID: 5Pv4VUv9Av9UHyxZwsl0RW32rXXRcdVg
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit d6abecb82573fed5f7e4b595b5c0bd37707d2848 upstream.

Range check the region counter when we're reassembling regions from log
items during log recovery.  In the old days ASSERT would halt the
kernel, but this isn't true any more so we have to make an explicit
error return.

Coverity-id: 1132508
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_log_recover.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index c1a514ffff55..094ae1a91c44 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -4293,7 +4293,16 @@ xlog_recover_add_to_trans(
 			kmem_zalloc(item->ri_total * sizeof(xfs_log_iovec_t),
 				    0);
 	}
-	ASSERT(item->ri_total > item->ri_cnt);
+
+	if (item->ri_total <= item->ri_cnt) {
+		xfs_warn(log->l_mp,
+	"log item region count (%d) overflowed size (%d)",
+				item->ri_cnt, item->ri_total);
+		ASSERT(0);
+		kmem_free(ptr);
+		return -EFSCORRUPTED;
+	}
+
 	/* Description region is ri_buf[0] */
 	item->ri_buf[item->ri_cnt].i_addr = ptr;
 	item->ri_buf[item->ri_cnt].i_len  = len;
-- 
2.35.1

