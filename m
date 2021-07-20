Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAC46C07E95
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Jul 2021 02:34:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D111861166
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Jul 2021 02:34:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbhGTBxT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Jul 2021 21:53:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:33036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344437AbhGTBju (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 19 Jul 2021 21:39:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A48260C40;
        Tue, 20 Jul 2021 02:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626747625;
        bh=wJQJYy19JoNbPgnn5nAMu95up14zFfvr3My3xlcpouQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g27orC+9SZy5A5AyJwWySl1PbZkF4xBfGEyBSTEUOeFGKG8DWNejQVDq4Um65wCWy
         q1XwZU5b7s3gk4fAXP2A7OFkWPq12rhBAZp+QAkiUd2QuEx08deGizr21VTaWmDAso
         5FctEeNmHPZxozCzy7MWEZNfmK4nzesvRzKXU4rsq8knw7iXI1JVuo71GyFHYEsBJI
         ysi2w0+hRSbDWuiWYmZfR5ZvPGhTRsxZREGO5Y2OTNJXlE7eolLT0G+2KZ56rK1Gvh
         VNa2BHtw0o/c2Pwi5VC+M93L9rGi3MyvNjvV/oLhXDTrte1NPzkbMVIJw6ioV72t84
         I++4eraSFOaKw==
Date:   Mon, 19 Jul 2021 19:20:24 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Xiyu Yang <xiyuyang19@fudan.edu.cn>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        yuanxzhang@fudan.edu.cn, Xin Tan <tanxin.ctf@gmail.com>
Subject: Re: [PATCH] xfs: Convert from atomic_t to refcount_t on
 xlog_ticket->t_ref
Message-ID: <20210720022024.GI23236@magnolia>
References: <1626517262-42986-1-git-send-email-xiyuyang19@fudan.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1626517262-42986-1-git-send-email-xiyuyang19@fudan.edu.cn>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jul 17, 2021 at 06:21:02PM +0800, Xiyu Yang wrote:
> refcount_t type and corresponding API can protect refcounters from
> accidental underflow and overflow and further use-after-free situations.
> 
> Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
> Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
> ---
>  fs/xfs/xfs_log.c      | 10 +++++-----
>  fs/xfs/xfs_log_priv.h |  4 +++-
>  2 files changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 36fa2650b081..1da711f1a229 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -3347,8 +3347,8 @@ void
>  xfs_log_ticket_put(
>  	xlog_ticket_t	*ticket)
>  {
> -	ASSERT(atomic_read(&ticket->t_ref) > 0);
> -	if (atomic_dec_and_test(&ticket->t_ref))
> +	ASSERT(refcount_read(&ticket->t_ref) > 0);
> +	if (refcount_dec_and_test(&ticket->t_ref))

I thought the refcount functions already had code to warn about
refcounts that get decremented below zero...

>  		kmem_cache_free(xfs_log_ticket_zone, ticket);
>  }
>  
> @@ -3356,8 +3356,8 @@ xlog_ticket_t *
>  xfs_log_ticket_get(
>  	xlog_ticket_t	*ticket)
>  {
> -	ASSERT(atomic_read(&ticket->t_ref) > 0);
> -	atomic_inc(&ticket->t_ref);
> +	ASSERT(refcount_read(&ticket->t_ref) > 0);

...and can't come back from the dead?  Also, how much of a performance
impact does this have over the atomic_t functions?  The last time anyone
proposed conversions similar to this, there were concerns about that.

--D

> +	refcount_inc(&ticket->t_ref);
>  	return ticket;
>  }
>  
> @@ -3477,7 +3477,7 @@ xlog_ticket_alloc(
>  
>  	unit_res = xlog_calc_unit_res(log, unit_bytes);
>  
> -	atomic_set(&tic->t_ref, 1);
> +	refcount_set(&tic->t_ref, 1);
>  	tic->t_task		= current;
>  	INIT_LIST_HEAD(&tic->t_queue);
>  	tic->t_unit_res		= unit_res;
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 4c41bbfa33b0..c4157d87cea4 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -6,6 +6,8 @@
>  #ifndef	__XFS_LOG_PRIV_H__
>  #define __XFS_LOG_PRIV_H__
>  
> +#include <linux/refcount.h>
> +
>  struct xfs_buf;
>  struct xlog;
>  struct xlog_ticket;
> @@ -163,7 +165,7 @@ typedef struct xlog_ticket {
>  	struct list_head   t_queue;	 /* reserve/write queue */
>  	struct task_struct *t_task;	 /* task that owns this ticket */
>  	xlog_tid_t	   t_tid;	 /* transaction identifier	 : 4  */
> -	atomic_t	   t_ref;	 /* ticket reference count       : 4  */
> +	refcount_t	   t_ref;	 /* ticket reference count       : 4  */
>  	int		   t_curr_res;	 /* current reservation in bytes : 4  */
>  	int		   t_unit_res;	 /* unit reservation in bytes    : 4  */
>  	char		   t_ocnt;	 /* original count		 : 1  */
> -- 
> 2.7.4
> 
