Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15077 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934065AbdKBTf0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 Nov 2017 15:35:26 -0400
Date: Thu, 2 Nov 2017 15:35:24 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 01/18] xfs: pass an on-disk extent to
 xfs_bmbt_validate_extent
Message-ID: <20171102193523.GI16645@bfoster.bfoster>
References: <20171031142230.11755-1-hch@lst.de>
 <20171031142230.11755-2-hch@lst.de>
 <20171031175311.GC7093@bfoster.bfoster>
 <20171031211520.GI4911@magnolia>
 <20171101135855.GA11709@bfoster.bfoster>
 <20171101230024.GF4922@magnolia>
 <20171102115710.GB15748@bfoster.bfoster>
 <20171102160505.GR4911@magnolia>
 <20171102165419.GG16645@bfoster.bfoster>
 <20171102184221.GA4244@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171102184221.GA4244@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Thu, Nov 02, 2017 at 07:42:21PM +0100, Christoph Hellwig wrote:
> On Thu, Nov 02, 2017 at 12:54:19PM -0400, Brian Foster wrote:
> > > <shrug> Same feeling here.  TBH I wonder about how costly those
> > > unaligned be64 accesses are on things like sparc such that we should
> > > minimize the number of calls and just check the (probably aligned)
> > > incore version instead...
> > > 
> > 
> > I'm not totally sure.. I guess it's potentially a function call where an
> > immediate memory copy would suffice..? Anyways, that's pretty much what
> > caused the function to stand out to me as starting to look a little too
> > busy/ugly for its own good. We now have a validation helper that has to
> > handle unaligned accesses because its caller may or may not refer to
> > unaligned memory. It's not even totally clear to me when we can expect
> > the memory to be unaligned.. when we're referring to an on-disk inode
> > fork?
> 
> We are iterating over each possibly unaligned on-disk extent, so we
> already are taking the hit.  In all modern CPUs unaligned access
> don't cause a function call.  They either require a slightly different
> load instruction or multiple small (e.g. byte) loads.  I'd really like
> to see anyone who can demonstrate a difference vs reading the inode or
> bmap btree from disk.
> 

Ok.

> > So rather than start to propagate that logic, much more clean to me is
> > to do the unaligned accesses only where necessary and fix up the error
> > checks to examine the read values. I don't see any logical difference
> > between checking the bit vs. the extent state since the unwritten bit
> > basically maps directly to XFS_EXT_UNWRITTEN/XFS_EXT_NORM in the incore
> > record.
> 
> With the new incore extent list I wanted to keep the incore extent
> format private to the xfs_iext_tree.c file, and so far succeeded.
> 
> With the final version of this tree I could switch to checking
> the xfs_bmbt_irec structure, which makes a whole lot sense, but I
> can't think of an easy way to stage this.  Let me thing if I can come
> up with something, else I'll leave this patch as-is and will change it
> again in the end.

Right.. checking xfs_bmbt_irec->br_state is precisely what I'm
advocating. If it's easier just to change it after the fact, that's fine
by me.

Brian

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
