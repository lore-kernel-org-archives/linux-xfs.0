Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 13 Jul 2007 06:43:53 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6DDhmbm024957
	for <xfs@oss.sgi.com>; Fri, 13 Jul 2007 06:43:49 -0700
Date: Fri, 13 Jul 2007 14:21:19 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/6][TAKE7] fallocate() implementation in i386, x86_64 and powerpc
Message-ID: <20070713132118.GA23256@infradead.org>
References: <20070713123816.GA18000@amitarora.in.ibm.com> <20070713124755.GB22961@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070713124755.GB22961@amitarora.in.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, tytso@mit.edu, cmm@us.ibm.com, suparna@in.ibm.com, adilger@clusterfs.com, dgc@sgi.com

On Fri, Jul 13, 2007 at 06:17:55PM +0530, Amit K. Arora wrote:
>  /*
> + * sys_fallocate - preallocate blocks or free preallocated blocks
> + * @fd: the file descriptor
> + * @mode: mode specifies the behavior of allocation.
> + * @offset: The offset within file, from where allocation is being
> + *	    requested. It should not have a negative value.
> + * @len: The amount of space in bytes to be allocated, from the offset.
> + *	 This can not be zero or a negative value.

kerneldoc comments are for in-kernel APIs which syscalls aren't.  I'd say
just temove this comment, the manpage is a much better documentation anyway.

> + * <TBD> Generic fallocate to be added for file systems that do not
> + *	 support fallocate.

Please remove the comment, adding a generic fallback in kernelspace is a
very dumb idea as we already discussed long time ago.

> --- linux-2.6.22.orig/include/linux/fs.h
> +++ linux-2.6.22/include/linux/fs.h
> @@ -266,6 +266,21 @@ extern int dir_notify_enable;
>  #define SYNC_FILE_RANGE_WRITE		2
>  #define SYNC_FILE_RANGE_WAIT_AFTER	4
>  
> +/*
> + * sys_fallocate modes
> + * Currently sys_fallocate supports two modes:
> + * FALLOC_ALLOCATE :	This is the preallocate mode, using which an application
> + *			may request reservation of space for a particular file.
> + *			The file size will be changed if the allocation is
> + *			beyond EOF.
> + * FALLOC_RESV_SPACE :	This is same as the above mode, with only one difference
> + *			that the file size will not be modified.
> + */
> +#define FALLOC_FL_KEEP_SIZE    0x01 /* default is extend/shrink size */
> +
> +#define FALLOC_ALLOCATE        0
> +#define FALLOC_RESV_SPACE      FALLOC_FL_KEEP_SIZE

Just remove FALLOC_ALLOCATE, 0 flags should be the default.  I'm also
not sure there is any point in having two namespace now that we have a flags-
based ABI.

Also please don't add this to fs.h.  fs.h is a complete mess and the
falloc flags are a new user ABI.  Add a linux/falloc.h instead which can
be added to headers-y so the ABI constant can be exported to userspace.
