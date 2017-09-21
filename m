Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38162 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752456AbdIURfP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Sep 2017 13:35:15 -0400
Date: Thu, 21 Sep 2017 10:35:10 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 03/27] xfs: create an ioctl to scrub AG metadata
Message-ID: <20170921173510.GK7112@magnolia>
References: <150595305131.18473.16572195821331601191.stgit@magnolia>
 <150595307619.18473.13254461981024786903.stgit@magnolia>
 <20170921143638.GE58956@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170921143638.GE58956@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Sep 21, 2017 at 10:36:39AM -0400, Brian Foster wrote:
> On Wed, Sep 20, 2017 at 05:17:56PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Create an ioctl that can be used to scrub internal filesystem metadata.
> > The new ioctl takes the metadata type, an (optional) AG number, an
> > (optional) inode number and generation, and a flags argument.  This will
> > be used by the upcoming XFS online scrub tool.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/Kconfig           |   17 ++++++++++++++
> >  fs/xfs/Makefile          |   11 +++++++++
> >  fs/xfs/libxfs/xfs_fs.h   |   53 +++++++++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/scrub/scrub.c     |   54 ++++++++++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/scrub/scrub.h     |   25 +++++++++++++++++++++
> >  fs/xfs/scrub/trace.c     |   41 +++++++++++++++++++++++++++++++++++
> >  fs/xfs/scrub/trace.h     |   33 ++++++++++++++++++++++++++++
> >  fs/xfs/scrub/xfs_scrub.h |   29 +++++++++++++++++++++++++
> >  fs/xfs/xfs_ioctl.c       |   28 ++++++++++++++++++++++++
> >  fs/xfs/xfs_ioctl32.c     |    1 +
> >  10 files changed, 292 insertions(+)
> >  create mode 100644 fs/xfs/scrub/scrub.c
> >  create mode 100644 fs/xfs/scrub/scrub.h
> >  create mode 100644 fs/xfs/scrub/trace.c
> >  create mode 100644 fs/xfs/scrub/trace.h
> >  create mode 100644 fs/xfs/scrub/xfs_scrub.h
> > 
> > 
> 
> The code looks sane, though I think I need to understand the error codes
> a bit better. Perhaps once I get further into the series..

Yes, the ioctl needs documentation, though I'm unclear on where's an
appropriate place to put them.  The ioctl is not intended for general
consumption, so man-pages.git seems inappropriate.  I was thinking
either in xfs_fs.h directly, or perhaps xfsprogs' man pages?

