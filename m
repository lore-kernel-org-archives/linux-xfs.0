Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 09BD17F80
	for <xfs@oss.sgi.com>; Thu,  3 Sep 2015 09:07:06 -0500 (CDT)
From: Rich Johnston <rjohnston@sgi.com>
Subject: [PATCH V2] xfsrestore: fix fs uuid order check for incremental
	restores
References: <20150826213133.GB3902@dastard> <55D5FB95.1280108@sgi.com>
	<20150902132112.GB23587@bfoster.bfoster>
Message-ID: <55E85407.7010106@sgi.com>
Date: Thu, 3 Sep 2015 09:07:03 -0500
MIME-Version: 1.0
In-Reply-To: <20150902132112.GB23587@bfoster.bfoster>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Restoring an incremental level 1 dump will fail with the following error
if the fs uuid of the most recent level 0 dump in the inventory does not
match level 1 dump we are restoring.

   xfsrestore: ERROR: selected dump not based on previously applied dump

To: <xfs@oss.sgi.com>
BCC: Rich Johnston <rjohnston@sgi.com>
This can happen when you have multiple filesystems and you are restoring
a level 1 or greater dump of filesystem FS1 but the most recent level 0
dump in the inventory was filesystem FS2

The fix is to ensure the fs uuid of the inventory entry and the dump to
be restored match.

Signed-off-by: Rich Johnston <rjohnston@sgi.com>
---
  dump/content.c        |    8 ++-
  inventory/inv_api.c   |  108 
++++++++++++++++++++++++++++++--------------------
  inventory/inv_mgr.c   |   48 +++++++++++++++-------
  inventory/inv_priv.h  |    7 +--
  inventory/inventory.h |    5 ++
  restore/content.c     |   17 +++++--
  6 files changed, 124 insertions(+), 69 deletions(-)

