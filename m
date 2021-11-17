Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55010C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 04:13:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A504608FE
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 04:13:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232992AbhKQEQv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Nov 2021 23:16:51 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:11432 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230088AbhKQEQu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Nov 2021 23:16:50 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AH3L6QR027692
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:13:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=UjifaO/VZRfmtWzuctGUH3Xr4bll222KVKv2//MwyVk=;
 b=ElCdMMU9buCOzv9Fbaxp7nnZKEAexc9j1EZRg9TBW3eAzHJkqxB53GdYvXBxBmJZ6S2Z
 7SP1ADWGjoFSA6lIhqTVPYt/tDNhlt7fnxe5KkcD+e6DVjsKIEZqxYdq8rHwN3FjYgk1
 /adBN24RKgQ2cOJIbi/PBbP0ncEFgKLigfpwSXKvf2Q0rUhBkvrtDYpOHKuV6Ucsj/o5
 Mmf8TdBZkO3EF883mne7TtGQMDk+Tc2oS/HX9cJSfWaJW0uEvUo8sEmcOu9mIdGZaXxr
 ed/huJhWVEqZcz4YWIP1oz9QcLhrHRt+iu9OBO7c0CMXW4KU4JMbNiNmxSobRxfK3Xr0 OQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cbhtvvpbw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:13:52 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AH4B6AO184801
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:13:51 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by userp3020.oracle.com with ESMTP id 3caq4tncu0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:13:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cKigFliNblmin/3FHaF0TbBiu2j0JCm2VqjF6JmxHZazXY6k+9o97051z7MHkyK+tD03RHtyAT6h7hJ/LyHwCLxipiYtLx5QSqYbQOm6Crp/T6oxAcch+Hh8tzQGI6O0VrYw09Zk6R6UsvB5vII0v1rtom+PrKurt/1eUStCzRKn9Ty5wfkRVqXjqk/RxDHqNXndovXq0tTcIYoVC8HeEAGRobilY8n9NIKsYDOdUAFsefeoHK0MNwx9SVZQA3u4Hhkzokbx2KkQN/0VyLXYDWpRR60IBvYOk+DsDBfOf9DJD1+SUh4A194x0Ic4pVoiNZJPXbGSQBVLDZl1x/QFhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UjifaO/VZRfmtWzuctGUH3Xr4bll222KVKv2//MwyVk=;
 b=lGLjabJuxKDyn37XxFCTYvwnNdmbm7OCcOmbbkb/afK92VWiD9F6PLeO1u+2KDPEaCkbooT/YTCPpZWQV4BfscTLWpo7i6ZX7+Surbam6Pf2rlP/m4VSTKB7oNYE+invgiJYnud27+u45WVR2lLvnVvr4zANx1SXsERcDagkzeys6ncFG7RhGMDY1l05qKyf3qXzuIPw/f9N+CpeOXMY8sqYWsUxKrTlIvJRswXgGDveEd8ntwvfuwMGYOkWrjJ/506KkbFXrO/Agv0T7r35Qga8pgO9GaK6E7OafmwdEhHfwzfHaltAn0QpLLCqbtSO0taq/irOlGcnAFwOMmbwYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UjifaO/VZRfmtWzuctGUH3Xr4bll222KVKv2//MwyVk=;
 b=HuHl1QlTheS8TtXfG2oKlHzRA2g91gg3ahDzsuHKU2n68880fPB9zlNS5s9xxSif9zaO4SSXlICN+rcyPji89ax72MVml8q1NLBcImC6OP6ng33d4ekD3WD00lSj5slhS9SnGW9WHrZyCQbMF4+ry6qEES3T6aiOcol46xeHHCI=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB4086.namprd10.prod.outlook.com (2603:10b6:a03:129::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Wed, 17 Nov
 2021 04:13:49 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2%9]) with mapi id 15.20.4713.019; Wed, 17 Nov 2021
 04:13:49 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v25 00/12] Log Attribute Replay