(We don't seem to document the xfs ioctls afaict?)

--D

> 
> Brian
> 
> > diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
> > index 1b98cfa..f42fcf1 100644
> > --- a/fs/xfs/Kconfig
> > +++ b/fs/xfs/Kconfig
> > @@ -71,6 +71,23 @@ config XFS_RT
> >  
> >  	  If unsure, say N.
> >  
> > +config XFS_ONLINE_SCRUB
> > +	bool "XFS online metadata check support"
> > +	default n
> > +	depends on XFS_FS
> > +	help
> > +	  If you say Y here you will be able to check metadata on a
> > +	  mounted XFS filesystem.  This feature is intended to reduce
> > +	  filesystem downtime by supplementing xfs_repair.  The key
> > +	  advantage here is to look for problems proactively so that
> > +	  they can be dealt with in a controlled manner.
> > +
> > +	  This feature is considered EXPERIMENTAL.  Use with caution!
> > +
> > +	  See the xfs_scrub man page in section 8 for additional information.
> > +
> > +	  If unsure, say N.
> > +
> >  config XFS_WARN
> >  	bool "XFS Verbose Warnings"
> >  	depends on XFS_FS && !XFS_DEBUG
> > diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> > index dbc33e0..f4312bc 100644
> > --- a/fs/xfs/Makefile
> > +++ b/fs/xfs/Makefile
> > @@ -138,3 +138,14 @@ xfs-$(CONFIG_XFS_POSIX_ACL)	+= xfs_acl.o
> >  xfs-$(CONFIG_SYSCTL)		+= xfs_sysctl.o
> >  xfs-$(CONFIG_COMPAT)		+= xfs_ioctl32.o
> >  xfs-$(CONFIG_EXPORTFS_BLOCK_OPS)	+= xfs_pnfs.o
> > +
> > +# online scrub/repair
> > +ifeq ($(CONFIG_XFS_ONLINE_SCRUB),y)
> > +
> > +# Tracepoints like to blow up, so build that before everything else
> > +
> > +xfs-y				+= $(addprefix scrub/, \
> > +				   trace.o \
> > +				   scrub.o \
> > +				   )
> > +endif
> > diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> > index 2c26c38..a4b4c8c 100644
> > --- a/fs/xfs/libxfs/xfs_fs.h
> > +++ b/fs/xfs/libxfs/xfs_fs.h
> > @@ -468,6 +468,58 @@ typedef struct xfs_swapext
> >  #define XFS_FSOP_GOING_FLAGS_LOGFLUSH		0x1	/* flush log but not data */
> >  #define XFS_FSOP_GOING_FLAGS_NOLOGFLUSH		0x2	/* don't flush log nor data */
> >  
> > +/* metadata scrubbing */
> > +struct xfs_scrub_metadata {
> > +	__u32 sm_type;		/* What to check? */
> > +	__u32 sm_flags;		/* flags; see below. */
> > +	__u64 sm_ino;		/* inode number. */
> > +	__u32 sm_gen;		/* inode generation. */
> > +	__u32 sm_agno;		/* ag number. */
> > +	__u64 sm_reserved[5];	/* pad to 64 bytes */
> > +};
> > +
> > +/*
> > + * Metadata types and flags for scrub operation.
> > + */
> > +
> > +/* Scrub subcommands. */
> > +
> > +/* Number of scrub subcommands. */
> > +#define XFS_SCRUB_TYPE_NR	0
> > +
> > +/* i: Repair this metadata. */
> > +#define XFS_SCRUB_IFLAG_REPAIR		(1 << 0)
> > +
> > +/* o: Metadata object needs repair. */
> > +#define XFS_SCRUB_OFLAG_CORRUPT		(1 << 1)
> > +
> > +/*
> > + * o: Metadata object could be optimized.  It's not corrupt, but
> > + *    we could improve on it somehow.
> > + */
> > +#define XFS_SCRUB_OFLAG_PREEN		(1 << 2)
> > +
> > +/* o: Cross-referencing failed. */
> > +#define XFS_SCRUB_OFLAG_XFAIL		(1 << 3)
> > +
> > +/* o: Metadata object disagrees with cross-referenced metadata. */
> > +#define XFS_SCRUB_OFLAG_XCORRUPT	(1 << 4)
> > +
> > +/* o: Scan was not complete. */
> > +#define XFS_SCRUB_OFLAG_INCOMPLETE	(1 << 5)
> > +
> > +/* o: Metadata object looked funny but isn't corrupt. */
> > +#define XFS_SCRUB_OFLAG_WARNING		(1 << 6)
> > +
> > +#define XFS_SCRUB_FLAGS_IN	(XFS_SCRUB_IFLAG_REPAIR)
> > +#define XFS_SCRUB_FLAGS_OUT	(XFS_SCRUB_OFLAG_CORRUPT | \
> > +				 XFS_SCRUB_OFLAG_PREEN | \
> > +				 XFS_SCRUB_OFLAG_XFAIL | \
> > +				 XFS_SCRUB_OFLAG_XCORRUPT | \
> > +				 XFS_SCRUB_OFLAG_INCOMPLETE | \
> > +				 XFS_SCRUB_OFLAG_WARNING)
> > +#define XFS_SCRUB_FLAGS_ALL	(XFS_SCRUB_FLAGS_IN | XFS_SCRUB_FLAGS_OUT)
> > +
> >  /*
> >   * AG reserved block counters
> >   */
> > @@ -522,6 +574,7 @@ struct xfs_fsop_ag_resblks {
> >  #define XFS_IOC_ZERO_RANGE	_IOW ('X', 57, struct xfs_flock64)
> >  #define XFS_IOC_FREE_EOFBLOCKS	_IOR ('X', 58, struct xfs_fs_eofblocks)
> >  /*	XFS_IOC_GETFSMAP ------ hoisted 59         */
> > +#define XFS_IOC_SCRUB_METADATA	_IOWR('X', 60, struct xfs_scrub_metadata)
> >  
> >  /*
> >   * ioctl commands that replace IRIX syssgi()'s
> > diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
> > new file mode 100644
> > index 0000000..5db2a6f
> > --- /dev/null
> > +++ b/fs/xfs/scrub/scrub.c
> > @@ -0,0 +1,54 @@
> > +/*
> > + * Copyright (C) 2017 Oracle.  All Rights Reserved.
> > + *
> > + * Author: Darrick J. Wong <darrick.wong@oracle.com>
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License
> > + * as published by the Free Software Foundation; either version 2
> > + * of the License, or (at your option) any later version.
> > + *
> > + * This program is distributed in the hope that it would be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write the Free Software Foundation,
> > + * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
> > + */
> > +#include "xfs.h"
> > +#include "xfs_fs.h"
> > +#include "xfs_shared.h"
> > +#include "xfs_format.h"
> > +#include "xfs_trans_resv.h"
> > +#include "xfs_mount.h"
> > +#include "xfs_defer.h"
> > +#include "xfs_btree.h"
> > +#include "xfs_bit.h"
> > +#include "xfs_log_format.h"
> > +#include "xfs_trans.h"
> > +#include "xfs_sb.h"
> > +#include "xfs_inode.h"
> > +#include "xfs_alloc.h"
> > +#include "xfs_alloc_btree.h"
> > +#include "xfs_bmap.h"
> > +#include "xfs_bmap_btree.h"
> > +#include "xfs_ialloc.h"
> > +#include "xfs_ialloc_btree.h"
> > +#include "xfs_refcount.h"
> > +#include "xfs_refcount_btree.h"
> > +#include "xfs_rmap.h"
> > +#include "xfs_rmap_btree.h"
> > +#include "scrub/xfs_scrub.h"
> > +#include "scrub/scrub.h"
> > +#include "scrub/trace.h"
> > +
> > +/* Dispatch metadata scrubbing. */
> > +int
> > +xfs_scrub_metadata(
> > +	struct xfs_inode		*ip,
> > +	struct xfs_scrub_metadata	*sm)
> > +{
> > +	return -EOPNOTSUPP;
> > +}
> > diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
> > new file mode 100644
> > index 0000000..eb1cd9d
> > --- /dev/null
> > +++ b/fs/xfs/scrub/scrub.h
> > @@ -0,0 +1,25 @@
> > +/*
> > + * Copyright (C) 2017 Oracle.  All Rights Reserved.
> > + *
> > + * Author: Darrick J. Wong <darrick.wong@oracle.com>
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License
> > + * as published by the Free Software Foundation; either version 2
> > + * of the License, or (at your option) any later version.
> > + *
> > + * This program is distributed in the hope that it would be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write the Free Software Foundation,
> > + * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
> > + */
> > +#ifndef __XFS_SCRUB_SCRUB_H__
> > +#define __XFS_SCRUB_SCRUB_H__
> > +
> > +/* Metadata scrubbers */
> > +
> > +#endif	/* __XFS_SCRUB_SCRUB_H__ */
> > diff --git a/fs/xfs/scrub/trace.c b/fs/xfs/scrub/trace.c
> > new file mode 100644
> > index 0000000..c59fd41
> > --- /dev/null
> > +++ b/fs/xfs/scrub/trace.c
> > @@ -0,0 +1,41 @@
> > +/*
> > + * Copyright (C) 2017 Oracle.  All Rights Reserved.
> > + *
> > + * Author: Darrick J. Wong <darrick.wong@oracle.com>
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License
> > + * as published by the Free Software Foundation; either version 2
> > + * of the License, or (at your option) any later version.
> > + *
> > + * This program is distributed in the hope that it would be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write the Free Software Foundation,
> > + * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
> > + */
> > +#include "xfs.h"
> > +#include "xfs_fs.h"
> > +#include "xfs_shared.h"
> > +#include "xfs_format.h"
> > +#include "xfs_log_format.h"
> > +#include "xfs_trans_resv.h"
> > +#include "xfs_mount.h"
> > +#include "xfs_defer.h"
> > +#include "xfs_da_format.h"
> > +#include "xfs_defer.h"
> > +#include "xfs_inode.h"
> > +#include "xfs_btree.h"
> > +#include "xfs_trans.h"
> > +#include "scrub/xfs_scrub.h"
> > +#include "scrub/scrub.h"
> > +
> > +/*
> > + * We include this last to have the helpers above available for the trace
> > + * event implementations.
> > + */
> > +#define CREATE_TRACE_POINTS
> > +#include "scrub/trace.h"
> > diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
> > new file mode 100644
> > index 0000000..a95a7c8
> > --- /dev/null
> > +++ b/fs/xfs/scrub/trace.h
> > @@ -0,0 +1,33 @@
> > +/*
> > + * Copyright (C) 2017 Oracle.  All Rights Reserved.
> > + *
> > + * Author: Darrick J. Wong <darrick.wong@oracle.com>
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License
> > + * as published by the Free Software Foundation; either version 2
> > + * of the License, or (at your option) any later version.
> > + *
> > + * This program is distributed in the hope that it would be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write the Free Software Foundation,
> > + * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
> > + */
> > +#undef TRACE_SYSTEM
> > +#define TRACE_SYSTEM xfs_scrub
> > +
> > +#if !defined(_TRACE_XFS_SCRUB_TRACE_H) || defined(TRACE_HEADER_MULTI_READ)
> > +#define _TRACE_XFS_SCRUB_TRACE_H
> > +
> > +#include <linux/tracepoint.h>
> > +
> > +#endif /* _TRACE_XFS_SCRUB_TRACE_H */
> > +
> > +#undef TRACE_INCLUDE_PATH
> > +#define TRACE_INCLUDE_PATH .
> > +#define TRACE_INCLUDE_FILE scrub/trace
> > +#include <trace/define_trace.h>
> > diff --git a/fs/xfs/scrub/xfs_scrub.h b/fs/xfs/scrub/xfs_scrub.h
> > new file mode 100644
> > index 0000000..e00e0ea
> > --- /dev/null
> > +++ b/fs/xfs/scrub/xfs_scrub.h
> > @@ -0,0 +1,29 @@
> > +/*
> > + * Copyright (C) 2017 Oracle.  All Rights Reserved.
> > + *
> > + * Author: Darrick J. Wong <darrick.wong@oracle.com>
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License
> > + * as published by the Free Software Foundation; either version 2
> > + * of the License, or (at your option) any later version.
> > + *
> > + * This program is distributed in the hope that it would be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write the Free Software Foundation,
> > + * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
> > + */
> > +#ifndef __XFS_SCRUB_H__
> > +#define __XFS_SCRUB_H__
> > +
> > +#ifndef CONFIG_XFS_ONLINE_SCRUB
> > +# define xfs_scrub_metadata(ip, sm)	(-ENOTTY)
> > +#else
> > +int xfs_scrub_metadata(struct xfs_inode *ip, struct xfs_scrub_metadata *sm);
> > +#endif /* CONFIG_XFS_ONLINE_SCRUB */
> > +
> > +#endif	/* __XFS_SCRUB_H__ */
> > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > index 44dc178..ab7a7f8 100644
> > --- a/fs/xfs/xfs_ioctl.c
> > +++ b/fs/xfs/xfs_ioctl.c
> > @@ -44,6 +44,7 @@
> >  #include "xfs_btree.h"
> >  #include <linux/fsmap.h>
> >  #include "xfs_fsmap.h"
> > +#include "scrub/xfs_scrub.h"
> >  
> >  #include <linux/capability.h>
> >  #include <linux/cred.h>
> > @@ -1702,6 +1703,30 @@ xfs_ioc_getfsmap(
> >  	return 0;
> >  }
> >  
> > +STATIC int
> > +xfs_ioc_scrub_metadata(
> > +	struct xfs_inode		*ip,
> > +	void				__user *arg)
> > +{
> > +	struct xfs_scrub_metadata	scrub;
> > +	int				error;
> > +
> > +	if (!capable(CAP_SYS_ADMIN))
> > +		return -EPERM;
> > +
> > +	if (copy_from_user(&scrub, arg, sizeof(scrub)))
> > +		return -EFAULT;
> > +
> > +	error = xfs_scrub_metadata(ip, &scrub);
> > +	if (error)
> > +		return error;
> > +
> > +	if (copy_to_user(arg, &scrub, sizeof(scrub)))
> > +		return -EFAULT;
> > +
> > +	return 0;
> > +}
> > +
> >  int
> >  xfs_ioc_swapext(
> >  	xfs_swapext_t	*sxp)
> > @@ -1906,6 +1931,9 @@ xfs_file_ioctl(
> >  	case FS_IOC_GETFSMAP:
> >  		return xfs_ioc_getfsmap(ip, arg);
> >  
> > +	case XFS_IOC_SCRUB_METADATA:
> > +		return xfs_ioc_scrub_metadata(ip, arg);
> > +
> >  	case XFS_IOC_FD_TO_HANDLE:
> >  	case XFS_IOC_PATH_TO_HANDLE:
> >  	case XFS_IOC_PATH_TO_FSHANDLE: {
> > diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> > index e8b4de3..972d4bd 100644
> > --- a/fs/xfs/xfs_ioctl32.c
> > +++ b/fs/xfs/xfs_ioctl32.c
> > @@ -557,6 +557,7 @@ xfs_file_compat_ioctl(
> >  	case XFS_IOC_ERROR_CLEARALL:
> >  	case FS_IOC_GETFSMAP:
> >  	case XFS_IOC_GET_AG_RESBLKS:
> > +	case XFS_IOC_SCRUB_METADATA:
> >  		return xfs_file_ioctl(filp, cmd, p);
> >  #ifndef BROKEN_X86_ALIGNMENT
> >  	/* These are handled fine if no alignment issues */
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
