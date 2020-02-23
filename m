Return-Path: <SRS0=wjSb=4L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3371C35674
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 02:06:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84F9A206EF
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 02:06:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ne93V4TL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727168AbgBWCGV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 22 Feb 2020 21:06:21 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:46264 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727133AbgBWCGU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 22 Feb 2020 21:06:20 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01N23261180436
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=3HPCXeUWlufOe7SBEU9V3gTvTCoXCz2OBAJFVTPQSxA=;
 b=ne93V4TLQXMZRVVTfeQ47eiBQXR4bWMKZcWHbeX9TAJ+L7dRkWrF9Kc8YskwfZ7namW4
 da5MRQFLP0TvICpzl51OiGrncaCSVmxiGY+tZu/mxDpasy3P+xH/fDdYudxROYMBHWhu
 O28W+PM2jgKCiQEY9jVcNz2VztV9OwJBK2QBvqsWE/HcVIVDyMgsaJxLUR6R8VAtW7o0
 lpUP/b0CiVNTcRrMW5QJGTZ26qZu1QLay4oavAMcM9RtU4kM6jMEPo/fFeyb1ET2CCJf
 AItZ3p2fVLvaZ+TNa1uuCMw04M7uu9rRBbkiza7obznAFt/0TMd/MdYLUSNZIT+gLr6B Kw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2yavxra003-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:19 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01N1w21N080884
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:18 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2ybe0wr17q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:18 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01N26I5n004620
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:18 GMT
Received: from localhost.localdomain (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 23 Feb 2020 02:06:17 +0000
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v7 00/19] xfs: Delayed Ready Attrs
Date:   Sat, 22 Feb 2020 19:05:52 -0700
Message-Id: <20200223020611.1802-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9539 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 suspectscore=0 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002230014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9539 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 spamscore=0 clxscore=1015 suspectscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 adultscore=0 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002230014
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This set is a subset of a larger series for delayed attributes. Which is
a subset of an even larger series, parent pointers. Delayed attributes
allow attribute operations (set and remove) to be logged and committed
in the same way that other delayed operations do. This allows more
complex operations (like parent pointers) to be broken up into multiple
smaller transactions. To do this, the existing attr operations must be
modified to operate as either a delayed operation or a inline operation
since older filesystems will not be able to use the new log entries.
This means that they cannot roll, commit, or finish transactions.
Instead, they return  EAGAIN an allow the calling function to handle
the transaction. In this series, we focus on only the clean up and
refactoring needed to accomplish this. We will introduce delayed attrs
and parent pointers in a later set.

At the moment, I would like people to focus their review efforts on just
this "delay ready" subseries, as I think that is a more conservative use
of peoples review time.  I also think the set is a bit much to manage
all at once, and we need to get the infrastructure ironed out before we
focus too much anything that depends on it. But I do have the extended
series for folks that want to see the bigger picture of where this is
going.

This series can be viewed on github here:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_v7

As well as the extended delayed attribute and parent pointer series:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_v7_extended

And the test cases:
https://github.com/allisonhenderson/xfs_work/tree/pptr_xfstests

To run the xfs attributes tests run:
check -g attr

To run as delayed attributes run:
export MKFS_OPTIONS="-n delattr"
check -g attr

To run parent pointer tests:
check -g parent

Changes since v6:
Mostly review just updates.  In the last review folks asked for a
diagram to make the code flow more visual.  They have been added in
patches 13 and 14.  At the moment, they're in the commit message.  I
figure people can decide where or if they want them somewhere in the
code later, since they are a bit lengthy.  Patch 15 is a helper function
that used to be part of 14 but I separated it to better organize things.
Patches 18 and 19 are new, and are just cleanups that I thought would
be helpful.

I've also gone through the set and rearranged the order of some of the
patches to make sort of mini sets.  I thought it would help reviewers
break down the reviewing some. For reviewing purposes, the set could be
broken up into 5 different phases:

Clean ups (patches 1-2):
These two patches were actually review suggestions made quiet some time
ago in regaurds to commit d29f781 (Remove all strlen ...), which has
since been merged.  The idea of the cleanups was to collapse down the
number of parameters getting passed around the xfs_attr_* routines.  It
has since drawn both commentary and critisim, so it's a little unclear
to me if people want it or not.  It could easily be taken as a stand
alone clean up.  But it's also not a neccassary must have in so far as
the delayed operations are concerned.  It does however pepper around a
lot of change activity up through the set.  So it would be helpfull to
get a verdict one way or another, depending on how people feel about it.
   xfs: Replace attribute parameters with struct xfs_name
   xfs: Embed struct xfs_name in xfs_da_args

Error code filtering (patches 3-4):
These two patches are all about finding and catching error codes that
need to be sent back up to user space before starting delayed
operations.  Errors that happen during a delayed operation are treated
like interal errors that cause a shutdown.  But we wouldnt want that
for example: when the user tries to rename a non existent attr.  So the
idea is that we need to find all such conditions, and take care of them
before starting a delayed operation.
   xfs: Add xfs_has_attr and subroutines
   xfs: Check for -ENOATTR or -EEXIST

