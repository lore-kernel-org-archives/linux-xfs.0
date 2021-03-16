Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93B29C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Mar 2021 14:52:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51C8F6508A
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Mar 2021 14:52:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237549AbhCPOvp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Mar 2021 10:51:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37350 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231553AbhCPOvV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Mar 2021 10:51:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615906280;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=M6qvxyNA6H/cts9BhZA2EWHObfsnDfIElB8Ikj53NcM=;
        b=ADOnVuWZJTLhAbxzALzSz4Od4jPkgpvO1x5THAEL7tsx2hj7W0va92TBRT0VOEW+QHBn5e
        rupX9l4m48v63328uxP8oIpaxKLQwgbay9CbvPc54o7jsnLibAq8dkd9rMRj5P7zJZuLVP
        BOq2hPkvVu9meBynhVuTAK4Pybxm1AY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-547-VDNoX0mYOKm_Z6tU_OKAqA-1; Tue, 16 Mar 2021 10:51:18 -0400
X-MC-Unique: VDNoX0mYOKm_Z6tU_OKAqA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6B598814256;
        Tue, 16 Mar 2021 14:51:17 +0000 (UTC)
Received: from bfoster (ovpn-112-124.rdu2.redhat.com [10.10.112.124])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B4B6C5D9DE;
        Tue, 16 Mar 2021 14:51:16 +0000 (UTC)
Date:   Tue, 16 Mar 2021 10:51:15 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 23/45] xfs: log tickets don't need log client id
Message-ID: <YFDF4zVE3VorGn5t@bfoster>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-24-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305051143.182133-24-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 05, 2021 at 04:11:21PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We currently set the log ticket client ID when we reserve a
> transaction. This client ID is only ever written to the log by
> a CIL checkpoint or unmount records, and so anything using a high
> level transaction allocated through xfs_trans_alloc() does not need
> a log ticket client ID to be set.
> 
> For the CIL checkpoint, the client ID written to the journal is
> always XFS_TRANSACTION, and for the unmount record it is always
> XFS_LOG, and nothing else writes to the log. All of these operations
> tell xlog_write() exactly what they need to write to the log (the
> optype) and build their own opheaders for start, commit and unmount
> records. Hence we no longer need to set the client id in either the
> log ticket or the xfs_trans.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---

