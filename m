Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50655 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751264AbdH2TA4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 15:00:56 -0400
Date: Tue, 29 Aug 2017 12:00:36 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 15/30] xfs: Define usercopy region in xfs_inode slab
 cache
Message-ID: <20170829190036.GD4757@magnolia>
References: <1503956111-36652-1-git-send-email-keescook@chromium.org>
 <1503956111-36652-16-git-send-email-keescook@chromium.org>
 <20170828214957.GJ4757@magnolia>
 <CAGXu5j+pvxRjASUuBE49+uH34Mw26a4mtcWrZd=CEqcRHjetvA@mail.gmail.com>
 <20170829044707.GP4757@magnolia>
 <CAGXu5jJX1DA9D1LtrKkNoBXKZEYhbSE148YmUOP=WXsBCFsCyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJX1DA9D1LtrKkNoBXKZEYhbSE148YmUOP=WXsBCFsCyw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, David Windsor <dave@nullcore.net>, linux-xfs@vger.kernel.org, Linux-MM <linux-mm@kvack.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>

On Tue, Aug 29, 2017 at 11:48:49AM -0700, Kees Cook wrote:
> On Mon, Aug 28, 2017 at 9:47 PM, Darrick J. Wong
> <darrick.wong@oracle.com> wrote:
> > On Mon, Aug 28, 2017 at 02:57:14PM -0700, Kees Cook wrote:
> >> On Mon, Aug 28, 2017 at 2:49 PM, Darrick J. Wong
> >> <darrick.wong@oracle.com> wrote:
> >> > On Mon, Aug 28, 2017 at 02:34:56PM -0700, Kees Cook wrote:
> >> >> From: David Windsor <dave@nullcore.net>
> >> >>
> >> >> The XFS inline inode data, stored in struct xfs_inode_t field
> >> >> i_df.if_u2.if_inline_data and therefore contained in the xfs_inode slab
> >> >> cache, needs to be copied to/from userspace.
> >> >>
> >> >> cache object allocation:
> >> >>     fs/xfs/xfs_icache.c:
> >> >>         xfs_inode_alloc(...):
> >> >>             ...
> >> >>             ip = kmem_zone_alloc(xfs_inode_zone, KM_SLEEP);
> >> >>
> >> >>     fs/xfs/libxfs/xfs_inode_fork.c:
> >> >>         xfs_init_local_fork(...):
> >> >>             ...
> >> >>             if (mem_size <= sizeof(ifp->if_u2.if_inline_data))
> >> >>                     ifp->if_u1.if_data = ifp->if_u2.if_inline_data;
> >> >
> >> > Hmm, what happens when mem_size > sizeof(if_inline_data)?  A slab object
> >> > will be allocated for ifp->if_u1.if_data which can then be used for
> >> > readlink in the same manner as the example usage trace below.  Does
> >> > that allocated object have a need for a usercopy annotation like
> >> > the one we're adding for if_inline_data?  Or is that already covered
> >> > elsewhere?
> >>
> >> Yeah, the xfs helper kmem_alloc() is used in the other case, which
> >> ultimately boils down to a call to kmalloc(), which is entirely
> >> whitelisted by an earlier patch in the series:
> >>
> >> https://lkml.org/lkml/2017/8/28/1026
> >
> > Ah.  It would've been helpful to have the first three patches cc'd to
> > the xfs list.  So basically this series establishes the ability to set
> 
> I went back and forth on that, and given all the things it touched, it
> seemed like too large a CC list. :) I can explicitly add the xfs list
> to the first three for any future versions.
> 
> > regions within a slab object into which copy_to_user can copy memory
> > contents, and vice versa.  Have you seen any runtime performance impact?
> > The overhead looks like it ought to be minimal.
> 
> Under CONFIG_HARDENED_USERCOPY, there's no difference in performance
> between the earlier bounds checking (of the whole slab object) vs the
> new bounds checking (of the useroffset/usersize portion of the slab
> object). Perf difference of CONFIG_HARDENED_USERCOPY itself has proven
> hard to measure, which likely means it's very minimal.
> 
> >> (It's possible that at some future time we can start segregating
> >> kernel-only kmallocs from usercopy-able kmallocs, but for now, there
> >> are no plans for this.)
> >
> > A pity.  It would be interesting to create no-usercopy versions of the
> > kmalloc-* slabs and see how much of XFS' memory consumption never
> > touches userspace buffers. :)
> 
> There are plans for building either a new helper (kmalloc_usercopy())
> or adding a new flag (GFP_USERCOPY), but I haven't had time yet to
> come back around to it. I wanted to land this step first, and we could
> then move forward on the rest in future.

Heh, fair enough.

For the XFS bits,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> 
> -Kees
> 
> -- 
> Kees Cook
> Pixel Security
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
