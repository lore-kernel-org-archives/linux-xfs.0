Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41E6CC43603
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 17:06:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09266613C9
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 17:06:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245073AbhELRGa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 May 2021 13:06:30 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48586 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239726AbhELQPk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 May 2021 12:15:40 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14CG8v0x053014
        for <linux-xfs@vger.kernel.org>; Wed, 12 May 2021 16:14:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=me3C4nEfwQK4R2UManbiZwUmw4sD5S3WVGJVlFN1cwY=;
 b=zT/aslhU7N2Jc0UdxWlH9jY4b1JD2jYsK4BMd6MqZ1kSu0bLEb0BVej+xeRP8O7gDu8Z
 Gj2r6/Wx774ZzwlbjnecZltps5Im9BUTgMtg2/jZBmp3ypYuAi0kIUQoKkYNxHPh7aIG
 oYvegSdlRgtAJ0wPq7+ago36kXlkCgur5ez1a9QUApz5eCDd6MSvaE21NZtnHcgKKG+S
 LrfN7UfVFACBnMMmt4msQaTHd6L4A9Hg7ZTrLhExF5ZJqHo9uHOhjRX71VS30iqenV9Y
 QWbyXng4RO4H/9LaTM2FEMYO7jAyvG33od9I3RWihyzfxfoGGWtVGMxNq+bP+DyRmlLM qQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 38dk9njh8f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 12 May 2021 16:14:30 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14CG9swq194902
        for <linux-xfs@vger.kernel.org>; Wed, 12 May 2021 16:14:30 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2045.outbound.protection.outlook.com [104.47.57.45])
        by aserp3030.oracle.com with ESMTP id 38e5q026eb-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 12 May 2021 16:14:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T7gczt4KAmePNou4YP4hT8uZrmvcCMBhOdK/jSHqwz/8V+Dvpv3yhdcFUH45zAIxIgJWNYzIfBoF5mt2sOglS6lT2k4GRtTu0s0cpky1uNUf5GlDvC35Z29gIFMUruLDQFt2Jzvj2j/Gs1lnosooTVrbGjFb/pnT1kKTA13sWjyLB0oNqPBpsufdTMkWY/9yUB4mBMfjJp555hUvebwRrq+vQ6uNZG4apzX/3TLpB1mYTYDGwYvSb32pn2tH9wtRG4d07QmqDffRYRkVJRw9wqwi80wBk+O9gVmzfrN6bAFgRgsrqNitC55Z5og6I3B2Ec1nMOjbT9Q0wd0Bcw6s8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=me3C4nEfwQK4R2UManbiZwUmw4sD5S3WVGJVlFN1cwY=;
 b=goxBgl8PE+SbaocF0RpNV327vx8k/7C3TR9ZvekC1jQAZVlg8J3DdAtxHbHrPV4jCoHIEAjd5KnF+m0E1p2PFsC4gSoad9GYto5x1tDxyCD3il9Vw2hWNh5PTOdjvikvVxb+SohUbLlZlXESpDyEL78R2vqQ3VDmpIaCjUlRKLeyGgISnRzXleuGqAfkvzDK2xUmaNYdo3jTiDZNhm3YC9XpxfMMyZp2nevXANZCE1bWUH9gSNRHnKUufp/uZJiY7TGFA2sglcqnu7pgVI01mdACkBQO8HJBgOgmz1oZRcF9s9LwaFthab81aULoFDGkl9Ns7Hge78vtzyECu/8BZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=me3C4nEfwQK4R2UManbiZwUmw4sD5S3WVGJVlFN1cwY=;
 b=Si5t5CKNpRIO9TSgEFxWBzlu/mqiibCHQ/P5Ie+cuRDLvpLAM5szAtVKSrR0DPtPbrVqEgSMw9+caihsQqhpZ5vuA2kmBc7EQuGi9hfqSGjqp87N/QMLPQ1ChuRjLKmH3R0tuKrrAxlvZROAIqTV7qWqIiSorPUcvDbR9JMCpzs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3112.namprd10.prod.outlook.com (2603:10b6:a03:157::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25; Wed, 12 May
 2021 16:14:26 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4129.027; Wed, 12 May 2021
 16:14:26 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH RESEND v18 10/11] xfs: Add delay ready attr remove routines
