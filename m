Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDF5AC433DB
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:34:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A994661A02
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:34:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbhCZAdf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 20:33:35 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:39298 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbhCZAdX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Mar 2021 20:33:23 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0PG4E066821
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:33:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=mux0n8PmKqPZnICpmL9xaXMjVpH9l0n3qxE/yYV+0HE=;
 b=Xqgg/dmYqFESUoV0TfW0k/udag6BuDC+hVjip+qX96Py70Iv069dbNGdUDsWZGVrdMZR
 tnpRRYk8Kfta7wjM4Wr9vqz3jjweTIHuelbJtTCimI0EPry8ZdwCFrId2rzztFgD/Dkc
 FT9Ull9gcyzH9Tk2CNvxmnWdK9gEAx3i6V6Fn3ZkdroGKvWBbhxBfM76jDT4CbFSRtwC
 khkdcLk1nH2TyAanIg0g4Z3YQWh1zn8hk/hvhz/xv7b7+ZwRhmaErr7Fc+71dfekxIOO
 f1norjl+N68R9u6C0btyXoq3s7NIgvt9M8B8+zHbXy965uoymqDdx26tvPxUkPDbOZNY ZQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 37h13hrh78-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:33:22 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0QXn8076081
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:33:21 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by userp3020.oracle.com with ESMTP id 37h14gg490-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:33:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kRPI5Y7bazK5MTnZevhKiV8byMiSjiAp+cSofeeORwufbcY2bJ8V47d+5TAVUSxJCSRf6SLpZMAOa9lct4jH+PcgA/LtFfp0k0gYoxToctqHVp4PkFLlcG/lYqx1/j3l/iFBdT9FiPh6FPa9i/q0yMInvaZFlm+g0uFqFmU6v7xG5udIhRbdl+MCGqCqLhfWHByaX+xOqdcSHaUSSJyuM1i0C/jMvUM7iIZs1ZGHjaiL9oBaIvF5FdBTE+ee7kjuvYsqUsmGd7rYUvikT4uxTZFoLyvVazDFSMyNZJgIKQtyvkgrXq/FKyyoaLpwgbXPRuuCGgoYFB+K/qwF3AFl1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mux0n8PmKqPZnICpmL9xaXMjVpH9l0n3qxE/yYV+0HE=;
 b=Nnqc4dint4/oy/G9nz6an4nFLf2C/VNx732ASzD/4JMQEtJqJpL9PBQ7vAPtoNx+PfPqmyhytqBw+MzXHLsFUk25iS5u/DH9hTebEWPkI6bQeeXivhTR9qOBwn8GfZE9nZBfHZzGIskYP6izlQD+XXtbNFLLHH5Yeg9G/OkQHqCsvLzzqOkfrhLYdsGc7YTio2fQos0VasOY9vziK8xk2gSW2NpMjTqnhww4bF/o3WHjhYlaUSOi+4UKfbqctM09leMm+rHHphOaOK/jtgU1QYf+WBUlxQa6TkCbZC6xNDDTixFK/H3IvI2XHuOpX9/ROh6f5sQgJW4XPT1Gcs15eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mux0n8PmKqPZnICpmL9xaXMjVpH9l0n3qxE/yYV+0HE=;
 b=zI7FaKsALTTPOYZSk4B99kdMl82u2A+C6P+TRqE0HzEuiVwXnEH+2KqMkfjuYRCrJVp2Om3apQGGoXfm4BqPFG1MfntDEzL0FxHrFB6NLxkcUDOSadHLFNkDIeTulb2cjXA7FxYL/DW0m5c7pT+swH0C8lxdbBub4pMnnjiNau0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2709.namprd10.prod.outlook.com (2603:10b6:a02:b7::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.29; Fri, 26 Mar
 2021 00:33:19 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3977.024; Fri, 26 Mar 2021
 00:33:19 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v16 00/11] xfs: Delay Ready Attributes
