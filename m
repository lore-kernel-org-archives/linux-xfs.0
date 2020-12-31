Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C0B9C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:46:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 161952087D
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:46:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbgLaWqn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Dec 2020 17:46:43 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:34406 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726883AbgLaWqm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Dec 2020 17:46:42 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMk26X148076
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:46:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=SUxukf7Y1ZXvph8pY74Ex53OX6SdMMu9Zs0Ux3kRXnI=;
 b=hBb4V6S49G38equRSMbSEPy9bCRaRmT+clAIaDtnFDoOhQSw1bOdTkBvsMsb9Uzk20eV
 ixHoeXRfZTR/j3UBjjQ1gOb/82/otXYx3PjfLKjgpury+Sj1Vw+ll2aFeBL/ntuQI52i
 lGodSCnfjx6zq/Dj3JqftCklObaAbIVEYdCa/6qvLKvd/FebzSl9TeIzmO1yFbgU9ekQ
 NgjOUAKqQbXD0qAG6yt6EQIvpD/IW7b7RdO12cOqK3nxkT8+RZzmHUIdzzzqCFcYamW6
 j5zODXm+tqr+tnuCG8FEhvT/dVLLty1TeE+V78Amd3CH9jqZSnBHjDjsghS7donzPuqK uw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 35phm1jt3n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:46:01 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMeUs9083479
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:46:01 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 35pf307mge-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:46:01 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BVMk1QW018993
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:46:01 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 31 Dec 2020 14:46:00 -0800
Subject: [PATCHSET v11 00/27] xfs: realtime reverse-mapping support
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 31 Dec 2020 14:46:00 -0800
Message-ID: <160945475931.2832202.9309718793198201005.stgit@magnolia>
In-Reply-To: <20201231223847.GI6918@magnolia>
References: <20201231223847.GI6918@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9851 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 malwarescore=0 suspectscore=0 spamscore=0 phishscore=0
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

This is the latest revision of a patchset that adds to XFS kernel
support for reverse mapping for the realtime device.  This time around
I've fixed some of the bitrot that I've noticed over the past few
months, and most notably have converted rtrmapbt to use the metadata
inode directory feature instead of burning more space in the superblock.

At the beginning of the set are patches to implement storing B+tree
leaves in an inode root, since the realtime rmapbt is rooted in an
inode, unlike the regular rmapbt which is rooted in an AG block.
Prior to this, the only btree that could be rooted in the inode fork
was the block mapping btree; if all the extent records fit in the
inode, format would be switched from 'btree' to 'extents'.

The next few patches widen the reverse mapping routines to fit the
64-bit numbers required to store information about the realtime
device and establish a new b+tree type (rtrmapbt) for the realtime
variant of the rmapbt.  After that are a few patches to handle rooting
the rtrmapbt in a specific inode that's referenced by the superblock.

Finally, there are patches to implement GETFSMAP with the rtrmapbt and
scrub functionality for the rtrmapbt and rtbitmap; and then wire up the
online scrub functionality.  We also enhance EFIs to support tracking
freeing of realtime extents so that when rmap is turned on we can
maintain the same order of operations as the regular rmap code.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-rmap

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=realtime-rmap

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=realtime-rmap

xfsdocs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-documentation.git/log/?h=realtime-rmap
---
 fs/xfs/Makefile                  |    4 
 fs/xfs/libxfs/xfs_ag_resv.c      |    5 
 fs/xfs/libxfs/xfs_bmap.c         |   29 +
 fs/xfs/libxfs/xfs_btree.c        |  108 +++++
 fs/xfs/libxfs/xfs_btree.h        |    9 
 fs/xfs/libxfs/xfs_format.h       |   76 ++++
 fs/xfs/libxfs/xfs_fs.h           |    4 
 fs/xfs/libxfs/xfs_health.h       |    4 
 fs/xfs/libxfs/xfs_imeta.c        |    2 
 fs/xfs/libxfs/xfs_imeta.h        |    1 
 fs/xfs/libxfs/xfs_inode_buf.c    |    6 
 fs/xfs/libxfs/xfs_inode_fork.c   |   13 +
 fs/xfs/libxfs/xfs_log_format.h   |    4 
 fs/xfs/libxfs/xfs_refcount.c     |    6 
 fs/xfs/libxfs/xfs_rmap.c         |  377 +++++++++++-------
 fs/xfs/libxfs/xfs_rmap.h         |   39 +-
 fs/xfs/libxfs/xfs_rtrmap_btree.c |  778 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtrmap_btree.h |  195 ++++++++++
 fs/xfs/libxfs/xfs_sb.c           |    6 
 fs/xfs/libxfs/xfs_shared.h       |    1 
 fs/xfs/libxfs/xfs_swapext.c      |    3 
 fs/xfs/libxfs/xfs_trans_resv.c   |   17 +
 fs/xfs/libxfs/xfs_trans_space.h  |   13 +
 fs/xfs/libxfs/xfs_types.h        |    6 
 fs/xfs/scrub/alloc_repair.c      |    6 
 fs/xfs/scrub/bmap.c              |   76 +++-
 fs/xfs/scrub/bmap_repair.c       |   87 ++++
 fs/xfs/scrub/common.c            |   37 ++
 fs/xfs/scrub/common.h            |    8 
 fs/xfs/scrub/health.c            |    1 
 fs/xfs/scrub/repair.c            |   95 +++++
 fs/xfs/scrub/repair.h            |   13 +
 fs/xfs/scrub/rmap_repair.c       |   21 +
 fs/xfs/scrub/rtbitmap.c          |   59 +++
 fs/xfs/scrub/rtbitmap_repair.c   |  252 ++++++++++++
 fs/xfs/scrub/rtrmap.c            |  147 +++++++
 fs/xfs/scrub/rtrmap_repair.c     |  689 ++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.c             |   11 -
 fs/xfs/scrub/scrub.h             |   11 +
 fs/xfs/scrub/trace.c             |    2 
 fs/xfs/scrub/trace.h             |   87 ++++
 fs/xfs/xfs_buf_item_recover.c    |    4 
 fs/xfs/xfs_fsmap.c               |   66 +++
 fs/xfs/xfs_health.c              |    4 
 fs/xfs/xfs_inode.c               |    9 
 fs/xfs/xfs_inode_item.c          |    2 
 fs/xfs/xfs_inode_item_recover.c  |   33 +-
 fs/xfs/xfs_mount.c               |    2 
 fs/xfs/xfs_mount.h               |    4 
 fs/xfs/xfs_ondisk.h              |    3 
 fs/xfs/xfs_rmap_item.c           |   31 +-
 fs/xfs/xfs_rtalloc.c             |   55 ++-
 fs/xfs/xfs_rtalloc.h             |    4 
 fs/xfs/xfs_super.c               |    6 
 fs/xfs/xfs_trace.h               |   39 +-
 55 files changed, 3286 insertions(+), 284 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_rtrmap_btree.c
 create mode 100644 fs/xfs/libxfs/xfs_rtrmap_btree.h
 create mode 100644 fs/xfs/scrub/rtbitmap_repair.c
 create mode 100644 fs/xfs/scrub/rtrmap.c
 create mode 100644 fs/xfs/scrub/rtrmap_repair.c

