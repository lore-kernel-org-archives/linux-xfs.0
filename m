Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:13772 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752363AbcIHBin (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Sep 2016 21:38:43 -0400
Date: Thu, 8 Sep 2016 11:38:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 7/7] xfsdocs: document the realtime reverse mapping btree
Message-ID: <20160908013838.GT30056@dastard>
References: <147216761636.32447.4229640006064129056.stgit@birch.djwong.org>
 <147216766221.32447.9777486170830928374.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147216766221.32447.9777486170830928374.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

On Thu, Aug 25, 2016 at 04:27:42PM -0700, Darrick J. Wong wrote:
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  .../allocation_groups.asciidoc                     |    8 +
>  design/XFS_Filesystem_Structure/docinfo.xml        |   14 +
>  .../internal_inodes.asciidoc                       |    2 
>  design/XFS_Filesystem_Structure/magic.asciidoc     |    1 
>  .../XFS_Filesystem_Structure/ondisk_inode.asciidoc |    6 -
>  design/XFS_Filesystem_Structure/rtrmapbt.asciidoc  |  234 ++++++++++++++++++++
>  6 files changed, 263 insertions(+), 2 deletions(-)
>  create mode 100644 design/XFS_Filesystem_Structure/rtrmapbt.asciidoc
> 
> 
> diff --git a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
> index cafa8b7..7ba636a 100644
> --- a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
> +++ b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
> @@ -105,6 +105,7 @@ struct xfs_sb
>  	xfs_ino_t		sb_pquotino;
>  	xfs_lsn_t		sb_lsn;
>  	uuid_t			sb_meta_uuid;
> +	xfs_ino_t		sb_rrmapino;
>  };
>  ----
>  *sb_magicnum*::
> @@ -449,6 +450,13 @@ If the +XFS_SB_FEAT_INCOMPAT_META_UUID+ feature is set, then the UUID field in
>  all metadata blocks must match this UUID.  If not, the block header UUID field
>  must match +sb_uuid+.
>  
> +*sb_rrmapino*::
> +If the +XFS_SB_FEAT_COMPAT_RMAPBT+ feature is set and a real-time

XFS_SB_FEAT_RO_COMPAT_RMAPBT?

(yes, I am reading these patches!)

-Dave.

-- 
Dave Chinner
david@fromorbit.com
