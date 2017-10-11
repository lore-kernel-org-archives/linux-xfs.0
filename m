Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:45517 "EHLO
        mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751528AbdJKRLp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2017 13:11:45 -0400
Received: by mail-oi0-f52.google.com with SMTP id f66so4227496oib.2
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2017 10:11:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171006204751.GM7122@magnolia>
References: <20171006200740.7140-1-bfoster@redhat.com> <20171006204751.GM7122@magnolia>
From: Marco Benatto <mbenatto@redhat.com>
Date: Wed, 11 Oct 2017 14:11:44 -0300
Message-ID: <CAOGQQ29rTuDzxfcbYHDi6ez9Mk2MKFzf_Qa8ZeTTvgusme5feQ@mail.gmail.com>
Subject: Re: [PATCH] xfs: reinit btree pointer on attr tree inactivation walk
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

Hello all

On Fri, Oct 6, 2017 at 5:47 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
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

Just to let you know, we've got some news regarding this testing and the
patch seems effective to fix the issue they were facing before at
xfs_attr_inactive() case.

>
>
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
> >                                                &bp, XFS_ATTR_FORK);
> >                       if (error)
> >                               return error;
> > +                     node = bp->b_addr;
> > +                     btree = dp->d_ops->node_tree_p(node);
> >                       child_fsb = be32_to_cpu(btree[i + 1].before);
> >                       xfs_trans_brelse(*trans, bp);
> >               }
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


Thanks,


-- 
Marco Benatto
