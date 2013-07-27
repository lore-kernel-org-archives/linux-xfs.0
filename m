Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 552967F67
	for <xfs@oss.sgi.com>; Fri, 26 Jul 2013 20:09:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 319A78F8035
	for <xfs@oss.sgi.com>; Fri, 26 Jul 2013 18:09:59 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	6yeqOx0VV7DZS7Ab for <xfs@oss.sgi.com>;
	Fri, 26 Jul 2013 18:09:56 -0700 (PDT)
Date: Sat, 27 Jul 2013 11:09:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v6 6/7] xfs: add permission check to free eofblocks ioctl
Message-ID: <20130727010952.GQ13468@dastard>
References: <20130725114946.13c7e4ad@oracle.com>
	<20130726012927.GC21982@dastard>
	<20130726152937.2eb3b4f0@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130726152937.2eb3b4f0@oracle.com>
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
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Fri, Jul 26, 2013 at 03:29:37PM -0400, Dwight Engen wrote:
> On Fri, 26 Jul 2013 11:29:27 +1000
> Dave Chinner <david@fromorbit.com> wrote:
> 
> > On Thu, Jul 25, 2013 at 11:49:46AM -0400, Dwight Engen wrote:
> > > We need to check that userspace callers can only truncate
> > > preallocated blocks from files they have write access to to prevent
> > > them from prematurley reclaiming blocks from another user. The
> > > internal reclaimer will not specify the internal
> > > XFS_KEOF_FLAGS_PERM_CHECK flag, but callers from userspace will
> > > have it forced on.
> > > 
> > > Add check for read-only filesystem to free eofblocks ioctl.
> > 
> > OK, so let me preface this by saying I understand a lot more about
> > user namespaces that I did a week ago...
> > 
> > Firstly, this ioctls allows any user to call this function with
> > arbitrary uid/gid/prid values here. Regardless of user namespaces, I
> > think that the only UID/GID that should be allowed to be passed for
> > a user context is their own UID/GID. There's no point in allowing a
> > scan if the inode_permission()/uid/gid matching checks are always
> > going to fail.
> 
> Hi Dave, I agree this patch isn't really about user namespaces. The
> reason for using inode_permission instead of just checking
> eofblocks->gid == current_fsgid is that the caller might want to trim
> an inode they have group write to but is not current_fsgid.

Sure. in_group_p() can be used to check if the user is a member of
the gid passed in. That's all inode_permission() ends up doing...

> When a caller passes in a uid/gid/projid, they are asking us to
> consider a smaller subset of inodes for trimming. If they don't pass in
> uid/gid/projid, the list of inodes is unfiltered and the
> inode_permission is what ensures they should be able to effect a
> particular inode.

A user should not be able to scan the world - they should only be
allowed to ask for scans that match their permissions.  That is, we
need to be restrictive by default, not permissive. It's easy to
relax permission in future if there is a need, but right now I think
we need to err on the side of caution and scrictly defining the
uids/gids we allow users to specify.

This doesn't mean we don't need the inode_permission() check in the
mechanism that does the scanning - what I'm talking about here is
strictly defining the interface and hence behaviour we expose to
userspace here.

> > Secondly, because a user can issue an arbitrary number of concurrent
> > scans, I'd suggest we serialise all user scans through a per-mount
> > mutex. i.e. there can only be one user scan in progress at a time.
> > For users with capable(CAP_SYS_ADMIN), we don't need to serialise
> > them as we let root in the init userns shoot themselves in the foot
> > all they want.
> 
> I can add this.
>  
> > Thirdly, project quotas are not really a user controlled resource
> > and so I don't think we want users calling this ioctl to trim
> > project quotas. Indeed, the files in the project that need trimming
> > may not even belong to the user running the scan, and hence the
> > user will never be allowed to trim the EOF blocks.
> > 
> > Further, project quotas might underly the namespace container and be
> > used for limiting the disk space the namespace container uses. In
> > which case, we don't even want access to the project ID scanning
> > from within the namespace.
> > 
> > Because of this, I'd suggest that project ID scans need a
> > "capable(CAP_SYS_ADMIN)" check on them. This means a project ID scan
> > can only be run from the init_userns - it cannot be done from within
> > the userns container at all.
> 
> I don't think this would be preventing anything the user can already do:
> the user just doesn't specify a projid and so we will just look at all
> the nodes.

Sure, but you are missing the point of what I was trying to get
across: We should not allow users to do unfiltered scans. i.e. they
must be explicit in their scan request, and have explicit ownership
of the inodes that are trimmed. We didn't get this right in the
initial implementation, but given that there aren't any users of the
interface outside of prototype code, we still have the flexibility
to restrict it down.