Move transactions upwards (patches 5-12):
The goal of this subset is to try and move all the transaction specific
code up the call stack much as possible.  The idea being that once we
get them to the top, we can introduce the statemachine to handle the
-EAGAIN logic where ever the transactions used to be.
   xfs: Factor out new helper functions xfs_attr_rmtval_set
   xfs: Factor out trans handling in xfs_attr3_leaf_flipflags
   xfs: Factor out xfs_attr_leaf_addname helper
   xfs: Refactor xfs_attr_try_sf_addname
   xfs: Factor out trans roll from xfs_attr3_leaf_setflag
   xfs: Factor out xfs_attr_rmtval_invalidate
   xfs: Factor out trans roll in xfs_attr3_leaf_clearflag
   xfs: Add helper function xfs_attr_rmtval_unmap

Introduce statemachine (patches 13-14):
Now that we have re-arranged the code such that we can remove the
transaction handleing, we proceed to do so.  The behavior of the attr
set/remove routines are now also compatible as a .finish_item callback
   xfs: Add delay ready attr remove routines
   xfs: Add delay ready attr set routines

Modularizing and cleanups (patches 15-19):
Now that we have pulled the transactions up to where we need them, it's
time to start breaking down the top level functions into new
subfunctions. The goal being to work towards a top level function that
deals mostly with the statemachine, and helpers for those states
   xfs: Add helper function xfs_attr_node_shrink
   xfs: Simplify xfs_attr_set_iter
   xfs: Add helper function xfs_attr_leaf_mark_incomplete
   xfs: Add remote block helper functions
   xfs: Remove xfs_attr_rmtval_remove


I've also made the corresponding updates to the user space side as well.

Questions, comment and feedback appreciated! 

Thanks all!
Allison

Allison Collins (18):
  xfs: Replace attribute parameters with struct xfs_name
  xfs: Embed struct xfs_name in xfs_da_args
  xfs: Check for -ENOATTR or -EEXIST
  xfs: Factor out new helper functions xfs_attr_rmtval_set
  xfs: Factor out trans handling in xfs_attr3_leaf_flipflags
  xfs: Factor out xfs_attr_leaf_addname helper
  xfs: Refactor xfs_attr_try_sf_addname
  xfs: Factor out trans roll from xfs_attr3_leaf_setflag
  xfs: Factor out xfs_attr_rmtval_invalidate
  xfs: Factor out trans roll in xfs_attr3_leaf_clearflag
  xfs: Add helper function xfs_attr_rmtval_unmap
  xfs: Add delay ready attr remove routines
  xfs: Add delay ready attr set routines
  xfs: Add helper function xfs_attr_node_shrink
  xfs: Simplify xfs_attr_set_iter
  xfs: Add helper function xfs_attr_leaf_mark_incomplete
  xfs: Add remote block helper functions
  xfs: Remove xfs_attr_rmtval_remove

Allison Henderson (1):
  xfs: Add xfs_has_attr and subroutines

 fs/xfs/libxfs/xfs_attr.c        | 947 ++++++++++++++++++++++++++++------------
 fs/xfs/libxfs/xfs_attr.h        |  15 +-
 fs/xfs/libxfs/xfs_attr_leaf.c   | 220 +++++-----
 fs/xfs/libxfs/xfs_attr_leaf.h   |   3 +
 fs/xfs/libxfs/xfs_attr_remote.c | 260 +++++++----
 fs/xfs/libxfs/xfs_attr_remote.h |   7 +-
 fs/xfs/libxfs/xfs_da_btree.c    |   6 +-
 fs/xfs/libxfs/xfs_da_btree.h    |  47 +-
 fs/xfs/libxfs/xfs_dir2.c        |  18 +-
 fs/xfs/libxfs/xfs_dir2_block.c  |   6 +-
 fs/xfs/libxfs/xfs_dir2_leaf.c   |   6 +-
 fs/xfs/libxfs/xfs_dir2_node.c   |   8 +-
 fs/xfs/libxfs/xfs_dir2_sf.c     |  30 +-
 fs/xfs/libxfs/xfs_types.c       |  11 +
 fs/xfs/libxfs/xfs_types.h       |   1 +
 fs/xfs/scrub/attr.c             |  12 +-
 fs/xfs/scrub/common.c           |   2 +
 fs/xfs/xfs_acl.c                |  27 +-
 fs/xfs/xfs_attr_list.c          |   1 +
 fs/xfs/xfs_ioctl.c              |  25 +-
 fs/xfs/xfs_ioctl32.c            |   2 +
 fs/xfs/xfs_iops.c               |   8 +-
 fs/xfs/xfs_trace.h              |  21 +-
 fs/xfs/xfs_xattr.c              |  29 +-
 24 files changed, 1140 insertions(+), 572 deletions(-)

-- 
2.7.4

