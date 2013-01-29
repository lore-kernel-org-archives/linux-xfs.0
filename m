Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1542A7F4E
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 21:31:12 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EA6BC304059
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 19:31:08 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Dt0b1vAtLDnk8SEc for <xfs@oss.sgi.com>;
	Mon, 28 Jan 2013 19:31:07 -0800 (PST)
Date: Tue, 29 Jan 2013 14:31:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: remove unneeded ASSERT from xfs_itruncate_extents
Message-ID: <20130129033105.GD7255@disturbed.disaster>
References: <1359381870-30908-1-git-send-email-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1359381870-30908-1-git-send-email-cmaiolino@redhat.com>
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
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com

On Mon, Jan 28, 2013 at 09:04:30AM -0500, Carlos Maiolino wrote:
> There is no reason to ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL)); twice, so,
> remove one of these ASSERT calls

Second assert is for the IOLOCK, not the ILOCK....

> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/xfs/xfs_inode.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 66282dc..25226ea 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1396,8 +1396,7 @@ xfs_itruncate_extents(
>  	int			done = 0;
>  
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> -	ASSERT(!atomic_read(&VFS_I(ip)->i_count) ||
> -	       xfs_isilocked(ip, XFS_IOLOCK_EXCL));
> +	ASSERT(!atomic_read(&VFS_I(ip)->i_count));

The code is correct. The ASSERT is testing the locking constraints on
the XFS_IOLOCK_EXCL. That is, if xfs_itruncate_extents() is called
in the VFS inode reclaim path (i.e. via xfs_inactive()), the IO lock
is not used (throws lockdep warnings). Hence the ASSERT is checking
that if we hold an inode reference, we are also holding the IO lock.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
