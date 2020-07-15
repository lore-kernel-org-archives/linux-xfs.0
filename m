Return-Path: <SRS0=dZhK=A2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1FB2C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 01:50:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2F4020658
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 01:50:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="f77/d8ST"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727981AbgGOBun (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Jul 2020 21:50:43 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:43888 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726356AbgGOBum (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jul 2020 21:50:42 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06F1mul5076291;
        Wed, 15 Jul 2020 01:50:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=zVSgQkym2DLoLw99MDsUhv0i1HMGoWMA4xlK/iIdUk8=;
 b=f77/d8STHXGHOXeZePGUW2a+EAPGYBJIVhLj7waHG06bkMu5RJWuC7RSVOVVnIszibcL
 2gqx8COW9wgvQbNmpZneDDYK54hJ5BHRQxet9+JifXBI8IQZERIHFOYN2q2hJTnoCbLQ
 m8R+JKA1r3ABwGJtXguhJeQa8KpI1cpr9Z8jCmK1bT/iqTpeOHzStDfFn8utchUMfKQv
 laC5tW3cg2P0bd2UaQP3vsvKk75dsp5B12EI/L2qiN6/8237nD7FyR2x61ddAwqH60OG
 Epq8Y/uzi5KUUV0qU9sWv38u4gwkpxgX2RGenBSk3FHLayEWNGTrpcDAZw2GB4dne92X hw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 3274ur8pvf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 15 Jul 2020 01:50:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06F1la8L184496;
        Wed, 15 Jul 2020 01:50:35 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 327qb5wn5h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jul 2020 01:50:35 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06F1oXs2026001;
        Wed, 15 Jul 2020 01:50:33 GMT
Received: from localhost (/10.159.237.234)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 Jul 2020 18:50:33 -0700
Subject: [PATCH v4 00/26] xfs: remove xfs_disk_quot from incore dquot
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Allison Collins <allison.henderson@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Brian Foster <bfoster@redhat.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Tue, 14 Jul 2020 18:50:32 -0700
Message-ID: <159477783164.3263162.2564345443708779029.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 phishscore=0 suspectscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007150013
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007150013
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series replaces q_core (the ondisk quota structure) in the incore
dquot structure with a quota resource control structure containing the
count, reservation, limits, timers, and warnings.  Each dquot gets three
of these resource control structures (blocks, inodes, rt blocks).

Doing this enables us to remove a whole lot of noisy endian conversions
in the quota code, and enables us to refactor a bunch of open-coded
logic to pass around pointers to quota resource control structs.

Note that these cleanups are a prerequisite for the bigtime patchset, as
it depends on incore quota timers being time64_t to take advantage of
the 64-bit time functions in the kernel with fewer places to trip over
the ondisk format.

In v2 we do some more work cleaning up the d_flags/dq_flags mess,
finally add the dquot cluster size to the ondisk format declarations
(because the cluster size actually /does/ affect that), shorten some of
the long names from v1, and fix quota warning count having been broken
for years.

In v3 we separate the incore dquot's dq_flags fields into separate q_type
and q_flags fields, and introduce a new xfs_dqtype_t to make it obvious
when a function operates on a *single* quota type.  This also makes it
easier to validate that outside functions aren't going to screw up the
incore dquot state.

v4: merge the dquot type flags when possible.  I still plan to keep the
incore type/state flag namespace separate from the ondisk flags so that
I can add more flags to the ondisk dquot in the next series.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=remove-quota-qcore

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=remove-quota-qcore
---
 fs/xfs/libxfs/xfs_dquot_buf.c   |   25 ++-
 fs/xfs/libxfs/xfs_format.h      |   36 +++-
 fs/xfs/libxfs/xfs_quota_defs.h  |   37 ++--
 fs/xfs/scrub/quota.c            |   86 ++++-----
 fs/xfs/scrub/repair.c           |   10 +
 fs/xfs/scrub/repair.h           |    4 
 fs/xfs/xfs_buf_item_recover.c   |    8 -
 fs/xfs/xfs_dquot.c              |  367 +++++++++++++++++++++------------------
 fs/xfs/xfs_dquot.h              |  119 ++++++++-----
 fs/xfs/xfs_dquot_item.c         |    8 +
 fs/xfs/xfs_dquot_item_recover.c |   12 +
 fs/xfs/xfs_icache.c             |    4 
 fs/xfs/xfs_iomap.c              |   42 ++--
 fs/xfs/xfs_qm.c                 |  196 ++++++++++-----------
 fs/xfs/xfs_qm.h                 |  104 +++++------
 fs/xfs/xfs_qm_bhv.c             |   22 +-
 fs/xfs/xfs_qm_syscalls.c        |  257 ++++++++++++++-------------
 fs/xfs/xfs_quota.h              |   10 +
 fs/xfs/xfs_quotaops.c           |   26 +--
 fs/xfs/xfs_trace.h              |  172 +++++++++++++++++-
 fs/xfs/xfs_trans_dquot.c        |  349 +++++++++++++++++++------------------
 21 files changed, 1059 insertions(+), 835 deletions(-)

