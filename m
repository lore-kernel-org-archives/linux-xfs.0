Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 29 Jul 2007 14:14:40 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6TLEWbm005001
	for <xfs@oss.sgi.com>; Sun, 29 Jul 2007 14:14:34 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l6TLEaA5013003
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sun, 29 Jul 2007 23:14:36 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l6TLEZ0t013001
	for xfs@oss.sgi.com; Sun, 29 Jul 2007 23:14:35 +0200
Date: Sun, 29 Jul 2007 23:14:35 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] kill move.[ch]
Message-ID: <20070729211435.GC12824@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Kill uio related functions and defines now that they're unused.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/Makefile-linux-2.6
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/Makefile-linux-2.6	2007-06-12 21:31:16.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/Makefile-linux-2.6	2007-06-12 21:31:20.000000000 +0200
@@ -103,7 +103,6 @@ xfs-y				+= $(addprefix $(XFS_LINUX)/, \
 # Objects in support/
 xfs-y				+= $(addprefix support/, \
 				   debug.o \
-				   move.o \
 				   uuid.o)
 
 xfs-$(CONFIG_XFS_TRACE)		+= support/ktrace.o
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_linux.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_linux.h	2007-06-12 21:31:06.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_linux.h	2007-06-12 21:31:09.000000000 +0200
@@ -51,7 +51,6 @@
 
 #include <support/ktrace.h>
 #include <support/debug.h>
-#include <support/move.h>
 #include <support/uuid.h>
 
 #include <linux/mm.h>
Index: linux-2.6-xfs/fs/xfs/support/move.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/support/move.c	2007-06-12 21:31:30.000000000 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,51 +0,0 @@
-/*
- * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-#include <xfs.h>
-
-/* Read from kernel buffer at src to user/kernel buffer defined
- * by the uio structure. Advance the pointer in the uio struct
- * as we go.
- */
-int
-xfs_uio_read(caddr_t src, size_t len, struct uio *uio)
-{
-	size_t	count;
-
-	if (!len || !uio->uio_resid)
-		return 0;
-
-	count = uio->uio_iov->iov_len;
-	if (!count)
-		return 0;
-	if (count > len)
-		count = len;
-
-	if (uio->uio_segflg == UIO_USERSPACE) {
-		if (copy_to_user(uio->uio_iov->iov_base, src, count))
-			return EFAULT;
-	} else {
-		ASSERT(uio->uio_segflg == UIO_SYSSPACE);
-		memcpy(uio->uio_iov->iov_base, src, count);
-	}
-
-	uio->uio_iov->iov_base = (void*)((char*)uio->uio_iov->iov_base + count);
-	uio->uio_iov->iov_len -= count;
-	uio->uio_offset += count;
-	uio->uio_resid -= count;
-	return 0;
-}
Index: linux-2.6-xfs/fs/xfs/support/move.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/support/move.h	2007-06-12 21:31:30.000000000 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,70 +0,0 @@
-/*
- * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
- * Portions Copyright (c) 1982, 1986, 1993, 1994
- *	The Regents of the University of California.  All rights reserved.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- * 1. Redistributions of source code must retain the above copyright
- *    notice, this list of conditions and the following disclaimer.
- * 2. Redistributions in binary form must reproduce the above copyright
- *    notice, this list of conditions and the following disclaimer in the
- *    documentation and/or other materials provided with the distribution.
- * 3. Neither the name of the University nor the names of its contributors
- *    may be used to endorse or promote products derived from this software
- *    without specific prior written permission.
- *
- * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
- * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
- * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
- * ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
- * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
- * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
- * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
- * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
- * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
- * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
- * SUCH DAMAGE.
- */
-#ifndef __XFS_SUPPORT_MOVE_H__
-#define __XFS_SUPPORT_MOVE_H__
-
-#include <linux/uio.h>
-#include <asm/uaccess.h>
-
-/* Segment flag values. */
-enum uio_seg {
-	UIO_USERSPACE,          /* from user data space */
-	UIO_SYSSPACE,           /* from system space */
-};
-
-struct uio {
-	struct kvec	*uio_iov;   /* pointer to array of iovecs */
-	int		uio_iovcnt; /* number of iovecs in array */
-	xfs_off_t	uio_offset; /* offset in file this uio corresponds to */
-	int		uio_resid;  /* residual i/o count */
-	enum uio_seg	uio_segflg; /* see above */
-};
-
-typedef struct uio uio_t;
-typedef struct kvec iovec_t;
-
-extern int	xfs_uio_read (caddr_t, size_t, uio_t *);
-
-#endif  /* __XFS_SUPPORT_MOVE_H__ */
