Return-Path: <SRS0=59Ki=B7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F03B8C433E1
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Aug 2020 02:11:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C63B12076E
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Aug 2020 02:11:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pMbPSO6f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbgHUCLg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Aug 2020 22:11:36 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51094 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726969AbgHUCLf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Aug 2020 22:11:35 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07L27gtI053156;
        Fri, 21 Aug 2020 02:11:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=OiIKzl2gp/pXKg6xkB+gqjzNH5KtAfAynFz4umLan5U=;
 b=pMbPSO6fJ1K1a02aj9/6FAr9pgiNN93Vf2Tb0JHW6BeIEb4BehBrvNxKOXkRCguheyPf
 Oh3DMCj9nIOXrSwyVEYI6ZXWdhVyzRb4BGTjPH73R0zaFeKyUR9jnk/AGAq/8Qa7W0jV
 X7JpXPNnEJVDl0w9yYt0rnTATHxt/ckWWbx2uvDqVPlV/mqDgD6FRDulCkAdups5dngE
 tCGAVpQ0ZYddBDg/xf2cYNbyJGsN9Aysxnm99DZnOv+1zPs7n5mgSLUHEcPTCAA3TaV7
 AgoS1AMuAv5sAYQ8HXFYnYcJ4GtaW83vZSHNeag1b3cxeWsLkahRTA4sjVaH4+GlmO05 7Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 3322bjgdsu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 21 Aug 2020 02:11:32 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07L28Vpo141036;
        Fri, 21 Aug 2020 02:11:32 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 331b2e8tmq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Aug 2020 02:11:31 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07L2BSOE028169;
        Fri, 21 Aug 2020 02:11:31 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 20 Aug 2020 19:11:28 -0700
Subject: [PATCH v3 00/11] xfs: widen timestamps to deal with y2038
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, sandeen@sandeen.net
Date:   Thu, 20 Aug 2020 19:11:27 -0700
Message-ID: <159797588727.965217.7260803484540460144.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9719 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008210018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9719 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 lowpriorityscore=0 spamscore=0 impostorscore=0 clxscore=1015 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008210018
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
 fs/xfs/libxfs/xfs_dquot_buf.c   |   48 +++++++++++++
 fs/xfs/libxfs/xfs_format.h      |  140 ++++++++++++++++++++++++++++++++++++---
 fs/xfs/libxfs/xfs_fs.h          |    1 
 fs/xfs/libxfs/xfs_inode_buf.c   |  132 ++++++++++++++++++-------------------
 fs/xfs/libxfs/xfs_inode_buf.h   |    7 +-
 fs/xfs/libxfs/xfs_log_format.h  |   21 ++++--
 fs/xfs/libxfs/xfs_quota_defs.h  |    9 ++-
 fs/xfs/libxfs/xfs_sb.c          |    2 +
 fs/xfs/libxfs/xfs_trans_inode.c |   11 +++
 fs/xfs/scrub/inode.c            |   31 ++++++---
 fs/xfs/xfs_dquot.c              |   57 +++++++++++++---
 fs/xfs/xfs_dquot.h              |    4 +
 fs/xfs/xfs_inode.c              |   15 ++++
 fs/xfs/xfs_inode_item.c         |   97 +++++++++++++++++++++++++--
 fs/xfs/xfs_inode_item.h         |    3 +
 fs/xfs/xfs_ioctl.c              |    3 +
 fs/xfs/xfs_ondisk.h             |   33 +++++++++
 fs/xfs/xfs_qm.c                 |    2 +
 fs/xfs/xfs_qm_syscalls.c        |   18 +++--
 fs/xfs/xfs_super.c              |   14 +++-
 fs/xfs/xfs_trans_dquot.c        |    6 ++
 21 files changed, 526 insertions(+), 128 deletions(-)

