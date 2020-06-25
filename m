Return-Path: <SRS0=UnAH=AG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B683C433E2
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 23:30:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C56920768
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 23:30:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="0KhZ05Ss"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728406AbgFYXar (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Jun 2020 19:30:47 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52224 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728399AbgFYXaq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jun 2020 19:30:46 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05PNRvek012286
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:30:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2020-01-29;
 bh=Et3BJeo1WZKx/FigPhzTioFma5ZuzSFT8tref5kAXjc=;
 b=0KhZ05SsW/qYv9o6/V/K1Te/TXjRydpxbMzm2nhYJWXx04F1CXdJJoVUfydKu0H0+5ya
 vu+gO6Z+So92awkzpXpLNNmvO0lgP2CVUChXd4MAfRGqnym1HBHMkMUJ0l+m65kIB8nA
 lWLhDr9ZQaAodrV7V0237RxkqLMsQQtgOQfCF4JqVGtMF1MMcI2SuQApJKw18tyRWFcG
 6xOKr9Q5H7z0dtM69ZvznlYDoZ9cRssNNp/jXaDZbdrjJqkk2b+ZxU/2Jy+ma16OfmAq
 XGYHI+GNKcoraz3hqPWYdJH9Mgb5bcEbMN/u2K0j4wpwvFe+MohyC40h6jkjBtVQLXXv xQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 31uustu9a3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:30:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05PNSIHG117255
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:30:44 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 31uuram5jt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:30:44 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05PNUhCp017506
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:30:43 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 25 Jun 2020 23:30:42 +0000
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v10 00/25] xfs: Delay Ready Attributes
Date:   Thu, 25 Jun 2020 16:29:53 -0700
Message-Id: <20200625233018.14585-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9663 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006250136
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9663 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 cotscore=-2147483648 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 suspectscore=0 priorityscore=1501 lowpriorityscore=0 clxscore=1015
 impostorscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006250136
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This set is a subset of a larger series for delayed attributes. Which is a
subset of an even larger series, parent pointers. Delayed attributes allow
attribute operations (set and remove) to be logged and committed in the same
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
"delay ready" subseries, as I think that is a more conservative use of peoples
review time.  I also think the set is a bit much to manage all at once, and we
need to get the infrastructure ironed out before we focus too much anything
that depends on it. But I do have the extended series for folks that want to
see the bigger picture of where this is going.

To help organize the set, I've arranged the patches to make sort of mini sets.
I thought it would help reviewers break down the reviewing some. For reviewing
purposes, the set could be broken up into 4 different phases:

Error code filtering (patches 1-2):
These two patches are all about finding and catching error codes that need to
be sent back up to user space before starting delayed operations.  Errors that
happen during a delayed operation are treated like internal errors that cause a
shutdown.  But we wouldnt want that for example: when the user tries to rename
a non existent attr.  So the idea is that we need to find all such conditions,
and take care of them before starting a delayed operation.
   xfs: Add xfs_has_attr and subroutines
   xfs: Check for -ENOATTR or -EEXIST

Move transactions upwards (patches 3-12): 
The goal of this subset is to try and move all the transaction specific code up
the call stack much as possible.  The idea being that once we get them to the
top, we can introduce the statemachine to handle the -EAGAIN logic where ever
the transactions used to be.
  xfs: Factor out new helper functions xfs_attr_rmtval_set
  xfs: Pull up trans handling in xfs_attr3_leaf_flipflags
  xfs: Split apart xfs_attr_leaf_addname
  xfs: Refactor xfs_attr_try_sf_addname
  xfs: Pull up trans roll from xfs_attr3_leaf_setflag
  xfs: Factor out xfs_attr_rmtval_invalidate
  xfs: Pull up trans roll in xfs_attr3_leaf_clearflag
  xfs: Refactor xfs_attr_rmtval_remove
  xfs: Pull up xfs_attr_rmtval_invalidate
  xfs: Add helper function xfs_attr_node_shrink

Modularizing and cleanups (patches 13-22):
Now that we have pulled the transactions up to where we need them, it's time to
start breaking down the top level functions into new subfunctions. The goal
being to work towards a top level function that deals mostly with the
statemachine, and helpers for those states
  xfs: Remove unneeded xfs_trans_roll_inode calls
  xfs: Remove xfs_trans_roll in xfs_attr_node_removename
  xfs: Add helpers xfs_attr_is_shortform and xfs_attr_set_shortform
  xfs: Add helper function xfs_attr_leaf_mark_incomplete
  xfs: Add remote block helper functions
  xfs: Add helper function xfs_attr_node_removename_setup
  xfs: Add helper function xfs_attr_node_removename_rmt
  xfs: Simplify xfs_attr_leaf_addname
  xfs: Simplify xfs_attr_node_addname
  xfs: Lift -ENOSPC handler from xfs_attr_leaf_addname

Introduce statemachine (patches 23-25):
Now that we have re-arranged the code such that we can remove the transaction
handling, we proceed to do so.  The behavior of the attr set/remove routines
are now also compatible as a .finish_item callback
  xfs: Add delay ready attr remove routines
  xfs: Add delay ready attr set routines
  xfs: Rename __xfs_attr_rmtval_remove


Changes since v9:
Theres a lot of activity that goes around with each set, so to help people
recall the discussion I've outlined the changes for each patch, which are new,
and which are unchanged:

