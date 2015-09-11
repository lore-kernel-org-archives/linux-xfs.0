Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BCDB57F37
	for <xfs@oss.sgi.com>; Fri, 11 Sep 2015 14:22:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9C8AA30404E
	for <xfs@oss.sgi.com>; Fri, 11 Sep 2015 12:22:32 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id MnSpInzGuCCdD99B (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 11 Sep 2015 12:22:30 -0700 (PDT)
Date: Fri, 11 Sep 2015 15:22:27 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH V4] xfsrestore: fix fs uuid order check for incremental
	restores
Message-ID: <20150911192226.GA19690@bfoster.bfoster>
References: <20150826213133.GB3902@dastard> <55D5FB95.1280108@sgi.com>
	<20150902132112.GB23587@bfoster.bfoster>
	<20150903234346.2473A600006AF@gulag1.americas.sgi.com>
	<20150908124726.GA5305@bfoster.bfoster>
	<20150911171450.C067C6073EA67@gulag1.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150911171450.C067C6073EA67@gulag1.americas.sgi.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Rich Johnston <rjohnston@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Sep 11, 2015 at 12:14:50PM -0500, Rich Johnston wrote:
> Restoring an incremental level 1 dump will fail with the following error
> if the fs uuid of the most recent level 0 dump in the inventory does not
> match level 1 dump we are restoring.
> 
>   xfsrestore: ERROR: selected dump not based on previously applied dump
> 
> This can happen when you have multiple filesystems and you are restoring
> a level 1 or greater dump of filesystem FS1 but the most recent level 0
> dump in the inventory was filesystem FS2
> 
> The fix is to ensure the fs uuid of the inventory entry and the dump to
> be restored match.
> 
> Signed-off-by: Rich Johnston <rjohnston@sgi.com>
> ---