Date:   Tue, 16 Nov 2021 21:13:31 -0700
Message-Id: <20211117041343.3050202-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0008.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::18) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
Received: from localhost.localdomain (67.1.243.157) by BY5PR04CA0008.namprd04.prod.outlook.com (2603:10b6:a03:1d0::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27 via Frontend Transport; Wed, 17 Nov 2021 04:13:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ae705c88-dbcb-4f17-c420-08d9a980a7f4
X-MS-TrafficTypeDiagnostic: BYAPR10MB4086:
X-Microsoft-Antispam-PRVS: <BYAPR10MB408684AFB1ED1E2F3FF105F6959A9@BYAPR10MB4086.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a0qVwztZEw7GvOrORMuHWoK+2bk7GGP/DLGyyjE4lwlbA7Yi5dQX+PtKVUou4EfmvaIf9EahT0hpjg6+1gv7mNYSKi8zFlOlC+v9BJNpYi72q/uev5aFeka5s/EwaIAookkt/F90U2s5jQY6aw4ltwhFu5PI4TLfvRoPJydWujTCU2SP41HRdtmyXWj/Py62iTgLdxHKLC1Q+aWKupUPIIoDEd1buoTms7PVP5qiGwsBCyj7IlV5NoxbtrLQUDJ1noXe5K24EKmymnfihL8aMWbUf0fVri9xgUPRVqJHV8eCW3TuKAmkIkE/59exF2k/V4/NHGL20ZIU+cYtHTRwj45po3K0QldrB9/227l8JBtairrH2knRN1GBu6yaKndlcoL7ir0kekPFeJTXE9bNWP7SyMKZOLUbEVHF+BN95MZ8KM3MRg0q5whzVdCyrymxmQlgzsE4uRCHw9MsylHHXbG/dx/2vAm+ZNt7rfIpe0s98tNznrzp626hV8C7d7qNJe/EmgiFNgCOKVh4mkSl+YcItxqibwwRtUgT5b/VGDqsWnXDwYGEglo8q1S+GWLqpS5KloXCFoh65hF51Bemp8d4rgugbbnxcf3pTW/vIrEurV0MvTVoh/c+dbJry6lDkKWXvAnHE42xp69ov257lSRq/rwapBByaah0Ta9AvwCvTY5O/qoS4dl2XMdxKO16Nk0Yr0gZrTzLjwfXEiIjwSPCcwALjTHHY04ue7lzIcOENJLtk5a1UIhV9ncHAs9mHOXaQt29P1DEx3Oeskchr1+iQmVWnALXz6ivazr6O6eGB4u32dF74fMZZJbZqv7gWsUNAJMfPAemtEq9DzieiA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36756003)(38350700002)(38100700002)(6486002)(44832011)(66556008)(8936002)(52116002)(2906002)(508600001)(5660300002)(8676002)(66476007)(6666004)(316002)(6512007)(966005)(66946007)(956004)(83380400001)(186003)(6916009)(6506007)(2616005)(26005)(86362001)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1iX/7rxT5cWYhCpq6Thwoz5C29UYJpf7bFE+tu1wY8jLvOLZfCCXpgnKRjdL?=
 =?us-ascii?Q?cF0J1rh7HsHJH30or4+Un0LxMq8VjNH3YkbNWNepGiHv+qnLdnzdzZ7xug4j?=
 =?us-ascii?Q?QL73otqd//KpFbjBlXOVqPLUai3HffZw2mzYcrQA1G/uSKKcN361hoAbFuhd?=
 =?us-ascii?Q?BRTVq7SsMgjv/Mu9E59q4wKbV56rRFyZIXm3J2kuAiek6JXnpkETfCSc/VlY?=
 =?us-ascii?Q?rs+T5I7wlgSXOfQkELkoSjG0bjsCxFp8X9aEG8/6y3zK4vDBpqTjVbMLXmK2?=
 =?us-ascii?Q?IW54fA5WIUEjtGjJ6kXK7TUj8PsPxHuvbbgf2p9Kkrq3GQKsr5f3htOmT+u3?=
 =?us-ascii?Q?fEZ1+B1uzieE4/7gtvD6NZvPtHguDQyvmAW2UeNF4YjOkQ7KVm9ERadtTjcY?=
 =?us-ascii?Q?RYya4YBG0xpXfSxoewHOaIUWgKsvKswKoPV2GBICwXf1FN7MOrYBtb3Chgbg?=
 =?us-ascii?Q?yS/xE/jDqnbYAjbZKwI0JbRPwgKmwSrpIiu/h1v/8cbg1CThtpFGvLedFH8h?=
 =?us-ascii?Q?2Pn+hwmqx47ORqMctEPO0Y3sz5KdPVfcgwINOnGy9xkoWByE9zqvQjN7LPFx?=
 =?us-ascii?Q?MUX5f18HRugej2+y9hs76+U5ZChIxS3Xpcg6KvDrXa0QhE1KLxCcboQw1OgL?=
 =?us-ascii?Q?GK31mnd4HmveH4IjoMByOY6yUCGt8RFc7TIeMTFpOLQwjDqCBPV/Tqx7AHY3?=
 =?us-ascii?Q?PzZmNcWX6jtFQNjb+XZBYju7VeNNbNW/h3F3rAaj8tCJTQLz50JG+T0x5aNo?=
 =?us-ascii?Q?va5a3/rAU3RbMVe0MVxA/pF8FIwsQOh7q5cWDt4eO5fby63gqg7OUIta+MEA?=
 =?us-ascii?Q?fJJTe8zpETMVyE3BOp1S20O8qc0Pv+ipf3Ets/bcdLkaaD2Jr3KY4XMKazaw?=
 =?us-ascii?Q?QQaewFECbiFN1s/1wy7882XB30ARAQNnppBIeHlMdbMkSvL8lJu+80BOYWSO?=
 =?us-ascii?Q?8pHEPc8XYkc7lhjx8/ghcZjw2Fn2ApqLfQYqEmzxvlWIZK5ceGeiTQeckqoE?=
 =?us-ascii?Q?PJpmmpO0Eg+YAfZJkQDlvMpNgu3BrM4CzVRTwRXC6bDvfDv+u7XM0h6ojwm9?=
 =?us-ascii?Q?2C1tXJrmC0XfKTmAKpHlsHtvipXYK1im7hCxEeFN+8r+BVMIwTNlNyCD3zXK?=
 =?us-ascii?Q?3djMWDp4m1PjQt3sKKVXkY2fnL2irzznnIc1VSoWg25cEXiYKx+CJGLUCR2h?=
 =?us-ascii?Q?GzQDICTDyzfkYbPwJ25L5RzM592O3igOyNtGRYaNfGmynV79pMU3hDTWij9u?=
 =?us-ascii?Q?I19qtwk8/BK2hiYUpNvuAIoj2k6EMm5hx2LAicMbtGRgGjUStbZ3XoYpwyi1?=
 =?us-ascii?Q?QNGXtr+QszuJugA+yVONFRUT6yVGgdKMz8OgmhEVmrxUsYIPMy9ToAjYYlEj?=
 =?us-ascii?Q?dxDsFlLILBJhWnuhrcAVd2xPdIXAzdUDYOOT1l73qbDCVSpvabl5yCIamqtU?=
 =?us-ascii?Q?Xn28qDsSazvk3i4VHbZFxrbeop6D1V5iTIWuNoiJd7GToki1shRT08U0ZIxO?=
 =?us-ascii?Q?DU0h7IL6GfPaUvx46qgFp9cCU2K9nKdacAaS3h1G0CXdvQmWO4/BVqmCpQyd?=
 =?us-ascii?Q?h6W/kJgK8/WqQtRi5tnOnahX/3DUK/MWKy8fFAEe22/RKMAQ6YqDbS2pi3fQ?=
 =?us-ascii?Q?IkNX8UefyuisiEniNl+kughl9+ivjK0AUUdGV3pVQ14I4k5fCosaaOwEcRLq?=
 =?us-ascii?Q?W3/7yQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae705c88-dbcb-4f17-c420-08d9a980a7f4
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2021 04:13:48.9415
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3IxHf0rJrfsioMox3A7hIhjt/zW333lL6En5Y7DcHbJto2s7UzHkMA4dGWYZ8MY0qTdbj8wydL43cWFkIgo0v/XM1UYm1kY9DczM7DJi8Xw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB4086
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10170 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 mlxscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111170019
X-Proofpoint-GUID: rsLKwa8bGtE4wN4g9L98EI7zPg1DcV5G
X-Proofpoint-ORIG-GUID: rsLKwa8bGtE4wN4g9L98EI7zPg1DcV5G
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This set is a subset of a larger series parent pointers. Delayed attributes allow
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