Date:   Thu, 25 Mar 2021 17:32:57 -0700
Message-Id: <20210326003308.32753-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR03CA0003.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::8) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.223.248) by SJ0PR03CA0003.namprd03.prod.outlook.com (2603:10b6:a03:33a::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Fri, 26 Mar 2021 00:33:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e90b6994-9935-4ea0-d983-08d8efeec0fe
X-MS-TrafficTypeDiagnostic: BYAPR10MB2709:
X-Microsoft-Antispam-PRVS: <BYAPR10MB27091F0B5F4FAEB4F89FB12495619@BYAPR10MB2709.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pKCI/oKmTP226aNX0TqLwypHg1DpF3dXP4UeFHOKTOuPEGXCMXwTrQ+XViTYViwvbp9vRywMzxEDXwiHduMQ6xhaoWPf2Ku02ZKVkgXI515EIdctt0iF2+TG595i10v8AZYoPp/DBmTUIcFOwRZ3vtiDGpfQSIyVM0UfHen7203F4Rfz6hdiDveTt0N4Jq+n5jaxYYctqY79EksvmiAVYN/iaCNiqe6/QdHN2AvaQ4FqtrRdoPt6vVakQuXmagZii8ukiRlDtiLuS8tmi03oLpwNalgHdp6GaPICUuor8wv1sUJImDczBROGmp+J9qLa7Dih5kolXz5D9bApV5+xvLf656vueaGLNq7N+BadTWCAIHgELZijq5N55VSaKMi0FbDTQpIa26pTqFe777tXO6w1NLKeAuyK7YIjtydDnjL5DCs/d8fTi5DNL7b3rePK3dgYDC6DllUSyQORlSpmPRFGxstmu/su/aAMSl5INWIG/0EULuonVPf/Mo+e1kWJmj4XFS4fI9eZQUFXEDMHF/d07NYY8c2yvaYo1QUGBZyezkzcmtJrsa2jF8/R9krwWGS5ZWQ3DPaQEReHpQjXl9M+pBZ4m4I0r1CqrPUmJ2Sq0tov3XlN9X1VqUlNX/G9YGn8IHQqtjb13QTQ5ylVJP8OuhVClKjBFzjU7H9p2emn9T5YMIo6PoTQYhuCBYjS1BEkprdV98PgG7DGJh6Z5V5rovEYwmLZ9xrYJLzdzIZGetA6yzfCWtah4mlkvzYmNleVnTCuEeasZAgVLAtbgw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(376002)(396003)(346002)(366004)(1076003)(8936002)(6506007)(2906002)(6512007)(6486002)(52116002)(6916009)(5660300002)(8676002)(83380400001)(36756003)(66476007)(66556008)(69590400012)(86362001)(38100700001)(66946007)(956004)(6666004)(316002)(2616005)(966005)(478600001)(44832011)(16526019)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?9wjKtm+m0GOCt8AvBxCy8/NeiuokYI4q5Mt6BNOhGpo7UCwrRjD1lTIQZbMi?=
 =?us-ascii?Q?VdKClei7bTWLznrn2WlZHMdzg8sQab8uDxyx/awdcnZx5sMSA1JxnwFNPEhy?=
 =?us-ascii?Q?fj+Vb45o7VwLYdF67K3+1QOPnI5NOh05Civ33NSZQIAVEppM+UKyvOQ6MGQx?=
 =?us-ascii?Q?iUWemCleFQtu6ozHgdoPjFNSFBrRHSrlchI8l6pdNYDijl7guOfIigrlG1hn?=
 =?us-ascii?Q?33mdueepBdxW+6D9X984rqV1T3FA1tp0GKctldp9AhUdC32K3QM4DNCmTXrv?=
 =?us-ascii?Q?YLJF/2dVG1HE0ruv0oks/U0+E8B/HAp4Q6owNmb25+uzVwsXApVc4Lh6dqm1?=
 =?us-ascii?Q?/lgYFcWiYcnQtbegp5SdLvm58S1ObR2U3OQ9AxhC1nVgx5leRiMN65gVdE+q?=
 =?us-ascii?Q?6qWccGerupAXErQQT3RgGDpj8eBMMVSeOSg8obrm+OGqMdHTKn4ZAZkJz2XA?=
 =?us-ascii?Q?Kxmwnu5pBxB7wgQIAe6X07ak/cdn7/87DxvOdbZs13nHpQlbVRFqP9YrnKDI?=
 =?us-ascii?Q?q5+zHrshKTotymZ4x+73phIattgURrjX2zwbY78nY4WXKTcl6Ndip7E2o/ne?=
 =?us-ascii?Q?670CRfg0CftR2qIxRtp+8wRUSlfEHJqF4J1fZhPKYaT5tutKn60pWiqFMF2E?=
 =?us-ascii?Q?mQNLLUocAyzM03MnmbM744YRqMpIYnFkaMK+IydwPRItyVU2ippzm9oV/f8R?=
 =?us-ascii?Q?GpK5fLbg2Xil2uLZk72ub0lnopl5Lxc0cF8ht6y7lr9BVA1R62RxfZZx+53F?=
 =?us-ascii?Q?P2l0Q7Xrm9w7t3SF7F+PPoVPIzKj+cU10sC6JkyI5vilAXoWAgLhcv2mljuu?=
 =?us-ascii?Q?zqc6XcgsWd40iGQ99uvFggRQ13ZtuKjakPruzkobQMGuBMiC34ZeDSLU+Jw4?=
 =?us-ascii?Q?cPPP16PEW2f1nsJJNGayWUXF/sx7shDcvsX/VqyZNjgkScVCW2iOYyb6b+Hl?=
 =?us-ascii?Q?6qMw5UzxAZdrlYocEs9tmr/8Sw1wTytWxqn1A7h+ieRBk8LR1PWvzAzO3TSP?=
 =?us-ascii?Q?iNLNS7bxHYk5GIkAq58DrS14c6MUTVxppfjV8YOZSxK36rWw9whVv1wvf48F?=
 =?us-ascii?Q?d6WV+BPHtTCNG+eZxxY4WmVOoDLMkjEWOhq8Ws+F/XrfUJ6qLfGBj+N8pRo5?=
 =?us-ascii?Q?ecV7cuMl/gS/Aa+YiRKrbmfFclG3CvEW65T7aa9zx9HZ6cILA3EKuo537pnq?=
 =?us-ascii?Q?gWqPnDLAebxLwdEtdHFngim/2mTaKNEljFJgvp6Z9rMldpU2ut87HJ7DaCUT?=
 =?us-ascii?Q?94Lxf9swZCXx/ZpIukJAKhea9gl4tykm+RPhS+ddxHed+fEAuTuoAedkdxDV?=
 =?us-ascii?Q?SYTpZJYg+jaddhWX7tbzjY2R?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e90b6994-9935-4ea0-d983-08d8efeec0fe
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 00:33:19.3580
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zcYpBA3Bkp29STnnM4/kX3pyrFxT6dE5i4cHN/ELJbGzjIagTkYWtL0l10CQbW9CM8IH8Qt7l9N2KS34pZPv6+wNZD4u8IqEX62/5oLnKPI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2709
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103260000
X-Proofpoint-GUID: LKxBnvYiDAp0B_P4HAWGxmvaJM5IKQ6m
X-Proofpoint-ORIG-GUID: LKxBnvYiDAp0B_P4HAWGxmvaJM5IKQ6m
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 spamscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0
 suspectscore=0 clxscore=1015 adultscore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103260000
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

In this version I have reduced the set back to the "Delay Ready Attrs" sub series to
avoid reviewer burn out, but the extended series is available to view in the inlcuded
git hub links, which extend all the way through parent pointers.  Feel free to review
as much as feels reasonable.  The set as a whole is a bit much to digest at once, so
working through it in progressive subsets seems like a reasonable way to manage its
dev efforts.

Lastly, in the last revision folks asked for some stress testing on the set.  On my
system, I found that in an fsstress test with all patches applied, we spend at most
%0.17 of the time in the attr routines, compared to at most %0.12 with out the set applied.
Both can fluctuate quite a bit depending on the other operations going on that seem to
occupy most of the activity.  For the most part though, I do not find these results to be
particularly concerning.  Though folks are certainly welcome to try it out on their own 
system to see how the results might differ.

Updates since v15: Mostly just review feed back from the previous revision.  I've
tracked changes below to help reviews recall the changes discussed

xfs: Reverse apply 72b97ea40d
  NEW

xfs: Add helper xfs_attr_node_remove_step
  DROPPED

xfs: Add xfs_attr_node_remove_cleanup
  No change

xfs: Hoist transaction handling in xfs_attr_node_remove_step
  DROPPED

xfs: Hoist xfs_attr_set_shortform
  No change

xfs: Add helper xfs_attr_set_fmt
  Fixed helper to return error when defer_finish fails

xfs: Separate xfs_attr_node_addname and xfs_attr_node_addname_work
  Renamed xfs_attr_node_addname_work to xfs_attr_node_addname_clear_incomplete

xfs: Add helper xfs_attr_node_addname_find_attr
  Renamed goto out, to goto error

xfs: Hoist xfs_attr_node_addname
  Removed unused retval variable
  Removed extra state free in xfs_attr_node_addname

xfs: Hoist xfs_attr_leaf_addname
  Fixed spelling typos

xfs: Hoist node transaction handling
  Added consistent braces to if/else statement

xfs: Add delay ready attr remove routines
  Typo fixes
  Merged xfs_attr_remove_iter with xfs_attr_node_removename_iter
  Added state XFS_DAS_RMTBLK
  Flow chart updated

xfs: Add delay ready attr set routines
  Rebase adjustments
  Typo fixes


Extended Series Changes
------------------------
xfs: Add state machine tracepoints
  Rebase adjustments
  xfs_attr_node_remove_rmt_return removed to match earlier refactoring changes
  trace_xfs_attr_node_removename_iter_return becomes
  trace_xfs_attr_remove_iter_return to match earlier refactoring changes

xfs: Rename __xfs_attr_rmtval_remove
  No change

xfs: Handle krealloc errors in xlog_recover_add_to_cont_trans
  Added kmem_alloc_large fall back
 
xfs: Set up infrastructure for deferred attribute operations
  Typo fixes
  Rename xfs_trans_attr to xfs_trans_attr_finish_update
  Added helper function xfs_attri_validate
  Split patch into infrastructure and implementation patches
  Added XFS_ERROR_REPORT in xlog_recover_attri_commit_pass2:

xfs: Implement for deferred attribute operations
  NEW

xfs: Skip flip flags for delayed attrs
  Did a performance analysis

xfs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred
  Typo fixes

xfs: Remove unused xfs_attr_*_args
  Rebase adjustments

xfs: Add delayed attributes error tag
  Added errortag include

xfs: Merge xfs_delattr_context into xfs_attr_item
  Typo fixes


This series can be viewed on github here:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_v16

As well as the extended delayed attribute and parent pointer series:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_v16_extended

And the test cases:
https://github.com/allisonhenderson/xfs_work/tree/pptr_xfstestsv2

In order to run the test cases, you will need have the corresponding xfsprogs
changes as well.  Which can be found here:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_xfsprogs_v16
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_xfsprogs_v16_extended

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
  xfs: Add xfs_attr_node_remove_cleanup
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

 fs/xfs/libxfs/xfs_attr.c        | 903 ++++++++++++++++++++++++----------------
 fs/xfs/libxfs/xfs_attr.h        | 364 ++++++++++++++++
 fs/xfs/libxfs/xfs_attr_leaf.c   |   2 +-
 fs/xfs/libxfs/xfs_attr_remote.c | 126 ++++--
 fs/xfs/libxfs/xfs_attr_remote.h |   7 +-
 fs/xfs/xfs_attr_inactive.c      |   2 +-
 fs/xfs/xfs_trace.h              |   1 -
 7 files changed, 998 insertions(+), 407 deletions(-)

-- 
2.7.4

