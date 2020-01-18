Return-Path: <SRS0=0TO6=3H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEAC3C32771
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Jan 2020 22:50:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76CBF246AC
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Jan 2020 22:50:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sc7IWtAT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbgARWur (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 18 Jan 2020 17:50:47 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:37738 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726997AbgARWuq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 18 Jan 2020 17:50:46 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00IMd2Ag056577
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jan 2020 22:50:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2019-08-05;
 bh=/2FEfD20m+W9NOpnQ5IFo0u+U7myLVfXQWbb7STp4xY=;
 b=sc7IWtAT6GCuBrU6cGDnkFPkhM4xdrua9Du9PzYwBgQBU3peZaFfN5KPM9wPMOFkK4zG
 YJhG1FkbUZRvITYQ7SNaNt3G8iajFhc4x8j8jyqtqahH54GqPJAWjzTWj11xyOISYG57
 abiyFBFGB1NnZH81Jvf61pOfTPC10XYjHO8JZ/9+VZ+qylYaJkPochnnt4r5cS+yKkIU
 m5ULNEzLeBWns65EOQzuNAiBb4X/M3Ae+XimJMgwD/2oPphX1vyANR0bMwUtfvFkPzAL
 7JD/Y3CkcAeS3Mq7B2Q61Ha5yAlQJGgsohjMfc9k0IjWNaXOW4eJl1FcQdoRjCr8ar1r sg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2xksypt053-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jan 2020 22:50:45 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00IMcuRf070512
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jan 2020 22:50:44 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2xkq5p96ce-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jan 2020 22:50:44 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00IMohnm026580
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jan 2020 22:50:43 GMT
Received: from localhost.localdomain (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 18 Jan 2020 14:50:43 -0800
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v6 00/16] xfs: Delay Ready Attributes
Date:   Sat, 18 Jan 2020 15:50:19 -0700
Message-Id: <20200118225035.19503-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9504 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001180185
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9504 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001180185
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This set is a subset of a larger series for delayed attributes. Which is a
subset of an even larger series, parent pointers. Delayed attributes allow
attribute operations (set and remove) to be logged and committed in the same way
that other delayed operations do. This allows more complex operations (like
parent pointers) to be broken up into multiple smaller transactions. To do this,
the existing attr operations must be modified to operate as either a delayed
operation or a inline operation since older filesystems will not be able to use
the new log entries. This means that they cannot roll, commit, or finish
transactions. Instead, they return  EAGAIN an allow the calling function to
handle the transaction. In this series, we focus on only the clean up and
refactoring needed to accomplish this. We will introduce delayed attrs and
parent pointers in a later set.

I know there are some other sets waiting for review that intersect with this
one, and I still need to go through those (not forgotten, just queued).  But I
wanted to get an update out before too much time gets away.

Changes since v5:
Mostly review updates and nits collected since v5.  Patches 12, 13 and 14 are
new, and help to modularize and simplify the larger routines in 15 and 16.

I've also made the corresponding updates to the user space side as well.

Questions, comment and feedback appreciated! 

Thanks all!
Allison

Allison Collins (15):
  xfs: Replace attribute parameters with struct xfs_name
  xfs: Embed struct xfs_name in xfs_da_args
  xfs: Factor out new helper functions xfs_attr_rmtval_set
  xfs: Factor out trans handling in xfs_attr3_leaf_flipflags
  xfs: Factor out xfs_attr_leaf_addname helper
  xfs: Refactor xfs_attr_try_sf_addname
  xfs: Factor out trans roll from xfs_attr3_leaf_setflag
  xfs: Factor out xfs_attr_rmtval_invalidate
  xfs: Factor out trans roll in xfs_attr3_leaf_clearflag
  xfs: Check for -ENOATTR or -EEXIST
  xfs: Add helper function xfs_attr_init_unmapstate
  xfs: Add helper function xfs_attr_rmtval_unmap
  xfs: Simplify xfs_attr_set_args
  xfs: Add delay ready attr remove routines
  xfs: Add delay ready attr set routines

Allison Henderson (1):
  xfs: Add xfs_has_attr and subroutines

 fs/xfs/libxfs/xfs_attr.c        | 866 +++++++++++++++++++++++++++-------------
 fs/xfs/libxfs/xfs_attr.h        |  15 +-
 fs/xfs/libxfs/xfs_attr_leaf.c   | 220 +++++-----
 fs/xfs/libxfs/xfs_attr_leaf.h   |   3 +
 fs/xfs/libxfs/xfs_attr_remote.c | 265 +++++++++---
 fs/xfs/libxfs/xfs_attr_remote.h |   7 +-
 fs/xfs/libxfs/xfs_da_btree.c    |   6 +-
 fs/xfs/libxfs/xfs_da_btree.h    |  41 +-
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
 fs/xfs/xfs_trace.h              |  20 +-
 fs/xfs/xfs_xattr.c              |  29 +-
 24 files changed, 1095 insertions(+), 534 deletions(-)

-- 
2.7.4

