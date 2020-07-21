Return-Path: <SRS0=jPpR=BA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07C3FC433E4
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jul 2020 00:16:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8A6C22C9C
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jul 2020 00:16:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="itudlyt7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728122AbgGUAQS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Jul 2020 20:16:18 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40444 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726742AbgGUAQR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Jul 2020 20:16:17 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06L03Sqs181798
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 00:16:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2020-01-29;
 bh=o+oFmIj88S0hEnFW8sULO2tGJln+YKt/44MF3O6ZFls=;
 b=itudlyt736P11nJ70DCESwHlYmeW0auskPwyUg5hmNJKJem4h3Ov1HEbphDaCtth1eXd
 J0PHGWAdUau9QoX5/8S3IIoOVKmQz57gk0g1D4VjbTSy6SDvNHrB3G9Dq4kD5IKXfrA/
 dPoyzx7G/g+O5NBQaEHSK2ax7Zmaxfz9/fIP7Cs0i77taf4At4+3hy+cUJOqe5NFqfhH
 3eIpvA4jawHHcW2r+Gs+gvOKZHJP60yWqd5bowa3shZZqSozjf5Hg16mghaZRXNiLK2E
 X1HS3hSJNDPTHsDmTn9Qvm/coqcNIhsu1/oo/Ap6ZABSKGF9a3LjCu2qDWpm/gtypjXn UQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 32bs1m9x82-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 00:16:14 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06L04MAs097183
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 00:16:13 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 32dnfngeya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 00:16:13 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06L0GCSY014511
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 00:16:12 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 Jul 2020 17:16:12 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v11 00/25] xfs: Delay Ready Attributes
Date:   Mon, 20 Jul 2020 17:15:41 -0700
Message-Id: <20200721001606.10781-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9688 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 mlxscore=0 adultscore=0 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007200146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9688 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 clxscore=1015
 spamscore=0 mlxscore=0 impostorscore=0 phishscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007200146
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


Changes since v10:
Theres a lot of activity that goes around with each set, so to help people
recall the discussion I've outlined the changes for each patch, which are new,
and which are unchanged:

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
   No change

xfs: Remove unneeded xfs_trans_roll_inode calls
   Fixed typo in commit message

xfs: Remove xfs_trans_roll in xfs_attr_node_removename
   Expanded commit message

xfs: Add helpers xfs_attr_is_shortform and xfs_attr_set_shortform
xfs: Add helper function xfs_attr_leaf_mark_incomplete
xfs: Add remote block helper functions
xfs: Add helper function xfs_attr_node_removename_setup
xfs: Add helper function xfs_attr_node_removename_rmt
xfs: Simplify xfs_attr_leaf_addname
xfs: Simplify xfs_attr_node_addname
xfs: Lift -ENOSPC handler from xfs_attr_leaf_addname
  No change

xfs: Add delay ready attr remove routines
  Renamed xfs_attr_roll_again to xfs_attr_trans_roll
  Some extra commentary added to xfs_attr_trans_roll
  Pulled error handling from xfs_attr_trans_roll into caller

xfs: Add delay ready attr set routines
  Renamed xfs_attr_roll_again to xfs_attr_trans_roll
  Pulled error handling from xfs_attr_trans_roll into caller
  Rebase adjustments

xfs: Rename __xfs_attr_rmtval_remove
  No change

This series can be viewed on github here:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_v11

As well as the extended delayed attribute and parent pointer series:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_v11_extended

And the test cases:
https://github.com/allisonhenderson/xfs_work/tree/pptr_xfstests

In order to run the test cases, you will need have the corresponding xfsprogs
changes as well.  Which can be found here:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_xfsprogs_v11
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_xfsprogs_v11_extended

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

 fs/xfs/libxfs/xfs_attr.c        | 1198 ++++++++++++++++++++++++++-------------
 fs/xfs/libxfs/xfs_attr.h        |  198 +++++++
 fs/xfs/libxfs/xfs_attr_leaf.c   |  116 ++--
 fs/xfs/libxfs/xfs_attr_leaf.h   |    3 +
 fs/xfs/libxfs/xfs_attr_remote.c |  258 ++++++---
 fs/xfs/libxfs/xfs_attr_remote.h |    8 +-
 fs/xfs/xfs_attr_inactive.c      |    2 +-
 fs/xfs/xfs_trace.h              |    1 -
 8 files changed, 1261 insertions(+), 523 deletions(-)

-- 
2.7.4

