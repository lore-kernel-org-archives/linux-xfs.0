Return-Path: <SRS0=+s6N=D6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E7E9C388F9
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Oct 2020 06:34:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4CD02192A
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Oct 2020 06:34:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kBeOTMd7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S375336AbgJWGeo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Oct 2020 02:34:44 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:38770 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S375331AbgJWGen (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Oct 2020 02:34:43 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09N6PfKU007905
        for <linux-xfs@vger.kernel.org>; Fri, 23 Oct 2020 06:34:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2020-01-29;
 bh=dlI9jyhlQ2lLWgnhNZu1Sss/2BbfwTkOUkmI17wjEsA=;
 b=kBeOTMd71hEZO5KIjMdT0h2BrKcBZ4nK7NHrPHpwxDNKTGf1vCLli0dLXj3D2aTQbBzI
 +BXjts3oiNifCRCVN59rbTeqGVAwLcwgS8UhgwlnY91n/7GkJ7KIK2PDJD3XaH9HYiiG
 oRJ/tVsolIDg+Pd1rpv4g8XNAXohYALQmQkpHlPmqzZtVMd11imqiKTK+Gn9sf2j1L6q
 EjJPc5tsvkhqZ0S7dZDv8nkLRP42ykLk8WpDQkpdRxNuJbrPHjWLj22Dc7oygZTxmDId
 0yGydsa7tR7hcGsV3cygREff2vzeEwBVNAPIDcLpRbR4raq+n0XgQnxUmfQCQHGiALnS UQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 347p4b9dxu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 23 Oct 2020 06:34:42 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09N6P443178172
        for <linux-xfs@vger.kernel.org>; Fri, 23 Oct 2020 06:34:41 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 348aj0na70-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 23 Oct 2020 06:34:41 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09N6Yefn009932
        for <linux-xfs@vger.kernel.org>; Fri, 23 Oct 2020 06:34:41 GMT
Received: from localhost.localdomain (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 22 Oct 2020 23:34:40 -0700
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v13 00/10] xfs: Delayed Attributes
Date:   Thu, 22 Oct 2020 23:34:25 -0700
Message-Id: <20201023063435.7510-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9782 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010230045
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9782 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 priorityscore=1501
 clxscore=1015 malwarescore=0 mlxscore=0 bulkscore=0 lowpriorityscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010230045
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This set is a subset of a larger series for parent pointers. Delayed attributes
allow attribute operations (set and remove) to be logged and committed in the same
way that other delayed operations do. This allows more complex operations (like
parent pointers) to be broken up into multiple smaller transactions. To do
this, the existing attr operations must be modified to operate as either a
delayed operation or a inline operation since older filesystems will not be
able to use the new log entries.  This means that they cannot roll, commit, or
finish transactions.  Instead, they return -EAGAIN to allow the calling
function to handle the transaction. In this series, we focus on only the clean
up and refactoring needed to accomplish this. We will introduce delayed attrs
and parent pointers in a later set.

At the moment, I would like people to focus their review efforts on just this
"delayed attribute" sub series, as I think that is a more conservative use of peoples
review time.  I also think the set is a bit much to manage all at once, and we
need to get the infrastructure ironed out before we focus too much anything
that depends on it. But I do have the extended series for folks that want to
see the bigger picture of where this is going.

To help organize the set, I've arranged the patches to make sort of mini sets.
I thought it would help reviewers break down the reviewing some. For reviewing
purposes, the set could be broken up into 2 phases:

Delay Ready Attributes: (patches 1-4)
These are the remaining patches belonging to the "Delay Ready" series that
we've been working with.  In these patches, transaction handling is removed
from the attr routines, and replaced with a state machine that allows a high
level function to roll the transaction and repeatedly recall the attr routines
until they are finished.  The behavior of the attr set/remove routines
are now also compatible as a .finish_item callback
  xfs: Add helper xfs_attr_node_remove_step
  xfs: Add delay ready attr remove routines
  xfs: Add delay ready attr set routines
  xfs: Rename __xfs_attr_rmtval_remove

Delayed Attributes: (patches 5 - 10)
These patches go on to fully implement delayed attributes.  New attr intent and
done items are introduced for use in the existing logging infrastructure.  A
feature bit is added to toggle the feature on and off, and an error tag is added
to test the log replay
  xfs: Set up infastructure for deferred attribute operations
  xfs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred
  xfs: Add feature bit XFS_SB_FEAT_INCOMPAT_LOG_DELATTR
  xfs: Enable delayed attributes
  xfs Remove unused xfs_attr_-_args.patch
  xfs: Add delayed attributes error tag

Updates since v12: Mostly integrating review feed back.  I've refactored
xfs_attr_node_removename as discussed in the 2nd patch, and consolidated the
xfs_attr_item members into a single args pointer.  I've gotten the dfops
mechanics to drive both delayed and non-delayed operations.  Lastly the
xfs_attr_*_args functions are removed at the end of the set since the dfops
machinery replaces it.  I did explore reorganizing xfs_da_args, though I think
thats big enough to be a separate project and I wanted to get a  v13 out before
too much time gets away.  Also updated the extended parent pointer series to
keep it functional for now.  

xfs: Add helper xfs_attr_node_remove_step
  New

xfs: Add delay ready attr remove routines
  Fixed typo in commit message
  Rebase adjustments
  Refactored xfs_attr_node_removename to xfs_attr_node_removename_iter
  Added state XFS_DAC_UNINIT to avoid warnings
  Found I could remove blk from dac.  Removed to simplify

xfs: Add delay ready attr set routines
  Rebase adjustments

xfs: Set up infastructure for deferred attribute operations
   Collapsed xfs_attr_item members into a single args pointer
   Modified xfs_attr_create_intent routines to return null when delayed attrs not enabled
   Modified xfs_trans_attr and xfs_attr_finish_item to avoid handling intent and
      done items when delayed attrs not enabled Moved xfs_sb_version_hasdelattr stub
      from "xfs: Add feature bit XFS_SB_FEAT_INCOMPAT_LOG_DELATTR" patch to this
      patch.  Used in managing when intents are recorded
   Removed initialization logic from args xfs_attr_finish_item (no longer needed)
   Simplified xfs_attr_recover to eliminate looping logic


xfs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred
  collapsed parameters into a single args pointer

xfs: Add feature bit XFS_SB_FEAT_INCOMPAT_LOG_DELATTR
  Rebase adjustments: Fill in xfs_sb_version_hasdelattr stub from earlier patch

xfs: Enable delayed attributes
  Removed logic to test for feature bit which is now handled by delayed attr mechanics

xfs: Remove unused xfs_attr_*_args
   New


This series can be viewed on github here:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_v13

As well as the extended delayed attribute and parent pointer series:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_v13_extended

And the test cases:
https://github.com/allisonhenderson/xfs_work/tree/pptr_xfstests

In order to run the test cases, you will need have the corresponding xfsprogs
changes as well.  Which can be found here:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_xfsprogs_v13
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_xfsprogs_v13_extended

To run the xfs attributes tests run:
check -g attr

To run as delayed attributes run:
export MKFS_OPTIONS="-n delattr"
check -g attr

To run parent pointer tests:
check -g parent

I've also made the corresponding updates to the user space side as well, and ported anything
they need to seat correctly.

Questions, comment and feedback appreciated! 

Thanks all!
Allison 

Allison Collins (5):
  xfs: Add helper xfs_attr_node_remove_step
  xfs: Rename __xfs_attr_rmtval_remove
  xfs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred
  xfs: Enable delayed attributes
  xfs: Add delayed attributes error tag

Allison Henderson (5):
  xfs: Add delay ready attr remove routines
  xfs: Add delay ready attr set routines
  xfs: Set up infastructure for deferred attribute operations
  xfs: Add feature bit XFS_SB_FEAT_INCOMPAT_LOG_DELATTR
  xfs: Remove unused xfs_attr_*_args

 fs/xfs/Makefile                 |   1 +
 fs/xfs/libxfs/xfs_attr.c        | 550 +++++++++++++++++++----------
 fs/xfs/libxfs/xfs_attr.h        | 218 +++++++++++-
 fs/xfs/libxfs/xfs_attr_leaf.c   |   2 +-
 fs/xfs/libxfs/xfs_attr_remote.c | 110 +++---
 fs/xfs/libxfs/xfs_attr_remote.h |   7 +-
 fs/xfs/libxfs/xfs_defer.c       |   1 +
 fs/xfs/libxfs/xfs_defer.h       |   3 +
 fs/xfs/libxfs/xfs_errortag.h    |   4 +-
 fs/xfs/libxfs/xfs_format.h      |  11 +-
 fs/xfs/libxfs/xfs_fs.h          |   1 +
 fs/xfs/libxfs/xfs_log_format.h  |  44 ++-
 fs/xfs/libxfs/xfs_log_recover.h |   2 +
 fs/xfs/libxfs/xfs_sb.c          |   2 +
 fs/xfs/libxfs/xfs_types.h       |   1 +
 fs/xfs/scrub/common.c           |   2 +
 fs/xfs/xfs_acl.c                |   2 +
 fs/xfs/xfs_attr_inactive.c      |   2 +-
 fs/xfs/xfs_attr_item.c          | 758 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_attr_item.h          |  76 ++++
 fs/xfs/xfs_attr_list.c          |   1 +
 fs/xfs/xfs_error.c              |   3 +
 fs/xfs/xfs_ioctl.c              |   2 +
 fs/xfs/xfs_ioctl32.c            |   2 +
 fs/xfs/xfs_iops.c               |   2 +
 fs/xfs/xfs_log.c                |   4 +
 fs/xfs/xfs_log_recover.c        |   2 +
 fs/xfs/xfs_ondisk.h             |   2 +
 fs/xfs/xfs_super.c              |   3 +
 fs/xfs/xfs_trace.h              |   1 -
 fs/xfs/xfs_xattr.c              |   1 +
 31 files changed, 1591 insertions(+), 229 deletions(-)
 create mode 100644 fs/xfs/xfs_attr_item.c
 create mode 100644 fs/xfs/xfs_attr_item.h

-- 
2.7.4

