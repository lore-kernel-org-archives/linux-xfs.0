Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:34630 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725884AbfGWXMX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Jul 2019 19:12:23 -0400
Date: Wed, 24 Jul 2019 09:11:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: allocate xattr buffer on demand
Message-ID: <20190723231112.GT7689@dread.disaster.area>
References: <20190722230518.19078-1-david@fromorbit.com>
 <20190723125205.GA59587@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190723125205.GA59587@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jul 23, 2019 at 08:52:05AM -0400, Brian Foster wrote:
> On Tue, Jul 23, 2019 at 09:05:18AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > When doing file lookups and checking for permissions, we end up in
> > xfs_get_acl() to see if there are any ACLs on the inode. This
> > requires and xattr lookup, and to do that we have to supply a buffer
> > large enough to hold an maximum sized xattr.
> > 
> > On workloads were we are accessing a wide range of cache cold files
> > under memory pressure (e.g. NFS fileservers) we end up spending a
> > lot of time allocating the buffer. The buffer is 64k in length, so
> > is a contiguous multi-page allocation, and if that then fails we
> > fall back to vmalloc(). Hence the allocation here is /expensive/
> > when we are looking up hundreds of thousands of files a second.
> > 
> > Initial numbers from a bpf trace show average time in xfs_get_acl()
> > is ~32us, with ~19us of that in the memory allocation. Note these
> > are average times, so there are going to be affected by the worst
> > case allocations more than the common fast case...
> > 
> > To avoid this, we could just do a "null"  lookup to see if the ACL
> > xattr exists and then only do the allocation if it exists. This,
> > however, optimises the path for the "no ACL present" case at the
> > expense of the "acl present" case. i.e. we can halve the time in
> > xfs_get_acl() for the no acl case (i.e down to ~10-15us), but that
> > then increases the ACL case by 30% (i.e. up to 40-45us).
> > 
> > To solve this and speed up both cases, drive the xattr buffer
> > allocation into the attribute code once we know what the actual
> > xattr length is. For the no-xattr case, we avoid the allocation
> > completely, speeding up that case. For the common ACL case, we'll
> > end up with a fast heap allocation (because it'll be smaller than a
> > page), and only for the rarer "we have a remote xattr" will we have
> > a multi-page allocation occur. Hence the common ACL case will be
> > much faster, too.
> > 
> > The down side of this is the buffer allocation is now a GFP_NOFS
> > allocation. This isn't a big deal for small allocations, though it
> > might cause large xattrs (which are out of line and doing
> > substantial GFP_NOFS allocations already) to have to do another
> > large allocation in this context. I think, however, this is rare
> > enough that it won't matter for the ACL path, and the common xattr
> > paths can still provide and external buffer...
> > 
> 
> Where's the NOFS allocation coming from?

As I mentioned to Darrick on #xfs, this is a stale comment from
development of the original prototype. When I reworked the code this
problem went away, but I forgot to remove it from the commit
message.

> 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_attr.c      | 23 ++++------
> >  fs/xfs/libxfs/xfs_attr.h      |  6 ++-
> >  fs/xfs/libxfs/xfs_attr_leaf.c | 85 +++++++++++++++++++++--------------
> >  fs/xfs/libxfs/xfs_da_btree.h  |  4 +-
> >  fs/xfs/xfs_acl.c              | 14 ++----
> >  fs/xfs/xfs_ioctl.c            |  2 +-
> >  fs/xfs/xfs_xattr.c            |  2 +-
> >  7 files changed, 72 insertions(+), 64 deletions(-)
> > 
> ...
> > diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
> > index cbda40d40326..cba1ea9d6d0a 100644
> > --- a/fs/xfs/xfs_acl.c
> > +++ b/fs/xfs/xfs_acl.c
> ...
> > @@ -130,17 +130,9 @@ xfs_get_acl(struct inode *inode, int type)
> >  		BUG();
> >  	}
> >  
> > -	/*
> > -	 * If we have a cached ACLs value just return it, not need to
> > -	 * go out to the disk.
> > -	 */
> >  	len = XFS_ACL_MAX_SIZE(ip->i_mount);
> > -	xfs_acl = kmem_zalloc_large(len, KM_SLEEP);
> > -	if (!xfs_acl)
> > -		return ERR_PTR(-ENOMEM);
> > -
> > -	error = xfs_attr_get(ip, ea_name, (unsigned char *)xfs_acl,
> > -							&len, ATTR_ROOT);
> > +	error = xfs_attr_get(ip, ea_name, (unsigned char **)&xfs_acl, &len,
> > +				ATTR_ALLOC|ATTR_ROOT);
> 
> This looks mostly fine to me aside from an interface nit. I find it
> strange that we need to specify a max value in len for an xattr of
> unknown length.

That's a quirk of the on-disk format. i.e. v4 filesystems only have
25 ACLs at most, so if we find an xattr that contains 200 ACLs we've
got an oversized xattr and it should return an error. The existing
code will return a -ERANGE for this case, and the size of the buffer
required would be returned in &len. This patch does not change that
behaviour.

Capping the maximum length to what is valid for the given context
also prevents corruption from triggering a massive allocation size
that might cause other problems....

> Even if we wanted to provide the caller the option to
> specify a max, I think we should be able to pass zero here and not fail
> with -ERANGE down in xfs_attr_copy_value().

We can change this behaviour if we even need such functionality. I
don't see any point in changing API behaviour for things we don't
actually need or use right now.

> Of course, we can and should
> still check the on-disk value length (against XFS_XATTR_SIZE_MAX for
> example) to protect against overtly large allocation attempts if on-disk
> data happens to bogus.

The max size of the xattr is context dependent, so given we have
always passed this down into xfs_attr_get() for it to determine
validity of the xattr that is found, I just don't see any
reason to change it...

> Somewhat related on the interface topic... should we ever return an
> allocated buffer on error, or should the xattr layer unwind such
> operations before it returns?

Errors can occur in different layers, having every layer know how to
handle unwinding/freeing adds unnecessary complexity to the error
handling. Having the top level code direct that the buffer must be
allocated, and that if it was allocated it will free it regardless
of success/failure greatly simplifies the rest of the code....

It largely makes no difference if it's handled by xfs_attr_get()
of the callers of that function. The only difference it makes if
we push it into xfs_attr_get() is that if we specify
XFS_DA_OP_ALLOCVAL the we have to unconditionally free anything in
args.value. i.e. it just pushes the same semantics in one layer...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