Date:   Wed, 12 May 2021 09:14:07 -0700
Message-Id: <20210512161408.5516-11-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210512161408.5516-1-allison.henderson@oracle.com>
References: <20210512161408.5516-1-allison.henderson@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: SJ0PR05CA0200.namprd05.prod.outlook.com
 (2603:10b6:a03:330::25) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.210.54) by SJ0PR05CA0200.namprd05.prod.outlook.com (2603:10b6:a03:330::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.11 via Frontend Transport; Wed, 12 May 2021 16:14:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 50b297bc-90d7-452f-a66a-08d915610349
X-MS-TrafficTypeDiagnostic: BYAPR10MB3112:
X-Microsoft-Antispam-PRVS: <BYAPR10MB31127B1DDD9409F8CD40458A95529@BYAPR10MB3112.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ckpgHuq6nuvhR9IwzTqdOsYVsY1dmwJkaUhbfz7mhGiqOiicoSBICFIiea+4N5PQqaSi/6Nh3P81LeV7bv3htXAxwzhA4313MAmggNGe1aoA5fdal1HqM/9ek78tyD+6OYa5UYrXExG+HBpCIP7/mxcVBVsy4fnApV+lbIxFJadYfvQhiUUZr6KoDIUVxlCWsuFue3MpXmqmFSmqaSE262oUGrexNrMgyuhTa6IG0bjpng3l2Bh+GyiZ+pkUShMNaGHh1pWAIxqQmDHN9SQKDOlGs8JSHlU9rps9DdZxMbgtDLOyYgKToNXNyN2ImAsbXwKOptmbCyuIdcALqPmHzg1mdg4+EEoUINCntU5fQ8TYYYeCP9KvrbRj3loAXMBM4pC2FYfLHVytHzdBPwpQ8gkYMqwNT55ApmxGuTRuFhg45A6ICLXMardE7uH7VnMJcuuvCICc8XkTTH0zVCbBQCdjCL/LIUqlx3fm9Wef3LqbW/rZhd5CY5RbKb9y3brBvcxyNqpDc1pyb9UqeESW8FQX8R7/edRL+TSfDv+1nB8aCUXD4/4FJ/+OfDJVAGWUYZojZF9sTRUGvzggsoKFymjl3Ms927qQP5Vax3bkZwo/GIx+4BZRwY3iF/+JM9ZVjsCzTBSuTfYRzap8kh+qNw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(346002)(376002)(39860400002)(366004)(478600001)(316002)(66946007)(38350700002)(1076003)(52116002)(2616005)(5660300002)(30864003)(36756003)(8676002)(8936002)(66556008)(6486002)(6506007)(83380400001)(44832011)(2906002)(6916009)(186003)(26005)(38100700002)(16526019)(66476007)(6512007)(6666004)(956004)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?QzJxUThmeGtjbE9UckJINTdROWVrQ25ySXRGTkRzK2dWWkNyQTcyQTk4OHBG?=
 =?utf-8?B?UmdWWFNLdnZQR01nWEd6RGFQTVNWck1DemhyU08rcFlIMGxCMDVaVlUrL1J1?=
 =?utf-8?B?cnFLYjVpdUZ2QTFIVmU2RGs2U2QyRHkrZ09uOHkvRlg5RmQ5enZiZE4vWTFw?=
 =?utf-8?B?MWZUK0VBNkF5VXE0d2Nsa1QySU9BTG85Zmt5WW9MbnJNazZlM1RqeGowT2gx?=
 =?utf-8?B?OTJLVXJCQnAxc1ppK3JWRkx0UThxOU9IUHVSYnJGd3Mxb01XYUlIVldZbjlR?=
 =?utf-8?B?dTJMaXpOR1d6U1VIckVuOVBNY05HeFRJOEN3aElCay9tWlpKOFh4R3hzMkdT?=
 =?utf-8?B?Rzg0czNVMzZNYmpJWTZZUjk5bHVZU1Z5ZmF4Skk1UFBoOGt4SU1YZjhSTm9j?=
 =?utf-8?B?QUhOZ0huU2RBWm1LR1pOL09QclFiM2NnUkVzbTRycXBGQ3doNFo2ZlFGeGdT?=
 =?utf-8?B?UTN6aUJWdm54UnRiOVEwaFpBck1wNFB4ZHlHR0hDU2o5WUdDd2Z5ZkwvM29v?=
 =?utf-8?B?R3VaT2JyZUUyRGxva0hkR1dTLy9RYlhUUEZFT3FQQkM1SHM3K3BjODJYMEFO?=
 =?utf-8?B?dnQ1UlhhOTNlaHZwSDV5bnpCckdDM1JXNmc0NlQwN1ExMkJ6NHdRT0tiNlRB?=
 =?utf-8?B?dHlyc3Z3SWhVeTQ3SHB1bzhlZ0RaaTJ5ZzlCVzRuSmhsL0Z3NXZpTktLckNL?=
 =?utf-8?B?T0FWeWNvSmhUT3pUUjdxTFE4eUROa0kzdHZCR1VVQ3FROUwxQzU5a2ltc0Jl?=
 =?utf-8?B?UHRiWDhPUThHK3VwcU5xME9SSm5YdXZoWXN6SDVQUWF4dlBBUXVCU0kzcXJw?=
 =?utf-8?B?SEMrUEdsVWRmZ1dGV21PQmYwOWd6aVM4S1pCdGpkajZmanc1YUJzZU9QS05a?=
 =?utf-8?B?NEpYbm1CTGU3MnFjcUpuKzBiZVIzM0JEcGViY1dTSmRGQTN3QU1HYlN6cVFC?=
 =?utf-8?B?cndFOEFWR0FKRWNDRFVvd1owRkkycGcwelBwNGgxcHZFQk1XQ3Mva3MyS0E5?=
 =?utf-8?B?UnVnbDBPKy9PQ1cvSEJIb3JTZElyNTh2ZzN1TXFIUFdRYUpNRWJQb2E3VDFP?=
 =?utf-8?B?NGtLUDU4c2FsMFdKMVB5Y2tWTUprVVIwOHhkLzJSd21yMy9OcXBjaEpITzVP?=
 =?utf-8?B?WWVoT1BJcTRCNlVFMnJSbW11UkwvKzVjVStOUDgwNWtQSG1wcWt0YWVQQ1Rw?=
 =?utf-8?B?WTZhUUJmNGxRYWpmbE1JRFBOcW9CN043WlUrL3FMREowUHIrc0l6SHhMM1VY?=
 =?utf-8?B?em5KVThGeGp6bktNQlRmenNoUVh6TUFuaDhpYmRHaG9EWDhjZURHaDJraHVO?=
 =?utf-8?B?Q1llWFdGYXhHSXFFaTlnaDAySEpmQTNUeDY4ejVLbzlyckw5eGttaXdrcVJl?=
 =?utf-8?B?RlpSeHI5K1hSVnJEYTE0cFZWaTl5dlJJS29SODFqNjdvYmRpWVJHN09yMTV2?=
 =?utf-8?B?ZzBBOW00L1lxNm5oRjRLQXg5TS9QSUxSOTFIN0lPSWVXVzNWVWtvVXVZOWFJ?=
 =?utf-8?B?VzlHNysybEZyandDTFVkcENmOTVqYmQvMWg3UUpMZSswclVJdEhXWXMxWHg1?=
 =?utf-8?B?Y2pkaXpCNUltNmJESjRNRWdrc3ZRMkg3VmoyYWk0L1UwdzhvMU5xck1NUWd0?=
 =?utf-8?B?UStuTG9ZQzNiU0o3QnNFU1hycHlZdU80TkVHOURNOGJueGpYZHRZd2J2d2lw?=
 =?utf-8?B?Y01DZm1JTll3b0JSS3F4dTZkNTErVW5ob3lLVDduWmJrOWY2eUs4dHEvT0Rm?=
 =?utf-8?Q?AsyuDqrhTgSbZT3xa3v+G4ow+W35ugq/Bvd8dFX?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50b297bc-90d7-452f-a66a-08d915610349
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2021 16:14:26.3085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h57jdevwhDZzuhdc/ndXrLZFe7EHzL7f8L8MyvHMGvLbTQ+U5MeVstU9WnZFkmLymiWlOxO2tMwoi3OJfrvETMe8R3xBGDlElRa7DKko93M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3112
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9982 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105120102
X-Proofpoint-ORIG-GUID: CP_JOSi1KVQbx3Z12IGHW_HS5OCd99xr
X-Proofpoint-GUID: CP_JOSi1KVQbx3Z12IGHW_HS5OCd99xr
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9982 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 adultscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 lowpriorityscore=0
 malwarescore=0 priorityscore=1501 clxscore=1015 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105120102
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch modifies the attr remove routines to be delay ready. This
means they no longer roll or commit transactions, but instead return
-EAGAIN to have the calling routine roll and refresh the transaction. In
this series, xfs_attr_remove_args is merged with
xfs_attr_node_removename become a new function, xfs_attr_remove_iter.
This new version uses a sort of state machine like switch to keep track
of where it was when EAGAIN was returned. A new version of
xfs_attr_remove_args consists of a simple loop to refresh the
transaction until the operation is completed. A new XFS_DAC_DEFER_FINISH
flag is used to finish the transaction where ever the existing code used
to.

Calls to xfs_attr_rmtval_remove are replaced with the delay ready
version __xfs_attr_rmtval_remove. We will rename
__xfs_attr_rmtval_remove back to xfs_attr_rmtval_remove when we are
done.

xfs_attr_rmtval_remove itself is still in use by the set routines (used
during a rename).  For reasons of preserving existing function, we
modify xfs_attr_rmtval_remove to call xfs_defer_finish when the flag is
set.  Similar to how xfs_attr_remove_args does here.  Once we transition
the set routines to be delay ready, xfs_attr_rmtval_remove is no longer
used and will be removed.

This patch also adds a new struct xfs_delattr_context, which we will use
to keep track of the current state of an attribute operation. The new
xfs_delattr_state enum is used to track various operations that are in
progress so that we know not to repeat them, and resume where we left
off before EAGAIN was returned to cycle out the transaction. Other
members take the place of local variables that need to retain their
values across multiple function recalls.  See xfs_attr.h for a more
detailed diagram of the states.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_attr.c        | 213 ++++++++++++++++++++++++++++------------
 fs/xfs/libxfs/xfs_attr.h        | 131 ++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_attr_leaf.c   |   2 +-
 fs/xfs/libxfs/xfs_attr_remote.c |  48 +++++----
 fs/xfs/libxfs/xfs_attr_remote.h |   2 +-
 fs/xfs/xfs_attr_inactive.c      |   2 +-
 6 files changed, 314 insertions(+), 84 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 21f862e..a91fff6 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -57,7 +57,6 @@ STATIC int xfs_attr_node_addname(struct xfs_da_args *args,
 				 struct xfs_da_state *state);
 STATIC int xfs_attr_node_addname_find_attr(struct xfs_da_args *args,
 				 struct xfs_da_state **state);
-STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
 STATIC int xfs_attr_node_addname_clear_incomplete(struct xfs_da_args *args);
 STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
 				 struct xfs_da_state **state);
