Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:37388 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751402AbeEPAte (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 May 2018 20:49:34 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w4G0lR40128410
        for <linux-xfs@vger.kernel.org>; Wed, 16 May 2018 00:49:34 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2hx29w2myp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 16 May 2018 00:49:33 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w4G0nXMh026650
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 16 May 2018 00:49:33 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w4G0nWDk017847
        for <linux-xfs@vger.kernel.org>; Wed, 16 May 2018 00:49:33 GMT
Date: Tue, 15 May 2018 17:49:31 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [ANNOUNCE] xfs-linux: for-next updated to 68932e193b27
Message-ID: <20180516004931.GQ4933@magnolia>
References: <20180515211913.GN4933@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180515211913.GN4933@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

On Tue, May 15, 2018 at 02:19:13PM -0700, Darrick J. Wong wrote:
> Hi folks,
> 
> The for-next branch of the xfs-linux repository at:
> 
> 	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git
> 
> has just been updated.
> 
> Patches often get missed, so please check if your outstanding
> patches were in this update. If they have not been in this update,
> please resubmit them to linux-xfs@vger.kernel.org so they can be
> picked up in the next update.  At this point I think the only things
> left to review are Christoph's iomap bufferhead removal and online
> repair.

Bleh, I screwed up the quota limits refactoring patch, disregard this
message.

--D

> 
> The new head of the for-next branch is commit:
> 
> 68932e193b27 xfs: factor the ag length extension code into libxfs
> 
> New Commits:
> 
> Brian Foster (1):
>       [1a04f418edc1] xfs: factor out nodiscard helpers
> 
> Darrick J. Wong (12):
>       [16b501076b2d] xfs: skip scrub xref if corruption already noted
>       [8c4f7226897d] xfs: superblock scrub should use short-lived buffers
>       [a919a9fe5506] xfs: refactor quota limits initialization
>       [792991a8dc4b] xfs: don't continue scrub if already corrupt
>       [6be32cc1333f] xfs: quota scrub should use bmapbtd scrubber
>       [d7d7c05fa262] xfs: scrub the data fork of the realtime inodes
>       [5e52c88aaef5] xfs: avoid ABBA deadlock when scrubbing parent pointers
>       [b76c0050f026] xfs: hoist xfs_scrub_agfl_walk to libxfs as xfs_agfl_walk
>       [edda0726ec71] xfs: make xfs_bmapi_remapi work with attribute forks
>       [3c0e061f3a76] xfs: teach xfs_bmapi_remap to accept some bmapi flags
>       [81633d16e012] xfs: create tracepoints for online repair
>       [1cfb2a768dea] xfs: implement the metadata repair ioctl flag
> 
> Dave Chinner (12):
>       [8ab11a7b19d0] xfs: add mount delay debug option
>       [939c8ca6f50e] xfs: clear sb->s_fs_info on mount failure
>       [dcea0413ef5c] xfs: one-shot cached buffers
>       [f65ede6d9e8e] xfs: factor out AG header initialisation from growfs core
>       [26c2e0a3c4b8] xfs: convert growfs AG header init to use buffer lists
>       [5a64ce3f2972] xfs: factor ag btree root block initialisation
>       [49d414e60b01] xfs: turn ag header initialisation into a table driven operation
>       [0e3f1e4debfe] xfs: make imaxpct changes in growfs separate
>       [36a7674290cb] xfs: separate secondary sb update in growfs
>       [d154678bf58e] xfs: rework secondary superblock updates in growfs
>       [e5a8059784d7] xfs: move growfs core to libxfs
>       [68932e193b27] xfs: factor the ag length extension code into libxfs
> 
> 
> Code Diffstat:
> 
>  fs/xfs/Kconfig               |  18 ++
>  fs/xfs/Makefile              |   8 +
>  fs/xfs/libxfs/xfs_ag.c       | 464 ++++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_ag.h       |  30 +++
>  fs/xfs/libxfs/xfs_alloc.c    |  37 +++
>  fs/xfs/libxfs/xfs_alloc.h    |  16 +-
>  fs/xfs/libxfs/xfs_bmap.c     |  49 ++--
>  fs/xfs/libxfs/xfs_bmap.h     |  15 +-
>  fs/xfs/libxfs/xfs_errortag.h |   4 +-
>  fs/xfs/libxfs/xfs_fs.h       |   9 +-
>  fs/xfs/libxfs/xfs_sb.c       |  95 +++++++
>  fs/xfs/libxfs/xfs_sb.h       |  12 +
>  fs/xfs/libxfs/xfs_shared.h   |   1 +
>  fs/xfs/scrub/agheader.c      |  82 ++----
>  fs/xfs/scrub/alloc.c         |   4 +-
>  fs/xfs/scrub/attr.c          |   3 +-
>  fs/xfs/scrub/bmap.c          |   5 +-
>  fs/xfs/scrub/common.c        |  83 ++++++
>  fs/xfs/scrub/common.h        |  17 +-
>  fs/xfs/scrub/dir.c           |  35 ++-
>  fs/xfs/scrub/ialloc.c        |   7 +-
>  fs/xfs/scrub/inode.c         |   5 +-
>  fs/xfs/scrub/parent.c        |  19 +-
>  fs/xfs/scrub/quota.c         |  83 +++---
>  fs/xfs/scrub/refcount.c      |   8 +-
>  fs/xfs/scrub/repair.c        | 130 ++++++++++
>  fs/xfs/scrub/repair.h        |  56 +++++
>  fs/xfs/scrub/rmap.c          |   6 +-
>  fs/xfs/scrub/rtbitmap.c      |  37 ++-
>  fs/xfs/scrub/scrub.c         | 138 +++++++++-
>  fs/xfs/scrub/scrub.h         |   3 +
>  fs/xfs/scrub/trace.h         | 258 +++++++++++++++++++
>  fs/xfs/xfs_bmap_util.c       |   4 +-
>  fs/xfs/xfs_buf.h             |  12 +
>  fs/xfs/xfs_error.c           |   3 +
>  fs/xfs/xfs_fsops.c           | 587 ++++++++-----------------------------------
>  fs/xfs/xfs_globals.c         |   1 +
>  fs/xfs/xfs_inode.c           |   9 +-
>  fs/xfs/xfs_inode.h           |  16 +-
>  fs/xfs/xfs_qm.c              | 142 ++++++-----
>  fs/xfs/xfs_super.c           |  21 ++
>  fs/xfs/xfs_sysctl.h          |   1 +
>  fs/xfs/xfs_sysfs.c           |  31 +++
>  fs/xfs/xfs_trans_extfree.c   |   9 +-
>  44 files changed, 1800 insertions(+), 773 deletions(-)
>  create mode 100644 fs/xfs/libxfs/xfs_ag.c
>  create mode 100644 fs/xfs/libxfs/xfs_ag.h
>  create mode 100644 fs/xfs/scrub/repair.c
>  create mode 100644 fs/xfs/scrub/repair.h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
