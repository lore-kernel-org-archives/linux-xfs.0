Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 33D407F37
	for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 20:29:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2517D304093
	for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 18:29:33 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	23qjhhtm0JmC5T8t for <xfs@oss.sgi.com>;
	Thu, 25 Jul 2013 18:29:31 -0700 (PDT)
Date: Fri, 26 Jul 2013 11:29:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v6 6/7] xfs: add permission check to free eofblocks ioctl
Message-ID: <20130726012927.GC21982@dastard>
References: <20130725114946.13c7e4ad@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130725114946.13c7e4ad@oracle.com>
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
To: Dwight Engen <dwight.engen@oracle.com>
Cc: xfs@oss.sgi.com

On Thu, Jul 25, 2013 at 11:49:46AM -0400, Dwight Engen wrote:
> We need to check that userspace callers can only truncate preallocated
> blocks from files they have write access to to prevent them from prematurley
> reclaiming blocks from another user. The internal reclaimer will not specify
> the internal XFS_KEOF_FLAGS_PERM_CHECK flag, but callers from userspace will
> have it forced on.
> 
> Add check for read-only filesystem to free eofblocks ioctl.

OK, so let me preface this by saying I understand a lot more about
user namespaces that I did a week ago...

Firstly, this ioctls allows any user to call this function with
arbitrary uid/gid/prid values here. Regardless of user namespaces, I
think that the only UID/GID that should be allowed to be passed for
a user context is their own UID/GID. There's no point in allowing a
scan if the inode_permission()/uid/gid matching checks are always
going to fail.

Secondly, because a user can issue an arbitrary number of concurrent
scans, I'd suggest we serialise all user scans through a per-mount
mutex. i.e. there can only be one user scan in progress at a time.
For users with capable(CAP_SYS_ADMIN), we don't need to serialise
them as we let root in the init userns shoot themselves in the foot
all they want.

Thirdly, project quotas are not really a user controlled resource
and so I don't think we want users calling this ioctl to trim
project quotas. Indeed, the files in the project that need trimming
may not even belong to the user running the scan, and hence the
user will never be allowed to trim the EOF blocks.

Further, project quotas might underly the namespace container and be
used for limiting the disk space the namespace container uses. In
which case, we don't even want access to the project ID scanning
from within the namespace.

Because of this, I'd suggest that project ID scans need a
"capable(CAP_SYS_ADMIN)" check on them. This means a project ID scan
can only be run from the init_userns - it cannot be done from within
the userns container at all.

.....
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index ed35584..a80f38c 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1247,6 +1247,10 @@ xfs_inode_free_eofblocks(
>  		if (!xfs_inode_match_id(ip, eofb))
>  			return 0;
>  
> +		if ((eofb->eof_flags & XFS_KEOF_FLAGS_PERM_CHECK) &&
> +		    inode_permission(VFS_I(ip), MAY_WRITE))
> +			return 0;

Lastly, what happens if this inode_permission() call occurs in the
context of a kworker thread. What userns does an anonymous kworker
thread run in? It's the init userns, right? so:

	inode_permission(inode, MAY_WRITE);
	  generic_permission(inode, MAY_WRITE)
	    inode_capable(inode, CAP_DAC_OVERRIDE)
	    {
		ns = current_user_ns();
		return ns_capable(ns, cap) &&
			kuid_has_mapping(ns, inode->i_uid);
	    }

If we are running in the init_userns as a kernel thread, the
ns_capable() check will return true, and there's always a mapping in
the init namespace so kuid_has_mapping() will return true. Hence
we'll always have write permission to every inode we check,
regardless of the XFS_KEOF_FLAGS_PERM_CHECK flag.

IOWs, this permission check is useless if we run the scan via a
workqueue. Hence we need to be *very careful* with the way we
execute scans and so this needs big, loud comments around it to
remind us to be careful in the future.

> +#define XFS_KEOF_FLAGS_PERM_CHECK	(1 << 31) /* check can write inode */
> +#if XFS_KEOF_FLAGS_PERM_CHECK & XFS_EOF_FLAGS_VALID
> +#error "Internal XFS_KEOF_FLAGS_PERM_CHECK duplicated bit from XFS_EOF_FLAGS_VALID"
> +#endif

BUILD_BUG_ON() is the preferred method of doing this. Say, in
xfs_super.c::init_xfs_fs().

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
