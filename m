Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:59866 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728630AbfCHSin (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Mar 2019 13:38:43 -0500
Date: Fri, 8 Mar 2019 10:38:30 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: clean up xfs_dir2_leafn_add
Message-ID: <20190308183830.GC20533@magnolia>
References: <20190308161308.GC4676@magnolia>
 <CAKwvOdn0=1svhDUBEP+391NvUXhm8bkzBzNMgNphML8kRzrRJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdn0=1svhDUBEP+391NvUXhm8bkzBzNMgNphML8kRzrRJQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: linux-xfs@vger.kernel.org, Nathan Chancellor <natechancellor@gmail.com>, LKML <linux-kernel@vger.kernel.org>, clang-built-linux@googlegroups.com

On Fri, Mar 08, 2019 at 10:12:33AM -0800, Nick Desaulniers wrote:
> On Fri, Mar 8, 2019 at 8:13 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> >
> > Remove typedefs and consolidate local variable initialization.
> >
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_dir2_node.c |   20 ++++++++------------
> >  1 file changed, 8 insertions(+), 12 deletions(-)
> >
> > diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> > index de46f26c5292..16731d2d684b 100644
> > --- a/fs/xfs/libxfs/xfs_dir2_node.c
> > +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> > @@ -426,26 +426,22 @@ xfs_dir2_leaf_to_node(
> >  static int                                     /* error */
> >  xfs_dir2_leafn_add(
> >         struct xfs_buf          *bp,            /* leaf buffer */
> > -       xfs_da_args_t           *args,          /* operation arguments */
> > +       struct xfs_da_args      *args,          /* operation arguments */
> >         int                     index)          /* insertion pt for new entry */
> >  {
> > +       struct xfs_dir3_icleaf_hdr leafhdr;
> > +       struct xfs_inode        *dp = args->dp;
> > +       struct xfs_dir2_leaf    *leaf = bp->b_addr;
> > +       struct xfs_dir2_leaf_entry *lep;
> > +       struct xfs_dir2_leaf_entry *ents;
> >         int                     compact;        /* compacting stale leaves */
> > -       xfs_inode_t             *dp;            /* incore directory inode */
> > -       int                     highstale;      /* next stale entry */
> > -       xfs_dir2_leaf_t         *leaf;          /* leaf structure */
> > -       xfs_dir2_leaf_entry_t   *lep;           /* leaf entry */
> > +       int                     highstale = 0;  /* next stale entry */
> >         int                     lfloghigh;      /* high leaf entry logging */
> >         int                     lfloglow;       /* low leaf entry logging */
> > -       int                     lowstale;       /* previous stale entry */
> > -       struct xfs_dir3_icleaf_hdr leafhdr;
> > -       struct xfs_dir2_leaf_entry *ents;
> > +       int                     lowstale = 0;   /* previous stale entry */
> >
> >         trace_xfs_dir2_leafn_add(args, index);
> >
> > -       dp = args->dp;
> > -       leaf = bp->b_addr;
> > -       highstale = 0;
> > -       lowstale = 0;
> >         dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
> >         ents = dp->d_ops->leaf_ents_p(leaf);
> 
> What about moving the initialization of `ents` above? (Or would that
> be over the line limit?)

It might be over the line limit, but more importantly I prefer to have
the tracepoint fire before we start interpreting the on-disk metadata.
That way, ftrace data will show exactly where we were in the kernel
if any corruption warnings are emitted during that interpretation.

I don't think either of those two functions do that today, but I don't
want to leave a logic bomb in case they ever start doing that.

> In general, I like this change (I considered asking Nathan to do the
> consolidation of declaration and initialization as you've done).  The
> additional part of converting from _t to struct * is less interesting
> (but still ok).  It's better to be consistent within the function
> scope, but this translation unit is still a mismatch of styles.  If
> the goal is to avoid typedefs, consider removing them from existence
> and the required work to consistently not use them throughout this
> code.

Yeah, we're slowly converting away from the _t typedefs (and other
IRIXisms) as parts of code get reworked, though of course there's
nothing obvious to suggest that this (slow transition) is in progress
nor that we're ok with the inconsistent formatting in the meantime,
which is why I accepted the original patch and added this one to do the
style conversions.

--D

> -- 
> Thanks,
> ~Nick Desaulniers
