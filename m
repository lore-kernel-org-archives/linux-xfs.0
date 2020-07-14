Return-Path: <SRS0=oQKh=AZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C589C433E2
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 01:31:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45CC621924
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 01:31:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="seOuD+z0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726409AbgGNBbk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Jul 2020 21:31:40 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37632 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbgGNBbk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Jul 2020 21:31:40 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06E1SDbM092876;
        Tue, 14 Jul 2020 01:31:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=SnmhEYxTqfL3ErM9gHoSbSQA78Fs+xK6pg/Aq21aIPM=;
 b=seOuD+z0VJ2rs4qFxf+7bXY0BmEseVIcOhKv7AzJiOoySm1WErEBo+zDaxmrddh9mUdI
 VZDEFYKfIF3ZI2c260bnw3ERQ+yr1+tNgeDRwFAjzYRugeTc6k27xcwHKKi/TlL4Shuy
 0PivfoNWJ36u3yL2xRG2bgSsg/jWhS+ZPk6r9T+F32LTwF5q/R80rshavzdIrPOM3AN7
 PLU65VkMbvhUuZLW1M3AyK/TSUizH3RWhrMa2/o55pByUj5ugbHkhYG7eC/RLqjxZRSI
 bsSVmGpgKLyZXU4E+LbQ1JXyPC9L7Wb0giMoZk1tfIL4IEY3oOfq4HNpcTdOpElrTePY 7Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 3274ur2etq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 14 Jul 2020 01:31:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06E1Sain055071;
        Tue, 14 Jul 2020 01:31:32 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 327qbwgwr6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 01:31:32 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06E1VSl1012066;
        Tue, 14 Jul 2020 01:31:28 GMT
Received: from localhost (/10.159.128.100)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Jul 2020 18:31:28 -0700
Subject: [PATCH v3 00/26] xfs: remove xfs_disk_quot from incore dquot
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        Allison Collins <allison.henderson@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Date:   Mon, 13 Jul 2020 18:31:27 -0700
Message-ID: <159469028734.2914673.17856142063205791176.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007140008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007140008
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
 fs/xfs/libxfs/xfs_dquot_buf.c   |   26 ++-
 fs/xfs/libxfs/xfs_format.h      |   29 +++
 fs/xfs/libxfs/xfs_quota_defs.h  |   54 ++++--
 fs/xfs/scrub/quota.c            |   86 +++------
 fs/xfs/scrub/repair.c           |   10 +
 fs/xfs/scrub/repair.h           |    4 
 fs/xfs/xfs_buf_item_recover.c   |    8 -
 fs/xfs/xfs_dquot.c              |  368 +++++++++++++++++++++------------------
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
 21 files changed, 1075 insertions(+), 831 deletions(-)

