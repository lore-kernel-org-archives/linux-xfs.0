Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F9D3C2BBCF
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Dec 2020 07:30:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2761123A5B
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Dec 2020 07:30:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732891AbgLRHaG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Dec 2020 02:30:06 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:36404 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732853AbgLRHaG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Dec 2020 02:30:06 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BI7KJRW001557
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:29:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2020-01-29;
 bh=sy84ZxFf/fb2B5pjpdm4kXgjreApHKCmh/JY5miWPIU=;
 b=zPgmbg3lEUlCKowcb1nn+w/cX4V/h7OeeyId6t9vxKVD7/rnLsb+HvabO0i2Ox/IU+C/
 yqG+n+1rkUOnWKOcANuawnynMpUxDYwaZAv74gdm2Y5V12E2tzyf2WVTg4KTTRO4a/yF
 Zb6ALgXkZptycozDBNX/vwM+W2NcdVT7I7vc8mSxPnr4N7UDu0XBgMy3ZRlGZpApwi0o
 VN3A6snsEtUTYeQZIX8BOZZSO+VdHol0evDe2RfmLo/9jkppHyuBbwt0/BbwQIqjPqcN
 HWhLRotXm5dXHIo7wUG1di4turkQQa2mxIFbQYsdAwixjql6r5XGhcQwC26eIuH5EgGI 7g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 35ckcbs6q0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:29:24 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BI7KIss038267
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:29:23 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 35d7t1hc2f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:29:23 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BI7TMxf003405
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:29:22 GMT
Received: from localhost.localdomain (/67.1.214.41)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Dec 2020 23:29:22 -0800
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v14 00/15] xfs: Delayed Attributes
Date:   Fri, 18 Dec 2020 00:29:02 -0700
Message-Id: <20201218072917.16805-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9838 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012180052
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9838 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 impostorscore=0 lowpriorityscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012180052
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

Delay Ready Attributes: (patches 1-8)
These are the remaining patches belonging to the "Delay Ready" series that
we've been working with.  In these patches, transaction handling is removed
from the attr routines, and replaced with a state machine that allows a high
level function to roll the transaction and repeatedly recall the attr routines
until they are finished.  The behavior of the attr set/remove routines
are now also compatible as a .finish_item callback
  xfs: Add helper xfs_attr_node_remove_step
  xfs: Hoist transaction handling in xfs_attr_node_remove_step
  xfs: Add xfs_attr_node_remove_cleanup
  xfs: Add delay ready attr remove routines
  xfs: Add delay ready attr set routines
  xfs: Add statemachine tracepoints
  xfs: Rename __xfs_attr_rmtval_remove
  xfs: Handle krealloc errors in xlog_recover_add_to_cont_trans

Delayed Attributes: (patches 9 - 15)
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

Updates since v13: Mostly integrating review feed back, which involved quite
a few changes.  Most significant being the removal of the incompat flag which
has been replaced with a mount option.  Though we do need to set an incompat
flag, we cannot use it to enable/disable the feature.  It needs to be set when
ever a new log item is written to disk.  ATM, writing the flag to the super
block on the fly currently not supported, but overlaps with another work effort
that needs it for other reasons.  For now, writing new log entries to the disk
is simply disabled unless specified at mount time.

xfs: Add helper xfs_attr_node_remove_step
   Initialized state to null in xfs_attr_node_removename
   Fixed typo "shirnk"

xfs: Add xfs_attr_node_remove_cleanup
   NEW

xfs: Hoist transaction handling in xfs_attr_node_remove_step
   NEW

xfs: Add delay ready attr remove routines
   Removed uneeded error = 0; initialization in xfs_attr_remove_args
   Simplified if/else logic in xfs_attr_remove_iter.  Added some commentary
   Collapsed extra state arg in xfs_attr_node_removename_setup
   Moved up state init in xfs_attr_node_removename_setup
   Fixed variable alignment in xfs_attr_node_remove_step
   Removed XFS_DAC_NODE_RMVNAME_INIT
   Modified default switch case in xfs_attr_node_removename_iter to goto out instead of return
   Updated /* fallthrough */ comment in xfs_attr_node_removename_iter
   Updated commentary for xfs_attr_node_remove_step in xfs_attr_node_removename_iter
   Updated xfs_attr_trans_roll to skip roll if defer_finish is called
   Expanded state machine diagram in b/fs/xfs/libxfs/xfs_attr.h
   Fixed typo in xfs_attr_rmtval_remove comment 
   Added explanation to stateless -EAGAIN return
   
xfs: Add delay ready attr set routines
   Rebase adjustments
   Removed uneeded bhold/join from xfs_attr_set_args
   Removed xfs_attr_rmtval_remove prototype from xfs_attr_remote.h.
   Added comments to EAGAIN returns that dont needs states
   Added XFS_DAS_RM_LBLK and XFS_DAS_UNINIT to switch in xfs_attr_set_iter
   Assert on states that belong to remove path 
   Expanded comments in xfs_attr_set_iter
   Fixed ENSPC handler for xfs_attr_leaf_try_add
   Expanded state machine diagram in b/fs/xfs/libxfs/xfs_attr.h
   Fix a bug found with generic/449
      Do no return EAGAIN on sucessfull leaf add if theres nothing left to do
   Moved state set to before xfs_attr_rmtval_remove call

