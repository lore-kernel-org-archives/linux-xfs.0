Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58CB3C433E4
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:32:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B13A61A49
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:32:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbhCZAcB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 20:32:01 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:38468 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbhCZAbr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Mar 2021 20:31:47 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0OpGS066406
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=d1cgS9gGRVyt4lzZgTDwwEPzKeAYfXnZ9Hbtx5B/fUg=;
 b=KodKQvekfDZCgjYsj+TOGhOxqMk5msAmjhadR9VyBwmNufQa0q5VSivyxIa5M7GLUKx2
 entSqD6lDXRF3zikeGGwyCSzKYIs0Z4Kio59ph6Xlnb3PJcHvlS3+rl1HHi9xNV3CNyo
 NxCxv6bDNKlof6ZEVIGFI4lnZf4ao85RvDRQOWrrCLmkXjcUW5Vww9BCpAmg+6WmKUT6
 9NaUFZOpK23elG7pwvo4z2L2eqhsazZ0lWGdCCDPeyDX+NLWF8xEn9gUeQtW/SyUCLfQ
 VPCXMf6qEZ3D7EMpkEq6Xhpy/aFANnynF4uuHNesWtcNNOlUWnLb4Dqdd82h5rzrZRoI Jg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 37h13hrh5c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:47 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0PK6L155451
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:46 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by userp3030.oracle.com with ESMTP id 37h13x0454-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=docBkeyh6d7g4sxk0YsnC3xnr1/neWsiNu7KC9cdvh2a0RHzauBAgOuR2YujZ4nX/0b8FWpkQ5pkLgpBSzF8mrUO/pomTtu5QM8pnANhWuy15sCs1m5BsdSNC/kKMxw7mba80Mv+5dH9K7ZmYFehBPCOG2OuLEOFrV9KDcdQ1ZNxmz3w39+NRgoHd29pxTpJV7mmFDj2yRI9J8BkPPH/Lo95D5/7bEHbTomv0Vd2ovIFE5wabpTDu557j4KJ3mf74/WlNuYj6e+S8zP4GbH5yn1QMjDwfjafTEOJ+N3crbeWaUvwPvP8Egl/RTBbSmtCxItaLGHZITLzMnqAn4i4ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d1cgS9gGRVyt4lzZgTDwwEPzKeAYfXnZ9Hbtx5B/fUg=;
 b=Z1n717fkp2m8Woz2k04uc0Dxj7ZjosgtdEdqNUMg7xMQzN9s+N06tfNG8NnoPLIQWIkNWUNCFP/yDweoE5fjIVCfDF0u9ADhZojHjCacpHAR3Gkle9xvuB4AMI7ERQCRjWKdan6K49McB1nx4KKIeG4sSAm/soPP4MVj93ighez0aYcJR6onPOpU/ldxxc+N8OYB/4MmUFJPdS2Ytsfy9ZeNx9oHQGnxOU8dZQVWgCSU+mgxwyZVSHbkUFqreS+bIdbugDVWs0+pIgS/XUwGuAXA226ImzJGIvVAo6HymtOQ8DKd+0JP8q6G7i0YICarXplMeE8nBENOLgS2NDeweQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d1cgS9gGRVyt4lzZgTDwwEPzKeAYfXnZ9Hbtx5B/fUg=;
 b=sd5+ZLPsMtV3VEwtVUeRbOeb6+ikFH2EFv9NuFYAauxiBtUEVjNHHDzQwzPRWbfwlb0wOWAHLmB8jkUPiXhpd+9u4kYItj5XNrhcL8sM2uRY/80DXIrT+kkGE7LAzamqJa3dWiF9j5PLXIcjf75fARcPWq7iil2H4jsOz3SwObo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2758.namprd10.prod.outlook.com (2603:10b6:a02:ba::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26; Fri, 26 Mar
 2021 00:31:43 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3977.024; Fri, 26 Mar 2021
 00:31:43 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v16 05/28] xfsprogs: Check for extent overflow when adding dir entries
