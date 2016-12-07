Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:33405 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753112AbcLGThM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 7 Dec 2016 14:37:12 -0500
Date: Wed, 7 Dec 2016 20:37:09 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/3] xfs: go straight to real allocations for direct
        I/O COW writes
Message-ID: <20161207193709.GA27479@lst.de>
References: <1480971924-4864-1-git-send-email-hch@lst.de> <1480971924-4864-3-git-send-email-hch@lst.de> <20161207190008.GC23106@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161207190008.GC23106@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com

On Wed, Dec 07, 2016 at 02:00:09PM -0500, Brian Foster wrote:
> > -	if (ap->flags & XFS_BMAPI_COWFORK)
> > -		align = xfs_get_cowextsz_hint(ap->ip);
> > -	else if (xfs_alloc_is_userdata(ap->datatype))
> > +	if (xfs_alloc_is_userdata(ap->datatype))
> 
> Doesn't this defeat the purpose (i.e., fragmentation avoidance via wider
> allocations) of the cowextszhint for direct I/O? I think it would be
> better to be consistent with the approach for traditional I/O + extsz
> and incorporate the alignment into the reservation. Perhaps the hunk of
> code that already does just that in xfs_iomap_write_direct() could be
> converted to a small helper and reused..?

We're already doing the alignment to the cowextsize hint in
__xfs_reflink_allocate_cow so that we can take the cowextsize into
account.

> > +	resblks = XFS_DIOSTRAT_SPACE_RES(mp, end_fsb - *offset_fsb);
> > +
> > +	error = xfs_qm_dqattach(ip, 0);
> 
> This is already in the (only) caller.

Yes, it can be dropped, although a superflous xfs_qm_dqattach is
totally harmless anyway.
