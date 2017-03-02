Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:34780 "EHLO
        aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754036AbdCBRuV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Mar 2017 12:50:21 -0500
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69])
        by aserp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v22GbpCG006032
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 2 Mar 2017 16:37:51 GMT
Date: Thu, 2 Mar 2017 08:36:16 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH RFC] xfs: use iomap new flag for newly allocated delalloc
 blocks
Message-ID: <20170302163616.GB24806@birch.djwong.org>
References: <1488379009-4972-1-git-send-email-bfoster@redhat.com>
 <20170301235624.GA29200@infradead.org>
 <20170302124353.GB3213@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170302124353.GB3213@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, Xiong Zhou <xzhou@redhat.com>

On Thu, Mar 02, 2017 at 07:43:53AM -0500, Brian Foster wrote:
> On Wed, Mar 01, 2017 at 03:56:24PM -0800, Christoph Hellwig wrote:
> > On Wed, Mar 01, 2017 at 09:36:49AM -0500, Brian Foster wrote:
> > > This is a stab at fixing the regression discussed in this[1] thread
> > > based on what Christoph mentioned regarding use of the IOMAP_F_NEW flag.
> > > I decided to co-opt the XFS_BMAPI_ENTIRE flag for the delalloc res bit
> > > since it seems logically equivalent, but we could define a new flag too.
> > > I considered as such to preserve default behavior of
> > > _reserve_delalloc(), but otoh there is only one other caller. Otherwise,
> > > this passes all of my testing so far. Thoughts?
> > 
> > I don't like reusing the flag that much, but I think instead of passing
> > the flag we could trivially just remove the xfs_bmbt_get_all in
> > xfs_bmapi_reserve_delalloc and let the caller handle it after
> > xfs_bmapi_reserve_delalloc returned.  That being said I see no good
> > reason why the COW would care to see the merged extent, so
> > unconditionally removing it should be fine as well.  Or did I miss
> > something?
> 
> I think that's correct. The reflink code just feeds got into a
> tracepoint and otherwise doesn't seem to care what's returned.

Yes.  It doesn't need to know the exact results of what happened, so
long as the reservation gets made.  The tracepoint exists so that I
could check that manually while debugging.

> My only concern is that the behavior of not updating got seems
> inconsistent with the rest of the bmap code. I also realize now that
> this case may have broken the subsequent ASSERT() calls in terms of
> their effectiveness (i.e., I'm not reproducing failures, but they sort
> of become no-ops).
> 
> We could rename the got param and/or update a local record structure to
> feed into the asserts, but that kind of confuses the input param
> requirements for got (which should be filled in based on a previous
> lookup), so I don't like that too much either. Hmm, what about instead
> of adding flags, we just add a new, optional output param that returns
> the allocated range? E.g.:
> 
> int
> xfs_bmapi_reserve_delalloc(
>         struct xfs_inode        *ip,
>         int                     whichfork,
>         xfs_fileoff_t           off,
>         xfs_filblks_t           len,
>         xfs_filblks_t           prealloc,
>         struct xfs_bmbt_irec    *got,		/* full rec after alloc */
>         xfs_extnum_t            *lastx,
>         int                     eof,
>         struct xfs_bmbt_irec	*arec)		/* allocation performed */
> {
> 	...
> 	if (arec)
> 		arec = ...;
> 	...
> }
> 
> The reflink code could just pass NULL, the iomap code will use arec
> explicitly to document the requirement, and the function behavior should
> be clear enough to avoid landmines from any future callers. Thoughts?

That seems fine to me too.

--D

> 
> Brian
> 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
