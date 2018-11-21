Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:35444 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726791AbeKVFKu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Nov 2018 00:10:50 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wALITnjG062637
        for <linux-xfs@vger.kernel.org>; Wed, 21 Nov 2018 18:35:21 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2ntaxqb5bn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 21 Nov 2018 18:35:21 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wALIZGPw026306
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 21 Nov 2018 18:35:16 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wALIZFsb006096
        for <linux-xfs@vger.kernel.org>; Wed, 21 Nov 2018 18:35:16 GMT
Date: Wed, 21 Nov 2018 10:35:15 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 8c110d43c6bc
Message-ID: <20181121183515.GS6792@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.  These are all the reflink, mmap, and blocksize <
pagesize corruption fixes that I've collected and tested over the past
couple of weeks.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the for-next branch is commit:

8c110d43c6bc iomap: readpages doesn't zero page tail beyond EOF

New Commits:

Brian Foster (1):
      [59e429314910] xfs: fix shared extent data corruption due to missing cow reservation

Dave Chinner (11):
      [d61fa8cbf3da] xfs: uncached buffer tracing needs to print bno
      [d43aaf1685aa] xfs: fix transient reference count error in xfs_buf_resubmit_failed_buffers
      [c08768977b9a] xfs: finobt AG reserves don't consider last AG can be a runt
      [7f9f71be84bc] xfs: extent shifting doesn't fully invalidate page cache
      [2c307174ab77] xfs: flush removing page cache in xfs_reflink_remap_prep
      [9230a0b65b47] xfs: delalloc -> unwritten COW fork allocation can go wrong
      [0929d8580071] iomap: FUA is wrong for DIO O_DSYNC writes into unwritten extents
      [b450672fb66b] iomap: sub-block dio needs to zeroout beyond EOF
      [4721a6010990] iomap: dio data corruption and spurious errors when pipes fill
      [494633fac789] vfs: vfs_dedupe_file_range() doesn't return EOPNOTSUPP
      [8c110d43c6bc] iomap: readpages doesn't zero page tail beyond EOF

Eric Biggers (1):
      [da034bcc6aaa] xfs: make xfs_file_remap_range() static


Code Diffstat:

 fs/iomap.c                       | 53 +++++++++++++++++++++++++++++++---------
 fs/read_write.c                  | 15 ++++++------
 fs/xfs/libxfs/xfs_bmap.c         |  5 +++-
 fs/xfs/libxfs/xfs_ialloc_btree.c | 11 ++++++---
 fs/xfs/xfs_bmap_util.c           | 10 ++------
 fs/xfs/xfs_bmap_util.h           |  3 +++
 fs/xfs/xfs_buf_item.c            | 28 +++++++++++++++------
 fs/xfs/xfs_file.c                |  2 +-
 fs/xfs/xfs_reflink.c             | 18 +++++++++++---
 fs/xfs/xfs_trace.h               |  5 +++-
 10 files changed, 104 insertions(+), 46 deletions(-)
