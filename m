Return-Path: <SRS0=KqY6=Y6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 532B3C5DF63
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Nov 2019 15:51:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1168021882
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Nov 2019 15:51:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DjfJE+3T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728018AbfKFPv5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Nov 2019 10:51:57 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:42010 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727321AbfKFPv5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Nov 2019 10:51:57 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA6FmuJJ075892;
        Wed, 6 Nov 2019 15:51:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=pmuVKTnrN2Pu44IKHOpkLXpXOWL5cNtV52QJfbWL4Fo=;
 b=DjfJE+3T9rYNM1072YalXvimu4NnLU8XUCClgLCzsobzUre9hsvr1/9y5xDLH9ImDdLc
 MbOpeDYydy1ASm9vsJ0xixDA3I/Rr0MGMY3uJM1YTSeE9ZwZPOuS0S333ZFfxPdSQ49y
 zYX+bitD6Vq05mq16ihBtZhRMPRMzWWMATXCbzOZ0GJzST8OXOYaAIH2TMqRiZjQbEXQ
 PuJw48lvelWtLGHiMrlHx9kma/clfxN3QtT/LoMr+7hn1klLpq+qaiuB03dEfYbsCyXv
 LIJXVTFzHZsHahscDiYuwQNeV5toWfejvE1QmhjLbP5vTNIZ2nMLOjL33rgh8thBV70M pA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2w11rq7mws-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 15:51:51 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA6FmaIM143516;
        Wed, 6 Nov 2019 15:51:51 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2w3vr310s8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 15:51:51 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA6FpnaB019567;
        Wed, 6 Nov 2019 15:51:50 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 07:51:49 -0800
Date:   Wed, 6 Nov 2019 07:51:48 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs_scrub: implement deferred description string
 rendering
Message-ID: <20191106155148.GI4153244@magnolia>
References: <157177017664.1460581.13561167273786314634.stgit@magnolia>
 <157177018914.1460581.6983232302876165323.stgit@magnolia>
 <20191106103809.so66jtxxz3kb5zwf@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191106103809.so66jtxxz3kb5zwf@orion>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911060152
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911060152
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 06, 2019 at 11:38:09AM +0100, Carlos Maiolino wrote:
> Hi Darrick.
> 
> This set looks mostly good, but there is one part in this patch (see below),
> which is kind confusing to me:
> 
> > +#include <sys/statvfs.h>
> > +#include "platform_defs.h"
> > +#include "input.h"
> > +#include "libfrog/paths.h"
> > +#include "libfrog/ptvar.h"
> > +#include "xfs_scrub.h"
> > +#include "common.h"
> > +#include "descr.h"
> > +
> > +/*
> > + * Deferred String Description Renderer
> > + * ====================================
> > + * There are many places in xfs_scrub where some event occurred and we'd like
> > + * to be able to print some sort of message describing what happened, and
> > + * where.  However, we don't know whether we're going to need the description
> > + * of where ahead of time and there's little point in spending any time looking
> > + * up gettext strings and formatting buffers until we actually need to.
> > + *
> > + * This code provides enough of a function closure that we are able to record
> > + * some information about the program status but defer rendering the textual
> > + * description until we know that we need it.  Once we've rendered the string
> > + * we can skip it for subsequent calls.  We use per-thread storage for the
> > + * message buffer to amortize the memory allocation across calls.
> > + *
> > + * On a clean filesystem this can reduce the xfs_scrub runtime by 7-10% by
> > + * avoiding unnecessary work.
> > + */
> > +
> > +static struct ptvar *descr_ptvar;
> > +
> > +/* Global buffer for when we aren't running in threaded mode. */
> > +static char global_dsc_buf[DESCR_BUFSZ];
> > +
> > +/*
> > + * Render a textual description string using the function and location stored
> > + * in the description context.
> > + */
> > +const char *
> > +__descr_render(
> > +	struct descr		*dsc,
> > +	const char		*file,
> > +	int			line)
> > +{
> > +	char			*dsc_buf;
> > +	int			ret;
> > +
> > +	if (descr_ptvar) {
> > +		dsc_buf = ptvar_get(descr_ptvar, &ret);
> > +		if (ret)
> > +			return _("error finding description buffer");
> > +	} else
> > +		dsc_buf = global_dsc_buf;
> > +
> > +	ret = dsc->fn(dsc->ctx, dsc_buf, DESCR_BUFSZ, dsc->where);
> > +	if (ret < 0) {
> > +		snprintf(dsc_buf, DESCR_BUFSZ,
> > +_("error %d while rendering description at %s line %d\n"),
> > +				ret, file, line);
> > +	}
> > +
> > +	return dsc_buf;
> > +}
> > +
> > +/*
> > + * Set a new location for this deferred-rendering string and discard any
> > + * old rendering.
> > + */
> > +void
> > +descr_set(
> > +	struct descr		*dsc,
> > +	void			*where)
> > +{
> > +	dsc->where = where;
> > +}
> 
> The comment on this function is actually confusing me. What exactly
> you mean by 'discard any old rendering' here?
> 
> Even though you use it on fresh created struct descr during the patch,
> the comment gave me the impression you intend to use this function to
> set a new location to an already created descriptor,

