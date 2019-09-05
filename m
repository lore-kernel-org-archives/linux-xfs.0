Return-Path: <SRS0=/Wyv=XA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 368DAC00306
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 22:19:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C22F2070C
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 22:19:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fMVRtaJ9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391117AbfIEWTj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 18:19:39 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33726 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389194AbfIEWTj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 18:19:39 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85MJ8ir078144
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:19:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2019-08-05;
 bh=rw7gWQpe06C4B7rq4x1/4VGonu/psfhUgXB4cOvKgjU=;
 b=fMVRtaJ9dyMwkF38IpPabrqG2Q8AjRvcPtiDLu1odLX6bYW/J70u2M0BisvQnVzAbxq1
 +wpYPg4S66/JRMFgy/zY8xrbp5AgDRDW3i4L4d9hV7Q9XwC/7TRFhsU8w8jhoK22/VZb
 JhmRlDu8uupL7vrtj29Ia7qRyiio8DBuXg2XnBaRTMjH5yDTtYgNo6XZB/PWc4SPj0eu
 BHthRTCCrouuaMrtVsfY1wsknAWxCGt20J3mInt2ynROCYu15l1eOC308CCjsdl2mDIA
 /qtUbE1TTzykKIMD3yAF8fDf7nuIk7l8ezfzx7avAOobf4wZ4smrB6FeytpGH9rglDr7 nA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2uuaqj02qe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2019 22:19:37 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85MIO2Y101652
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:19:36 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2uu1b9474n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2019 22:19:36 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x85MJ0RE001664
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:19:00 GMT
Received: from localhost.localdomain (/67.1.183.122)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 15:19:00 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 00/21] Delayed Attributes
Date:   Thu,  5 Sep 2019 15:18:34 -0700
Message-Id: <20190905221855.17555-1-allison.henderson@oracle.com>
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

This set applies the corresponding changes for delayed attributes to xfsprogs.  
The goal of the set is to provide basic utilities to replay and print the new
attribute log entries.

The first 19 patches synchronize libxfs with changes seen the kernel space
patches. The last two  patches add routines for journal replay and also a
cli option to enable the delayed attributes feature bit. I will pick up the
reviews from the kernel side series and mirror them here.  

Thanks all!
Allison

Allison Collins (20):
  xfsprogs: Replace attribute parameters with struct xfs_name
  xfsprogs: Embed struct xfs_name in xfs_da_args
  xfsprogs: Add xfs_dabuf defines
  xfsprogs: Add xfs_has_attr and subroutines
  xfsprogs: Factor out new helper functions xfs_attr_rmtval_set
  xfsprogs: Factor up trans handling in xfs_attr3_leaf_flipflags
  xfsprogs: Factor out xfs_attr_leaf_addname helper
  xfsprogs: Factor up commit from xfs_attr_try_sf_addname
  xfsprogs: Factor up trans roll from xfs_attr3_leaf_setflag
  xfsprogs: Add xfs_attr3_leaf helper functions
  xfsprogs: Factor out xfs_attr_rmtval_invalidate
  xfsprogs: Factor up trans roll in xfs_attr3_leaf_clearflag
  xfsprogs: Add delay context to xfs_da_args
  xfsprogs: Add delayed attribute routines
  xfsprogs: Set up infastructure for deferred attribute operations
  xfsprogs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred
  xfsprogs: Add feature bit XFS_SB_FEAT_INCOMPAT_LOG_DELATTR
  xfsprogs: Enable delayed attributes
  xfs_io: Add delayed attributes error tag
  xfsprogs: Add delayed attribute flag to cmd

Allison Henderson (1):
  xfsprogs: Add log item printing for ATTRI and ATTRD

 db/attrset.c             |   14 +-
 io/inject.c              |    1 +
 libxfs/defer_item.c      |  175 +++++++-
 libxfs/libxfs_priv.h     |   15 +-
 libxfs/xfs_attr.c        | 1068 ++++++++++++++++++++++++++++++++++++++++------
 libxfs/xfs_attr.h        |   53 ++-
 libxfs/xfs_attr_leaf.c   |  284 ++++++++----
 libxfs/xfs_attr_leaf.h   |    7 +
 libxfs/xfs_attr_remote.c |  103 +++--
 libxfs/xfs_attr_remote.h |    4 +-
 libxfs/xfs_da_btree.c    |    8 +-
 libxfs/xfs_da_btree.h    |   27 +-
 libxfs/xfs_defer.c       |    1 +
 libxfs/xfs_defer.h       |    3 +
 libxfs/xfs_dir2.c        |   22 +-
 libxfs/xfs_dir2_block.c  |    6 +-
 libxfs/xfs_dir2_leaf.c   |    6 +-
 libxfs/xfs_dir2_node.c   |    8 +-
 libxfs/xfs_dir2_sf.c     |   30 +-
 libxfs/xfs_errortag.h    |    4 +-
 libxfs/xfs_format.h      |   11 +-
 libxfs/xfs_fs.h          |    1 +
 libxfs/xfs_log_format.h  |   44 +-
 libxfs/xfs_sb.c          |    2 +
 libxfs/xfs_types.h       |    1 +
 logprint/log_misc.c      |   31 +-
 logprint/log_print_all.c |   12 +
 logprint/log_redo.c      |  197 +++++++++
 logprint/logprint.h      |    9 +
 mkfs/xfs_mkfs.c          |   24 +-
 30 files changed, 1854 insertions(+), 317 deletions(-)

-- 
2.7.4

