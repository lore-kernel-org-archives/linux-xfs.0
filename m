Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:50204 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726113AbeJ0D5U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Oct 2018 23:57:20 -0400
Date: Fri, 26 Oct 2018 12:18:51 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] libxfs: check all defer ops types
Message-ID: <20181026191851.GI28243@magnolia>
References: <20181026161905.GH28243@magnolia>
 <0dc53e1c-2ad6-b04f-2747-451b6760e1d5@sandeen.net>
 <d13db2aa-3e73-7dd6-8677-7e19f9b7ffcd@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d13db2aa-3e73-7dd6-8677-7e19f9b7ffcd@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>

On Fri, Oct 26, 2018 at 02:11:47PM -0500, Eric Sandeen wrote:
> 
> 
> On 10/26/18 2:02 PM, Eric Sandeen wrote:
> > On 10/26/18 11:19 AM, Darrick J. Wong wrote:
> >> From: Darrick J. Wong <darrick.wong@oracle.com>
> >>
> >> Make sure we have all the defer ops types loaded before proceeding.
> > 
> > So, the only reason we have this problem is that userspace doesn't
> > exactly share the code which handles all the defer ops.
> > 
> > I think this really needs to be a BUILD_BUG_ON if anything, by the
> > time we get to runtime it's really too late, and a weird thing to
> > run at every invocation.
> > 
> > The only thing I can think of is to make an array containing each
> > of the xfs_defer_op_types, and iterate over it in some sort of
> > xfs_defer_ops_init(), then we can compare the size of that array to
> > XFS_DEFER_OPS_TYPE_MAX with a BUILD_BUG_ON.  Worth it?
> 
> Uh, or just make a statically initialized array?
> I guess nothing about this directly enforces that the ->type number
> is in the right slot of the array.
> 
> static const struct
> xfs_defer_op_type *defer_op_types[XFS_DEFER_OPS_TYPE_MAX] = {
>        xfs_bmap_update_defer_type,
>        xfs_refcount_update_defer_type,
>        xfs_rmap_update_defer_type,
>        xfs_extent_free_defer_type,
>        xfs_agfl_free_defer_type,
> };

I was thinking more:

static const struct
xfs_defer_op_type defer_op_types[XFS_DEFER_OPS_TYPE_MAX] = {
	[XFS_DEFER_OPS_TYPE_AGFL_FREE] = {
		.type		= XFS_DEFER_OPS_TYPE_AGFL_FREE,
		.diff_items	= xfs_extent_free_diff_items,
		.create_intent	= xfs_extent_free_create_intent,
		.abort_intent	= xfs_extent_free_abort_intent,
		.log_item	= xfs_extent_free_log_item,
		.create_done	= xfs_extent_free_create_done,
		.finish_item	= xfs_agfl_free_finish_item,
		.cancel_item	= xfs_extent_free_cancel_item,
	},
	...
};

The downside of this is that now we have to declare all those functions
somewhere so that the fs/xfs/ and libxfs/defer_item.c can match the
prototypes.  But that's probably better than what we have now, which is
a big gaping hole in xfsprogs 4.18.

--D
> 
> 
> 
> 
