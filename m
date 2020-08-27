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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18F93C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 00:35:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4DF9208E4
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 00:35:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PzywKbBi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbgH0Af2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Aug 2020 20:35:28 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40804 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbgH0Af1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Aug 2020 20:35:27 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07R0TJi5165404
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:35:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2020-01-29;
 bh=8BMIWpTXNmvSLlkbWleGf7ITJox3n2zcyJr/BeEn0ZI=;
 b=PzywKbBiZFKhjpCYAJEZwZQ/fN1vIoa1/N5aNX4mDEelNIx7Z6QFfCFkC8txx97QtXfg
 KzCP2aPdXfCDa7TLcvso/S3TL7yMUO0tFbeIRU1WOvhGpw0dBBaRWNNo31ebq+Vg6edb
 oHeu+GgMvVWnZt3CQ2iHOu+/r9L+AKcuqSbc/GznxzHHu95v6iYm/z4iRtjw/D6y9xWz
 vAfm0pYT0MhWDNV/wmNv5e3AxQCkw0qrkvvaFcrW8J+fGKJ4WJxN+r1etdAvLGoXfZVs
 hFgd3dWRhc7Y+ft9pKb4B9xwUX9tjZUs+x/Uo1dhOEbOisiSipz0P9G9vJpQpQbTt7hg dw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 333w6u20a1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:35:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07R0VNVX081244
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:35:25 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 333r9mk9r6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:35:25 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07R0ZOxa027611
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:35:24 GMT
Received: from localhost.localdomain (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Aug 2020 17:35:24 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v12 0/8] xfs: Delayed Attributes
Date:   Wed, 26 Aug 2020 17:35:10 -0700
Message-Id: <20200827003518.1231-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008270001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 malwarescore=0 spamscore=0
 priorityscore=1501 clxscore=1015 mlxscore=0 lowpriorityscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008270001
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This set is a subset of a larger series for parent pointers. Delayed attributes
allow attribute operations (set and remove) to be logged and committed in the same
way that other delayed operations do. This allows more complex operations (like
parent pointers) to be broken up into multiple smaller transactions. To do
this, the existing attr operations must be modified to operate as either a
delayed operation or a inline operation since older filesystems will not be
able to use the new log entries.  This means that they cannot roll, commit, or
finish transactions.  Instead, they return -EAGAIN to allow the calling
function to handle the transaction. In this series, we focus on only the clean
up and refactoring needed to accomplish this. We will introduce delayed attrs
and parent pointers in a later set.

At the moment, I would like people to focus their review efforts on just this
"delayed attribute" sub series, as I think that is a more conservative use of peoples
review time.  I also think the set is a bit much to manage all at once, and we
need to get the infrastructure ironed out before we focus too much anything
that depends on it. But I do have the extended series for folks that want to
see the bigger picture of where this is going.

To help organize the set, I've arranged the patches to make sort of mini sets.
I thought it would help reviewers break down the reviewing some. For reviewing
purposes, the set could be broken up into 2 phases:


Delay Ready Attributes: (patches 1-3)
These are the remaining patches belonging to the "Delay Ready" series that
we've been working with.  In these patches, transaction handling is removed
from the attr routines, and replaced with a state machine that allows a high
level function to roll the transaction and repeatedly recall the attr routines
until they are finished.  The behavior of the attr set/remove routines
are now also compatible as a .finish_item callback
  xfs: Add delay ready attr remove routines
  xfs: Add delay ready attr set routines
  xfs: Rename __xfs_attr_rmtval_remove

Delayed Attributes: (patches 4 - 8)
These patches go on to fully implement delayed attributes.  New attr intent and
done items are introduced for use in the existing logging infrastructure.  A
feature bit is added to toggle the feature on and off, and an error tag is added
to test the log replay
  xfs: Set up infastructure for deferred attribute operations
  xfs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred
  xfs: Add feature bit XFS_SB_FEAT_INCOMPAT_LOG_DELATTR
  xfs: Enable delayed attributes
  xfs_io: Add delayed attributes error tag

This series can be viewed on github here:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_v12

As well as the extended delayed attribute and parent pointer series:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_v12_extended

And the test cases:
https://github.com/allisonhenderson/xfs_work/tree/pptr_xfstests

In order to run the test cases, you will need have the corresponding xfsprogs
changes as well.  Which can be found here:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_xfsprogs_v12
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_xfsprogs_v12_extended

To run the xfs attributes tests run:
check -g attr

To run as delayed attributes run:
export MKFS_OPTIONS="-n delattr"
check -g attr

To run parent pointer tests:
check -g parent

I've also made the corresponding updates to the user space side as well, and ported anything
they need to seat correctly.

Questions, comment and feedback appreciated! 

Thanks all!
Allison 


Allison Collins (8):
  xfs: Add delay ready attr remove routines
  xfs: Add delay ready attr set routines
  xfs: Rename __xfs_attr_rmtval_remove
  xfs: Set up infastructure for deferred attribute operations
  xfs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred
  xfs: Add feature bit XFS_SB_FEAT_INCOMPAT_LOG_DELATTR
  xfs: Enable delayed attributes
  xfs_io: Add delayed attributes error tag

 fs/xfs/Makefile                 |   1 +
 fs/xfs/libxfs/xfs_attr.c        | 638 ++++++++++++++++++++++--------
 fs/xfs/libxfs/xfs_attr.h        | 243 ++++++++++++
 fs/xfs/libxfs/xfs_attr_leaf.c   |   2 +-
 fs/xfs/libxfs/xfs_attr_remote.c | 114 ++++--
 fs/xfs/libxfs/xfs_attr_remote.h |   7 +-
 fs/xfs/libxfs/xfs_defer.c       |   1 +
 fs/xfs/libxfs/xfs_defer.h       |   3 +
 fs/xfs/libxfs/xfs_errortag.h    |   4 +-
 fs/xfs/libxfs/xfs_format.h      |  11 +-
 fs/xfs/libxfs/xfs_fs.h          |   1 +
 fs/xfs/libxfs/xfs_log_format.h  |  44 ++-
 fs/xfs/libxfs/xfs_log_recover.h |   2 +
 fs/xfs/libxfs/xfs_sb.c          |   2 +
 fs/xfs/libxfs/xfs_types.h       |   1 +
 fs/xfs/scrub/common.c           |   2 +
 fs/xfs/xfs_acl.c                |   2 +
 fs/xfs/xfs_attr_inactive.c      |   2 +-
 fs/xfs/xfs_attr_item.c          | 837 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_attr_item.h          |  76 ++++
 fs/xfs/xfs_attr_list.c          |   1 +
 fs/xfs/xfs_error.c              |   3 +
 fs/xfs/xfs_ioctl.c              |   2 +
 fs/xfs/xfs_ioctl32.c            |   2 +
 fs/xfs/xfs_iops.c               |   2 +
 fs/xfs/xfs_log.c                |   4 +
 fs/xfs/xfs_log_recover.c        |   2 +
 fs/xfs/xfs_ondisk.h             |   2 +
 fs/xfs/xfs_super.c              |   4 +
 fs/xfs/xfs_trace.h              |   1 -
 fs/xfs/xfs_xattr.c              |   1 +
 31 files changed, 1806 insertions(+), 211 deletions(-)
 create mode 100644 fs/xfs/xfs_attr_item.c
 create mode 100644 fs/xfs/xfs_attr_item.h

-- 
2.7.4

