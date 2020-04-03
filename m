Return-Path: <SRS0=euis=5T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 190CEC2BA1A
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Apr 2020 22:14:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8E412082F
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Apr 2020 22:14:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IZmr0Ifn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729151AbgDCWOl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Apr 2020 18:14:41 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58506 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728636AbgDCWOl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Apr 2020 18:14:41 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033M9fZR093022
        for <linux-xfs@vger.kernel.org>; Fri, 3 Apr 2020 22:14:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=4HJwdFCxlDCsS6Rz2rItlL4vLcZVPwS/vubEYLrKpe4=;
 b=IZmr0IfnXxUTJOod0o2XjcpWQl1OA7LPYG9AChGYKaZS/eyviqaW1iR48xetE4GmHxZX
 qnqYa0z1y6ztEg1z+D/C9q9t8cUTR+6SuAXKBJZ18KVnwtPnV3fL1IibfT7YJXGjTu/g
 csg6rfSrRJvvvzaq7g4QesLvPWrMotzGbs/7q6vQwgfpn2mo9YzaKi5xC7uPr5hwz1ie
 uetUBDl5BGwwqQJ2ZfVV/ATxgVhjJ1xvaidRmgC4b6cuKdaVRhkv0vixDBEkqoXOdtwW
 FKTM2NiXYLxaWYLh3y75P8qzEZPYtWVez3L+BJEG8lOAvcW6B9K7rebF9lDAuDl06VVW aQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 303yunp0w8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 03 Apr 2020 22:14:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033M7Bpe171152
        for <linux-xfs@vger.kernel.org>; Fri, 3 Apr 2020 22:12:38 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 302g2p2eh2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 03 Apr 2020 22:12:38 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 033MCbV7016967
        for <linux-xfs@vger.kernel.org>; Fri, 3 Apr 2020 22:12:37 GMT
Received: from localhost.localdomain (/67.1.1.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Apr 2020 15:12:37 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v8 00/20] xfs: Delay Ready Attributes
Date:   Fri,  3 Apr 2020 15:12:09 -0700
Message-Id: <20200403221229.4995-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9580 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 mlxscore=0
 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9580 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0
 suspectscore=0 mlxscore=0 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030171
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
   xfs: Removed unneeded xfs_trans_roll_inode calls
   xfs: Add helpers xfs_attr_is_shortform and xfs_attr_set_shortform
   xfs: Add helper function xfs_attr_leaf_mark_incomplete
   xfs: Add remote block helper functions
   xfs: Add helper function xfs_attr_node_removename_setup
   xfs: Add helper function xfs_attr_node_removename_rmt

Introduce statemachine (patches 18-20):
Now that we have re-arranged the code such that we can remove the transaction
handling, we proceed to do so.  The behavior of the attr set/remove routines
are now also compatible as a .finish_item callback
   xfs: Add delay ready attr remove routines
   xfs: Add delay ready attr set routines
   xfs: Rename __xfs_attr_rmtval_remove


Changes since v7:
Theres a lot of activity that goes around with each set, so to help people
recall the discussion I've outlined the changes for each patch, which are new,
and which are unchanged:

xfs: Add xfs_has_attr and subroutines
  Added extra free in the case of statep == NULL
  Minor error handling syntax nits
  Rebase adjustments
 
xfs: Check for -ENOATTR or -EEXIST
  Extra error handling in the case of (error != -ENOATTR && error != -EEXIST)
  Rebase adjustments

xfs: Factor out new helper functions xfs_attr_rmtval_set
  No change

xfs: Pull up trans handling in xfs_attr3_leaf_flipflags
  Commit message amended based on review commentary

xfs: Split apart xfs_attr_leaf_addname
  Commit message amended based on review commentary
  brealse on error moved into xfs_attr_leaf_addname helper
  line wrap adjust
  Investigated error handling logic suggestion:
     let go for reasons of later statemachine impacts

xfs: Refactor xfs_attr_try_sf_addname
   Commit message typo

xfs: Pull up out trans roll from xfs_attr3_leaf_setflag
   Commit message amended based on review nits

xfs: Factor out xfs_attr_rmtval_invalidate
   no change

