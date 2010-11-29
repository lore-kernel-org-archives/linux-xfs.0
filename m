Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oATFwq9Q184039 for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 09:58:52 -0600
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9F2B68F8092
	for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 08:00:31 -0800 (PST)
Received: from augusta (augusta.americas.sgi.com [128.162.233.117])
	by estes.americas.sgi.com (Postfix) with ESMTP id 662E47001C6B
	for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 10:00:31 -0600 (CST)
Date: Mon, 29 Nov 2010 10:00:23 -0600
From: Bill Kendall <wkendall@sgi.com>
Subject: [PATCH] xfsdump: remove old namreg code
Message-ID: <20101129160023.GA20755@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Remove the old, unused namreg code under the 'common' directory.
This was superceded a long time ago by the version under the
'restore' directory.

Signed-off-by: Bill Kendall <wkendall@sgi.com>

---
 common/Makefile |    2 
 common/namreg.c |  253 --------------------------------------------------------
 common/namreg.h |   69 ---------------
 3 files changed, 1 insertion(+), 323 deletions(-)

Index: xfsdump-kernel.org/common/Makefile
===================================================================
--- xfsdump-kernel.org.orig/common/Makefile
+++ xfsdump-kernel.org/common/Makefile
@@ -12,7 +12,7 @@ LSRCFILES = arch_xlate.c arch_xlate.h \
 	exit.h fs.c fs.h getdents.c getdents.h global.c global.h \
 	hsmapi.c hsmapi.h inventory.c inventory.h lock.c lock.h \
 	main.c media.c media.h media_rmvtape.h mlog.c mlog.h \
-	namreg.c namreg.h openutil.c openutil.h path.c path.h qlock.c qlock.h \
+	openutil.c openutil.h path.c path.h qlock.c qlock.h \
 	rec_hdr.h ring.c ring.h sproc.c sproc.h stream.c \
 	stream.h timeutil.c timeutil.h ts_mtio.h types.h util.c util.h
 
