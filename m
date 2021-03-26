Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C4BAC433E6
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:32:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55C48619FC
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:32:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbhCZAcA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 20:32:00 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:38472 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbhCZAbs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Mar 2021 20:31:48 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0OhrF066387
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=Pwi8W5JQ/VXAEsCu8s+pt6HfHMOKFOFm+RgPQLKMLL4=;
 b=il7iQqeZfcyGLwjDiNQmP5MBFeDugbolxZFmc+hT3nAAAmBX398HeyMcWmBFcwjW/fS+
 rBJmOjlR0zKkLQRvgiJE2y90gEcPgghmnoeGHd8IW36165e2SGVf5SOmBFEoO9UAsBMh
 06bJid2YiUoLl1yGyzgCUcSfklENV4HVnmqLgVVGzPzwci3LBGc9cbc1wNmByL8JhSdG
 7SR9LSJ89mKCEuQTGbONpsnw9Gfw9FCddief6BQLsChgy2c90g1EQfZwCF6j//7EIF6P
 Jx4ZdwPUWH9eq15Eo5J2QNT0yId6zQ7mhM/sIK6dWJTYNLHdB7QyV9xMcZD/vtPULc+0 1g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 37h13hrh5d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:47 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0PK6N155451
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:47 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by userp3030.oracle.com with ESMTP id 37h13x0454-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=odY+5eWNTpZiM+kH7fKyqj8h3g60sKYwFAMP0vDYSHxn/ojt8R8CIjkZ7zZCEY6t75QEdy4mSQJorZIK5zQl7kfcKKIOt5Pw29KCf67bq/igQkzsFJDmz9rTCFIE5idw7zIidxSqGqmpI4UF+uqskJ+qBICYehwwF/+SQL6Wonp+ICRUGknSqkTannWwNZCihKMI9fWz4BiQVEaujheAGcTqOo0jNiO3LY2nSAi/WeZ+JJY/0RqXRSv5Uou/awm79gyiwVUp4Rk/5VkAY3UWE8EjWrrdEZCXGTb+OMsF172q2ChF1jAyPPGjiUnmH53doC3lqI3ayuHuR4OEaQ31MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pwi8W5JQ/VXAEsCu8s+pt6HfHMOKFOFm+RgPQLKMLL4=;
 b=dBx1N3O+OYkki1Sv2FOykINCe5diIvGLsZBkNaMzMHjkoEtMTF2KYR6bv3k4tobZHh85qw3026+okU+NA6G22229qezVduMwV9Cboepc4fOcejta55ykwQ+Og/87aGpBqoGRJnApukz/p6WwLw388lFtG9M46YdPyURr7AUKtArU6vaWb9SZq4Vcpx/zHDOKZrdghM/2DHYCMT5RQWHlNxj8Ietf4A4s70nOq6LICN7FHJQkd7XuE4olwAZeO2VZE2Xe2r4bFRyt1iQOqhV+DA7TiIYndP1zdojdj8+pCuJXRLk6coXAcogiDVLE3GjCgCAedSV/RVQVYadUBnoAYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pwi8W5JQ/VXAEsCu8s+pt6HfHMOKFOFm+RgPQLKMLL4=;
 b=KRbrCmmr3eWCpFDzaDnK9Xl78C/Yl7C7o0ZEORCw8NIe0ONUL/SsMMHrqf4wRRqx+X/MogXQIZOXTGAR1lsJvOw4ljQJa+XpRnw9hu/owPZf0O/y8AgtCw4e4H5gSyZW2oHmV46+TJGl2UEhEE8EfZg5s/8j0MXxguSCFY2DLFg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2758.namprd10.prod.outlook.com (2603:10b6:a02:ba::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26; Fri, 26 Mar
 2021 00:31:44 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3977.024; Fri, 26 Mar 2021
 00:31:44 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v16 06/28] xfsprogs: Check for extent overflow when removing dir entries
