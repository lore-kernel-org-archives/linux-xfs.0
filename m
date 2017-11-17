Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:46046 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1422736AbdKQUfo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Nov 2017 15:35:44 -0500
Received: by mail-ot0-f194.google.com with SMTP id u10so3047230otc.12
        for <linux-xfs@vger.kernel.org>; Fri, 17 Nov 2017 12:35:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171117202524.24696-2-ross.zwisler@linux.intel.com>
References: <20171117202524.24696-1-ross.zwisler@linux.intel.com> <20171117202524.24696-2-ross.zwisler@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 17 Nov 2017 12:35:43 -0800
Message-ID: <CAPcyv4g+3Drmpwva1Cxpq0SNsR0SJwT1vZGmXt-NGgL_2Zt48Q@mail.gmail.com>
Subject: Re: [xfsprogs PATCH 1/2] xfs_io: add MAP_SYNC support to mmap()
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, fstests <fstests@vger.kernel.org>, Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>

On Fri, Nov 17, 2017 at 12:25 PM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> Add support for a new -S flag to xfs_io's mmap command.  This opens the
> mapping with the (MAP_SYNC | MAP_SHARED_VALIDATE) flags instead of the
> standard MAP_SHARED flag.
>
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Suggested-by: Dave Chinner <david@fromorbit.com>
> ---
>  configure.ac          |  1 +
>  include/builddefs.in  |  1 +
>  include/linux.h       |  5 +++++
>  io/io.h               |  1 +
>  io/mmap.c             | 19 ++++++++++++++-----
>  m4/package_libcdev.m4 | 16 ++++++++++++++++
>  man/man8/xfs_io.8     |  6 +++++-
>  7 files changed, 43 insertions(+), 6 deletions(-)
>
> diff --git a/configure.ac b/configure.ac
> index cb23fb8..7153c9f 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -162,6 +162,7 @@ AC_HAVE_FSETXATTR
>  AC_HAVE_MREMAP
>  AC_NEED_INTERNAL_FSXATTR
>  AC_HAVE_GETFSMAP
> +AC_HAVE_MAP_SYNC
>
>  if test "$enable_blkid" = yes; then
>  AC_HAVE_BLKID_TOPO
> diff --git a/include/builddefs.in b/include/builddefs.in
> index 1d454b6..78b71fe 100644
> --- a/include/builddefs.in
> +++ b/include/builddefs.in
> @@ -114,6 +114,7 @@ HAVE_FSETXATTR = @have_fsetxattr@
>  HAVE_MREMAP = @have_mremap@
>  NEED_INTERNAL_FSXATTR = @need_internal_fsxattr@
>  HAVE_GETFSMAP = @have_getfsmap@
> +HAVE_MAP_SYNC = @have_map_sync@
>
>  GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
>  #         -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
> diff --git a/include/linux.h b/include/linux.h
> index 6ce344c..4ee03ed 100644
> --- a/include/linux.h
> +++ b/include/linux.h
> @@ -327,4 +327,9 @@ fsmap_advance(
>  #define HAVE_GETFSMAP
>  #endif /* HAVE_GETFSMAP */
>
> +#ifndef HAVE_MAP_SYNC
> +#define MAP_SYNC 0x80000

Hmm, this is the x86 specific value of MAP_SYNC. I think it would be
better to define MAP_SYNC to zero in this case and check for MAP_SYNC
== 0 at run time.
