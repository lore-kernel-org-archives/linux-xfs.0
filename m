Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 23 May 2008 01:02:32 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4N82TLQ002789
	for <xfs@oss.sgi.com>; Fri, 23 May 2008 01:02:30 -0700
Date: Fri, 23 May 2008 04:03:18 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [GIT PULL] XFS update for 2.6.26-rc4
Message-ID: <20080523080318.GA19078@infradead.org>
References: <20080523075846.F1ECF58C4C29@chook.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080523075846.F1ECF58C4C29@chook.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org

This is missing the page locking fix in xfs_buf.c which causes
regressions for people out there.

On Fri, May 23, 2008 at 05:58:46PM +1000, Lachlan McIlroy wrote:
> Please pull from the for-linus branch:
>     git pull git://oss.sgi.com:8090/xfs/xfs-2.6.git for-linus
> 
> This will update the following files:
> 
>  fs/xfs/linux-2.6/xfs_file.c  |   17 ++++--
>  fs/xfs/linux-2.6/xfs_vnode.h |    8 ---
>  fs/xfs/xfs_inode.c           |    9 ++--
>  fs/xfs/xfs_vnodeops.c        |  112 ++++++++++++++++--------------------------
>  fs/xfs/xfs_vnodeops.h        |    3 +-
>  5 files changed, 59 insertions(+), 90 deletions(-)
> 
> through these commits:
> 
> commit c8f5f12e46f079a954d4f7163ba59dadee08ca26
> Author: David Chinner <dgc@sgi.com>
> Date:   Tue May 20 11:30:15 2008 +1000
> 
>     [XFS] Fix inode list allocation size in writeback.
>     
>     We only need to allocate space for the number of inodes in the cluster
>     when writing back inodes, not every byte in the inode cluster. This
>     reduces the amount of memory needing to be allocated to 256 bytes instead
>     of 64k.
>     
>     SGI-PV: 981949
>     SGI-Modid: xfs-linux-melb:xfs-kern:31182a
>     
>     Signed-off-by: David Chinner <dgc@sgi.com>
>     Signed-off-by: Christoph Hellwig <hch@infradead.org>
>     Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
> 
> commit 49383b0e98ad1f69ff4c816eb1961f703df12318
> Author: David Chinner <dgc@sgi.com>
> Date:   Mon May 19 16:29:34 2008 +1000
> 
>     [XFS] Don't allow memory reclaim to wait on the filesystem in inode
>     writeback
>     
>     If we allow memory reclaim to wait on the pages under writeback in inode
>     cluster writeback we could deadlock because we are currently holding the
>     ILOCK on the initial writeback inode which is needed in data I/O
>     completion to change the file size or do unwritten extent conversion
>     before the pages are taken out of writeback state.
>     
>     SGI-PV: 981091
>     SGI-Modid: xfs-linux-melb:xfs-kern:31015a
>     
>     Signed-off-by: David Chinner <dgc@sgi.com>
>     Signed-off-by: Christoph Hellwig <hch@infradead.org>
>     Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
> 
> commit 978b7237123d007b9fa983af6e0e2fa8f97f9934
> Author: David Chinner <dgc@sgi.com>
> Date:   Mon May 19 16:29:46 2008 +1000
> 
>     [XFS] Fix fsync() b0rkage.
>     
>     xfs_fsync() fails to wait for data I/O completion before checking if the
>     inode is dirty or clean to decide whether to log the inode or not. This
>     misses inode size updates when the data flushed by the fsync() is
>     extending the file.
>     
>     Hence, like fdatasync(), we need to wait for I/o completion first, then
>     check the inode for cleanliness. Doing so makes the behaviour of
>     xfs_fsync() identical for fsync and fdatasync and we *always* use
>     synchronous semantics if the inode is dirty. Therefore also kill the
>     differences and remove the unused flags from the xfs_fsync function and
>     callers.
>     
>     SGI-PV: 981296
>     SGI-Modid: xfs-linux-melb:xfs-kern:31033a
>     
>     Signed-off-by: David Chinner <dgc@sgi.com>
>     Signed-off-by: Christoph Hellwig <hch@infradead.org>
>     Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
> 
> 
---end quoted text---
