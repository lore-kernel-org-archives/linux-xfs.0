Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2268DC388F9
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Nov 2020 04:15:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDA5C221FB
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Nov 2020 04:15:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725849AbgKKEPi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Nov 2020 23:15:38 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:45888 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725852AbgKKEPh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Nov 2020 23:15:37 -0500
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 0FE9E3A9FA9;
        Wed, 11 Nov 2020 15:15:31 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kchXe-009u0V-Te; Wed, 11 Nov 2020 15:15:30 +1100
Date:   Wed, 11 Nov 2020 15:15:30 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] [RFC] spaceman: physically move a regular inode
Message-ID: <20201111041530.GK7391@dread.disaster.area>
References: <20201110225924.4031404-1-david@fromorbit.com>
 <20201111012646.GO9695@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201111012646.GO9695@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=kj9zAlcOel0A:10 a=nNwsprhYR40A:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=G2npBHJeo2QcjWp4_IMA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 10, 2020 at 05:26:46PM -0800, Darrick J. Wong wrote:
> On Wed, Nov 11, 2020 at 09:59:24AM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > To be able to shrink a filesystem, we need to be able to physically
> > move an inode and all it's data and metadata from it's current
> > location to a new AG.  Add a command to spaceman to allow an inode
> > to be moved to a new AG.
> > 
> > This new command is not intended to be a perfect solution. I am not
> > trying to handle atomic movement of open files - this is intended to
> > be run as a maintenance operation on idle filesystem. If root
> > filesystems are the target, then this should be run via a rescue
> > environment that is not executing directly on the root fs. With
> > those caveats in place, we can do the entire inode move as a set of
> > non-destructive operations finalised by an atomic inode swap
> > without any needing special kernel support.
> > 
> > To ensure we move metadata such as BMBT blocks even if we don't need
> > to move data, we clone the data to a new inode that we've allocated
> 
> Very clever!
> 
> On a related topic, I had been thinking about how to manage relocations
> of shared extents without breaking the sharing.  If userspace had a way
> to query the refcounts of some arbitrary range of disk, it could iterate
> over the extents of the doomed AG in decreasing refcount order using the
> GETFSMAP data and FIDEDUPERANGE to safely reconnect shared blocks in the
> surviving parts of the filesystem.

I've not really thought about that. If the extent needs moving, I'm
just going to move it for now regardless of whether it breaks
sharing or not. Like I said, there's plenty of scope for future
improvements here...

Similarly, this move will currently break hardlinks, too. The plan
to fix that is part of the next bit I'm working on - finding the
paths to the inodes that have stuff that need moving. This will
record all the paths to the same inode, so when we go to move the
inode we first create N tmp hardlinks to the new inode and then
RENAME_EXCHANGE each of the hardlinks in turn. Then we can clean up
the old inode and all the tmp hardlinks...

I suspect it will be a lot more complex with shared extents....

> (Granted you can compute the refcounts from the GETFSMAP data...)
> 
> > in the destination AG. This will result in new bmbt blocks being
> > allocated in the new location even though the data is not copied.
> 
> I assume you (or maybe hsiangkao) have some means to prevent those
> bmbt/xattr blocks from being allocated in the bad AG?

I'm not caring about that here. I'm assuming that the allocation
policy that has been put in place before the inode move is run will
prevent it. As it is, I'm (ab)using inode64 allocation policy which
places inode data and metadata in the same AG as the inode to get it
to move data and metadata to the required place....

> > --- /dev/null
> > +++ b/spaceman/move_inode.c
> > @@ -0,0 +1,518 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright (c) 2012 Red Hat, Inc.
> 
> 2012?  O ye halcyon days before the world caught fire...

Already noticed and fixed that :)

> > +/*
> > + * We can't entirely use O_TMPFILE here because we want to use RENAME_EXCHANGE
> > + * to swap the inode once rebuild is complete. Hence the new file has to be
> > + * somewhere in the namespace for rename to act upon. Hence we use a normal
> > + * open(O_CREATE) for now.
> 
> For the corner case that the inode is in a good AG but its blocks maybe
> aren't, I think you actually /could/ use O_TMPFILE for donor file.

UNless it is bmbt blocks or attr data that need to be moved, and
then we still need to swap the entire inodes....

> > +	if (!fiemap) {
> > +		fprintf(stderr, _("%s: malloc of %d bytes failed.\n"),
> > +			progname, map_size);
> > +		return -ENOMEM;
> > +	}
> > +
> > +	while (!done) {
> > +		memset(fiemap, 0, map_size);
> > +		fiemap->fm_flags = fiemap_flags;
> > +		fiemap->fm_start = last_logical;
> > +		fiemap->fm_length = range_end - last_logical;
> > +		fiemap->fm_extent_count = EXTENT_BATCH;
> > +
> > +		ret = ioctl(destfd, FS_IOC_FIEMAP, (unsigned long)fiemap);
> 
> This could have reused scrub/filemap.c to avoid code duplication.

SOmething to be done later :)

> Also, if the inode itself isn't in the doomed AG, you could use
> FIEMAP/BMAPX on the attr fork to find out if it's even necessary to copy
> the xattrs.

Sure, optimisations for later, because still got to be careful about
bmbt blocks in the attr fork. :)

> > +	/* copy user attributes to tempfile */
> > +	ret = copy_attrs(xfd->fd, tmpfd, 0);
> > +	if (ret)
> > +		goto out_cleanup;
> > +
> > +	/* unshare data to move it */
> > +	ret = unshare_data(xfd, tmpfd, agno);
> > +	if (ret)
> > +		goto out_cleanup;
> 
> Do we need to clear out the CoW fork too, just in case there are
> preallocations in there that map to the bad AG?

I'm kinda assuming stuff gets handled by the unlink of the original
inode. The new inode won't have blocks in the AGs that are getting
cleared out....

FWIW, I just realised I hadn't done any of the
owner/permission/timestamp/etc copying that needs to done to make
the new inode look like the old inode. That shouldn't be hugely
complicated to add...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
