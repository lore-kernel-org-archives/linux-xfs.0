Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEC75C433E6
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:48:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FA2E64EB7
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:48:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232974AbhBRSrs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 13:47:48 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:45830 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234016AbhBRQyu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 11:54:50 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGngNr069605
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=EZcuHKxkzuu6GLjXd1Nut7StMvwZhEsJKge87YBkAUI=;
 b=T1iJtSUZq2S8L3tQsZwhf+TLTviQA8AnyGKy5WcJxOJpIeHTfkYcWT4Zj6zW10e9KB2p
 RvQEHyFpVCBaOdB/GMdUdWmgOiDwzpbIlmxUkJCaV8KiL+4+eiDfiBvQbHEHIqrB4/Hf
 NpA7Y3GhZFnQyHkAuoe8wiyLewlSKjByTJaz+fa9isauxt3pkZ9uSJYnkk06WaR3/9r4
 08oSja+gfhPrhXP4/7b/khh/lDKPeJVcTYi5uUN4GXso3DKD2BOLw7nYC/EbJwRp8SWO
 BVtV0pmrra3f0VLPX33iAG7j+hZ/8I2nQU44y3gS1Ta7bJHY/pzNjmpiBcNeOj+eNI/Q VA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 36pd9ae4pg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:05 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGngUj162355
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:04 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by userp3020.oracle.com with ESMTP id 36prhufdh3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eNXF33SD/RGh2Jrp4JTUS2A2ZpUBeRkWpPyH4ltLaY+Byxpfv6UU8MwgwLFrTP+NeNLs6/qaKoWfC5XWncvZN1aq1G/ceT+DIeMEmVelrICRExKce+IpECajI12Kvj3zFFB+76lj0tb13YnArhYCl3C6kpHNaKpsRVYxHbbIK9lJE8fk8BE0Qc8+hyRlEDjG8ev0P7Qq27Sw13JBqczRgQwyvbE9gbL1jN9Bt8qijcWKTKMruQjVh8lc3hPZqX60yNyI2w+8eiE5s6nNYfs4PJXFXdwndMLfvFUJ+KkG7FogI0Uu/CCfmMebj254oF8sMeCBjJj8r5SRyRVTLqLF+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EZcuHKxkzuu6GLjXd1Nut7StMvwZhEsJKge87YBkAUI=;
 b=i7l0nUKmuyw2+wiKFvpjftmQWYW9O3PAuHLuYtI5fVxSHLMzKOqoInQiPdCMkyXFfsqBzSTzLNkHDa1n0yRxVD7WKJyrQaunzXblrpNHKU0xNbuDPy1Jlnx1gjnzuvOv+Y5vfpkkia/UuGQgl7KW4CeYHZhbA1NIGRvam/UGtOW3cMJAHhusjq1fzq0rwBVpz3AOpmk2PgQQypXNHKtUTHb8ynkcn0ULpXGyhmqA836UOzxyqBYBwkKdJVUFs6F+mGCgqAZ5xJ81PdSwqX1gF/adEzzUn4zjUODqleBQzAXFWm7U9uRbE3iLuEoKN/zmz/N5dJ3Ago9Ph7xyhRMwTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EZcuHKxkzuu6GLjXd1Nut7StMvwZhEsJKge87YBkAUI=;
 b=h9I+Oy511QsRhwBQBAzt6IJgUeFqf2YC7C1kwtcr38MJOoF0mqYXIxdpKNvWdY0jqdw61v0JmaV/R1BgEmGbwBsdY0Kh2iuswokCITpR6I+FD64qi6Kbr/RkYxq8GON9tStMFGF1bGDDdhhQM9N0pcbe5zQ3WU/wQf72/Ct1Q0w=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4161.namprd10.prod.outlook.com (2603:10b6:a03:213::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.29; Thu, 18 Feb
 2021 16:54:02 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 16:54:02 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v15 00/22] xfs: Delayed Attributes