Looks fine to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> 
> Changelog
> V2 wrong file sent
> 
> V3
>  Address review comments from Brian:
> 
>  fix invmgr_query_all_sessions() returning true if these error cases
>  persist throughout the loop
> 
>  make if check more readable and less overloaded in search_inv() and
>  return an error if GET_REC_NOLOCK() fails
> 
>  use NULL instead of (uuid_t *)0 in Inv_validate_cmdline()
> 
>  remove any spaces around braces of code that was changed
> 
> V4
>  fix compile error introduced when I removed any spaces around braces of
>  code that was changed and cleaning up whitespace.
> 
>  we should be returning BOOL_FALSE on any errors. I missed one.
> 
>  dump/content.c        |   16 +++---
>  inventory/inv_api.c   |  130 +++++++++++++++++++++++++++++---------------------
>  inventory/inv_mgr.c   |   53 +++++++++++++-------
>  inventory/inv_priv.h  |    7 +-
>  inventory/inventory.h |   21 +++++---
>  restore/content.c     |   23 +++++---
>  6 files changed, 151 insertions(+), 99 deletions(-)
> 
> Index: b/dump/content.c
> ===================================================================
> --- a/dump/content.c
> +++ b/dump/content.c
> @@ -872,7 +872,7 @@ content_init( intgen_t argc,
>  		sameinterruptedpr = BOOL_FALSE;
>  		interruptedpr = BOOL_FALSE;
>  
> -		ok = inv_get_session_byuuid( &baseuuid, &sessp );
> +		ok = inv_get_session_byuuid(&fsid, &baseuuid, &sessp);
>  		if ( ! ok ) {
>  			mlog( MLOG_NORMAL | MLOG_ERROR, _(
>  			      "could not find specified base dump (%s) "
> @@ -983,9 +983,10 @@ content_init( intgen_t argc,
>  			      "online inventory not available\n") );
>  			return BOOL_FALSE;
>  		}
> -		ok = inv_lastsession_level_lessthan( inv_idbt,
> -						     ( u_char_t )sc_level,
> -						     &sessp );
> +		ok = inv_lastsession_level_lessthan(&fsid,
> +						    inv_idbt,
> +						    (u_char_t)sc_level,
> +						    &sessp);
>  		if ( ! ok ) {
>  			sessp = 0;
>  		}
> @@ -1022,9 +1023,10 @@ content_init( intgen_t argc,
>  	if ( inv_idbt != INV_TOKEN_NULL ) {
>  		/* REFERENCED */
>  		bool_t ok1;
> -		ok = inv_lastsession_level_equalto( inv_idbt,
> -						    ( u_char_t )sc_level,
> -						    &sessp );
> +		ok = inv_lastsession_level_equalto(&fsid,
> +						   inv_idbt,
> +						   (u_char_t)sc_level,
> +						   &sessp);
>  		ok1 = inv_close( inv_idbt );
>  		ASSERT( ok1 );
>  		if ( ! ok ) {
> Index: b/inventory/inv_api.c
> ===================================================================
> --- a/inventory/inv_api.c
> +++ b/inventory/inv_api.c
> @@ -596,69 +596,78 @@ inv_free_session(
>  
>  
>  /*----------------------------------------------------------------------*/
> -/* inventory_lasttime_level_lessthan					*/
> -/*                                                                      */
> -/* Given a token that refers to a file system, and a level, this returns*/
> -/* the last time when a session of a lesser level was done.             */
> -/*                                                                      */
> -/* returns -1 on error.                                                 */
> +/* inv_lasttime_level_lessthan						*/
> +/*									*/
> +/* Given a file system uuid, token that refers to a file system, and a	*/
> +/* level, tm is populated with last time when a session of a lesser	*/
> +/* level was done.							*/
> +/*									*/
> +/* Returns TRUE on success.						*/
>  /*----------------------------------------------------------------------*/
>  
>  bool_t
>  inv_lasttime_level_lessthan( 
> -	inv_idbtoken_t  tok,
> -	u_char level,
> -	time32_t **tm )
> +	uuid_t		*fsidp,
> +	inv_idbtoken_t	tok,
> +	u_char		level,
> +	time32_t	**tm)
>  {
>  	int 	rval;
>  	if ( tok != INV_TOKEN_NULL ) {
> -		rval =  search_invt( tok->d_invindex_fd, &level, (void **) tm,
> -				    (search_callback_t) tm_level_lessthan );
> +		rval =  search_invt(fsidp, tok->d_invindex_fd, &level,
> +				    (void **)tm,
> +				    (search_callback_t)tm_level_lessthan);
>  
>  		return ( rval < 0) ? BOOL_FALSE: BOOL_TRUE;
>  	}
>  	
> -	return invmgr_query_all_sessions((void *) &level, /* in */
> -					 (void **) tm,   /* out */
> -			       (search_callback_t) tm_level_lessthan); 
> +	return invmgr_query_all_sessions(fsidp,		 /* fs uuid ptr */
> +					 (void *)&level, /* in */
> +					 (void **)tm,	 /* out */
> +			       (search_callback_t)tm_level_lessthan);
>  }
>  
> -
> -
> -
> -
>  /*----------------------------------------------------------------------*/
> -/*                                                                      */
> -/*                                                                      */
> -/*                                                                      */
> +/* inv_lastsession_level_lessthan					*/
> +/*									*/
> +/* Given a file system uuid, token that refers to a file system, and a	*/
> +/* level, ses is populated with a session of lesser than the level	*/
> +/* passed in.								*/
> +/*									*/
> +/* Returns FALSE on an error, TRUE if not. If (*ses) is NULL, then the	*/
> +/* search failed.                                                       */
>  /*----------------------------------------------------------------------*/
>  
>  bool_t
>  inv_lastsession_level_lessthan( 
> -	inv_idbtoken_t 	tok,
> +	uuid_t		*fsidp,
> +	inv_idbtoken_t	tok,
>  	u_char		level,
> -	inv_session_t 	**ses )
> +	inv_session_t	**ses)
>  {
>  	int 	rval;
>  	if ( tok != INV_TOKEN_NULL ) {
> -		rval = search_invt( tok->d_invindex_fd, &level, (void **) ses, 
> -				   (search_callback_t) lastsess_level_lessthan );
> +		rval = search_invt(fsidp, tok->d_invindex_fd, &level,
> +				   (void **)ses,
> +				   (search_callback_t)lastsess_level_lessthan);
>  
>  		return ( rval < 0) ? BOOL_FALSE: BOOL_TRUE;
>  	}
>  
> -	return invmgr_query_all_sessions((void *) &level, /* in */
> -					 (void **) ses,   /* out */
> -			       (search_callback_t) lastsess_level_lessthan);
> +	return invmgr_query_all_sessions(fsidp,		 /* fs uuid */
> +					 (void *)&level, /* in */
> +					 (void **)ses,	 /* out */
> +			       (search_callback_t)lastsess_level_lessthan);
>  
>  }
>  
> -
> -
> -
>  /*----------------------------------------------------------------------*/
> -/*                                                                      */
> -/*                                                                      */
> +/* inv_lastsession_level_equalto					*/
> +/*									*/
> +/* Given a file system uuid, token that refers to a file system, and a	*/
> +/* level, this populates ses with last time when a session of a lesser	*/
> +/* level was done.							*/
> +/*									*/
>  /* Return FALSE on an error, TRUE if not. If (*ses) is NULL, then the   */
>  /* search failed.                                                       */
>  /*----------------------------------------------------------------------*/
> @@ -666,21 +675,24 @@ inv_lastsession_level_lessthan(
>  
>  bool_t
>  inv_lastsession_level_equalto( 
> -	inv_idbtoken_t 	tok,			    
> +	uuid_t		*fsidp,
> +	inv_idbtoken_t	tok,
>  	u_char		level,
>  	inv_session_t	**ses )
>  {
>  	int 	rval;
>  	if ( tok != INV_TOKEN_NULL ) {
> -		rval = search_invt( tok->d_invindex_fd, &level, (void **) ses, 
> -				   (search_callback_t) lastsess_level_equalto );
> +		rval = search_invt(fsidp, tok->d_invindex_fd, &level,
> +				   (void **)ses,
> +				   (search_callback_t)lastsess_level_equalto);
>  
>  		return ( rval < 0) ? BOOL_FALSE: BOOL_TRUE;
>  	}
>  	
> -	return invmgr_query_all_sessions((void *) &level, /* in */
> -					 (void **) ses,   /* out */
> -			       (search_callback_t) lastsess_level_equalto);
> +	return invmgr_query_all_sessions(fsidp,		 /* fs uuid */
> +					 (void *)&level, /* in */
> +					 (void **)ses,	 /* out */
> +			       (search_callback_t)lastsess_level_equalto);
>  
>  }
>  
> @@ -688,35 +700,45 @@ inv_lastsession_level_equalto(
>  /*----------------------------------------------------------------------*/
>  /* inv_getsession_byuuid                                                */
>  /*                                                                      */
> +/* Given a file system uuid and a session uuid , ses is populated with	*/
> +/* the session that contains the matching system uuid.			*/
> +/*									*/
> +/* Returns FALSE on an error, TRUE if the session was found.		*/
>  /*----------------------------------------------------------------------*/
>  
>  bool_t
>  inv_get_session_byuuid(
> -	uuid_t	*sesid,
> -	inv_session_t **ses)
> +	uuid_t		*fsidp,
> +	uuid_t		*sesid,
> +	inv_session_t	**ses)
>  {
>  
> -	return (invmgr_query_all_sessions((void *)sesid, /* in */
> -					  (void **) ses, /* out */
> -			       (search_callback_t) stobj_getsession_byuuid));
> +	return invmgr_query_all_sessions(fsidp,		/* fs uuid */
> +					 (void *)sesid, /* in */
> +					 (void **)ses,	/* out */
> +			       (search_callback_t)stobj_getsession_byuuid);
>  }
>  
> -
> -
>  /*----------------------------------------------------------------------*/
> -/* inv_getsession_byuuid                                                */
> +/* inv_getsession_bylabel						*/
>  /*                                                                      */
> +/* Given a file system uuid and a session uuid, ses is populated with	*/
> +/* the session that contains the matching system label.			*/
> +/*									*/
> +/* Returns FALSE on an error, TRUE if the session was found.		*/
>  /*----------------------------------------------------------------------*/
>  
>  bool_t
>  inv_get_session_bylabel(
> -	char *session_label,
> -	inv_session_t **ses)
> +	uuid_t		*fsidp,
> +	char		*session_label,
> +	inv_session_t	**ses)
>  {
>  
> -	return (invmgr_query_all_sessions((void *)session_label, /* in */
> -					  (void **) ses, /* out */
> -			       (search_callback_t) stobj_getsession_bylabel));
> +	return invmgr_query_all_sessions(fsidp,			/* fs uuid */
> +					 (void *)session_label, /* in */
> +					 (void **)ses,		/* out */
> +			       (search_callback_t)stobj_getsession_bylabel);
>  }
>  
>  
> @@ -786,8 +808,8 @@ inv_delete_mediaobj( uuid_t *moid )
>  			return BOOL_FALSE;
>  		}
>  
> -		if ( search_invt( invfd, NULL, (void **)&moid, 
> -				  (search_callback_t) stobj_delete_mobj )
> +		if (search_invt(&arr[i].ft_uuid, invfd, NULL, (void **)&moid,
> +				(search_callback_t)stobj_delete_mobj)
>  		    < 0 )
>  			return BOOL_FALSE;
>  		/* we have to delete the session, etc */
> Index: b/inventory/inv_mgr.c
> ===================================================================
> --- a/inventory/inv_mgr.c
> +++ b/inventory/inv_mgr.c
> @@ -134,8 +134,9 @@ get_sesstoken( inv_idbtoken_t tok )
>  /*---------------------------------------------------------------------------*/
>  bool_t
>  invmgr_query_all_sessions (
> -	void *inarg,
> -	void **outarg,
> +	uuid_t		  *fsidp,
> +	void 		  *inarg,
> +	void 		  **outarg,
>  	search_callback_t func)
>  {
>  	invt_counter_t *cnt;
> @@ -145,6 +146,7 @@ invmgr_query_all_sessions (
>  	int result;
>  	inv_oflag_t forwhat = INV_SEARCH_ONLY;
>  	void *objectfound;
> +	bool_t ret = BOOL_FALSE;
>  
>  	/* if on return, this is still null, the search failed */
>  	*outarg = NULL; 
> @@ -157,7 +159,7 @@ invmgr_query_all_sessions (
>  	}
>  	if ( fd < 0 || numfs <= 0 ) {
>  		mlog( MLOG_NORMAL | MLOG_INV, _("INV: Error in fstab\n") );
> -		return BOOL_FALSE;
> +		return ret;
>  	}
>  	
>  	close( fd );
> @@ -169,7 +171,7 @@ invmgr_query_all_sessions (
>  			mlog( MLOG_NORMAL | MLOG_INV, _(
>  			     "INV: Cant get inv-name for uuid\n")
>  			     );
> -			return BOOL_FALSE;
> +			continue;
>  		}
>  		strcat( fname, INV_INVINDEX_PREFIX );
>  		invfd = open( fname, INV_OFLAG(forwhat) );
> @@ -178,9 +180,9 @@ invmgr_query_all_sessions (
>  			     "INV: Open failed on %s\n"),
>  			     fname
>  			     );
> -			return BOOL_FALSE;
> +			continue;
>  		}
> -		result = search_invt( invfd, inarg, &objectfound, func );
> +		result = search_invt(fsidp, invfd, inarg, &objectfound, func);
>  		close(invfd);		
>  
>  		/* if error return BOOL_FALSE */
> @@ -192,12 +194,13 @@ invmgr_query_all_sessions (
>  			return BOOL_TRUE;
>  		} else if (result == 1) {
>  			*outarg = objectfound;
> +			ret = BOOL_TRUE;
>  		}
>  	}
>  	
>  	/* return val indicates if there was an error or not. *buf
>  	   says whether the search was successful */
> -	return BOOL_TRUE;
> +	return ret;
>  }
>  
>  
> @@ -213,10 +216,11 @@ invmgr_query_all_sessions (
>  
>  intgen_t
>  search_invt( 
> -	int 			invfd,
> -	void 			*arg, 
> -	void 			**buf,
> -	search_callback_t 	do_chkcriteria )
> +	uuid_t			*fsidp,
> +	int			invfd,
> +	void			*arg,
> +	void			**buf,
> +	search_callback_t	do_chkcriteria)
>  {
>  
>  	int 		fd, i;
> @@ -247,7 +251,7 @@ search_invt(
>  	/* we need to get all the invindex headers and seshdrs in reverse
>  	   order */
>  	for (i = nindices - 1; i >= 0; i--) {
> -		int 			nsess;
> +		int			nsess, j;
>  		invt_sescounter_t 	*scnt = NULL;
>  		invt_seshdr_t		*harr = NULL;
>  		bool_t                  found;
> @@ -272,19 +276,34 @@ search_invt(
>  		}
>  		free ( scnt );
>  
> -		while ( nsess ) {
> +		for (j = nsess - 1; j >= 0; j--) {
> +			invt_session_t ses;
> +
>  			/* fd is kept locked until we return from the 
>  			   callback routine */
>  
>  			/* Check to see if this session has been pruned 
>  			 * by xfsinvutil before checking it. 
>  			 */
> -			if ( harr[nsess - 1].sh_pruned ) {
> -				--nsess;
> +			if (harr[j].sh_pruned) {
>  				continue;
>  			}
> -			found = (* do_chkcriteria ) ( fd, &harr[ --nsess ],
> -						      arg, buf );
> +
> +			/* if we need to check the fs uuid's and they don't
> +			 * match or we fail to get the session record,
> +			 * then keep looking
> +			 */
> +			if (fsidp) {
> +				int ret = GET_REC_NOLOCK(fd, &ses,
> +						         sizeof(invt_session_t),
> +						         harr[j].sh_sess_off);
> +				if (ret < 0)
> +					return ret;
> +				if (uuid_compare(ses.s_fsid, *fsidp))
> +					continue;
> +			}
> +
> +			found = (* do_chkcriteria)(fd, &harr[j], arg, buf);
>  			if (! found ) continue;
>  			
>  			/* we found what we need; just return */
> Index: b/inventory/inv_priv.h
> ===================================================================
> --- a/inventory/inv_priv.h
> +++ b/inventory/inv_priv.h
> @@ -548,11 +548,12 @@ get_headerinfo( int fd, void **hdrs, voi
>  	        size_t hdrsz, size_t cntsz, bool_t doblock );
>  
>  bool_t
> -invmgr_query_all_sessions (void *inarg,	void **outarg, search_callback_t func);
> +invmgr_query_all_sessions(uuid_t *fsidp, void *inarg, void **outarg,
> +			  search_callback_t func);
>  
>  intgen_t
> -search_invt( int invfd, void *arg, void **buf, 
> -	    search_callback_t do_chkcriteria );
> +search_invt(uuid_t *fsidp, int invfd, void *arg, void **buf,
> +	    search_callback_t do_chkcriteria);
>  intgen_t
>  invmgr_inv_print( int invfd, invt_pr_ctx_t *prctx);
>  
> Index: b/inventory/inventory.h
> ===================================================================
> --- a/inventory/inventory.h
> +++ b/inventory/inventory.h
> @@ -247,32 +247,37 @@ inv_put_mediafile(
>   */
>  extern bool_t
>  inv_lasttime_level_lessthan( 
> +	uuid_t			*fsidp,
>  	inv_idbtoken_t 		tok,
> -	u_char  		level,
> -	time32_t		**time );/* out */
> +	u_char			level,
> +	time32_t		**time); /* out */
>  
>  extern bool_t
>  inv_lastsession_level_lessthan( 
> +	uuid_t			*fsidp,
>  	inv_idbtoken_t 		tok,			     
>  	u_char  		level,
> -	inv_session_t		**ses );/* out */
> +	inv_session_t		**ses); /* out */
>  
>  extern bool_t
>  inv_lastsession_level_equalto( 
> +	uuid_t			*fsidp,
>  	inv_idbtoken_t 		tok,			     
>  	u_char  		level,
> -	inv_session_t		**ses );/* out */
> +	inv_session_t		**ses); /* out */
>  
>  /* Given a uuid of a session, return the session structure.*/
>  extern bool_t
>  inv_get_session_byuuid(
> -	uuid_t	*sesid,
> -	inv_session_t **ses);
> +	uuid_t		*fsidp,
> +	uuid_t		*sesid,
> +	inv_session_t	**ses);
>  
>  extern bool_t
>  inv_get_session_bylabel(
> -	char *session_label,
> -	inv_session_t **ses);
> +	uuid_t		*fsidp,
> +	char		*session_label,
> +	inv_session_t	**ses);
>  
>  
>  /* on return, *ses is NULL */
> Index: b/restore/content.c
> ===================================================================
> --- a/restore/content.c
> +++ b/restore/content.c
> @@ -2179,8 +2179,9 @@ content_stream_restore( ix_t thrdix )
>  		if ( ! drivep->d_isnamedpipepr
>  		     &&
>  		     ! drivep->d_isunnamedpipepr ) {
> -			ok = inv_get_session_byuuid( &grhdrp->gh_dumpid,
> -						     &sessp );
> +			ok = inv_get_session_byuuid(NULL,
> +						    &grhdrp->gh_dumpid,
> +						    &sessp);
>  			if ( ok && sessp ) {
>  				mlog( MLOG_VERBOSE, _(
>  				      "using online session inventory\n") );
> @@ -3736,9 +3737,9 @@ Inv_validate_cmdline( void )
>  	ok = BOOL_FALSE;
>  	sessp = 0;
>  	if ( tranp->t_reqdumpidvalpr ) {
> -		ok = inv_get_session_byuuid( &tranp->t_reqdumpid, &sessp );
> +		ok = inv_get_session_byuuid(NULL, &tranp->t_reqdumpid, &sessp);
>  	} else if ( tranp->t_reqdumplabvalpr ) {
> -		ok = inv_get_session_bylabel( tranp->t_reqdumplab, &sessp );
> +		ok = inv_get_session_bylabel(NULL, tranp->t_reqdumplab, &sessp);
>  	}
>  	rok = BOOL_FALSE;
>  	if ( ok && sessp ) {
> @@ -6812,13 +6813,15 @@ askinvforbaseof( uuid_t baseid, inv_sess
>  	/* get the base session
>  	 */
>  	if ( resumedpr ) {
> -		ok = inv_lastsession_level_equalto( invtok,
> -						    ( u_char_t )level,
> -						    &basesessp );
> +		ok = inv_lastsession_level_equalto(&sessp->s_fsid,
> +						    invtok,
> +						    (u_char_t)level,
> +						    &basesessp);
>  	} else {
> -		ok = inv_lastsession_level_lessthan( invtok,
> -						     ( u_char_t )level,
> -						     &basesessp );
> +		ok = inv_lastsession_level_lessthan(&sessp->s_fsid,
> +						     invtok,
> +						     (u_char_t)level,
> +						     &basesessp);
>  	}
>  	if ( ! ok ) {
>  		mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA, _(
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
