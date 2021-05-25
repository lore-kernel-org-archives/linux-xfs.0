Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B61D8C4708A
	for <linux-xfs@archiver.kernel.org>; Tue, 25 May 2021 19:55:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F9676101B
	for <linux-xfs@archiver.kernel.org>; Tue, 25 May 2021 19:55:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232988AbhEYT5I (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 May 2021 15:57:08 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37910 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233003AbhEYT5E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 May 2021 15:57:04 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PJnPtj034986
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 19:55:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=v4i0BZYQDBVoY/d5DvNAJhDnRbmdygAIDaRSkfGERok=;
 b=z9t1GCEzpLuFC2qwr/9mPLxQ1YiAMmiqOScK9Yec9oIzHVD+gkfAyzPErVgE1oVAI0Ai
 mfGtHhoYdvd7/tagN8OfTyit/3fqNGPZ+m4O8O7oSilIJ6q0wrWg18V0hEVNy/ruYTBO
 tgNJUPUCNbmIIBRa8g+14k+7TvL5WussidjC30BXzw9odvKHwSXbrfGkHyhSTGIHtfvh
 Nr5mJYEIh7bU0HFR67T0UT/k2HxqEKRQdsg226R9LgHUzvBlj7HmUSCWHoQ2edvqnRni
 z7tAx6j/UnjHCwy/9/UlZXCGGexu8ZVjrGrh3ymvNydUHDgnapcm7uwloftOUHpcRu0Y rw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 38q3q8xkjs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 19:55:33 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PJoDif188864
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 19:55:33 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by userp3020.oracle.com with ESMTP id 38qbqsjk0g-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 19:55:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FvS+6ms++evqw29l8hOQXqkTMNR2JOZOCa9oD2WP+7qEr7NyoTmS9HEtSVPeE+pjWuPWULEfys7DBWhUJn0TWWYp2OmWA6fe9mYl9EOnoqv/x2MIiE376UeSGo5lGUwSZEARG81qf7hIOjuWq4rxPpj8XFRiCsqVfGcgV9yu41RLMhGDsXFu4kfI9CdWk46vWPE8QPX+WHVftT83AMPwywA5h3Lr+RX2uABPyaGHYxGTk5/CAFG/qsI5E2buHn+g1QIkbPfbgs+pJWywlumQub874oDe3eyFdizexGrbjvUh5Vg5vQEfe0IGVCkj1W453KEkLxVH8DtF7s+ZPOmcdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v4i0BZYQDBVoY/d5DvNAJhDnRbmdygAIDaRSkfGERok=;
 b=gQXOn60W96KQBlclB+nz3LWkZm8WEGOf6cVpdaf2sMDnD4lmXCJAPjj/fdnf1FmV1Ai598Nd5sZO0M8PbsGql9M1cWZh0ZLGYu5l0ej79NjgJ484+ddNomjqtTu8HpS7E1c2ghuG+SKqn+ZMWq7UItL8yu7gGRdA+osksGOOk9gaaaVmvyQR+uy/E/eUmllC8MZeE+Xdzw5Kul719SggJCHG8k9YNfehNpNVGEvw46aLMcpTyQIu+SHmcll7sZthOoH0hFFjbifQkLZlrt4ixJeUNK1Hw+RBTmnQ/VWMFJDr4E5ItAWNt9A7pOMaENz57d1M7tXIAg4A9zl5T0Z6Dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v4i0BZYQDBVoY/d5DvNAJhDnRbmdygAIDaRSkfGERok=;
 b=D+6Jg/wdDDeqpcDGsTJs7c1REyV8R3F7AtaUKTNS0JSvz6K9JMTGZ0Illo5UlQMzS6SEXIu0KR9mtQbQAEKR49yf4OLcOjCmQhBTzYhRMc7vSdx49RgFalcJByBhEOvr8OTu5ZGZl5gT5oiAnG+fdeIPbytfCaXqLtRq6JnylGg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4544.namprd10.prod.outlook.com (2603:10b6:a03:2ad::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.25; Tue, 25 May
 2021 19:55:29 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4150.027; Tue, 25 May 2021
 19:55:29 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v19 09/14] xfs: Add delay ready attr remove routines
Date:   Tue, 25 May 2021 12:54:59 -0700
Message-Id: <20210525195504.7332-10-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210525195504.7332-1-allison.henderson@oracle.com>
References: <20210525195504.7332-1-allison.henderson@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: BYAPR01CA0016.prod.exchangelabs.com (2603:10b6:a02:80::29)
 To BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.210.54) by BYAPR01CA0016.prod.exchangelabs.com (2603:10b6:a02:80::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26 via Frontend Transport; Tue, 25 May 2021 19:55:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1b4cea42-b817-4436-e1b6-08d91fb70c3f
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4544:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4544DD9BAF4662018D4EC6E995259@SJ0PR10MB4544.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l6q3f+2J9n12BPyKZpdOIG3cZBzfV4M0DiOJL4MybaLoV6Cbk96yxg96G9UxbS2ILurwOqG2eqd6anB6t+aDQV0KimbWNedASF1BJtN1ZeIU/z010BjMSCeuS/4fXIzOldCAxCqmpyOpIpEYKuEcZU3BLENjWpK4841N+7xSmQKYjSTjWjlgNyX7GbQOE3UvZnBJ51ThGUzWw4TAb0NF7tdu4dgi5K8LLb97hvM/4ZWbdQbcOmIHXH7LCR10tSjlY8Cq5NN+R2UPk4+yd86oyOoH3CLmXpJbVixXgMSUnMMSu2ZMLjWTSw78oEBb3f2/dlqwq1GXkTaVMHo6ogjn2l5n4BpYpgVxWizb4/77+9vo+prA+2XEiy2yvO+E2l8/beRgNdv/BfSJ8qKY/XOZOIVvWUzI3f0+t1fyYsiuSPWU7l7/MfM8MMaDmu/5brwkJ3/9/zw/vqlrgb57rGjbhUmlK1eHnlXuxnkF8v8SKoR/xP5wo+PzSDYZW6jPDwZk2Rfu0u73P2qMvPjoIi0hdZphmikNCbJT9CUNL6r1S3y/zALB8Hr/G9TYYKJ/mw5oJNJS4pn1vMYEfI2BnS3KCxeIg277A6o3TGqkrzcRS1b+UaTY0OKcM8rC1QEbttCX558y/sZZ7yH0gZktWlYu2Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(366004)(346002)(396003)(136003)(376002)(2616005)(52116002)(5660300002)(956004)(478600001)(186003)(83380400001)(6486002)(66476007)(36756003)(2906002)(44832011)(38350700002)(66556008)(66946007)(26005)(6916009)(86362001)(38100700002)(1076003)(16526019)(6506007)(6666004)(8676002)(8936002)(6512007)(316002)(30864003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Lyt3SzhpQWUwZVI3UjRpQmYyTWFRaExUZWRUTm1FZ0M1Z0xZcXFTSkc4ZVRn?=
 =?utf-8?B?QUlxN05CTm92S1FsdnFOamdGeUdkcHRlM0RJSjhHWkxvSUJIUnRUaGRiNENt?=
 =?utf-8?B?S2M2anEvYlNXb3BGWlRQZ3lsMnFJblpFekQ5RUJkMG93aVQySFJ0bFRqUEt5?=
 =?utf-8?B?aU9kUU03VExkVmkzNElsTUExSjRpRTd2YjRlaTJZYk5xa3F2b0JhRjdlNlVX?=
 =?utf-8?B?OW4wS2FveTRkZlp5MlJyWWYvajRyM1VGYm9Xa01zMjlMOFdsdENYOFp4NCtZ?=
 =?utf-8?B?V2pNRTh3SjFENWtNTzhoYittMG9ES0Y5bkJteHJZc0xiNzVqK1VoNi9pa0Nt?=
 =?utf-8?B?M2pWUzE3VU1QeGd2M3Z2UVJlUk5UdHNzSllKNUlQL2czT1VFL0FrTE5Eemo4?=
 =?utf-8?B?NHpBTmptMmREMC95dVJ1K0c4QmVvUTlNZENMWVAvbG9leCtpekd1YUNBZWI0?=
 =?utf-8?B?cXRpQUdoVDZLeU1yQ0tHNmo0b0RHNjh5OXpucDRtaWZDNnkzaUl0TUxMbzJv?=
 =?utf-8?B?R0JwMlZZdDhjMGtZdW9FMjNLYS90MEgwSHRzR0phQVJtUWVpU21JOGFNamdh?=
 =?utf-8?B?YUVuRmhmdHdZRWN6S1BiQklLVmc2NklaY2FGM0wwMS84S3YyYUVhbGh6T01w?=
 =?utf-8?B?U01nMlFYV3lnajFBMTNKYjJVQ0Rxc0dXbmUzdUJQYWZzUEtuS0RMYmp3ZXU4?=
 =?utf-8?B?UHViZVRvb3NwWTRJb2tSdkVreWlPL1g4TzQ5NWVTRzJqdXd5MTd0THZveTNi?=
 =?utf-8?B?TC9Ub2ltem8zTWlqTkhJaXMxN3FyWUZYOU5lZGUvTWZwOVpRVzlCRmhRNVZl?=
 =?utf-8?B?cDBDZlgyKzF4OVFYZlhJVGRGazBUNTYvcG43MlNJakRrL0FpWjV0b2JEVnNp?=
 =?utf-8?B?T3gzR1EyMDcyaGVtTGViWnB6Qks0RFhNeEhHeTlQL2paNVJvMFdsR1RaK0do?=
 =?utf-8?B?Y0h2THFPRUptRmlBUjBKaGFhTWpseVBES1hsejRxT3JIOXBHYW5zczFjeWhy?=
 =?utf-8?B?SlFRR1RRUGtvTlAzSGJWc2NSY0dRcXBjVDZxZnFueGZDSzlVWFlobDZ5d21y?=
 =?utf-8?B?bUNsb1pvck9uaFJlNGUvQ2twTS8yVXBEODFJM25kOHhDNDl2N3hrTGFYeEoz?=
 =?utf-8?B?TS9BZk1mNzY1Tjd5WEcxdkk4SmM4ZmxObjhCNGhKdHhKNDZaQUNuRWlseThQ?=
 =?utf-8?B?c3JqWEpnVXdrdmtzaEtYWWtuZ2JvSlZQazZ3clFtNEg0YXYwWkZOM3llVnBl?=
 =?utf-8?B?Q0xnM3RaeG1QQkF5dFRyNXpEK3BLVVowVE5yay83ZnFrUHlibnBPdmlWVXlU?=
 =?utf-8?B?OW5GMWdBZk94U2R5dGs1QU1XREJwV0VFZGFiR01ZSkVpY0ZrWEJHYk83QzR5?=
 =?utf-8?B?TGp5RGtlWmdXVUYxZEk3eFBiS0t0WXFnYWZmem1zWEkwaUduMHJ4czJVNWdq?=
 =?utf-8?B?VVJ0VDlSazlubFNwRml4WXBFUSt5U2tMdmxxRC84WmgxM3EreE9xSldBamNC?=
 =?utf-8?B?TGQvRVRPREIybGVXWmxTY3F6cnZrWGF1UTd1UG9pc1NFZkllZzN4czFtSVkv?=
 =?utf-8?B?MHlsa25NNDF6blVVUmNYOEI3a1lZUTdZMWQvYlhUTUpMTzdnRkVyQkpmQk5z?=
 =?utf-8?B?ajZ6cGpUbjEybFJuOWJoeHY3TU5QenBZSnN0RlBtNzRpc1RORHBidjVjLzlC?=
 =?utf-8?B?TllWaExOSnM4ZG9xVFNsK0I5MkFJZGcyY1RJK3RDWHMxcGY2ZDd2dDVGZHdK?=
 =?utf-8?Q?M/y4r4LH8OYe8B14eaN7QwOhF3Dzx7M03fkn7AA?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b4cea42-b817-4436-e1b6-08d91fb70c3f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 19:55:29.5874
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cv5eB0TfBRpFw+px2oraF4DK0k/wZvUiyGyErZQcwbVMTWRB7T44sycuZOfQEb/6vmNifB6hnkXDcErUOrbJW6TQ57USR4FrFZKDsfwkNmQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4544
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250121
X-Proofpoint-GUID: 7dGtlkdh-MiRg_Aj2iDnd7C2R-S8k6wU
X-Proofpoint-ORIG-GUID: 7dGtlkdh-MiRg_Aj2iDnd7C2R-S8k6wU
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250121
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
values across multiple function calls.  See xfs_attr.h for a more
detailed diagram of the states.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c        | 213 ++++++++++++++++++++++++++++------------
 fs/xfs/libxfs/xfs_attr.h        | 131 ++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_attr_leaf.c   |   2 +-
 fs/xfs/libxfs/xfs_attr_remote.c |  49 +++++----
 fs/xfs/libxfs/xfs_attr_remote.h |   2 +-
 fs/xfs/xfs_attr_inactive.c      |   2 +-
 6 files changed, 314 insertions(+), 85 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 812dd1a..088f622 100644
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
+ * functions will need to handle this, and call the function until a
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
index 2b1f619..1267ea8 100644
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
+ * immediately resume from after being called by the calling function. States
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
+ *   │ attr has remote blks? ──n─┐
+ *   │          │                v
+ *   │          │         find and invalidate
+ *   │          y         the remote blocks.
+ *   │          │         mark attr incomplete
+ *   │          ├────────────────┘
+ *   └──────────┤
+ *              │
+ *              v
+ *   Have remote blks to remove? ───y─────┐
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
+ * calling function to roll the transaction, and then call the subroutine to
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
index 48d8e9c..ada8254 100644
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
 
@@ -685,31 +687,30 @@ xfs_attr_rmtval_remove(
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
- * transaction and re-call the function
+ * buffer that it is stored on. Returns -EAGAIN for the caller to refresh the
+ * transaction and re-call the function.  Callers should keep calling this
+ * routine until it returns something other than -EAGAIN.
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
@@ -719,12 +720,18 @@ __xfs_attr_rmtval_remove(
 	if (error)
 		return error;
 
-	error = xfs_defer_finish(&args->trans);
-	if (error)
-		return error;
-
-	if (!done)
+	/*
+	 * We don't need an explicit state here to pick up where we left off. We
+	 * can figure it out using the !done return code. The actual value of
+	 * attr->xattri_dela_state may be some value reminiscent of the calling
+	 * function, but it's value is irrelevant with in the context of this
+	 * function. Once we are done here, the next state is set as needed by
+	 * the parent
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

