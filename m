Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C913DC48BCF
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Jun 2021 19:45:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A81A76136D
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Jun 2021 19:45:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbhFITrH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Jun 2021 15:47:07 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:37620 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbhFITrG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Jun 2021 15:47:06 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 159JdQg4125162
        for <linux-xfs@vger.kernel.org>; Wed, 9 Jun 2021 19:45:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=BBtZJCcsV39I/pv7ctqhb6/wo61/ZhcIG9To7p3d8zQ=;
 b=y5bcqiinAGMDQ9O6N1XjsI9jmrOxPiXOAeCuMeptq0MGjS/mLV0FKb+h5033pOBsJpPx
 jlJuQccojn6ta1zhxKmvnIbxIzRKkFJve/r0cwn4iBXtceALcGZKyg4tmg3mgEioKF3I
 jh9wk7UM7ONyBLVfVwt7rUUeSt+XjbdP9rxb7FlISC+MIPqWHjQUrbyFp3a41TKpqUfP
 vR/VZTGiqflzUUo63NWRC2zdjMu8ZVcrg9mXZLX4BkRJX1EQ1OHaXlAa/ZMDBtXBgJ2z
 fpqmCqednVgj0fPp23v37RHmEBESQ66rwV7tha0hR6Mx5swhUmw2MvvQFEPyJq/+rjO5 ig== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 38yxscj6wr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 09 Jun 2021 19:45:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 159Jf6cA050206
        for <linux-xfs@vger.kernel.org>; Wed, 9 Jun 2021 19:45:09 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by userp3020.oracle.com with ESMTP id 390k1s81rx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 09 Jun 2021 19:45:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UBEe+rkXlnzChzfSVK+Xy/ksxFWxW3rphC84tlwnxAOrsMVQ3l3b0KTqr9SADgArB3+r2nPadhZD7BT1vvdEzCtZcwXscfJ6BbAzEQywB42l4KmsqO+35PF31s/WU3VlNtLOouZfD180pB75cm37Gv8OH0uT22GQbcys3p/OGD1/jhWo+GDYrlRqKFg09exT/bHMpDyTXXi8UMwxjf5nRkCU7PoBDWKt2oNx8nbCVrH5VVDKV6XiaqtfKSj6ta4jf5HZ9ntkiQkeOdL4/b2rkvgWTOgdhUV8DKQSeRfiIgxyxXetXDOLly1M1SpukbfTKxkrEjCkrQINjxdoDCrQBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BBtZJCcsV39I/pv7ctqhb6/wo61/ZhcIG9To7p3d8zQ=;
 b=f2lgBxz+sacJ2f3Kf8Htzu2BpVcGYsjTBhvffMIaz4kJpNobNW+eT5ggChiSjbVmssHQ4h2/3dbnTiCoobdR/r7MwTmNZNIfdBafGBFpP3m5QrXtqrQWliZvGRDHXZ1rhxH2HOtL+6NfSnNN9ausnNggT4pAD7zgXvruH39U+yYYf9StnST7tnR0NRl9DvqGB1wcLYt/hmT+mpvedNFWk2Z53I9gOFWv8Pngk2HZmZ/pzlazbo3lsbaF4FwlRcZNyyQPdaYSQAwMgbrG2xmU2hKTJQNsAQuYkxUrxJYB9Av5eBnm8VE5T751TbhH740vY7u2oTd+HLgTrdJN2xgj1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BBtZJCcsV39I/pv7ctqhb6/wo61/ZhcIG9To7p3d8zQ=;
 b=WseFOyanHMW7zPmAt7TqM3uAN+OEe1ai0ZeFTMRHJAIGQa9rt12w8oyE+trwi1xHX3LkKM7BwGvuTT1+RIvMt+3AvKtJ4L7nkmggbRYEdwUsDup8KnjvGuTx/p0oyMGsPoemXVgc1B0xBKnhYrC6RxkveJWL2joO93IfHjzpJ2Q=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4147.namprd10.prod.outlook.com (2603:10b6:a03:20e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Wed, 9 Jun
 2021 19:45:07 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a9c4:d124:3473:1728]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a9c4:d124:3473:1728%5]) with mapi id 15.20.4195.030; Wed, 9 Jun 2021
 19:45:07 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [GIT PULL] xfs: Delay Ready Attributes
