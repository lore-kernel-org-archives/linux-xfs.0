Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D16C8C10F1E
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Dec 2022 10:04:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbiLRKEB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 18 Dec 2022 05:04:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230312AbiLRKEA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Dec 2022 05:04:00 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74FCF55A8
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 02:03:58 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BI5KweF015523
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=QnZjoGgIcEUP40CqmQBJYUuAmBfobRJOlbitbtUwDrQ=;
 b=gHB4gd2SrDgMI0H36yNm72CoVfr4ZttrnkKxCIuYTJMTBlYri6mn7vmylXBsNrawceNW
 EiDX34WnQ/hFuG5ARLWRG/rYsU6lEFEv6UzipRrrfFxABFvqJ68FkWv+v0rh2nUWWiL5
 aUJbWg1bbh54T4i4bTG869JKBb7GwlwTTdgQ+qIhkQVCxGu9oz/2q0V4yPY/gMxiHNrh
 8kdx8/m2eKH5fYtXNHEd5u0UsEEpb0mDEmr8GS3Uttgj08XW+hYBEABF0bN69Ooygmlp
 iLXbJjxha8xloyqWPuOZGkrTMVDY3kWP/FYF9WTFuUJyzcDOYfVYdLTAD4CLWtnXBobY pw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mh6tss9n9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:57 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BI8JeXK024870
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:54 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mh478mxs8-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dNDuth2RSjUwQtkKYQRyUYmlz1Mdcd4iLIqP6CYWr8JPXssaRLSHMd2gP1nAyxNeA9BCeQa3vmXeHjZRxAVqIyRGwSAt1hurb9ZPbgDnwHLY98sZwoWcPtiKKzeuybnamUV49FgDWFGxz/NMDO8KLo/eulkIeG/mDK55hnl2BpN/jpVLJ4AmlcO0lCLcEbbdmjd/xZvlBe8CXlvBqgqtQBuSSi1tWHljbd/jJJcQO1tEnTXIPpEp8SKsMn25N3XxggYoMiUUR1udGPFBVHoQNngiBvfTR9+vI/XjPk08Kwy5EBQGe3bg0xJVrbwNj6K2vn4TTgbTfsesMM5fzg2tmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QnZjoGgIcEUP40CqmQBJYUuAmBfobRJOlbitbtUwDrQ=;
 b=NSzRRa6lQOP+cP7HwsrtIeGlg4uziW2Wn2h+pd7F4QGsnVf8tW3ecn0jekuslQMnHhWb0q7fcQUb4AZ9zZ26R/FmZ3QVUrssyXxM7AzmvUmk8dfEoeHkzImQZbL3waCAe9Vu1o32aLzjhGdUQP8y4E6F4b6STwYUc7Hwr3TvOHbbRViGgtQXUgAw8ckO8/ksI1l0xaQ6kXRM2jD7RmCLRxI5Pb0KVIsDm6QkVdLj+WaBZ26znSke5wzHwhAPOxGyY1bI93jXO/o6WS3u6wNDA+tdUBFczIoR4sO9YWNm/o3cxALMA5ncJv/eSUjxaH4YLVmGULHuqiupiU8fOwwPCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QnZjoGgIcEUP40CqmQBJYUuAmBfobRJOlbitbtUwDrQ=;
 b=sc6NKCMzamZbzGBSFbShgeogIxC+OFVR0da0TaZgPVUG10lFRP78L+izBPZVV3yjXZ4pv+INWsfHDODBZ8R2dbjfc7MymogqqCyOfuDuZYvLGnzNAL1NMAh3vZg2B+gnWRGKVLUH8YOPItwnbPvy1GG+XcWfk3H2Ino7eNFSUEE=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by IA0PR10MB7181.namprd10.prod.outlook.com (2603:10b6:208:400::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Sun, 18 Dec
 2022 10:03:49 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c%4]) with mapi id 15.20.5924.016; Sun, 18 Dec 2022
 10:03:49 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v7 27/27] xfs: drop compatibility minimum log size computations for reflink
