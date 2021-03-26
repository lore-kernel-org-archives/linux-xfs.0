Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87E79C433E5
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:32:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67C3861A4D
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:32:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbhCZAcC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 20:32:02 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:56878 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbhCZAbt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Mar 2021 20:31:49 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0OLKb057422
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=LTxh0Leuv5LYESHWFdjj/Jd8KVPTaqxdnNTe2z2c4OQ=;
 b=aj051f+p8Khk1egBPyQ96/Zoxjb/pt1Lbc80tQjkqAO55iV2Rp4p/RIuxu49Qn7O6ngP
 bGzoZ9I41r3HJvSbDPg1fffYvuS1hzNf+frIPtitO2gJCzahKTDPGHf3uMjZp2rRS4Ux
 QwuTf3YzG/J9suCfSE5jbs37Pvdkl8ohd2Z1PpB9Idi8jqs25YelQszl0GE1uTwYDmmP
 G0cow/BqK/4YC+yZs1ppZu4UYOYea+yHY0HJ2xivBGwsbL4yWvucUH27Zcp92cEM/eRz
 DzcfwQZ9i5T/JO9MiAba6ufFK15O5JT/0i2kqtSDiBTDw0FuQSgoQnyO8NZeivqJRJ4c yg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 37h13e8h44-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:48 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0PK6Q155451
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:48 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by userp3030.oracle.com with ESMTP id 37h13x0454-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UA589ta3utawleueIvN8coghua7iODoqdrAHdNOlfXUWfgaxOs8Wn8V7ajQJ7A/c/HKGjjRxmebFza/nm0ngtwfOsYAa1/hsfnxvTjlTnHWVU+Vzx/fPZcWpozRDrcil8x2paLtfHoV1+5reebcKENdmZr+NalCSKcEfMuF8rol0aiWkixpG/xEVLhJI2sOHmg82U9oohjdVYusMBrB+yQ65ey8yKBRHSTrWJrFIZkEVvGN5gyAm26zHbuPN+PPGw5f7QjMKY7wGeZU3O/uZ+wDtTrjgamfYPb33EyfMfhj6SHG0YDe4IBnl9SpIIUcnrpYYDYo2a3toQ0dj9r5yBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LTxh0Leuv5LYESHWFdjj/Jd8KVPTaqxdnNTe2z2c4OQ=;
 b=nNNkhjdshhsfRnh41dkzM6xIFZH2aiZGRhsZQEesnzyy5s++/2ksPQVpJvWjIbTqXF3rgwYdyQkMZHmtV2h/qvCYFMjRPtyKLOyQ6rD/IRuSbWdg4rRCTgTDhuHFIA7iLQac9iAhYNrCaYqMW3inzxTWItpC+JgHaw2btFn3Jmh9h8wuLPpiRknviu3uGxFXgXJo1MqICYZmyvFyO8NBveMsSpzjZ0FmJsiWbaJVyIHDjnafzFEipHmgZ3WBo4khX/YaWNupDARP/DtSnpQSBP4GZnJzSITEsEXW/0LbIDhjb+3L9HO3uIDiLyiO0tBpg4g3i1MlGNNPkraSrsXrOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LTxh0Leuv5LYESHWFdjj/Jd8KVPTaqxdnNTe2z2c4OQ=;
 b=kYTomhBF8nxFR1aNF0DN89+ryIkn3qH5RNFukJ5X3yHa6P9MzfqGvPorj2NULLhtB7E6xZnWV0bdTmQ6wvEKzQNfTLxQ+axbPoEV1UDeQ/DLhysWhcPIMpH2bMVOu0p0lcRwa44LMuCXeaioeoyCPB0O6lC3wgEJ2haXU6uimMs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2758.namprd10.prod.outlook.com (2603:10b6:a02:ba::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26; Fri, 26 Mar
 2021 00:31:45 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3977.024; Fri, 26 Mar 2021
 00:31:45 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v16 09/28] xfsprogs: Check for extent overflow when writing to unwritten extent