Updates since v25:

xfs: don't commit the first deferred transaction without intents
    NEW

xfs: Set up infrastructure for log atrribute replay
   Removed unused DAC flag XFS_DAC_DELAYED_OP_INIT
   Removed uneeded header includes
   Fixed ATTR_NVEC_SIZE
   Modified xfs_attri_item_size and xfs_attri_item_format to avoid crash with CIL scalability patchset
   Fixed malloc flags in xfs_attri_init
   Changed xfs_attri_validate to take an xfs_attri_log_format
   Use xfs_attri_validate in xlog_recover_attri_commit_pass2
   Removed uneeded attri flag
   Move *item_ops to end of file

xfs: Implement attr logging and replay
   Rearrange atti/attrd functions
   Added xfs_sb_is_v5 helper to xfs_sb_version_haslogxattrs
   Added xfs_ prefix to sb_version_haslogxattrs

xfs: Skip flip flags for delayed attrs
   Fixed fallthrough warnings

xfs: Add larp debug option
   Added if def wrappers

And the test cases:
https://github.com/allisonhenderson/xfs_work/tree/pptr_xfstestsv5
In order to run the test cases, you will need have the corresponding xfsprogs
changes as well.  Which can be found here:
https://github.com/allisonhenderson/xfs_work/tree/delayed_attrs_xfsprogs_v25
https://github.com/allisonhenderson/xfs_work/tree/delayed_attrs_xfsprogs_v25_extended

