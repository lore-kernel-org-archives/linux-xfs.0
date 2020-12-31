Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53A6BC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:45:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E28A20678
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:45:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbgLaWps (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Dec 2020 17:45:48 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:33824 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726829AbgLaWps (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Dec 2020 17:45:48 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMitdR147507
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:45:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=x2EkzkT3ngj5ir1lA2O0YGvo4W32tx7wrnLIVr3ohlc=;
 b=vldxJXvxj1TdwonHD0STR+FwxSKoF2L4svAvy9Rib/U3mlOtCkxG/ANEWXJw7EMApOVn
 8QG7CiWtE9gunJrBSpElPm9gjPhzxjDap4eUdx47GT24JS9AP0KZpBdZ9NnMIrEuvqf4
 qZPMiRHo+wA8vw//3aabb3nn7zxkbZNgD8cWPEqFcFT4+fUhfP6udifb4siePtTd7aiU
 faHHC+7FhoHxNCfn5h78+ImBK0pJflWtqy3Ay9y5hfvcCelcBmTFYUIH8c/YLP39Mv30
 c4sGMrQ+2/31orzKyk3VNJn0UQMmKTNf1G9IkcB87frwnLLTR+T/xO0tC/P001DSYJfg rQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 35phm1jt3a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:45:07 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMj5IT015967
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:45:06 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 35pf40p8u3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:45:06 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BVMj5gG003229
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:45:05 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 31 Dec 2020 14:45:05 -0800
Subject: [PATCHSET v2 00/20] xfs: hoist inode operations to libxfs
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 31 Dec 2020 14:45:04 -0800
Message-ID: <160945470423.2831307.16915302122460161782.stgit@magnolia>
In-Reply-To: <20201231223847.GI6918@magnolia>
References: <20201231223847.GI6918@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9851 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012310135
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

This series hoists inode creation, renaming, and deletion operations to
libxfs in anticipation of the metadata inode directory feature, which
maintains a directory tree of metadata inodes.  This will be necessary
for further enhancements to the realtime feature, subvolume support.

There aren't supposed to be any functional changes in this intense
refactoring -- we just split the functions into pieces that are generic
and pieces that are specific to libxfs clients.  As a bonus, we can
remove various open-coded pieces of mkfs.xfs and xfs_repair when this
series gets to xfsprogs.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=inode-refactor

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=inode-refactor
---
 fs/xfs/Makefile                 |    1 
 fs/xfs/libxfs/xfs_bmap.c        |   44 +
 fs/xfs/libxfs/xfs_bmap.h        |    3 
 fs/xfs/libxfs/xfs_dir2.c        |  474 +++++++++++++++
 fs/xfs/libxfs/xfs_dir2.h        |   19 +
 fs/xfs/libxfs/xfs_inode_util.c  |  859 +++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_inode_util.h  |   74 ++
 fs/xfs/libxfs/xfs_shared.h      |    8 
 fs/xfs/libxfs/xfs_trans_inode.c |    2 
 fs/xfs/scrub/repair.c           |   13 
 fs/xfs/xfs_inode.c              | 1255 ++-------------------------------------
 fs/xfs/xfs_inode.h              |   31 -
 fs/xfs/xfs_ioctl.c              |   59 --
 fs/xfs/xfs_iops.c               |   45 +
 fs/xfs/xfs_linux.h              |    2 
 fs/xfs/xfs_qm.c                 |    6 
 fs/xfs/xfs_reflink.h            |    6 
 fs/xfs/xfs_symlink.c            |   16 
 fs/xfs/xfs_trans.h              |    1 
 19 files changed, 1594 insertions(+), 1324 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_inode_util.c
 create mode 100644 fs/xfs/libxfs/xfs_inode_util.h

