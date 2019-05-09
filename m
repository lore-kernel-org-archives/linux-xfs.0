Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44960 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726449AbfEINFn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 9 May 2019 09:05:43 -0400
Date: Thu, 9 May 2019 09:05:39 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: short circuit xfs_get_acl() if no acl is possible
Message-ID: <20190509130535.GB41691@bfoster>
References: <35128e32-d69b-316e-c8d6-8f109646390d@redhat.com>
 <20190508201033.GW5207@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190508201033.GW5207@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, David Valin <dvalin@redhat.com>

On Wed, May 08, 2019 at 01:10:33PM -0700, Darrick J. Wong wrote:
> On Wed, May 08, 2019 at 02:28:09PM -0500, Eric Sandeen wrote:
> > If there are no attributes on the inode, don't go through the
> > cost of memory allocation and callling xfs_attr_get when we
> > already know we'll just get -ENOATTR.
> > 
> > Reported-by: David Valin <dvalin@redhat.com>
> > Suggested-by: Dave Chinner <david@fromorbit.com>
> > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> > ---
> > 
> > diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
> > index 8039e35147dd..b469b44e9e71 100644
> > --- a/fs/xfs/xfs_acl.c
> > +++ b/fs/xfs/xfs_acl.c
> > @@ -132,6 +132,9 @@ xfs_get_acl(struct inode *inode, int type)
> >  		BUG();
> >  	}
> >  
> > +	if (!xfs_inode_hasattr(ip))
> > +		return NULL;
> 
> This isn't going to cause problems if someone's adding an ACL to the
> inode at the same time, right?
> 
> I'm assuming that's the case since we only would load inodes when
> setting up a vfs inode but before any userspace can get its sticky
> fingers all over the inode, but it sure would be nice to know that
> for sure. :)
> 

Hmm, that's a good question. At first I was thinking it wouldn't matter,
but then I remembered the fairly recent issue around writing back an
empty leaf buffer on format conversion a bit too early. That has me
wondering if that would be an issue here as well. For example, suppose a
non-empty local format attr fork is being converted to extent format due
to a concurrent (and unrelated) xattr set. That involves
xfs_attr_shortform_to_leaf() -> xfs_bmap_local_to_extents_empty(), which
looks like it creates a transient empty fork state. Might
xfs_inode_hasattr() catch that as a false negative here? If so, that
would certainly be a problem if the existing xattr was the ACL the
caller happens to be interested in. It might be prudent to surround this
check with ILOCK_SHARED...

Brian

> --D
> 
> > +
> >  	/*
> >  	 * If we have a cached ACLs value just return it, not need to
> >  	 * go out to the disk.
> > 