xfs: Pull up trans roll in xfs_attr3_leaf_clearflag
  Commit message amended based on review commentary

xfs: Add helper function __xfs_attr_rmtval_remove
   renamed xfs_attr_rmtval_unmap to __xfs_attr_rmtval_remove
   remove stale comment

xfs: Add helper function xfs_attr_node_shrink
   rebase to lower position in the set

xfs: Removed unneeded xfs_trans_roll_inode calls
   new

xfs: Add helpers xfs_attr_is_shortform and xfs_attr_set_shortform
   new

xfs: Add helper function xfs_attr_leaf_mark_incomplete
   rebased to lower position in the set

xfs: Add remote block helper functions
  rename xfs_attr_store_rmt_blk to xfs_attr_save_rmt_blk
  rebase adjustments

xfs: Add helper function xfs_attr_node_removename_setup
   new

xfs: Add helper function xfs_attr_node_removename_rmt
   rename xfs_attr_rmtval_unmap to _xfs_attr_rmtval_remove

xfs: Add delay ready attr remove routines
   Simplify xfs_attr_remove_args loop now that trailing transaction rolls are gone
      (removed in patch 12)
   Subroutines adjusted to accept a struct xfs_delattr_context containing an xfs_da_args
      instead of an xfs_da_args containing a struct xfs_delattr_context
   Extra transaction conversion logic added for helpers added in the new patches
   gotos associated with state logic amended to have the das_* prefix
   XFS_DAC_DEFER_FINISH renamed to XFS_DAC_DEFER_FINISH
   enum xfs_delattr_state ammended to start at 1 instead of 0
   extra includes removed due to xfs_delattr_context and an xfs_da_args flip
   rebase adjustments

xfs: Add delay ready attr set routines
   Simplify xfs_attr_remove_args loop now that trailing transaction rolls are gone
       (removed in patch 12)
   Subroutines adjusted to accept a struct xfs_delattr_context containing an xfs_da_args
      instead of an xfs_da_args containing a struct xfs_delattr_context
   Extra transaction conversion logic added for helpers added in the new patches
   gotos associated with state logic amended to have the das_* prefix
   XFS_DAC_DEFER_FINISH renamed to XFS_DAC_DEFER_FINISH
   Extra XFS_DAS_RM_LBLK state added in the case of attr rename
   Remove now unused xfs_attr_rmtval_remove added to this patch instead of next patch
   rebase adjustments

xfs: Rename __xfs_attr_rmtval_remove
   New



This series can be viewed on github here:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_v8

As well as the extended delayed attribute and parent pointer series:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_v8_extended

And the test cases:
https://github.com/allisonhenderson/xfs_work/tree/pptr_xfstests

In order to run the test cases, you will need have the corresponding xfsprogs
changes as well.  Which can be found here:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_xfsprogs_v8
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_xfsprogs_v8_extended

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



Allison Collins (20):
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
  xfs: Add helper function xfs_attr_node_shrink
  xfs: Removed unneeded xfs_trans_roll_inode calls
  xfs: Add helpers xfs_attr_is_shortform and xfs_attr_set_shortform
  xfs: Add helper function xfs_attr_leaf_mark_incomplete
  xfs: Add remote block helper functions
  xfs: Add helper function xfs_attr_node_removename_setup
  xfs: Add helper function xfs_attr_node_removename_rmt
  xfs: Add delay ready attr remove routines
  xfs: Add delay ready attr set routines
  xfs: Rename __xfs_attr_rmtval_remove

 fs/xfs/libxfs/xfs_attr.c        | 1052 ++++++++++++++++++++++++++++-----------
 fs/xfs/libxfs/xfs_attr.h        |   55 ++
 fs/xfs/libxfs/xfs_attr_leaf.c   |  115 +++--
 fs/xfs/libxfs/xfs_attr_leaf.h   |    3 +
 fs/xfs/libxfs/xfs_attr_remote.c |  257 +++++++---
 fs/xfs/libxfs/xfs_attr_remote.h |    7 +-
 fs/xfs/xfs_attr_inactive.c      |    1 +
 fs/xfs/xfs_trace.h              |    1 -
 8 files changed, 1067 insertions(+), 424 deletions(-)

-- 
2.7.4