Correct.

> but it's not clear to me, if, this is the case, who is responsible to
> free up the memory previously associated with the dsc->where pointer
> here, and so, it just feels like a potential memory leak landmine
> here.

It's the caller's responsibility.  So far all three callers passed in
pointers local stack variables, so the variable and the @dsc disappear
into the aether when the function returns.

> Maybe I've got confused by the comment or didn't fully understand your
> intention here.

Nah, the problem is that the comment is unclear.  How about:

/*
 * Set a new location context for this deferred-rendering string.
 * The caller is responsible for freeing the old context, if necessary.
 */

Question: does this API need to return the old context?  For now the
void return is fine under the "YAGNI" principle, since we can always add
it later if the usage pattern changes.

> My apologies if I'm talking something nonsense, I'm trying to catch up
> with all the scrub work yet.

I appreciate it!

--D

> 
> Cheers.
> 
> 
> > +
> > +/* Allocate all the description string buffers. */
> > +int
> > +descr_init_phase(
> > +	struct scrub_ctx	*ctx,
> > +	unsigned int		nr_threads)
> > +{
> > +	int			ret;
> > +
> > +	assert(descr_ptvar == NULL);
> > +	ret = ptvar_alloc(nr_threads, DESCR_BUFSZ, &descr_ptvar);
> > +	if (ret)
> > +		str_liberror(ctx, ret, _("creating description buffer"));
> > +
> > +	return ret;
> > +}
> > +
> > +/* Free all the description string buffers. */
> > +void
> > +descr_end_phase(void)
> > +{
> > +	if (descr_ptvar)
> > +		ptvar_free(descr_ptvar);
> > +	descr_ptvar = NULL;
> > +}
> > diff --git a/scrub/descr.h b/scrub/descr.h
> > new file mode 100644
> > index 00000000..f1899b67
> > --- /dev/null
> > +++ b/scrub/descr.h
> > @@ -0,0 +1,29 @@
> > +/* SPDX-License-Identifier: GPL-2.0-or-later */
> > +/*
> > + * Copyright (C) 2019 Oracle.  All Rights Reserved.
> > + * Author: Darrick J. Wong <darrick.wong@oracle.com>
> > + */
> > +#ifndef XFS_SCRUB_DESCR_H_
> > +#define XFS_SCRUB_DESCR_H_
> > +
> > +typedef int (*descr_fn)(struct scrub_ctx *ctx, char *buf, size_t buflen,
> > +			void *data);
> > +
> > +struct descr {
> > +	struct scrub_ctx	*ctx;
> > +	descr_fn		fn;
> > +	void			*where;
> > +};
> > +
> > +#define DEFINE_DESCR(_name, _ctx, _fn) \
> > +	struct descr _name = { .ctx = (_ctx), .fn = (_fn) }
> > +
> > +const char *__descr_render(struct descr *dsc, const char *file, int line);
> > +#define descr_render(dsc) __descr_render((dsc), __FILE__, __LINE__)
> > +
> > +void descr_set(struct descr *dsc, void *where);
> > +
> > +int descr_init_phase(struct scrub_ctx *ctx, unsigned int nr_threads);
> > +void descr_end_phase(void);
> > +
> > +#endif /* XFS_SCRUB_DESCR_H_ */
> > diff --git a/scrub/scrub.c b/scrub/scrub.c
> > index 718f09b8..d9df1e5b 100644
> > --- a/scrub/scrub.c
> > +++ b/scrub/scrub.c
> > @@ -20,37 +20,40 @@
> >  #include "scrub.h"
> >  #include "xfs_errortag.h"
> >  #include "repair.h"
> > +#include "descr.h"
> >  
> >  /* Online scrub and repair wrappers. */
> >  
> >  /* Format a scrub description. */
> > -static void
> > +static int
> >  format_scrub_descr(
> >  	struct scrub_ctx		*ctx,
> >  	char				*buf,
> >  	size_t				buflen,
> > -	struct xfs_scrub_metadata	*meta)
> > +	void				*where)
> >  {
> > +	struct xfs_scrub_metadata	*meta = where;
> >  	const struct xfrog_scrub_descr	*sc = &xfrog_scrubbers[meta->sm_type];
> >  
> >  	switch (sc->type) {
> >  	case XFROG_SCRUB_TYPE_AGHEADER:
> >  	case XFROG_SCRUB_TYPE_PERAG:
> > -		snprintf(buf, buflen, _("AG %u %s"), meta->sm_agno,
> > +		return snprintf(buf, buflen, _("AG %u %s"), meta->sm_agno,
> >  				_(sc->descr));
> >  		break;
> >  	case XFROG_SCRUB_TYPE_INODE:
> > -		scrub_render_ino_descr(ctx, buf, buflen,
> > +		return scrub_render_ino_descr(ctx, buf, buflen,
> >  				meta->sm_ino, meta->sm_gen, "%s",
> >  				_(sc->descr));
> >  		break;
> >  	case XFROG_SCRUB_TYPE_FS:
> > -		snprintf(buf, buflen, _("%s"), _(sc->descr));
> > +		return snprintf(buf, buflen, _("%s"), _(sc->descr));
> >  		break;
> >  	case XFROG_SCRUB_TYPE_NONE:
> >  		assert(0);
> >  		break;
> >  	}
> > +	return -1;
> >  }
> >  
> >  /* Predicates for scrub flag state. */
> > @@ -95,21 +98,24 @@ static inline bool needs_repair(struct xfs_scrub_metadata *sm)
> >  static inline void
> >  xfs_scrub_warn_incomplete_scrub(
> >  	struct scrub_ctx		*ctx,
> > -	const char			*descr,
> > +	struct descr			*dsc,
> >  	struct xfs_scrub_metadata	*meta)
> >  {
> >  	if (is_incomplete(meta))
> > -		str_info(ctx, descr, _("Check incomplete."));
> > +		str_info(ctx, descr_render(dsc), _("Check incomplete."));
> >  
> >  	if (is_suspicious(meta)) {
> >  		if (debug)
> > -			str_info(ctx, descr, _("Possibly suspect metadata."));
> > +			str_info(ctx, descr_render(dsc),
> > +					_("Possibly suspect metadata."));
> >  		else
> > -			str_warn(ctx, descr, _("Possibly suspect metadata."));
> > +			str_warn(ctx, descr_render(dsc),
> > +					_("Possibly suspect metadata."));
> >  	}
> >  
> >  	if (xref_failed(meta))
> > -		str_info(ctx, descr, _("Cross-referencing failed."));
> > +		str_info(ctx, descr_render(dsc),
> > +				_("Cross-referencing failed."));
> >  }
> >  
> >  /* Do a read-only check of some metadata. */
> > @@ -119,16 +125,16 @@ xfs_check_metadata(
> >  	struct xfs_scrub_metadata	*meta,
> >  	bool				is_inode)
> >  {
> > -	char				buf[DESCR_BUFSZ];
> > +	DEFINE_DESCR(dsc, ctx, format_scrub_descr);
> >  	unsigned int			tries = 0;
> >  	int				code;
> >  	int				error;
> >  
> >  	assert(!debug_tweak_on("XFS_SCRUB_NO_KERNEL"));
> >  	assert(meta->sm_type < XFS_SCRUB_TYPE_NR);
> > -	format_scrub_descr(ctx, buf, DESCR_BUFSZ, meta);
> > +	descr_set(&dsc, meta);
> >  
> > -	dbg_printf("check %s flags %xh\n", buf, meta->sm_flags);
> > +	dbg_printf("check %s flags %xh\n", descr_render(&dsc), meta->sm_flags);
> >  retry:
> >  	error = xfrog_scrub_metadata(&ctx->mnt, meta);
> >  	if (debug_tweak_on("XFS_SCRUB_FORCE_REPAIR") && !error)
> > @@ -141,13 +147,13 @@ xfs_check_metadata(
> >  			return CHECK_DONE;
> >  		case ESHUTDOWN:
> >  			/* FS already crashed, give up. */
> > -			str_error(ctx, buf,
> > +			str_error(ctx, descr_render(&dsc),
> >  _("Filesystem is shut down, aborting."));
> >  			return CHECK_ABORT;
> >  		case EIO:
> >  		case ENOMEM:
> >  			/* Abort on I/O errors or insufficient memory. */
> > -			str_errno(ctx, buf);
> > +			str_errno(ctx, descr_render(&dsc));
> >  			return CHECK_ABORT;
> >  		case EDEADLOCK:
> >  		case EBUSY:
> > @@ -161,7 +167,7 @@ _("Filesystem is shut down, aborting."));
> >  			/* fall through */
> >  		default:
> >  			/* Operational error. */
> > -			str_errno(ctx, buf);
> > +			str_errno(ctx, descr_render(&dsc));
> >  			return CHECK_DONE;
> >  		}
> >  	}
> > @@ -179,7 +185,7 @@ _("Filesystem is shut down, aborting."));
> >  	}
> >  
> >  	/* Complain about incomplete or suspicious metadata. */
> > -	xfs_scrub_warn_incomplete_scrub(ctx, buf, meta);
> > +	xfs_scrub_warn_incomplete_scrub(ctx, &dsc, meta);
> >  
> >  	/*
> >  	 * If we need repairs or there were discrepancies, schedule a
> > @@ -187,7 +193,7 @@ _("Filesystem is shut down, aborting."));
> >  	 */
> >  	if (is_corrupt(meta) || xref_disagrees(meta)) {
> >  		if (ctx->mode < SCRUB_MODE_REPAIR) {
> > -			str_corrupt(ctx, buf,
> > +			str_corrupt(ctx, descr_render(&dsc),
> >  _("Repairs are required."));
> >  			return CHECK_DONE;
> >  		}
> > @@ -203,7 +209,7 @@ _("Repairs are required."));
> >  		if (ctx->mode != SCRUB_MODE_REPAIR) {
> >  			if (!is_inode) {
> >  				/* AG or FS metadata, always warn. */
> > -				str_info(ctx, buf,
> > +				str_info(ctx, descr_render(&dsc),
> >  _("Optimization is possible."));
> >  			} else if (!ctx->preen_triggers[meta->sm_type]) {
> >  				/* File metadata, only warn once per type. */
> > @@ -656,9 +662,9 @@ xfs_repair_metadata(
> >  	struct action_item		*aitem,
> >  	unsigned int			repair_flags)
> >  {
> > -	char				buf[DESCR_BUFSZ];
> >  	struct xfs_scrub_metadata	meta = { 0 };
> >  	struct xfs_scrub_metadata	oldm;
> > +	DEFINE_DESCR(dsc, ctx, format_scrub_descr);
> >  	int				error;
> >  
> >  	assert(aitem->type < XFS_SCRUB_TYPE_NR);
> > @@ -682,12 +688,13 @@ xfs_repair_metadata(
> >  		return CHECK_RETRY;
> >  
> >  	memcpy(&oldm, &meta, sizeof(oldm));
> > -	format_scrub_descr(ctx, buf, DESCR_BUFSZ, &meta);
> > +	descr_set(&dsc, &oldm);
> >  
> >  	if (needs_repair(&meta))
> > -		str_info(ctx, buf, _("Attempting repair."));
> > +		str_info(ctx, descr_render(&dsc), _("Attempting repair."));
> >  	else if (debug || verbose)
> > -		str_info(ctx, buf, _("Attempting optimization."));
> > +		str_info(ctx, descr_render(&dsc),
> > +				_("Attempting optimization."));
> >  
> >  	error = xfrog_scrub_metadata(&ctx->mnt, &meta);
> >  	if (error) {
> > @@ -696,12 +703,12 @@ xfs_repair_metadata(
> >  		case EBUSY:
> >  			/* Filesystem is busy, try again later. */
> >  			if (debug || verbose)
> > -				str_info(ctx, buf,
> > +				str_info(ctx, descr_render(&dsc),
> >  _("Filesystem is busy, deferring repair."));
> >  			return CHECK_RETRY;
> >  		case ESHUTDOWN:
> >  			/* Filesystem is already shut down, abort. */
> > -			str_error(ctx, buf,
> > +			str_error(ctx, descr_render(&dsc),
> >  _("Filesystem is shut down, aborting."));
> >  			return CHECK_ABORT;
> >  		case ENOTTY:
> > @@ -726,13 +733,13 @@ _("Filesystem is shut down, aborting."));
> >  			/* fall through */
> >  		case EINVAL:
> >  			/* Kernel doesn't know how to repair this? */
> > -			str_corrupt(ctx, buf,
> > +			str_corrupt(ctx, descr_render(&dsc),
> >  _("Don't know how to fix; offline repair required."));
> >  			return CHECK_DONE;
> >  		case EROFS:
> >  			/* Read-only filesystem, can't fix. */
> >  			if (verbose || debug || needs_repair(&oldm))
> > -				str_error(ctx, buf,
> > +				str_error(ctx, descr_render(&dsc),
> >  _("Read-only filesystem; cannot make changes."));
> >  			return CHECK_ABORT;
> >  		case ENOENT:
> > @@ -753,12 +760,12 @@ _("Read-only filesystem; cannot make changes."));
> >  			 */
> >  			if (!(repair_flags & XRM_COMPLAIN_IF_UNFIXED))
> >  				return CHECK_RETRY;
> > -			str_errno(ctx, buf);
> > +			str_errno(ctx, descr_render(&dsc));
> >  			return CHECK_DONE;
> >  		}
> >  	}
> >  	if (repair_flags & XRM_COMPLAIN_IF_UNFIXED)
> > -		xfs_scrub_warn_incomplete_scrub(ctx, buf, &meta);
> > +		xfs_scrub_warn_incomplete_scrub(ctx, &dsc, &meta);
> >  	if (needs_repair(&meta)) {
> >  		/*
> >  		 * Still broken; if we've been told not to complain then we
> > @@ -767,14 +774,16 @@ _("Read-only filesystem; cannot make changes."));
> >  		 */
> >  		if (!(repair_flags & XRM_COMPLAIN_IF_UNFIXED))
> >  			return CHECK_RETRY;
> > -		str_corrupt(ctx, buf,
> > +		str_corrupt(ctx, descr_render(&dsc),
> >  _("Repair unsuccessful; offline repair required."));
> >  	} else {
> >  		/* Clean operation, no corruption detected. */
> >  		if (needs_repair(&oldm))
> > -			record_repair(ctx, buf, _("Repairs successful."));
> > +			record_repair(ctx, descr_render(&dsc),
> > +					_("Repairs successful."));
> >  		else
> > -			record_preen(ctx, buf, _("Optimization successful."));
> > +			record_preen(ctx, descr_render(&dsc),
> > +					_("Optimization successful."));
> >  	}
> >  	return CHECK_DONE;
> >  }
> > diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
> > index fe76d075..9945c7f4 100644
> > --- a/scrub/xfs_scrub.c
> > +++ b/scrub/xfs_scrub.c
> > @@ -15,6 +15,7 @@
> >  #include "libfrog/paths.h"
> >  #include "xfs_scrub.h"
> >  #include "common.h"
> > +#include "descr.h"
> >  #include "unicrash.h"
> >  #include "progress.h"
> >  
> > @@ -467,8 +468,14 @@ run_scrub_phases(
> >  			work_threads++;
> >  			moveon = progress_init_phase(ctx, progress_fp, phase,
> >  					max_work, rshift, work_threads);
> > +			if (!moveon)
> > +				break;
> > +			moveon = descr_init_phase(ctx, work_threads) == 0;
> >  		} else {
> >  			moveon = progress_init_phase(ctx, NULL, phase, 0, 0, 0);
> > +			if (!moveon)
> > +				break;
> > +			moveon = descr_init_phase(ctx, 1) == 0;
> >  		}
> >  		if (!moveon)
> >  			break;
> > @@ -480,6 +487,7 @@ _("Scrub aborted after phase %d."),
> >  			break;
> >  		}
> >  		progress_end_phase();
> > +		descr_end_phase();
> >  		moveon = phase_end(&pi, phase);
> >  		if (!moveon)
> >  			break;
> > 
> 
> -- 
> Carlos
> 