Date:   Thu, 25 Mar 2021 17:31:12 -0700
Message-Id: <20210326003131.32642-10-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210326003131.32642-1-allison.henderson@oracle.com>
References: <20210326003131.32642-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BYAPR07CA0078.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.223.248) by BYAPR07CA0078.namprd07.prod.outlook.com (2603:10b6:a03:12b::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Fri, 26 Mar 2021 00:31:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 16c5ac11-46f4-4f12-ee7f-08d8efee88c2
X-MS-TrafficTypeDiagnostic: BYAPR10MB2758:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2758DBB6BDA94C291FD557C495619@BYAPR10MB2758.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:220;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2+FYSgoACZFOiB9gDkVomf4y+V4YC78bo9r15GyRVc566x3ifYuvAaclmWq+JpZXNBLuGcNO3W5k5XMqkpBXFmpoTcD+2NLdXCfWRTpEjQoF4C9qYuwX6IrGuXPzcToJl83oUl3J77Pq92IH9lI4NeppH1BdZqWxMzgVRtP6mkrd0176oHv4hS9hmhIglBuGN2G+WrBpg+r62VWTCsOiiTMNgl5Xe7wGmYn6k38/V3SHNZAmKI5FWGjockX9jakRCX9OD7nMReFsGaf8IN0O8L4EumIr+qKK/ElhXuaYMMO6hBfarGHpR8DMn7u7caRWF9CioTxe7Ri58Rym4sD6776em+8ByuSkeaqYe2TX4+1DhNs2XOGumi39NL319HYHTkz8Z/2Bn5sSph5hMYfh/Vew/EBHPdpp7HhRKkiV3yUzscnDF2QExok3gQwpN/lyzPEbpg1zphfGNxa9q9AIY44KkGeqGB8ZeNMG9nvhM+GSQSwKTZffOi06k1xtwCARy5SPC9GfMOdVLYVSTRToTfz5axy3xTg2CZNI+t2mkM25ObXmpEwBXw3vkl0L4Ro/5jkKN8J8dbbwdv4i1bdxVenoh7/5GxNvG4ZBkQtpqETsiXCrpLHehLUFQ0Te5dFg2x1f3obVqvMVmVZxoRjrXbszueXU9QNY6wWZiwqAl9D8PfLx0HhnxeBN/YN7Gg9W
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(396003)(366004)(136003)(316002)(6666004)(5660300002)(6486002)(16526019)(478600001)(52116002)(8676002)(186003)(44832011)(1076003)(8936002)(956004)(2616005)(66556008)(38100700001)(6506007)(2906002)(66476007)(86362001)(6916009)(66946007)(26005)(69590400012)(6512007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?4jDI72buNCS4Rf7A83UgUKH+EEbd864VTJ+ry4cjUEvsdHMg6L8R8VxPOJ6q?=
 =?us-ascii?Q?/vbX/9HUhxSVuqPl8vrDZBNN38TADHgPqsrs2ThEGPgr3Um5xZyhxZWAcZwU?=
 =?us-ascii?Q?K5TSYVUeEEw5Bk6fpobnrEOnojFFW5uRV4IJqnvVBMgGdLcjkzWovfbSZFcg?=
 =?us-ascii?Q?8R3QCqw4WjMPmBJ1TnGXig5dn7uTz3vRyYnXiMj5ieofC5ffkmLyHW2SAsD1?=
 =?us-ascii?Q?gD6o2J/BTnLIhxJPJA3rm6gjLeXUux5goW0P1trIya2QLupqsyyJbNZLMUSj?=
 =?us-ascii?Q?p7yA3Y4R9BMFBFtCLTFNpi1+Ss4HFXSQHIDMAUKLo9YUcA1CTVl7khTglYWI?=
 =?us-ascii?Q?CY69DUJR5Ffcyp5w6uaYvJQ5ydfAEzEKzXnpWAHsDyqGJ0ODoDVGdPWXuJdy?=
 =?us-ascii?Q?kRFAoVrQEjmzKCUK9VC4DBtZhxwIyHhOHpHqfcCVkyRU+C1j5EP04cuJHrnk?=
 =?us-ascii?Q?Tt+9Z/mnIbIsv+B2R0q2dpGGXGD8uT2fvGFN23buQruBPaPpzCirgHPF4eZy?=
 =?us-ascii?Q?3zz8b68/Xftgx3xYsBpGQERaiAlbJ1q7PgR/MG+Xrzp1q2gE9uTG6jepQ4ab?=
 =?us-ascii?Q?HXbrUjRz3MA4UI77OxIUwR0gmYgSdn74Qy5Z6Bo2daqWzAkgR0DjFOUtwP63?=
 =?us-ascii?Q?KQKtDzju2XvdLgSrFQ+1Ugnp5ixXF6kNksBT+DImuc9xLRKk8uoJSEQtudyO?=
 =?us-ascii?Q?GcJA3hh52yihEZIJQ+ohe5KBI6P5fNyf0r/7p4faSCjfsrNUD/nLA0Rhcdi1?=
 =?us-ascii?Q?Y0tRutrYibktUGTKWNjd6oYWFYmryGzkQfWbdz8dNoB0Alvvi3Nkuewj43+g?=
 =?us-ascii?Q?TO9apYl6BtkibnfDTm9dmgMUGAd3XvSlDHldwdsguJ/o6vvE74ayrSJRiszT?=
 =?us-ascii?Q?3h2wdkacCmkFIvDA55vJVYOCoQyF5TD2EmWFQdKJQkvwqDHFjqAPDyyiLQUd?=
 =?us-ascii?Q?zQIPPGBJ2x3pbdXy58rtF7AIdRcXV8IKV+A0jiHBpiuUc9MWNTrtf8hD0WO+?=
 =?us-ascii?Q?fbD1cAI39uogZLIp9ULUUTIEZuMyK+tV8tFX43jcBQ04SsVC6NelLFoeNCMK?=
 =?us-ascii?Q?zp9yfzV7Oh57Ont4gaQULWCBgS4RUCwwRhE1yegPSASU4mv+QLrQTgfmrQaL?=
 =?us-ascii?Q?yryi3St49DnD5JYL6+ixAezxd4K0nOpjpMWvUlzdFK9jlOskQcl3Qpq9sMso?=
 =?us-ascii?Q?OefIj+bHczS592oOdxQpRZe8pSHKQvbVTqD92auaZh/Lf4ECAsg9KperCrbA?=
 =?us-ascii?Q?ltxy+ol4zUul4XvwF5/PPg0xAG9XW5lQLGTrN2+b9rI7tkhTd6KIeGbSMpzR?=
 =?us-ascii?Q?yf34XY1vDtGaSmBbkhdUvV3d?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16c5ac11-46f4-4f12-ee7f-08d8efee88c2
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 00:31:45.0239
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nj7JJPM7xBiWCl4MsqcVASYHhrBYoag99y+YyatHt+9hOiVNuzVIN6Mj4iOAozOAKRGhL2yAnamk3YT/Cmja/9uMJu6VOQoudf0hZAAPugg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2758
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103260000
X-Proofpoint-ORIG-GUID: jI931k8S7OamqX55wrs_JX7kLRcn62o3
X-Proofpoint-GUID: jI931k8S7OamqX55wrs_JX7kLRcn62o3
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 lowpriorityscore=0
 bulkscore=0 malwarescore=0 priorityscore=1501 suspectscore=0
 impostorscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103260000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Chandan Babu R <chandanrlinux@gmail.com>

Source kernel commit: c442f3086d5a108b7ff086c8ade1923a8f389db5

A write to a sub-interval of an existing unwritten extent causes
the original extent to be split into 3 extents
i.e. | Unwritten | Real | Unwritten |
Hence extent count can increase by 2.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_inode_fork.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/libxfs/xfs_inode_fork.h b/libxfs/xfs_inode_fork.h
index 8d89838..917e289 100644
--- a/libxfs/xfs_inode_fork.h
+++ b/libxfs/xfs_inode_fork.h
@@ -71,6 +71,15 @@ struct xfs_ifork {
 	(XFS_DA_NODE_MAXDEPTH + max(1, rmt_blks))
 
 /*
+ * A write to a sub-interval of an existing unwritten extent causes the original
+ * extent to be split into 3 extents
+ * i.e. | Unwritten | Real | Unwritten |
+ * Hence extent count can increase by 2.
+ */
+#define XFS_IEXT_WRITE_UNWRITTEN_CNT	(2)
+
+
+/*
  * Fork handling.
  */
 
-- 
2.7.4

