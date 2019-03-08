Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:55972 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726286AbfCHXLc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Mar 2019 18:11:32 -0500
Date: Fri, 8 Mar 2019 15:11:14 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: clean up xfs_dir2_leafn_add
Message-ID: <20190308231114.GD4676@magnolia>
References: <20190308161308.GC4676@magnolia>
 <CAKwvOdn0=1svhDUBEP+391NvUXhm8bkzBzNMgNphML8kRzrRJQ@mail.gmail.com>
 <20190308183830.GC20533@magnolia>
 <CAKwvOdnpfQ_v3Hx0Y0ZjzQEet9DH+39RzMeG6rFqp6nw0ha7GQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdnpfQ_v3Hx0Y0ZjzQEet9DH+39RzMeG6rFqp6nw0ha7GQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: linux-xfs@vger.kernel.org, Nathan Chancellor <natechancellor@gmail.com>, LKML <linux-kernel@vger.kernel.org>, clang-built-linux@googlegroups.com

On Fri, Mar 08, 2019 at 10:42:59AM -0800, Nick Desaulniers wrote:
> On Fri, Mar 8, 2019 at 10:38 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >
> > On Fri, Mar 08, 2019 at 10:12:33AM -0800, Nick Desaulniers wrote:
> > > On Fri, Mar 8, 2019 at 8:13 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > > >
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > >
> > > > Remove typedefs and consolidate local variable initialization.
> > > >
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > ---
> > > >  fs/xfs/libxfs/xfs_dir2_node.c |   20 ++++++++------------
> > > >  1 file changed, 8 insertions(+), 12 deletions(-)
> > > >
> > > > diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> > > > index de46f26c5292..16731d2d684b 100644
> > > > --- a/fs/xfs/libxfs/xfs_dir2_node.c
> > > > +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> > > > @@ -426,26 +426,22 @@ xfs_dir2_leaf_to_node(
> > > >  static int                                     /* error */
> > > >  xfs_dir2_leafn_add(
> > > >         struct xfs_buf          *bp,            /* leaf buffer */
> > > > -       xfs_da_args_t           *args,          /* operation arguments */
> > > > +       struct xfs_da_args      *args,          /* operation arguments */
> > > >         int                     index)          /* insertion pt for new entry */
> > > >  {
> > > > +       struct xfs_dir3_icleaf_hdr leafhdr;
> > > > +       struct xfs_inode        *dp = args->dp;
> > > > +       struct xfs_dir2_leaf    *leaf = bp->b_addr;
> > > > +       struct xfs_dir2_leaf_entry *lep;
> > > > +       struct xfs_dir2_leaf_entry *ents;
> > > >         int                     compact;        /* compacting stale leaves */
> > > > -       xfs_inode_t             *dp;            /* incore directory inode */
> > > > -       int                     highstale;      /* next stale entry */
> > > > -       xfs_dir2_leaf_t         *leaf;          /* leaf structure */
> > > > -       xfs_dir2_leaf_entry_t   *lep;           /* leaf entry */
> > > > +       int                     highstale = 0;  /* next stale entry */
> > > >         int                     lfloghigh;      /* high leaf entry logging */
> > > >         int                     lfloglow;       /* low leaf entry logging */
> > > > -       int                     lowstale;       /* previous stale entry */
> > > > -       struct xfs_dir3_icleaf_hdr leafhdr;
> > > > -       struct xfs_dir2_leaf_entry *ents;
> > > > +       int                     lowstale = 0;   /* previous stale entry */
> > > >
> > > >         trace_xfs_dir2_leafn_add(args, index);
> > > >
> > > > -       dp = args->dp;
> > > > -       leaf = bp->b_addr;
> > > > -       highstale = 0;
> > > > -       lowstale = 0;
> > > >         dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
> > > >         ents = dp->d_ops->leaf_ents_p(leaf);
> > >
> > > What about moving the initialization of `ents` above? (Or would that
> > > be over the line limit?)
> >
> > It might be over the line limit, but more importantly I prefer to have
> > the tracepoint fire before we start interpreting the on-disk metadata.
> > That way, ftrace data will show exactly where we were in the kernel
> > if any corruption warnings are emitted during that interpretation.
> >
> > I don't think either of those two functions do that today, but I don't
> > want to leave a logic bomb in case they ever start doing that.
> 
> Makes sense, ents is initialized to the results of function call.
> Thanks for the additional info, for accepting the earlier patch, and
> this additional cleanup.
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

Thanks for the review!

By the way, does clang complain about highstale/lowstale in
xfs_dir2_leaf_addname being uninitialized too?  Just wondering since
smatch/sparse do...

--D

> -- 
> Thanks,
> ~Nick Desaulniers
