Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 12 Mar 2007 18:51:32 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l2D1pL6p030724
	for <xfs@oss.sgi.com>; Mon, 12 Mar 2007 18:51:23 -0700
Message-Id: <200703130151.MAA03235@larry.melbourne.sgi.com>
From: "Barry Naujok" <bnaujok@melbourne.sgi.com>
Subject: RE: [PATCH] New xfs_repair handling for inode nlink counts
Date: Tue, 13 Mar 2007 12:51:35 +1100
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0193_01C7656E.58D2DAD0"
In-Reply-To: <20070309073410.GA8798@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: 'Christoph Hellwig' <hch@infradead.org>
Cc: xfs@oss.sgi.com, xfs-dev@sgi.com

This is a multi-part message in MIME format.

------=_NextPart_000_0193_01C7656E.58D2DAD0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Christoph,

Thanks for the feedback. I've attached an update to the trackmem stuff 
for review. globals.c is now unmodified.

Regards,
Barry.

> -----Original Message-----
> From: xfs-bounce@oss.sgi.com [mailto:xfs-bounce@oss.sgi.com] 
> On Behalf Of Christoph Hellwig
> Sent: Friday, 9 March 2007 6:34 PM
> To: Barry Naujok
> Cc: xfs@oss.sgi.com; xfs-dev@sgi.com
> Subject: Re: [PATCH] New xfs_repair handling for inode nlink counts
> 
> 
> +#ifdef TRACK_MEMORY
> +
> +#undef calloc
> +#undef malloc
> +#undef memalign
> +#undef realloc
> +#undef free
> 
> 
> 	Can you put all thise into a memory_tracking.h file that
> 	gets include with:
> 
> 	#ifdef TRACK_MEMORY
> 	#include "track_memory.h"
> 	#endif
> 
> 	Instead of polluting the implementation file?
> 
> +	/* add pointer to hash list, very basic simple hash function */
> +	i = (((size_t)p) >> 8) & 0xff;
> 
> +	i = (((size_t)ptr) >> 8) & 0xff;
> 
> 	Note that there is not guarantee that size_t and 
> pointers have the
> 	same lenght, and there are system where it's not 
> (win64?), better
> 	cast things use uintptr_t here.
> 
> --- xfsprogs.orig/repair/globals.h
> +++ xfsprogs/repair/globals.h
> @@ -16,6 +16,16 @@
>   * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  
> +#ifdef TRACK_MEMORY
> +
> +#define calloc(n,s)	track_calloc(__FILE__, __LINE__, (n), (s))
> +#define malloc(s)	track_malloc(__FILE__, __LINE__, (s))
> +#define memalign(b,s)	track_memalign(__FILE__, 
> __LINE__, (b), (s))
> +#define realloc(p,s)	track_realloc(__FILE__, __LINE__, (p), (s))
> +#define free(p)		track_free(__FILE__, __LINE__, (p))
> +
> +#endif
> +
>  #ifndef _XFS_REPAIR_GLOBAL_H
>  #define _XFS_REPAIR_GLOBAL_H
> 
> 	The memory tracking should probably come after the inclusion
> 	guards.
> 
> 

------=_NextPart_000_0193_01C7656E.58D2DAD0
Content-Type: application/octet-stream;
	name="trackmem_update.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="trackmem_update.patch"


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
xfsprogs/repair/Makefile
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

--- a/xfsprogs/repair/Makefile	2007-03-13 12:48:40.000000000 +1100
+++ b/xfsprogs/repair/Makefile	2007-03-13 12:02:05.061400111 +1100
@@ -9,13 +9,14 @@ LTCOMMAND =3D xfs_repair
=20
 HFILES =3D agheader.h attr_repair.h avl.h avl64.h bmap.h dinode.h dir.h \
 	dir2.h dir_stack.h err_protos.h globals.h incore.h protos.h rt.h \
-	progress.h scan.h versions.h prefetch.h threads.h
+	progress.h scan.h versions.h prefetch.h threads.h trackmem.h
=20
 CFILES =3D agheader.c attr_repair.c avl.c avl64.c bmap.c dino_chunks.c \
 	dinode.c dir.c dir2.c dir_stack.c globals.c incore.c \
 	incore_bmc.c init.c incore_ext.c incore_ino.c phase1.c \
 	phase2.c phase3.c phase4.c phase5.c phase6.c phase7.c rt.c sb.c \
