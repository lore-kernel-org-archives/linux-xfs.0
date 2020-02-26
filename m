Return-Path: <SRS0=HAJZ=4O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4026C4BA06
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 01:03:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B01DF21927
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 01:03:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729387AbgBZBDS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 20:03:18 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:44752 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729277AbgBZBDS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 20:03:18 -0500
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 1CAED7EA134;
        Wed, 26 Feb 2020 12:03:13 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j6l6V-0005KJ-MH; Wed, 26 Feb 2020 12:03:11 +1100
Date:   Wed, 26 Feb 2020 12:03:11 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Chandan Rajendra <chandanrlinux@gmail.com>
Subject: Re: [PATCH 27/30] xfs: clean up the attr flag confusion
Message-ID: <20200226010311.GV10776@dread.disaster.area>
References: <20200225231012.735245-1-hch@lst.de>
 <20200225231012.735245-28-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200225231012.735245-28-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=l697ptgUJYAA:10
        a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=kLxnlGGNcKsLmm9ys_0A:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 25, 2020 at 03:10:09PM -0800, Christoph Hellwig wrote:
> The ATTR_* flags have a long IRIX history, where they a userspace
> interface, the on-disk format and an internal interface.  We've split
> out the on-disk interface to the XFS_ATTR_* values, but despite (or
> because?) of that the flag have still been a mess.  Switch the
> internal interface to pass the on-disk XFS_ATTR_* flags for the
> namespace and the Linux XATTR_* flags for the actual flags instead.
> The ATTR_* values that are actually used are move to xfs_fs.h with a
> new XFS_IOC_* prefix to not conflict with the userspace version that
> has the same name and must have the same value.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c      | 16 ++++++-------
>  fs/xfs/libxfs/xfs_attr.h      | 22 +-----------------
>  fs/xfs/libxfs/xfs_attr_leaf.c | 14 +++++------
>  fs/xfs/libxfs/xfs_da_btree.h  |  3 ++-
>  fs/xfs/libxfs/xfs_da_format.h | 12 ----------
>  fs/xfs/libxfs/xfs_fs.h        | 12 +++++++++-
>  fs/xfs/scrub/attr.c           |  5 +---
>  fs/xfs/xfs_acl.c              |  4 ++--
>  fs/xfs/xfs_ioctl.c            | 44 +++++++++++++++++++++++++----------
>  fs/xfs/xfs_iops.c             |  3 +--
>  fs/xfs/xfs_linux.h            |  1 +
>  fs/xfs/xfs_trace.h            | 35 +++++++++++++++++-----------
>  fs/xfs/xfs_xattr.c            | 18 +++++---------
>  13 files changed, 93 insertions(+), 96 deletions(-)

This cleans up a lot of messy checks. Nice. Couple of minor things
below.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

> @@ -489,10 +489,10 @@ xfs_attr_leaf_addname(
>  	 * the given flags produce an error or call for an atomic rename.
>  	 */
>  	retval = xfs_attr3_leaf_lookup_int(bp, args);
> -	if (retval == -ENOATTR && (args->flags & ATTR_REPLACE))
> +	if (retval == -ENOATTR && (args->attr_flags & XATTR_REPLACE))
>  		goto out_brelse;
>  	if (retval == -EEXIST) {
> -		if (args->flags & ATTR_CREATE)	/* pure create op */
> +		if (args->attr_flags & XATTR_CREATE)	/* pure create op */
>  			goto out_brelse;

Comment can die.

> diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
> index d93cb8385b52..f3660ae9eb3e 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.h
> +++ b/fs/xfs/libxfs/xfs_da_btree.h
> @@ -59,7 +59,8 @@ typedef struct xfs_da_args {
>  	uint8_t		filetype;	/* filetype of inode for directories */
>  	void		*value;		/* set of bytes (maybe contain NULLs) */
>  	int		valuelen;	/* length of value */
> -	int		flags;		/* argument flags (eg: ATTR_NOCREATE) */
> +	unsigned int	attr_filter;	/* XFS_ATTR_{ROOT,SECURE} */
> +	unsigned int	attr_flags;	/* XATTR_{CREATE,REPLACE} */

At this point, these are really operation flags. I would have named
the variable attr_opflags but I don't think it's worth redoing the
entire patch and others over this.

> @@ -50,7 +54,7 @@ DECLARE_EVENT_CLASS(xfs_attr_list_class,
>  		__field(int, count)
>  		__field(int, firstu)
>  		__field(int, dupcnt)
> -		__field(int, flags)
> +		__field(int, attr_filter)

uint?

> @@ -174,7 +179,7 @@ TRACE_EVENT(xfs_attr_list_node_descend,
>  		__field(int, count)
>  		__field(int, firstu)
>  		__field(int, dupcnt)
> -		__field(int, flags)
> +		__field(int, attr_filter)

same.

> @@ -1701,7 +1707,7 @@ DECLARE_EVENT_CLASS(xfs_attr_class,
>  		__field(int, namelen)
>  		__field(int, valuelen)
>  		__field(xfs_dahash_t, hashval)
> -		__field(int, flags)
> +		__field(int, attr_filter)

And once more.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
