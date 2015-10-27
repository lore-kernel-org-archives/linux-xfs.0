Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3F3897F37
	for <xfs@oss.sgi.com>; Tue, 27 Oct 2015 17:37:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 221758F8033
	for <xfs@oss.sgi.com>; Tue, 27 Oct 2015 15:37:31 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Waz8mL1tmgbwIDie for <xfs@oss.sgi.com>;
	Tue, 27 Oct 2015 15:37:27 -0700 (PDT)
Date: Wed, 28 Oct 2015 09:37:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/4] xfs: SGI ACLs: Map uid/gid namespaces
Message-ID: <20151027223724.GM19199@dastard>
References: <1445721369-25679-1-git-send-email-agruenba@redhat.com>
	<1445721369-25679-4-git-send-email-agruenba@redhat.com>
	<20151026214651.GJ8773@dastard>
	<CAHc6FU7YbdmH+S0HZUg1cL++NM4FXFot=GLBr1_6HPhJSP+dvA@mail.gmail.com>
	<20151027195502.GN8773@dastard>
	<CAHc6FU4+z_1EqJHHpv7yPgO_s6k2gpcmq_zBofYyudAtK-bFyg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAHc6FU4+z_1EqJHHpv7yPgO_s6k2gpcmq_zBofYyudAtK-bFyg@mail.gmail.com>
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
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Tue, Oct 27, 2015 at 10:10:26PM +0100, Andreas Gruenbacher wrote:
> On Tue, Oct 27, 2015 at 8:55 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Tue, Oct 27, 2015 at 04:55:22PM +0100, Andreas Gruenbacher wrote:
> > But now that I've thought about this a bit more, I don't think that
> > the changes you've made are correct - we shouldn't be doing uid/gid
> > namespace conversion in disk formating functions. That is, the
> > conversion of user/group types should be done at the incoming layers
> > (i.e. at VFS/ioctl layers), not deep in the guts of the XFS code.
> 
> There are two kinds of code paths where we need to convert between the
> SGI_ACL and the kernel's in-memory representation (struct posix_acl
> *): one is in the get_acl and set_acl iops, converting to/from the
> actual on-disk attrbutes, and the actual IDs stay the same. The other
> is in the get and set SGI_ACL xattr handlers which are invoked from
> the getxattr and setxattr iops. The conversion there is to/from the
> user-facing SGI_ACL xattrs, and ID mappings may be in effect.

And then we have the ioctls XFS_IOC_ATTRLIST_BY_HANDLE and
XFS_IOC_ATTRMULTI_BY_HANDLE which can directly access the ACL xattrs
without even going through the the getxattr and setxattr iops. They
go direct to xfs_attr_get/xfs_attr_set() and set/return the xattrs
with *exactly* what the caller/on-disk xattr provides.

IOWs, you've only addressed one possible vector for direct access to
the SGI_ACL xattrs....

> The VFS doesn't know anything about the SGI_ACL attributes, so XFS
> will have to do the ID mappings itself. We could convert the IDS
> in-place in separate pre- / post-passes over the xattr value and leave
> xfs_acl_from_disk and xfs_acl_to_disk alone. That's what the VFS does
> for POSIX ACLs. The problem there is that the setxattr iop and set
> xattr handler give us a const void * value; we cannot modify it
> without casting const away. Hence the additional namespace parameter
> to xfs_acl_from_disk and xfs_acl_to_disk instead.

Yes, I read your patches - you take a low level disk formating
function and make it also work as a high level conversion function
through a different interface that has no higher level conversion
interface. i.e. you're changing the user visible behaviour of
writing a specific xattr.

But I think it's also wrong: users are not supposed to manipulate
SGI_ACL_FILE/SGI_ACL_DEFAULT xattrs directly.  Just because root can
see them doesn't mean users should be touching them - users should
be using the kernel posix ACL interface/namespace to modify their
ACLs.

OTOH, xfsdump/restore require direct, unfiltered access to set
uid/gid/mode/xattrs exactly as they are found. Changing that
behaviour like your change does will break xfsdump/restore and
breaking userspace is not a negotiable option.

> > Why do you think we added the wrappers in the first place? It was
> > because the ns maintainer refused to follow standard, self
> > documenting type conversion naming conventions of <type>_to_<type>
> > so we added them ourselves. The user namespace code is horrible
> > enough without adding confusing type change functions everywhere...
> 
> Well, so far these functions were at least hiding the &init_user_ns
> part, they didn't just introduce XFS specific names for generic
> things.

That was precisely the reason they were introduced - the higher
levels should already be doing namespace conversions before anything
gets to the filesystem disk formatting routines. Hence the
&init_user_ns bullshit for getting a raw uid is just noise.

> It would be sad if every subsystem introduced their own names
> when they don't like the generic ones.

It was a symptom of the much larger problem: the userns maintainer
refusing or ignoring *all* requests to change anything or answer any
questions about how things like dump/restore is supposed to work
across user namespaces. Hence, for better or for worse, we were
forced to make up our own rules on how dump/restore and mapped ids
are supposed to interact....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