Index: xfsdump-kernel.org/common/namreg.c
===================================================================
--- xfsdump-kernel.org.orig/common/namreg.c
+++ /dev/null
@@ -1,253 +0,0 @@
-/*
- * Copyright (c) 2000-2001 Silicon Graphics, Inc.
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
-
-#include <sys/types.h>
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <fcntl.h>
-#include <stdio.h>
-#include <stdlib.h>
-#include <unistd.h>
-#include <errno.h>
-#include <string.h>
-
-#include "types.h"
-#include "mlog.h"
-#include "namreg.h"
-#include "openutil.h"
-#include "cleanup.h"
-
-/* structure definitions used locally ****************************************/
-
-/* template for the name of the tmp file containing the names
- */
-#define NAMETEMPLATE	"namreg"
-
-/* context for a namreg - allocated by and pointer to returned by namreg_init()
- */
-struct namreg_context {
-	int nc_fd;		/* file descriptor of tmp file */
-	bool_t nc_not_at_end;
-	off64_t nc_nextoff;
-	char *nc_pathname;
-};
-
-typedef struct namreg_context namreg_context_t;
-
-
-/* declarations of externally defined global symbols *************************/
-
-
-/* forward declarations of locally defined static functions ******************/
-
-static void namreg_abort_cleanup( void *, void * );
-
-
-/* definition of locally defined global variables ****************************/
-
-
-/* definition of locally defined static variables *****************************/
-
-
-/* definition of locally defined global functions ****************************/
-
-namreg_t *
-namreg_init( bool_t cumulative,
-	     bool_t delta,
-	     char *housekeepingdir )
-{
-	namreg_context_t *ncp;
-
-	/* allocate and initialize context
-	 */
-	ncp = ( namreg_context_t * )calloc( 1, sizeof( namreg_context_t ));
-	ASSERT( ncp );
-
-	/* generate a string containing the pathname of the namreg file
-	 */
-	ncp->nc_pathname = open_pathalloc( housekeepingdir, NAMETEMPLATE, 0 );
-
-	/* if not a cumulative restore, be sure the name registry gets removed
-	 * on exit.
-	 */
-	if ( ! cumulative ) {
-		( void )cleanup_register( namreg_abort_cleanup,
-					  ( void * )ncp,
-					  0 );
-	}
-
-	/* if this is a delta during a cumulative restore, the namreg file must
-	 * already exist. if not, create/truncate.
-	 */
-	if ( cumulative && delta ) {
-		ncp->nc_fd = open_rwp( ncp->nc_pathname );
-		if ( ncp->nc_fd < 0 ) {
-			mlog( MLOG_NORMAL,
-			      _("could not open %s: %s\n"),
-			      ncp->nc_pathname,
-			      strerror( errno ));
-			return 0;
-		}
-	} else {
-		ncp->nc_fd = open_trwp( ncp->nc_pathname );
-		if ( ncp->nc_fd < 0 ) {
-			return 0;
-		}
-	}
-
-	return ( namreg_t * )ncp;
-}
-
-namreg_ix_t
-namreg_add( namreg_t *namregp, char *name, size_t namelen )
-{
-	register namreg_context_t *ncp = ( namreg_context_t *)namregp;
-	off64_t oldoff;
-	intgen_t nwritten;
-	unsigned char c;
-	
-	/* make sure file pointer is positioned to write at end of file
-	 */
-	if ( ncp->nc_not_at_end ) {
-		off64_t new_off;
-		new_off = lseek64( ncp->nc_fd, ( off64_t )0, SEEK_END );
-		if ( new_off == ( off64_t )-1 ) {
-			mlog( MLOG_NORMAL,
-			      _("lseek of namreg failed: %s\n"),
-			      strerror( errno ));
-			ASSERT( 0 );
-			return NAMREG_IX_NULL;
-		}
-		ncp->nc_nextoff = new_off;
-		ncp->nc_not_at_end = BOOL_FALSE;
-	}
-
-	/* save the current offset
-	 */
-	oldoff = ncp->nc_nextoff;
-
-	/* write a one byte unsigned string length
-	 */
-	ASSERT( namelen < 256 );
-	c = ( unsigned char )( namelen & 0xff );
-	nwritten = write( ncp->nc_fd, ( void * )&c, 1 );
-	if ( nwritten != 1 ) {
-		mlog( MLOG_NORMAL,
-		      _("write of namreg failed: %s\n"),
-		      strerror( errno ));
-		ASSERT( 0 );
-		return NAMREG_IX_NULL;
-	}
-
-	/* write the name string
-	 */
-	nwritten = write( ncp->nc_fd, ( void * )name, namelen );
-	if ( ( size_t )nwritten != namelen ) {
-		mlog( MLOG_NORMAL,
-		      _("write of namreg failed: %s\n"),
-		      strerror( errno ));
-		ASSERT( 0 );
-		return NAMREG_IX_NULL;
-	}
-
-	ncp->nc_nextoff += ( off64_t )( 1 + namelen );
-	return ( namreg_ix_t )oldoff;
-}
-
-/* ARGSUSED */
-void
-namreg_del( namreg_t *namregp, namreg_ix_t namreg_ix )
-{
-	/* currently not implemented - grows, never shrinks
-	 */
-}
-
-intgen_t
-namreg_get( namreg_t *namregp,
-	    namreg_ix_t namreg_ix,
-	    char *bufp,
-	    size_t bufsz )
-{
-	register namreg_context_t *ncp = ( namreg_context_t *)namregp;
-	off64_t new_off;
-	intgen_t nread;
-	size_t len;
-	unsigned char c;
-
-	/* convert the ix into the offset
-	 */
-	new_off = ( off64_t )namreg_ix;
-
-	/* seek to the name
-	 */
-	ASSERT( namreg_ix != NAMREG_IX_NULL );
-	new_off = lseek64( ncp->nc_fd, new_off, SEEK_SET );
-	if ( new_off == ( off64_t )-1 ) {
-		mlog( MLOG_NORMAL,
-		      _("lseek of namreg failed: %s\n"),
-		      strerror( errno ));
-		return -3;
-	}
-
-	/* read the name length
-	 */
-	c = 0; /* unnecessary, but keeps lint happy */
-	nread = read( ncp->nc_fd, ( void * )&c, 1 );
-	if ( nread != 1 ) {
-		mlog( MLOG_NORMAL,
-		      _("read of namreg failed: %s (nread = %d)\n"),
-		      strerror( errno ),
-		      nread );
-		return -3;
-	}
-	
-	/* deal with a short caller-supplied buffer
-	 */
-	len = ( size_t )c;
-	if ( bufsz < len + 1 ) {
-		return -1;
-	}
-
-	/* read the name
-	 */
-	nread = read( ncp->nc_fd, ( void * )bufp, len );
-	if ( ( size_t )nread != len ) {
-		mlog( MLOG_NORMAL,
-		      _("read of namreg failed: %s\n"),
-		      strerror( errno ));
-		return -3;
-	}
-
-	/* null-terminate the string if room
-	 */
-	bufp[ len ] = 0;
-
-	ncp->nc_not_at_end = BOOL_TRUE;
-	
-	return ( intgen_t )len;
-}
-
-
-/* definition of locally defined static functions ****************************/
-
-static void
-namreg_abort_cleanup( void *arg1, void *arg2 )
-{
-	namreg_context_t *ncp = ( namreg_context_t * )arg1;
-	( void )unlink( ncp->nc_pathname );
-}
Index: xfsdump-kernel.org/common/namreg.h
===================================================================
--- xfsdump-kernel.org.orig/common/namreg.h
+++ /dev/null
@@ -1,69 +0,0 @@
-/*
- * Copyright (c) 2000-2001 Silicon Graphics, Inc.
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
-#ifndef NAMREG_H
-#define NAMREG_H
-
-/* namreg.[hc] - directory entry registry
- *
- * provides unique directory entry ID's and storage for the entry
- * name.
- */
-
-/* namreg_t - external handle; internally typecast to something more useful
- */
-typedef void namreg_t;
-
-
-/* namreg_ix_t - abstract index of a registered name
- */
-typedef size_t namreg_ix_t;
-#define NAMREG_IX_NULL	( ( namreg_ix_t )( -1 ))
-#define NAMREG_IX_MAX	SIZEMAX
-
-
-/* namreg_init - creates a name registry. returns namreg_t pointer
- */
-extern namreg_t *namreg_init( bool_t cumulative,
-			      bool_t delta,
-			      char *housekeepingdir );
-
-
-/* namreg_add - registers a name. name does not need to be null-terminated.
- * returns abstract index for use with namreg_get().
- */
-extern namreg_ix_t namreg_add( namreg_t *namregp, char *name, size_t namelen );
-
-
-/* namreg_del - remove a name from the registry
- */
-extern void namreg_del( namreg_t *namregp, namreg_ix_t namreg_ix );
-
-
-/* namreg_get - retrieves the name identified by the index.
- * fills the buffer with the null-terminated name from the registry.
- * returns the strlen() of the name. returns -1 if the buffer is too
- * small to fit the null-terminated name. return -2 if the name
- * not in the registry. return -3 if a system call fails.
- */
-extern intgen_t namreg_get( namreg_t *namregp,
-			    namreg_ix_t namreg_ix,
-			    char *bufp,
-			    size_t bufsz );
-
-
-#endif /* NAMREG_H */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
