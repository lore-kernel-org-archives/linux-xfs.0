Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56908 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750891AbdJGMOu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 7 Oct 2017 08:14:50 -0400
Date: Sat, 7 Oct 2017 08:14:48 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: reinit btree pointer on attr tree inactivation walk
Message-ID: <20171007121448.GA10074@bfoster.bfoster>
References: <20171006200740.7140-1-bfoster@redhat.com>
 <20171006204751.GM7122@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171006204751.GM7122@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Oct 06, 2017 at 01:47:51PM -0700, Darrick J. Wong wrote:
> On Fri, Oct 06, 2017 at 04:07:40PM -0400, Brian Foster wrote:
> > xfs_attr3_root_inactive() walks the attr fork tree to invalidate the
> > associated blocks. xfs_attr3_node_inactive() recursively descends
> > from internal blocks to leaf blocks, caching block address values
> > along the way to revisit parent blocks, locate the next entry and
> > descend down that branch of the tree.
> > 
> > The code that attempts to reread the parent block is unsafe because
> > it assumes that the local xfs_da_node_entry pointer remains valid
> > after an xfs_trans_brelse() and re-read of the parent buffer. Under
> > heavy memory pressure, it is possible that the buffer has been
> > reclaimed and reallocated by the time the parent block is reread.
> > This means that 'btree' can point to an invalid memory address, lead
> > to a random/garbage value for child_fsb and cause the subsequent
> > read of the attr fork to go off the rails and return a NULL buffer
> > for an attr fork offset that is most likely not allocated.
> > 
> > Note that this problem can be manufactured by setting
> > XFS_ATTR_BTREE_REF to 0 to prevent LRU caching of attr buffers,
> > creating a file with a multi-level attr fork and removing it to
> > trigger inactivation.
> > 
> > To address this problem, reinit the node/btree pointers to the
> > parent buffer after it has been re-read. This ensures btree points
> > to a valid record and allows the walk to proceed.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> 
> Looks ok,
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> /me wonders if this is a good enough reason to introduce a new errortag
> that turns xfs_buf_set_ref into a no-op and fills bp->b_addr with
> garbage prior to releasing the memory to weed out any other dangling
> pointers?
> 

I was starting to think about if/how we could test for this but hadn't
come up with anything concrete yet. An errortag that forces
_buf_set_ref() to set ->b_lru_ref to 0 of all buffer types might be
simple and effective enough to do the trick. I'll play around with that
next week.

Note that with my roughly equivalent hack in place, I didn't have to
overwrite the buffer content to observe the tree walk to go off the
rails. I haven't confirmed why, but perhaps the memory just happens to
be reused fairly quickly for the next buffer (we have a zone for
buffers, after all). I don't have poisoning or anything like that
enabled that I know of.

We may need a better way to know whether the test failed, however, since
the kernel now handles the !bpp case without crashing (as it should).
Perhaps we can assert that we don't hit a hole in this case, but that
has me wondering why we pass -2 to _da3_node_read() and skip over the
!child_bp case in xfs_attr3_node_inactive() in the first place. Is there
some legitimate case where we can hit a hole here that we don't know
about? I suppose adding an assert might be a more cautious first step
than switching it to -1 and potentially subjecting real users to
corruption errors. Thoughts?

> > ---
> > 
> > I suspect this is the cause of the NULL buf problem down in
> > xfs_attr_inactive(). I can manufacture an instance of that problem as
> > noted above. We have a customer who's hitting that problem and will
> > attempt to validate this fix, but there is no confirmation as of yet.
> > I'm posting this for review in the meantime because this seems like a
> > legit fix regardless of whether they are hitting this or something else.
> 
> Let me know what they report back.
> 

Will do, thanks.

Brian

> --D
> 
> > Brian
> > 
> >  fs/xfs/xfs_attr_inactive.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
> > index ebd66b1..e3a950e 100644
> > --- a/fs/xfs/xfs_attr_inactive.c
> > +++ b/fs/xfs/xfs_attr_inactive.c
> > @@ -302,6 +302,8 @@ xfs_attr3_node_inactive(
> >  						 &bp, XFS_ATTR_FORK);
> >  			if (error)
> >  				return error;
> > +			node = bp->b_addr;
> > +			btree = dp->d_ops->node_tree_p(node);
> >  			child_fsb = be32_to_cpu(btree[i + 1].before);
> >  			xfs_trans_brelse(*trans, bp);
> >  		}
> > -- 
> > 2.9.5
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
