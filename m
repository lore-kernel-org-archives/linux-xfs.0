Return-Path: <SRS0=wjSb=4L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10765C35669
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 02:06:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D315A208C4
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 02:06:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TRj69qvd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbgBWCGE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 22 Feb 2020 21:06:04 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:56180 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727024AbgBWCGE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 22 Feb 2020 21:06:04 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01N25DrU010941
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=f/P8CUdyesReCWhyBGBs+a116kNq56q+7mAWre55LCg=;
 b=TRj69qvdML4YMl4tQoylFLEB9hyajDzLm225y3daQ4AJMOAtNf1cwj7d6RAv6KC03pDW
 i6/NUJmPEePze2lc9TG/rDIe/qeLZbyJnlCwDA6kx74o08gaR/I1iOpt0o8de0uv6yjO
 kha1lIfw0dObUQ1LTFIAkNiXlCBXluOdUIgAtsNTmc2DYAp3TVcYOtThu8+eIHeUModt
 oz+DS6ASRjndKIdb/5dCjqG1ppcujR9+qLcV5Rq8bW1IK10Gti9FLSNF45Zril/07gUs
 /TFzcp/aUul8z9iGAWLqrQx9sjPazyLA4+6QNnm/ObXQl8U8LyCJKA3DoRRjvxPCG6gl lw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2yav8qa0s9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:02 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01N1w4ZT054030
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:01 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2ybe38mcsm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:01 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01N25xmm004454
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:00 GMT
Received: from localhost.localdomain (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 23 Feb 2020 02:05:59 +0000
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v7 00/20] xfsprogs: Delayed Ready Attributes
Date:   Sat, 22 Feb 2020 19:05:34 -0700
Message-Id: <20200223020554.1731-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9539 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002230014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9539 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 impostorscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 priorityscore=1501 spamscore=0
 phishscore=0 malwarescore=0 mlxscore=0 clxscore=1015 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002230014
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This set applies the corresponding changes for delayed ready attributes to
xfsprogs. I will pick up the reviews from the kernel side series and mirror
them here.  

This series can also be viewed on github here:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_xfsprogs_v7

And also the extended delayed attribute and parent pointer series:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_xfsprogs_v7_extended

Thanks all!
Allison

Allison Collins (20):
  xfsprogs: Remove all strlen in all xfs_attr_* functions for attr
    names.
  xfsprogs: Replace attribute parameters with struct xfs_name
  xfsprogs: Embed struct xfs_name in xfs_da_args
  xfsprogs: Add xfs_has_attr and subroutines
  xfsprogs: Check for -ENOATTR or -EEXIST
  xfsprogs: Factor out new helper functions xfs_attr_rmtval_set
  xfsprogs: Factor out trans handling in xfs_attr3_leaf_flipflags
  xfsprogs: Factor out xfs_attr_leaf_addname helper
  xfsprogs: Refactor xfs_attr_try_sf_addname
  xfsprogs: Factor out trans roll from xfs_attr3_leaf_setflag
  xfsprogs: Factor out xfs_attr_rmtval_invalidate
  xfsprogs: Factor out trans roll in xfs_attr3_leaf_clearflag
  xfsprogs: Add helper function xfs_attr_rmtval_unmap
  xfsprogs: Add delay ready attr remove routines
  xfsprogs: Add delay ready attr set routines
  xfsprogs: Add helper function xfs_attr_node_shrink
  xfsprogs: Simplify xfs_attr_set_iter
  xfsprogs: Add helper function xfs_attr_leaf_mark_incomplete
  xfsprogs: Add remote block helper functions
  xfsprogs: Remove xfs_attr_rmtval_remove

 db/attrset.c             |  11 +-
 libxfs/libxfs_priv.h     |  11 +-
 libxfs/xfs_attr.c        | 938 +++++++++++++++++++++++++++++++++--------------
 libxfs/xfs_attr.h        |   9 +-
 libxfs/xfs_attr_leaf.c   | 222 ++++++-----
 libxfs/xfs_attr_leaf.h   |   3 +
 libxfs/xfs_attr_remote.c | 260 +++++++++----
 libxfs/xfs_attr_remote.h |   7 +-
 libxfs/xfs_da_btree.c    |   6 +-
 libxfs/xfs_da_btree.h    |  47 ++-
 libxfs/xfs_dir2.c        |  18 +-
 libxfs/xfs_dir2_block.c  |   6 +-
 libxfs/xfs_dir2_leaf.c   |   6 +-
 libxfs/xfs_dir2_node.c   |   8 +-
 libxfs/xfs_dir2_sf.c     |  30 +-
 libxfs/xfs_types.c       |  11 +
 libxfs/xfs_types.h       |   1 +
 17 files changed, 1077 insertions(+), 517 deletions(-)

-- 
2.7.4

