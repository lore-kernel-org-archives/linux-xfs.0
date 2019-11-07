Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 850D6FA372C
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 01:28:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50E13217D7
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 01:28:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nEj2rANN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728154AbfKGB2t (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Nov 2019 20:28:49 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:51160 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727963AbfKGB2t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Nov 2019 20:28:49 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA71On2c152322
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 01:28:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2019-08-05;
 bh=xmU58VReh/66PSSRHRdzcgzw7P+FhPbD8rL3cx5mKKU=;
 b=nEj2rANNp4xFmaUfaAH1CEhsJbgFZUTmY6S+xxdg9xFCPhODqnagrjzOlgo6KmjLggoN
 H+qg0ab6CvfAfqDOReFU7tujyct+vRlvEVLUmWqR7lTOC8LnMKKhOERc1XqMST50nqDC
 DS+NE8r9fmYNSs0vBAwdRXarnjQYexae6sdnrTjrr8r0avfO9QhGBlJGv70doHtUO4+t
 NKp2tMHpH2sItn34wCeJxzwUKgPUvLxfOuxy2lCtVTinslGDKm64z71/hl59PJZ/znJU
 IW5VD3C1eCHSRejtipMrbm33lYN9A4txa/y88d/2dqQ7l++cURhiBk3Y6QFUPRjYNmxx /Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2w41w0tq4a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 01:28:47 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA71SjP5088036
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 01:28:46 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2w41wfe833-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 01:28:46 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA71Sj4I031896
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 01:28:45 GMT
Received: from localhost.localdomain (/67.1.205.161)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 17:28:44 -0800
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 00/17] xfs: Delay Ready Attributes
Date:   Wed,  6 Nov 2019 18:27:44 -0700
Message-Id: <20191107012801.22863-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911070014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911070013
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

Changes since v3:
Mostly review updates collected since v3.  Patches 15, 16, and 17 are new
and apply most of the new code flow changes.  No new function is added at
this time. 

I've also made the corresponding updates to the user space side, and
xfstests as well.

Question, comment and feedback appreciated! 

Thanks all!
Allison

Allison Collins (15):
  xfs: Replace attribute parameters with struct xfs_name
  xfs: Embed struct xfs_name in xfs_da_args
  xfs: Add xfs_dabuf defines
  xfs: Factor out new helper functions xfs_attr_rmtval_set
  xfs: Factor up trans handling in xfs_attr3_leaf_flipflags
  xfs: Factor out xfs_attr_leaf_addname helper
  xfs: Factor up commit from xfs_attr_try_sf_addname
  xfs: Factor up trans roll from xfs_attr3_leaf_setflag
  xfs: Add xfs_attr3_leaf helper functions
  xfs: Factor out xfs_attr_rmtval_invalidate
  xfs: Factor up trans roll in xfs_attr3_leaf_clearflag
  xfs: Add delay context to xfs_da_args
  xfs: Check for -ENOATTR or -EEXIST
  xfs: Add delay ready attr remove routines
  xfs: Add delay ready attr set routines

Allison Henderson (2):
  xfs: Remove all strlen in all xfs_attr_* functions for attr names.
  xfs: Add xfs_has_attr and subroutines

 fs/xfs/libxfs/xfs_attr.c        | 771 +++++++++++++++++++++++++---------------
 fs/xfs/libxfs/xfs_attr.h        |   9 +-
 fs/xfs/libxfs/xfs_attr_leaf.c   | 329 +++++++++++------
 fs/xfs/libxfs/xfs_attr_leaf.h   |   7 +
 fs/xfs/libxfs/xfs_attr_remote.c | 103 ++++--
 fs/xfs/libxfs/xfs_attr_remote.h |   4 +-
 fs/xfs/libxfs/xfs_da_btree.c    |  55 ++-
 fs/xfs/libxfs/xfs_da_btree.h    |  32 +-
 fs/xfs/libxfs/xfs_dir2.c        |  18 +-
 fs/xfs/libxfs/xfs_dir2_block.c  |  12 +-
 fs/xfs/libxfs/xfs_dir2_data.c   |   3 +-
 fs/xfs/libxfs/xfs_dir2_leaf.c   |  15 +-
 fs/xfs/libxfs/xfs_dir2_node.c   |  18 +-
 fs/xfs/libxfs/xfs_dir2_sf.c     |  30 +-
 fs/xfs/scrub/attr.c             |  12 +-
 fs/xfs/scrub/common.c           |   2 +
 fs/xfs/scrub/dabtree.c          |   6 +-
 fs/xfs/scrub/dir.c              |   4 +-
 fs/xfs/xfs_acl.c                |  26 +-
 fs/xfs/xfs_attr_inactive.c      |   6 +-
 fs/xfs/xfs_attr_list.c          |  17 +-
 fs/xfs/xfs_ioctl.c              |  20 +-
 fs/xfs/xfs_ioctl32.c            |   2 +
 fs/xfs/xfs_iops.c               |  11 +-
 fs/xfs/xfs_trace.h              |  20 +-
 fs/xfs/xfs_xattr.c              |  23 +-
 26 files changed, 1016 insertions(+), 539 deletions(-)

-- 
2.7.4

