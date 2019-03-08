Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44889 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726761AbfCHSMp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Mar 2019 13:12:45 -0500
Received: by mail-pg1-f195.google.com with SMTP id j3so14735152pgm.11
        for <linux-xfs@vger.kernel.org>; Fri, 08 Mar 2019 10:12:45 -0800 (PST)
MIME-Version: 1.0
References: <20190308161308.GC4676@magnolia>
In-Reply-To: <20190308161308.GC4676@magnolia>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Fri, 8 Mar 2019 10:12:33 -0800
Message-ID: <CAKwvOdn0=1svhDUBEP+391NvUXhm8bkzBzNMgNphML8kRzrRJQ@mail.gmail.com>
Subject: Re: [PATCH] xfs: clean up xfs_dir2_leafn_add
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Nathan Chancellor <natechancellor@gmail.com>, LKML <linux-kernel@vger.kernel.org>, clang-built-linux@googlegroups.com

On Fri, Mar 8, 2019 at 8:13 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> Remove typedefs and consolidate local variable initialization.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_dir2_node.c |   20 ++++++++------------
>  1 file changed, 8 insertions(+), 12 deletions(-)
>
> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> index de46f26c5292..16731d2d684b 100644
> --- a/fs/xfs/libxfs/xfs_dir2_node.c
> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> @@ -426,26 +426,22 @@ xfs_dir2_leaf_to_node(
>  static int                                     /* error */
>  xfs_dir2_leafn_add(
>         struct xfs_buf          *bp,            /* leaf buffer */
> -       xfs_da_args_t           *args,          /* operation arguments */
> +       struct xfs_da_args      *args,          /* operation arguments */
>         int                     index)          /* insertion pt for new entry */
>  {
> +       struct xfs_dir3_icleaf_hdr leafhdr;
> +       struct xfs_inode        *dp = args->dp;
> +       struct xfs_dir2_leaf    *leaf = bp->b_addr;
> +       struct xfs_dir2_leaf_entry *lep;
> +       struct xfs_dir2_leaf_entry *ents;
>         int                     compact;        /* compacting stale leaves */
> -       xfs_inode_t             *dp;            /* incore directory inode */
> -       int                     highstale;      /* next stale entry */
> -       xfs_dir2_leaf_t         *leaf;          /* leaf structure */
> -       xfs_dir2_leaf_entry_t   *lep;           /* leaf entry */
> +       int                     highstale = 0;  /* next stale entry */
>         int                     lfloghigh;      /* high leaf entry logging */
>         int                     lfloglow;       /* low leaf entry logging */
> -       int                     lowstale;       /* previous stale entry */
> -       struct xfs_dir3_icleaf_hdr leafhdr;
> -       struct xfs_dir2_leaf_entry *ents;
> +       int                     lowstale = 0;   /* previous stale entry */
>
>         trace_xfs_dir2_leafn_add(args, index);
>
> -       dp = args->dp;
> -       leaf = bp->b_addr;
> -       highstale = 0;
> -       lowstale = 0;
>         dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
>         ents = dp->d_ops->leaf_ents_p(leaf);

What about moving the initialization of `ents` above? (Or would that
be over the line limit?)

In general, I like this change (I considered asking Nathan to do the
consolidation of declaration and initialization as you've done).  The
additional part of converting from _t to struct * is less interesting
(but still ok).  It's better to be consistent within the function
scope, but this translation unit is still a mismatch of styles.  If
the goal is to avoid typedefs, consider removing them from existence
and the required work to consistently not use them throughout this
code.

-- 
Thanks,
~Nick Desaulniers