xfs: Add statemachine tracepoints
  NEW

xfs: Rename __xfs_attr_rmtval_remove
   Rebase adjustments

xfs: Handle krealloc errors in xlog_recover_add_to_cont_trans
   NEW

xfs: Set up infastructure for deferred attribute operations
  Added extra buffer_size parameter to xfs_attri_log_item
    This allows a trailing buffer to be allocated allong with the intent
    Simplifies having to realloc the intent during the log commit
  Misc white space cleanups
  Removed unused xfs_attrlen_t
  Removed wrapper function xfs_attri_item_sizeof and xfs_attrd_item_sizeof
  Added inline helper ATTR_NVEC_SIZE.  Simplified with roundup function
  Rephrased comment for xfs_trans_attr
  Moved attrip cleanup in xfs_attr_finish_item to xfs_attri_item_committed
  Removed unused xfs_attri_item_committing  and xfs_attrd_item_committing
  Merged xfs_attrd_init into xfs_trans_get_attrd
  Added XFS_ITEM_RELEASE_WHEN_COMMITTED to xfs_attrd_item_ops
  Reworked xfs_attri_item_recover to preseerve log replay order
  Expanded xfs_attri_item_recover validate check
  Added xfs_attri_item_relog
  Added validate check to xfs_attr_leaf_try_add
  Trimmed down xfs_attri_log_item commentary
  Reordered xfs_attri_log_item members to remove holes
  Renamed xfs_sb_version_hasdelattr to xfs_hasdelattr, and moved to xfs_attr.h
    This will be used for a mount option later instead of an incompat flag

xfs: Skip flip flags for delayed attrs
  NEW

xfs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred
  Merged with patch xfs: Enable delayed attributes
  Manged kmem_alloc_large to kmem_zalloc 
  Merged with previous "Enable delayed attributes" patch

xfs: Enable delayed attributes
  REMOVED

xfs: Remove unused xfs_attr_*_args
  Collapsed in leaf_bp parameter in xfs_attr_set_iter

xfs: Add delayed attributes error tag
   No change

xfs: Add feature bit XFS_SB_FEAT_INCOMPAT_LOG_DELATTR
   REMOVED

xfs: Add delattr mount option
   NEW

b54c08d xfsprogs: Merge xfs_delattr_context into xfs_attr_item
   NEW

This series can be viewed on github here:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_v14

As well as the extended delayed attribute and parent pointer series:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_v14_extended

And the test cases:
https://github.com/allisonhenderson/xfs_work/tree/pptr_xfstestsv2

In order to run the test cases, you will need have the corresponding xfsprogs
changes as well.  Which can be found here:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_xfsprogs_v14
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_xfsprogs_v14_extended

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


Allison Collins (3):
  xfs: Add helper xfs_attr_node_remove_step
  xfs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred
  xfs: Add delayed attributes error tag

Allison Henderson (12):
  xfs: Add xfs_attr_node_remove_cleanup
  xfs: Hoist transaction handling in xfs_attr_node_remove_step
  xfs: Add delay ready attr remove routines
  xfs: Add delay ready attr set routines
  xfs: Add state machine tracepoints
  xfs: Rename __xfs_attr_rmtval_remove
  xfs: Handle krealloc errors in xlog_recover_add_to_cont_trans
  xfs: Set up infastructure for deferred attribute operations
  xfs: Skip flip flags for delayed attrs
  xfs: Remove unused xfs_attr_*_args
  xfs: Add delattr mount option
  xfs: Merge xfs_delattr_context into xfs_attr_item

 fs/xfs/Makefile                 |   1 +
 fs/xfs/libxfs/xfs_attr.c        | 633 ++++++++++++++++++++----------
 fs/xfs/libxfs/xfs_attr.h        | 360 ++++++++++++++++-
 fs/xfs/libxfs/xfs_attr_leaf.c   |   5 +-
 fs/xfs/libxfs/xfs_attr_remote.c | 126 +++---
 fs/xfs/libxfs/xfs_attr_remote.h |   7 +-
 fs/xfs/libxfs/xfs_defer.c       |   1 +
 fs/xfs/libxfs/xfs_defer.h       |   3 +
 fs/xfs/libxfs/xfs_errortag.h    |   4 +-
 fs/xfs/libxfs/xfs_log_format.h  |  44 ++-
 fs/xfs/libxfs/xfs_log_recover.h |   2 +
 fs/xfs/scrub/common.c           |   2 +
 fs/xfs/xfs_acl.c                |   2 +
 fs/xfs/xfs_attr_inactive.c      |   2 +-
 fs/xfs/xfs_attr_item.c          | 830 ++++++++++++++++++++++++++++++++++++++++
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
 fs/xfs/xfs_trace.h              |  21 +-
 fs/xfs/xfs_xattr.c              |   3 +
 28 files changed, 1874 insertions(+), 254 deletions(-)
 create mode 100644 fs/xfs/xfs_attr_item.c
 create mode 100644 fs/xfs/xfs_attr_item.h

-- 
2.7.4

