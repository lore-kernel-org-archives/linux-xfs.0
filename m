Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36634 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727827AbeKJAMi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 9 Nov 2018 19:12:38 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8566E307D963
        for <linux-xfs@vger.kernel.org>; Fri,  9 Nov 2018 14:31:46 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 06/24] xfsdump: (4/4)(style) remove spaces from parentheses
Date: Fri,  9 Nov 2018 15:29:46 +0100
Message-Id: <20181109143004.24963-7-jtulak@redhat.com>
In-Reply-To: <20181109143004.24963-1-jtulak@redhat.com>
References: <20181109143004.24963-1-jtulak@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jan Tulak <jtulak@redhat.com>

Transform "( x, y )" to "(x, y)", and the same for [].

Created by this script:

#!/usr/bin/env bash
# transform 'foo( x, y )' -> 'foo(x, y)'

# regexps in order:
# - remove spaces after opening parentheses (
# - remove spaces before closing parentheses )
# - remove spaces after opening brackets [
# - remove spaces before closing brackets ]

find . -name '*.[ch]' ! -type d -exec bash -c '
sed -i \
    -e "s/(\s\+/(/g" \
    -e "s/\(\S\)\s\+)/\1)/g" \
    -e "s/\[\s\+/[/g" \
    -e "s/\(\S\)\s\+\]/\1]/g" \
    $0
' {} \;

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 include/swab.h        |  24 +-
 include/swap.h        |  10 +-
 inventory/getopt.h    |   2 +-
 inventory/inv_api.c   | 414 +++++++++++------------
 inventory/inv_core.c  | 106 +++---
 inventory/inv_files.c |  10 +-
 inventory/inv_fstab.c | 152 ++++-----
 inventory/inv_idx.c   | 276 ++++++++--------
 inventory/inv_mgr.c   | 332 +++++++++----------
 inventory/inv_oref.c  |  46 +--
 inventory/inv_oref.h  |   2 +-
 inventory/inv_priv.h  | 244 +++++++-------
 inventory/inv_stobj.c | 748 +++++++++++++++++++++---------------------
 inventory/inventory.h |  28 +-
 inventory/testmain.c  | 238 +++++++-------
 invutil/cmenu.h       |  24 +-
 invutil/fstab.c       |  12 +-
 invutil/invidx.c      |  76 ++---
 invutil/invutil.c     | 246 +++++++-------
 invutil/invutil.h     |   6 +-
 invutil/stobj.c       |  32 +-
 librmt/rmtcommand.c   |   2 +-
 librmt/rmtfstat.c     |   6 +-
 librmt/rmtioctl.c     |  18 +-
 librmt/rmtopen.c      |   4 +-
 librmt/rmtstatus.c    |   8 +-
 librmt/rmtwrite.c     |   2 +-
 27 files changed, 1534 insertions(+), 1534 deletions(-)

diff --git a/include/swab.h b/include/swab.h
index 2684aa7..abfeeb6 100644
--- a/include/swab.h
+++ b/include/swab.h
@@ -7,25 +7,25 @@
 #define ___swab16(x) \
 ({ \
 	__u16 __x = (x); \
-	((__u16)( \
+	((__u16)(\
 		(((__u16)(__x) & (__u16)0x00ffU) << 8) | \
-		(((__u16)(__x) & (__u16)0xff00U) >> 8) )); \
+		(((__u16)(__x) & (__u16)0xff00U) >> 8))); \
 })
 
 #define ___swab32(x) \
 ({ \
 	__u32 __x = (x); \
-	((__u32)( \
+	((__u32)(\
 		(((__u32)(__x) & (__u32)0x000000ffUL) << 24) | \
 		(((__u32)(__x) & (__u32)0x0000ff00UL) <<  8) | \
 		(((__u32)(__x) & (__u32)0x00ff0000UL) >>  8) | \
-		(((__u32)(__x) & (__u32)0xff000000UL) >> 24) )); \
+		(((__u32)(__x) & (__u32)0xff000000UL) >> 24))); \
 })
 
 #define ___swab64(x) \
 ({ \
 	__u64 __x = (x); \
-	((__u64)( \
+	((__u64)(\
 		(__u64)(((__u64)(__x) & (__u64)0x00000000000000ffULL) << 56) | \
 		(__u64)(((__u64)(__x) & (__u64)0x000000000000ff00ULL) << 40) | \
 		(__u64)(((__u64)(__x) & (__u64)0x0000000000ff0000ULL) << 24) | \
@@ -33,21 +33,21 @@
 		(__u64)(((__u64)(__x) & (__u64)0x000000ff00000000ULL) >>  8) | \
 		(__u64)(((__u64)(__x) & (__u64)0x0000ff0000000000ULL) >> 24) | \
 		(__u64)(((__u64)(__x) & (__u64)0x00ff000000000000ULL) >> 40) | \
-		(__u64)(((__u64)(__x) & (__u64)0xff00000000000000ULL) >> 56) )); \
+		(__u64)(((__u64)(__x) & (__u64)0xff00000000000000ULL) >> 56))); \
 })
 
 #define ___constant_swab16(x) \
-	((__u16)( \
+	((__u16)(\
 		(((__u16)(x) & (__u16)0x00ffU) << 8) | \
-		(((__u16)(x) & (__u16)0xff00U) >> 8) ))
+		(((__u16)(x) & (__u16)0xff00U) >> 8)))
 #define ___constant_swab32(x) \
-	((__u32)( \
+	((__u32)(\
 		(((__u32)(x) & (__u32)0x000000ffUL) << 24) | \
 		(((__u32)(x) & (__u32)0x0000ff00UL) <<  8) | \
 		(((__u32)(x) & (__u32)0x00ff0000UL) >>  8) | \
-		(((__u32)(x) & (__u32)0xff000000UL) >> 24) ))
+		(((__u32)(x) & (__u32)0xff000000UL) >> 24)))
 #define ___constant_swab64(x) \
-	((__u64)( \
+	((__u64)(\
 		(__u64)(((__u64)(x) & (__u64)0x00000000000000ffULL) << 56) | \
 		(__u64)(((__u64)(x) & (__u64)0x000000000000ff00ULL) << 40) | \
 		(__u64)(((__u64)(x) & (__u64)0x0000000000ff0000ULL) << 24) | \
@@ -55,7 +55,7 @@
 		(__u64)(((__u64)(x) & (__u64)0x000000ff00000000ULL) >>  8) | \
 		(__u64)(((__u64)(x) & (__u64)0x0000ff0000000000ULL) >> 24) | \
 		(__u64)(((__u64)(x) & (__u64)0x00ff000000000000ULL) >> 40) | \
-		(__u64)(((__u64)(x) & (__u64)0xff00000000000000ULL) >> 56) ))
+		(__u64)(((__u64)(x) & (__u64)0xff00000000000000ULL) >> 56)))
 
 /*
  * provide defaults when no architecture-specific optimization is detected
diff --git a/include/swap.h b/include/swap.h
index fa6aec6..ae575ee 100644
--- a/include/swap.h
+++ b/include/swap.h
@@ -51,11 +51,11 @@
 
 #define INT_SET(ref,arch,valueref) \
 	(__builtin_constant_p(valueref) ? \
-	(void)( (ref) = ( ((arch) != ARCH_NOCONVERT) ? \
-	  		   (INT_SWAP((ref),(valueref))) : (valueref)) ) : \
-	(void)( ((ref) = (valueref)), \
-			( ((arch) != ARCH_NOCONVERT) ? \
-			   (ref) = INT_SWAP((ref),(ref)) : 0 ) ))
+	(void)((ref) = (((arch) != ARCH_NOCONVERT) ? \
+	  		   (INT_SWAP((ref),(valueref))) : (valueref))) : \
+	(void)(((ref) = (valueref)), \
+			(((arch) != ARCH_NOCONVERT) ? \
+			   (ref) = INT_SWAP((ref),(ref)) : 0) ))
 
 #define INT_XLATE(buf,p,dir,arch) \
 	((dir > 0) ? ((p) = INT_GET((buf),(arch))) : INT_SET((buf),(arch),(p)))
diff --git a/inventory/getopt.h b/inventory/getopt.h
index 7bebc6d..4ae23e4 100644
--- a/inventory/getopt.h
+++ b/inventory/getopt.h
@@ -32,7 +32,7 @@
 #define	GETOPT_DUMPDEST		'f'	/* dump dest. file (drive.c) */
 #define	GETOPT_LEVEL		'l'	/* dump level (content_inode.c) */
 #define	GETOPT_SUBTREE		's'	/* subtree dump (content_inode.c) */
-#define	GETOPT_VERBOSITY	'v'	/* verbosity level (0 to 4 ) */
+#define	GETOPT_VERBOSITY	'v'	/* verbosity level (0 to 4) */
 #define	GETOPT_DUMPLABEL	'L'	/* dump session label (global.c) */
 #define	GETOPT_MEDIALABEL	'M'	/* media object label (content.c) */
 #define	GETOPT_RESUME		'R'	/* resume intr dump (content_inode.c) */
diff --git a/inventory/inv_api.c b/inventory/inv_api.c
index eee128e..6473811 100644
--- a/inventory/inv_api.c
+++ b/inventory/inv_api.c
@@ -47,7 +47,7 @@
 /*----------------------------------------------------------------------*/
 
 inv_idbtoken_t
