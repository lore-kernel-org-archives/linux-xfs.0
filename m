Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9BE777F50
	for <xfs@oss.sgi.com>; Sat, 15 Aug 2015 19:42:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8C1AF304039
	for <xfs@oss.sgi.com>; Sat, 15 Aug 2015 17:42:46 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	P69U792XHmaCPd4Y for <xfs@oss.sgi.com>;
	Sat, 15 Aug 2015 17:42:44 -0700 (PDT)
Date: Sun, 16 Aug 2015 10:42:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] v3 inodes are only valid on crc-enabled filesystems.
Message-ID: <20150816004242.GA3902@dastard>
References: <C69467E1-642A-422A-8ECF-FDED92550B1B@filmlight.ltd.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <C69467E1-642A-422A-8ECF-FDED92550B1B@filmlight.ltd.uk>
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
To: Roger Willcocks <roger@filmlight.ltd.uk>
Cc: xfs@oss.sgi.com

On Sun, Aug 16, 2015 at 01:14:55AM +0100, Roger Willcocks wrote:
> Fix an xfs_repair regression reported by Leslie Rhorer where a bad
> (v3) inode version number was not reset.
> 
> Signed-off-by: Roger Willcocks <roger@filmlight.ltd.uk>
> ---
> db/check.c             | 2 +-
> include/xfs_dinode.h   | 3 ++-
> libxfs/xfs_inode_buf.c | 2 +-
> repair/dinode.c        | 7 +++----
> repair/prefetch.c      | 2 +-
> 5 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/db/check.c b/db/check.c
> index c4c972f..810fa55 100644
> --- a/db/check.c
> +++ b/db/check.c
> @@ -2637,7 +2637,7 @@ process_inode(
> 		error++;
> 		return;
> 	}
> -	if (!XFS_DINODE_GOOD_VERSION(idic.di_version)) {
> +	if (!XFS_DINODE_GOOD_VERSION(&mp->m_sb, idic.di_version)) {
> 		if (isfree || v)
> 			dbprintf(_("bad version number %#x for inode %lld\n"),
> 				idic.di_version, ino);
> diff --git a/include/xfs_dinode.h b/include/xfs_dinode.h
> index 623bbe8..40700e6 100644
> --- a/include/xfs_dinode.h
> +++ b/include/xfs_dinode.h
> @@ -19,7 +19,8 @@
> #define	__XFS_DINODE_H__
> 
> #define	XFS_DINODE_MAGIC		0x494e	/* 'IN' */
> -#define XFS_DINODE_GOOD_VERSION(v)	((v) >= 1 && (v) <= 3)
> +#define XFS_DINODE_GOOD_VERSION(sb, v) \
> +	(xfs_sb_version_hascrc(sb) ? ((v) == 3) : ((v) == 1 || (v) == 2))

I'd make this a static inline function so it gets type checking and
it is easier to understand the logic at a glance. i.e. something
like:

static inline bool
xfs_dinode_good_version(struct xfs_mount *mp, __uint8_t version)
{
	if (version < 1 || version > 3)
		return false;
	if (xfs_sb_version_hascrc(&mp->m_sb)) {
		if (version != 3)
			return false;
	} else if (version > 2)
		return false;

	return true;
}

Otherwise looks fine.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