Date:   Thu, 18 Feb 2021 09:53:26 -0700
Message-Id: <20210218165348.4754-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR03CA0352.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::27) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.223.248) by SJ0PR03CA0352.namprd03.prod.outlook.com (2603:10b6:a03:39c::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 16:54:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bd254b0b-27a0-4f96-e01d-08d8d42dcb88
X-MS-TrafficTypeDiagnostic: BY5PR10MB4161:
X-Microsoft-Antispam-PRVS: <BY5PR10MB41611D57055C2F95C2D4CEE795859@BY5PR10MB4161.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xbdAbT090AnaUVoOAExfJW2noMo7soRNX5M3fU5N5p4dA/o+Txr6zNRYa5sPGUTAu1SIAgYJc9AXjxr2lwClPRKih/rjAe07KI64Rz3Zyz25XLojiagAeG1mq3xYOZjTtseyGR8LQKm0hu+9QJJerPdYPZR5iGEQwsarQLdazdGJbXWIdhpECOVaSibalFLNfDNNPeHMGNlFunrjhfQ9z/zE0QZmg3Hf0spoeQws1S138fmY9knXcVYnPEr7QNf5K78MEaOkQfN3W+gLSk0GNoHwKspJhHIpvaPLng6qP+HxIqqHtZcSKI8E7UHYL66w74Xivd2+JSL/bzh0YtGvfVO5fa5ldc55haNtCDkZgZH2RWMIA005ce6bRueNvuSeUWdsZC9B2J9BZ398DDA4SozzkiXB5jS3CJz1OjNLWG9iPFCNDlt1GgrfalnOJZpe3iWuCQo2zKRnECSPy3oKw8hgcVe1Me8fDH6iZ1YTbLjjIl8461XOMkKhS6ZsjUFUa4van9lFEQs/WVe48LJzK4WQc+pOo88HyiN1z/Ee5BLYoEI8VPy52qblbZeGUf35YCc14r3CeBkBpIuDmRB8TBSuBFdGuPczXC0+8GOLKdKlyR1whu4X+98GTdiVU8AXTSYHzDF4BI6AM3/ZvcFhmQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(396003)(366004)(136003)(346002)(16526019)(66556008)(6506007)(478600001)(5660300002)(956004)(69590400012)(26005)(6486002)(83380400001)(66476007)(186003)(66946007)(2616005)(52116002)(6512007)(1076003)(6666004)(316002)(8676002)(8936002)(6916009)(36756003)(966005)(2906002)(86362001)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?DDr7DdVqS/shcF9MSsMv+MHggU/PXlEFjVTUmSh9RfC/10xNV8iMjcPmdNmg?=
 =?us-ascii?Q?ah6u/KhetMfm3z/FLRR8jDU9bJQRB/SPqbbiSJ/yxOV79drvGRxLQLUL+F7O?=
 =?us-ascii?Q?vM+J5Ai5xpm5lzmZKaxVUZH5/DCWUJVn3uXMuEl1Kq8dNN5RrAHSwOHyebhX?=
 =?us-ascii?Q?8o96hvcOQqQl1bsNBCgBqT0HhebqXIauroclQV/Sy5IW27hXcW4zjkvE4P5z?=
 =?us-ascii?Q?9Ms1+v0g6bpvzWwSxQWoVm88fV2yOwXSFB5wYegvDjInQiXzuZ1+Rk2Vkbn5?=
 =?us-ascii?Q?vxMEcK88vr6HKEj1Z2bOfVegEKZ0gm0jEIFDVzTG3FkrPq1cx4F1+jn2bH6+?=
 =?us-ascii?Q?m9WoH84xZeT0vL+tYM0YgIjiQyxl80+yYPpY6nwIKFAZJ5bQQAEfyJ+CDe5N?=
 =?us-ascii?Q?GWOkXhji8nnLxl49bo+Tj502e0KDK5EAS1HQCGotFF6qubQzroMQ6CiW5C2m?=
 =?us-ascii?Q?UlPiQncIHfjOtof+2YQvTT/C5u9YRUHXuPND7M33eKsWrsErEN0ByMfSdVp5?=
 =?us-ascii?Q?xn1K6hNUO483lRt2YCEc475L7CBy0KkbH7vZ0NEhHuz9TLn6ddbQzjAbLbOn?=
 =?us-ascii?Q?frscZ2ANLAv0/rydVAWu21wOoGBVE2NxQTTOHEmuzT6V8KOi07JnEu4aQtu6?=
 =?us-ascii?Q?sNPTvRng3XldqvKNPlGkCOKtSk33CZGLoeAA6vrelXHv6nPf/2jy2h2JGS/Q?=
 =?us-ascii?Q?+K8q4Pfd7xjaIPpwRIzCiN/Uunh6TGmcOIlDm4Mpy6+fQ3H5xDp8oUh+Wii2?=
 =?us-ascii?Q?3/HV2tqEyo9dltDEX5Z1fdoAfko6npJZdDZzHm4SMiBiDOvJd9ahezIiCixT?=
 =?us-ascii?Q?vfbDr4dEaRz/o64DzdO5jzW6nFwz9eJIJT9zb/u+eTvgZC8/c01q59KvZwOr?=
 =?us-ascii?Q?RK2GEXBBY+J2DHFg4ea3ph1EJAaYuIjvVj7K2IlT32I/wPSqpIf+Vi76kb3a?=
 =?us-ascii?Q?SJjBl8503MtFu94Xk5P+trBGrl7IfRjVZJZNCA5f0Z+phop6Adxu0e1Yaxvv?=
 =?us-ascii?Q?e3pOQ2r89yTGdVz/PaU9fF82MzKtDkXwaaq1oVpD44gUK2HB+eeatUW6YZyO?=
 =?us-ascii?Q?+5drSwyhDNy9ZQ+CWjHNBV5qUdYamU1P/UD4VFcxLWXjRVs7pe3hkAV7yemA?=
 =?us-ascii?Q?0o9XtUT9vSCNyK9yA//AatZzHuQY2v8oPmmmzn+qjK0LWK/jKl2dOuO7DZSL?=
 =?us-ascii?Q?dk7opYlL87+zkQWIjTdrSeaathqN0ETp3hvhBo/0wSt7zj2i/dFWZw1+VGz3?=
 =?us-ascii?Q?DYoFe4nC8ypbDkwoPirUPOUcsp+jnedSnSxdOQAx+JDdfbNrTqprUpM7yJMr?=
 =?us-ascii?Q?ZqtQCNkVtpXoFDFaZaPDVROq?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd254b0b-27a0-4f96-e01d-08d8d42dcb88
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 16:54:02.7501
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vLjF7AaYalFqvk6SI1/bztpbYuOyAK1/GqoYs0PTcdfh+7IaVyV3TMyw7HosmUKTBRMZnG1ZkUV6YOLoHM8WmlExbU5hprh3Nyng+HEJrEM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4161
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102180142
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180142
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This set is a subset of a larger series for parent pointers. Delayed attributes
allow attribute operations (set and remove) to be logged and committed in the same
way that other delayed operations do. This allows more complex operations (like
parent pointers) to be broken up into multiple smaller transactions. To do
this, the existing attr operations must be modified to operate as a delayed
operation.  This means that they cannot roll, commit, or finish transactions.  
Instead, they return -EAGAIN to allow the calling function to handle the transaction.
In this series, we focus on only the delayed attribute portion. We will introduce
parent pointers in a later set.

At the moment, I would like people to focus their review efforts on just this
"delayed attribute" sub series, as I think that is a more conservative use of peoples
review time.  I also think the set is a bit much to manage all at once, and we
need to get the infrastructure ironed out before we focus too much anything
that depends on it. But I do have the extended series for folks that want to
see the bigger picture of where this is going.

To help organize the set, I've arranged the patches to make sort of mini sets.
I thought it would help reviewers break down the reviewing some. For reviewing
purposes, the set could be broken up into 2 phases:

Delay Ready Attributes: (patches 1-15)
Some of these are the remaining patches belonging to the "Delay Ready" series that
we've been working with.  In these patches, transaction handling is removed
from the attr routines, and replaced with a state machine that allows a high
level function to roll the transaction and repeatedly recall the attr routines
until they are finished.  Patches 4-12 correspond to a refactoring RFC effort that
Brian and I had worked on earlier.  The lower level versions of the RFC patch
deviates slightly to correct some minor logic bugs not seen in the RFC.  I further
continued the refactoring to hoist the last state up into the xfs_attr_set_iter
routine.  The final product does create a bit of a monster function, but the state
management code is much more linear than in previous versions.  It should be noted
that while some of these new patches look a little odd, their purpose is neither to
optimize aesthetics, or even the hoist.  The goal is to prepare an arrangement of the
code such that the code changes in patch 12 are minimal and limited to state machine
mechanics.  As in previous revisions, the final product of this sub series is that the
attr routines are now compatible as a .finish_item call back.
   xfs: Add helper xfs_attr_node_remove_step
   xfs: Add xfs_attr_node_remove_cleanup
   xfs: Hoist transaction handling in xfs_attr_node_remove_step
   xfs: Hoist xfs_attr_set_shortform
   xfs: Add helper xfs_attr_set_fmt
   xfs: Separate xfs_attr_node_addname and xfs_attr_node_addname_work
   xfs: Add helper xfs_attr_node_addname_find_attr
   xfs: Hoist xfs_attr_node_addname
   xfs: Hoist xfs_attr_leaf_addname
   xfs: Hoist node transaction handling
   xfs: Add delay ready attr remove routines
   xfs: Add delay ready attr set routines
   xfs: Add state machine tracepoints
   xfs: Rename __xfs_attr_rmtval_remove
   xfs: Handle krealloc errors in xlog_recover_add_to_cont_trans

Delayed Attributes: (patches 15 - 22)
These patches go on to fully implement delayed attributes.  New attr intent and
done items are introduced for use in the existing logging infrastructure.  A
mount option is added to toggle the feature on and off, and an error tag is added
to test the log replay
  xfs: Set up infastructure for deferred attribute operations
  xfs: Skip flip flags for delayed attrs
  xfs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred
  xfs: Remove unused xfs_attr_*_args
  xfs: Add delayed attributes error tag
  xfs: Add delattr mount option
  xfs: Merge xfs_delattr_context into xfs_attr_item

Updates since v14: Mostly re-layering the changes discussed in the rfc along
with other minor nits from the last revision

xfs: Add helper xfs_attr_node_remove_step
   Typo nits in commit message

xfs: Hoist transaction handling in xfs_attr_node_remove_step
   Fixed typo in commit message
   removed unused dp variable from xfs_attr_node_remove_step
   Changed "return error" to "goto out" in xfs_attr_node_removename

xfs: Add delay ready attr remove routines
   Added extra xfs_freestate in xfs_attr_node_removename_setup
   rebase adjustments

xfs: Hoist xfs_attr_set_shortform
   NEW

xfs: Add helper xfs_attr_set_fmt
   NEW

xfs: Separate xfs_attr_node_addname and xfs_attr_node_addname_work
   NEW

xfs: Add helper xfs_attr_node_addname_find_attr
   NEW

xfs: Hoist xfs_attr_node_addname
   NEW

xfs: Hoist xfs_attr_leaf_addname
   NEW

xfs: Hoist node transaction handling
   NEW

xfs: Add delay ready attr set routines
  Fixed typos in comments and commit message
  Rebased onto refactoring additions
  All state management appears in xfs_attr_set_iter
  State machine gotos replaced with switch
  Flow chart updated

xfs: Add state machine tracepoints
  Rebase adjustments
  Added inode to trace data
  Added separate traces types for each function

xfs: Rename __xfs_attr_rmtval_remove
  Rebase adjustments

xfs: Handle krealloc errors in xlog_recover_add_to_cont_trans
  Expanded commit message about alloc warnings

xfs: Skip flip flags for delayed attrs
  Rebase adjustments

xfs: Remove unused xfs_attr_*_args
  Rebase adjustments

xfs: Merge xfs_delattr_context into xfs_attr_item
  Rebase adjustments


xfsprogs: Introduce error injection to allocate only minlen size extents for files
  Ported as a rebase dependancy
  Amended io/inject.c with error tag name to avoid compiler errors

xfsprogs: Introduce error injection to reduce maximum inode fork extent count
  Ported as a rebase dependancy
  Amended io/inject.c with error tag name to avoid compiler errors


This series can be viewed on github here:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_v15

As well as the extended delayed attribute and parent pointer series:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_v15_extended

And the test cases:
https://github.com/allisonhenderson/xfs_work/tree/pptr_xfstestsv2

In order to run the test cases, you will need have the corresponding xfsprogs
changes as well.  Which can be found here:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_xfsprogs_v15
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_xfsprogs_v15_extended

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

Allison Collins (1):
  xfs: Add helper xfs_attr_node_remove_step
  xfs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred

Allison Henderson (20):
  xfs: Add xfs_attr_node_remove_cleanup
  xfs: Hoist transaction handling in xfs_attr_node_remove_step
  xfs: Hoist xfs_attr_set_shortform
  xfs: Add helper xfs_attr_set_fmt
  xfs: Separate xfs_attr_node_addname and xfs_attr_node_addname_work
  xfs: Add helper xfs_attr_node_addname_find_attr
  xfs: Hoist xfs_attr_node_addname
  xfs: Hoist xfs_attr_leaf_addname
  xfs: Hoist node transaction handling
  xfs: Add delay ready attr remove routines
  xfs: Add delay ready attr set routines
  xfs: Add state machine tracepoints
  xfs: Rename __xfs_attr_rmtval_remove
  xfs: Handle krealloc errors in xlog_recover_add_to_cont_trans
  xfs: Set up infastructure for deferred attribute operations
  xfs: Skip flip flags for delayed attrs
  xfs: Remove unused xfs_attr_*_args
  xfs: Add delayed attributes error tag
  xfs: Add delattr mount option
  xfs: Merge xfs_delattr_context into xfs_attr_item

 fs/xfs/Makefile                 |   1 +
 fs/xfs/libxfs/xfs_attr.c        | 955 +++++++++++++++++++++++++---------------
 fs/xfs/libxfs/xfs_attr.h        | 366 ++++++++++++++-
 fs/xfs/libxfs/xfs_attr_leaf.c   |   5 +-
 fs/xfs/libxfs/xfs_attr_remote.c | 127 ++++--
 fs/xfs/libxfs/xfs_attr_remote.h |   7 +-
 fs/xfs/libxfs/xfs_defer.c       |   1 +
 fs/xfs/libxfs/xfs_defer.h       |   3 +
 fs/xfs/libxfs/xfs_errortag.h    |   4 +-
 fs/xfs/libxfs/xfs_log_format.h  |  44 +-
 fs/xfs/libxfs/xfs_log_recover.h |   2 +
 fs/xfs/scrub/common.c           |   2 +
 fs/xfs/xfs_acl.c                |   2 +
 fs/xfs/xfs_attr_inactive.c      |   2 +-
 fs/xfs/xfs_attr_item.c          | 830 ++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_attr_item.h          |  52 +++
 fs/xfs/xfs_attr_list.c          |   1 +
 fs/xfs/xfs_error.c              |   3 +
 fs/xfs/xfs_ioctl.c              |   2 +
 fs/xfs/xfs_ioctl32.c            |   2 +
 fs/xfs/xfs_iops.c               |   2 +
 fs/xfs/xfs_log.c                |   4 +
 fs/xfs/xfs_log_recover.c        |   7 +-
 fs/xfs/xfs_mount.h              |   1 +
 fs/xfs/xfs_ondisk.h             |   2 +
 fs/xfs/xfs_super.c              |   6 +-
 fs/xfs/xfs_trace.h              |  26 +-
 fs/xfs/xfs_xattr.c              |   3 +
 28 files changed, 2056 insertions(+), 406 deletions(-)
 create mode 100644 fs/xfs/xfs_attr_item.c
 create mode 100644 fs/xfs/xfs_attr_item.h

-- 
2.7.4