Date:   Thu, 25 Mar 2021 17:31:08 -0700
Message-Id: <20210326003131.32642-6-allison.henderson@oracle.com>
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
Received: from localhost.localdomain (67.1.223.248) by BYAPR07CA0078.namprd07.prod.outlook.com (2603:10b6:a03:12b::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Fri, 26 Mar 2021 00:31:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2887bb6f-9c91-4dce-b5fc-08d8efee87f3
X-MS-TrafficTypeDiagnostic: BYAPR10MB2758:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2758466FB0E49FF29010BE3F95619@BYAPR10MB2758.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:506;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LzBm2Nc66LVVNTep/hx64dbDkaCRDWKyilueyytzUGgyUynfD1PgxDUCan5RLZ1LwpMEBbXKhYphJf6UbcXM1GcFP7uBr6YYxsj6izzoKveVtuoEiABo7MM5pgR8EvSKOKp6AY+3VVPkIFkq7KRTICdFDK9+8GvpN2EWoljWBfUYzncXEZbCpDKrdvsm9oKdPuroRFAwulkE7/1MkcEtujeMq+S2xKU5eNmz70SKBLxnS18wabhlKB1WIxbtoAk8YMM1+6w5d1GqpTijfQH9ql8taQhn3Ot27x31BCqy2/oZtGPPmkgUDTq4EgspeNkjeSuzqFIbYsA80jcQfT5sHOmVuqaTdIRUzUakWS+tuI5xaCZ9rrlZBPos5WvcopL0dlsjJBa7t/wnGPkg12QCny6znR+mLEzVqx0W9Mcr4HUa/DqNmFX433+Z9trKyyOg8/RqsxzA8okULP+Q4xttIYOgJcvluIk5AeyMUDSVe3JMK7j6umtXVgqNYZcPC9Bt6c0B4ySl/NjjZDPo8wQcs/VUOlWdZN2nay4qhss+3jB5fyedsSdg8SOwUaXdoN6qRv+u1WXrkwNjkBqOEf64XNiHcIOyAqoApfT7G3ZFMiR5aaOhk10KIqAJ+QUr8XkUU6xeaGz3rY82yeKd6lJ0wWW7GEeivgppw1JpIgBfEvzdx6Cynj3/PGrQUJejC8Sr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(396003)(366004)(136003)(316002)(6666004)(5660300002)(6486002)(16526019)(478600001)(52116002)(8676002)(186003)(44832011)(1076003)(8936002)(956004)(2616005)(66556008)(38100700001)(83380400001)(6506007)(2906002)(66476007)(86362001)(6916009)(66946007)(26005)(69590400012)(6512007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?nELwIcwFctQJ7wLlCLxxfDKxgeZl2bfXLHy2+fkLTPrrz+FRjHzHzhRnfWCo?=
 =?us-ascii?Q?e5TU9lgbpbX/5a2lrJCEI8O6wNqwjzLLMpORFdfJe6cXFBpQjT97df3YuAIv?=
 =?us-ascii?Q?f3wzz6lnSckTPbb00yb4aqHsBPBbuc7cgwrYYCtA6fR10IF3J5GtYuRAbVwA?=
 =?us-ascii?Q?YDvkiNTSW42UlEviVRgVhmTgXpRUphkGNTaQyICYIWZFD4SDnYr5R+hHCRxM?=
 =?us-ascii?Q?ahFLCOwmqjdyYZSX3qz48tVW7VCV3+XyajCpXYzYQSH+GHn2WkmRKS7K3nnp?=
 =?us-ascii?Q?xGX0fdpCYOUfkk0jez09E3r9LAmKAsVC6obcItNnFdeuc/8ZUDSzNcv7gNaA?=
 =?us-ascii?Q?Om/wRrg2JBaIv/hHZU/iymjoxdIQ1ZoZ9OPwstliyt5JbbZaP7GdmhQsw5Cx?=
 =?us-ascii?Q?dJA3tFvXwdUDGKZICurC9nccoiHMhaF0zuh120VDWcQA8xAiorN6SJjwhxom?=
 =?us-ascii?Q?3hxEpIVtEcE3joprlRPylDFQfqZl3bsf/EVJKAXStkm8Ef/Tsx6flSQbdxiL?=
 =?us-ascii?Q?+vunQHIIFv9uMZ8AXlmIUY0MYY6D3haWnGTG1TujNGuothlSdBci2Kbcpblm?=
 =?us-ascii?Q?MfqShN/JQCL8CfYQEXnYjkTD2dzr4A2ffkrIfkaBj56hBo6LFrOTmP9iYsX4?=
 =?us-ascii?Q?D3ZJVJS+EN5BpmxlX60k2ywNtoz5MD3pUObF+/SxrfI220ygHSUwYg5kbI7D?=
 =?us-ascii?Q?Hx3xlcHTjaltvRHrjFSA7TakgFyqwvSyXAgsWQiyN+ezgfP9N6gqwdG+lL7n?=
 =?us-ascii?Q?nYRMQv1DjNhBXvvJw0snV8QujvgJ/SClXbC/9G7P0U42UA2MXCcDbdJqRWHQ?=
 =?us-ascii?Q?JIjKLLMGzfKMsq+eW4D2N5zD+jVb0sHdn4Iiq52FudWhoUYHT1L2g/Y0p8iB?=
 =?us-ascii?Q?edxRi7uWu8uhGkFb8vzWWghF0Qc47k+ffa+u8lE3uVJnbjyZeglTARzMrFNO?=
 =?us-ascii?Q?bpcWndtkh9rINhJ4AmIf6+HXe36wMrET/w5Qnok181xVsSDICUZH7G+E9h+M?=
 =?us-ascii?Q?mQOeel/oA0bMAHEgfxuw+B6ph76kasPg9XYB2ocBv0flyRUbiadF0nTgjxv7?=
 =?us-ascii?Q?1ElJ3uktvFIfUtJW8T10Qoqu1JqJP9t0WCcYsBKQHZoCq/IPAPlnrmHwTlAf?=
 =?us-ascii?Q?i+bU/w8UbBV/6V6GEeN0NhYezv4utQdFJ8P2RzN+JW7w7aAzFmjqtnoSlBsS?=
 =?us-ascii?Q?nhbOb3vZuwCIO5MyS3ADVzs0ya55wNsVXyIRSw6mb3UlpvdpBu0fouN6z7Pj?=
 =?us-ascii?Q?aOtB1yFwvJMvOvJmbma78Nv5ON6Mg+eYuiIyMy0DkwWhqw/YLanjwRkQ9NqY?=
 =?us-ascii?Q?boOw7b8t9hBCDDKAVj8zpqL6?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2887bb6f-9c91-4dce-b5fc-08d8efee87f3
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 00:31:43.6330
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A6goiFw0CW/xPoALPdiHRWrIlZW0xMeI5Jsn0xE8uF41eVc/lLG4OQqEDC78NQtQe1+UIdc7W2mifSE4z1Qzo4XOZe6zZCHJFbRePvp/GAg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2758
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103260000
X-Proofpoint-GUID: _lxlgkyc8Jl-Q_wbeoLEVL_FmKPNLrD6
X-Proofpoint-ORIG-GUID: _lxlgkyc8Jl-Q_wbeoLEVL_FmKPNLrD6
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 spamscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0
 suspectscore=0 clxscore=1015 adultscore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103260000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Chandan Babu R <chandanrlinux@gmail.com>

Source kernel commit: f5d92749191402c50e32ac83dd9da3b910f5680f

Directory entry addition can cause the following,
1. Data block can be added/removed.
A new extent can cause extent count to increase by 1.
2. Free disk block can be added/removed.
Same behaviour as described above for Data block.
3. Dabtree blocks.
XFS_DA_NODE_MAXDEPTH blocks can be added. Each of these
can be new extents. Hence extent count can increase by
XFS_DA_NODE_MAXDEPTH.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_inode_fork.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/libxfs/xfs_inode_fork.h b/libxfs/xfs_inode_fork.h
index bcac769..ea1a9dd 100644
--- a/libxfs/xfs_inode_fork.h
+++ b/libxfs/xfs_inode_fork.h
@@ -48,6 +48,19 @@ struct xfs_ifork {
 #define XFS_IEXT_PUNCH_HOLE_CNT		(1)
 
 /*
+ * Directory entry addition can cause the following,
+ * 1. Data block can be added/removed.
+ *    A new extent can cause extent count to increase by 1.
+ * 2. Free disk block can be added/removed.
+ *    Same behaviour as described above for Data block.
+ * 3. Dabtree blocks.
+ *    XFS_DA_NODE_MAXDEPTH blocks can be added. Each of these can be new
+ *    extents. Hence extent count can increase by XFS_DA_NODE_MAXDEPTH.
+ */
+#define XFS_IEXT_DIR_MANIP_CNT(mp) \
+	((XFS_DA_NODE_MAXDEPTH + 1 + 1) * (mp)->m_dir_geo->fsbcount)
+
+/*
  * Fork handling.
  */
 
-- 
2.7.4