-inv_open( inv_predicate_t bywhat, inv_oflag_t forwhat, void *pred )
+inv_open(inv_predicate_t bywhat, inv_oflag_t forwhat, void *pred)
 {
 	int fd, stobjfd, num, retval;
 	inv_idbtoken_t tok = INV_TOKEN_NULL;
@@ -55,17 +55,17 @@ inv_open( inv_predicate_t bywhat, inv_oflag_t forwhat, void *pred )
 
 	int index = 0;
 
-	assert ( pred );
-	fd = retval = init_idb ( pred, bywhat, forwhat, &tok );
+	assert (pred);
+	fd = retval = init_idb (pred, bywhat, forwhat, &tok);
 
-	if ( retval == I_DONE )
+	if (retval == I_DONE)
 		return tok;
 
 	/* if we just want to search the db, all we need is the invidx.
 	   at this point, we know that a tok wasnt created in init_idb() */
-	if ( forwhat == INV_SEARCH_ONLY ) {
+	if (forwhat == INV_SEARCH_ONLY) {
 		/* fd == I_EMPTYINV or fd == valid fd */
-		tok = get_token( fd, -1);
+		tok = get_token(fd, -1);
 		tok->d_oflag = forwhat;
 		return tok;
 	}
@@ -73,51 +73,51 @@ inv_open( inv_predicate_t bywhat, inv_oflag_t forwhat, void *pred )
 	/* XXX also, see if it is too full. if so, make another and leave a
 	   reference to the new file in the old one */
 
-	stobjfd = idx_get_stobj( fd, forwhat, &index );
-	if ( stobjfd < 0 ) {
-		close( fd );
+	stobjfd = idx_get_stobj(fd, forwhat, &index);
+	if (stobjfd < 0) {
+		close(fd);
 		return INV_TOKEN_NULL;
 	}
 
-	assert ( index > 0 );
+	assert (index > 0);
 
 	/* Now we need to make sure that this has enough space */
-	INVLOCK( stobjfd, LOCK_SH );
+	INVLOCK(stobjfd, LOCK_SH);
 
-	num = GET_SESCOUNTERS( stobjfd, &sescnt );
-	if ( num < 0 ) {
-		close( fd );
-		INVLOCK( stobjfd, LOCK_UN );
-		close( stobjfd );
+	num = GET_SESCOUNTERS(stobjfd, &sescnt);
+	if (num < 0) {
+		close(fd);
+		INVLOCK(stobjfd, LOCK_UN);
+		close(stobjfd);
 		return INV_TOKEN_NULL;
 	}
 
-	/* create another storage object ( and, an inv_index entry for it
-	   too ) if we've filled this one up */
+	/* create another storage object (and, an inv_index entry for it
+	   too) if we've filled this one up */
 
-	if ( (uint) num >= sescnt->ic_maxnum ) {
-		mlog( MLOG_DEBUG | MLOG_INV, "$ INV: creating a new storage obj & "
-		      "index entry. \n" );
-		INVLOCK( stobjfd, LOCK_UN );
+	if ((uint) num >= sescnt->ic_maxnum) {
+		mlog(MLOG_DEBUG | MLOG_INV, "$ INV: creating a new storage obj & "
+		      "index entry. \n");
+		INVLOCK(stobjfd, LOCK_UN);
 		close (stobjfd);
 
-		INVLOCK( fd, LOCK_EX );
-		stobjfd = idx_create_entry( &tok, fd, BOOL_FALSE );
-		INVLOCK( fd, LOCK_UN );
+		INVLOCK(fd, LOCK_EX);
+		stobjfd = idx_create_entry(&tok, fd, BOOL_FALSE);
+		INVLOCK(fd, LOCK_UN);
 
-		free ( sescnt );
-		if ( stobjfd < 0 ) {
-			close( fd );
+		free (sescnt);
+		if (stobjfd < 0) {
+			close(fd);
 			return INV_TOKEN_NULL;
 		}
 		return tok;
 	}
 
-	INVLOCK( stobjfd, LOCK_UN );
+	INVLOCK(stobjfd, LOCK_UN);
 
-	free ( sescnt );
-	tok = get_token( fd, stobjfd );
-	tok->d_invindex_off = IDX_HDR_OFFSET( index - 1 );
+	free (sescnt);
+	tok = get_token(fd, stobjfd);
+	tok->d_invindex_off = IDX_HDR_OFFSET(index - 1);
 	tok->d_oflag = forwhat;
 	return tok;
 
@@ -134,12 +134,12 @@ inv_open( inv_predicate_t bywhat, inv_oflag_t forwhat, void *pred )
 
 
 bool_t
-inv_close( inv_idbtoken_t tok )
+inv_close(inv_idbtoken_t tok)
 {
-	close ( tok->d_invindex_fd );
-	if ( tok->d_stobj_fd >= 0 )
-		close ( tok->d_stobj_fd );
-	destroy_token( tok );
+	close (tok->d_invindex_fd);
+	if (tok->d_stobj_fd >= 0)
+		close (tok->d_stobj_fd);
+	destroy_token(tok);
 	return BOOL_TRUE;
 }
 
@@ -167,7 +167,7 @@ inv_writesession_open(
 	uint		nstreams,
 	time32_t	time,
 	char		*mntpt,
-	char		*devpath )
+	char		*devpath)
 {
 	invt_session_t  ses;
 	int		fd;
@@ -177,17 +177,17 @@ inv_writesession_open(
 	inv_sestoken_t	sestok;
 	inv_oflag_t     forwhat;
 
-	assert ( tok != INV_TOKEN_NULL );
-	assert ( sesid && fsid && mntpt && devpath );
+	assert (tok != INV_TOKEN_NULL);
+	assert (sesid && fsid && mntpt && devpath);
 	forwhat = tok->d_oflag;
 	fd = tok->d_stobj_fd;
-	assert ( forwhat != INV_SEARCH_ONLY );
-	assert ( fd > 0 );
+	assert (forwhat != INV_SEARCH_ONLY);
+	assert (fd > 0);
 
-	if ( ! ( tok->d_update_flag & FSTAB_UPDATED ) ) {
-		if ( fstab_put_entry( fsid, mntpt, devpath, forwhat ) < 0 ) {
-		       mlog( MLOG_NORMAL | MLOG_INV, _(
-				"INV: put_fstab_entry failed.\n") );
+	if (! (tok->d_update_flag & FSTAB_UPDATED) ) {
+		if (fstab_put_entry(fsid, mntpt, devpath, forwhat) < 0) {
+		       mlog(MLOG_NORMAL | MLOG_INV, _(
+				"INV: put_fstab_entry failed.\n"));
 		       return INV_TOKEN_NULL;
 		}
 		tok->d_update_flag |= FSTAB_UPDATED;
@@ -195,12 +195,12 @@ inv_writesession_open(
 
 
 	/* copy the session information to store */
-	memset( (void *)&ses, 0, sizeof( ses ) );	/* paranoia */
-	memcpy( &ses.s_sesid, sesid, sizeof( uuid_t ) );
-	memcpy( &ses.s_fsid, fsid, sizeof( uuid_t ) );
-	strcpy( ses.s_label, label );
-	strcpy( ses.s_mountpt, mntpt );
-	strcpy( ses.s_devpath, devpath );
+	memset((void *)&ses, 0, sizeof(ses) );	/* paranoia */
+	memcpy(&ses.s_sesid, sesid, sizeof(uuid_t) );
+	memcpy(&ses.s_fsid, fsid, sizeof(uuid_t) );
+	strcpy(ses.s_label, label);
+	strcpy(ses.s_mountpt, mntpt);
+	strcpy(ses.s_devpath, devpath);
 	ses.s_max_nstreams = nstreams;
 
         hdr.sh_pruned = 0; /* session is not pruned by invutil */
@@ -210,41 +210,41 @@ inv_writesession_open(
 	hdr.sh_flag |= (isresumed) ? INVT_RESUMED : 0;
 	/* sh_streams_off and sh_sess_off will be set in create_session() */
 
-	sestok = get_sesstoken( tok );
+	sestok = get_sesstoken(tok);
 
 	/* we need to put the new session in the appropriate place in
 	   storage object. So first find out howmany sessions are there */
 
-	INVLOCK( fd, LOCK_EX );
-	if ( GET_SESCOUNTERS( fd, &sescnt) < 0 ) {
-		free ( sestok );
-		INVLOCK( fd, LOCK_UN );
+	INVLOCK(fd, LOCK_EX);
+	if (GET_SESCOUNTERS(fd, &sescnt) < 0) {
+		free (sestok);
+		INVLOCK(fd, LOCK_UN);
 		return INV_TOKEN_NULL;
 	}
 
 	/* create the writesession, and get ready for the streams to come
 	   afterwards */
-	rval = stobj_create_session( sestok, fd, sescnt, &ses, &hdr );
+	rval = stobj_create_session(sestok, fd, sescnt, &ses, &hdr);
 	assert (rval > 0);
 
 
-	INVLOCK( fd, LOCK_UN );
+	INVLOCK(fd, LOCK_UN);
 
 	sestok->sd_sesstime = time;
 
-	if ( tok->d_update_flag & NEW_INVINDEX ) {
-		if ( idx_put_sesstime( sestok, INVT_STARTTIME ) < 0 ) {
-			mlog( MLOG_NORMAL | MLOG_INV, _(
-				"INV: put_starttime failed.\n") );
+	if (tok->d_update_flag & NEW_INVINDEX) {
+		if (idx_put_sesstime(sestok, INVT_STARTTIME) < 0) {
+			mlog(MLOG_NORMAL | MLOG_INV, _(
+				"INV: put_starttime failed.\n"));
 			return INV_TOKEN_NULL;
 		}
 		tok->d_update_flag &= ~(NEW_INVINDEX);
 	}
 
-	free ( sescnt );
+	free (sescnt);
 
 
-	return ( rval < 0 )? INV_TOKEN_NULL: sestok;
+	return (rval < 0)? INV_TOKEN_NULL: sestok;
 }
 
 
@@ -259,19 +259,19 @@ inv_writesession_open(
 
 
 bool_t
-inv_writesession_close( inv_sestoken_t tok )
+inv_writesession_close(inv_sestoken_t tok)
 {
 	int		rval;
 
-	assert ( tok != INV_TOKEN_NULL );
+	assert (tok != INV_TOKEN_NULL);
 
 	/* now update end_time in the inv index header */
-	rval = idx_put_sesstime( tok, INVT_ENDTIME );
+	rval = idx_put_sesstime(tok, INVT_ENDTIME);
 
-	memset( tok, 0, sizeof( invt_sesdesc_entry_t ) );
-	free ( tok );
+	memset(tok, 0, sizeof(invt_sesdesc_entry_t) );
+	free (tok);
 
-	return ( rval < 0 ) ? BOOL_FALSE: BOOL_TRUE;
+	return (rval < 0) ? BOOL_FALSE: BOOL_TRUE;
 
 }
 
@@ -285,7 +285,7 @@ inv_writesession_close( inv_sestoken_t tok )
 inv_stmtoken_t
 inv_stream_open(
 	inv_sestoken_t tok,
-	char		*cmdarg )
+	char		*cmdarg)
 {
 	inv_stmtoken_t stok;
 	invt_stream_t  stream;
@@ -294,21 +294,21 @@ inv_stream_open(
 	int fd;
 	bool_t err = BOOL_FALSE;
 
-	assert ( tok != INV_TOKEN_NULL );
+	assert (tok != INV_TOKEN_NULL);
 
 	/* this memset is needed as a dump interrupted/crashed very soon
 	 * after starting results in an inventory with exteremely large
 	 * starting/ending inodes or offsets. This can be misleading.
 	 * See bug #463702 for an example.
 	 */
-	memset( (void *)&stream, 0 , sizeof(invt_stream_t) );
+	memset((void *)&stream, 0 , sizeof(invt_stream_t));
 
 	stream.st_nmediafiles = 0;
 	stream.st_interrupted = BOOL_TRUE; /* fix for 353197 */
-	strcpy( stream.st_cmdarg, cmdarg );
+	strcpy(stream.st_cmdarg, cmdarg);
 
 	/* XXX yukk... make the token descriptors not pointers */
-	stok = ( inv_stmtoken_t ) malloc( sizeof( invt_strdesc_entry_t ) );
+	stok = (inv_stmtoken_t) malloc(sizeof(invt_strdesc_entry_t) );
 
 	stok->md_sesstok = tok;
 	stok->md_lastmfile = 0;
@@ -316,46 +316,46 @@ inv_stream_open(
 	/* get the session to find out where the stream is going to go */
 	fd = tok->sd_invtok->d_stobj_fd;
 
-	INVLOCK( fd, LOCK_EX );
+	INVLOCK(fd, LOCK_EX);
 
 	/* get the session header and the session */
-	if ( stobj_get_sessinfo( tok, &seshdr, &ses ) <= 0 )
+	if (stobj_get_sessinfo(tok, &seshdr, &ses) <= 0)
 		err = BOOL_TRUE;
 
-	if ( ( ! err )  && ses.s_cur_nstreams < ses.s_max_nstreams ) {
+	if ((! err)  && ses.s_cur_nstreams < ses.s_max_nstreams) {
 		/* this is where this stream header will be written to */
-		stok->md_stream_off = (off64_t) (sizeof( invt_stream_t ) *
-					         ses.s_cur_nstreams )
+		stok->md_stream_off = (off64_t) (sizeof(invt_stream_t) *
+					         ses.s_cur_nstreams)
 			                         + seshdr.sh_streams_off;
 		ses.s_cur_nstreams++;
 
 		/* write it back. */
-		if ( PUT_REC_NOLOCK( fd, &ses, sizeof( ses ),
-				     tok->sd_session_off ) < 0 )
+		if (PUT_REC_NOLOCK(fd, &ses, sizeof(ses),
+				     tok->sd_session_off) < 0)
 			err = BOOL_TRUE;
-	} else if ( ! err ) {
-		mlog ( MLOG_NORMAL, _(
+	} else if (! err) {
+		mlog (MLOG_NORMAL, _(
 		       "INV: cant create more than %d streams."
-		       " Max'd out..\n"), ses.s_cur_nstreams );
+		       " Max'd out..\n"), ses.s_cur_nstreams);
 		err = BOOL_TRUE;
 	}
 
-	if ( ! err ) {
+	if (! err) {
 		stream.st_firstmfile = stream.st_lastmfile =
 			               stok->md_stream_off;
 
 		/* now write the stream header on to the disk */
-		if ( PUT_REC_NOLOCK( fd, &stream, sizeof( invt_stream_t ),
-				    stok->md_stream_off ) > 0 ) {
+		if (PUT_REC_NOLOCK(fd, &stream, sizeof(invt_stream_t),
+				    stok->md_stream_off) > 0) {
 			/* we're all set */
-			INVLOCK( fd, LOCK_UN );
+			INVLOCK(fd, LOCK_UN);
 			return stok;
 		}
 	}
 
 	/* error occured somewhere */
-	free ( stok );
-	INVLOCK( fd, LOCK_UN );
+	free (stok);
+	INVLOCK(fd, LOCK_UN);
 	return INV_TOKEN_NULL;
 
 }
@@ -372,36 +372,36 @@ inv_stream_open(
 bool_t
 inv_stream_close(
 		inv_stmtoken_t	tok,
-		bool_t wasinterrupted )
+		bool_t wasinterrupted)
 {
 	invt_stream_t strm;
 	int fd = tok->md_sesstok->sd_invtok->d_stobj_fd;
 	int rval;
 	bool_t dowrite = BOOL_FALSE;
 
-	rval = idx_put_sesstime( tok->md_sesstok, INVT_ENDTIME );
+	rval = idx_put_sesstime(tok->md_sesstok, INVT_ENDTIME);
 	if (rval < 0)
-		mlog( MLOG_NORMAL | MLOG_INV, _(
+		mlog(MLOG_NORMAL | MLOG_INV, _(
 		      "INV: idx_put_sesstime failed in "
-		      "inv_stream_close() \n") );
-	INVLOCK( fd, LOCK_EX );
-	if ((rval = GET_REC_NOLOCK( fd, &strm, sizeof( invt_stream_t ),
-			       tok->md_stream_off )) > 0 ) {
+		      "inv_stream_close() \n"));
+	INVLOCK(fd, LOCK_EX);
+	if ((rval = GET_REC_NOLOCK(fd, &strm, sizeof(invt_stream_t),
+			       tok->md_stream_off)) > 0) {
 
-		if ( strm.st_interrupted != wasinterrupted ) {
+		if (strm.st_interrupted != wasinterrupted) {
 			strm.st_interrupted = wasinterrupted;
 			dowrite = BOOL_TRUE;
 		}
 
 		/* get the last media file to figure out what our last
 		   ino was. we have a pointer to that in the stream token */
-		if ( tok->md_lastmfile ){
-			if ( strm.st_endino.ino !=
+		if (tok->md_lastmfile){
+			if (strm.st_endino.ino !=
 			      tok->md_lastmfile->mf_endino.ino ||
 			     strm.st_endino.offset !=
 			      tok->md_lastmfile->mf_endino.offset) {
 
-			      mlog( MLOG_DEBUG | MLOG_INV, "INV: stream_close() "
+			      mlog(MLOG_DEBUG | MLOG_INV, "INV: stream_close() "
 				    " - endinos dont match ! \n");
 			      dowrite = BOOL_TRUE;
 			      strm.st_endino = tok->md_lastmfile->mf_endino;
@@ -414,15 +414,15 @@ inv_stream_close(
 		}
 	}
 
-	INVLOCK( fd, LOCK_UN );
+	INVLOCK(fd, LOCK_UN);
 
-	if ( tok->md_lastmfile ) {
-		free ( tok->md_lastmfile );
+	if (tok->md_lastmfile) {
+		free (tok->md_lastmfile);
 	}
-	memset( tok, 0, sizeof( invt_strdesc_entry_t ) );
-	free ( tok );
+	memset(tok, 0, sizeof(invt_strdesc_entry_t) );
+	free (tok);
 
-	return ( rval < 0 ) ? BOOL_FALSE: BOOL_TRUE;
+	return (rval < 0) ? BOOL_FALSE: BOOL_TRUE;
 }
 
 
@@ -452,15 +452,15 @@ inv_put_mediafile(
 	int 		 rval;
 
 
-	assert ( tok != INV_TOKEN_NULL );
-	assert ( tok->md_sesstok->sd_invtok->d_update_flag & FSTAB_UPDATED );
-	assert ( tok->md_sesstok->sd_invtok->d_stobj_fd >= 0 );
+	assert (tok != INV_TOKEN_NULL);
+	assert (tok->md_sesstok->sd_invtok->d_update_flag & FSTAB_UPDATED);
+	assert (tok->md_sesstok->sd_invtok->d_stobj_fd >= 0);
 
-	mf = (invt_mediafile_t *) calloc( 1, sizeof( invt_mediafile_t ) );
+	mf = (invt_mediafile_t *) calloc(1, sizeof(invt_mediafile_t) );
 
 	/* copy the media file information */
-	memcpy( &mf->mf_moid, moid, sizeof( uuid_t ) );
-	strcpy( mf->mf_label, label );
+	memcpy(&mf->mf_moid, moid, sizeof(uuid_t) );
+	strcpy(mf->mf_label, label);
 	mf->mf_mfileidx = mfileindex;
 	mf->mf_startino.ino = startino;
 	mf->mf_startino.offset = startino_offset;
@@ -468,25 +468,25 @@ inv_put_mediafile(
 	mf->mf_endino.offset = endino_offset;
 	mf->mf_size = size;
 	mf->mf_flag = 0;
-	if ( isgood )
+	if (isgood)
 		mf->mf_flag |= INVT_MFILE_GOOD;
 
 	/* This flag is used to indicate the media file that contains the
 	   dump of the sessioninfo structure that contains all but this
 	   media file */
-	if ( isinvdump )
+	if (isinvdump)
 		mf->mf_flag |= INVT_MFILE_INVDUMP;
 
-	INVLOCK( tok->md_sesstok->sd_invtok->d_stobj_fd, LOCK_EX );
-	rval = stobj_put_mediafile( tok, mf );
-	INVLOCK( tok->md_sesstok->sd_invtok->d_stobj_fd, LOCK_UN );
+	INVLOCK(tok->md_sesstok->sd_invtok->d_stobj_fd, LOCK_EX);
+	rval = stobj_put_mediafile(tok, mf);
+	INVLOCK(tok->md_sesstok->sd_invtok->d_stobj_fd, LOCK_UN);
 
 	/* we dont free the mfile here. we always keep the last mfile
 	   around, inside the inv_stmtoken, and when we add a new mfile,
 	   we free the previous one. The last one is freed in stream_close()
 	   */
 
-	return ( rval < 0 ) ? BOOL_FALSE: BOOL_TRUE;
+	return (rval < 0) ? BOOL_FALSE: BOOL_TRUE;
 
 }
 
@@ -510,7 +510,7 @@ bool_t
 inv_get_sessioninfo(
 	inv_sestoken_t		tok,
 	void		      **bufpp,	/* buf to fill */
-	size_t		       *bufszp )/* size of that buffer */
+	size_t		       *bufszp)/* size of that buffer */
 {
 	invt_session_t 	ses;
 	invt_seshdr_t	hdr;
@@ -518,23 +518,23 @@ inv_get_sessioninfo(
 	int		fd;
 
 
-	assert( tok != INV_TOKEN_NULL );
-	assert( tok->sd_invtok );
+	assert(tok != INV_TOKEN_NULL);
+	assert(tok->sd_invtok);
 	*bufpp = NULL;
 	*bufszp = 0;
 	fd = tok->sd_invtok->d_stobj_fd;
 
-	INVLOCK( fd, LOCK_SH );
+	INVLOCK(fd, LOCK_SH);
 
 	/* Next we get the session header, and the session information. Then
 	   we can figure out how much space to allocate */
-	if ( stobj_get_sessinfo( tok, &hdr, &ses ) <= 0 ) {
-		INVLOCK( fd, LOCK_UN );
+	if (stobj_get_sessinfo(tok, &hdr, &ses) <= 0) {
+		INVLOCK(fd, LOCK_UN);
 		return BOOL_FALSE;
 	}
 
-	rval = stobj_pack_sessinfo( fd, &ses, &hdr, bufpp, bufszp );
-	INVLOCK( fd, LOCK_UN );
+	rval = stobj_pack_sessinfo(fd, &ses, &hdr, bufpp, bufszp);
+	INVLOCK(fd, LOCK_UN);
 
 
 	return rval;
@@ -555,18 +555,18 @@ inv_get_sessioninfo(
 /*----------------------------------------------------------------------*/
 
 bool_t
-inv_put_sessioninfo( invt_sessinfo_t *s )
+inv_put_sessioninfo(invt_sessinfo_t *s)
 {
 	static bool_t invdir_ok = BOOL_FALSE;
 
-	if ( !invdir_ok ) {
-		if ( make_invdirectory( INV_SEARCH_N_MOD ) < 0 )
+	if (!invdir_ok) {
+		if (make_invdirectory(INV_SEARCH_N_MOD) < 0)
 			return BOOL_FALSE;
 		else
 			invdir_ok = BOOL_TRUE;
 	}
 
-      	return insert_session( s );
+      	return insert_session(s);
 
 }
 
@@ -588,7 +588,7 @@ inv_free_session(
 	assert(ses);
 	assert(*ses);
 
-	for ( i = 0; i < (*ses)->s_nstreams; i++ ) {
+	for (i = 0; i < (*ses)->s_nstreams; i++) {
 		/* the array of mediafiles is contiguous */
 		free ((*ses)->s_streams[i].st_mediafiles);
 	}
@@ -619,12 +619,12 @@ inv_lasttime_level_lessthan(
 	time32_t	**tm)
 {
 	int 	rval;
-	if ( tok != INV_TOKEN_NULL ) {
+	if (tok != INV_TOKEN_NULL) {
 		rval =  search_invt(fsidp, tok->d_invindex_fd, &level,
 				    (void **)tm,
 				    (search_callback_t)tm_level_lessthan);
 
-		return ( rval < 0) ? BOOL_FALSE: BOOL_TRUE;
+		return (rval < 0) ? BOOL_FALSE: BOOL_TRUE;
 	}
 
 	return invmgr_query_all_sessions(fsidp,		 /* fs uuid ptr */
@@ -652,12 +652,12 @@ inv_lastsession_level_lessthan(
 	inv_session_t	**ses)
 {
 	int 	rval;
-	if ( tok != INV_TOKEN_NULL ) {
+	if (tok != INV_TOKEN_NULL) {
 		rval = search_invt(fsidp, tok->d_invindex_fd, &level,
 				   (void **)ses,
 				   (search_callback_t)lastsess_level_lessthan);
 
-		return ( rval < 0) ? BOOL_FALSE: BOOL_TRUE;
+		return (rval < 0) ? BOOL_FALSE: BOOL_TRUE;
 	}
 
 	return invmgr_query_all_sessions(fsidp,		 /* fs uuid */
@@ -684,15 +684,15 @@ inv_lastsession_level_equalto(
 	uuid_t		*fsidp,
 	inv_idbtoken_t	tok,
 	u_char		level,
-	inv_session_t	**ses )
+	inv_session_t	**ses)
 {
 	int 	rval;
-	if ( tok != INV_TOKEN_NULL ) {
+	if (tok != INV_TOKEN_NULL) {
 		rval = search_invt(fsidp, tok->d_invindex_fd, &level,
 				   (void **)ses,
 				   (search_callback_t)lastsess_level_equalto);
 
-		return ( rval < 0) ? BOOL_FALSE: BOOL_TRUE;
+		return (rval < 0) ? BOOL_FALSE: BOOL_TRUE;
 	}
 
 	return invmgr_query_all_sessions(fsidp,		 /* fs uuid */
@@ -758,7 +758,7 @@ inv_get_session_bylabel(
 /*----------------------------------------------------------------------*/
 
 bool_t
-inv_delete_mediaobj( uuid_t *moid )
+inv_delete_mediaobj(uuid_t *moid)
 {
 	inv_oflag_t forwhat = INV_SEARCH_N_MOD;
 
@@ -771,8 +771,8 @@ inv_delete_mediaobj( uuid_t *moid )
 		         forall mediafiles (m) in strm {
 			     if (m.mediaobj == moid) {
 			     // delete m
-			     if ( --strm.nmediafiles == 0 )
-			        if ( --s.nstreams == 0 )
+			     if (--strm.nmediafiles == 0)
+			        if (--s.nstreams == 0)
 			            delete-session (s)
 			     }
 			 }
@@ -786,40 +786,40 @@ inv_delete_mediaobj( uuid_t *moid )
 	int numfs, i, fd, invfd;
 	char fname[INV_STRLEN];
 
-	fd = fstab_getall( &arr, &cnt, &numfs, forwhat );
-	if ( fd < 0 || numfs <= 0 ) {
-		mlog( MLOG_NORMAL | MLOG_INV, _("INV: Error in fstab\n") );
+	fd = fstab_getall(&arr, &cnt, &numfs, forwhat);
+	if (fd < 0 || numfs <= 0) {
+		mlog(MLOG_NORMAL | MLOG_INV, _("INV: Error in fstab\n"));
 		return BOOL_FALSE;
 	}
 
-	close( fd );
+	close(fd);
 
-	for ( i = 0; i < numfs; i++) {
-		if ( fstab_get_fname( &arr[i].ft_uuid,
+	for (i = 0; i < numfs; i++) {
+		if (fstab_get_fname(&arr[i].ft_uuid,
 				      fname,
 				      (inv_predicate_t)INV_BY_UUID,
 				      forwhat
 				     )
-		     < 0 ) {
-			mlog( MLOG_NORMAL | MLOG_INV, _(
-			      "INV: Cant get inv-name for uuid\n") );
+		     < 0) {
+			mlog(MLOG_NORMAL | MLOG_INV, _(
+			      "INV: Cant get inv-name for uuid\n"));
 			return BOOL_FALSE;
 		}
-		strcat( fname, INV_INVINDEX_PREFIX );
-		invfd = open( fname, INV_OFLAG(forwhat));
-		if ( invfd < 0 ) {
-			mlog( MLOG_NORMAL | MLOG_INV, _(
+		strcat(fname, INV_INVINDEX_PREFIX);
+		invfd = open(fname, INV_OFLAG(forwhat));
+		if (invfd < 0) {
+			mlog(MLOG_NORMAL | MLOG_INV, _(
 			     "INV: Open failed on %s\n"),
-			     fname );
+			     fname);
 			return BOOL_FALSE;
 		}
 
 		if (search_invt(&arr[i].ft_uuid, invfd, NULL, (void **)&moid,
 				(search_callback_t)stobj_delete_mobj)
-		    < 0 )
+		    < 0)
 			return BOOL_FALSE;
 		/* we have to delete the session, etc */
-		close( invfd );
+		close(invfd);
 	}
 
 	return BOOL_TRUE;
@@ -899,8 +899,8 @@ inv_getopt(int argc, char **argv, invt_pr_ctx_t *prctx)
 		rptr = wptr + 1;
 		while (*wptr != '\0')
 			*wptr++ = *rptr++;
-		while ( ( c = getopt( argc, argv, invoptstring)) != EOF ) {
-			switch ( c ) {
+		while ((c = getopt(argc, argv, invoptstring)) != EOF) {
+			switch (c) {
 			case GETOPT_INVPRINT:
 				prctx->depth = 0;
 				rval |= I_IFOUND ;
@@ -912,8 +912,8 @@ inv_getopt(int argc, char **argv, invt_pr_ctx_t *prctx)
 		optarg = NULL;
 	}
 
-	while ( ( c = getopt( argc, argv, GETOPT_CMDSTRING )) != EOF ) {
-		switch ( c ) {
+	while ((c = getopt(argc, argv, GETOPT_CMDSTRING)) != EOF) {
+		switch (c) {
 		case GETOPT_INVPRINT:
 			rval |= I_IFOUND ;
 			if ((options = optarg) == NULL)
@@ -924,7 +924,7 @@ inv_getopt(int argc, char **argv, invt_pr_ctx_t *prctx)
 				if (value == NULL && d != OPT_FSTAB &&
 				     d != OPT_INVIDX && d != OPT_INVCHECK)
 					continue;
-				switch( d ) {
+				switch(d) {
 					/* process mntpt option */
 				      case OPT_MNT:
 					bywhat = (inv_predicate_t) INV_BY_MOUNTPT;
@@ -950,14 +950,14 @@ inv_getopt(int argc, char **argv, invt_pr_ctx_t *prctx)
 				      case OPT_DEPTH:
 					prctx->depth = atoi(value);
 					if (prctx->depth < 0 ||
-					    prctx->depth > 4 )
+					    prctx->depth > 4)
 						prctx->depth = 0;
 					break;
 
 				      case OPT_MOBJID:
 					{
 					uuid_t *u;
-					u = malloc ( sizeof( uuid_t ) );
+					u = malloc (sizeof(uuid_t) );
 					uuid_parse(value, *u);
 					prctx->mobj.type = INVT_MOID;
 					prctx->mobj.value = (void *)u;
@@ -988,13 +988,13 @@ inv_getopt(int argc, char **argv, invt_pr_ctx_t *prctx)
 					break;
 
 				      default:
-					if ( strlen(value) == 1 &&
-					     atoi(value) < PR_MAXDEPTH )
+					if (strlen(value) == 1 &&
+					     atoi(value) < PR_MAXDEPTH)
 						prctx->depth = atoi(value);
 					else {
-						mlog( MLOG_NORMAL | MLOG_INV, _(
+						mlog(MLOG_NORMAL | MLOG_INV, _(
 					       "INV: invalid sub-option %s"
-					       " for -I option\n"), value );
+					       " for -I option\n"), value);
 						rval |= I_IERR;
 					}
 					break;
@@ -1006,18 +1006,18 @@ inv_getopt(int argc, char **argv, invt_pr_ctx_t *prctx)
 	}
 
 	if (npreds > 1) {
-		mlog( MLOG_NORMAL | MLOG_INV, _(
+		mlog(MLOG_NORMAL | MLOG_INV, _(
 		     "INV: Only one of mnt=,dev= and fsid=value can be used.\n")
 		     );
 		rval |= I_IERR;
 	}
 	else if (npreds2 > 1) {
-		mlog( MLOG_NORMAL | MLOG_INV, _(
+		mlog(MLOG_NORMAL | MLOG_INV, _(
 		     "INV: Only one of mobjid= and mobjlabel= can be used.\n")
 		     );
 		rval |= I_IERR;
 	}
-	else if ( (rval & I_IFOUND) && !(rval & I_IERR) && fs
+	else if ((rval & I_IFOUND) && !(rval & I_IERR) && fs
 		 && ! prctx->fstab && ! prctx->invcheck) {
 		inv_idbtoken_t tok;
 
@@ -1032,33 +1032,33 @@ inv_getopt(int argc, char **argv, invt_pr_ctx_t *prctx)
 			invt_counter_t *cnt = NULL;
 			inv_oflag_t forwhat = INV_SEARCH_ONLY;
 
-			fd = fstab_getall( &arr, &cnt, &numfs, forwhat );
-			free( cnt );
+			fd = fstab_getall(&arr, &cnt, &numfs, forwhat);
+			free(cnt);
 
 			rval |= I_IERR; /* Cleared if successful */
 
-			if ( fd >= 0 ) {
-				for ( i = 0; i < numfs; i++ ) {
+			if (fd >= 0) {
+				for (i = 0; i < numfs; i++) {
 					tok = inv_open(
-						(inv_predicate_t )INV_BY_UUID,
+						(inv_predicate_t)INV_BY_UUID,
 						INV_SEARCH_ONLY,
-						&arr[i].ft_uuid );
-					if ( tok == INV_TOKEN_NULL )
+						&arr[i].ft_uuid);
+					if (tok == INV_TOKEN_NULL)
 						break;
-					if ( STREQL( arr[i].ft_mountpt, fs) ) {
+					if (STREQL(arr[i].ft_mountpt, fs)) {
 						prctx->index = i;
 						invmgr_inv_print(
 						          tok->d_invindex_fd,
-							  prctx );
+							  prctx);
 						rval &= ~(I_IERR);
 					}
-					inv_close( tok );
+					inv_close(tok);
 				}
-				free ( arr );
+				free (arr);
 				rval |= I_IDONE;
 			}
-			if ( (rval&I_IERR) ) {
-				mlog( MLOG_NORMAL | MLOG_INV, _(
+			if ((rval&I_IERR)) {
+				mlog(MLOG_NORMAL | MLOG_INV, _(
 				    "INV: open failed on mount point \"%s\"\n"),
 				     fs);
 			}
@@ -1066,14 +1066,14 @@ inv_getopt(int argc, char **argv, invt_pr_ctx_t *prctx)
 		}
 
 		/* We have to print only one file system to print by UUID */
-		tok = inv_open( bywhat, INV_SEARCH_ONLY, fs);
-		if ( tok != INV_TOKEN_NULL ) {
+		tok = inv_open(bywhat, INV_SEARCH_ONLY, fs);
+		if (tok != INV_TOKEN_NULL) {
 			prctx->index = 0;
 			invmgr_inv_print(tok->d_invindex_fd, prctx);
-			inv_close( tok );
+			inv_close(tok);
 			rval |= I_IDONE;
 		} else {
-			mlog( MLOG_NORMAL | MLOG_INV, _(
+			mlog(MLOG_NORMAL | MLOG_INV, _(
 			     "INV: open failed on file system id \"%s\"\n"),
 			     fs);
 			rval |= I_IERR;
@@ -1085,7 +1085,7 @@ inv_getopt(int argc, char **argv, invt_pr_ctx_t *prctx)
 
 /* This prints out all the sessions of a filesystem that are in the inventory */
 bool_t
-inv_DEBUG_print( int argc, char **argv )
+inv_DEBUG_print(int argc, char **argv)
 {
 	invt_counter_t *cnt = NULL;
 	invt_fstab_t *arr = NULL;
@@ -1099,37 +1099,37 @@ inv_DEBUG_print( int argc, char **argv )
 	prctx.level = PR_MAXLEVEL;
 
 	/* If user didnt indicate -i option, we can't do anything */
-	rval = inv_getopt( argc, argv, &prctx );
+	rval = inv_getopt(argc, argv, &prctx);
 
 	if (!prctx.invcheck && ! prctx.fstab) {
 		if (! (rval & I_IFOUND)) {
 			return BOOL_TRUE;
-		} else if ( rval & I_IERR || rval & I_IDONE ) {
+		} else if (rval & I_IERR || rval & I_IDONE) {
 			return BOOL_FALSE;
 		}
 	}
 
-	fd = fstab_getall( &arr, &cnt, &numfs, forwhat );
-	free( cnt );
+	fd = fstab_getall(&arr, &cnt, &numfs, forwhat);
+	free(cnt);
 
-	if ( fd >= 0 ) {
+	if (fd >= 0) {
 		 if (prctx.fstab) {
-			 fstab_DEBUG_print( arr, numfs );
+			 fstab_DEBUG_print(arr, numfs);
 			 if (! prctx.invidx)
 				 return BOOL_FALSE;
 		 }
 
-		for ( i = 0; i < numfs; i++ ) {
-			tok = inv_open( ( inv_predicate_t )INV_BY_UUID,
+		for (i = 0; i < numfs; i++) {
+			tok = inv_open((inv_predicate_t)INV_BY_UUID,
 					forwhat,
-				        &arr[i].ft_uuid );
-			if ( tok == INV_TOKEN_NULL ) {
-				free ( arr );
+				        &arr[i].ft_uuid);
+			if (tok == INV_TOKEN_NULL) {
+				free (arr);
 				return BOOL_FALSE;
 			}
 
 			if (prctx.invcheck) {
-				mlog( MLOG_VERBOSE | MLOG_INV, _(
+				mlog(MLOG_VERBOSE | MLOG_INV, _(
 				     "INV: checking fs \"%s\"\n"),
 				     &arr[i].ft_mountpt
 				     );
@@ -1137,10 +1137,10 @@ inv_DEBUG_print( int argc, char **argv )
 			}
 			else {
 				prctx.index = i;
-				invmgr_inv_print( tok->d_invindex_fd,
-						 &prctx );
+				invmgr_inv_print(tok->d_invindex_fd,
+						 &prctx);
 			}
-			inv_close( tok );
+			inv_close(tok);
 		}
 	}
 
diff --git a/inventory/inv_core.c b/inventory/inv_core.c
index f9866a5..006b41b 100644
--- a/inventory/inv_core.c
+++ b/inventory/inv_core.c
@@ -46,30 +46,30 @@
 /*----------------------------------------------------------------------*/
 
 int
-get_counters( int fd, void **cntpp, size_t cntsz )
+get_counters(int fd, void **cntpp, size_t cntsz)
 {
 	/* object must be locked at least SHARED by caller */
 	uint num;
-	assert( cntsz >= sizeof( invt_counter_t ) );
+	assert(cntsz >= sizeof(invt_counter_t) );
 
-	*cntpp =  calloc( 1, cntsz);
+	*cntpp =  calloc(1, cntsz);
 
 	/* find the number of sessions and the max possible */
-	if ( GET_REC_NOLOCK( fd, (void *) *cntpp, cntsz, (off64_t) 0 ) < 0 ) {
-		free( *cntpp );
+	if (GET_REC_NOLOCK(fd, (void *) *cntpp, cntsz, (off64_t) 0) < 0) {
+		free(*cntpp);
 		*cntpp = NULL;
 		return -1;
 	}
 
 	num = ((invt_counter_t *)(*cntpp))->ic_curnum;
 
-	if ( ( (invt_counter_t *)(*cntpp))->ic_vernum != INV_VERSION ) {
-		mlog( MLOG_NORMAL | MLOG_INV, _(
+	if (((invt_counter_t *)(*cntpp))->ic_vernum != INV_VERSION) {
+		mlog(MLOG_NORMAL | MLOG_INV, _(
 		      "INV : Unknown version %d - Expected version %d\n"),
-		      (int) ( (invt_counter_t *)(*cntpp))->ic_vernum,
-		      (int) INV_VERSION );
-		assert ( ((invt_counter_t *)(*cntpp))->ic_vernum ==
-			INV_VERSION );
+		      (int) ((invt_counter_t *)(*cntpp))->ic_vernum,
+		      (int) INV_VERSION);
+		assert (((invt_counter_t *)(*cntpp))->ic_vernum ==
+			INV_VERSION);
 	}
 
 	return (int) num;
@@ -84,19 +84,19 @@ get_counters( int fd, void **cntpp, size_t cntsz )
 /*----------------------------------------------------------------------*/
 
 int
-get_headers( int fd, void **hdrs, size_t bufsz, size_t off )
+get_headers(int fd, void **hdrs, size_t bufsz, size_t off)
 {
 
-	*hdrs = malloc( bufsz );
-	if ( *hdrs == NULL ) {
-		INV_PERROR( _("get_headers() - malloc(seshdrs)\n") );
+	*hdrs = malloc(bufsz);
+	if (*hdrs == NULL) {
+		INV_PERROR(_("get_headers() - malloc(seshdrs)\n"));
 		return -1;
 	}
 	/* file must be locked at least SHARED by caller */
 
 	/* get the array of hdrs */
-	if ( GET_REC_NOLOCK( fd, (void *) *hdrs, bufsz, (off64_t)off ) < 0 ) {
-		free ( *hdrs );
+	if (GET_REC_NOLOCK(fd, (void *) *hdrs, bufsz, (off64_t)off) < 0) {
+		free (*hdrs);
 		*hdrs = NULL;
 		return -1;
 	}
@@ -111,26 +111,26 @@ get_headers( int fd, void **hdrs, size_t bufsz, size_t off )
 /*----------------------------------------------------------------------*/
 
 int
-get_invtrecord( int fd, void *buf, size_t bufsz, off64_t off,
-		bool_t dolock )
+get_invtrecord(int fd, void *buf, size_t bufsz, off64_t off,
+		bool_t dolock)
 {
 	int  nread;
 
-	assert ( fd >= 0 );
+	assert (fd >= 0);
 
-	if ( dolock )
-		INVLOCK( fd, LOCK_SH );
+	if (dolock)
+		INVLOCK(fd, LOCK_SH);
 
 	nread = pread(fd, buf, bufsz, (off_t)off);
-	if (  nread != (int) bufsz ) {
-		INV_PERROR( _("Error in reading inventory record :") );
-		if ( dolock )
-			INVLOCK( fd, LOCK_UN );
+	if (nread != (int) bufsz) {
+		INV_PERROR(_("Error in reading inventory record :"));
+		if (dolock)
+			INVLOCK(fd, LOCK_UN);
 		return -1;
 	}
 
-	if ( dolock )
-		INVLOCK( fd, LOCK_UN );
+	if (dolock)
+		INVLOCK(fd, LOCK_UN);
 
 	return nread;
 }
@@ -145,23 +145,23 @@ get_invtrecord( int fd, void *buf, size_t bufsz, off64_t off,
 /*----------------------------------------------------------------------*/
 
 int
-put_invtrecord( int fd, void *buf, size_t bufsz, off64_t off, bool_t dolock )
+put_invtrecord(int fd, void *buf, size_t bufsz, off64_t off, bool_t dolock)
 {
 	int nwritten;
 
-	if ( dolock )
-		INVLOCK( fd, LOCK_EX );
+	if (dolock)
+		INVLOCK(fd, LOCK_EX);
 
 	nwritten = pwrite(fd, buf, bufsz, (off_t)off);
-	if (nwritten != (int) bufsz ) {
-		INV_PERROR( _("Error in writing inventory record :") );
-		if ( dolock )
-			INVLOCK( fd, LOCK_UN );
+	if (nwritten != (int) bufsz) {
+		INV_PERROR(_("Error in writing inventory record :"));
+		if (dolock)
+			INVLOCK(fd, LOCK_UN);
 		return -1;
 	}
 
-	if ( dolock )
-		INVLOCK( fd, LOCK_UN );
+	if (dolock)
+		INVLOCK(fd, LOCK_UN);
 	return nwritten;
 }
 
@@ -177,25 +177,25 @@ put_invtrecord( int fd, void *buf, size_t bufsz, off64_t off, bool_t dolock )
 
 
 int
-get_headerinfo( int fd, void **hdrs, void **cnt,
-	        size_t hdrsz, size_t cntsz, bool_t dolock )
+get_headerinfo(int fd, void **hdrs, void **cnt,
+	        size_t hdrsz, size_t cntsz, bool_t dolock)
 {
 	int num;
 
 	/* get a lock on the table for reading */
-	if ( dolock ) INVLOCK( fd, LOCK_SH );
+	if (dolock) INVLOCK(fd, LOCK_SH);
 
-	num = get_counters( fd, cnt, cntsz );
+	num = get_counters(fd, cnt, cntsz);
 
 	/* If there are no sessions recorded yet, we're done too */
-	if ( num > 0 ) {
-		if ( get_headers( fd, hdrs, hdrsz * (size_t)num, cntsz ) < 0 ) {
-			free ( *cnt );
+	if (num > 0) {
+		if (get_headers(fd, hdrs, hdrsz * (size_t)num, cntsz) < 0) {
+			free (*cnt);
 			num = -1;
 		}
 	}
 
-	if ( dolock ) INVLOCK( fd, LOCK_UN );
+	if (dolock) INVLOCK(fd, LOCK_UN);
 	return num;
 }
 
@@ -206,25 +206,25 @@ get_headerinfo( int fd, void **hdrs, void **cnt,
 /*----------------------------------------------------------------------*/
 
 int
-get_lastheader( int fd, void **ent, size_t hdrsz, size_t cntsz )
+get_lastheader(int fd, void **ent, size_t hdrsz, size_t cntsz)
 {
 	int	     	 nindices;
 	void	 	 *arr = NULL;
 	invt_counter_t	 *cnt = NULL;
 	char 		 *pos;
 	/* get the entries in the inv_index */
-	if ( ( nindices = GET_ALLHDRS_N_CNTS( fd, &arr, (void **)&cnt,
-					 hdrsz, cntsz )) <= 0 ) {
+	if ((nindices = GET_ALLHDRS_N_CNTS(fd, &arr, (void **)&cnt,
+					 hdrsz, cntsz)) <= 0) {
 		return -1;
 	}
 
 	/* if there's space anywhere at all, then it must be in the last
 	   entry */
-	*ent = malloc( hdrsz );
-	pos = (char *) arr + ( (uint)nindices - 1 ) * hdrsz;
-	memcpy( *ent, pos, hdrsz );
-	free ( arr );
-	free ( cnt );
+	*ent = malloc(hdrsz);
+	pos = (char *) arr + ((uint)nindices - 1) * hdrsz;
+	memcpy(*ent, pos, hdrsz);
+	free (arr);
+	free (cnt);
 
 	return nindices;
 }
diff --git a/inventory/inv_files.c b/inventory/inv_files.c
index 46f6b8f..ae4642d 100644
--- a/inventory/inv_files.c
+++ b/inventory/inv_files.c
@@ -49,35 +49,35 @@ static char inv_dirpathp[MGR_PATH_MAX];
 static char inv_lockfilep[MGR_PATH_MAX];
 
 char *
-inv_dirpath( void )
+inv_dirpath(void)
 {
 	assert(inv_base);
 	return inv_dirpathp;
 }
 
 char *
-inv_fstab( void )
+inv_fstab(void)
 {
 	assert(inv_base);
 	return inv_fstabp;
 }
 
 char *
-inv_lockfile( void )
+inv_lockfile(void)
 {
 	assert(inv_base);
 	return inv_lockfilep;
 }
 
 char *
-inv_basepath( void )
+inv_basepath(void)
 {
 	assert(inv_base);
 	return inv_base;
 }
 
 int
-inv_setup_base( void )
+inv_setup_base(void)
 {
 	struct stat64 new_sbuf, old_sbuf;
 	int new_exists, old_exists;
diff --git a/inventory/inv_fstab.c b/inventory/inv_fstab.c
index 5f7e734..5afec57 100644
--- a/inventory/inv_fstab.c
+++ b/inventory/inv_fstab.c
@@ -49,28 +49,28 @@
 
 
 int
-fstab_getall( invt_fstab_t **arr, invt_counter_t **cnt, int *numfs,
-	      inv_oflag_t forwhat )
+fstab_getall(invt_fstab_t **arr, invt_counter_t **cnt, int *numfs,
+	      inv_oflag_t forwhat)
 {
 	int fd;
 
-	fd = open ( INV_FSTAB, INV_OFLAG(forwhat) );
+	fd = open (INV_FSTAB, INV_OFLAG(forwhat));
 
-	if ( fd < 0 )
+	if (fd < 0)
 		return -1; /* if ENOENT, fstab_put_entry will CREAT */
 
-	INVLOCK( fd, LOCK_EX );
-	if (( *numfs = GET_ALLHDRS_N_CNTS_NOLOCK( fd, (void**) arr,
+	INVLOCK(fd, LOCK_EX);
+	if ((*numfs = GET_ALLHDRS_N_CNTS_NOLOCK(fd, (void**) arr,
 						 (void **)cnt,
-						 sizeof( invt_fstab_t ),
-						 sizeof( invt_counter_t ) )
-	     ) < 0 ) {
-		mlog( MLOG_NORMAL | MLOG_INV, _(
-			"INV: couldn't get fstab headers\n") );
+						 sizeof(invt_fstab_t),
+						 sizeof(invt_counter_t) )
+	     ) < 0) {
+		mlog(MLOG_NORMAL | MLOG_INV, _(
+			"INV: couldn't get fstab headers\n"));
 	}
 #ifdef INVT_DEBUG
-	mlog( MLOG_NITTY | MLOG_INV, "INV: number of filesystems in fstab %d\n",
-	      *numfs );
+	mlog(MLOG_NITTY | MLOG_INV, "INV: number of filesystems in fstab %d\n",
+	      *numfs);
 #endif
 	/* fstab is left locked EX on exit. The caller takes does
 	   the unlocking */
@@ -88,53 +88,53 @@ fstab_getall( invt_fstab_t **arr, invt_counter_t **cnt, int *numfs,
 
 
 int
-fstab_put_entry( uuid_t *fsidp, char *mntpt, char *dev, inv_oflag_t forwhat )
+fstab_put_entry(uuid_t *fsidp, char *mntpt, char *dev, inv_oflag_t forwhat)
 {
 	int numfs, i, fd;
 	invt_counter_t *cnt;
 	invt_fstab_t *arr;
 	int rval = 1;
 
-	assert( forwhat != INV_SEARCH_ONLY );
+	assert(forwhat != INV_SEARCH_ONLY);
 
 	/* fd is locked on succesful return */
-	fd = fstab_getall( &arr, &cnt, &numfs, forwhat );
-	if ( fd < 0 ) {
-		if ( errno != ENOENT ) {
+	fd = fstab_getall(&arr, &cnt, &numfs, forwhat);
+	if (fd < 0) {
+		if (errno != ENOENT) {
 			return -1;
 		}
-		if ((fd = open( INV_FSTAB, INV_OFLAG(forwhat) | O_CREAT, S_IRUSR|S_IWUSR ))
-		    < 0 ) {
-			INV_PERROR ( INV_FSTAB );
+		if ((fd = open(INV_FSTAB, INV_OFLAG(forwhat) | O_CREAT, S_IRUSR|S_IWUSR))
+		    < 0) {
+			INV_PERROR (INV_FSTAB);
 			return -1;
 		}
 
-		INVLOCK( fd, LOCK_EX );
-		fchmod( fd, INV_PERMS );
+		INVLOCK(fd, LOCK_EX);
+		fchmod(fd, INV_PERMS);
 
-		cnt = (invt_counter_t *) malloc( sizeof ( invt_counter_t ) );
+		cnt = (invt_counter_t *) malloc(sizeof (invt_counter_t) );
 
 		cnt->ic_maxnum = -1;
 		cnt->ic_curnum = 0;
 		cnt->ic_vernum = INV_VERSION;
 
-	} else if ( numfs > 0 ) {
+	} else if (numfs > 0) {
 
 		for (i = 0; i < numfs; i++) {
-		    if ( uuid_compare( *fsidp, arr[ i ].ft_uuid ) == 0 ) {
+		    if (uuid_compare(*fsidp, arr[i].ft_uuid) == 0) {
 
-/*			if ( ( STREQL( arr[i].ft_mountpt, mntpt ) ) &&
-			    ( STREQL( arr[i].ft_devpath, dev ) ) )
+/*			if ((STREQL(arr[i].ft_mountpt, mntpt) ) &&
+			    (STREQL(arr[i].ft_devpath, dev) ))
 */
-				free ( arr );
-				free ( cnt );
-				close( fd );
+				free (arr);
+				free (cnt);
+				close(fd);
 				return 1;
 
 		}
 	    }
 	    /* entry not found. just follow thru to create a new one */
-	    free ( arr );
+	    free (arr);
 	}
 
 	/* make a new fstab entry and insert it at the end. the table
@@ -143,29 +143,29 @@ fstab_put_entry( uuid_t *fsidp, char *mntpt, char *dev, inv_oflag_t forwhat )
 		invt_fstab_t ent;
 		off64_t hoff;
 
-		memcpy( &ent.ft_uuid, fsidp, sizeof( uuid_t ) );
-		strcpy( ent.ft_mountpt, mntpt );
-		strcpy( ent.ft_devpath, dev );
+		memcpy(&ent.ft_uuid, fsidp, sizeof(uuid_t) );
+		strcpy(ent.ft_mountpt, mntpt);
+		strcpy(ent.ft_devpath, dev);
 
 		/* increase the number of entries first */
 #ifdef INVT_DEBUG
-		mlog( MLOG_NITTY | MLOG_INV,"INV: putting new fstab entry for %s ....\n",
+		mlog(MLOG_NITTY | MLOG_INV,"INV: putting new fstab entry for %s ....\n",
 		      mntpt);
 #endif
 		cnt->ic_curnum++;
-		hoff = (off64_t) ( sizeof( invt_counter_t ) +
-				 (size_t)( cnt->ic_curnum - 1 ) *
-				           sizeof( invt_fstab_t ) );
+		hoff = (off64_t) (sizeof(invt_counter_t) +
+				 (size_t)(cnt->ic_curnum - 1) *
+				           sizeof(invt_fstab_t) );
 
-		rval = PUT_COUNTERS( fd, cnt );
-		if ( rval > 0 ) {
-		      rval = PUT_REC_NOLOCK( fd, &ent, sizeof( ent ), hoff );
+		rval = PUT_COUNTERS(fd, cnt);
+		if (rval > 0) {
+		      rval = PUT_REC_NOLOCK(fd, &ent, sizeof(ent), hoff);
 		}
 
 	}
-	INVLOCK( fd, LOCK_UN );
-	free ( cnt );
-	close ( fd );
+	INVLOCK(fd, LOCK_UN);
+	free (cnt);
+	close (fd);
 	return rval;
 }
 
@@ -174,7 +174,7 @@ fstab_put_entry( uuid_t *fsidp, char *mntpt, char *dev, inv_oflag_t forwhat )
 
 
 int
-fstab_get_fname( void *pred,
+fstab_get_fname(void *pred,
 		 char *fname,
 		 inv_predicate_t bywhat,
 		 inv_oflag_t forwhat)
@@ -189,34 +189,34 @@ fstab_get_fname( void *pred,
 		invt_counter_t *cnt;
 
 		/* on sucessful return fd is locked */
-		fd = fstab_getall( &arr, &cnt, &numfs, forwhat );
-		if ( fd < 0 )
+		fd = fstab_getall(&arr, &cnt, &numfs, forwhat);
+		if (fd < 0)
 			return -1;
-		if ( numfs <= 0 ) {
-			mlog( MLOG_NORMAL | MLOG_INV, _(
+		if (numfs <= 0) {
+			mlog(MLOG_NORMAL | MLOG_INV, _(
 			      "INV: No recorded filesystems in"
-			      " inventory's fstab.\n") );
+			      " inventory's fstab.\n"));
 			return -1;
 		}
-		INVLOCK( fd, LOCK_UN );
-		close ( fd );
-		free ( cnt ); /* we dont need it */
+		INVLOCK(fd, LOCK_UN);
+		close (fd);
+		free (cnt); /* we dont need it */
 
 		/* first get hold of the uuid for this mount point/device */
 
 		for (i = 0; i < numfs; i++) {
-			if ( ( bywhat == INV_BY_MOUNTPT &&
-			     ( STREQL( arr[i].ft_mountpt, pred ) )) ||
-			     ( bywhat == INV_BY_DEVPATH &&
-			     ( STREQL( arr[i].ft_devpath, pred ) )) ) {
+			if ((bywhat == INV_BY_MOUNTPT &&
+			     (STREQL(arr[i].ft_mountpt, pred) )) ||
+			     (bywhat == INV_BY_DEVPATH &&
+			     (STREQL(arr[i].ft_devpath, pred) ))) {
 
 				uuidp = &arr[i].ft_uuid;
 				break;
 			}
 		}
 #ifdef INVT_DEBUG
-		if (! uuidp )
-			mlog( MLOG_DEBUG | MLOG_INV,"INV: get_fname: unable to find %s"
+		if (! uuidp)
+			mlog(MLOG_DEBUG | MLOG_INV,"INV: get_fname: unable to find %s"
 			      " in the inventory\n", (char *)pred);
 #endif
 
@@ -224,35 +224,35 @@ fstab_get_fname( void *pred,
 		uuidp = (uuid_t *)pred;
 	}
 
-	if (! uuidp )
+	if (! uuidp)
 		return -1;
 
-	uuid_unparse( *uuidp, uuidstr );
+	uuid_unparse(*uuidp, uuidstr);
 
-	strncpy ( fname, INV_DIRPATH, INV_STRLEN );
-	strcat ( fname, "/" );
-	strcat ( fname, uuidstr);
+	strncpy (fname, INV_DIRPATH, INV_STRLEN);
+	strcat (fname, "/");
+	strcat (fname, uuidstr);
 
-	if ( bywhat != INV_BY_UUID )
-		free ( arr );
+	if (bywhat != INV_BY_UUID)
+		free (arr);
 
-	assert( (int) strlen( fname ) < INV_STRLEN );
+	assert((int) strlen(fname) < INV_STRLEN);
 	return 1;
 }
 
 
 void
-fstab_DEBUG_print( invt_fstab_t *arr, int num )
+fstab_DEBUG_print(invt_fstab_t *arr, int num)
 {
 	int i;
 	char str[UUID_STR_LEN + 1];
 
-	mlog( MLOG_NORMAL | MLOG_INV, _("\n\n--------- fstab ------------\n") );
-	for ( i = 0; i < num; i++ ) {
-		printf( _("Mount\t%s\n"), arr[i].ft_mountpt );
-		printf( _("Dev\t%s\n"), arr[i].ft_devpath );
-		uuid_unparse( arr[i].ft_uuid, str );
-		printf( _("FSid\t%s\n\n"), str );
+	mlog(MLOG_NORMAL | MLOG_INV, _("\n\n--------- fstab ------------\n"));
+	for (i = 0; i < num; i++) {
+		printf(_("Mount\t%s\n"), arr[i].ft_mountpt);
+		printf(_("Dev\t%s\n"), arr[i].ft_devpath);
+		uuid_unparse(arr[i].ft_uuid, str);
+		printf(_("FSid\t%s\n\n"), str);
 	}
-	mlog( MLOG_NORMAL | MLOG_INV, "\n---------========------------\n" );
+	mlog(MLOG_NORMAL | MLOG_INV, "\n---------========------------\n");
 }
diff --git a/inventory/inv_idx.c b/inventory/inv_idx.c
index b33983d..7b36cd6 100644
--- a/inventory/inv_idx.c
+++ b/inventory/inv_idx.c
@@ -44,10 +44,10 @@
 /* into.                                                                */
 /*----------------------------------------------------------------------*/
 uint
-idx_insert_newentry( int fd, /* kept locked EX by caller */
+idx_insert_newentry(int fd, /* kept locked EX by caller */
 		     int *stobjfd, /* OUT */
 		     invt_entry_t *iarr, invt_counter_t *icnt,
-		     time32_t tm )
+		     time32_t tm)
 {
 	uint i;
 	inv_oflag_t forwhat = INV_SEARCH_N_MOD;
@@ -56,42 +56,42 @@ idx_insert_newentry( int fd, /* kept locked EX by caller */
 
 	/* If time period of the new entry is before our first invindex,
 	   we have to insert a new invindex in the first slot */
-	if ( iarr[0].ie_timeperiod.tp_start > tm ) {
-		/* *stobjfd = idx_put_newentry( fd, 0, iarr, icnt, &ient );*/
-		*stobjfd = open( iarr[0].ie_filename, INV_OFLAG(forwhat) );
+	if (iarr[0].ie_timeperiod.tp_start > tm) {
+		/* *stobjfd = idx_put_newentry(fd, 0, iarr, icnt, &ient);*/
+		*stobjfd = open(iarr[0].ie_filename, INV_OFLAG(forwhat));
 		return 0;
 	}
 
-	for ( i = 0; i < icnt->ic_curnum; i++ ) {
+	for (i = 0; i < icnt->ic_curnum; i++) {
 		/* if our time is nicely within an existing entry's time
 		   period, hellalujah */
-		if ( IS_WITHIN( &iarr[i].ie_timeperiod, tm ) ) {
+		if (IS_WITHIN(&iarr[i].ie_timeperiod, tm) ) {
 #ifdef INVT_DEBUG
-			mlog( MLOG_DEBUG | MLOG_INV, "INV: is_within %d\n",i );
+			mlog(MLOG_DEBUG | MLOG_INV, "INV: is_within %d\n",i);
 #endif
-			*stobjfd = open( iarr[i].ie_filename, INV_OFLAG(forwhat) );
+			*stobjfd = open(iarr[i].ie_filename, INV_OFLAG(forwhat));
 			return i;
 		}
-		if ( iarr[i].ie_timeperiod.tp_end == 0  &&
-		     iarr[i].ie_timeperiod.tp_start  == 0 ) {
+		if (iarr[i].ie_timeperiod.tp_end == 0  &&
+		     iarr[i].ie_timeperiod.tp_start  == 0) {
 #ifdef INVT_DEBUG
-			mlog( MLOG_DEBUG | MLOG_INV, "INV: end = start \n" );
-			mlog( MLOG_DEBUG | MLOG_INV,"BEF: st %ld end %ld\n",
+			mlog(MLOG_DEBUG | MLOG_INV, "INV: end = start \n");
+			mlog(MLOG_DEBUG | MLOG_INV,"BEF: st %ld end %ld\n",
 			     iarr[i].ie_timeperiod.tp_start,
-			     iarr[i].ie_timeperiod.tp_end );
+			     iarr[i].ie_timeperiod.tp_end);
 #endif
 
 			iarr[i].ie_timeperiod.tp_start =
 				iarr[i].ie_timeperiod.tp_end = tm;
-			PUT_REC_NOLOCK( fd, iarr,
+			PUT_REC_NOLOCK(fd, iarr,
 				       icnt->ic_curnum * sizeof(invt_entry_t),
-				       (off64_t) sizeof( invt_counter_t ) );
+				       (off64_t) sizeof(invt_counter_t) );
 #ifdef INVT_DEBUG
-			mlog( MLOG_DEBUG | MLOG_INV,"AFT: st %ld end %ld\n",
+			mlog(MLOG_DEBUG | MLOG_INV,"AFT: st %ld end %ld\n",
 			     iarr[i].ie_timeperiod.tp_start,
-			     iarr[i].ie_timeperiod.tp_end );
+			     iarr[i].ie_timeperiod.tp_end);
 #endif
-			*stobjfd = open( iarr[i].ie_filename, INV_OFLAG(forwhat) );
+			*stobjfd = open(iarr[i].ie_filename, INV_OFLAG(forwhat));
 			return i;
 		}
 
@@ -99,9 +99,9 @@ idx_insert_newentry( int fd, /* kept locked EX by caller */
 
 		/* if it is beyond the end of this timeperiod, see if we
 		   belong to a timeperiod that doesn't have an entry */
-		if ( iarr[i].ie_timeperiod.tp_end < tm ) {
+		if (iarr[i].ie_timeperiod.tp_end < tm) {
 			/* see if we're the last entry here */
-			if ( i == icnt->ic_curnum - 1 ) {
+			if (i == icnt->ic_curnum - 1) {
 				/* our slot is (i+1)th entry. Make the
 				   timeperiod's the same as it was. As far
 				   as I can see there is no way that
@@ -109,13 +109,13 @@ idx_insert_newentry( int fd, /* kept locked EX by caller */
 
 				   insert the new entry and write back
 				   icnt and invindex entry */
-				/* *stobjfd = idx_put_newentry( fd, i+1, iarr,
-							     icnt, &ient );*/
-			      *stobjfd = open( iarr[i].ie_filename, INV_OFLAG(forwhat) );
+				/* *stobjfd = idx_put_newentry(fd, i+1, iarr,
+							     icnt, &ient);*/
+			      *stobjfd = open(iarr[i].ie_filename, INV_OFLAG(forwhat));
 			      return i;
 			}
 			/* see if the next entry starts later than us */
-			if ( iarr[i+1].ie_timeperiod.tp_start > tm ) {
+			if (iarr[i+1].ie_timeperiod.tp_start > tm) {
 
 
 				/* We have the option of pushing entries
@@ -125,22 +125,22 @@ idx_insert_newentry( int fd, /* kept locked EX by caller */
 				   We choose the former. */
 
 				/* the timeperiods had better not overlap */
-				assert(( tm > iarr[i].ie_timeperiod.tp_end ) &&
-				       ( tm < iarr[i+1].ie_timeperiod.tp_start ));
+				assert((tm > iarr[i].ie_timeperiod.tp_end) &&
+				       (tm < iarr[i+1].ie_timeperiod.tp_start));
 
 				/* shift everything from (i+1) onwards by
 				   one. Then insert the new entry and write
 				   back icnt and invindex entries */
-				/* *stobjfd = idx_put_newentry( fd, i+1, iarr,
-							     icnt, &ient );*/
-			      *stobjfd = open( iarr[i].ie_filename, INV_OFLAG(forwhat) );
+				/* *stobjfd = idx_put_newentry(fd, i+1, iarr,
+							     icnt, &ient);*/
+			      *stobjfd = open(iarr[i].ie_filename, INV_OFLAG(forwhat));
 				return i;
 			}
 		}
 	}
 
 	/* We couldnt find anything that fits */
-	assert( 0 );	/* We can't get here ! */
+	assert(0);	/* We can't get here ! */
 	return -1;
 
 
@@ -156,7 +156,7 @@ idx_insert_newentry( int fd, /* kept locked EX by caller */
 int
 idx_put_newentry(
 	invt_idxinfo_t *idx,
-	invt_entry_t *ient )
+	invt_entry_t *ient)
 {
 	invt_entry_t	*idxarr;
 	int stobjfd;
@@ -166,37 +166,37 @@ idx_put_newentry(
 	invt_entry_t *iarr = idx->iarr;
 	invt_counter_t *icnt = idx->icnt;
 
-	stobj_makefname( ient->ie_filename );
-	if ( ( stobjfd = stobj_create( ient->ie_filename ) ) < 0 )
+	stobj_makefname(ient->ie_filename);
+	if ((stobjfd = stobj_create(ient->ie_filename) ) < 0)
 		return -1;
 
 	icnt->ic_curnum++; /* there is no maximum */
 
-	idxarr = ( invt_entry_t * ) calloc ( icnt->ic_curnum,
-					     sizeof( invt_entry_t ) );
-	memcpy( idxarr, iarr, ( size_t ) ( sizeof( invt_entry_t ) * index ) );
+	idxarr = (invt_entry_t *) calloc (icnt->ic_curnum,
+					     sizeof(invt_entry_t) );
+	memcpy(idxarr, iarr, (size_t) (sizeof(invt_entry_t) * index) );
 
 	/* shift everything from (i+1) onwards by one */
-	if ( index <  icnt->ic_curnum - 1 )
-		memcpy( &idxarr[ index + 1 ], &iarr[ index ],
-		       ( size_t ) ( ( icnt->ic_curnum - index - 1 ) *
-				    sizeof( invt_entry_t ) ) );
+	if (index <  icnt->ic_curnum - 1)
+		memcpy(&idxarr[index + 1], &iarr[index],
+		       (size_t) ((icnt->ic_curnum - index - 1) *
+				    sizeof(invt_entry_t) ));
 	/* insert the new entry */
-	memcpy( &idxarr[ index ], ient, sizeof( invt_entry_t ) );
+	memcpy(&idxarr[index], ient, sizeof(invt_entry_t) );
 
 
-	if ( ( PUT_COUNTERS( fd, icnt ) < 0 ) ||
-		( PUT_REC_NOLOCK( fd, idxarr,
-				  icnt->ic_curnum * sizeof( invt_entry_t ),
-				  sizeof( invt_counter_t ) ) < 0 ) ) {
+	if ((PUT_COUNTERS(fd, icnt) < 0) ||
+		(PUT_REC_NOLOCK(fd, idxarr,
+				  icnt->ic_curnum * sizeof(invt_entry_t),
+				  sizeof(invt_counter_t) ) < 0) ) {
 			/* XXX delete the stobj that we just created */
 
-			memset( ient->ie_filename, 0 , INV_STRLEN );
-			free( idxarr );
+			memset(ient->ie_filename, 0 , INV_STRLEN);
+			free(idxarr);
 			return -1;
 		}
 
-	free( iarr );
+	free(iarr);
 	idx->iarr = idxarr;
 	return stobjfd;
 
@@ -213,8 +213,8 @@ idx_put_newentry(
 
 
 int
-idx_find_stobj( invt_idxinfo_t *idx,
-	        time32_t tm )
+idx_find_stobj(invt_idxinfo_t *idx,
+	        time32_t tm)
 {
 
 	int 		stobjfd;
@@ -222,22 +222,22 @@ idx_find_stobj( invt_idxinfo_t *idx,
 	/* since sessions can be inserted in random order, the invindex
 	   table can contain time-periods that don't have corresponding
 	   entries for */
-	if ( GET_ALLHDRS_N_CNTS_NOLOCK( idx->invfd, (void **)&idx->iarr,
+	if (GET_ALLHDRS_N_CNTS_NOLOCK(idx->invfd, (void **)&idx->iarr,
 						     (void **)&idx->icnt,
-						     sizeof( invt_entry_t ),
-				sizeof( invt_counter_t ) ) < 0 ) {
+						     sizeof(invt_entry_t),
+				sizeof(invt_counter_t) ) < 0) {
 		return -1;
 	}
 
 #ifdef INVT_DEBUG
-	printf( "idx_find_stobj Time: %ld\n", tm );
-	idx_DEBUG_printinvindices( idx->iarr, idx->icnt->ic_curnum );
+	printf("idx_find_stobj Time: %ld\n", tm);
+	idx_DEBUG_printinvindices(idx->iarr, idx->icnt->ic_curnum);
 #endif
 
 	/* Now figure out where we are going to insert this stobj among the
 	   invindices and put it there */
-	idx->index = idx_insert_newentry( idx->invfd, &stobjfd, idx->iarr,
-						 idx->icnt, tm );
+	idx->index = idx_insert_newentry(idx->invfd, &stobjfd, idx->iarr,
+						 idx->icnt, tm);
 
 	return stobjfd;
 }
@@ -254,33 +254,33 @@ idx_find_stobj( invt_idxinfo_t *idx,
 /*----------------------------------------------------------------------*/
 
 inv_idbtoken_t
-idx_create( char *fname, inv_oflag_t forwhat )
+idx_create(char *fname, inv_oflag_t forwhat)
 {
 	int stobjfd, fd;
 	inv_idbtoken_t tok;
 
 	/* This is not to be called when the user wants to open
 	   the db for SEARCH_ONLY. */
-	assert( forwhat != INV_SEARCH_ONLY );
+	assert(forwhat != INV_SEARCH_ONLY);
 
-	if ((fd = open ( fname , INV_OFLAG(forwhat) | O_CREAT, S_IRUSR|S_IWUSR ) ) < 0 ) {
-		INV_PERROR ( fname );
+	if ((fd = open (fname , INV_OFLAG(forwhat) | O_CREAT, S_IRUSR|S_IWUSR) ) < 0) {
+		INV_PERROR (fname);
 		return INV_TOKEN_NULL;
 	}
 
-	INVLOCK( fd, LOCK_EX );
-	fchmod( fd, INV_PERMS );
+	INVLOCK(fd, LOCK_EX);
+	fchmod(fd, INV_PERMS);
 
 #ifdef INVT_DEBUG
-	mlog( MLOG_NITTY | MLOG_INV, "creating InvIndex %s\n", fname);
+	mlog(MLOG_NITTY | MLOG_INV, "creating InvIndex %s\n", fname);
 #endif
 
 	/* create the first entry in the new inv_index */
-	stobjfd = idx_create_entry( &tok, fd, BOOL_TRUE );
+	stobjfd = idx_create_entry(&tok, fd, BOOL_TRUE);
 
-	INVLOCK( fd, LOCK_UN );
+	INVLOCK(fd, LOCK_UN);
 
-	if ( stobjfd < 0 )
+	if (stobjfd < 0)
 		return INV_TOKEN_NULL;
 	return tok;
 }
@@ -292,18 +292,18 @@ idx_create( char *fname, inv_oflag_t forwhat )
 /*                                                                      */
 /*----------------------------------------------------------------------*/
 int
-idx_recons_time( time32_t tm, invt_idxinfo_t *idx )
+idx_recons_time(time32_t tm, invt_idxinfo_t *idx)
 {
 	invt_timeperiod_t *tp = &idx->iarr[idx->index].ie_timeperiod;
-	if ( tp->tp_start && IS_WITHIN( tp, tm ) )
+	if (tp->tp_start && IS_WITHIN(tp, tm) )
 		return 1;
 
-	if ( tm > tp->tp_end || tp->tp_end == 0 )
+	if (tm > tp->tp_end || tp->tp_end == 0)
 		tp->tp_end =  tm;
-	if ( tm < tp->tp_start || tp->tp_start == 0 )
+	if (tm < tp->tp_start || tp->tp_start == 0)
 		tp->tp_start = tm;
-	PUT_REC_NOLOCK( idx->invfd,  &idx->iarr[idx->index],
-		        sizeof( invt_entry_t ), IDX_HDR_OFFSET(idx->index) );
+	PUT_REC_NOLOCK(idx->invfd,  &idx->iarr[idx->index],
+		        sizeof(invt_entry_t), IDX_HDR_OFFSET(idx->index));
 	return 1;
 }
 
@@ -317,29 +317,29 @@ idx_recons_time( time32_t tm, invt_idxinfo_t *idx )
 /*----------------------------------------------------------------------*/
 
 int
-idx_put_sesstime( inv_sestoken_t tok, bool_t whichtime)
+idx_put_sesstime(inv_sestoken_t tok, bool_t whichtime)
 {
 	int rval;
 	invt_entry_t ent;
 	int fd = tok->sd_invtok->d_invindex_fd;
 
-	INVLOCK( fd, LOCK_EX );
+	INVLOCK(fd, LOCK_EX);
 
-	rval = GET_REC_NOLOCK( fd, &ent, sizeof( invt_entry_t ),
+	rval = GET_REC_NOLOCK(fd, &ent, sizeof(invt_entry_t),
 			        tok->sd_invtok->d_invindex_off);
-	if ( rval < 0 ) {
-		INVLOCK( fd, LOCK_UN );
+	if (rval < 0) {
+		INVLOCK(fd, LOCK_UN);
 		return -1;
 	}
 	ent.ie_timeperiod.tp_end = tok->sd_sesstime;
 
-	if ( whichtime == INVT_STARTTIME || ent.ie_timeperiod.tp_start == 0 ) {
+	if (whichtime == INVT_STARTTIME || ent.ie_timeperiod.tp_start == 0) {
 		ent.ie_timeperiod.tp_start = tok->sd_sesstime;
 	}
 #ifdef INVT_DEBUG
-	mlog( MLOG_DEBUG | MLOG_INV,"Putsestime: st %ld end %ld\n",
+	mlog(MLOG_DEBUG | MLOG_INV,"Putsestime: st %ld end %ld\n",
 			      ent.ie_timeperiod.tp_start,
-			      ent.ie_timeperiod.tp_end );
+			      ent.ie_timeperiod.tp_end);
 #endif
 	rval = PUT_REC_NOLOCK(fd, &ent, sizeof(invt_entry_t),
 			      tok->sd_invtok->d_invindex_off);
@@ -349,20 +349,20 @@ idx_put_sesstime( inv_sestoken_t tok, bool_t whichtime)
 		int nindices;
 		invt_entry_t *iarr = NULL;
 		invt_counter_t *icnt = NULL;
-		if ( ( nindices = GET_ALLHDRS_N_CNTS_NOLOCK( fd,
+		if ((nindices = GET_ALLHDRS_N_CNTS_NOLOCK(fd,
 						     (void **)&iarr,
 						     (void **)&icnt,
-						sizeof( invt_entry_t ),
-				sizeof( invt_counter_t ))) < 0 ) {
+						sizeof(invt_entry_t),
+				sizeof(invt_counter_t))) < 0) {
 			return -1;
 		}
-		idx_DEBUG_printinvindices( iarr, (uint) nindices );
-		free( iarr );
-		free( icnt );
+		idx_DEBUG_printinvindices(iarr, (uint) nindices);
+		free(iarr);
+		free(icnt);
 	}
 #endif
 
-	INVLOCK( fd, LOCK_UN );
+	INVLOCK(fd, LOCK_UN);
 	return rval;
 }
 
@@ -384,42 +384,42 @@ int
 idx_create_entry(
 	inv_idbtoken_t *tok,
 	int invfd, 	/* kept locked EX  by caller */
-	bool_t firstentry )
+	bool_t firstentry)
 {
 	invt_entry_t   	ent;
 	int	      	fd;
 	off64_t 	hoff;
 
 
-	memset ( &ent, 0, sizeof( ent ) );
+	memset (&ent, 0, sizeof(ent) );
 
 	/* initialize the start and end times to be the same */
 	ent.ie_timeperiod.tp_start = ent.ie_timeperiod.tp_end = (time32_t)0;
-	stobj_makefname( ent.ie_filename );
+	stobj_makefname(ent.ie_filename);
 
-	if ( firstentry ) {
+	if (firstentry) {
 		invt_counter_t cnt;
 
 		cnt.ic_maxnum = INVT_MAX_INVINDICES;
 		cnt.ic_curnum = 1;
 		cnt.ic_vernum = INV_VERSION;
 
-		fd = stobj_create( ent.ie_filename );
-		if ( fd < 0 ) {
+		fd = stobj_create(ent.ie_filename);
+		if (fd < 0) {
 			return -1;
 		}
 
-		if ( PUT_REC_NOLOCK( invfd, &cnt, sizeof(cnt), (off64_t)0 ) < 0 )
+		if (PUT_REC_NOLOCK(invfd, &cnt, sizeof(cnt), (off64_t)0) < 0)
 			return -1;
 
-		hoff = sizeof( invt_counter_t );
+		hoff = sizeof(invt_counter_t);
 
-		if ( PUT_REC_NOLOCK( invfd, &ent, sizeof( ent ), hoff ) < 0)
+		if (PUT_REC_NOLOCK(invfd, &ent, sizeof(ent), hoff) < 0)
 			return -1;
 	} else {
 		invt_counter_t *cnt = NULL;
 
-		if ( GET_COUNTERS( invfd, &cnt )  < 0 ) {
+		if (GET_COUNTERS(invfd, &cnt)  < 0) {
 			return -1;
 		}
 
@@ -427,29 +427,29 @@ idx_create_entry(
 		   another and leave a pointer to that in here */
 
 		/* create the new storage object */
-		fd = stobj_create( ent.ie_filename );
-		if ( fd < 0 ) {
+		fd = stobj_create(ent.ie_filename);
+		if (fd < 0) {
 			return -1;
 		}
 		++(cnt->ic_curnum);
-		if ( PUT_COUNTERS( invfd, cnt ) < 0 ) {
+		if (PUT_COUNTERS(invfd, cnt) < 0) {
 			return -1;
 		}
 
 		/* add the new index entry to the array, at the end */
 
-		hoff = IDX_HDR_OFFSET( cnt->ic_curnum - 1 );
+		hoff = IDX_HDR_OFFSET(cnt->ic_curnum - 1);
 		free (cnt);
 #ifdef INVT_DEBUG
-		mlog( MLOG_NITTY | MLOG_INV, "new stobj name %s @ offset %d\n",
-		      ent.ie_filename,(int)hoff );
+		mlog(MLOG_NITTY | MLOG_INV, "new stobj name %s @ offset %d\n",
+		      ent.ie_filename,(int)hoff);
 #endif
-		if (PUT_REC_NOLOCK( invfd, &ent, sizeof( ent ), hoff) < 0 )
+		if (PUT_REC_NOLOCK(invfd, &ent, sizeof(ent), hoff) < 0)
 			return -1;
 
 	}
 
-	*tok = get_token( invfd, fd );
+	*tok = get_token(invfd, fd);
 	(*tok)->d_invindex_off = hoff;
 	(*tok)->d_update_flag |= NEW_INVINDEX;
 	(*tok)->d_oflag = INV_SEARCH_N_MOD;
@@ -469,7 +469,7 @@ idx_create_entry(
 /*----------------------------------------------------------------------*/
 
 int
-idx_get_stobj( int invfd, inv_oflag_t forwhat, int *index )
+idx_get_stobj(int invfd, inv_oflag_t forwhat, int *index)
 {
 	invt_entry_t 	*ent = 0;
 	int	     	 fd;
@@ -477,65 +477,65 @@ idx_get_stobj( int invfd, inv_oflag_t forwhat, int *index )
 	/* if there's space anywhere at all, then it must be in the last
 	   entry. get_lastheader() does the locking */
 
-	if ((*index = get_lastheader( invfd, (void **)&ent,
+	if ((*index = get_lastheader(invfd, (void **)&ent,
 				       sizeof(invt_entry_t),
-				       sizeof(invt_counter_t) ) ) < 0 )
+				       sizeof(invt_counter_t)) ) < 0)
 		return -1;
 	/* at this point we know that there should be at least one invindex
 	   entry present */
-	assert ( ent != NULL );
-	assert ( ent->ie_filename );
+	assert (ent != NULL);
+	assert (ent->ie_filename);
 
-	fd = open( ent->ie_filename, INV_OFLAG(forwhat) );
-	if ( fd < 0 )
-		INV_PERROR( ent->ie_filename );
-	free ( ent );
+	fd = open(ent->ie_filename, INV_OFLAG(forwhat));
+	if (fd < 0)
+		INV_PERROR(ent->ie_filename);
+	free (ent);
 
 	return fd;
 }
 
 
 int
-idx_DEBUG_printinvindices( invt_entry_t *iarr, uint num )
+idx_DEBUG_printinvindices(invt_entry_t *iarr, uint num)
 {
 	uint i;
 	uint k;
 
 	char s[9];
-	printf( "\n ==================================\n"
-	        " InvIndex\n # StObjs\t%d\n", num );
+	printf("\n ==================================\n"
+	        " InvIndex\n # StObjs\t%d\n", num);
 #define INV_UUID_STR_LEN	36 /* not exported via uuid.h */
-	for ( i = 0; i < num; i++ ) {
-		k = strlen( iarr[i].ie_filename );
-		strncpy( s, (char *) iarr[i].ie_filename + k -
-			( INV_UUID_STR_LEN + strlen(INV_STOBJ_PREFIX)), 8 );
+	for (i = 0; i < num; i++) {
+		k = strlen(iarr[i].ie_filename);
+		strncpy(s, (char *) iarr[i].ie_filename + k -
+			(INV_UUID_STR_LEN + strlen(INV_STOBJ_PREFIX)), 8);
 		s[8]= 0;
-		printf("%d. %s \t( %d - %d )\n", i, s,
+		printf("%d. %s \t(%d - %d)\n", i, s,
 		       iarr[i].ie_timeperiod.tp_start,
-		       iarr[i].ie_timeperiod.tp_end );
+		       iarr[i].ie_timeperiod.tp_end);
 	}
 #undef INV_UUID_STR_LEN
-	printf( "\n ==================================\n");
+	printf("\n ==================================\n");
 	return 1;
 
 }
 
 int
-idx_DEBUG_print ( int fd )
+idx_DEBUG_print (int fd)
 {
 	int nindices;
 	invt_entry_t *iarr = NULL;
 	invt_counter_t *icnt = NULL;
-	if ( ( nindices = GET_ALLHDRS_N_CNTS_NOLOCK( fd,
+	if ((nindices = GET_ALLHDRS_N_CNTS_NOLOCK(fd,
 						    (void **)&iarr,
 						    (void **)&icnt,
-						    sizeof( invt_entry_t ),
-				         sizeof( invt_counter_t ))) < 0 ) {
+						    sizeof(invt_entry_t),
+				         sizeof(invt_counter_t))) < 0) {
 		return -1;
 	}
-	idx_DEBUG_printinvindices( iarr, (uint) nindices );
-	free( iarr );
-	free( icnt );
+	idx_DEBUG_printinvindices(iarr, (uint) nindices);
+	free(iarr);
+	free(icnt);
 
 	return 1;
 }
@@ -543,16 +543,16 @@ idx_DEBUG_print ( int fd )
 
 
 int
-DEBUG_displayallsessions( int fd, invt_seshdr_t *hdr, uint ref,
+DEBUG_displayallsessions(int fd, invt_seshdr_t *hdr, uint ref,
 			  invt_pr_ctx_t *prctx)
 {
 	inv_session_t *ses;
-	if ( stobj_make_invsess( fd, &ses, hdr ) < 1 )
+	if (stobj_make_invsess(fd, &ses, hdr) < 1)
 		return -1;
 
-	DEBUG_sessionprint( ses, ref, prctx);
-	free( ses->s_streams );
-	free( ses );
+	DEBUG_sessionprint(ses, ref, prctx);
+	free(ses->s_streams);
+	free(ses);
 
 	return 0;
 }
diff --git a/inventory/inv_mgr.c b/inventory/inv_mgr.c
index f175c02..078798f 100644
--- a/inventory/inv_mgr.c
+++ b/inventory/inv_mgr.c
@@ -45,33 +45,33 @@
 /*----------------------------------------------------------------------*/
 
 int
-init_idb( void *pred, inv_predicate_t bywhat, inv_oflag_t forwhat,
-	  inv_idbtoken_t *tok )
+init_idb(void *pred, inv_predicate_t bywhat, inv_oflag_t forwhat,
+	  inv_idbtoken_t *tok)
 {
-	char fname[ INV_STRLEN ];
-	char uuname[ INV_STRLEN ];
+	char fname[INV_STRLEN];
+	char uuname[INV_STRLEN];
 	int fd;
 
 	*tok = INV_TOKEN_NULL;
 	/* make sure INV_DIRPATH exists, and is writable */
-	if ( make_invdirectory( forwhat ) < 0 )
+	if (make_invdirectory(forwhat) < 0)
 		return I_DONE;
 
 	/* come up with the unique file suffix that refers to this
 	   filesystem */
-	if ( fstab_get_fname( pred, uuname, bywhat, forwhat ) < 0 ) {
+	if (fstab_get_fname(pred, uuname, bywhat, forwhat) < 0) {
 		return I_DONE;
 	}
 
-	( void )strcpy( fname, uuname );
-	strcat ( fname, INV_INVINDEX_PREFIX );
+	(void)strcpy(fname, uuname);
+	strcat (fname, INV_INVINDEX_PREFIX);
 
 	/* first check if the inv_index file exists: if not create it */
-	if ( ( fd = open( fname, INV_OFLAG(forwhat) ) ) == -1 ) {
+	if ((fd = open(fname, INV_OFLAG(forwhat)) ) == -1) {
 		if (errno != ENOENT) {
-			INV_PERROR ( fname );
+			INV_PERROR (fname);
 		} else if (forwhat == INV_SEARCH_N_MOD) {
-			*tok = idx_create( fname, forwhat );
+			*tok = idx_create(fname, forwhat);
 		} else {
 			/* this happens when the inv is empty and the user
 			   wants to do a search. this is legal - not an error */
@@ -89,12 +89,12 @@ init_idb( void *pred, inv_predicate_t bywhat, inv_oflag_t forwhat,
 
 
 inv_idbtoken_t
-get_token( int invfd, int stobjfd  )
+get_token(int invfd, int stobjfd)
 {
 	invt_desc_entry_t *desc;
 
 	desc = (invt_desc_entry_t *) malloc
-		( sizeof( invt_desc_entry_t ) );
+		(sizeof(invt_desc_entry_t) );
 
 	desc->d_invindex_fd = invfd;
 	desc->d_stobj_fd  = stobjfd;
@@ -110,19 +110,19 @@ get_token( int invfd, int stobjfd  )
 
 
 void
-destroy_token( inv_idbtoken_t tok )
+destroy_token(inv_idbtoken_t tok)
 {
-	free ( (invt_desc_entry_t *) tok );
+	free ((invt_desc_entry_t *) tok);
 }
 
 
 
 inv_sestoken_t
-get_sesstoken( inv_idbtoken_t tok )
+get_sesstoken(inv_idbtoken_t tok)
 {
 	inv_sestoken_t stok;
 
-	stok = (inv_sestoken_t) malloc( sizeof( invt_sesdesc_entry_t ) );
+	stok = (inv_sestoken_t) malloc(sizeof(invt_sesdesc_entry_t) );
 	stok->sd_invtok = tok;
 	stok->sd_session_off = stok->sd_sesshdr_off = -1;
 	stok->sd_sesstime = (time32_t) 0;
@@ -159,31 +159,31 @@ invmgr_query_all_sessions (
 	*outarg = NULL;
 	assert(inarg);
 
-	fd = fstab_getall( &arr, &cnt, &numfs, forwhat );
+	fd = fstab_getall(&arr, &cnt, &numfs, forwhat);
 	/* special case missing file: ok, outarg says zero */
-	if ( fd < 0 && errno == ENOENT ) {
+	if (fd < 0 && errno == ENOENT) {
 		return BOOL_TRUE;
 	}
-	if ( fd < 0 || numfs <= 0 ) {
-		mlog( MLOG_NORMAL | MLOG_INV, _("INV: Error in fstab\n") );
+	if (fd < 0 || numfs <= 0) {
+		mlog(MLOG_NORMAL | MLOG_INV, _("INV: Error in fstab\n"));
 		return ret;
 	}
 
-	close( fd );
+	close(fd);
 
-	for ( i = 0; i < numfs; i++) {
-		if ( fstab_get_fname( &arr[i].ft_uuid, fname,
+	for (i = 0; i < numfs; i++) {
+		if (fstab_get_fname(&arr[i].ft_uuid, fname,
 				     (inv_predicate_t)INV_BY_UUID,
-				     forwhat) < 0 ) {
-			mlog( MLOG_NORMAL | MLOG_INV, _(
+				     forwhat) < 0) {
+			mlog(MLOG_NORMAL | MLOG_INV, _(
 			     "INV: Cant get inv-name for uuid\n")
 			     );
 			continue;
 		}
-		strcat( fname, INV_INVINDEX_PREFIX );
-		invfd = open( fname, INV_OFLAG(forwhat) );
-		if ( invfd < 0 ) {
-			mlog( MLOG_NORMAL | MLOG_INV, _(
+		strcat(fname, INV_INVINDEX_PREFIX);
+		invfd = open(fname, INV_OFLAG(forwhat));
+		if (invfd < 0) {
+			mlog(MLOG_NORMAL | MLOG_INV, _(
 			     "INV: Open failed on %s\n"),
 			     fname
 			     );
@@ -216,7 +216,7 @@ invmgr_query_all_sessions (
 /*----------------------------------------------------------------------*/
 /* search_invt                                                          */
 /*                                                                      */
-/* Used by the toplevel (inv layer ) to do common searches on the inven-*/
+/* Used by the toplevel (inv layer) to do common searches on the inven-*/
 /* tory. Caller supplies a callback routine that performs the real      */
 /* comparison/check.                                                    */
 /*----------------------------------------------------------------------*/
@@ -243,17 +243,17 @@ search_invt(
 	 * if no session found, the caller will expect to see
 	 * NULL.
 	 */
-	*( char ** )buf = NULL;
+	*(char **)buf = NULL;
 
-	if ( ( nindices = GET_ALLHDRS_N_CNTS( invfd, (void **)&iarr,
+	if ((nindices = GET_ALLHDRS_N_CNTS(invfd, (void **)&iarr,
 					      (void **)&icnt,
-					      sizeof( invt_entry_t ),
-					      sizeof( invt_counter_t ))
-	      ) <= 0 ) {
+					      sizeof(invt_entry_t),
+					      sizeof(invt_counter_t))
+	      ) <= 0) {
 		return -1;
 	}
 
-	free( icnt );
+	free(icnt);
 
 	/* we need to get all the invindex headers and seshdrs in reverse
 	   order */
@@ -263,25 +263,25 @@ search_invt(
 		invt_seshdr_t		*harr = NULL;
 		bool_t                  found;
 
-		fd = open (iarr[i].ie_filename, O_RDONLY );
+		fd = open (iarr[i].ie_filename, O_RDONLY);
 		if (fd < 0) {
-			INV_PERROR( iarr[i].ie_filename );
+			INV_PERROR(iarr[i].ie_filename);
 			continue;
 		}
-		INVLOCK( fd, LOCK_SH );
+		INVLOCK(fd, LOCK_SH);
 
 		/* Now see if we can find the session we're looking for */
-		if (( nsess = GET_ALLHDRS_N_CNTS_NOLOCK( fd, (void **)&harr,
+		if ((nsess = GET_ALLHDRS_N_CNTS_NOLOCK(fd, (void **)&harr,
 						  (void **)&scnt,
-						  sizeof( invt_seshdr_t ),
-						 sizeof( invt_sescounter_t ))
-		     ) < 0 ) {
-			INV_PERROR( iarr[i].ie_filename );
-			INVLOCK( fd, LOCK_UN );
-			close( fd );
+						  sizeof(invt_seshdr_t),
+						 sizeof(invt_sescounter_t))
+		     ) < 0) {
+			INV_PERROR(iarr[i].ie_filename);
+			INVLOCK(fd, LOCK_UN);
+			close(fd);
 			continue;
 		}
-		free ( scnt );
+		free (scnt);
 
 		for (j = nsess - 1; j >= 0; j--) {
 			invt_session_t ses;
@@ -311,18 +311,18 @@ search_invt(
 			}
 
 			found = (* do_chkcriteria)(fd, &harr[j], arg, buf);
-			if (! found ) continue;
+			if (! found) continue;
 
 			/* we found what we need; just return */
-			INVLOCK( fd, LOCK_UN );
-			close( fd );
-			free( harr );
+			INVLOCK(fd, LOCK_UN);
+			close(fd);
+			free(harr);
 
 			return found; /* == -1 or 1 */
 		}
 
-		INVLOCK( fd, LOCK_UN );
-		close( fd );
+		INVLOCK(fd, LOCK_UN);
+		close(fd);
 	}
 
 	return 0;
@@ -353,66 +353,66 @@ invmgr_inv_print(
 		return 0;
 
 
-	if ( ( nindices = GET_ALLHDRS_N_CNTS( invfd, (void **)&iarr,
+	if ((nindices = GET_ALLHDRS_N_CNTS(invfd, (void **)&iarr,
 					      (void **)&icnt,
-					      sizeof( invt_entry_t ),
-					      sizeof( invt_counter_t ))
-	      ) <= 0 ) {
+					      sizeof(invt_entry_t),
+					      sizeof(invt_counter_t))
+	      ) <= 0) {
 		return -1;
 	}
 
-	free( icnt );
+	free(icnt);
 
 	if (prctx->invidx) {
-		idx_DEBUG_printinvindices( iarr, (uint) nindices );
+		idx_DEBUG_printinvindices(iarr, (uint) nindices);
 		free(iarr);
 		return (0);
 	}
 
 
 
-	for ( i = 0; i < nindices; i++ ) {
+	for (i = 0; i < nindices; i++) {
 		int 			nsess;
 		invt_sescounter_t 	*scnt = NULL;
 		invt_seshdr_t		*harr = NULL;
 		int                     s;
 
-		fd = open (iarr[i].ie_filename, O_RDONLY );
+		fd = open (iarr[i].ie_filename, O_RDONLY);
 		if (fd < 0) {
-			INV_PERROR( iarr[i].ie_filename );
+			INV_PERROR(iarr[i].ie_filename);
 			continue;
 		}
-		INVLOCK( fd, LOCK_SH );
+		INVLOCK(fd, LOCK_SH);
 
 		/* Now see if we can find the session we're looking for */
-		if (( nsess = GET_ALLHDRS_N_CNTS_NOLOCK( fd, (void **)&harr,
+		if ((nsess = GET_ALLHDRS_N_CNTS_NOLOCK(fd, (void **)&harr,
 						  (void **)&scnt,
-						  sizeof( invt_seshdr_t ),
-						 sizeof( invt_sescounter_t ))
-		     ) < 0 ) {
-			INV_PERROR( iarr[i].ie_filename );
-			INVLOCK( fd, LOCK_UN );
-			close( fd );
+						  sizeof(invt_seshdr_t),
+						 sizeof(invt_sescounter_t))
+		     ) < 0) {
+			INV_PERROR(iarr[i].ie_filename);
+			INVLOCK(fd, LOCK_UN);
+			close(fd);
 			continue;
 		}
-		free ( scnt );
-		for( s = 0; s < nsess; s++ ) {
+		free (scnt);
+		for(s = 0; s < nsess; s++) {
 			/* fd is kept locked until we return from the
 			   callback routine */
 
 			/* Check to see if this session has been pruned
 			 * by xfsinvutil before returning it.
 			 */
-			if ( harr[s].sh_pruned ) {
+			if (harr[s].sh_pruned) {
 				continue;
 			}
 
-			(void)DEBUG_displayallsessions( fd, &harr[ s ],
+			(void)DEBUG_displayallsessions(fd, &harr[s],
 						        ref++, prctx);
 		}
 
-		INVLOCK( fd, LOCK_UN );
-		close( fd );
+		INVLOCK(fd, LOCK_UN);
+		close(fd);
 	}
 
 	free (iarr);
@@ -441,42 +441,42 @@ invmgr_inv_check(
 	if (invfd == I_EMPTYINV)
 		return 0;
 
-	if ( ( nindices = GET_ALLHDRS_N_CNTS( invfd, (void **)&iarr,
+	if ((nindices = GET_ALLHDRS_N_CNTS(invfd, (void **)&iarr,
 					      (void **)&icnt,
-					      sizeof( invt_entry_t ),
-					      sizeof( invt_counter_t ))
-	      ) <= 0 ) {
+					      sizeof(invt_entry_t),
+					      sizeof(invt_counter_t))
+	      ) <= 0) {
 		return -1;
 	}
 
-	free( icnt );
+	free(icnt);
 
 
-	for ( i = 0; i < nindices; i++ ) {
+	for (i = 0; i < nindices; i++) {
 		int 			nsess;
 		invt_sescounter_t 	*scnt = NULL;
 		invt_seshdr_t		*harr = NULL;
 		int                     s;
 
-		fd = open (iarr[i].ie_filename, O_RDONLY );
+		fd = open (iarr[i].ie_filename, O_RDONLY);
 		if (fd < 0) {
-			INV_PERROR( iarr[i].ie_filename );
+			INV_PERROR(iarr[i].ie_filename);
 			continue;
 		}
-		INVLOCK( fd, LOCK_SH );
+		INVLOCK(fd, LOCK_SH);
 
 		/* Now see if we can find the session we're looking for */
-		if (( nsess = GET_ALLHDRS_N_CNTS_NOLOCK( fd, (void **)&harr,
+		if ((nsess = GET_ALLHDRS_N_CNTS_NOLOCK(fd, (void **)&harr,
 						  (void **)&scnt,
-						  sizeof( invt_seshdr_t ),
-						 sizeof( invt_sescounter_t ))
-		     ) < 0 ) {
-			INV_PERROR( iarr[i].ie_filename );
-			INVLOCK( fd, LOCK_UN );
-			close( fd );
+						  sizeof(invt_seshdr_t),
+						 sizeof(invt_sescounter_t))
+		     ) < 0) {
+			INV_PERROR(iarr[i].ie_filename);
+			INVLOCK(fd, LOCK_UN);
+			close(fd);
 			continue;
 		}
-		free ( scnt );
+		free (scnt);
 
 		if ((iarr[i].ie_timeperiod.tp_start != harr[0].sh_time) ||
 		    (iarr[i].ie_timeperiod.tp_end != harr[nsess-1].sh_time)) {
@@ -485,7 +485,7 @@ invmgr_inv_check(
 			       i+1,
 			       iarr[i].ie_timeperiod.tp_start,
 			       iarr[i].ie_timeperiod.tp_end);
-			for( s = 0; s < nsess; s++ ) {
+			for(s = 0; s < nsess; s++) {
 				printf(_("tm (%d)\t%d\n"), s, harr[s].sh_time);
 			}
 		}
@@ -493,8 +493,8 @@ invmgr_inv_check(
 			printf(_("INV: Check %d out of %d succeeded\n"),
 			       i+1, nindices);
 		}
-		INVLOCK( fd, LOCK_UN );
-		close( fd );
+		INVLOCK(fd, LOCK_UN);
+		close(fd);
 	}
 
 	return 0;
@@ -509,20 +509,20 @@ invmgr_inv_check(
 
 /* ARGSUSED */
 bool_t
-tm_level_lessthan( int fd, invt_seshdr_t *hdr, void *arg,
-		   void **tm )
+tm_level_lessthan(int fd, invt_seshdr_t *hdr, void *arg,
+		   void **tm)
 {
 	u_char level = *(u_char *)arg;
 	*tm = NULL;
-	if ( IS_PARTIAL_SESSION( hdr ) )
+	if (IS_PARTIAL_SESSION(hdr) )
 		return 0;
-	if (hdr->sh_level < level ) {
+	if (hdr->sh_level < level) {
 #ifdef INVT_DEBUG
-		mlog( MLOG_DEBUG | MLOG_INV, "$ found level %d < %d\n", hdr->sh_level,
-		     level );
+		mlog(MLOG_DEBUG | MLOG_INV, "$ found level %d < %d\n", hdr->sh_level,
+		     level);
 #endif
-		*tm = calloc( 1, sizeof( time32_t ) );
-		memcpy( *tm, &hdr->sh_time, sizeof( time32_t ) );
+		*tm = calloc(1, sizeof(time32_t) );
+		memcpy(*tm, &hdr->sh_time, sizeof(time32_t) );
 		return 1;
 	}
 	return 0;
@@ -538,19 +538,19 @@ tm_level_lessthan( int fd, invt_seshdr_t *hdr, void *arg,
 /*----------------------------------------------------------------------*/
 
 bool_t
-lastsess_level_lessthan( int fd, invt_seshdr_t *hdr, void *arg,
-			 void **buf )
+lastsess_level_lessthan(int fd, invt_seshdr_t *hdr, void *arg,
+			 void **buf)
 {
 	u_char level = *(u_char *)arg;
 	*buf = NULL;
-	if ( IS_PARTIAL_SESSION( hdr ) )
+	if (IS_PARTIAL_SESSION(hdr) )
 		return 0;
-	if (hdr->sh_level < level ) {
+	if (hdr->sh_level < level) {
 #ifdef INVT_DEBUG
-		mlog( MLOG_DEBUG | MLOG_INV, "$ found (ses) level %d < %d \n",
-		     hdr->sh_level, level );
+		mlog(MLOG_DEBUG | MLOG_INV, "$ found (ses) level %d < %d \n",
+		     hdr->sh_level, level);
 #endif
-		return stobj_make_invsess( fd, (inv_session_t **) buf, hdr );
+		return stobj_make_invsess(fd, (inv_session_t **) buf, hdr);
 	}
 	return 0;
 
@@ -565,19 +565,19 @@ lastsess_level_lessthan( int fd, invt_seshdr_t *hdr, void *arg,
 /*----------------------------------------------------------------------*/
 
 bool_t
-lastsess_level_equalto( int fd, invt_seshdr_t *hdr,
-		       void *arg, void **buf )
+lastsess_level_equalto(int fd, invt_seshdr_t *hdr,
+		       void *arg, void **buf)
 {
 	u_char level = *(u_char *)arg;
 	*buf = NULL;
-	if ( IS_PARTIAL_SESSION( hdr ) )
+	if (IS_PARTIAL_SESSION(hdr) )
 		return 0;
-	if (hdr->sh_level == level ) {
+	if (hdr->sh_level == level) {
 #ifdef INVT_DEBUG
-	mlog( MLOG_DEBUG | MLOG_INV, "$ found (ses) level %d == %d \n", hdr->sh_level,
-	     level );
+	mlog(MLOG_DEBUG | MLOG_INV, "$ found (ses) level %d == %d \n", hdr->sh_level,
+	     level);
 #endif
-		return stobj_make_invsess( fd, (inv_session_t **) buf, hdr );
+		return stobj_make_invsess(fd, (inv_session_t **) buf, hdr);
 	}
 	return 0;
 
@@ -596,7 +596,7 @@ lastsess_level_equalto( int fd, invt_seshdr_t *hdr,
 /* this is used in reconstructing the database.                         */
 /*----------------------------------------------------------------------*/
 bool_t
-insert_session( invt_sessinfo_t *s)
+insert_session(invt_sessinfo_t *s)
 {
 	inv_idbtoken_t tok = INV_TOKEN_NULL;
 	int invfd, stobjfd = -1;
@@ -605,21 +605,21 @@ insert_session( invt_sessinfo_t *s)
 	inv_oflag_t       forwhat = INV_SEARCH_N_MOD;
 
 	/* initialize the inventory */
-	if ( ( invfd = init_idb ( (void *) s->ses->s_fsid,
+	if ((invfd = init_idb ((void *) s->ses->s_fsid,
 				  (inv_predicate_t) INV_BY_UUID,
  				  forwhat,
-				  &tok ) ) < 0 ) {
-		if ( tok == INV_TOKEN_NULL ) {
+				  &tok) ) < 0) {
+		if (tok == INV_TOKEN_NULL) {
 #ifdef INVT_DEBUG
-			mlog( MLOG_DEBUG | MLOG_INV, "INV: insert_session: init_db "
-			      "failed\n" );
+			mlog(MLOG_DEBUG | MLOG_INV, "INV: insert_session: init_db "
+			      "failed\n");
 #endif
 			return BOOL_FALSE;
 		}
 
 		invfd = tok->d_invindex_fd;
-		close( tok->d_stobj_fd );
-		destroy_token( tok );
+		close(tok->d_stobj_fd);
+		destroy_token(tok);
 	}
 
 	/* at this point we know that invindex has at least one entry
@@ -629,33 +629,33 @@ insert_session( invt_sessinfo_t *s)
 	   contain this session, it suffices to sequentially search the
 	   inventory indices of this filesystem for the particular invt-entry
 	 */
-	INVLOCK( invfd, LOCK_EX );
+	INVLOCK(invfd, LOCK_EX);
 	idx.invfd = invfd;
-	stobjfd = idx_find_stobj( &idx, s->seshdr->sh_time );
+	stobjfd = idx_find_stobj(&idx, s->seshdr->sh_time);
 	if (stobjfd < 0) {
-		INVLOCK( invfd, LOCK_UN );
-		free( idx.icnt );
-		free( idx.iarr );
+		INVLOCK(invfd, LOCK_UN);
+		free(idx.icnt);
+		free(idx.iarr);
 		return BOOL_FALSE;
 	}
 
 	/* Now put the session in the storage-object */
-	INVLOCK( stobjfd, LOCK_EX );
-	if ( ( stobj_insert_session( &idx, stobjfd, s ) < 0 ) ||
-		( idx_recons_time ( s->seshdr->sh_time, &idx ) < 0 ) )
+	INVLOCK(stobjfd, LOCK_EX);
+	if ((stobj_insert_session(&idx, stobjfd, s) < 0) ||
+		(idx_recons_time (s->seshdr->sh_time, &idx) < 0) )
 			ret = BOOL_TRUE;
 
-	INVLOCK( stobjfd, LOCK_UN );
-	INVLOCK( invfd, LOCK_UN );
+	INVLOCK(stobjfd, LOCK_UN);
+	INVLOCK(invfd, LOCK_UN);
 
-	free( idx.icnt );
-	free( idx.iarr );
+	free(idx.icnt);
+	free(idx.iarr);
 
 	if (ret) return BOOL_FALSE;
 
 	/* make sure the fstab is uptodate too */
-	if ( fstab_put_entry( &s->ses->s_fsid, s->ses->s_mountpt, s->ses->s_devpath,
-			      forwhat ) < 0 )
+	if (fstab_put_entry(&s->ses->s_fsid, s->ses->s_mountpt, s->ses->s_devpath,
+			      forwhat) < 0)
 		return BOOL_FALSE;
 
 	/* and we are done */
@@ -672,82 +672,82 @@ insert_session( invt_sessinfo_t *s)
 /*----------------------------------------------------------------------*/
 
 int
-make_invdirectory( inv_oflag_t forwhat )
+make_invdirectory(inv_oflag_t forwhat)
 {
 	struct stat64 st;
 	char path[PATH_MAX];
 	char *p;
 
-	p = strcpy( path, INV_DIRPATH );
+	p = strcpy(path, INV_DIRPATH);
 
-	if ( stat64( path, &st ) == 0 )
+	if (stat64(path, &st) == 0)
 		return 1;
 
-	if ( forwhat == INV_SEARCH_ONLY || errno != ENOENT )
+	if (forwhat == INV_SEARCH_ONLY || errno != ENOENT)
 		return -1;
 
 	do {
 		p++;
-		if ( *p == '/' ) {
+		if (*p == '/') {
 			*p = '\0';
-			if ( mkdir( path, (mode_t)0755 ) < 0 ) {
-				if ( errno != EEXIST ) {
-					INV_PERROR( path );
+			if (mkdir(path, (mode_t)0755) < 0) {
+				if (errno != EEXIST) {
+					INV_PERROR(path);
 					return -1;
 				}
 			}
 			*p = '/';
 		}
-	} while ( *p );
+	} while (*p);
 
-	if ( mkdir( path, (mode_t)0755 ) < 0 ) {
-		if ( errno != EEXIST ) {
-			INV_PERROR( path );
+	if (mkdir(path, (mode_t)0755) < 0) {
+		if (errno != EEXIST) {
+			INV_PERROR(path);
 			return -1;
 		}
 	}
 
-	mlog( MLOG_VERBOSE | MLOG_INV, _("%s created\n"), path );
+	mlog(MLOG_VERBOSE | MLOG_INV, _("%s created\n"), path);
 	return 1;
 }
 
 #ifdef NOTDEF
 
 bool_t
-invmgr_lockinit( void )
+invmgr_lockinit(void)
 {
-	if ( invlock_fd == -1 ) {
-		if (( invlock_fd = open( INV_LOCKFILE,
-					O_RDONLY | O_CREAT, S_IRUSR|S_IWUSR )) < 0 ) {
-			INV_PERROR( INV_LOCKFILE );
+	if (invlock_fd == -1) {
+		if ((invlock_fd = open(INV_LOCKFILE,
+					O_RDONLY | O_CREAT, S_IRUSR|S_IWUSR)) < 0) {
+			INV_PERROR(INV_LOCKFILE);
 			return BOOL_FALSE;
 		}
-		fchmod ( invlock_fd, INV_PERMS );
+		fchmod (invlock_fd, INV_PERMS);
 	}
 	return BOOL_TRUE;
 }
 
 
 bool_t
-invmgr_trylock( invt_mode_t mode )
+invmgr_trylock(invt_mode_t mode)
 {
 	int md;
-	assert( invlock_fd >= 0 );
+	assert(invlock_fd >= 0);
 
 	md = (mode == INVT_RECONSTRUCT) ? LOCK_EX: LOCK_SH;
 
-	if (INVLOCK( invlock_fd, md | LOCK_NB ) < 0)
+	if (INVLOCK(invlock_fd, md | LOCK_NB) < 0)
 		return BOOL_FALSE;
 
 	return BOOL_TRUE;
 }
 
 void
-invmgr_unlock( void )
+invmgr_unlock(void)
 {
-	assert( invlock_fd >= 0 );
+	assert(invlock_fd >= 0);
 
-	INVLOCK( invlock_fd, LOCK_UN );
+	INVLOCK(invlock_fd, LOCK_UN);
 
 }
 
diff --git a/inventory/inv_oref.c b/inventory/inv_oref.c
index 56ac5e5..70fc634 100644
--- a/inventory/inv_oref.c
+++ b/inventory/inv_oref.c
@@ -269,7 +269,7 @@ _oref_free(
 	 */
 	OREF_UNLOCK(obj);
 
-	if (OREF_ISRESOLVED(obj, INVT_OTYPE_STOBJ) ){
+	if (OREF_ISRESOLVED(obj, INVT_OTYPE_STOBJ)){
 		if (OREF_ISRESOLVED(obj, INVT_RES_COUNTERS))
 			free((oref)->cu_sescnt);
 		if (OREF_ISRESOLVED(obj, INVT_RES_HDRS))
@@ -311,8 +311,8 @@ oref_resolve(
 	inv_predicate_t bywhat,
 	void 		*pred)
 {
-	char 		fname[ INV_STRLEN ];
-	char 		uuname[ INV_STRLEN ];
+	char 		fname[INV_STRLEN];
+	char 		uuname[INV_STRLEN];
 	int 		fd;
 	invt_oref_t	*stobj;
 	int		index;
@@ -358,13 +358,13 @@ oref_resolve(
 		return INV_ERR;
 	}
 
-	/* create another storage object ( and, an inv_index entry for it
-	   too ) if we've filled this one up */
+	/* create another storage object (and, an inv_index entry for it
+	   too) if we've filled this one up */
 	if (OREF_CNT_CURNUM(stobj) >= OREF_CNT_MAXNUM(stobj)) {
 		int 	rval;
 #ifdef INVT_DEBUG
-		mlog( MLOG_DEBUG | MLOG_INV, "$ INV: creating a new storage obj & "
-		      "index entry. \n" );
+		mlog(MLOG_DEBUG | MLOG_INV, "$ INV: creating a new storage obj & "
+		      "index entry. \n");
 #endif
 		/* Close(), Destroy() and mark unresolved */
 		OREF_UNRESOLVE_CHILD(invidx);
@@ -405,12 +405,12 @@ oref_resolve_child(
 
 	/* at this point we know that there should be at least one invindex
 	   entry present */
-	assert ( ent != NULL );
-	assert ( ent->ie_filename );
+	assert (ent != NULL);
+	assert (ent->ie_filename);
 
-	fd = open( ent->ie_filename, O_RDWR );
-	if ( fd < 0 ) {
-		INV_PERROR( ent->ie_filename );
+	fd = open(ent->ie_filename, O_RDWR);
+	if (fd < 0) {
+		INV_PERROR(ent->ie_filename);
 		return INV_ERR;
 	}
 
@@ -432,8 +432,8 @@ oref_resolve_new_invidx(
 	int stobjfd, fd;
 	inv_idbtoken_t tok;
 
-	if ((fd = open ( fname , O_RDWR | O_CREAT, S_IRUSR|S_IWUSR ) ) < 0 ) {
-		INV_PERROR ( fname );
+	if ((fd = open (fname , O_RDWR | O_CREAT, S_IRUSR|S_IWUSR) ) < 0) {
+		INV_PERROR (fname);
 		return INV_ERR;
 	}
 	invidx->fd = fd;
@@ -441,7 +441,7 @@ oref_resolve_new_invidx(
 	fchmod(fd, INV_PERMS);
 
 #ifdef INVT_DEBUG
-	mlog( MLOG_NITTY | MLOG_INV, "creating InvIndex %s\n", fname);
+	mlog(MLOG_NITTY | MLOG_INV, "creating InvIndex %s\n", fname);
 #endif
 	/* create the new stobj as its first entry */
 	rval = oref_resolve_new_stobj(invidx, IS_EMPTY);
@@ -467,15 +467,15 @@ oref_resolve_new_stobj(
 
 	assert(OREF_ISLOCKED(invidx));
 
-	memset ( &ent, 0, sizeof( ent ) );
+	memset (&ent, 0, sizeof(ent) );
 	stobj = calloc(1, sizeof(invt_oref_t));
 	OREF_SET_CHILD(invidx, stobj);
 
 	/* initialize the start and end times to be the same */
 	ent.ie_timeperiod.tp_start = ent.ie_timeperiod.tp_end = (time32_t)0;
-	stobj_makefname( ent.ie_filename );
+	stobj_makefname(ent.ie_filename);
 
-	if ( firstentry ) {
+	if (firstentry) {
 		invt_counter_t *cnt;
 		cnt = malloc(sizeof(invt_counter_t));
 
@@ -483,8 +483,8 @@ oref_resolve_new_stobj(
 		cnt->ic_curnum = 1;
 		cnt->ic_vernum = INV_VERSION;
 
-		fd = stobj_create( ent.ie_filename );
-		if ( fd < 0 ) {
+		fd = stobj_create(ent.ie_filename);
+		if (fd < 0) {
 			free(cnt);
 			return INV_ERR;
 		}
@@ -501,8 +501,8 @@ oref_resolve_new_stobj(
 			return INV_ERR;
 
 		/* create the new storage object */
-		fd = stobj_create( ent.ie_filename );
-		if ( fd < 0 ) {
+		fd = stobj_create(ent.ie_filename);
+		if (fd < 0) {
 			return -1;
 		}
 
@@ -516,7 +516,7 @@ oref_resolve_new_stobj(
 			return INV_ERR;
 
 	}
-	tok = get_token( invfd, fd );
+	tok = get_token(invfd, fd);
 	tok->d_invindex_off = IDX_HDR_OFFSET(OREF_CNT_CURNUM(invidx) - 1);
 	tok->d_update_flag |= NEW_INVINDEX;
 
diff --git a/inventory/inv_oref.h b/inventory/inv_oref.h
index 0061722..836ce82 100644
--- a/inventory/inv_oref.h
+++ b/inventory/inv_oref.h
@@ -120,7 +120,7 @@ typedef struct invt_oref {
  * For locking/unlocking orefs - mode { LOCK_SH, LOCK_EX, LOCK_UN }
  */
 
-#define OREF_LOCKMODE_EQL(oref, mode) ((oref)->lockflag == mode )
+#define OREF_LOCKMODE_EQL(oref, mode) ((oref)->lockflag == mode)
 #define OREF_ISLOCKED(oref)	      ((oref)->lockflag == 0 ||
 				       (oref)->lockflag == LOCK_UN)
 
diff --git a/inventory/inv_priv.h b/inventory/inv_priv.h
index ed50782..7199920 100644
--- a/inventory/inv_priv.h
+++ b/inventory/inv_priv.h
@@ -47,11 +47,11 @@
 #define FSTAB_UPDATED		1
 #define NEW_INVINDEX		2
 
-/* session flags ( seshdr.sh_flag ) */
+/* session flags (seshdr.sh_flag) */
 #define INVT_PARTIAL		(uint)0x0001
 #define INVT_RESUMED            (uint)0x0002
 
-/* media file flags ( mfile.mf_flag ) */
+/* media file flags (mfile.mf_flag) */
 #define INVT_MFILE_GOOD         (u_char)0x01
 #define INVT_MFILE_INVDUMP      (u_char)0x02
 
@@ -60,7 +60,7 @@
 #define INVT_DOLOCK		BOOL_TRUE
 #define INVT_DONTLOCK		BOOL_FALSE
 
-#define INVLOCK( fd, m )	flock( fd, m )
+#define INVLOCK(fd, m)	flock(fd, m)
 
 /* return values */
 #define INV_OK			(int) 1
@@ -75,27 +75,27 @@
 
 #define INV_PERMS               S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH
 
-#define IS_WITHIN(ttpe, tm)	( tm >= (ttpe)->tp_start && \
-				  tm <= (ttpe)->tp_end )
-#define IDX_HDR_OFFSET(n) 	(off64_t) ( sizeof( invt_entry_t ) * \
+#define IS_WITHIN(ttpe, tm)	(tm >= (ttpe)->tp_start && \
+				  tm <= (ttpe)->tp_end)
+#define IDX_HDR_OFFSET(n) 	(off64_t) (sizeof(invt_entry_t) * \
 					   (size_t) (n)\
-					   + sizeof( invt_counter_t ) )
-#define STOBJ_OFFSET( nhdrs, nsess ) (off64_t) ( \
-			       sizeof( invt_sescounter_t ) + \
-			       (size_t) nhdrs * sizeof( invt_seshdr_t ) + \
-			       (size_t) nsess * sizeof( invt_session_t ) )
-
-#define STREQL( n,m )		( strcmp((n),(m)) == 0 )
-#define UUID_EQL( n,m,t )	( uuid_compare( n, m, t ) == 0 )
-#define IS_PARTIAL_SESSION( h ) ( (h)->sh_flag & INVT_PARTIAL )
-#define IS_RESUMED_SESSION( h ) ( (h)->sh_flag & INVT_RESUMED )
-#define SC_EOF_INITIAL_POS	(off64_t) (sizeof( invt_sescounter_t ) + \
+					   + sizeof(invt_counter_t) )
+#define STOBJ_OFFSET(nhdrs, nsess) (off64_t) (\
+			       sizeof(invt_sescounter_t) + \
+			       (size_t) nhdrs * sizeof(invt_seshdr_t) + \
+			       (size_t) nsess * sizeof(invt_session_t) )
+
+#define STREQL(n,m)		(strcmp((n),(m)) == 0)
+#define UUID_EQL(n,m,t)	(uuid_compare(n, m, t) == 0)
+#define IS_PARTIAL_SESSION(h) ((h)->sh_flag & INVT_PARTIAL)
+#define IS_RESUMED_SESSION(h) ((h)->sh_flag & INVT_RESUMED)
+#define SC_EOF_INITIAL_POS	(off64_t) (sizeof(invt_sescounter_t) + \
 					 INVT_STOBJ_MAXSESSIONS * \
-					 ( sizeof( invt_seshdr_t ) + \
-					   sizeof( invt_session_t ) ) )
+					 (sizeof(invt_seshdr_t) + \
+					   sizeof(invt_session_t) ))
 
-#define INV_PERROR(s)  	mlog( MLOG_NORMAL,"INV: %s %s\n", s,strerror(errno) )
-#define INV_OFLAG(f)    ( f == INV_SEARCH_ONLY ) ? O_RDONLY: O_RDWR
+#define INV_PERROR(s)  	mlog(MLOG_NORMAL,"INV: %s %s\n", s,strerror(errno))
+#define INV_OFLAG(f)    (f == INV_SEARCH_ONLY) ? O_RDONLY: O_RDWR
 
 /*----------------------------------------------------------------------*/
 /* On Disk Data Structures                                              */
@@ -200,8 +200,8 @@ typedef struct invt_sescounter {
 	INVT_COUNTER_FIELDS
 	off64_t	       ic_eof;   /* current end of the file, where the next
 				 media file or stream will be written to */
-	char 	       ic_padding[0x20 - ( INVT_COUNTER_FIELDS_SIZE +
-					   sizeof( off64_t) )];
+	char 	       ic_padding[0x20 - (INVT_COUNTER_FIELDS_SIZE +
+					   sizeof(off64_t))];
 } invt_sescounter_t;
 
 
@@ -297,41 +297,41 @@ typedef struct invt_pr_ctx {
 typedef bool_t (*search_callback_t) (int, invt_seshdr_t *, void *, void *);
 
 
-#define GET_REC( fd, buf, sz, off )  \
-                 get_invtrecord( fd, buf, sz, off, INVT_DOLOCK )
+#define GET_REC(fd, buf, sz, off)  \
+                 get_invtrecord(fd, buf, sz, off, INVT_DOLOCK)
 
-#define GET_REC_NOLOCK( fd, buf, sz, off )  \
-                 get_invtrecord( fd, buf, sz, off, INVT_DONTLOCK )
+#define GET_REC_NOLOCK(fd, buf, sz, off)  \
+                 get_invtrecord(fd, buf, sz, off, INVT_DONTLOCK)
 
-#define GET_ALLHDRS_N_CNTS( fd, h, c, hsz, csz ) \
-                 get_headerinfo( fd, h, c, hsz, csz, INVT_DOLOCK )
+#define GET_ALLHDRS_N_CNTS(fd, h, c, hsz, csz) \
+                 get_headerinfo(fd, h, c, hsz, csz, INVT_DOLOCK)
 
-#define GET_ALLHDRS_N_CNTS_NOLOCK( fd, h, c, hsz, csz ) \
-                 get_headerinfo( fd, h, c, hsz, csz, INVT_DONTLOCK )
+#define GET_ALLHDRS_N_CNTS_NOLOCK(fd, h, c, hsz, csz) \
+                 get_headerinfo(fd, h, c, hsz, csz, INVT_DONTLOCK)
 
-#define PUT_REC( fd, buf, sz, off )  \
-                 put_invtrecord( fd, buf, sz, off, INVT_DOLOCK )
+#define PUT_REC(fd, buf, sz, off)  \
+                 put_invtrecord(fd, buf, sz, off, INVT_DOLOCK)
 
-#define PUT_REC_NOLOCK( fd, buf, sz, off )  \
-                 put_invtrecord( fd, buf, sz, off, INVT_DONTLOCK )
+#define PUT_REC_NOLOCK(fd, buf, sz, off)  \
+                 put_invtrecord(fd, buf, sz, off, INVT_DONTLOCK)
 
 
-#define GET_COUNTERS( fd, cnt ) get_counters( fd, (void **)(cnt), \
-					      sizeof(invt_counter_t) )
-#define GET_SESCOUNTERS( fd, cnt ) get_counters( fd, (void **)(cnt), \
-						sizeof(invt_sescounter_t) )
+#define GET_COUNTERS(fd, cnt) get_counters(fd, (void **)(cnt), \
+					      sizeof(invt_counter_t))
+#define GET_SESCOUNTERS(fd, cnt) get_counters(fd, (void **)(cnt), \
+						sizeof(invt_sescounter_t))
 
-#define PUT_COUNTERS( fd, cnt ) PUT_REC_NOLOCK( fd, (void *)(cnt), \
-					     sizeof( invt_counter_t ), \
-					     (off64_t) 0 )
+#define PUT_COUNTERS(fd, cnt) PUT_REC_NOLOCK(fd, (void *)(cnt), \
+					     sizeof(invt_counter_t), \
+					     (off64_t) 0)
 
-#define PUT_SESCOUNTERS( fd, cnt )  PUT_REC_NOLOCK( fd, (void *)(cnt), \
-					     sizeof( invt_sescounter_t ), \
-					     (off64_t) 0 )
+#define PUT_SESCOUNTERS(fd, cnt)  PUT_REC_NOLOCK(fd, (void *)(cnt), \
+					     sizeof(invt_sescounter_t), \
+					     (off64_t) 0)
 
-#define GET_SESHEADERS( fd, hdrs, n ) get_headers( fd, (void**)(hdrs), \
-				   (size_t) ( n * sizeof(invt_seshdr_t ) ),\
-				          sizeof( invt_sescounter_t )  )
+#define GET_SESHEADERS(fd, hdrs, n) get_headers(fd, (void**)(hdrs), \
+				   (size_t) (n * sizeof(invt_seshdr_t) ),\
+				          sizeof(invt_sescounter_t)  )
 
 #define GET_ENTRIES(fd, hdrs, n, sz) get_headers(fd, (void**)(hdrs), \
 				   (size_t) (n * sz), sizeof(invt_counter_t))
@@ -345,48 +345,48 @@ typedef bool_t (*search_callback_t) (int, invt_seshdr_t *, void *, void *);
 
 /*----------------------------------------------------------------------*/
 inv_idbtoken_t
-idx_create( char *fname, inv_oflag_t forwhat );
+idx_create(char *fname, inv_oflag_t forwhat);
 
 int
-idx_create_entry( inv_idbtoken_t *tok, int invfd, bool_t firstentry );
+idx_create_entry(inv_idbtoken_t *tok, int invfd, bool_t firstentry);
 
 int
-idx_put_sesstime( inv_sestoken_t tok, bool_t whichtime);
+idx_put_sesstime(inv_sestoken_t tok, bool_t whichtime);
 
 
 int
-idx_find_stobj( invt_idxinfo_t *idx, time32_t tm );
+idx_find_stobj(invt_idxinfo_t *idx, time32_t tm);
 
 uint
-idx_insert_newentry( int fd, int *stobjfd, invt_entry_t *iarr,
+idx_insert_newentry(int fd, int *stobjfd, invt_entry_t *iarr,
 		     invt_counter_t *icnt,
-		     time32_t tm );
+		     time32_t tm);
 int
-idx_put_newentry( invt_idxinfo_t *idx, invt_entry_t *ient );
+idx_put_newentry(invt_idxinfo_t *idx, invt_entry_t *ient);
 
 int
-idx_get_stobj( int invfd, inv_oflag_t forwhat, int *index );
+idx_get_stobj(int invfd, inv_oflag_t forwhat, int *index);
 
 int
-idx_recons_time( time32_t tm, invt_idxinfo_t *idx );
+idx_recons_time(time32_t tm, invt_idxinfo_t *idx);
 
 int
-idx_DEBUG_printinvindices( invt_entry_t *iarr, uint num );
+idx_DEBUG_printinvindices(invt_entry_t *iarr, uint num);
 
 int
-idx_DEBUG_print ( int fd );
+idx_DEBUG_print (int fd);
 
 /*----------------------------------------------------------------------*/
 
 int
-stobj_create( char *fname );
+stobj_create(char *fname);
 
 int
-stobj_create_session( inv_sestoken_t tok, int fd, invt_sescounter_t *sescnt,
-		      invt_session_t *ses, invt_seshdr_t *hdr );
+stobj_create_session(inv_sestoken_t tok, int fd, invt_sescounter_t *sescnt,
+		      invt_session_t *ses, invt_seshdr_t *hdr);
 
 int
-stobj_put_mediafile( inv_stmtoken_t tok, invt_mediafile_t *mf );
+stobj_put_mediafile(inv_stmtoken_t tok, invt_mediafile_t *mf);
 
 off64_t
 stobj_put_session(
@@ -395,73 +395,73 @@ stobj_put_session(
 	invt_session_t *ses,
 	invt_seshdr_t *hdr,
 	invt_stream_t *strms,
-	invt_mediafile_t *mfiles );
+	invt_mediafile_t *mfiles);
 
 int
-stobj_put_streams( int fd, invt_seshdr_t *hdr, invt_session_t *ses,
+stobj_put_streams(int fd, invt_seshdr_t *hdr, invt_session_t *ses,
 		   invt_stream_t *strms,
-		   invt_mediafile_t *mfiles );
+		   invt_mediafile_t *mfiles);
 
 int
-stobj_hdrcmp( const void *h1, const void *h2 );
+stobj_hdrcmp(const void *h1, const void *h2);
 
 int
-stobj_sortheaders( int fd, uint num );
+stobj_sortheaders(int fd, uint num);
 
 uint
-stobj_find_splitpoint( int fd, invt_seshdr_t *harr, uint ns, time32_t tm );
+stobj_find_splitpoint(int fd, invt_seshdr_t *harr, uint ns, time32_t tm);
 
 int
-stobj_split( invt_idxinfo_t *idx, int fd, invt_sescounter_t *sescnt,
-	     invt_sessinfo_t *newsess );
+stobj_split(invt_idxinfo_t *idx, int fd, invt_sescounter_t *sescnt,
+	     invt_sessinfo_t *newsess);
 bool_t
-stobj_replace_session( int fd, invt_sescounter_t *sescnt, invt_session_t *ses,
-		       invt_seshdr_t *hdr, invt_sessinfo_t *newsess );
+stobj_replace_session(int fd, invt_sescounter_t *sescnt, invt_session_t *ses,
+		       invt_seshdr_t *hdr, invt_sessinfo_t *newsess);
 
 int
-stobj_delete_mfile( int fd, inv_stream_t *strm, invt_mediafile_t *mf,
-		    off64_t  mfileoff );
+stobj_delete_mfile(int fd, inv_stream_t *strm, invt_mediafile_t *mf,
+		    off64_t  mfileoff);
 
 bool_t
-stobj_pack_sessinfo( int fd, invt_session_t *ses, invt_seshdr_t *hdr,
-		     void  **bufpp, size_t *bufszp );
+stobj_pack_sessinfo(int fd, invt_session_t *ses, invt_seshdr_t *hdr,
+		     void  **bufpp, size_t *bufszp);
 
 bool_t
 stobj_unpack_sessinfo(
         void              *bufp,
         size_t             bufsz,
-	invt_sessinfo_t   *s );
+	invt_sessinfo_t   *s);
 
 bool_t
-stobj_delete_sessinfo( int fd, invt_sescounter_t *sescnt,
-		       invt_session_t *ses, invt_seshdr_t *hdr );
+stobj_delete_sessinfo(int fd, invt_sescounter_t *sescnt,
+		       invt_session_t *ses, invt_seshdr_t *hdr);
 
 bool_t
-stobj_delete_mobj( int fd, invt_seshdr_t *hdr, void *arg,
-		   void **buf );
+stobj_delete_mobj(int fd, invt_seshdr_t *hdr, void *arg,
+		   void **buf);
 
 int
-stobj_get_sessinfo ( inv_sestoken_t tok, invt_seshdr_t *hdr, invt_session_t *ses );
+stobj_get_sessinfo (inv_sestoken_t tok, invt_seshdr_t *hdr, invt_session_t *ses);
 
 void
-stobj_makefname( char *fname );
+stobj_makefname(char *fname);
 
 int
-stobj_insert_session( invt_idxinfo_t *idx, int fd,
-		      invt_sessinfo_t *s );
+stobj_insert_session(invt_idxinfo_t *idx, int fd,
+		      invt_sessinfo_t *s);
 
 int
-stobj_make_invsess( int fd, inv_session_t **buf, invt_seshdr_t *hdr );
+stobj_make_invsess(int fd, inv_session_t **buf, invt_seshdr_t *hdr);
 
 int
-stobj_copy_invsess( int fd, invt_seshdr_t *hdr, invt_session_t *ses,
+stobj_copy_invsess(int fd, invt_seshdr_t *hdr, invt_session_t *ses,
 		    inv_session_t **buf);
 
 void
-DEBUG_sessionprint( inv_session_t *ses, uint ref, invt_pr_ctx_t *prctx);
+DEBUG_sessionprint(inv_session_t *ses, uint ref, invt_pr_ctx_t *prctx);
 
 void
-DEBUG_sessprint( invt_session_t *ses );
+DEBUG_sessprint(invt_session_t *ses);
 
 bool_t
 stobj_getsession_byuuid(int fd, invt_seshdr_t *hdr, void *sesid, void **buf);
@@ -486,57 +486,57 @@ stobj_convert_sessinfo(inv_session_t **buf, invt_sessinfo_t *sinfo);
 /*----------------------------------------------------------------------*/
 
 int
-fstab_get_fname( void *pred, char *fname, inv_predicate_t bywhat,
-		 inv_oflag_t forwhat );
+fstab_get_fname(void *pred, char *fname, inv_predicate_t bywhat,
+		 inv_oflag_t forwhat);
 
 int
-fstab_put_entry( uuid_t *fsidp, char *mntpt, char *dev, inv_oflag_t forwhat );
+fstab_put_entry(uuid_t *fsidp, char *mntpt, char *dev, inv_oflag_t forwhat);
 
 int
-fstab_getall( invt_fstab_t **arr, invt_counter_t **cnt, int *numfs,
-	      inv_oflag_t forwhat );
+fstab_getall(invt_fstab_t **arr, invt_counter_t **cnt, int *numfs,
+	      inv_oflag_t forwhat);
 
 void
-fstab_DEBUG_print( invt_fstab_t *arr, int num );
+fstab_DEBUG_print(invt_fstab_t *arr, int num);
 
 
 /*----------------------------------------------------------------------*/
 
 int
-get_invtentry( char *fname, time32_t tm, invt_entry_t *buf, size_t bufsz );
+get_invtentry(char *fname, time32_t tm, invt_entry_t *buf, size_t bufsz);
 
 int
-get_invtrecord( int fd, void *buf, size_t bufsz, off64_t off, bool_t dolock );
+get_invtrecord(int fd, void *buf, size_t bufsz, off64_t off, bool_t dolock);
 
 int
-put_invtrecord( int fd, void *buf, size_t bufsz, off64_t off, bool_t dolock );
+put_invtrecord(int fd, void *buf, size_t bufsz, off64_t off, bool_t dolock);
 
 inv_idbtoken_t
-get_token( int fd, int objfd );
+get_token(int fd, int objfd);
 
 void
-destroy_token( inv_idbtoken_t tok );
+destroy_token(inv_idbtoken_t tok);
 
 
 int
-get_headers( int fd, void **hdrs, size_t bufsz, size_t cntsz );
+get_headers(int fd, void **hdrs, size_t bufsz, size_t cntsz);
 
 int
-get_counters( int fd, void **cntpp, size_t sz );
+get_counters(int fd, void **cntpp, size_t sz);
 
 int
-get_sescounters( int fd, invt_sescounter_t **cntpp );
+get_sescounters(int fd, invt_sescounter_t **cntpp);
 
 int
-get_lastheader( int fd, void **ent, size_t hdrsz,  size_t cntsz );
+get_lastheader(int fd, void **ent, size_t hdrsz,  size_t cntsz);
 
 
 inv_sestoken_t
-get_sesstoken( inv_idbtoken_t tok );
+get_sesstoken(inv_idbtoken_t tok);
 
 int
-get_headerinfo( int fd, void **hdrs, void **cnt,
-	        size_t hdrsz, size_t cntsz, bool_t doblock );
+get_headerinfo(int fd, void **hdrs, void **cnt,
+	        size_t hdrsz, size_t cntsz, bool_t doblock);
 
 bool_t
 invmgr_query_all_sessions(uuid_t *fsidp, void *inarg, void **outarg,
@@ -546,42 +546,42 @@ int
 search_invt(uuid_t *fsidp, int invfd, void *arg, void **buf,
 	    search_callback_t do_chkcriteria);
 int
-invmgr_inv_print( int invfd, invt_pr_ctx_t *prctx);
+invmgr_inv_print(int invfd, invt_pr_ctx_t *prctx);
 
 int
-invmgr_inv_check( int invfd );
+invmgr_inv_check(int invfd);
 
 bool_t
-tm_level_lessthan( int fd, invt_seshdr_t *hdr, void *arg,
-		   void **tm );
+tm_level_lessthan(int fd, invt_seshdr_t *hdr, void *arg,
+		   void **tm);
 
 bool_t
-lastsess_level_lessthan( int fd, invt_seshdr_t *hdr,  void *arg,
-			 void **buf );
+lastsess_level_lessthan(int fd, invt_seshdr_t *hdr,  void *arg,
+			 void **buf);
 
 bool_t
-lastsess_level_equalto( int fd, invt_seshdr_t *hdr,  void *arg, void **buf );
+lastsess_level_equalto(int fd, invt_seshdr_t *hdr,  void *arg, void **buf);
 
 int
-DEBUG_displayallsessions( int fd, invt_seshdr_t *hdr, uint ref,
+DEBUG_displayallsessions(int fd, invt_seshdr_t *hdr, uint ref,
 			  invt_pr_ctx_t *prctx);
 
 int
-make_invdirectory( inv_oflag_t forwhat );
+make_invdirectory(inv_oflag_t forwhat);
 
 bool_t
-init_idb( void *pred, inv_predicate_t bywhat, inv_oflag_t forwhat,
-	 inv_idbtoken_t *tok );
+init_idb(void *pred, inv_predicate_t bywhat, inv_oflag_t forwhat,
+	 inv_idbtoken_t *tok);
 
 int
-inv_getopt( int argc, char **argv, invt_pr_ctx_t *prctx);
+inv_getopt(int argc, char **argv, invt_pr_ctx_t *prctx);
 
 bool_t
-insert_session( invt_sessinfo_t *s);
+insert_session(invt_sessinfo_t *s);
 
 /* To reconstruct a complete inventory from dumped inventories */
 extern bool_t
-inv_put_sessioninfo( invt_sessinfo_t *s );
+inv_put_sessioninfo(invt_sessinfo_t *s);
 
 
 #endif
diff --git a/inventory/inv_stobj.c b/inventory/inv_stobj.c
index 25df2fe..235e621 100644
--- a/inventory/inv_stobj.c
+++ b/inventory/inv_stobj.c
@@ -49,67 +49,67 @@
 /* storage object whether or not it has reached its maximum.            */
 /*----------------------------------------------------------------------*/
 int
-stobj_insert_session( invt_idxinfo_t *idx,
+stobj_insert_session(invt_idxinfo_t *idx,
 		      int fd, /* kept locked EX by caller */
-		      invt_sessinfo_t *s )
+		      invt_sessinfo_t *s)
 {
 	invt_sescounter_t *sescnt = NULL;
 
-	if ( GET_SESCOUNTERS( fd, &sescnt ) < 0 ) {
-		INVLOCK( fd, LOCK_UN );
+	if (GET_SESCOUNTERS(fd, &sescnt) < 0) {
+		INVLOCK(fd, LOCK_UN);
 		return -1;
 	}
 
 	/* Check the existing sessions to make sure that we're not
 	   duplicating this session */
-	if ( sescnt->ic_curnum > 0 ) {
+	if (sescnt->ic_curnum > 0) {
 		uint i;
-		invt_session_t	*sessions = calloc( sescnt->ic_curnum,
-				   sizeof( invt_session_t ) );
-		if ( GET_REC_NOLOCK( fd, sessions, sescnt->ic_curnum *
-				     sizeof( invt_session_t ),
-				     (off64_t) ( sizeof( *sescnt ) +
-         		sescnt->ic_maxnum * sizeof( invt_seshdr_t ))) < 0 ) {
-			free ( sescnt );
-			free ( sessions );
+		invt_session_t	*sessions = calloc(sescnt->ic_curnum,
+				   sizeof(invt_session_t) );
+		if (GET_REC_NOLOCK(fd, sessions, sescnt->ic_curnum *
+				     sizeof(invt_session_t),
+				     (off64_t) (sizeof(*sescnt) +
+         		sescnt->ic_maxnum * sizeof(invt_seshdr_t))) < 0) {
+			free (sescnt);
+			free (sessions);
 			return -1;
 		}
 
-		for( i = 0; i <  sescnt->ic_curnum; i++ ) {
-			if ( uuid_compare( sessions[i].s_sesid,
-					   s->ses->s_sesid ) == 0 )
+		for(i = 0; i <  sescnt->ic_curnum; i++) {
+			if (uuid_compare(sessions[i].s_sesid,
+					   s->ses->s_sesid) == 0)
 				break;
 
 		}
-		free ( sessions );
-		if ( i < sescnt->ic_curnum ) {
-			mlog( MLOG_DEBUG | MLOG_INV,
+		free (sessions);
+		if (i < sescnt->ic_curnum) {
+			mlog(MLOG_DEBUG | MLOG_INV,
 			      "INV: attempt to insert an "
 			      "existing session.\n"
 			     );
-			free ( sescnt );
+			free (sescnt);
 			return 1;
 		}
 
 	}
 
-	if ( sescnt->ic_curnum >= sescnt->ic_maxnum ) {
-		if ( stobj_split( idx, fd, sescnt, s ) < 0 ) {
-			free( sescnt );
+	if (sescnt->ic_curnum >= sescnt->ic_maxnum) {
+		if (stobj_split(idx, fd, sescnt, s) < 0) {
+			free(sescnt);
 			return -1;
 		}
-		free( sescnt );
+		free(sescnt);
 		return 1;
 
 	}
 
-	if ( stobj_put_session( fd, sescnt, s->ses, s->seshdr, s->strms,
-			        s->mfiles ) < 0 ){
-		free ( sescnt);
+	if (stobj_put_session(fd, sescnt, s->ses, s->seshdr, s->strms,
+			        s->mfiles) < 0){
+		free (sescnt);
 		return -1;
 	}
 
-	free ( sescnt);
+	free (sescnt);
 	return 1;
 }
 
@@ -125,16 +125,16 @@ stobj_insert_session( invt_idxinfo_t *idx,
 
 /* ARGSUSED */
 uint
-stobj_find_splitpoint( int fd, invt_seshdr_t *harr, uint ns, time32_t tm )
+stobj_find_splitpoint(int fd, invt_seshdr_t *harr, uint ns, time32_t tm)
 {
 	uint i;
 
-	if ( harr[ns-1].sh_time < tm )
+	if (harr[ns-1].sh_time < tm)
 		return ns;
 	/* since ns > 1, our split point > 0  */
-	for ( i = ns - 1; i > 0; i-- ) {
+	for (i = ns - 1; i > 0; i--) {
 		/* these are ordered in ascending order */
-		if ( harr[i].sh_time > harr[i-1].sh_time )
+		if (harr[i].sh_time > harr[i-1].sh_time)
 			return i;
 	}
 
@@ -143,7 +143,7 @@ stobj_find_splitpoint( int fd, invt_seshdr_t *harr, uint ns, time32_t tm )
 	   really possible, but either way, we split at the last entry.
 	   This will impact the guarantee that invindex tries to give - that
 	   there's always a unique stobj for every session. */
-	mlog( MLOG_VERBOSE | MLOG_INV, _(
+	mlog(MLOG_VERBOSE | MLOG_INV, _(
 	      "INV: failed to find a different sh_time to split\n")
 	     );
 
@@ -162,8 +162,8 @@ stobj_find_splitpoint( int fd, invt_seshdr_t *harr, uint ns, time32_t tm )
 /*----------------------------------------------------------------------*/
 
 int
-stobj_split( invt_idxinfo_t *idx, int fd, invt_sescounter_t *sescnt,
-	     invt_sessinfo_t *newsess )
+stobj_split(invt_idxinfo_t *idx, int fd, invt_sescounter_t *sescnt,
+	     invt_sessinfo_t *newsess)
 {
 	invt_seshdr_t 	*harr = NULL;
 	uint          	i, ix, ns = sescnt->ic_curnum;
@@ -172,22 +172,22 @@ stobj_split( invt_idxinfo_t *idx, int fd, invt_sescounter_t *sescnt,
 	invt_sessinfo_t sesinfo;
 	invt_entry_t 	ient;
 
-	if ( GET_SESHEADERS( fd, &harr, ns ) < 0 )
+	if (GET_SESHEADERS(fd, &harr, ns) < 0)
 		return -1;
 
-	assert( harr != NULL );
+	assert(harr != NULL);
 
-	if ( ( ix = stobj_find_splitpoint( fd, harr, ns,
-				       newsess->seshdr->sh_time ) ) == 0 )
+	if ((ix = stobj_find_splitpoint(fd, harr, ns,
+				       newsess->seshdr->sh_time) ) == 0)
 		return -1;
 
-	if ( ix == ns ) {
+	if (ix == ns) {
 		ient.ie_timeperiod.tp_start = ient.ie_timeperiod.tp_end =
 			 newsess->seshdr->sh_time;
 	} else {
 		ient.ie_timeperiod.tp_start = ient.ie_timeperiod.tp_end =
 		harr[ix].sh_time;
-		if ( harr[ix - 1].sh_time >  newsess->seshdr->sh_time )
+		if (harr[ix - 1].sh_time >  newsess->seshdr->sh_time)
 			idx->iarr[idx->index].ie_timeperiod.tp_end
 				= harr[ix - 1].sh_time;
 		else
@@ -198,11 +198,11 @@ stobj_split( invt_idxinfo_t *idx, int fd, invt_sescounter_t *sescnt,
 	/* Get the new stobj to put the 'spilling' sessinfo in. We know the
 	   idx of the current stobj, and by definition, the new stobj
 	   should come right afterwards. */
-	newsess->stobjfd = idx_put_newentry( idx, &ient );
-	if ( newsess->stobjfd < 0 )
+	newsess->stobjfd = idx_put_newentry(idx, &ient);
+	if (newsess->stobjfd < 0)
 		return -1;
 
-	if ( ix == ns ) {
+	if (ix == ns) {
 		invt_sescounter_t *scnt = NULL;
 		off64_t rval;
 
@@ -210,55 +210,55 @@ stobj_split( invt_idxinfo_t *idx, int fd, invt_sescounter_t *sescnt,
 		   the new stobj, and rest in peace */
 		idx->index++;
 
-		if ( GET_SESCOUNTERS( newsess->stobjfd, &scnt ) < 0 )
+		if (GET_SESCOUNTERS(newsess->stobjfd, &scnt) < 0)
 			return -1;
 
-		rval = stobj_put_session( newsess->stobjfd, scnt,
+		rval = stobj_put_session(newsess->stobjfd, scnt,
 				        newsess->ses,
 				        newsess->seshdr, newsess->strms,
-				        newsess->mfiles );
-		free( scnt );
+				        newsess->mfiles);
+		free(scnt);
 		return (rval < 0)? -1: 1;
 	}
 
 
 
-	for ( i = ix; i < ns; i++ ) {
+	for (i = ix; i < ns; i++) {
 		invt_session_t session;
 		bufpp = NULL;
 		bufszp = 0;
 
 		newsess->seshdr->sh_sess_off = harr[i].sh_sess_off;
 
-		if ( GET_REC_NOLOCK( fd, &session, sizeof( invt_session_t ),
-			     harr[i].sh_sess_off ) < 0 )
+		if (GET_REC_NOLOCK(fd, &session, sizeof(invt_session_t),
+			     harr[i].sh_sess_off) < 0)
 			return -1;
-		if (! stobj_pack_sessinfo( fd, &session, &harr[i], &bufpp,
-					   &bufszp ))
+		if (! stobj_pack_sessinfo(fd, &session, &harr[i], &bufpp,
+					   &bufszp))
 			return -1;
 		/* Now we need to put this in the new StObj. So, first
 		   unpack it. */
-		if (! stobj_unpack_sessinfo( bufpp, bufszp, &sesinfo ) )
+		if (! stobj_unpack_sessinfo(bufpp, bufszp, &sesinfo) )
 			return -1;
 
 		/* There is no chance of a recursion here */
-		if ( stobj_insert_session( idx, newsess->stobjfd, &sesinfo )
-		     < 0 )
+		if (stobj_insert_session(idx, newsess->stobjfd, &sesinfo)
+		     < 0)
 			return -1;
 
 		/* Now delete that session from this StObj */
-		if (! stobj_delete_sessinfo( fd, sescnt, &session,
-					     &harr[i] ) )
+		if (! stobj_delete_sessinfo(fd, sescnt, &session,
+					     &harr[i]) )
 			return -1;
-		free( bufpp );
+		free(bufpp);
 	}
 	/* Put the new session in the stobj that we just split. Make
 	   sure that we use the updated sescnt and not the stale stuff
 	   from disk. stobj_put_session() writes sescnt and sessinfo to
 	   disk */
-	if ( stobj_put_session( fd, sescnt, newsess->ses, newsess->seshdr,
-			        newsess->strms, newsess->mfiles ) < 0 ) {
-		free ( sescnt);
+	if (stobj_put_session(fd, sescnt, newsess->ses, newsess->seshdr,
+			        newsess->strms, newsess->mfiles) < 0) {
+		free (sescnt);
 		return -1;
 	}
 
@@ -271,8 +271,8 @@ stobj_split( invt_idxinfo_t *idx, int fd, invt_sescounter_t *sescnt,
 
 /* ARGSUSED */
 int
-stobj_delete_mfile( int fd, inv_stream_t *strm, invt_mediafile_t *mf,
-		    off64_t  mfileoff )
+stobj_delete_mfile(int fd, inv_stream_t *strm, invt_mediafile_t *mf,
+		    off64_t  mfileoff)
 {
 
 	return 1;
@@ -284,9 +284,9 @@ stobj_delete_mfile( int fd, inv_stream_t *strm, invt_mediafile_t *mf,
 
 /* ARGSUSED */
 bool_t
-stobj_delete_sessinfo( int fd, /* kept locked EX by caller */
+stobj_delete_sessinfo(int fd, /* kept locked EX by caller */
 		       invt_sescounter_t *sescnt,
-		       invt_session_t *ses, invt_seshdr_t *hdr )
+		       invt_session_t *ses, invt_seshdr_t *hdr)
 {
 	/* we change the sescnt here, but dont write it back to disk
 	   until later */
@@ -314,65 +314,65 @@ stobj_put_session(
 	invt_session_t *ses,
 	invt_seshdr_t *hdr,
 	invt_stream_t *strms,
-	invt_mediafile_t *mfiles )
+	invt_mediafile_t *mfiles)
 {
 	off64_t hoff;
 
 	/* figure out the place where the header will go */
-	hoff =  STOBJ_OFFSET( sescnt->ic_curnum, 0 );
+	hoff =  STOBJ_OFFSET(sescnt->ic_curnum, 0);
 
 	/* figure out where the session information is going to go. */
-	if ( hdr->sh_sess_off < 0 )
-		hdr->sh_sess_off = STOBJ_OFFSET( sescnt->ic_maxnum,
-						 sescnt->ic_curnum );
+	if (hdr->sh_sess_off < 0)
+		hdr->sh_sess_off = STOBJ_OFFSET(sescnt->ic_maxnum,
+						 sescnt->ic_curnum);
 	sescnt->ic_curnum++;
 
 #ifdef INVT_DEBUG
-	mlog ( MLOG_VERBOSE,
+	mlog (MLOG_VERBOSE,
 	       "INV: create sess #%d @ offset %d ic_eof = %d\n",
 	       sescnt->ic_curnum, (int) hdr->sh_sess_off,
-	       (int) sescnt->ic_eof );
+	       (int) sescnt->ic_eof);
 #endif
 
 	/* we need to know where the streams begin, and where the
 	   media files will begin, at the end of the streams */
 	hdr->sh_streams_off = sescnt->ic_eof;
 
-	if ( strms == NULL ) {
-		sescnt->ic_eof += (off64_t)( ses->s_max_nstreams *
-					     sizeof( invt_stream_t ) );
+	if (strms == NULL) {
+		sescnt->ic_eof += (off64_t)(ses->s_max_nstreams *
+					     sizeof(invt_stream_t) );
 	} else {
 		uint i;
 		size_t nmf = 0;
-		sescnt->ic_eof += (off64_t)( ses->s_cur_nstreams *
-					     sizeof( invt_stream_t ) );
+		sescnt->ic_eof += (off64_t)(ses->s_cur_nstreams *
+					     sizeof(invt_stream_t) );
 		for (i=0; i<ses->s_cur_nstreams; i++)
-			nmf += ( size_t ) strms[i].st_nmediafiles;
+			nmf += (size_t) strms[i].st_nmediafiles;
 
-		sescnt->ic_eof += (off64_t)( sizeof( invt_mediafile_t )
-					     * nmf );
-		if ( stobj_put_streams( fd, hdr, ses, strms, mfiles ) < 0 )
+		sescnt->ic_eof += (off64_t)(sizeof(invt_mediafile_t)
+					     * nmf);
+		if (stobj_put_streams(fd, hdr, ses, strms, mfiles) < 0)
 			return -1;
 
 	}
 
 	/* we write back the counters of this storage object first */
-	if ( PUT_SESCOUNTERS( fd, sescnt ) < 0 )
+	if (PUT_SESCOUNTERS(fd, sescnt) < 0)
 		return -1;
 
 	/* write the header next; lseek to the right position */
-	if ( PUT_REC_NOLOCK( fd, hdr, sizeof( invt_seshdr_t ), hoff ) < 0 ) {
+	if (PUT_REC_NOLOCK(fd, hdr, sizeof(invt_seshdr_t), hoff) < 0) {
 		return -1;
 	}
 
 	/* write the header information to the storage object */
-	if ( PUT_REC_NOLOCK( fd, ses, sizeof( invt_session_t ),
-			     hdr->sh_sess_off ) < 0 ) {
+	if (PUT_REC_NOLOCK(fd, ses, sizeof(invt_session_t),
+			     hdr->sh_sess_off) < 0) {
 		return -1;
 	}
 
-	if ( strms != NULL )
-		stobj_sortheaders( fd, sescnt->ic_curnum );
+	if (strms != NULL)
+		stobj_sortheaders(fd, sescnt->ic_curnum);
 
 	return hoff;
 }
@@ -387,41 +387,41 @@ stobj_put_session(
 /*----------------------------------------------------------------------*/
 
 int
-stobj_sortheaders( int fd, uint num )
+stobj_sortheaders(int fd, uint num)
 {
-	size_t sz = sizeof( invt_seshdr_t ) * num;
+	size_t sz = sizeof(invt_seshdr_t) * num;
 	invt_seshdr_t *hdrs;
 #ifdef INVT_DEBUG
 	int i;
 #endif
-	if ( num < 2 ) return 1;
+	if (num < 2) return 1;
 
-	hdrs = malloc( sz );
-	assert( hdrs );
+	hdrs = malloc(sz);
+	assert(hdrs);
 
-	if ( GET_REC_NOLOCK( fd, hdrs, sz, STOBJ_OFFSET( 0, 0 ) ) < 0 ) {
-		free ( hdrs );
+	if (GET_REC_NOLOCK(fd, hdrs, sz, STOBJ_OFFSET(0, 0) ) < 0) {
+		free (hdrs);
 		return -1;
 	}
 #ifdef INVT_DEBUG
-	printf("\nBEF\n" );
+	printf("\nBEF\n");
 	for (i=0; i<(int)num; i++)
-		printf("%ld\n", (long) hdrs[i].sh_time );
+		printf("%ld\n", (long) hdrs[i].sh_time);
 #endif
-	qsort( (void*) hdrs, (size_t) num,
-	      sizeof( invt_seshdr_t ), stobj_hdrcmp );
+	qsort((void*) hdrs, (size_t) num,
+	      sizeof(invt_seshdr_t), stobj_hdrcmp);
 
 #ifdef INVT_DEBUG
-	printf("\n\nAFT\n" );
+	printf("\n\nAFT\n");
 	for (i=0; i<(int)num; i++)
-		printf("%ld\n", (long) hdrs[i].sh_time );
+		printf("%ld\n", (long) hdrs[i].sh_time);
 #endif
-	if ( PUT_REC_NOLOCK( fd, hdrs, sz, STOBJ_OFFSET( 0, 0 ) ) < 0 ) {
-		free ( hdrs );
+	if (PUT_REC_NOLOCK(fd, hdrs, sz, STOBJ_OFFSET(0, 0) ) < 0) {
+		free (hdrs);
 		return -1;
 	}
 
-	free ( hdrs );
+	free (hdrs);
 	return 1;
 
 }
@@ -437,51 +437,51 @@ stobj_sortheaders( int fd, uint num )
 /*----------------------------------------------------------------------*/
 
 int
-stobj_put_streams( int fd, invt_seshdr_t *hdr, invt_session_t *ses,
+stobj_put_streams(int fd, invt_seshdr_t *hdr, invt_session_t *ses,
 		   invt_stream_t *strms,
-		   invt_mediafile_t *mfiles )
+		   invt_mediafile_t *mfiles)
 {
 	uint	nstm = ses->s_cur_nstreams;
 	off64_t off  = hdr->sh_streams_off;
-	off64_t mfileoff = off + (off64_t)( nstm * sizeof( invt_stream_t ) );
+	off64_t mfileoff = off + (off64_t)(nstm * sizeof(invt_stream_t) );
 	uint nmfiles = 0;
 	uint i,j;
 
 	/* fix the offsets in streams */
-	for ( i = 0; i < nstm; i++ ) {
+	for (i = 0; i < nstm; i++) {
 		strms[i].st_firstmfile = mfileoff +
-		  (off64_t) ((size_t) nmfiles * sizeof( invt_mediafile_t ) );
+		  (off64_t) ((size_t) nmfiles * sizeof(invt_mediafile_t) );
 		/* now fix the offsets in mediafiles */
-		for ( j = 0; j < strms[i].st_nmediafiles; j++ ) {
+		for (j = 0; j < strms[i].st_nmediafiles; j++) {
 
 			/* no need to fix the last element's next ptr */
-			if ( j < strms[i].st_nmediafiles - 1 )
-				mfiles[ nmfiles + j ].mf_nextmf =
+			if (j < strms[i].st_nmediafiles - 1)
+				mfiles[nmfiles + j].mf_nextmf =
 				        strms[i].st_firstmfile +
-			      (off64_t) ((j+1) * sizeof( invt_mediafile_t ));
+			      (off64_t) ((j+1) * sizeof(invt_mediafile_t));
 
 			/* no need to fix the first element's prev ptr */
-			if ( j )
-				mfiles[ nmfiles + j ].mf_prevmf =
+			if (j)
+				mfiles[nmfiles + j].mf_prevmf =
 				        strms[i].st_firstmfile +
-			    (off64_t) ((j-1) * sizeof( invt_mediafile_t ));
+			    (off64_t) ((j-1) * sizeof(invt_mediafile_t));
 		}
 
 		/* adjust the offsets of the first and the last elements
 		   in the mediafile chain */
-		mfiles[ nmfiles ].mf_prevmf = 0;
+		mfiles[nmfiles].mf_prevmf = 0;
 		nmfiles += strms[i].st_nmediafiles;
-		mfiles[ nmfiles - 1 ].mf_nextmf = 0;
+		mfiles[nmfiles - 1].mf_nextmf = 0;
 
 	}
 
 	/* first put the streams. hdr already points at the right place */
-	if ( PUT_REC_NOLOCK( fd, strms, nstm * sizeof( invt_stream_t ),
-			     off ) < 0 )
+	if (PUT_REC_NOLOCK(fd, strms, nstm * sizeof(invt_stream_t),
+			     off) < 0)
 		return -1;
 
-	if ( PUT_REC_NOLOCK( fd, mfiles, nmfiles * sizeof( invt_mediafile_t ),
-			     mfileoff ) < 0 )
+	if (PUT_REC_NOLOCK(fd, mfiles, nmfiles * sizeof(invt_mediafile_t),
+			     mfileoff) < 0)
 		return -1;
 
 	return 1;
@@ -498,21 +498,21 @@ stobj_put_streams( int fd, invt_seshdr_t *hdr, invt_session_t *ses,
 /*----------------------------------------------------------------------*/
 
 void
-stobj_makefname( char *fname )
+stobj_makefname(char *fname)
 {
 	/* come up with a new unique name */
 	uuid_t	fn;
 	char str[UUID_STR_LEN + 1];
 
-	uuid_generate( fn );
-        uuid_unparse( fn, str );
+	uuid_generate(fn);
+        uuid_unparse(fn, str);
 
-	strcpy( fname, INV_DIRPATH );
-	strcat( fname, "/" );
-	strcat( fname, str );
-	strcat( fname, INV_STOBJ_PREFIX );
+	strcpy(fname, INV_DIRPATH);
+	strcat(fname, "/");
+	strcat(fname, str);
+	strcat(fname, INV_STOBJ_PREFIX);
 
-	assert( (int) strlen( fname ) < INV_STRLEN );
+	assert((int) strlen(fname) < INV_STRLEN);
 }
 
 
@@ -523,39 +523,39 @@ stobj_makefname( char *fname )
 
 /* NOTE: this doesnt update counters or headers in the inv_index */
 int
-stobj_create( char *fname )
+stobj_create(char *fname)
 {
 	int fd;
 	invt_sescounter_t sescnt;
 	inv_oflag_t forwhat = INV_SEARCH_N_MOD;
 
 #ifdef INVT_DEBUG
-	mlog( MLOG_VERBOSE | MLOG_INV, "INV: creating storage obj %s\n", fname);
+	mlog(MLOG_VERBOSE | MLOG_INV, "INV: creating storage obj %s\n", fname);
 #endif
 
 	/* create the new storage object */
-	if (( fd = open( fname, INV_OFLAG(forwhat) | O_EXCL | O_CREAT, S_IRUSR|S_IWUSR )) < 0 ) {
-		INV_PERROR ( fname );
-		memset( fname, 0, INV_STRLEN );
+	if ((fd = open(fname, INV_OFLAG(forwhat) | O_EXCL | O_CREAT, S_IRUSR|S_IWUSR)) < 0) {
+		INV_PERROR (fname);
+		memset(fname, 0, INV_STRLEN);
 		return -1;
 	}
 
-	INVLOCK( fd, LOCK_EX );
-	fchmod( fd, INV_PERMS );
+	INVLOCK(fd, LOCK_EX);
+	fchmod(fd, INV_PERMS);
 
 	sescnt.ic_vernum = INV_VERSION;
 	sescnt.ic_curnum = 0; /* there are no sessions as yet */
 	sescnt.ic_maxnum = INVT_STOBJ_MAXSESSIONS;
 	sescnt.ic_eof = SC_EOF_INITIAL_POS;
 
-	if ( PUT_SESCOUNTERS ( fd, &sescnt ) < 0 ) {
-		memset( fname, 0, INV_STRLEN );
-		INVLOCK( fd, LOCK_UN );
-		close( fd );
+	if (PUT_SESCOUNTERS (fd, &sescnt) < 0) {
+		memset(fname, 0, INV_STRLEN);
+		INVLOCK(fd, LOCK_UN);
+		close(fd);
 		return -1;
 	}
 
-	INVLOCK( fd, LOCK_UN );
+	INVLOCK(fd, LOCK_UN);
 	return fd;
 }
 
@@ -574,16 +574,16 @@ stobj_create_session(
 	int fd, /* kept locked EX by caller */
 	invt_sescounter_t *sescnt,
 	invt_session_t *ses,
-	invt_seshdr_t *hdr )
+	invt_seshdr_t *hdr)
 {
 	off64_t hoff;
 
-	assert( tok && sescnt && ses && hdr );
+	assert(tok && sescnt && ses && hdr);
 
 	hdr->sh_sess_off = -1;
 	ses->s_cur_nstreams = 0;
 
-	if ((hoff = stobj_put_session( fd, sescnt, ses, hdr, NULL, NULL ))
+	if ((hoff = stobj_put_session(fd, sescnt, ses, hdr, NULL, NULL))
 	    < 0) {
 		return -1;
 	}
@@ -603,7 +603,7 @@ stobj_create_session(
 /*----------------------------------------------------------------------*/
 
 int
-stobj_put_mediafile( inv_stmtoken_t tok, invt_mediafile_t *mf )
+stobj_put_mediafile(inv_stmtoken_t tok, invt_mediafile_t *mf)
 {
 	int  rval;
 	invt_sescounter_t *sescnt = NULL;
@@ -615,31 +615,31 @@ stobj_put_mediafile( inv_stmtoken_t tok, invt_mediafile_t *mf )
 	/* first we need to find out where the current write-position is.
 	   so, we first read the sescounter that is at the top of this
 	   storage object */
-	if ( GET_SESCOUNTERS( fd, &sescnt ) < 0 )
+	if (GET_SESCOUNTERS(fd, &sescnt) < 0)
 		return -1;
 
 	pos = sescnt->ic_eof;
 
 	/* increment the pointer to give space for this media file */
-	sescnt->ic_eof += (off64_t) sizeof( invt_mediafile_t );
+	sescnt->ic_eof += (off64_t) sizeof(invt_mediafile_t);
 
-	if ( PUT_SESCOUNTERS( fd, sescnt ) < 0 )
+	if (PUT_SESCOUNTERS(fd, sescnt) < 0)
 		return -1;
 
 	/* get the stream information, and update number of mediafiles.
 	   we also need to link the new mediafile into the linked-list of
 	   media files of this stream */
 
-	if ( GET_REC_NOLOCK( fd, &stream, sizeof( stream ),
-			     tok->md_stream_off ) < 0 )
+	if (GET_REC_NOLOCK(fd, &stream, sizeof(stream),
+			     tok->md_stream_off) < 0)
 		return -1;
 
 	/* We need to update the last ino of this STREAM, which is now the
 	   last ino of the new mediafile. If this is the first mediafile, we
 	   have to update the startino as well. Note that ino is a <ino,off>
 	   tuple */
-	if ( ! ( mf->mf_flag & INVT_MFILE_INVDUMP )) {
-		if ( stream.st_nmediafiles == 0 )
+	if (! (mf->mf_flag & INVT_MFILE_INVDUMP)) {
+		if (stream.st_nmediafiles == 0)
 			stream.st_startino = mf->mf_startino;
 		stream.st_endino = mf->mf_endino;
 	}
@@ -655,7 +655,7 @@ stobj_put_mediafile( inv_stmtoken_t tok, invt_mediafile_t *mf )
 	mf->mf_prevmf = stream.st_lastmfile;
 
 
-	if ( tok->md_lastmfile )
+	if (tok->md_lastmfile)
 		tok->md_lastmfile->mf_nextmf = pos;
 	else {
 		stream.st_firstmfile = pos;
@@ -665,29 +665,29 @@ stobj_put_mediafile( inv_stmtoken_t tok, invt_mediafile_t *mf )
 
 
 	/* write the stream to disk */
-	if ( PUT_REC_NOLOCK( fd, &stream, sizeof( stream ),
-			     tok->md_stream_off ) < 0 )
+	if (PUT_REC_NOLOCK(fd, &stream, sizeof(stream),
+			     tok->md_stream_off) < 0)
 		return -1;
 
 	/* write the prev media file to disk too */
-	if ( tok->md_lastmfile ) {
-		rval = PUT_REC_NOLOCK( fd, tok->md_lastmfile,
-				       sizeof( invt_mediafile_t ),
-				       mf->mf_prevmf );
-		free (  tok->md_lastmfile );
-		if ( rval < 0 )
+	if (tok->md_lastmfile) {
+		rval = PUT_REC_NOLOCK(fd, tok->md_lastmfile,
+				       sizeof(invt_mediafile_t),
+				       mf->mf_prevmf);
+		free (tok->md_lastmfile);
+		if (rval < 0)
 			return -1;
 	}
 
-	if ( ! ( mf->mf_flag & INVT_MFILE_INVDUMP )) {
+	if (! (mf->mf_flag & INVT_MFILE_INVDUMP)) {
 		tok->md_lastmfile = mf;
 	} else {
 		tok->md_lastmfile = NULL;
 	}
 
 	/* at last, write the new media file to disk */
-	rval = PUT_REC_NOLOCK( fd, mf, sizeof( invt_mediafile_t ), pos );
-	if ( rval < 0 ) {
+	rval = PUT_REC_NOLOCK(fd, mf, sizeof(invt_mediafile_t), pos);
+	if (rval < 0) {
 		return -1;
 	}
 
@@ -709,17 +709,17 @@ stobj_put_mediafile( inv_stmtoken_t tok, invt_mediafile_t *mf )
 /*----------------------------------------------------------------------*/
 
 int
-stobj_get_sessinfo ( inv_sestoken_t tok, invt_seshdr_t *hdr,
-		     invt_session_t *ses )
+stobj_get_sessinfo (inv_sestoken_t tok, invt_seshdr_t *hdr,
+		     invt_session_t *ses)
 {
 	int rval;
 	int fd = tok->sd_invtok->d_stobj_fd;
 
 	/* get the session header first */
-	if ( ( rval = GET_REC_NOLOCK( fd, hdr, sizeof( invt_seshdr_t ),
-			     tok->sd_sesshdr_off ) ) > 0 ) {
-		rval = GET_REC_NOLOCK( fd, ses, sizeof( invt_session_t ),
-			     tok->sd_session_off );
+	if ((rval = GET_REC_NOLOCK(fd, hdr, sizeof(invt_seshdr_t),
+			     tok->sd_sesshdr_off) ) > 0) {
+		rval = GET_REC_NOLOCK(fd, ses, sizeof(invt_session_t),
+			     tok->sd_session_off);
 	}
 
 	return rval;
@@ -734,8 +734,8 @@ stobj_get_sessinfo ( inv_sestoken_t tok, invt_seshdr_t *hdr,
 /*----------------------------------------------------------------------*/
 
 bool_t
-stobj_pack_sessinfo( int fd, invt_session_t *ses, invt_seshdr_t *hdr,
-		     void  **bufpp, size_t *bufszp )
+stobj_pack_sessinfo(int fd, invt_session_t *ses, invt_seshdr_t *hdr,
+		     void  **bufpp, size_t *bufszp)
 {
 	size_t	      	stmsz;
 	uint		i, j;
@@ -745,38 +745,38 @@ stobj_pack_sessinfo( int fd, invt_session_t *ses, invt_seshdr_t *hdr,
 	off64_t		off;
 	invt_mediafile_t mf;
 
-	stmsz = sizeof( invt_stream_t ) * ses->s_cur_nstreams;
+	stmsz = sizeof(invt_stream_t) * ses->s_cur_nstreams;
 
 	/* the initial size without the mediafiles */
-	sessz = strlen( INVTSESS_COOKIE ) * sizeof( char ) +
-		sizeof( inv_version_t ) +
-		sizeof( inv_version_t ) +  /* added to fix 64 bit alignment prob */
-		sizeof( invt_session_t) + sizeof( invt_seshdr_t ) + stmsz;
+	sessz = strlen(INVTSESS_COOKIE) * sizeof(char) +
+		sizeof(inv_version_t) +
+		sizeof(inv_version_t) +  /* added to fix 64 bit alignment prob */
+		sizeof(invt_session_t) + sizeof(invt_seshdr_t) + stmsz;
 
 	/* now get all the streams of this session */
-	strms = calloc ( ses->s_cur_nstreams, sizeof( invt_stream_t ) );
-	if ( GET_REC_NOLOCK( fd, strms, stmsz, hdr->sh_streams_off ) < 0 ) {
-		free ( strms );
+	strms = calloc (ses->s_cur_nstreams, sizeof(invt_stream_t) );
+	if (GET_REC_NOLOCK(fd, strms, stmsz, hdr->sh_streams_off) < 0) {
+		free (strms);
 		return BOOL_FALSE;
 	}
 
-	for ( i = 0; i < ses->s_cur_nstreams; i++ )
-		sessz += sizeof( invt_mediafile_t ) *
+	for (i = 0; i < ses->s_cur_nstreams; i++)
+		sessz += sizeof(invt_mediafile_t) *
 			 (size_t) strms[i].st_nmediafiles;
 
 	/* Now we know how big this entire thing is going to be */
-	sesbufcp = sesbuf = calloc( 1, sessz );
-	assert( sesbuf );
+	sesbufcp = sesbuf = calloc(1, sessz);
+	assert(sesbuf);
 
 	/* Copy everything. Note that we don't bother to adjust the offsets
 	   either in the seshdr or in the mediafiles, because we don't need
-	   those in order to restore this session ( since everything's
-	   contiguous ) */
+	   those in order to restore this session (since everything's
+	   contiguous) */
 
 	/* magic cookie that we put for sanity checking in case of an
 	   earthquake or something :) */
-	strcpy( sesbuf, INVTSESS_COOKIE );
-	sesbuf += (size_t)( strlen( INVTSESS_COOKIE ) * sizeof( char ) );
+	strcpy(sesbuf, INVTSESS_COOKIE);
+	sesbuf += (size_t)(strlen(INVTSESS_COOKIE) * sizeof(char) );
 
 	/* This was originally INV_VERSION. Changed it to mean packed inventory
 	 * version number and added another inv_version_t to contain the INV_VERSION.
@@ -785,43 +785,43 @@ stobj_pack_sessinfo( int fd, invt_session_t *ses, invt_seshdr_t *hdr,
 	 * the general inventory version
 	 */
 	*(inv_version_t *)sesbuf = INT_GET(PACKED_INV_VERSION, ARCH_CONVERT);
-	sesbuf += sizeof( inv_version_t );
+	sesbuf += sizeof(inv_version_t);
 
 	/* This has the INV_VERSION */
 	*(inv_version_t *)sesbuf = INT_GET(INV_VERSION, ARCH_CONVERT);
-	sesbuf += sizeof( inv_version_t );
+	sesbuf += sizeof(inv_version_t);
 
 	xlate_invt_seshdr(hdr, (invt_seshdr_t *)sesbuf, 1);
-	sesbuf += sizeof( invt_seshdr_t );
+	sesbuf += sizeof(invt_seshdr_t);
 
-	xlate_invt_session( ses, (invt_session_t *)sesbuf, 1 );
-	sesbuf += sizeof( invt_session_t );
+	xlate_invt_session(ses, (invt_session_t *)sesbuf, 1);
+	sesbuf += sizeof(invt_session_t);
 
-	for ( i = 0; i < ses->s_cur_nstreams; i++ ) {
-		xlate_invt_stream( strms, (invt_stream_t *)sesbuf, 1 );
-		sesbuf += sizeof( invt_stream_t );
+	for (i = 0; i < ses->s_cur_nstreams; i++) {
+		xlate_invt_stream(strms, (invt_stream_t *)sesbuf, 1);
+		sesbuf += sizeof(invt_stream_t);
 	}
 
 	/* now append all the mediafiles */
-	for ( i = 0; i < ses->s_cur_nstreams; i++ ) {
+	for (i = 0; i < ses->s_cur_nstreams; i++) {
 		off = strms[i].st_firstmfile;
-		for ( j = 0; j < strms[i].st_nmediafiles;
+		for (j = 0; j < strms[i].st_nmediafiles;
 		     j++,
-		     off = mf.mf_nextmf ) {
-			assert( off );
-			if ( GET_REC_NOLOCK( fd, &mf,
-					     sizeof( invt_mediafile_t ),
-					     off ) <= 0 ) {
-				free( strms );
-				free( sesbuf );
+		     off = mf.mf_nextmf) {
+			assert(off);
+			if (GET_REC_NOLOCK(fd, &mf,
+					     sizeof(invt_mediafile_t),
+					     off) <= 0) {
+				free(strms);
+				free(sesbuf);
 				return BOOL_FALSE;
 			}
 			xlate_invt_mediafile(&mf, (invt_mediafile_t *)sesbuf, 1);
-			sesbuf += sizeof( invt_mediafile_t );
+			sesbuf += sizeof(invt_mediafile_t);
 		}
 	}
 
-	free( strms );
+	free(strms);
 	*bufpp = sesbufcp;
 	*bufszp = sessz;
 
@@ -840,13 +840,13 @@ stobj_getsession_byuuid(
 	int fd,
 	invt_seshdr_t *hdr,
 	void *sesid,
-	void **buf )
+	void **buf)
 {
 	invt_session_t ses;
 
 	/* retrieve the session */
-	if ( GET_REC_NOLOCK( fd, &ses, sizeof( invt_session_t ),
-			     hdr->sh_sess_off ) < 0 )
+	if (GET_REC_NOLOCK(fd, &ses, sizeof(invt_session_t),
+			     hdr->sh_sess_off) < 0)
 		return -1;
 
 	/* now see if this is the one that caller is askin for */
@@ -876,13 +876,13 @@ stobj_getsession_bylabel(
 	int fd,
 	invt_seshdr_t *hdr,
 	void *seslabel,
-	void **buf )
+	void **buf)
 {
 	invt_session_t ses;
 
 	/* retrieve the session */
-	if ( GET_REC_NOLOCK( fd, &ses, sizeof( invt_session_t ),
-			     hdr->sh_sess_off ) < 0 )
+	if (GET_REC_NOLOCK(fd, &ses, sizeof(invt_session_t),
+			     hdr->sh_sess_off) < 0)
 		return -1;
 
 	/* now see if this is the one that caller is askin for */
@@ -910,7 +910,7 @@ bool_t
 stobj_delete_mobj(int fd,
 		  invt_seshdr_t *hdr,
 		  void *arg ,
-		  void **buf )
+		  void **buf)
 {
 	/* XXX fd needs to be locked EX, not SH */
 	uuid_t *moid = *buf;
@@ -922,38 +922,38 @@ stobj_delete_mobj(int fd,
 	uint		i, j;
 	bool_t 		dirty;
 
-	if ( GET_REC_NOLOCK( fd, &ses, sizeof( invt_session_t ),
-			     hdr->sh_sess_off ) < 0 )
+	if (GET_REC_NOLOCK(fd, &ses, sizeof(invt_session_t),
+			     hdr->sh_sess_off) < 0)
 		return -1;
 
 	/* now get all the streams of this session */
-	strms = calloc ( ses.s_cur_nstreams, sizeof( invt_stream_t ) );
-	if ( GET_REC_NOLOCK( fd, strms,
-			     sizeof( invt_stream_t ) * ses.s_cur_nstreams,
-			     hdr->sh_streams_off ) < 0 ) {
-		free ( strms );
+	strms = calloc (ses.s_cur_nstreams, sizeof(invt_stream_t) );
+	if (GET_REC_NOLOCK(fd, strms,
+			     sizeof(invt_stream_t) * ses.s_cur_nstreams,
+			     hdr->sh_streams_off) < 0) {
+		free (strms);
 		return BOOL_FALSE;
 	}
 
 	/* now look at all the mediafiles in all the streams */
-	for ( i = 0; i < ses.s_cur_nstreams; i++ ) {
+	for (i = 0; i < ses.s_cur_nstreams; i++) {
 		off = strms[i].st_firstmfile;
 		nmfiles = strms[i].st_nmediafiles;
-		mfiles = mf = calloc( nmfiles, sizeof( invt_mediafile_t ) );
-		for ( j = 0; j < nmfiles;
+		mfiles = mf = calloc(nmfiles, sizeof(invt_mediafile_t) );
+		for (j = 0; j < nmfiles;
 		     j++,
 		     off = mf->mf_nextmf,
-		     mf++ ) {
+		     mf++) {
 
 /*  The prob is that we need to keep track of where we got these mfiles from
     as we get them, or we wont know how to put them back if they are dirty.
 */
-			assert( off );
-			if ( GET_REC_NOLOCK( fd, mf,
-					     sizeof( invt_mediafile_t ),
-					     off ) <= 0 ) {
-				free( strms );
-				free( mfiles );
+			assert(off);
+			if (GET_REC_NOLOCK(fd, mf,
+					     sizeof(invt_mediafile_t),
+					     off) <= 0) {
+				free(strms);
+				free(mfiles);
 				return BOOL_FALSE;
 			}
 		}
@@ -962,31 +962,31 @@ stobj_delete_mobj(int fd,
 		   pass, checking to see if we need to remove any mfiles */
  		dirty = BOOL_FALSE;
 
-		for ( j = 0; j < nmfiles; j++ ) {
+		for (j = 0; j < nmfiles; j++) {
 			mf = &mfiles[j];
-			if ( !uuid_compare( mf->mf_moid, *moid ) ) {
+			if (!uuid_compare(mf->mf_moid, *moid) ) {
 #ifdef INVT_DEBUG
-				printf(" found one\n" );
+				printf(" found one\n");
 #endif
 
 /*                                dirty = BOOL_TRUE;
 
-				if ( j == 0 )
+				if (j == 0)
 				       strms[i].st_firstmfile = mf->mf_nextmf;
 				else
 				       mfiles[j-1].mf_nextmf = mf->mf_nextmf;
 
-				if ( j == nmfiles - 1 )
+				if (j == nmfiles - 1)
 				       strms[i].st_lastmfile = ;
 */
 			}
 
 		}
-		free ( mfiles );
-		if ( dirty );
+		free (mfiles);
+		if (dirty);
 	}
 
-	free ( strms );
+	free (strms);
 
 	return BOOL_FALSE; /* ret FALSE, or it'll stop iteration */
 }
@@ -1006,36 +1006,36 @@ bool_t
 stobj_unpack_sessinfo(
         void              *bufp,
         size_t             bufsz,
-	invt_sessinfo_t   *s )
+	invt_sessinfo_t   *s)
 {
 	uint 		 i;
 	char	         *tmpbuf;
 	char 		 *p = (char *)bufp;
 
-	assert ( bufp );
+	assert (bufp);
 
 	tmpbuf = (char *)malloc(bufsz);
 
 	/* first make sure that the magic cookie at the beginning is right.
 	   this isn't null-terminated */
-	if (strncmp( p, INVTSESS_COOKIE, strlen( INVTSESS_COOKIE ) ) != 0) {
-		mlog( MLOG_NORMAL | MLOG_INV, _(
-			"INV: inv_put_session: unknown cookie\n") );
+	if (strncmp(p, INVTSESS_COOKIE, strlen(INVTSESS_COOKIE) ) != 0) {
+		mlog(MLOG_NORMAL | MLOG_INV, _(
+			"INV: inv_put_session: unknown cookie\n"));
 		return BOOL_FALSE;
 	}
 	/* skip the cookie */
-	p += strlen( INVTSESS_COOKIE ) * sizeof( char );
+	p += strlen(INVTSESS_COOKIE) * sizeof(char);
 
 	/* Check the packing version number. In version 1 , this was the only version number.
 	 * see the comment in stobj_pack_sessinfo().
 	 */
-	if ( INT_GET(*( inv_version_t *) p, ARCH_CONVERT) == PACKED_INV_VERSION_1 ) {
+	if (INT_GET(*(inv_version_t *) p, ARCH_CONVERT) == PACKED_INV_VERSION_1) {
 		char *temp_p;
 		size_t		 tempsz;
 
-	        mlog( MLOG_DEBUG | MLOG_INV,"INV: packed inventory version  = 1\n" );
+	        mlog(MLOG_DEBUG | MLOG_INV,"INV: packed inventory version  = 1\n");
 
-		p += sizeof( inv_version_t );
+		p += sizeof(inv_version_t);
 
 		/* We hit a 64 bit alignment issue at this point leading to a
 		 * SIGBUS and core dump. The best way to handle it is to
@@ -1047,21 +1047,21 @@ stobj_unpack_sessinfo(
 		 * have the INV_VERSION. This makes everything 64 bit aligned.
 		 */
 
-		tempsz = bufsz - (strlen( INVTSESS_COOKIE ) * sizeof( char ))
-			       - sizeof( inv_version_t ) ;
+		tempsz = bufsz - (strlen(INVTSESS_COOKIE) * sizeof(char))
+			       - sizeof(inv_version_t) ;
 		temp_p = calloc(1, tempsz);
 		bcopy(p, temp_p, tempsz);
 		p = temp_p;
-	} else if ( INT_GET(*( inv_version_t *) p, ARCH_CONVERT) == PACKED_INV_VERSION_2 ) {
-	        mlog( MLOG_DEBUG | MLOG_INV,"INV: packed inventory version = 2\n" );
+	} else if (INT_GET(*(inv_version_t *) p, ARCH_CONVERT) == PACKED_INV_VERSION_2) {
+	        mlog(MLOG_DEBUG | MLOG_INV,"INV: packed inventory version = 2\n");
 
-		p += sizeof( inv_version_t ); /* skip the packed inventory version */
+		p += sizeof(inv_version_t); /* skip the packed inventory version */
 		/* At this point , don't care about the INV_VERSION. Maybe in future */
-		p += sizeof( inv_version_t ); /* skip the inventory version */
+		p += sizeof(inv_version_t); /* skip the inventory version */
 	} else {
-	        mlog( MLOG_NORMAL | MLOG_INV, _(
+	        mlog(MLOG_NORMAL | MLOG_INV, _(
 		      "INV: inv_put_session: unknown packed inventory version"
-		      " %d\n"), *( inv_version_t *) p);
+		      " %d\n"), *(inv_version_t *) p);
 		return BOOL_FALSE;
 	}
 
@@ -1071,52 +1071,52 @@ stobj_unpack_sessinfo(
 	/* get the seshdr and then, the remainder of the session */
 	s->seshdr = (invt_seshdr_t *)p;
 	s->seshdr->sh_sess_off = -1;
-	p += sizeof( invt_seshdr_t );
+	p += sizeof(invt_seshdr_t);
 
 
 	xlate_invt_session((invt_session_t *)p, (invt_session_t *)tmpbuf, 1);
 	bcopy (tmpbuf, p, sizeof(invt_session_t));
 	s->ses = (invt_session_t *)p;
-	p += sizeof( invt_session_t );
+	p += sizeof(invt_session_t);
 
 	/* the array of all the streams belonging to this session */
 	xlate_invt_stream((invt_stream_t *)p, (invt_stream_t *)tmpbuf, 1);
 	bcopy(tmpbuf, p, sizeof(invt_stream_t));
 	s->strms = (invt_stream_t *)p;
-	p += s->ses->s_cur_nstreams * sizeof( invt_stream_t );
+	p += s->ses->s_cur_nstreams * sizeof(invt_stream_t);
 
 	/* all the media files */
 	s->mfiles = (invt_mediafile_t *)p;
 
 #ifdef INVT_DELETION
 	{
-		int tmpfd = open( "moids", O_RDWR | O_CREAT, S_IRUSR|S_IWUSR );
+		int tmpfd = open("moids", O_RDWR | O_CREAT, S_IRUSR|S_IWUSR);
 		uint j;
 		invt_mediafile_t *mmf = s->mfiles;
-		for (i=0; i< s->ses->s_cur_nstreams; i++ ) {
-			for (j=0; j< s->strms[ i ].st_nmediafiles;
-			     j++, mmf++ )
+		for (i=0; i< s->ses->s_cur_nstreams; i++) {
+			for (j=0; j< s->strms[i].st_nmediafiles;
+			     j++, mmf++)
 				xlate_invt_mediafile((invt_mediafile_t *)mmf, (invt_mediafile_t *)tmpbuf, 1);
 				bcopy(tmpbuf, mmf, sizeof(invt_mediafile_t));
-				put_invtrecord( tmpfd, &mmf->mf_moid,
-					 sizeof( uuid_t ), 0, SEEK_END, 0 );
+				put_invtrecord(tmpfd, &mmf->mf_moid,
+					 sizeof(uuid_t), 0, SEEK_END, 0);
 		}
-		close( tmpfd );
+		close(tmpfd);
 	}
 #endif
-	for ( i = 0; i < s->ses->s_cur_nstreams; i++ ) {
-		p += (size_t) ( s->strms[ i ].st_nmediafiles )
-			* sizeof( invt_mediafile_t );
+	for (i = 0; i < s->ses->s_cur_nstreams; i++) {
+		p += (size_t) (s->strms[i].st_nmediafiles)
+			* sizeof(invt_mediafile_t);
 	}
 
 	/* sanity check the size of the buffer given to us vs. the size it
 	   should be */
-	if ( (size_t) ( p - (char *) bufp ) != bufsz ) {
-		mlog( MLOG_DEBUG | MLOG_INV, "p-bufp %d != bufsz %d entsz %d\n",
-		      (int)( p - (char *) bufp ), (int) bufsz,
-	      (int) ( sizeof( invt_entry_t ) ) );
+	if ((size_t) (p - (char *) bufp) != bufsz) {
+		mlog(MLOG_DEBUG | MLOG_INV, "p-bufp %d != bufsz %d entsz %d\n",
+		      (int)(p - (char *) bufp), (int) bufsz,
+	      (int) (sizeof(invt_entry_t) ));
 	}
-	assert( (size_t) ( p - (char *) bufp ) == bufsz );
+	assert((size_t) (p - (char *) bufp) == bufsz);
 
 	return BOOL_TRUE;
 }
@@ -1129,13 +1129,13 @@ stobj_unpack_sessinfo(
 /*----------------------------------------------------------------------*/
 
 int
-stobj_make_invsess( int fd, inv_session_t **buf, invt_seshdr_t *hdr )
+stobj_make_invsess(int fd, inv_session_t **buf, invt_seshdr_t *hdr)
 {
 	invt_session_t ses;
 
 	/* load in the rest of the session, but not the streams */
-	if ( GET_REC_NOLOCK( fd, &ses, sizeof(ses), hdr->sh_sess_off )
-	    < 0 ) {
+	if (GET_REC_NOLOCK(fd, &ses, sizeof(ses), hdr->sh_sess_off)
+	    < 0) {
 		return -1;
 	}
 
@@ -1147,15 +1147,15 @@ void
 stobj_convert_mfile(inv_mediafile_t *expmf, invt_mediafile_t *mf)
 {
 	/* copy the mediafile into the exported structure */
-	memcpy( &expmf->m_moid, &mf->mf_moid, sizeof( uuid_t ) );
-	strcpy( expmf->m_label, mf->mf_label );
+	memcpy(&expmf->m_moid, &mf->mf_moid, sizeof(uuid_t) );
+	strcpy(expmf->m_label, mf->mf_label);
 	expmf->m_mfile_index = mf->mf_mfileidx;
 	expmf->m_startino = mf->mf_startino.ino;
 	expmf->m_startino_off = mf->mf_startino.offset;
 	expmf->m_endino = mf->mf_endino.ino;
 	expmf->m_endino_off = mf->mf_endino.offset;
 	expmf->m_size = mf->mf_size;
-	expmf->m_isgood = (mf->mf_flag & INVT_MFILE_GOOD ) ?
+	expmf->m_isgood = (mf->mf_flag & INVT_MFILE_GOOD) ?
 		BOOL_TRUE : BOOL_FALSE;
 	expmf->m_isinvdump = (mf->mf_flag & INVT_MFILE_INVDUMP)?
 		BOOL_TRUE : BOOL_FALSE;
@@ -1172,7 +1172,7 @@ stobj_convert_strm(inv_stream_t *expstrm, invt_stream_t *strm)
 		strm->st_startino.offset;
 	expstrm->st_endino = strm->st_endino.ino;
 	expstrm->st_endino_off = strm->st_endino.offset;
-	strcpy( expstrm->st_cmdarg, strm->st_cmdarg );
+	strcpy(expstrm->st_cmdarg, strm->st_cmdarg);
 
 	expstrm->st_nmediafiles = strm->st_nmediafiles;
 
@@ -1186,14 +1186,14 @@ stobj_convert_session(inv_session_t *ises, invt_session_t *ses,
 {
 	ises->s_time = hdr->sh_time;
 	ises->s_level = hdr->sh_level;
-	ises->s_ispartial = IS_PARTIAL_SESSION( hdr )? BOOL_TRUE: BOOL_FALSE;
-	ises->s_isresumed = IS_RESUMED_SESSION( hdr )? BOOL_TRUE: BOOL_FALSE;
+	ises->s_ispartial = IS_PARTIAL_SESSION(hdr)? BOOL_TRUE: BOOL_FALSE;
+	ises->s_isresumed = IS_RESUMED_SESSION(hdr)? BOOL_TRUE: BOOL_FALSE;
 	ises->s_nstreams = ses->s_cur_nstreams;
-	memcpy( &ises->s_sesid, &ses->s_sesid, sizeof( uuid_t ) );
-	memcpy( &ises->s_fsid, &ses->s_fsid, sizeof( uuid_t ) );
-	strcpy( ises->s_mountpt, ses->s_mountpt );
-	strcpy( ises->s_devpath, ses->s_devpath );
-	strcpy( ises->s_label, ses->s_label );
+	memcpy(&ises->s_sesid, &ses->s_sesid, sizeof(uuid_t) );
+	memcpy(&ises->s_fsid, &ses->s_fsid, sizeof(uuid_t) );
+	strcpy(ises->s_mountpt, ses->s_mountpt);
+	strcpy(ises->s_devpath, ses->s_devpath);
+	strcpy(ises->s_label, ses->s_label);
 
 	/* caller is responsible for initializing this */
 	ises->s_streams = NULL;
@@ -1218,23 +1218,23 @@ stobj_copy_invsess(int fd,
 	int i;
 	invt_mediafile_t mf;
 
-	strms = calloc ( ses->s_cur_nstreams, sizeof( invt_stream_t ) );
+	strms = calloc (ses->s_cur_nstreams, sizeof(invt_stream_t) );
 
 	/* load in all the stream-headers */
-	if ( GET_REC_NOLOCK( fd, strms,
-			     ses->s_cur_nstreams * sizeof( invt_stream_t ),
-			     hdr->sh_streams_off ) < 0 ) {
+	if (GET_REC_NOLOCK(fd, strms,
+			     ses->s_cur_nstreams * sizeof(invt_stream_t),
+			     hdr->sh_streams_off) < 0) {
 		free (strms);
 		return -1;
 	}
 
-	ises = calloc( 1, sizeof( inv_session_t ) );
+	ises = calloc(1, sizeof(inv_session_t) );
 	stobj_convert_session(ises, ses, hdr);
-	ises->s_streams = calloc(ses->s_cur_nstreams, sizeof( inv_stream_t ));
+	ises->s_streams = calloc(ses->s_cur_nstreams, sizeof(inv_stream_t));
 
 	/* fill in the stream structures too */
 	i = (int) ses->s_cur_nstreams;
-	while ( i-- ) {
+	while (i--) {
 		off64_t		 off;
 		uint            j, nmf;
 
@@ -1243,31 +1243,31 @@ stobj_copy_invsess(int fd,
 		off = strms[i].st_firstmfile;
 
 		if (nmf)
-			ises->s_streams[i].st_mediafiles = calloc( nmf,
-						    sizeof( inv_mediafile_t ) );
-		assert( !nmf || ises->s_streams[i].st_mediafiles );
+			ises->s_streams[i].st_mediafiles = calloc(nmf,
+						    sizeof(inv_mediafile_t) );
+		assert(!nmf || ises->s_streams[i].st_mediafiles);
 
-		for ( j = 0; j < nmf;
+		for (j = 0; j < nmf;
 		      j++,
-		      off = mf.mf_nextmf ) {
-			assert( off );
-			if ( GET_REC_NOLOCK( fd, &mf,
-					     sizeof( invt_mediafile_t ),
-					     off ) <= 0 ) {
-				INV_PERROR( "stobj::make_invsess\n" );
-				free( strms );
-				free( ises );
+		      off = mf.mf_nextmf) {
+			assert(off);
+			if (GET_REC_NOLOCK(fd, &mf,
+					     sizeof(invt_mediafile_t),
+					     off) <= 0) {
+				INV_PERROR("stobj::make_invsess\n");
+				free(strms);
+				free(ises);
 				return -1;
 			}
 
 			/* copy the mediafile into the exported structure */
 			if (ises->s_streams[i].st_mediafiles) {
-				stobj_convert_mfile( &ises->s_streams[i].st_mediafiles[j],
+				stobj_convert_mfile(&ises->s_streams[i].st_mediafiles[j],
 						&mf);
 			} else {
 				mlog(MLOG_ERROR, _(
 					"Failed to get data from media file: "
-					"possible file corruption\n") );
+					"possible file corruption\n"));
 				mlog_exit_hint(RV_CORRUPT);
 				return -1;
 			}
@@ -1276,7 +1276,7 @@ stobj_copy_invsess(int fd,
 	}
 
 
-	free( strms );
+	free(strms);
 	*buf = ises;
 
 	return 1;
@@ -1297,21 +1297,21 @@ stobj_convert_sessinfo(inv_session_t **buf, invt_sessinfo_t *sinfo)
 	int nstreams;
 	invt_mediafile_t *mf;
 
-	ises = calloc( 1, sizeof( inv_session_t ) );
+	ises = calloc(1, sizeof(inv_session_t) );
 
 	stobj_convert_session(ises, sinfo->ses, sinfo->seshdr);
-	ises->s_streams = calloc( ises->s_nstreams, sizeof( inv_stream_t ) );
+	ises->s_streams = calloc(ises->s_nstreams, sizeof(inv_stream_t) );
 	mf = sinfo->mfiles;
 	nstreams = (int) ises->s_nstreams;
-	for ( i = 0 ; i < nstreams ; i++ ) {
+	for (i = 0 ; i < nstreams ; i++) {
 		stobj_convert_strm(&ises->s_streams[i], &sinfo->strms[i]);
 		nmf = (int) ises->s_streams[i].st_nmediafiles;
-		ises->s_streams[i].st_mediafiles = calloc( (uint) nmf,
-						    sizeof( inv_mediafile_t ) );
+		ises->s_streams[i].st_mediafiles = calloc((uint) nmf,
+						    sizeof(inv_mediafile_t) );
 
-		for ( j = 0; j < nmf; j++ ) {
-			stobj_convert_mfile( &ises->s_streams[i].st_mediafiles[j],
-					     mf++ );
+		for (j = 0; j < nmf; j++) {
+			stobj_convert_mfile(&ises->s_streams[i].st_mediafiles[j],
+					     mf++);
 		}
 	}
 
@@ -1321,10 +1321,10 @@ stobj_convert_sessinfo(inv_session_t **buf, invt_sessinfo_t *sinfo)
 
 
 int
-stobj_hdrcmp( const void *h1, const void *h2 )
+stobj_hdrcmp(const void *h1, const void *h2)
 {
-	return (int) ( ((invt_seshdr_t *)h1)->sh_time -
-		       ((invt_seshdr_t *)h2)->sh_time );
+	return (int) (((invt_seshdr_t *)h1)->sh_time -
+		       ((invt_seshdr_t *)h2)->sh_time);
 }
 
 
@@ -1335,32 +1335,32 @@ stobj_hdrcmp( const void *h1, const void *h2 )
 
 
 void
-DEBUG_sessprint( invt_session_t *ses )
+DEBUG_sessprint(invt_session_t *ses)
 {
 	char str[UUID_STR_LEN + 1];
-	uuid_unparse( ses->s_fsid, str );
+	uuid_unparse(ses->s_fsid, str);
 
 	printf("-------- session -------------\n");
 	printf("label\t%s\n", ses->s_label);
 	printf("mount\t%s\n", ses->s_mountpt);
 	printf("devpath\t%s\n", ses->s_devpath);
-	printf("strms\t%d\n", ses->s_cur_nstreams );
+	printf("strms\t%d\n", ses->s_cur_nstreams);
 	printf("fsid\t%s\n", str);
 	printf("-------- end -------------\n");
 }
 
 bool_t
-mobj_eql ( inv_mediafile_t *mfp, invt_mobjinfo_t *mobj )
+mobj_eql (inv_mediafile_t *mfp, invt_mobjinfo_t *mobj)
 {
 
-	if ( mobj->type == INVT_MOID ) {
-		if ( !uuid_compare( *((uuid_t*) mobj->value),
-			      mfp->m_moid) ) {
+	if (mobj->type == INVT_MOID) {
+		if (!uuid_compare(*((uuid_t*) mobj->value),
+			      mfp->m_moid)) {
 			return BOOL_TRUE;
 		}
 	} else {
-		if ( STREQL( (char*) mobj->value,
-			    mfp->m_label ) ) {
+		if (STREQL((char*) mobj->value,
+			    mfp->m_label) ) {
 			return BOOL_TRUE;
 		}
 	}
@@ -1370,16 +1370,16 @@ mobj_eql ( inv_mediafile_t *mfp, invt_mobjinfo_t *mobj )
 
 
 bool_t
-check_for_mobj ( inv_session_t *ses, invt_mobjinfo_t *mobj )
+check_for_mobj (inv_session_t *ses, invt_mobjinfo_t *mobj)
 {
 	int i;
 	uint j;
 	inv_mediafile_t *mfp;
 
-	for (i = 0; i < (int) ses->s_nstreams; i++ ) {
-		for ( j = 0 ; j < ses->s_streams[i].st_nmediafiles ; j++ ) {
+	for (i = 0; i < (int) ses->s_nstreams; i++) {
+		for (j = 0 ; j < ses->s_streams[i].st_nmediafiles ; j++) {
 			mfp = &ses->s_streams[i].st_mediafiles[j];
-			if (mobj_eql( mfp, mobj ))
+			if (mobj_eql(mfp, mobj))
 				return BOOL_TRUE;
 		}
 	}
@@ -1391,7 +1391,7 @@ check_for_mobj ( inv_session_t *ses, invt_mobjinfo_t *mobj )
 
 
 void
-DEBUG_sessionprint( inv_session_t *ses, uint ref, invt_pr_ctx_t *prctx)
+DEBUG_sessionprint(inv_session_t *ses, uint ref, invt_pr_ctx_t *prctx)
 {
 	char str[UUID_STR_LEN + 1];
 	int i;
@@ -1400,17 +1400,17 @@ DEBUG_sessionprint( inv_session_t *ses, uint ref, invt_pr_ctx_t *prctx)
 
        invt_mobjinfo_t *mobj = &prctx->mobj;
 
-	bool_t  moidsearch = ( mobj && mobj->type != INVT_NULLTYPE );
-	if ( moidsearch ){
+	bool_t  moidsearch = (mobj && mobj->type != INVT_NULLTYPE);
+	if (moidsearch){
 		if (!check_for_mobj (ses, mobj))
 			return;
 	}
 
-	if ( ref == 0 || fsidxprinted != (uint) prctx->index ) {
+	if (ref == 0 || fsidxprinted != (uint) prctx->index) {
 		fsidxprinted = (uint) prctx->index;
 
 		printf("file system %d:\n", prctx->index);
-		uuid_unparse( ses->s_fsid, str );
+		uuid_unparse(ses->s_fsid, str);
 		printf("\tfs id:\t\t%s\n", str);
 	}
 
@@ -1423,73 +1423,73 @@ DEBUG_sessionprint( inv_session_t *ses, uint ref, invt_pr_ctx_t *prctx)
 	printf("\tsession %d:\n", ref);
 	printf("\t\tmount point:\t%s\n", ses->s_mountpt);
 	printf("\t\tdevice:\t\t%s\n", ses->s_devpath);
-	printf("\t\ttime:\t\t%s", ctime32( &ses->s_time ));
+	printf("\t\ttime:\t\t%s", ctime32(&ses->s_time));
 	printf("\t\tsession label:\t\"%s\"\n", ses->s_label);
-	uuid_unparse( ses->s_sesid, str );
+	uuid_unparse(ses->s_sesid, str);
 	printf("\t\tsession id:\t%s\n", str);
 	printf("\t\tlevel:\t\t%d\n", ses->s_level);
-	printf("\t\tresumed:\t%s\n", ses->s_isresumed ? "YES" : "NO" );
-	printf( "\t\tsubtree:\t%s\n", ses->s_ispartial ? "YES" : "NO" );
-	printf("\t\tstreams:\t%d\n", ses->s_nstreams );
+	printf("\t\tresumed:\t%s\n", ses->s_isresumed ? "YES" : "NO");
+	printf("\t\tsubtree:\t%s\n", ses->s_ispartial ? "YES" : "NO");
+	printf("\t\tstreams:\t%d\n", ses->s_nstreams);
 
-	if (prctx->depth == PR_SESSONLY )
+	if (prctx->depth == PR_SESSONLY)
 		return;
 
-	for (i = 0; i < (int) ses->s_nstreams; i++ ) {
+	for (i = 0; i < (int) ses->s_nstreams; i++) {
 		uint j;
-		printf("\t\tstream %d:\n", i );
-		printf( "\t\t\tpathname:\t%s\n", ses->s_streams[i].st_cmdarg );
-		printf( "\t\t\tstart:\t\tino %llu offset %lld\n",
+		printf("\t\tstream %d:\n", i);
+		printf("\t\t\tpathname:\t%s\n", ses->s_streams[i].st_cmdarg);
+		printf("\t\t\tstart:\t\tino %llu offset %lld\n",
 		        (unsigned long long)ses->s_streams[i].st_startino,
-		        (long long)ses->s_streams[i].st_startino_off );
-		printf( "\t\t\tend:\t\tino %llu offset %lld\n",
+		        (long long)ses->s_streams[i].st_startino_off);
+		printf("\t\t\tend:\t\tino %llu offset %lld\n",
 		        (unsigned long long)ses->s_streams[i].st_endino,
-		        (long long)ses->s_streams[i].st_endino_off );
-		printf( "\t\t\tinterrupted:\t%s\n",
-		        ses->s_streams[i].st_interrupted ? "YES" : "NO" );
-		printf( "\t\t\tmedia files:\t%d\n",
+		        (long long)ses->s_streams[i].st_endino_off);
+		printf("\t\t\tinterrupted:\t%s\n",
+		        ses->s_streams[i].st_interrupted ? "YES" : "NO");
+		printf("\t\t\tmedia files:\t%d\n",
 		        ses->s_streams[i].st_nmediafiles);
 
-		if (prctx->depth == PR_STRMSONLY )
+		if (prctx->depth == PR_STRMSONLY)
 			continue;
 
-		for ( j = 0 ; j < ses->s_streams[i].st_nmediafiles ; j++ ) {
+		for (j = 0 ; j < ses->s_streams[i].st_nmediafiles ; j++) {
 			mfp = &ses->s_streams[i].st_mediafiles[j];
-			if ( moidsearch ) {
-				if (! mobj_eql( mfp, mobj ) )
+			if (moidsearch) {
+				if (! mobj_eql(mfp, mobj) )
 					continue;
 			}
-			printf( "\t\t\tmedia file %d:", j );
+			printf("\t\t\tmedia file %d:", j);
 			/*
 			if (mfp->m_isinvdump)
 				printf(" SESSION INVENTORY");
 			*/
-			printf( "\n");
-			printf( "\t\t\t\tmfile index:\t%d\n", mfp->m_mfile_index );
-			printf( "\t\t\t\tmfile type:\t" );
+			printf("\n");
+			printf("\t\t\t\tmfile index:\t%d\n", mfp->m_mfile_index);
+			printf("\t\t\t\tmfile type:\t");
 			if (mfp->m_isinvdump) {
-				printf( "inventory\n" );
+				printf("inventory\n");
 			} else {
-				printf( "data\n" );
+				printf("data\n");
 			}
-			printf( "\t\t\t\tmfile size:\t%llu\n",
+			printf("\t\t\t\tmfile size:\t%llu\n",
 				(unsigned long long)mfp->m_size);
 
 			if (! mfp->m_isinvdump) {
-				printf( "\t\t\t\tmfile start:"
+				printf("\t\t\t\tmfile start:"
 					"\tino %llu offset %lld\n",
 					(unsigned long long)mfp->m_startino,
-					(long long)mfp->m_startino_off );
-				printf( "\t\t\t\tmfile end:"
+					(long long)mfp->m_startino_off);
+				printf("\t\t\t\tmfile end:"
 					"\tino %llu offset %lld\n",
 					(unsigned long long)mfp->m_endino,
-					(long long)mfp->m_endino_off );
+					(long long)mfp->m_endino_off);
 			}
 
-			printf( "\t\t\t\tmedia label:\t\"%s\"\n",
+			printf("\t\t\t\tmedia label:\t\"%s\"\n",
 				mfp->m_label);
-			uuid_unparse( mfp->m_moid, str );
-			printf( "\t\t\t\tmedia id:\t%s\n", str );
+			uuid_unparse(mfp->m_moid, str);
+			printf("\t\t\t\tmedia id:\t%s\n", str);
 		}
 	}
 }
diff --git a/inventory/inventory.h b/inventory/inventory.h
index 076b83e..ad27205 100644
--- a/inventory/inventory.h
+++ b/inventory/inventory.h
@@ -189,12 +189,12 @@ extern inv_idbtoken_t
 inv_open(
 	 inv_predicate_t bywhat, /* BY_UUID, BY_MOUNTPT, BY_DEVPATH */
 	 inv_oflag_t      forwhat,/* SEARCH_ONLY, SEARCH_N_MOD */
-	 void 		 *pred );/* uuid_t *,char * mntpt, or char *dev */
+	 void 		 *pred);/* uuid_t *,char * mntpt, or char *dev */
 
 
 extern bool_t
 inv_close(
-	inv_idbtoken_t	tok );
+	inv_idbtoken_t	tok);
 
 
 extern inv_sestoken_t
@@ -209,21 +209,21 @@ inv_writesession_open(
 	uint		nstreams,
 	time32_t	time,
 	char		*mntpt,
-	char		*devpath );
+	char		*devpath);
 
 extern bool_t
 inv_writesession_close(
-	inv_sestoken_t  tok );
+	inv_sestoken_t  tok);
 
 extern inv_stmtoken_t
 inv_stream_open(
 	inv_sestoken_t 	tok,
-	char		*cmdarg );
+	char		*cmdarg);
 
 extern bool_t
 inv_stream_close(
 	inv_stmtoken_t	tok,
-	bool_t 		wasinterrupted );
+	bool_t 		wasinterrupted);
 
 extern bool_t
 inv_put_mediafile(
@@ -291,29 +291,29 @@ extern bool_t
 inv_get_sessioninfo(
 	inv_sestoken_t		tok,
 	void		      **bufpp,		/* out */
-	size_t		       *bufszp );	/* out */
+	size_t		       *bufszp);	/* out */
 
 
 extern bool_t
-inv_delete_mediaobj( uuid_t *moid );
+inv_delete_mediaobj(uuid_t *moid);
 
 extern bool_t
-inv_DEBUG_print( int argc, char **argv );
+inv_DEBUG_print(int argc, char **argv);
 
 extern int
-inv_setup_base( void );
+inv_setup_base(void);
 
 extern char *
-inv_dirpath( void );
+inv_dirpath(void);
 
 extern char *
-inv_fstab( void );
+inv_fstab(void);
 
 extern char *
-inv_lockfile( void );
+inv_lockfile(void);
 
 extern char *
-inv_basepath( void );
+inv_basepath(void);
 
 
 #endif /* INVENTORY_H */
diff --git a/inventory/testmain.c b/inventory/testmain.c
index e43e392..c4003fd 100644
--- a/inventory/testmain.c
+++ b/inventory/testmain.c
@@ -52,28 +52,28 @@ static char *dev_str[] = { "/dev/usr/lib", "/dev/usr", "/dev/u/sw/courses",
 
 typedef enum { BULL = -1, WRI, REC, QUE, DEL, MP, QUE2 } hi;
 
-void usage( void );
+void usage(void);
 char *progname;
 char *sesfile;
 
 
 void
-CREAT_mfiles( inv_stmtoken_t tok, uuid_t *moid, ino_t f, ino_t n )
+CREAT_mfiles(inv_stmtoken_t tok, uuid_t *moid, ino_t f, ino_t n)
 {
 	uuid_t labelid;
 	char label[128], strbuf[20];
 	char *str;
 	unsigned int stat;
 
-	uuid_create( &labelid, &stat );
-	uuid_to_string( &labelid, &str, &stat );
-	strncpy( strbuf, str, 8 );
+	uuid_create(&labelid, &stat);
+	uuid_to_string(&labelid, &str, &stat);
+	strncpy(strbuf, str, 8);
 	free (str);
 	strbuf[8] = '\0';
-	sprintf(label,"%s_%s (%d-%d)\0","MEDIA_FILE", strbuf, (int)f, (int)n );
+	sprintf(label,"%s_%s (%d-%d)\0","MEDIA_FILE", strbuf, (int)f, (int)n);
 
-	inv_put_mediafile( tok, moid, label, 12, f, 0, n, 0, 0xffff,
-			  BOOL_TRUE, BOOL_FALSE );
+	inv_put_mediafile(tok, moid, label, 12, f, 0, n, 0, 0xffff,
+			  BOOL_TRUE, BOOL_FALSE);
 
 }
 
@@ -86,33 +86,33 @@ typedef struct ses{
 #define SESLIM  240
 
 int
-recons_test( int howmany )
+recons_test(int howmany)
 {
 	int fd, i, rval = 1;
 	off64_t off = 0;
 
-	ses sarr[ SESLIM];
+	ses sarr[SESLIM];
 
-	fd = open( sesfile, O_RDONLY );
+	fd = open(sesfile, O_RDONLY);
 
-	for ( i=0; i<howmany && i < SESLIM; i++ ){
-		rval = get_invtrecord( fd, &sarr[i],
-				       sizeof( uuid_t ) + sizeof( size_t ), off,
-				       BOOL_FALSE );
-		assert( rval > 0 );
-		assert( sarr[i].sz > 0 );
-		sarr[i].buf = calloc( 1,  sarr[i].sz );
+	for (i=0; i<howmany && i < SESLIM; i++){
+		rval = get_invtrecord(fd, &sarr[i],
+				       sizeof(uuid_t) + sizeof(size_t), off,
+				       BOOL_FALSE);
+		assert(rval > 0);
+		assert(sarr[i].sz > 0);
+		sarr[i].buf = calloc(1,  sarr[i].sz);
 		off += (off64_t)(sizeof(uuid_t) + sizeof(size_t));
-		rval = get_invtrecord( fd, sarr[i].buf,  sarr[i].sz, off,
-				       BOOL_FALSE );
-		assert( rval > 0 );
+		rval = get_invtrecord(fd, sarr[i].buf,  sarr[i].sz, off,
+				       BOOL_FALSE);
+		assert(rval > 0);
 		off += sarr[i].sz;
 	}
 
 
 
-	for ( i=0; i<howmany && i < SESLIM; i++ ){
-		if ( inv_put_sessioninfo( sarr[i].buf, sarr[i].sz ) < 0)
+	for (i=0; i<howmany && i < SESLIM; i++){
+		if (inv_put_sessioninfo(sarr[i].buf, sarr[i].sz) < 0)
 			printf("$ insert failed.\n");
 	}
 
@@ -125,21 +125,21 @@ recons_test( int howmany )
 
 
 int
-delete_test( int n )
+delete_test(int n)
 {
 	int fd, i;
 	uuid_t moid;
 	char *str = 0;
 	unsigned int stat;
 
-	fd = open( "moids", O_RDONLY );
-	if ( fd < 0 ) return -1;
+	fd = open("moids", O_RDONLY);
+	if (fd < 0) return -1;
 
-	get_invtrecord( fd, &moid, sizeof(uuid_t), (n-1)* sizeof( uuid_t), 0 );
-	uuid_to_string( &moid, &str, &stat );
-	printf("Searching for Moid = %s\n", str );
-	free( str );
-	if (! inv_delete_mediaobj( &moid ) ) return -1;
+	get_invtrecord(fd, &moid, sizeof(uuid_t), (n-1)* sizeof(uuid_t), 0);
+	uuid_to_string(&moid, &str, &stat);
+	printf("Searching for Moid = %s\n", str);
+	free(str);
+	if (! inv_delete_mediaobj(&moid) ) return -1;
 
 	return 1;
 
@@ -193,7 +193,7 @@ sess_queries_bylabel(char *lab)
 
 
 int
-query_test( int level )
+query_test(int level)
 {
 	int i;
 	inv_idbtoken_t tok;
@@ -203,40 +203,40 @@ query_test( int level )
 
 	if (level == -2) {
 		printf("mount pt %s\n",sesfile);
-		tok = inv_open( INV_BY_MOUNTPT, INV_SEARCH_ONLY, sesfile );
-		if (! tok ) return -1;
+		tok = inv_open(INV_BY_MOUNTPT, INV_SEARCH_ONLY, sesfile);
+		if (! tok) return -1;
 		idx_DEBUG_print (tok->d_invindex_fd);
 		return 1;
 	}
 
 	for (i = 7; i<8; i++) {
 		printf("\n\n\n----------------------------------\n"
-		       "$ Searching fs %s\n", mnt_str[7-i] );
-		tok = inv_open( INV_BY_MOUNTPT, INV_SEARCH_ONLY, mnt_str[7-i] );
-		if (! tok ) return -1;
+		       "$ Searching fs %s\n", mnt_str[7-i]);
+		tok = inv_open(INV_BY_MOUNTPT, INV_SEARCH_ONLY, mnt_str[7-i]);
+		if (! tok) return -1;
 
 		prctx.index = i;
-		if (level == -1 )
-			invmgr_inv_print( tok->d_invindex_fd, &prctx );
+		if (level == -1)
+			invmgr_inv_print(tok->d_invindex_fd, &prctx);
 		else {
-		if (inv_lasttime_level_lessthan( tok, level, &tm ) && tm) {
-			printf("\n\nTIME %s %ld\n", ctime(tm), (long) *tm );
+		if (inv_lasttime_level_lessthan(tok, level, &tm) && tm) {
+			printf("\n\nTIME %s %ld\n", ctime(tm), (long) *tm);
 			free (tm);
 		}
-		if (inv_lastsession_level_lessthan( tok, level, &ses ) && ses) {
-			DEBUG_sessionprint( ses, 99, &prctx);
-			free ( ses->s_streams );
-			free ( ses );
+		if (inv_lastsession_level_lessthan(tok, level, &ses) && ses) {
+			DEBUG_sessionprint(ses, 99, &prctx);
+			free (ses->s_streams);
+			free (ses);
 		}
 
-		if (inv_lastsession_level_equalto( tok, level, &ses ) && ses) {
+		if (inv_lastsession_level_equalto(tok, level, &ses) && ses) {
 			printf("Gotcha\n");
-			DEBUG_sessionprint( ses, 99, &prctx );
-			free ( ses->s_streams );
-			free ( ses );
+			DEBUG_sessionprint(ses, 99, &prctx);
+			free (ses->s_streams);
+			free (ses);
 		}
 	        }
-		inv_close( tok );
+		inv_close(tok);
 	}
 	return 1;
 }
@@ -249,7 +249,7 @@ query_test( int level )
 /*----------------------------------------------------------------------*/
 
 int
-write_test( int nsess, int nstreams, int nmedia, int dumplevel )
+write_test(int nsess, int nstreams, int nmedia, int dumplevel)
 {
 	int i,j,k,m,fd;
 	unsigned int stat;
@@ -274,23 +274,23 @@ write_test( int nsess, int nstreams, int nmedia, int dumplevel )
 #ifdef FIRSTTIME
 	printf("first time!\n");
 	for (i=0; i<8; i++) {
-		uuid_create( &fsidarr[i], &stat );
-		assert ( stat == uuid_s_ok );
-		uuid_create( &sesidarr[i], &stat );
-		assert ( stat == uuid_s_ok );
+		uuid_create(&fsidarr[i], &stat);
+		assert (stat == uuid_s_ok);
+		uuid_create(&sesidarr[i], &stat);
+		assert (stat == uuid_s_ok);
 	}
-	fd = open( "uuids", O_RDWR | O_CREAT );
-	PUT_REC(fd, (void *)fsidarr, sizeof (uuid_t) * 8, 0L );
-	PUT_REC(fd, (void *)sesidarr, sizeof (uuid_t) * 8, sizeof (uuid_t) * 8 );
+	fd = open("uuids", O_RDWR | O_CREAT);
+	PUT_REC(fd, (void *)fsidarr, sizeof (uuid_t) * 8, 0L);
+	PUT_REC(fd, (void *)sesidarr, sizeof (uuid_t) * 8, sizeof (uuid_t) * 8);
 	close(fd);
 #endif
-	fd = open("uuids", O_RDONLY );
-	GET_REC( fd, fsidarr, sizeof (uuid_t) * 8, 0L );
-	GET_REC( fd, sesidarr, sizeof (uuid_t) * 8, sizeof (uuid_t) * 8 );
+	fd = open("uuids", O_RDONLY);
+	GET_REC(fd, fsidarr, sizeof (uuid_t) * 8, 0L);
+	GET_REC(fd, sesidarr, sizeof (uuid_t) * 8, sizeof (uuid_t) * 8);
 	close(fd);
 #ifdef RECONS
-	rfd = open( sesfile, O_RDWR | O_CREAT );
-	fchmod( rfd, INV_PERMS );
+	rfd = open(sesfile, O_RDWR | O_CREAT);
+	fchmod(rfd, INV_PERMS);
 	if (fstat64(fd, &statbuf) < 0) {
 		perror("fstat64 session file");
 		return -1;
@@ -298,22 +298,22 @@ write_test( int nsess, int nstreams, int nmedia, int dumplevel )
 	off = (off64_t)statbuf.st_size;
 #endif
 
-	for ( i = 0; i < nsess; i++ ) {
+	for (i = 0; i < nsess; i++) {
 		j = i % 8;
 		/*mnt = mnt_str[j];
 		dev = dev_str[7-j];*/
 		mnt = mnt_str[0];
 		dev = dev_str[7];
 		fsidp = &fsidarr[0]; /* j */
-		tok1 = inv_open( INV_BY_UUID, INV_SEARCH_N_MOD, fsidp );
-		assert (tok1 != INV_TOKEN_NULL );
+		tok1 = inv_open(INV_BY_UUID, INV_SEARCH_N_MOD, fsidp);
+		assert (tok1 != INV_TOKEN_NULL);
 
-		uuid_create( &labelid, &stat );
-		uuid_to_string( &labelid, &str, &stat );
-		strncpy( strbuf, str, 8 );
+		uuid_create(&labelid, &stat);
+		uuid_to_string(&labelid, &str, &stat);
+		strncpy(strbuf, str, 8);
 		free (str);
 		strbuf[8] = '\0';
-		sprintf(label,"%s_%s (%d)\0","SESSION_LABEL", strbuf, i );
+		sprintf(label,"%s_%s (%d)\0","SESSION_LABEL", strbuf, i);
 
 		tok2 = inv_writesession_open(tok1, fsidp,
 					     &labelid,
@@ -322,47 +322,47 @@ write_test( int nsess, int nstreams, int nmedia, int dumplevel )
 					     (bool_t)i%2,
 					     dumplevel, nstreams,
 					     time(NULL),
-					     mnt, dev );
-		assert (tok2 != INV_TOKEN_NULL );
+					     mnt, dev);
+		assert (tok2 != INV_TOKEN_NULL);
 		for (m = 0; m<nstreams; m++) {
-			tok3 = inv_stream_open( tok2,"/dev/rmt");
-			assert (tok3 != INV_TOKEN_NULL );
+			tok3 = inv_stream_open(tok2,"/dev/rmt");
+			assert (tok3 != INV_TOKEN_NULL);
 
-			for (k = 0; k<nmedia; k++ )
-				CREAT_mfiles( tok3, &labelid, k*100,
-					      k*100 + 99 );
-			inv_stream_close( tok3, BOOL_TRUE );
+			for (k = 0; k<nmedia; k++)
+				CREAT_mfiles(tok3, &labelid, k*100,
+					      k*100 + 99);
+			inv_stream_close(tok3, BOOL_TRUE);
 		}
 
 #ifdef RECONS
-		if (inv_get_sessioninfo( tok2, &bufp, &sz ) == BOOL_TRUE ) {
-			put_invtrecord( rfd, fsidp, sizeof( uuid_t ), off,
-					BOOL_FALSE );
+		if (inv_get_sessioninfo(tok2, &bufp, &sz) == BOOL_TRUE) {
+			put_invtrecord(rfd, fsidp, sizeof(uuid_t), off,
+					BOOL_FALSE);
 			off += (off64_t)sizeof(uuid_t);
-			put_invtrecord( rfd, &sz, sizeof( size_t ), off,
+			put_invtrecord(rfd, &sz, sizeof(size_t), off,
 					BOOL_FALSE);
 			off += (off64_t)sizeof(size_t);
-			put_invtrecord( rfd, bufp, sz, off, BOOL_FALSE );
+			put_invtrecord(rfd, bufp, sz, off, BOOL_FALSE);
 		}
 #endif
 #ifdef NOTDEF
-		if (inv_get_sessioninfo( tok2, &bufp, &sz ) == BOOL_TRUE )
-			inv_put_sessioninfo(  fsidp, bufp, sz );
+		if (inv_get_sessioninfo(tok2, &bufp, &sz) == BOOL_TRUE)
+			inv_put_sessioninfo(fsidp, bufp, sz);
 #endif
-		inv_writesession_close( tok2 );
-		inv_close( tok1 );
+		inv_writesession_close(tok2);
+		inv_close(tok1);
 	}
 #ifdef RECONS
-	close( rfd );
+	close(rfd);
 #endif
 	return 1;
 }
 
 
-void usage( void )
+void usage(void)
 {
-	printf("( %s ./inv w|r|q -v <verbosity> -s <nsess>"
-	       "-t <strms> -m <nmediafiles> \n", optarg );
+	printf("(%s ./inv w|r|q -v <verbosity> -s <nsess>"
+	       "-t <strms> -m <nmediafiles> \n", optarg);
 }
 
 
@@ -370,8 +370,8 @@ int
 mp_test(int nstreams)
 {
 #if 0
-	tok1 = inv_open( INV_BY_UUID, fsidp );
-	assert (tok1 != INV_TOKEN_NULL );
+	tok1 = inv_open(INV_BY_UUID, fsidp);
+	assert (tok1 != INV_TOKEN_NULL);
 
 	tok2 = inv_writesession_open(tok1, fsidp,
 				     &labelid,
@@ -380,17 +380,17 @@ mp_test(int nstreams)
 				     (bool_t)i%2,
 				     dumplevel, nstreams,
 				     time(NULL),
-				     mnt, dev );
-	assert (tok2 != INV_TOKEN_NULL );
+				     mnt, dev);
+	assert (tok2 != INV_TOKEN_NULL);
 
 	for (m = 0; m<nstreams; m++) {
-			tok3 = inv_stream_open( tok2,"/dev/rmt");
-			assert (tok3 != INV_TOKEN_NULL );
+			tok3 = inv_stream_open(tok2,"/dev/rmt");
+			assert (tok3 != INV_TOKEN_NULL);
 
-			for (k = 0; k<nmedia; k++ )
-				CREAT_mfiles( tok3, &labelid, k*100,
-					      k*100 + 99 );
-			inv_stream_close( tok3, BOOL_TRUE );
+			for (k = 0; k<nmedia; k++)
+				CREAT_mfiles(tok3, &labelid, k*100,
+					      k*100 + 99);
+			inv_stream_close(tok3, BOOL_TRUE);
 		}
 #endif
 }
@@ -417,9 +417,9 @@ main(int argc, char *argv[])
 
 	progname = argv[0];
 	sesfile = "sessions";
-	assert( argc > 1 );
+	assert(argc > 1);
 
-	mlog_init( argc, argv );
+	mlog_init(argc, argv);
 
 	if (! inv_DEBUG_print(argc, argv))
 		return 0;
@@ -427,8 +427,8 @@ main(int argc, char *argv[])
 	optind = 1;
 	optarg = 0;
 
-	while( ( cc = getopt( argc, argv, GETOPT_CMDSTRING)) != EOF ) {
-		switch ( cc ) {
+	while((cc = getopt(argc, argv, GETOPT_CMDSTRING)) != EOF) {
+		switch (cc) {
 		      case 'w':
 			op = WRI;
 			break;
@@ -473,7 +473,7 @@ main(int argc, char *argv[])
 			break;
 
 		      case 'm':
-			nmedia = atoi( optarg );
+			nmedia = atoi(optarg);
 			break;
 		      case 'v':
 			break;
@@ -489,17 +489,17 @@ main(int argc, char *argv[])
 	}
 
 
-	if ( op == WRI )
-		rval = write_test( nsess, nstreams, nmedia, level );
-	else if ( op == QUE )
-		rval = query_test( level );
-	else if ( op == REC )
-		rval = recons_test( nsess );
-	else if ( op == DEL )
-		rval = delete_test( nsess );
-	else if ( op == MP )
+	if (op == WRI)
+		rval = write_test(nsess, nstreams, nmedia, level);
+	else if (op == QUE)
+		rval = query_test(level);
+	else if (op == REC)
+		rval = recons_test(nsess);
+	else if (op == DEL)
+		rval = delete_test(nsess);
+	else if (op == MP)
 		rval = mp_test (nstreams);
-	else if ( op == QUE2 ) {
+	else if (op == QUE2) {
 		if (uuid)
 			rval = sess_queries_byuuid(uuid);
 		else if (label)
@@ -508,10 +508,10 @@ main(int argc, char *argv[])
 	else
 		usage();
 
-	if (rval < 0 )
-		printf( "aborted\n");
+	if (rval < 0)
+		printf("aborted\n");
 	else
-		printf( "done\n" );
+		printf("done\n");
 
 
 }
diff --git a/invutil/cmenu.h b/invutil/cmenu.h
index a9788f2..f3c205f 100644
--- a/invutil/cmenu.h
+++ b/invutil/cmenu.h
@@ -44,18 +44,18 @@ typedef enum {
 } alignment_t;
 
 typedef struct menu_ops_s {
-    int (* op_delete		) (WINDOW *win, node_t *current, node_t *list);
-    int (* op_undelete		) (WINDOW *win, node_t *current, node_t *list);
-    int (* op_saveexit		) (WINDOW *win, node_t *current, node_t *list);
-    int (* op_select		) (WINDOW *win, node_t *current, node_t *list);
-    int (* op_collapse		) (WINDOW *win, node_t *current, node_t *list);
-    int (* op_expand		) (WINDOW *win, node_t *current, node_t *list);
-    int (* op_collapseall	) (WINDOW *win, node_t *current, node_t *list);
-    int (* op_expandall		) (WINDOW *win, node_t *current, node_t *list);
-    int (* op_highlight		) (WINDOW *win, node_t *current, node_t *list);
-    int (* op_unhighlight	) (WINDOW *win, node_t *current, node_t *list);
-    int (* op_commit		) (WINDOW *win, node_t *current, node_t *list);
-    int (* op_prune		) (char *mountpt, uuid_t *uuidp, time32_t prunetime, node_t *node, node_t *list);
+    int (* op_delete) (WINDOW *win, node_t *current, node_t *list);
+    int (* op_undelete) (WINDOW *win, node_t *current, node_t *list);
+    int (* op_saveexit) (WINDOW *win, node_t *current, node_t *list);
+    int (* op_select) (WINDOW *win, node_t *current, node_t *list);
+    int (* op_collapse) (WINDOW *win, node_t *current, node_t *list);
+    int (* op_expand) (WINDOW *win, node_t *current, node_t *list);
+    int (* op_collapseall) (WINDOW *win, node_t *current, node_t *list);
+    int (* op_expandall) (WINDOW *win, node_t *current, node_t *list);
+    int (* op_highlight) (WINDOW *win, node_t *current, node_t *list);
+    int (* op_unhighlight) (WINDOW *win, node_t *current, node_t *list);
+    int (* op_commit) (WINDOW *win, node_t *current, node_t *list);
+    int (* op_prune) (char *mountpt, uuid_t *uuidp, time32_t prunetime, node_t *node, node_t *list);
 } menu_ops_t;
 
 typedef struct {
diff --git a/invutil/fstab.c b/invutil/fstab.c
index a4333ad..3319a5c 100644
--- a/invutil/fstab.c
+++ b/invutil/fstab.c
@@ -83,7 +83,7 @@ fstab_commit(WINDOW *win, node_t *current, node_t *list)
 
 	fstabentry_idx = (int)(((long)fstabentry - (long)fstab_file[fidx].mapaddr - sizeof(invt_counter_t)) / sizeof(invt_fstab_t));
 
-	if ( fstab_file[fidx].counter->ic_curnum > 1 ) {
+	if (fstab_file[fidx].counter->ic_curnum > 1) {
 	    memmove(fstabentry,
 		    fstabentry + 1,
 		    (sizeof(invt_fstab_t) * (fstab_file[fidx].counter->ic_curnum - fstabentry_idx - 1)));
@@ -355,7 +355,7 @@ remmap_fstab(int fidx, int num)
 
     nEntries = fstab_file[fidx].counter->ic_curnum;
 
-    munmap( fstab_file[fidx].mapaddr,
+    munmap(fstab_file[fidx].mapaddr,
 	    (nEntries * sizeof(invt_fstab_t)) + sizeof(invt_counter_t));
 
     /* need to lseek on the file to grow it to the right size - no autogrow on linux */
@@ -395,9 +395,9 @@ open_fstab(char *fstabname)
     char		*name;
     invt_counter_t	cnt;
 
-    fd = open_and_lock( fstabname, FILE_WRITE, wait_for_locks );
+    fd = open_and_lock(fstabname, FILE_WRITE, wait_for_locks);
     if (fd < 0) {
-	fprintf( stderr, "%s: abnormal termination\n", g_programName );
+	fprintf(stderr, "%s: abnormal termination\n", g_programName);
 	exit(1);
     }
 
@@ -426,7 +426,7 @@ close_fstab(int fidx)
 
     fstabentries = fstab_file[fidx].counter->ic_curnum;
 
-    munmap( fstab_file[fidx].mapaddr,
+    munmap(fstab_file[fidx].mapaddr,
 	    (fstab_file[fidx].counter->ic_curnum * sizeof(invt_fstab_t)) + sizeof(invt_counter_t));
 
     if ((fstabentries != 0)  && (fstabentries < fstab_file[fidx].nEntries)) {
@@ -437,7 +437,7 @@ close_fstab(int fidx)
     close(fstab_file[fidx].fd);
 
     if (fstabentries == 0) {
-	unlink( fstab_file[fidx].name );
+	unlink(fstab_file[fidx].name);
     }
 
     free(fstab_file[fidx].name);
diff --git a/invutil/invidx.c b/invutil/invidx.c
index 5e540a3..9944bd0 100644
--- a/invutil/invidx.c
+++ b/invutil/invidx.c
@@ -47,7 +47,7 @@ int invidx_numfiles;
 extern stobj_fileinfo_t *stobj_file;
 extern int stobj_numfiles;
 
-static void stobj_makefname_len( char *fname, int fname_len );
+static void stobj_makefname_len(char *fname, int fname_len);
 
 menu_ops_t invidx_ops = {
     NULL,
@@ -94,7 +94,7 @@ invidx_commit(WINDOW *win, node_t *current, node_t *list)
 	}
 	mark_all_children_commited(current);
 
-	if ( invidx_file[fidx].counter->ic_curnum > 1 ) {
+	if (invidx_file[fidx].counter->ic_curnum > 1) {
 	    memmove(&inv_entry[idx],
 		    &inv_entry[idx + 1],
 		    (sizeof(invt_entry_t) * (invidx_file[fidx].counter->ic_curnum - idx - 1)));
@@ -547,7 +547,7 @@ insert_stobj_into_stobjfile(int invidx_fileidx, char *filename, int fd,
     }
 
     /* stobj file not full, just insert the entry */
-    hdr->sh_sess_off = STOBJ_OFFSET( sescnt.ic_maxnum, pos);
+    hdr->sh_sess_off = STOBJ_OFFSET(sescnt.ic_maxnum, pos);
     hdr->sh_streams_off = sescnt.ic_eof;
 
     /* for seshdr: malloc buffer, copy new entry into buffer, read file entries into buffer, write the lot out */
@@ -584,31 +584,31 @@ insert_stobj_into_stobjfile(int invidx_fileidx, char *filename, int fd,
 }
 
 static void
-stobj_makefname_len( char *fname, int fname_len )
+stobj_makefname_len(char *fname, int fname_len)
 {
     /* come up with a new unique name */
     uuid_t	fn;
     char	str[UUID_STR_LEN + 1];
 
-    uuid_generate( fn );
-    uuid_unparse( fn, str );
+    uuid_generate(fn);
+    uuid_unparse(fn, str);
 
     snprintf(fname, fname_len, "%s/%s.StObj", inventory_path, str);
 }
 
 int
-stobj_create( char *fname )
+stobj_create(char *fname)
 {
     int fd;
     invt_sescounter_t sescnt;
 
     /* create the new storage object */
-    if (( fd = open( fname, O_RDWR | O_EXCL | O_CREAT, S_IRUSR|S_IWUSR )) < 0 ) {
+    if ((fd = open(fname, O_RDWR | O_EXCL | O_CREAT, S_IRUSR|S_IWUSR)) < 0) {
 	return -1;
     }
 
-    INVLOCK( fd, LOCK_EX );
-    fchmod( fd, INV_PERMS );
+    INVLOCK(fd, LOCK_EX);
+    fchmod(fd, INV_PERMS);
 
     memset(&sescnt, 0, sizeof(sescnt));
     sescnt.ic_vernum = INV_VERSION;
@@ -617,51 +617,51 @@ stobj_create( char *fname )
     sescnt.ic_eof = SC_EOF_INITIAL_POS;
 
     lseek(fd, 0, SEEK_SET);
-    write_n_bytes ( fd, (char *)&sescnt, sizeof(sescnt), "new stobj file" );
+    write_n_bytes (fd, (char *)&sescnt, sizeof(sescnt), "new stobj file");
 
-    INVLOCK( fd, LOCK_UN );
+    INVLOCK(fd, LOCK_UN);
     return fd;
 }
 
 int
-stobj_put_streams( int fd, invt_seshdr_t *hdr, invt_session_t *ses,
+stobj_put_streams(int fd, invt_seshdr_t *hdr, invt_session_t *ses,
 		   invt_stream_t *strms,
-		   invt_mediafile_t *mfiles )
+		   invt_mediafile_t *mfiles)
 {
     uint	nstm	= ses->s_cur_nstreams;
     off64_t	off	= hdr->sh_streams_off;
-    off64_t	mfileoff= off + (off64_t)( nstm * sizeof( invt_stream_t ) );
+    off64_t	mfileoff= off + (off64_t)(nstm * sizeof(invt_stream_t) );
     uint	nmfiles = 0;
     uint	i,j;
 
     /* fix the offsets in streams */
-     for ( i = 0; i < nstm; i++ ) {
-	strms[i].st_firstmfile = mfileoff + (off64_t) ((size_t) nmfiles * sizeof( invt_mediafile_t ) );
+     for (i = 0; i < nstm; i++) {
+	strms[i].st_firstmfile = mfileoff + (off64_t) ((size_t) nmfiles * sizeof(invt_mediafile_t) );
 	/* now fix the offsets in mediafiles */
-	for ( j = 0; j < strms[i].st_nmediafiles; j++ ) {
+	for (j = 0; j < strms[i].st_nmediafiles; j++) {
 
 	    /* no need to fix the last element's next ptr */
-	    if ( j < strms[i].st_nmediafiles - 1 )
-		mfiles[ nmfiles + j ].mf_nextmf =  strms[i].st_firstmfile + (off64_t) ((j+1) * sizeof( invt_mediafile_t ));
+	    if (j < strms[i].st_nmediafiles - 1)
+		mfiles[nmfiles + j].mf_nextmf =  strms[i].st_firstmfile + (off64_t) ((j+1) * sizeof(invt_mediafile_t));
 
 	    /* no need to fix the first element's prev ptr */
-	    if ( j )
-		mfiles[ nmfiles + j ].mf_prevmf = strms[i].st_firstmfile + (off64_t) ((j-1) * sizeof( invt_mediafile_t ));
+	    if (j)
+		mfiles[nmfiles + j].mf_prevmf = strms[i].st_firstmfile + (off64_t) ((j-1) * sizeof(invt_mediafile_t));
 	}
 
 	/* adjust the offsets of the first and the last elements
 	   in the mediafile chain */
-	mfiles[ nmfiles ].mf_prevmf = 0;
+	mfiles[nmfiles].mf_prevmf = 0;
 	nmfiles += strms[i].st_nmediafiles;
-	mfiles[ nmfiles - 1 ].mf_nextmf = 0;
+	mfiles[nmfiles - 1].mf_nextmf = 0;
     }
 
     /* first put the streams. hdr already points at the right place */
     lseek(fd, off, SEEK_SET);
-    write_n_bytes( fd, strms, nstm * sizeof( invt_stream_t ), "stobj file" );
+    write_n_bytes(fd, strms, nstm * sizeof(invt_stream_t), "stobj file");
 
     lseek(fd, mfileoff, SEEK_SET);
-    write_n_bytes( fd, mfiles, nmfiles * sizeof( invt_mediafile_t ), "stobj file" );
+    write_n_bytes(fd, mfiles, nmfiles * sizeof(invt_mediafile_t), "stobj file");
 
     return 1;
 }
@@ -834,7 +834,7 @@ find_invidx_insert_pos(int fidx, invt_entry_t *inv_entry)
 	next_entry = invidx_file[fidx].data[i+1];
 
 	if(inv_entry->ie_timeperiod.tp_start > entry->ie_timeperiod.tp_end
-	   && inv_entry->ie_timeperiod.tp_end < next_entry->ie_timeperiod.tp_start ) {
+	   && inv_entry->ie_timeperiod.tp_end < next_entry->ie_timeperiod.tp_start) {
 	    return i;
 	}
     }
@@ -916,7 +916,7 @@ generate_invidx_menu(char * inv_path, node_t *startnode, int level, char *idxFil
 	return startnode;
     }
 
-    invidx_entry = (invt_entry_t *)( invidx_file[idx].mapaddr + sizeof(invt_counter_t));
+    invidx_entry = (invt_entry_t *)(invidx_file[idx].mapaddr + sizeof(invt_counter_t));
 
     n = startnode;
     for (i=0; i < invidx_file[idx].counter->ic_curnum; i++) {
@@ -947,7 +947,7 @@ generate_invidx_menu(char * inv_path, node_t *startnode, int level, char *idxFil
 
 	add_invidx_data(idx, &(invidx_entry[i]));
 	stobjname = GetNameOfStobj(inv_path, invidx_entry[i].ie_filename);
-	n = generate_stobj_menu( n, level + 1, stobjname );
+	n = generate_stobj_menu(n, level + 1, stobjname);
 	free(stobjname);
     }
 
@@ -1001,7 +1001,7 @@ remmap_invidx(int fidx, int num)
 
     nEntries = invidx_file[fidx].counter->ic_curnum;
 
-    munmap( invidx_file[fidx].mapaddr,
+    munmap(invidx_file[fidx].mapaddr,
 	    (nEntries * sizeof(invt_entry_t)) + sizeof(invt_counter_t));
 
     /* need to lseek on the file to grow it to the right size - no autogrow on linux */
@@ -1042,7 +1042,7 @@ open_invidx(char *idxFileName)
     invt_counter_t header;
 
     errno=0;
-    fd = open_and_lock( idxFileName, FILE_WRITE, wait_for_locks );
+    fd = open_and_lock(idxFileName, FILE_WRITE, wait_for_locks);
     if (fd < 0) {
         return fd;
     }
@@ -1053,7 +1053,7 @@ open_invidx(char *idxFileName)
 	exit(1);
     }
 
-    read_n_bytes( fd, &header, sizeof(invt_counter_t), idxFileName);
+    read_n_bytes(fd, &header, sizeof(invt_counter_t), idxFileName);
 
     nEntries = header.ic_curnum;
 
@@ -1075,21 +1075,21 @@ close_invidx(int idx)
 	return 0;
 
     nEntries = invidx_file[idx].counter->ic_curnum;
-    munmap( invidx_file[idx].mapaddr,
-	    (invidx_file[idx].nEntries*sizeof(invt_entry_t)) + sizeof(invt_counter_t) );
+    munmap(invidx_file[idx].mapaddr,
+	    (invidx_file[idx].nEntries*sizeof(invt_entry_t)) + sizeof(invt_counter_t));
 
     if(nEntries != 0 && nEntries != invidx_file[idx].nEntries) {
 	ftruncate(invidx_file[idx].fd,
-		  sizeof(invt_counter_t) + (nEntries * sizeof(invt_entry_t)) );
+		  sizeof(invt_counter_t) + (nEntries * sizeof(invt_entry_t)));
     }
 
-    close( invidx_file[idx].fd );
+    close(invidx_file[idx].fd);
 
     if(nEntries == 0) {
 	unlink(invidx_file[idx].name);
     }
-    free( invidx_file[idx].name );
-    free( invidx_file[idx].data );
+    free(invidx_file[idx].name);
+    free(invidx_file[idx].data);
 
     invidx_file[idx].fd = -1;
     invidx_file[idx].name = NULL;
diff --git a/invutil/invutil.c b/invutil/invutil.c
index e06b1f4..242574f 100644
--- a/invutil/invutil.c
+++ b/invutil/invutil.c
@@ -78,51 +78,51 @@ main(int argc, char *argv[])
     uuid_clear(uuid);
     uuid_clear(session);
 
-    while((c = getopt( argc, argv, GETOPT_CMDSTRING)) != EOF) {
+    while((c = getopt(argc, argv, GETOPT_CMDSTRING)) != EOF) {
 	switch(c) {
 	case GETOPT_DEBUG:
 	    debug = BOOL_TRUE;
 	    break;
 	case GETOPT_INTERACTIVE:
 	    if (force) {
-		fprintf( stderr, "%s: may not specify both -%c and -%c\n",
+		fprintf(stderr, "%s: may not specify both -%c and -%c\n",
 			 g_programName,
 			 GETOPT_FORCE,
-			 c );
+			 c);
 		usage();
 	    }
 	    if (session_option) {
-		fprintf( stderr, "%s: may not specify both -%c and -%c\n",
+		fprintf(stderr, "%s: may not specify both -%c and -%c\n",
 			 g_programName,
 			 GETOPT_PRUNESESSION,
-			 c );
+			 c);
 		usage();
 	    }
 	    interactive_option = BOOL_TRUE;
 	    break;
 	case GETOPT_NONINTERACTIVE: /* obsoleted by -F */
 	    if (interactive_option) {
-		fprintf( stderr, "%s: may not specify both -%c and -%c\n",
+		fprintf(stderr, "%s: may not specify both -%c and -%c\n",
 			 g_programName,
 			 GETOPT_INTERACTIVE,
-			 c );
+			 c);
 		usage();
 	    }
 	    force = BOOL_TRUE;
 	    break;
 	case GETOPT_UUID:
 	    if (check_option) {
-		fprintf( stderr, "%s: may not specify both -%c and -%c\n",
+		fprintf(stderr, "%s: may not specify both -%c and -%c\n",
 			 g_programName,
 			 GETOPT_CHECKPRUNEFSTAB,
-			 c );
+			 c);
 		usage();
 	    }
 	    if (mntpnt_option || session_option) {
-		fprintf( stderr, "%s: may not specify both -%c and -%c\n",
+		fprintf(stderr, "%s: may not specify both -%c and -%c\n",
 			 g_programName,
 			 mntpnt_option ? GETOPT_PRUNEMNT : GETOPT_PRUNESESSION,
-			 c );
+			 c);
 		usage();
 	    }
 	    uuid_option = BOOL_TRUE;
@@ -133,51 +133,51 @@ main(int argc, char *argv[])
 	    break;
 	case GETOPT_CHECKPRUNEFSTAB:
 	    if (mntpnt_option) {
-		fprintf( stderr, "%s: may not specify both -%c and -%c\n",
+		fprintf(stderr, "%s: may not specify both -%c and -%c\n",
 			 g_programName,
 			 GETOPT_PRUNEMNT,
-			 c );
+			 c);
 		usage();
 	    }
 	    if (uuid_option) {
-		fprintf( stderr, "%s: may not specify both -%c and -%c\n",
+		fprintf(stderr, "%s: may not specify both -%c and -%c\n",
 			 g_programName,
 			 GETOPT_UUID,
-			 c );
+			 c);
 		usage();
 	    }
 	    if (session_option) {
-		fprintf( stderr, "%s: may not specify both -%c and -%c\n",
+		fprintf(stderr, "%s: may not specify both -%c and -%c\n",
 			 g_programName,
 			 GETOPT_PRUNESESSION,
-			 c );
+			 c);
 		usage();
 	    }
 	    check_option = BOOL_TRUE;
 	    break;
 	case GETOPT_FORCE:
 	    if (interactive_option) {
-		fprintf( stderr, "%s: may not specify both -%c and -%c\n",
+		fprintf(stderr, "%s: may not specify both -%c and -%c\n",
 			 g_programName,
 			 GETOPT_INTERACTIVE,
-			 c );
+			 c);
 		usage();
 	    }
 	    force = BOOL_TRUE;
 	    break;
 	case GETOPT_PRUNEMNT:
 	    if (check_option) {
-		fprintf( stderr, "%s: may not specify both -%c and -%c\n",
+		fprintf(stderr, "%s: may not specify both -%c and -%c\n",
 			 g_programName,
 			 GETOPT_CHECKPRUNEFSTAB,
-			 c );
+			 c);
 		usage();
 	    }
 	    if (uuid_option || session_option) {
-		fprintf( stderr, "%s: may not specify both -%c and -%c\n",
+		fprintf(stderr, "%s: may not specify both -%c and -%c\n",
 			 g_programName,
 			 uuid_option ? GETOPT_UUID : GETOPT_PRUNESESSION,
-			 c );
+			 c);
 		usage();
 	    }
 	    mntpnt_option = BOOL_TRUE;
@@ -188,24 +188,24 @@ main(int argc, char *argv[])
 	    break;
 	case GETOPT_PRUNESESSION:
 	    if (check_option) {
-		fprintf( stderr, "%s: may not specify both -%c and -%c\n",
+		fprintf(stderr, "%s: may not specify both -%c and -%c\n",
 			 g_programName,
 			 GETOPT_CHECKPRUNEFSTAB,
-			 c );
+			 c);
 		usage();
 	    }
 	    if (interactive_option) {
-		fprintf( stderr, "%s: may not specify both -%c and -%c\n",
+		fprintf(stderr, "%s: may not specify both -%c and -%c\n",
 			 g_programName,
 			 GETOPT_INTERACTIVE,
-			 c );
+			 c);
 		usage();
 	    }
 	    if (mntpnt_option || uuid_option) {
-		fprintf( stderr, "%s: may not specify both -%c and -%c\n",
+		fprintf(stderr, "%s: may not specify both -%c and -%c\n",
 			 g_programName,
 			 mntpnt_option ? GETOPT_PRUNEMNT : GETOPT_UUID,
-			 c );
+			 c);
 		usage();
 	    }
 	    session_option = BOOL_TRUE;
@@ -218,11 +218,11 @@ main(int argc, char *argv[])
     }
 
     if (r_mf_label != NULL && !(mntpnt_option || uuid_option)) {
-	    fprintf( stderr, "%s: -%c requires either -%c or -%c\n",
+	    fprintf(stderr, "%s: -%c requires either -%c or -%c\n",
 			 g_programName,
 			 GETOPT_PRUNEMEDIALABEL,
 			 GETOPT_PRUNEMNT,
-			 GETOPT_UUID );
+			 GETOPT_UUID);
 	    usage();
     }
 
@@ -245,9 +245,9 @@ main(int argc, char *argv[])
     /* sanity check the inventory database directory, setup global paths
      */
     if (!inv_setup_base()) {
-        fprintf( stderr,
+        fprintf(stderr,
                 "%s: both /var/lib/xfsdump and /var/xfsdump exist - fatal\n",
-	        g_programName );
+	        g_programName);
         exit(1);
     }
     inventory_path = INV_DIRPATH;
@@ -276,7 +276,7 @@ main(int argc, char *argv[])
 		    &session, timeSecs, r_mf_label);
 	}
     }
-    else if ( interactive_option ) {
+    else if (interactive_option) {
 	invutil_interactive(inventory_path, mntPoint, &uuid, 0);
 	printf("\n");
     }
@@ -370,7 +370,7 @@ ParseDate(char *strDate)
 #endif
 
     if (*fmt == NULL || (date = mktime(&tm)) < 0) {
-        fprintf(stderr, "%s: bad date, \"%s\"\n", g_programName, strDate );
+        fprintf(stderr, "%s: bad date, \"%s\"\n", g_programName, strDate);
         usage();
     }
 
@@ -408,10 +408,10 @@ GetNameOfStobj (char *inv_path, char *filename)
     char *name;
 
     str = basename(filename);
-    name = (char *) malloc( strlen( inv_path ) + 1  + strlen( str ) + 1);
-    strcpy( name, inv_path );
-    strcat( name, "/" );
-    strcat( name, str );
+    name = (char *) malloc(strlen(inv_path) + 1  + strlen(str) + 1);
+    strcpy(name, inv_path);
+    strcat(name, "/");
+    strcat(name, str);
 
     return(name);
 }
@@ -422,13 +422,13 @@ GetNameOfInvIndex (char *inv_path, uuid_t uuid)
     char str[UUID_STR_LEN + 1];
     char *name;
 
-    uuid_unparse( uuid, str );
-    name = (char *) malloc( strlen( inv_path ) + 1  + strlen( str )
-			     + strlen( INV_INVINDEX_PREFIX ) + 1);
-    strcpy( name, inv_path );
-    strcat( name, "/" );
-    strcat( name, str );
-    strcat( name, INV_INVINDEX_PREFIX );
+    uuid_unparse(uuid, str);
+    name = (char *) malloc(strlen(inv_path) + 1  + strlen(str)
+			     + strlen(INV_INVINDEX_PREFIX) + 1);
+    strcpy(name, inv_path);
+    strcat(name, "/");
+    strcat(name, str);
+    strcat(name, INV_INVINDEX_PREFIX);
 
     return(name);
 }
@@ -438,11 +438,11 @@ GetFstabFullPath(char *inv_path)
 {
     char *fstabname;
 
-    fstabname = (char *) malloc( strlen(inv_path) + 1 /* one for the "/" */
-				   + strlen("fstab") + 1 );
-    strcpy( fstabname, inv_path );
-    strcat( fstabname, "/" );
-    strcat( fstabname, "fstab" );
+    fstabname = (char *) malloc(strlen(inv_path) + 1 /* one for the "/" */
+				   + strlen("fstab") + 1);
+    strcpy(fstabname, inv_path);
+    strcat(fstabname, "/");
+    strcat(fstabname, "fstab");
     return(fstabname);
 }
 
@@ -463,18 +463,18 @@ CheckAndPruneFstab(char *inv_path, bool_t checkonly, char *mountPt,
     invt_counter_t *counter,cnt;
 
     if (mountPt == NULL && uuid_is_null(*uuidp) && uuid_is_null(*sessionp)) {
-	fprintf( stderr, "%s: mountpoint, uuid or session "
-			 "must be specified\n", g_programName );
-	fprintf( stderr, "%s: abnormal termination\n", g_programName );
+	fprintf(stderr, "%s: mountpoint, uuid or session "
+			 "must be specified\n", g_programName);
+	fprintf(stderr, "%s: abnormal termination\n", g_programName);
 	exit(1);
     }
 
     fstabname = GetFstabFullPath(inv_path);
-    fd = open_and_lock( fstabname,
+    fd = open_and_lock(fstabname,
 			FILE_WRITE,
-			wait_for_locks );
+			wait_for_locks);
     if (fd < 0) {
-	fprintf( stderr, "%s: abnormal termination\n", g_programName );
+	fprintf(stderr, "%s: abnormal termination\n", g_programName);
 	exit(1);
     }
 
@@ -492,13 +492,13 @@ CheckAndPruneFstab(char *inv_path, bool_t checkonly, char *mountPt,
     printf("Processing file %s\n", fstabname);
 
     /* check each entry in fstab for mount pt or uuid match */
-    for (i = 0; i < counter->ic_curnum; )
+    for (i = 0; i < counter->ic_curnum;)
     {
 	removeflag = BOOL_FALSE;
 
 	printf("   Found entry for %s\n" , fstabentry[i].ft_mountpt);
 
-	for (j = i +1 ; j < counter->ic_curnum ; j++ ) {
+	for (j = i +1 ; j < counter->ic_curnum ; j++) {
 	    if (uuid_compare(fstabentry[i].ft_uuid, fstabentry[j].ft_uuid) == 0)
 	    {
 		printf("     duplicate fstab entry\n");
@@ -519,7 +519,7 @@ CheckAndPruneFstab(char *inv_path, bool_t checkonly, char *mountPt,
 		   (r_mf_label ? r_mf_label : "(NULL)"));
 #endif
 
-	    if ( checkonly == BOOL_FALSE ) {
+	    if (checkonly == BOOL_FALSE) {
 		if(mountPt != NULL && strcmp(mountPt, fstabentry[i].ft_mountpt) == 0) {
 		    printf("     Match on hostname and path\n");
 		    IdxCheckOnly = BOOL_FALSE;
@@ -542,18 +542,18 @@ CheckAndPruneFstab(char *inv_path, bool_t checkonly, char *mountPt,
 
 	    if (CheckAndPruneInvIndexFile(
 			IdxCheckOnly, invname, sessionp,
-			prunetime, r_mf_label) == -1 ) {
+			prunetime, r_mf_label) == -1) {
 		removeflag = BOOL_TRUE;
 	    }
 
-	    free( invname );
+	    free(invname);
 
 	}
 
 	if (removeflag == BOOL_TRUE)
 	{
 	    printf("     removing fstab entry %s\n", fstabentry[i].ft_mountpt);
-	    if ( counter->ic_curnum > 1 ) {
+	    if (counter->ic_curnum > 1) {
 		bcopy((void *)&fstabentry[i + 1],
 		      (void *)&fstabentry[i],
 		      (sizeof(invt_fstab_t) * (counter->ic_curnum - i - 1)));
@@ -566,7 +566,7 @@ CheckAndPruneFstab(char *inv_path, bool_t checkonly, char *mountPt,
 
     fstabEntries = counter->ic_curnum;
 
-    munmap( mapaddr,
+    munmap(mapaddr,
 	    (nEntries*sizeof(invt_fstab_t)) + sizeof(invt_counter_t));
 
     if ((fstabEntries != 0)  && (fstabEntries != nEntries)) {
@@ -588,14 +588,14 @@ CheckAndPruneFstab(char *inv_path, bool_t checkonly, char *mountPt,
 	if(debug) {
 	    printf("unlink fstab file %s\n", fstabname);
 	}
-	unlink( fstabname );
+	unlink(fstabname);
     }
 
-    free( fstabname );
+    free(fstabname);
 }
 
 int
-CheckAndPruneInvIndexFile( bool_t checkonly,
+CheckAndPruneInvIndexFile(bool_t checkonly,
 			   char *idxFileName,
 			   uuid_t *sessionp,
 			   time32_t prunetime,
@@ -615,14 +615,14 @@ CheckAndPruneInvIndexFile( bool_t checkonly,
     printf("      processing index file \n"
 	   "       %s\n",idxFileName);
 
-    fd = open_and_lock( idxFileName,
+    fd = open_and_lock(idxFileName,
 			FILE_WRITE,
-			wait_for_locks );
+			wait_for_locks);
     if (fd < 0) {
         return -1;
     }
 
-    read_n_bytes( fd, &header, sizeof(invt_counter_t), idxFileName);
+    read_n_bytes(fd, &header, sizeof(invt_counter_t), idxFileName);
     nEntries = header.ic_curnum;
 
     temp = mmap_n_bytes(fd,
@@ -630,9 +630,9 @@ CheckAndPruneInvIndexFile( bool_t checkonly,
 			BOOL_FALSE, idxFileName);
 
     counter = (invt_counter_t *)temp;
-    invIndexEntry = (invt_entry_t *)( temp + sizeof(invt_counter_t));
+    invIndexEntry = (invt_entry_t *)(temp + sizeof(invt_counter_t));
 
-    for (i=0; i < counter->ic_curnum; )
+    for (i=0; i < counter->ic_curnum;)
     {
 	removeflag = BOOL_FALSE;
 	printf("         Checking access for\n"
@@ -644,7 +644,7 @@ CheckAndPruneInvIndexFile( bool_t checkonly,
 		   ctime32(&(invIndexEntry[i].ie_timeperiod.tp_end)));
 	}
 
-	if (( access( invIndexEntry[i].ie_filename, R_OK | W_OK ) == -1)  &&
+	if ((access(invIndexEntry[i].ie_filename, R_OK | W_OK) == -1)  &&
 	   (errno == ENOENT))
 	{
 	    printf("         Unable to access %s referred in %s\n",
@@ -660,7 +660,7 @@ CheckAndPruneInvIndexFile( bool_t checkonly,
 
 	if (removeflag == BOOL_TRUE)
 	{
-	    if ( counter->ic_curnum > 1 ) {
+	    if (counter->ic_curnum > 1) {
 	        bcopy((void *)&invIndexEntry[i + 1],
 		      (void *)&invIndexEntry[i],
 		      (sizeof(invt_entry_t) * (counter->ic_curnum - i - 1)));
@@ -673,18 +673,18 @@ CheckAndPruneInvIndexFile( bool_t checkonly,
 
     validEntries = counter->ic_curnum;
 
-    munmap( temp, (nEntries*sizeof(invt_entry_t)) + sizeof(invt_counter_t) );
+    munmap(temp, (nEntries*sizeof(invt_entry_t)) + sizeof(invt_counter_t));
 
     if ((validEntries != 0)  && (validEntries != nEntries)) {
 	if(debug) {
 	    printf("ftruncate idx from %d to %d (%ld bytes)\n",
 		   nEntries,
 		   validEntries,
-		   (long) sizeof(invt_counter_t) + (validEntries * sizeof(invt_entry_t)) );
+		   (long) sizeof(invt_counter_t) + (validEntries * sizeof(invt_entry_t)));
             printf("- truncate %s\n", idxFileName);
 	}
-    	ftruncate( fd,
-		   sizeof(invt_counter_t) + (validEntries * sizeof(invt_entry_t)) );
+    	ftruncate(fd,
+		   sizeof(invt_counter_t) + (validEntries * sizeof(invt_entry_t)));
     }
 
     if (debug) {
@@ -693,14 +693,14 @@ CheckAndPruneInvIndexFile( bool_t checkonly,
 	       validEntries);
     }
 
-    close( fd );
+    close(fd);
 
     if (validEntries == 0)
     {
 	if(debug) {
 	    printf("unlink idx file %s\n", idxFileName);
 	}
-	unlink( idxFileName );
+	unlink(idxFileName);
 	return(-1);
     }
 
@@ -708,7 +708,7 @@ CheckAndPruneInvIndexFile( bool_t checkonly,
 }
 
 int
-CheckAndPruneStObjFile( bool_t checkonly,
+CheckAndPruneStObjFile(bool_t checkonly,
 			char *StObjFileName,
 			uuid_t *sessionp,
 			time32_t prunetime,
@@ -734,9 +734,9 @@ CheckAndPruneStObjFile( bool_t checkonly,
     invt_sescounter_t *counter;
     invt_sescounter_t header;
 
-    fd = open_and_lock( StObjFileName,
+    fd = open_and_lock(StObjFileName,
 			FILE_WRITE,
-			wait_for_locks );
+			wait_for_locks);
     if (fd < 0) {
         return -1;
     }
@@ -751,11 +751,11 @@ CheckAndPruneStObjFile( bool_t checkonly,
 
     temp = mmap_n_bytes(fd, sb.st_size, BOOL_FALSE, StObjFileName);
     counter = (invt_sescounter_t *)temp;
-    StObjhdr = (invt_seshdr_t *)( temp + sizeof(invt_sescounter_t));
+    StObjhdr = (invt_seshdr_t *)(temp + sizeof(invt_sescounter_t));
     StObjses = (invt_session_t *)(temp + StObjhdr->sh_sess_off);
 
     sescount = 0;
-    for (i=0; i < counter->ic_curnum; ) {
+    for (i=0; i < counter->ic_curnum;) {
 	removeflag = BOOL_FALSE;
 	if (StObjhdr->sh_pruned)
 	    prunedcount++;
@@ -788,37 +788,37 @@ CheckAndPruneStObjFile( bool_t checkonly,
 		       ctime32(&StObjhdr->sh_time));
 	    printf("\t\tdevice:\t\t%s\n", StObjses->s_devpath);
 	    printf("\t\tsession label:\t\"%s\"\n", StObjses->s_label);
-	    uuid_unparse( StObjses->s_sesid, str );
+	    uuid_unparse(StObjses->s_sesid, str);
 	    printf("\t\tsession id:\t%s\n", str);
 	    printf("\t\tlevel:\t\t%d\n", StObjhdr->sh_level);
-	    printf("\t\tstreams:\t%d\n", StObjses->s_cur_nstreams );
-	    for ( i = 0; i < (int) StObjses->s_cur_nstreams; i++ ) {
-		printf( "\t\tstream %d:\n", i);
+	    printf("\t\tstreams:\t%d\n", StObjses->s_cur_nstreams);
+	    for (i = 0; i < (int) StObjses->s_cur_nstreams; i++) {
+		printf("\t\tstream %d:\n", i);
 		StObjstrm = (invt_stream_t *)(temp +
 					      StObjhdr->sh_streams_off +
 					      (i * sizeof(invt_stream_t)));
-		printf( "\t\t\tpathname:\t%s\n",
+		printf("\t\t\tpathname:\t%s\n",
 			StObjstrm->st_cmdarg);
-		printf( "\t\t\tinode start:\t%llu\n",
+		printf("\t\t\tinode start:\t%llu\n",
 			(unsigned long long) StObjstrm->st_startino.ino);
-		printf( "\t\t\tinode   end:\t%llu\n",
+		printf("\t\t\tinode   end:\t%llu\n",
 			(unsigned long long) StObjstrm->st_endino.ino);
-		printf( "\t\t\tinterrupted:\t%s\n",
-			StObjstrm->st_interrupted ? "YES" : "NO" );
-		printf( "\t\t\tmedia files:\t%d\n",
+		printf("\t\t\tinterrupted:\t%s\n",
+			StObjstrm->st_interrupted ? "YES" : "NO");
+		printf("\t\t\tmedia files:\t%d\n",
 			StObjstrm->st_nmediafiles);
-		for ( j = 0; j < StObjstrm->st_nmediafiles; j++) {
+		for (j = 0; j < StObjstrm->st_nmediafiles; j++) {
 		    StObjmed = (invt_mediafile_t *)(temp +
 						    StObjstrm->st_firstmfile +
 						    (j * sizeof(invt_mediafile_t)));
-		    printf( "\t\t\tmfile file %d:\n", j);
-		    printf( "\t\t\t\tmfile size:\t%lld\n",
+		    printf("\t\t\tmfile file %d:\n", j);
+		    printf("\t\t\t\tmfile size:\t%lld\n",
 			    (long long) StObjmed->mf_size);
-		    printf( "\t\t\t\tmfile start:\t%llu\n",
+		    printf("\t\t\t\tmfile start:\t%llu\n",
 			    (unsigned long long) StObjmed->mf_startino.ino);
-		    printf( "\t\t\t\tmfile end:\t%llu\n",
+		    printf("\t\t\t\tmfile end:\t%llu\n",
 			    (unsigned long long) StObjmed->mf_endino.ino);
-		    printf( "\t\t\t\tmedia label:\t\"%s\"\n",
+		    printf("\t\t\t\tmedia label:\t\"%s\"\n",
 			    StObjmed->mf_label);
 		}
 	    }
@@ -842,12 +842,12 @@ CheckAndPruneStObjFile( bool_t checkonly,
 	    && (uses_specified_mf_label(StObjhdr, StObjses, temp, r_mf_label))){
 	    bool_t GotResponse = BOOL_FALSE;
 
-	    uuid_unparse( StObjses->s_sesid, str );
+	    uuid_unparse(StObjses->s_sesid, str);
 
 	    if(force) {
 		printf("-------------------------------------------------\n");
 		printf("Pruning this matching entry:\n");
-		printf( "UUID\t\t:\t%s\nMOUNT POINT\t:\t%s\n"
+		printf("UUID\t\t:\t%s\nMOUNT POINT\t:\t%s\n"
 			"DEV PATH\t:\t%s\n"
 			"LABEL\t\t:\t%s\n"
 			"TIME OF DUMP\t:\t%s",
@@ -862,20 +862,20 @@ CheckAndPruneStObjFile( bool_t checkonly,
 		       "DEV PATH\t:\t%s\nTIME OF DUMP\t:\t%s",
 		       str, StObjses->s_mountpt, StObjses->s_devpath,
 		       ctime32(&StObjhdr->sh_time));
-		while ( GotResponse == BOOL_FALSE )
+		while (GotResponse == BOOL_FALSE)
 		{
 		    char *chp;
 
 		    printf("\nDo you want to prune this entry: [y/n] ");
-		    fgets( response, GEN_STRLEN, stdin );
-		    chp = strchr( response, '\n');
+		    fgets(response, GEN_STRLEN, stdin);
+		    chp = strchr(response, '\n');
 		    if (chp)
 			*chp = '\0';
-		    if (strcasecmp( response, "Y" ) == 0) {
+		    if (strcasecmp(response, "Y") == 0) {
 			removeflag = BOOL_TRUE;
 			GotResponse = BOOL_TRUE;
 		    }
-		    else if (strcasecmp( response, "N" ) == 0) {
+		    else if (strcasecmp(response, "N") == 0) {
 			GotResponse = BOOL_TRUE;
 		    }
 		}
@@ -891,26 +891,26 @@ CheckAndPruneStObjFile( bool_t checkonly,
 
 	i++;
 
-	StObjhdr = (invt_seshdr_t *)( temp + sizeof(invt_sescounter_t) +
-				      (i * sizeof(invt_seshdr_t)) );
+	StObjhdr = (invt_seshdr_t *)(temp + sizeof(invt_sescounter_t) +
+				      (i * sizeof(invt_seshdr_t)));
 	StObjses = (invt_session_t *)(temp + StObjhdr->sh_sess_off);
     }
 
     validEntries = counter->ic_curnum - prunedcount - removedcount;
 
-    munmap( temp, sb.st_size);
+    munmap(temp, sb.st_size);
 
     if (debug && removedcount)
 	printf("       pruned %d entries from this StObj file,"
 	       " %d remaining\n", removedcount, validEntries);
 
-    close( fd );
+    close(fd);
 
     if (validEntries == 0)
     {
 	if (debug)
 	    printf("Removing: %s\n", StObjFileName);
-	unlink( StObjFileName );
+	unlink(StObjFileName);
 	return(-1);
     }
 
@@ -938,10 +938,10 @@ uses_specified_mf_label(
     if (!r_mf_label) {
 	return 1;	/* prune */
     }
-    for ( s = 0; s < (int) StObjses->s_cur_nstreams; s++ ) {
+    for (s = 0; s < (int) StObjses->s_cur_nstreams; s++) {
 	StObjstrm = (invt_stream_t *)
 	    (temp + StObjhdr->sh_streams_off + (s * sizeof(invt_stream_t)));
-	for ( m = 0; m < StObjstrm->st_nmediafiles; m++, num_media_objects++) {
+	for (m = 0; m < StObjstrm->st_nmediafiles; m++, num_media_objects++) {
 	    StObjmed = (invt_mediafile_t *)
 		(temp + StObjstrm->st_firstmfile + (m * sizeof(invt_mediafile_t)));
 	    if (!strncmp(StObjmed->mf_label, r_mf_label,
@@ -963,7 +963,7 @@ uses_specified_mf_label(
 
 /* copied from inv_api.c */
 char *
-inv_DEBUG_lock_str( int c )
+inv_DEBUG_lock_str(int c)
 {
 #ifdef USE_LOCKF
     static char *lockstr[] = {
@@ -1050,9 +1050,9 @@ open_and_lock(char * path, Open_t open_type, uint lock_wait_flag)
 
     fd = open(path, open_mode);
     if (fd < 0) {
-	fprintf( stderr, "%s: open of %s failed.\n",
+	fprintf(stderr, "%s: open of %s failed.\n",
 		 g_programName, path);
-	perror( "open" );
+	perror("open");
 	return SYSCALL_FAILED;
     }
 
@@ -1146,16 +1146,16 @@ mmap_n_bytes(int fd, size_t count, bool_t checkonly, char *path)
 {
     void *  temp;
 
-    lseek( fd, 0, SEEK_SET );
-    temp = mmap( NULL, count,
+    lseek(fd, 0, SEEK_SET);
+    temp = mmap(NULL, count,
 		 (checkonly == BOOL_TRUE) ? PROT_READ : PROT_READ|PROT_WRITE,
-		 MAP_SHARED, fd, 0 );
+		 MAP_SHARED, fd, 0);
 
     if (temp == (void *)-1) {
-	fprintf( stderr, "%s: error in mmap of %ld bytes for file %s\n",
+	fprintf(stderr, "%s: error in mmap of %ld bytes for file %s\n",
 		 g_programName, (long) count, path);
 	perror("mmap");
-	fprintf( stderr, "%s: abnormal termination\n", g_programName );
+	fprintf(stderr, "%s: abnormal termination\n", g_programName);
 	exit(1);
     }
     return temp;
diff --git a/invutil/invutil.h b/invutil/invutil.h
index f1b1681..db5fc26 100644
--- a/invutil/invutil.h
+++ b/invutil/invutil.h
@@ -46,8 +46,8 @@ char *	GetNameOfInvIndex (char *, uuid_t);
 char *	GetNameOfStobj (char *inv_path, char *filename);
 void	CheckAndPruneFstab(
 		char *, bool_t, char *, uuid_t *, uuid_t *, time32_t, char *);
-int	CheckAndPruneInvIndexFile( bool_t, char *, uuid_t *, time32_t, char *);
-int	CheckAndPruneStObjFile( bool_t, char *, uuid_t *, time32_t, char *);
+int	CheckAndPruneInvIndexFile(bool_t, char *, uuid_t *, time32_t, char *);
+int	CheckAndPruneStObjFile(bool_t, char *, uuid_t *, time32_t, char *);
 int	uses_specified_mf_label(
 		invt_seshdr_t *, invt_session_t *, char	*, char *);
 time32_t ParseDate(char *);
@@ -57,7 +57,7 @@ void	read_n_bytes(int, void *, size_t, char *);
 void	write_n_bytes(int, void *, size_t, char *);
 void *	mmap_n_bytes(int, size_t, bool_t, char *);
 void	ListFstab(void);
-int	ListInvIndexFile( char *);
+int	ListInvIndexFile(char *);
 int	ListStObjFile(char *);
 int	invutil_interactive(char *, char *, uuid_t *, time32_t timeSecs);
 int	mntpnt_equal(char *s1, char *s2);
diff --git a/invutil/stobj.c b/invutil/stobj.c
index 582858f..2912e0c 100644
--- a/invutil/stobj.c
+++ b/invutil/stobj.c
@@ -409,12 +409,12 @@ generate_stobj_menu(node_t *startnode, int level, char *StObjFileName)
 	return startnode;
     }
 
-    StObjhdr = (invt_seshdr_t *)( stobj_file[idx].mapaddr + sizeof(invt_sescounter_t));
+    StObjhdr = (invt_seshdr_t *)(stobj_file[idx].mapaddr + sizeof(invt_sescounter_t));
     StObjses = (invt_session_t *)(stobj_file[idx].mapaddr + StObjhdr->sh_sess_off);
 
     data_idx = 0;
     n = startnode;
-    for (i=0; i < stobj_file[idx].counter->ic_curnum; ) {
+    for (i=0; i < stobj_file[idx].counter->ic_curnum;) {
 	session = malloc(sizeof(*session));
 	if(session == NULL) {
 	    fprintf(stderr, "%s: internal memory error: session malloc\n", g_programName);
@@ -453,7 +453,7 @@ generate_stobj_menu(node_t *startnode, int level, char *StObjFileName)
 	add_stobj_data(idx, session);
 
 	parent_session = n;
-	for ( j = 0; j < (int) StObjses->s_cur_nstreams; j++ ) {
+	for (j = 0; j < (int) StObjses->s_cur_nstreams; j++) {
 	    StObjstrm = (invt_stream_t *)(stobj_file[idx].mapaddr +
 					  StObjhdr->sh_streams_off +
 					  (j * sizeof(invt_stream_t)));
@@ -486,7 +486,7 @@ generate_stobj_menu(node_t *startnode, int level, char *StObjFileName)
 	    add_stobj_data(idx, StObjstrm);
 
 	    parent_stream = n;
-	    for ( k = 0; k < StObjstrm->st_nmediafiles; k++) {
+	    for (k = 0; k < StObjstrm->st_nmediafiles; k++) {
 		StObjmed = (invt_mediafile_t *)(stobj_file[idx].mapaddr +
 						StObjstrm->st_firstmfile +
 						(k * sizeof(invt_mediafile_t)));
@@ -522,8 +522,8 @@ generate_stobj_menu(node_t *startnode, int level, char *StObjFileName)
 
 	i++;
 
-	StObjhdr = (invt_seshdr_t *)( stobj_file[idx].mapaddr + sizeof(invt_sescounter_t) +
-				      (i * sizeof(invt_seshdr_t)) );
+	StObjhdr = (invt_seshdr_t *)(stobj_file[idx].mapaddr + sizeof(invt_sescounter_t) +
+				      (i * sizeof(invt_seshdr_t)));
 	StObjses = (invt_session_t *)(stobj_file[idx].mapaddr + StObjhdr->sh_sess_off);
     }
 
@@ -578,13 +578,13 @@ open_stobj(char *StObjFileName)
     char		*name;
 
     errno=0;
-    fd = open_and_lock( StObjFileName, FILE_WRITE, wait_for_locks );
+    fd = open_and_lock(StObjFileName, FILE_WRITE, wait_for_locks);
     if (fd < 0) {
 	return fd;
     }
 
     read_n_bytes(fd, &cnt, sizeof(invt_sescounter_t), StObjFileName);
-    lseek( fd, 0, SEEK_SET );
+    lseek(fd, 0, SEEK_SET);
     errno = 0;
     if (fstat(fd, &sb) < 0) {
 	fprintf(stderr, "Could not get stat info on %s\n", StObjFileName);
@@ -610,16 +610,16 @@ close_stobj_file(int fidx, int unlink_ok)
     if(fidx >= stobj_numfiles || stobj_file[fidx].fd < 0)
 	return 0;
 
-    munmap( stobj_file[fidx].mapaddr, stobj_file[fidx].size);
-    close( stobj_file[fidx].fd );
+    munmap(stobj_file[fidx].mapaddr, stobj_file[fidx].size);
+    close(stobj_file[fidx].fd);
     stobj_file[fidx].fd = -1;
 
     if(unlink_ok == BOOL_TRUE) {
 	unlink(stobj_file[fidx].name);
     }
 
-    free( stobj_file[fidx].name );
-    free( stobj_file[fidx].data );
+    free(stobj_file[fidx].name);
+    free(stobj_file[fidx].data);
 
     stobj_file[fidx].name = NULL;
     stobj_file[fidx].data = NULL;
@@ -641,15 +641,15 @@ close_all_stobj()
 	    continue;
 
 	unlink_ok = BOOL_TRUE;
-	StObjhdr = (invt_seshdr_t *)( stobj_file[i].mapaddr + sizeof(invt_sescounter_t));
-	for(j = 0; j < stobj_file[i].counter->ic_curnum; ) {
+	StObjhdr = (invt_seshdr_t *)(stobj_file[i].mapaddr + sizeof(invt_sescounter_t));
+	for(j = 0; j < stobj_file[i].counter->ic_curnum;) {
 	    if(StObjhdr->sh_pruned != 1) {
 		unlink_ok = BOOL_FALSE;
 		break;
 	    }
 	    j++;
-	    StObjhdr = (invt_seshdr_t *)( stobj_file[i].mapaddr + sizeof(invt_sescounter_t) +
-					  (j * sizeof(invt_seshdr_t)) );
+	    StObjhdr = (invt_seshdr_t *)(stobj_file[i].mapaddr + sizeof(invt_sescounter_t) +
+					  (j * sizeof(invt_seshdr_t)));
 	}
 
 	close_stobj_file(i, unlink_ok);
diff --git a/librmt/rmtcommand.c b/librmt/rmtcommand.c
index 82c9032..b5726d9 100644
--- a/librmt/rmtcommand.c
+++ b/librmt/rmtcommand.c
@@ -56,7 +56,7 @@ char *buf;
 
 	_rmt_abort(fildes);
 
-	setoserror( EIO );
+	setoserror(EIO);
 	return(-1);
 }
 
diff --git a/librmt/rmtfstat.c b/librmt/rmtfstat.c
index 92a49d7..8bfaea7 100644
--- a/librmt/rmtfstat.c
+++ b/librmt/rmtfstat.c
@@ -54,10 +54,10 @@ struct stat *buf;
 static int
 _rmt_fstat(int fildes, char *arg)
 {
-	char buffer[ BUFMAGIC ];
+	char buffer[BUFMAGIC];
 	int rc, cnt, adj_rc;
 
-	sprintf( buffer, "Z%d\n", fildes );
+	sprintf(buffer, "Z%d\n", fildes);
 
 	/*
 	 *	grab the status and read it directly into the structure
@@ -83,7 +83,7 @@ _rmt_fstat(int fildes, char *arg)
 		{
 abortit:
 			_rmt_abort(fildes);
-			setoserror( EIO );
+			setoserror(EIO);
 			return(-1);
 		}
 	}
diff --git a/librmt/rmtioctl.c b/librmt/rmtioctl.c
index edcd611..84932a5 100644
--- a/librmt/rmtioctl.c
+++ b/librmt/rmtioctl.c
@@ -193,7 +193,7 @@ _rmt_ioctl(int fildes, unsigned int op, void *arg)
 		if (RMTHOST(fildes) == UNAME_UNDEFINED) {
 			_rmt_msg(RMTWARN,
 		_("rmtioctl: remote host type not supported for MTIOCTOP\n"));
-			setoserror( EPROTONOSUPPORT );
+			setoserror(EPROTONOSUPPORT);
 			return(-1);
 		}
 
@@ -201,7 +201,7 @@ _rmt_ioctl(int fildes, unsigned int op, void *arg)
 		if (RMTHOST(fildes) == UNAME_IRIX) {
 			mt_op = mtop_irixmap[mt_op];
 			if (mt_op == -1) {
-			    setoserror( EINVAL );
+			    setoserror(EINVAL);
 			    return(-1);
 			}
 		}
@@ -209,7 +209,7 @@ _rmt_ioctl(int fildes, unsigned int op, void *arg)
 		/* map the linux op code to the standard/fallback op code */
 			mt_op = mtop_stdmap[mt_op];
 			if (mt_op == -1) {
-			    setoserror( EINVAL );
+			    setoserror(EINVAL);
 			    return(-1);
 			}
 		}
@@ -248,7 +248,7 @@ _rmt_ioctl(int fildes, unsigned int op, void *arg)
 		    case UNAME_UNDEFINED:
 			_rmt_msg(RMTWARN,
 		_("rmtioctl: remote host type not supported for MTIOCGET\n"));
-			setoserror( EPROTONOSUPPORT );
+			setoserror(EPROTONOSUPPORT);
 			return(-1);
 		    case UNAME_IRIX:
 			if (sizeof(struct irix_mtget) != rc) {
@@ -256,7 +256,7 @@ _rmt_ioctl(int fildes, unsigned int op, void *arg)
 				_("rmtioctl: IRIX mtget structure of wrong size"
 				  " - got %d, wanted %d\n"),
 				rc, sizeof(struct irix_mtget));
-			    setoserror( EPROTONOSUPPORT );
+			    setoserror(EPROTONOSUPPORT);
 			    return(-1);
 			}
 			break;
@@ -273,12 +273,12 @@ _rmt_ioctl(int fildes, unsigned int op, void *arg)
 			  "- got %d, wanted %d or %d\n"),
 				rc, sizeof(struct linux32_mtget),
 				sizeof(struct linux64_mtget));
-			    setoserror( EPROTONOSUPPORT );
+			    setoserror(EPROTONOSUPPORT);
 			    return(-1);
 			}
 			break;
 		    default:
-			setoserror( EPROTONOSUPPORT );
+			setoserror(EPROTONOSUPPORT);
 			return(-1);
 		}
 
@@ -303,7 +303,7 @@ _rmt_ioctl(int fildes, unsigned int op, void *arg)
 			cnt = read(READ(fildes), p, ssize);
 			if (cnt <= 0) {
 				_rmt_abort(fildes);
-				setoserror( EIO );
+				setoserror(EIO);
 				return(-1);
 			}
 		}
@@ -421,7 +421,7 @@ _rmt_ioctl(int fildes, unsigned int op, void *arg)
 
 	}
         else {
-	    setoserror( EINVAL );
+	    setoserror(EINVAL);
 	    return(-1);
 	}
 }
diff --git a/librmt/rmtopen.c b/librmt/rmtopen.c
index 09ba3e4..a091c72 100644
--- a/librmt/rmtopen.c
+++ b/librmt/rmtopen.c
@@ -120,7 +120,7 @@ static int _rmt_open (char *path, int oflag, int mode)
 
 	if (i == MAXUNIT)
 	{
-		setoserror( EMFILE );
+		setoserror(EMFILE);
 		return(-1);
 	}
 
@@ -144,7 +144,7 @@ static int _rmt_open (char *path, int oflag, int mode)
 	}
 	else
 	{
-		for ( user = login; (*sys = *user); user++, sys++ )
+		for (user = login; (*sys = *user); user++, sys++)
 			;
 		user = login;
 	}
diff --git a/librmt/rmtstatus.c b/librmt/rmtstatus.c
index 21d909d..f141395 100644
--- a/librmt/rmtstatus.c
+++ b/librmt/rmtstatus.c
@@ -47,7 +47,7 @@ int fildes;
 		if (read(READ(fildes), cp, 1) != 1)
 		{
 			_rmt_abort(fildes);
-			setoserror( EIO );
+			setoserror(EIO);
 			return(-1);
 		}
 		if (*cp == '\n')
@@ -60,7 +60,7 @@ int fildes;
 	if (i == BUFMAGIC)
 	{
 		_rmt_abort(fildes);
-		setoserror( EIO );
+		setoserror(EIO);
 		return(-1);
 	}
 
@@ -74,7 +74,7 @@ int fildes;
 
 	if (*cp == 'E' || *cp == 'F')
 	{
-		setoserror( atoi(cp + 1) );
+		setoserror(atoi(cp + 1));
 		while (read(READ(fildes), &c, 1) == 1)
 			if (c == '\n')
 				break;
@@ -92,7 +92,7 @@ int fildes;
 	if (*cp != 'A')
 	{
 		_rmt_abort(fildes);
-		setoserror( EIO );
+		setoserror(EIO);
 		return(-1);
 	}
 
diff --git a/librmt/rmtwrite.c b/librmt/rmtwrite.c
index 9e5a1a3..9b4cc50 100644
--- a/librmt/rmtwrite.c
+++ b/librmt/rmtwrite.c
@@ -67,6 +67,6 @@ static int _rmt_write(int fildes, char *buf, unsigned int nbyte)
 	}
 
 	_rmt_abort(fildes);
-	setoserror( EIO );
+	setoserror(EIO);
 	return(-1);
 }
-- 
2.19.1
