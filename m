Return-Path: <SRS0=ttQi=5Y=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3962C2D0EA
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Apr 2020 11:43:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD5D820787
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Apr 2020 11:43:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="duuxeGXp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728625AbgDHLnU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Apr 2020 07:43:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26801 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728572AbgDHLnU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Apr 2020 07:43:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586346197;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VkIf2f7G4BzDdOB7aIAYxEq48cTU3D5XAAX5LlMyjcQ=;
        b=duuxeGXpMppmcwRnBReNJqqBvGLazKRxIgRzoZVgWaNnRQTw51QPb+GxfvoMZOH2ifqST+
        l07o9Tz+H7HrSTDmNoiTdjdMTbFV8InO6gN4HhdzX2dT/Sax4tpuByMF1G0uaXaJSXTHVe
        pRHiFRileIJHa71dFul3DET16hH4nQU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-484-Ssxb08zjPAOtCUlmcx4UZQ-1; Wed, 08 Apr 2020 07:43:16 -0400
X-MC-Unique: Ssxb08zjPAOtCUlmcx4UZQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2A703800D50;
        Wed,  8 Apr 2020 11:43:15 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BF84E7E303;
        Wed,  8 Apr 2020 11:43:14 +0000 (UTC)
Date:   Wed, 8 Apr 2020 07:43:12 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFC v6 PATCH 03/10] xfs: extra runtime reservation overhead for
 relog transactions
Message-ID: <20200408114312.GA33192@bfoster>
References: <20200406123632.20873-1-bfoster@redhat.com>
 <20200406123632.20873-4-bfoster@redhat.com>
 <24e8c67b-be11-cd04-81d1-8eeb1122f33e@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24e8c67b-be11-cd04-81d1-8eeb1122f33e@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 07, 2020 at 04:04:43PM -0700, Allison Collins wrote:
