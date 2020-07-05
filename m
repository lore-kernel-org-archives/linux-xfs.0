Return-Path: <SRS0=iu4H=AQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCD3BC433E0
	for <linux-xfs@archiver.kernel.org>; Sun,  5 Jul 2020 22:12:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93A5E2075B
	for <linux-xfs@archiver.kernel.org>; Sun,  5 Jul 2020 22:12:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Xmrsf0wB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728169AbgGEWMt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 5 Jul 2020 18:12:49 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39652 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727842AbgGEWMs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 5 Jul 2020 18:12:48 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 065MCgeM147180;
        Sun, 5 Jul 2020 22:12:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=cQKwod68a12YZkaohwfuWOaSqb3l0eAo1RFPHe6eqOU=;
 b=Xmrsf0wBkQ0QAT36kC746x6B8JsQRsa+kfhOasueUI6rO+cjxc6kIu7ytNtYIsEmtWtB
 DKmbc8gfEPasOW5EM5cApis25zCMC6MyhTVGhKcklVfqyPUBYleURAWT9A00taTyjRsw
 j558TtaYXG5RoXKLXcPfq8UFBF+3Tu3rOFfjoOQM+E7aNwWjOw+vy+DeJGmT+D823YDW
 e9GQvVX0/Ch2665ZvoVIqmJDX2Na2EVwPLW+iPvhJoC7kaXqOZ3yMvP5pycGKQRJp6zM
 Q+M7PpyQT56Lkk+Hw0VTrr/cuqXt7f5p6l3H8OYydCjm9doCN8LdnIyJ5/a3/rfTXC4W aw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 322jdn3f4r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 05 Jul 2020 22:12:41 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 065M87w6055729;
        Sun, 5 Jul 2020 22:12:41 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 3233pubj0x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 05 Jul 2020 22:12:41 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 065MCZ9Z018078;
        Sun, 5 Jul 2020 22:12:35 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 05 Jul 2020 15:12:34 -0700
Subject: [PATCH v2 00/22] xfs: remove xfs_disk_quot from incore dquot
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        Allison Collins <allison.henderson@oracle.com>,
        Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Sun, 05 Jul 2020 15:12:33 -0700
Message-ID: <159398715269.425236.15910213189856396341.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9673 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007050171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9673 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 clxscore=1015
 lowpriorityscore=0 suspectscore=0 impostorscore=0 spamscore=0 phishscore=0
 malwarescore=0 bulkscore=0 mlxlogscore=999 priorityscore=1501 mlxscore=0
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007050172
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
 fs/xfs/libxfs/xfs_dquot_buf.c   |   15 +-
 fs/xfs/libxfs/xfs_format.h      |   28 +++
 fs/xfs/libxfs/xfs_quota_defs.h  |    6 -
 fs/xfs/scrub/quota.c            |   69 +++-----
 fs/xfs/xfs_dquot.c              |  289 +++++++++++++++++++---------------
 fs/xfs/xfs_dquot.h              |   54 +++++-
 fs/xfs/xfs_dquot_item.c         |    8 +
 fs/xfs/xfs_dquot_item_recover.c |    4 
 fs/xfs/xfs_iomap.c              |    6 -
 fs/xfs/xfs_qm.c                 |  113 +++++++------
 fs/xfs/xfs_qm.h                 |   51 ++----
 fs/xfs/xfs_qm_bhv.c             |   20 +-
 fs/xfs/xfs_qm_syscalls.c        |  231 ++++++++++++++-------------
 fs/xfs/xfs_quotaops.c           |   12 +
 fs/xfs/xfs_trace.h              |  160 +++++++++++++++++--
 fs/xfs/xfs_trans_dquot.c        |  330 ++++++++++++++++++++-------------------
 16 files changed, 798 insertions(+), 598 deletions(-)