xfs: Add xfs_has_attr and subroutines
xfs: Check for -ENOATTR or -EEXIST
xfs: Factor out new helper functions xfs_attr_rmtval_set
xfs: Pull up trans handling in xfs_attr3_leaf_flipflags
   No changes

xfs: Split apart xfs_attr_leaf_addname
   Updated commentary for xfs_defer_finish in xfs_attr_set_args

xfs: Refactor xfs_attr_try_sf_addname
xfs: Pull up trans roll from xfs_attr3_leaf_setflag
xfs: Factor out xfs_attr_rmtval_invalidate
xfs: Pull up trans roll in xfs_attr3_leaf_clearflag
   No changes

xfs: Refactor xfs_attr_rmtval_remove
   Updated commit message

xfs: Pull up xfs_attr_rmtval_invalidate
xfs: Add helper function xfs_attr_node_shrink
   No Changes

xfs: Remove unneeded xfs_trans_roll_inode calls
   Cleaned up some error handling
   Split off xfs_attr_node_removename case into separate patch 

xfs: Remove xfs_trans_roll in xfs_attr_node_removename
   New

xfs: Add helpers xfs_attr_is_shortform and xfs_attr_set_shortform
xfs: Add helper function xfs_attr_leaf_mark_incomplete
xfs: Add remote block helper functions
xfs: Add helper function xfs_attr_node_removename_setup
   No changes

xfs: Add helper function xfs_attr_node_removename_rmt
   Renamed xfs_attr_snode_removename_rmt to xfs_attr_node_remove_rmt

xfs: Simplify xfs_attr_leaf_addname
  Minor adjustments to if logic
  Updated commit message

xfs: Simplify xfs_attr_node_addname
  Minor adjustments to if logic
  Updated commit message

xfs: Lift -ENOSPC handler from xfs_attr_leaf_addname
  No Change

xfs: Add delay ready attr remove routines
  renamed xfs_attr_defer_finish to xfs_attr_roll_again
  hosted xfs_trans_roll_inode into roll again helper
  removed xfs_delattr_context_init helper
  moved state diagrams to xfs_attr.h

xfs: Add delay ready attr set routines
  renamed xfs_attr_defer_finish to xfs_attr_roll_again
  hosted xfs_trans_roll_inode into roll again helper
  removed xfs_delattr_context_init helper
  moved state diagrams to xfs_attr.h

xfs: Rename __xfs_attr_rmtval_remove
  simplified some while ldoop logic with if statements
  renamed  xfs_attr_rmtval_set_init to xfs_attr_rmtval_find_space
  some indentation fixes
  rephrased some comments
  simplified some return code logic


This series can be viewed on github here:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_v10

As well as the extended delayed attribute and parent pointer series:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_v10_extended

And the test cases:
https://github.com/allisonhenderson/xfs_work/tree/pptr_xfstests

In order to run the test cases, you will need have the corresponding xfsprogs
changes as well.  Which can be found here:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_xfsprogs_v10
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_xfsprogs_v10_extended

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

Allison Collins (25):
  xfs: Add xfs_has_attr and subroutines
  xfs: Check for -ENOATTR or -EEXIST
  xfs: Factor out new helper functions xfs_attr_rmtval_set
  xfs: Pull up trans handling in xfs_attr3_leaf_flipflags
  xfs: Split apart xfs_attr_leaf_addname
  xfs: Refactor xfs_attr_try_sf_addname
  xfs: Pull up trans roll from xfs_attr3_leaf_setflag
  xfs: Factor out xfs_attr_rmtval_invalidate
  xfs: Pull up trans roll in xfs_attr3_leaf_clearflag
  xfs: Refactor xfs_attr_rmtval_remove
  xfs: Pull up xfs_attr_rmtval_invalidate
  xfs: Add helper function xfs_attr_node_shrink
  xfs: Remove unneeded xfs_trans_roll_inode calls
  xfs: Remove xfs_trans_roll in xfs_attr_node_removename
  xfs: Add helpers xfs_attr_is_shortform and xfs_attr_set_shortform
  xfs: Add helper function xfs_attr_leaf_mark_incomplete
  xfs: Add remote block helper functions
  xfs: Add helper function xfs_attr_node_removename_setup
  xfs: Add helper function xfs_attr_node_removename_rmt
  xfs: Simplify xfs_attr_leaf_addname
  xfs: Simplify xfs_attr_node_addname
  xfs: Lift -ENOSPC handler from xfs_attr_leaf_addname
  xfs: Add delay ready attr remove routines
  xfs: Add delay ready attr set routines
  xfs: Rename __xfs_attr_rmtval_remove

 fs/xfs/libxfs/xfs_attr.c        | 1190 ++++++++++++++++++++++++++-------------
 fs/xfs/libxfs/xfs_attr.h        |  198 +++++++
 fs/xfs/libxfs/xfs_attr_leaf.c   |  116 ++--
 fs/xfs/libxfs/xfs_attr_leaf.h   |    3 +
 fs/xfs/libxfs/xfs_attr_remote.c |  258 ++++++---
 fs/xfs/libxfs/xfs_attr_remote.h |    8 +-
 fs/xfs/xfs_attr_inactive.c      |    2 +-
 fs/xfs/xfs_trace.h              |    1 -
 8 files changed, 1251 insertions(+), 525 deletions(-)

-- 
2.7.4

