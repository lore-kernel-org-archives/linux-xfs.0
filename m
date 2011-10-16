Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9GNfRbQ218381 for <xfs@oss.sgi.com>; Sun, 16 Oct 2011 18:41:27 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 49FFB14788B1
	for <xfs@oss.sgi.com>; Sun, 16 Oct 2011 16:49:11 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	olPnGfdgSN2U7uYS for <xfs@oss.sgi.com>;
	Sun, 16 Oct 2011 16:49:11 -0700 (PDT)
Date: Mon, 17 Oct 2011 10:41:21 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: Fix possible memory corruption in xfs_readlink
Message-ID: <20111016234121.GS3159@dastard>
References: <1318814794-5597-1-git-send-email-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1318814794-5597-1-git-send-email-cmaiolino@redhat.com>
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
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com

On Sun, Oct 16, 2011 at 11:26:34PM -0200, Carlos Maiolino wrote:
> This patch fix a possible memory corruption when
> the link is larger than MAXPATHLEN and XFS_DEBUG
> is not enabled. This also uses S_IFLNK to check
> link not only in DEBUG mode.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

Well found, Carlos. A few comments on the fix below.

> ---
>  fs/xfs/xfs_vnodeops.c |   18 ++++++++++++++++--
>  1 files changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
> index 51fc429..3f4fbd5 100644
> --- a/fs/xfs/xfs_vnodeops.c
> +++ b/fs/xfs/xfs_vnodeops.c
> @@ -123,8 +123,22 @@ xfs_readlink(
>  
>  	xfs_ilock(ip, XFS_ILOCK_SHARED);
>  
> -	ASSERT(S_ISLNK(ip->i_d.di_mode));
> -	ASSERT(ip->i_d.di_size <= MAXPATHLEN);
> +	if (unlikely(!(S_ISLNK(ip->i_d.di_mode))) ||
> +	    unlikely(!(ip->i_d.di_size <= MAXPATHLEN ))){

No need for the unlikely - the hardware generally handles branch
prediction better than we can. ;)

> +
> +		XFS_CORRUPTION_ERROR("xfs_readlink",
> +		XFS_ERRLEVEL_HIGH, mp, ip);

At first glance this looks like the "right" error reporting macro to
use, but it realy isn't: XFS_CORRUPTION_ERROR() is for reporting
details of the on-disk structure that is corrupted. Basically it is
used to dump the first chunk of the disk buffer/structure that the
error was found in, but we only have in-memory state here so there's
nothing to dump. Yes, we can dump the first 16 bytes of ip, but that
just gets us a couple of memory pointers which has nothing to do
with the corruption just detected.

> +#ifdef DEBUG
> +		xfs_emerg(mp, "inode (%lld), link too long or not a link."
> +			 (unsigned long long)ip->i_no);
                                                 ^^^^ i_ino
> +
> +		ASSERT(S_ISLNK(ip->i_d.di_mode));
> +		ASSERT(ip->i_d.di_size <= MAXPATHLEN);

Not much point putting a second print for only debug kernels - if
it's useful information about the corruption (e.g. the inode
number), then it should be emitted for non-debug kernels, too. Yeah,
I know you probably copied it from somewhere else (like
xfs_imap_to_bmap()), but for all new detected corruptions having
some indication on normal production machines of where the
corruption was detected is very important.

IOWs, I'd simply be replacing the ASSERT()s with something like this:

	if (!(S_ISLNK(ip->i_d.di_mode) && ip->i_d.di_size <= MAXPATHLEN)) {
		xfs_alert(mp, "inode %lld: link too long (%) or not a link."
			 (unsigned long long)ip->i_ino, i_d.di_size);
		ASSERT(0);
		return XFS_ERROR(EFSCORRUPTED);
	}

It will still assert fail on a debug kernel, with enough information
to tell us exactly which condition failed. And it will detect and
return an error on a non-debug kernel, too.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