-	progress.c prefetch.c scan.c versions.c xfs_repair.c threads.c
+	progress.c prefetch.c scan.c versions.c xfs_repair.c threads.c \
+	trackmem.c
=20
 LLDLIBS =3D $(LIBXFS) $(LIBXLOG) $(LIBUUID) $(LIBPTHREAD) $(LIBRT)
 LTDEPENDENCIES =3D $(LIBXFS) $(LIBXLOG)

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
xfsprogs/repair/globals.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

--- a/xfsprogs/repair/globals.h	2007-03-13 12:48:40.000000000 +1100
+++ b/xfsprogs/repair/globals.h	2007-03-13 12:39:46.487391946 +1100
@@ -23,6 +23,10 @@
 #define EXTERN extern
 #endif
=20
+#ifdef TRACK_MEMORY
+#include "trackmem.h"
+#endif
+
 /* useful macros */
=20
 #define rounddown(x, y) (((x)/(y))*(y))

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
xfsprogs/repair/trackmem.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

--- a/xfsprogs/repair/trackmem.c	2006-06-17 00:58:24.000000000 +1000
+++ b/xfsprogs/repair/trackmem.c	2007-03-13 12:48:25.331111073 +1100
@@ -0,0 +1,195 @@
+/*
+ * Copyright (c) 2007 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <libxfs.h>
+
+#undef calloc
+#undef malloc
+#undef memalign
+#undef realloc
+#undef free
+
+/*
+ * Track by file name pointer and also by return pointer
+ */
+
+typedef struct func {
+	const char	*file;
+	int		line;
+	int64_t		acount;
+	int64_t		fcount;
+	int64_t		rcount;
+	int64_t		current;
+	int64_t		peak;
+} func_t;
+
+typedef struct entry {
+	struct entry	*next;
+	func_t		*fileline;
+	size_t		size;
+	void		*ptr;
+} entry_t;
+
+static int	caller_count =3D 0;
+static int	caller_size =3D 0;
+static func_t	*callers =3D NULL;
+
+static entry_t	*ptrhash[256];
+
+static
+void track_alloc(const char *file, int line, size_t size, void *p)
+{
+	int		i;
+	entry_t		*e;
+
+	/* find an existing func call from file/line */
+	for (i =3D 0; i < caller_count; i++) {
+		if ((callers[i].file =3D=3D file) && (callers[i].line =3D=3D line))
+			break;
+	}
+	if (i =3D=3D caller_count) {	/* add new func if not found */
+		if (caller_count =3D=3D caller_size) {
+			caller_size +=3D 64;
+			callers =3D realloc(callers, sizeof(func_t) * caller_size);
+		}
+		memset(&callers[i], 0, sizeof(func_t));
+		callers[i].file =3D file;
+		callers[i].line =3D line;
+		caller_count++;
+	}
+
+	e =3D malloc(sizeof(entry_t));
+	e->size =3D size;
+	e->ptr =3D p;
+	e->fileline =3D &callers[i];
+
+	callers[i].acount++;
+	callers[i].current +=3D size;
+	if (callers[i].current > callers[i].peak)
+		callers[i].peak =3D callers[i].current;
+
+	/* add pointer to hash list, very basic simple hash function */
+	i =3D (((int)p) >> 8) & 0xff;
+
+	e->next =3D ptrhash[i];
+	ptrhash[i] =3D e;
+}
+
+void *track_calloc(const char *file, int line, size_t num, size_t size)
+{
+	void *retval =3D calloc(num, size);
+
+	if (retval !=3D NULL)
+		track_alloc(file, line, num * size, retval);
+
+	return retval;
+}
+
+void *track_malloc(const char *file, int line, size_t size)
+{
+	void *retval =3D malloc(size);
+
+	if (retval !=3D NULL)
+		track_alloc(file, line, size, retval);
+
+	return retval;
+}
+
+void *track_memalign(const char *file, int line, size_t boundary, size_t s=
ize)
+{
+	void *retval =3D memalign(boundary, size);
+
+	if (retval !=3D NULL)
+		track_alloc(file, line, size, retval);
+
+	return retval;
+}
+
+void *track_realloc(const char *file, int line, void *ptr, size_t size)
+{
+	int		i;
+	entry_t		*e, *prev;
+	void 		*newptr =3D realloc(ptr, size);
+
+	if (ptr =3D=3D NULL && newptr !=3D NULL) {
+		track_alloc(file, line, size, newptr);
+		return newptr;
+	}
+
+	i =3D (((size_t)ptr) >> 8) & 0xff;
+
+	prev =3D NULL;
+	for (e =3D ptrhash[i]; e; e =3D e->next) {
+		if (e->ptr =3D=3D ptr)
+			break;
+		prev =3D e;
+	}
+	if (!e)
+		return newptr;
+
+	e->fileline->rcount++;
+	e->fileline->current =3D e->fileline->current + size - e->size;
+	if (e->fileline->current > e->fileline->peak)
+		e->fileline->peak =3D e->fileline->current;
+	e->size =3D size;
+	e->ptr =3D newptr;
+
+	return newptr;
+}
+
+void track_free(const char *file, int line, void *ptr)
+{
+	int		i;
+	entry_t	*e, *prev;
+
+	free(ptr);
+
+	/* find associated entry */
+	i =3D (((size_t)ptr) >> 8) & 0xff;
+
+	prev =3D NULL;
+	for (e =3D ptrhash[i]; e; e =3D e->next) {
+		if (e->ptr =3D=3D ptr)
+			break;
+		prev =3D e;
+	}
+	if (!e)
+		return;
+
+	e->fileline->fcount++;
+	e->fileline->current -=3D e->size;
+
+	if (prev)
+		prev->next =3D e->next;
+	else
+		ptrhash[i] =3D e->next;
+	free(e);
+}
+
+void print_memory_usage(void)
+{
+	int i;
+
+	printf("%20s:line \ta_cnt\tf_cnt\tr_cnt\tremain\tpeak\n", "file");
+	for (i =3D 0; i < caller_count; i++) {
+		printf("%20s:%-5d\t%lld\t%lld\t%lld\t%lld\t%lld\n",
+			callers[i].file, callers[i].line,
+			callers[i].acount, callers[i].fcount, callers[i].rcount,
+			callers[i].current, callers[i].peak);
+	}
+}

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
xfsprogs/repair/trackmem.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

