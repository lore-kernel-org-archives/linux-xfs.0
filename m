Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EB8AE29E21
	for <xfs@oss.sgi.com>; Fri, 26 Jul 2013 14:30:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 97822AC002
	for <xfs@oss.sgi.com>; Fri, 26 Jul 2013 12:30:24 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id Ip1RCNNXHrF1hnXA (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 26 Jul 2013 12:30:15 -0700 (PDT)
Date: Fri, 26 Jul 2013 15:29:37 -0400
From: Dwight Engen <dwight.engen@oracle.com>
Subject: Re: [PATCH v6 6/7] xfs: add permission check to free eofblocks ioctl
Message-ID: <20130726152937.2eb3b4f0@oracle.com>
In-Reply-To: <20130726012927.GC21982@dastard>
References: <20130725114946.13c7e4ad@oracle.com>
	<20130726012927.GC21982@dastard>
Mime-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Fri, 26 Jul 2013 11:29:27 +1000
Dave Chinner <david@fromorbit.com> wrote:

> On Thu, Jul 25, 2013 at 11:49:46AM -0400, Dwight Engen wrote:
> > We need to check that userspace callers can only truncate
> > preallocated blocks from files they have write access to to prevent
> > them from prematurley reclaiming blocks from another user. The
> > internal reclaimer will not specify the internal
> > XFS_KEOF_FLAGS_PERM_CHECK flag, but callers from userspace will
> > have it forced on.
> > 
> > Add check for read-only filesystem to free eofblocks ioctl.
> 
> OK, so let me preface this by saying I understand a lot more about
> user namespaces that I did a week ago...
> 
> Firstly, this ioctls allows any user to call this function with
> arbitrary uid/gid/prid values here. Regardless of user namespaces, I
> think that the only UID/GID that should be allowed to be passed for
> a user context is their own UID/GID. There's no point in allowing a
> scan if the inode_permission()/uid/gid matching checks are always
> going to fail.

Hi Dave, I agree this patch isn't really about user namespaces. The
reason for using inode_permission instead of just checking
eofblocks->gid == current_fsgid is that the caller might want to trim
an inode they have group write to but is not current_fsgid.

When a caller passes in a uid/gid/projid, they are asking us to
consider a smaller subset of inodes for trimming. If they don't pass in
uid/gid/projid, the list of inodes is unfiltered and the
inode_permission is what ensures they should be able to effect a
particular inode.

> Secondly, because a user can issue an arbitrary number of concurrent
> scans, I'd suggest we serialise all user scans through a per-mount
> mutex. i.e. there can only be one user scan in progress at a time.
> For users with capable(CAP_SYS_ADMIN), we don't need to serialise
> them as we let root in the init userns shoot themselves in the foot
> all they want.

I can add this.
 
> Thirdly, project quotas are not really a user controlled resource
> and so I don't think we want users calling this ioctl to trim
> project quotas. Indeed, the files in the project that need trimming
> may not even belong to the user running the scan, and hence the
> user will never be allowed to trim the EOF blocks.
> 
> Further, project quotas might underly the namespace container and be
> used for limiting the disk space the namespace container uses. In
> which case, we don't even want access to the project ID scanning
> from within the namespace.
> 
> Because of this, I'd suggest that project ID scans need a
> "capable(CAP_SYS_ADMIN)" check on them. This means a project ID scan
> can only be run from the init_userns - it cannot be done from within
> the userns container at all.

I don't think this would be preventing anything the user can already do:
the user just doesn't specify a projid and so we will just look at all
the nodes. Specifying a uid/gid/projid only filters/limits the amount of
nodes we'll consider, which I think could be useful ie. the caller
passes in a projid which will only trim inodes that match the projid
and which the caller has inode_permission to.

> .....
> > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > index ed35584..a80f38c 100644
> > --- a/fs/xfs/xfs_icache.c
> > +++ b/fs/xfs/xfs_icache.c
> > @@ -1247,6 +1247,10 @@ xfs_inode_free_eofblocks(
> >  		if (!xfs_inode_match_id(ip, eofb))
> >  			return 0;
> >  
> > +		if ((eofb->eof_flags & XFS_KEOF_FLAGS_PERM_CHECK)
> > &&
> > +		    inode_permission(VFS_I(ip), MAY_WRITE))
> > +			return 0;
> 
> Lastly, what happens if this inode_permission() call occurs in the
> context of a kworker thread. What userns does an anonymous kworker
> thread run in? It's the init userns, right? so:
> 
> 	inode_permission(inode, MAY_WRITE);
> 	  generic_permission(inode, MAY_WRITE)
> 	    inode_capable(inode, CAP_DAC_OVERRIDE)
> 	    {
> 		ns = current_user_ns();
> 		return ns_capable(ns, cap) &&
> 			kuid_has_mapping(ns, inode->i_uid);
> 	    }
> 
> If we are running in the init_userns as a kernel thread, the
> ns_capable() check will return true, and there's always a mapping in
> the init namespace so kuid_has_mapping() will return true. Hence
> we'll always have write permission to every inode we check,
> regardless of the XFS_KEOF_FLAGS_PERM_CHECK flag.
> 
> IOWs, this permission check is useless if we run the scan via a
> workqueue. Hence we need to be *very careful* with the way we
> execute scans and so this needs big, loud comments around it to
> remind us to be careful in the future.

Right, the XFS_KEOF_FLAGS_PERM_CHECK flag should not be on for internal
contexts so the inode_permission check won't even be done (and it would
pass anyway as you mention). I can add a big comment that
XFS_KEOF_FLAGS_PERM_CHECK should only be used from process context
because it won't work otherwise.

> > +#define XFS_KEOF_FLAGS_PERM_CHECK	(1 << 31) /* check can
> > write inode */ +#if XFS_KEOF_FLAGS_PERM_CHECK & XFS_EOF_FLAGS_VALID
> > +#error "Internal XFS_KEOF_FLAGS_PERM_CHECK duplicated bit from
> > XFS_EOF_FLAGS_VALID" +#endif
> 
> BUILD_BUG_ON() is the preferred method of doing this. Say, in
> xfs_super.c::init_xfs_fs().

Sounds good, will do it there.
 
> Cheers,
> 
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
