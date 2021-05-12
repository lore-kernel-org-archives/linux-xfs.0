Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61B5CC433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 17:06:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BCD261363
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 17:06:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239392AbhELRGV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 May 2021 13:06:21 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48574 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239716AbhELQPj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 May 2021 12:15:39 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14CG8kH4052871
        for <linux-xfs@vger.kernel.org>; Wed, 12 May 2021 16:14:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=v6MvN0TfXyIJVdgeVuKSUq9Urg9VrI+1K8si4nZE6/0=;
 b=je5nBu4FY938oYhSmaWPz+HY/JF5ShWTEeb9INBR1bOl3xW8eemHcRaLT/4MtcoZXzwW
 1zPfKB4k247vGat4LDX+83oQ6DB0e0KjDhohLoQFuNCdFHlt3ver7PVdHcvaVA1r/yCM
 Zf0Jxx9NOcY+bmbXvULJr21Wj8N7XYbLtTM/kBeV5iQQuoAo9etwaWMKkZt9NqV0a1uM
 nqfK4b0lvPlkPpBdhHZDUM57GeDkAlE+/spGuAsFhq/ZqL+bfbbUjxnfCifs5qI5Gd6J
 Um7xKZ0V81cvDS7WN6ug/1Lsb32ODKzvFf7HR25UAcKREaIWQaPzXM/oqzNrESsN8LcO 8Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 38dk9njh8c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 12 May 2021 16:14:29 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14CG9swm194902
        for <linux-xfs@vger.kernel.org>; Wed, 12 May 2021 16:14:28 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2045.outbound.protection.outlook.com [104.47.57.45])
        by aserp3030.oracle.com with ESMTP id 38e5q026eb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 12 May 2021 16:14:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SVKBji+ilH/VZDrsm1BsEBNyA0nOQiCjzL8nUMCOe99F3eGZvqkmYBmRRT5mh4vAhZnsUM33mmX0smDVdIcOxO+LrRSMMSxvewf2j92EMHa1zyqJjQCpjwNXgzPjS5/UeP1ZY2cQrPIxdYQAU/Z+eI4VrTRXd3yRKwTCEy1q9AYAHurJce0GQ+ffgfQUzDgsUddYjeoInZuwuzK8QfH5n1FFo62pqka8VBlT6/dHUzbj0r4ILpz9906rVH0nnpxV/xm0WMjxjCZxvo+WPm9/QBKIwrfokH2xJW/FSjm2URtm2vYvlZ2jQcce1xw1PQpfCq00683UqvidQ87fJvurEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v6MvN0TfXyIJVdgeVuKSUq9Urg9VrI+1K8si4nZE6/0=;
 b=ORvd+zyEjG4y+VzlArc0PPqINdxW26+3mXSuO4O0ybttSj585hF7OIIaoqwWYWz+9RChAB8oHX1641H6nUAEUFGe142+xDTF3nIRnI4a++f3Q/MFT+nhk0fA14ZWR8Dsm+g/awnuADledUbhJlQYnggDJ05whQNORr+KV58XYWjla7t3zneu+OvbpeD/awl6YXIS+Q5ILkmusDHpzHjGQXEE1W2VRxxl6g/ig8L4Hl8Bed91FCG+S+LoLiRul5cQVugeE5HVIaTorJ9oAZzZa3U6eqrVzBAligOEzXtRZRQMQBBPq7xeTu6scVDjcTP0fVaFv4E0bFCz6zJev/d+QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v6MvN0TfXyIJVdgeVuKSUq9Urg9VrI+1K8si4nZE6/0=;
 b=CUyvjXE4Y7ZxAqdu9zBo++jmU+qBnztcLZzl11LZWejyqMzD7orvr6yThi8qYwraTgXCwevzr0sxK7NKgbLTtl2zpMTB9EACdqyWrrKorjxR+3YX5Eg0f1NKddg+SWGfCZja2i6PqQ5T/rNKT1U/kfU4zYYllXXhvbs32KgeiBI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3112.namprd10.prod.outlook.com (2603:10b6:a03:157::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25; Wed, 12 May
 2021 16:14:21 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4129.027; Wed, 12 May 2021
 16:14:21 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH RESEND v18 00/11] Delay Ready Attributes
