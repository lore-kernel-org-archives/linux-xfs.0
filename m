Return-Path: <SRS0=KqY6=Y6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFAB1C5DF62
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Nov 2019 10:38:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D6D120869
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Nov 2019 10:38:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="av6Q0Ao3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727560AbfKFKiT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Nov 2019 05:38:19 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:52825 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725937AbfKFKiS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Nov 2019 05:38:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573036696;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XbxoMbcg/EbOvVcDOKWISZtZ5VA25ocy5lJ5q67SRwk=;
        b=av6Q0Ao35Yg/ajv6KWSkQ7Z9idAaoNatn7zFBUrhgofK3P8bzg4ZWnRp7KsDR2xp0ZAj9H
        vEqtpjNQ9zlsFyG43avX14jtDE7D82ngezdKQNkG9skDfHtV3VqVCxiq3TI9V4CA9tVOhH
        W90DANTd74G4ODlNrmB/X+M0PC1ZK60=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-154-yfVITP-8NFuBWlw-79iGyw-1; Wed, 06 Nov 2019 05:38:14 -0500
Received: by mail-wr1-f70.google.com with SMTP id v6so4554058wrm.18
        for <linux-xfs@vger.kernel.org>; Wed, 06 Nov 2019 02:38:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=eBeXn+cI3fUeo069xXtao1ifH4ROkQ+/hJRksyNyDZE=;
        b=NXbmrxTJyQ3S0VrwRWFcqwYGynTIHZw4HyEhI5H4SgbF36cabeEiALK1tq8kEs98Ja
         0jU7F8GELANBovExskMLVNyOIX9obWgATgArb5S67PDHn94DU3WU0t8o+6lGqBQ8Yibp
         CrrM+w2PL7wysVdvXjfP+RpqkzpMQ3vYmGgBBPYV8szqVQUnbPZnqTouHNKMghUmN9ob
         j5yCpojXy/nzy7CoE1/NcNF7Tl8svUG+TfT4L3xTfWcvFHxq74jeAelR+1kpveStOHYY
         WF0pHSRvCakL9KIwCXlfb2z6mi4nPlSTSgT25O7zIzqUggUCSCwLSGC3ncaz3VUffkyi
         txwQ==
X-Gm-Message-State: APjAAAUUQVmeujCdmZ46LlSgqVhTfJQKO9QfUTrB5gh1x+85+03dsvjN
        eI4dRux3mjYI17OGP6ocKLpiFdkLGWce/UhL5BPtvIXnHG/+s6jQeCVHreuUVU3eiu0ctK4FGCE
        sEbC1ff6QMqlO7PD7W6e4
X-Received: by 2002:adf:f147:: with SMTP id y7mr1941988wro.236.1573036693371;
        Wed, 06 Nov 2019 02:38:13 -0800 (PST)
X-Google-Smtp-Source: APXvYqzZYIbCwCsaa2H1kmWPCy8B+bg9ysW184Q0ltf8SA22i7rGbqGfTEcB4lXu4K8Zp5XD8YR6aQ==
X-Received: by 2002:adf:f147:: with SMTP id y7mr1941959wro.236.1573036692884;
        Wed, 06 Nov 2019 02:38:12 -0800 (PST)