To run the xfs attributes tests run:
check -g attr

To run as delayed attributes run:
echo 1 > /sys/fs/xfs/debug/larp;
check -g attr

To run parent pointer tests:
check -g parent

I've also made the corresponding updates to the user space side as well, and ported anything
they need to seat correctly.

Questions, comment and feedback appreciated! 

Allison
Allison Collins (1):
  xfs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred

Allison Henderson (11):
  xfs: Fix double unlock in defer capture code
  xfs: don't commit the first deferred transaction without intents
  xfs: Return from xfs_attr_set_iter if there are no more rmtblks to
    process
  xfs: Set up infrastructure for log attribute replay
  xfs: Implement attr logging and replay
  xfs: Skip flip flags for delayed attrs
  xfs: Remove unused xfs_attr_*_args
  xfs: Add log attribute error tag
  xfs: Add larp debug option
  xfs: Merge xfs_delattr_context into xfs_attr_item
  xfs: Add helper function xfs_attr_leaf_addname

 fs/xfs/Makefile                 |   1 +
 fs/xfs/libxfs/xfs_attr.c        | 454 +++++++++---------
 fs/xfs/libxfs/xfs_attr.h        |  60 ++-
 fs/xfs/libxfs/xfs_attr_leaf.c   |   3 +-
 fs/xfs/libxfs/xfs_attr_remote.c |  37 +-
 fs/xfs/libxfs/xfs_attr_remote.h |   6 +-
 fs/xfs/libxfs/xfs_defer.c       |  41 +-
 fs/xfs/libxfs/xfs_defer.h       |   3 +
 fs/xfs/libxfs/xfs_errortag.h    |   4 +-
 fs/xfs/libxfs/xfs_format.h      |   9 +-
 fs/xfs/libxfs/xfs_log_format.h  |  44 +-
 fs/xfs/libxfs/xfs_log_recover.h |   2 +
 fs/xfs/scrub/common.c           |   2 +
 fs/xfs/xfs_attr_item.c          | 796 ++++++++++++++++++++++++++++++++
 fs/xfs/xfs_attr_item.h          |  46 ++
 fs/xfs/xfs_attr_list.c          |   1 +
 fs/xfs/xfs_error.c              |   3 +
 fs/xfs/xfs_globals.c            |   1 +
 fs/xfs/xfs_ioctl32.c            |   2 +
 fs/xfs/xfs_iops.c               |   2 +
 fs/xfs/xfs_log.c                |  45 ++
 fs/xfs/xfs_log.h                |  12 +
 fs/xfs/xfs_log_recover.c        |   2 +
 fs/xfs/xfs_ondisk.h             |   2 +
 fs/xfs/xfs_sysctl.h             |   1 +
 fs/xfs/xfs_sysfs.c              |  24 +
 fs/xfs/xfs_trace.h              |   1 +
 27 files changed, 1327 insertions(+), 277 deletions(-)
 create mode 100644 fs/xfs/xfs_attr_item.c
 create mode 100644 fs/xfs/xfs_attr_item.h

-- 
2.25.1

