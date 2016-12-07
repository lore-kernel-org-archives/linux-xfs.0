Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46200 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753008AbcLGTqq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 7 Dec 2016 14:46:46 -0500
Date: Wed, 7 Dec 2016 14:46:34 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/3] xfs: go straight to real allocations for direct I/O
 COW writes
Message-ID: <20161207194634.GE23106@bfoster.bfoster>
References: <1480971924-4864-1-git-send-email-hch@lst.de>
 <1480971924-4864-3-git-send-email-hch@lst.de>
 <20161207190008.GC23106@bfoster.bfoster>
 <20161207193709.GA27479@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161207193709.GA27479@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com

On Wed, Dec 07, 2016 at 08:37:09PM +0100, Christoph Hellwig wrote:
> On Wed, Dec 07, 2016 at 02:00:09PM -0500, Brian Foster wrote:
> > > -	if (ap->flags & XFS_BMAPI_COWFORK)
> > > -		align = xfs_get_cowextsz_hint(ap->ip);
> > > -	else if (xfs_alloc_is_userdata(ap->datatype))
> > > +	if (xfs_alloc_is_userdata(ap->datatype))
> > 
> > Doesn't this defeat the purpose (i.e., fragmentation avoidance via wider
> > allocations) of the cowextszhint for direct I/O? I think it would be
> > better to be consistent with the approach for traditional I/O + extsz
> > and incorporate the alignment into the reservation. Perhaps the hunk of
> > code that already does just that in xfs_iomap_write_direct() could be
> > converted to a small helper and reused..?
> 
> We're already doing the alignment to the cowextsize hint in
> __xfs_reflink_allocate_cow so that we can take the cowextsize into
> account.
> 

Only for end_fsb... xfs_bmap_btalloc() calls xfs_bmap_extsize_align()
with the alignment, which rounds out the start and end offsets.

This same end_fsb code has already been removed from
xfs_reflink_reserve_cow() for similar reasons. It should probably be
removed from xfs_reflink_allocate_cow() as well.

Brian

> > > +	resblks = XFS_DIOSTRAT_SPACE_RES(mp, end_fsb - *offset_fsb);
> > > +
> > > +	error = xfs_qm_dqattach(ip, 0);
> > 
> > This is already in the (only) caller.
> 
> Yes, it can be dropped, although a superflous xfs_qm_dqattach is
> totally harmless anyway.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
