Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B3EBFC6198
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 01:29:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63937217D7
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 01:29:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Dkaq8S9P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732817AbfKGB3x (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Nov 2019 20:29:53 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:38284 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727798AbfKGB3x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Nov 2019 20:29:53 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA71TqSD180843
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 01:29:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2019-08-05;
 bh=GpgpKLtP3L76e6SKB4iHHWY3WBvRtRkvLrblrrvkazQ=;
 b=Dkaq8S9PcTSJSk41r7DHozn8jGuOF1KqUJPlySUD7mtMg+cX6eJkCVnZoqsXXyDAlJmg
 Be0wVgLMN5g9NMGGHECOJZjLlnjqBPdbJd2b1KGIQEYp+TXvmXPC3T62uH8ZkLv3TAxi
 ukaj6KJbPxrnc0ioM/InYtl1ftG2gDYYTFuq66Fce8nCptSKqrVHeO5U1pKtijfRRFLv
 kdP76fsGFHWXr1s+/C12MmATkiv4d3tX9XMRR6h62FQWUyUfXi2e0Rp3+1DvTfkTzPhW
 0Fi9gj9iPe57H0NPGCEOHlqJvSa2DU6YAoImS0Ux/0UHvdjAZNIr4f4f3YS+1/hacHzO Iw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2w41w12pxj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 01:29:51 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA71T0Vl008587
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 01:29:51 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2w41wdmumx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 01:29:51 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA71ToEP009813
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 01:29:50 GMT
Received: from localhost.localdomain (/67.1.205.161)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 17:29:50 -0800
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 00/17] xfsprogs: Delayed Ready Attributes
Date:   Wed,  6 Nov 2019 18:29:28 -0700
Message-Id: <20191107012945.22941-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=900
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911070014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=993 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911070014
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This set applies the corresponding changes for delayed ready attributes to
xfsprogs. I will pick up the reviews from the kernel side series and mirror
them here.  

Thanks all!
Allison

Allison Collins (17):
  xfsprogs: Remove all strlen in all xfs_attr_* functions for attr
    names.
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
  xfsprogs: Check for -ENOATTR or -EEXIST
  xfsprogs: Add delay ready attr remove routines
  xfsprogs: Add delay ready attr set routines

 db/attrset.c             |  12 +-
 libxfs/libxfs_priv.h     |  11 +-
 libxfs/xfs_attr.c        | 777 ++++++++++++++++++++++++++++++-----------------
 libxfs/xfs_attr.h        |   9 +-
 libxfs/xfs_attr_leaf.c   | 335 +++++++++++++-------
 libxfs/xfs_attr_leaf.h   |   7 +
 libxfs/xfs_attr_remote.c | 103 +++++--
 libxfs/xfs_attr_remote.h |   4 +-
 libxfs/xfs_da_btree.c    |  55 ++--
 libxfs/xfs_da_btree.h    |  32 +-
 libxfs/xfs_dir2.c        |  18 +-
 libxfs/xfs_dir2_block.c  |  12 +-
 libxfs/xfs_dir2_data.c   |   3 +-
 libxfs/xfs_dir2_leaf.c   |  15 +-
 libxfs/xfs_dir2_node.c   |  18 +-
 libxfs/xfs_dir2_sf.c     |  30 +-
 16 files changed, 940 insertions(+), 501 deletions(-)

-- 
2.7.4