LGTM with Darrick's suggested feedback:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_log.c      | 47 ++++++++-----------------------------------
>  fs/xfs/xfs_log.h      | 16 ++++++---------
>  fs/xfs/xfs_log_cil.c  |  2 +-
>  fs/xfs/xfs_log_priv.h | 10 ++-------
>  fs/xfs/xfs_trans.c    |  6 ++----
>  5 files changed, 19 insertions(+), 62 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index c2e69a1f5cad..429cb1e7cc67 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -431,10 +431,9 @@ xfs_log_regrant(
>  int
>  xfs_log_reserve(
>  	struct xfs_mount	*mp,
> -	int		 	unit_bytes,
> -	int		 	cnt,
> +	int			unit_bytes,
> +	int			cnt,
>  	struct xlog_ticket	**ticp,
> -	uint8_t		 	client,
>  	bool			permanent)
>  {
>  	struct xlog		*log = mp->m_log;
> @@ -442,15 +441,13 @@ xfs_log_reserve(
>  	int			need_bytes;
>  	int			error = 0;
>  
> -	ASSERT(client == XFS_TRANSACTION || client == XFS_LOG);
> -
>  	if (XLOG_FORCED_SHUTDOWN(log))
>  		return -EIO;
>  
>  	XFS_STATS_INC(mp, xs_try_logspace);
>  
>  	ASSERT(*ticp == NULL);
> -	tic = xlog_ticket_alloc(log, unit_bytes, cnt, client, permanent);
> +	tic = xlog_ticket_alloc(log, unit_bytes, cnt, permanent);
>  	*ticp = tic;
>  
>  	xlog_grant_push_ail(log, tic->t_cnt ? tic->t_unit_res * tic->t_cnt
> @@ -847,7 +844,7 @@ xlog_unmount_write(
>  	struct xlog_ticket	*tic = NULL;
>  	int			error;
>  
> -	error = xfs_log_reserve(mp, 600, 1, &tic, XFS_LOG, 0);
> +	error = xfs_log_reserve(mp, 600, 1, &tic, 0);
>  	if (error)
>  		goto out_err;
>  
> @@ -2170,35 +2167,13 @@ xlog_write_calc_vec_length(
>  
>  static xlog_op_header_t *
>  xlog_write_setup_ophdr(
> -	struct xlog		*log,
>  	struct xlog_op_header	*ophdr,
> -	struct xlog_ticket	*ticket,
> -	uint			flags)
> +	struct xlog_ticket	*ticket)
>  {
>  	ophdr->oh_tid = cpu_to_be32(ticket->t_tid);
> -	ophdr->oh_clientid = ticket->t_clientid;
> +	ophdr->oh_clientid = XFS_TRANSACTION;
>  	ophdr->oh_res2 = 0;
> -
> -	/* are we copying a commit or unmount record? */
> -	ophdr->oh_flags = flags;
> -
> -	/*
> -	 * We've seen logs corrupted with bad transaction client ids.  This
> -	 * makes sure that XFS doesn't generate them on.  Turn this into an EIO
> -	 * and shut down the filesystem.
> -	 */
> -	switch (ophdr->oh_clientid)  {
> -	case XFS_TRANSACTION:
> -	case XFS_VOLUME:
> -	case XFS_LOG:
> -		break;
> -	default:
> -		xfs_warn(log->l_mp,
> -			"Bad XFS transaction clientid 0x%x in ticket "PTR_FMT,
> -			ophdr->oh_clientid, ticket);
> -		return NULL;
> -	}
> -
> +	ophdr->oh_flags = 0;
>  	return ophdr;
>  }
>  
> @@ -2439,11 +2414,7 @@ xlog_write(
>  				if (index)
>  					optype &= ~XLOG_START_TRANS;
>  			} else {
> -				ophdr = xlog_write_setup_ophdr(log, ptr,
> -							ticket, optype);
> -				if (!ophdr)
> -					return -EIO;
> -
> +                                ophdr = xlog_write_setup_ophdr(ptr, ticket);
>  				xlog_write_adv_cnt(&ptr, &len, &log_offset,
>  					   sizeof(struct xlog_op_header));
>  				added_ophdr = true;
> @@ -3499,7 +3470,6 @@ xlog_ticket_alloc(
>  	struct xlog		*log,
>  	int			unit_bytes,
>  	int			cnt,
> -	char			client,
>  	bool			permanent)
>  {
>  	struct xlog_ticket	*tic;
> @@ -3517,7 +3487,6 @@ xlog_ticket_alloc(
>  	tic->t_cnt		= cnt;
>  	tic->t_ocnt		= cnt;
>  	tic->t_tid		= prandom_u32();
> -	tic->t_clientid		= client;
>  	if (permanent)
>  		tic->t_flags |= XLOG_TIC_PERM_RESERV;
>  
> diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
> index 1bd080ce3a95..c0c3141944ea 100644
> --- a/fs/xfs/xfs_log.h
> +++ b/fs/xfs/xfs_log.h
> @@ -117,16 +117,12 @@ int	  xfs_log_mount_finish(struct xfs_mount *mp);
>  void	xfs_log_mount_cancel(struct xfs_mount *);
>  xfs_lsn_t xlog_assign_tail_lsn(struct xfs_mount *mp);
>  xfs_lsn_t xlog_assign_tail_lsn_locked(struct xfs_mount *mp);
> -void	  xfs_log_space_wake(struct xfs_mount *mp);
> -int	  xfs_log_reserve(struct xfs_mount *mp,
> -			  int		   length,
> -			  int		   count,
> -			  struct xlog_ticket **ticket,
> -			  uint8_t		   clientid,
> -			  bool		   permanent);
> -int	  xfs_log_regrant(struct xfs_mount *mp, struct xlog_ticket *tic);
> -void      xfs_log_unmount(struct xfs_mount *mp);
> -int	  xfs_log_force_umount(struct xfs_mount *mp, int logerror);
> +void	xfs_log_space_wake(struct xfs_mount *mp);
> +int	xfs_log_reserve(struct xfs_mount *mp, int length, int count,
> +			struct xlog_ticket **ticket, bool permanent);
> +int	xfs_log_regrant(struct xfs_mount *mp, struct xlog_ticket *tic);
> +void	xfs_log_unmount(struct xfs_mount *mp);
> +int	xfs_log_force_umount(struct xfs_mount *mp, int logerror);
>  bool	xfs_log_writable(struct xfs_mount *mp);
>  
>  struct xlog_ticket *xfs_log_ticket_get(struct xlog_ticket *ticket);
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index e9da074ecd69..0c81c13e2cf6 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -37,7 +37,7 @@ xlog_cil_ticket_alloc(
>  {
>  	struct xlog_ticket *tic;
>  
> -	tic = xlog_ticket_alloc(log, 0, 1, XFS_TRANSACTION, 0);
> +	tic = xlog_ticket_alloc(log, 0, 1, 0);
>  
>  	/*
>  	 * set the current reservation to zero so we know to steal the basic
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index bb5fa6b71114..7f601c1c9f45 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -158,7 +158,6 @@ typedef struct xlog_ticket {
>  	int		   t_unit_res;	 /* unit reservation in bytes    : 4  */
>  	char		   t_ocnt;	 /* original count		 : 1  */
>  	char		   t_cnt;	 /* current count		 : 1  */
> -	char		   t_clientid;	 /* who does this belong to;	 : 1  */
>  	char		   t_flags;	 /* properties of reservation	 : 1  */
>  
>          /* reservation array fields */
> @@ -465,13 +464,8 @@ extern __le32	 xlog_cksum(struct xlog *log, struct xlog_rec_header *rhead,
>  			    char *dp, int size);
>  
>  extern kmem_zone_t *xfs_log_ticket_zone;
> -struct xlog_ticket *
> -xlog_ticket_alloc(
> -	struct xlog	*log,
> -	int		unit_bytes,
> -	int		count,
> -	char		client,
> -	bool		permanent);
> +struct xlog_ticket *xlog_ticket_alloc(struct xlog *log, int unit_bytes,
> +		int count, bool permanent);
>  
>  static inline void
>  xlog_write_adv_cnt(void **ptr, int *len, int *off, size_t bytes)
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 52f3fdf1e0de..83c2b7f22eb7 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -194,11 +194,9 @@ xfs_trans_reserve(
>  			ASSERT(resp->tr_logflags & XFS_TRANS_PERM_LOG_RES);
>  			error = xfs_log_regrant(mp, tp->t_ticket);
>  		} else {
> -			error = xfs_log_reserve(mp,
> -						resp->tr_logres,
> +			error = xfs_log_reserve(mp, resp->tr_logres,
>  						resp->tr_logcount,
> -						&tp->t_ticket, XFS_TRANSACTION,
> -						permanent);
> +						&tp->t_ticket, permanent);
>  		}
>  
>  		if (error)
> -- 
> 2.28.0
> 

