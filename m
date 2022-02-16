Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE700C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Feb 2022 01:37:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245510AbiBPBhi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Feb 2022 20:37:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245501AbiBPBhh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Feb 2022 20:37:37 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1FA119C2B
        for <linux-xfs@vger.kernel.org>; Tue, 15 Feb 2022 17:37:25 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21FMrfZU024709
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 01:37:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=fJ5CaKNvw0pAT8Iux/k1gmCD4eTUAw/E68x7c31yUgA=;
 b=pQ4VQtGlzkurBSW/61UKrdg+jtnIVNfXx3hg9hHJTvB7ONeRf3sqBMDNQLtNmjfENT5B
 XqkSmrdIob/MSXwInSTzDtOLY4wQ9FtPY7GCh/HBems49EgsNpvTnTGnN9KZkd3zh5Ru
 XeRXzZF5tCdy7K2LfEDNMCNKTAMc6reHVMBHQjK/V3QJIn2mK2YIssq+CZ6JeMHNCDsZ
 00qRnRNRQIxGKtm65mddmm1G6/wMkbbYlb0BHAW/dmzi4lq1T5RhHfiXtvEG59b0yBm5
 uo9nl0QXwCV1XOnM/34alOg+FfkjZjBxWavU0vhwWyOihWkOQ+v5ij318q9HQksEZh6u dg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e8ncar778-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 01:37:24 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21G1VQCa138909
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 01:37:23 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2045.outbound.protection.outlook.com [104.47.73.45])
        by userp3030.oracle.com with ESMTP id 3e8nkxj2rq-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 01:37:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ycpai+JaHTcvMNcsjSsbmEyHiqTiojEwtJT1EXC4Z4fOnAUl4rnSwLGaA+sMJBef+/wmqDrRIXHCRAPdEDgK6l3Sq+VHj9oFzMl7Rod2Mr84e3MLEbMslaNLocZ8ggEPq7cO6j4gOORYdmNjVgt4amrkTq8ncjkwVsaiPVx0J2KlJm9tS2Qg5I3Ru7/G62L+CacHqaH8O8xQAbzkdmlAOi5tF82hcVEBPqySdS7Nce8zLBQjv2X/EADsMqPKAj8OWjlIdXN3SQJHUszcdblWSmPV2xNl9GZAfne6qcGBiEVvCdAJHy8N9fYraghfdQ+uFeiHg8tDEc9Wxv43z2eSCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fJ5CaKNvw0pAT8Iux/k1gmCD4eTUAw/E68x7c31yUgA=;
 b=CBSd2Wl9ZXomUCMlnMXRMTzjzAHdkmCC0BSARdaNQomRLy7L7cLkWkkeiznR7SWGxOrK0RcaxoepsPU4pAHUAfYem2PMUHomDiYdtG4OOEifcd9elfAPSG9dfz3kG4koTlStnVwziJ3E1VuMDzVI2jn0Jrd7qzQ9Vxlet4ucBy7qfs0Ud8d5S8OZL1OV0x++PXWdskAMO1xtPytBhKa3uYXVUsQYj0za5talZ5vSgFs9uX0lBlNFUyioPpUfhRp+gkfid7+A5v9DnG3StLONhZ9PpzQncfffXMp7BsUghlNSwVVkETDAtwwxAdo1JrPOzC0JRaJKMi/SUAk940hiDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fJ5CaKNvw0pAT8Iux/k1gmCD4eTUAw/E68x7c31yUgA=;
 b=mlNCc4MaY1npIysPvm8ijrShLlsQeVyo4O1JXmY1xyLi/iu7aDXmv64l4ohDYp/gbdM6MPPvZh0Y1xwVn2z8bNxoJ1FxaU/S0qnV330V6Zqaq6NhX1277jjy4oJhTTFfC/ytk+aGKPPcgBGL/bhRrMkwEdv3xd3EZoFBP837LS4=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BN6PR10MB1283.namprd10.prod.outlook.com (2603:10b6:404:45::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Wed, 16 Feb
 2022 01:37:21 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a91b:c130:5e3f:119]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a91b:c130:5e3f:119%6]) with mapi id 15.20.4995.015; Wed, 16 Feb 2022
 01:37:21 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v27 02/15] xfs: don't commit the first deferred transaction without intents
Date:   Tue, 15 Feb 2022 18:37:00 -0700
Message-Id: <20220216013713.1191082-3-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220216013713.1191082-1-allison.henderson@oracle.com>
References: <20220216013713.1191082-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0046.namprd07.prod.outlook.com
 (2603:10b6:510:e::21) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 76c2554b-41e2-425f-cb66-08d9f0ecdfb7
