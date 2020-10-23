Return-Path: <SRS0=+s6N=D6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9A80C388F9
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Oct 2020 06:33:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76B4322253
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Oct 2020 06:33:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="I7MJcqPV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S372783AbgJWGdT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Oct 2020 02:33:19 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:41396 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S372779AbgJWGdT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Oct 2020 02:33:19 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09N6OwQH106676
        for <linux-xfs@vger.kernel.org>; Fri, 23 Oct 2020 06:33:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2020-01-29;
 bh=4dN7iVTkp2dsBU165RIXuDkL3vLXuuYjAKHa1Nswyxk=;
 b=I7MJcqPVy6pf6KbyYeRUwyc631Byb+VFNjJC1R5HpFQg9AzUdvtDYg40/XUbATC67AmM
 SoaQiwI3r1eJ+jQYboSsEGmhQiKmLUeuccPdo13V8Hln5vyXUgG83bcwCShUJBWSR5vX
 T66ZF9KCpgVd96VdQq2pa6p9UPtdvdW3/XHb1LF4ZqxaJidahf9MUnnO8WRQgo9B51/Y
 F6l9FvRUg3wuL5YIAkI0TzMSd25dxwIt3W0K+peun81bY7LtRteqSd2ZV+GnpTr9XWQ4
 ejyS6jzg6GvbeqgNr9OFDqfXcXYiBg0v2smJtoccYqqxubv5P+gcObKVasPIcnHaZpRo qA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 349jrq1epw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 23 Oct 2020 06:33:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09N6Q2UH123374
        for <linux-xfs@vger.kernel.org>; Fri, 23 Oct 2020 06:33:17 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 34ak1aqy89-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 23 Oct 2020 06:33:17 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09N6XGNv027434
        for <linux-xfs@vger.kernel.org>; Fri, 23 Oct 2020 06:33:16 GMT
Received: from localhost.localdomain (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 22 Oct 2020 23:33:16 -0700
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v13 00/14] xfsprogs: Delayed Attributes
Date:   Thu, 22 Oct 2020 23:32:52 -0700
Message-Id: <20201023063306.7441-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9782 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010230045
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9782 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 suspectscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010230045
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
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_xfsprogs_v13

And also the extended delayed attribute and parent pointer series:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_xfsprogs_v13_extended

Thanks all!
Allison

Allison Collins (7):
  xfsprogs: Add helper xfs_attr_node_remove_step
  xfsprogs: Rename __xfs_attr_rmtval_remove
  xfsprogs: Set up infastructure for deferred attribute operations
  xfsprogs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred
  xfsprogs: Enable delayed attributes
  xfs_io: Add delayed attributes error tag
  xfsprogs: Add delayed attribute flag to cmd

Allison Henderson (5):
  xfsprogs: Add delay ready attr remove routines
  xfsprogs: Add delay ready attr set routines
  xfsprogs: Add feature bit XFS_SB_FEAT_INCOMPAT_LOG_DELATTR
  xfsprogs: Remove unused xfs_attr_*_args
  [RFC] xfsprogs: Add log item printing for ATTRI and ATTRD

Darrick J. Wong (2):
  xfs: store inode btree block counts in AGI header
  xfs: enable new inode btree counters feature

 include/libxfs.h          |   1 +
 io/inject.c               |   1 +
 libxfs/defer_item.c       | 132 +++++++++++
 libxfs/libxfs_priv.h      |   1 +
 libxfs/xfs_ag.c           |   5 +
 libxfs/xfs_attr.c         | 547 +++++++++++++++++++++++++++++++---------------
 libxfs/xfs_attr.h         | 219 ++++++++++++++++++-
 libxfs/xfs_attr_leaf.c    |   2 +-
 libxfs/xfs_attr_remote.c  | 114 ++++++----
 libxfs/xfs_attr_remote.h  |   7 +-
 libxfs/xfs_defer.c        |   1 +
 libxfs/xfs_defer.h        |   2 +
 libxfs/xfs_errortag.h     |   4 +-
 libxfs/xfs_format.h       |  32 ++-
 libxfs/xfs_fs.h           |   1 +
 libxfs/xfs_ialloc.c       |   1 +
 libxfs/xfs_ialloc_btree.c |  21 ++
 libxfs/xfs_log_format.h   |  43 +++-
 libxfs/xfs_sb.c           |   2 +
 libxfs/xfs_types.h        |   1 +
 logprint/log_misc.c       |  31 ++-
 logprint/log_print_all.c  |  12 +
 logprint/log_redo.c       | 197 +++++++++++++++++
 logprint/logprint.h       |  10 +
 mkfs/xfs_mkfs.c           |  24 +-
 25 files changed, 1179 insertions(+), 232 deletions(-)

-- 
2.7.4

