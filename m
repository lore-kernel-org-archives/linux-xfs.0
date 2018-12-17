Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:39542 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728155AbeLQSjc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Dec 2018 13:39:32 -0500
Date: Mon, 17 Dec 2018 10:39:22 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 08/10] xfs: set failaddr into vc for checksum failures
Message-ID: <20181217183922.GN24487@magnolia>
References: <542b81dc-b564-c5fa-86b4-b4dc8ac50b63@redhat.com>
 <d380b0b8-b88f-fc96-8515-c5bd97918317@redhat.com>
 <20181207133747.GC55482@bfoster>
 <590579dd-f483-1ca2-eca8-e11e4a265f2b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <590579dd-f483-1ca2-eca8-e11e4a265f2b@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Dec 10, 2018 at 10:00:08AM -0600, Eric Sandeen wrote:
> On 12/7/18 7:37 AM, Brian Foster wrote:
> > On Wed, Dec 05, 2018 at 03:09:48PM -0600, Eric Sandeen wrote:
> >> Modify CRC checking functions to set __this_address into the
> >> verifier context failaddr vc->fa using new macro XFS_BADCRC_RETURN,
> >> and pass that to failure handlers as well.
> >>
> >> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> >> ---
> >>  fs/xfs/libxfs/xfs_alloc.c          |  4 ++--
> >>  fs/xfs/libxfs/xfs_alloc_btree.c    |  2 +-
> >>  fs/xfs/libxfs/xfs_attr_leaf.c      |  2 +-
> >>  fs/xfs/libxfs/xfs_bmap_btree.c     |  2 +-
> >>  fs/xfs/libxfs/xfs_cksum.h          |  5 ++++-
> >>  fs/xfs/libxfs/xfs_da_btree.c       |  3 +--
> >>  fs/xfs/libxfs/xfs_dir2_block.c     |  2 +-
> >>  fs/xfs/libxfs/xfs_dir2_data.c      |  2 +-
> >>  fs/xfs/libxfs/xfs_dir2_leaf.c      |  2 +-
> >>  fs/xfs/libxfs/xfs_dir2_node.c      |  2 +-
> >>  fs/xfs/libxfs/xfs_ialloc.c         |  2 +-
> >>  fs/xfs/libxfs/xfs_ialloc_btree.c   |  2 +-
> >>  fs/xfs/libxfs/xfs_refcount_btree.c |  2 +-
> >>  fs/xfs/libxfs/xfs_rmap_btree.c     |  2 +-
> >>  fs/xfs/libxfs/xfs_symlink_remote.c |  2 +-
> >>  fs/xfs/libxfs/xfs_types.h          | 12 ++++++++++--
> >>  fs/xfs/xfs_linux.h                 |  7 -------
> >>  17 files changed, 29 insertions(+), 26 deletions(-)
> >>
> > ...
> >> diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
> >> index 29b0d354d9b7..ab045e8dfcb9 100644
> >> --- a/fs/xfs/libxfs/xfs_types.h
> >> +++ b/fs/xfs/libxfs/xfs_types.h
> >> @@ -45,8 +45,16 @@ struct xfs_vc {
> >>  	xfs_failaddr_t	fa;
> >>  };
> >>  
> >> -#define XFS_CORRUPTED_RETURN(vc) ({(vc)->fa = __this_address; false;})
> >> -#define XFS_VERIFIED_RETURN(vc) ({(vc)->fa = NULL; true;})
> >> +/*
> >> + * Return the address of a label.  Use barrier() so that the optimizer
> >> + * won't reorder code to refactor the error jumpouts into a single
> >> + * return, which throws off the reported address.
> >> + */
> >> +#define __this_address ({ __label__ __here; __here: barrier(); &&__here; })
> >> + 
> > 
> > FYI, minor whitespace damage on the line above.
> > 
> >> +#define XFS_CORRUPTED_RETURN(vc)	({(vc)->fa = __this_address; false;})
> >> +#define XFS_BADCRC_RETURN(vc)		({(vc)->fa = __this_address; false;})
> >> +#define XFS_VERIFIED_RETURN(vc)		({(vc)->fa = NULL; true;})
> >>  
> > 
> > A couple high level comments..
> > 
> > I don't particularly care that much whether we bury function returns in
> > the macro or open-code it, but the macro naming suggests the former
> > (based on precedent of other such macros in XFS) while we implement the
> > latter. If there's objection to a return within a macro, perhaps a
> > reasonable compromise between this and the common pattern of having to
> > return on a separate line is to tweak the macros to never clobber an
> > existing error and update the verifiers to check/return failure state at
> > opportune points. For example:
> > 
> > 	...
> > 	if (!uuid_equal(&agfl->agfl_uuid, &mp->m_sb.sb_meta_uuid))
> > 		XFS_VC_CORRUPT(vc);
> > 	if (be32_to_cpu(agfl->agfl_magicnum) != XFS_AGFL_MAGIC)
> > 		XFS_VC_CORRUPT(vc);
> > 	if (bp->b_pag && be32_to_cpu(agfl->agfl_seqno) != bp->b_pag->pag_agno)
> > 		XFS_VC_CORRUPT(vc);
> > 	...
> > 
> > 	return vc->fa ? false : true;
> > 
> > Of course, that assumes it's safe to keep checking the structure(s) as
> > such in the event of corruption, which perhaps is not ideal. Anyways, we
> > could also just return on a separate line or rename the macros. Just
> > thinking out loud a bit.

I would be fine with changing the name but leaving the return, e.g.:

#define XFS_VC_CORRUPT(vc) ({vc->fa = __this_address; false;})

if (!uuid_equal(&agfl->agfl_uuid, &mp->m_sb.sb_meta_uuid))
	return XFS_VC_CORRUPT(vc);

Since I don't see much point in continuing once we've decided the
metadata is garbage.  Scrub used to try to continue to find all the
errors in a metadata, but Dave had good reasons for shooting down that
strategy (unnecessary work, slows down the checker, potential for
straying into places we shouldn't).

> > I'm also a little curious why we have the need for the success macro at
> > all. I've only made a cursory pass at this point, but is there a
> > particular need to set anything in the xfs_vc at the point of a
> > successful return as opposed to just leaving the structure in the
> > initialized state?
> 
> yeah, it's probably not necessary; it seemed consistent tho.  There is some
> risk to this whole framework that failing to initialize a vc would cause
> problems that might be difficult to debug, and always marking success
> upon success seemed "safe."  But you're right, not not necessary if it's
> properly initialized to success at the top of the call chain.

Yeah, how about a good static initializer so we don't have to open code
struct xfs_vc	vc = { NULL }; everywhere?

--D

> -Eric
