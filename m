Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA7GWXJv066969 for <xfs@oss.sgi.com>; Mon, 7 Nov 2011 10:32:34 -0600
Date: Mon, 7 Nov 2011 14:31:08 -0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH, updated] xfs: Fix possible memory corruption in
	xfs_readlink
Message-ID: <20111107163108.GA21214@andromeda.usersys.redhat.com>
References: <1320156842.30281.28.camel@deadeye> <1320682224.3186.5.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1320682224.3186.5.camel@doink>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alex Elder <aelder@sgi.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, XFS Mailing List <xfs@oss.sgi.com>

ACK, below my signoff
On Mon, Nov 07, 2011 at 10:10:24AM -0600, Alex Elder wrote:
> From: Carlos Maiolino <cmaiolino@redhat.com>
> 
> Fixes a possible memory corruption when the link is larger than
> MAXPATHLEN and XFS_DEBUG is not enabled. This also remove the
> S_ISLNK assert, since the inode mode is checked previously in
> xfs_readlink_by_handle() and via VFS.
> 
> Updated to address concerns raised by Ben Hutchings about the loose
> attention paid to 32- vs 64-bit values, and the lack of handling a
> potentially negative pathlen value:
>  - Changed type of "pathlen" to be xfs_fsize_t, to match that of
>    ip->i_d.di_size
>  - Added checking for a negative pathlen to the too-long pathlen
>    test, and generalized the message that gets reported in that case
>    to reflect the change
> As a result, if a negative pathlen were encountered, this function
> would return EFSCORRUPTED (and would fail an assertion for a debug
> build)--just as would a too-long pathlen.
> 
> Signed-off-by Alex Elder <aelder@sgi.com>
Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
> ---
>  fs/xfs/xfs_vnodeops.c |   14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> Index: b/fs/xfs/xfs_vnodeops.c
> ===================================================================
> --- a/fs/xfs/xfs_vnodeops.c
> +++ b/fs/xfs/xfs_vnodeops.c
> @@ -112,7 +112,7 @@ xfs_readlink(
>  	char		*link)
>  {
>  	xfs_mount_t	*mp = ip->i_mount;
> -	int		pathlen;
> +	xfs_fsize_t	pathlen;
>  	int		error = 0;
>  
>  	trace_xfs_readlink(ip);
> @@ -122,13 +122,19 @@ xfs_readlink(
>  
>  	xfs_ilock(ip, XFS_ILOCK_SHARED);
>  
> -	ASSERT(S_ISLNK(ip->i_d.di_mode));
> -	ASSERT(ip->i_d.di_size <= MAXPATHLEN);
> -
>  	pathlen = ip->i_d.di_size;
>  	if (!pathlen)
>  		goto out;
>  
> +	if (pathlen < 0 || pathlen > MAXPATHLEN) {
> +		xfs_alert(mp, "%s: inode (%llu) bad symlink length (%lld)",
> +			 __func__, (unsigned long long) ip->i_ino,
> +			 (long long) pathlen);
> +		ASSERT(0);
> +		return XFS_ERROR(EFSCORRUPTED);
> +	}
> +
> +
>  	if (ip->i_df.if_flags & XFS_IFINLINE) {
>  		memcpy(link, ip->i_df.if_u1.if_data, pathlen);
>  		link[pathlen] = '\0';
> 
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
--Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