X-MS-TrafficTypeDiagnostic: BN6PR10MB1283:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB12839E26C42A78736CF074BD95359@BN6PR10MB1283.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:331;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bsyWoCUky9xOo/bGBCkUyrhqW9lDfi+frCksbAKnU5TPOFh2hguNdDeXjOeThOE8qH1bAZQGLGBNPqPiwSrMOsqLlT8Z4NDbya50iHYDZJa3YhyXnTWDRZ0jYtUvxe01rsWcX6ZvEYQaesCgxjYE+qL7hk5LdVb6xYL0IuB48sjGqpKL9J4+F7/xfezvaMhajywWE/SiEpJy/+7yhXbFexeS94G8WGhgkF6jXVAcr7P9P4T5ojdoSedCp9221Cb9RdJUlCJ2jwrbH22BFyHDJ0nFro/CQAJs8oYL2XeF5sYsHxkImqnOzLH//GDEyGHZ3FL0cKvUQUwCcWzLtElO3c3BgEhkdWKqUxsARLeALCgBlT2dTkn5Wn12kHg0pofhQMxS4dHRiRDzrb5kNRKKLeVa08z6dLcddiq/klVOuG2tB1RYyJFSZhY7XsRKT7j/ThAKCmCFX+HSs7JakclWsJFHZ1LQB1i9eFCWM9n+Mj1qeNHfitQu+LTrQIrR5xkRmqnFNod+h8DoN/HgBsjND9DMHq398hJuXxG4pWgtINL9PdTvaLTm+7W0JLqIbCEUblrKk9KP0HTVPlBw9P8dxFGMOi2siLBoHpMa3CeqyLi3nl0vzhghxn6n2x4GxhyIItIqaYrjrTk895Dlgwzus1mcmnUoHFMCIPNbpk/jMelFljuIn5MtqqFiMA3ToGovlczdwgGGOvQ1UTBUjMT0gA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(8676002)(6506007)(66476007)(52116002)(83380400001)(86362001)(6666004)(66946007)(66556008)(6512007)(36756003)(38350700002)(38100700002)(2616005)(26005)(508600001)(6916009)(2906002)(5660300002)(316002)(1076003)(186003)(6486002)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MupkBjInxni0eOjuXGn4rgIyrUU7Jf0w13ogJ1Nax5B93U6lDAL3DA9BwaDi?=
 =?us-ascii?Q?jb6unkMqlj57uR5mHU3pPoyrVIEhxpHU+xWVX5pWfIqZ2W5FE/beaf0hDaCe?=
 =?us-ascii?Q?RqkssrO4rwgsth+Ou5wOpi43WKazLjYEYsJtuPXFH53aNEA7YCfF8Pp4OMQ0?=
 =?us-ascii?Q?Ou5h5IOKuV7BIsO9JdWheSv8uIxLP1M+krWFxAbUTkP6n+wUvjXyMoEZJJwU?=
 =?us-ascii?Q?ScfH8Ftx2N2fnWRl7sRW4YHtNI21xTGb4fvmXPe/7x9ekTLzVWXzwy3ItMvH?=
 =?us-ascii?Q?E3RhIkh04qSBUMtMa53QZIzNzMTshJnesf4oXjnXdxjVJbPBRQbJo+9o6dg/?=
 =?us-ascii?Q?1us8VyCyVEcJ2HFL+1PaCC+QEN05kwyDc1F0UtEA2Dao3lMuGQsrUGw0DfbI?=
 =?us-ascii?Q?inums+3e5tsKBbAsdsrGkRYFeBmLWMe7w5xRx5MZ/Ir+fbZLsW0td6osrLa2?=
 =?us-ascii?Q?Yl6km7RsKaQ/4bndiIec62Xb533J8DQMHNF2Q7EPnShvaa5YcO+yjohgI/8K?=
 =?us-ascii?Q?evweiZe6dcU0JdcvuLU+EbjyVkFXwIOSvVbaCQXoN9kmr0jtQGPY5DDOuLMw?=
 =?us-ascii?Q?H6JrCr4f8VN5nkSZdjeCL5tMXb91a0tA3U5JQ5walWGw1u6EYEPtrU2yxm8F?=
 =?us-ascii?Q?lI17kAKpC0np6j4HP2eraakGT8OqeO4HjmA0KHjG3HoJO+7Lhzq3To/S52hl?=
 =?us-ascii?Q?WDFnE7MyqGr5ZgE4svDtn/TG+5UuSaX4YP7hQOTjIsIS83B857wzCb41U1//?=
 =?us-ascii?Q?Ia4znfOoJo7lztsXi0Rh2lIWSneKt0jEx9WrhdLkNo/HTH5d/tCh0SosNS3w?=
 =?us-ascii?Q?6QHSQaFWHGfaE/0ugqiYkYGUJc9a3BmrHY9JM3128Aa8UBMFjD9qWpyHfU44?=
 =?us-ascii?Q?67bMwGCZn422pY0RQPHvTN90itHY5HRQnPUztATHjqes3a6YI4DcSzwYADSQ?=
 =?us-ascii?Q?uU87GDGNwJ1Erq9c1yTeoo0rK7Z6HUtmzw/biR+B483labyvpgB8WYrhN7y2?=
 =?us-ascii?Q?Qo00N01btoMhc1X1g0cy9yuq7NvWxadGfbBMH9aIOqg9WLYQRKLiKdnwC4Ah?=
 =?us-ascii?Q?HBS+ww8TQreVT7J9KfTz28EOvnwsjFqPZmC/+xd9VfiFa3wfzpkAXMHT2RWN?=
 =?us-ascii?Q?a2bq3d9MR80LDGGKt2YX439xbKRu+xNLlKnZIitvrYd8T9nQYZ2D7yg6zyqH?=
 =?us-ascii?Q?wH5j6rb6wxukpgKAH+BY1BS1u26iwMGlPekJjD4SXoFHAXqbd2d8PdTZvtt2?=
 =?us-ascii?Q?Xx4v4Zxt9Yqusx7L3XlC+dJm0YGfko1STF644Hc8kO9KZRUW30ZzjZ3rJOAs?=
 =?us-ascii?Q?R3DNtFje9mc+RuKKf8a1XC8BW3qmF98GPAqYJJ6Lj0Yp2VffLRAmc/NvBHqK?=
 =?us-ascii?Q?tpsmBUhX3ts7KULPkGJ0ZnHMmIM1U7z03aM796EfBDbg8HaOI7uMtFP7doqp?=
 =?us-ascii?Q?Xkp02uJ3wrnSJEAnQIlIbcHH2IzoDVqavKYZoZ/5V4h3a4rr69Rr3nKOUO2J?=
 =?us-ascii?Q?1wKvJDuCeQVPtnPi6R9kfKiM5L5FZ2z9SPpOStWjkjsYZrKxLNfB0Ec/paWv?=
 =?us-ascii?Q?XA3VnUpvp5xdavhJKEl27pbBj8sATAGtbWbE+LoHbQr5sPntKlOVAaUjq2DT?=
 =?us-ascii?Q?5N1GGn4wyO/q63JauqDW7jnnlEmNkE9YI/e4HdqxvaQx1PMeYa15Se0d/p8w?=
 =?us-ascii?Q?LFck4g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76c2554b-41e2-425f-cb66-08d9f0ecdfb7
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 01:37:20.6885
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iERWmuk0czKe15TpevRCEBZrdHtsy6JYYCr5urWP0zbMQCw9GOQXGmuNcn/xCP1p0elT20w9uEcLlJoUVZ7Zqp2YRjByKKLK2/Dhg2x6d1s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1283
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10259 signatures=675924
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202160007
X-Proofpoint-ORIG-GUID: IVtuzXd2AODyxZzMSIrWuk6pPYBFtQEN
X-Proofpoint-GUID: IVtuzXd2AODyxZzMSIrWuk6pPYBFtQEN
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

If the first operation in a string of defer ops has no intents,
then there is no reason to commit it before running the first call
to xfs_defer_finish_one(). This allows the defer ops to be used
effectively for non-intent based operations without requiring an
unnecessary extra transaction commit when first called.

This fixes a regression in per-attribute modification transaction
count when delayed attributes are not being used.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_defer.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 6dac8d6b8c21..26680e9f50f5 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -510,9 +510,16 @@ xfs_defer_finish_noroll(
 		xfs_defer_create_intents(*tp);
 		list_splice_init(&(*tp)->t_dfops, &dop_pending);
 
-		error = xfs_defer_trans_roll(tp);
-		if (error)
-			goto out_shutdown;
+		/*
+		 * We must ensure the transaction is clean before we try to finish
+		 * deferred work by committing logged intent items and anything
+		 * else that dirtied the transaction.
+		 */
+		if ((*tp)->t_flags & XFS_TRANS_DIRTY) {
+			error = xfs_defer_trans_roll(tp);
+			if (error)
+				goto out_shutdown;
+		}
 
 		/* Possibly relog intent items to keep the log moving. */
 		error = xfs_defer_relog(tp, &dop_pending);
-- 
2.25.1

