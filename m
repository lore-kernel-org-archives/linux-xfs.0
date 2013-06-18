Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 43C8129DF8
	for <xfs@oss.sgi.com>; Mon, 17 Jun 2013 23:49:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E3201AC003
	for <xfs@oss.sgi.com>; Mon, 17 Jun 2013 21:49:36 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	kc76ARd5iSmUGn9u for <xfs@oss.sgi.com>;
	Mon, 17 Jun 2013 21:49:34 -0700 (PDT)
Date: Tue, 18 Jun 2013 14:49:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix sgid inheritance for subdirectories inheriting
	default acls
Message-ID: <20130618044931.GQ29338@dastard>
References: <1371238877-5722-1-git-send-email-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1371238877-5722-1-git-send-email-cmaiolino@redhat.com>
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

On Fri, Jun 14, 2013 at 04:41:17PM -0300, Carlos Maiolino wrote:
> XFS removes sgid bits of subdirectories created under a directory containing a
> default acl.
> 
> When a default acl is set, it implies xfs to call xfs_setattr_nonsize() in its
> code path. Such function is shared among mkdir and chmod system calls, and
> does some checks unneeded by mkdir (calling inode_change_ok()). Such checks
> remove sgid bit from the inode after it has been granted. So, this patch wraps
> up these checks to be used only in chmod path.
> 
> Also, chmod should not remove sgid bit from an inode if this is a directory, so,
> it adds a check if S_ISDIR is set in the inode mode, into xfs_setattr_nonsize()
> 
> Done that, xfs_setattr_mode() doesn't need to re-check for group id and
> capabilities permissions, this only implies in another try to remove sgid bit
> from the directories. Such check is already done either on inode_change_ok() or
> xfs_setattr_nonsize().
> 
> This addresses SGI bug 280:
> http://oss.sgi.com/bugzilla/show_bug.cgi?id=280

I guess that shows how urgent fixing this behaviour is ;)

> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/xfs/xfs_iops.c |   51 ++++++++++++++++++++++++++++++++++-----------------
>  1 files changed, 34 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index ca9ecaa..5c9c505 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -467,9 +467,6 @@ xfs_setattr_mode(
>  	ASSERT(tp);
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
>  
> -	if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
> -		mode &= ~S_ISGID;
> -
>  	ip->i_d.di_mode &= S_IFMT;
>  	ip->i_d.di_mode |= mode & ~S_IFMT;
>  
> @@ -477,23 +474,20 @@ xfs_setattr_mode(
>  	inode->i_mode |= mode & ~S_IFMT;
>  }
>  
> +/* Check inode permissions and filesystem errors
> + *
> + * Wrapper to some pre-checks needed while changing
> + * inode attributes
> + */
>  int
> -xfs_setattr_nonsize(
> +xfs_setattr_setup(

The change looks fine from a functional POV, but that is a bit of a
strange name and structure. :/

What the fix introduces is a 3rd setattr code paths:

	1. xfs_setattr_size();
	2. xfs_setattr_nonsize();

and the new one:

	3. xfs_setattr_nonsize_nomodecheck();

It's obvious that xfs_setattr_nonsize() is just
xfs_setattr_nonsize_nomodecheck() with a couple of extra checks, and
so the structure should probably be:

	xfs_setattr_nonsize_nomodecheck()
	{
		do the changes
	}

	xfs_setattr_nonsize()
	{
		inode_change_ok()

		return xfs_setattr_nonsize_nomodecheck()
	}

	xfs_set_mode()
	{
		setup iattr
		return xfs_setattr_nonsize_nomodecheck()
	}


That way the code is pretty clear that the normal setattr path does
checks on the way in, while the ACL code does not need to do them.
i.e the code documents itself as being intentional behaviour...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
