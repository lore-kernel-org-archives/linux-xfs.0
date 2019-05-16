Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56410 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726314AbfEPP46 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 May 2019 11:56:58 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C02363082B6B
        for <linux-xfs@vger.kernel.org>; Thu, 16 May 2019 15:56:55 +0000 (UTC)
Date: Thu, 16 May 2019 10:56:52 -0500
From: Bill O'Donnell <billodo@redhat.com>
Subject: Re: [PATCH] xfsdump: (style) remove spaces for pointers and negations
Message-ID: <20190516155652.GB12451@redhat.com>
References: <20190515130340.45155-1-jtulak@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190515130340.45155-1-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, May 15, 2019 at 03:03:40PM +0200, Jan Tulak wrote:
> Another case of different xfsdump style, spaces around * and !
> operators. This style was used a lot through xfsdump:
> (* foo_t)xxx
>   ^ space
> While the rest of XFS omits the space. Same for negations:
> if (! foo)
> 
> This patch changes all occurrences to comply with the rest of xfs/kernel
> coding style by removing the space. Unlike the previous patches, this
> one is not fully replicable by a script - I had to manually correct many
> cases of overzealous replacements in comments or strings.
> (Regular expressions are a too weak tool for these context-sensitive
> changes.)
> 
> Still, the script that did most of the job is here:
> 
> find . -name '*.[ch]' ! -type d -exec gawk -i inplace '{
>     $0 = gensub(/^([^"]*)\(\* /, "\\1(*", "g") # foo(* bar
>     $0 = gensub(/\(\* ([^"]*)$/, "(*\\1", "g") #
>     $0 = gensub(/^([^ *#]{2}[^"]*)! /, "\\1!", "g") # space after exclamation mark
> }; {print }' {} \;
> 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>
> ---

looks good.
Reviewed-by: Bill O'Donnell <billodo@redhat.com>

>  common/cldmgr.c         |   8 +-
>  common/cldmgr.h         |   2 +-
>  common/cleanup.c        |  12 +-
>  common/dlog.c           |   8 +-
>  common/dlog.h           |   4 +-
>  common/drive.c          |  30 +--
>  common/drive.h          |  50 ++---
>  common/drive_minrmt.c   | 136 ++++++-------
>  common/drive_scsitape.c | 283 +++++++++++++-------------
>  common/drive_simple.c   |  32 +--
>  common/fs.c             |  10 +-
>  common/global.c         |  12 +-
>  common/inventory.c      |   2 +-
>  common/main.c           | 116 +++++------
>  common/media.c          |  18 +-
>  common/mlog.c           |  12 +-
>  common/path.c           |  16 +-
>  common/qlock.c          |   8 +-
>  common/ring.c           |   8 +-
>  common/ring.h           |   4 +-
>  common/stream.c         |   2 +-
>  common/util.c           |  22 +-
>  common/util.h           |   8 +-
>  dump/content.c          | 170 ++++++++--------
>  dump/inomap.c           |  12 +-
>  dump/var.c              |   6 +-
>  inventory/inv_api.c     |  16 +-
>  inventory/inv_fstab.c   |   4 +-
>  inventory/inv_idx.c     |   1 -
>  inventory/inv_mgr.c     |   4 +-
>  inventory/inv_oref.c    |  10 +-
>  inventory/inv_stobj.c   |  16 +-
>  inventory/testmain.c    |   8 +-
>  invutil/cmenu.h         |  24 +--
>  invutil/invutil.c       |   2 +-
>  restore/bag.c           |  10 +-
>  restore/content.c       | 436 ++++++++++++++++++++--------------------
>  restore/dirattr.c       |  24 +--
>  restore/dirattr.h       |   2 +-
>  restore/inomap.c        |  12 +-
>  restore/inomap.h        |   2 +-
>  restore/namreg.c        |  14 +-
>  restore/node.c          |   8 +-
>  restore/tree.c          | 262 ++++++++++++------------
>  restore/tree.h          |   4 +-
>  restore/win.c           |  20 +-
>  46 files changed, 934 insertions(+), 936 deletions(-)
> 
> diff --git a/common/cldmgr.c b/common/cldmgr.c
> index 3702f71..295a5dd 100644
> --- a/common/cldmgr.c
> +++ b/common/cldmgr.c
> @@ -47,7 +47,7 @@ struct cld {
>  	int c_exit_code;
>  	pthread_t c_tid;
>  	ix_t c_streamix;
> -	int (* c_entry)(void *arg1);
> +	int (*c_entry)(void *arg1);
>  	void * c_arg1;
>  };
>  
> @@ -73,7 +73,7 @@ cldmgr_init(void)
>  }
>  
>  bool_t
> -cldmgr_create(int (* entry)(void *arg1),
> +cldmgr_create(int (*entry)(void *arg1),
>  	       ix_t streamix,
>  	       char *descstr,
>  	       void *arg1)
> @@ -84,7 +84,7 @@ cldmgr_create(int (* entry)(void *arg1),
>  	assert(pthread_equal(pthread_self(), cldmgr_parenttid));
>  
>  	cldp = cldmgr_getcld();
> -	if (! cldp) {
> +	if (!cldp) {
>  		mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_PROC, _(
>  		      "cannot create %s thread for stream %u: "
>  		      "too many child threads (max allowed is %d)\n"),
> @@ -234,7 +234,7 @@ cldmgr_entry(void *arg1)
>  	      "thread %lu created for stream %d\n",
>  	      tid,
>  	      cldp->c_streamix);
> -	cldp->c_exit_code = (* cldp->c_entry)(cldp->c_arg1);
> +	cldp->c_exit_code = (*cldp->c_entry)(cldp->c_arg1);
>  
>  	pthread_cleanup_pop(1);
>  
> diff --git a/common/cldmgr.h b/common/cldmgr.h
> index ce3a382..3dc74a6 100644
> --- a/common/cldmgr.h
> +++ b/common/cldmgr.h
> @@ -29,7 +29,7 @@ extern bool_t cldmgr_init(void);
>  /* cldmgr_create - creates a child thread. returns FALSE if trouble
>   * encountered
>   */
> -extern bool_t cldmgr_create(int (* entry)(void *arg1),
> +extern bool_t cldmgr_create(int (*entry)(void *arg1),
>  			     ix_t streamix,
>  			     char *descstr,
>  			     void *arg1);
> diff --git a/common/cleanup.c b/common/cleanup.c
> index 5248f3c..f5039ec 100644
> --- a/common/cleanup.c
> +++ b/common/cleanup.c
> @@ -22,7 +22,7 @@
>  #include "cleanup.h"
>  
>  struct cu {
> -	void (* cu_funcp)(void *arg1, void *arg2);
> +	void (*cu_funcp)(void *arg1, void *arg2);
>  	void *cu_arg1;
>  	void *cu_arg2;
>  	int  cu_flags;
> @@ -45,7 +45,7 @@ cleanup_init(void)
>  }
>  
>  static cleanup_t *
> -cleanup_register_base(void (* funcp)(void *arg1, void *arg2),
> +cleanup_register_base(void (*funcp)(void *arg1, void *arg2),
>  		  void *arg1,
>  		  void *arg2)
>  {
> @@ -64,7 +64,7 @@ cleanup_register_base(void (* funcp)(void *arg1, void *arg2),
>  }
>  
>  cleanup_t *
> -cleanup_register(void (* funcp)(void *arg1, void *arg2),
> +cleanup_register(void (*funcp)(void *arg1, void *arg2),
>  		  void *arg1,
>  		  void *arg2)
>  {
> @@ -76,7 +76,7 @@ cleanup_register(void (* funcp)(void *arg1, void *arg2),
>  }
>  
>  cleanup_t *
> -cleanup_register_early(void (* funcp)(void *arg1, void *arg2),
> +cleanup_register_early(void (*funcp)(void *arg1, void *arg2),
>  		  void *arg1,
>  		  void *arg2)
>  {
> @@ -118,7 +118,7 @@ cleanup(void)
>  {
>  	while (cu_rootp) {
>  		cu_t *p = cu_rootp;
> -		(* p->cu_funcp)(p->cu_arg1, p->cu_arg2);
> +		(*p->cu_funcp)(p->cu_arg1, p->cu_arg2);
>  		cu_rootp = p->cu_nextp;
>  		free((void *)p);
>  	}
> @@ -136,7 +136,7 @@ cleanup_early(void)
>  		cu_t *cunextp = cuptr->cu_nextp;
>  
>  		if (cuptr->cu_flags & CU_EARLY) {
> -			(* cuptr->cu_funcp)(cuptr->cu_arg1, cuptr->cu_arg2);
> +			(*cuptr->cu_funcp)(cuptr->cu_arg1, cuptr->cu_arg2);
>  			free((void *)cuptr);
>  			if (cuprevp)  {
>  				cuprevp->cu_nextp = cunextp;
> diff --git a/common/dlog.c b/common/dlog.c
> index ee2654f..836044d 100644
> --- a/common/dlog.c
> +++ b/common/dlog.c
> @@ -90,7 +90,7 @@ dlog_init(int argc, char *argv[])
>  	/* look to see if restore source coming in on
>  	 * stdin. If so, try to open /dev/tty for dialogs.
>  	 */
> -	if (optind < argc && ! strcmp(argv[optind ], "-")) {
> +	if (optind < argc && !strcmp(argv[optind ], "-")) {
>  		dlog_ttyfd = open("/dev/tty", O_RDWR);
>  		if (dlog_ttyfd < 0) {
>  			perror("/dev/tty");
> @@ -251,7 +251,7 @@ dlog_multi_query(char *querystr[],
>  			long int val;
>  			char *end = buf;
>  
> -			if (! strlen(buf)) {
> +			if (!strlen(buf)) {
>  				return defaultix;
>  			}
>  
> @@ -303,7 +303,7 @@ dlog_string_query(dlog_ucbp_t ucb, /* user's print func */
>  	/* call the caller's callback with his context, print context, and
>  	 * print operator
>  	 */
> -	(* ucb)(uctxp, dlog_string_query_print, 0);
> +	(*ucb)(uctxp, dlog_string_query_print, 0);
>  
>  	/* if called for, print the timeout and a newline.
>  	 * if not, print just a newline
> @@ -362,7 +362,7 @@ dlog_string_query_print(void *ctxp, char *fmt, ...)
>  {
>  	va_list args;
>  
> -	assert(! ctxp);
> +	assert(!ctxp);
>  
>  	va_start(args, fmt);
>  	mlog_va(MLOG_NORMAL | MLOG_NOLOCK | MLOG_BARE, fmt, args);
> diff --git a/common/dlog.h b/common/dlog.h
> index 7f0e41d..4c76f31 100644
> --- a/common/dlog.h
> +++ b/common/dlog.h
> @@ -78,8 +78,8 @@ extern void dlog_multi_ack(char *ackstr[], size_t ackcnt);
>   * received, sigquitix if SIGQUIT received. if any of the exception indices
>   * are set to IXMAX by the caller, those events will be ignored.
>   */
> -typedef void (* dlog_pcbp_t)(void *pctxp, char *s, ...);
> -typedef void (* dlog_ucbp_t)(void *uctxp, dlog_pcbp_t pcb, void *pctxp);
> +typedef void (*dlog_pcbp_t)(void *pctxp, char *s, ...);
> +typedef void (*dlog_ucbp_t)(void *uctxp, dlog_pcbp_t pcb, void *pctxp);
>  extern ix_t dlog_string_query(dlog_ucbp_t ucb, /* user's print func */
>  			       void *uctxp,	/* user's context for above */
>  			       char *bufp,	/* typed string returned in */
> diff --git a/common/drive.c b/common/drive.c
> index a3514a9..67b6f25 100644
> --- a/common/drive.c
> +++ b/common/drive.c
> @@ -131,7 +131,7 @@ drive_init1(int argc, char *argv[])
>  	while ((c = getopt(argc, argv, GETOPT_CMDSTRING)) != EOF) {
>  		switch (c) {
>  		case GETOPT_DUMPDEST:
> -			if (! optarg || optarg[0] == '-') {
> +			if (!optarg || optarg[0] == '-') {
>  				mlog(MLOG_NORMAL,
>  				      _("-%c argument missing\n"),
>  				      c);
> @@ -152,7 +152,7 @@ drive_init1(int argc, char *argv[])
>  	 * a single dash ('-') with no option letter. This must appear
>  	 * between all lettered arguments and the file system pathname.
>  	 */
> -	if (optind < argc && ! strcmp(argv[optind ], "-")) {
> +	if (optind < argc && !strcmp(argv[optind ], "-")) {
>  		if (driveix > 0) {
>  			mlog(MLOG_NORMAL,
>  #ifdef DUMP
> @@ -211,10 +211,10 @@ drive_init1(int argc, char *argv[])
>  		for (six = 0; six < scnt; six++) {
>  			drive_strategy_t *sp = strategypp[six];
>  			int score;
> -			score = (* sp->ds_match)(argc,
> +			score = (*sp->ds_match)(argc,
>  						    argv,
>  						    drivep);
> -			if (! bestsp || score > bestscore) {
> +			if (!bestsp || score > bestscore) {
>  				bestsp = sp;
>  				bestscore = score;
>  			}
> @@ -226,10 +226,10 @@ drive_init1(int argc, char *argv[])
>  		mlog(MLOG_VERBOSE,
>  		      _("using %s strategy\n"),
>  		      bestsp->ds_description);
> -		ok = (* bestsp->ds_instantiate)(argc,
> +		ok = (*bestsp->ds_instantiate)(argc,
>  						   argv,
>  						   drivep);
> -		if (! ok) {
> +		if (!ok) {
>  			return BOOL_FALSE;
>  		}
>  	}
> @@ -256,8 +256,8 @@ drive_init2(int argc,
>  		bool_t ok;
>  
>  		drive_allochdrs(drivep, gwhdrtemplatep, driveix);
> -		ok = (* drivep->d_opsp->do_init)(drivep);
> -		if (! ok) {
> +		ok = (*drivep->d_opsp->do_init)(drivep);
> +		if (!ok) {
>  			return BOOL_FALSE;
>  		}
>  	}
> @@ -278,8 +278,8 @@ drive_init3(void)
>  		drive_t *drivep = drivepp[driveix];
>  		bool_t ok;
>  
> -		ok = (* drivep->d_opsp->do_sync)(drivep);
> -		if (! ok) {
> +		ok = (*drivep->d_opsp->do_sync)(drivep);
> +		if (!ok) {
>  			return BOOL_FALSE;
>  		}
>  	}
> @@ -304,7 +304,7 @@ drive_mark_commit(drive_t *drivep, off64_t ncommitted)
>  	;
>  	) {
>  		drivep->d_markrecheadp = dmp->dm_nextp;
> -		(* dmp->dm_cbfuncp)(dmp->dm_cbcontextp, dmp, BOOL_TRUE);
> +		(*dmp->dm_cbfuncp)(dmp->dm_cbcontextp, dmp, BOOL_TRUE);
>  		dmp = drivep->d_markrecheadp;
>  	}
>  }
> @@ -324,7 +324,7 @@ drive_mark_discard(drive_t *drivep)
>  	;
>  	drivep->d_markrecheadp = dmp->dm_nextp, dmp = dmp->dm_nextp) {
>  
> -		(* dmp->dm_cbfuncp)(dmp->dm_cbcontextp, dmp, BOOL_FALSE);
> +		(*dmp->dm_cbfuncp)(dmp->dm_cbcontextp, dmp, BOOL_FALSE);
>  	}
>  }
>  
> @@ -340,7 +340,7 @@ drive_display_metrics(void)
>  		drive_t *drivep = drivepp[driveix];
>  		drive_ops_t *dop = drivep->d_opsp;
>  		if (dop->do_display_metrics) {
> -			(* dop->do_display_metrics)(drivep);
> +			(*dop->do_display_metrics)(drivep);
>  		}
>  	}
>  }
> @@ -371,9 +371,9 @@ drive_alloc(char *pathname, ix_t driveix)
>  
>  	/* set pipe flags
>  	 */
> -	if (! strcmp(pathname, "stdio")) {
> +	if (!strcmp(pathname, "stdio")) {
>  		drivep->d_isunnamedpipepr = BOOL_TRUE;
> -	} else if (! stat64(pathname, &statbuf)
> +	} else if (!stat64(pathname, &statbuf)
>  		    &&
>  		    (statbuf.st_mode & S_IFMT) == S_IFIFO) {
>  		drivep->d_isnamedpipepr = BOOL_TRUE;
> diff --git a/common/drive.h b/common/drive.h
> index 4b4fcf8..ee53aeb 100644
> --- a/common/drive.h
> +++ b/common/drive.h
> @@ -138,13 +138,13 @@ struct drive_strategy {
>  	char *ds_description;
>  		    /* a short char string describing strategy
>  		     */
> -	int (* ds_match)(int argc,
> +	int (*ds_match)(int argc,
>  				 char *argv[],
>  				 struct drive *drivep);
>  		    /* returns degree of match. drivep has been pre-allocated
>  		     * and initialized with generic info.
>  		     */
> -	bool_t (* ds_instantiate)(int argc,
> +	bool_t (*ds_instantiate)(int argc,
>  				     char *argv[],
>  				     struct drive *drivep);
>  		    /* creates a drive manager instance, by filling in the
> @@ -186,7 +186,7 @@ typedef off64_t drive_mark_t;
>   * was NOT committed.
>   */
>  struct drive_markrec; /* forward decl */
> -typedef void (* drive_mcbfp_t)(void *context_t,
> +typedef void (*drive_mcbfp_t)(void *context_t,
>  				  struct drive_markrec *markrecp,
>  				  bool_t committed);
>  
> @@ -257,17 +257,17 @@ struct drive {
>  typedef struct drive drive_t;
>  
>  struct drive_ops {
> -	bool_t (* do_init)(drive_t *drivep);
> +	bool_t (*do_init)(drive_t *drivep);
>  				/* initializes drive, and begins async
>  				 * determination of media object presence
>  				 * returns FALSE if session should be aborted.
>  				 */
> -	bool_t (* do_sync)(drive_t *drivep);
> +	bool_t (*do_sync)(drive_t *drivep);
>  				/* synchronizes with the activity kicked off
>  				 * by do_init. returns FALSE if session should
>  				 * be aborted.
>  				 */
> -	int (* do_begin_read)(drive_t *drivep);
> +	int (*do_begin_read)(drive_t *drivep);
>  				/* prepares the drive manager for reading.
>  				 * if the media is positioned at BOM or just
>  				 * after a file mark, current media file is
> @@ -306,7 +306,7 @@ struct drive_ops {
>  				 * begin_read. if successful, caller MUST call
>  				 * end_read prior to next begin_read.
>  				 */
> -	char * (* do_read)(drive_t *drivep,
> +	char *(*do_read)(drive_t *drivep,
>  			      size_t wanted_bufsz,
>  			      size_t *actual_bufszp,
>  			      int *statp);
> @@ -341,7 +341,7 @@ struct drive_ops {
>  				 * valid data (although the buffer size may
>  				 * be zero!).
>  				 */
> -	void (* do_return_read_buf)(drive_t *drivep,
> +	void (*do_return_read_buf)(drive_t *drivep,
>  				       char *bufp,
>  				       size_t bufsz);
>  				/* returns the buffer obtained
> @@ -349,14 +349,14 @@ struct drive_ops {
>  				 * the entire buffer must be returned
>  				 * in one shot.
>  				 */
> -	void (* do_get_mark)(drive_t *drivep,
> +	void (*do_get_mark)(drive_t *drivep,
>  				drive_mark_t *drivemarkp);
>  				/* returns (by reference) a mark corresponding
>  				 * to the next byte which will be read by a
>  				 * call to do_read(). will be used in a later
>  				 * session to seek to that position.
>  				 */
> -	int (* do_seek_mark)(drive_t *drivep,
> +	int (*do_seek_mark)(drive_t *drivep,
>  				     drive_mark_t *drivemarkp);
>  				/* searches for the specified mark within the
>  				 * current file. returns zero if the mark
> @@ -367,7 +367,7 @@ struct drive_ops {
>  				 *	CORRUPTION - encountered corrupt data;
>  				 *	DEVICE - device error;
>  				 */
> -	int (* do_next_mark)(drive_t *drivep);
> +	int (*do_next_mark)(drive_t *drivep);
>  				/* if d_capabilities has DRIVE_CAP_NEXTMARK set,
>  				 * drive has the capability to
>  				 * seek forward to the next mark. returns
> @@ -385,7 +385,7 @@ struct drive_ops {
>  				 * will position the media at the next media
>  				 * file.
>  				 */
> -	int (* do_begin_write)(drive_t *drivep);
> +	int (*do_begin_write)(drive_t *drivep);
>  				/* begins a write media file for writing.
>  				 * asserts the media is positioned at BOM or
>  				 * just after a file mark. write header will
> @@ -396,7 +396,7 @@ struct drive_ops {
>  				 *	DEVICE - device error;
>  				 *	CORE  - driver error
>  				 */
> -	void (* do_set_mark)(drive_t *drivep,
> +	void (*do_set_mark)(drive_t *drivep,
>  				drive_mcbfp_t cbfuncp,
>  				void *cbcontextp,
>  				drive_markrec_t *markrecp);
> @@ -426,7 +426,7 @@ struct drive_ops {
>  				 * last committed marked point in the write
>  				 * stream.
>  				 */
> -	char * (* do_get_write_buf)(drive_t *drivep,
> +	char *(*do_get_write_buf)(drive_t *drivep,
>  				       size_t wanted_bufsz,
>  				       size_t *actual_bufszp);
>  				/* asks the drive manager for a buffer.
> @@ -443,7 +443,7 @@ struct drive_ops {
>  				 * be larger or smaller than the wanted bufsz,
>  				 * but will be at least 1 byte in length.
>  				 */
> -	int (* do_write)(drive_t *drivep,
> +	int (*do_write)(drive_t *drivep,
>  				 char *bufp,
>  				 size_t bufsz);
>  				/* asks the drive manager to write bufsz
> @@ -473,7 +473,7 @@ struct drive_ops {
>  				 * instead, the caller must get another buffer
>  				 * using do_get_write_buf().
>  				 */
> -	size_t (* do_get_align_cnt)(drive_t *drivep);
> +	size_t (*do_get_align_cnt)(drive_t *drivep);
>  				/* used during writing. returns the number
>  				 * of bytes which should be written to
>  				 * page-align the next do_get_write_buf()
> @@ -481,7 +481,7 @@ struct drive_ops {
>  				 * alignment will be maintained after the
>  				 * initial alignment done using this info.
>  				 */
> -	int (* do_end_write)(drive_t *drivep, off64_t *ncommittedp);
> +	int (*do_end_write)(drive_t *drivep, off64_t *ncommittedp);
>  				/* terminates a media file write sequence.
>  				 * flushes any buffered data not yet committed
>  				 * to media, and calls callbacks for all marks
> @@ -502,7 +502,7 @@ struct drive_ops {
>  				 * an error, do_end_write will not do any
>  				 * I/O, and will return 0.
>  				 */
> -	int (* do_fsf)(drive_t *drivep,
> +	int (*do_fsf)(drive_t *drivep,
>  			      int count,
>  			      int *statp);
>  				/* if d_capabilities has DRIVE_CAP_FSF set,
> @@ -528,7 +528,7 @@ struct drive_ops {
>  				 * behaves as if position is at most recent
>  				 * file mark or BOT.
>  				 */
> -	int (* do_bsf)(drive_t *drivep,
> +	int (*do_bsf)(drive_t *drivep,
>  			       int count,
>  			       int *statp);
>  				/* if d_capabilities has DRIVE_CAP_BSF set,
> @@ -554,35 +554,35 @@ struct drive_ops {
>  				 *	BOM - hit beginning of recorded data;
>  				 *	DEVICE - device error;
>  				 */
> -	int (* do_rewind)(drive_t *drivep);
> +	int (*do_rewind)(drive_t *drivep);
>  				/* if d_capabilities has DRIVE_CAP_REWIND set,
>  				 * drive has the capability to
>  				 * position at beginning of recorded data
>  				 *	DEVICE - device error;
>  				 */
> -	int (* do_erase)(drive_t *drivep);
> +	int (*do_erase)(drive_t *drivep);
>  				/* if d_capabilities has DRIVE_CAP_ERASE set,
>  				 * drive has the capability to
>  				 * erase: all content of media object is
>  				 * eradicated.
>  				 *	DEVICE - device error;
>  				 */
> -	int (* do_eject_media)(drive_t *drivep);
> +	int (*do_eject_media)(drive_t *drivep);
>  				/* if d_capabilities has DRIVE_CAP_EJECT set,
>  				 * drive has capability
>  				 * to eject media, and will do so when called.
>  				 *	DEVICE - device error;
>  				 */
> -	int (* do_get_device_class)(drive_t *drivep);
> +	int (*do_get_device_class)(drive_t *drivep);
>  				/* returns the media class of the device
>  				 * (see below).
>  				 */
> -	void (* do_display_metrics)(drive_t *drivep);
> +	void (*do_display_metrics)(drive_t *drivep);
>  				/* use BARE mlog to print useful throughput
>  				 * and performance info. set to NULL if
>  				 * nothing to say.
>  				 */
> -	void (* do_quit)(drive_t * drivep);
> +	void (*do_quit)(drive_t *drivep);
>  				/* tells the drive manager to de-allocate
>  				 * resources, INCLUDING the slave process.
>  				 */
> diff --git a/common/drive_minrmt.c b/common/drive_minrmt.c
> index 2a72939..c497583 100644
> --- a/common/drive_minrmt.c
> +++ b/common/drive_minrmt.c
> @@ -278,7 +278,7 @@ static void do_get_mark(drive_t *, drive_mark_t *);
>  static void do_end_read(drive_t *);
>  static int do_begin_write(drive_t *);
>  static void do_set_mark(drive_t *, drive_mcbfp_t, void *, drive_markrec_t *);
> -static char * do_get_write_buf(drive_t *, size_t, size_t *);
> +static char *do_get_write_buf(drive_t *, size_t, size_t *);
>  static int do_write(drive_t *, char *, size_t);
>  static size_t do_get_align_cnt(drive_t *);
>  static int do_end_write(drive_t *, off64_t *);
> @@ -320,7 +320,7 @@ static double percent64(off64_t num, off64_t denom);
>  static int getrec(drive_t *drivep);
>  static int write_record(drive_t *drivep, char *bufp, bool_t chksumpr,
>                                bool_t xlatepr);
> -static ring_msg_t * Ring_get(ring_t *ringp);
> +static ring_msg_t *Ring_get(ring_t *ringp);
>  static void Ring_reset(ring_t *ringp, ring_msg_t *msgp);
>  static void Ring_put(ring_t *ringp, ring_msg_t *msgp);
>  static int validate_media_file_hdr(drive_t *drivep);
> @@ -417,7 +417,7 @@ ds_match(int argc, char *argv[], drive_t *drivep)
>  	/* heuristics to determine if this is a drive.
>  	 */
>  
> -	if (! strcmp(drivep->d_pathname, "stdio")) {
> +	if (!strcmp(drivep->d_pathname, "stdio")) {
>  		return -10;
>  	}
>  
> @@ -432,7 +432,7 @@ ds_match(int argc, char *argv[], drive_t *drivep)
>  		while ((c = getopt(argc, argv, GETOPT_CMDSTRING)) != EOF) {
>  		   switch (c) {
>  		      case GETOPT_BLOCKSIZE:
> -			    if (! optarg || optarg[0] == '-') {
> +			    if (!optarg || optarg[0] == '-') {
>  				mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
>  					_("-%c argument missing\n"),
>  					c);
> @@ -479,7 +479,7 @@ ds_instantiate(int argc, char *argv[], drive_t *drivep)
>  	assert(sizeof(rec_hdr_t)
>  		==
>  		sizeofmember(drive_hdr_t, dh_specific));
> -	assert(! (STAPE_MAX_RECSZ % PGSZ));
> +	assert(!(STAPE_MAX_RECSZ % PGSZ));
>  
>  	/* hook up the drive ops
>  	 */
> @@ -510,7 +510,7 @@ ds_instantiate(int argc, char *argv[], drive_t *drivep)
>  	while ((c = getopt(argc, argv, GETOPT_CMDSTRING)) != EOF) {
>  		switch (c) {
>  		case GETOPT_RINGLEN:
> -			if (! optarg || optarg[0] == '-') {
> +			if (!optarg || optarg[0] == '-') {
>  				mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
>  				      _("-%c argument missing\n"),
>  				      c);
> @@ -549,7 +549,7 @@ ds_instantiate(int argc, char *argv[], drive_t *drivep)
>  	      			_("Overwrite command line option\n"));
>  			break;
>  		case GETOPT_FILESZ:
> -			if (! optarg || optarg [0] == '-') {
> +			if (!optarg || optarg [0] == '-') {
>  				mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
>  				      _("-%c argument missing\n"),
>  				      c);
> @@ -601,7 +601,7 @@ ds_instantiate(int argc, char *argv[], drive_t *drivep)
>  						  ring_write,
>  						  (void *)drivep,
>  						  &rval);
> -		if (! contextp->dc_ringp) {
> +		if (!contextp->dc_ringp) {
>  			if (rval == ENOMEM) {
>  				mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_DRIVE,
>  				      _("unable to allocate memory "
> @@ -727,7 +727,7 @@ do_begin_read(drive_t *drivep)
>  	 */
>  	assert(drivep->d_capabilities & DRIVE_CAP_READ);
>  	assert(contextp->dc_mode == OM_NONE);
> -	assert(! contextp->dc_recp);
> +	assert(!contextp->dc_recp);
>  
>  	/* get a record buffer to use during initialization.
>  	 */
> @@ -749,7 +749,7 @@ do_begin_read(drive_t *drivep)
>  		assert(contextp->dc_fd == -1);
>  		rval = prepare_drive(drivep);
>  		if (rval) {
> -			if (! contextp->dc_singlethreadedpr) {
> +			if (!contextp->dc_singlethreadedpr) {
>  			    Ring_reset(contextp->dc_ringp, contextp->dc_msgp);
>  			}
>  			contextp->dc_msgp = 0;
> @@ -759,7 +759,7 @@ do_begin_read(drive_t *drivep)
>  	} else {
>  		rval = read_label(drivep);
>  		if (rval) {
> -			if (! contextp->dc_singlethreadedpr) {
> +			if (!contextp->dc_singlethreadedpr) {
>  			    Ring_reset(contextp->dc_ringp, contextp->dc_msgp);
>  			}
>  			contextp->dc_msgp = 0;
> @@ -773,7 +773,7 @@ do_begin_read(drive_t *drivep)
>  	/* all is well. adjust context. don't kick off read-aheads just yet;
>  	 * the client may not want this media file.
>  	 */
> -	if (! contextp->dc_singlethreadedpr) {
> +	if (!contextp->dc_singlethreadedpr) {
>  		contextp->dc_msgp->rm_op = RING_OP_NOP;
>  		contextp->dc_msgp->rm_user = 0; /* do diff. use in do_seek */
>  		Ring_put(contextp->dc_ringp, contextp->dc_msgp);
> @@ -829,8 +829,8 @@ do_read(drive_t *drivep,
>  	/* assert protocol being followed
>  	 */
>  	assert(contextp->dc_mode == OM_READ);
> -	assert(! contextp->dc_errorpr);
> -	assert(! contextp->dc_ownedp);
> +	assert(!contextp->dc_errorpr);
> +	assert(!contextp->dc_ownedp);
>  	assert(wantedcnt > 0);
>  
>  	/* clear the return status field
> @@ -891,7 +891,7 @@ do_return_read_buf(drive_t *drivep, char *bufp, size_t retcnt)
>  	/* assert protocol being followed
>  	 */
>  	assert(contextp->dc_mode == OM_READ);
> -	assert(! contextp->dc_errorpr);
> +	assert(!contextp->dc_errorpr);
>  	assert(contextp->dc_ownedp);
>  	assert(bufp == contextp->dc_ownedp);
>  
> @@ -910,7 +910,7 @@ do_return_read_buf(drive_t *drivep, char *bufp, size_t retcnt)
>  	 */
>  	if (contextp->dc_nextp >= contextp->dc_dataendp) {
>  		assert(contextp->dc_nextp == contextp->dc_dataendp);
> -		if (! contextp->dc_singlethreadedpr) {
> +		if (!contextp->dc_singlethreadedpr) {
>  			contextp->dc_msgp->rm_op = RING_OP_READ;
>  			Ring_put(contextp->dc_ringp, contextp->dc_msgp);
>  			contextp->dc_msgp = 0;
> @@ -941,8 +941,8 @@ do_get_mark(drive_t *drivep, drive_mark_t *markp)
>  	/* assert protocol being followed
>  	 */
>  	assert(contextp->dc_mode == OM_READ);
> -	assert(! contextp->dc_errorpr);
> -	assert(! contextp->dc_ownedp);
> +	assert(!contextp->dc_errorpr);
> +	assert(!contextp->dc_ownedp);
>  
>  	/* the mark is simply the offset into the media file of the
>  	 * next byte to be read.
> @@ -982,8 +982,8 @@ do_seek_mark(drive_t *drivep, drive_mark_t *markp)
>  	/* assert protocol being followed
>  	 */
>  	assert(contextp->dc_mode == OM_READ);
> -	assert(! contextp->dc_errorpr);
> -	assert(! contextp->dc_ownedp);
> +	assert(!contextp->dc_errorpr);
> +	assert(!contextp->dc_ownedp);
>  
>  
>  	/* the desired mark is passed by reference, and is really just an
> @@ -1068,7 +1068,7 @@ do_seek_mark(drive_t *drivep, drive_mark_t *markp)
>  			currentoffset += (off64_t)actualcnt;
>  			assert(currentoffset == nextrecoffset);
>  			assert(wantedoffset >= currentoffset);
> -			assert(! contextp->dc_recp);
> +			assert(!contextp->dc_recp);
>  			assert(currentoffset
>  				==
>  				contextp->dc_reccnt * (off64_t)tape_recsz);
> @@ -1088,7 +1088,7 @@ do_seek_mark(drive_t *drivep, drive_mark_t *markp)
>  		off64_t wantedreccnt;
>  		seekmode_t seekmode;
>  
> -		assert(! contextp->dc_recp);
> +		assert(!contextp->dc_recp);
>  		wantedreccnt = wantedoffset / (off64_t)tape_recsz;
>  		if (contextp->dc_singlethreadedpr) {
>  			seekmode = SEEKMODE_RAW;
> @@ -1105,7 +1105,7 @@ do_seek_mark(drive_t *drivep, drive_mark_t *markp)
>  
>  			if (seekmode == SEEKMODE_BUF) {
>  				ring_stat_t rs;
> -				assert(! contextp->dc_msgp);
> +				assert(!contextp->dc_msgp);
>  				contextp->dc_msgp =
>  						Ring_get(contextp->dc_ringp);
>  				rs = contextp->dc_msgp->rm_stat;
> @@ -1194,7 +1194,7 @@ do_seek_mark(drive_t *drivep, drive_mark_t *markp)
>  		size_t actualcnt;
>  		int rval;
>  
> -		assert(! contextp->dc_recp);
> +		assert(!contextp->dc_recp);
>  
>  		/* figure how much to ask for. to eat an entire record,
>  		 * ask for a record sans the header. do_read will eat
> @@ -1211,7 +1211,7 @@ do_seek_mark(drive_t *drivep, drive_mark_t *markp)
>  		}
>  		assert(actualcnt == wantedcnt);
>  		do_return_read_buf(drivep, dummybufp, actualcnt);
> -		assert(! contextp->dc_recp);
> +		assert(!contextp->dc_recp);
>  		currentoffset += (off64_t)tape_recsz;
>  		assert(currentoffset
>  			==
> @@ -1315,8 +1315,8 @@ do_next_mark(drive_t *drivep)
>  	/* assert protocol being followed.
>  	 */
>  	assert(contextp->dc_mode == OM_READ);
> -	assert(! contextp->dc_errorpr);
> -	assert(! contextp->dc_ownedp);
> +	assert(!contextp->dc_errorpr);
> +	assert(!contextp->dc_ownedp);
>  
>  	mlog(MLOG_DEBUG | MLOG_DRIVE,
>  	      "rmt drive op: next mark\n");
> @@ -1354,7 +1354,7 @@ noerrorsearch:
>  			}
>  		}
>  
> -		if (! contextp->dc_singlethreadedpr) {
> +		if (!contextp->dc_singlethreadedpr) {
>  			Ring_put(contextp->dc_ringp,
>  				  contextp->dc_msgp);
>  			contextp->dc_msgp = 0;
> @@ -1374,7 +1374,7 @@ noerrorsearch:
>  	assert(contextp->dc_nextp <= contextp->dc_dataendp);
>  	assert(contextp->dc_nextp >= contextp->dc_recp + STAPE_HDR_SZ);
>  	if (contextp->dc_nextp == contextp->dc_dataendp) {
> -		if (! contextp->dc_singlethreadedpr) {
> +		if (!contextp->dc_singlethreadedpr) {
>  			Ring_put(contextp->dc_ringp,
>  				  contextp->dc_msgp);
>  			contextp->dc_msgp = 0;
> @@ -1386,7 +1386,7 @@ noerrorsearch:
>  	return 0;
>  
>  resetring:
> -	if (! contextp->dc_singlethreadedpr) {
> +	if (!contextp->dc_singlethreadedpr) {
>  		Ring_reset(contextp->dc_ringp, contextp->dc_msgp);
>  		contextp->dc_msgp = 0;
>  	}
> @@ -1464,7 +1464,7 @@ validatehdr:
>  		goto readrecord;
>  	}
>  
> -	assert(! (rechdrp->file_offset % (off64_t)tape_recsz));
> +	assert(!(rechdrp->file_offset % (off64_t)tape_recsz));
>  	markoff = rechdrp->first_mark_offset - rechdrp->file_offset;
>  	assert(markoff >= (off64_t)STAPE_HDR_SZ);
>  	assert(markoff < (off64_t)tape_recsz);
> @@ -1475,7 +1475,7 @@ validatehdr:
>  
>  alliswell:
>  	contextp->dc_nextp = contextp->dc_recp + (size_t)markoff;
> -	assert(! (rechdrp->file_offset % (off64_t)tape_recsz));
> +	assert(!(rechdrp->file_offset % (off64_t)tape_recsz));
>  	contextp->dc_reccnt = rechdrp->file_offset / (off64_t)tape_recsz;
>  	contextp->dc_iocnt = contextp->dc_reccnt + 1;
>  	contextp->dc_recendp = contextp->dc_recp + tape_recsz;
> @@ -1558,7 +1558,7 @@ do_end_read(drive_t *drivep)
>  	/* assert protocol being followed
>  	 */
>  	assert(contextp->dc_mode == OM_READ);
> -	assert(! contextp->dc_ownedp);
> +	assert(!contextp->dc_ownedp);
>  
>  	/* In the scsi version, read_label() does a status command to the
>  	 * drive to then decide if doing a 'fsf' is appropriate.  For minrmt,
> @@ -1567,7 +1567,7 @@ do_end_read(drive_t *drivep)
>  	 */
>  	(void)fsf_and_verify(drivep);
>  
> -	if (! contextp->dc_singlethreadedpr) {
> +	if (!contextp->dc_singlethreadedpr) {
>  		Ring_reset(contextp->dc_ringp, contextp->dc_msgp);
>  		contextp->dc_msgp = 0;
>  	}
> @@ -1613,8 +1613,8 @@ do_begin_write(drive_t *drivep)
>  	/* verify protocol being followed
>  	 */
>  	assert(contextp->dc_mode == OM_NONE);
> -	assert(! drivep->d_markrecheadp);
> -	assert(! contextp->dc_recp);
> +	assert(!drivep->d_markrecheadp);
> +	assert(!contextp->dc_recp);
>  
>  	/* get pointers into global write header
>  	 */
> @@ -1641,13 +1641,13 @@ do_begin_write(drive_t *drivep)
>  	/* get a record buffer. will be used for the media file header,
>  	 * and is needed to "prime the pump" for first call to do_write.
>  	 */
> -	assert(! contextp->dc_recp);
> +	assert(!contextp->dc_recp);
>  	if (contextp->dc_singlethreadedpr) {
>  		assert(contextp->dc_bufp);
>  		contextp->dc_recp = contextp->dc_bufp;
>  	} else {
>  		assert(contextp->dc_ringp);
> -		assert(! contextp->dc_msgp);
> +		assert(!contextp->dc_msgp);
>  		contextp->dc_msgp = Ring_get(contextp->dc_ringp);
>  		assert(contextp->dc_msgp->rm_stat == RING_STAT_INIT);
>  		contextp->dc_recp = contextp->dc_msgp->rm_bufp;
> @@ -1683,7 +1683,7 @@ do_begin_write(drive_t *drivep)
>  
>  	rval = write_record(drivep, contextp->dc_recp, BOOL_TRUE, BOOL_FALSE);
>  	if (rval) {
> -		if (! contextp->dc_singlethreadedpr) {
> +		if (!contextp->dc_singlethreadedpr) {
>  			Ring_reset(contextp->dc_ringp, contextp->dc_msgp);
>  			contextp->dc_msgp = 0;
>  		}
> @@ -1694,7 +1694,7 @@ do_begin_write(drive_t *drivep)
>  	/* prepare the drive context. must have a record buffer ready to
>  	 * go, header initialized.
>  	 */
> -	assert(! contextp->dc_ownedp);
> +	assert(!contextp->dc_ownedp);
>  	contextp->dc_reccnt = 1; /* count the header record */
>  	contextp->dc_recendp = contextp->dc_recp + tape_recsz;
>  	contextp->dc_nextp = contextp->dc_recp + STAPE_HDR_SZ;
> @@ -1740,8 +1740,8 @@ do_set_mark(drive_t *drivep,
>  	/* verify protocol being followed
>  	 */
>  	assert(contextp->dc_mode == OM_WRITE);
> -	assert(! contextp->dc_errorpr);
> -	assert(! contextp->dc_ownedp);
> +	assert(!contextp->dc_errorpr);
> +	assert(!contextp->dc_ownedp);
>  	assert(contextp->dc_recp);
>  	assert(contextp->dc_nextp);
>  
> @@ -1803,8 +1803,8 @@ do_get_write_buf(drive_t *drivep, size_t wantedcnt, size_t *actualcntp)
>  	/* verify protocol being followed
>  	 */
>  	assert(contextp->dc_mode == OM_WRITE);
> -	assert(! contextp->dc_errorpr);
> -	assert(! contextp->dc_ownedp);
> +	assert(!contextp->dc_errorpr);
> +	assert(!contextp->dc_ownedp);
>  	assert(contextp->dc_recp);
>  	assert(contextp->dc_nextp);
>  	assert(contextp->dc_nextp < contextp->dc_recendp);
> @@ -1869,7 +1869,7 @@ do_write(drive_t *drivep, char *bufp, size_t retcnt)
>  	/* verify protocol being followed
>  	 */
>  	assert(contextp->dc_mode == OM_WRITE);
> -	assert(! contextp->dc_errorpr);
> +	assert(!contextp->dc_errorpr);
>  	assert(contextp->dc_ownedp);
>  	assert(contextp->dc_recp);
>  	assert(contextp->dc_nextp);
> @@ -1970,7 +1970,7 @@ do_write(drive_t *drivep, char *bufp, size_t retcnt)
>   *	the number of bytes to next alignment
>   */
>  static size_t
> -do_get_align_cnt(drive_t * drivep)
> +do_get_align_cnt(drive_t *drivep)
>  {
>  	char *next_alignment_point;
>  	intptr_t next_alignment_off;
> @@ -1984,8 +1984,8 @@ do_get_align_cnt(drive_t * drivep)
>  	/* verify protocol being followed
>  	 */
>  	assert(contextp->dc_mode == OM_WRITE);
> -	assert(! contextp->dc_errorpr);
> -	assert(! contextp->dc_ownedp);
> +	assert(!contextp->dc_errorpr);
> +	assert(!contextp->dc_ownedp);
>  	assert(contextp->dc_recp);
>  	assert(contextp->dc_nextp);
>  	assert(contextp->dc_nextp < contextp->dc_recendp);
> @@ -2030,7 +2030,7 @@ do_end_write(drive_t *drivep, off64_t *ncommittedp)
>  	/* verify protocol being followed
>  	 */
>  	assert(contextp->dc_mode == OM_WRITE);
> -	assert(! contextp->dc_ownedp);
> +	assert(!contextp->dc_ownedp);
>  	assert(contextp->dc_recp);
>  	assert(contextp->dc_nextp);
>  	assert(contextp->dc_nextp >= contextp->dc_recp + STAPE_HDR_SZ);
> @@ -2045,7 +2045,7 @@ do_end_write(drive_t *drivep, off64_t *ncommittedp)
>  	 * do commits, already done when error occured.
>  	 */
>  	if (contextp->dc_errorpr) {
> -		if (! contextp->dc_singlethreadedpr) {
> +		if (!contextp->dc_singlethreadedpr) {
>  			Ring_reset(contextp->dc_ringp, contextp->dc_msgp);
>  			contextp->dc_msgp = 0;
>  		}
> @@ -2117,8 +2117,8 @@ do_end_write(drive_t *drivep, off64_t *ncommittedp)
>  	} else {
>  		first_rec_w_err = -1L;
>  	}
> -	if (! contextp->dc_singlethreadedpr) {
> -		while (! rval) {
> +	if (!contextp->dc_singlethreadedpr) {
> +		while (!rval) {
>  			assert(contextp->dc_msgp);
>  			contextp->dc_msgp->rm_op = RING_OP_TRACE;
>  			Ring_put(contextp->dc_ringp,
> @@ -2147,7 +2147,7 @@ do_end_write(drive_t *drivep, off64_t *ncommittedp)
>  
>  	/* the ring is now flushed. reset
>  	 */
> -	if (! contextp->dc_singlethreadedpr) {
> +	if (!contextp->dc_singlethreadedpr) {
>  		Ring_reset(contextp->dc_ringp, contextp->dc_msgp);
>  		contextp->dc_msgp = 0;
>  	}
> @@ -2157,7 +2157,7 @@ do_end_write(drive_t *drivep, off64_t *ncommittedp)
>  	 * side-effect of flushing the driver/drive of pending writes,
>  	 * exposing any write errors.
>  	 */
> -	if (! rval) {
> +	if (!rval) {
>  		int weofrval;
>  
>  		weofrval = mt_op(contextp->dc_fd, MTWEOF, 1);
> @@ -2637,13 +2637,13 @@ validate_media_file_hdr(drive_t *drivep)
>  
>  	/* check the checksum
>  	 */
> -	if (! global_hdr_checksum_check(tmpgh)) {
> +	if (!global_hdr_checksum_check(tmpgh)) {
>  	        mlog(MLOG_DEBUG | MLOG_DRIVE,
>  	              "bad media file header checksum\n");
>  	        return DRIVE_ERROR_CORRUPTION;
>  	}
>  
> -	if (! tape_rec_checksum_check(contextp, contextp->dc_recp)) {
> +	if (!tape_rec_checksum_check(contextp, contextp->dc_recp)) {
>  		mlog(MLOG_NORMAL | MLOG_DRIVE,
>  		      _("tape record checksum error\n"));
>  		return DRIVE_ERROR_CORRUPTION;
> @@ -2925,7 +2925,7 @@ tape_rec_checksum_set(drive_context_t *contextp, char *bufp)
>  	uint32_t *p;
>  	uint32_t accum;
>  
> -	if (! contextp->dc_recchksumpr) {
> +	if (!contextp->dc_recchksumpr) {
>  		return;
>  	}
>  
> @@ -3096,7 +3096,7 @@ prepare_drive(drive_t *drivep)
>  		/* open the drive
>  	 	 */
>  		ok = Open(drivep);
> -		if (! ok) {
> +		if (!ok) {
>  			if (errno != EBUSY) {
>  				display_access_failed_message(drivep);
>  				return DRIVE_ERROR_DEVICE;
> @@ -3121,7 +3121,7 @@ prepare_drive(drive_t *drivep)
>  	 * mark separation and media file size.
>  	 */
>  	ok = get_tpcaps(drivep);
> -	if (! ok) {
> +	if (!ok) {
>  		return DRIVE_ERROR_DEVICE;
>  	}
>  
> @@ -3223,7 +3223,7 @@ prepare_drive(drive_t *drivep)
>  			      "and try again\n");
>  			Close(drivep);
>  			ok = Open(drivep);
> -			if (! ok) {
> +			if (!ok) {
>  				display_access_failed_message(drivep);
>  				return DRIVE_ERROR_DEVICE;
>  			}
> @@ -3246,7 +3246,7 @@ prepare_drive(drive_t *drivep)
>  			      "and try again\n");
>  			Close(drivep);
>  			ok = Open(drivep);
> -			if (! ok) {
> +			if (!ok) {
>  				display_access_failed_message(drivep);
>  				return DRIVE_ERROR_DEVICE;
>  			}
> @@ -3335,7 +3335,7 @@ checkhdr:
>  				}
>  				(void)rewind_and_verify(drivep);
>  				ok = set_best_blk_and_rec_sz(drivep);
> -				if (! ok) {
> +				if (!ok) {
>  					return DRIVE_ERROR_DEVICE;
>  				}
>  				return DRIVE_ERROR_FOREIGN;
> @@ -3362,7 +3362,7 @@ largersize:
>  				      _("assuming media is corrupt "
>  				      "or contains non-xfsdump data\n"));
>  				ok = set_best_blk_and_rec_sz(drivep);
> -				if (! ok) {
> +				if (!ok) {
>  					return DRIVE_ERROR_DEVICE;
>  				}
>  				return DRIVE_ERROR_FOREIGN;
> @@ -3371,7 +3371,7 @@ largersize:
>                   */
>  		if (tape_recsz != STAPE_MAX_RECSZ) {
>  			tape_recsz = STAPE_MAX_RECSZ;
> -			if (! contextp->dc_isQICpr) {
> +			if (!contextp->dc_isQICpr) {
>  				tape_blksz = tape_recsz;;
>  			}
>  			changedblkszpr = BOOL_TRUE;
> @@ -3526,7 +3526,7 @@ record_hdr_validate(drive_t *drivep, char *bufp, bool_t chkoffpr)
>  	rec_hdr_t *rechdrp = &rechdr;
>  	rec_hdr_t *tmprh = (rec_hdr_t *)bufp;
>  
> -	if (! tape_rec_checksum_check(contextp, bufp)) {
> +	if (!tape_rec_checksum_check(contextp, bufp)) {
>  		mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
>  		      _("record %lld corrupt: bad record checksum\n"),
>  		      contextp->dc_iocnt - 1);
> @@ -3703,7 +3703,7 @@ getrec(drive_t *drivep)
>  	drive_context_t *contextp;
>  	contextp = (drive_context_t *)drivep->d_contextp;
>  
> -	while (! contextp->dc_recp) {
> +	while (!contextp->dc_recp) {
>  		rec_hdr_t *rechdrp;
>  		if (contextp->dc_singlethreadedpr) {
>  			int rval;
> @@ -3850,12 +3850,12 @@ display_ring_metrics(drive_t *drivep, int mlog_flags)
>  	char *bufszsfxp;
>  
>  	if (tape_recsz == STAPE_MIN_MAX_BLKSZ) {
> -		assert(! (STAPE_MIN_MAX_BLKSZ % 0x400));
> +		assert(!(STAPE_MIN_MAX_BLKSZ % 0x400));
>  		sprintf(bufszbuf, "%u", STAPE_MIN_MAX_BLKSZ / 0x400);
>  		assert(strlen(bufszbuf) < sizeof(bufszbuf));
>  		bufszsfxp = _("KB");
>  	} else if (tape_recsz == STAPE_MAX_RECSZ) {
> -		assert(! (STAPE_MAX_RECSZ % 0x100000));
> +		assert(!(STAPE_MAX_RECSZ % 0x100000));
>  		sprintf(bufszbuf, "%u", STAPE_MAX_RECSZ / 0x100000);
>  		assert(strlen(bufszbuf) < sizeof(bufszbuf));
>  		bufszsfxp = _("MB");
> diff --git a/common/drive_scsitape.c b/common/drive_scsitape.c
> index 7c54c11..ba26f60 100644
> --- a/common/drive_scsitape.c
> +++ b/common/drive_scsitape.c
> @@ -370,7 +370,7 @@ static double percent64(off64_t num, off64_t denom);
>  static int getrec(drive_t *drivep);
>  static int write_record(drive_t *drivep, char *bufp, bool_t chksumpr,
>                                bool_t xlatepr);
> -static ring_msg_t * Ring_get(ring_t *ringp);
> +static ring_msg_t *Ring_get(ring_t *ringp);
>  static void Ring_reset(ring_t *ringp, ring_msg_t *msgp);
>  static void Ring_put(ring_t *ringp, ring_msg_t *msgp);
>  static int validate_media_file_hdr(drive_t *drivep);
> @@ -518,7 +518,7 @@ ds_match(int argc, char *argv[], drive_t *drivep)
>  	/* heuristics to determine if this is a drive.
>  	 */
>  
> -	if (! strcmp(drivep->d_pathname, "stdio")) {
> +	if (!strcmp(drivep->d_pathname, "stdio")) {
>  		return -10;
>  	}
>  
> @@ -559,7 +559,7 @@ ds_instantiate(int argc, char *argv[], drive_t *drivep)
>  	assert(sizeof(rec_hdr_t)
>  		==
>  		sizeofmember(drive_hdr_t, dh_specific));
> -	assert(! (STAPE_MAX_RECSZ % PGSZ));
> +	assert(!(STAPE_MAX_RECSZ % PGSZ));
>  
>  	/* hook up the drive ops
>  	 */
> @@ -592,7 +592,7 @@ ds_instantiate(int argc, char *argv[], drive_t *drivep)
>  	while ((c = getopt(argc, argv, GETOPT_CMDSTRING)) != EOF) {
>  		switch (c) {
>  		case GETOPT_RINGLEN:
> -			if (! optarg || optarg[0] == '-') {
> +			if (!optarg || optarg[0] == '-') {
>  				mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
>  				      _("-%c argument missing\n"),
>  				      c);
> @@ -625,7 +625,7 @@ ds_instantiate(int argc, char *argv[], drive_t *drivep)
>  			contextp->dc_isQICpr = BOOL_TRUE;
>  			break;
>  		case GETOPT_BLOCKSIZE:
> -			if (! optarg || optarg[0] == '-') {
> +			if (!optarg || optarg[0] == '-') {
>  			    mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
>  				    _("-%c argument missing\n"),
>  				    c);
> @@ -638,7 +638,7 @@ ds_instantiate(int argc, char *argv[], drive_t *drivep)
>  			contextp->dc_overwritepr = BOOL_TRUE;
>  			break;
>  		case GETOPT_FILESZ:
> -			if (! optarg || optarg[0] == '-') {
> +			if (!optarg || optarg[0] == '-') {
>  				mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
>  				      _("-%c argument missing\n"),
>  				      c);
> @@ -691,7 +691,7 @@ ds_instantiate(int argc, char *argv[], drive_t *drivep)
>  						  ring_write,
>  						  (void *)drivep,
>  						  &rval);
> -		if (! contextp->dc_ringp) {
> +		if (!contextp->dc_ringp) {
>  			if (rval == ENOMEM) {
>  				mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_DRIVE,
>  				      _("unable to allocate memory "
> @@ -840,7 +840,7 @@ do_begin_read(drive_t *drivep)
>  	 */
>  	assert(drivep->d_capabilities & DRIVE_CAP_READ);
>  	assert(contextp->dc_mode == OM_NONE);
> -	assert(! contextp->dc_recp);
> +	assert(!contextp->dc_recp);
>  
>  	/* get a record buffer to use during initialization.
>  	 */
> @@ -862,7 +862,7 @@ do_begin_read(drive_t *drivep)
>  		assert(contextp->dc_fd == -1);
>  		rval = prepare_drive(drivep);
>  		if (rval) {
> -			if (! contextp->dc_singlethreadedpr) {
> +			if (!contextp->dc_singlethreadedpr) {
>  			    Ring_reset(contextp->dc_ringp, contextp->dc_msgp);
>  			}
>  			contextp->dc_msgp = 0;
> @@ -872,7 +872,7 @@ do_begin_read(drive_t *drivep)
>  	} else {
>  		rval = read_label(drivep);
>  		if (rval) {
> -			if (! contextp->dc_singlethreadedpr) {
> +			if (!contextp->dc_singlethreadedpr) {
>  			    Ring_reset(contextp->dc_ringp, contextp->dc_msgp);
>  			}
>  			contextp->dc_msgp = 0;
> @@ -886,7 +886,7 @@ do_begin_read(drive_t *drivep)
>  	/* all is well. adjust context. don't kick off read-aheads just yet;
>  	 * the client may not want this media file.
>  	 */
> -	if (! contextp->dc_singlethreadedpr) {
> +	if (!contextp->dc_singlethreadedpr) {
>  		contextp->dc_msgp->rm_op = RING_OP_NOP;
>  		contextp->dc_msgp->rm_user = 0; /* do diff. use in do_seek */
>  		Ring_put(contextp->dc_ringp, contextp->dc_msgp);
> @@ -942,8 +942,8 @@ do_read(drive_t *drivep,
>  	/* assert protocol being followed
>  	 */
>  	assert(contextp->dc_mode == OM_READ);
> -	assert(! contextp->dc_errorpr);
> -	assert(! contextp->dc_ownedp);
> +	assert(!contextp->dc_errorpr);
> +	assert(!contextp->dc_ownedp);
>  	assert(wantedcnt > 0);
>  
>  	/* clear the return status field
> @@ -1004,7 +1004,7 @@ do_return_read_buf(drive_t *drivep, char *bufp, size_t retcnt)
>  	/* assert protocol being followed
>  	 */
>  	assert(contextp->dc_mode == OM_READ);
> -	assert(! contextp->dc_errorpr);
> +	assert(!contextp->dc_errorpr);
>  	assert(contextp->dc_ownedp);
>  	assert(bufp == contextp->dc_ownedp);
>  
> @@ -1023,7 +1023,7 @@ do_return_read_buf(drive_t *drivep, char *bufp, size_t retcnt)
>  	 */
>  	if (contextp->dc_nextp >= contextp->dc_dataendp) {
>  		assert(contextp->dc_nextp == contextp->dc_dataendp);
> -		if (! contextp->dc_singlethreadedpr) {
> +		if (!contextp->dc_singlethreadedpr) {
>  			contextp->dc_msgp->rm_op = RING_OP_READ;
>  			Ring_put(contextp->dc_ringp, contextp->dc_msgp);
>  			contextp->dc_msgp = 0;
> @@ -1054,8 +1054,8 @@ do_get_mark(drive_t *drivep, drive_mark_t *markp)
>  	/* assert protocol being followed
>  	 */
>  	assert(contextp->dc_mode == OM_READ);
> -	assert(! contextp->dc_errorpr);
> -	assert(! contextp->dc_ownedp);
> +	assert(!contextp->dc_errorpr);
> +	assert(!contextp->dc_ownedp);
>  
>  	/* the mark is simply the offset into the media file of the
>  	 * next byte to be read.
> @@ -1095,8 +1095,8 @@ do_seek_mark(drive_t *drivep, drive_mark_t *markp)
>  	/* assert protocol being followed
>  	 */
>  	assert(contextp->dc_mode == OM_READ);
> -	assert(! contextp->dc_errorpr);
> -	assert(! contextp->dc_ownedp);
> +	assert(!contextp->dc_errorpr);
> +	assert(!contextp->dc_ownedp);
>  
>  
>  	/* the desired mark is passed by reference, and is really just an
> @@ -1181,7 +1181,7 @@ do_seek_mark(drive_t *drivep, drive_mark_t *markp)
>  			currentoffset += (off64_t)actualcnt;
>  			assert(currentoffset == nextrecoffset);
>  			assert(wantedoffset >= currentoffset);
> -			assert(! contextp->dc_recp);
> +			assert(!contextp->dc_recp);
>  			assert(currentoffset
>  				==
>  				contextp->dc_reccnt * (off64_t)tape_recsz);
> @@ -1201,7 +1201,7 @@ do_seek_mark(drive_t *drivep, drive_mark_t *markp)
>  		off64_t wantedreccnt;
>  		seekmode_t seekmode;
>  
> -		assert(! contextp->dc_recp);
> +		assert(!contextp->dc_recp);
>  		wantedreccnt = wantedoffset / (off64_t)tape_recsz;
>  		if (contextp->dc_singlethreadedpr) {
>  			seekmode = SEEKMODE_RAW;
> @@ -1218,7 +1218,7 @@ do_seek_mark(drive_t *drivep, drive_mark_t *markp)
>  
>  			if (seekmode == SEEKMODE_BUF) {
>  				ring_stat_t rs;
> -				assert(! contextp->dc_msgp);
> +				assert(!contextp->dc_msgp);
>  				contextp->dc_msgp =
>  						Ring_get(contextp->dc_ringp);
>  				rs = contextp->dc_msgp->rm_stat;
> @@ -1307,7 +1307,7 @@ do_seek_mark(drive_t *drivep, drive_mark_t *markp)
>  		size_t actualcnt;
>  		int rval;
>  
> -		assert(! contextp->dc_recp);
> +		assert(!contextp->dc_recp);
>  
>  		/* figure how much to ask for. to eat an entire record,
>  		 * ask for a record sans the header. do_read will eat
> @@ -1324,7 +1324,7 @@ do_seek_mark(drive_t *drivep, drive_mark_t *markp)
>  		}
>  		assert(actualcnt == wantedcnt);
>  		do_return_read_buf(drivep, dummybufp, actualcnt);
> -		assert(! contextp->dc_recp);
> +		assert(!contextp->dc_recp);
>  		currentoffset += (off64_t)tape_recsz;
>  		assert(currentoffset
>  			==
> @@ -1430,8 +1430,8 @@ do_next_mark(drive_t *drivep)
>  	/* assert protocol being followed.
>  	 */
>  	assert(contextp->dc_mode == OM_READ);
> -	assert(! contextp->dc_errorpr);
> -	assert(! contextp->dc_ownedp);
> +	assert(!contextp->dc_errorpr);
> +	assert(!contextp->dc_ownedp);
>  
>  	mlog(MLOG_DEBUG | MLOG_DRIVE,
>  	      "drive op: next mark\n");
> @@ -1469,7 +1469,7 @@ noerrorsearch:
>  			}
>  		}
>  
> -		if (! contextp->dc_singlethreadedpr) {
> +		if (!contextp->dc_singlethreadedpr) {
>  			Ring_put(contextp->dc_ringp,
>  				  contextp->dc_msgp);
>  			contextp->dc_msgp = 0;
> @@ -1489,7 +1489,7 @@ noerrorsearch:
>  	assert(contextp->dc_nextp <= contextp->dc_dataendp);
>  	assert(contextp->dc_nextp >= contextp->dc_recp + STAPE_HDR_SZ);
>  	if (contextp->dc_nextp == contextp->dc_dataendp) {
> -		if (! contextp->dc_singlethreadedpr) {
> +		if (!contextp->dc_singlethreadedpr) {
>  			Ring_put(contextp->dc_ringp,
>  				  contextp->dc_msgp);
>  			contextp->dc_msgp = 0;
> @@ -1501,7 +1501,7 @@ noerrorsearch:
>  	return 0;
>  
>  resetring:
> -	if (! contextp->dc_singlethreadedpr) {
> +	if (!contextp->dc_singlethreadedpr) {
>  		Ring_reset(contextp->dc_ringp, contextp->dc_msgp);
>  		contextp->dc_msgp = 0;
>  	}
> @@ -1535,7 +1535,7 @@ validateread:
>  		goto validatehdr;
>  	}
>  	ok = mt_get_status(drivep, &mtstat);
> -	if (! ok) {
> +	if (!ok) {
>  		status_failed_message(drivep);
>  		return DRIVE_ERROR_DEVICE;
>  	}
> @@ -1608,7 +1608,7 @@ validatehdr:
>  		goto readrecord;
>  	}
>  
> -	assert(! (rechdrp->file_offset % (off64_t)tape_recsz));
> +	assert(!(rechdrp->file_offset % (off64_t)tape_recsz));
>  	markoff = rechdrp->first_mark_offset - rechdrp->file_offset;
>  	assert(markoff >= (off64_t)STAPE_HDR_SZ);
>  	assert(markoff < (off64_t)tape_recsz);
> @@ -1619,7 +1619,7 @@ validatehdr:
>  
>  alliswell:
>  	contextp->dc_nextp = contextp->dc_recp + (size_t)markoff;
> -	assert(! (rechdrp->file_offset % (off64_t)tape_recsz));
> +	assert(!(rechdrp->file_offset % (off64_t)tape_recsz));
>  	contextp->dc_reccnt = rechdrp->file_offset / (off64_t)tape_recsz;
>  	contextp->dc_iocnt = contextp->dc_reccnt + 1;
>  	contextp->dc_recendp = contextp->dc_recp + tape_recsz;
> @@ -1701,9 +1701,9 @@ do_end_read(drive_t *drivep)
>  	/* assert protocol being followed
>  	 */
>  	assert(contextp->dc_mode == OM_READ);
> -	assert(! contextp->dc_ownedp);
> +	assert(!contextp->dc_ownedp);
>  
> -	if (! contextp->dc_singlethreadedpr) {
> +	if (!contextp->dc_singlethreadedpr) {
>  		Ring_reset(contextp->dc_ringp, contextp->dc_msgp);
>  		contextp->dc_msgp = 0;
>  	}
> @@ -1750,8 +1750,8 @@ do_begin_write(drive_t *drivep)
>  	/* verify protocol being followed
>  	 */
>  	assert(contextp->dc_mode == OM_NONE);
> -	assert(! drivep->d_markrecheadp);
> -	assert(! contextp->dc_recp);
> +	assert(!drivep->d_markrecheadp);
> +	assert(!contextp->dc_recp);
>  
>  	/* get pointers into global write header
>  	 */
> @@ -1766,7 +1766,7 @@ do_begin_write(drive_t *drivep)
>  
>  	/* get tape device status. verify tape is positioned
>   	 */
> -	if (! mt_get_status(drivep, &mtstat)) {
> +	if (!mt_get_status(drivep, &mtstat)) {
>  		status_failed_message(drivep);
>          	return DRIVE_ERROR_DEVICE;
>  	}
> @@ -1791,13 +1791,13 @@ do_begin_write(drive_t *drivep)
>  	/* get a record buffer. will be used for the media file header,
>  	 * and is needed to "prime the pump" for first call to do_write.
>  	 */
> -	assert(! contextp->dc_recp);
> +	assert(!contextp->dc_recp);
>  	if (contextp->dc_singlethreadedpr) {
>  		assert(contextp->dc_bufp);
>  		contextp->dc_recp = contextp->dc_bufp;
>  	} else {
>  		assert(contextp->dc_ringp);
> -		assert(! contextp->dc_msgp);
> +		assert(!contextp->dc_msgp);
>  		contextp->dc_msgp = Ring_get(contextp->dc_ringp);
>  		assert(contextp->dc_msgp->rm_stat == RING_STAT_INIT);
>  		contextp->dc_recp = contextp->dc_msgp->rm_bufp;
> @@ -1833,7 +1833,7 @@ do_begin_write(drive_t *drivep)
>  
>  	rval = write_record(drivep, contextp->dc_recp, BOOL_TRUE, BOOL_FALSE);
>  	if (rval) {
> -		if (! contextp->dc_singlethreadedpr) {
> +		if (!contextp->dc_singlethreadedpr) {
>  			Ring_reset(contextp->dc_ringp, contextp->dc_msgp);
>  			contextp->dc_msgp = 0;
>  		}
> @@ -1844,7 +1844,7 @@ do_begin_write(drive_t *drivep)
>  	/* prepare the drive context. must have a record buffer ready to
>  	 * go, header initialized.
>  	 */
> -	assert(! contextp->dc_ownedp);
> +	assert(!contextp->dc_ownedp);
>  	contextp->dc_reccnt = 1; /* count the header record */
>  	contextp->dc_recendp = contextp->dc_recp + tape_recsz;
>  	contextp->dc_nextp = contextp->dc_recp + STAPE_HDR_SZ;
> @@ -1890,8 +1890,8 @@ do_set_mark(drive_t *drivep,
>  	/* verify protocol being followed
>  	 */
>  	assert(contextp->dc_mode == OM_WRITE);
> -	assert(! contextp->dc_errorpr);
> -	assert(! contextp->dc_ownedp);
> +	assert(!contextp->dc_errorpr);
> +	assert(!contextp->dc_ownedp);
>  	assert(contextp->dc_recp);
>  	assert(contextp->dc_nextp);
>  
> @@ -1953,8 +1953,8 @@ do_get_write_buf(drive_t *drivep, size_t wantedcnt, size_t *actualcntp)
>  	/* verify protocol being followed
>  	 */
>  	assert(contextp->dc_mode == OM_WRITE);
> -	assert(! contextp->dc_errorpr);
> -	assert(! contextp->dc_ownedp);
> +	assert(!contextp->dc_errorpr);
> +	assert(!contextp->dc_ownedp);
>  	assert(contextp->dc_recp);
>  	assert(contextp->dc_nextp);
>  	assert(contextp->dc_nextp < contextp->dc_recendp);
> @@ -2019,7 +2019,7 @@ do_write(drive_t *drivep, char *bufp, size_t retcnt)
>  	/* verify protocol being followed
>  	 */
>  	assert(contextp->dc_mode == OM_WRITE);
> -	assert(! contextp->dc_errorpr);
> +	assert(!contextp->dc_errorpr);
>  	assert(contextp->dc_ownedp);
>  	assert(contextp->dc_recp);
>  	assert(contextp->dc_nextp);
> @@ -2120,7 +2120,7 @@ do_write(drive_t *drivep, char *bufp, size_t retcnt)
>   *	the number of bytes to next alignment
>   */
>  static size_t
> -do_get_align_cnt(drive_t * drivep)
> +do_get_align_cnt(drive_t *drivep)
>  {
>  	char *next_alignment_point;
>  	intptr_t next_alignment_off;
> @@ -2134,8 +2134,8 @@ do_get_align_cnt(drive_t * drivep)
>  	/* verify protocol being followed
>  	 */
>  	assert(contextp->dc_mode == OM_WRITE);
> -	assert(! contextp->dc_errorpr);
> -	assert(! contextp->dc_ownedp);
> +	assert(!contextp->dc_errorpr);
> +	assert(!contextp->dc_ownedp);
>  	assert(contextp->dc_recp);
>  	assert(contextp->dc_nextp);
>  	assert(contextp->dc_nextp < contextp->dc_recendp);
> @@ -2180,7 +2180,7 @@ do_end_write(drive_t *drivep, off64_t *ncommittedp)
>  	/* verify protocol being followed
>  	 */
>  	assert(contextp->dc_mode == OM_WRITE);
> -	assert(! contextp->dc_ownedp);
> +	assert(!contextp->dc_ownedp);
>  	assert(contextp->dc_recp);
>  	assert(contextp->dc_nextp);
>  	assert(contextp->dc_nextp >= contextp->dc_recp + STAPE_HDR_SZ);
> @@ -2195,7 +2195,7 @@ do_end_write(drive_t *drivep, off64_t *ncommittedp)
>  	 * do commits, already done when error occured.
>  	 */
>  	if (contextp->dc_errorpr) {
> -		if (! contextp->dc_singlethreadedpr) {
> +		if (!contextp->dc_singlethreadedpr) {
>  			Ring_reset(contextp->dc_ringp, contextp->dc_msgp);
>  			contextp->dc_msgp = 0;
>  		}
> @@ -2267,8 +2267,8 @@ do_end_write(drive_t *drivep, off64_t *ncommittedp)
>  	} else {
>  		first_rec_w_err = -1L;
>  	}
> -	if (! contextp->dc_singlethreadedpr) {
> -		while (! rval) {
> +	if (!contextp->dc_singlethreadedpr) {
> +		while (!rval) {
>  			assert(contextp->dc_msgp);
>  			contextp->dc_msgp->rm_op = RING_OP_TRACE;
>  			Ring_put(contextp->dc_ringp,
> @@ -2297,7 +2297,7 @@ do_end_write(drive_t *drivep, off64_t *ncommittedp)
>  
>  	/* the ring is now flushed. reset
>  	 */
> -	if (! contextp->dc_singlethreadedpr) {
> +	if (!contextp->dc_singlethreadedpr) {
>  		Ring_reset(contextp->dc_ringp, contextp->dc_msgp);
>  		contextp->dc_msgp = 0;
>  	}
> @@ -2307,15 +2307,15 @@ do_end_write(drive_t *drivep, off64_t *ncommittedp)
>  	 * side-effect of flushing the driver/drive of pending writes,
>  	 * exposing any write errors.
>  	 */
> -	if (! rval) {
> +	if (!rval) {
>  		int weofrval;
>  		mtstat_t mtstat;
>  		bool_t ok;
>  
>  		weofrval = mt_op(contextp->dc_fd, MTWEOF, 1);
> -		if (! weofrval) {
> +		if (!weofrval) {
>  			ok = mt_get_status(drivep, &mtstat);
> -			if (! ok) {
> +			if (!ok) {
>  				status_failed_message(drivep);
>  				mtstat = 0;
>  				rval = DRIVE_ERROR_DEVICE;
> @@ -2397,7 +2397,7 @@ do_fsf(drive_t *drivep, int count, int *statp)
>  
>  	/* get tape status
>    	 */
> -	if (! mt_get_status(drivep, &mtstat)) {
> +	if (!mt_get_status(drivep, &mtstat)) {
>  		status_failed_message(drivep);
>  		*statp = DRIVE_ERROR_DEVICE;
>  		return 0;
> @@ -2435,7 +2435,7 @@ do_fsf(drive_t *drivep, int count, int *statp)
>  				op_failed = 1;
>  			}
>  
> -			if (! mt_get_status(drivep, &mtstat)) {
> +			if (!mt_get_status(drivep, &mtstat)) {
>  				status_failed_message(drivep);
>  				*statp = DRIVE_ERROR_DEVICE;
>  				return i;
> @@ -2497,7 +2497,7 @@ do_bsf(drive_t *drivep, int count, int *statp)
>  
>  	/* get tape status
>  	 */
> -	if (! mt_get_status(drivep, &mtstat)) {
> +	if (!mt_get_status(drivep, &mtstat)) {
>  		status_failed_message(drivep);
>  		*statp = DRIVE_ERROR_DEVICE;
>  		return 0;
> @@ -2509,12 +2509,12 @@ do_bsf(drive_t *drivep, int count, int *statp)
>  		mlog(MLOG_DEBUG | MLOG_DRIVE,
>  		      "reopening drive while at BOT\n");
>  		Close(drivep);
> -		if (! Open(drivep)) {
> +		if (!Open(drivep)) {
>  			display_access_failed_message(drivep);
>  			*statp = DRIVE_ERROR_DEVICE;
>  			return 0;
>  		}
> -		if (! mt_get_status(drivep, &mtstat)) {
> +		if (!mt_get_status(drivep, &mtstat)) {
>  			status_failed_message(drivep);
>  			*statp = DRIVE_ERROR_DEVICE;
>  			return 0;
> @@ -2551,7 +2551,7 @@ do_bsf(drive_t *drivep, int count, int *statp)
>  	 * GMT_EOF to the right of the filemark !!
>  	 */
>  	if (TS_ISDRIVER) {
> -		if (! IS_FMK(mtstat)) {
> +		if (!IS_FMK(mtstat)) {
>  			*statp = DRIVE_ERROR_DEVICE;
>  			return 0;
>  		}
> @@ -2570,7 +2570,7 @@ do_bsf(drive_t *drivep, int count, int *statp)
>  			return skipped + 1;
>  		}
>  		if (TS_ISDRIVER) {
> -			if (! IS_FMK(mtstat)) {
> +			if (!IS_FMK(mtstat)) {
>  				*statp = DRIVE_ERROR_DEVICE;
>  				return 0;
>  			}
> @@ -2583,7 +2583,7 @@ do_bsf(drive_t *drivep, int count, int *statp)
>  	if(IS_EOT(mtstat)) {
>  		*statp = DRIVE_ERROR_EOM;
>  	}
> -	if (! IS_FMK(mtstat)) {
> +	if (!IS_FMK(mtstat)) {
>  		*statp = DRIVE_ERROR_DEVICE;
>  	}
>  
> @@ -2616,7 +2616,7 @@ do_rewind(drive_t *drivep)
>  	/* use validating tape rewind util func
>  	 */
>  	mtstat = rewind_and_verify(drivep);
> -	if (! IS_BOT(mtstat)) {
> +	if (!IS_BOT(mtstat)) {
>  		return DRIVE_ERROR_DEVICE;
>  	} else {
>  		return 0;
> @@ -2647,7 +2647,7 @@ do_erase(drive_t *drivep)
>  	/* use validating tape rewind util func
>  	 */
>  	mtstat = rewind_and_verify(drivep);
> -	if (! IS_BOT(mtstat)) {
> +	if (!IS_BOT(mtstat)) {
>  		return DRIVE_ERROR_DEVICE;
>  	}
>  
> @@ -2658,7 +2658,7 @@ do_erase(drive_t *drivep)
>  	/* rewind again
>  	 */
>  	mtstat = rewind_and_verify(drivep);
> -	if (! IS_BOT(mtstat)) {
> +	if (!IS_BOT(mtstat)) {
>  		return DRIVE_ERROR_DEVICE;
>  	}
>  
> @@ -2759,7 +2759,7 @@ do_quit(drive_t *drivep)
>  		ring_destroy(ringp);
>  	}
>  
> -	if (! contextp->dc_isvarpr
> +	if (!contextp->dc_isvarpr
>  	     &&
>  	     ! contextp->dc_isQICpr
>  	     &&
> @@ -2848,11 +2848,11 @@ read_label(drive_t *drivep)
>  	/* if not at BOT or a file mark, advance to right of next file mark
>  	 */
>  	ok = mt_get_status(drivep, &mtstat);
> -	if (! ok) {
> +	if (!ok) {
>  		status_failed_message(drivep);
>  		return DRIVE_ERROR_DEVICE;
>  	}
> -	if (! IS_BOT(mtstat) && ! IS_FMK(mtstat)) {
> +	if (!IS_BOT(mtstat) && !IS_FMK(mtstat)) {
>  		mtstat = fsf_and_verify(drivep);
>  	}
>  
> @@ -2881,7 +2881,7 @@ read_label(drive_t *drivep)
>  			return DRIVE_ERROR_MEDIA;
>  		}
>  		ok = mt_get_status(drivep, &mtstat);
> -		if (! ok) {
> +		if (!ok) {
>  			status_failed_message(drivep);
>  			return DRIVE_ERROR_DEVICE;
>  		}
> @@ -2890,7 +2890,7 @@ read_label(drive_t *drivep)
>  
>  	/* verify we are either at BOT or a file mark
>  	 */
> -	if (! IS_BOT(mtstat) && ! IS_FMK(mtstat)) {
> +	if (!IS_BOT(mtstat) && !IS_FMK(mtstat)) {
>  		mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
>  		      _("file mark missing from tape\n"));
>  #ifdef DUMP
> @@ -2919,7 +2919,7 @@ read_label(drive_t *drivep)
>  	if (nread != (int)tape_recsz) {
>  		assert(nread < (int)tape_recsz);
>  		ok = mt_get_status(drivep, &mtstat);
> -		if (! ok) {
> +		if (!ok) {
>  			status_failed_message(drivep);
>  			return DRIVE_ERROR_DEVICE;
>  		}
> @@ -3047,13 +3047,13 @@ validate_media_file_hdr(drive_t *drivep)
>  
>  	/* check the checksum
>  	 */
> -	if (! global_hdr_checksum_check(tmpgh)) {
> +	if (!global_hdr_checksum_check(tmpgh)) {
>  	        mlog(MLOG_DEBUG | MLOG_DRIVE,
>  	              "bad media file header checksum\n");
>  	        return DRIVE_ERROR_CORRUPTION;
>  	}
>  
> -	if (! tape_rec_checksum_check(contextp, contextp->dc_recp)) {
> +	if (!tape_rec_checksum_check(contextp, contextp->dc_recp)) {
>  		mlog(MLOG_DEBUG | MLOG_DRIVE,
>  		      "tape record checksum error\n");
>  		return DRIVE_ERROR_CORRUPTION;
> @@ -3158,7 +3158,7 @@ set_fixed_blksz(drive_t *drivep, size_t blksz)
>  		/* close and re-open
>  		 */
>  		Close(drivep);
> -		if (! Open(drivep)) {
> +		if (!Open(drivep)) {
>  			display_access_failed_message(drivep);
>  			return BOOL_FALSE;
>  		}
> @@ -3178,7 +3178,7 @@ set_fixed_blksz(drive_t *drivep, size_t blksz)
>  		/* see if we were successful (can't look if RMT, so assume
>  		 * it worked)
>  		 */
> -		if (! contextp->dc_isrmtpr) {
> +		if (!contextp->dc_isrmtpr) {
>                          bool_t ok;
>                          ok = mt_blkinfo(contextp->dc_fd, &mtinfo);
>                          if (! ok) {
> @@ -3237,7 +3237,7 @@ get_tpcaps(drive_t *drivep)
>  		struct mtblkinfo mtinfo;
>  		bool_t ok;
>  		ok = mt_blkinfo(contextp->dc_fd, &mtinfo);
> -		if (! ok) {
> +		if (!ok) {
>  			return BOOL_FALSE;
>  		}
>  
> @@ -3561,7 +3561,7 @@ determine_write_error(drive_t *drivep, int nwritten, int saved_errno)
>  
>  	/* get tape device status
>  	 */
> -	if (! mt_get_status(drivep, &mtstat)) {
> +	if (!mt_get_status(drivep, &mtstat)) {
>  		status_failed_message(drivep);
>  		ret = DRIVE_ERROR_DEVICE;
>  	} else if (IS_WPROT(mtstat) && (saved_errno == EROFS)) {
> @@ -3617,7 +3617,7 @@ tape_rec_checksum_set(drive_context_t *contextp, char *bufp)
>  	uint32_t *p;
>  	uint32_t accum;
>  
> -	if (! contextp->dc_recchksumpr) {
> +	if (!contextp->dc_recchksumpr) {
>  		return;
>  	}
>  
> @@ -3886,7 +3886,7 @@ retry:
>  		/* open the drive
>  	 	 */
>  		ok = Open(drivep);
> -		if (! ok) {
> +		if (!ok) {
>  			if (errno != EBUSY) {
>  				display_access_failed_message(drivep);
>  				return DRIVE_ERROR_DEVICE;
> @@ -3907,7 +3907,7 @@ retry:
>  		 */
>  		mtstat = 0;
>  		ok = mt_get_status(drivep, &mtstat);
> -		if (! ok) {
> +		if (!ok) {
>  			status_failed_message(drivep);
>  			return DRIVE_ERROR_DEVICE;
>  		}
> @@ -3977,7 +3977,7 @@ retry:
>  	 * mark separation and media file size.
>  	 */
>  	ok = get_tpcaps(drivep);
> -	if (! ok) {
> +	if (!ok) {
>  		return DRIVE_ERROR_DEVICE;
>  	}
>  
> @@ -3998,7 +3998,7 @@ retry:
>  			"Overwrite option specified. "
>  			"Trying best blocksize\n");
>  		ok = set_best_blk_and_rec_sz(drivep);
> -		if (! ok) {
> +		if (!ok) {
>  			return DRIVE_ERROR_DEVICE;
>  		}
>  		return DRIVE_ERROR_OVERWRITE;
> @@ -4017,7 +4017,7 @@ retry:
>  	 * we will use tape motion. back up two file marks, because
>  	 * typically we will be positioned after last file mark at EOD.
>  	 */
> -	if (! IS_BOT(mtstat) && IS_FMK(mtstat)) {
> +	if (!IS_BOT(mtstat) && IS_FMK(mtstat)) {
>  		mlog(MLOG_DEBUG | MLOG_DRIVE,
>  		      "tape positioned at file mark, "
>  		      "but do not know if before or after: "
> @@ -4077,13 +4077,13 @@ retry:
>  		/* if a fixed device, but not QIC, and possible to set the block
>  		 * size, do so.
>  		 */
> -		if (! contextp->dc_isvarpr
> +		if (!contextp->dc_isvarpr
>  		     &&
> -		     ! contextp->dc_isQICpr
> +		     !contextp->dc_isQICpr
>  		     &&
>  		     contextp->dc_cansetblkszpr) {
>  			ok = set_fixed_blksz(drivep, tape_blksz);
> -			if (! ok) {
> +			if (!ok) {
>  				return DRIVE_ERROR_DEVICE;
>  			}
>  		}
> @@ -4092,7 +4092,7 @@ retry:
>  		 */
>  		mtstat = 0;
>  		ok = mt_get_status(drivep, &mtstat);
> -		if (! ok) {
> +		if (!ok) {
>  			status_failed_message(drivep);
>  			return DRIVE_ERROR_DEVICE;
>  		}
> @@ -4103,7 +4103,7 @@ retry:
>  		 * so we must either bsf or rewind to eliminate the uncertainty.
>  		 * if BSF is not supported, must rewind.
>  		 */
> -		if (! IS_BOT(mtstat) && ! IS_FMK(mtstat)) {
> +		if (!IS_BOT(mtstat) && !IS_FMK(mtstat)) {
>  			mlog(MLOG_DEBUG | MLOG_DRIVE,
>  			      "tape position unknown: searching backward "
>  			      "for file mark or BOT\n");
> @@ -4113,7 +4113,7 @@ retry:
>  			}
>  			mtstat = 0;
>  			ok = mt_get_status(drivep, &mtstat);
> -			if (! ok) {
> +			if (!ok) {
>  				status_failed_message(drivep);
>  				return DRIVE_ERROR_DEVICE;
>  			}
> @@ -4121,7 +4121,7 @@ retry:
>  
>  		/* if we can't position the tape, call it a media error
>  		 */
> -		if (! IS_BOT(mtstat) && ! IS_FMK(mtstat)) {
> +		if (!IS_BOT(mtstat) && !IS_FMK(mtstat)) {
>  			mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
>  			      _("unable to backspace/rewind media\n"));
>  			return DRIVE_ERROR_MEDIA;
> @@ -4131,7 +4131,7 @@ retry:
>  			      "tape positioned at BOT: "
>  			      "doing redundant rewind\n");
>  			mtstat = rewind_and_verify(drivep);
> -			if (! IS_BOT(mtstat)) {
> +			if (!IS_BOT(mtstat)) {
>  				return DRIVE_ERROR_DEVICE;
>  			}
>  		}
> @@ -4198,7 +4198,7 @@ retry:
>  			      "indicates blank tape: returning\n");
>  			(void)rewind_and_verify(drivep);
>  			ok = set_best_blk_and_rec_sz(drivep);
> -			if (! ok) {
> +			if (!ok) {
>  				return DRIVE_ERROR_DEVICE;
>  			}
>  			return DRIVE_ERROR_BLANK;
> @@ -4216,7 +4216,7 @@ retry:
>  			      "indicates blank tape: returning\n");
>  			(void)rewind_and_verify(drivep);
>  			ok = set_best_blk_and_rec_sz(drivep);
> -			if (! ok) {
> +			if (!ok) {
>  				return DRIVE_ERROR_DEVICE;
>  			}
>  			return DRIVE_ERROR_BLANK;
> @@ -4226,7 +4226,7 @@ retry:
>  		 */
>  		if (saved_errno == ENOSPC
>  		     &&
> -		     ! wasatbotpr) {
> +		     !wasatbotpr) {
>  			mlog(MLOG_DEBUG | MLOG_DRIVE,
>  			      "errno ENOSPC while not at BOT "
>  			      "indicates EOD: retrying\n");
> @@ -4245,7 +4245,7 @@ retry:
>  			      "and try again\n");
>  			Close(drivep);
>  			ok = Open(drivep);
> -			if (! ok) {
> +			if (!ok) {
>  				display_access_failed_message(drivep);
>  				return DRIVE_ERROR_DEVICE;
>  			}
> @@ -4258,14 +4258,14 @@ retry:
>  		 */
>  		mtstat = 0;
>  		ok = mt_get_status(drivep, &mtstat);
> -		if (! ok) {
> +		if (!ok) {
>  			status_failed_message(drivep);
>  			return DRIVE_ERROR_DEVICE;
>  		}
>  
>  		if (nread == 0
>  		     &&
> -		     ! contextp->dc_isvarpr
> +		     !contextp->dc_isvarpr
>  		     &&
>  		     IS_EOD(mtstat)
>  		     &&
> @@ -4276,7 +4276,7 @@ retry:
>  			  "indicates blank tape: returning\n");
>  			(void)rewind_and_verify(drivep);
>  			ok = set_best_blk_and_rec_sz(drivep);
> -			if (! ok) {
> +			if (!ok) {
>  				return DRIVE_ERROR_DEVICE;
>  			}
>  			return DRIVE_ERROR_BLANK;
> @@ -4284,11 +4284,11 @@ retry:
>  
>  		if (nread == 0
>  		     &&
> -		     ! contextp->dc_isvarpr
> +		     !contextp->dc_isvarpr
>  		     &&
>  		     IS_EOD(mtstat)
>  		     &&
> -		     ! wasatbotpr) {
> +		     !wasatbotpr) {
>  			mlog(MLOG_DEBUG | MLOG_DRIVE,
>  			  "nread == 0 and EOD while not at BOT on "
>  			  "fixed blocksize drive "
> @@ -4302,11 +4302,11 @@ retry:
>  
>  		if (nread == 0
>  		     &&
> -		     ! contextp->dc_isvarpr
> +		     !contextp->dc_isvarpr
>  		     &&
>  		     IS_EOT(mtstat)
>  		     &&
> -		     ! wasatbotpr) {
> +		     !wasatbotpr) {
>  			mlog(MLOG_DEBUG | MLOG_DRIVE,
>  			  "nread == 0 and EOT while not at BOT on "
>  			  "fixed blocksize drive "
> @@ -4320,13 +4320,13 @@ retry:
>  
>  		if (nread == 0
>  		     &&
> -		     ! contextp->dc_isvarpr
> +		     !contextp->dc_isvarpr
>  		     &&
> -		     ! IS_EOD(mtstat)
> +		     !IS_EOD(mtstat)
>  		     &&
> -		     ! IS_FMK(mtstat)
> +		     !IS_FMK(mtstat)
>  		     &&
> -		     ! IS_EOT(mtstat)) {
> +		     !IS_EOT(mtstat)) {
>  			mlog(MLOG_DEBUG | MLOG_DRIVE,
>  			  "nread == 0 and not EOD, not EOT, "
>  			  "and not at a file mark on fixed blocksize drive "
> @@ -4347,7 +4347,7 @@ retry:
>  			      "indicates blank tape: returning\n");
>  			(void)rewind_and_verify(drivep);
>  			ok = set_best_blk_and_rec_sz(drivep);
> -			if (! ok) {
> +			if (!ok) {
>  				return DRIVE_ERROR_DEVICE;
>  			}
>  			return DRIVE_ERROR_BLANK;
> @@ -4359,7 +4359,7 @@ retry:
>  		     &&
>  		     IS_EOD(mtstat)
>  		     &&
> -		     ! wasatbotpr) {
> +		     !wasatbotpr) {
>  			mlog(MLOG_DEBUG | MLOG_DRIVE,
>  			  "nread == 0 and EOD while not at BOT on "
>  			  "variable blocksize drive "
> @@ -4377,7 +4377,7 @@ retry:
>  		     &&
>  		     IS_EOT(mtstat)
>  		     &&
> -		     ! wasatbotpr) {
> +		     !wasatbotpr) {
>  			mlog(MLOG_DEBUG | MLOG_DRIVE,
>  			  "nread == 0 and EOT while not at BOT on "
>  			  "variable blocksize drive "
> @@ -4402,7 +4402,7 @@ retry:
>  			      "indicates foreign tape: returning\n");
>  			(void)rewind_and_verify(drivep);
>  			ok = set_best_blk_and_rec_sz(drivep);
> -			if (! ok) {
> +			if (!ok) {
>  				return DRIVE_ERROR_DEVICE;
>  			}
>  			return DRIVE_ERROR_FOREIGN;
> @@ -4412,11 +4412,11 @@ retry:
>  		     &&
>  		     contextp->dc_isvarpr
>  		     &&
> -		     ! IS_EOD(mtstat)
> +		     !IS_EOD(mtstat)
>  		     &&
> -		     ! IS_FMK(mtstat)
> +		     !IS_FMK(mtstat)
>  		     &&
> -		     ! IS_EOT(mtstat)) {
> +		     !IS_EOT(mtstat)) {
>  			mlog(MLOG_DEBUG | MLOG_DRIVE,
>  			  "nread > 0 and not EOD, not EOT, "
>  			  "and not at a file mark on variable blocksize drive "
> @@ -4426,7 +4426,7 @@ retry:
>  
>  		if (nread < (int)tape_recsz
>  		     &&
> -		     ! contextp->dc_isvarpr) {
> +		     !contextp->dc_isvarpr) {
>  			mlog(MLOG_DEBUG | MLOG_DRIVE,
>  			  "nread less than selected record size on "
>  			  "fixed blocksize drive "
> @@ -4436,7 +4436,7 @@ retry:
>  
>  		if (nread == (int)tape_recsz
>  		     &&
> -		     ! contextp->dc_isvarpr) {
> +		     !contextp->dc_isvarpr) {
>  			mlog(MLOG_DEBUG | MLOG_DRIVE,
>  			  "nread == selected blocksize "
>  			  "on fixed blocksize drive "
> @@ -4518,7 +4518,7 @@ checkhdr:
>  				}
>  				(void)rewind_and_verify(drivep);
>  				ok = set_best_blk_and_rec_sz(drivep);
> -				if (! ok) {
> +				if (!ok) {
>  					return DRIVE_ERROR_DEVICE;
>  				}
>  				return DRIVE_ERROR_FOREIGN;
> @@ -4556,7 +4556,7 @@ newsize:
>  			mlog(MLOG_NORMAL | MLOG_DRIVE,
>  			      _("cannot determine tape block size "
>  			      "after two tries\n"));
> -			if (! wasatbotpr) {
> +			if (!wasatbotpr) {
>  				mlog(MLOG_NORMAL | MLOG_DRIVE,
>  				      _("will rewind and try again\n"));
>  				(void)rewind_and_verify(drivep);
> @@ -4568,7 +4568,7 @@ newsize:
>  				      "or contains non-xfsdump data\n"));
>  				(void)rewind_and_verify(drivep);
>  				ok = set_best_blk_and_rec_sz(drivep);
> -				if (! ok) {
> +				if (!ok) {
>  					return DRIVE_ERROR_DEVICE;
>  				}
>  				return DRIVE_ERROR_FOREIGN;
> @@ -4576,7 +4576,7 @@ newsize:
>  		}
>  		if (tape_recsz > STAPE_MIN_MAX_BLKSZ) {
>  			tape_recsz = STAPE_MIN_MAX_BLKSZ;
> -			if (! contextp->dc_isQICpr) {
> +			if (!contextp->dc_isQICpr) {
>  				tape_blksz = tape_recsz;;
>  			}
>  			changedblkszpr = BOOL_TRUE;
> @@ -4595,7 +4595,7 @@ largersize:
>  			mlog(MLOG_NORMAL | MLOG_DRIVE,
>  			      _("cannot determine tape block size "
>  			      "after two tries\n"));
> -			if (! wasatbotpr) {
> +			if (!wasatbotpr) {
>  				mlog(MLOG_NORMAL | MLOG_DRIVE,
>  				      _("will rewind and try again\n"));
>  				(void)rewind_and_verify(drivep);
> @@ -4607,7 +4607,7 @@ largersize:
>  				      "or contains non-xfsdump data\n"));
>  				(void)rewind_and_verify(drivep);
>  				ok = set_best_blk_and_rec_sz(drivep);
> -				if (! ok) {
> +				if (!ok) {
>  					return DRIVE_ERROR_DEVICE;
>  				}
>  				return DRIVE_ERROR_FOREIGN;
> @@ -4617,7 +4617,7 @@ largersize:
>                   */
>  		if (tape_recsz != STAPE_MAX_RECSZ) {
>  			tape_recsz = STAPE_MAX_RECSZ;
> -			if (! contextp->dc_isQICpr) {
> +			if (!contextp->dc_isQICpr) {
>  				tape_blksz = tape_recsz;;
>  			}
>  			changedblkszpr = BOOL_TRUE;
> @@ -4777,7 +4777,7 @@ quick_backup(drive_t *drivep, drive_context_t *contextp, ix_t skipcnt)
>  				return 0;
>  			}
>  			if (TS_ISDRIVER) {
> -				if (! IS_FMK(mtstat)) {
> +				if (!IS_FMK(mtstat)) {
>  					mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
>  					      _("unable to backspace tape: "
>  					      "assuming media error\n"));
> @@ -4805,7 +4805,7 @@ record_hdr_validate(drive_t *drivep, char *bufp, bool_t chkoffpr)
>  	rec_hdr_t *rechdrp = &rechdr;
>  	rec_hdr_t *tmprh = (rec_hdr_t *)bufp;
>  
> -	if (! tape_rec_checksum_check(contextp, bufp)) {
> +	if (!tape_rec_checksum_check(contextp, bufp)) {
>  		mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
>  		      _("record %lld corrupt: bad record checksum\n"),
>  		      contextp->dc_iocnt - 1);
> @@ -4904,7 +4904,7 @@ read_record(drive_t *drivep, char *bufp)
>  	/* get drive status
>  	 */
>  	ok = mt_get_status(drivep, &mtstat);
> -	if (! ok) {
> +	if (!ok) {
>  		status_failed_message(drivep);
>  		return DRIVE_ERROR_DEVICE;
>  	}
> @@ -4982,7 +4982,7 @@ getrec(drive_t *drivep)
>  	drive_context_t *contextp;
>  	contextp = (drive_context_t *)drivep->d_contextp;
>  
> -	while (! contextp->dc_recp) {
> +	while (!contextp->dc_recp) {
>  		rec_hdr_t *rechdrp;
>  		if (contextp->dc_singlethreadedpr) {
>  			int rval;
> @@ -5129,17 +5129,17 @@ display_ring_metrics(drive_t *drivep, int mlog_flags)
>  	char *bufszsfxp;
>  
>  	if (tape_recsz == STAPE_MIN_MAX_BLKSZ) {
> -		assert(! (STAPE_MIN_MAX_BLKSZ % 0x400));
> +		assert(!(STAPE_MIN_MAX_BLKSZ % 0x400));
>  		sprintf(bufszbuf, "%u", STAPE_MIN_MAX_BLKSZ / 0x400);
>  		assert(strlen(bufszbuf) < sizeof(bufszbuf));
>  		bufszsfxp = "KB";
>  	} else if (tape_recsz == STAPE_MAX_RECSZ) {
> -		assert(! (STAPE_MAX_RECSZ % 0x100000));
> +		assert(!(STAPE_MAX_RECSZ % 0x100000));
>  		sprintf(bufszbuf, "%u", STAPE_MAX_RECSZ / 0x100000);
>  		assert(strlen(bufszbuf) < sizeof(bufszbuf));
>  		bufszsfxp = "MB";
>  	} else if (tape_recsz == STAPE_MAX_LINUX_RECSZ) {
> -		assert(! (STAPE_MAX_LINUX_RECSZ % 0x100000));
> +		assert(!(STAPE_MAX_LINUX_RECSZ % 0x100000));
>  		sprintf(bufszbuf, "%u", STAPE_MAX_LINUX_RECSZ / 0x100000);
>  		assert(strlen(bufszbuf) < sizeof(bufszbuf));
>  		bufszsfxp = "MB";
> @@ -5184,7 +5184,7 @@ rewind_and_verify(drive_t *drivep)
>  			rval = mt_op(contextp->dc_fd, MTREW, 0);
>  		}
>  		ok = mt_get_status(drivep, &mtstat);
> -		if (! ok) {
> +		if (!ok) {
>  			mtstat = 0;
>  			status_failed_message(drivep);
>  			if (try > 1) {
> @@ -5214,7 +5214,7 @@ erase_and_verify(drive_t *drivep)
>  
>  	(void)mt_op(contextp->dc_fd, MTERASE, 0);
>  	ok = mt_get_status(drivep, &mtstat);
> -	if (! ok) {
> +	if (!ok) {
>  		mtstat = 0;
>  		status_failed_message(drivep);
>  	}
> @@ -5235,7 +5235,7 @@ bsf_and_verify(drive_t *drivep)
>  			mtstat_t mtstat;
>  
>  			ok = mt_get_status(drivep, &mtstat);
> -			if (! ok) {
> +			if (!ok) {
>  				mtstat = 0;
>  				status_failed_message(drivep);
>  				if (try > 1) {
> @@ -5265,7 +5265,7 @@ bsf_and_verify(drive_t *drivep)
>  		 * set correctly otherwise. [TS:Oct/2000]
>  		 */
>  		ok = mt_get_fileno(drivep, &fileno);
> -		if (! ok) {
> +		if (!ok) {
>  			status_failed_message(drivep);
>  			return 0;
>  		}
> @@ -5279,7 +5279,7 @@ bsf_and_verify(drive_t *drivep)
>  
>  		try = 1;
>  status:		ok = mt_get_status(drivep, &mtstat);
> -		if (! ok) {
> +		if (!ok) {
>  			mtstat = 0;
>  			status_failed_message(drivep);
>  			if (try > 1) {
> @@ -5306,7 +5306,7 @@ fsf_and_verify(drive_t *drivep)
>  		bool_t ok;
>  
>  		ok = mt_get_status(drivep, &mtstat);
> -		if (! ok) {
> +		if (!ok) {
>  			mtstat = 0;
>  			status_failed_message(drivep);
>  			if (try > 1) {
> @@ -5335,7 +5335,7 @@ calc_best_blk_and_rec_sz(drive_t *drivep)
>  {
>  	drive_context_t *contextp = (drive_context_t *)drivep->d_contextp;
>  
> -	if (! contextp->dc_isrmtpr) {
> +	if (!contextp->dc_isrmtpr) {
>  		if (cmdlineblksize > 0) {
>  		    tape_blksz = cmdlineblksize;
>                  } else {
> @@ -5361,14 +5361,14 @@ set_best_blk_and_rec_sz(drive_t *drivep)
>  
>          calc_best_blk_and_rec_sz(drivep);
>  
> -	if (! contextp->dc_isvarpr
> +	if (!contextp->dc_isvarpr
>  	     &&
>  	     ! contextp->dc_isQICpr
>  	     &&
>  	     contextp->dc_cansetblkszpr) {
>  		bool_t ok;
>  		ok = set_fixed_blksz(drivep, tape_blksz);
> -		if (! ok) {
> +		if (!ok) {
>  			return BOOL_FALSE;
>  		}
>  	}
> @@ -5460,4 +5460,3 @@ map_ts_status(struct mtget *mtstat, struct mtget_sgi mtstat_sgi)
>  	}
>  	return;
>  }
> -
> diff --git a/common/drive_simple.c b/common/drive_simple.c
> index fd1a958..5c3ed4b 100644
> --- a/common/drive_simple.c
> +++ b/common/drive_simple.c
> @@ -195,7 +195,7 @@ ds_match(int argc, char *argv[], drive_t *drivep)
>  
>  	/* sanity checks
>  	 */
> -	assert(! (sizeofmember(drive_context_t, dc_buf) % PGSZ));
> +	assert(!(sizeofmember(drive_context_t, dc_buf) % PGSZ));
>  
>  	/* determine if this is an rmt file. if so, give a weak match:
>  	 * might be an ordinary file accessed via the rmt protocol.
> @@ -212,7 +212,7 @@ ds_match(int argc, char *argv[], drive_t *drivep)
>  	/* willing to pick up anything not picked up by other strategies,
>  	 * as long as it exists and is not a directory
>  	 */
> -	if (! strcmp(drivep->d_pathname, "stdio")) {
> +	if (!strcmp(drivep->d_pathname, "stdio")) {
>  		return 1;
>  	}
>  
> @@ -260,7 +260,7 @@ ds_instantiate(int argc, char *argv[], drive_t *drivep)
>  	 */
>  	drivep->d_capabilities = 0;
>  	drivep->d_capabilities |= DRIVE_CAP_AUTOREWIND;
> -	if (! strcmp(drivep->d_pathname, "stdio")) {
> +	if (!strcmp(drivep->d_pathname, "stdio")) {
>  #ifdef DUMP
>  		contextp->dc_fd = 1;
>  #endif /* DUMP */
> @@ -514,7 +514,7 @@ do_begin_read(drive_t *drivep)
>  
>  	/* check the checksum
>  	 */
> -	if (! global_hdr_checksum_check(tmphdr)) {
> +	if (!global_hdr_checksum_check(tmphdr)) {
>  		mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_DRIVE,
>  		      _("media file header checksum error\n"));
>  		free(tmphdr);
> @@ -596,7 +596,7 @@ do_read(drive_t *drivep,
>  	/* assert protocol
>  	 */
>  	assert(contextp->dc_mode == OM_READ);
> -	assert(! contextp->dc_ownedp);
> +	assert(!contextp->dc_ownedp);
>  	assert(wantedcnt > 0);
>  
>  	/* pre-initialize reference return
> @@ -724,7 +724,7 @@ do_get_mark(drive_t *drivep, drive_mark_t *markp)
>  	/* assert protocol
>  	 */
>  	assert(contextp->dc_mode == OM_READ);
> -	assert(! contextp->dc_ownedp);
> +	assert(!contextp->dc_ownedp);
>  
>  	/* calculate the offset of the next byte to be supplied relative to
>  	 * the beginning of the buffer and relative to the beginning of
> @@ -757,7 +757,7 @@ do_seek_mark(drive_t *drivep, drive_mark_t *markp)
>  	/* assert protocol
>  	 */
>  	assert(contextp->dc_mode == OM_READ);
> -	assert(! contextp->dc_ownedp);
> +	assert(!contextp->dc_ownedp);
>  
>  	/* calculate the current offset within the media file
>  	 * of the next byte to be read
> @@ -820,9 +820,9 @@ do_next_mark(drive_t *drivep)
>  	 */
>  	assert(dcaps & DRIVE_CAP_NEXTMARK);
>  	assert(contextp->dc_mode == OM_READ);
> -	assert(! contextp->dc_ownedp);
> +	assert(!contextp->dc_ownedp);
>  
> -	if (! mark) {
> +	if (!mark) {
>  		return DRIVE_ERROR_EOF;
>  	}
>  
> @@ -964,7 +964,7 @@ do_begin_write(drive_t *drivep)
>  	     tmphdr->gh_hostname,
>  	     tmphdr->gh_dumplabel);
>  
> -	if (! global_hdr_checksum_check(tmphdr)) {
> +	if (!global_hdr_checksum_check(tmphdr)) {
>  		mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_DRIVE,
>  		      _("media file header checksum error\n"));
>  	}
> @@ -1008,7 +1008,7 @@ do_set_mark(drive_t *drivep,
>  	/* assert protocol
>  	 */
>  	assert(contextp->dc_mode == OM_WRITE);
> -	assert(! contextp->dc_ownedp);
> +	assert(!contextp->dc_ownedp);
>  	assert(contextp->dc_nextp);
>  
>  	/* calculate the mark offset
> @@ -1155,7 +1155,7 @@ do_set_mark(drive_t *drivep,
>  	 */
>  	if (contextp->dc_nextp == contextp->dc_buf) {
>  		assert(drivep->d_markrecheadp == 0);
> -		(* cbfuncp)(cbcontextp, markrecp, BOOL_TRUE);
> +		(*cbfuncp)(cbcontextp, markrecp, BOOL_TRUE);
>  		return;
>  	} else {
>  		markrecp->dm_cbfuncp = cbfuncp;
> @@ -1191,7 +1191,7 @@ do_get_write_buf(drive_t *drivep, size_t wanted_bufsz, size_t *actual_bufszp)
>  	/* assert protocol
>  	 */
>  	assert(contextp->dc_mode == OM_WRITE);
> -	assert(! contextp->dc_ownedp);
> +	assert(!contextp->dc_ownedp);
>  	assert(contextp->dc_nextp);
>  	assert(contextp->dc_nextp < contextp->dc_emptyp);
>  	assert(contextp->dc_ownedsz == 0);
> @@ -1250,7 +1250,7 @@ do_write(drive_t *drivep, char *bufp, size_t writesz)
>  	assert(contextp->dc_mode == OM_WRITE);
>  	assert(contextp->dc_ownedp);
>  	assert(bufp == contextp->dc_ownedp);
> -	assert(! contextp->dc_nextp);
> +	assert(!contextp->dc_nextp);
>  	assert(contextp->dc_ownedp < contextp->dc_emptyp);
>  	assert(writesz == contextp->dc_ownedsz);
>  
> @@ -1315,7 +1315,7 @@ do_get_align_cnt(drive_t *drivep)
>  	/* assert protocol
>  	 */
>  	assert(contextp->dc_mode == OM_WRITE);
> -	assert(! contextp->dc_ownedp);
> +	assert(!contextp->dc_ownedp);
>  	assert(contextp->dc_nextp);
>  	assert(contextp->dc_nextp < contextp->dc_emptyp);
>  
> @@ -1349,7 +1349,7 @@ do_end_write(drive_t *drivep, off64_t *ncommittedp)
>  	/* assert protocol
>  	 */
>  	assert(contextp->dc_mode == OM_WRITE);
> -	assert(! contextp->dc_ownedp);
> +	assert(!contextp->dc_ownedp);
>  	assert(contextp->dc_nextp);
>  	assert(contextp->dc_nextp < contextp->dc_emptyp);
>  
> diff --git a/common/fs.c b/common/fs.c
> index 5c2b266..a4c175c 100644
> --- a/common/fs.c
> +++ b/common/fs.c
> @@ -339,16 +339,16 @@ fs_tab_lookup_blk(char *blks)
>  		struct stat64 statb;
>  		bool_t bok;
>  
> -		if (! tep->fte_blks) {
> +		if (!tep->fte_blks) {
>  			continue;
>  		}
>  
> -		if (! strcmp(tep->fte_blks, blks)) {
> +		if (!strcmp(tep->fte_blks, blks)) {
>  			return tep;
>  		}
>  
> -		aok = ! stat64(blks, &stata);
> -		bok = ! stat64(tep->fte_blks, &statb);
> +		aok = !stat64(blks, &stata);
> +		bok = !stat64(tep->fte_blks, &statb);
>  		if (aok && bok && stata.st_rdev == statb.st_rdev) {
>  			return tep;
>  		}
> @@ -362,7 +362,7 @@ fs_tab_lookup_mnt(char *mnts)
>  	fs_tab_ent_t *tep;
>  
>  	for (tep = fs_tabp; tep; tep = tep->fte_nextp) {
> -		if (tep->fte_mnts && ! strcmp(tep->fte_mnts, mnts)) {
> +		if (tep->fte_mnts && !strcmp(tep->fte_mnts, mnts)) {
>  			return tep;
>  		}
>  	}
> diff --git a/common/global.c b/common/global.c
> index 881042b..6a4e348 100644
> --- a/common/global.c
> +++ b/common/global.c
> @@ -114,7 +114,7 @@ global_hdr_alloc(int argc, char *argv[])
>  		      strerror(errno));
>  		return 0;
>  	}
> -	if (! strlen(ghdrp->gh_hostname)) {
> +	if (!strlen(ghdrp->gh_hostname)) {
>  		mlog(MLOG_NORMAL | MLOG_ERROR,
>  		      _("hostname length is zero\n"));
>  		return 0;
> @@ -164,7 +164,7 @@ global_hdr_alloc(int argc, char *argv[])
>                                  return 0;
>                          }
>  
> -			if (! uuid_parse(optarg, ghdrp->gh_dumpid)) {
> +			if (!uuid_parse(optarg, ghdrp->gh_dumpid)) {
>  				mlog(MLOG_NORMAL | MLOG_ERROR,
>  				      _("-%c argument not a valid uuid\n"),
>  				      c);
> @@ -208,14 +208,14 @@ global_hdr_alloc(int argc, char *argv[])
>  	/* if no dump label specified, no pipes in use, and dialogs
>  	 * are allowed, prompt for one
>  	 */
> -	if (! dumplabel && dlog_allowed()) {
> +	if (!dumplabel && dlog_allowed()) {
>  		dumplabel = prompt_label(labelbuf, sizeof(labelbuf));
>  	}
>  #endif /* DUMP */
>  
> -	if (! dumplabel || ! strlen(dumplabel)) {
> +	if (!dumplabel || !strlen(dumplabel)) {
>  #ifdef DUMP
> -		if (! pipeline) {
> +		if (!pipeline) {
>  			mlog(MLOG_VERBOSE | MLOG_WARNING,
>  			      _("no session label specified\n"));
>  		}
> @@ -308,7 +308,7 @@ prompt_label_cb(void *uctxp, dlog_pcbp_t pcb, void *pctxp)
>  {
>  	/* query: ask for a dump label
>  	 */
> -	(* pcb)(pctxp,
> +	(*pcb)(pctxp,
>  		   _("please enter label for this dump session"));
>  }
>  
> diff --git a/common/inventory.c b/common/inventory.c
> index 9ebe461..6ffe9fe 100644
> --- a/common/inventory.c
> +++ b/common/inventory.c
> @@ -241,7 +241,7 @@ inv_writesession_open(
>  	assert (tok != INV_TOKEN_NULL);
>  	assert (sesid && fsid && mntpt && devpath);
>  
> -	if (! (tok->d_update_flag & FSTAB_UPDATED)) {
> +	if (!(tok->d_update_flag & FSTAB_UPDATED)) {
>  		if (put_fstab_entry(fsid, mntpt, devpath) < 0) {
>  			printf ("put_fstab_entry :(\n");
>  			return INV_TOKEN_NULL;
> diff --git a/common/main.c b/common/main.c
> index e212b6a..ef5f394 100644
> --- a/common/main.c
> +++ b/common/main.c
> @@ -201,14 +201,14 @@ main(int argc, char *argv[])
>  	 * if found, create a new argv.
>  	 */
>  	ok = loadoptfile(&argc, &argv);
> -	if (! ok) {
> +	if (!ok) {
>  		return mlog_exit(EXIT_ERROR, RV_OPT);
>  	}
>  
>  	/* initialize message logging (stage 1)
>  	 */
>  	ok = mlog_init1(argc, argv);
> -	if (! ok) {
> +	if (!ok) {
>  		return mlog_exit(EXIT_ERROR, RV_INIT);
>  	}
>  	/* scan the command line for the info, progress
> @@ -223,7 +223,7 @@ main(int argc, char *argv[])
>  	while ((c = getopt(argc, argv, GETOPT_CMDSTRING)) != EOF) {
>  		switch (c) {
>                  case GETOPT_MINSTACKSZ:
> -			if (! optarg || optarg[0] == '-') {
> +			if (!optarg || optarg[0] == '-') {
>  				mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_NOLOCK,
>  				      _("-%c argument missing\n"),
>  				      c);
> @@ -245,7 +245,7 @@ main(int argc, char *argv[])
>  			minstacksz = tmpstacksz;
>  			break;
>                  case GETOPT_MAXSTACKSZ:
> -			if (! optarg || optarg[0] == '-') {
> +			if (!optarg || optarg[0] == '-') {
>  				mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_NOLOCK,
>  				      _("-%c argument missing\n"),
>  				      c);
> @@ -271,7 +271,7 @@ main(int argc, char *argv[])
>  			mlog_exit_hint(RV_USAGE);
>  			break;
>  		case GETOPT_PROGRESS:
> -			if (! optarg || optarg[0] == '-') {
> +			if (!optarg || optarg[0] == '-') {
>  				mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_NOLOCK,
>  				      _("-%c argument missing\n"),
>  				      c);
> @@ -333,14 +333,14 @@ main(int argc, char *argv[])
>  	 */
>  	ok = set_rlimits(&vmsz);
>  #endif /* RESTORE */
> -	if (! ok) {
> +	if (!ok) {
>  		return mlog_exit(EXIT_ERROR, RV_INIT);
>  	}
>  
>  	/* initialize message logging (stage 2) - allocate the message lock
>  	 */
>  	ok = mlog_init2();
> -	if (! ok) {
> +	if (!ok) {
>  		return mlog_exit(EXIT_ERROR, RV_INIT);
>  	}
>  
> @@ -385,7 +385,7 @@ main(int argc, char *argv[])
>  	 * core, if necessary. some tmp files may be placed here as well.
>  	 */
>  	homedir = getcwd(0, MAXPATHLEN);
> -	if (! homedir) {
> +	if (!homedir) {
>  		mlog(MLOG_NORMAL | MLOG_ERROR,
>  		      _("unable to determine current directory: %s\n"),
>  		      strerror(errno));
> @@ -395,7 +395,7 @@ main(int argc, char *argv[])
>  	/* sanity check the inventory database directory, setup global paths
>  	 */
>  	ok = inv_setup_base();
> -	if (! ok) {
> +	if (!ok) {
>  		mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_NOLOCK,
>  		      _("both /var/lib/xfsdump and /var/xfsdump exist - fatal\n"));
>  		return mlog_exit(EXIT_ERROR, RV_INIT);
> @@ -413,7 +413,7 @@ main(int argc, char *argv[])
>  
>  	/* if an inventory display is requested, do it and exit
>  	 */
> -	if (! inv_DEBUG_print(argc, argv)) {
> +	if (!inv_DEBUG_print(argc, argv)) {
>  		return mlog_exit(EXIT_NORMAL, RV_OK); /* normal termination */
>  	}
>  
> @@ -436,14 +436,14 @@ main(int argc, char *argv[])
>  	/* initialize operator dialog capability
>  	 */
>  	ok = dlog_init(argc, argv);
> -	if (! ok) {
> +	if (!ok) {
>  		return mlog_exit(EXIT_ERROR, RV_INIT);
>  	}
>  
>  	/* initialize the child process manager
>  	 */
>  	ok = cldmgr_init();
> -	if (! ok) {
> +	if (!ok) {
>  		return mlog_exit(EXIT_ERROR, RV_INIT);
>  	}
>  
> @@ -453,7 +453,7 @@ main(int argc, char *argv[])
>  	 * will be done shortly.
>  	 */
>  	ok = drive_init1(argc, argv);
> -	if (! ok) {
> +	if (!ok) {
>  		return mlog_exit(EXIT_ERROR, RV_INIT);
>  	}
>  
> @@ -480,7 +480,7 @@ main(int argc, char *argv[])
>  	mlog(MLOG_VERBOSE,
>  	      _("version %s (dump format %d.0)"),
>  	      VERSION, GLOBAL_HDR_VERSION);
> -	if (! pipeline && ! stdoutpiped && sistr && dlog_allowed()) {
> +	if (!pipeline && !stdoutpiped && sistr && dlog_allowed()) {
>  		mlog(MLOG_VERBOSE | MLOG_BARE, _(
>  		      " - "
>  		      "type %s for status and control\n"),
> @@ -494,7 +494,7 @@ main(int argc, char *argv[])
>  	/* build a global write header template
>  	 */
>  	gwhdrtemplatep = global_hdr_alloc(argc, argv);
> -	if (! gwhdrtemplatep) {
> +	if (!gwhdrtemplatep) {
>  		return mlog_exit(EXIT_ERROR, RV_INIT);
>  	}
>  #endif /* DUMP */
> @@ -526,7 +526,7 @@ main(int argc, char *argv[])
>  	sa.sa_handler = SIG_IGN;
>  	sigaction(SIGPIPE, &sa, NULL);
>  
> -	if (! pipeline) {
> +	if (!pipeline) {
>  		sigset_t blocked_set;
>  
>  		stop_in_progress = BOOL_FALSE;
> @@ -565,7 +565,7 @@ main(int argc, char *argv[])
>  #ifdef RESTORE
>  	ok = content_init(argc, argv, vmsz / VMSZ_PER);
>  #endif /* RESTORE */
> -	if (! ok) {
> +	if (!ok) {
>  		err = mlog_exit(EXIT_ERROR, RV_INIT);
>  		goto err_free;
>  	}
> @@ -591,12 +591,12 @@ main(int argc, char *argv[])
>  				  argv,
>  				  (global_hdr_t *)0);
>  #endif /* RESTORE */
> -		if (! ok) {
> +		if (!ok) {
>  			err = mlog_exit(EXIT_ERROR, RV_INIT);
>  			goto err_free;
>  		}
>  		ok = drive_init3();
> -		if (! ok) {
> +		if (!ok) {
>  			err = mlog_exit(EXIT_ERROR, RV_INIT);
>  			goto err_free;
>  		}
> @@ -630,7 +630,7 @@ main(int argc, char *argv[])
>  	 * asynchronously read the media file header, typically a very
>  	 * time-consuming chore. drive_init3 will synchronize with each slave.
>  	 */
> -	if (! init_error) {
> +	if (!init_error) {
>  #ifdef DUMP
>  		ok = drive_init2(argc,
>  				  argv,
> @@ -641,13 +641,13 @@ main(int argc, char *argv[])
>  				  argv,
>  				  (global_hdr_t *)0);
>  #endif /* RESTORE */
> -		if (! ok) {
> +		if (!ok) {
>  			init_error = BOOL_TRUE;
>  		}
>  	}
> -	if (! init_error) {
> +	if (!init_error) {
>  		ok = drive_init3();
> -		if (! ok) {
> +		if (!ok) {
>  			init_error = BOOL_TRUE;
>  		}
>  	}
> @@ -655,13 +655,13 @@ main(int argc, char *argv[])
>  	/* create a child thread for each stream. drivecnt global from
>  	 * drive.h, initialized by drive_init[12]
>  	 */
> -	if (! init_error) {
> +	if (!init_error) {
>  		for (stix = 0; stix < drivecnt; stix++) {
>  			ok = cldmgr_create(childmain,
>  					    stix,
>  					    "child",
>  					    (void *)stix);
> -			if (! ok) {
> +			if (!ok) {
>  				init_error = BOOL_TRUE;
>  			}
>  		}
> @@ -800,7 +800,7 @@ main(int argc, char *argv[])
>  
>  		/* see if need to initiate a stop
>  		 */
> -		if (stop_requested && ! stop_in_progress) {
> +		if (stop_requested && !stop_in_progress) {
>  			mlog(MLOG_NORMAL,
>  			      _("initiating session interrupt (timeout in %d sec)\n"),
>  			      stop_timeout);
> @@ -828,7 +828,7 @@ main(int argc, char *argv[])
>  			}
>  		}
>  
> -		if (progrpt_enabledpr && ! stop_in_progress) {
> +		if (progrpt_enabledpr && !stop_in_progress) {
>  			bool_t need_progrptpr = BOOL_FALSE;
>  			while (now >= progrpt_deadline) {
>  				need_progrptpr = BOOL_TRUE;
> @@ -1153,7 +1153,7 @@ loadoptfile(int *argcp, char ***argvp)
>  	while ((c = getopt(*argcp, *argvp, GETOPT_CMDSTRING)) != EOF) {
>  		switch (c) {
>  		case GETOPT_OPTFILE:
> -			if (! optarg || optarg[0] == '-') {
> +			if (!optarg || optarg[0] == '-') {
>  				mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_NOLOCK,
>  				      _("-%c argument missing\n"),
>  				      c);
> @@ -1173,7 +1173,7 @@ loadoptfile(int *argcp, char ***argvp)
>  			break;
>  		}
>  	}
> -	if (! optfilename)  {
> +	if (!optfilename)  {
>  		return BOOL_TRUE;
>  	}
>  
> @@ -1222,7 +1222,7 @@ loadoptfile(int *argcp, char ***argvp)
>  			i++; /* to skip option argument */
>  			continue;
>  		}
> -		sz += strlen((* argvp)[i]) + 1;
> +		sz += strlen((*argvp)[i]) + 1;
>  	}
>  
>  	/* add in the size of the option file (plus one byte in case
> @@ -1240,7 +1240,7 @@ loadoptfile(int *argcp, char ***argvp)
>  	p = argbuf;
>  	i = 0;
>  	sprintf(p, "%s ", ( * argvp)[ i]);
> -	p += strlen((* argvp)[i]) + 1;
> +	p += strlen((*argvp)[i]) + 1;
>  	i++;
>  
>  	/* copy the options file into the buffer after the given args
> @@ -1267,7 +1267,7 @@ loadoptfile(int *argcp, char ***argvp)
>  			continue;
>  		}
>  		sprintf(p, "%s ", ( * argvp)[ i]);
> -		p += strlen((* argvp)[i]) + 1;
> +		p += strlen((*argvp)[i]) + 1;
>  	}
>  
>  	/* null-terminate the entire buffer
> @@ -1296,7 +1296,7 @@ loadoptfile(int *argcp, char ***argvp)
>  
>  		/* done when NULL encountered
>  		 */
> -		if (! *p) {
> +		if (!*p) {
>  			break;
>  		}
>  
> @@ -1310,14 +1310,14 @@ loadoptfile(int *argcp, char ***argvp)
>  
>  		/* if no more separators, all tokens seen
>  		 */
> -		if (! p) {
> +		if (!p) {
>  			break;
>  		}
>  	}
>  
>  	/* if no arguments, can return now
>  	 */
> -	if (! tokencnt) {
> +	if (!tokencnt) {
>  		close(fd);
>  		return BOOL_TRUE;
>  	}
> @@ -1342,7 +1342,7 @@ loadoptfile(int *argcp, char ***argvp)
>  
>  		/* done when NULL encountered
>  		 */
> -		if (! *p) {
> +		if (!*p) {
>  			break;
>  		}
>  
> @@ -1370,7 +1370,7 @@ loadoptfile(int *argcp, char ***argvp)
>  
>  		/* if no more separators, all tokens seen
>  		 */
> -		if (! endp) {
> +		if (!endp) {
>  			break;
>  		}
>  
> @@ -1468,7 +1468,7 @@ childmain(void *arg1)
>  	/* let the drive manager shut down its slave thread
>  	 */
>  	drivep = drivepp[stix];
> -	(* drivep->d_opsp->do_quit)(drivep);
> +	(*drivep->d_opsp->do_quit)(drivep);
>  
>  	return exitcode;
>  }
> @@ -1480,7 +1480,7 @@ prompt_prog_cb(void *uctxp, dlog_pcbp_t pcb, void *pctxp)
>  {
>  	/* query: ask for a dump label
>  	 */
> -	(* pcb)(pctxp,
> +	(*pcb)(pctxp,
>  		   progrpt_enabledpr
>  		   ?
>  		   _("please enter seconds between progress reports, "
> @@ -1565,7 +1565,7 @@ sigint_dialog(void)
>  				 "the following operations\n");
>  	assert(querycnt <= QUERYMAX);
>  	choicecnt = 0;
> -	if (! stop_in_progress) {
> +	if (!stop_in_progress) {
>  		interruptix = choicecnt;
>  		choicestr[choicecnt++ ] = _("interrupt this session");
>  	} else {
> @@ -1906,7 +1906,7 @@ sigint_dialog(void)
>  			if (responseix == okix) {
>  				int newinterval;
>  				newinterval = atoi(buf);
> -				if (! strlen(buf)) {
> +				if (!strlen(buf)) {
>  					ackstr[ackcnt++ ] = _("no change\n");
>  				} else if (newinterval > 0) {
>  					time32_t newdeadline;
> @@ -1953,21 +1953,21 @@ sigint_dialog(void)
>  				ackstr[ackcnt++ ] = _("no change\n");
>  			}
>  		} else if (responseix == mllevix) {
> -			mlog_showlevel = ! mlog_showlevel;
> +			mlog_showlevel = !mlog_showlevel;
>  			if (mlog_showlevel) {
>  				ackstr[ackcnt++ ] = _("showing log message levels\n");
>  			} else {
>  				ackstr[ackcnt++ ] = _("hiding log message levels\n");
>  			}
>  		} else if (responseix == mlssix) {
> -			mlog_showss = ! mlog_showss;
> +			mlog_showss = !mlog_showss;
>  			if (mlog_showss) {
>  				ackstr[ackcnt++ ] = _("showing log message subsystems\n");
>  			} else {
>  				ackstr[ackcnt++ ] = _("hiding log message subsystems\n");
>  			}
>  		} else if (responseix == mltsix) {
> -			mlog_timestamp = ! mlog_timestamp;
> +			mlog_timestamp = !mlog_timestamp;
>  			if (mlog_timestamp) {
>  				ackstr[ackcnt++ ] = _("showing log message timestamps\n");
>  			} else {
> @@ -2056,7 +2056,7 @@ set_rlimits(size64_t *vmszp)
>  
>  	rval = getrlimit64(RLIMIT_AS, &rlimit64);
>  
> -	assert(! rval);
> +	assert(!rval);
>  	mlog(MLOG_NITTY | MLOG_NOLOCK | MLOG_PROC,
>  	      "RLIMIT_AS org cur 0x%llx max 0x%llx\n",
>  	      rlimit64.rlim_cur,
> @@ -2066,7 +2066,7 @@ set_rlimits(size64_t *vmszp)
>  		rlimit64.rlim_cur = rlimit64.rlim_max;
>  		(void)setrlimit64(RLIMIT_AS, &rlimit64);
>  		rval = getrlimit64(RLIMIT_AS, &rlimit64);
> -		assert(! rval);
> +		assert(!rval);
>  		mlog(MLOG_NITTY | MLOG_NOLOCK | MLOG_PROC,
>  			"RLIMIT_VMEM now cur 0x%llx max 0x%llx\n",
>  			rlimit64.rlim_cur,
> @@ -2078,7 +2078,7 @@ set_rlimits(size64_t *vmszp)
>  
>  	assert(minstacksz <= maxstacksz);
>  	rval = getrlimit64(RLIMIT_STACK, &rlimit64);
> -	assert(! rval);
> +	assert(!rval);
>  	mlog(MLOG_NITTY | MLOG_NOLOCK | MLOG_PROC,
>  	      "RLIMIT_STACK org cur 0x%llx max 0x%llx\n",
>  	      rlimit64.rlim_cur,
> @@ -2098,7 +2098,7 @@ set_rlimits(size64_t *vmszp)
>  			rlimit64.rlim_max = minstacksz;
>  			(void)setrlimit64(RLIMIT_STACK, &rlimit64);
>  			rval = getrlimit64(RLIMIT_STACK, &rlimit64);
> -			assert(! rval);
> +			assert(!rval);
>  			if (rlimit64.rlim_cur < minstacksz) {
>  				mlog(MLOG_NORMAL
>  				      |
> @@ -2125,7 +2125,7 @@ set_rlimits(size64_t *vmszp)
>  			rlimit64.rlim_cur = minstacksz;
>  			(void)setrlimit64(RLIMIT_STACK, &rlimit64);
>  			rval = getrlimit64(RLIMIT_STACK, &rlimit64);
> -			assert(! rval);
> +			assert(!rval);
>  			if (rlimit64.rlim_cur < minstacksz) {
>  				mlog(MLOG_NORMAL
>  				      |
> @@ -2153,7 +2153,7 @@ set_rlimits(size64_t *vmszp)
>  		rlimit64.rlim_cur = maxstacksz;
>  		(void)setrlimit64(RLIMIT_STACK, &rlimit64);
>  		rval = getrlimit64(RLIMIT_STACK, &rlimit64);
> -		assert(! rval);
> +		assert(!rval);
>  		if (rlimit64.rlim_cur > maxstacksz) {
>  			mlog(MLOG_NORMAL
>  			      |
> @@ -2174,14 +2174,14 @@ set_rlimits(size64_t *vmszp)
>  	      rlimit64.rlim_max);
>  
>  	rval = getrlimit64(RLIMIT_DATA, &rlimit64);
> -	assert(! rval);
> +	assert(!rval);
>  	mlog(MLOG_NITTY | MLOG_NOLOCK | MLOG_PROC,
>  	      "RLIMIT_DATA org cur 0x%llx max 0x%llx\n",
>  	      rlimit64.rlim_cur,
>  	      rlimit64.rlim_max);
>  
>  	rval = getrlimit64(RLIMIT_FSIZE, &rlimit64);
> -	assert(! rval);
> +	assert(!rval);
>  	mlog(MLOG_NITTY | MLOG_NOLOCK | MLOG_PROC,
>  	      "RLIMIT_FSIZE org cur 0x%llx max 0x%llx\n",
>  	      rlimit64.rlim_cur,
> @@ -2191,14 +2191,14 @@ set_rlimits(size64_t *vmszp)
>  	rlimit64.rlim_cur = RLIM64_INFINITY;
>  	(void)setrlimit64(RLIMIT_FSIZE, &rlimit64);
>  	rval = getrlimit64(RLIMIT_FSIZE, &rlimit64);
> -	assert(! rval);
> +	assert(!rval);
>  	mlog(MLOG_NITTY | MLOG_NOLOCK | MLOG_PROC,
>  	      "RLIMIT_FSIZE now cur 0x%llx max 0x%llx\n",
>  	      rlimit64.rlim_cur,
>  	      rlimit64.rlim_max);
>  
>  	rval = getrlimit64(RLIMIT_CPU, &rlimit64);
> -	assert(! rval);
> +	assert(!rval);
>  	mlog(MLOG_NITTY | MLOG_NOLOCK | MLOG_PROC,
>  	      "RLIMIT_CPU cur 0x%llx max 0x%llx\n",
>  	      rlimit64.rlim_cur,
> @@ -2206,7 +2206,7 @@ set_rlimits(size64_t *vmszp)
>  	rlimit64.rlim_cur = rlimit64.rlim_max;
>  	(void)setrlimit64(RLIMIT_CPU, &rlimit64);
>  	rval = getrlimit64(RLIMIT_CPU, &rlimit64);
> -	assert(! rval);
> +	assert(!rval);
>  	mlog(MLOG_NITTY | MLOG_NOLOCK | MLOG_PROC,
>  	      "RLIMIT_CPU now cur 0x%llx max 0x%llx\n",
>  	      rlimit64.rlim_cur,
> @@ -2285,7 +2285,7 @@ strpbrkquotes(char *p, const char *sep)
>  		}
>  
>  		if (*p == '\\') {
> -			if (! prevcharwasbackslash) {
> +			if (!prevcharwasbackslash) {
>  				prevcharwasbackslash = BOOL_TRUE;
>  			} else {
>  				prevcharwasbackslash = BOOL_FALSE;
> @@ -2306,7 +2306,7 @@ strpbrkquotes(char *p, const char *sep)
>  			continue;
>  		}
>  
> -		if (! inquotes) {
> +		if (!inquotes) {
>  			if (strchr(sep, (int)(*p))) {
>  				return p;
>  			}
> @@ -2338,7 +2338,7 @@ stripquotes(char *p)
>  	justremovedbackslash = BOOL_FALSE;
>  
>  	for (nextp = p; nextp < endp;) {
> -		if (*nextp == '\\' && ! justremovedbackslash) {
> +		if (*nextp == '\\' && !justremovedbackslash) {
>  			shiftleftby1(nextp, endp);
>  			endp--;
>  			justremovedbackslash = BOOL_TRUE;
> diff --git a/common/media.c b/common/media.c
> index 2337a84..ab020ce 100644
> --- a/common/media.c
> +++ b/common/media.c
> @@ -113,7 +113,7 @@ media_create(int argc, char *argv[], drive_strategy_t *dsp)
>  				usage();
>  				return 0;
>  			}
> -			if (! optarg || optarg[0] == '-') {
> +			if (!optarg || optarg[0] == '-') {
>  				mlog(MLOG_NORMAL,
>  				      _("-%c argument missing\n"),
>  				      c);
> @@ -128,7 +128,7 @@ media_create(int argc, char *argv[], drive_strategy_t *dsp)
>  
>  	/* if no media label specified, synthesize one
>  	 */
> -	if (! medialabel) {
> +	if (!medialabel) {
>  		/* not useful
>  		mlog(MLOG_VERBOSE,
>  		      _("WARNING: no media label specified\n"));
> @@ -158,7 +158,7 @@ media_create(int argc, char *argv[], drive_strategy_t *dsp)
>  	chosen_sp = 0;
>  	for (id = 0; spp < epp; spp++, id++) {
>  		(*spp)->ms_id = id;
> -		if (! chosen_sp) {
> +		if (!chosen_sp) {
>  			/* lend the media_t array to the strategy
>  			 */
>  			(*spp)->ms_mediap = mediapp;
> @@ -169,12 +169,12 @@ media_create(int argc, char *argv[], drive_strategy_t *dsp)
>  				mediap->m_strategyp = *spp;
>  				mediap->m_writehdrp->mh_strategyid = id;
>  			}
> -			if ((* (*spp)->ms_match)(argc, argv, dsp)) {
> +			if ((*(*spp)->ms_match)(argc, argv, dsp)) {
>  				chosen_sp = *spp;
>  			}
>  		}
>  	}
> -	if (! chosen_sp) {
> +	if (!chosen_sp) {
>  		mlog(MLOG_NORMAL,
>  #ifdef DUMP
>  		      _("no media strategy available for selected "
> @@ -200,8 +200,8 @@ media_create(int argc, char *argv[], drive_strategy_t *dsp)
>  	/* initialize the strategy. this will cause each of the managers
>  	 * to be initialized as well. if error, return 0.
>  	 */
> -	ok = (* chosen_sp->ms_create)(chosen_sp, argc, argv);
> -	if (! ok) {
> +	ok = (*chosen_sp->ms_create)(chosen_sp, argc, argv);
> +	if (!ok) {
>  		return 0;
>  	}
>  
> @@ -215,7 +215,7 @@ media_init(media_strategy_t *msp, int argc, char *argv[])
>  {
>  	bool_t ok;
>  
> -	ok = (* msp->ms_init)(msp, argc, argv);
> +	ok = (*msp->ms_init)(msp, argc, argv);
>  
>  	return ok;
>  }
> @@ -223,7 +223,7 @@ media_init(media_strategy_t *msp, int argc, char *argv[])
>  void
>  media_complete(media_strategy_t *msp)
>  {
> -	(* msp->ms_complete)(msp);
> +	(*msp->ms_complete)(msp);
>  }
>  
>  /* media_get_upper_hdrs - supply pointers to portion of media file headers
> diff --git a/common/mlog.c b/common/mlog.c
> index 32fcc32..7f8640b 100644
> --- a/common/mlog.c
> +++ b/common/mlog.c
> @@ -188,7 +188,7 @@ mlog_init1(int argc, char *argv[])
>  
>  		switch (c) {
>  		case GETOPT_VERBOSITY:
> -			if (! optarg || optarg[0] == '-') {
> +			if (!optarg || optarg[0] == '-') {
>  				fprintf(stderr,
>  					 _("%s: -%c argument missing\n"),
>  					 progname,
> @@ -216,7 +216,7 @@ mlog_init1(int argc, char *argv[])
>  					<
>  					MLOG_SS_CNT + vsymcnt);
>  				if (suboptix < MLOG_SS_CNT) {
> -					if (! valstr) {
> +					if (!valstr) {
>  						fprintf(stderr,
>  							 _("%s: -%c subsystem "
>  							 "subargument "
> @@ -382,11 +382,11 @@ mlog_va(int levelarg, char *fmt, va_list args)
>  		return;
>  	}
>  
> -	if (! (levelarg & MLOG_NOLOCK)) {
> +	if (!(levelarg & MLOG_NOLOCK)) {
>  		mlog_lock();
>  	}
>  
> -	if (! (levelarg & MLOG_BARE)) {
> +	if (!(levelarg & MLOG_BARE)) {
>  		int streamix;
>  		streamix = stream_getix(pthread_self());
>  
> @@ -455,7 +455,7 @@ mlog_va(int levelarg, char *fmt, va_list args)
>  	vfprintf(mlog_fp, fmt, args);
>  	fflush(mlog_fp);
>  
> -	if (! (levelarg & MLOG_NOLOCK)) {
> +	if (!(levelarg & MLOG_NOLOCK)) {
>  		mlog_unlock();
>  	}
>  }
> @@ -793,7 +793,7 @@ mlog_sym_lookup(char *sym)
>  			 sizeof(mlog_sym) / sizeof(mlog_sym[0]);
>  
>  	for (; p < ep; p++) {
> -		if (! strcmp(sym, p->sym)) {
> +		if (!strcmp(sym, p->sym)) {
>  			return p->level;
>  		}
>  	}
> diff --git a/common/path.c b/common/path.c
> index f34f2f2..270e7dc 100644
> --- a/common/path.c
> +++ b/common/path.c
> @@ -60,7 +60,7 @@ path_diff(char *path, char *base)
>  	assert(*base == '/');
>  	assert(*path == '/');
>  
> -	if (! path_beginswith(path, base)) {
> +	if (!path_beginswith(path, base)) {
>  		return 0;
>  	}
>  
> @@ -85,10 +85,10 @@ path_diff(char *path, char *base)
>  int
>  path_beginswith(char *path, char *base)
>  {
> -	if (! base) {
> +	if (!base) {
>  		return 0;
>  	}
> -	return ! strncmp(base, path, strlen(base));
> +	return !strncmp(base, path, strlen(base));
>  }
>  
>  char *
> @@ -136,19 +136,19 @@ path_normalize(char *path)
>  	assert(path[0] == '/');
>  
>  	while ((pep = pem_next(pemp)) != 0) {
> -		if (! strcmp(pep, "")) {
> +		if (!strcmp(pep, "")) {
>  			free((void *)pep);
>  			continue;
>  		}
> -		if (! strcmp(pep, ".")) {
> +		if (!strcmp(pep, ".")) {
>  			free((void *)pep);
>  			continue;
>  		}
> -		if (! strcmp(pep, "..")) {
> +		if (!strcmp(pep, "..")) {
>  			int ok;
>  			free((void *)pep);
>  			ok = pa_peel(pap);
> -			if (! ok) {
> +			if (!ok) {
>  				pa_free(pap);
>  				pem_free(pemp);
>  				return 0;
> @@ -201,7 +201,7 @@ pem_next(pem_t *pemp)
>  
>  	/* if end of string encountered, place next next at end of string
>  	 */
> -	if (! nextnext) {
> +	if (!nextnext) {
>  		for (nextnext = pemp->pem_next; *nextnext; nextnext++)
>  			;
>  	}
> diff --git a/common/qlock.c b/common/qlock.c
> index ae36817..81a0e0b 100644
> --- a/common/qlock.c
> +++ b/common/qlock.c
> @@ -79,7 +79,7 @@ qlock_alloc(ix_t ord)
>  
>  	/* verify the ordinal is not already taken, and mark as taken
>  	 */
> -	assert(! QLOCK_ORDMAP_GET(qlock_ordalloced, ord));
> +	assert(!QLOCK_ORDMAP_GET(qlock_ordalloced, ord));
>  	QLOCK_ORDMAP_SET(qlock_ordalloced, ord);
>  
>  	/* allocate lock memory
> @@ -119,7 +119,7 @@ qlock_lock(qlockh_t qlockh)
>  		      qlockp->ql_ord,
>  		      thread_ordmap);
>  	}
> -	assert(! QLOCK_ORDMAP_GET(thread_ordmap, qlockp->ql_ord));
> +	assert(!QLOCK_ORDMAP_GET(thread_ordmap, qlockp->ql_ord));
>  
>  	/* assert that no locks with a lesser ordinal are held by this thread
>  	 */
> @@ -130,7 +130,7 @@ qlock_lock(qlockh_t qlockh)
>  		      qlockp->ql_ord,
>  		      thread_ordmap);
>  	}
> -	assert(! QLOCK_ORDMAP_CHK(thread_ordmap, qlockp->ql_ord));
> +	assert(!QLOCK_ORDMAP_CHK(thread_ordmap, qlockp->ql_ord));
>  
>  	/* acquire the lock
>  	 */
> @@ -160,7 +160,7 @@ qlock_unlock(qlockh_t qlockh)
>  	/* release the lock
>  	 */
>  	rval = pthread_mutex_unlock(&qlockp->ql_mutex);
> -	assert(! rval);
> +	assert(!rval);
>  }
>  
>  qsemh_t
> diff --git a/common/ring.c b/common/ring.c
> index faef34f..87152dd 100644
> --- a/common/ring.c
> +++ b/common/ring.c
> @@ -99,7 +99,7 @@ ring_create(size_t ringlen,
>  		msgp->rm_loc = RING_LOC_READY;
>  
>  		msgp->rm_bufp = (char *)memalign(PGSZ, bufsz);
> -		if (! msgp->rm_bufp) {
> +		if (!msgp->rm_bufp) {
>  			*rvalp = ENOMEM;
>  			return 0;
>  		}
> @@ -224,7 +224,7 @@ ring_reset(ring_t *ringp, ring_msg_t *msgp)
>  	/* if the client is not holding a message, get the next message
>  	 */
>  	if (ringp->r_client_cnt == 0) {
> -		assert(! msgp);
> +		assert(!msgp);
>  		msgp = ring_get(ringp);
>  		assert(msgp);
>  		assert(ringp->r_client_cnt == 1);
> @@ -433,7 +433,7 @@ ring_slave_entry(void *ringctxp)
>  				msgp->rm_stat = RING_STAT_IGNORE;
>  				break;
>  			}
> -			if (! ringp->r_first_io_time) {
> +			if (!ringp->r_first_io_time) {
>  				ringp->r_first_io_time = time(0);
>  				assert(ringp->r_first_io_time);
>  			}
> @@ -453,7 +453,7 @@ ring_slave_entry(void *ringctxp)
>  				msgp->rm_stat = RING_STAT_IGNORE;
>  				break;
>  			}
> -			if (! ringp->r_first_io_time) {
> +			if (!ringp->r_first_io_time) {
>  				ringp->r_first_io_time = time(0);
>  				assert(ringp->r_first_io_time);
>  			}
> diff --git a/common/ring.h b/common/ring.h
> index be4ae69..6535af8 100644
> --- a/common/ring.h
> +++ b/common/ring.h
> @@ -168,8 +168,8 @@ extern ring_t *ring_create(size_t ringlen,
>  			    size_t bufsz,
>  			    bool_t pinpr,
>  			    ix_t drive_index,
> -			    int (* readfunc)(void *clientctxp, char *bufp),
> -			    int (* writefunc)(void *clientctxp, char *bufp),
> +			    int (*readfunc)(void *clientctxp, char *bufp),
> +			    int (*writefunc)(void *clientctxp, char *bufp),
>  			    void *clientctxp,
>  			    int *rvalp);
>  
> diff --git a/common/stream.c b/common/stream.c
> index 2860021..4f56517 100644
> --- a/common/stream.c
> +++ b/common/stream.c
> @@ -253,7 +253,7 @@ stream_get_exit_status(pthread_t tid,
>  
>  	lock();
>  	p = stream_find(tid, states, nstates);
> -	if (! p) goto unlock;
> +	if (!p) goto unlock;
>  
>  	if (state) *state = p->s_state;
>  	if (ix) *ix = p->s_ix;
> diff --git a/common/util.c b/common/util.c
> index b6daeaa..05a5cb8 100644
> --- a/common/util.c
> +++ b/common/util.c
> @@ -58,7 +58,7 @@ write_buf(char *bufp,
>  		} else {
>  			(void)memset((void *)mbufp, 0, mbufsz);
>  		}
> -		rval = (* write_funcp)(contextp, mbufp, mbufsz);
> +		rval = (*write_funcp)(contextp, mbufp, mbufsz);
>  		if (rval) {
>  			return rval;
>  		}
> @@ -86,7 +86,7 @@ read_buf(char *bufp,
>  	nread = 0;
>  	*statp = 0;
>  	while (bufsz) {
> -		mbufp = (* read_funcp)(contextp, bufsz, &mbufsz, statp);
> +		mbufp = (*read_funcp)(contextp, bufsz, &mbufsz, statp);
>  		if (*statp) {
>  			break;
>  		}
> @@ -97,7 +97,7 @@ read_buf(char *bufp,
>  		}
>  		bufsz -= mbufsz;
>  		nread += (int)mbufsz;
> -		(* return_read_buf_funcp)(contextp, mbufp, mbufsz);
> +		(*return_read_buf_funcp)(contextp, mbufp, mbufsz);
>  	}
>  
>  	return nread;
> @@ -202,15 +202,15 @@ bigstat_iter(jdm_fshandle_t *fshandlep,
>  			}
>  
>  			if ((p->bs_mode & S_IFMT) == S_IFDIR) {
> -				if (! (selector & BIGSTAT_ITER_DIR)){
> +				if (!(selector & BIGSTAT_ITER_DIR)){
>  					continue;
>  				}
>  			} else {
> -				if (! (selector & BIGSTAT_ITER_NONDIR)){
> +				if (!(selector & BIGSTAT_ITER_NONDIR)){
>  					continue;
>  				}
>  			}
> -			rval = (* fp)(cb_arg1, fshandlep, fsfd, p);
> +			rval = (*fp)(cb_arg1, fshandlep, fsfd, p);
>  			if (rval) {
>  				*statp = rval;
>  				return 0;
> @@ -272,7 +272,7 @@ bigstat_one(int fsfd,
>  #define INOGRPLEN	256
>  int
>  inogrp_iter(int fsfd,
> -	     int (* fp)(void *arg1,
> +	     int (*fp)(void *arg1,
>  				int fsfd,
>  				xfs_inogrp_t *inogrp),
>  	     void * arg1,
> @@ -311,7 +311,7 @@ inogrp_iter(int fsfd,
>  		for (p = igrp, endp = igrp + inogrpcnt; p < endp; p++) {
>  			int rval;
>  
> -			rval = (* fp)(arg1, fsfd, p);
> +			rval = (*fp)(arg1, fsfd, p);
>  			if (rval) {
>  				*statp = rval;
>  				free(igrp);
> @@ -376,7 +376,7 @@ diriter(jdm_fshandle_t *fshandlep,
>  		      statp->bs_ino,
>  		      strerror(errno));
>  		*cbrvalp = 0;
> -		if (! usrgdp) {
> +		if (!usrgdp) {
>  			free((void *)gdp);
>  		}
>  		return -1;
> @@ -476,7 +476,7 @@ diriter(jdm_fshandle_t *fshandlep,
>  
>  			/* invoke the callback
>  			 */
> -			cbrval = (* cbfp)(arg1,
> +			cbrval = (*cbfp)(arg1,
>  					     fshandlep,
>  					     fsfd,
>  					     &statbuf,
> @@ -495,7 +495,7 @@ diriter(jdm_fshandle_t *fshandlep,
>  	}
>  
>  	(void)close(fd);
> -	if (! usrgdp) {
> +	if (!usrgdp) {
>  		free((void *)gdp);
>  	}
>  
> diff --git a/common/util.h b/common/util.h
> index ab43739..9e8bb6f 100644
> --- a/common/util.h
> +++ b/common/util.h
> @@ -32,8 +32,8 @@
>   *
>   * if bufp is null, writes bufsz zeros.
>   */
> -typedef char * (* gwbfp_t)(void *contextp, size_t wantedsz, size_t *szp);
> -typedef int (* wfp_t)(void *contextp, char *bufp, size_t bufsz);
> +typedef char *(*gwbfp_t)(void *contextp, size_t wantedsz, size_t *szp);
> +typedef int (*wfp_t)(void *contextp, char *bufp, size_t bufsz);
>  
>  extern int write_buf(char *bufp,
>  			   size_t bufsz,
> @@ -57,7 +57,7 @@ extern int write_buf(char *bufp,
>   * *statp will be zero.
>   */
>  typedef char * (*rfp_t)(void *contextp, size_t wantedsz, size_t *szp, int *statp);
> -typedef void (* rrbfp_t)(void *contextp, char *bufp, size_t bufsz);
> +typedef void (*rrbfp_t)(void *contextp, char *bufp, size_t bufsz);
>  
>  extern int read_buf(char *bufp,
>  			  size_t bufsz,
> @@ -110,7 +110,7 @@ extern int bigstat_one(int fsfd,
>  			     xfs_bstat_t *statp);
>  
>  extern int inogrp_iter(int fsfd,
> -			     int (* fp)(void *arg1,
> +			     int (*fp)(void *arg1,
>  				     		int fsfd,
>  						xfs_inogrp_t *inogrp),
>  			     void * arg1,
> diff --git a/dump/content.c b/dump/content.c
> index 14ce63b..d9a53d1 100644
> --- a/dump/content.c
> +++ b/dump/content.c
> @@ -599,7 +599,7 @@ content_init(int argc,
>  	while ((c = getopt(argc, argv, GETOPT_CMDSTRING)) != EOF) {
>  		switch (c) {
>  		case GETOPT_LEVEL:
> -			if (! optarg || optarg[0] == '-') {
> +			if (!optarg || optarg[0] == '-') {
>  				mlog(MLOG_NORMAL | MLOG_ERROR, _(
>  				      "-%c argument missing\n"),
>  				      c);
> @@ -618,7 +618,7 @@ content_init(int argc,
>  			}
>  			break;
>  		case GETOPT_SUBTREE:
> -			if (! optarg || optarg[0] == '-') {
> +			if (!optarg || optarg[0] == '-') {
>  				mlog(MLOG_NORMAL | MLOG_ERROR, _(
>  				      "-%c argument missing\n"),
>  				      c);
> @@ -636,7 +636,7 @@ content_init(int argc,
>  			subtreecnt++;
>  			break;
>  		case GETOPT_MAXDUMPFILESIZE:
> -			if (! optarg || optarg [0] == '-') {
> +			if (!optarg || optarg [0] == '-') {
>  				mlog(MLOG_NORMAL | MLOG_ERROR, _(
>  				      "-%c argument missing\n"),
>  				      c);
> @@ -671,7 +671,7 @@ content_init(int argc,
>  			sc_preerasepr = BOOL_TRUE;
>  			break;
>  		case GETOPT_ALERTPROG:
> -			if (! optarg || optarg[0] == '-') {
> +			if (!optarg || optarg[0] == '-') {
>  				mlog(MLOG_NORMAL | MLOG_ERROR, _(
>  					"-%c argument missing\n"),
>  				    c);
> @@ -687,7 +687,7 @@ content_init(int argc,
>  			sc_dumpasoffline = BOOL_TRUE;
>  			break;
>  		case GETOPT_BASED:
> -			if (! optarg || optarg[0] == '-') {
> +			if (!optarg || optarg[0] == '-') {
>  				mlog(MLOG_NORMAL | MLOG_ERROR, _(
>  				      "-%c argument missing\n"),
>  				      c);
> @@ -720,7 +720,7 @@ content_init(int argc,
>  	 * dash ('-') with no option letter. This must appear between
>  	 * all lettered arguments and the source file system pathname.
>  	 */
> -	if (optind < argc && ! strcmp(argv[optind ], "-")) {
> +	if (optind < argc && !strcmp(argv[optind ], "-")) {
>  		optind++;
>  	}
>  
> @@ -769,7 +769,7 @@ content_init(int argc,
>  	 * system ID (uuid). returns BOOL_FALSE if the last
>  	 * argument doesn't look like a file system.
>  	 */
> -	if (! fs_info(fstype,
> +	if (!fs_info(fstype,
>  			sizeof(fstype),
>  			FS_DEFAULT,
>  			fsdevice,
> @@ -790,7 +790,7 @@ content_init(int argc,
>  	 * to mount an unmounted file system on a temporary mount point,
>  	 * if it is not currently mounted.
>  	 */
> -	if (! fs_mounted(fstype, fsdevice, mntpnt, &fsid)) {
> +	if (!fs_mounted(fstype, fsdevice, mntpnt, &fsid)) {
>  		mlog(MLOG_NORMAL | MLOG_ERROR, _(
>  		      "%s must be mounted to be dumped\n"),
>  		      srcname);
> @@ -880,7 +880,7 @@ content_init(int argc,
>  		interruptedpr = BOOL_FALSE;
>  
>  		ok = inv_get_session_byuuid(&fsid, &baseuuid, &sessp);
> -		if (! ok) {
> +		if (!ok) {
>  			mlog(MLOG_NORMAL | MLOG_ERROR, _(
>  			      "could not find specified base dump (%s) "
>  			      "in inventory\n"),
> @@ -994,7 +994,7 @@ content_init(int argc,
>  						    inv_idbt,
>  						    (u_char_t)sc_level,
>  						    &sessp);
> -		if (! ok) {
> +		if (!ok) {
>  			sessp = 0;
>  		}
>  
> @@ -1036,7 +1036,7 @@ content_init(int argc,
>  						   &sessp);
>  		ok1 = inv_close(inv_idbt);
>  		assert(ok1);
> -		if (! ok) {
> +		if (!ok) {
>  			sessp = 0;
>  		}
>  		inv_idbt = INV_TOKEN_NULL;
> @@ -1107,13 +1107,13 @@ baseuuidbypass:
>  
>  	/* now determine the incremental and resume bases, if any.
>  	 */
> -	if (samefoundpr && ! sameinterruptedpr) {
> +	if (samefoundpr && !sameinterruptedpr) {
>  		free((void *)sc_resumerangep);
>  		sc_resumerangep = 0;
>  		samefoundpr = BOOL_FALSE;
>  	}
> -	if (samefoundpr && ! resumereqpr) {
> -		if (! underfoundpr || undertime <= sametime) {
> +	if (samefoundpr && !resumereqpr) {
> +		if (!underfoundpr || undertime <= sametime) {
>  			mlog(MLOG_VERBOSE | MLOG_WARNING, _(
>  			      "most recent level %d dump "
>  			      "was interrupted, "
> @@ -1141,7 +1141,7 @@ baseuuidbypass:
>  					      sc_level);
>  					return BOOL_FALSE;
>  				}
> -				if (subtreecnt && ! underpartialpr) {
> +				if (subtreecnt && !underpartialpr) {
>  					mlog(MLOG_NORMAL | MLOG_WARNING, _(
>  					      "level %u incremental "
>  					      "subtree dump "
> @@ -1150,7 +1150,7 @@ baseuuidbypass:
>  					      sc_level,
>  					      underlevel);
>  				}
> -				if (! subtreecnt && underpartialpr) {
> +				if (!subtreecnt && underpartialpr) {
>  					mlog(MLOG_NORMAL | MLOG_WARNING, _(
>  					      "level %u incremental "
>  					      "non-subtree dump "
> @@ -1168,7 +1168,7 @@ baseuuidbypass:
>  				free((void *)sc_resumerangep);
>  				sc_resumerangep = 0;
>  			} else {
> -				if (subtreecnt && ! samepartialpr) {
> +				if (subtreecnt && !samepartialpr) {
>  					mlog(MLOG_NORMAL | MLOG_WARNING, _(
>  					      "level %u incremental "
>  					      "subtree dump "
> @@ -1177,7 +1177,7 @@ baseuuidbypass:
>  					      sc_level,
>  					      sc_level);
>  				}
> -				if (! subtreecnt && samepartialpr) {
> +				if (!subtreecnt && samepartialpr) {
>  					mlog(MLOG_NORMAL | MLOG_WARNING, _(
>  					      "level %u incremental "
>  					      "non-subtree dump "
> @@ -1207,7 +1207,7 @@ baseuuidbypass:
>  				      sc_level);
>  				return BOOL_FALSE;
>  			}
> -			if (subtreecnt && ! underpartialpr) {
> +			if (subtreecnt && !underpartialpr) {
>  				mlog(MLOG_NORMAL | MLOG_WARNING, _(
>  				      "level %u incremental "
>  				      "subtree dump "
> @@ -1216,7 +1216,7 @@ baseuuidbypass:
>  				      sc_level,
>  				      underlevel);
>  			}
> -			if (! subtreecnt && underpartialpr) {
> +			if (!subtreecnt && underpartialpr) {
>  				mlog(MLOG_NORMAL | MLOG_WARNING, _(
>  				      "level %u incremental "
>  				      "non-subtree dump "
> @@ -1230,12 +1230,12 @@ baseuuidbypass:
>  			sc_incrbaselevel = underlevel;
>  			uuid_copy(sc_incrbaseid, underid);
>  			sc_resumepr = BOOL_FALSE;
> -			assert(! sc_resumerangep);
> +			assert(!sc_resumerangep);
>  		}
>  	} else {
>  		if (samefoundpr) {
>  			assert(sametime);
> -			if (subtreecnt && ! samepartialpr) {
> +			if (subtreecnt && !samepartialpr) {
>  				mlog(MLOG_NORMAL | MLOG_WARNING, _(
>  				      "level %u "
>  				      "subtree dump "
> @@ -1244,7 +1244,7 @@ baseuuidbypass:
>  				      sc_level,
>  				      sc_level);
>  			}
> -			if (! subtreecnt && samepartialpr) {
> +			if (!subtreecnt && samepartialpr) {
>  				mlog(MLOG_NORMAL | MLOG_WARNING, _(
>  				      "level %u "
>  				      "non-subtree dump "
> @@ -1261,7 +1261,7 @@ baseuuidbypass:
>  		} else {
>  			sc_incrpr = BOOL_FALSE;
>  			sc_resumepr = BOOL_FALSE;
> -			assert(! sc_resumerangep);
> +			assert(!sc_resumerangep);
>  			if (sc_level > 0) {
>  				mlog(MLOG_NORMAL | MLOG_ERROR, _(
>  				      "cannot find earlier dump "
> @@ -1285,7 +1285,7 @@ baseuuidbypass:
>  
>  	/* reject if resume (-R) specified, but base was not interrupted
>  	 */
> -	if (! sc_resumepr && resumereqpr) {
> +	if (!sc_resumepr && resumereqpr) {
>  		mlog(MLOG_NORMAL | MLOG_ERROR, _(
>  		      "resume (-R) option inappropriate: "
>  		      "no interrupted level %d dump to resume\n"),
> @@ -1425,7 +1425,7 @@ baseuuidbypass:
>  	 * functions.
>  	 */
>  	sc_fshandlep = jdm_getfshandle(mntpnt);
> -	if (! sc_fshandlep) {
> +	if (!sc_fshandlep) {
>  		mlog(MLOG_NORMAL, _(
>  		      "unable to construct a file system handle for %s: %s\n"),
>  		      mntpnt,
> @@ -1478,7 +1478,7 @@ baseuuidbypass:
>  			   &sc_stat_inomapdone);
>  	free((void *)subtreep);
>  	subtreep = 0;
> -	if (! ok) {
> +	if (!ok) {
>  		return BOOL_FALSE;
>  	}
>  
> @@ -1663,7 +1663,7 @@ baseuuidbypass:
>  					usage();
>  					return BOOL_FALSE;
>  				}
> -				if (! optarg || optarg[0] == '-') {
> +				if (!optarg || optarg[0] == '-') {
>  					mlog(MLOG_NORMAL, _(
>  					      "-%c argument missing\n"),
>  					      c);
> @@ -1764,7 +1764,7 @@ content_statline(char **linespp[])
>  
>  	/* if start time not initialized, return no strings
>  	 */
> -	if (! sc_stat_starttime) {
> +	if (!sc_stat_starttime) {
>  		return 0;
>  	}
>  
> @@ -1929,7 +1929,7 @@ create_inv_session(
>  
>  	/* create a cleanup handler to close the inventory on exit. */
>  	rval = atexit(inv_cleanup);
> -	assert(! rval);
> +	assert(!rval);
>  
>  	sc_inv_idbtoken = inv_open((inv_predicate_t)INV_BY_UUID,
>  					INV_SEARCH_N_MOD,
> @@ -2014,7 +2014,7 @@ mark_set(drive_t *drivep, xfs_ino_t ino, off64_t offset, int32_t flags)
>  	markp->startpt.sp_ino = ino;
>  	markp->startpt.sp_offset = offset;
>  	markp->startpt.sp_flags = flags;
> -	(* dop->do_set_mark)(drivep,
> +	(*dop->do_set_mark)(drivep,
>  				mark_callback,
>  				(void *)drivep->d_index,
>  				(drive_markrec_t *)markp);
> @@ -2372,7 +2372,7 @@ content_stream_dump(ix_t strmix)
>  		 * non-directory file is fully committed to media,
>  		 * the starting point for the next media file will be advanced.
>  		 */
> -		if (! all_nondirs_committed) {
> +		if (!all_nondirs_committed) {
>  			mlog(MLOG_VERBOSE, _(
>  			      "dumping non-directory files\n"));
>  			sc_stat_pds[strmix].pds_phase = PDS_NONDIR;
> @@ -2447,7 +2447,7 @@ decision_more:
>  		 * media file in the stream. don't bother if we hit
>  		 * EOM.
>  		 */
> -		if (! hit_eom) {
> +		if (!hit_eom) {
>  			rv = dump_filehdr(drivep,
>  					   contextp,
>  					   0,
> @@ -2540,7 +2540,7 @@ decision_more:
>  		if (inv_stmt != INV_TOKEN_NULL) {
>  			bool_t ok;
>  
> -			if (! all_dirs_committed) {
> +			if (!all_dirs_committed) {
>  				mlog(MLOG_DEBUG,
>  				      "giving inventory "
>  				      "partial dirdump media file\n");
> @@ -2589,9 +2589,9 @@ decision_more:
>  						ncommitted,
>  					        all_dirs_committed
>  						&&
> -						! empty_mediafile,
> +						!empty_mediafile,
>  						BOOL_FALSE);
> -			if (! ok) {
> +			if (!ok) {
>  				mlog(MLOG_NORMAL, _(
>  				      "inventory media file put failed\n"));
>  			}
> @@ -2790,16 +2790,16 @@ update_cc_Media_useterminatorpr(drive_t *drivep, context_t *contextp)
>  	int dcaps = drivep->d_capabilities;
>  
>  	contextp->cc_Media_useterminatorpr = BOOL_TRUE;
> -	if (! (dcaps & DRIVE_CAP_FILES)) {
> +	if (!(dcaps & DRIVE_CAP_FILES)) {
>  		contextp->cc_Media_useterminatorpr = BOOL_FALSE;
>  	}
> -	if (! (dcaps & DRIVE_CAP_OVERWRITE)) {
> +	if (!(dcaps & DRIVE_CAP_OVERWRITE)) {
>  		contextp->cc_Media_useterminatorpr = BOOL_FALSE;
>  	}
> -	if (! (dcaps & DRIVE_CAP_BSF)) {
> +	if (!(dcaps & DRIVE_CAP_BSF)) {
>  		contextp->cc_Media_useterminatorpr = BOOL_FALSE;
>  	}
> -	if (! (dcaps & DRIVE_CAP_APPEND)) {
> +	if (!(dcaps & DRIVE_CAP_APPEND)) {
>  		contextp->cc_Media_useterminatorpr = BOOL_FALSE;
>  	}
>  }
> @@ -3754,7 +3754,7 @@ dump_file(void *arg1,
>  	/* skip if at or beyond next startpoint. return non-zero to
>  	 * abort iteration.
>  	 */
> -	if (! (endptp->sp_flags & STARTPT_FLAGS_END)) {
> +	if (!(endptp->sp_flags & STARTPT_FLAGS_END)) {
>  		if (endptp->sp_offset == 0) {
>  			if (statp->bs_ino >= endptp->sp_ino) {
>  				if (statp->bs_ino > contextp->cc_stat_lastino) {
> @@ -4309,7 +4309,7 @@ init_extent_group_context(jdm_fshandle_t *fshandlep,
>  	 * after this check but before all reads have completed.
>  	 * This change just closes the window a bit.
>  	 */
> -	if ((statp->bs_mode & S_ISGID) && (! (statp->bs_mode&S_IXOTH))) {
> +	if ((statp->bs_mode & S_ISGID) && (!(statp->bs_mode&S_IXOTH))) {
>  		fl.l_type = F_RDLCK;
>  		fl.l_whence = SEEK_SET;
>  		fl.l_start = (off_t)0;
> @@ -4588,7 +4588,7 @@ dump_extent_group(drive_t *drivep,
>  		 * but does not contain any data above the current
>  		 * offset, go to the next one and rescan.
>  		 */
> -		if (! sosig || offset < stopoffset) {
> +		if (!sosig || offset < stopoffset) {
>  			if (offset + extsz <= nextoffset) {
>  				mlog(MLOG_NITTY,
>  				      "extent ends before nextoffset\n");
> @@ -4717,7 +4717,7 @@ dump_extent_group(drive_t *drivep,
>  		if (sosig && (extsz > stopoffset - offset)) {
>  			extsz = stopoffset - offset;
>  			assert(extsz >= 0);
> -			assert(! (extsz & (off64_t)(BBSIZE - 1)));
> +			assert(!(extsz & (off64_t)(BBSIZE - 1)));
>  			mlog(MLOG_NITTY,
>  			      "adjusted top of extent "
>  			      "to adhere to stop offset: "
> @@ -4734,7 +4734,7 @@ dump_extent_group(drive_t *drivep,
>  		 */
>  		if (isrealtime || extsz >= PGALIGNTHRESH * PGSZ) {
>  			size_t cnt_to_align;
> -			cnt_to_align = (* dop->do_get_align_cnt)(drivep);
> +			cnt_to_align = (*dop->do_get_align_cnt)(drivep);
>  			if ((size_t)cnt_to_align < 2*sizeof(extenthdr_t)) {
>  				cnt_to_align += PGSZ;
>  			}
> @@ -4807,7 +4807,7 @@ dump_extent_group(drive_t *drivep,
>  				INTGENMAX
>  				:
>  				(size_t)extsz;
> -			bufp = (* dop->do_get_write_buf)(drivep,
> +			bufp = (*dop->do_get_write_buf)(drivep,
>  							    reqsz,
>  							    &actualsz);
>  			assert(actualsz <= reqsz);
> @@ -4853,7 +4853,7 @@ dump_extent_group(drive_t *drivep,
>  					actualsz - (size_t)nread);
>  			}
>  
> -			rval = (* dop->do_write)(drivep,
> +			rval = (*dop->do_write)(drivep,
>  						    bufp,
>  						    actualsz);
>  			switch (rval) {
> @@ -5225,7 +5225,7 @@ dump_session_inv(drive_t *drivep,
>  	inv_sbufp = 0;
>  	inv_sbufsz = 0;
>  	ok = inv_get_sessioninfo(sc_inv_sestoken, (void *)&inv_sbufp, &inv_sbufsz);
> -	if (! ok) {
> +	if (!ok) {
>  		mlog(MLOG_NORMAL | MLOG_WARNING, _(
>  		      "unable to get session inventory to dump\n"));
>  		return BOOL_TRUE;
> @@ -5240,7 +5240,7 @@ dump_session_inv(drive_t *drivep,
>  	 * until we are successful or until the media layer
>  	 * tells us to give up.
>  	 */
> -	for (done = BOOL_FALSE; ! done;) {
> +	for (done = BOOL_FALSE; !done;) {
>  		uuid_t mediaid;
>  		char medialabel[GLOBAL_HDR_STRING_SZ];
>  		bool_t partial;
> @@ -5351,9 +5351,9 @@ dump_session_inv(drive_t *drivep,
>  						(xfs_ino_t)0,
>  						(off64_t)0,
>  						ncommitted,
> -						! partial,
> +						!partial,
>  						BOOL_TRUE);
> -			if (! ok) {
> +			if (!ok) {
>  				mlog(MLOG_NORMAL, _(
>  				      "inventory session media file "
>  				      "put failed\n"));
> @@ -5361,7 +5361,7 @@ dump_session_inv(drive_t *drivep,
>  			}
>  		}
>  
> -		done = ! partial;
> +		done = !partial;
>  	}
>  
>  	return BOOL_TRUE;
> @@ -5375,7 +5375,7 @@ dump_terminator(drive_t *drivep, context_t *contextp, media_hdr_t *mwhdrp)
>  
>  	/* if the drive doesn't support use of stream terminators, don't bother
>  	 */
> -	if (! contextp->cc_Media_useterminatorpr) {
> +	if (!contextp->cc_Media_useterminatorpr) {
>  		return;
>  	}
>  
> @@ -5390,7 +5390,7 @@ dump_terminator(drive_t *drivep, context_t *contextp, media_hdr_t *mwhdrp)
>  	 * until we are successful or until the media layer
>  	 * tells us to give up.
>  	 */
> -	for (done = BOOL_FALSE; ! done;) {
> +	for (done = BOOL_FALSE; !done;) {
>  		bool_t partial;
>  		rv_t rv;
>  
> @@ -5454,7 +5454,7 @@ dump_terminator(drive_t *drivep, context_t *contextp, media_hdr_t *mwhdrp)
>  			      ncommitted);
>  		}
>  
> -		done = ! partial;
> +		done = !partial;
>  	}
>  }
>  
> @@ -5511,7 +5511,7 @@ inv_cleanup(void)
>  		      inv_stmtp++,
>  		      contextp++) {
>  			bool_t interrupted;
> -			interrupted = ! contextp->cc_completepr;
> +			interrupted = !contextp->cc_completepr;
>  			if (*inv_stmtp == INV_TOKEN_NULL) {
>  				continue;
>  			}
> @@ -5635,7 +5635,7 @@ position:
>  
>  		/* do a begin_read to see the disposition of the drive/media.
>  		 */
> -		rval = (* dop->do_begin_read)(drivep);
> +		rval = (*dop->do_begin_read)(drivep);
>  
>  		/* update cc_Media_useterminatorpr after every begin_read,
>  		 * since begin_read will cause some unknown drive params
> @@ -5679,7 +5679,7 @@ position:
>  			 * media object a virgin.
>  			 * also, check for erase option.
>  			 */
> -			(* dop->do_end_read)(drivep);
> +			(*dop->do_end_read)(drivep);
>  
>  			switch(Media_erasechk(drivep,
>  						dcaps,
> @@ -5699,7 +5699,7 @@ position:
>  				      "must supply a blank media object\n"));
>  				goto changemedia;
>  			}
> -			if (! (dcaps & DRIVE_CAP_APPEND)) {
> +			if (!(dcaps & DRIVE_CAP_APPEND)) {
>  				mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_MEDIA, _(
>  				      "media contains valid xfsdump "
>  				      "but does not support append\n"));
> @@ -5712,7 +5712,7 @@ position:
>  				assert(contextp->cc_Media_useterminatorpr);
>  				assert(dcaps & DRIVE_CAP_BSF); /* redundant */
>  				status = 0;
> -				rval = (* dop->do_bsf)(drivep, 0, &status);
> +				rval = (*dop->do_bsf)(drivep, 0, &status);
>  				assert(rval == 0);
>  				if (status == DRIVE_ERROR_DEVICE) {
>  					mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_MEDIA, _(
> @@ -5753,12 +5753,12 @@ position:
>  				if (intr_allowed && cldmgr_stop_requested()) {
>  					return RV_INTR;
>  				}
> -				if (! ok) {
> +				if (!ok) {
>  					goto changemedia;
>  				}
>  			}
>  
> -			if (! (dcaps & DRIVE_CAP_OVERWRITE)) {
> +			if (!(dcaps & DRIVE_CAP_OVERWRITE)) {
>  				mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA, _(
>  				      "unable to overwrite\n"));
>  				goto changemedia;
> @@ -5768,7 +5768,7 @@ position:
>  				      "repositioning to overwrite\n"));
>  				assert(dcaps & DRIVE_CAP_BSF);
>  				status = 0;
> -				rval = (* dop->do_bsf)(drivep, 0, &status);
> +				rval = (*dop->do_bsf)(drivep, 0, &status);
>  				assert(rval == 0);
>  				if (status == DRIVE_ERROR_DEVICE) {
>  					return RV_DRIVE;
> @@ -5792,7 +5792,7 @@ position:
>  				if (intr_allowed && cldmgr_stop_requested()) {
>  					return RV_INTR;
>  				}
> -				if (! ok) {
> +				if (!ok) {
>  					goto changemedia;
>  				}
>  			}
> @@ -5889,7 +5889,7 @@ position:
>  				      "assuming corrupted media\n"));
>  				mlog_exit_hint(RV_CORRUPT);
>  				goto changemedia;
> -			} else if (! (dcaps & DRIVE_CAP_OVERWRITE)) {
> +			} else if (!(dcaps & DRIVE_CAP_OVERWRITE)) {
>  				mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA,_(
>  				      "encountered corrupt or foreign data: "
>  				      "unable to overwrite: "
> @@ -5904,7 +5904,7 @@ position:
>  				mlog_exit_hint(RV_CORRUPT);
>  				assert(dcaps & DRIVE_CAP_BSF);
>  				status = 0;
> -				rval = (* dop->do_bsf)(drivep, 0, &status);
> +				rval = (*dop->do_bsf)(drivep, 0, &status);
>  				assert(rval == 0);
>  				if (status == DRIVE_ERROR_DEVICE) {
>  					return RV_DRIVE;
> @@ -5928,7 +5928,7 @@ position:
>  erasemedia:
>  	mlog(MLOG_VERBOSE | MLOG_WARNING | MLOG_MEDIA, _(
>  	      "erasing media\n"));
> -	rval = (* dop->do_erase)(drivep);
> +	rval = (*dop->do_erase)(drivep);
>  	if (rval) {
>  		return RV_DRIVE;
>  	}
> @@ -5941,7 +5941,7 @@ erasemedia:
>  changemedia:
>  	/* if the drive does not support media change, quit.
>  	 */
> -	if (! (dcaps & DRIVE_CAP_REMOVABLE)) {
> +	if (!(dcaps & DRIVE_CAP_REMOVABLE)) {
>  		return RV_ERROR;
>  	}
>  
> @@ -5950,7 +5950,7 @@ changemedia:
>  	assert(mediapresentpr != BOOL_UNKNOWN);
>  	if (mediapresentpr == BOOL_TRUE) {
>  		if (dcaps & DRIVE_CAP_EJECT) {
> -			rval = (* dop->do_eject_media)(drivep);
> +			rval = (*dop->do_eject_media)(drivep);
>  			if (rval) {
>  				return RV_DRIVE;
>  			}
> @@ -5959,7 +5959,7 @@ changemedia:
>  
>  	/* if dialogs not allowed, we are done.
>  	 */
> -	if (! dlog_allowed()) {
> +	if (!dlog_allowed()) {
>  		return RV_QUIT; /* this return value will cause approp. msg */
>  	}
>  
> @@ -5971,7 +5971,7 @@ changemedia:
>  	/* if media change prompt declined or times out,
>  	 * we are done
>  	 */
> -	if (drivecnt > 1 && ! stdoutpiped) {
> +	if (drivecnt > 1 && !stdoutpiped) {
>  		ix_t thrdix = drivep->d_index;
>  		assert(sistr);
>  		mlog(MLOG_NORMAL | MLOG_NOTE | MLOG_MEDIA, _(
> @@ -5993,7 +5993,7 @@ changemedia:
>  	if (intr_allowed && cldmgr_stop_requested()) {
>  		return RV_INTR;
>  	}
> -	if (! ok) {
> +	if (!ok) {
>  		return RV_QUIT;
>  	}
>  
> @@ -6038,13 +6038,13 @@ write:
>  			mwhdrp->mh_mediafileix++;
>  		} else {
>  			mwhdrp->mh_mediafileix = mrhdrp->mh_mediafileix;
> -			if (! MEDIA_TERMINATOR_CHK(mrhdrp)) {
> +			if (!MEDIA_TERMINATOR_CHK(mrhdrp)) {
>  				mwhdrp->mh_mediafileix++;
>  			}
>  		}
>  	}
>  
> -	if (! mediawrittentopr) {
> +	if (!mediawrittentopr) {
>  		mwhdrp->mh_mediaix++; /* pre-initialized to -1 */
>  	}
>  
> @@ -6067,7 +6067,7 @@ write:
>  
>  	/* update the media object previous id and label
>  	 */
> -	if (! mediawrittentopr && mwhdrp->mh_dumpfileix != 0) {
> +	if (!mediawrittentopr && mwhdrp->mh_dumpfileix != 0) {
>  		uuid_copy(mwhdrp->mh_prevmediaid, mwhdrp->mh_mediaid);
>  		(void)strncpyterm(mwhdrp->mh_prevmedialabel,
>  				     mwhdrp->mh_medialabel,
> @@ -6076,17 +6076,17 @@ write:
>  
>  	/* update the media object current id and label
>  	 */
> -	if (! mediawrittentopr) {
> +	if (!mediawrittentopr) {
>  		if (mwhdrp->mh_mediafileix == 0) {
>  			char labelbuf[GLOBAL_HDR_STRING_SZ];
>  
>  			uuid_generate(mwhdrp->mh_mediaid);
>  
> -			if (! cmdlinemedialabel
> +			if (!cmdlinemedialabel
>  			     &&
> -			     ! drivep->d_isnamedpipepr
> +			     !drivep->d_isnamedpipepr
>  			     &&
> -			     ! drivep->d_isunnamedpipepr
> +			     !drivep->d_isunnamedpipepr
>  			     &&
>  			     dlog_allowed()) {
>  				cmdlinemedialabel = Media_prompt_label(drivep,
> @@ -6104,7 +6104,7 @@ write:
>  				(void)memset((void *)mwhdrp->mh_medialabel,
>  						     0,
>  					       sizeof(mwhdrp->mh_medialabel));
> -				if (! pipeline) {
> +				if (!pipeline) {
>  					mlog(MLOG_VERBOSE
>  					      |
>  					      MLOG_WARNING
> @@ -6114,7 +6114,7 @@ write:
>  				}
>  			}
>  		} else {
> -			assert(! virginmediapr);
> +			assert(!virginmediapr);
>  			uuid_copy(mwhdrp->mh_mediaid, mrhdrp->mh_mediaid);
>  			(void)strncpyterm(mwhdrp->mh_medialabel,
>  					     mrhdrp->mh_medialabel,
> @@ -6129,7 +6129,7 @@ write:
>  	if (intr_allowed && cldmgr_stop_requested()) {
>  		return RV_INTR;
>  	}
> -	rval = (* dop->do_begin_write)(drivep);
> +	rval = (*dop->do_begin_write)(drivep);
>  	switch(rval) {
>  	case 0:
>  		return RV_OK;
> @@ -6170,7 +6170,7 @@ Media_mfile_end(drive_t *drivep,
>  	 */
>  	rval = (dop->do_end_write)(drivep, ncommittedp);
>  	if (hit_eom) {
> -		assert(! rval);
> +		assert(!rval);
>  		contextp->cc_Media_begin_entrystate = BES_ENDEOM;
>  		return RV_EOM;
>  	}
> @@ -6444,7 +6444,7 @@ Media_prompt_label_cb(void *uctxp, dlog_pcbp_t pcb, void *pctxp)
>  
>  	/* query: ask for a label
>  	 */
> -	(* pcb)(pctxp,
> +	(*pcb)(pctxp,
>  		   "please enter label for media in "
>  		   "drive %u",
>  		   drivep->d_index);
> @@ -6567,7 +6567,7 @@ check_complete_flags(void)
>  
>  	for (strmix = 0; strmix < drivecnt; strmix++) {
>  		context_t *contextp = &sc_contextp[strmix];
> -		if (! contextp->cc_completepr) {
> +		if (!contextp->cc_completepr) {
>  			completepr = BOOL_FALSE;
>  			break;
>  		}
> diff --git a/dump/inomap.c b/dump/inomap.c
> index 7841157..86d6072 100644
> --- a/dump/inomap.c
> +++ b/dump/inomap.c
> @@ -373,13 +373,13 @@ inomap_build(jdm_fshandle_t *fshandlep,
>  			} else {
>  				ep = &startptp[startptix + 1];
>  			}
> -			assert(! p->sp_flags);
> +			assert(!p->sp_flags);
>  			mlog(MLOG_VERBOSE | MLOG_INOMAP,
>  			      _("stream %u: ino %llu offset %lld to "),
>  			      startptix,
>  			      p->sp_ino,
>  			      p->sp_offset);
> -			if (! ep) {
> +			if (!ep) {
>  				mlog(MLOG_VERBOSE | MLOG_BARE | MLOG_INOMAP,
>  				      _("end\n"));
>  			} else {
> @@ -533,7 +533,7 @@ cb_add(void *arg1,
>  	 * increment was based, dump it if it has changed since that
>  	 * original base dump.
>  	 */
> -	if (cb_resume && ! cb_inoinresumerange(ino)) {
> +	if (cb_resume && !cb_inoinresumerange(ino)) {
>  		if (ltime >= cb_resumetime) {
>  			changed = BOOL_TRUE;
>  		} else {
> @@ -645,7 +645,7 @@ cb_inoinresumerange(xfs_ino_t ino)
>  
>  	for (streamix = 0; streamix < cb_resumerangecnt; streamix++) {
>  		register drange_t *rp = &cb_resumerangep[streamix];
> -		if (! (rp->dr_begin.sp_flags & STARTPT_FLAGS_END)
> +		if (!(rp->dr_begin.sp_flags & STARTPT_FLAGS_END)
>  		     &&
>  		     ino >= rp->dr_begin.sp_ino
>  		     &&
> @@ -670,7 +670,7 @@ cb_inoresumed(xfs_ino_t ino)
>  
>  	for (streamix = 0; streamix < cb_resumerangecnt; streamix++) {
>  		drange_t *rp = &cb_resumerangep[streamix];
> -		if (! (rp->dr_begin.sp_flags & STARTPT_FLAGS_END)
> +		if (!(rp->dr_begin.sp_flags & STARTPT_FLAGS_END)
>  		     &&
>  		     ino == rp->dr_begin.sp_ino
>  		     &&
> @@ -1397,7 +1397,7 @@ inomap_get_gen(void *contextp, xfs_ino_t ino, gen_t *gen)
>  	i2gsegp = &inomap.i2gmap[inomap_addr2segix(addrp)];
>  
>  	relino = ino - segp->base;
> -	if (! (i2gsegp->s_valid & ((uint64_t)1 << relino)))
> +	if (!(i2gsegp->s_valid & ((uint64_t)1 << relino)))
>  		return 1;
>  
>  	*gen = i2gsegp->s_gen[relino];
> diff --git a/dump/var.c b/dump/var.c
> index 440e42d..3f33fab 100644
> --- a/dump/var.c
> +++ b/dump/var.c
> @@ -50,7 +50,7 @@ var_create(void)
>  		p++;
>  		if (*p == '/') {
>  			*p = '\0';
> -			if (! var_create_component(path))
> +			if (!var_create_component(path))
>  				return;
>  			*p = '/';
>  		}
> @@ -132,14 +132,14 @@ var_skip_recurse(char *base, void (*cb)(xfs_ino_t ino))
>  	      "excluding %s from dump\n",
>  	      base);
>  
> -	(* cb)(statbuf.st_ino);
> +	(*cb)(statbuf.st_ino);
>  
>  	if ((statbuf.st_mode & S_IFMT) != S_IFDIR) {
>  		return;
>  	}
>  
>  	dirp = opendir(base);
> -	if (! dirp) {
> +	if (!dirp) {
>  		mlog(MLOG_NORMAL, _(
>  		      "unable to open directory %s\n"),
>  		      base);
> diff --git a/inventory/inv_api.c b/inventory/inv_api.c
> index a8f65ff..d31c9ae 100644
> --- a/inventory/inv_api.c
> +++ b/inventory/inv_api.c
> @@ -184,7 +184,7 @@ inv_writesession_open(
>  	assert (forwhat != INV_SEARCH_ONLY);
>  	assert (fd > 0);
>  
> -	if (! (tok->d_update_flag & FSTAB_UPDATED)) {
> +	if (!(tok->d_update_flag & FSTAB_UPDATED)) {
>  		if (fstab_put_entry(fsid, mntpt, devpath, forwhat) < 0) {
>  		       mlog(MLOG_NORMAL | MLOG_INV, _(
>  				"INV: put_fstab_entry failed.\n"));
> @@ -322,7 +322,7 @@ inv_stream_open(
>  	if (stobj_get_sessinfo(tok, &seshdr, &ses) <= 0)
>  		err = BOOL_TRUE;
>  
> -	if ((! err)  && ses.s_cur_nstreams < ses.s_max_nstreams) {
> +	if ((!err)  && ses.s_cur_nstreams < ses.s_max_nstreams) {
>  		/* this is where this stream header will be written to */
>  		stok->md_stream_off = (off64_t) (sizeof(invt_stream_t) *
>  					         ses.s_cur_nstreams)
> @@ -333,14 +333,14 @@ inv_stream_open(
>  		if (PUT_REC_NOLOCK(fd, &ses, sizeof(ses),
>  				     tok->sd_session_off) < 0)
>  			err = BOOL_TRUE;
> -	} else if (! err) {
> +	} else if (!err) {
>  		mlog (MLOG_NORMAL, _(
>  		       "INV: cant create more than %d streams."
>  		       " Max'd out..\n"), ses.s_cur_nstreams);
>  		err = BOOL_TRUE;
>  	}
>  
> -	if (! err) {
> +	if (!err) {
>  		stream.st_firstmfile = stream.st_lastmfile =
>  			               stok->md_stream_off;
>  
> @@ -1018,7 +1018,7 @@ inv_getopt(int argc, char **argv, invt_pr_ctx_t *prctx)
>  		rval |= I_IERR;
>  	}
>  	else if ((rval & I_IFOUND) && !(rval & I_IERR) && fs
> -		 && ! prctx->fstab && ! prctx->invcheck) {
> +		 && !prctx->fstab && !prctx->invcheck) {
>  		inv_idbtoken_t tok;
>  
>  		/* A filesystem could be backed up, mkfs'ed then restored
> @@ -1101,8 +1101,8 @@ inv_DEBUG_print(int argc, char **argv)
>  	/* If user didnt indicate -i option, we can't do anything */
>  	rval = inv_getopt(argc, argv, &prctx);
>  
> -	if (!prctx.invcheck && ! prctx.fstab) {
> -		if (! (rval & I_IFOUND)) {
> +	if (!prctx.invcheck && !prctx.fstab) {
> +		if (!(rval & I_IFOUND)) {
>  			return BOOL_TRUE;
>  		} else if (rval & I_IERR || rval & I_IDONE) {
>  			return BOOL_FALSE;
> @@ -1115,7 +1115,7 @@ inv_DEBUG_print(int argc, char **argv)
>  	if (fd >= 0) {
>  		 if (prctx.fstab) {
>  			 fstab_DEBUG_print(arr, numfs);
> -			 if (! prctx.invidx)
> +			 if (!prctx.invidx)
>  				 return BOOL_FALSE;
>  		 }
>  
> diff --git a/inventory/inv_fstab.c b/inventory/inv_fstab.c
> index bc56f30..b115eb8 100644
> --- a/inventory/inv_fstab.c
> +++ b/inventory/inv_fstab.c
> @@ -215,7 +215,7 @@ fstab_get_fname(void *pred,
>  			}
>  		}
>  #ifdef INVT_DEBUG
> -		if (! uuidp)
> +		if (!uuidp)
>  			mlog(MLOG_DEBUG | MLOG_INV,"INV: get_fname: unable to find %s"
>  			      " in the inventory\n", (char *)pred);
>  #endif
> @@ -224,7 +224,7 @@ fstab_get_fname(void *pred,
>  		uuidp = (uuid_t *)pred;
>  	}
>  
> -	if (! uuidp)
> +	if (!uuidp)
>  		return -1;
>  
>  	uuid_unparse(*uuidp, uuidstr);
> diff --git a/inventory/inv_idx.c b/inventory/inv_idx.c
> index a54cfd7..af94b09 100644
> --- a/inventory/inv_idx.c
> +++ b/inventory/inv_idx.c
> @@ -556,4 +556,3 @@ DEBUG_displayallsessions(int fd, invt_seshdr_t *hdr, uint ref,
>  
>  	return 0;
>  }
> -
> diff --git a/inventory/inv_mgr.c b/inventory/inv_mgr.c
> index c78e64e..84c72f3 100644
> --- a/inventory/inv_mgr.c
> +++ b/inventory/inv_mgr.c
> @@ -310,8 +310,8 @@ search_invt(
>  					continue;
>  			}
>  
> -			found = (* do_chkcriteria)(fd, &harr[j], arg, buf);
> -			if (! found) continue;
> +			found = (*do_chkcriteria)(fd, &harr[j], arg, buf);
> +			if (!found) continue;
>  
>  			/* we found what we need; just return */
>  			INVLOCK(fd, LOCK_UN);
> diff --git a/inventory/inv_oref.c b/inventory/inv_oref.c
> index ba5061f..183b8c0 100644
> --- a/inventory/inv_oref.c
> +++ b/inventory/inv_oref.c
> @@ -38,7 +38,7 @@ oref_resolve_(
>  
>  	type &= INVT_OTYPE_MASK;
>  	assert(type);
> -	assert(! OREF_ISRESOLVED(obj, INVT_OTYPE_MASK));
> +	assert(!OREF_ISRESOLVED(obj, INVT_OTYPE_MASK));
>  
>  	switch (type) {
>  	      case INVT_OTYPE_INVIDX:
> @@ -114,7 +114,7 @@ oref_resolve_entries(
>  	if (OREF_ISRESOLVED(obj, INVT_RES_ENTRIES))
>  		return INV_OK;
>  
> -	assert(! OREF_ISRESOLVED(INVT_OTYPE_STOBJ));
> +	assert(!OREF_ISRESOLVED(INVT_OTYPE_STOBJ));
>  
>  	if (OREF_ISRESOLVED(INVT_OTYPE_INVIDX)) {
>  		invt_entry_t *ent;
> @@ -202,7 +202,7 @@ oref_sync(
>  		break;
>  
>  	      case INVT_RES_ENTRIES:
> -		assert(! OREF_ISRESOLVED(obj, INVT_OTYPE_STOBJ));
> +		assert(!OREF_ISRESOLVED(obj, INVT_OTYPE_STOBJ));
>  
>  		rval = PUT_REC_NOLOCK(obj->fd,
>  				      OREF_ENTRIES(obj),
> @@ -235,7 +235,7 @@ oref_sync_append(
>  
>  	switch (type) {
>  	      case INVT_RES_ENTRIES:
> -		assert(! OREF_ISRESOLVED(obj, INVT_OTYPE_STOBJ));
> +		assert(!OREF_ISRESOLVED(obj, INVT_OTYPE_STOBJ));
>  
>  		rval = PUT_REC_NOLOCK(obj->fd,
>  				      entry,
> @@ -317,7 +317,7 @@ oref_resolve(
>  	invt_oref_t	*stobj;
>  	int		index;
>  
> -	assert(! OREF_ISRESOLVED(invidx, INVT_OTYPE_MASK));
> +	assert(!OREF_ISRESOLVED(invidx, INVT_OTYPE_MASK));
>  
>  	OREF_SET_TYPE(invidx, INVT_OTYPE_INVIDX);
>  
> diff --git a/inventory/inv_stobj.c b/inventory/inv_stobj.c
> index 6339e4e..f836236 100644
> --- a/inventory/inv_stobj.c
> +++ b/inventory/inv_stobj.c
> @@ -233,12 +233,12 @@ stobj_split(invt_idxinfo_t *idx, int fd, invt_sescounter_t *sescnt,
>  		if (GET_REC_NOLOCK(fd, &session, sizeof(invt_session_t),
>  			     harr[i].sh_sess_off) < 0)
>  			return -1;
> -		if (! stobj_pack_sessinfo(fd, &session, &harr[i], &bufpp,
> +		if (!stobj_pack_sessinfo(fd, &session, &harr[i], &bufpp,
>  					   &bufszp))
>  			return -1;
>  		/* Now we need to put this in the new StObj. So, first
>  		   unpack it. */
> -		if (! stobj_unpack_sessinfo(bufpp, bufszp, &sesinfo))
> +		if (!stobj_unpack_sessinfo(bufpp, bufszp, &sesinfo))
>  			return -1;
>  
>  		/* There is no chance of a recursion here */
> @@ -247,7 +247,7 @@ stobj_split(invt_idxinfo_t *idx, int fd, invt_sescounter_t *sescnt,
>  			return -1;
>  
>  		/* Now delete that session from this StObj */
> -		if (! stobj_delete_sessinfo(fd, sescnt, &session,
> +		if (!stobj_delete_sessinfo(fd, sescnt, &session,
>  					     &harr[i]))
>  			return -1;
>  		free(bufpp);
> @@ -638,7 +638,7 @@ stobj_put_mediafile(inv_stmtoken_t tok, invt_mediafile_t *mf)
>  	   last ino of the new mediafile. If this is the first mediafile, we
>  	   have to update the startino as well. Note that ino is a <ino,off>
>  	   tuple */
> -	if (! (mf->mf_flag & INVT_MFILE_INVDUMP)) {
> +	if (!(mf->mf_flag & INVT_MFILE_INVDUMP)) {
>  		if (stream.st_nmediafiles == 0)
>  			stream.st_startino = mf->mf_startino;
>  		stream.st_endino = mf->mf_endino;
> @@ -679,7 +679,7 @@ stobj_put_mediafile(inv_stmtoken_t tok, invt_mediafile_t *mf)
>  			return -1;
>  	}
>  
> -	if (! (mf->mf_flag & INVT_MFILE_INVDUMP)) {
> +	if (!(mf->mf_flag & INVT_MFILE_INVDUMP)) {
>  		tok->md_lastmfile = mf;
>  	} else {
>  		tok->md_lastmfile = NULL;
> @@ -886,7 +886,7 @@ stobj_getsession_bylabel(
>  		return -1;
>  
>  	/* now see if this is the one that caller is askin for */
> -	if (! STREQL(ses.s_label, (char *)seslabel)) {
> +	if (!STREQL(ses.s_label, (char *)seslabel)) {
>  		return BOOL_FALSE;
>  	}
>  
> @@ -1456,7 +1456,7 @@ DEBUG_sessionprint(inv_session_t *ses, uint ref, invt_pr_ctx_t *prctx)
>  		for (j = 0; j < ses->s_streams[i].st_nmediafiles; j++) {
>  			mfp = &ses->s_streams[i].st_mediafiles[j];
>  			if (moidsearch) {
> -				if (! mobj_eql(mfp, mobj))
> +				if (!mobj_eql(mfp, mobj))
>  					continue;
>  			}
>  			printf("\t\t\tmedia file %d:", j);
> @@ -1475,7 +1475,7 @@ DEBUG_sessionprint(inv_session_t *ses, uint ref, invt_pr_ctx_t *prctx)
>  			printf("\t\t\t\tmfile size:\t%llu\n",
>  				(unsigned long long)mfp->m_size);
>  
> -			if (! mfp->m_isinvdump) {
> +			if (!mfp->m_isinvdump) {
>  				printf("\t\t\t\tmfile start:"
>  					"\tino %llu offset %lld\n",
>  					(unsigned long long)mfp->m_startino,
> diff --git a/inventory/testmain.c b/inventory/testmain.c
> index 90654cc..b0e6135 100644
> --- a/inventory/testmain.c
> +++ b/inventory/testmain.c
> @@ -139,7 +139,7 @@ delete_test(int n)
>  	uuid_to_string(&moid, &str, &stat);
>  	printf("Searching for Moid = %s\n", str);
>  	free(str);
> -	if (! inv_delete_mediaobj(&moid)) return -1;
> +	if (!inv_delete_mediaobj(&moid)) return -1;
>  
>  	return 1;
>  
> @@ -204,7 +204,7 @@ query_test(int level)
>  	if (level == -2) {
>  		printf("mount pt %s\n",sesfile);
>  		tok = inv_open(INV_BY_MOUNTPT, INV_SEARCH_ONLY, sesfile);
> -		if (! tok) return -1;
> +		if (!tok) return -1;
>  		idx_DEBUG_print (tok->d_invindex_fd);
>  		return 1;
>  	}
> @@ -213,7 +213,7 @@ query_test(int level)
>  		printf("\n\n\n----------------------------------\n"
>  		       "$ Searching fs %s\n", mnt_str[7-i]);
>  		tok = inv_open(INV_BY_MOUNTPT, INV_SEARCH_ONLY, mnt_str[7-i]);
> -		if (! tok) return -1;
> +		if (!tok) return -1;
>  
>  		prctx.index = i;
>  		if (level == -1)
> @@ -421,7 +421,7 @@ main(int argc, char *argv[])
>  
>  	mlog_init(argc, argv);
>  
> -	if (! inv_DEBUG_print(argc, argv))
> +	if (!inv_DEBUG_print(argc, argv))
>  		return 0;
>  
>  	optind = 1;
> diff --git a/invutil/cmenu.h b/invutil/cmenu.h
> index f3c205f..075bcf3 100644
> --- a/invutil/cmenu.h
> +++ b/invutil/cmenu.h
> @@ -44,18 +44,18 @@ typedef enum {
>  } alignment_t;
>  
>  typedef struct menu_ops_s {
> -    int (* op_delete) (WINDOW *win, node_t *current, node_t *list);
> -    int (* op_undelete) (WINDOW *win, node_t *current, node_t *list);
> -    int (* op_saveexit) (WINDOW *win, node_t *current, node_t *list);
> -    int (* op_select) (WINDOW *win, node_t *current, node_t *list);
> -    int (* op_collapse) (WINDOW *win, node_t *current, node_t *list);
> -    int (* op_expand) (WINDOW *win, node_t *current, node_t *list);
> -    int (* op_collapseall) (WINDOW *win, node_t *current, node_t *list);
> -    int (* op_expandall) (WINDOW *win, node_t *current, node_t *list);
> -    int (* op_highlight) (WINDOW *win, node_t *current, node_t *list);
> -    int (* op_unhighlight) (WINDOW *win, node_t *current, node_t *list);
> -    int (* op_commit) (WINDOW *win, node_t *current, node_t *list);
> -    int (* op_prune) (char *mountpt, uuid_t *uuidp, time32_t prunetime, node_t *node, node_t *list);
> +    int (*op_delete) (WINDOW *win, node_t *current, node_t *list);
> +    int (*op_undelete) (WINDOW *win, node_t *current, node_t *list);
> +    int (*op_saveexit) (WINDOW *win, node_t *current, node_t *list);
> +    int (*op_select) (WINDOW *win, node_t *current, node_t *list);
> +    int (*op_collapse) (WINDOW *win, node_t *current, node_t *list);
> +    int (*op_expand) (WINDOW *win, node_t *current, node_t *list);
> +    int (*op_collapseall) (WINDOW *win, node_t *current, node_t *list);
> +    int (*op_expandall) (WINDOW *win, node_t *current, node_t *list);
> +    int (*op_highlight) (WINDOW *win, node_t *current, node_t *list);
> +    int (*op_unhighlight) (WINDOW *win, node_t *current, node_t *list);
> +    int (*op_commit) (WINDOW *win, node_t *current, node_t *list);
> +    int (*op_prune) (char *mountpt, uuid_t *uuidp, time32_t prunetime, node_t *node, node_t *list);
>  } menu_ops_t;
>  
>  typedef struct {
> diff --git a/invutil/invutil.c b/invutil/invutil.c
> index a002d56..b6f2227 100644
> --- a/invutil/invutil.c
> +++ b/invutil/invutil.c
> @@ -760,7 +760,7 @@ CheckAndPruneStObjFile(bool_t checkonly,
>  	if (StObjhdr->sh_pruned)
>  	    prunedcount++;
>  
> -	if (! StObjhdr->sh_pruned) {
> +	if (!StObjhdr->sh_pruned) {
>  	    printf("            Session %d: %s %s",
>  		   sescount++,
>  		   StObjses->s_mountpt,
> diff --git a/restore/bag.c b/restore/bag.c
> index d35f8b8..4d60d1d 100644
> --- a/restore/bag.c
> +++ b/restore/bag.c
> @@ -46,9 +46,9 @@ bag_insert(bag_t *bagp,
>  	register bagelem_t *nextp;
>  	register bagelem_t *prevp;
>  
> -	assert(! newp->be_loaded);
> +	assert(!newp->be_loaded);
>  	newp->be_loaded = BOOL_TRUE;
> -	assert(! newp->be_bagp);
> +	assert(!newp->be_bagp);
>  	newp->be_bagp = bagp;
>  
>  	newp->be_key = key;
> @@ -117,7 +117,7 @@ bag_find(bag_t *bagp,
>  	      p = p->be_nextp)
>  		;
>  
> -	if (! p || p->be_key != key) {
> +	if (!p || p->be_key != key) {
>  		*payloadpp = 0;
>  		return 0;
>  	} else {
> @@ -133,7 +133,7 @@ void
>  bagiter_init(bag_t *bagp, bagiter_t *iterp)
>  {
>  	iterp->bi_bagp = bagp;
> -	if (! bagp->b_headp) {
> +	if (!bagp->b_headp) {
>  		iterp->bi_nextp = 0;
>  		return;
>  	}
> @@ -148,7 +148,7 @@ bagiter_next(bagiter_t *iterp, void **payloadpp)
>  
>  	/* termination condition
>  	 */
> -	if (! iterp->bi_nextp) {
> +	if (!iterp->bi_nextp) {
>  		*payloadpp = 0;
>  		return 0;
>  	}
> diff --git a/restore/content.c b/restore/content.c
> index cc68472..5d5ffe0 100644
> --- a/restore/content.c
> +++ b/restore/content.c
> @@ -920,10 +920,10 @@ content_init(int argc, char *argv[], size64_t vmsz)
>  	 */
>  	assert(sizeof(pers_desc_t) <= PERS_DESCSZ);
>  	assert(PERS_DESCSZ <= pgsz);
> -	assert(! (pgsz % PERS_DESCSZ));
> +	assert(!(pgsz % PERS_DESCSZ));
>  	assert(sizeof(extattrhdr_t) == EXTATTRHDR_SZ);
>  
> -	assert(! (perssz % pgsz));
> +	assert(!(perssz % pgsz));
>  
>  	assert(SYNC_INIT == 0);
>  
> @@ -981,7 +981,7 @@ content_init(int argc, char *argv[], size64_t vmsz)
>  			existpr = BOOL_TRUE;
>  			break;
>  		case GETOPT_NEWER:
> -			if (! optarg || optarg[0] == '-') {
> +			if (!optarg || optarg[0] == '-') {
>  				mlog(MLOG_NORMAL | MLOG_ERROR, _(
>  				      "-%c argument missing\n"),
>  				      c);
> @@ -1007,7 +1007,7 @@ content_init(int argc, char *argv[], size64_t vmsz)
>  			ownerpr = BOOL_TRUE;
>  			break;
>  		case GETOPT_WORKSPACE:
> -			if (! optarg || optarg[0] == '-') {
> +			if (!optarg || optarg[0] == '-') {
>  				mlog(MLOG_NORMAL | MLOG_ERROR, _(
>  				      "-%c argument missing\n"),
>  				      c);
> @@ -1017,7 +1017,7 @@ content_init(int argc, char *argv[], size64_t vmsz)
>  			if (optarg[0] != '/') {
>  				tranp->t_hkdir = path_reltoabs(optarg,
>  								homedir);
> -				if (! tranp->t_hkdir) {
> +				if (!tranp->t_hkdir) {
>  					mlog(MLOG_NORMAL | MLOG_ERROR, _(
>  					      "-%c argument %s is an "
>  					      "invalid pathname\n"),
> @@ -1068,7 +1068,7 @@ content_init(int argc, char *argv[], size64_t vmsz)
>  				usage();
>  				return BOOL_FALSE;
>  			}
> -			if (! optarg || optarg[0] == '-') {
> +			if (!optarg || optarg[0] == '-') {
>  				mlog(MLOG_NORMAL | MLOG_ERROR, _(
>  				      "-%c argument missing\n"),
>  				      c);
> @@ -1097,7 +1097,7 @@ content_init(int argc, char *argv[], size64_t vmsz)
>  				usage();
>  				return BOOL_FALSE;
>  			}
> -			if (! optarg || optarg[0] == '-') {
> +			if (!optarg || optarg[0] == '-') {
>  				mlog(MLOG_NORMAL | MLOG_ERROR, _(
>  				      "-%c argument missing\n"),
>  				      c);
> @@ -1115,7 +1115,7 @@ content_init(int argc, char *argv[], size64_t vmsz)
>  			break;
>  		case GETOPT_SUBTREE:
>  		case GETOPT_NOSUBTREE:
> -			if (! optarg
> +			if (!optarg
>  			     ||
>  			     optarg[0] == 0
>  			     ||
> @@ -1134,7 +1134,7 @@ content_init(int argc, char *argv[], size64_t vmsz)
>  				return BOOL_FALSE;
>  			}
>  			stcnt++;
> -			if (! firststsenseprvalpr) {
> +			if (!firststsenseprvalpr) {
>  				if (c == GETOPT_SUBTREE) {
>  					firststsensepr = BOOL_TRUE;
>  				} else {
> @@ -1150,7 +1150,7 @@ content_init(int argc, char *argv[], size64_t vmsz)
>  			stsz &= ~(STDESCALIGN - 1);
>  			break;
>  		case GETOPT_INTERACTIVE:
> -			if (! dlog_allowed()) {
> +			if (!dlog_allowed()) {
>  				mlog(MLOG_NORMAL, _(
>  				      "-%c unavailable: no /dev/tty\n"),
>  				      GETOPT_INTERACTIVE);
> @@ -1165,7 +1165,7 @@ content_init(int argc, char *argv[], size64_t vmsz)
>  			restoredmpr = BOOL_TRUE;
>  			break;
>  		case GETOPT_ALERTPROG:
> -			if (! optarg || optarg[0] == '-') {
> +			if (!optarg || optarg[0] == '-') {
>  				mlog(MLOG_NORMAL | MLOG_ERROR, _(
>  					"-%c argument missing\n"),
>  					c);
> @@ -1222,7 +1222,7 @@ content_init(int argc, char *argv[], size64_t vmsz)
>  	 * appear between the last lettered argument and the destination
>  	 * directory pathname.
>  	 */
> -	if (optind < argc && ! strcmp(argv[optind ], "-")) {
> +	if (optind < argc && !strcmp(argv[optind ], "-")) {
>  		optind++;
>  	}
>  
> @@ -1230,14 +1230,14 @@ content_init(int argc, char *argv[], size64_t vmsz)
>  	 * required if table-of-contents display, or if a resumed restore
>  	 * or a delta restore.
>  	 */
> -	if (! tranp->t_toconlypr) {
> +	if (!tranp->t_toconlypr) {
>  		if (optind >= argc) {
>  			dstdir = 0;
>  		} else {
>  			if (argv[optind][0] != '/') {
>  				dstdir = path_reltoabs(argv[optind],
>  							homedir);
> -				if (! dstdir) {
> +				if (!dstdir) {
>  					mlog(MLOG_NORMAL | MLOG_ERROR, _(
>  					      "destination directory %s "
>  					      "invalid pathname\n"),
> @@ -1292,11 +1292,11 @@ content_init(int argc, char *argv[], size64_t vmsz)
>  	 * if this is toconly, modify the housekeeping dir's name with
>  	 * the pid.
>  	 */
> -	if (! tranp->t_hkdir) {
> +	if (!tranp->t_hkdir) {
>  		if (tranp->t_toconlypr) {
>  			tranp->t_hkdir = homedir;
>  		} else {
> -			if (! dstdir) {
> +			if (!dstdir) {
>  				mlog(MLOG_NORMAL | MLOG_ERROR, _(
>  				      "destination directory "
>  				      "not specified\n"));
> @@ -1335,7 +1335,7 @@ content_init(int argc, char *argv[], size64_t vmsz)
>  
>  	/* build a full pathname to pers. state file
>  	 */
> -	assert(! perspath);
> +	assert(!perspath);
>  	perspath = open_pathalloc(tranp->t_hkdir, persname, 0);
>  
>  	/* open, creating if non-existent
> @@ -1367,7 +1367,7 @@ content_init(int argc, char *argv[], size64_t vmsz)
>  
>  	/* but first setup or verify the on-disk format information
>  	 */
> -	if (! persp->a.valpr) {
> +	if (!persp->a.valpr) {
>  		/* this is the first restore session
>  		 */
>  		persp->v.housekeeping_magic = HOUSEKEEPING_MAGIC;
> @@ -1407,8 +1407,8 @@ content_init(int argc, char *argv[], size64_t vmsz)
>  		}
>  	}
>  
> -	if (! persp->a.valpr) {
> -		if (! dstdir) {
> +	if (!persp->a.valpr) {
> +		if (!dstdir) {
>  			mlog(MLOG_NORMAL | MLOG_ERROR, _(
>  			      "destination directory not specified\n"));
>  			usage();
> @@ -1438,8 +1438,8 @@ content_init(int argc, char *argv[], size64_t vmsz)
>  			usage();
>  			return BOOL_FALSE;
>  		}
> -	} else if (! persp->s.valpr) {
> -		if (! cumpr) {
> +	} else if (!persp->s.valpr) {
> +		if (!cumpr) {
>  			mlog(MLOG_NORMAL | MLOG_ERROR, _(
>  			      "must rm -rf %s prior to noncumulative restore\n"),
>  			      tranp->t_hkdir);
> @@ -1505,7 +1505,7 @@ content_init(int argc, char *argv[], size64_t vmsz)
>  			return BOOL_FALSE;
>  		}
>  	} else {
> -		if (! resumepr && ! sesscpltpr) {
> +		if (!resumepr && !sesscpltpr) {
>  			mlog(MLOG_NORMAL | MLOG_ERROR, _(
>  			      "-%c option required to resume "
>  			      "or "
> @@ -1580,7 +1580,7 @@ content_init(int argc, char *argv[], size64_t vmsz)
>  			      GETOPT_SETDM);
>  			return BOOL_FALSE;
>  		}
> -		if (! restoreextattrpr &&
> +		if (!restoreextattrpr &&
>  		       persp->a.restoreextattrpr != restoreextattrpr) {
>  			mlog(MLOG_NORMAL | MLOG_ERROR, _(
>  			     "-%c cannot reset flag from previous restore\n"),
> @@ -1616,15 +1616,15 @@ content_init(int argc, char *argv[], size64_t vmsz)
>  			return BOOL_FALSE;
>  		}
>  		ok = dirattr_init(tranp->t_hkdir, BOOL_TRUE, (uint64_t)0);
> -		if (! ok) {
> +		if (!ok) {
>  			return BOOL_FALSE;
>  		}
>  		ok = namreg_init(tranp->t_hkdir, BOOL_TRUE, (uint64_t)0);
> -		if (! ok) {
> +		if (!ok) {
>  			return BOOL_FALSE;
>  		}
>  		ok = inomap_sync_pers(tranp->t_hkdir);
> -		if (! ok) {
> +		if (!ok) {
>  			return BOOL_FALSE;
>  		}
>  
> @@ -1642,7 +1642,7 @@ content_init(int argc, char *argv[], size64_t vmsz)
>  				tranp->t_toconlypr,
>  				fullpr,
>  				persp->a.dstdirisxfspr);
> -		if (! ok) {
> +		if (!ok) {
>  			return BOOL_FALSE;
>  		}
>  		rv = finalize(path1, path2);
> @@ -1664,13 +1664,13 @@ content_init(int argc, char *argv[], size64_t vmsz)
>  	/* for the three cases, calculate old and new mapping params
>  	 * and wipe partial state
>  	 */
> -	if (! persp->a.valpr) {
> +	if (!persp->a.valpr) {
>  		stpgcnt = 0;
>  		newstpgcnt = (stsz + pgmask) / pgsz;
>  		descpgcnt = 0;
>  		memset((void *)&persp->a, 0,
>  			sizeof(pers_t) - offsetofmember(pers_t, a));
> -	} else if (! persp->s.valpr) {
> +	} else if (!persp->s.valpr) {
>  		stpgcnt = persp->a.stpgcnt;
>  		newstpgcnt = stpgcnt;
>  		descpgcnt = 0;
> @@ -1689,13 +1689,13 @@ content_init(int argc, char *argv[], size64_t vmsz)
>  	/* unmap temp mapping of hdr, truncate, and remap hdr/subtrees
>  	 */
>  	rval = munmap((void *)persp, perssz);
> -	assert(! rval);
> +	assert(!rval);
>  	rval = ftruncate(tranp->t_persfd, (off_t)perssz
>  					   +
>  					   (off_t)(stpgcnt + descpgcnt)
>  					   *
>  					   (off_t)pgsz);
> -	assert(! rval);
> +	assert(!rval);
>  	stpgcnt = newstpgcnt;
>  	persp = (pers_t *) mmap_autogrow(perssz + stpgcnt * pgsz,
>  				   tranp->t_persfd, 0);
> @@ -1710,7 +1710,7 @@ content_init(int argc, char *argv[], size64_t vmsz)
>  	/* if first restore session, record cmd line args and subtrees
>  	 * and start time.
>  	 */
> -	if (! persp->a.valpr) {
> +	if (!persp->a.valpr) {
>  		stdesc_t *stdescp;
>  
>  		strcpy(persp->a.dstdir, dstdir);
> @@ -1735,7 +1735,7 @@ content_init(int argc, char *argv[], size64_t vmsz)
>  			persp->a.newertime = newertime;
>  		}
>  		persp->a.restoredmpr = restoredmpr;
> -		if (! persp->a.dstdirisxfspr) {
> +		if (!persp->a.dstdirisxfspr) {
>  			restoreextattrpr = BOOL_FALSE;
>  		}
>  		persp->a.restoreextattrpr = restoreextattrpr;
> @@ -1778,7 +1778,7 @@ content_init(int argc, char *argv[], size64_t vmsz)
>  	 * we don't intend to restore extended attributes
>  	 */
>  	ok = extattr_init(drivecnt);
> -	if (! ok) {
> +	if (!ok) {
>  		return BOOL_FALSE;
>  	}
>  
> @@ -1807,7 +1807,7 @@ content_init(int argc, char *argv[], size64_t vmsz)
>  	 * referenced ONLY via the macros provided; the descriptors will be
>  	 * occasionally remapped, causing the ptr to change.
>  	 */
> -	assert(! descp);
> +	assert(!descp);
>  	if (descpgcnt) {
>  		descp = (pers_desc_t *) mmap_autogrow(descpgcnt * pgsz,
>  						tranp->t_persfd,
> @@ -1842,7 +1842,7 @@ content_init(int argc, char *argv[], size64_t vmsz)
>  	 */
>  	if (persp->a.valpr && persp->s.valpr) {
>  		ok = dirattr_init(tranp->t_hkdir, BOOL_TRUE, (uint64_t)0);
> -		if (! ok) {
> +		if (!ok) {
>  			return BOOL_FALSE;
>  		}
>  		tranp->t_dirattrinitdonepr = BOOL_TRUE;
> @@ -1854,7 +1854,7 @@ content_init(int argc, char *argv[], size64_t vmsz)
>  	 */
>  	if (persp->a.valpr) {
>  		ok = namreg_init(tranp->t_hkdir, BOOL_TRUE, (uint64_t)0);
> -		if (! ok) {
> +		if (!ok) {
>  			return BOOL_FALSE;
>  		}
>  		tranp->t_namreginitdonepr = BOOL_TRUE;
> @@ -1865,7 +1865,7 @@ content_init(int argc, char *argv[], size64_t vmsz)
>  	 * determine if full init needed instead.
>  	 */
>  	ok = inomap_sync_pers(tranp->t_hkdir);
> -	if (! ok) {
> +	if (!ok) {
>  		return BOOL_FALSE;
>  	}
>  
> @@ -1889,7 +1889,7 @@ content_init(int argc, char *argv[], size64_t vmsz)
>  				tranp->t_toconlypr,
>  				fullpr,
>  				persp->a.dstdirisxfspr);
> -		if (! ok) {
> +		if (!ok) {
>  			return BOOL_FALSE;
>  		}
>  		tranp->t_treeinitdonepr = BOOL_TRUE;
> @@ -2108,7 +2108,7 @@ content_stream_restore(ix_t thrdix)
>  						    scrhdrp);
>  			}
>  		} else if (tranp->t_reqdumplabvalpr) {
> -			if (! strncmp(tranp->t_reqdumplab,
> +			if (!strncmp(tranp->t_reqdumplab,
>  					grhdrp->gh_dumplabel,
>  					sizeof(grhdrp->gh_dumplabel))) {
>  				matchpr = BOOL_TRUE;
> @@ -2158,20 +2158,20 @@ content_stream_restore(ix_t thrdix)
>  			Media_end(Mediap);
>  			return mlog_exit(EXIT_NORMAL, RV_INTR);
>  		}
> -		if (! matchpr) {
> +		if (!matchpr) {
>  			Media_end(Mediap);
>  			uuid_copy(lastdumprejectedid, grhdrp->gh_dumpid);
>  			tranp->t_sync2 = SYNC_INIT;
> -			if (! dlog_allowed()
> +			if (!dlog_allowed()
>  			     ||
> -			     (! (dcaps & DRIVE_CAP_FILES)
> +			     (!(dcaps & DRIVE_CAP_FILES)
>  			       &&
> -			       ! (dcaps & DRIVE_CAP_REMOVABLE))) {
> +			       !(dcaps & DRIVE_CAP_REMOVABLE))) {
>  				return mlog_exit(EXIT_NORMAL, RV_QUIT);
>  			}
>  			continue;
>  		}
> -		if (! dumpcompat(resumepr, level, *baseidp, BOOL_TRUE)) {
> +		if (!dumpcompat(resumepr, level, *baseidp, BOOL_TRUE)) {
>  			Media_end(Mediap);
>  			return mlog_exit(EXIT_ERROR, RV_COMPAT);
>  		}
> @@ -2182,9 +2182,9 @@ content_stream_restore(ix_t thrdix)
>  
>  		/* don't look at the online inventory if the input is piped
>  		 */
> -		if (! drivep->d_isnamedpipepr
> +		if (!drivep->d_isnamedpipepr
>  		     &&
> -		     ! drivep->d_isunnamedpipepr) {
> +		     !drivep->d_isunnamedpipepr) {
>  			ok = inv_get_session_byuuid(NULL,
>  						    &grhdrp->gh_dumpid,
>  						    &sessp);
> @@ -2310,7 +2310,7 @@ content_stream_restore(ix_t thrdix)
>  		}
>  		tranp->t_sync3 = SYNC_BUSY;
>  		unlock();
> -		if (! tranp->t_dirattrinitdonepr) {
> +		if (!tranp->t_dirattrinitdonepr) {
>  			mlog(MLOG_TRACE,
>  			      "initializing directory attributes registry\n");
>  			mlog(MLOG_NITTY,
> @@ -2319,14 +2319,14 @@ content_stream_restore(ix_t thrdix)
>  			ok = dirattr_init(tranp->t_hkdir,
>  					   BOOL_FALSE,
>  					   scrhdrp->cih_inomap_dircnt);
> -			if (! ok) {
> +			if (!ok) {
>  				Media_end(Mediap);
>  				return mlog_exit(EXIT_ERROR, RV_ERROR);
>  			}
>  			tranp->t_dirattrinitdonepr = BOOL_TRUE;
>  		}
>  
> -		if (! tranp->t_namreginitdonepr) {
> +		if (!tranp->t_namreginitdonepr) {
>  			mlog(MLOG_TRACE,
>  			      "initializing directory entry name registry\n");
>  			ok = namreg_init(tranp->t_hkdir,
> @@ -2334,21 +2334,21 @@ content_stream_restore(ix_t thrdix)
>  					  scrhdrp->cih_inomap_dircnt
>  					  +
>  					  scrhdrp->cih_inomap_nondircnt);
> -			if (! ok) {
> +			if (!ok) {
>  				Media_end(Mediap);
>  				return mlog_exit(EXIT_ERROR, RV_ERROR);
>  			}
>  			tranp->t_namreginitdonepr = BOOL_TRUE;
>  		}
>  
> -		if (! tranp->t_treeinitdonepr) {
> +		if (!tranp->t_treeinitdonepr) {
>  			bool_t fullpr;
>  
>  			fullpr = (scrhdrp->cih_level
>  				   ==
>  				   0)
>  				 &&
> -				 ! (scrhdrp->cih_dumpattr
> +				 !(scrhdrp->cih_dumpattr
>  				    &
>  				    CIH_DUMPATTR_RESUME);
>  
> @@ -2369,7 +2369,7 @@ content_stream_restore(ix_t thrdix)
>  					persp->a.dstdirisxfspr,
>  					grhdrp->gh_version,
>  					tranp->t_truncategenpr);
> -			if (! ok) {
> +			if (!ok) {
>  				Media_end(Mediap);
>  				return mlog_exit(EXIT_ERROR, RV_ERROR);
>  			}
> @@ -2377,7 +2377,7 @@ content_stream_restore(ix_t thrdix)
>  
>  		} else {
>  			ok = tree_check_dump_format(grhdrp->gh_version);
> -			if (! ok) {
> +			if (!ok) {
>  				Media_end(Mediap);
>  				return mlog_exit(EXIT_ERROR, RV_ERROR);
>  			}
> @@ -2621,11 +2621,11 @@ content_complete(void)
>  	bool_t completepr;
>  	time_t elapsed;
>  
> -	if (! persp) {
> +	if (!persp) {
>  		completepr = BOOL_TRUE;
> -	} else if (! persp->a.valpr) {
> +	} else if (!persp->a.valpr) {
>  		completepr =  BOOL_TRUE;
> -	} else if (! persp->s.valpr) {
> +	} else if (!persp->s.valpr) {
>  		completepr =  BOOL_TRUE;
>  	} else {
>  		completepr = BOOL_FALSE;
> @@ -2688,7 +2688,7 @@ content_complete(void)
>  		persp->s.accumtime = elapsed;
>  	}
>  
> -	if (! persp->a.valpr) {
> +	if (!persp->a.valpr) {
>  		wipepersstate();
>  		persp = 0;
>  	}
> @@ -2720,7 +2720,7 @@ content_statline(char **linespp[])
>  	}
>  	*linespp = statline;
>  
> -	if (! persp->s.stat_valpr) {
> +	if (!persp->s.stat_valpr) {
>  		return 0;
>  	}
>  
> @@ -2735,8 +2735,8 @@ content_statline(char **linespp[])
>  	now = time(0);
>  	tmp = localtime(&now);
>  
> -	if (! persp->s.dirdonepr) {
> -		if (! tranp->t_dircnt) {
> +	if (!persp->s.dirdonepr) {
> +		if (!tranp->t_dircnt) {
>  			return 0;
>  		}
>  
> @@ -2979,7 +2979,7 @@ applydirdump(drive_t *drivep,
>  	       :
>  	       BOOL_FALSE;
>  
> -	if (! persp->s.marknorefdonepr) {
> +	if (!persp->s.marknorefdonepr) {
>  		tree_marknoref();
>  		persp->s.marknorefdonepr = BOOL_TRUE;
>  	}
> @@ -2991,7 +2991,7 @@ applydirdump(drive_t *drivep,
>  		      "was not applied\n"));
>  	}
>  
> -	if (! persp->s.dirdonepr) {
> +	if (!persp->s.dirdonepr) {
>  		rv_t rv;
>  		dah_t dah;
>  
> @@ -3291,18 +3291,18 @@ treepost(char *path1, char *path2)
>  	 */
>  	mlog(MLOG_DEBUG | MLOG_TREE,
>  	      "checking tree for consistency\n");
> -	if (! tree_chk()) {
> +	if (!tree_chk()) {
>  		return RV_CORE;
>  	}
>  #endif /* TREE_CHK */
>  
>  	/* adjust ref flags based on what dirs were dumped
>  	 */
> -	if (! persp->s.adjrefdonepr) {
> +	if (!persp->s.adjrefdonepr) {
>  		mlog(MLOG_DEBUG | MLOG_TREE,
>  		      "adjusting dirent ref flags\n");
>  		ok = tree_adjref();
> -		if (! ok) {
> +		if (!ok) {
>  			return RV_INTR;
>  		}
>  		persp->s.adjrefdonepr = BOOL_TRUE;
> @@ -3312,7 +3312,7 @@ treepost(char *path1, char *path2)
>  	 * so only inos selected by subtree or interactive cmds will
>  	 * be present in inomap.
>  	 */
> -	if (! persp->s.inomapsanitizedonepr) {
> +	if (!persp->s.inomapsanitizedonepr) {
>  		if (persp->a.interpr
>  		     ||
>  		     (persp->a.firststsenseprvalpr
> @@ -3325,7 +3325,7 @@ treepost(char *path1, char *path2)
>  
>  	/* apply subtree selections
>  	 */
> -	if (! persp->s.stdonepr) {
> +	if (!persp->s.stdonepr) {
>  		ix_t stix;
>  		stdesc_t *stdescp;
>  
> @@ -3338,7 +3338,7 @@ treepost(char *path1, char *path2)
>  		 */
>  		if ((persp->a.interpr
>  		       &&
> -		       (! persp->a.firststsenseprvalpr
> +		       (!persp->a.firststsenseprvalpr
>  		         ||
>  		         persp->a.firststsensepr))
>  		     ||
> @@ -3363,7 +3363,7 @@ treepost(char *path1, char *path2)
>  						stdescp->std_nextoff)) {
>  			ok = tree_subtree_parse(stdescp->std_sensepr,
>  						 stdescp->std_path);
> -			if (! ok) {
> +			if (!ok) {
>  				mlog(MLOG_NORMAL | MLOG_ERROR, _(
>  				      "subtree argument %s invalid\n"),
>  				      stdescp->std_path);
> @@ -3375,10 +3375,10 @@ treepost(char *path1, char *path2)
>  
>  	/* next engage interactive subtree selection
>  	 */
> -	if (! persp->s.interdonepr) {
> +	if (!persp->s.interdonepr) {
>  		if (persp->a.interpr) {
>  			ok = tree_subtree_inter();
> -			if (! ok) {
> +			if (!ok) {
>  				return RV_INTR;
>  			}
>  		}
> @@ -3387,12 +3387,12 @@ treepost(char *path1, char *path2)
>  
>  	ok = tree_post(path1, path2);
>  
> -	if (! ok) {
> +	if (!ok) {
>  		return RV_INTR;
>  	}
>  
>  	ok = tree_extattr(restore_dir_extattr_cb, path1);
> -	if (! ok) {
> +	if (!ok) {
>  		return RV_INTR;
>  	}
>  
> @@ -3502,7 +3502,7 @@ applynondirdump(drive_t *drivep,
>  			rv = RV_OK;
>  			goto applynondirdump_out;
>  		case RV_CORRUPT:
> -			rval = (* dop->do_next_mark)(drivep);
> +			rval = (*dop->do_next_mark)(drivep);
>  			if (rval) {
>  				mlog(MLOG_NORMAL | MLOG_WARNING, _(
>  				      "unable to resync media file: "
> @@ -3521,7 +3521,7 @@ applynondirdump(drive_t *drivep,
>  		 */
>  		if (((bstatp->bs_mode & S_IFMT) == S_IFREG)
>  		     &&
> -		     ! (fhdrp->fh_flags & FILEHDR_FLAGS_EXTATTR)
> +		     !(fhdrp->fh_flags & FILEHDR_FLAGS_EXTATTR)
>  		     &&
>  		     fhdrp->fh_offset == 0) {
>  			egrp_t cur_egrp;
> @@ -3545,7 +3545,7 @@ applynondirdump(drive_t *drivep,
>  		do {
>  			/* get a mark for the next read, in case we restart here
>  			 */
> -			(* dop->do_get_mark)(drivep, &drivemark);
> +			(*dop->do_get_mark)(drivep, &drivemark);
>  
>  			/* read the file header.
>  			 */
> @@ -3557,7 +3557,7 @@ applynondirdump(drive_t *drivep,
>  				rv = RV_OK;
>  				goto applynondirdump_out;
>  			case RV_CORRUPT:
> -				rval = (* dop->do_next_mark)(drivep);
> +				rval = (*dop->do_next_mark)(drivep);
>  				if (rval) {
>  					mlog(MLOG_NORMAL | MLOG_WARNING, _(
>  					      "unable to resync media file: "
> @@ -3583,7 +3583,7 @@ applynondirdump(drive_t *drivep,
>  
>  		/* checkpoint into persistent state if not a null file hdr
>  		 */
> -		if (! (fhdrp->fh_flags & FILEHDR_FLAGS_NULL)) {
> +		if (!(fhdrp->fh_flags & FILEHDR_FLAGS_NULL)) {
>  			pi_checkpoint(fileh,
>  				       &drivemark,
>  				       fhdrp->fh_stat.bs_ino,
> @@ -3618,13 +3618,13 @@ finalize(char *path1, char *path2)
>  {
>  	bool_t ok;
>  
> -	if (! tranp->t_toconlypr) {
> +	if (!tranp->t_toconlypr) {
>  
>  		/* restore directory attributes
>  		 */
> -		if (! persp->s.dirattrdonepr) {;
> +		if (!persp->s.dirattrdonepr) {;
>  			ok = tree_setattr(path1);
> -			if (! ok) {
> +			if (!ok) {
>  				return RV_INTR;
>  			}
>  			persp->s.dirattrdonepr = BOOL_TRUE;
> @@ -3632,9 +3632,9 @@ finalize(char *path1, char *path2)
>  
>  		/* remove orphanage if empty
>  		 */
> -		if (! persp->s.orphdeltriedpr) {;
> +		if (!persp->s.orphdeltriedpr) {;
>  			ok = tree_delorph();
> -			if (! ok) {
> +			if (!ok) {
>  				return RV_INTR;
>  			}
>  			persp->s.orphdeltriedpr = BOOL_TRUE;
> @@ -3642,7 +3642,7 @@ finalize(char *path1, char *path2)
>  
>  		/* delete the persistent ino map
>  		 */
> -		if (! persp->s.inomapdelpr) {
> +		if (!persp->s.inomapdelpr) {
>  			inomap_del_pers(tranp->t_hkdir);
>  			persp->s.inomapdelpr = BOOL_TRUE;
>  		}
> @@ -3669,19 +3669,19 @@ finalize(char *path1, char *path2)
>  static void
>  toconly_cleanup(void)
>  {
> -	if (! tranp) {
> +	if (!tranp) {
>  		return;
>  	}
>  
> -	if (! tranp->t_toconlypr) {
> +	if (!tranp->t_toconlypr) {
>  		return;
>  	}
>  
> -	if (! tranp->t_hkdir) {
> +	if (!tranp->t_hkdir) {
>  		return;
>  	}
>  
> -	if (! strlen(tranp->t_hkdir)) {
> +	if (!strlen(tranp->t_hkdir)) {
>  		return;
>  	}
>  
> @@ -3695,17 +3695,17 @@ wipepersstate(void)
>  	struct dirent64 *direntp;
>  	char pathname[MAXPATHLEN];
>  	dirp = opendir(tranp->t_hkdir);
> -	if (! dirp) {
> +	if (!dirp) {
>  		return;
>  	}
>  
>  	while ((direntp = readdir64(dirp)) != 0) {
>  		/* REFERENCED */
>  		int len;
> -		if (! strcmp(direntp->d_name, ".")) {
> +		if (!strcmp(direntp->d_name, ".")) {
>  			continue;
>  		}
> -		if (! strcmp(direntp->d_name, "..")) {
> +		if (!strcmp(direntp->d_name, "..")) {
>  			continue;
>  		}
>  		len = sprintf(pathname,
> @@ -3717,7 +3717,7 @@ wipepersstate(void)
>  		(void)unlink(pathname);
>  		closedir(dirp);
>  		dirp = opendir(tranp->t_hkdir);
> -		if (! dirp) {
> +		if (!dirp) {
>  			return;
>  		}
>  	}
> @@ -3738,7 +3738,7 @@ Inv_validate_cmdline(void)
>  	bool_t ok;
>  	bool_t rok;
>  
> -	assert(! persp->s.valpr);
> +	assert(!persp->s.valpr);
>  
>  	ok = BOOL_FALSE;
>  	sessp = 0;
> @@ -3753,7 +3753,7 @@ Inv_validate_cmdline(void)
>  
>  		uuid_clear(baseid);
>                  askinvforbaseof(baseid, sessp);
> -		if (! dumpcompat(sessp->s_isresumed,
> +		if (!dumpcompat(sessp->s_isresumed,
>  				   (ix_t)(sessp->s_level),
>  				   baseid,
>  				   BOOL_TRUE)) {
> @@ -3926,7 +3926,7 @@ Media_mfile_next(Media_t *Mediap,
>  		     Mediap->M_pos == POS_INDIR
>  		     ||
>  		     Mediap->M_pos == POS_ATNONDIR) {
> -			(* dop->do_end_read)(drivep);
> +			(*dop->do_end_read)(drivep);
>  			Mediap->M_pos = POS_UNKN;
>  			fileh = DH_NULL;
>  		}
> @@ -4026,12 +4026,12 @@ Media_mfile_next(Media_t *Mediap,
>  		 * has finished the job.
>  		 */
>  		if (Mediap->M_pos == POS_END) {
> -			if (! (dcaps & DRIVE_CAP_REWIND)) {
> +			if (!(dcaps & DRIVE_CAP_REWIND)) {
>  				goto newmedia;
>  			}
>  			mlog(MLOG_VERBOSE | MLOG_MEDIA, _(
>  			      "rewinding\n"));
> -			(* drivep->d_opsp->do_rewind)(drivep);
> +			(*drivep->d_opsp->do_rewind)(drivep);
>  			Mediap->M_pos = POS_UNKN;
>  			if (cldmgr_stop_requested()) {
>  				return RV_INTR;
> @@ -4050,7 +4050,7 @@ Media_mfile_next(Media_t *Mediap,
>  		 * bail if catastrophic. also, tell pi about EOD/EOM
>  		 * if appropriate.
>  		 */
> -		rval = (* drivep->d_opsp->do_begin_read)(drivep);
> +		rval = (*drivep->d_opsp->do_begin_read)(drivep);
>  		switch (rval) {
>  		case 0:
>  			mlog_lock();
> @@ -4138,7 +4138,7 @@ validate:
>  		     Mediap->M_pos == POS_INDIR
>  		     ||
>  		     Mediap->M_pos == POS_ATNONDIR) {
> -			if (! Mediap->M_flmfixvalpr) {
> +			if (!Mediap->M_flmfixvalpr) {
>  				Mediap->M_fmfix = mrhdrp->mh_mediafileix;
>  				Mediap->M_mfixpurp = purp;
>  				Mediap->M_flmfixvalpr = BOOL_TRUE;
> @@ -4154,7 +4154,7 @@ validate:
>  			     Mediap->M_pos == POS_INDIR
>  			     ||
>  			     Mediap->M_pos == POS_ATNONDIR) {
> -				(* dop->do_end_read)(drivep);
> +				(*dop->do_end_read)(drivep);
>  				Mediap->M_pos = POS_UNKN;
>  				fileh = DH_NULL;
>  			}
> @@ -4263,7 +4263,7 @@ validate:
>  		 * dump, we know we have hit the end of the stream. tell the
>  		 * persistent inventory.
>  		 */
> -		 if (! partofdumppr
> +		 if (!partofdumppr
>  		      &&
>  		      Mediap->M_fsfixvalpr
>  		      &&
> @@ -4278,7 +4278,7 @@ validate:
>  		 * object was part of the dump, we know we have hit the end of
>  		 * the stream. check if we are done.
>  		 */
> -		 if (! partofdumppr
> +		 if (!partofdumppr
>  		      &&
>  		      purp == PURP_NONDIR
>  		      &&
> @@ -4286,7 +4286,7 @@ validate:
>  		      &&
>  		      Mediap->M_lmfix > Mediap->M_fsfix) {
>  			if (pi_alldone()) {
> -				(* dop->do_end_read)(drivep);
> +				(*dop->do_end_read)(drivep);
>  				Mediap->M_pos = POS_UNKN;
>  				fileh = DH_NULL;
>  				return RV_NOMORE;
> @@ -4297,18 +4297,18 @@ validate:
>  		 * and preceeding media files on this object were, decide if
>  		 * we need to rewind and look at the beginning of the object.
>  		 */
> -		if (! partofdumppr
> +		if (!partofdumppr
>  		     &&
>  		     Mediap->M_fsfixvalpr
>  		     &&
>  		     Mediap->M_fmfix <= Mediap->M_fsfix) {
> -			(* dop->do_end_read)(drivep);
> +			(*dop->do_end_read)(drivep);
>  			Mediap->M_pos = POS_UNKN;
>  			fileh = DH_NULL;
>  			if (dcaps & DRIVE_CAP_REWIND) {
>  				mlog(MLOG_VERBOSE | MLOG_MEDIA, _(
>  				  "rewinding\n"));
> -				(* drivep->d_opsp->do_rewind)(drivep);
> +				(*drivep->d_opsp->do_rewind)(drivep);
>  				continue;
>  			} else {
>  				goto newmedia;
> @@ -4318,8 +4318,8 @@ validate:
>  		/* if this media file is not part of the desired dump session,
>  		 * and the above conditions were not met, then keep looking
>  		 */
> -		if (! partofdumppr) {
> -			(* dop->do_end_read)(drivep);
> +		if (!partofdumppr) {
> +			(*dop->do_end_read)(drivep);
>  			Mediap->M_pos = POS_UNKN;
>  			fileh = DH_NULL;
>  			continue;
> @@ -4328,7 +4328,7 @@ validate:
>  		/* record the index within this media object of the first
>  		 * media file in the dump stream
>  		 */
> -		if (! Mediap->M_fsfixvalpr) {
> +		if (!Mediap->M_fsfixvalpr) {
>  			Mediap->M_fsfix =
>  				     mrhdrp->mh_mediafileix
>  				     -
> @@ -4363,7 +4363,7 @@ validate:
>  		/* if purp is nondir, we may be done.
>  		 */
>  		if (purp == PURP_NONDIR && pi_alldone()) {
> -			(* dop->do_end_read)(drivep);
> +			(*dop->do_end_read)(drivep);
>  			Mediap->M_pos = POS_UNKN;
>  			return RV_NOMORE;
>  		}
> @@ -4376,7 +4376,7 @@ validate:
>  			     Mediap->M_fmfix <= Mediap->M_fsfix
>  			     &&
>  			     Mediap->M_lmfix < Mediap->M_fmfix) {
> -				(* dop->do_end_read)(drivep);
> +				(*dop->do_end_read)(drivep);
>  				Mediap->M_pos = POS_UNKN;
>  				fileh = DH_NULL;
>  				goto newmedia;
> @@ -4386,7 +4386,7 @@ validate:
>  			     Mediap->M_pmfix < Mediap->M_fmfix
>  			     &&
>  			     Mediap->M_lmfix > Mediap->M_fmfix) {
> -				(* dop->do_end_read)(drivep);
> +				(*dop->do_end_read)(drivep);
>  				Mediap->M_pos = POS_UNKN;
>  				fileh = DH_NULL;
>  				goto newmedia;
> @@ -4404,7 +4404,7 @@ validate:
>  		     scrhdrp->cih_mediafiletype
>  		     ==
>  		     CIH_MEDIAFILETYPE_INVENTORY) {
> -			(* dop->do_end_read)(drivep);
> +			(*dop->do_end_read)(drivep);
>  			Mediap->M_pos = POS_UNKN;
>  			fileh = DH_NULL;
>  			if (pi_know_no_more_on_object(purp,
> @@ -4418,7 +4418,7 @@ validate:
>  				pi_note_underhead(objh, DH_NULL);
>  				mlog(MLOG_VERBOSE | MLOG_MEDIA, _(
>  					"rewinding\n"));
> -				(* drivep->d_opsp->do_rewind)(drivep);
> +				(*drivep->d_opsp->do_rewind)(drivep);
>  				continue;
>  			}
>  			goto newmedia;
> @@ -4433,7 +4433,7 @@ validate:
>  		     (Mediap->M_pos != POS_ATHDR
>  		       ||
>  		       DH2F(fileh)->f_dirtriedpr)) {
> -			(* dop->do_end_read)(drivep);
> +			(*dop->do_end_read)(drivep);
>  			Mediap->M_pos = POS_UNKN;
>  			fileh = DH_NULL;
>  			if (pi_know_no_more_beyond_on_object(purp,
> @@ -4451,7 +4451,7 @@ validate:
>  					pi_note_underhead(objh, DH_NULL);
>  					mlog(MLOG_VERBOSE | MLOG_MEDIA, _(
>  						"rewinding\n"));
> -					(* drivep->d_opsp->do_rewind)(drivep);
> +					(*drivep->d_opsp->do_rewind)(drivep);
>  					continue;
>  				}
>  				goto newmedia;
> @@ -4493,12 +4493,12 @@ validate:
>  		     ||
>  		     DH2F(fileh)->f_nondirskippr
>  		     ||
> -		     ! hassomepr) {
> -			if (! DH2F(fileh)->f_nondirskippr) {
> +		     !hassomepr) {
> +			if (!DH2F(fileh)->f_nondirskippr) {
>  				DH2F(fileh)->f_nondirdonepr = BOOL_TRUE;
>  			}
>  			pi_unlock();
> -			(* dop->do_end_read)(drivep);
> +			(*dop->do_end_read)(drivep);
>  			Mediap->M_pos = POS_UNKN;
>  			fileh = DH_NULL;
>  			if (pi_know_no_more_beyond_on_object(purp,
> @@ -4516,7 +4516,7 @@ validate:
>  					pi_note_underhead(objh, DH_NULL);
>  					mlog(MLOG_VERBOSE | MLOG_MEDIA, _(
>  						"rewinding\n"));
> -					(* drivep->d_opsp->do_rewind)(drivep);
> +					(*drivep->d_opsp->do_rewind)(drivep);
>  					continue;
>  				}
>  				goto newmedia;
> @@ -4564,9 +4564,9 @@ validate:
>  			    mlog(MLOG_VERBOSE | MLOG_MEDIA, _(
>  				  "seeking past portion of media file "
>  				  "already restored\n"));
> -			    rval = (* dop->do_seek_mark)(drivep,
> +			    rval = (*dop->do_seek_mark)(drivep,
>  							    &chkpnt);
> -			    if (! rval) {
> +			    if (!rval) {
>  				    rv_t rv;
>  				    rv = read_filehdr(drivep,
>  						       fhdrp,
> @@ -4583,8 +4583,8 @@ validate:
>  			    mlog(MLOG_VERBOSE | MLOG_MEDIA, _(
>  				  "seeking past media file "
>  				  "directory dump\n"));
> -			    rval = (* dop->do_next_mark)(drivep);
> -			    if (! rval) {
> +			    rval = (*dop->do_next_mark)(drivep);
> +			    if (!rval) {
>  				    rv_t rv;
>  				    rv = read_filehdr(drivep,
>  						       fhdrp,
> @@ -4638,7 +4638,7 @@ validate:
>  
>  		/* if no error during fine positioning, return.
>  		 */
> -		if (! rval) {
> +		if (!rval) {
>  			if (filehp) {
>  				assert(fileh != DH_NULL);
>  				*filehp = fileh;
> @@ -4650,7 +4650,7 @@ validate:
>  		 * media files on this object? if so, continue; if not, get
>  		 * more media.
>  		 */
> -		(* dop->do_end_read)(drivep);
> +		(*dop->do_end_read)(drivep);
>  		Mediap->M_pos = POS_UNKN;
>  		fileh = DH_NULL;
>  		assert(purp == PURP_NONDIR);
> @@ -4669,7 +4669,7 @@ validate:
>  				pi_note_underhead(objh, DH_NULL);
>  				mlog(MLOG_VERBOSE | MLOG_MEDIA, _(
>  					"rewinding\n"));
> -				(* drivep->d_opsp->do_rewind)(drivep);
> +				(*drivep->d_opsp->do_rewind)(drivep);
>  				continue;
>  			}
>  			goto newmedia;
> @@ -4701,7 +4701,7 @@ newmedia:
>  
>  		/* if media not removable, just return
>  		 */
> -		if ((* dop->do_get_device_class)(drivep)
> +		if ((*dop->do_get_device_class)(drivep)
>  		     ==
>  		     DEVICE_NONREMOVABLE)
>  		{
> @@ -4744,7 +4744,7 @@ newmedia:
>  			assert(0);
>  		}
>  
> -		if (! bagp && ! knownholespr && ! maybeholespr) {
> +		if (!bagp && !knownholespr && !maybeholespr) {
>  			/* if PURP_DIR, this may be a problem
>  			 */
>  			if (purp == PURP_NONDIR) {
> @@ -4754,7 +4754,7 @@ newmedia:
>  
>  		/* eject media if drive not already empty
>  		 */
> -		if (! emptypr) {
> +		if (!emptypr) {
>  			int dcaps = drivep->d_capabilities;
>  			if (purp == PURP_SEARCH) {
>  				if (Mediap->M_pos == POS_USELESS) {
> @@ -4770,7 +4770,7 @@ newmedia:
>  				}
>  			}
>  			if (dcaps & DRIVE_CAP_EJECT) {
> -				(* dop->do_eject_media)(drivep);
> +				(*dop->do_eject_media)(drivep);
>  			}
>  		}
>  
> @@ -4796,7 +4796,7 @@ newmedia:
>  			if (media_change_alert_program != NULL)
>  				system(media_change_alert_program);
>  
> -			if (drivecnt > 1 && ! stdoutpiped) {
> +			if (drivecnt > 1 && !stdoutpiped) {
>  				ix_t thrdix = drivep->d_index;
>  				if (bagp) {
>  					pi_neededobjs_free(bagp);
> @@ -4839,7 +4839,7 @@ newmedia:
>  		if (cldmgr_stop_requested()) {
>  			return RV_INTR;
>  		}
> -		if (! ok) {
> +		if (!ok) {
>  			return RV_QUIT;
>  		}
>  	}
> @@ -4863,7 +4863,7 @@ Media_end(Media_t *Mediap)
>  	     Mediap->M_pos == POS_INDIR
>  	     ||
>  	     Mediap->M_pos == POS_ATNONDIR) {
> -		(* dop->do_end_read)(drivep);
> +		(*dop->do_end_read)(drivep);
>  		Mediap->M_pos = POS_UNKN;
>  	}
>  }
> @@ -4937,7 +4937,7 @@ pi_allocdesc(dh_t *deschp)
>  			assert(olddescpgcnt > 0);
>  			rval = munmap((void *)descp,
>  				       olddescpgcnt * pgsz);
> -			assert(! rval);
> +			assert(!rval);
>  			descp = 0;
>  		} else {
>  			assert(olddescpgcnt == 0);
> @@ -5028,7 +5028,7 @@ pi_insertfile(ix_t drivecnt,
>  	if (persp->s.strmheadh == DH_NULL) {
>  		for (strmix = 0; strmix < drivecnt; strmix++) {
>  			ok = pi_allocdesc(&strmh);
> -			if (! ok) {
> +			if (!ok) {
>  				pi_unlock();
>  				return DH_NULL;
>  			}
> @@ -5062,7 +5062,7 @@ pi_insertfile(ix_t drivecnt,
>  		}
>  		if (objh == DH_NULL) {
>  			ok = pi_allocdesc(&objh);
> -			if (! ok) {
> +			if (!ok) {
>  				pi_unlock();
>  				return DH_NULL;
>  			}
> @@ -5161,7 +5161,7 @@ pi_insertfile(ix_t drivecnt,
>  
>  	/* if don't know dump stream media file index, can't add any media files
>  	 */
> -	if (! dmfixvalpr) {
> +	if (!dmfixvalpr) {
>  		pi_unlock();
>  		pi_show(" after pi_insertfile no media file ix");
>  		return DH_NULL;
> @@ -5180,7 +5180,7 @@ pi_insertfile(ix_t drivecnt,
>  		}
>  		if (fileh == DH_NULL) {
>  			ok = pi_allocdesc(&fileh);
> -			if (! ok) {
> +			if (!ok) {
>  				pi_unlock();
>  				return DH_NULL;
>  			}
> @@ -5195,9 +5195,9 @@ pi_insertfile(ix_t drivecnt,
>  
>  	/* update the media file fields not yet valid
>  	 */
> -	if (egrpvalpr && ! DH2F(fileh)->f_valpr) {
> -		assert(! (DH2F(fileh)->f_flags & PF_INV));
> -		assert(! (DH2F(fileh)->f_flags & PF_TERM));
> +	if (egrpvalpr && !DH2F(fileh)->f_valpr) {
> +		assert(!(DH2F(fileh)->f_flags & PF_INV));
> +		assert(!(DH2F(fileh)->f_flags & PF_TERM));
>  		DH2F(fileh)->f_firstegrp.eg_ino = startino;
>  		DH2F(fileh)->f_firstegrp.eg_off = startoffset;
>  		DH2F(fileh)->f_curegrp = DH2F(fileh)->f_firstegrp;
> @@ -5236,7 +5236,7 @@ pi_addfile(Media_t *Mediap,
>  {
>  	dh_t fileh;
>  
> -	if (! persp->s.stat_valpr) {
> +	if (!persp->s.stat_valpr) {
>  		persp->s.stat_inocnt = scrhdrp->cih_inomap_nondircnt;
>  		persp->s.stat_inodone = 0;
>  		assert(scrhdrp->cih_inomap_datasz <= OFF64MAX);
> @@ -5335,7 +5335,7 @@ pi_addfile(Media_t *Mediap,
>  					       BOOL_FALSE,
>  					       (off64_t)0);
>  		}
> -		if (! (drivep->d_capabilities & DRIVE_CAP_FILES)) {
> +		if (!(drivep->d_capabilities & DRIVE_CAP_FILES)) {
>  			/* if drive does not support multiple files,
>  			 * we know this is end of object and stream
>  			 */
> @@ -5399,7 +5399,7 @@ pi_addfile(Media_t *Mediap,
>  					       BOOL_FALSE,
>  					       (off64_t)0);
>  		}
> -		if (! persp->s.fullinvpr
> +		if (!persp->s.fullinvpr
>  		     &&
>  		     Mediap->M_pos == POS_ATHDR) {
>  			size_t bufszincr;
> @@ -5427,7 +5427,7 @@ pi_addfile(Media_t *Mediap,
>  			 */
>  			Mediap->M_pos = POS_ATNONDIR;
>  			donepr = BOOL_FALSE;
> -			while (! donepr) {
> +			while (!donepr) {
>  				int nread;
>  				drive_ops_t *dop = drivep->d_opsp;
>  				int rval = 0;
> @@ -5461,7 +5461,7 @@ pi_addfile(Media_t *Mediap,
>  			 * desc.
>  			 */
>  			sessp = 0;
> -			if (! buflen) {
> +			if (!buflen) {
>  				ok = BOOL_FALSE;
>  			} else {
>  			    /* extract the session information from the buffer */
> @@ -5472,16 +5472,16 @@ pi_addfile(Media_t *Mediap,
>  				ok = BOOL_TRUE;
>  			    }
>  			}
> -			if (! ok || ! sessp) {
> +			if (!ok || !sessp) {
>  				mlog(MLOG_DEBUG | MLOG_WARNING | MLOG_MEDIA, _(
>  				      "on-media session "
>  				      "inventory corrupt\n"));
>  			} else {
>  				/* if root, update online inventory.
>  				 */
> -				if (! geteuid()
> +				if (!geteuid()
>  				     &&
> -				     ! tranp->t_noinvupdatepr) {
> +				     !tranp->t_noinvupdatepr) {
>  					mlog(MLOG_VERBOSE | MLOG_MEDIA, _(
>  					      "incorporating on-media session "
>  					      "inventory into online "
> @@ -5869,8 +5869,8 @@ pi_scanfileendino(dh_t fileh)
>  			if (DH2F(nexth)->f_valpr) {
>  			    xfs_ino_t ino;
>  
> -			    assert(! (DH2F(nexth)->f_flags & PF_INV));
> -			    assert(! (DH2F(nexth)->f_flags & PF_TERM));
> +			    assert(!(DH2F(nexth)->f_flags & PF_INV));
> +			    assert(!(DH2F(nexth)->f_flags & PF_TERM));
>  			    if (DH2F(nexth)->f_firstegrp.eg_off) {
>  				ino =  DH2F(nexth)->f_firstegrp.eg_ino;
>  				return ino;
> @@ -5926,17 +5926,17 @@ pi_bracketneededegrps(dh_t thisfileh, egrp_t *first_egrp, egrp_t *next_egrp)
>  		      fileh != DH_NULL
>  		      ;
>  		      fileh = DH2F(fileh)->f_nexth) {
> -		    if (! thisfoundpr) {
> +		    if (!thisfoundpr) {
>  			if (fileh == thisfileh) {
>  			    thisfoundpr = BOOL_TRUE;
>  			} else if (DH2F(fileh)->f_valpr) {
> -			    assert(! (DH2F(fileh)->f_flags & PF_INV));
> -			    assert(! (DH2F(fileh)->f_flags & PF_TERM));
> +			    assert(!(DH2F(fileh)->f_flags & PF_INV));
> +			    assert(!(DH2F(fileh)->f_flags & PF_TERM));
>  			    prech = fileh;
>  			}
>  		    } else if (DH2F(fileh)->f_valpr) {
> -			assert(! (DH2F(fileh)->f_flags & PF_INV));
> -			assert(! (DH2F(fileh)->f_flags & PF_TERM));
> +			assert(!(DH2F(fileh)->f_flags & PF_INV));
> +			assert(!(DH2F(fileh)->f_flags & PF_TERM));
>  			assert(follh == DH_NULL);
>  			follh = fileh;
>  			goto done;
> @@ -6032,25 +6032,25 @@ pi_iter_nextfileh(pi_iter_t *iterp,
>  		   bool_t *objmissingprp,
>  		   bool_t *filemissingprp)
>  {
> -	assert(! iterp->donepr);
> +	assert(!iterp->donepr);
>  
>  	if (persp->s.strmheadh == DH_NULL) {
>  		iterp->donepr = BOOL_TRUE;
>  		return DH_NULL;
>  	}
>  
> -	if (! iterp->initializedpr) {
> +	if (!iterp->initializedpr) {
>  		assert(persp->s.strmheadh != DH_NULL);
>  		iterp->strmh = persp->s.strmheadh;
>  		iterp->objh = DH2S(iterp->strmh)->s_cldh;
>  		if (iterp->objh == DH_NULL) {
> -			if (! DH2S(iterp->strmh)->s_lastobjknwnpr) {
> +			if (!DH2S(iterp->strmh)->s_lastobjknwnpr) {
>  				*objmissingprp = BOOL_TRUE;
>  			}
>  		} else {
>  			iterp->fileh = DH2O(iterp->objh)->o_cldh;
>  			if (iterp->fileh == DH_NULL) {
> -				if (! DH2O(iterp->objh)->o_lmfknwnpr) {
> +				if (!DH2O(iterp->objh)->o_lmfknwnpr) {
>  					*filemissingprp = BOOL_TRUE;
>  				}
>  			}
> @@ -6058,7 +6058,7 @@ pi_iter_nextfileh(pi_iter_t *iterp,
>  
>  		while (iterp->fileh == DH_NULL) {
>  			while (iterp->objh == DH_NULL) {
> -				if (! DH2S(iterp->strmh)->s_lastobjknwnpr) {
> +				if (!DH2S(iterp->strmh)->s_lastobjknwnpr) {
>  					*objmissingprp = BOOL_TRUE;
>  				}
>  				iterp->strmh = DH2S(iterp->strmh)->s_nexth;
> @@ -6070,7 +6070,7 @@ pi_iter_nextfileh(pi_iter_t *iterp,
>  			}
>  			iterp->fileh = DH2O(iterp->objh)->o_cldh;
>  			if (iterp->fileh == DH_NULL) {
> -				if (! DH2O(iterp->objh)->o_lmfknwnpr) {
> +				if (!DH2O(iterp->objh)->o_lmfknwnpr) {
>  					*filemissingprp = BOOL_TRUE;
>  				}
>  				iterp->objh = DH2O(iterp->objh)->o_nexth;
> @@ -6082,12 +6082,12 @@ pi_iter_nextfileh(pi_iter_t *iterp,
>  
>  	iterp->fileh = DH2F(iterp->fileh)->f_nexth;
>  	while (iterp->fileh == DH_NULL) {
> -		if (! DH2O(iterp->objh)->o_lmfknwnpr) {
> +		if (!DH2O(iterp->objh)->o_lmfknwnpr) {
>  			*filemissingprp = BOOL_TRUE;
>  		}
>  		iterp->objh = DH2O(iterp->objh)->o_nexth;
>  		while (iterp->objh == DH_NULL) {
> -			if (! DH2S(iterp->strmh)->s_lastobjknwnpr) {
> +			if (!DH2S(iterp->strmh)->s_lastobjknwnpr) {
>  				*objmissingprp = BOOL_TRUE;
>  			}
>  			iterp->strmh = DH2S(iterp->strmh)->s_nexth;
> @@ -6200,13 +6200,13 @@ pi_neededobjs_nondir_alloc(bool_t *knownholesprp,
>  			headh = pi_iter_nextfileh(headiterp,
>  						   &dummyobjmissingpr,
>  						   &dummyfilemissingpr);
> -		} while (headh != DH_NULL && ! DH2F(headh)->f_valpr);
> +		} while (headh != DH_NULL && !DH2F(headh)->f_valpr);
>  		if (headh == DH_NULL) {
>  			headegrp.eg_ino = INO64MAX;
>  			headegrp.eg_off = OFF64MAX;
>  		} else {
> -			assert(! (DH2F(headh)->f_flags & PF_INV));
> -			assert(! (DH2F(headh)->f_flags & PF_TERM));
> +			assert(!(DH2F(headh)->f_flags & PF_INV));
> +			assert(!(DH2F(headh)->f_flags & PF_TERM));
>  			headegrp = DH2F(headh)->f_firstegrp;
>  		}
>  
> @@ -6228,15 +6228,15 @@ pi_neededobjs_nondir_alloc(bool_t *knownholesprp,
>  		     */
>  		    if (markskippr
>  			 &&
> -			 ! foundgappr
> +			 !foundgappr
>  			 &&
>  			 tailh != DH_NULL
>  			 &&
> -			 ! (DH2F(tailh)->f_flags & PF_INV)
> +			 !(DH2F(tailh)->f_flags & PF_INV)
>  			 &&
> -			 ! (DH2F(tailh)->f_flags & PF_TERM)
> +			 !(DH2F(tailh)->f_flags & PF_TERM)
>  			 &&
> -			 ! DH2F(tailh)->f_nondirskippr) {
> +			 !DH2F(tailh)->f_nondirskippr) {
>  			    DH2F(tailh)->f_nondirskippr = BOOL_TRUE;
>  		    }
>  
> @@ -6246,17 +6246,17 @@ pi_neededobjs_nondir_alloc(bool_t *knownholesprp,
>  			 &&
>  			 tailh != DH_NULL
>  			 &&
> -			 ! (DH2F(tailh)->f_flags & PF_INV)
> +			 !(DH2F(tailh)->f_flags & PF_INV)
>  			 &&
> -			 ! (DH2F(tailh)->f_flags & PF_TERM)
> +			 !(DH2F(tailh)->f_flags & PF_TERM)
>  			 &&
> -			 ! DH2F(tailh)->f_nondirdonepr
> +			 !DH2F(tailh)->f_nondirdonepr
>  			 &&
> -			 ! DH2F(tailh)->f_nondirskippr) {
> +			 !DH2F(tailh)->f_nondirskippr) {
>  
>  			    dh_t objh = DH2F(tailh)->f_parh;
>  
> -			    if (! DH2O(objh)->o_indrivepr
> +			    if (!DH2O(objh)->o_indrivepr
>  				 ||
>  				 showobjindrivepr) {
>  				if (DH2O(objh)->o_idlabvalpr) {
> @@ -6332,9 +6332,9 @@ pi_neededobjs_dir_alloc(bool_t *knownholesprp, bool_t *maybeholesprp)
>  					     &maybeobjmissingpr,
>  					     &maybefilemissingpr))
>  		!= DH_NULL) {
> -		if (! DH2F(fileh)->f_dirtriedpr) {
> +		if (!DH2F(fileh)->f_dirtriedpr) {
>  			dh_t objh = DH2F(fileh)->f_parh;
> -			if (! DH2O(objh)->o_indrivepr) {
> +			if (!DH2O(objh)->o_indrivepr) {
>  				if (DH2O(objh)->o_idlabvalpr) {
>  					if (objh != lastobjaddedh) {
>  						addobj(bagp,
> @@ -6584,7 +6584,7 @@ pi_know_no_more_on_object(purp_t purp, ix_t strmix, ix_t objix)
>  
>  	/* if don't know last media file on object, return FALSE
>  	 */
> -	if (! DH2O(objh)->o_lmfknwnpr) {
> +	if (!DH2O(objh)->o_lmfknwnpr) {
>  		pi_unlock();
>  		return BOOL_FALSE;
>  	}
> @@ -6604,14 +6604,14 @@ pi_know_no_more_on_object(purp_t purp, ix_t strmix, ix_t objix)
>  			continue;
>  		}
>  		if (purp == PURP_DIR) {
> -			if (! DH2F(fileh)->f_dirtriedpr) {
> +			if (!DH2F(fileh)->f_dirtriedpr) {
>  				pi_unlock();
>  				return BOOL_FALSE;
>  			}
>  		} else {
> -			if (! DH2F(fileh)->f_nondirskippr
> +			if (!DH2F(fileh)->f_nondirskippr
>  			     &&
> -			     ! DH2F(fileh)->f_nondirdonepr) {
> +			     !DH2F(fileh)->f_nondirdonepr) {
>  				pi_unlock();
>  				return BOOL_FALSE;
>  			}
> @@ -6663,7 +6663,7 @@ pi_know_no_more_beyond_on_object(purp_t purp,
>  
>  	/* if don't know last media file on object, return FALSE
>  	 */
> -	if (! DH2O(objh)->o_lmfknwnpr) {
> +	if (!DH2O(objh)->o_lmfknwnpr) {
>  		pi_unlock();
>  		return BOOL_FALSE;
>  	}
> @@ -6688,14 +6688,14 @@ pi_know_no_more_beyond_on_object(purp_t purp,
>  			continue;
>  		}
>  		if (purp == PURP_DIR) {
> -			if (! DH2F(fileh)->f_dirtriedpr) {
> +			if (!DH2F(fileh)->f_dirtriedpr) {
>  				pi_unlock();
>  				return BOOL_FALSE;
>  			}
>  		} else {
> -			if (! DH2F(fileh)->f_nondirdonepr
> +			if (!DH2F(fileh)->f_nondirdonepr
>  			     &&
> -			     ! DH2F(fileh)->f_nondirskippr) {
> +			     !DH2F(fileh)->f_nondirskippr) {
>  				pi_unlock();
>  				return BOOL_FALSE;
>  			}
> @@ -6730,7 +6730,7 @@ gapneeded(egrp_t *firstegrpp, egrp_t *lastegrpp)
>  		endino = lastegrpp->eg_ino - 1;
>  	}
>  
> -	if (! inomap_rst_needed(firstegrpp->eg_ino, endino)) {
> +	if (!inomap_rst_needed(firstegrpp->eg_ino, endino)) {
>  		return BOOL_FALSE;
>  	}
>  
> @@ -6801,7 +6801,7 @@ askinvforbaseof(uuid_t baseid, inv_session_t *sessp)
>  
>  	/* don't look for base if level 0 and not resumed
>  	 */
> -	if (level == 0 && ! resumedpr) {
> +	if (level == 0 && !resumedpr) {
>  		return BOOL_TRUE;
>  	}
>  
> @@ -6829,7 +6829,7 @@ askinvforbaseof(uuid_t baseid, inv_session_t *sessp)
>  						     (u_char_t)level,
>  						     &basesessp);
>  	}
> -	if (! ok) {
> +	if (!ok) {
>  		mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA, _(
>  		      "unable to find base dump in inventory "
>  		      "to validate dump\n"));
> @@ -7278,7 +7278,7 @@ restore_file_cb(void *cp, bool_t linkpr, char *path1, char *path2)
>  		return BOOL_FALSE;
>  	}
>  
> -	if (! linkpr) {
> +	if (!linkpr) {
>  		if (path1) {
>  			/* cache the path for use in restoring attributes
>  			 * and extended attributes
> @@ -7334,7 +7334,7 @@ restore_file_cb(void *cp, bool_t linkpr, char *path1, char *path2)
>  			      bstatp->bs_mode);
>  			return BOOL_FALSE;
>  		}
> -	} else if (! tranp->t_toconlypr) {
> +	} else if (!tranp->t_toconlypr) {
>  		assert(path1);
>  		assert(path2);
>  		mlog(MLOG_TRACE,
> @@ -7451,7 +7451,7 @@ restore_reg(drive_t *drivep,
>  		return BOOL_TRUE;
>  
>  	if (fhdrp->fh_offset) {
> -		if (! tranp->t_toconlypr) {
> +		if (!tranp->t_toconlypr) {
>  			mlog(MLOG_TRACE,
>  			      "restoring regular file ino %llu %s"
>  			      " (offset %lld)\n",
> @@ -7465,7 +7465,7 @@ restore_reg(drive_t *drivep,
>  			      fhdrp->fh_offset);
>  		}
>  	} else {
> -		if (! tranp->t_toconlypr) {
> +		if (!tranp->t_toconlypr) {
>  			mlog(MLOG_TRACE,
>  			      "restoring regular file ino %llu %s\n",
>  			      bstatp->bs_ino,
> @@ -7783,7 +7783,7 @@ restore_spec(filehdr_t *fhdrp, rv_t *rvp, char *path)
>  	char *printstr;
>  	int rval;
>  
> -	if (! path) {
> +	if (!path) {
>  		return BOOL_TRUE;
>  	}
>  
> @@ -7814,7 +7814,7 @@ restore_spec(filehdr_t *fhdrp, rv_t *rvp, char *path)
>  		return BOOL_TRUE;
>  	}
>  
> -	if (! tranp->t_toconlypr) {
> +	if (!tranp->t_toconlypr) {
>  		mlog(MLOG_TRACE,
>  		      "restoring %s ino %llu %s\n",
>  		      printstr,
> @@ -7826,7 +7826,7 @@ restore_spec(filehdr_t *fhdrp, rv_t *rvp, char *path)
>  		      path);
>  	}
>  
> -	if (! tranp->t_toconlypr) {
> +	if (!tranp->t_toconlypr) {
>  		if ((bstatp->bs_mode & S_IFMT) == S_IFSOCK) {
>  			int sockfd;
>  			struct sockaddr_un addr;
> @@ -7955,7 +7955,7 @@ restore_symlink(drive_t *drivep,
>  	mode_t oldumask;
>  
>  	if (path) {
> -		if (! tranp->t_toconlypr) {
> +		if (!tranp->t_toconlypr) {
>  			mlog(MLOG_TRACE,
>  			      "restoring symbolic link ino %llu %s\n",
>  			      bstatp->bs_ino,
> @@ -8013,7 +8013,7 @@ restore_symlink(drive_t *drivep,
>  		return BOOL_FALSE;
>  	}
>  	assert((off64_t)nread == ehdr.eh_sz);
> -	if (! scratch) {
> +	if (!scratch) {
>  		if (path) {
>  			mlog(MLOG_VERBOSE | MLOG_WARNING, _(
>  			      "unable to create symlink ino %llu "
> @@ -8024,7 +8024,7 @@ restore_symlink(drive_t *drivep,
>  		return BOOL_TRUE;
>  	}
>  	scratchpath[nread] = 0;
> -	if (! tranp->t_toconlypr && path) {
> +	if (!tranp->t_toconlypr && path) {
>  		/* create the symbolic link
>  		 */
>  		/* NOTE: There is no direct way to set mode for
> @@ -8125,7 +8125,7 @@ read_filehdr(drive_t *drivep, filehdr_t *fhdrp, bool_t fhcs)
>  	      bstatp->bs_mode);
>  
>  	if (fhcs) {
> -		if (! (fhdrp->fh_flags & FILEHDR_FLAGS_CHECKSUM)) {
> +		if (!(fhdrp->fh_flags & FILEHDR_FLAGS_CHECKSUM)) {
>  			mlog(MLOG_NORMAL | MLOG_WARNING, _(
>  			      "corrupt file header\n"));
>  			return RV_CORRUPT;
> @@ -8184,7 +8184,7 @@ read_extenthdr(drive_t *drivep, extenthdr_t *ehdrp, bool_t ehcs)
>  	      ehdrp->eh_flags);
>  
>  	if (ehcs) {
> -		if (! (ehdrp->eh_flags & EXTENTHDR_FLAGS_CHECKSUM)) {
> +		if (!(ehdrp->eh_flags & EXTENTHDR_FLAGS_CHECKSUM)) {
>  			mlog(MLOG_NORMAL | MLOG_WARNING, _(
>  			      "corrupt extent header\n"));
>  			return RV_CORRUPT;
> @@ -8293,7 +8293,7 @@ read_dirent(drive_t *drivep,
>  	 */
>  	assert((size_t)dhdrp->dh_sz <= direntbufsz);
>  	assert((size_t)dhdrp->dh_sz >= sizeof(direnthdr_t));
> -	assert(! ((size_t)dhdrp->dh_sz & (DIRENTHDR_ALIGN - 1)));
> +	assert(!((size_t)dhdrp->dh_sz & (DIRENTHDR_ALIGN - 1)));
>  	if ((size_t)dhdrp->dh_sz > sizeof(direnthdr_t)) {
>  		size_t remsz = (size_t)dhdrp->dh_sz - sizeof(direnthdr_t);
>  		nread = read_buf(namep,
> @@ -8494,7 +8494,7 @@ restore_extent(filehdr_t *fhdrp,
>  		size_t ntowrite;
>  
>  		req_bufsz = (size_t)min((off64_t)INTGENMAX, sz);
> -		bufp = (* dop->do_read)(drivep, req_bufsz, &sup_bufsz, &rval);
> +		bufp = (*dop->do_read)(drivep, req_bufsz, &sup_bufsz, &rval);
>  		if (rval) {
>  			rv_t rv;
>  			char *reasonstr;
> @@ -8639,7 +8639,7 @@ restore_extent(filehdr_t *fhdrp,
>  		} else {
>  			nwritten = 0;
>  		}
> -		(* dop->do_return_read_buf)(drivep, bufp, sup_bufsz);
> +		(*dop->do_return_read_buf)(drivep, bufp, sup_bufsz);
>  		if ((size_t)nwritten != ntowrite) {
>  			if (nwritten < 0) {
>  				mlog(MLOG_NORMAL, _(
> @@ -8679,7 +8679,7 @@ static size_t extattrbufsz = 0; /* size of each extattr buffer */
>  static bool_t
>  extattr_init(size_t drivecnt)
>  {
> -	assert(! extattrbufp);
> +	assert(!extattrbufp);
>  	extattrbufsz = EXTATTRHDR_SZ		/* dump hdr */
>  		       +
>  		       NAME_MAX			/* attribute name */
> @@ -8729,7 +8729,7 @@ restore_extattr(drive_t *drivep,
>  
>  	assert(extattrbufp);
>  
> -	if (! isdirpr)
> +	if (!isdirpr)
>  		isfilerestored = partial_check(bstatp->bs_ino,  bstatp->bs_size);
>  
>  	/* peel off extattrs until null hdr hit
> @@ -8777,7 +8777,7 @@ restore_extattr(drive_t *drivep,
>  		}
>  		assert(nread == (int)(recsz - EXTATTRHDR_SZ));
>  
> -		if (! persp->a.restoreextattrpr && ! persp->a.restoredmpr) {
> +		if (!persp->a.restoreextattrpr && !persp->a.restoredmpr) {
>  			continue;
>  		}
>  
> @@ -8790,7 +8790,7 @@ restore_extattr(drive_t *drivep,
>  		 * extended attributes.
>  		 */
>  		if (isdirpr) {
> -			assert(! path);
> +			assert(!path);
>  			if (dah != DAH_NULL) {
>  				dirattr_addextattr(dah, ahdrp);
>  			}
> @@ -9033,7 +9033,7 @@ partial_reg(ix_t d_index,
>  	}
>  
>  	/* If not found, find a free one, fill it in and return */
> -	if (! isptr) {
> +	if (!isptr) {
>  		mlog(MLOG_NITTY | MLOG_NOLOCK,
>  			"partial_reg: no entry found for %llu\n", ino);
>  		/* find a free one */
> @@ -9136,7 +9136,7 @@ partial_check (xfs_ino_t ino, off64_t fsize)
>  	}
>  
>  	/* If not found, return okay */
> -	if (! isptr) {
> +	if (!isptr) {
>  		pi_unlock();
>  		return BOOL_TRUE;
>  	}
> @@ -9379,7 +9379,7 @@ pi_show_nomloglock(void)
>  				mlog(MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA,
>  				      _("    label is blank\n"));
>  				}
> -				if (! uuid_is_null(DH2O(objh)->o_id)) {
> +				if (!uuid_is_null(DH2O(objh)->o_id)) {
>  				    char media_string_uuid[UUID_STR_LEN + 1];
>  				    uuid_unparse(DH2O(objh)->o_id,
>  						    media_string_uuid);
> @@ -9489,13 +9489,13 @@ pi_show_nomloglock(void)
>  					  _("        now reading\n"));
>  			    }
>  			}
> -			if (! DH2O(objh)->o_lmfknwnpr) {
> +			if (!DH2O(objh)->o_lmfknwnpr) {
>  				mlog(MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA,
>  				      _("\n        may be additional "
>  				      "unidentified media files\n"));
>  			}
>  		}
> -		if (! DH2S(strmh)->s_lastobjknwnpr) {
> +		if (!DH2S(strmh)->s_lastobjknwnpr) {
>  			mlog(MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA,
>  			      _("\n    may be "
>  			      "additional unidentified media objects\n\n"));
> @@ -9703,7 +9703,7 @@ display_needed_objects(purp_t purp,
>  		}
>  	}
>  
> -	if (! bagp && ! knownholespr && ! maybeholespr) {
> +	if (!bagp && !knownholespr && !maybeholespr) {
>  		mlog(MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK,
>  		      _("no additional media objects needed\n"));
>  	}
> diff --git a/restore/dirattr.c b/restore/dirattr.c
> index cd9cad0..806f282 100644
> --- a/restore/dirattr.c
> +++ b/restore/dirattr.c
> @@ -208,8 +208,8 @@ dirattr_init(char *hkdir, bool_t resume, uint64_t dircnt)
>  	/* sanity checks
>  	 */
>  	assert(sizeof(dirattr_pers_t) <= DIRATTR_PERS_SZ);
> -	assert(! dtp);
> -	assert(! dpp);
> +	assert(!dtp);
> +	assert(!dpp);
>  
>  	/* allocate and initialize context
>  	 */
> @@ -269,7 +269,7 @@ dirattr_init(char *hkdir, bool_t resume, uint64_t dircnt)
>  		      ioctlcmd = XFS_IOC_RESVSP64,
>  		      loglevel = MLOG_VERBOSE
>  		      ;
> -		      ! successpr && trycnt < 2
> +		      !successpr && trycnt < 2
>  		      ;
>  		      trycnt++,
>  		      ioctlcmd = XFS_IOC_ALLOCSP64,
> @@ -278,7 +278,7 @@ dirattr_init(char *hkdir, bool_t resume, uint64_t dircnt)
>  			struct flock64 flock64;
>  			int rval;
>  
> -			if (! ioctlcmd) {
> +			if (!ioctlcmd) {
>  				continue;
>  			}
>  
> @@ -314,7 +314,7 @@ dirattr_init(char *hkdir, bool_t resume, uint64_t dircnt)
>  
>  	/* mmap the persistent descriptor
>  	 */
> -	assert(! (DIRATTR_PERS_SZ % pgsz));
> +	assert(!(DIRATTR_PERS_SZ % pgsz));
>  	dpp = (dirattr_pers_t *)mmap_autogrow(DIRATTR_PERS_SZ,
>  				        dtp->dt_fd,
>  				        (off_t)0);
> @@ -329,7 +329,7 @@ dirattr_init(char *hkdir, bool_t resume, uint64_t dircnt)
>  
>  	/* initialize persistent state
>  	 */
> -	if (! resume) {
> +	if (!resume) {
>  		dpp->dp_appendoff = (off64_t)DIRATTR_PERS_SZ;
>  	}
>  
> @@ -356,12 +356,12 @@ dirattr_cleanup(void)
>  	/* REFERENCED */
>  	int rval;
>  
> -	if (! dtp) {
> +	if (!dtp) {
>  		return;
>  	}
>  	if (dpp) {
>  		rval = munmap((void *)dpp, DIRATTR_PERS_SZ);
> -		assert(! rval);
> +		assert(!rval);
>  		dpp = 0;
>  	}
>  	if (dtp->dt_fd >= 0) {
> @@ -403,7 +403,7 @@ dirattr_add(filehdr_t *fhdrp)
>  
>  	/* make sure file pointer is positioned to write at end of file
>  	 */
> -	if (! dtp->dt_at_endpr) {
> +	if (!dtp->dt_at_endpr) {
>  		off64_t newoff;
>  		newoff = lseek64(dtp->dt_fd, dpp->dp_appendoff, SEEK_SET);
>  		if (newoff == (off64_t)-1) {
> @@ -621,7 +621,7 @@ dirattr_addextattr(dah_t dah, extattrhdr_t *ahdrp)
>  
>  bool_t
>  dirattr_cb_extattr(dah_t dah,
> -		    bool_t (* cbfunc)(extattrhdr_t *ahdrp,
> +		    bool_t (*cbfunc)(extattrhdr_t *ahdrp,
>  				         void *ctxp),
>  		    extattrhdr_t *ahdrp,
>  		    void *ctxp)
> @@ -735,8 +735,8 @@ dirattr_cb_extattr(dah_t dah,
>  
>  		/* call the callback func
>  		 */
> -		ok = (* cbfunc)(ahdrp, ctxp);
> -		if (! ok) {
> +		ok = (*cbfunc)(ahdrp, ctxp);
> +		if (!ok) {
>  			return BOOL_FALSE;
>  		}
>  
> diff --git a/restore/dirattr.h b/restore/dirattr.h
> index dd37a98..232822e 100644
> --- a/restore/dirattr.h
> +++ b/restore/dirattr.h
> @@ -83,7 +83,7 @@ extern void dirattr_addextattr(dah_t dah, extattrhdr_t *ahdrp);
>   * else returns TRUE.
>   */
>  extern bool_t dirattr_cb_extattr(dah_t dah,
> -				  bool_t (* cbfunc)(extattrhdr_t *ahdrp,
> +				  bool_t (*cbfunc)(extattrhdr_t *ahdrp,
>  						       void *ctxp),
>  				  extattrhdr_t *ahdrp,
>  				  void *ctxp);
> diff --git a/restore/inomap.c b/restore/inomap.c
> index 868244b..13e1247 100644
> --- a/restore/inomap.c
> +++ b/restore/inomap.c
> @@ -274,7 +274,7 @@ inomap_restore_pers(drive_t *drivep,
>  		        PERSSZ
>  		        +
>  		        sizeof(hnk_t) * (size_t)hnkcnt);
> -	assert(! rval1);
> +	assert(!rval1);
>  	(void)close(fd);
>  	free((void *)perspath);
>  
> @@ -286,7 +286,7 @@ inomap_restore_pers(drive_t *drivep,
>  	case 0:
>  		assert((size_t)nread == sizeof(hnk_t) * (size_t)hnkcnt);
>  		ok = inomap_sync_pers(hkdir);
> -		if (! ok) {
> +		if (!ok) {
>  			return RV_ERROR;
>  		}
>  		return RV_OK;
> @@ -515,7 +515,7 @@ inomap_rst_needed(xfs_ino_t firstino, xfs_ino_t lastino)
>  
>  	/* if inomap not restored/resynced, just say yes
>  	 */
> -	if (! roothnkp) {
> +	if (!roothnkp) {
>  		return BOOL_TRUE;
>  	}
>  
> @@ -570,7 +570,7 @@ begin:
>  		}
>  		if (segp >= hnkp->seg + SEGPERHNK) {
>  			hnkp = hnkp->nextp;
> -			if (! hnkp) {
> +			if (!hnkp) {
>  				return BOOL_FALSE;
>  			}
>  			segp = hnkp->seg;
> @@ -585,7 +585,7 @@ begin:
>   */
>  void
>  inomap_cbiter(int statemask,
> -	       bool_t (* cbfunc)(void *ctxp, xfs_ino_t ino),
> +	       bool_t (*cbfunc)(void *ctxp, xfs_ino_t ino),
>  	       void *ctxp)
>  {
>  	hnk_t *hnkp;
> @@ -620,7 +620,7 @@ inomap_cbiter(int statemask,
>  				if (statemask & (1 << state)) {
>  					bool_t ok;
>  					ok = (cbfunc)(ctxp, ino);
> -					if (! ok) {
> +					if (!ok) {
>  						return;
>  					}
>  				}
> diff --git a/restore/inomap.h b/restore/inomap.h
> index 93f982c..55f9d07 100644
> --- a/restore/inomap.h
> +++ b/restore/inomap.h
> @@ -80,7 +80,7 @@ extern void inomap_rst_add(xfs_ino_t ino);
>  extern void inomap_rst_del(xfs_ino_t ino);
>  extern rv_t inomap_discard(drive_t *drivep, content_inode_hdr_t *scrhdrp);
>  extern void inomap_cbiter(int mapstatemask,
> -			   bool_t (* cbfunc)(void *ctxp, xfs_ino_t ino),
> +			   bool_t (*cbfunc)(void *ctxp, xfs_ino_t ino),
>  			   void *ctxp);
>  
>  #endif /* INOMAP_H */
> diff --git a/restore/namreg.c b/restore/namreg.c
> index 89fa5ef..fe159e4 100644
> --- a/restore/namreg.c
> +++ b/restore/namreg.c
> @@ -124,8 +124,8 @@ namreg_init(char *hkdir, bool_t resume, uint64_t inocnt)
>  
>  	/* sanity checks
>  	 */
> -	assert(! ntp);
> -	assert(! npp);
> +	assert(!ntp);
> +	assert(!npp);
>  
>  	assert(sizeof(namreg_pers_t) <= NAMREG_PERS_SZ);
>  
> @@ -184,7 +184,7 @@ namreg_init(char *hkdir, bool_t resume, uint64_t inocnt)
>  		      ioctlcmd = XFS_IOC_RESVSP64,
>  		      loglevel = MLOG_VERBOSE
>  		      ;
> -		      ! successpr && trycnt < 2
> +		      !successpr && trycnt < 2
>  		      ;
>  		      trycnt++,
>  		      ioctlcmd = XFS_IOC_ALLOCSP64,
> @@ -193,7 +193,7 @@ namreg_init(char *hkdir, bool_t resume, uint64_t inocnt)
>  			struct flock64 flock64;
>  			int rval;
>  
> -			if (! ioctlcmd) {
> +			if (!ioctlcmd) {
>  				continue;
>  			}
>  
> @@ -229,7 +229,7 @@ namreg_init(char *hkdir, bool_t resume, uint64_t inocnt)
>  
>  	/* mmap the persistent descriptor
>  	 */
> -	assert(! (NAMREG_PERS_SZ % pgsz));
> +	assert(!(NAMREG_PERS_SZ % pgsz));
>  	npp = (namreg_pers_t *) mmap_autogrow(
>  				        NAMREG_PERS_SZ,
>  				        ntp->nt_fd,
> @@ -244,7 +244,7 @@ namreg_init(char *hkdir, bool_t resume, uint64_t inocnt)
>  
>  	/* initialize persistent state
>  	 */
> -	if (! resume) {
> +	if (!resume) {
>  		npp->np_appendoff = (off64_t)NAMREG_PERS_SZ;
>  	}
>  
> @@ -270,7 +270,7 @@ namreg_add(char *name, size_t namelen)
>  
>  	/* make sure file pointer is positioned to append
>  	 */
> -	if (! ntp->nt_at_endpr) {
> +	if (!ntp->nt_at_endpr) {
>  		off64_t newoff;
>  		newoff = lseek64(ntp->nt_fd, npp->np_appendoff, SEEK_SET);
>  		if (newoff == (off64_t)-1) {
> diff --git a/restore/node.c b/restore/node.c
> index cd9385c..51a183e 100644
> --- a/restore/node.c
> +++ b/restore/node.c
> @@ -211,7 +211,7 @@ node_unmap_internal(nh_t nh, void **pp, bool_t freepr)
>  	nodegen = HKPGETGEN(hkp);
>  	assert(nodegen == hdlgen);
>  	nodeunq = HKPGETUNQ(hkp);
> -	if (! freepr) {
> +	if (!freepr) {
>  		assert(nodeunq != NODEUNQFREE);
>  		assert(nodeunq == NODEUNQALCD);
>  	} else {
> @@ -337,9 +337,9 @@ node_init(int fd,
>  	/* map the abstraction header
>  	 */
>  	assert((NODE_HDRSZ & pgmask) == 0);
> -	assert(! (NODE_HDRSZ % pgsz));
> +	assert(!(NODE_HDRSZ % pgsz));
>  	assert(off <= OFF64MAX);
> -	assert(! (off % (off64_t)pgsz));
> +	assert(!(off % (off64_t)pgsz));
>  	node_hdrp = (node_hdr_t *)mmap_autogrow(
>  					    NODE_HDRSZ,
>  					    fd,
> @@ -405,7 +405,7 @@ node_sync(int fd, off64_t off)
>  	 */
>  	assert((NODE_HDRSZ & pgmask) == 0);
>  	assert(off <= (off64_t)OFF64MAX);
> -	assert(! (off % (off64_t)pgsz));
> +	assert(!(off % (off64_t)pgsz));
>  	node_hdrp = (node_hdr_t *)mmap_autogrow(
>  					    NODE_HDRSZ,
>  					    fd,
> diff --git a/restore/tree.c b/restore/tree.c
> index 305791f..7ee1ce0 100644
> --- a/restore/tree.c
> +++ b/restore/tree.c
> @@ -287,7 +287,7 @@ static nh_t link_nexth(nh_t nh);
>  static nh_t link_matchh(nh_t hardh, nh_t parh, char *name);
>  static void link_in(nh_t nh);
>  static void link_out(nh_t nh);
> -static void link_headiter(bool_t (* cbfp)(void *contextp, nh_t hardh),
> +static void link_headiter(bool_t (*cbfp)(void *contextp, nh_t hardh),
>  			   void *contextp);
>  static void link_iter_init(link_iter_context_t *link_iter_contextp,
>  			    nh_t hardheadh);
> @@ -302,7 +302,7 @@ static inline size_t hash_val(xfs_ino_t ino, size_t hashmask);
>  static void hash_in(nh_t nh);
>  static void hash_out(nh_t nh);
>  static nh_t hash_find(xfs_ino_t ino, gen_t gen);
> -static void hash_iter(bool_t (* cbfp)(void *contextp, nh_t hashh),
> +static void hash_iter(bool_t (*cbfp)(void *contextp, nh_t hashh),
>  		       void *contextp);
>  static void setdirattr(dah_t dah, char *path);
>  static bool_t tsi_walkpath(char *arg, nh_t rooth, nh_t cwdh,
> @@ -360,11 +360,11 @@ tree_init(char *hkdir,
>  
>  	/* sanity checks
>  	 */
> -	assert(! (PERSSZ % pgsz));
> +	assert(!(PERSSZ % pgsz));
>  	assert(sizeof(persp) <= PERSSZ);
>  	assert(sizeof(node_t) <= NODESZ);
> -	assert(! persp);
> -	assert(! tranp);
> +	assert(!persp);
> +	assert(!tranp);
>  
>  	/* allocate transient state
>  	 */
> @@ -396,7 +396,7 @@ tree_init(char *hkdir,
>  	/* create an orphanage, if it already exists, complain.
>  	 * not needed if just a table-of-contents restore.
>  	 */
> -	if (! tranp->t_toconlypr) {
> +	if (!tranp->t_toconlypr) {
>  		rval = mkdir(tranp->t_orphdir, S_IRWXU);
>  		if (rval) {
>  			if (errno == EEXIST) {
> @@ -434,7 +434,7 @@ tree_init(char *hkdir,
>  
>  	/* mmap the persistent state
>  	 */
> -	assert(! (PERSSZ % pgsz));
> +	assert(!(PERSSZ % pgsz));
>  	persp = (treepers_t *) mmap_autogrow(
>  				     PERSSZ,
>  				     tranp->t_persfd,
> @@ -451,7 +451,7 @@ tree_init(char *hkdir,
>  	 * persistent state file.
>  	 */
>  	ok = hash_init(vmsz / HASHSZ_PERVM, dircnt, nondircnt, perspath);
> -	if (! ok) {
> +	if (!ok) {
>  		return BOOL_FALSE;
>  	}
>  
> @@ -469,7 +469,7 @@ tree_init(char *hkdir,
>  		        sizeof(size64_t), /* node alignment */
>  		        vmsz - (size64_t)nodeoff,
>  			dircnt + nondircnt);
> -	if (! ok) {
> +	if (!ok) {
>  		return BOOL_FALSE;
>  	}
>  
> @@ -548,11 +548,11 @@ tree_sync(char *hkdir,
>  
>  	/* sanity checks
>  	 */
> -	assert(! (PERSSZ % pgsz));
> +	assert(!(PERSSZ % pgsz));
>  	assert(sizeof(persp) <= PERSSZ);
>  	assert(sizeof(node_t) <= NODESZ);
> -	assert(! persp);
> -	assert(! tranp);
> +	assert(!persp);
> +	assert(!tranp);
>  
>  	/* allocate transient state
>  	 */
> @@ -609,7 +609,7 @@ tree_sync(char *hkdir,
>  
>  	/* mmap the persistent state
>  	 */
> -	assert(! (PERSSZ % pgsz));
> +	assert(!(PERSSZ % pgsz));
>  	persp = (treepers_t *) mmap_autogrow(
>  				     PERSSZ,
>  				     tranp->t_persfd,
> @@ -640,7 +640,7 @@ tree_sync(char *hkdir,
>  	 * persistent state file.
>  	 */
>  	ok = hash_sync(perspath);
> -	if (! ok) {
> +	if (!ok) {
>  		return BOOL_FALSE;
>  	}
>  
> @@ -649,7 +649,7 @@ tree_sync(char *hkdir,
>  	assert(persp->p_hashsz <= (size64_t)(OFF64MAX - (off64_t)PERSSZ));
>  	nodeoff = (off64_t)PERSSZ + (off64_t)persp->p_hashsz;
>  	ok = node_sync(tranp->t_persfd, nodeoff);
> -	if (! ok) {
> +	if (!ok) {
>  		return BOOL_FALSE;
>  	}
>  
> @@ -729,7 +729,7 @@ tree_marknoref_recurse(nh_t parh)
>  void
>  tree_markallsubtree(bool_t sensepr)
>  {
> -	if (! sensepr) {
> +	if (!sensepr) {
>  		persp->p_ignoreorphpr = BOOL_TRUE;
>  	}
>  	selsubtree(persp->p_rooth, sensepr);
> @@ -761,7 +761,7 @@ tree_begindir(filehdr_t *fhdrp, dah_t *dahp)
>  	if (hardh != NH_NULL) {
>  		node_t *hardp;
>  		hardp = Node_map(hardh);
> -		if (! (hardp->n_flags & NF_ISDIR)) {
> +		if (!(hardp->n_flags & NF_ISDIR)) {
>  			/* case 1: previously seen as dirent, now know is dir
>  			 */
>  			mlog(MLOG_TRACE | MLOG_TREE,
> @@ -770,11 +770,11 @@ tree_begindir(filehdr_t *fhdrp, dah_t *dahp)
>  			      ino,
>  			      gen,
>  			      fhdrp->fh_stat.bs_gen);
> -			if (! tranp->t_toconlypr) {
> +			if (!tranp->t_toconlypr) {
>  				assert(hardp->n_dah == DAH_NULL);
>  				hardp->n_dah = dirattr_add(fhdrp);
>  			}
> -		} else if (! tranp->t_toconlypr && hardp->n_dah == DAH_NULL) {
> +		} else if (!tranp->t_toconlypr && hardp->n_dah == DAH_NULL) {
>  			/* case 2: node is a dir, but had thrown away dirattr
>  			 */
>  			mlog(MLOG_TRACE | MLOG_TREE,
> @@ -807,7 +807,7 @@ tree_begindir(filehdr_t *fhdrp, dah_t *dahp)
>  		      ino,
>  		      gen,
>  		      fhdrp->fh_stat.bs_gen);
> -		if (! tranp->t_toconlypr) {
> +		if (!tranp->t_toconlypr) {
>  			dah = dirattr_add(fhdrp);
>  		} else {
>  			dah = DAH_NULL;
> @@ -976,7 +976,7 @@ tree_addent(nh_t parh, xfs_ino_t ino, gen_t gen, char *name, size_t namelen)
>  				assert(namebuflen > 0);
>  				if (hardp->n_parh == parh
>  				     &&
> -				     ! strcmp(tranp->t_namebuf, name)) {
> +				     !strcmp(tranp->t_namebuf, name)) {
>  					/* dir seen as entry again
>  					 */
>  					if (hardp->n_lnkh != NH_NULL) {
> @@ -1151,7 +1151,7 @@ tree_subtree_parse(bool_t sensepr, char *path)
>  			   &ino,
>  			   &isdirpr,
>  			   &isselpr);
> -	if (! ok) {
> +	if (!ok) {
>  		return BOOL_FALSE;
>  	}
>  
> @@ -1200,7 +1200,7 @@ tree_post(char *path1, char *path2)
>  
>  	/* eliminate unreferenced dirents
>  	 */
> -	if (! persp->p_fullpr) {
> +	if (!persp->p_fullpr) {
>  		mlog(MLOG_DEBUG | MLOG_TREE,
>  		      "eliminating unreferenced directory entries\n");
>  		rootp = Node_map(persp->p_rooth);
> @@ -1211,7 +1211,7 @@ tree_post(char *path1, char *path2)
>  					 BOOL_TRUE,
>  					 path1,
>  					 path2);
> -		if (! ok) {
> +		if (!ok) {
>  			return BOOL_FALSE;
>  		}
>  	}
> @@ -1224,7 +1224,7 @@ tree_post(char *path1, char *path2)
>  	cldh = rootp->n_cldh;
>  	Node_unmap(persp->p_rooth, &rootp);
>  	ok = mkdirs_recurse(persp->p_rooth, cldh, path1);
> -	if (! ok) {
> +	if (!ok) {
>  		return BOOL_FALSE;
>  	}
>  
> @@ -1234,14 +1234,14 @@ tree_post(char *path1, char *path2)
>  
>  	/* rename directories
>  	 */
> -	if (! persp->p_fullpr) {
> +	if (!persp->p_fullpr) {
>  		mlog(MLOG_DEBUG | MLOG_TREE,
>  		      "performing directory renames\n");
>  		orphp = Node_map(persp->p_orphh);
>  		cldh = orphp->n_cldh;
>  		Node_unmap(persp->p_orphh, &orphp);
>  		ok = rename_dirs(cldh, path1, path2);
> -		if (! ok) {
> +		if (!ok) {
>  			return BOOL_FALSE;
>  		}
>  	}
> @@ -1252,11 +1252,11 @@ tree_post(char *path1, char *path2)
>  
>  	/* process hard links
>  	 */
> -	if (! persp->p_fullpr) {
> +	if (!persp->p_fullpr) {
>  		mlog(MLOG_DEBUG | MLOG_TREE,
>  		      "processing hard links\n");
>  		ok = proc_hardlinks(path1, path2);
> -		if (! ok) {
> +		if (!ok) {
>  			return BOOL_FALSE;
>  		}
>  	}
> @@ -1318,7 +1318,7 @@ noref_elim_recurse(nh_t parh,
>  						 path1,
>  						 path2);
>  						/* RECURSION */
> -			if (! ok) {
> +			if (!ok) {
>  				return BOOL_FALSE;
>  			}
>  
> @@ -1327,13 +1327,13 @@ noref_elim_recurse(nh_t parh,
>  				continue;
>  			}
>  
> -			if (! isrefpr) {
> +			if (!isrefpr) {
>  				nrh_t nrh;
>  
> -				assert(! isrenamepr);
> +				assert(!isrenamepr);
>  				if (isrealpr) {
>  					ok = Node2path(cldh, path1, _("rmdir"));
> -					if (! ok) {
> +					if (!ok) {
>  						cldh = nextcldh;
>  						continue;
>  					}
> @@ -1370,7 +1370,7 @@ noref_elim_recurse(nh_t parh,
>  				ok = Node2path(cldh,
>  						path1,
>  						_("tmp dir rename src"));
> -				if (! ok) {
> +				if (!ok) {
>  					cldh = nextcldh;
>  					continue;
>  				}
> @@ -1380,7 +1380,7 @@ noref_elim_recurse(nh_t parh,
>  				ok = Node2path(cldh,
>  						path2,
>  						_("tmp dir rename dst"));
> -				if (! ok) {
> +				if (!ok) {
>  					/* REFERENCED */
>  					nrh_t dummynrh;
>  					dummynrh = disown(cldh);
> @@ -1440,8 +1440,8 @@ noref_elim_recurse(nh_t parh,
>  			}
>  
>  			mustorphpr = BOOL_FALSE;
> -			canunlinkpr = ! isrefpr && ! isrealpr;
> -			if (! isrefpr && isrealpr) {
> +			canunlinkpr = !isrefpr && !isrealpr;
> +			if (!isrefpr && isrealpr) {
>  				nh_t hardh;
>  				bool_t neededpr;
>  				hardh = link_hardh(ino, gen);
> @@ -1468,7 +1468,7 @@ noref_elim_recurse(nh_t parh,
>  					if (hardh != cldh && hardisrealpr) {
>  						break;
>  					}
> -					if (hardisrefpr && ! hardisrealpr) {
> +					if (hardisrefpr && !hardisrealpr) {
>  						neededpr = BOOL_TRUE;
>  					}
>  					hardh = nexthardh;
> @@ -1484,11 +1484,11 @@ noref_elim_recurse(nh_t parh,
>  			if (mustorphpr) {
>  				/* rename file to orphanage */
>  				nrh_t nrh;
> -				assert(! canunlinkpr);
> +				assert(!canunlinkpr);
>  				ok = Node2path(cldh,
>  						path1,
>  						_("tmp nondir rename src"));
> -				if (! ok) {
> +				if (!ok) {
>  					cldh = nextcldh;
>  					continue;
>  				}
> @@ -1498,7 +1498,7 @@ noref_elim_recurse(nh_t parh,
>  				ok = Node2path(cldh,
>  						path2,
>  						_("tmp nondir rename dst"));
> -				if (! ok) {
> +				if (!ok) {
>  					/* REFERENCED */
>  					nrh_t dummynrh;
>  					dummynrh = disown(cldh);
> @@ -1536,10 +1536,10 @@ noref_elim_recurse(nh_t parh,
>  				/* REFERENCED */
>  				nrh_t nrh;
>  
> -				assert(! mustorphpr);
> +				assert(!mustorphpr);
>  				if (isrealpr) {
>  					ok = Node2path(cldh, path1, _("rmdir"));
> -					if (! ok) {
> +					if (!ok) {
>  						cldh = nextcldh;
>  						continue;
>  					}
> @@ -1600,10 +1600,10 @@ mkdirs_recurse(nh_t parh, nh_t cldh, char *path)
>  
>  		/* if needed, create a directory and update real flag
>  		 */
> -		if (isdirpr && ! isrealpr && isrefpr && isselpr) {
> +		if (isdirpr && !isrealpr && isrefpr && isselpr) {
>  			int rval;
>  
> -			if (! Node2path(cldh, path, _("makedir"))) {
> +			if (!Node2path(cldh, path, _("makedir"))) {
>  				cldh = nextcldh;
>  				continue;
>  			}
> @@ -1635,7 +1635,7 @@ mkdirs_recurse(nh_t parh, nh_t cldh, char *path)
>  			bool_t ok;
>  			ok = mkdirs_recurse(cldh, grandcldh, path);
>  							/* RECURSION */
> -			if (! ok) {
> +			if (!ok) {
>  				return BOOL_FALSE;
>  			}
>  		}
> @@ -1685,7 +1685,7 @@ rename_dirs(nh_t cldh,
>  			newnrh = renamep->n_nrh;
>  			Node_unmap(renameh, &renamep);
>  			ok = Node2path(cldh, path1, _("rename dir"));
> -			if (! ok) {
> +			if (!ok) {
>  				cldh = nextcldh;
>  				continue;
>  			}
> @@ -1693,7 +1693,7 @@ rename_dirs(nh_t cldh,
>  			assert(dummynrh == NRH_NULL);
>  			adopt(newparh, cldh, newnrh);
>  			ok = Node2path(cldh, path2, _("rename dir"));
> -			if (! ok) {
> +			if (!ok) {
>  				dummynrh = disown(cldh);
>  				assert(dummynrh == newnrh);
>  				adopt(persp->p_orphh, cldh, NRH_NULL);
> @@ -1744,7 +1744,7 @@ tree_cb_links(xfs_ino_t ino,
>  	       gen_t gen,
>  	       int32_t ctime,
>  	       int32_t mtime,
> -	       bool_t (* funcp)(void *contextp,
> +	       bool_t (*funcp)(void *contextp,
>  				   bool_t linkpr,
>  				   char *path1,
>  				   char *path2),
> @@ -1783,13 +1783,13 @@ tree_cb_links(xfs_ino_t ino,
>  		/* build a pathname
>  		 */
>  		ok = Node2path(nh, path, _("restore"));
> -		if (! ok) {
> +		if (!ok) {
>  			continue;
>  		}
>  
>  		/* skip if not in selected subtree
>  		 */
> -		if (! (flags & NF_SUBTREE)) {
> +		if (!(flags & NF_SUBTREE)) {
>  			mlog((MLOG_NITTY + 1) | MLOG_TREE,
>  			      "skipping %s (ino %llu gen %u): %s\n",
>  			      path,
> @@ -1817,9 +1817,9 @@ tree_cb_links(xfs_ino_t ino,
>  		 * so we won't check again. in fact, can't check again
>  		 * since restore changes the answer.
>  		 */
> -		if (! (flags & NF_WRITTEN)) {
> +		if (!(flags & NF_WRITTEN)) {
>  			bool_t exists;
> -			if (! content_overwrite_ok(path,
> +			if (!content_overwrite_ok(path,
>  						     ctime,
>  						     mtime,
>  						     &reasonstr,
> @@ -1842,7 +1842,7 @@ tree_cb_links(xfs_ino_t ino,
>  				 * that may have been set since the dump was
>  				 * taken.
>  				 */
> -				if (! tranp->t_toconlypr && exists) {
> +				if (!tranp->t_toconlypr && exists) {
>  					rval = unlink(path);
>  					if (rval && errno != ENOENT) {
>  						mlog(MLOG_NORMAL |
> @@ -1876,8 +1876,8 @@ tree_cb_links(xfs_ino_t ino,
>  			      ino,
>  			      gen);
>  		}
> -		ok = (* funcp)(contextp, path == path2, path1, path2);
> -		if (! ok) {
> +		ok = (*funcp)(contextp, path == path2, path1, path2);
> +		if (!ok) {
>  			return RV_NOTOK;
>  		}
>  
> @@ -1929,13 +1929,13 @@ tree_cb_links(xfs_ino_t ino,
>  				      "discarding %llu %u\n",
>  				      ino,
>  				      gen);
> -				ok = (* funcp)(contextp, BOOL_FALSE, 0, 0);
> -				if (! ok) {
> +				ok = (*funcp)(contextp, BOOL_FALSE, 0, 0);
> +				if (!ok) {
>  					return RV_NOTOK;
>  				}
>  			} else {
>  
> -				if (! tranp->t_toconlypr) {
> +				if (!tranp->t_toconlypr) {
>  					char *dir;
>  					char tmp[PATH_MAX];
>  
> @@ -1947,9 +1947,9 @@ tree_cb_links(xfs_ino_t ino,
>  				mlog (MLOG_VERBOSE | MLOG_NOTE | MLOG_TREE, _(
>  				      "ino %llu salvaging file,"
>  				      " placing in %s\n"), ino, path1);
> -				ok = (* funcp)(contextp, path == path2,
> +				ok = (*funcp)(contextp, path == path2,
>  					path1, path2);
> -				if (! ok) {
> +				if (!ok) {
>  					return RV_NOTOK;
>  				}
>  			}
> @@ -1974,7 +1974,7 @@ tree_cb_links(xfs_ino_t ino,
>  			adopt(persp->p_orphh, nh, NRH_NULL);
>  			ok = Node2path(nh, path1, _("orphan"));
>  			assert(ok);
> -			(void)(* funcp)(contextp, BOOL_FALSE, path1,path2);
> +			(void)(*funcp)(contextp, BOOL_FALSE, path1,path2);
>  		}
>  	}
>  	return RV_OK;
> @@ -2013,7 +2013,7 @@ tree_adjref_recurse(nh_t cldh,
>  	{
>  		node_t *cldp;
>  		cldp = Node_map(cldh);
> -		if (! pardumpedpr && parrefedpr) {
> +		if (!pardumpedpr && parrefedpr) {
>  			cldp->n_flags |= NF_REFED;
>  		}
>  		clddumpedpr = (int)cldp->n_flags & NF_DUMPEDDIR;
> @@ -2035,12 +2035,12 @@ tree_adjref_recurse(nh_t cldh,
>  
>  static bool_t tree_extattr_recurse(nh_t parh,
>  				    nh_t cldh,
> -				    bool_t (* cbfunc)(char *path,
> +				    bool_t (*cbfunc)(char *path,
>  							 dah_t dah),
>  				    char *path);
>  
>  bool_t
> -tree_extattr(bool_t (* cbfunc)(char *path, dah_t dah), char *path)
> +tree_extattr(bool_t (*cbfunc)(char *path, dah_t dah), char *path)
>  {
>  	node_t *rootp;
>  	nh_t cldh;
> @@ -2057,7 +2057,7 @@ tree_extattr(bool_t (* cbfunc)(char *path, dah_t dah), char *path)
>  static bool_t
>  tree_extattr_recurse(nh_t parh,
>  		      nh_t cldh,
> -		      bool_t (* cbfunc)(char *path, dah_t dah),
> +		      bool_t (*cbfunc)(char *path, dah_t dah),
>  		      char *path)
>  {
>  	node_t *parp;
> @@ -2091,7 +2091,7 @@ tree_extattr_recurse(nh_t parh,
>  						   cbfunc,
>  						   path);
>  							/* RECURSION */
> -			if (! ok) {
> +			if (!ok) {
>  				return BOOL_FALSE;
>  			}
>  		}
> @@ -2106,14 +2106,14 @@ tree_extattr_recurse(nh_t parh,
>  	parp = Node_map(parh);
>  	dah = parp->n_dah;
>  	Node_unmap(parh, &parp);
> -	if (! Node2path(parh, path, _("set dir extattr"))) {
> +	if (!Node2path(parh, path, _("set dir extattr"))) {
>  		mlog (MLOG_NORMAL | MLOG_WARNING | MLOG_TREE,  _(
>  		      "tree_extattr_recurse: Could not convert node to "
>  		      "path for %s\n"), path);
>  		return BOOL_TRUE;
>  	}
>  	if (dah != DAH_NULL) {
> -		ok = (* cbfunc)(path, dah);
> +		ok = (*cbfunc)(path, dah);
>  	} else {
>  		ok = BOOL_TRUE;
>  	}
> @@ -2214,7 +2214,7 @@ proc_hardlinks_cb(void *contextp, nh_t hardheadh)
>  
>  		/* if unrefed, unreal, free node etc. (sel doesn't matter)
>  		 */
> -		if (! isrealpr && ! isrefpr) {
> +		if (!isrealpr && !isrefpr) {
>  			mlog(MLOG_NITTY | MLOG_TREE,
>  			      "freeing node %x: not real, not referenced\n",
>  			      nh);
> @@ -2227,7 +2227,7 @@ proc_hardlinks_cb(void *contextp, nh_t hardheadh)
>  
>  		/* not real, refed, but not selected, can't help
>  		 */
> -		if (! isrealpr &&   isrefpr && ! isselpr) {
> +		if (!isrealpr &&   isrefpr && !isselpr) {
>  			mlog(MLOG_NITTY | MLOG_TREE,
>  			      "skipping node %x: not selected\n",
>  			      nh);
> @@ -2237,7 +2237,7 @@ proc_hardlinks_cb(void *contextp, nh_t hardheadh)
>  
>  		/* if unreal, refed, sel, add to dst list,
>  		 */
> -		if (! isrealpr &&   isrefpr &&   isselpr) {
> +		if (!isrealpr &&   isrefpr &&   isselpr) {
>  			mlog(MLOG_NITTY | MLOG_TREE,
>  			      "making node %x dst: "
>  			      "not real, refed, sel\n",
> @@ -2251,7 +2251,7 @@ proc_hardlinks_cb(void *contextp, nh_t hardheadh)
>  
>  		/* if real, unrefed, sel, add to src list
>  		 */
> -		if (isrealpr && ! isrefpr &&   isselpr) {
> +		if (isrealpr && !isrefpr &&   isselpr) {
>  			mlog(MLOG_NITTY | MLOG_TREE,
>  			      "making node %x src: real, not refed, sel\n",
>  			      nh);
> @@ -2301,13 +2301,13 @@ proc_hardlinks_cb(void *contextp, nh_t hardheadh)
>  		/* build pathname to dst
>  		 */
>  		ok = Node2path(dsth, phcbp->path2, _("rename to"));
> -		if (! ok) {
> +		if (!ok) {
>  			link_in(dsth);
>  			continue;
>  		}
>  
>  		successpr = BOOL_FALSE;
> -		while (! successpr && rnsrcheadh != NH_NULL) {
> +		while (!successpr && rnsrcheadh != NH_NULL) {
>  			nh_t srch;
>  			nrh_t nrh;
>  			node_t *srcp;
> @@ -2321,7 +2321,7 @@ proc_hardlinks_cb(void *contextp, nh_t hardheadh)
>  			/* build a path to src
>  			 */
>  			ok = Node2path(srch, phcbp->path1, _("rename from"));
> -			if (! ok) {
> +			if (!ok) {
>  				link_in(srch);
>  				continue;
>  			}
> @@ -2358,10 +2358,10 @@ proc_hardlinks_cb(void *contextp, nh_t hardheadh)
>  
>  		/* tes@sgi.com: note: loop of one iteration only
>  		 */
> -		while (! successpr && lnsrch != NH_NULL) {
> +		while (!successpr && lnsrch != NH_NULL) {
>  			ok = Node2path(lnsrch, phcbp->path1, _("link"));
>  
> -			if (! ok) {
> +			if (!ok) {
>  				mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_TREE, _(
>  				      "unable to use %s "
>  				      "as a hard link source\n"),
> @@ -2392,7 +2392,7 @@ proc_hardlinks_cb(void *contextp, nh_t hardheadh)
>  			successpr = BOOL_TRUE;
>  		}
>  
> -		if (! successpr) {
> +		if (!successpr) {
>  			mlog(MLOG_NITTY | MLOG_TREE,
>  			      "no link src for node %x\n",
>  			      dsth);
> @@ -2421,7 +2421,7 @@ proc_hardlinks_cb(void *contextp, nh_t hardheadh)
>  		Node_unmap(srch, &srcp);
>  
>  		ok = Node2path(srch, phcbp->path1, _("unlink"));
> -		if (! ok) {
> +		if (!ok) {
>  			link_in(srch);
>  			continue;
>  		}
> @@ -2501,7 +2501,7 @@ tree_setattr_recurse(nh_t parh, char *path)
>  		if (isdirpr && isselpr && isrealpr) {
>  			bool_t ok;
>  			ok = tree_setattr_recurse(cldh, path); /* RECURSION */
> -			if (! ok) {
> +			if (!ok) {
>  				Node_unmap(cldh, &cldp);
>  				return BOOL_FALSE;
>  			}
> @@ -2793,7 +2793,7 @@ restart:
>  
>  		tsi_cmd_parse(buf);
>  		cmdp = tsi_cmd_match();
> -		if (! cmdp) {
> +		if (!cmdp) {
>  			cmdp = tsi_cmd_help;
>  		}
>  	} while (cmdp != tsi_cmd_quit && cmdp != tsi_cmd_extract);
> @@ -2833,14 +2833,14 @@ tsi_cmd_pwd(void *ctxp,
>  	/* special case root
>  	 */
>  	if (tranp->t_inter.i_cwdh == persp->p_rooth) {
> -		(* pcb )(pctxp, "cwd is fs root\n");
> +		(*pcb )(pctxp, "cwd is fs root\n");
>  		return;
>  	}
>  
>  	/* ascend tree recursively, print path on way back
>  	 */
>  	tsi_cmd_pwd_recurse(ctxp, pcb, pctxp, tranp->t_inter.i_cwdh);
> -	(* pcb )(pctxp, "\n");
> +	(*pcb )(pctxp, "\n");
>  }
>  
>  static void
> @@ -2864,14 +2864,14 @@ tsi_cmd_pwd_recurse(void *ctxp,
>  	if (parh != persp->p_rooth) {
>  		tsi_cmd_pwd_recurse(ctxp, pcb, pctxp, parh);
>  			/* RECURSION */
> -		(* pcb )(pctxp, "/");
> +		(*pcb )(pctxp, "/");
>  	}
>  	assert(nrh != NRH_NULL);
>  	namelen = namreg_get(nrh,
>  			      tranp->t_inter.i_name,
>  			      sizeof(tranp->t_inter.i_name));
>  	assert(namelen > 0);
> -	(* pcb)(pctxp, tranp->t_inter.i_name);
> +	(*pcb)(pctxp, tranp->t_inter.i_name);
>  }
>  
>  /* ARGSUSED */
> @@ -2905,14 +2905,14 @@ tsi_cmd_ls(void *ctxp,
>  			   &ino,
>  			   &isdirpr,
>  			   &isselpr);
> -	if (! ok) {
> +	if (!ok) {
>  		return;
>  	}
>  
>  	/* if named is not a dir, just display named
>  	 */
> -	if (! isdirpr) {
> -		(* pcb)(pctxp,
> +	if (!isdirpr) {
> +		(*pcb)(pctxp,
>  			   "    %s %10llu %s%s\n",
>  			   isselpr ? "*" : " ",
>  			   ino,
> @@ -2943,7 +2943,7 @@ tsi_cmd_ls(void *ctxp,
>  					      tranp->t_inter.i_name,
>  					      sizeof(tranp->t_inter.i_name));
>  			assert(namelen > 0);
> -			(* pcb)(pctxp,
> +			(*pcb)(pctxp,
>  				   "    %s %10llu %s%s\n",
>  				   isselpr ? "*" : " ",
>  				   ino,
> @@ -2985,15 +2985,15 @@ tsi_cmd_cd(void *ctxp,
>  			   &ino,
>  			   &isdirpr,
>  			   &isselpr);
> -	if (! ok) {
> +	if (!ok) {
>  		return;
>  	}
>  
>  	/* if named is not a dir, complain
>  	 */
> -	if (! isdirpr) {
> +	if (!isdirpr) {
>  		assert(arg);
> -		(* pcb)(pctxp,
> +		(*pcb)(pctxp,
>  			   _("%s is not a directory\n"),
>  			   arg);
>  
> @@ -3036,7 +3036,7 @@ tsi_cmd_add(void *ctxp,
>  			   &ino,
>  			   &isdirpr,
>  			   &isselpr);
> -	if (! ok) {
> +	if (!ok) {
>  		return;
>  	}
>  
> @@ -3074,7 +3074,7 @@ tsi_cmd_delete(void *ctxp,
>  			   &ino,
>  			   &isdirpr,
>  			   &isselpr);
> -	if (! ok) {
> +	if (!ok) {
>  		return;
>  	}
>  
> @@ -3104,7 +3104,7 @@ tsi_cmd_parse(char *buf)
>  {
>  	int wordcnt;
>  
> -	if (! buf) {
> +	if (!buf) {
>  		tranp->t_inter.i_argc = 0;
>  		return;
>  	}
> @@ -3150,7 +3150,7 @@ tsi_cmd_match(void)
>  	}
>  
>  	for (; tblp < tblendp; tblp++) {
> -		if (! strncmp(tranp->t_inter.i_argv[0],
> +		if (!strncmp(tranp->t_inter.i_argv[0],
>  				tblp->tct_pattern,
>  				strlen(tranp->t_inter.i_argv[0]))) {
>  			break;
> @@ -3186,9 +3186,9 @@ tsi_cmd_help(void *ctxp,
>  				 /
>  				 sizeof(tsi_cmd_tbl[0]);
>  
> -	(* pcb )(pctxp, _("the following commands are available:\n"));
> +	(*pcb )(pctxp, _("the following commands are available:\n"));
>  	for (; tblp < tblendp; tblp++) {
> -		(* pcb)(pctxp,
> +		(*pcb)(pctxp,
>  			   "\t%s %s\n",
>  			   tblp->tct_pattern,
>  			   tblp->tct_help);
> @@ -3266,7 +3266,7 @@ tsi_walkpath(char *arg, nh_t rooth, nh_t cwdh,
>  
>  		/* if no path arg, break
>  		 */
> -		if (! path) {
> +		if (!path) {
>  			break;
>  		}
>  
> @@ -3279,7 +3279,7 @@ tsi_walkpath(char *arg, nh_t rooth, nh_t cwdh,
>  
>  		/* if empty path arg, break
>  		 */
> -		if (! strlen(path)) {
> +		if (!strlen(path)) {
>  			break;
>  		}
>  
> @@ -3302,9 +3302,9 @@ tsi_walkpath(char *arg, nh_t rooth, nh_t cwdh,
>  
>  		/* be sure the named node is a dir
>  		 */
> -		if (! isdirpr) {
> +		if (!isdirpr) {
>  			if (pcb) {
> -				(* pcb)(pctxp, _(
> +				(*pcb)(pctxp, _(
>  					   "parent of %s is not a directory\n"),
>  					   arg);
>  			}
> @@ -3313,7 +3313,7 @@ tsi_walkpath(char *arg, nh_t rooth, nh_t cwdh,
>  
>  		/* special case "."
>  		 */
> -		if (! strcmp(nbuf, ".")) {
> +		if (!strcmp(nbuf, ".")) {
>  			if (strpatchp) {
>  				*strpatchp = '/';
>  			}
> @@ -3322,10 +3322,10 @@ tsi_walkpath(char *arg, nh_t rooth, nh_t cwdh,
>  
>  		/* special case ".."
>  		 */
> -		if (! strcmp(nbuf, "..")) {
> +		if (!strcmp(nbuf, "..")) {
>  			if (parh == NH_NULL) {
>  				if (pcb) {
> -					(* pcb)(pctxp, _(
> +					(*pcb)(pctxp, _(
>  						   "%s above root\n"),
>  						   arg);
>  				}
> @@ -3368,7 +3368,7 @@ tsi_walkpath(char *arg, nh_t rooth, nh_t cwdh,
>  						     tranp->t_inter.i_name,
>  					       sizeof(tranp->t_inter.i_name));
>  				assert(siblen > 0);
> -				if (! strcmp(nbuf, tranp->t_inter.i_name)) {
> +				if (!strcmp(nbuf, tranp->t_inter.i_name)) {
>  					break;
>  				}
>  			}
> @@ -3379,7 +3379,7 @@ tsi_walkpath(char *arg, nh_t rooth, nh_t cwdh,
>  		 */
>  		if (sibh == NH_NULL) {
>  			if (pcb) {
> -				(* pcb)(pctxp, _(
> +				(*pcb)(pctxp, _(
>  					   "%s not found\n"),
>  					   arg);
>  			}
> @@ -3751,7 +3751,7 @@ selsubtree(nh_t nh, bool_t sensepr)
>  				}
>  				cldh = nextcldh;
>  			}
> -			if (! atleastonechildselpr) {
> +			if (!atleastonechildselpr) {
>  				parp->n_flags &= ~NF_SUBTREE;
>  				/* DBG could break out here (remember to unmap!)
>  				 */
> @@ -3787,7 +3787,7 @@ selsubtree_recurse_down(nh_t nh, bool_t sensepr)
>  		gen = np->n_gen;
>  		isdirpr = (np->n_flags & NF_ISDIR);
>  		Node_unmap(nh, &np);
> -		if (! isdirpr) {
> +		if (!isdirpr) {
>  			if (sensepr) {
>  				inomap_rst_add(ino);
>  			} else {
> @@ -3810,7 +3810,7 @@ selsubtree_recurse_down(nh_t nh, bool_t sensepr)
>  						break;
>  					}
>  				}
> -				if (! neededpr) {
> +				if (!neededpr) {
>  					inomap_rst_del(ino);
>  				}
>  			}
> @@ -3875,7 +3875,7 @@ link_matchh(nh_t hardh, nh_t parh, char *name)
>  					      tranp->t_namebuf,
>  					      sizeof(tranp->t_namebuf));
>  			assert(namelen > 0);
> -			if (! strcmp(name, tranp->t_namebuf)) {
> +			if (!strcmp(name, tranp->t_namebuf)) {
>  				Node_unmap(hardh, &np);
>  				break;
>  			}
> @@ -3999,7 +3999,7 @@ link_out(nh_t nh)
>   * iteration aborted if callback returns FALSE
>   */
>  static void
> -link_headiter(bool_t (* cbfp)(void *contextp, nh_t hardh), void *contextp)
> +link_headiter(bool_t (*cbfp)(void *contextp, nh_t hardh), void *contextp)
>  {
>  	hash_iter(cbfp, contextp);
>  }
> @@ -4152,8 +4152,8 @@ hash_init(size64_t vmsz,
>  	/* map the hash array just after the persistent state header
>  	 */
>  	assert(persp->p_hashsz <= SIZEMAX);
> -	assert(! (persp->p_hashsz % (size64_t)pgsz));
> -	assert(! (PERSSZ % pgsz));
> +	assert(!(persp->p_hashsz % (size64_t)pgsz));
> +	assert(!(PERSSZ % pgsz));
>  	tranp->t_hashp = (nh_t *) mmap_autogrow(
>  					    (size_t)persp->p_hashsz,
>  					    tranp->t_persfd,
> @@ -4193,13 +4193,13 @@ hash_sync(char *perspath)
>  	/* retrieve the hash size from the persistent state
>  	 */
>  	hashsz = persp->p_hashsz;
> -	assert(! (hashsz % sizeof(nh_t)));
> +	assert(!(hashsz % sizeof(nh_t)));
>  
>  	/* map the hash array just after the persistent state header
>  	 */
>  	assert(hashsz <= SIZEMAX);
> -	assert(! (hashsz % (size64_t)pgsz));
> -	assert(! (PERSSZ % pgsz));
> +	assert(!(hashsz % (size64_t)pgsz));
> +	assert(!(PERSSZ % pgsz));
>  	tranp->t_hashp = (nh_t *) mmap_autogrow(
>  					    (size_t)hashsz,
>  					    tranp->t_persfd,
> @@ -4369,7 +4369,7 @@ hash_find(xfs_ino_t ino, gen_t gen)
>   * must figure next node prior to calling callback.
>   */
>  static void
> -hash_iter(bool_t (* cbfp)(void *contextp, nh_t hashh), void *contextp)
> +hash_iter(bool_t (*cbfp)(void *contextp, nh_t hashh), void *contextp)
>  {
>  	ix_t hix;
>  	size64_t hashlen = persp->p_hashsz / sizeof(nh_t);
> @@ -4386,8 +4386,8 @@ hash_iter(bool_t (* cbfp)(void *contextp, nh_t hashh), void *contextp)
>  			nexth = np->n_hashh;
>  			Node_unmap(nh, &np);
>  
> -			ok = (* cbfp)(contextp, nh);
> -			if (! ok) {
> +			ok = (*cbfp)(contextp, nh);
> +			if (!ok) {
>  				return;
>  			}
>  
> @@ -4429,7 +4429,7 @@ Node_chk(nh_t nh, nh_t *nexthashhp, nh_t *nextlnkhp)
>  	n = *np;
>  	Node_unmap(nh, &np);
>  
> -	if (! nexthashhp && n.n_hashh != NH_NULL) {
> +	if (!nexthashhp && n.n_hashh != NH_NULL) {
>  		mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_TREE, _(
>  		      "nh 0x%x np 0x%x hash link not null\n"),
>  		      nh,
> @@ -4501,13 +4501,13 @@ tree_chk(void)
>  			nh_t lnkh;
>  
>  			ok = Node_chk(hashh, &hashh, &lnkh);
> -			if (! ok) {
> +			if (!ok) {
>  				okaccum = BOOL_FALSE;
>  			}
>  
>  			while (lnkh != NH_NULL) {
>  				ok = Node_chk(lnkh, 0, &lnkh);
> -				if (! ok) {
> +				if (!ok) {
>  					okaccum = BOOL_FALSE;
>  				}
>  			}
> @@ -4515,7 +4515,7 @@ tree_chk(void)
>  	}
>  
>  	ok = tree_chk2();
> -	if (! ok) {
> +	if (!ok) {
>  		okaccum = BOOL_FALSE;
>  	}
>  
> @@ -4610,7 +4610,7 @@ tree_chk2_recurse(nh_t cldh, nh_t parh)
>  			      parh);
>  		}
>  		ok = tree_chk2_recurse(grandcldh, cldh);
> -		if (! ok) {
> +		if (!ok) {
>  			okaccum = BOOL_FALSE;
>  		}
>  
> @@ -4646,7 +4646,7 @@ parse(int slotcnt, char **slotbuf, char *string)
>  	 * characters which are to be interpreted literally.
>  	 */
>  	liter = (char *)calloc(1, strlen(string) + 1);
> -	if (! liter) {
> +	if (!liter) {
>  		return -1;
>  	}
>  
> @@ -4654,7 +4654,7 @@ parse(int slotcnt, char **slotbuf, char *string)
>  	 * are to be interpreted literally
>  	 */
>  	for (s = string, l = liter; *s; s++, l++) {
> -		if (*s == '\\' && ! *l) {
> +		if (*s == '\\' && !*l) {
>  			fix_escape(s, l);
>  		}
>  	}
> @@ -4671,7 +4671,7 @@ parse(int slotcnt, char **slotbuf, char *string)
>  	/* pass 3: collapse white space spans into a single space
>  	 */
>  	for (s = string, l = liter; *s; s++, l++) {
> -		if (is_white(*s) && ! *l) {
> +		if (is_white(*s) && !*l) {
>  			collapse_white(s, l);
>  		}
>  	}
> @@ -4839,7 +4839,7 @@ collapse_white(char *string, char *liter)
>  	size_t cnt;
>  
>  	cnt = 0;
> -	for (s = string, l = liter; is_white(*s) && ! *l; s++, l++) {
> +	for (s = string, l = liter; is_white(*s) && !*l; s++, l++) {
>  		cnt++;
>  	}
>  
> @@ -4856,7 +4856,7 @@ distance_to_space(char *s, char *l)
>  {
>  	size_t cnt;
>  
> -	for (cnt = 0; *s && (! is_white(*s) || *l); s++, l++) {
> +	for (cnt = 0; *s && (!is_white(*s) || *l); s++, l++) {
>  		cnt++;
>  	}
>  
> diff --git a/restore/tree.h b/restore/tree.h
> index 6c9551b..4f9ffe8 100644
> --- a/restore/tree.h
> +++ b/restore/tree.h
> @@ -97,7 +97,7 @@ extern rv_t tree_cb_links(xfs_ino_t ino,
>  			   gen_t gen,
>  			   int32_t ctime,
>  			   int32_t mtime,
> -			   bool_t (* funcp)(void *contextp,
> +			   bool_t (*funcp)(void *contextp,
>  					       bool_t linkpr,
>  					       char *path1,
>  					       char *path2),
> @@ -115,7 +115,7 @@ extern bool_t tree_setattr(char *path);
>  extern bool_t tree_delorph(void);
>  extern bool_t tree_subtree_inter(void);
>  
> -extern bool_t tree_extattr(bool_t (* cbfunc)(char *path, dah_t dah),
> +extern bool_t tree_extattr(bool_t (*cbfunc)(char *path, dah_t dah),
>  			    char *path);
>  	/* does a depthwise bottom-up traversal of the tree, calling
>  	 * the supplied callback for all directories with a non-NULL dirattr
> diff --git a/restore/win.c b/restore/win.c
> index 53ca9b8..5d40592 100644
> --- a/restore/win.c
> +++ b/restore/win.c
> @@ -225,8 +225,8 @@ win_map(segix_t segix, void **pp)
>  			winp->w_prevp = 0;
>  			winp->w_nextp = 0;
>  		} else {
> -			assert(! winp->w_prevp);
> -			assert(! winp->w_nextp);
> +			assert(!winp->w_prevp);
> +			assert(!winp->w_nextp);
>  		}
>  		winp->w_refcnt++;
>  		*pp = winp->w_p;
> @@ -262,7 +262,7 @@ win_map(segix_t segix, void **pp)
>  		}
>  		tranp->t_segmap[winp->w_segix] = NULL;
>  		rval = munmap(winp->w_p, tranp->t_segsz);
> -		assert(! rval);
> +		assert(!rval);
>  		memset((void *)winp, 0, sizeof(win_t));
>  	} else {
>  		assert(tranp->t_wincnt == tranp->t_winmax);
> @@ -283,8 +283,8 @@ win_map(segix_t segix, void **pp)
>  	assert(tranp->t_firstoff
>  		<=
>  		OFF64MAX - segoff - (off64_t)tranp->t_segsz + 1ll);
> -	assert(! (tranp->t_segsz % pgsz));
> -	assert(! ((tranp->t_firstoff + segoff) % (off64_t)pgsz));
> +	assert(!(tranp->t_segsz % pgsz));
> +	assert(!((tranp->t_firstoff + segoff) % (off64_t)pgsz));
>  #ifdef TREE_DEBUG
>  	mlog(MLOG_DEBUG | MLOG_TREE | MLOG_NOLOCK,
>  	     "win_map(): mmap segment at %lld, size = %llu\n",
> @@ -350,8 +350,8 @@ win_unmap(segix_t segix, void **pp)
>  	 */
>  	assert(winp->w_refcnt > 0);
>  	winp->w_refcnt--;
> -	assert(! winp->w_prevp);
> -	assert(! winp->w_nextp);
> +	assert(!winp->w_prevp);
> +	assert(!winp->w_nextp);
>  	if (winp->w_refcnt == 0) {
>  		if (tranp->t_lrutailp) {
>  			assert(tranp->t_lruheadp);
> @@ -359,12 +359,12 @@ win_unmap(segix_t segix, void **pp)
>  			tranp->t_lrutailp->w_nextp = winp;
>  			tranp->t_lrutailp = winp;
>  		} else {
> -			assert(! tranp->t_lruheadp);
> -			assert(! winp->w_prevp);
> +			assert(!tranp->t_lruheadp);
> +			assert(!winp->w_prevp);
>  			tranp->t_lruheadp = winp;
>  			tranp->t_lrutailp = winp;
>  		}
> -		assert(! winp->w_nextp);
> +		assert(!winp->w_nextp);
>  	}
>  
>  	/* zero the caller's pointer
> -- 
> 2.21.0
> 