--- a/xfsprogs/repair/trackmem.h	2006-06-17 00:58:24.000000000 +1000
+++ b/xfsprogs/repair/trackmem.h	2007-03-13 12:47:31.226230019 +1100
@@ -0,0 +1,35 @@
+/*
+ * Copyright (c) 2007 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#ifndef _XFS_REPAIR_TRACK_MEM_H
+#define _XFS_REPAIR_TRACK_MEM_H
+
+#define calloc(n,s)	track_calloc(__FILE__, __LINE__, (n), (s))
+#define malloc(s)	track_malloc(__FILE__, __LINE__, (s))
+#define memalign(b,s)	track_memalign(__FILE__, __LINE__, (b), (s))
+#define realloc(p,s)	track_realloc(__FILE__, __LINE__, (p), (s))
+#define free(p)		track_free(__FILE__, __LINE__, (p))
+
+void print_memory_usage(void);
+void *track_calloc(const char *file, int line, size_t num, size_t size);
+void *track_malloc(const char *file, int line, size_t size);
+void *track_memalign(const char *file, int line, size_t boundary, size_t s=
ize);
+void *track_realloc(const char *file, int line, void *ptr, size_t size);
+void track_free(const char *file, int line, void *ptr);
+
+#endif /* _XFS_REPAIR_TRACK_MEM_H */

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
xfsprogs/repair/xfs_repair.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

--- a/xfsprogs/repair/xfs_repair.c	2007-03-13 12:48:40.000000000 +1100
+++ b/xfsprogs/repair/xfs_repair.c	2007-03-13 12:02:45.340085859 +1100
@@ -563,7 +563,7 @@ main(int argc, char **argv)
=20
 	/* XXX: nathans - something in phase4 ain't playing by */
 	/* the buffer cache rules.. why doesn't IRIX hit this? */
-	libxfs_bcache_purge();
+	libxfs_bcache_flush();
=20
 	if (no_modify)
 		printf(_("No modify flag set, skipping phase 5\n"));
@@ -576,6 +576,8 @@ main(int argc, char **argv)
 		phase6(mp);
 		timestamp(PHASE_END, 6, NULL);
=20
+		libxfs_bcache_flush();
+
 		phase7(mp);
 		timestamp(PHASE_END, 7, NULL);
 	} else  {
@@ -640,6 +642,10 @@ _("Warning:  project quota information w
 	if (do_parallel && report_interval)
 		stop_progress_rpt();
=20
+#ifdef TRACK_MEMORY
+	print_memory_usage();
+#endif
+
 	if (no_modify)  {
 		do_log(
 	_("No modify flag set, skipping filesystem flush and exiting.\n"));

------=_NextPart_000_0193_01C7656E.58D2DAD0--
