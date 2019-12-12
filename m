Return-Path: <SRS0=0MSb=2C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0702BC43603
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Dec 2019 04:18:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB799206C3
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Dec 2019 04:18:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QqZPLBPJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727864AbfLLESK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Dec 2019 23:18:10 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:45072 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727507AbfLLESK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Dec 2019 23:18:10 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBC4EZZe128970
        for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2019 04:18:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2019-08-05;
 bh=HvJZLvr5crKOkQIlANZJyNq2hidP5cKM6Q83C39KDqM=;
 b=QqZPLBPJYJSB3KMz05U4Up41zz2hZFgdI6gVveR7VCAqie+sZhfbtfJd02Kj+NU2wXFo
 I/URDcc/aZKlydBCC2Ob18UX+6j7fmtxvV27V1godjRA6cpwd9jxNdwmEoCd80rHOIMu
 73IbwYYsJCr+xxxM/5LKCzcPlkWkbBCIWLKrSDRqNRw/l4UdvDlKvzHh/EBdIGqfRvqN
 6M3YGcY0OGD1Pj5XrKzcLXW9Tq/rjtKgdf96FSnc5rS4fHAjS09IH+ZYya0lj+lPhLJs
 m0pI0VYWlEZGQ0qCzBg1gcReGYITwd4Fsznrviwt00jQTvf6Trjajh9HC1mkcRhfeCT1 vA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2wr4qrre5w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2019 04:18:08 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBC4E7aV128217
        for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2019 04:18:07 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2wu5cs3h14-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2019 04:18:07 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBC4I7KB018535
        for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2019 04:18:07 GMT
Received: from localhost.localdomain (/67.1.205.161)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 11 Dec 2019 20:18:07 -0800
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 00/14] xfsprogs: Delayed Ready Attributes
Date:   Wed, 11 Dec 2019 21:17:49 -0700
Message-Id: <20191212041803.14018-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9468 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=820
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912120022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9468 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=895 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912120022
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This set applies the corresponding changes for delayed ready attributes to
xfsprogs. I will pick up the reviews from the kernel side series and mirror
them here.  

Thanks all!
Allison

Allison Collins (14):
  xfsprogs: Remove all strlen in all xfs_attr_* functions for attr
    names.
  xfsprogs: Replace attribute parameters with struct xfs_name
  xfsprogs: Embed struct xfs_name in xfs_da_args
  xfsprogs: Add xfs_has_attr and subroutines
  xfsprogs: Factor out new helper functions xfs_attr_rmtval_set
  xfsprogs: Factor up trans handling in xfs_attr3_leaf_flipflags
  xfsprogs: Factor out xfs_attr_leaf_addname helper
  xfsprogs: Factor up xfs_attr_try_sf_addname
  xfsprogs: Factor up trans roll from xfs_attr3_leaf_setflag
  xfsprogs: Factor out xfs_attr_rmtval_invalidate
  xfsprogs: Factor up trans roll in xfs_attr3_leaf_clearflag
  xfsprogs: Check for -ENOATTR or -EEXIST
  xfsprogs: Add delay ready attr remove routines
  xfsprogs: Add delay ready attr set routines

 db/attrset.c             |  12 +-
 libxfs/libxfs_priv.h     |  11 +-
 libxfs/xfs_attr.c        | 804 +++++++++++++++++++++++++++++++++--------------
 libxfs/xfs_attr.h        |   9 +-
 libxfs/xfs_attr_leaf.c   | 219 +++++++------
 libxfs/xfs_attr_leaf.h   |   3 +
 libxfs/xfs_attr_remote.c | 103 ++++--
 libxfs/xfs_attr_remote.h |   4 +-
 libxfs/xfs_da_btree.c    |   6 +-
 libxfs/xfs_da_btree.h    |  33 +-
 libxfs/xfs_dir2.c        |  18 +-
 libxfs/xfs_dir2_block.c  |   6 +-
 libxfs/xfs_dir2_leaf.c   |   6 +-
 libxfs/xfs_dir2_node.c   |   8 +-
 libxfs/xfs_dir2_sf.c     |  30 +-
 libxfs/xfs_types.c       |  10 +
 libxfs/xfs_types.h       |   1 +
 17 files changed, 861 insertions(+), 422 deletions(-)

-- 
2.7.4

