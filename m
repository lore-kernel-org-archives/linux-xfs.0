Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EEC2C433FE
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Feb 2022 19:52:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbiB1Twt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Feb 2022 14:52:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbiB1Twm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Feb 2022 14:52:42 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18C7E3BFBF
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 11:51:58 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21SIJIAr010136
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 19:51:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=CynGEQXlrzRyu57rGg3pJ4Uxg/CKC2Ldoxjwmms6s/4=;
 b=yaTaJlaUifDbOOfWb5qhQtSOsj+uMEgSmOgcWM3I3J4iAek2g/jcysJpB8s5mWcGN1Af
 leWty9u6/7wwhqagH3iVwhcwSzAPvJdyiFAw4cVddAvPWX0YYFG4m70XB3/5qqx6TwXy
 I47Vr2eav4u5bwPRlw7RFkoPbIQPhJvmTmVaF8KDhtjiHW/x7ITTW056dubeYXueW5ZW
 Y8boxM1sHMAXJWz5nVvQQaSKaSjg3BfLSZkp/fpru6T2eZ9rreoaBcB++61K6Li6HtP4
 3DWkUrrLlJrq1ckqli1rYoQQvv/bKjFJqLnxwOWUGACyzPhboxlMwpu02c5iYoescplr tQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eh1k40ppy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 19:51:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21SJkltg076550
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 19:51:55 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by aserp3020.oracle.com with ESMTP id 3efc13e3fr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 19:51:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YJINODQnvO9bUEMhd+lEKWPVjxX4bzyMeSMMFs6+n+DFkVI9qIQ5cN0C7lyhtldaB6BJKtQCU2LAuHOTyQWN0LSlaNv4D4RnrDtUWpL9Wb/YjDmkKulY59z9BTt+lciw6q2bipQAkdvfU0AGTzR+RkDu26NHDl/5NW0K7de5qhzt7tmBgj4bSR9sDkpo9fNWdER20kzDHBhn0eKxQRm7ziZV4xQYq8VAhKu5YHTlEx9WIYv/Rp6SkP914EZtJM3/vLoxQILhGLrFdB27FOQuO0Kqw8jFDNBghN0UgSetgb5U8Icy6XAHJ9CG9P9Nz5Uzue86uya/w+ZOMfKfL80P4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CynGEQXlrzRyu57rGg3pJ4Uxg/CKC2Ldoxjwmms6s/4=;
 b=CZvX/IH1gHFnwbzLs9aielgFw/iKb/J9C6RTQI9N2Htrs/wRw31mSDDd7n+XneO2wqdQDPLTyHGso6Et/+QIBQVTFNO6hCs4rPO/uRCayWWEkdy3iy+yAdJVbdRMNiKLcmsxiYLHVZFuXTmL7Bxlj4kEr9Tp7ej7Jt9MKZ3tYVEaA9jMSsCxGqxlTTK+nZexbcJZ8J2ELu6UZjSdLBkUkwLYzR+bW8e2uz/JqfC07CRLz+IO7Sq6MPOBQXdCV1TTLoG27aDhJoKa/jN1QK/D+ttEAQiG13XIM1ZbpcjbwlkmpIs5dYsjPSV9Fqez81/eWc8Iftv9JKqEFW9LuFfePg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CynGEQXlrzRyu57rGg3pJ4Uxg/CKC2Ldoxjwmms6s/4=;
 b=Fcms2ePUagiSzDMYAt1ZjxLvwssqdiWuijov2ZN1dEQuKp/OsD+USBD6szdwysqgCYvmBFSRybFRrDb0hbHnss1OOEDqxhH5OZwdGBbmoifXMJM0izHmiPTUH7ItDtKc0FDobemRoAMXlBQka5Xtixz0XMyfGd+VDibxwc8ZXXs=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB5612.namprd10.prod.outlook.com (2603:10b6:510:fa::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Mon, 28 Feb
 2022 19:51:53 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a91b:c130:5e3f:119]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a91b:c130:5e3f:119%7]) with mapi id 15.20.5017.027; Mon, 28 Feb 2022
 19:51:53 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v28 00/15] xfs: Log Attribute Replay
