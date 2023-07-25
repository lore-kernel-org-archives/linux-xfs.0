Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33064EB64DD
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Jul 2023 04:00:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbjGYEAs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Jul 2023 00:00:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjGYEAr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jul 2023 00:00:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C8B5E57
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jul 2023 21:00:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 013E461507
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jul 2023 04:00:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5765AC433C8;
        Tue, 25 Jul 2023 04:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690257645;
        bh=OauOWu+rLo7kLBW6I959b4NtdnfNcdqOwnRl8hmko2k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oeDfK49Xa2bzmCwDlcr+BIndG9BnQjb+8Hzh1ZnsKLpGe5Yv1LmuToXnQx/330NDJ
         089wbHxs/g9GOU9Ij/CjpCy+ov4sgoNtaQMZ7ukMlEFhSWpsQequkMBG+h1/pLao0t
         p6hq5o1LZYPYCOUNjspvJe8gzEwsAdUVQJ17jeQm2T0lGflL6eVe9zjs5YPduJEUDf
         1Pi/PJH3V5OlUWF9QPti0AbXVG9xwrMUKNHuK/zwNj54vRPs2heEuFEw2e4b7xwFm0
         QXPuV6IHFzYuCxVlRvwUi5UBqOqjCh0b8VrQoZuqocoofIm1SMGAif734XxAydSoT1
         uEtdIO3UFt2sw==
Date:   Mon, 24 Jul 2023 21:00:44 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: remove the XFS_IOC_ATTRLIST_BY_HANDLE definitions
 out of xfs_fs.h
Message-ID: <20230725040044.GY11352@frogsfrogsfrogs>
References: <20230724154404.34524-1-hch@lst.de>
 <20230724154404.34524-2-hch@lst.de>
 <20230725034913.GX11352@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230725034913.GX11352@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 24, 2023 at 08:49:13PM -0700, Darrick J. Wong wrote:
