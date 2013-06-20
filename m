Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 588CE7CBF
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 20:41:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D8501AC005
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 18:41:41 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	CnJpLWfmujz6HtY0 for <xfs@oss.sgi.com>;
	Wed, 19 Jun 2013 18:41:39 -0700 (PDT)
Date: Thu, 20 Jun 2013 11:41:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] userns: Convert xfs to use kuid/kgid where appropriate
Message-ID: <20130620014133.GN29338@dastard>
References: <20130619110948.0bfafa2b@oracle.com> <8761x9x2i5.fsf@xmission.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <8761x9x2i5.fsf@xmission.com>
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
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Eric W. Biederman" <ebiederm@gmail.com>, Dwight Engen <dwight.engen@oracle.com>, xfs@oss.sgi.com

On Wed, Jun 19, 2013 at 01:35:30PM -0700, Eric W. Biederman wrote:
> 
> I am copying my gmail address so I have a chance of seeing replies from
> Dave Chiner.  So far the only way I have been able to read his replies
> has been to read mailling lists.  Which has not be conductive to having
> this code discussed properly.  Hopefully copying my gmail address will
> allow us to have a reasonable and timely conversation.
> 
> 
> Dwight Engen <dwight.engen@oracle.com> writes:
> 
> > Use uint32 from init_user_ns for xfs internal uid/gid representation in
> > acl, xfs_icdinode. 
> 
> From my review of the code earlier that just isn't safe.  It allows all
> kinds of things to slip through.

Such as?

> > Conversion of kuid/gid is done at the vfs boundary,
> > other user visible xfs specific interfaces (bulkstat, eofblocks filter)
> > expect uint32 init_user_ns uid/gid values.
> 
> From my earlier review of the code conversion at the vfs boundary is
> not safe.    

So you've claimed.

> First off kuid_t and kgid_t are not a vfs concepts, they are linux
> kernel concepts, and xfs is in the linux kernel.  What makes this
> relevant is not all filesystem accesses are through the vfs so all of
> the necessary conversions for security and a consistent user experience
> can be had by only performing conversions at the user/kernel boundary.

Right. Boundaries and consistent conversion across them are
important. They are especially important in filesystems for
converting to/from on-disk and kernel-native formats. Blindly
pushing kernel structure down as far are you can make them reach
ignores important boundaries.

You might want to hit XFS with a big hammer but the right solution
is far more nuanced that that.

> In particular by being sloppy and not pushing kuid_t/kgid_t further down
> you did not handle all of the conversions needed at the user/kernel
> boundary in XFS_IOC_FREE_EOFBLOCKS.

The kuid_t/kgid_t is actually pushed down this far - it's in the
struct inode - the code currently uses the on-disk XFS uid/gid,
not the struct inode's kuid_t/kgid_t. That's easily fixable.

Indeed, that's where most of the work needs to be done in XFS -
using VFS(ip)->i_uid instead of ip->i_d.di_uid in places where we
aren't dealing with reading or modifying the on-disk structures of
XFS. Once that is done, we will have driven kuid_t/kgid_t as far
down as the in-memory/on-disk format boundary allows, and we'll end
up catching all the sorts of problems you are worried about.

> Which can be called by an
> unprivileged user.

That's an oversite. Needs fixing.

> I honestly don't think avoiding the push down of kuid_t and kgid_t to
> all of the xfs in-core data structures is safe.  Even if the initial
> patch is safe I expect there will be silent breakage when the next ioctl
> that bypasses the vfs is added.

This problem isn't isolated to XFS - ioctls are added to ext4,
btrfs, gfs2, etc in every release and they all face the same
problems.  Hence trying to paint it as an XFS problem is realy
missing the mark....

I'd really like to see some regressions tests in xfstests that we
can use to confirm that filesystems have implemented namespaces
properly (e.g. quota set/get/report tests). That would go a long way
to ensuring that people don't inadvertantly. I'm sure you have some
test scripts for testing all the changes you made, so sharing them
would help us a lot.

[ Hmmmm - the quota netlink warning interface - it just takes a
warning for a specific kqid and emits it to all listeners on the
netlink interface. There's no namespace awareness there, so what
stops quota warning messages from one namespace being heard in all
other namespaces? It's not network namespace aware.... ]

As it is, I'm far more concerned about the security problems
existing ioctls and interfaces pose for user namespaces. i.e. that
CAP_SYS_ADMIN in any namespace can use bulkstat and then the
fs/fhandle.c interfaces to find and access any file in the
filesystem regardless of namespace restrictions. You can guess
filehandles pretty trivially, so you don't need bulkstat and you
don't need XFS for this to be a problem....

Further, bulkstat is used by backup utilities, so I think it needs
the unmodified uid/gid/prid to be passed out, and the restore
program needs a way to push them all back in unmodified. How would
you propose we go about doing this. Alternatively could you tell us
how a sub-namespace level backup/restore program supposed to
handle/detect/avoid being invoked from inside a restricted,
non-global namespace?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