Date:   Wed,  9 Jun 2021 12:44:47 -0700
Message-Id: <20210609194447.10600-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: BYAPR06CA0013.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::26) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.210.54) by BYAPR06CA0013.namprd06.prod.outlook.com (2603:10b6:a03:d4::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend Transport; Wed, 9 Jun 2021 19:45:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: af4b9183-e9c7-45b1-4df4-08d92b7f1574
X-MS-TrafficTypeDiagnostic: BY5PR10MB4147:
X-Microsoft-Antispam-PRVS: <BY5PR10MB4147D5CD87F9CF76750D7E5895369@BY5PR10MB4147.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9gja86dz5YirGv+oAzPfVtOTAkbhnDHPLsfoXdRmYCZ9zaMoIY89TFXzZBA3vJ1POXMxxD6IRoMOxRwIKkA+L7EM6KxSCrjQFQwvhqHUfwezSnjqzgL/1ADZHwSLmKlCSA9NHd1YZHviQha8pDAze6t+ZkzvkHGyIrFNOWX5bBgbGWYafqKzrjUTA/K9iDxYdMKvlMpG6ssGxYqL92dasYLREpvE6rWSdz9bk867ds6cbwKy3YbW8AzgCDJoY7VtazWSTLV9O3genXcjM/J2MgqQ5+2TUC7wjHul1AZHCZmtGoZrryZhT7W8zfNQB6MMbDpP9rxh26xw3i0/90zY7YIi2rakj/rNivl1fbSfq5rBCzi7YfOUMBjhkCJ0w0vzLR1cILM+2+RpCH347lUEDQ/jbiEHbmlu8+s4gzaZo2yta6hBvea6srgloHm6xgTiYD2QAuSDB84nlL8cAee6doF7BvQ7IlYH6J0CXIGPcwh+VkMQaEe35MXnLjddB4UjK+aSGW351Wv17mi8opghtqmNquGYkbaZLdPmwgJUv/uiJ1lNXmiQLVvH77ugCp/AMOmiDggwDZkgGWTUEYd7X7BnRuDDSuh38MXd4RAve2WqWBVcuHHnjZkhFXZKjjRjloobQR0ukKR/kcQn6UqMt2Sxofer9MaTI4X3snPQZcvaiQHgsD0WwGZZeWduIXT7kCI0F/gNEfIVjv8j2GyyKasXC+1cGqfbWKHNP8LFY7VXHm6EOz6ttJCdzM6McSNYODNbH7E9ln94xpGOsoY9AnpA34HJOn3Jq4RGEVxbqNvx/rKbp1kLQxZuFnLpj8s5x8Y/dz274CMfMOeiWY4KtA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(376002)(366004)(136003)(39860400002)(1076003)(6506007)(36756003)(2906002)(8936002)(6666004)(6512007)(6916009)(5660300002)(478600001)(83380400001)(966005)(44832011)(956004)(38350700002)(8676002)(38100700002)(66476007)(66556008)(86362001)(6486002)(186003)(2616005)(66946007)(26005)(16526019)(52116002)(316002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5QpnU/LBoF2JM/YUGsteZVJGVAjJdQj7k2MU1APpAxYFb66TlUeW5ANVJqdq?=
 =?us-ascii?Q?mcOjyuB99oDfe1UHtYAYgqNorm3SdiZkpIPNQOiQpErgm6JPsScwRVbkksnW?=
 =?us-ascii?Q?FbGKEQigiSF4nAKkHJVM08UeLeeands9zSDKTvPXDncX5i6fpdKriusv7tCQ?=
 =?us-ascii?Q?zy4pUA4fKMb4uve6iV/BCFQV25sYRLeaNTWZSiFOPhVO7dK4zUFf7ZcLYljT?=
 =?us-ascii?Q?0lUf92tY4KlNMmZbhZEC9Wrq6YgnaAcQdQyzFH29tNh3KC6Wd58T3KRoQM0z?=
 =?us-ascii?Q?UGpu4byBU69XMplXAKAWGCu5OmUn9cFrmGSIVGPL9lIu0BZgWuHq5uM1LqTc?=
 =?us-ascii?Q?l1PofqgKulHkaMt0/7LrQO9704PBX0tzU3L+LNs1tETV92OWHAnDATGyi88q?=
 =?us-ascii?Q?olFq48IYD7Okhq4JMI5rOBq3leoaLVQ7TL5fFKKYGA8rg7h01Tbx7CrKRFjg?=
 =?us-ascii?Q?aI/ohEyJW3xmx9YERHcTHAOwKmNxQ67Lfz7w/20aUSnPQWKGF4jf1rClZ/MG?=
 =?us-ascii?Q?wZboDaVBGkDOMb8UM0g0Q8Z9MkLEU6YpP8hsOwlgkBTYzvSpmJm9/1frRDYk?=
 =?us-ascii?Q?YpK+15Rei78KJReE1AuwZ26Ums2daqxQTKeKl/JmVFDJuLLtHLeKcACkKmlV?=
 =?us-ascii?Q?o1WGFmZIFPAo21zv53klUO0gjCLl8Cla13fk02xNfkpVSLQQVWv9iJl900hL?=
 =?us-ascii?Q?NCp/Pr+xhh4Mcw+4ArVHOAhrzY79ZYJNSJPleWhAx9NPCwA6G3Ih7r5oensg?=
 =?us-ascii?Q?aAvxk5s9eoGQhRhkLqfqtiIHgUrds2FqNLkgjiJNP5licsqScCcvboaYL7Hz?=
 =?us-ascii?Q?R2BDbxOnB9RFgb6QlzQQRwYnQ5mh0DmWOAbN96P78D9ItKBFtVhN8AX70e3T?=
 =?us-ascii?Q?a6JKNpFKVHOTkX9moEmox4Gcd6sUWkoMwLscdArvpwtcg6kc2mi7qG03NfYw?=
 =?us-ascii?Q?0lWeTQq2QxVL00ZTjhp7uVYlSo9doK6IkzMPjmudkTTqWT/QDxwWUi9hcCuY?=
 =?us-ascii?Q?b5Tlv0Cp+UnPWIGMiABu6szOGr4PwoXopK1yNMl0UUvaONGlHVm4Smb5M1T/?=
 =?us-ascii?Q?PRifQvNicB6QUzrMkusqh9IItJuoB4aGeGxmbFKtSr/W4KTDQOgPLZZ2qOvZ?=
 =?us-ascii?Q?nTldRXcNvtavbpOpR6BpSZI3QYY4kPevHyM1ByjV9YLp5qN1Li9auQk1OznB?=
 =?us-ascii?Q?EwjKNUotBYGr/du2pFYwjTmJU3DFd5DFXX5eOMDPuQduu32n+G4eid0pYqiI?=
 =?us-ascii?Q?UAadneFWbszAVXx4f6N1LUMBu0O2KRfw/EW6VQBaBQ1hIciBnxUmw642wtn4?=
 =?us-ascii?Q?8i1n3E5+6ikvLYgWKg0KlEw6?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af4b9183-e9c7-45b1-4df4-08d92b7f1574
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 19:45:07.3735
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m5MWFmnLoafL/p3hnlzpKksc1iXwmRBLRH8cYFGfLMgQdtcC9sDt5V3gF0zzHHr/LdUgEou23s99nVKmP2CHbYi7YdWuZdW/+bgEx5msMeQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4147
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10010 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106090101
X-Proofpoint-ORIG-GUID: -BFaL6TgGbpr0JjF4_CjjOvmMzOu_by-
X-Proofpoint-GUID: -BFaL6TgGbpr0JjF4_CjjOvmMzOu_by-
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10010 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 phishscore=0 suspectscore=0 bulkscore=0 spamscore=0 priorityscore=1501
 mlxscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106090101
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

I've created a branch and tag for the delay ready attribute series.  I'ved
added the rvbs since the last review, but otherwise it is unchanged since
v20.

Please pull from the tag decsribed below.

Thanks!
Allison

The following changes since commit 0fe0bbe00a6fb77adf75085b7d06b71a830dd6f2:

  xfs: bunmapi has unnecessary AG lock ordering issues (2021-05-27 08:11:24 -0700)

are available in the git repository at:

  https://github.com/allisonhenderson/xfs_work.git tags/xfs-delay-ready-attrs-v20.1

for you to fetch changes up to 816c8e39b7ea0875640312c9ed3be0d5a68d7183:

  xfs: Make attr name schemes consistent (2021-06-09 09:34:05 -0700)

----------------------------------------------------------------
xfs: Delay Ready Attributes

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

Updates since v19: Added Darricks fix for the remote block accounting as well as
some minor nits about the default assert in xfs_attr_set_iter.  Spent quite
a bit of time testing this cycle to weed out any more unexpected bugs.  No new
test failures were observed with the addition of this set.

xfs: Fix default ASSERT in xfs_attr_set_iter
  Replaced the assert with ASSERT(0);

xfs: Add delay ready attr remove routines
  Added Darricks fix for remote block accounting

This series can be viewed on github here:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_v20

As well as the extended delayed attribute and parent pointer series:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_v20_extended

And the test cases:
https://github.com/allisonhenderson/xfs_work/tree/pptr_xfstestsv3
In order to run the test cases, you will need have the corresponding xfsprogs

changes as well.  Which can be found here:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_xfsprogs_v20
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_xfsprogs_v20_extended

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

----------------------------------------------------------------
Allison Henderson (14):
      xfs: Reverse apply 72b97ea40d
      xfs: Add xfs_attr_node_remove_name
      xfs: Refactor xfs_attr_set_shortform
      xfs: Separate xfs_attr_node_addname and xfs_attr_node_addname_clear_incomplete
      xfs: Add helper xfs_attr_node_addname_find_attr
      xfs: Hoist xfs_attr_node_addname
      xfs: Hoist xfs_attr_leaf_addname
      xfs: Hoist node transaction handling
      xfs: Add delay ready attr remove routines
      xfs: Add delay ready attr set routines
      xfs: Remove xfs_attr_rmtval_set
      xfs: Clean up xfs_attr_node_addname_clear_incomplete
      xfs: Fix default ASSERT in xfs_attr_set_iter
      xfs: Make attr name schemes consistent

 fs/xfs/libxfs/xfs_attr.c        | 910 ++++++++++++++++++++++++----------------
 fs/xfs/libxfs/xfs_attr.h        | 403 ++++++++++++++++++
 fs/xfs/libxfs/xfs_attr_leaf.c   |   4 +-
 fs/xfs/libxfs/xfs_attr_leaf.h   |   2 +-
 fs/xfs/libxfs/xfs_attr_remote.c | 167 ++++----
 fs/xfs/libxfs/xfs_attr_remote.h |   8 +-
 fs/xfs/xfs_attr_inactive.c      |   2 +-
 fs/xfs/xfs_trace.h              |   2 -
 8 files changed, 1032 insertions(+), 466 deletions(-)

