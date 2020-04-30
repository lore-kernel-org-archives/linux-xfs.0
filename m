Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC914C47247
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 22:50:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C3A220774
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 22:50:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZJilk8HI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbgD3Wue (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Apr 2020 18:50:34 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50736 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726355AbgD3Wud (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Apr 2020 18:50:33 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UMm9nf051092
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:50:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=xTWwXLlMvq7UMBBX+Ql0isAuAI7bFySgcM8wxIaZMyE=;
 b=ZJilk8HIkkXryOYmnN7ky0txJK8jIEhtB52Ul0fzCLGDDCBIvA+oCYLlBjm26ThAiDuY
 UWbllovjpWAMxYQgfP2px8Dx75tYWnz7U5DzDYKtBQqS84qT/ww+Kpm+OCvr2YeATAQ4
 9PgSTMWe/waI7G4tBL+PlvaKp3suAKzvoMgioShBzJypBSxHyVZmkKlaAuw2TTEYrHmu
 gApQ2lATFXzI8zS0zyuMzAfGmzBTQvUsfSR0P278yUXE1JFQkP5Y8RkaALrJe2T3z07f
 t5hgzlJ+F4t0CAZKrRBYt1QElHmkCwBvsocQCQkQ6oQzuoahYoYmHy5ruB45FklZjX9t wQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 30r7f5r2jc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:50:31 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UMhPuL181233
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:50:31 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 30r7fesapt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:50:31 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03UMoUVv013635
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:50:31 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Apr 2020 15:50:30 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v9 00/24] xfs: Delay Ready Attributes
Date:   Thu, 30 Apr 2020 15:49:52 -0700
Message-Id: <20200430225016.4287-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300167
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 adultscore=0 mlxlogscore=999
 clxscore=1015 phishscore=0 impostorscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300167
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

Move transactions upwards (patches 3-10): 
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
   xfs: Add helper function __xfs_attr_rmtval_remove

Modularizing and cleanups (patches 11-18):
Now that we have pulled the transactions up to where we need them, it's time to
start breaking down the top level functions into new subfunctions. The goal
being to work towards a top level function that deals mostly with the
statemachine, and helpers for those states
   xfs: Add helper function xfs_attr_node_shrink
   xfs: Remove unneeded xfs_trans_roll_inode calls
   xfs: Add helpers xfs_attr_is_shortform and xfs_attr_set_shortform
   xfs: Add helper function xfs_attr_leaf_mark_incomplete
   xfs: Add remote block helper functions
   xfs: Add helper function xfs_attr_node_removename_setup
   xfs: Add helper function xfs_attr_node_removename_rmt
   xfs: Simplify xfs_attr_leaf_addname
   xfs: Simplify xfs_attr_node_addname
   xfs: Lift -ENOSPC handler from xfs_attr_leaf_addname

Introduce statemachine (patches 18-20):
Now that we have re-arranged the code such that we can remove the transaction
handling, we proceed to do so.  The behavior of the attr set/remove routines
are now also compatible as a .finish_item callback
   xfs: Add delay ready attr remove routines
   xfs: Add delay ready attr set routines
   xfs: Rename __xfs_attr_rmtval_remove


Changes since v8:
Theres a lot of activity that goes around with each set, so to help people
recall the discussion I've outlined the changes for each patch, which are new,
and which are unchanged:

xfs: Add xfs_has_attr and subroutines
  Fixed ENOATTR check
  Inverted error check handler in xfs_attr_node_hasname
  Indentation fixes

xfs: Check for -ENOATTR or -EEXIST
  Removed whitespace

xfs: Factor out new helper functions xfs_attr_rmtval_set
xfs: Pull up trans handling in xfs_attr3_leaf_flipflags
xfs: Split apart xfs_attr_leaf_addname
xfs: Refactor xfs_attr_try_sf_addname
xfs: Pull up trans roll from xfs_attr3_leaf_setflag
xfs: Factor out xfs_attr_rmtval_invalidate
xfs: Pull up trans roll in xfs_attr3_leaf_clearflag
   No change 

xfs: Add helper function __xfs_attr_rmtval_remove
   __xfs_attr_rmtval_remove becomes a helper function of xfs_attr_rmtval_remove
   instead of a new function
   Retain xfs_defer_finish in the helper so that we can replace it with the
   DEFER_FINISH flag later

xfs: Add helper function xfs_attr_leaf_mark_incomplete
   NEW

xfs: Add helper function xfs_attr_node_shrink
   Removed trailing error = 0

xfs: Remove unneeded xfs_trans_roll_inode calls
   More unneeded xfs_defer_finish calls removed
   Commit message verbage fix

xfs: Add helpers xfs_attr_is_shortform and xfs_attr_set_shortform
   Indentation adjustment
   Fixed comment verbage

xfs: Add helper function xfs_attr_leaf_mark_incomplete
   Simplified error handler

xfs: Add remote block helper functions
   No change

xfs: Add helper function xfs_attr_node_removename_setup
   Move the invalidate addd from new patch 12 into the helper function in this patch

xfs: Add helper function xfs_attr_node_removename_rmt
   Widen comment
   Simplify error handler

xfs: Simplify xfs_attr_leaf_addname
   NEW

xfs: Simplify xfs_attr_node_addname
   NEW

xfs: Lift -ENOSPC handler from xfs_attr_leaf_addname
   NEW

xfs: Add delay ready attr remove routines
  Replaced XFS_DAS_RMTVAL_REMOVE state with XFS_DAC_NODE_RMVNAME_INIT flag
  Extra XFS_DAC_DEFER_FINISH set added to __xfs_attr_rmtval_remove
  Temporary XFS_DAC_DEFER_FINISH hander plumbed into xfs_attr_rmtval_remove until we delete it in the next patch
  Simplify xfs_attr_remove_iter with less states to handle
  New helper function xfs_attr_defer_finish
  Indentation fixes
  Comments added to xfs_delattr_context
  Commit message update
  Flow chart update
  Added flow chart to xfs_attr.h

xfs: Add delay ready attr set routines
  Add fork code moved further up the set into parent pointers
  Replace XFS_DAS_ADD_LEAF state with shortform check
  Replace XFS_DAS_LEAF_TO_NODE state with leaf form check
  Replace XFS_DAS_ALLOC_LEAF with XFS_DAC_LEAF_ADDNAME_INIT flag
  Comments added to xfs_delattr_context, some unused feilds removed
  Rebase adjustments
  Flow chart update

xfs: Rename __xfs_attr_rmtval_remove
   Rebase adjustments


This series can be viewed on github here:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_v9

As well as the extended delayed attribute and parent pointer series:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_v9_extended

And the test cases:
https://github.com/allisonhenderson/xfs_work/tree/pptr_xfstests

In order to run the test cases, you will need have the corresponding xfsprogs
changes as well.  Which can be found here:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_xfsprogs_v9
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_xfsprogs_v9_extended

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


Allison Collins (24):
  xfs: Add xfs_has_attr and subroutines
  xfs: Check for -ENOATTR or -EEXIST
  xfs: Factor out new helper functions xfs_attr_rmtval_set
  xfs: Pull up trans handling in xfs_attr3_leaf_flipflags
  xfs: Split apart xfs_attr_leaf_addname
  xfs: Refactor xfs_attr_try_sf_addname
  xfs: Pull up trans roll from xfs_attr3_leaf_setflag
  xfs: Factor out xfs_attr_rmtval_invalidate
  xfs: Pull up trans roll in xfs_attr3_leaf_clearflag
  xfs: Add helper function __xfs_attr_rmtval_remove
  xfs: Pull up xfs_attr_rmtval_invalidate
  xfs: Add helper function xfs_attr_node_shrink
  xfs: Remove unneeded xfs_trans_roll_inode calls
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

 fs/xfs/libxfs/xfs_attr.c        | 1229 ++++++++++++++++++++++++++-------------
 fs/xfs/libxfs/xfs_attr.h        |  199 +++++++
 fs/xfs/libxfs/xfs_attr_leaf.c   |  116 ++--
 fs/xfs/libxfs/xfs_attr_leaf.h   |    3 +
 fs/xfs/libxfs/xfs_attr_remote.c |  259 ++++++---
 fs/xfs/libxfs/xfs_attr_remote.h |    8 +-
 fs/xfs/xfs_attr_inactive.c      |    2 +-
 fs/xfs/xfs_trace.h              |    1 -
 8 files changed, 1281 insertions(+), 536 deletions(-)

-- 
2.7.4

