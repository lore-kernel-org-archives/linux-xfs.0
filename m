Return-Path: <SRS0=R4OI=CF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33B11C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 00:29:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02A9A2087C
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 00:29:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WtmP8KYf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726790AbgH0A3J (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Aug 2020 20:29:09 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37586 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726753AbgH0A3J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Aug 2020 20:29:09 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07R0FgBb144946
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2020-01-29;
 bh=u57ihfld6tVjAe3xaOTVTdyw/7UWRBh6riqio+QLbyU=;
 b=WtmP8KYfdjIWfsVuwfyREkhKPvGOa9S1ZFZnPi6CJlGQGqQjXKtPHBCj4P2VE6EUA/yG
 09Y5hlG6XyFbhEtdQrYjCaxCISGBFBBj48BnSBkd2xhJHTh4KwjFaFj9qoO4w3nnlTSy
 TNuemeG20r3d0sDxRnO5nMG/VjtXOthAQ93IdIiA3aalgJR5Ovpjm6ChxoFLWGVS8Jzt
 UBCQR/9F0KG7iNuYmC1BemfAqMbqMCO8vAnJ6ZhC6QhCiTpw9U4OJfy62icJ9k5qBFHV
 X2QGf5ruzMwrLig2n3ZJW/gq3ChDlZN6p+Y5b4b4ZrN8cBHyDcAHLjr50y4ECLdJYIH6 7A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 333w6u1yve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:08 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07R0AHZ9121694
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:07 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 333rubkfx9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:07 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07R0T68c016799
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:06 GMT
Received: from localhost.localdomain (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Aug 2020 17:29:06 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v12 00/32] xfsprogs: Delayed Attributes
Date:   Wed, 26 Aug 2020 17:28:24 -0700
Message-Id: <20200827002856.1131-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 bulkscore=0 suspectscore=0 spamscore=0 mlxscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008270000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 malwarescore=0 spamscore=0
 priorityscore=1501 clxscore=1015 mlxscore=0 lowpriorityscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008270000
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This set applies the corresponding changes for delayed attributes to
xfsprogs. I will pick up the reviews from the kernel side series and mirror
them here.  This set also includes some patches from the kernel side that have
not yet been ported. This set also includes patches needed for the user space
cli and log printing routines

This series can also be viewed on github here:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_xfsprogs_v12

And also the extended delayed attribute and parent pointer series:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_xfsprogs_v12_extended

Thanks all!
Allison

Allison Collins (31):
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
  xfsprogs: Set up infastructure for deferred attribute operations
  xfsprogs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred
  xfsprogs: Add feature bit XFS_SB_FEAT_INCOMPAT_LOG_DELATTR
  xfsprogs: Enable delayed attributes
  xfs_io: Add delayed attributes error tag
  xfsprogs: Add delayed attribute flag to cmd

Allison Henderson (1):
  [RFC] xfsprogs: Add log item printing for ATTRI and ATTRD

 include/libxfs.h         |    1 +
 io/inject.c              |    1 +
 libxfs/defer_item.c      |  171 ++++++
 libxfs/libxfs_priv.h     |    1 +
 libxfs/xfs_attr.c        | 1307 ++++++++++++++++++++++++++++++++--------------
 libxfs/xfs_attr.h        |  244 +++++++++
 libxfs/xfs_attr_leaf.c   |  116 ++--
 libxfs/xfs_attr_leaf.h   |    3 +
 libxfs/xfs_attr_remote.c |  258 ++++++---
 libxfs/xfs_attr_remote.h |    8 +-
 libxfs/xfs_defer.c       |    1 +
 libxfs/xfs_defer.h       |    2 +
 libxfs/xfs_errortag.h    |    4 +-
 libxfs/xfs_format.h      |   11 +-
 libxfs/xfs_fs.h          |    1 +
 libxfs/xfs_log_format.h  |   43 +-
 libxfs/xfs_sb.c          |    2 +
 libxfs/xfs_types.h       |    1 +
 logprint/log_misc.c      |   31 +-
 logprint/log_print_all.c |   12 +
 logprint/log_redo.c      |  197 +++++++
 logprint/logprint.h      |   10 +
 mkfs/xfs_mkfs.c          |   24 +-
 23 files changed, 1920 insertions(+), 529 deletions(-)

-- 
2.7.4

