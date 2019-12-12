Return-Path: <SRS0=0MSb=2C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E813CC43603
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Dec 2019 04:17:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA6BA206A5
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Dec 2019 04:17:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HRNumdeJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727734AbfLLER3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Dec 2019 23:17:29 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:49918 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727507AbfLLER3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Dec 2019 23:17:29 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBC4FVuA145703
        for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2019 04:17:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2019-08-05;
 bh=ChJ6YY3TXTEokDCaLGneNsgDznxtZmoyWlxi2StjB9A=;
 b=HRNumdeJI6/BvgkFmIY8RpLJuy7S/wgpi3yx49ZkNs/rHv1VmcslUPoECc6cKw6cI0nr
 YYgdc5UEKEZaxxHUt+GOjFB5w3HX9solYYmVcLDAj0VcrRevtezP/CPaXcMXWHcFWQCR
 K9pd/+gFc29SUQCDU1wxbrpoR6mywUjvm7nTDWDJsSB+q0yqQzbtQCBNxTnm2TUpZN5d
 fp8ZjxzofsvhlBE6yBmoIRc55tGSpbhcD+YpBLdIJeAJxJCHBmSpP2W147Jl+wEMgH1A
 YRFCwALPnj1zZP0lb6HIdtAgx1K4m9KrroP/JI6kmZNp1ooN/7pCLBz2OqVSa4Q9JnBK uA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2wrw4ndbhx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2019 04:17:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBC4E404127161
        for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2019 04:15:27 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2wu2fvekmh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2019 04:15:27 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBC4FQ4P017121
        for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2019 04:15:26 GMT
Received: from localhost.localdomain (/67.1.205.161)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 11 Dec 2019 20:15:26 -0800
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 00/14] xfs: Delay Ready Attributes
Date:   Wed, 11 Dec 2019 21:14:59 -0700
Message-Id: <20191212041513.13855-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9468 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912120022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9468 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912120022
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This set is a subset of a larger series for delayed attributes. Which
is a subset of an even larger series, parent pointers. Delayed attributes
allow attribute operations (set and remove) to be logged and committed in
the same way that other delayed operations do. This allows more complex 
operations (like parent pointers) to be broken up into multiple smaller 
transactions. To do this, the existing attr operations must be modified to
operate as either a delayed operation or a inline operation since older
filesystems will not be able to use the new log entries. This means that 
they cannot roll, commit, or finish transactions. Instead, they return 
EAGAIN an allow the calling function to handle the transaction. In this
series, we focus on only the clean up and refactoring needed to accomplish
this. We will introduce delayed attrs and parent pointers in a later set.

Changes since v4:
Mostly review updates and nits collected since v4.  I've added an
xfs_name_init to patch 2 to consolidate some of the initialization. The state
machine is introduced in patch 13 and then expanded as needed 14.  I've also
adjusted some of the conditional logic in the delay ready routines such that
we avoid nested gotos.

I've also made the corresponding updates to the user space side, and
xfstests as well.

Questions, comment and feedback appreciated! 

Thanks all!
Allison

Allison Collins (12):
  xfs: Replace attribute parameters with struct xfs_name
  xfs: Embed struct xfs_name in xfs_da_args
  xfs: Factor out new helper functions xfs_attr_rmtval_set
  xfs: Factor up trans handling in xfs_attr3_leaf_flipflags
  xfs: Factor out xfs_attr_leaf_addname helper
  xfs: Factor up xfs_attr_try_sf_addname
  xfs: Factor up trans roll from xfs_attr3_leaf_setflag
  xfs: Factor out xfs_attr_rmtval_invalidate
  xfs: Factor up trans roll in xfs_attr3_leaf_clearflag
  xfs: Check for -ENOATTR or -EEXIST
  xfs: Add delay ready attr remove routines
  xfs: Add delay ready attr set routines

Allison Henderson (2):
  xfs: Remove all strlen in all xfs_attr_* functions for attr names.
  xfs: Add xfs_has_attr and subroutines

 fs/xfs/libxfs/xfs_attr.c        | 802 ++++++++++++++++++++++++++++------------
 fs/xfs/libxfs/xfs_attr.h        |   9 +-
 fs/xfs/libxfs/xfs_attr_leaf.c   | 219 ++++++-----
 fs/xfs/libxfs/xfs_attr_leaf.h   |   3 +
 fs/xfs/libxfs/xfs_attr_remote.c | 103 ++++--
 fs/xfs/libxfs/xfs_attr_remote.h |   4 +-
 fs/xfs/libxfs/xfs_da_btree.c    |   6 +-
 fs/xfs/libxfs/xfs_da_btree.h    |  33 +-
 fs/xfs/libxfs/xfs_dir2.c        |  18 +-
 fs/xfs/libxfs/xfs_dir2_block.c  |   6 +-
 fs/xfs/libxfs/xfs_dir2_leaf.c   |   6 +-
 fs/xfs/libxfs/xfs_dir2_node.c   |   8 +-
 fs/xfs/libxfs/xfs_dir2_sf.c     |  30 +-
 fs/xfs/libxfs/xfs_types.c       |  10 +
 fs/xfs/libxfs/xfs_types.h       |   1 +
 fs/xfs/scrub/attr.c             |  12 +-
 fs/xfs/scrub/common.c           |   2 +
 fs/xfs/xfs_acl.c                |  26 +-
 fs/xfs/xfs_attr_list.c          |   1 +
 fs/xfs/xfs_ioctl.c              |  18 +-
 fs/xfs/xfs_ioctl32.c            |   2 +
 fs/xfs/xfs_iops.c               |   8 +-
 fs/xfs/xfs_trace.h              |  20 +-
 fs/xfs/xfs_xattr.c              |  21 +-
 24 files changed, 918 insertions(+), 450 deletions(-)

-- 
2.7.4

