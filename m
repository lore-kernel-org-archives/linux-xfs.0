Return-Path: <SRS0=euis=5T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D373AC43331
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Apr 2020 22:10:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F16F208E4
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Apr 2020 22:10:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NoOsbjCy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727907AbgDCWKH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Apr 2020 18:10:07 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38370 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727829AbgDCWKH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Apr 2020 18:10:07 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033M91FZ019183
        for <linux-xfs@vger.kernel.org>; Fri, 3 Apr 2020 22:10:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=2otkeFdg5S/snqitTSgmNQYVJhR4Ef2wt3q/TXJrLJs=;
 b=NoOsbjCyB+q7GjS6K4G5+ar+kih/dgivAXztfyTMF0U0JcHaXIZot9xiDkA2k/mJ3i/n
 1IUtDOG1DIUbMmDtcRjzQ6YLXi7CWSZTtWCPTTNiAETYZ45CAAoJNeVs52jt800eunOa
 92AfO941PFxCj+BH0kwW0r0Pb2Lya2fGYb/IM8vusxfGxTg+D6LGyQuihgHIpjZy1ZtQ
 VQ9JKHeYKgoOPhk98YygACSM0Vk+3NzyIiRzn4ANzxZPVI9Z/eB2iabuqI9sxdmQJYOD
 2K/kjulKZDEvCyPXcdhMl/uqvSyAJrO167ExVGhDHKnVfwtEAlI6E3KzN+pONiSaDk4v Aw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 303aqj3w4a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 03 Apr 2020 22:10:06 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033M7Jav167747
        for <linux-xfs@vger.kernel.org>; Fri, 3 Apr 2020 22:10:05 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 304sju4c0b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 03 Apr 2020 22:10:05 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 033MA4OZ015866
        for <linux-xfs@vger.kernel.org>; Fri, 3 Apr 2020 22:10:04 GMT
Received: from localhost.localdomain (/67.1.1.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Apr 2020 15:10:03 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v8 00/39] xfsprogs: Delay Ready Attributes
Date:   Fri,  3 Apr 2020 15:09:19 -0700
Message-Id: <20200403220958.4944-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9580 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 phishscore=0 suspectscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9580 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 mlxlogscore=999 spamscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030171
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
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_xfsprogs_v8

And also the extended delayed attribute and parent pointer series:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_xfsprogs_v8_extended

Thanks all!
Allison

Allison Collins (39):
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
  xfsprogs: Add helper function xfs_attr_node_shrink
  xfsprogs: Removed unneeded xfs_trans_roll_inode calls
  xfsprogs: Add helpers xfs_attr_is_shortform and xfs_attr_set_shortform
  xfsprogs: Add helper function xfs_attr_leaf_mark_incomplete
  xfsprogs: Add remote block helper functions
  xfsprogs: Add helper function xfs_attr_node_removename_setup
  xfsprogs: Add helper function xfs_attr_node_removename_rmt
  xfsprogs: Add delay ready attr remove routines
  xfsprogs: Add delay ready attr set routines
  xfsprogs: Rename __xfs_attr_rmtval_remove

 db/attrset.c             |   61 +-
 include/libxfs.h         |    1 +
 libxfs/libxfs_api_defs.h |    9 +-
 libxfs/xfs_attr.c        | 1389 +++++++++++++++++++++++++++++-----------------
 libxfs/xfs_attr.h        |  169 +++---
 libxfs/xfs_attr_leaf.c   |  211 +++----
 libxfs/xfs_attr_leaf.h   |    4 +-
 libxfs/xfs_attr_remote.c |  259 ++++++---
 libxfs/xfs_attr_remote.h |    7 +-
 libxfs/xfs_da_btree.h    |    9 +-
 libxfs/xfs_da_format.h   |   12 -
 libxfs/xfs_fs.h          |   32 +-
 12 files changed, 1321 insertions(+), 842 deletions(-)

-- 
2.7.4

