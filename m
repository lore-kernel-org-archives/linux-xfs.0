Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9IEPMjc101760 for <xfs@oss.sgi.com>; Tue, 18 Oct 2011 09:25:22 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2ADCB1480B7B
	for <xfs@oss.sgi.com>; Tue, 18 Oct 2011 07:33:16 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id e909prwhEp1JVLui for <xfs@oss.sgi.com>;
	Tue, 18 Oct 2011 07:33:16 -0700 (PDT)
Message-ID: <4E9D8C4E.5020107@sandeen.net>
Date: Tue, 18 Oct 2011 09:25:18 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] Fix possible memory corruption in xfs_readlink
References: <1318911538-9174-1-git-send-email-cmaiolino@redhat.com>
In-Reply-To: <1318911538-9174-1-git-send-email-cmaiolino@redhat.com>
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

On 10/17/11 11:18 PM, Carlos Maiolino wrote:
> Fixes a possible memory corruption when the link is larger than
> MAXPATHLEN and XFS_DEBUG is not enabled. This also remove the
> S_ISLNK assert, since the inode mode is checked previously in
> xfs_readlink_by_handle() and via VFS.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

Thanks!

Discussed-to-death-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/xfs/xfs_vnodeops.c |   11 ++++++++---
>  1 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
> index 51fc429..c3288be 100644
> --- a/fs/xfs/xfs_vnodeops.c
> +++ b/fs/xfs/xfs_vnodeops.c
> @@ -123,13 +123,18 @@ xfs_readlink(
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
> +	if (pathlen > MAXPATHLEN) {
> +		xfs_alert(mp, "%s: inode (%llu) symlink length (%d) too long",
> +			 __func__, (unsigned long long)ip->i_ino, pathlen);
> +		ASSERT(0);
> +		return XFS_ERROR(EFSCORRUPTED);
> +	}
> +
> +
>  	if (ip->i_df.if_flags & XFS_IFINLINE) {
>  		memcpy(link, ip->i_df.if_u1.if_data, pathlen);
>  		link[pathlen] = '\0';

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
