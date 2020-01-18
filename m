Return-Path: <SRS0=0TO6=3H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB63DC32771
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Jan 2020 22:46:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6A06246A9
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Jan 2020 22:46:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="C90TD/n4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbgARWqO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 18 Jan 2020 17:46:14 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:50246 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726960AbgARWqN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 18 Jan 2020 17:46:13 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00IMcxQa072194
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jan 2020 22:46:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2019-08-05;
 bh=BSNzOoLC1petU0NoTiKYr4jdzAmMz0LKP71SIoSNTLY=;
 b=C90TD/n4TH7nU1pgc6rXSZfh7GkPQL3jjetmQ80ebdHVVTv/i3KBb/tvQUO3FSFN7Pj7
 be0/tJIC1MsER3btnIMleucUefZyL9bTar8hIe1mjznjPRnvsZ6H1orjowMNbhRU2f3A
 62AcrIcl9006bBxRyCjcnNVYxMW8pksnRw7cFT4d4JnjYmL82mdapq0Ewny4QS35Makx
 6PzTwwTPaICSVihx/Qjw1RMtAx8poXG9Zsg6xzmLE+sB2wjjl+pBwll9fUs08GoYk5nu
 2BTmferYfWKMsZmOXsx6KX6exJJ1y2bWeeJuNZybc2za1hnqhgdPyABc5YmvPdvtsnqT sQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2xktnqsvtn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jan 2020 22:46:11 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00IMcqOj125861
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jan 2020 22:46:11 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2xkr2danky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jan 2020 22:46:11 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00IMkAsT028985
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jan 2020 22:46:10 GMT
Received: from localhost.localdomain (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 18 Jan 2020 14:46:10 -0800
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v6 00/17] xfsprogs: Delayed Ready Attributes
Date:   Sat, 18 Jan 2020 15:45:41 -0700
Message-Id: <20200118224558.19382-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9504 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=930
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001180185
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9504 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=991 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001180185
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
  xfsprogs: Add xfs_has_attr and subroutines
  xfsprogs: Factor out new helper functions xfs_attr_rmtval_set
  xfsprogs: Factor out trans handling in xfs_attr3_leaf_flipflags
  xfsprogs: Factor out xfs_attr_leaf_addname helper
  xfsprogs: Refactor xfs_attr_try_sf_addname
  xfsprogs: Factor out trans roll from xfs_attr3_leaf_setflag
  xfsprogs: Factor out xfs_attr_rmtval_invalidate
  xfsprogs: Factor out trans roll in xfs_attr3_leaf_clearflag
  xfsprogs: Check for -ENOATTR or -EEXIST
  xfsprogs: Add helper function xfs_attr_init_unmapstate
  xfsprogs: Add helper function xfs_attr_rmtval_unmap
  xfsprogs: Simplify xfs_attr_set_args
  xfsprogs: Add delay ready attr remove routines
  xfsprogs: Add delay ready attr set routines

 db/attrset.c             |  11 +-
 libxfs/libxfs_priv.h     |  11 +-
 libxfs/xfs_attr.c        | 859 ++++++++++++++++++++++++++++++++---------------
 libxfs/xfs_attr.h        |   9 +-
 libxfs/xfs_attr_leaf.c   | 222 ++++++------
 libxfs/xfs_attr_leaf.h   |   3 +
 libxfs/xfs_attr_remote.c | 265 +++++++++++----
 libxfs/xfs_attr_remote.h |   7 +-
 libxfs/xfs_da_btree.c    |   6 +-
 libxfs/xfs_da_btree.h    |  41 ++-
 libxfs/xfs_dir2.c        |  18 +-
 libxfs/xfs_dir2_block.c  |   6 +-
 libxfs/xfs_dir2_leaf.c   |   6 +-
 libxfs/xfs_dir2_node.c   |   8 +-
 libxfs/xfs_dir2_sf.c     |  30 +-
 libxfs/xfs_types.c       |  11 +
 libxfs/xfs_types.h       |   1 +
 17 files changed, 1033 insertions(+), 481 deletions(-)

-- 
2.7.4

