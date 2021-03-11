Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3791EC433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 00:36:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0EDF64FC0
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 00:36:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbhCKAgJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Mar 2021 19:36:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:51760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229655AbhCKAgH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Mar 2021 19:36:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0C5B64FBA;
        Thu, 11 Mar 2021 00:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615422966;
        bh=XDl9FusC+rDFhETdRnzDyk8nOYJgOjuxQREJ7pqTcOk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cR7CQR7lwY8XzeZ/9edwEX8swTiTaooQZ+L6lN30F0Iy8EXAwV0unnZV9NeP8Vwc4
         xBPyFyyG++8NO4j+F5WLPwlW3+5Tsnlo5m6BPVE6EZxI/tm78amdEJQ+17lYFzok7u
         O58bqjWKEIY1kwKOrZR8if+Y59HVQC7+yr2L3aZ4Ap+kSlUfPSd4+0MSi/OMnvsuvm
         c7TfpF1kY+UXO4za1XfUGb/qbyIV8KoIyWhp5f/dRDb2QeQi7G0YcLkksaRlB9dj3j
         m9B7HS1NSBVeLw0lheu45ytEnclL4C5TPE12ybX9k77JXMM1bZuHY+4F+P765wmueR
         g4CwRF74yBMGQ==
Date:   Wed, 10 Mar 2021 16:36:01 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 38/45] xfs: convert CIL busy extents to per-cpu
Message-ID: <20210311003601.GL3419940@magnolia>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-39-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305051143.182133-39-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 05, 2021 at 04:11:36PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> To get them out from under the CIL lock.
> 
> This is an unordered list, so we can simply punt it to per-cpu lists
> during transaction commits and reaggregate it back into a single
> list during the CIL push work.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log_cil.c | 26 ++++++++++++++++++--------
>  1 file changed, 18 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index a2f93bd7644b..7428b98c8279 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -501,6 +501,9 @@ xlog_cil_insert_items(
>  		atomic_add(cilpcp->space_used, &ctx->space_used);
>  		cilpcp->space_used = 0;
>  	}
> +	/* attach the transaction to the CIL if it has any busy extents */
> +	if (!list_empty(&tp->t_busy))
> +		list_splice_init(&tp->t_busy, &cilpcp->busy_extents);
>  	put_cpu_ptr(cilpcp);
>  
>  	/*
> @@ -540,9 +543,6 @@ xlog_cil_insert_items(
>  			list_move_tail(&lip->li_cil, &cil->xc_cil);
>  	}
>  
> -	/* attach the transaction to the CIL if it has any busy extents */
> -	if (!list_empty(&tp->t_busy))
> -		list_splice_init(&tp->t_busy, &ctx->busy_extents);
>  	spin_unlock(&cil->xc_cil_lock);
>  
>  	if (tp->t_ticket->t_curr_res < 0)
> @@ -802,7 +802,10 @@ xlog_cil_push_work(
>  		ctx->ticket->t_curr_res += cilpcp->space_reserved;
>  		cilpcp->space_used = 0;
>  		cilpcp->space_reserved = 0;
> -
> +		if (!list_empty(&cilpcp->busy_extents)) {
> +			list_splice_init(&cilpcp->busy_extents,
> +					&ctx->busy_extents);
> +		}
>  	}
>  
>  	spin_lock(&cil->xc_push_lock);
> @@ -1459,17 +1462,24 @@ static void __percpu *
>  xlog_cil_pcp_alloc(
>  	struct xfs_cil		*cil)
>  {
> +	void __percpu		*pcptr;
>  	struct xlog_cil_pcp	*cilpcp;
> +	int			cpu;
>  
> -	cilpcp = alloc_percpu(struct xlog_cil_pcp);
> -	if (!cilpcp)
> +	pcptr = alloc_percpu(struct xlog_cil_pcp);
> +	if (!pcptr)
>  		return NULL;
>  
> +	for_each_possible_cpu(cpu) {
> +		cilpcp = per_cpu_ptr(pcptr, cpu);

So... in my mind, "cilpcp" and "pcptr" aren't really all that distinct
from each other.  I /think/ you're trying to use "cilpcp" everywhere
else to mean "pointer to a particular CPU's CIL data", and this change
makes that usage consistent in the alloc function.

However, this leaves xlog_cil_pcp_free using "cilpcp" to refer to the
entire chunk of per-CPU data structures.  Given that the first refers to
a specific structure and the second refers to them all in aggregate,
maybe _pcp_alloc and _pcp_free should use a name that at least sounds
plural?

e.g.

	void __percpu	*all_cilpcps = alloc_percpu(...);

	for_each_possible_cpu(cpu) {
		cilpcp = per_cpu_ptr(all_cilpcps, cpu);
		cilpcp->magicval = 7777;
	}

and

	cil->xc_all_pcps = xlog_cil_pcp_alloc(...);

Hm?

--D

> +		INIT_LIST_HEAD(&cilpcp->busy_extents);
> +	}
> +
>  	if (xlog_cil_pcp_hpadd(cil) < 0) {
> -		free_percpu(cilpcp);
> +		free_percpu(pcptr);
>  		return NULL;
>  	}
> -	return cilpcp;
> +	return pcptr;
>  }
>  
>  static void
> -- 
> 2.28.0
> 