Date:   Wed, 12 May 2021 09:13:57 -0700
Message-Id: <20210512161408.5516-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: SJ0PR05CA0200.namprd05.prod.outlook.com
 (2603:10b6:a03:330::25) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.210.54) by SJ0PR05CA0200.namprd05.prod.outlook.com (2603:10b6:a03:330::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.11 via Frontend Transport; Wed, 12 May 2021 16:14:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c510ff42-3187-4a6e-562f-08d915610065
X-MS-TrafficTypeDiagnostic: BYAPR10MB3112:
X-Microsoft-Antispam-PRVS: <BYAPR10MB31122A6904FD7A14F1A2E24795529@BYAPR10MB3112.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dSYFBXICI2I1QX2nrhcrsyEtOtCVjF36juQAi3kfHqLCb4v3Ekd973gy0ClV52DS0960EnxDqGH/JrLE1Ej8pWkviPDZrZRvw+mW1OlmDyVZTL9YfkhUrPhjD0hCkHhRlHXWKByC3r/CqA5ton4gSqOV+oBpUbT4KoRXbIItYIjPfKIOAvzIf2OxnZVN1VWJNpLb/bNGNgqH4uVZNX3VtSEqEdwqqM1wLosztF+6Oylr6XlGwOSttARYQ403rhWMm7GOSvxyR51/ZJGLOzmpcW086nQLVrA2mGSNmvtO3zPeNhSwTlOIS39XIjNNjc/YA/TNWBHgl+Kbl8EhU53X2EST0Kpqme4es3nx62fyv8JgI8UskXdPHz5G8jye1FG2syKSIp/B9E0oF9U9sJqOFf39V83zY5olXLTwMcSAcACvk+k+aDg8iSpnlrZrqAS8ZRYPt/LWfaLhC0cSqfMDYPYBWvk5Guo7VvpQhWnv+5kB1WqIlMYS1NGrLRb64ep+jOIy+VgN7ydxx01amFMki9PwpAPj1Ppg9G1Kq7Ffk4XY1KFdK/tr7erVH6Xbgg/fhOzaUvNrQXzgRfIw8TOej0JG1G6aaQL42/WwRDnAK7BO6v8jzlBJW4opGibb3TNJ2o2NBCjFS1AUERDD/Zrs+RmZh3+SLu5XVCR+RMd9vMWfr1TxGKh7C5NfS4UjNCO6NGOFfP3MZwFZQAC+cA68L3jLVWgtb23Vd8NTkGcFmCirQbkKfJ+POBNpc6lwmb5CVjH+6mgaIJTRRtLiqoBD5ekyNTf/98SFXUlJjwBcSEY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(346002)(376002)(39860400002)(366004)(478600001)(966005)(316002)(66946007)(38350700002)(1076003)(52116002)(2616005)(5660300002)(36756003)(8676002)(8936002)(66556008)(6486002)(6506007)(83380400001)(44832011)(2906002)(6916009)(186003)(26005)(38100700002)(16526019)(66476007)(6512007)(6666004)(956004)(86362001)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?JKjdy1W/hemFtvWjp8cTl3XWbLOWOj0NDc55g2LSN92DwKMOml0f2sf3QAXc?=
 =?us-ascii?Q?VDnrNewvb02KhRjvLQZTzgiSEGjHdlF0bQ39+z8wOgVwmWZ7BqQ/Ynut83uu?=
 =?us-ascii?Q?9+Qoua8DElBuM6og0cBNyyIKaU6NimujULUGdpEFXIh+lIXyE11qedOwHFx7?=
 =?us-ascii?Q?Hcz7uz6Sq37L5AQjJujN88YbOtWnjzl33XTaZjnE/9RDIVtlfrSL/fLlxEqo?=
 =?us-ascii?Q?D64w8VdgBROwUEAW04yc2zyURzUxNdkX570JMmqenaKlHO0pIB0eYseiFry9?=
 =?us-ascii?Q?YZRjsQaEF3xQ8rZVv5U7aBFrla70Vc4jWK8jJ1VMo9ZM4COszvc/kvr7qU9R?=
 =?us-ascii?Q?PCf4YqLuuiSm+jDEQf3Y1MzwKRI8t9q62r5btH++mdsDq9P6jlT8IGRiy8I3?=
 =?us-ascii?Q?hJVHSmbB0BAm9mIEUQiJc9r1PA9vh1073QNIvgKNTj+9r3mAOpJMzt1jAWxR?=
 =?us-ascii?Q?nWiMePcB5+TY/hPiovBKtouCugc76NTzckYfytVM/4rYaC6XXngREvKEUBJg?=
 =?us-ascii?Q?l0wyrh43tTLyFf8ycVHhc2M/wSR4tqnLpL9EG5saqOdY9iZrBlzN4lxJaxO8?=
 =?us-ascii?Q?9pUZIdDpWWQk6wLLmxg8obz9si7grad9cpB1HfGbRgQ7g6BQJbBNzMZ5/vK1?=
 =?us-ascii?Q?rRSk4Ugwq6gYR9xAqWw1srV+mmqi/xF3Dp6/dC9i1FjrbPpEJucF4V2YoXDA?=
 =?us-ascii?Q?8oVnEY3ewB7SARAUrTJ5998+8g86XSVSG/21dtu3RfBq4OhKqm+q8Jjkvwif?=
 =?us-ascii?Q?X9D3eExb1UsH7rMWWMEiiOS0x54MJAjVS97iDJ2POxYIEDqBJfr1pBGGS09r?=
 =?us-ascii?Q?J/cOxJtt4fu19uIAr5xAprBzSEd3AsRRjtYTcTddZZJc6yvBUhlz5UW1fV0f?=
 =?us-ascii?Q?awgtiXQEGGq7h3fTYxWW4GWVBriWjswCaAy+OF+XaQZNCQvgBuJtGj3gpWPp?=
 =?us-ascii?Q?lefBp7zIREBBjT6QggU6A3k34YRMg/38OsDfuZTEsVNiS73njpGIAzwD5wlw?=
 =?us-ascii?Q?YAiOQK6QWPTy97Nxt06QPTx2SLyzDOcGs8svNc4kAmII9fnDemMC9ZLBXdBI?=
 =?us-ascii?Q?z5ypSZbLirWEmgXawvmIN0a1VcIEl17LPyJOZfJP8oXXHIqicwOqb99feBV2?=
 =?us-ascii?Q?LPx0NcJ0uSWNCYFhi1pSgbpEuxxktZoGibWj++Lo0Ucg8d7Cs+uHC3xUQp8i?=
 =?us-ascii?Q?GA6q9L8QaBGnpz/Ii2PS+RagIJd8TxG2qxxUG+nJ7AlX4LECHGrzjHEIyoAD?=
 =?us-ascii?Q?87dulje6ihFfhaz77erqXnRwr6ufcxP/XZXVMCzKB7VrGVQO3bNW1Muug34X?=
 =?us-ascii?Q?W2aLMr/EZk5IUci5vA+TytAD?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c510ff42-3187-4a6e-562f-08d915610065
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2021 16:14:21.7913
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s1hkAwSAYcqmyy6OEQy5MzZlgjWTzdPdHzGGEBx8byP9FcTE1lqfaZBLfbjEPlqvjCLxfRtZlTYWQPVqQsZxuk0943RRnmGOWgMUjjdQUOY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3112
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9982 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105120102
X-Proofpoint-ORIG-GUID: PbQxFF5-TWWjJJfI-YQJRZO_2shsFogn
X-Proofpoint-GUID: PbQxFF5-TWWjJJfI-YQJRZO_2shsFogn
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9982 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 adultscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 lowpriorityscore=0
 malwarescore=0 priorityscore=1501 clxscore=1015 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105120102
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This set is a subset of a larger series for Dealyed Attributes. Which is a
subset of a yet larger series for parent pointers. Delayed attributes allow
attribute operations (set and remove) to be logged and committed in the same
way that other delayed operations do. This allows more complex operations (like
parent pointers) to be broken up into multiple smaller transactions. To do
this, the existing attr operations must be modified to operate as a delayed
operation.  This means that they cannot roll, commit, or finish transactions.
Instead, they return -EAGAIN to allow the calling function to handle the
transaction.  In this series, we focus on only the delayed attribute portion.
We will introduce parent pointers in a later set.

The set as a whole is a bit much to digest at once, so I usually send out the
smaller sub series to reduce reviewer burn out.  But the entire extended series
is visible through the included github links.

This set is just a rebase and resend since the last review came back with no nits.

This series can be viewed on github here:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_v18_rebase

As well as the extended delayed attribute and parent pointer series:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_v18_extended_rebase

And the test cases:
https://github.com/allisonhenderson/xfs_work/tree/pptr_xfstestsv3

In order to run the test cases, you will need have the corresponding xfsprogs
changes as well.  Which can be found here:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_xfsprogs_v18_rebase
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_xfsprogs_v18_extended_rebase

To run the xfs attributes tests run:
check -g attr

To run as delayed attributes run:
export MOUNT_OPTIONS="-o delattr"
check -g attr

To run parent pointer tests:
check -g parent

I've also made the corresponding updates to the user space side as well, and ported anything
they need to seat correctly.

Questions, comment and feedback appreciated! 

Thanks all!
Allison 

Allison Henderson (11):
  xfs: Reverse apply 72b97ea40d
  xfs: Add xfs_attr_node_remove_name
  xfs: Hoist xfs_attr_set_shortform
  xfs: Add helper xfs_attr_set_fmt
  xfs: Separate xfs_attr_node_addname and
    xfs_attr_node_addname_clear_incomplete
  xfs: Add helper xfs_attr_node_addname_find_attr
  xfs: Hoist xfs_attr_node_addname
  xfs: Hoist xfs_attr_leaf_addname
  xfs: Hoist node transaction handling
  xfs: Add delay ready attr remove routines
  xfs: Add delay ready attr set routines

 fs/xfs/libxfs/xfs_attr.c        | 897 ++++++++++++++++++++++++----------------
 fs/xfs/libxfs/xfs_attr.h        | 401 ++++++++++++++++++
 fs/xfs/libxfs/xfs_attr_leaf.c   |   2 +-
 fs/xfs/libxfs/xfs_attr_remote.c | 126 ++++--
 fs/xfs/libxfs/xfs_attr_remote.h |   7 +-
 fs/xfs/xfs_attr_inactive.c      |   2 +-
 fs/xfs/xfs_trace.h              |   2 -
 7 files changed, 1031 insertions(+), 406 deletions(-)

-- 
2.7.4