> On Mon, Jul 24, 2023 at 08:44:04AM -0700, Christoph Hellwig wrote:
> > The xfs_attrlist and xfs_attrlist_ent structures as well as the
> > XFS_ATTR_* flags used by the XFS_IOC_ATTRLIST_BY_HANDLE are a very
> > odd and special kind of UAPI in that there is no userspace actually
> > ever using the definition.  The reason for that is that libattr has
> > copies of these definitions without the xfs_ prefix that are used
> > by libattr for the emulation of the IRIX-style attr calls, to which
> > XFS_IOC_ATTRLIST_BY_HANDLE is an extension, and users of
> > XFS_IOC_ATTRLIST_BY_HANDLE like xfsdump (though libhandle in xfsprogs)
> > use that definition.
> > 
> > So far, so odd, but with the change away from the deprecated and
> > dangerous "[1]" syntax for variable sized array, the kernel now
> > has actually changed the sizeof these structures, so even if some
> > obscure unkown userspace actually used it, it could easily get in
> > trouble next time xfs_fs.h gets synced to xfsprogs and it picks it up.
> > 
> > Move the definition to a new private xfs_ioctl_attr.h so that it
> > stops getting exposed in xfsprogs with the next sync.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/libxfs/xfs_fs.h  | 36 -------------------------------
> >  fs/xfs/xfs_ioctl.c      |  1 +
> >  fs/xfs/xfs_ioctl_attr.h | 48 +++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 49 insertions(+), 36 deletions(-)
> >  create mode 100644 fs/xfs/xfs_ioctl_attr.h
> > 
> > diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> > index 2cbf9ea39b8cc4..d069a72b8ae246 100644
> > --- a/fs/xfs/libxfs/xfs_fs.h
> > +++ b/fs/xfs/libxfs/xfs_fs.h
> > @@ -560,46 +560,10 @@ typedef struct xfs_fsop_handlereq {
> >  	__u32		__user *ohandlen;/* user buffer length		*/
> >  } xfs_fsop_handlereq_t;
> >  
> > -/*
> > - * Compound structures for passing args through Handle Request interfaces
> > - * xfs_attrlist_by_handle, xfs_attrmulti_by_handle
> > - * - ioctls: XFS_IOC_ATTRLIST_BY_HANDLE, and XFS_IOC_ATTRMULTI_BY_HANDLE
> > - */
> > -
> > -/*
> > - * Flags passed in xfs_attr_multiop.am_flags for the attr ioctl interface.
> > - *
> > - * NOTE: Must match the values declared in libattr without the XFS_IOC_ prefix.
> > - */
> > -#define XFS_IOC_ATTR_ROOT	0x0002	/* use attrs in root namespace */
> > -#define XFS_IOC_ATTR_SECURE	0x0008	/* use attrs in security namespace */
> > -#define XFS_IOC_ATTR_CREATE	0x0010	/* fail if attr already exists */
> > -#define XFS_IOC_ATTR_REPLACE	0x0020	/* fail if attr does not exist */
> > -
> >  typedef struct xfs_attrlist_cursor {
> >  	__u32		opaque[4];
> >  } xfs_attrlist_cursor_t;
> >  
> > -/*
> > - * Define how lists of attribute names are returned to userspace from the
> > - * XFS_IOC_ATTRLIST_BY_HANDLE ioctl.  struct xfs_attrlist is the header at the
> > - * beginning of the returned buffer, and a each entry in al_offset contains the
> > - * relative offset of an xfs_attrlist_ent containing the actual entry.
> > - *
> > - * NOTE: struct xfs_attrlist must match struct attrlist defined in libattr, and
> > - * struct xfs_attrlist_ent must match struct attrlist_ent defined in libattr.
> > - */
> > -struct xfs_attrlist {
> > -	__s32	al_count;	/* number of entries in attrlist */
> > -	__s32	al_more;	/* T/F: more attrs (do call again) */
> > -	__s32	al_offset[];	/* byte offsets of attrs [var-sized] */
> > -};
> > -
> > -struct xfs_attrlist_ent {	/* data from attr_list() */
> > -	__u32	a_valuelen;	/* number bytes in value of attr */
> > -	char	a_name[];	/* attr name (NULL terminated) */
> > -};
> > -
> >  typedef struct xfs_fsop_attrlist_handlereq {
> 
> /me is confused by this patch -- attributes.h in libattr also has
> definitions for a struct attrlist_cursor and a struct attr_multiop, so
> why not remove them from xfs_fs.h?
> 
> OTOH, there's XFS_IOC_ATTR{LIST,MULTI}_BY_HANDLE -- these ioctls format
> the user's buffer into xfs_attrlist and xfs_attrlist_ent structs.  They
> haven't been deprecated or removed, so why wouldn't we leave all these
> structs exactly where they are?
> 
> Or: Why not hoist all this to include/uapi/?

[adding dchinner]

Further questions, now that I've recalled trying to program xfs_scrub to
use ATTRLIST_BY_HANDLE:

Why is it that ATTR_ENTRY is defined in the libattr headers but not
xfs_fs.h?  xfsprogs has its own attr_list_by_handle function in
libhandle that does all the work of iterating information out of the
kernel, but then the poor caller doesn't get a helper function to walk
the resulting buffer...?

Even more strangely, libattr has that "attr_list" function, but all that
does is calls listxattr() and then formats the listxattr output into
ATTRLIST_BY_HANDLE format.  listxattr is (AFAICT) a much worse version
of ATTRLIST since the VFS implementation forces a max buffer size of 64k.
Why would anyone want that?

libhandle *also* doesn't define struct attrlist_ent, which makes it even
more weird that it wraps a system call to return data but doesn't define
the format of that data.

Oh, and then there was that other weird thing: when I wired up
ATTRLIST_BY_HANDLE into xfs_scrub, I then discovered that the
implementation had a bug where it forgot to write the cursor contents
back to userspace, which meant that userspace will continuously requery
the first buffer's worth of names until the sun dies.

Does anyone actually /use/ these extended extended attribute functions?

I get the feeling I'm opening a weird can of "XFS porting to Linux"
friction that I don't know about...

--D

> --D
> 
> >  	struct xfs_fsop_handlereq	hreq; /* handle interface structure */
> >  	struct xfs_attrlist_cursor	pos; /* opaque cookie, list offset */
> > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > index 55bb01173cde8c..7d9154e0e198f6 100644
> > --- a/fs/xfs/xfs_ioctl.c
> > +++ b/fs/xfs/xfs_ioctl.c
> > @@ -38,6 +38,7 @@
> >  #include "xfs_reflink.h"
> >  #include "xfs_ioctl.h"
> >  #include "xfs_xattr.h"
> > +#include "xfs_ioctl_attr.h"
> >  
> >  #include <linux/mount.h>
> >  #include <linux/namei.h>
> > diff --git a/fs/xfs/xfs_ioctl_attr.h b/fs/xfs/xfs_ioctl_attr.h
> > new file mode 100644
> > index 00000000000000..7bf3046665c322
> > --- /dev/null
> > +++ b/fs/xfs/xfs_ioctl_attr.h
> > @@ -0,0 +1,48 @@
> > +/* SPDX-License-Identifier: LGPL-2.1 */
> > +/*
> > + * Copyright (c) 1995-2005 Silicon Graphics, Inc.
> > + * All Rights Reserved.
> > + */
> > +#ifndef _XFS_ATTR_IOCTL_H
> > +#define _XFS_ATTR_IOCTL_H
> > +
> > +/*
> > + * Attr structures for passing through XFS_IOC_ATTRLIST_BY_HANDLE.
> > + *
> > + * These are UAPIs, but in a rather strange way - nothing in userspace uses
> > + * these declarations directly, but instead they use separate definitions
> > + * in libattr that are derived from the same IRIX interface and must stay
> > + * binary compatible forever.  They generally match the names in this file,
> > + * but without the xfs_ or XFS_ prefix.
> > + *
> > + * For extra fun the kernel version has replace the [1] sized arrays for
> > + * variable sized parts with the newer [] syntax that produces the same
> > + * structure layout, but can produce different sizeof results.
> > + */
> > +
> > +/*
> > + * Flags passed in xfs_attr_multiop.am_flags for the attr ioctl interface.
> > + */
> > +#define XFS_IOC_ATTR_ROOT	0x0002	/* use attrs in root namespace */
> > +#define XFS_IOC_ATTR_SECURE	0x0008	/* use attrs in security namespace */
> > +#define XFS_IOC_ATTR_CREATE	0x0010	/* fail if attr already exists */
> > +#define XFS_IOC_ATTR_REPLACE	0x0020	/* fail if attr does not exist */
> > +
> > +/*
> > + * Define how lists of attribute names are returned to userspace from the
> > + * XFS_IOC_ATTRLIST_BY_HANDLE ioctl.  struct xfs_attrlist is the header at the
> > + * beginning of the returned buffer, and a each entry in al_offset contains the
> > + * relative offset of an xfs_attrlist_ent containing the actual entry.
> > + */
> > +struct xfs_attrlist {
> > +	__s32	al_count;	/* number of entries in attrlist */
> > +	__s32	al_more;	/* T/F: more attrs (do call again) */
> > +	__s32	al_offset[];	/* byte offsets of attrs [var-sized] */
> > +};
> > +
> > +struct xfs_attrlist_ent {	/* data from attr_list() */
> > +	__u32	a_valuelen;	/* number bytes in value of attr */
> > +	char	a_name[];	/* attr name (NULL terminated) */
> > +};
> > +
> > +#endif /* _XFS_ATTR_IOCTL_H */
> > -- 
> > 2.39.2
> > 
