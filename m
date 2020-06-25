Return-Path: <SRS0=UnAH=AG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B8A8C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 23:31:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78D0B20885
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 23:31:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ugSSNC9Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728681AbgFYXbA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Jun 2020 19:31:00 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:54398 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728275AbgFYXa7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jun 2020 19:30:59 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05PNQl0P037988
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:30:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2020-01-29;
 bh=JeM/USQL3XOntguJmE+yZPyXrwAlfJfC0FBH4T/qS8E=;
 b=ugSSNC9YznZn1sCymL3TqG2f6YicK+bfkqHijJJ4pqhYpUS2LieMUEKLkkO50T5h3Rzb
 SbIxAgCvUQ7ZmCenHW9IGkNJPoZxQxjock4WIGz0Ekk6rqoKH/M3UxtOgQEdoo+e+3ZV
 BWX1fMONFn58GsGHZHzQqNGOAqZLMIRU7KlRgazvZ9HT/bzhiI2y0PmsTGFo0w6MbsOx
 BycG7LGKQ2JQod5c7VFabv3PuFVb3t4uznvhIznnzzDCb2XtPJ+2SJKsc68UBwJSeB+z
 kb+at90HfMe93N05fVrFt8SDMamTqeNVGvXfN2KQZmKxJ4s58HsdAU0tFasSgkDdY3N9 iw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 31uut5u9xt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:30:58 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05PNSI7c110943
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:28:58 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 31uur9r3be-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:28:58 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05PNSv0P016761
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:28:57 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 25 Jun 2020 23:28:57 +0000
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v10 00/26] Delay Ready Attributes
Date:   Thu, 25 Jun 2020 16:28:22 -0700
Message-Id: <20200625232848.14465-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9663 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006250136
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9663 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 clxscore=1015
 lowpriorityscore=0 bulkscore=0 adultscore=0 spamscore=0 suspectscore=0
 phishscore=0 impostorscore=0 cotscore=-2147483648 priorityscore=1501
 mlxscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006250136
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This set applies the corresponding changes for delayed ready attributes to
xfsprogs. I will pick up the reviews from the kernel side series and mirror
them here.  This set also includes some patches from the kernel side that have
not yet been ported.  They are not part of the delayed ready attr set, but
they are required in order for the kernel side ports to seat correctly.

This series can also be viewed on github here:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_xfsprogs_v10

And also the extended delayed attribute and parent pointer series:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_xfsprogs_v10_extended

Thanks all!
Allison

Allison Collins (25):
  xfsprogs: Add xfs_has_attr and subroutines
  xfsprogs: Check for -ENOATTR or -EEXIST
  xfsprogs: Factor out new helper functions xfs_attr_rmtval_set
  xfsprogs: Pull up trans handling in xfs_attr3_leaf_flipflags
  xfsprogs: Split apart xfs_attr_leaf_addname
  xfsprogs: Refactor xfs_attr_try_sf_addname
  xfsprogs: Pull up trans roll from xfs_attr3_leaf_setflag
  xfsprogs: Factor out xfs_attr_rmtval_invalidate
  xfsprogs: Pull up trans roll in xfs_attr3_leaf_clearflag
  xfsprogs: Refactor xfs_attr_rmtval_remove
  xfsprogs: Pull up xfs_attr_rmtval_invalidate
  xfsprogs: Add helper function xfs_attr_node_shrink
  xfsprogs: Remove unneeded xfs_trans_roll_inode calls
  xfsprogs: Remove xfs_trans_roll in xfs_attr_node_removename
  xfsprogs: Add helpers xfs_attr_is_shortform and xfs_attr_set_shortform
  xfsprogs: Add helper function xfs_attr_leaf_mark_incomplete
  xfsprogs: Add remote block helper functions
  xfsprogs: Add helper function xfs_attr_node_removename_setup
  xfsprogs: Add helper function xfs_attr_node_removename_rmt
  xfsprogs: Simplify xfs_attr_leaf_addname
  xfsprogs: Simplify xfs_attr_node_addname
  xfsprogs: Lift -ENOSPC handler from xfs_attr_leaf_addname
  xfsprogs: Add delay ready attr remove routines
  xfsprogs: Add delay ready attr set routines
  xfsprogs: Rename __xfs_attr_rmtval_remove

Brian Foster (1):
  xfsprogs: random buffer write failure errortag

 include/libxfs.h         |    1 +
 io/inject.c              |    1 +
 libxfs/xfs_attr.c        | 1191 ++++++++++++++++++++++++++++++----------------
 libxfs/xfs_attr.h        |  198 ++++++++
 libxfs/xfs_attr_leaf.c   |  116 +++--
 libxfs/xfs_attr_leaf.h   |    3 +
 libxfs/xfs_attr_remote.c |  258 +++++++---
 libxfs/xfs_attr_remote.h |    8 +-
 libxfs/xfs_errortag.h    |    4 +-
 9 files changed, 1256 insertions(+), 524 deletions(-)

-- 
2.7.4