@@ -241,6 +240,31 @@ xfs_attr_is_shortform(
 		ip->i_afp->if_nextents == 0);
 }
 
+/*
+ * Checks to see if a delayed attribute transaction should be rolled.  If so,
+ * transaction is finished or rolled as needed.
+ */
+int
+xfs_attr_trans_roll(
+	struct xfs_delattr_context	*dac)
+{
+	struct xfs_da_args		*args = dac->da_args;
+	int				error;
+
+	if (dac->flags & XFS_DAC_DEFER_FINISH) {
+		/*
+		 * The caller wants us to finish all the deferred ops so that we
+		 * avoid pinning the log tail with a large number of deferred
+		 * ops.
+		 */
+		dac->flags &= ~XFS_DAC_DEFER_FINISH;
+		error = xfs_defer_finish(&args->trans);
+	} else
+		error = xfs_trans_roll_inode(&args->trans, args->dp);
+
+	return error;
+}
+
 STATIC int
 xfs_attr_set_fmt(
 	struct xfs_da_args	*args)
@@ -544,16 +568,25 @@ xfs_has_attr(
  */
 int
 xfs_attr_remove_args(
-	struct xfs_da_args      *args)
+	struct xfs_da_args	*args)
 {
-	if (!xfs_inode_hasattr(args->dp))
-		return -ENOATTR;
+	int				error;
+	struct xfs_delattr_context	dac = {
+		.da_args	= args,
+	};
 
-	if (args->dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL)
-		return xfs_attr_shortform_remove(args);
-	if (xfs_attr_is_leaf(args->dp))
-		return xfs_attr_leaf_removename(args);
-	return xfs_attr_node_removename(args);
+	do {
+		error = xfs_attr_remove_iter(&dac);
+		if (error != -EAGAIN)
+			break;
+
+		error = xfs_attr_trans_roll(&dac);
+		if (error)
+			return error;
+
+	} while (true);
+
+	return error;
 }
 
 /*
@@ -1197,14 +1230,16 @@ xfs_attr_leaf_mark_incomplete(
  */
 STATIC
 int xfs_attr_node_removename_setup(
-	struct xfs_da_args	*args,
-	struct xfs_da_state	**state)
+	struct xfs_delattr_context	*dac)
 {
-	int			error;
+	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_state		**state = &dac->da_state;
+	int				error;
 
 	error = xfs_attr_node_hasname(args, state);
 	if (error != -EEXIST)
 		return error;
+	error = 0;
 
 	ASSERT((*state)->path.blk[(*state)->path.active - 1].bp != NULL);
 	ASSERT((*state)->path.blk[(*state)->path.active - 1].magic ==
@@ -1213,12 +1248,15 @@ int xfs_attr_node_removename_setup(
 	if (args->rmtblkno > 0) {
 		error = xfs_attr_leaf_mark_incomplete(args, *state);
 		if (error)
-			return error;
+			goto out;
 
-		return xfs_attr_rmtval_invalidate(args);
+		error = xfs_attr_rmtval_invalidate(args);
 	}
+out:
+	if (error)
+		xfs_da_state_free(*state);
 
-	return 0;
+	return error;
 }
 
 STATIC int
@@ -1241,70 +1279,123 @@ xfs_attr_node_remove_name(
 }
 
 /*
- * Remove a name from a B-tree attribute list.
+ * Remove the attribute specified in @args.
  *
  * This will involve walking down the Btree, and may involve joining
  * leaf nodes and even joining intermediate nodes up to and including
  * the root node (a special case of an intermediate node).
+ *
+ * This routine is meant to function as either an in-line or delayed operation,
+ * and may return -EAGAIN when the transaction needs to be rolled.  Calling
+ * functions will need to handle this, and recall the function until a
+ * successful error code is returned.
  */
-STATIC int
-xfs_attr_node_removename(
-	struct xfs_da_args	*args)
+int
+xfs_attr_remove_iter(
+	struct xfs_delattr_context	*dac)
 {
-	struct xfs_da_state	*state;
-	int			retval, error;
-	struct xfs_inode	*dp = args->dp;
+	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_state		*state = dac->da_state;
+	int				retval, error;
+	struct xfs_inode		*dp = args->dp;
 
 	trace_xfs_attr_node_removename(args);
 
-	error = xfs_attr_node_removename_setup(args, &state);
-	if (error)
-		goto out;
+	switch (dac->dela_state) {
+	case XFS_DAS_UNINIT:
+		if (!xfs_inode_hasattr(dp))
+			return -ENOATTR;
 
-	/*
-	 * If there is an out-of-line value, de-allocate the blocks.
-	 * This is done before we remove the attribute so that we don't
-	 * overflow the maximum size of a transaction and/or hit a deadlock.
-	 */
-	if (args->rmtblkno > 0) {
-		error = xfs_attr_rmtval_remove(args);
-		if (error)
-			goto out;
+		/*
+		 * Shortform or leaf formats don't require transaction rolls and
+		 * thus state transitions. Call the right helper and return.
+		 */
+		if (dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL)
+			return xfs_attr_shortform_remove(args);
+
+		if (xfs_attr_is_leaf(dp))
+			return xfs_attr_leaf_removename(args);
 
 		/*
-		 * Refill the state structure with buffers, the prior calls
-		 * released our buffers.
+		 * Node format may require transaction rolls. Set up the
+		 * state context and fall into the state machine.
 		 */
-		error = xfs_attr_refillstate(state);
-		if (error)
-			goto out;
-	}
-	retval = xfs_attr_node_remove_name(args, state);
+		if (!dac->da_state) {
+			error = xfs_attr_node_removename_setup(dac);
+			if (error)
+				return error;
+			state = dac->da_state;
+		}
+
+		/* fallthrough */
+	case XFS_DAS_RMTBLK:
+		dac->dela_state = XFS_DAS_RMTBLK;
 
-	/*
-	 * Check to see if the tree needs to be collapsed.
-	 */
-	if (retval && (state->path.active > 1)) {
-		error = xfs_da3_join(state);
-		if (error)
-			goto out;
-		error = xfs_defer_finish(&args->trans);
-		if (error)
-			goto out;
 		/*
-		 * Commit the Btree join operation and start a new trans.
+		 * If there is an out-of-line value, de-allocate the blocks.
+		 * This is done before we remove the attribute so that we don't
+		 * overflow the maximum size of a transaction and/or hit a
+		 * deadlock.
 		 */
-		error = xfs_trans_roll_inode(&args->trans, dp);
-		if (error)
-			goto out;
-	}
+		if (args->rmtblkno > 0) {
+			/*
+			 * May return -EAGAIN. Roll and repeat until all remote
+			 * blocks are removed.
+			 */
+			error = __xfs_attr_rmtval_remove(dac);
+			if (error == -EAGAIN)
+				return error;
+			else if (error)
+				goto out;
 
-	/*
-	 * If the result is small enough, push it all into the inode.
-	 */
-	if (xfs_attr_is_leaf(dp))
-		error = xfs_attr_node_shrink(args, state);
+			/*
+			 * Refill the state structure with buffers (the prior
+			 * calls released our buffers) and close out this
+			 * transaction before proceeding.
+			 */
+			ASSERT(args->rmtblkno == 0);
+			error = xfs_attr_refillstate(state);
+			if (error)
+				goto out;
+			dac->dela_state = XFS_DAS_RM_NAME;
+			dac->flags |= XFS_DAC_DEFER_FINISH;
+			return -EAGAIN;
+		}
+
+		/* fallthrough */
+	case XFS_DAS_RM_NAME:
+		retval = xfs_attr_node_remove_name(args, state);
 
+		/*
+		 * Check to see if the tree needs to be collapsed. If so, roll
+		 * the transacton and fall into the shrink state.
+		 */
+		if (retval && (state->path.active > 1)) {
+			error = xfs_da3_join(state);
+			if (error)
+				goto out;
+
+			dac->flags |= XFS_DAC_DEFER_FINISH;
+			dac->dela_state = XFS_DAS_RM_SHRINK;
+			return -EAGAIN;
+		}
+
+		/* fallthrough */
+	case XFS_DAS_RM_SHRINK:
+		/*
+		 * If the result is small enough, push it all into the inode.
+		 * This is our final state so it's safe to return a dirty
+		 * transaction.
+		 */
+		if (xfs_attr_is_leaf(dp))
+			error = xfs_attr_node_shrink(args, state);
+		ASSERT(error != -EAGAIN);
+		break;
+	default:
+		ASSERT(0);
+		error = -EINVAL;
+		goto out;
+	}
 out:
 	if (state)
 		xfs_da_state_free(state);
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 2b1f619..32736d9 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -74,6 +74,133 @@ struct xfs_attr_list_context {
 };
 
 
+/*
+ * ========================================================================
+ * Structure used to pass context around among the delayed routines.
+ * ========================================================================
+ */
+
+/*
+ * Below is a state machine diagram for attr remove operations. The  XFS_DAS_*
+ * states indicate places where the function would return -EAGAIN, and then
+ * immediately resume from after being recalled by the calling function. States
+ * marked as a "subroutine state" indicate that they belong to a subroutine, and
+ * so the calling function needs to pass them back to that subroutine to allow
+ * it to finish where it left off. But they otherwise do not have a role in the
+ * calling function other than just passing through.
+ *
+ * xfs_attr_remove_iter()
+ *              │
+ *              v
+ *        have attr to remove? ──n──> done
+ *              │
+ *              y
+ *              │
+ *              v
+ *        are we short form? ──y──> xfs_attr_shortform_remove ──> done
+ *              │
+ *              n
+ *              │
+ *              V
+ *        are we leaf form? ──y──> xfs_attr_leaf_removename ──> done
+ *              │
+ *              n
+ *              │
+ *              V
+ *   ┌── need to setup state?
+ *   │          │
+ *   n          y
+ *   │          │
+ *   │          v
+ *   │ find attr and get state
+ *   │    attr has blks? ───n────┐
+ *   │          │                v
+ *   │          │         find and invalidate
+ *   │          y         the blocks. mark
+ *   │          │         attr incomplete
+ *   │          ├────────────────┘
+ *   └──────────┤
+ *              │
+ *              v
+ *      Have blks to remove? ───y─────────┐
+ *              │        ^          remove the blks
+ *              │        │                │
+ *              │        │                v
+ *              │  XFS_DAS_RMTBLK <─n── done?
+ *              │  re-enter with          │
+ *              │  one less blk to        y
+ *              │      remove             │
+ *              │                         V
+ *              │                  refill the state
+ *              n                         │
+ *              │                         v
+ *              │                   XFS_DAS_RM_NAME
+ *              │                         │
+ *              ├─────────────────────────┘
+ *              │
+ *              v
+ *       remove leaf and
+ *       update hash with
+ *   xfs_attr_node_remove_cleanup
+ *              │
+ *              v
+ *           need to
+ *        shrink tree? ─n─┐
+ *              │         │
+ *              y         │
+ *              │         │
+ *              v         │
+ *          join leaf     │
+ *              │         │
+ *              v         │
+ *      XFS_DAS_RM_SHRINK │
+ *              │         │
+ *              v         │
+ *       do the shrink    │
+ *              │         │
+ *              v         │
+ *          free state <──┘
+ *              │
+ *              v
+ *            done
+ *
+ */
+
+/*
+ * Enum values for xfs_delattr_context.da_state
+ *
+ * These values are used by delayed attribute operations to keep track  of where
+ * they were before they returned -EAGAIN.  A return code of -EAGAIN signals the
+ * calling function to roll the transaction, and then recall the subroutine to
+ * finish the operation.  The enum is then used by the subroutine to jump back
+ * to where it was and resume executing where it left off.
+ */
+enum xfs_delattr_state {
+	XFS_DAS_UNINIT		= 0,  /* No state has been set yet */
+	XFS_DAS_RMTBLK,		      /* Removing remote blks */
+	XFS_DAS_RM_NAME,	      /* Remove attr name */
+	XFS_DAS_RM_SHRINK,	      /* We are shrinking the tree */
+};
+
+/*
+ * Defines for xfs_delattr_context.flags
+ */
+#define XFS_DAC_DEFER_FINISH		0x01 /* finish the transaction */
+
+/*
+ * Context used for keeping track of delayed attribute operations
+ */
+struct xfs_delattr_context {
+	struct xfs_da_args      *da_args;
+
+	/* Used in xfs_attr_node_removename to roll through removing blocks */
+	struct xfs_da_state     *da_state;
+
+	/* Used to keep track of current state of delayed operation */
+	unsigned int            flags;
+	enum xfs_delattr_state  dela_state;
+};
+
 /*========================================================================
  * Function prototypes for the kernel.
  *========================================================================*/
@@ -92,6 +219,10 @@ int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_args(struct xfs_da_args *args);
 int xfs_has_attr(struct xfs_da_args *args);
 int xfs_attr_remove_args(struct xfs_da_args *args);
+int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
+int xfs_attr_trans_roll(struct xfs_delattr_context *dac);
 bool xfs_attr_namecheck(const void *name, size_t length);
+void xfs_delattr_context_init(struct xfs_delattr_context *dac,
+			      struct xfs_da_args *args);
 
 #endif	/* __XFS_ATTR_H__ */
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 556184b..d97de20 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -19,8 +19,8 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_bmap.h"
 #include "xfs_attr_sf.h"
-#include "xfs_attr_remote.h"
 #include "xfs_attr.h"
+#include "xfs_attr_remote.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_error.h"
 #include "xfs_trace.h"
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 48d8e9c..2f3c4cc 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -674,10 +674,12 @@ xfs_attr_rmtval_invalidate(
  */
 int
 xfs_attr_rmtval_remove(
-	struct xfs_da_args      *args)
+	struct xfs_da_args		*args)
 {
-	int			error;
-	int			retval;
+	int				error;
+	struct xfs_delattr_context	dac  = {
+		.da_args	= args,
+	};
 
 	trace_xfs_attr_rmtval_remove(args);
 
@@ -685,31 +687,29 @@ xfs_attr_rmtval_remove(
 	 * Keep de-allocating extents until the remote-value region is gone.
 	 */
 	do {
-		retval = __xfs_attr_rmtval_remove(args);
-		if (retval && retval != -EAGAIN)
-			return retval;
+		error = __xfs_attr_rmtval_remove(&dac);
+		if (error && error != -EAGAIN)
+			break;
 
-		/*
-		 * Close out trans and start the next one in the chain.
-		 */
-		error = xfs_trans_roll_inode(&args->trans, args->dp);
+		error = xfs_attr_trans_roll(&dac);
 		if (error)
 			return error;
-	} while (retval == -EAGAIN);
+	} while (true);
 
-	return 0;
+	return error;
 }
 
 /*
  * Remove the value associated with an attribute by deleting the out-of-line
- * buffer that it is stored on. Returns EAGAIN for the caller to refresh the
+ * buffer that it is stored on. Returns -EAGAIN for the caller to refresh the
  * transaction and re-call the function
  */
 int
 __xfs_attr_rmtval_remove(
-	struct xfs_da_args	*args)
+	struct xfs_delattr_context	*dac)
 {
-	int			error, done;
+	struct xfs_da_args		*args = dac->da_args;
+	int				error, done;
 
 	/*
 	 * Unmap value blocks for this attr.
@@ -719,12 +719,20 @@ __xfs_attr_rmtval_remove(
 	if (error)
 		return error;
 
-	error = xfs_defer_finish(&args->trans);
-	if (error)
-		return error;
-
-	if (!done)
+	/*
+	 * We don't need an explicit state here to pick up where we left off. We
+	 * can figure it out using the !done return code. Calling function only
+	 * needs to keep recalling this routine until we indicate to stop by
+	 * returning anything other than -EAGAIN. The actual value of
+	 * attr->xattri_dela_state may be some value reminiscent of the calling
+	 * function, but it's value is irrelevant with in the context of this
+	 * function. Once we are done here, the next state is set as needed
+	 * by the parent
+	 */
+	if (!done) {
+		dac->flags |= XFS_DAC_DEFER_FINISH;
 		return -EAGAIN;
+	}
 
 	return error;
 }
diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
index 9eee615..002fd30 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.h
+++ b/fs/xfs/libxfs/xfs_attr_remote.h
@@ -14,5 +14,5 @@ int xfs_attr_rmtval_remove(struct xfs_da_args *args);
 int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
 		xfs_buf_flags_t incore_flags);
 int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
-int __xfs_attr_rmtval_remove(struct xfs_da_args *args);
+int __xfs_attr_rmtval_remove(struct xfs_delattr_context *dac);
 #endif /* __XFS_ATTR_REMOTE_H__ */
diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index bfad669..aaa7e66 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -15,10 +15,10 @@
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
 #include "xfs_inode.h"
+#include "xfs_attr.h"
 #include "xfs_attr_remote.h"
 #include "xfs_trans.h"
 #include "xfs_bmap.h"
-#include "xfs_attr.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_quota.h"
 #include "xfs_dir2.h"
-- 
2.7.4