Date:   Thu, 25 Mar 2021 17:31:09 -0700
Message-Id: <20210326003131.32642-7-allison.henderson@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 691b0800-418c-4556-0f71-08d8efee8827
X-MS-TrafficTypeDiagnostic: BYAPR10MB2758:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2758AFD25396BB420D959C9C95619@BYAPR10MB2758.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vRlvbbxcxT0xHwbFm35lAOqxIXn+jtiRyjWQwtMmkafAJE4Qaz107/RGKuYXev5G+pcXaKMNVkXctprOpRdZ+zG/y2qvM147lwhOKd26U1OPLqlAm7TdgIpt/0OrKXN4lN7DJRHHzn2CAmCwhnMqHm63N4fLktyOp4A/DIiJwPgXMWAlSh0jbLZ/ztF8y2BTa8QXdImJWOv2Qz52pNlvUhvMXUfQyv2YuaNEIorgi+5A2nZZ4adZwTBUZdUNj5K/XKSiZHNJaMHmtKshQISuyFvrIxaM2Zqzmv9dmNxAzMq0WuFpQSX1e7Eqf/sjXw7fHsPGHlyaO7FbI9NAmowJmZAvPZRD2TU9hC7r0d40VIC9ANBTgBXZzH9BFKGR9Wh4Lhclq4btQ65j0oGvMMLzKHbmoBQaF/wlPGmZGm51k2Epim+VbMgGG+wEVhRuPP8dJo2XYYMapRyLtfSDKsqSD0AB9GEqo4+3LDVi4nta/zesqzHU5hS2feyaC9yZH+NJL816w0vrgVZu2GGx/uAZfEY0CGW7vCiIPLEbzZNtlTPHZl8wmNH3h0tKWzfBEc/W9Nrv7Jf2SnV7n53D5/oIgPxfMlDfx6gkBNI10MVLFfzLFmoN7s4cLDlO9AM6+zeV74KMh6BAdNmLT7chSA/Scay2rhnWa2OGweNfJ5RRiEqvWnc9WJ3sZkx8d2DCL0tF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(396003)(366004)(136003)(316002)(6666004)(5660300002)(6486002)(16526019)(478600001)(52116002)(8676002)(186003)(44832011)(1076003)(8936002)(956004)(2616005)(66556008)(38100700001)(83380400001)(6506007)(2906002)(66476007)(86362001)(6916009)(66946007)(26005)(69590400012)(6512007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?tI+6JQaUuA53RUJSKryeL164h98/Z7kj9wPiHmiNgrtir3kAj7LQV2rLYCDx?=
 =?us-ascii?Q?bpwVmm2aBOI+B+QumrAVVMRgsfpvQ5xl/Bj9iNPnCkHUIkKSwL2olzzgqwqM?=
 =?us-ascii?Q?zik5zIgOaf0hB2fhwbhaJ5ZxJreuiVFAS/l+aHUkpoefVMerSbdyIWAyiEMM?=
 =?us-ascii?Q?YmIdxqVT49BqzIw+16AD4ELxcZVThR3EVUKm7hWUVffhMotDKt5oiN9Z2o9a?=
 =?us-ascii?Q?70apdeQ39CVIguihbfDXgE6pP9vq7iIFsCR9ymzplukw3gA37Qe0Ve57JxgS?=
 =?us-ascii?Q?8O3pXbGjAHAXl7M4H8LdWie0dl77SwYA+FkWSAMi/P4QihzLv5OZ89evMnm/?=
 =?us-ascii?Q?3T1fx1OoVPjkgBWs2K6GNTDZUa3fkfomnWBxXtmOCrtTDP5x/kCjJhrezzYP?=
 =?us-ascii?Q?Uv2CpvVdeAbmtZ0o3cgkQxI1353Xaidy7HbnoVCKk8vwn9daNgKGOk7UvODi?=
 =?us-ascii?Q?sqd/JNm4EktYKAwdkHksX02y1dlEGgTzotREJ4r3jnXbu2RCasz3qp/YgRol?=
 =?us-ascii?Q?u2twgv0KmfWrLhLEyZVYLPCvu9sZNw+V/1X1OOm/k6iRqzXJxuiJaJ8Aui9w?=
 =?us-ascii?Q?jJdLhot169sQ6MGF0B6euCRsanhGVKG0sBJsbHu+EmwuXzIcAUsg2mM3KFmu?=
 =?us-ascii?Q?CCULWYaUy2NpXQqR4rxkmXCt9SugBVbYraP9Opdj2iROITQhC+JEOP0visrm?=
 =?us-ascii?Q?TCOgu9bYGZ0tDGzkWeD7t3EO0Ts4FxFLH+Tx88hTEs2+myIgAQrfq3IsT4zI?=
 =?us-ascii?Q?/2WBfXaD+Jt+1D0hYX0dV3BeYrtmD1yZXGjOCjKWj5tfWpT8PzZzloi6gOFS?=
 =?us-ascii?Q?YYROd0VvG8knfnIDUyn1yLvtTPbvJ1f86KSAEpsiC81yGH25hoFDo4IuRcnO?=
 =?us-ascii?Q?sS+7e40sUe8iC8vStThlKyxPe1qg1W8z9olW0qegHRRN4CGjsj8rTGzOiDeE?=
 =?us-ascii?Q?7ld8jwR2gjIc0RwNhFptx6W1LSoxxwh2cTicqEQxR518pDfde1N+sEYXyJ/+?=
 =?us-ascii?Q?aH1mMJ34vJhFiovUFxq+dmAtGD7t9zYvcTZIwXGFNCLFIBL+/tWvQZx2U1L+?=
 =?us-ascii?Q?q70BKHUeXBdpejJFhbMTGD8f7Zwft21Ws2Q+b8h6EYYWVHx2G9nq4JONejJm?=
 =?us-ascii?Q?cVMo0f8c80EEbOfxdF3P/kIo8/JwQrWVF4dRofNBh/vA7BWRmr655BARVdqw?=
 =?us-ascii?Q?EyhBBU6mDzW8YEoOXUdFwgAgbWQ4goZ93H0/FMU+SEXkzbpqpTRLj4f5MFl/?=
 =?us-ascii?Q?utW8eZBJsYKdNnc78B3KGYNgL/anB3QLay2jejcY0rLKnaZkhW3093wTUvKo?=
 =?us-ascii?Q?oaNKJCVg6Vd0LPd5aATks7t8?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 691b0800-418c-4556-0f71-08d8efee8827
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 00:31:43.9616
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kX77GHsIQAKFZFLpJqvrw9Wv2NnUwixPvHkIGe9Yd6Z1fnIccdx0N7NgiO/EM29HR5lZ5ypoDusUzI6JhmY6o1/P1+P1DMXfEwdo+7kMgqA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2758
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103260000
X-Proofpoint-GUID: fNzglJ3oByd-k8dvlAZWwzQJkH8iboZv
X-Proofpoint-ORIG-GUID: fNzglJ3oByd-k8dvlAZWwzQJkH8iboZv
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

Source kernel commit: 0dbc5cb1a91cc8c44b1c75429f5b9351837114fd

Directory entry removal must always succeed; Hence XFS does the
following during low disk space scenario:
1. Data/Free blocks linger until a future remove operation.
2. Dabtree blocks would be swapped with the last block in the leaf space
and then the new last block will be unmapped.

This facility is reused during low inode extent count scenario i.e. this
that the above mentioned behaviour is exercised causing no change to the
directory's extent count.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_bmap.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 336c6d6..e3c6b0b 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -5144,6 +5144,24 @@ xfs_bmap_del_extent_real(
 		/*
 		 * Deleting the middle of the extent.
 		 */
+
+		/*
+		 * For directories, -ENOSPC is returned since a directory entry
+		 * remove operation must not fail due to low extent count
+		 * availability. -ENOSPC will be handled by higher layers of XFS
+		 * by letting the corresponding empty Data/Free blocks to linger
+		 * until a future remove operation. Dabtree blocks would be
+		 * swapped with the last block in the leaf space and then the
+		 * new last block will be unmapped.
+		 */
+		error = xfs_iext_count_may_overflow(ip, whichfork, 1);
+		if (error) {
+			ASSERT(S_ISDIR(VFS_I(ip)->i_mode) &&
+				whichfork == XFS_DATA_FORK);
+			error = -ENOSPC;
+			goto done;
+		}
+
 		old = got;
 
 		got.br_blockcount = del->br_startoff - got.br_startoff;
-- 
2.7.4

