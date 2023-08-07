Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC61FC001B0
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Aug 2023 06:58:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbjHGG6z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Aug 2023 02:58:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjHGG6z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Aug 2023 02:58:55 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EF171A4
        for <linux-xfs@vger.kernel.org>; Sun,  6 Aug 2023 23:58:54 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-686f090310dso4216672b3a.0
        for <linux-xfs@vger.kernel.org>; Sun, 06 Aug 2023 23:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1691391534; x=1691996334;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tNY0hUJZzup40ZtRkW5u2kzQNAU2MQrXdEQ3lfUlD2k=;
        b=4eaC+pzwYIzetpyei2XX+uISMsTJ8b3mupWas79HtSGDTMWkp5ryYMKlq7wWLlujs9
         RSWa1dGFCCvrGpdJGZ29a+qmuOytut8QlYVJ+S9iY7kuYR2J01Wah7etm1lw6UGReQy7
         BoxiUrNaY7r1MJ7aITLYVJnWd+sY9lEMpdYBfQ4g/pu97ll7dKdw7JobQgwubEd641TW
         UvH/S4eVBRsZF+aNOmYjcEqQwnhNqJOX1ZQvGOC7kYpu7uNKTfKtsVP6XKMMxrhYsPwM
         gNM05J3gNA0ahxRn4LwSaMig//CErN+lOPRvKZqvrnHGqFCPrVNJmWt4X+wmJTLo2wjD
         BjCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691391534; x=1691996334;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tNY0hUJZzup40ZtRkW5u2kzQNAU2MQrXdEQ3lfUlD2k=;
        b=DT3saWSVg6NplJdBZ9z08ZDUtjxgvuVD+g1m79KN+zp8lFfvnhSB/9r7yiRjUg26PG
         yHk9xOnq1hAfpEHy0U4afrf2nBWTFG3dBwaDLu5Wew1cJryx3MzLzuO5KIUY6OwM6lMp
         R41k3gIbpsfH4J0UyuwoYUa7iC72wT88hSWIi0CmktxPSxAoFdUOBZcqI97iLW2VMVdi
         IdMcqTaAA4USdGogOtxhvbBoMzTy9lxSCqrqGJSzI3Ma2PxW0jURNB+DK0YtlqFrylgI
         ohDJPn8Gyla02e1Wk+wg48ufYDkrYzIbau8oUFKy+3aYLjeAJJMtWq3m4ga5RuNaDldB
         QWOw==
X-Gm-Message-State: AOJu0YyXYh4MEFYDwXyNoR3uypqHWmtakQGOV4c4dFnExSCCZwPaRVgX
        SsLtZFV3qPOeu9P/rMGObg2dZt36KdOXYHMw/3w=
X-Google-Smtp-Source: AGHT+IGXAkUpGZhHpAJuDCE6joJrNsrk2jkwGTDYxDbCcWQ7hSwEZE31PuMCpu4Gtqo5QFN3QRAIbQ==
X-Received: by 2002:a05:6a20:96d6:b0:133:f0b9:856d with SMTP id hq22-20020a056a2096d600b00133f0b9856dmr9401357pzc.17.1691391533710;
        Sun, 06 Aug 2023 23:58:53 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-166-213.pa.nsw.optusnet.com.au. [49.180.166.213])
        by smtp.gmail.com with ESMTPSA id q2-20020a638c42000000b0055c02b8688asm4456996pgn.20.2023.08.06.23.58.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Aug 2023 23:58:53 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qSuCY-002Az1-0p;
        Mon, 07 Aug 2023 16:58:50 +1000
Date:   Mon, 7 Aug 2023 16:58:50 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] xfs: implement block reservation accounting for
 btrees we're staging
Message-ID: <ZNCWKoOnYc++JFTW@dread.disaster.area>
References: <169049623167.921279.16448199708156630380.stgit@frogsfrogsfrogs>
 <169049623203.921279.8246035009618084259.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169049623203.921279.8246035009618084259.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 27, 2023 at 03:24:16PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create a new xrep_newbt structure to encapsulate a fake root for
> creating a staged btree cursor as well as to track all the blocks that
> we need to reserve in order to build that btree.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
.....
> +/* Allocate disk space for our new file-based btree. */
> +STATIC int
> +xrep_newbt_alloc_file_blocks(
> +	struct xrep_newbt	*xnr,
> +	uint64_t		nr_blocks)
> +{
> +	struct xfs_scrub	*sc = xnr->sc;
> +	int			error = 0;
> +
> +	while (nr_blocks > 0) {
> +		struct xfs_alloc_arg	args = {
> +			.tp		= sc->tp,
> +			.mp		= sc->mp,
> +			.oinfo		= xnr->oinfo,
> +			.minlen		= 1,
> +			.maxlen		= nr_blocks,
> +			.prod		= 1,
> +			.resv		= xnr->resv,
> +		};
> +		struct xfs_perag	*pag;
> +
> +		xrep_newbt_validate_file_alloc_hint(xnr);
> +
> +		error = xfs_alloc_vextent_start_ag(&args, xnr->alloc_hint);
> +		if (error)
> +			return error;
> +		if (args.fsbno == NULLFSBLOCK)
> +			return -ENOSPC;
> +
> +		trace_xrep_newbt_alloc_file_blocks(sc->mp, args.agno,
> +				args.agbno, args.len, xnr->oinfo.oi_owner);
> +
> +		pag = xfs_perag_get(sc->mp, args.agno);

I don't think we should allow callers to trust args.agno and
args.agbno after the allocation has completed. The result of the
allocation is returned in args.fsbno, and there is no guarantee that
args.agno and args.agbno will be valid at the completion of the
allocation.

i.e. we set args.agno and args.agbno internally based on the target
that is passed to xfs_alloc_vextent_start_ag(), and they change
internally depending on the iterations being done during allocation.
IOWs, those two fields are internal allocation state and not
actually return values that the caller can rely on.

Hence I think this needs to do:

	agno = XFS_FSB_TO_AGNO(mp, args.fsbno);
	agbno = XFS_FSB_TO_AGBNO(mp, args.fsbno);

before using those values.

> +
> +/*
> + * How many extent freeing items can we attach to a transaction before we want
> + * to finish the chain so that unreserving new btree blocks doesn't overrun
> + * the transaction reservation?
> + */
> +#define XREP_REAP_MAX_NEWBT_EFIS	(128)

Should there be a common define for this for repair operations?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
