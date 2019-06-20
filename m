Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:59689 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726549AbfFTVcH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Jun 2019 17:32:07 -0400
Date: Fri, 21 Jun 2019 07:31:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: move xfs_ino_geometry to xfs_shared.h
Message-ID: <20190620213105.GD26375@dread.disaster.area>
References: <20190618205935.GS5387@magnolia>
 <20190619011309.GT5387@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190619011309.GT5387@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>

On Tue, Jun 18, 2019 at 06:13:09PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The inode geometry structure isn't related to ondisk format; it's
> support for the mount structure.  Move it to xfs_shared.h.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: move it to xfs_shared.h, which now every file has to include
> ---
>  fs/xfs/libxfs/xfs_dir2.c       |    1 +
>  fs/xfs/libxfs/xfs_dir2_block.c |    1 +
>  fs/xfs/libxfs/xfs_dir2_data.c  |    1 +
>  fs/xfs/libxfs/xfs_dir2_leaf.c  |    1 +
>  fs/xfs/libxfs/xfs_dir2_node.c  |    1 +
>  fs/xfs/libxfs/xfs_dir2_sf.c    |    1 +
>  fs/xfs/libxfs/xfs_format.h     |   41 ---------------------------------------
>  fs/xfs/libxfs/xfs_iext_tree.c  |    1 +
>  fs/xfs/libxfs/xfs_inode_fork.c |    1 +
>  fs/xfs/libxfs/xfs_shared.h     |   42 ++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_acl.c               |    1 +
>  fs/xfs/xfs_attr_list.c         |    1 +
>  fs/xfs/xfs_buf.c               |    1 +
>  fs/xfs/xfs_buf_item.c          |    1 +
>  fs/xfs/xfs_dir2_readdir.c      |    1 +
>  fs/xfs/xfs_discard.c           |    1 +
>  fs/xfs/xfs_dquot_item.c        |    1 +
>  fs/xfs/xfs_error.c             |    1 +
>  fs/xfs/xfs_export.c            |    1 +
>  fs/xfs/xfs_filestream.c        |    1 +
>  fs/xfs/xfs_icache.c            |    1 +
>  fs/xfs/xfs_inode_item.c        |    1 +
>  fs/xfs/xfs_ioctl32.c           |    1 +
>  fs/xfs/xfs_message.c           |    1 +
>  fs/xfs/xfs_pnfs.c              |    1 +
>  fs/xfs/xfs_qm_bhv.c            |    1 +
>  fs/xfs/xfs_quotaops.c          |    1 +
>  fs/xfs/xfs_trans_ail.c         |    1 +
>  fs/xfs/xfs_xattr.c             |    1 +
>  29 files changed, 69 insertions(+), 41 deletions(-)

Bigger patch, but I think it's the right way to do this.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
