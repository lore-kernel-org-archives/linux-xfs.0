Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1864FEB64DD
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Jul 2023 03:49:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbjGYDtQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jul 2023 23:49:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjGYDtQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jul 2023 23:49:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C36B4171E
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jul 2023 20:49:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 522A161503
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jul 2023 03:49:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADC64C433C8;
        Tue, 25 Jul 2023 03:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690256953;
        bh=jppp2Y7mNpfxnWnbO50o1jfcsoithFjWf2RtUGvfFoU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aCkYvMzcH1j/xtQKdhme0lR464hymBPT00UHJXAXluWrC+dyVAhDqT3+7ST3Fcwgh
         MJP2oSdOaVStV91eoPcmyqHrHmmImPKxoUD9JWF/BWadlk3Mwe0WkuqJf7V9lRwpPS
         SK5VK6ZYKlhegAR9PSZu3EaTi4SlBRvwJ8QrjM9/7VoL7hNuK/e1mZxZwB95s7+7p+
         VGw/Xwnhig2luByuOIa9E5p5w7PsEvZVO7XzoRVcsb88L3rD5oH4kLpZtWQFmhjRa4
         ehzmOjspwTzFEufW1yXCvlqTTwQLW5MDHUi79zkvpLpnZa/VtM68CQ/9meJ662bXzs
         xFRASdJZC2w+A==
Date:   Mon, 24 Jul 2023 20:49:13 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: remove the XFS_IOC_ATTRLIST_BY_HANDLE definitions
 out of xfs_fs.h
Message-ID: <20230725034913.GX11352@frogsfrogsfrogs>
References: <20230724154404.34524-1-hch@lst.de>
 <20230724154404.34524-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230724154404.34524-2-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 24, 2023 at 08:44:04AM -0700, Christoph Hellwig wrote:
