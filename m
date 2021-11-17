Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACFA1C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 04:50:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DBFC619E5
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 04:50:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231538AbhKQExn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Nov 2021 23:53:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:51794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230255AbhKQExn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 16 Nov 2021 23:53:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84111619E5;
        Wed, 17 Nov 2021 04:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637124645;
        bh=vFK9zSnapv1NfrLDOh2k6qsvbkpNMFFlHJ0LI4xjb5c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AgSzuVcsIaGQCoxaOo0v/gqycvdAc43GnKPjtwClxpFc1BYA6F7G3tykT2yFXa9mg
         d8bO8HUH8fEOsWpmCEKbxdeQ19ItzIVqW9QoRSazeDBBA9ClEVoK2j7KgCH+oYY7sj
         YIt1NdnJgdLEybVFR0FL8aNdMWdOjhMjVr+B4jSy3pPKtBrUOPH4g/qOjXrM8YnwQq
         zhIICknRJ9kJKv/Tv6J7lQknlrdDCKd6dC7pK1ZccQmcBoyWayaJ18t8AnJ6SLEbdu
         n2R5uhu1AKZsZiBu+tLa9jxmffMuReeAE3B/hxd249a9rPcdrm9adZ256UTMPoKS63
         TpRRQbIX445Zw==
Date:   Tue, 16 Nov 2021 20:50:45 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/16] xfs: change the type of ic_datap
Message-ID: <20211117045045.GR24307@magnolia>
References: <20211109015055.1547604-1-david@fromorbit.com>
 <20211109015055.1547604-11-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211109015055.1547604-11-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 09, 2021 at 12:50:49PM +1100, Dave Chinner wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> Turn ic_datap from a char into a void pointer given that it points
> to arbitrary data.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
> [dgc: also remove (char *) cast in xlog_alloc_log()]
> Signed-off-by: Dave Chinner <david@fromorbit.com>

Gosh, I actually like the syntax highlighting in lore for reading
patches.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_log.c      | 7 +++----
>  fs/xfs/xfs_log_priv.h | 2 +-
>  2 files changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 76d5a743f6fb..f26c85dbc765 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1658,7 +1658,7 @@ xlog_alloc_log(
>  		iclog->ic_log = log;
>  		atomic_set(&iclog->ic_refcnt, 0);
>  		INIT_LIST_HEAD(&iclog->ic_callbacks);
> -		iclog->ic_datap = (char *)iclog->ic_data + log->l_iclog_hsize;
> +		iclog->ic_datap = (void *)iclog->ic_data + log->l_iclog_hsize;
>  
>  		init_waitqueue_head(&iclog->ic_force_wait);
>  		init_waitqueue_head(&iclog->ic_write_wait);
> @@ -3678,7 +3678,7 @@ xlog_verify_iclog(
>  		if (field_offset & 0x1ff) {
>  			clientid = ophead->oh_clientid;
>  		} else {
> -			idx = BTOBBT((char *)&ophead->oh_clientid - iclog->ic_datap);
> +			idx = BTOBBT((void *)&ophead->oh_clientid - iclog->ic_datap);
>  			if (idx >= (XLOG_HEADER_CYCLE_SIZE / BBSIZE)) {
>  				j = idx / (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
>  				k = idx % (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
> @@ -3701,8 +3701,7 @@ xlog_verify_iclog(
>  		if (field_offset & 0x1ff) {
>  			op_len = be32_to_cpu(ophead->oh_len);
>  		} else {
> -			idx = BTOBBT((uintptr_t)&ophead->oh_len -
> -				    (uintptr_t)iclog->ic_datap);
> +			idx = BTOBBT((void *)&ophead->oh_len - iclog->ic_datap);
>  			if (idx >= (XLOG_HEADER_CYCLE_SIZE / BBSIZE)) {
>  				j = idx / (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
>  				k = idx % (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 56df86d62430..51254d7f38d6 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -190,7 +190,7 @@ typedef struct xlog_in_core {
>  	u32			ic_offset;
>  	enum xlog_iclog_state	ic_state;
>  	unsigned int		ic_flags;
> -	char			*ic_datap;	/* pointer to iclog data */
> +	void			*ic_datap;	/* pointer to iclog data */
>  	struct list_head	ic_callbacks;
>  
>  	/* reference counts need their own cacheline */
> -- 
> 2.33.0
> 