Date:   Sun, 18 Dec 2022 03:03:06 -0700
Message-Id: <20221218100306.76408-28-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221218100306.76408-1-allison.henderson@oracle.com>
References: <20221218100306.76408-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0013.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::18) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|IA0PR10MB7181:EE_
X-MS-Office365-Filtering-Correlation-Id: aab44ed5-a0d4-4553-db2c-08dae0df288d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2lrcLKbYNudM31e8w7S0PtFrshRmib+A5imBrGgu3Dav+Mu/oEUgK7Q3CPe7aurlpx7R6FT4fHQsQOeZA+8yaICOON6NrkLwZoxUVFdEJy5oGCg5XCTqS9MCPQrrsEKPirm/STd4yfBN7jJlc5pOgWtCjv3IpnBhiCgwXqEqCclrkgQQqxl1Z+3o+io4FaajtXuakimR9j3/RWeKkx2Un6am2khyF5dTZ3Sp8XJ2ovZSiWHAnDFuWIVY5+Y8MY7y+q9+ECCzfHZUDE9oB9Vkz4unGAtEiz73ElhOUVNiplGwOmdF67sKIBmyzetaxJnjDH2S8E4H2aX6SDfp9380KHtiZsVxQBYTGGpHt/48kOe7WHRx9x0TrQ4iIgJoShuglx08Wvy6/PWWzGlNtWcVa+DrPDPWFFtOzF4hJfMgvOz1Iox3xZ+eiGL2Gh5WZ8zz1Ulxb+F5FEiTqYeTnyslm7hP40DBNa6qqER+aBwzmPwlwZq+2w5TGVpdURd+1PWmBSr78SwmTzLsoGcLWjWlz7hUmFc1X/zeozhL2oSsBS4YW9zIDzEwugnOHutWbDuYJ/wtUHyZTUEHX+BO5wzUfEDc8A679NtopkCYHt7ZMgT722FBOTI7gLkKaysVu5en4G14RA6rQcloB39ijUdNZg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(366004)(376002)(396003)(346002)(451199015)(83380400001)(2906002)(41300700001)(8936002)(5660300002)(86362001)(38100700002)(36756003)(316002)(6506007)(6916009)(478600001)(6486002)(186003)(26005)(6512007)(66946007)(9686003)(2616005)(66476007)(8676002)(6666004)(66556008)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3vnbWH3h79eZJ86MC5T9Uh8rxLlDgKZByFla9JSrP4LWa95/whd6cPBtwVrF?=
 =?us-ascii?Q?sClEvOgKtsEZ+yE1F0CQzKcjVzmqb0waZm8qE1qmOeYyLN6dj5HA1Vh8F846?=
 =?us-ascii?Q?ql+HO4U1ODjYCfqWAW45ywqfV7FBYW6gFTT97agAFaejaNr7TVsTwyne8KFm?=
 =?us-ascii?Q?vLXR8yWjXymn6yP2IX22C1YShIM16bLu9We9liHpzzp0Y8EgvHptPZZTiVUW?=
 =?us-ascii?Q?6Ml5PM8P2330RtDDG4VPFlx3iJjS2q6gLAlB9ZRQGUc7OW3+g1c4dhKbZYRc?=
 =?us-ascii?Q?DfcRvqmYMohbqhZHuIu0eOcekPW7J9GZoQoWEC7+rdw6u8+bHyxtD/Ln1IgC?=
 =?us-ascii?Q?bqZxuAvw9CmMmfbLKY63R7hy+iATafpOGIjTyl9UTcY6tGPI0BEkvFlwnkKn?=
 =?us-ascii?Q?6nr+PS8+t6SFCwtmJ9/9rqcwccMFhGuWCax2ux8VeFZzvnW3qT6qzD5d+HMX?=
 =?us-ascii?Q?02v38FmO8G81Vt62XvQ4M5+dMV2594Ap3+iYL3yD3shewt26j79Vz10ggBWh?=
 =?us-ascii?Q?HB+q8TqQGju2yXY+a2PuwW2UGAT9QjaiaSyra11DlwyEd+wfqLXgm89G28Ra?=
 =?us-ascii?Q?6Jqku9WPDxu4gyWFd3TRxenP0Hf2QY7IBf8wpBcI7jG/7dXdlTy66nNSoAFj?=
 =?us-ascii?Q?Tp93fvhOjZcVSNXGOURy8t5qzrItJGkY0vxc9RE593DJDb/zZ/t/2Pl5NSE8?=
 =?us-ascii?Q?KIb4KbehZjaERiZ7jB0zPoDQkT/gUkckH2tuVky6Kfr0tOOn4jY0L8Hz5NjI?=
 =?us-ascii?Q?kMWngcvEv3IJovNUtLIW/ENhfkEyJyg7DdKj89HGxydNG6M+MTBJfwYsv22l?=
 =?us-ascii?Q?ptzwmC1RiMeGdsvpoyFSzSQWA3aeQL+0BSM3EL3BBf5Coi9eLohbOzFGOBKZ?=
 =?us-ascii?Q?DHXSSZLnjfWl6X4mBH2MKamvSt2SPVYg3/L2P7EkVtuAU+yooG6JW8wQRF8S?=
 =?us-ascii?Q?buaYCWSxLPV6Ka14GVv0DdvHFLX7MLiwLOHzb7dRAgTLzHfwMb5P/uwmrTs4?=
 =?us-ascii?Q?RRGtao5loZkIfEDzhTwxALhoeqHO1XEf5QNKJQrmjxkhlz1lwThPlSLP4T8z?=
 =?us-ascii?Q?I/e0P7WjdiXAoVLu2s5lXGyy3UVS1ili8BFKbM3jsy9nSBH2CjzjR6PrbsK/?=
 =?us-ascii?Q?sOVIAc3x5q8Kwy56q6U1hslOcC2vINawciuGPhzowfqglmlKt6qqD/WmCGcK?=
 =?us-ascii?Q?U98FgAfmAHSPOeGlDxHhol2z8jEYpo4y08oXrGbJ8VtWOTvt5OwEX+S+TgCK?=
 =?us-ascii?Q?duUrXhBjPw9/n0lvdY4e/gwreUFI5brKQj65Z1+BoFEKAh1v3ljW4a8V2uD3?=
 =?us-ascii?Q?WSxwGXeBoBl0unkXpyBbsgm5vUMDlSSqRjmOMj9D/BacovGPoxhkDhWBPjcn?=
 =?us-ascii?Q?QOMD6CA/T0v27nTJ/yw7cItRv+XSKzew6ujzfU21cIy7ySP/MOe/8OUqU2Zz?=
 =?us-ascii?Q?1sD+wHmS+VByL7iqHAcLnNuqdBQgytvsQJrw3ZU76S1qNLlmmI0B5B+UbPRT?=
 =?us-ascii?Q?rLhaeoNdMn6cPhTs85LZTgKSQLAv2T+Q3TqSczxjRFEeqZmi5pEPEEwLEjya?=
 =?us-ascii?Q?Mix1ZtHPxEUoO/HpZFMuj3aGvybVrI3vAJ/WtLgENKitMhQ4iCuKKW9fb9am?=
 =?us-ascii?Q?Tg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aab44ed5-a0d4-4553-db2c-08dae0df288d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2022 10:03:48.9685
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CMWJRvG7kQD4mxdGGipbb9F/fFnDv0SjJ5FJAtYraeto2rBR3wRdiR/CPNN/I0qkV8HS+JDVXTLRSVgqYO8aQMIq7V1d20Yc9l8lS0Rw/Bc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7181
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-18_02,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212180095
X-Proofpoint-ORIG-GUID: 9qgU5CX_aqXyXcPEXRtoIWTz5j4V8zmN
X-Proofpoint-GUID: 9qgU5CX_aqXyXcPEXRtoIWTz5j4V8zmN
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Having established that we can reduce the minimum log size computation
for filesystems with parent pointers or any newer feature, we should
also drop the compat minlogsize code that we added when we reduced the
transaction reservation size for rmap and reflink.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_log_rlimit.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_log_rlimit.c b/fs/xfs/libxfs/xfs_log_rlimit.c
index e5c606fb7a6a..74821c7fd0cc 100644
--- a/fs/xfs/libxfs/xfs_log_rlimit.c
+++ b/fs/xfs/libxfs/xfs_log_rlimit.c
@@ -91,6 +91,16 @@ xfs_log_calc_trans_resv_for_minlogblocks(
 {
 	unsigned int		rmap_maxlevels = mp->m_rmap_maxlevels;
 
+	/*
+	 * Starting with the parent pointer feature, every new fs feature
+	 * drops the oversized minimum log size computation introduced by the
+	 * original reflink code.
+	 */
+	if (xfs_has_parent_or_newer_feature(mp)) {
+		xfs_trans_resv_calc(mp, resv);
+		return;
+	}
+
 	/*
 	 * In the early days of rmap+reflink, we always set the rmap maxlevels
 	 * to 9 even if the AG was small enough that it would never grow to
-- 
2.25.1

