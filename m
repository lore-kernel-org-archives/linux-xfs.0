Return-Path: <SRS0=IYU2=A5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37EF9C433E1
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Jul 2020 04:35:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D4D72076D
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Jul 2020 04:35:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Q+Qoh8/+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725868AbgGREfx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 18 Jul 2020 00:35:53 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60400 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbgGREfx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 18 Jul 2020 00:35:53 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06I4ZqsP075499
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jul 2020 04:35:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2020-01-29;
 bh=HVXc4pJ7tMXoWpK3w7tP3bbkGGKd0JWv1uhqpDfK/wM=;
 b=Q+Qoh8/+kYuIc52Zm+96yiQ5NlAF3VLia+oCPe1h28FTtnktrwWz0YVNSF727rxXfGlp
 t95+KxWU+6f3GAZY7uzkHt5mQWkFl79sNt+YaLXtDXwyhaa5KHHIT3pwOYz9Jf1v6n5k
 55gKcw9TcQDx3GLFi04OuXVSGnwYOYf3TvqNns06XuLth8nkQcQ9ubo/OOAzlhWe6jsN
 YEHctifx0fd6eSAq8zT8i14Cry0o+OMm4NLMrGCSMye2N8mkk+9WsJeEirDJAPa34iEB
 g5UfVRAE+XAHSHzTa/S7KXEuFqQ7GrN4uxvSZ9olPDeRak4W3xHeXWw+tw3Gi3N1r+/a 7g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 32brgr05gr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jul 2020 04:35:52 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06I4XlBX169288
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jul 2020 04:33:51 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 32brw1w76u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jul 2020 04:33:51 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06I4Xo6k003162
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jul 2020 04:33:50 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 17 Jul 2020 21:33:50 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v11 00/26] xfsprogs: Delay Ready Attributes
Date:   Fri, 17 Jul 2020 21:33:16 -0700
Message-Id: <20200718043342.6432-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9685 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 malwarescore=0 adultscore=0 spamscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007180030
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9685 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 impostorscore=0 suspectscore=0 adultscore=0 clxscore=1015 mlxlogscore=999
 priorityscore=1501 phishscore=0 lowpriorityscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007180030
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
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_xfsprogs_v11

And also the extended delayed attribute and parent pointer series:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_xfsprogs_v11_extended

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
  xfs: random buffer write failure errortag

 include/libxfs.h         |    1 +
 io/inject.c              |    1 +
 libxfs/xfs_attr.c        | 1197 +++++++++++++++++++++++++++++++---------------
 libxfs/xfs_attr.h        |  198 ++++++++
 libxfs/xfs_attr_leaf.c   |  116 +++--
 libxfs/xfs_attr_leaf.h   |    3 +
 libxfs/xfs_attr_remote.c |  258 +++++++---
 libxfs/xfs_attr_remote.h |    8 +-
 libxfs/xfs_errortag.h    |    4 +-
 9 files changed, 1265 insertions(+), 521 deletions(-)

-- 
2.7.4