> The xfs_attrlist and xfs_attrlist_ent structures as well as the
> XFS_ATTR_* flags used by the XFS_IOC_ATTRLIST_BY_HANDLE are a very
> odd and special kind of UAPI in that there is no userspace actually
> ever using the definition.  The reason for that is that libattr has
> copies of these definitions without the xfs_ prefix that are used
> by libattr for the emulation of the IRIX-style attr calls, to which
> XFS_IOC_ATTRLIST_BY_HANDLE is an extension, and users of
> XFS_IOC_ATTRLIST_BY_HANDLE like xfsdump (though libhandle in xfsprogs)
> use that definition.
> 
> So far, so odd, but with the change away from the deprecated and
> dangerous "[1]" syntax for variable sized array, the kernel now
> has actually changed the sizeof these structures, so even if some
> obscure unkown userspace actually used it, it could easily get in
> trouble next time xfs_fs.h gets synced to xfsprogs and it picks it up.
> 
> Move the definition to a new private xfs_ioctl_attr.h so that it
> stops getting exposed in xfsprogs with the next sync.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_fs.h  | 36 -------------------------------
>  fs/xfs/xfs_ioctl.c      |  1 +
>  fs/xfs/xfs_ioctl_attr.h | 48 +++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 49 insertions(+), 36 deletions(-)
>  create mode 100644 fs/xfs/xfs_ioctl_attr.h
> 
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index 2cbf9ea39b8cc4..d069a72b8ae246 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -560,46 +560,10 @@ typedef struct xfs_fsop_handlereq {
>  	__u32		__user *ohandlen;/* user buffer length		*/
>  } xfs_fsop_handlereq_t;
>  
> -/*
> - * Compound structures for passing args through Handle Request interfaces
> - * xfs_attrlist_by_handle, xfs_attrmulti_by_handle
> - * - ioctls: XFS_IOC_ATTRLIST_BY_HANDLE, and XFS_IOC_ATTRMULTI_BY_HANDLE
> - */
> -
> -/*
> - * Flags passed in xfs_attr_multiop.am_flags for the attr ioctl interface.
> - *
> - * NOTE: Must match the values declared in libattr without the XFS_IOC_ prefix.
> - */
> -#define XFS_IOC_ATTR_ROOT	0x0002	/* use attrs in root namespace */
> -#define XFS_IOC_ATTR_SECURE	0x0008	/* use attrs in security namespace */
> -#define XFS_IOC_ATTR_CREATE	0x0010	/* fail if attr already exists */
> -#define XFS_IOC_ATTR_REPLACE	0x0020	/* fail if attr does not exist */
> -
>  typedef struct xfs_attrlist_cursor {
>  	__u32		opaque[4];
>  } xfs_attrlist_cursor_t;
>  
> -/*
> - * Define how lists of attribute names are returned to userspace from the
> - * XFS_IOC_ATTRLIST_BY_HANDLE ioctl.  struct xfs_attrlist is the header at the
> - * beginning of the returned buffer, and a each entry in al_offset contains the
> - * relative offset of an xfs_attrlist_ent containing the actual entry.
> - *
> - * NOTE: struct xfs_attrlist must match struct attrlist defined in libattr, and
> - * struct xfs_attrlist_ent must match struct attrlist_ent defined in libattr.
> - */
> -struct xfs_attrlist {
> -	__s32	al_count;	/* number of entries in attrlist */
> -	__s32	al_more;	/* T/F: more attrs (do call again) */
> -	__s32	al_offset[];	/* byte offsets of attrs [var-sized] */
> -};
> -
> -struct xfs_attrlist_ent {	/* data from attr_list() */
> -	__u32	a_valuelen;	/* number bytes in value of attr */
> -	char	a_name[];	/* attr name (NULL terminated) */
> -};
> -
>  typedef struct xfs_fsop_attrlist_handlereq {

/me is confused by this patch -- attributes.h in libattr also has
definitions for a struct attrlist_cursor and a struct attr_multiop, so
why not remove them from xfs_fs.h?

OTOH, there's XFS_IOC_ATTR{LIST,MULTI}_BY_HANDLE -- these ioctls format
the user's buffer into xfs_attrlist and xfs_attrlist_ent structs.  They
haven't been deprecated or removed, so why wouldn't we leave all these
structs exactly where they are?

Or: Why not hoist all this to include/uapi/?

--D

>  	struct xfs_fsop_handlereq	hreq; /* handle interface structure */
>  	struct xfs_attrlist_cursor	pos; /* opaque cookie, list offset */
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 55bb01173cde8c..7d9154e0e198f6 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -38,6 +38,7 @@
>  #include "xfs_reflink.h"
>  #include "xfs_ioctl.h"
>  #include "xfs_xattr.h"
> +#include "xfs_ioctl_attr.h"
>  
>  #include <linux/mount.h>
>  #include <linux/namei.h>
> diff --git a/fs/xfs/xfs_ioctl_attr.h b/fs/xfs/xfs_ioctl_attr.h
> new file mode 100644
> index 00000000000000..7bf3046665c322
> --- /dev/null
> +++ b/fs/xfs/xfs_ioctl_attr.h
> @@ -0,0 +1,48 @@
> +/* SPDX-License-Identifier: LGPL-2.1 */
> +/*
> + * Copyright (c) 1995-2005 Silicon Graphics, Inc.
> + * All Rights Reserved.
> + */
> +#ifndef _XFS_ATTR_IOCTL_H
> +#define _XFS_ATTR_IOCTL_H
> +
> +/*
> + * Attr structures for passing through XFS_IOC_ATTRLIST_BY_HANDLE.
> + *
> + * These are UAPIs, but in a rather strange way - nothing in userspace uses
> + * these declarations directly, but instead they use separate definitions
> + * in libattr that are derived from the same IRIX interface and must stay
> + * binary compatible forever.  They generally match the names in this file,
> + * but without the xfs_ or XFS_ prefix.
> + *
> + * For extra fun the kernel version has replace the [1] sized arrays for
> + * variable sized parts with the newer [] syntax that produces the same
> + * structure layout, but can produce different sizeof results.
> + */
> +
> +/*
> + * Flags passed in xfs_attr_multiop.am_flags for the attr ioctl interface.
> + */
> +#define XFS_IOC_ATTR_ROOT	0x0002	/* use attrs in root namespace */
> +#define XFS_IOC_ATTR_SECURE	0x0008	/* use attrs in security namespace */
> +#define XFS_IOC_ATTR_CREATE	0x0010	/* fail if attr already exists */
> +#define XFS_IOC_ATTR_REPLACE	0x0020	/* fail if attr does not exist */
> +
> +/*
> + * Define how lists of attribute names are returned to userspace from the
> + * XFS_IOC_ATTRLIST_BY_HANDLE ioctl.  struct xfs_attrlist is the header at the
> + * beginning of the returned buffer, and a each entry in al_offset contains the
> + * relative offset of an xfs_attrlist_ent containing the actual entry.
> + */
> +struct xfs_attrlist {
> +	__s32	al_count;	/* number of entries in attrlist */
> +	__s32	al_more;	/* T/F: more attrs (do call again) */
> +	__s32	al_offset[];	/* byte offsets of attrs [var-sized] */
> +};
> +
> +struct xfs_attrlist_ent {	/* data from attr_list() */
> +	__u32	a_valuelen;	/* number bytes in value of attr */
> +	char	a_name[];	/* attr name (NULL terminated) */
> +};
> +
> +#endif /* _XFS_ATTR_IOCTL_H */
> -- 
> 2.39.2
> 
