Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 673EF7F69
	for <xfs@oss.sgi.com>; Mon,  5 May 2014 05:24:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3873B8F8040
	for <xfs@oss.sgi.com>; Mon,  5 May 2014 03:24:08 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	fgSGCrkL8DvKICKL for <xfs@oss.sgi.com>;
	Mon, 05 May 2014 03:24:06 -0700 (PDT)
Date: Mon, 5 May 2014 20:24:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: initialize default acls for ->tmpfile()
Message-ID: <20140505102403.GV26353@dastard>
References: <1398951487-15462-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1398951487-15462-1-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, May 01, 2014 at 09:38:07AM -0400, Brian Foster wrote:
> The current tmpfile handler does not initialize default ACLs. Doing so
> within xfs_vn_tmpfile() makes it roughly equivalent to xfs_vn_mknod(),
> which is already used as a common create handler.
> 
> xfs_vn_mknod() does not currently have a mechanism to determine whether
> to link the file into the namespace. Therefore, further abstract
> xfs_vn_mknod() into a new xfs_generic_create() handler with a tmpfile
> parameter. This new handler passes a NULL xname to the create and calls
> d_tmpfile() on the dentry when called via ->tmpfile().
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> Hi all,
> 
> It appears that we want to initialize default ACLs for ->tmpfile() after
> all. This patch reintroduces the refactoring to initialize security and
> ACLs through the current xfs_vn_mknod(). This is based on top of the
> previously posted series:
> 
> 	http://oss.sgi.com/archives/xfs/2014-04/msg00396.html
> 
> Brian
.....
> @@ -1053,25 +1074,7 @@ xfs_vn_tmpfile(
>  	struct dentry	*dentry,
>  	umode_t		mode)
>  {
> -	int			error;
> -	struct xfs_inode	*ip;
> -	struct inode		*inode;
> -
> -	error = xfs_create(XFS_I(dir), NULL, mode, 0, &ip);
> -	if (unlikely(error))
> -		return -error;
> -
> -	inode = VFS_I(ip);
> -
> -	error = xfs_init_security(inode, dir, &dentry->d_name);
> -	if (unlikely(error)) {
> -		iput(inode);
> -		return -error;
> -	}
> -
> -	d_tmpfile(dentry, inode);
> -
> -	return 0;
> +	return xfs_generic_create(dir, dentry, mode, 0, true);
>  }

This hunk doesn't apply to a 3.15-rc2 kernel - it calls
xfs_create_tmpfile(). Just applying it as is after fixing the hunk
causes a crash in xfs-create(), because the code in the patch is
calling xfs-create ratehr than xfs_create_tmpfile().

Brian, can you regenerate this patch against a current linus tree
(3.15-rc4)?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
