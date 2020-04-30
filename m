Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DE92C4724C
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 22:47:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F11620774
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 22:47:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PG+TGR6m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbgD3WrJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Apr 2020 18:47:09 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48368 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726784AbgD3WrH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Apr 2020 18:47:07 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UMhNBX047342
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=p52fkTygRwBbegWKK/2yBceS1c6Adp5pxzT7YrbwB3Y=;
 b=PG+TGR6mrFZC5xKnFp6BpjHd8/gtaO0t/CInWxfs4ZmirSYfCX2Eqwd51Jj6L6BOsG+E
 f/K9Fq1dNvapM8j7bzpV6Hm81PpRkGlWBE7pClYSzNTEJZflq+IbgIiDfhH5cWasXJyK
 yRc4yw3Qnh6IcyUF4ZVzBb/isfAoHKsWUogvMqBKCBjKiy8SOTQErE3ZSX5ejt7tA8jf
 7ZOZezYjkelGm7avBB95Wu2hJqFyUtp6V4osC7FGz/sa7NpoRntz1G34HiX5SYTY6nV/
 zFDPNVPSBpn/Qrc0hmlItSVDBEb7RBZG2P0E+aqoPg4LW4gyRD+6hGI9Qg8twKFvJaMw RQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 30r7f5r269-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:06 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UMhP7f181146
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:05 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 30r7fes26a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:05 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03UMl5Tv012786
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:05 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Apr 2020 15:47:04 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v9 00/43] xfsprogs: Delay Ready Attributes
Date:   Thu, 30 Apr 2020 15:46:17 -0700
Message-Id: <20200430224700.4183-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300167
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 adultscore=0 mlxlogscore=999
 clxscore=1015 phishscore=0 impostorscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300167
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
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_xfsprogs_v9

And also the extended delayed attribute and parent pointer series:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_xfsprogs_v9_extended

Thanks all!
Allison

Allison Collins (43):
  xfsprogs: remove the ATTR_INCOMPLETE flag
  xfsprogs: merge xfs_attr_remove into xfs_attr_set
  xfsprogs: remove the name == NULL check from xfs_attr_args_init
  xfsprogs: remove the MAXNAMELEN check from xfs_attr_args_init
  xfsprogs: turn xfs_da_args.value into a void pointer
  xfsprogs: pass an initialized xfs_da_args structure to xfs_attr_set
  xfsprogs: pass an initialized xfs_da_args to xfs_attr_get
  xfsprogs: remove the xfs_inode argument to xfs_attr_get_ilocked
  xfsprogs: remove ATTR_KERNOVAL
  xfsprogs: remove ATTR_ALLOC and XFS_DA_OP_ALLOCVAL
  xfsprogs: replace ATTR_KERNOTIME with XFS_DA_OP_NOTIME
  xfsprogs: factor out a xfs_attr_match helper
  xfsprogs: cleanup struct xfs_attr_list_context
  xfsprogs: remove the unused ATTR_ENTRY macro
  xfsprogs: move the legacy xfs_attr_list to xfs_ioctl.c
  xfsprogs: rename xfs_attr_list_int to xfs_attr_list
  xfsprogs: clean up the ATTR_REPLACE checks
  xfsprogs: clean up the attr flag confusion
  xfsprogs: embedded the attrlist cursor into struct
    xfs_attr_list_context
  xfsprogs: Add xfs_has_attr and subroutines
  xfsprogs: Check for -ENOATTR or -EEXIST
  xfsprogs: Factor out new helper functions xfs_attr_rmtval_set
  xfsprogs: Pull up trans handling in xfs_attr3_leaf_flipflags
  xfsprogs: Split apart xfs_attr_leaf_addname
  xfsprogs: Refactor xfs_attr_try_sf_addname
  xfsprogs: Pull up trans roll from xfs_attr3_leaf_setflag
  xfsprogs: Factor out xfs_attr_rmtval_invalidate
  xfsprogs: Pull up trans roll in xfs_attr3_leaf_clearflag
  xfsprogs: Add helper function __xfs_attr_rmtval_remove
  xfsprogs: Pull up xfs_attr_rmtval_invalidate
  xfsprogs: Add helper function xfs_attr_node_shrink
  xfsprogs: Remove unneeded xfs_trans_roll_inode calls
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

 db/attrset.c             |   61 +-
 include/libxfs.h         |    1 +
 libxfs/libxfs_api_defs.h |    9 +-
 libxfs/xfs_attr.c        | 1518 +++++++++++++++++++++++++++-------------------
 libxfs/xfs_attr.h        |  313 +++++++---
 libxfs/xfs_attr_leaf.c   |  212 +++----
 libxfs/xfs_attr_leaf.h   |    4 +-
 libxfs/xfs_attr_remote.c |  261 +++++---
 libxfs/xfs_attr_remote.h |    8 +-
 libxfs/xfs_da_btree.h    |    9 +-
 libxfs/xfs_da_format.h   |   12 -
 libxfs/xfs_fs.h          |   32 +-
 12 files changed, 1511 insertions(+), 929 deletions(-)

-- 
2.7.4

