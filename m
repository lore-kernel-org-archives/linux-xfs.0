Return-Path: <SRS0=/Wyv=XA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B84C1C00307
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 22:19:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE6CE2070C
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 22:19:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZDDBeGQA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391122AbfIEWTK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 18:19:10 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33102 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391113AbfIEWTJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 18:19:09 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85MJ8IA078153
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:19:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2019-08-05;
 bh=XzVMWnYNQmhWvrYQZ3vnl0FjAQGMSlNv9H/Umm8qADs=;
 b=ZDDBeGQAXVbAsSjJvulEtoLtgKp16mE/nEiCANe49NP2gWltDhyrid7D7AlLFD2N/js7
 NV1ibUe/iwCPZ7Pnmz89efw4FQ3EzQfcHcvWlnT+EGYNdBcu0TPTb0WuEU2/ClgJsxm7
 TZR6QkmC5LraYdPSzeOdEkx9bKCl7nRzIZLh7ATZrjhcsF2koSAFUnhxbmno155vrcMy
 GBf6p4u7adwDwaia5fvYgOZjLcwv/ly74rh9JXG70wSNBew8U9EBhQwOAPRiGmQH5zJ8
 zL2wHJDupa3s37klGGBDBZAxU+/D6JuRVgLm/E7Y5SbK3UML2jYljFfSLOQbPUnjVc4h tw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2uuaqj02mf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2019 22:19:08 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85MINCg101595
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:19:02 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2uu1b946s3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2019 22:19:02 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x85MIh3L001598
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:18:44 GMT
Received: from localhost.localdomain (/67.1.183.122)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 15:18:43 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 00/19] Delayed Attributes
Date:   Thu,  5 Sep 2019 15:18:18 -0700
Message-Id: <20190905221837.17388-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909050207
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909050207
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This set is a subset of a larger series for parent pointers. 
Delayed attributes allow attribute operations (set and remove) to be 
logged and committed in the same way that other delayed operations do.
This will help break up more complex operations when we later introduce
parent pointers which can be used in a number of optimizations.  Since
delayed attributes can be implemented as a stand alone feature, I've
decided to subdivide the set to help make it more manageable.  Delayed
attributes may also provide the infastructure to later break up large
attributes into smaller transactions instead of one large bwrite.

Changes since v2:
Mostly review updates collected since v2.  Patch 17 is new and adds a
new feature bit that is enabled through mkfs.xfs -n delattr.  Attr
renames have been simplified into separate remove and set opertaions
which removes the need for the INCOMPLETE state used in non delayed
operations

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
  xfs: Add delayed attribute routines
  xfs: Add feature bit XFS_SB_FEAT_INCOMPAT_LOG_DELATTR
  xfs: Enable delayed attributes

Allison Henderson (4):
  xfs: Add xfs_has_attr and subroutines
  xfs: Set up infastructure for deferred attribute operations
  xfs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred
  xfs_io: Add delayed attributes error tag

 fs/xfs/Makefile                 |    2 +-
 fs/xfs/libxfs/xfs_attr.c        | 1068 ++++++++++++++++++++++++++++++++++-----
 fs/xfs/libxfs/xfs_attr.h        |   53 +-
 fs/xfs/libxfs/xfs_attr_leaf.c   |  277 ++++++----
 fs/xfs/libxfs/xfs_attr_leaf.h   |    7 +
 fs/xfs/libxfs/xfs_attr_remote.c |  103 +++-
 fs/xfs/libxfs/xfs_attr_remote.h |    4 +-
 fs/xfs/libxfs/xfs_da_btree.c    |    8 +-
 fs/xfs/libxfs/xfs_da_btree.h    |   27 +-
 fs/xfs/libxfs/xfs_defer.c       |    1 +
 fs/xfs/libxfs/xfs_defer.h       |    3 +
 fs/xfs/libxfs/xfs_dir2.c        |   22 +-
 fs/xfs/libxfs/xfs_dir2_block.c  |    6 +-
 fs/xfs/libxfs/xfs_dir2_leaf.c   |    6 +-
 fs/xfs/libxfs/xfs_dir2_node.c   |    8 +-
 fs/xfs/libxfs/xfs_dir2_sf.c     |   30 +-
 fs/xfs/libxfs/xfs_errortag.h    |    4 +-
 fs/xfs/libxfs/xfs_format.h      |   11 +-
 fs/xfs/libxfs/xfs_fs.h          |    1 +
 fs/xfs/libxfs/xfs_log_format.h  |   44 +-
 fs/xfs/libxfs/xfs_sb.c          |    2 +
 fs/xfs/libxfs/xfs_types.h       |    1 +
 fs/xfs/scrub/attr.c             |   12 +-
 fs/xfs/scrub/common.c           |    2 +
 fs/xfs/xfs_acl.c                |   29 +-
 fs/xfs/xfs_attr_item.c          |  764 ++++++++++++++++++++++++++++
 fs/xfs/xfs_attr_item.h          |   88 ++++
 fs/xfs/xfs_attr_list.c          |    1 +
 fs/xfs/xfs_error.c              |    3 +
 fs/xfs/xfs_ioctl.c              |   30 +-
 fs/xfs/xfs_ioctl32.c            |    2 +
 fs/xfs/xfs_iops.c               |   14 +-
 fs/xfs/xfs_log.c                |    4 +
 fs/xfs/xfs_log_recover.c        |  173 +++++++
 fs/xfs/xfs_ondisk.h             |    2 +
 fs/xfs/xfs_super.c              |    4 +
 fs/xfs/xfs_trace.h              |   20 +-
 fs/xfs/xfs_trans.h              |    1 -
 fs/xfs/xfs_xattr.c              |   31 +-
 39 files changed, 2509 insertions(+), 359 deletions(-)
 create mode 100644 fs/xfs/xfs_attr_item.c
 create mode 100644 fs/xfs/xfs_attr_item.h

-- 
2.7.4