> 
> 
> On 4/6/20 5:36 AM, Brian Foster wrote:
> > Every transaction reservation includes runtime overhead on top of
> > the reservation calculated in the struct xfs_trans_res. This
> > overhead is required for things like the CIL context ticket, log
> > headers, etc., that are stolen from individual transactions. Since
> > reservation for the relog transaction is entirely contributed by
> > regular transactions, this runtime reservation overhead must be
> > contributed as well. This means that a transaction that relogs one
> > or more items must include overhead for the current transaction as
> > well as for the relog transaction.
> > 
> > Define a new transaction flag to indicate that a transaction is
> > relog enabled. Plumb this state down to the log ticket allocation
> > and use it to bump the worst case overhead included in the
> > transaction. The overhead will eventually be transferred to the
> > relog system as needed for individual log items.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >   fs/xfs/libxfs/xfs_shared.h |  1 +
> >   fs/xfs/xfs_log.c           | 12 +++++++++---
> >   fs/xfs/xfs_log.h           |  3 ++-
> >   fs/xfs/xfs_log_cil.c       |  2 +-
> >   fs/xfs/xfs_log_priv.h      |  1 +
> >   fs/xfs/xfs_trans.c         |  3 ++-
> >   6 files changed, 16 insertions(+), 6 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
> > index c45acbd3add9..1ede1e720a5c 100644
> > --- a/fs/xfs/libxfs/xfs_shared.h
> > +++ b/fs/xfs/libxfs/xfs_shared.h
> > @@ -65,6 +65,7 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
> >   #define XFS_TRANS_DQ_DIRTY	0x10	/* at least one dquot in trx dirty */
> >   #define XFS_TRANS_RESERVE	0x20    /* OK to use reserved data blocks */
> >   #define XFS_TRANS_NO_WRITECOUNT 0x40	/* do not elevate SB writecount */
> > +#define XFS_TRANS_RELOG		0x80	/* requires extra relog overhead */
> >   /*
> >    * LOWMODE is used by the allocator to activate the lowspace algorithm - when
> >    * free space is running low the extent allocator may choose to allocate an
> > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > index d6b63490a78b..b55abde6c142 100644
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -418,7 +418,8 @@ xfs_log_reserve(
> >   	int		 	cnt,
> >   	struct xlog_ticket	**ticp,
> >   	uint8_t		 	client,
> > -	bool			permanent)
> > +	bool			permanent,
> > +	bool			relog)
> >   {
> >   	struct xlog		*log = mp->m_log;
> >   	struct xlog_ticket	*tic;
> > @@ -433,7 +434,8 @@ xfs_log_reserve(
> >   	XFS_STATS_INC(mp, xs_try_logspace);
> >   	ASSERT(*ticp == NULL);
> > -	tic = xlog_ticket_alloc(log, unit_bytes, cnt, client, permanent, 0);
> > +	tic = xlog_ticket_alloc(log, unit_bytes, cnt, client, permanent, relog,
> > +				0);
> >   	*ticp = tic;
> >   	xlog_grant_push_ail(log, tic->t_cnt ? tic->t_unit_res * tic->t_cnt
> > @@ -831,7 +833,7 @@ xlog_unmount_write(
> >   	uint			flags = XLOG_UNMOUNT_TRANS;
> >   	int			error;
> > -	error = xfs_log_reserve(mp, 600, 1, &tic, XFS_LOG, 0);
> > +	error = xfs_log_reserve(mp, 600, 1, &tic, XFS_LOG, false, false);
> >   	if (error)
> >   		goto out_err;
> > @@ -3421,6 +3423,7 @@ xlog_ticket_alloc(
> >   	int			cnt,
> >   	char			client,
> >   	bool			permanent,
> > +	bool			relog,
> >   	xfs_km_flags_t		alloc_flags)
> I notice this routine already has a flag param.  Wondering if it would make
> sense to have a KM_RELOG flag instead of an extra bool param?  It would just
> be one less thing to pass around.  Other than that, it seems straight
> forward.
> 

In the xlog_ticket_alloc() case, those are actually memory allocation
flags (as opposed to transaction flags used in xfs_trans_alloc()). The
former includes things like KM_NOFS, etc., that translate to GFP_*
allocation flags. So I don't think it's appropriate to stash a
transaction or ticket oriented flag there.

I did halfway expect some feedback wrt to XFS_TRANS_RELOG because it
technically could be buried in the reservation structure itself, similar
to how permanent state is handled (though we'd still need to pass the
boolean around a bit). I opted to introduce XFS_TRANS_RELOG here instead
because I need to use that for random buffer relogging later in the
series, so it accomplished both at least for the time being. For a
non-RFC series I could look into moving that flag into the reservation,
relegating TRANS_RELOG to debug mode and letting the test code use it
from there.

> Reviewed-by: Allison Collins <allison.henderson@oracle.com>
> 

Thanks!

Brian

> >   {
> >   	struct xlog_ticket	*tic;
> > @@ -3431,6 +3434,9 @@ xlog_ticket_alloc(
> >   		return NULL;
> >   	unit_res = xfs_log_calc_unit_res(log->l_mp, unit_bytes);
> > +	/* double the overhead for the relog transaction */
> > +	if (relog)
> > +		unit_res += (unit_res - unit_bytes);
> >   	atomic_set(&tic->t_ref, 1);
> >   	tic->t_task		= current;
> > diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
> > index 6d2f30f42245..f1089a4b299c 100644
> > --- a/fs/xfs/xfs_log.h
> > +++ b/fs/xfs/xfs_log.h
> > @@ -123,7 +123,8 @@ int	  xfs_log_reserve(struct xfs_mount *mp,
> >   			  int		   count,
> >   			  struct xlog_ticket **ticket,
> >   			  uint8_t		   clientid,
> > -			  bool		   permanent);
> > +			  bool		   permanent,
> > +			  bool		   relog);
> >   int	  xfs_log_regrant(struct xfs_mount *mp, struct xlog_ticket *tic);
> >   void	  xfs_log_ungrant_bytes(struct xfs_mount *mp, int bytes);
> >   void      xfs_log_unmount(struct xfs_mount *mp);
> > diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> > index b43f0e8f43f2..1c48e95402aa 100644
> > --- a/fs/xfs/xfs_log_cil.c
> > +++ b/fs/xfs/xfs_log_cil.c
> > @@ -37,7 +37,7 @@ xlog_cil_ticket_alloc(
> >   {
> >   	struct xlog_ticket *tic;
> > -	tic = xlog_ticket_alloc(log, 0, 1, XFS_TRANSACTION, 0,
> > +	tic = xlog_ticket_alloc(log, 0, 1, XFS_TRANSACTION, false, false,
> >   				KM_NOFS);
> >   	/*
> > diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> > index ec22c7a3867f..08d8ff9bce1a 100644
> > --- a/fs/xfs/xfs_log_priv.h
> > +++ b/fs/xfs/xfs_log_priv.h
> > @@ -465,6 +465,7 @@ xlog_ticket_alloc(
> >   	int		count,
> >   	char		client,
> >   	bool		permanent,
> > +	bool		relog,
> >   	xfs_km_flags_t	alloc_flags);
> > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > index 4fbe11485bbb..1b25980315bd 100644
> > --- a/fs/xfs/xfs_trans.c
> > +++ b/fs/xfs/xfs_trans.c
> > @@ -177,6 +177,7 @@ xfs_trans_reserve(
> >   	 */
> >   	if (resp->tr_logres > 0) {
> >   		bool	permanent = false;
> > +		bool	relog	  = (tp->t_flags & XFS_TRANS_RELOG);
> >   		ASSERT(tp->t_log_res == 0 ||
> >   		       tp->t_log_res == resp->tr_logres);
> > @@ -199,7 +200,7 @@ xfs_trans_reserve(
> >   						resp->tr_logres,
> >   						resp->tr_logcount,
> >   						&tp->t_ticket, XFS_TRANSACTION,
> > -						permanent);
> > +						permanent, relog);
> >   		}
> >   		if (error)
> > 
> 

