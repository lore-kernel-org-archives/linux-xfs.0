Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52B09EB64DA
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Jul 2023 01:22:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232167AbjGMBWV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Jul 2023 21:22:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbjGMBWU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jul 2023 21:22:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26716B7
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 18:22:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF26D619BF
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jul 2023 01:22:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C703C433C8;
        Thu, 13 Jul 2023 01:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689211339;
        bh=p3kBC4Q/EqQwA4a2mrJ63mltiqfGg6hXSir+jpoMa2Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dh1UAfXfloSMsLXqLM17glNm0qP8Tn2LB6gOG2kj8PUa72mVQhCiGX3sn0FCc5zPL
         qgnnm0ESwF6CUI3mE1Rvs6gsf4gX9vFLY0l2LXedtP26yZzQDI1ecZY4QDBv0ABogV
         xbV/5Xp85An4pTfh6oHvjsO0BP/qDduj5Zvn7X5K8CKNVajGgDRgswjcQALaMGgMF+
         9xS0ILNTKVgF+3dZn31dpm48fjmR0zF6AuKZdRfK1Q1Celh7lg3pHQiiE+d+tAi+3K
         4Dz2GQJDLHhe5B20na71FALhL/3N9vRw8okUUWJ4mGgHqBY1+bqONfEN8zMlMUiO0U
         mTJu3TSPNyVcQ==
Date:   Wed, 12 Jul 2023 18:22:18 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Wengang Wang <wen.gang.wang@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: xfs_trans->t_flags overflow
Message-ID: <20230713012218.GZ108251@frogsfrogsfrogs>
References: <20230713011508.18071-1-wen.gang.wang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230713011508.18071-1-wen.gang.wang@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 12, 2023 at 06:15:08PM -0700, Wengang Wang wrote:
> Current xfs_trans->t_flags is of type uint8_t (8 bits long). We are storing
> XFS_TRANS_LOWMODE, which is 0x100, to t_flags. The highest set bit of
> XFS_TRANS_LOWMODE overflows.
> 
> Fix:
> Change the type from uint8_t to uint16_t.
> 
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_shared.h | 2 +-
>  fs/xfs/xfs_log_priv.h      | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
> index c4381388c0c1..5532d6480d53 100644
> --- a/fs/xfs/libxfs/xfs_shared.h
> +++ b/fs/xfs/libxfs/xfs_shared.h
> @@ -82,7 +82,7 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
>   * for free space from AG 0. If the correct transaction reservations have been
>   * made then this algorithm will eventually find all the space it needs.
>   */
> -#define XFS_TRANS_LOWMODE	0x100	/* allocate in low space mode */
> +#define XFS_TRANS_LOWMODE	(1u << 8)	/* allocate in low space mode */
>  
>  /*
>   * Field values for xfs_trans_mod_sb.
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 1bd2963e8fbd..e4b03edbc87b 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -151,7 +151,7 @@ typedef struct xlog_ticket {

Huh?  xlog_ticket != xfs_trans.

typedef struct xfs_trans {
	unsigned int		t_magic;	/* magic number */
	...
	unsigned int		t_flags;	/* misc flags */
	...
};

This declaration looks wide enough to me.  The only place I see
xlog_ticket.t_flags used is to set, clear, and test XLOG_TIC_PERM_RESERV.

--D

>  	int			t_unit_res;	/* unit reservation */
>  	char			t_ocnt;		/* original unit count */
>  	char			t_cnt;		/* current unit count */
> -	uint8_t			t_flags;	/* properties of reservation */
> +	uint16_t		t_flags;	/* properties of reservation */
>  	int			t_iclog_hdrs;	/* iclog hdrs in t_curr_res */
>  } xlog_ticket_t;
>  
> -- 
> 2.21.0 (Apple Git-122.2)
> 
