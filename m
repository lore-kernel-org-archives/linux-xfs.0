Return-Path: <SRS0=3PXQ=AL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9AF7C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 15:41:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CAF4E20724
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 15:41:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RhElbHW0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389631AbgF3Ply (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Jun 2020 11:41:54 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56554 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389628AbgF3Ply (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jun 2020 11:41:54 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UFRHxY011564
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:41:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=xhoy+mBmLwtCZmFIhoIG4FePjcKpp4SB8LI6k+ZlVX0=;
 b=RhElbHW0AaLgpN8VYZVkr5bvAdZFLznVDUNfyMZ6fb4PCb2Ow6VGCl39+YxUoR49rppe
 6SXop76NLD3Z31xp+JGXutitI+JkbMMkaZNT6DtJXKIJBpANl9YUaZAJ7THRrCrEFX1x
 YZSGayT0WFOWpmCVOQNRpZDcb0fYohNJJZYY6hnG+yTsTY4kBTrrFqW+TI/5UfVcLv+K
 Yp5F/o1etmXREpPFSo6cbxZyONWf8evAR6yzLUejkHBL2yLapWRv/Loh7LxavGL56GUz
 kJL68gCLoDbPm+Hvd4N0OD+28vicSwun4UZ7UijCulPZpNwSLBpBz+VGPWMc199oFRNs 9w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 31xx1dt5y4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:41:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UFNkIt051069
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:41:52 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 31xg1wy52w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:41:52 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05UFfpgL000484
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:41:51 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 30 Jun 2020 15:41:51 +0000
Subject: [PATCH 00/18] xfs: remove xfs_disk_quot from incore dquot
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 30 Jun 2020 08:41:50 -0700
Message-ID: <159353170983.2864738.16885438169173786208.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9667 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300112
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9667 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015 adultscore=0
 suspectscore=0 mlxlogscore=999 cotscore=-2147483648 lowpriorityscore=0
 malwarescore=0 phishscore=0 impostorscore=0 mlxscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006300112
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
 fs/xfs/libxfs/xfs_quota_defs.h |    2 
 fs/xfs/scrub/quota.c           |   69 +++-----
 fs/xfs/xfs_dquot.c             |  283 +++++++++++++++++++---------------
 fs/xfs/xfs_dquot.h             |   54 +++++--
 fs/xfs/xfs_dquot_item.c        |    8 +
 fs/xfs/xfs_iomap.c             |    6 -
 fs/xfs/xfs_qm.c                |   92 +++++------
 fs/xfs/xfs_qm.h                |   42 ++---
 fs/xfs/xfs_qm_bhv.c            |   20 +-
 fs/xfs/xfs_qm_syscalls.c       |  231 +++++++++++++++-------------
 fs/xfs/xfs_quotaops.c          |   12 +
 fs/xfs/xfs_trace.h             |  160 ++++++++++++++++++-
 fs/xfs/xfs_trans_dquot.c       |  329 ++++++++++++++++++++--------------------
 13 files changed, 744 insertions(+), 564 deletions(-)

