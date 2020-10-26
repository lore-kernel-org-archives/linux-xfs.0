Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACECFC2D0A3
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:38:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FDA820809
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:38:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RUM4t4hT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407233AbgJZXiQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:38:16 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:45578 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407215AbgJZXiP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 19:38:15 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNPdtV177154;
        Mon, 26 Oct 2020 23:36:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=2167jIt1WxoL+3qu1xlZpxf3uLGbR0qZnc1ZiNWJ7X0=;
 b=RUM4t4hTthDfQxDD+kMhM4SKU2/2pJy1S3ZpdrsXgqBeIO7CYAJYBKBbBsnDltjWhw6R
 +v5mw1d33Jj1B2xyxe1D5HFyq0n0dWLvbQ04mSvt3eOSdTulVMKBdutOfbzaRqH1E+eQ
 lMlr+58DQUk/DvKerCnzgCu4giq8MpYoOp+BEAfnLpBgyCqV9ckmU/cvAl6b8r730Yql
 qnS8KvuR4mpk7/OcXk64nViCrrNDYtOq72s/TC47S3CfDmg0JfI239T4N7ch77SYzo0N
 39w/etzDYN4OynwSj7hUDmWACJCS2ewySh/Z+CaALxy6r30UwI3xK8Oml5sUcER3/DlR pQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 34c9saqd6v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 23:36:09 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNQNIq058381;
        Mon, 26 Oct 2020 23:34:08 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 34cwukr8af-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 23:34:08 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09QNY7j7007291;
        Mon, 26 Oct 2020 23:34:07 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 16:34:07 -0700
Subject: [PATCH v6 00/26] xfsprogs: widen timestamps to deal with y2038
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>,
        Amir Goldstein <amir73il@gmail.com>,
        Allison Collins <allison.henderson@oracle.com>,
        Gao Xiang <hsiangkao@redhat.com>,
        Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Mon, 26 Oct 2020 16:34:06 -0700
Message-ID: <160375524618.881414.16347303401529121282.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010260153
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
v6: minor stylistic changes

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
 db/Makefile                |    3 -
 db/command.c               |    1 
 db/command.h               |    1 
 db/dquot.c                 |    6 +
 db/field.c                 |   10 +-
 db/field.h                 |    1 
 db/fprint.c                |  133 +++++++++++++++++++++++++++----
 db/fprint.h                |    4 +
 db/inode.c                 |    9 +-
 db/sb.c                    |   17 ++++
 db/timelimit.c             |  160 +++++++++++++++++++++++++++++++++++++
 include/libxfs.h           |    1 
 include/platform_defs.h.in |    3 +
 include/xfs.h              |    2 
 include/xfs_fs_compat.h    |   12 +++
 include/xfs_inode.h        |   27 ++++--
 include/xfs_mount.h        |    5 +
 include/xqm.h              |   20 ++++-
 libfrog/bulkstat.h         |    4 +
 libfrog/convert.c          |    6 +
 libfrog/convert.h          |    2 
 libfrog/fsgeom.c           |    6 +
 libxfs/libxfs_api_defs.h   |    2 
 libxfs/libxfs_priv.h       |    2 
 libxfs/util.c              |    7 +-
 libxfs/xfs_dquot_buf.c     |   35 ++++++++
 libxfs/xfs_format.h        |  190 +++++++++++++++++++++++++++++++++++++++++++-
 libxfs/xfs_fs.h            |    1 
 libxfs/xfs_ialloc.c        |    4 +
 libxfs/xfs_inode_buf.c     |  130 ++++++++++++++----------------
 libxfs/xfs_inode_buf.h     |   15 +++
 libxfs/xfs_log_format.h    |    7 +-
 libxfs/xfs_quota_defs.h    |    8 ++
 libxfs/xfs_sb.c            |    2 
 libxfs/xfs_shared.h        |    3 +
 libxfs/xfs_trans_inode.c   |   11 +++
 logprint/log_misc.c        |   29 ++++++-
 logprint/log_print_all.c   |    3 -
 logprint/logprint.h        |    2 
 man/man8/mkfs.xfs.8        |   16 ++++
 man/man8/xfs_admin.8       |    5 +
 man/man8/xfs_db.8          |   23 +++++
 mkfs/xfs_mkfs.c            |   24 +++++-
 quota/edit.c               |   79 +++++++++++++++---
 quota/quota.c              |   16 ++--
 quota/quota.h              |    9 ++
 quota/report.c             |   16 ++--
 quota/util.c               |    5 +
 repair/dinode.c            |   40 ++++++++-
 repair/quotacheck.c        |   11 ++-
 scrub/common.c             |    2 
 scrub/fscounters.c         |    1 
 scrub/inodes.c             |    5 -
 scrub/progress.c           |    1 
 54 files changed, 959 insertions(+), 178 deletions(-)
 create mode 100644 db/timelimit.c

