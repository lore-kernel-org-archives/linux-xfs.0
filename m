Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A9E9C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:44:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 259BC20678
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:44:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbgLaWoO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Dec 2020 17:44:14 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:32920 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbgLaWoO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Dec 2020 17:44:14 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMctUC143534
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:43:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=AF/j2GkiSZQ3gux5fUJuBEEYSh6kA5QJ9o1gVd+NeEs=;
 b=x5MevQge51mJiZGezZbhgZxOjqeZYS5I3O24LVHCvXRw68yZMvAOG9Bux8zgO0Ms4EU3
 fobpj7TU/LVg56FVtOlX/gsYGP/U9uMq4+k1PCvc77g0fsAOG7k3sESrRA4T8OjU7Q//
 fQEQFyinvCPy8zlKuFqnYewTKZJLy9OZ4J/R8QfmgGWQ8XFom0n0CAAiboujzLLQeFVV
 fj7JeSvuTxwn8zUz8iVeji8Gc21LF3YBtBNYqpvhsrLVSZq7SavVMynWeKv3g0ft7MLC
 Ra87vD6L0e4QH81PDVM+yfgF16MF9zv1URN3jdjfdq0Hg+7qrdAjbOaQCiKDsuRlw0IL NA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 35phm1jt2e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:43:33 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMe5VF143807
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:43:32 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 35pexuktd9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:43:32 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BVMhVQ2008255
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:43:31 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 31 Dec 2020 14:43:31 -0800
Subject: [PATCHSET 00/10] xfs: report corruption to the health trackers
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 31 Dec 2020 14:43:30 -0800
Message-ID: <160945461009.2829022.273891214095359709.stgit@magnolia>
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
 definitions=main-2012310134
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

In a previous series we performed a lot of cleanups to the metadata
corruption detection code in XFS.  Now add the ability to report these
problems to the health tracking system so that administrators can gather
reports on live filesystems, and (in the future) to enable more targeted
scanning of metadata.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=corruption-health-reports

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=corruption-health-reports

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=corruption-health-reports
---
 fs/xfs/libxfs/xfs_alloc.c       |  103 ++++++++++++++++++++----
 fs/xfs/libxfs/xfs_attr_leaf.c   |    5 +
 fs/xfs/libxfs/xfs_attr_remote.c |   25 +++---
 fs/xfs/libxfs/xfs_bmap.c        |  115 ++++++++++++++++++++++++--
 fs/xfs/libxfs/xfs_btree.c       |   30 ++++++-
 fs/xfs/libxfs/xfs_da_btree.c    |   35 +++++++-
 fs/xfs/libxfs/xfs_dir2.c        |    5 +
 fs/xfs/libxfs/xfs_dir2_block.c  |    2 
 fs/xfs/libxfs/xfs_dir2_data.c   |    3 +
 fs/xfs/libxfs/xfs_dir2_leaf.c   |    3 +
 fs/xfs/libxfs/xfs_dir2_node.c   |    7 ++
 fs/xfs/libxfs/xfs_health.h      |   35 +++++++-
 fs/xfs/libxfs/xfs_ialloc.c      |   56 +++++++++++--
 fs/xfs/libxfs/xfs_inode_buf.c   |    4 +
 fs/xfs/libxfs/xfs_inode_fork.c  |    8 ++
 fs/xfs/libxfs/xfs_refcount.c    |   36 ++++++++
 fs/xfs/libxfs/xfs_rmap.c        |   86 +++++++++++++++++++-
 fs/xfs/libxfs/xfs_rmap.h        |    2 
 fs/xfs/libxfs/xfs_rtbitmap.c    |    9 ++
 fs/xfs/libxfs/xfs_sb.c          |    2 
 fs/xfs/scrub/health.c           |   20 +++--
 fs/xfs/scrub/refcount_repair.c  |    4 +
 fs/xfs/scrub/rmap.c             |    2 
 fs/xfs/xfs_attr_inactive.c      |    4 +
 fs/xfs/xfs_attr_list.c          |    7 +-
 fs/xfs/xfs_discard.c            |    2 
 fs/xfs/xfs_dquot.c              |   28 ++++++
 fs/xfs/xfs_health.c             |  170 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_icache.c             |    5 +
 fs/xfs/xfs_inode.c              |   11 +++
 fs/xfs/xfs_iomap.c              |   15 +++
 fs/xfs/xfs_iops.c               |    5 +
 fs/xfs/xfs_iwalk.c              |    4 +
 fs/xfs/xfs_mount.c              |    5 +
 fs/xfs/xfs_qm.c                 |    9 ++
 fs/xfs/xfs_rtalloc.c            |    5 +
 fs/xfs/xfs_symlink.c            |    4 +
 37 files changed, 784 insertions(+), 87 deletions(-)

