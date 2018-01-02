Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:10161 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750996AbeABXWR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jan 2018 18:22:17 -0500
Date: Wed, 3 Jan 2018 10:22:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 05/20] xfs: refactor xfs_verifier_error and
 xfs_buf_ioerror
Message-ID: <20180102232214.GZ5858@dastard>
References: <151399122361.23543.15718507168231759645.stgit@magnolia>
 <151399125430.23543.14769548442400740447.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151399125430.23543.14769548442400740447.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Dec 22, 2017 at 05:07:34PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Since all verification errors also mark the buffer as having an error,
> we can combine these two calls.  Later we'll add a xfs_failaddr_t
> parameter to promote the idea of reporting corruption errors and the
> address of the failing check to enable better debugging reports.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c          |   20 ++++++--------------
>  fs/xfs/libxfs/xfs_alloc_btree.c    |   11 ++++-------
>  fs/xfs/libxfs/xfs_attr_leaf.c      |   10 +++-------
>  fs/xfs/libxfs/xfs_attr_remote.c    |   24 +++++++++++-------------
>  fs/xfs/libxfs/xfs_bmap_btree.c     |   11 ++++-------
>  fs/xfs/libxfs/xfs_da_btree.c       |   16 +++++-----------
>  fs/xfs/libxfs/xfs_dir2_block.c     |   10 +++-------
>  fs/xfs/libxfs/xfs_dir2_data.c      |   15 +++++----------
>  fs/xfs/libxfs/xfs_dir2_leaf.c      |   10 +++-------
>  fs/xfs/libxfs/xfs_dir2_node.c      |   13 ++++---------
>  fs/xfs/libxfs/xfs_dquot_buf.c      |   10 +++-------
>  fs/xfs/libxfs/xfs_ialloc.c         |   10 +++-------
>  fs/xfs/libxfs/xfs_ialloc_btree.c   |   11 ++++-------
>  fs/xfs/libxfs/xfs_inode_buf.c      |    3 +--
>  fs/xfs/libxfs/xfs_refcount_btree.c |   11 ++++-------
>  fs/xfs/libxfs/xfs_rmap_btree.c     |   11 ++++-------
>  fs/xfs/libxfs/xfs_sb.c             |   10 ++++------
>  fs/xfs/libxfs/xfs_symlink_remote.c |   10 +++-------
>  fs/xfs/xfs_buf.c                   |    7 ++++---
>  fs/xfs/xfs_buf.h                   |    4 +++-
>  fs/xfs/xfs_error.c                 |    5 ++++-
>  fs/xfs/xfs_error.h                 |    2 +-
>  fs/xfs/xfs_trace.h                 |    6 +++---
>  23 files changed, 89 insertions(+), 151 deletions(-)

Nice! I didn't think there was that much cleanup in this little
rework :) Looks good to me.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
