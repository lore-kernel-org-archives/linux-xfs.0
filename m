Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4E4047F62
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 10:53:27 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D5BA7AC001
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 08:53:26 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id smSzz3KJKnD3r7Ly for
	<xfs@oss.sgi.com>; Mon, 28 Jan 2013 08:53:26 -0800 (PST)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r0SGrPug028940
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 11:53:25 -0500
Received: from andromeda.usersys.redhat.com (ovpn-113-142.phx2.redhat.com
	[10.3.113.142])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id r0SGrMGs029426
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 11:53:24 -0500
Date: Mon, 28 Jan 2013 11:53:21 -0500
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs: re-organize XFS_ILOCK asserts in
	xfs_itruncate_extents()
Message-ID: <20130128165321.GA4281@andromeda.usersys.redhat.com>
References: <1359391710-3862-1-git-send-email-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1359391710-3862-1-git-send-email-cmaiolino@redhat.com>
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
To: xfs@oss.sgi.com

Please discard this patch, I left a doubled assert by mistake, my apologies for
that

On Mon, Jan 28, 2013 at 11:48:30AM -0500, Carlos Maiolino wrote:
> An logically OR'red assert for check an inode locked in XFS_ILOCK_EXCL and
> XFS_IOLOCK_EXCL looks better than the old way, avoiding possible mistakes while
> readin the code
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/xfs/xfs_inode.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 66282dc..f7efe77 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1395,9 +1395,10 @@ xfs_itruncate_extents(
>  	int			error = 0;
>  	int			done = 0;
>  
> -	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> -	ASSERT(!atomic_read(&VFS_I(ip)->i_count) ||
> +	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL) ||
>  	       xfs_isilocked(ip, XFS_IOLOCK_EXCL));
> +	ASSERT(!atomic_read(&VFS_I(ip)->i_count));
> +	ASSERT(!atomic_read(&VFS_I(ip)->i_count));
>  	ASSERT(new_size <= XFS_ISIZE(ip));
>  	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
>  	ASSERT(ip->i_itemp != NULL);
> -- 
> 1.8.1
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
