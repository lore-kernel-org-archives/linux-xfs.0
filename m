Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CE06C433E9
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:47:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B8F620678
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:47:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbgLaWr4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Dec 2020 17:47:56 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:35086 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726630AbgLaWr4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Dec 2020 17:47:56 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMlFou148543
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:47:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=GQ9M1dbIAFmpCQVF1OWhHpoDsWW0UJLNV6mo6SMzPhw=;
 b=VPxZttLqqQ/uOFmvUwcntz1Akq71GWt90QkP0H6aTXx3p4MLLTmOs+mcvee/Aql2SqKi
 grpf1XRaMNiHdWU02WPdlBrM0KXhVgv6j3IFcDEbhb3zKa6Gp0Wx1eMP7/EEmjO14ObJ
 cb6K7GRYfi0fw5kNV3CEljpvDrB0/duoKuZ7RsbS9VbSe1GjiFL2g1oyzf6zV0cQsJgQ
 t0jHNCPCHQDJ+PXoNrdenWObaiBM6oihML+op8fTv6y9y+pevYKAQoIK5YhTUegETTby
 iJ51rFBLREG7wr6jhTWUOy1S8ZBiS0I97v3NccuapkidYX2Vw8NFArzvrJZ40GIqeqI7 4g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 35phm1jt4g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:47:15 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMe5eb143878
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:45:14 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 35pexuktyf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:45:14 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BVMjDN4008813
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:45:13 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 31 Dec 2020 14:45:13 -0800
Subject: [PATCHSET v2 00/15] xfs: metadata inode directories
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 31 Dec 2020 14:45:12 -0800
Message-ID: <160945471235.2831517.11575699953142645925.stgit@magnolia>
In-Reply-To: <20201231223847.GI6918@magnolia>
References: <20201231223847.GI6918@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9851 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 spamscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012310134
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9851 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 priorityscore=1501
 mlxscore=0 mlxlogscore=999 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 impostorscore=0 phishscore=0 clxscore=1015 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012310135
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series delivers a new feature -- metadata inode directories.  This
is a separate directory tree (rooted in the superblock) that contains
only inodes that contain filesystem metadata.  Different metadata
objects can be looked up with regular paths.

We start by creating xfs_imeta_* functions to mediate access to metadata
inode pointers.  This enables the imeta code to abstract inode pointers,
whether they're the classic five in the superblock, or the much more
complex directory tree.  All current users of metadata inodes (rt+quota)
are converted to use the boilerplate code.

Next, we define the metadir on-disk format, which consists of marking
inodes with a new iflag that says they're metadata.  This we use to
prevent bulkstat and friends from ever getting their hands on fs
metadata.

Finally, we implement metadir operations so that clients can create,
delete, zap, and look up metadata inodes by path.  Beware that much of
this code is only lightly used, because the five current users of
metadata inodes don't tend to change them very often.  This is likely to
change if and when the subvolume and multiple-rt-volume features get
written/merged/etc.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=metadir

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=metadir

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=metadir

xfsdocs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-documentation.git/log/?h=metadir
---
 fs/xfs/Makefile                |    1 
 fs/xfs/libxfs/xfs_dir2.c       |    1 
 fs/xfs/libxfs/xfs_format.h     |   55 ++
 fs/xfs/libxfs/xfs_ialloc.c     |   47 +-
 fs/xfs/libxfs/xfs_ialloc.h     |    2 
 fs/xfs/libxfs/xfs_imeta.c      |  959 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_imeta.h      |   73 +++
 fs/xfs/libxfs/xfs_inode_buf.c  |   69 +++
 fs/xfs/libxfs/xfs_inode_buf.h  |    3 
 fs/xfs/libxfs/xfs_inode_util.c |    4 
 fs/xfs/libxfs/xfs_sb.c         |   31 +
 fs/xfs/libxfs/xfs_trans_resv.c |   83 +++
 fs/xfs/libxfs/xfs_trans_resv.h |    2 
 fs/xfs/libxfs/xfs_types.c      |    7 
 fs/xfs/scrub/common.c          |    3 
 fs/xfs/scrub/inode_repair.c    |    6 
 fs/xfs/scrub/scrub.c           |    1 
 fs/xfs/xfs_icache.c            |   38 ++
 fs/xfs/xfs_inode.c             |  132 ++++++
 fs/xfs/xfs_inode.h             |    5 
 fs/xfs/xfs_iops.c              |   34 +
 fs/xfs/xfs_mount.c             |   39 ++
 fs/xfs/xfs_mount.h             |    1 
 fs/xfs/xfs_qm.c                |  192 +++++---
 fs/xfs/xfs_qm_syscalls.c       |    4 
 fs/xfs/xfs_rtalloc.c           |   14 -
 fs/xfs/xfs_super.c             |    4 
 fs/xfs/xfs_trace.h             |   81 +++
 28 files changed, 1786 insertions(+), 105 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_imeta.c
 create mode 100644 fs/xfs/libxfs/xfs_imeta.h

