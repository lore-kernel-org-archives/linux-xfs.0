Return-Path: <SRS0=tsMC=CJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ADC5C433E2
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 06:11:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D3AE20707
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 06:11:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="grPFk6bT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725949AbgHaGLF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 02:11:05 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50786 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725794AbgHaGLE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Aug 2020 02:11:04 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07V5s6q5019120;
        Mon, 31 Aug 2020 06:08:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=6Gby8EVcTGpd/FR4ZKgCKw1RpJjhllla92JWuJOQGwQ=;
 b=grPFk6bTsV3HnKLQd95wT4WNHwIQUwG0f3U9PLmgS/ZVuqm6zdQ8Nik0cURR+MXV0xtj
 A3GML4UAhndH9gmw0fmNFLNf1wTbAF4IM3rqGf2YqGlpw1cvXkZYA0OQhYQqVIhhd8ze
 x2mNxYGJ5XahlqLACmQMzFlJYw14jCPIDbugwn4f1Zl445z8azk9ylxH93mFfCaIyq0Z
 wIccHyB3JoPvVgckKB3sK4x9xGLmrJQiLXIl9gb82efOOx1YekOk0hPaPwA9XaWinH30
 N6HA0IQVeeymEkw5KCX74VScAfdzByeAYT2A3dhgPOZZOqmpAMHP783r+jxHebTBe6k0 qA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 337qrhbdf1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 31 Aug 2020 06:08:55 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07V5t7Vu021272;
        Mon, 31 Aug 2020 06:06:54 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 3380kk6uu1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Aug 2020 06:06:54 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07V66hae004540;
        Mon, 31 Aug 2020 06:06:43 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 30 Aug 2020 23:06:42 -0700
Subject: [PATCH v5 00/11] xfs: widen timestamps to deal with y2038
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, david@fromorbit.com, hch@infradead.org
Cc:     Allison Collins <allison.henderson@oracle.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, sandeen@sandeen.net
Date:   Sun, 30 Aug 2020 23:06:46 -0700
Message-ID: <159885400575.3608006.17716724192510967135.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9729 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008310042
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9729 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 mlxscore=0 lowpriorityscore=0 phishscore=0 clxscore=1015
 suspectscore=0 priorityscore=1501 spamscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008310042
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series performs some refactoring of our timestamp and inode
encoding functions, then retrofits the timestamp union to handle
timestamps as a 64-bit nanosecond counter.  Next, it adds bit shifting
to the non-root dquot timer fields to boost their effective size to 34
bits.  These two changes enable correct time handling on XFS through the
year 2486.

On a current V5 filesystem, inodes timestamps are a signed 32-bit
seconds counter, with 0 being the Unix epoch.  Quota timers are an
unsigned 32-bit seconds counter, with 0 also being the Unix epoch.

This means that inode timestamps can range from:
-(2^31-1) (13 Dec 1901) through (2^31-1) (19 Jan 2038).

And quota timers can range from:
0 (1 Jan 1970) through (2^32-1) (7 Feb 2106).

With the bigtime encoding turned on, inode timestamps are an unsigned
64-bit nanoseconds counter, with 0 being the 1901 epoch.  Quota timers
are a 34-bit unsigned second counter right shifted two bits, with 0
being the Unix epoch, and capped at the maximum inode timestamp value.

This means that inode timestamps can range from:
0 (13 Dec 1901) through (2^64-1 / 1e9) (2 Jul 2486)

Quota timers could theoretically range from:
0 (1 Jan 1970) through (((2^34-1) + (2^31-1)) & ~3) (16 Jun 2582).

But with the capping in place, the quota timers maximum is:
max((2^64-1 / 1e9) - (2^31-1), (((2^34-1) + (2^31-1)) & ~3) (2 Jul 2486).

v2: rebase to 5.9, having landed the quota refactoring
v3: various suggestions by Amir and Dave
v4: drop the timestamp unions, add "is bigtime?" predicates everywhere
v5: reintroduce timestamp unions as *legacy* timestamp unions

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=bigtime

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=bigtime

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=bigtime
---
 fs/xfs/libxfs/xfs_dquot_buf.c   |   35 +++++++
 fs/xfs/libxfs/xfs_format.h      |  190 ++++++++++++++++++++++++++++++++++++++-
 fs/xfs/libxfs/xfs_fs.h          |    1 
 fs/xfs/libxfs/xfs_ialloc.c      |    4 +
 fs/xfs/libxfs/xfs_inode_buf.c   |  130 +++++++++++++--------------
 fs/xfs/libxfs/xfs_inode_buf.h   |   15 +++
 fs/xfs/libxfs/xfs_log_format.h  |    7 +
 fs/xfs/libxfs/xfs_quota_defs.h  |    8 +-
 fs/xfs/libxfs/xfs_sb.c          |    2 
 fs/xfs/libxfs/xfs_shared.h      |    3 +
 fs/xfs/libxfs/xfs_trans_inode.c |   16 +++
 fs/xfs/scrub/inode.c            |   31 +++++-
 fs/xfs/xfs_dquot.c              |   52 +++++++++--
 fs/xfs/xfs_dquot.h              |    3 +
 fs/xfs/xfs_inode.c              |    4 -
 fs/xfs/xfs_inode.h              |    5 +
 fs/xfs/xfs_inode_item.c         |   34 +++++--
 fs/xfs/xfs_inode_item_recover.c |   76 ++++++++++++++++
 fs/xfs/xfs_ioctl.c              |    3 -
 fs/xfs/xfs_ondisk.h             |   24 +++++
 fs/xfs/xfs_qm.c                 |   13 +++
 fs/xfs/xfs_qm.h                 |    4 +
 fs/xfs/xfs_qm_syscalls.c        |   18 ++--
 fs/xfs/xfs_super.c              |   14 ++-
 fs/xfs/xfs_trace.h              |   26 +++++
 fs/xfs/xfs_trans_dquot.c        |    6 +
 26 files changed, 607 insertions(+), 117 deletions(-)