Date:   Mon, 28 Feb 2022 12:51:32 -0700
Message-Id: <20220228195147.1913281-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0023.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::33) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 88d7611d-4975-4e71-7a24-08d9faf3c4b6
X-MS-TrafficTypeDiagnostic: PH0PR10MB5612:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB5612C30DB9E74261565970D595019@PH0PR10MB5612.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JrLwqsD24KW8vmpEuiKo7OO1hXqmHzIQmWT7N5zWuHbTpginkN8lXwup+VGy903MicymAy/JLzAl2oRgdk8MbUeHYVk2pN1eCybznuj2WhGkwVmm7WXm82HjLxa4CpOXZxOqfW6WVCVG9KEZcaC31ejMMqhdSJeEdgrbNM84cJJObGU+Kwgz1T8LoVE3bM+QjGECTjIjtt1SHJ0ERjXWp6YZWE2yo04Q07HaEcLiHWU4ZEzDddxtETIf+ZdUi7EgJKC35yWxn1p3aTW4H2d2mDY7MYzfcYmANmKZS2jf6ZBduprRK/oS8UbfMk9GoprnL3cYQ20TGxWPom+D6fE92k46ixAA6WJ7SGgldhzj7bW2+nCVJeOJxoQ1eAWfJ40lXL28YWzfCrMBvjN+88t1q49wPhZZlDjfQWDyJWFwScSw2GM9gc1B77lo2K5Zgl9o3zZuXESrShPqKlZD8OTTCohDmRKcWFu6amZbWn87Mx2UBrreA711NkvRCDwBiWYo6KxViFoh/NY3b9gBDz3pNEQj2r2811geRWMF59aLQ8X4/K6dPHiFDxnPAdTz7HFPlQcXjZx5t4KQ1qNB/AsIJV9tzrvFVTjJvVBANCFimGcH1lBQs/e18PXBMO++gEopunujQaP2OalIEE8gLQ7aBDEYu96sHBF2l5uRaQZD2Upg8Qlu7PhY84ereBjq8QuXOrFBSucXpyvWyX/Ozs2VdNpZFHGtiVJUQw639yWInBDnbOvnwghzPIfNYArh+1jaqBRm3CikerfujEMVnNzAuGBMf0GOwHUGZ3J3CVkuXFrjai+snRlbhf/tg9zX8r/dyWWaI8a1Uu3my6MvPa0i0g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(86362001)(186003)(8676002)(6916009)(1076003)(316002)(66946007)(66476007)(66556008)(2906002)(2616005)(6486002)(966005)(6666004)(6512007)(52116002)(8936002)(508600001)(5660300002)(38350700002)(44832011)(83380400001)(38100700002)(6506007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VnAbtUJE0MAfjZv44fNiLhdhiTF4Cl3e5Tw+SQct1SmX/bikj2gMOq2ui8x4?=
 =?us-ascii?Q?RX7OFcIWMiJ8SbxLcwNCaA+bc+zXIHHs88p8fo7wi1zXt9DZaYDZ5zmCPHxJ?=
 =?us-ascii?Q?LN6KWIRUs37e8at4hTCj7sxYxYS4z/6KIp5AGL6DVtZhErBXP0iyp/k0rtMk?=
 =?us-ascii?Q?MHCRipEyUyi7jm0sNP+Br8BSGVVie52HCsdsngcSCI+1yKeUkGo0KduFOjZ4?=
 =?us-ascii?Q?tmggYnbFPib5IX0HVezb6zmgRSZ5rGjv/4TqI1mVlRYcdIY9kChSw2Abn1Yc?=
 =?us-ascii?Q?03T8uQUAnPtdSOoloRp7js+CDMTeAQNfi6qdUsYRzfXZ3KmX6t8gPM2ZR4Oh?=
 =?us-ascii?Q?XT4Bx5gnnBe9j9VYW2zVcxaITb70bAu1xIFIpi++US7CQNB9ZR71hLKGUeDG?=
 =?us-ascii?Q?F3087hxnwrmxTooksCaBQAFchPX/l6rC5WDyjopfJ7H0hJcrFUg58XDRo3x0?=
 =?us-ascii?Q?QP8aUPNvdd2NeCZ79bz4KskckLBto+VhfmkwHnJ9EJvi0rSn+kn/UFik7h87?=
 =?us-ascii?Q?9E36vTlQNPc15hdgPAFhSTZcrozRSLJpkghlNNV72eFsCS8BLz6pczlX12Dg?=
 =?us-ascii?Q?skkHeAwor0sNqsm/uktUCoYlwautAz+jBdPHixshWLKdtxA6VD+6ud3fbUOO?=
 =?us-ascii?Q?Y6aHuWNd9owaXoQ4PsEMNgEFWf689HfcAeMLOTR0ct7/NOJrDg/7mce72M6d?=
 =?us-ascii?Q?ngQbdyilMa7VP1pqv55BR7H738SExLptNd6KZ9fUONDBbyJksoaAnn4ZjzE+?=
 =?us-ascii?Q?q4WITRx6qB1/+/9+9D8KItAZ92IwMZLf5CCoTUH94jJgjnxCMA/WDwFUYNf7?=
 =?us-ascii?Q?ltnY5mtoA6+koT1PIpSCpM+ySTvH8H6DLHsDEhlikljKWGaE0mYGOvIKFnIS?=
 =?us-ascii?Q?4Dq0gIn9UoO6r5ODCT8lh8MFmPnLEiDbtRWRp5mskVbnpkejZT2vtcwgDmT8?=
 =?us-ascii?Q?uJk2egYMRQo9qCzNCtDaHbcobPL4n8/kvDdLPuhUFg8CDOd8otB8WNMhSivx?=
 =?us-ascii?Q?PEp2twhVA+weuyiH1aLK97/3+kaNs/hLVhbgiJk9mtG0rLZCFT18vZrnp0hN?=
 =?us-ascii?Q?Xn3xFtmuSPwdnTYbnUmnlpbWov2MprZ0J8hmOJ8nHuyMxPF6gWjt8Lz7Ugjk?=
 =?us-ascii?Q?8eZySBfzsMnKamIOrInv56jjr02BHkqV3TWEfFfS2VEQkkizdAcCXZO+fUma?=
 =?us-ascii?Q?u7qN8FxXDZSV9zqknvVlIHPP+zR7ER2bdtmwT/YmzcXJA12UJSRfTWdrxjI7?=
 =?us-ascii?Q?2QMIJFQ3+uUEQVRmK+jBuodgYC63h2h6h5IkiD3G/tfwpIYK6cmaeIeWZFrj?=
 =?us-ascii?Q?enzCSBMqPyj0JGrbeh1J7sdOLIpQE+NAGn/7pmIoxACPlKQ3q6Xs92VxUylF?=
 =?us-ascii?Q?iyd2u8/oQPx4n0EIRIOCjAqp3wQb0tVeQbrVX3SL3mP9jirf9UQE+Do4FHhf?=
 =?us-ascii?Q?MsLzKbRKEPy/C13VFGPr9L27kq56l17/ZT/eiYh1F/aXg2pEqq+/poXmLQux?=
 =?us-ascii?Q?2xZl9cyuAhYrQ64NhSsKKwONkR+bfqBm0c93ejKr6WYLOA+GA6XZ7oipWVDz?=
 =?us-ascii?Q?HV9eiYufcqU7+81MsOGgMiysCwJWOhm6vg5CMsDS6inhbbg3K7ZpJkX4fqWj?=
 =?us-ascii?Q?cLLzoTZZ2uFanw51lADdsRB9u5msp9I6PCRSaHmiI3wcAIcGuj4zApesneim?=
 =?us-ascii?Q?qzLasg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88d7611d-4975-4e71-7a24-08d9faf3c4b6
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2022 19:51:53.5488
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: axn3TwJ8ObpL8evN0OLiTqVoYje2JFoDAw284QeP3PHF3VNWtfLLUVhkLOK0BT/yOSjtv8idtCkNkCdZaFZfuS+/a/ULgNY/S0avOTQ3PGg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5612
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10272 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=0 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202280097
X-Proofpoint-ORIG-GUID: Dd0tbhhJN2qIh7XP4Fv087tGcaAjspeR
X-Proofpoint-GUID: Dd0tbhhJN2qIh7XP4Fv087tGcaAjspeR
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

Updates since v27:
xfs: don't commit the first deferred transaction without intents
  Comment update

xfs: Add helper function xfs_init_attr_trans
  Added new line for function name

This series can be viewed on github here:
https://github.com/allisonhenderson/xfs_work/tree/delayed_attrs_v28

As well as the extended delayed attribute and parent pointer series:
https://github.com/allisonhenderson/xfs_work/tree/delayed_attrs_v28_extended

Thanks all!
Allison

Allison Henderson (15):
  xfs: Fix double unlock in defer capture code
  xfs: don't commit the first deferred transaction without intents
  xfs: Return from xfs_attr_set_iter if there are no more rmtblks to
    process
  xfs: Set up infrastructure for log attribute replay
  xfs: Implement attr logging and replay
  xfs: Skip flip flags for delayed attrs
  xfs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred
  xfs: Remove unused xfs_attr_*_args
  xfs: Add log attribute error tag
  xfs: Add larp debug option
  xfs: Merge xfs_delattr_context into xfs_attr_item
  xfs: Add helper function xfs_attr_leaf_addname
  xfs: Add helper function xfs_init_attr_trans
  xfs: add leaf split error tag
  xfs: add leaf to node error tag

 fs/xfs/Makefile                 |   1 +
 fs/xfs/libxfs/xfs_attr.c        | 524 +++++++++++----------
 fs/xfs/libxfs/xfs_attr.h        |  70 ++-
 fs/xfs/libxfs/xfs_attr_leaf.c   |   9 +-
 fs/xfs/libxfs/xfs_attr_remote.c |  37 +-
 fs/xfs/libxfs/xfs_attr_remote.h |   6 +-
 fs/xfs/libxfs/xfs_da_btree.c    |   4 +
 fs/xfs/libxfs/xfs_defer.c       |  35 +-
 fs/xfs/libxfs/xfs_defer.h       |   3 +
 fs/xfs/libxfs/xfs_errortag.h    |   8 +-
 fs/xfs/libxfs/xfs_format.h      |   9 +-
 fs/xfs/libxfs/xfs_log_format.h  |  44 +-
 fs/xfs/libxfs/xfs_log_recover.h |   2 +
 fs/xfs/scrub/common.c           |   2 +
 fs/xfs/xfs_attr_item.c          | 795 ++++++++++++++++++++++++++++++++
 fs/xfs/xfs_attr_item.h          |  46 ++
 fs/xfs/xfs_attr_list.c          |   1 +
 fs/xfs/xfs_error.c              |   9 +
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
 28 files changed, 1418 insertions(+), 279 deletions(-)
 create mode 100644 fs/xfs/xfs_attr_item.c
 create mode 100644 fs/xfs/xfs_attr_item.h

-- 
2.25.1