Received: from orion (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id t5sm11638774wro.76.2019.11.06.02.38.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2019 02:38:12 -0800 (PST)
Date:   Wed, 6 Nov 2019 11:38:09 +0100
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs_scrub: implement deferred description string
 rendering
Message-ID: <20191106103809.so66jtxxz3kb5zwf@orion>
Mail-Followup-To: "Darrick J. Wong" <darrick.wong@oracle.com>,
        sandeen@sandeen.net, linux-xfs@vger.kernel.org
References: <157177017664.1460581.13561167273786314634.stgit@magnolia>
 <157177018914.1460581.6983232302876165323.stgit@magnolia>
MIME-Version: 1.0
In-Reply-To: <157177018914.1460581.6983232302876165323.stgit@magnolia>
X-MC-Unique: yfVITP-8NFuBWlw-79iGyw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick.

This set looks mostly good, but there is one part in this patch (see below)=
,
which is kind confusing to me:

> +#include <sys/statvfs.h>
> +#include "platform_defs.h"
> +#include "input.h"
> +#include "libfrog/paths.h"
> +#include "libfrog/ptvar.h"
> +#include "xfs_scrub.h"
> +#include "common.h"
> +#include "descr.h"
> +
> +/*
> + * Deferred String Description Renderer
> + * =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> + * There are many places in xfs_scrub where some event occurred and we'd=
 like
> + * to be able to print some sort of message describing what happened, an=
d
> + * where.  However, we don't know whether we're going to need the descri=
ption
> + * of where ahead of time and there's little point in spending any time =
looking
> + * up gettext strings and formatting buffers until we actually need to.
> + *
> + * This code provides enough of a function closure that we are able to r=
ecord
> + * some information about the program status but defer rendering the tex=
tual
> + * description until we know that we need it.  Once we've rendered the s=
tring
> + * we can skip it for subsequent calls.  We use per-thread storage for t=
he
> + * message buffer to amortize the memory allocation across calls.
> + *
> + * On a clean filesystem this can reduce the xfs_scrub runtime by 7-10% =
by
> + * avoiding unnecessary work.
> + */
> +
> +static struct ptvar *descr_ptvar;
> +
> +/* Global buffer for when we aren't running in threaded mode. */
> +static char global_dsc_buf[DESCR_BUFSZ];
> +
> +/*
> + * Render a textual description string using the function and location s=
tored
> + * in the description context.
> + */
> +const char *
> +__descr_render(
> +=09struct descr=09=09*dsc,
> +=09const char=09=09*file,
> +=09int=09=09=09line)
> +{
> +=09char=09=09=09*dsc_buf;
> +=09int=09=09=09ret;
> +
> +=09if (descr_ptvar) {
> +=09=09dsc_buf =3D ptvar_get(descr_ptvar, &ret);
> +=09=09if (ret)
> +=09=09=09return _("error finding description buffer");
> +=09} else
> +=09=09dsc_buf =3D global_dsc_buf;
> +
> +=09ret =3D dsc->fn(dsc->ctx, dsc_buf, DESCR_BUFSZ, dsc->where);
> +=09if (ret < 0) {
> +=09=09snprintf(dsc_buf, DESCR_BUFSZ,
> +_("error %d while rendering description at %s line %d\n"),
> +=09=09=09=09ret, file, line);
> +=09}
> +
> +=09return dsc_buf;
> +}
> +
> +/*
> + * Set a new location for this deferred-rendering string and discard any
> + * old rendering.
> + */
> +void
> +descr_set(
> +=09struct descr=09=09*dsc,
> +=09void=09=09=09*where)
> +{
> +=09dsc->where =3D where;
> +}

The comment on this function is actually confusing me. What exactly you mea=
n by
'discard any old rendering' here?

Even though you use it on fresh created struct descr during the patch, the
comment gave me the impression you intend to use this function to set a new
location to an already created descriptor, but it's not clear to me, if, th=
is is
the case, who is responsible to free up the memory previously associated wi=
th
the dsc->where pointer here, and so, it just feels like a potential memory =
leak
landmine here.

Maybe I've got confused by the comment or didn't fully understand your inte=
ntion
here.

My apologies if I'm talking something nonsense, I'm trying to catch up with=
 all
the scrub work yet.

Cheers.


> +
> +/* Allocate all the description string buffers. */
> +int
> +descr_init_phase(
> +=09struct scrub_ctx=09*ctx,
> +=09unsigned int=09=09nr_threads)
> +{
> +=09int=09=09=09ret;
> +
> +=09assert(descr_ptvar =3D=3D NULL);
> +=09ret =3D ptvar_alloc(nr_threads, DESCR_BUFSZ, &descr_ptvar);
> +=09if (ret)
> +=09=09str_liberror(ctx, ret, _("creating description buffer"));
> +
> +=09return ret;
> +}
> +
> +/* Free all the description string buffers. */
> +void
> +descr_end_phase(void)
> +{
> +=09if (descr_ptvar)
> +=09=09ptvar_free(descr_ptvar);
> +=09descr_ptvar =3D NULL;
> +}
> diff --git a/scrub/descr.h b/scrub/descr.h
> new file mode 100644
> index 00000000..f1899b67
> --- /dev/null
> +++ b/scrub/descr.h
> @@ -0,0 +1,29 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/*
> + * Copyright (C) 2019 Oracle.  All Rights Reserved.
> + * Author: Darrick J. Wong <darrick.wong@oracle.com>
> + */
> +#ifndef XFS_SCRUB_DESCR_H_
> +#define XFS_SCRUB_DESCR_H_
> +
> +typedef int (*descr_fn)(struct scrub_ctx *ctx, char *buf, size_t buflen,
> +=09=09=09void *data);
> +
> +struct descr {
> +=09struct scrub_ctx=09*ctx;
> +=09descr_fn=09=09fn;
> +=09void=09=09=09*where;
> +};
> +
> +#define DEFINE_DESCR(_name, _ctx, _fn) \
> +=09struct descr _name =3D { .ctx =3D (_ctx), .fn =3D (_fn) }
> +
> +const char *__descr_render(struct descr *dsc, const char *file, int line=
);
> +#define descr_render(dsc) __descr_render((dsc), __FILE__, __LINE__)
> +
> +void descr_set(struct descr *dsc, void *where);
> +
> +int descr_init_phase(struct scrub_ctx *ctx, unsigned int nr_threads);
> +void descr_end_phase(void);
> +
> +#endif /* XFS_SCRUB_DESCR_H_ */
> diff --git a/scrub/scrub.c b/scrub/scrub.c
> index 718f09b8..d9df1e5b 100644
> --- a/scrub/scrub.c
> +++ b/scrub/scrub.c
> @@ -20,37 +20,40 @@
>  #include "scrub.h"
>  #include "xfs_errortag.h"
>  #include "repair.h"
> +#include "descr.h"
> =20
>  /* Online scrub and repair wrappers. */
> =20
>  /* Format a scrub description. */
> -static void
> +static int
>  format_scrub_descr(
>  =09struct scrub_ctx=09=09*ctx,
>  =09char=09=09=09=09*buf,
>  =09size_t=09=09=09=09buflen,
> -=09struct xfs_scrub_metadata=09*meta)
> +=09void=09=09=09=09*where)
>  {
> +=09struct xfs_scrub_metadata=09*meta =3D where;
>  =09const struct xfrog_scrub_descr=09*sc =3D &xfrog_scrubbers[meta->sm_ty=
pe];
> =20
>  =09switch (sc->type) {
>  =09case XFROG_SCRUB_TYPE_AGHEADER:
>  =09case XFROG_SCRUB_TYPE_PERAG:
> -=09=09snprintf(buf, buflen, _("AG %u %s"), meta->sm_agno,
> +=09=09return snprintf(buf, buflen, _("AG %u %s"), meta->sm_agno,
>  =09=09=09=09_(sc->descr));
>  =09=09break;
>  =09case XFROG_SCRUB_TYPE_INODE:
> -=09=09scrub_render_ino_descr(ctx, buf, buflen,
> +=09=09return scrub_render_ino_descr(ctx, buf, buflen,
>  =09=09=09=09meta->sm_ino, meta->sm_gen, "%s",
>  =09=09=09=09_(sc->descr));
>  =09=09break;
>  =09case XFROG_SCRUB_TYPE_FS:
> -=09=09snprintf(buf, buflen, _("%s"), _(sc->descr));
> +=09=09return snprintf(buf, buflen, _("%s"), _(sc->descr));
>  =09=09break;
>  =09case XFROG_SCRUB_TYPE_NONE:
>  =09=09assert(0);
>  =09=09break;
>  =09}
> +=09return -1;
>  }
> =20
>  /* Predicates for scrub flag state. */
> @@ -95,21 +98,24 @@ static inline bool needs_repair(struct xfs_scrub_meta=
data *sm)
>  static inline void
>  xfs_scrub_warn_incomplete_scrub(
>  =09struct scrub_ctx=09=09*ctx,
> -=09const char=09=09=09*descr,
> +=09struct descr=09=09=09*dsc,
>  =09struct xfs_scrub_metadata=09*meta)
>  {
>  =09if (is_incomplete(meta))
> -=09=09str_info(ctx, descr, _("Check incomplete."));
> +=09=09str_info(ctx, descr_render(dsc), _("Check incomplete."));
> =20
>  =09if (is_suspicious(meta)) {
>  =09=09if (debug)
> -=09=09=09str_info(ctx, descr, _("Possibly suspect metadata."));
> +=09=09=09str_info(ctx, descr_render(dsc),
> +=09=09=09=09=09_("Possibly suspect metadata."));
>  =09=09else
> -=09=09=09str_warn(ctx, descr, _("Possibly suspect metadata."));
> +=09=09=09str_warn(ctx, descr_render(dsc),
> +=09=09=09=09=09_("Possibly suspect metadata."));
>  =09}
> =20
>  =09if (xref_failed(meta))
> -=09=09str_info(ctx, descr, _("Cross-referencing failed."));
> +=09=09str_info(ctx, descr_render(dsc),
> +=09=09=09=09_("Cross-referencing failed."));
>  }
> =20
>  /* Do a read-only check of some metadata. */
> @@ -119,16 +125,16 @@ xfs_check_metadata(
>  =09struct xfs_scrub_metadata=09*meta,
>  =09bool=09=09=09=09is_inode)
>  {
> -=09char=09=09=09=09buf[DESCR_BUFSZ];
> +=09DEFINE_DESCR(dsc, ctx, format_scrub_descr);
>  =09unsigned int=09=09=09tries =3D 0;
>  =09int=09=09=09=09code;
>  =09int=09=09=09=09error;
> =20
>  =09assert(!debug_tweak_on("XFS_SCRUB_NO_KERNEL"));
>  =09assert(meta->sm_type < XFS_SCRUB_TYPE_NR);
> -=09format_scrub_descr(ctx, buf, DESCR_BUFSZ, meta);
> +=09descr_set(&dsc, meta);
> =20
> -=09dbg_printf("check %s flags %xh\n", buf, meta->sm_flags);
> +=09dbg_printf("check %s flags %xh\n", descr_render(&dsc), meta->sm_flags=
);
>  retry:
>  =09error =3D xfrog_scrub_metadata(&ctx->mnt, meta);
>  =09if (debug_tweak_on("XFS_SCRUB_FORCE_REPAIR") && !error)
> @@ -141,13 +147,13 @@ xfs_check_metadata(
>  =09=09=09return CHECK_DONE;
>  =09=09case ESHUTDOWN:
>  =09=09=09/* FS already crashed, give up. */
> -=09=09=09str_error(ctx, buf,
> +=09=09=09str_error(ctx, descr_render(&dsc),
>  _("Filesystem is shut down, aborting."));
>  =09=09=09return CHECK_ABORT;
>  =09=09case EIO:
>  =09=09case ENOMEM:
>  =09=09=09/* Abort on I/O errors or insufficient memory. */
> -=09=09=09str_errno(ctx, buf);
> +=09=09=09str_errno(ctx, descr_render(&dsc));
>  =09=09=09return CHECK_ABORT;
>  =09=09case EDEADLOCK:
>  =09=09case EBUSY:
> @@ -161,7 +167,7 @@ _("Filesystem is shut down, aborting."));
>  =09=09=09/* fall through */
>  =09=09default:
>  =09=09=09/* Operational error. */
> -=09=09=09str_errno(ctx, buf);
> +=09=09=09str_errno(ctx, descr_render(&dsc));
>  =09=09=09return CHECK_DONE;
>  =09=09}
>  =09}
> @@ -179,7 +185,7 @@ _("Filesystem is shut down, aborting."));
>  =09}
> =20
>  =09/* Complain about incomplete or suspicious metadata. */
> -=09xfs_scrub_warn_incomplete_scrub(ctx, buf, meta);
> +=09xfs_scrub_warn_incomplete_scrub(ctx, &dsc, meta);
> =20
>  =09/*
>  =09 * If we need repairs or there were discrepancies, schedule a
> @@ -187,7 +193,7 @@ _("Filesystem is shut down, aborting."));
>  =09 */
>  =09if (is_corrupt(meta) || xref_disagrees(meta)) {
>  =09=09if (ctx->mode < SCRUB_MODE_REPAIR) {
> -=09=09=09str_corrupt(ctx, buf,
> +=09=09=09str_corrupt(ctx, descr_render(&dsc),
>  _("Repairs are required."));
>  =09=09=09return CHECK_DONE;
>  =09=09}
> @@ -203,7 +209,7 @@ _("Repairs are required."));
>  =09=09if (ctx->mode !=3D SCRUB_MODE_REPAIR) {
>  =09=09=09if (!is_inode) {
>  =09=09=09=09/* AG or FS metadata, always warn. */
> -=09=09=09=09str_info(ctx, buf,
> +=09=09=09=09str_info(ctx, descr_render(&dsc),
>  _("Optimization is possible."));
>  =09=09=09} else if (!ctx->preen_triggers[meta->sm_type]) {
>  =09=09=09=09/* File metadata, only warn once per type. */
> @@ -656,9 +662,9 @@ xfs_repair_metadata(
>  =09struct action_item=09=09*aitem,
>  =09unsigned int=09=09=09repair_flags)
>  {
> -=09char=09=09=09=09buf[DESCR_BUFSZ];
>  =09struct xfs_scrub_metadata=09meta =3D { 0 };
>  =09struct xfs_scrub_metadata=09oldm;
> +=09DEFINE_DESCR(dsc, ctx, format_scrub_descr);
>  =09int=09=09=09=09error;
> =20
>  =09assert(aitem->type < XFS_SCRUB_TYPE_NR);
> @@ -682,12 +688,13 @@ xfs_repair_metadata(
>  =09=09return CHECK_RETRY;
> =20
>  =09memcpy(&oldm, &meta, sizeof(oldm));
> -=09format_scrub_descr(ctx, buf, DESCR_BUFSZ, &meta);
> +=09descr_set(&dsc, &oldm);
> =20
>  =09if (needs_repair(&meta))
> -=09=09str_info(ctx, buf, _("Attempting repair."));
> +=09=09str_info(ctx, descr_render(&dsc), _("Attempting repair."));
>  =09else if (debug || verbose)
> -=09=09str_info(ctx, buf, _("Attempting optimization."));
> +=09=09str_info(ctx, descr_render(&dsc),
> +=09=09=09=09_("Attempting optimization."));
> =20
>  =09error =3D xfrog_scrub_metadata(&ctx->mnt, &meta);
>  =09if (error) {
> @@ -696,12 +703,12 @@ xfs_repair_metadata(
>  =09=09case EBUSY:
>  =09=09=09/* Filesystem is busy, try again later. */
>  =09=09=09if (debug || verbose)
> -=09=09=09=09str_info(ctx, buf,
> +=09=09=09=09str_info(ctx, descr_render(&dsc),
>  _("Filesystem is busy, deferring repair."));
>  =09=09=09return CHECK_RETRY;
>  =09=09case ESHUTDOWN:
>  =09=09=09/* Filesystem is already shut down, abort. */
> -=09=09=09str_error(ctx, buf,
> +=09=09=09str_error(ctx, descr_render(&dsc),
>  _("Filesystem is shut down, aborting."));
>  =09=09=09return CHECK_ABORT;
>  =09=09case ENOTTY:
> @@ -726,13 +733,13 @@ _("Filesystem is shut down, aborting."));
>  =09=09=09/* fall through */
>  =09=09case EINVAL:
>  =09=09=09/* Kernel doesn't know how to repair this? */
> -=09=09=09str_corrupt(ctx, buf,
> +=09=09=09str_corrupt(ctx, descr_render(&dsc),
>  _("Don't know how to fix; offline repair required."));
>  =09=09=09return CHECK_DONE;
>  =09=09case EROFS:
>  =09=09=09/* Read-only filesystem, can't fix. */
>  =09=09=09if (verbose || debug || needs_repair(&oldm))
> -=09=09=09=09str_error(ctx, buf,
> +=09=09=09=09str_error(ctx, descr_render(&dsc),
>  _("Read-only filesystem; cannot make changes."));
>  =09=09=09return CHECK_ABORT;
>  =09=09case ENOENT:
> @@ -753,12 +760,12 @@ _("Read-only filesystem; cannot make changes."));
>  =09=09=09 */
>  =09=09=09if (!(repair_flags & XRM_COMPLAIN_IF_UNFIXED))
>  =09=09=09=09return CHECK_RETRY;
> -=09=09=09str_errno(ctx, buf);
> +=09=09=09str_errno(ctx, descr_render(&dsc));
>  =09=09=09return CHECK_DONE;
>  =09=09}
>  =09}
>  =09if (repair_flags & XRM_COMPLAIN_IF_UNFIXED)
> -=09=09xfs_scrub_warn_incomplete_scrub(ctx, buf, &meta);
> +=09=09xfs_scrub_warn_incomplete_scrub(ctx, &dsc, &meta);
>  =09if (needs_repair(&meta)) {
>  =09=09/*
>  =09=09 * Still broken; if we've been told not to complain then we
> @@ -767,14 +774,16 @@ _("Read-only filesystem; cannot make changes."));
>  =09=09 */
>  =09=09if (!(repair_flags & XRM_COMPLAIN_IF_UNFIXED))
>  =09=09=09return CHECK_RETRY;
> -=09=09str_corrupt(ctx, buf,
> +=09=09str_corrupt(ctx, descr_render(&dsc),
>  _("Repair unsuccessful; offline repair required."));
>  =09} else {
>  =09=09/* Clean operation, no corruption detected. */
>  =09=09if (needs_repair(&oldm))
> -=09=09=09record_repair(ctx, buf, _("Repairs successful."));
> +=09=09=09record_repair(ctx, descr_render(&dsc),
> +=09=09=09=09=09_("Repairs successful."));
>  =09=09else
> -=09=09=09record_preen(ctx, buf, _("Optimization successful."));
> +=09=09=09record_preen(ctx, descr_render(&dsc),
> +=09=09=09=09=09_("Optimization successful."));
>  =09}
>  =09return CHECK_DONE;
>  }
> diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
> index fe76d075..9945c7f4 100644
> --- a/scrub/xfs_scrub.c
> +++ b/scrub/xfs_scrub.c
> @@ -15,6 +15,7 @@
>  #include "libfrog/paths.h"
>  #include "xfs_scrub.h"
>  #include "common.h"
> +#include "descr.h"
>  #include "unicrash.h"
>  #include "progress.h"
> =20
> @@ -467,8 +468,14 @@ run_scrub_phases(
>  =09=09=09work_threads++;
>  =09=09=09moveon =3D progress_init_phase(ctx, progress_fp, phase,
>  =09=09=09=09=09max_work, rshift, work_threads);
> +=09=09=09if (!moveon)
> +=09=09=09=09break;
> +=09=09=09moveon =3D descr_init_phase(ctx, work_threads) =3D=3D 0;
>  =09=09} else {
>  =09=09=09moveon =3D progress_init_phase(ctx, NULL, phase, 0, 0, 0);
> +=09=09=09if (!moveon)
> +=09=09=09=09break;
> +=09=09=09moveon =3D descr_init_phase(ctx, 1) =3D=3D 0;
>  =09=09}
>  =09=09if (!moveon)
>  =09=09=09break;
> @@ -480,6 +487,7 @@ _("Scrub aborted after phase %d."),
>  =09=09=09break;
>  =09=09}
>  =09=09progress_end_phase();
> +=09=09descr_end_phase();
>  =09=09moveon =3D phase_end(&pi, phase);
>  =09=09if (!moveon)
>  =09=09=09break;
>=20

--=20
Carlos