Index: b/dump/content.c
===================================================================
--- a/dump/content.c
+++ b/dump/content.c
@@ -872,7 +872,7 @@ content_init( intgen_t argc,
  		sameinterruptedpr = BOOL_FALSE;
  		interruptedpr = BOOL_FALSE;
  -		ok = inv_get_session_byuuid( &baseuuid, &sessp );
+		ok = inv_get_session_byuuid( &fsid, &baseuuid, &sessp );
  		if ( ! ok ) {
  			mlog( MLOG_NORMAL | MLOG_ERROR, _(
  			      "could not find specified base dump (%s) "
@@ -983,7 +983,8 @@ content_init( intgen_t argc,
  			      "online inventory not available\n") );
  			return BOOL_FALSE;
  		}
-		ok = inv_lastsession_level_lessthan( inv_idbt,
+		ok = inv_lastsession_level_lessthan( &fsid,
+						     inv_idbt,
  						     ( u_char_t )sc_level,
  						     &sessp );
  		if ( ! ok ) {
@@ -1022,7 +1023,8 @@ content_init( intgen_t argc,
  	if ( inv_idbt != INV_TOKEN_NULL ) {
  		/* REFERENCED */
  		bool_t ok1;
-		ok = inv_lastsession_level_equalto( inv_idbt,
+		ok = inv_lastsession_level_equalto( &fsid,
+						    inv_idbt,
  						    ( u_char_t )sc_level,
  						    &sessp );
  		ok1 = inv_close( inv_idbt );
Index: b/inventory/inv_api.c
===================================================================
--- a/inventory/inv_api.c
+++ b/inventory/inv_api.c
@@ -596,69 +596,78 @@ inv_free_session(
 
/*----------------------------------------------------------------------*/
-/* inventory_lasttime_level_lessthan					*/
-/*                                                                      */
-/* Given a token that refers to a file system, and a level, this returns*/
-/* the last time when a session of a lesser level was done.             */
-/*                                                                      */
-/* returns -1 on error.                                                 */
+/* inv_lasttime_level_lessthan						*/
+/*									*/
+/* Given a file system uuid, token that refers to a file system, and a	*/
+/* level, tm is populated with last time when a session of a lesser	*/
+/* level was done.							*/
+/*									*/
+/* Returns TRUE on success.						*/
  /*----------------------------------------------------------------------*/
   bool_t
  inv_lasttime_level_lessthan( -	inv_idbtoken_t  tok,
-	u_char level,
-	time32_t **tm )
+	uuid_t		*fsidp,
+	inv_idbtoken_t	tok,
+	u_char		level,
+	time32_t	**tm )
  {
  	int 	rval;
  	if ( tok != INV_TOKEN_NULL ) {
-		rval =  search_invt( tok->d_invindex_fd, &level, (void **) tm,
-				    (search_callback_t) tm_level_lessthan );
+		rval =  search_invt(fsidp, tok->d_invindex_fd, &level,
+				    (void **) tm,
+				    (search_callback_t) tm_level_lessthan);
   		return ( rval < 0) ? BOOL_FALSE: BOOL_TRUE;
  	}
  	
-	return invmgr_query_all_sessions((void *) &level, /* in */
-					 (void **) tm,   /* out */
+	return invmgr_query_all_sessions(fsidp,		  /* fs uuid ptr*/
+					 (void *) &level, /* in */
+					 (void **) tm,    /* out */
  			       (search_callback_t) tm_level_lessthan);  }
  -
-
-
-
  /*----------------------------------------------------------------------*/
-/*                                                                      */
-/*                                                                      */
-/*                                                                      */
+/* inv_lastsession_level_lessthan					*/
+/*									*/
+/* Given a file system uuid, token that refers to a file system, and a	*/
+/* level, ses is populated with a session of lesser than the level	*/
+/* passed in.								*/
+/*									*/
+/* Returns FALSE on an error, TRUE if not. If (*ses) is NULL, then the	*/
+/* search failed.                                                       */
  /*----------------------------------------------------------------------*/
   bool_t
  inv_lastsession_level_lessthan( -	inv_idbtoken_t 	tok,
+	uuid_t		*fsidp,
+	inv_idbtoken_t	tok,
  	u_char		level,
-	inv_session_t 	**ses )
+	inv_session_t	**ses )
  {
  	int 	rval;
  	if ( tok != INV_TOKEN_NULL ) {
-		rval = search_invt( tok->d_invindex_fd, &level, (void **) ses, -				 
   (search_callback_t) lastsess_level_lessthan );
+		rval = search_invt(fsidp, tok->d_invindex_fd, &level,
+				   (void **) ses,
+				   (search_callback_t) lastsess_level_lessthan);
   		return ( rval < 0) ? BOOL_FALSE: BOOL_TRUE;
  	}
  -	return invmgr_query_all_sessions((void *) &level, /* in */
+	return invmgr_query_all_sessions(fsidp,		  /* fs uuid */
+					 (void *) &level, /* in */
  					 (void **) ses,   /* out */
  			       (search_callback_t) lastsess_level_lessthan);
   }
  -
-
-
  /*----------------------------------------------------------------------*/
-/*                                                                      */
-/*                                                                      */
+/* inv_lastsession_level_equalto					*/
+/*									*/
+/* Given a file system uuid, token that refers to a file system, and a	*/
+/* level, this populates ses with last time when a session of a lesser	*/
+/* level was done.							*/
+/*									*/
  /* Return FALSE on an error, TRUE if not. If (*ses) is NULL, then the   */
  /* search failed.                                                       */
  /*----------------------------------------------------------------------*/
@@ -666,19 +675,22 @@ inv_lastsession_level_lessthan(
   bool_t
  inv_lastsession_level_equalto( +	uuid_t		*fsidp,
  	inv_idbtoken_t 	tok,			     	u_char		level,
  	inv_session_t	**ses )
  {
  	int 	rval;
  	if ( tok != INV_TOKEN_NULL ) {
-		rval = search_invt( tok->d_invindex_fd, &level, (void **) ses, -				 
   (search_callback_t) lastsess_level_equalto );
+		rval = search_invt(fsidp, tok->d_invindex_fd, &level,
+				   (void **) ses,
+				   (search_callback_t) lastsess_level_equalto);
   		return ( rval < 0) ? BOOL_FALSE: BOOL_TRUE;
  	}
  	
-	return invmgr_query_all_sessions((void *) &level, /* in */
+	return invmgr_query_all_sessions(fsidp,		  /* fs uuid */
+					 (void *) &level, /* in */
  					 (void **) ses,   /* out */
  			       (search_callback_t) lastsess_level_equalto);
  @@ -688,35 +700,45 @@ inv_lastsession_level_equalto(
  /*----------------------------------------------------------------------*/
  /* inv_getsession_byuuid                                                */
  /*                                                                      */
+/* Given a file system uuid and a session uuid , ses is populated with	*/
+/* the session that contains the matching system uuid.			*/
+/*									*/
+/* Returns FALSE on an error, TRUE if the session was found.		*/
  /*----------------------------------------------------------------------*/
   bool_t
  inv_get_session_byuuid(
+	uuid_t *fsidp,
  	uuid_t	*sesid,
  	inv_session_t **ses)
  {
  -	return (invmgr_query_all_sessions((void *)sesid, /* in */
-					  (void **) ses, /* out */
-			       (search_callback_t) stobj_getsession_byuuid));
+	return invmgr_query_all_sessions(fsidp,		  /* fs uuid */
+					 (void *) sesid,  /* in */
+					 (void **) ses,   /* out */
+			       (search_callback_t) stobj_getsession_byuuid);
  }
  -
-
  /*----------------------------------------------------------------------*/
-/* inv_getsession_byuuid                                                */
+/* inv_getsession_bylabel						*/
  /*                                                                      */
+/* Given a file system uuid and a session uuid, ses is populated with	*/
+/* the session that contains the matching system label.			*/
+/*									*/
+/* Returns FALSE on an error, TRUE if the session was found.		*/
  /*----------------------------------------------------------------------*/
   bool_t
  inv_get_session_bylabel(
+	uuid_t *fsidp,
  	char *session_label,
  	inv_session_t **ses)
  {
  -	return (invmgr_query_all_sessions((void *)session_label, /* in */
-					  (void **) ses, /* out */
-			       (search_callback_t) stobj_getsession_bylabel));
+	return invmgr_query_all_sessions(fsidp,			 /* fs uuid */
+					 (void *) session_label, /* in */
+					 (void **) ses,		 /* out */
+			       (search_callback_t) stobj_getsession_bylabel);
  }
   @@ -786,7 +808,7 @@ inv_delete_mediaobj( uuid_t *moid )
  			return BOOL_FALSE;
  		}
  -		if ( search_invt( invfd, NULL, (void **)&moid, +		if ( search_invt( 
&arr[i].ft_uuid, invfd, NULL, (void **)&moid,
  				  (search_callback_t) stobj_delete_mobj )
  		    < 0 )
  			return BOOL_FALSE;
Index: b/inventory/inv_mgr.c
===================================================================
--- a/inventory/inv_mgr.c
+++ b/inventory/inv_mgr.c
@@ -134,6 +134,7 @@ get_sesstoken( inv_idbtoken_t tok )
 
/*---------------------------------------------------------------------------*/
  bool_t
  invmgr_query_all_sessions (
+	uuid_t *fsidp,
  	void *inarg,
  	void **outarg,
  	search_callback_t func)
@@ -145,6 +146,7 @@ invmgr_query_all_sessions (
  	int result;
  	inv_oflag_t forwhat = INV_SEARCH_ONLY;
  	void *objectfound;
+	bool ret = false;
   	/* if on return, this is still null, the search failed */
  	*outarg = NULL; @@ -153,11 +155,11 @@ invmgr_query_all_sessions (
  	fd = fstab_getall( &arr, &cnt, &numfs, forwhat );
  	/* special case missing file: ok, outarg says zero */
  	if ( fd < 0 && errno == ENOENT ) {
-		return BOOL_TRUE;
+		return true;
  	}
  	if ( fd < 0 || numfs <= 0 ) {
  		mlog( MLOG_NORMAL | MLOG_INV, _("INV: Error in fstab\n") );
-		return BOOL_FALSE;
+		return ret;
  	}
  	
  	close( fd );
@@ -169,7 +171,7 @@ invmgr_query_all_sessions (
  			mlog( MLOG_NORMAL | MLOG_INV, _(
  			     "INV: Cant get inv-name for uuid\n")
  			     );
-			return BOOL_FALSE;
+			continue;
  		}
  		strcat( fname, INV_INVINDEX_PREFIX );
  		invfd = open( fname, INV_OFLAG(forwhat) );
@@ -178,26 +180,27 @@ invmgr_query_all_sessions (
  			     "INV: Open failed on %s\n"),
  			     fname
  			     );
-			return BOOL_FALSE;
+			continue;
  		}
-		result = search_invt( invfd, inarg, &objectfound, func );
+		result = search_invt(fsidp, invfd, inarg, &objectfound, func);
  		close(invfd);		
   		/* if error return BOOL_FALSE */
  		if (result < 0) {
-			return BOOL_FALSE;
+			return ret;
  		} else if ((result == 1) && *outarg) {
  			/* multiple entries found,  more info needed */
  			*outarg = NULL;
-			return BOOL_TRUE;
+			return true;
  		} else if (result == 1) {
  			*outarg = objectfound;
+			ret = true;
  		}
  	}
  	
  	/* return val indicates if there was an error or not. *buf
  	   says whether the search was successful */
-	return BOOL_TRUE;
+	return ret;
  }
   @@ -213,6 +216,7 @@ invmgr_query_all_sessions (
   intgen_t
  search_invt( +	uuid_t			*fsidp,
  	int 			invfd,
  	void 			*arg,  	void 			**buf,
@@ -247,7 +251,7 @@ search_invt(
  	/* we need to get all the invindex headers and seshdrs in reverse
  	   order */
  	for (i = nindices - 1; i >= 0; i--) {
-		int 			nsess;
+		int			nsess, j;
  		invt_sescounter_t 	*scnt = NULL;
  		invt_seshdr_t		*harr = NULL;
  		bool_t                  found;
@@ -272,19 +276,35 @@ search_invt(
  		}
  		free ( scnt );
  -		while ( nsess ) {
+		for (j = nsess - 1; j >= 0; j--) {
+			invt_session_t ses;
+
  			/* fd is kept locked until we return from the  			   callback 
routine */
   			/* Check to see if this session has been pruned  			 * by 
xfsinvutil before checking it.  			 */
-			if ( harr[nsess - 1].sh_pruned ) {
-				--nsess;
+			if (harr[j].sh_pruned) {
  				continue;
  			}
-			found = (* do_chkcriteria ) ( fd, &harr[ --nsess ],
-						      arg, buf );
+
+			/* if we need to check the fs uuid's and they don't
+			 * match or we fail to get the session record,
+			 * then keep looking
+			 */
+			if (fsidp) {
+				int ret = GET_REC_NOLOCK(fd, &ses,
+							 sizeof(invt_session_t),
+							 harr[j].sh_sess_off);
+				if (ret < 0)
+					return ret;
+
+				if (uuid_compare(ses.s_fsid, *fsidp))
+					continue;
+			}
+
+			found = (* do_chkcriteria ) (fd, &harr[j], arg, buf);
  			if (! found ) continue;
  			
  			/* we found what we need; just return */
Index: b/inventory/inv_priv.h
===================================================================
--- a/inventory/inv_priv.h
+++ b/inventory/inv_priv.h
@@ -548,11 +548,12 @@ get_headerinfo( int fd, void **hdrs, voi
  	        size_t hdrsz, size_t cntsz, bool_t doblock );
   bool_t
-invmgr_query_all_sessions (void *inarg,	void **outarg, 
search_callback_t func);
+invmgr_query_all_sessions(uuid_t *fsidp, void *inarg, void **outarg,
+			  search_callback_t func);
   intgen_t
-search_invt( int invfd, void *arg, void **buf, -	    search_callback_t 
do_chkcriteria );
+search_invt(uuid_t *fsidp, int invfd, void *arg, void **buf,
+	    search_callback_t do_chkcriteria);
  intgen_t
  invmgr_inv_print( int invfd, invt_pr_ctx_t *prctx);
  Index: b/inventory/inventory.h
===================================================================
--- a/inventory/inventory.h
+++ b/inventory/inventory.h
@@ -247,18 +247,21 @@ inv_put_mediafile(
   */
  extern bool_t
  inv_lasttime_level_lessthan( +	uuid_t			*fsidp,
  	inv_idbtoken_t 		tok,
  	u_char  		level,
  	time32_t		**time );/* out */
   extern bool_t
  inv_lastsession_level_lessthan( +	uuid_t			*fsidp,
  	inv_idbtoken_t 		tok,			      	u_char  		level,
  	inv_session_t		**ses );/* out */
   extern bool_t
  inv_lastsession_level_equalto( +	uuid_t			*fsidp,
  	inv_idbtoken_t 		tok,			      	u_char  		level,
  	inv_session_t		**ses );/* out */
@@ -266,11 +269,13 @@ inv_lastsession_level_equalto(
  /* Given a uuid of a session, return the session structure.*/
  extern bool_t
  inv_get_session_byuuid(
+	uuid_t	*fsidp,
  	uuid_t	*sesid,
  	inv_session_t **ses);
   extern bool_t
  inv_get_session_bylabel(
+	uuid_t *fsidp,
  	char *session_label,
  	inv_session_t **ses);
  Index: b/restore/content.c
===================================================================
--- a/restore/content.c
+++ b/restore/content.c
@@ -2179,8 +2179,9 @@ content_stream_restore( ix_t thrdix )
  		if ( ! drivep->d_isnamedpipepr
  		     &&
  		     ! drivep->d_isunnamedpipepr ) {
-			ok = inv_get_session_byuuid( &grhdrp->gh_dumpid,
-						     &sessp );
+			ok = inv_get_session_byuuid(NULL,
+						    &grhdrp->gh_dumpid,
+						    &sessp);
  			if ( ok && sessp ) {
  				mlog( MLOG_VERBOSE, _(
  				      "using online session inventory\n") );
@@ -3736,9 +3737,11 @@ Inv_validate_cmdline( void )
  	ok = BOOL_FALSE;
  	sessp = 0;
  	if ( tranp->t_reqdumpidvalpr ) {
-		ok = inv_get_session_byuuid( &tranp->t_reqdumpid, &sessp );
+		ok = inv_get_session_byuuid(NULL, &tranp->t_reqdumpid,
+					    &sessp );
  	} else if ( tranp->t_reqdumplabvalpr ) {
-		ok = inv_get_session_bylabel( tranp->t_reqdumplab, &sessp );
+		ok = inv_get_session_bylabel(NULL, tranp->t_reqdumplab,
+					     &sessp );
  	}
  	rok = BOOL_FALSE;
  	if ( ok && sessp ) {
@@ -6812,11 +6815,13 @@ askinvforbaseof( uuid_t baseid, inv_sess
  	/* get the base session
  	 */
  	if ( resumedpr ) {
-		ok = inv_lastsession_level_equalto( invtok,
+		ok = inv_lastsession_level_equalto( &sessp->s_fsid,
+						    invtok,
  						    ( u_char_t )level,
  						    &basesessp );
  	} else {
-		ok = inv_lastsession_level_lessthan( invtok,
+		ok = inv_lastsession_level_lessthan( &sessp->s_fsid,
+						     invtok,
  						     ( u_char_t )level,
  						     &basesessp );
  	}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