The reason this is so complex is that the scan is not namespace
aware, and so files hidden behind limited accees directory
permissions would be considered targets of eof trimming even though
the user doesn't have access to the files or even know they exist.

That's the big issue here - inode_permission() assumes that we've
already done all the directory traversal permission checks to
determine that we actually have permission to know about the inode's
existance. Here we are doing a cache traversal that doesn't know
anything about the heirarchy.

Hence we must be restrictive for user-driven scans, otherwise
they can affect files that they would not otherwise have access to.
That's why I'm suggesting that they should be limited to a direct
matches with their uid and primary gid.

Supplemental gids are problematic as they are often used for
defining special permissions (e.g. sudo groups), and so perhaps we
should limit gid scans to groups that have quota limits associated
with them (i.e. only the groups that a group-based scan is relevant
to).

> Specifying a uid/gid/projid only filters/limits the amount of
> nodes we'll consider, which I think could be useful ie. the caller
> passes in a projid which will only trim inodes that match the projid
> and which the caller has inode_permission to.

See my comments about the problems with using inode_permission()
like this above.

In addition to the lack of namespace checking, the project ID might
be a property controlled externally to the user namespace. Hence we
cannot allow users within a namespace to filter on it at all.
Indeed, we need to ensure that the quota interfaces won't allow the
project id limits to be modified, that queries for project quotas
are rejected from within namespaces, etc.

Basically, until we have worked out *if* project quotas can be used
safely within user namespaces, we need to reject any attempt to use
them from within a user namespace container.

> > .....
> > > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > > index ed35584..a80f38c 100644
> > > --- a/fs/xfs/xfs_icache.c
> > > +++ b/fs/xfs/xfs_icache.c
> > > @@ -1247,6 +1247,10 @@ xfs_inode_free_eofblocks(
> > >  		if (!xfs_inode_match_id(ip, eofb))
> > >  			return 0;
> > >  
> > > +		if ((eofb->eof_flags & XFS_KEOF_FLAGS_PERM_CHECK)
> > > &&
> > > +		    inode_permission(VFS_I(ip), MAY_WRITE))
> > > +			return 0;
> > 
> > Lastly, what happens if this inode_permission() call occurs in the
> > context of a kworker thread. What userns does an anonymous kworker
> > thread run in? It's the init userns, right? so:
> > 
> > 	inode_permission(inode, MAY_WRITE);
> > 	  generic_permission(inode, MAY_WRITE)
> > 	    inode_capable(inode, CAP_DAC_OVERRIDE)
> > 	    {
> > 		ns = current_user_ns();
> > 		return ns_capable(ns, cap) &&
> > 			kuid_has_mapping(ns, inode->i_uid);
> > 	    }
> > 
> > If we are running in the init_userns as a kernel thread, the
> > ns_capable() check will return true, and there's always a mapping in
> > the init namespace so kuid_has_mapping() will return true. Hence
> > we'll always have write permission to every inode we check,
> > regardless of the XFS_KEOF_FLAGS_PERM_CHECK flag.
> > 
> > IOWs, this permission check is useless if we run the scan via a
> > workqueue. Hence we need to be *very careful* with the way we
> > execute scans and so this needs big, loud comments around it to
> > remind us to be careful in the future.
> 
> Right, the XFS_KEOF_FLAGS_PERM_CHECK flag should not be on for internal
> contexts so the inode_permission check won't even be done (and it would
> pass anyway as you mention). I can add a big comment that
> XFS_KEOF_FLAGS_PERM_CHECK should only be used from process context
> because it won't work otherwise.

I thikn you missed my point - there's nothing stopping code in a
user context from doing:

	queue_work(......)
	flush_workqueue(....)

and that work is run in the context of a workqueue and the above
issue with inode_permission() comes for the fore. That's a *massive*
security hole and the only way we can avoid that is by making sure
everyone knows about the restrictions permission checking place on a
specific code path.

We are trending towards pushing more and more work into workqueues
for async processing.  If we are architecting code that is required
to run in user context for security reasons, we need big, loud
comments all over that code reminding us of this fact. I rely on
comments in the code to remind me why we did something 2-3 years
ago. I do not want to have to search list archives or git history
just to find out something that could have easily been docuemented
in a 5 line comment...

IMO, the XFS_KEOF_FLAGS_PERM_CHECK flag is not sufficient to
document this restriction - my point was that it is redundant. i.e.
it is only used for workqueue based scans where the permission
checks don't restrict anything...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
