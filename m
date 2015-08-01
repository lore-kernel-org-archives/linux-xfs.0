Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 843B97F77
	for <xfs@oss.sgi.com>; Sat,  1 Aug 2015 07:51:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 635AD8F8033
	for <xfs@oss.sgi.com>; Sat,  1 Aug 2015 05:51:41 -0700 (PDT)
Received: from josefsipek.net (josefsipek.net [71.174.113.7]) by cuda.sgi.com
	with ESMTP id GK2kFu7oqGQ5VknJ for <xfs@oss.sgi.com>;
	Sat, 01 Aug 2015 05:51:34 -0700 (PDT)
Date: Sat, 1 Aug 2015 08:51:35 -0400
From: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
Subject: Re: [PATCH 22/24] xfs: swap inode reflink flags when swapping inode
	extents
Message-ID: <20150801125135.GC101746@meili.valhalla.31bits.net>
References: <20150729223258.17414.91354.stgit@birch.djwong.org>
	<20150729223519.17414.25444.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150729223519.17414.25444.stgit@birch.djwong.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs@oss.sgi.com

On Wed, Jul 29, 2015 at 03:35:19PM -0700, Darrick J. Wong wrote:
> When we're swapping the extents of two inodes, be sure to swap the
> reflink inode flag too.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_bmap_util.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 349a5a6..7bdec90 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1929,6 +1929,11 @@ xfs_swap_extents(
>  		break;
>  	}
>  
> +	if (xfs_is_reflink_inode(ip)) {
> +		tip->i_d.di_flags2 |= XFS_DIFLAG2_REFLINK;
> +		ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;

Are you guaranteed that the temp inode does not have the flag set to begin
with?  This doesn't swap, but rather moves over the flag one way, and clears
it the other way.

Jeff.

> +	}
> +
>  	xfs_trans_log_inode(tp, ip,  src_log_flags);
>  	xfs_trans_log_inode(tp, tip, target_log_flags);
>  
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Si hoc legere scis nimium eruditionis habes.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
