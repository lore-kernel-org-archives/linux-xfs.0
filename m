Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F40EC47254
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 09:29:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BB3B2075A
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 09:29:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DoB0YZQz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727931AbgEEJ35 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 May 2020 05:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725766AbgEEJ34 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 May 2020 05:29:56 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FCD3C061A0F
        for <linux-xfs@vger.kernel.org>; Tue,  5 May 2020 02:29:56 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id mq3so789610pjb.1
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 02:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yilirYGikd4SlQXs1eSLAEgDMW/DuMRNR9czsAHqEdE=;
        b=DoB0YZQzuyHzc0q18LjTXXtF85kb6pPgieq40LxWopw+3A7UOqmJ+yxYePfyMynI7E
         mcsjFJFGTmjmQjyHMgs1fVsfViJfvVxcY6O/xrmAebE/PIyUvr8bvUFA0DnYt1C/6Q7b
         66seRMMbLKVfkjMvxRwnUC/wPDOsdzk8887a2mN1zOb7xBjN757hzm4cgnyAaTNA0X/t
         8jhhog5zBIw2pvh0qfxLvsegr7gR9bFRSEhIiM8PIIzAzhcUzbZbieHVpHJFTzf51qjy
         bILiIUWZoTtPRu4OMIDMlD0xyPGAE4u3hm6BV+p7ZdpBPP+uMbX+Kuh5Qd/e5NtR5cH2
         f/Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yilirYGikd4SlQXs1eSLAEgDMW/DuMRNR9czsAHqEdE=;
        b=TFcnL1lh8lFsZarbJ14HfhWEthlrko21+sJ2IU5MVYUTx1PKPEfwKoOZZrCMNHMJid
         u9v3GEgnvWr4UIlmG1x1I8KqkLAH32BX1kCSCYghVfg5hwLgJFvVEsPvfkZ68Z1xS7dr
         j6DrQB4ka8zlJrz9glBp1Ec7EidXk1mGeL/CKEJ3Afhz0PDHGs6LNBwCWb/HzZ7lIndn
         mdJPKdIcFLbiubImGvrHA6AePjmtXIPPDPfIGYV7uZAGG97eqnLScV5RUtFBx4QRyCYj
         bRcSrjZWK10wOkdvOyJaGgbVKkWaEI7nbhNttoI4EEvL7Tn8G0Al8bWA6VYk+dWyiv2Q
         rtSw==
X-Gm-Message-State: AGi0PuZZ4ww1JgTKC5e67bPf/Ia2SWE5t31+5MJAJGlgNXJdKpe1cZpW
        g2y3yXgH28qKebQ39WXAZ0TQKylkRfk=
X-Google-Smtp-Source: APiQypL9rccwfkk+tcTmqddP0qnBL96Iol9xIZrG9t9mQC3ZiPrYr827f5tjv47yinEFqikF9TKMUg==
X-Received: by 2002:a17:90a:fb89:: with SMTP id cp9mr1804247pjb.40.1588670996178;
        Tue, 05 May 2020 02:29:56 -0700 (PDT)
Received: from garuda.localnet ([122.171.152.206])
        by smtp.gmail.com with ESMTPSA id e12sm1214987pgv.16.2020.05.05.02.29.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 02:29:55 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 16/28] xfs: refactor recovered CUI log item playback
Date:   Tue, 05 May 2020 14:59:53 +0530
Message-ID: <2088588.1jBhJPiLum@garuda>
In-Reply-To: <1747593.SPgpe11F3s@garuda>
References: <158864103195.182683.2056162574447133617.stgit@magnolia> <158864113397.182683.5812513715201193839.stgit@magnolia> <1747593.SPgpe11F3s@garuda>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tuesday 5 May 2020 2:59:02 PM IST Chandan Babu R wrote:
> On Tuesday 5 May 2020 6:42:14 AM IST Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Move the code that processes the log items created from the recovered
> > log items into the per-item source code files and use dispatch functions
> > to call them.  No functional changes.
> >
> 
> RUI log item playback is consistent with what was done before the patch is
> applied.

I meant "CUI log item playback ...".

> 
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
> 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_log_recover.c   |   48 ++------------------------------------------
> >  fs/xfs/xfs_refcount_item.c |   44 ++++++++++++++++++++++++++++++++--------
> >  fs/xfs/xfs_refcount_item.h |    3 ---
> >  3 files changed, 37 insertions(+), 58 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > index da66484acaa7..ad5ac97ed0c7 100644
> > --- a/fs/xfs/xfs_log_recover.c
> > +++ b/fs/xfs/xfs_log_recover.c
> > @@ -2553,46 +2553,6 @@ xlog_recover_process_data(
> >  	return 0;
> >  }
> >  
> > -/* Recover the CUI if necessary. */
> > -STATIC int
> > -xlog_recover_process_cui(
> > -	struct xfs_trans		*parent_tp,
> > -	struct xfs_ail			*ailp,
> > -	struct xfs_log_item		*lip)
> > -{
> > -	struct xfs_cui_log_item		*cuip;
> > -	int				error;
> > -
> > -	/*
> > -	 * Skip CUIs that we've already processed.
> > -	 */
> > -	cuip = container_of(lip, struct xfs_cui_log_item, cui_item);
> > -	if (test_bit(XFS_CUI_RECOVERED, &cuip->cui_flags))
> > -		return 0;
> > -
> > -	spin_unlock(&ailp->ail_lock);
> > -	error = xfs_cui_recover(parent_tp, cuip);
> > -	spin_lock(&ailp->ail_lock);
> > -
> > -	return error;
> > -}
> > -
> > -/* Release the CUI since we're cancelling everything. */
> > -STATIC void
> > -xlog_recover_cancel_cui(
> > -	struct xfs_mount		*mp,
> > -	struct xfs_ail			*ailp,
> > -	struct xfs_log_item		*lip)
> > -{
> > -	struct xfs_cui_log_item		*cuip;
> > -
> > -	cuip = container_of(lip, struct xfs_cui_log_item, cui_item);
> > -
> > -	spin_unlock(&ailp->ail_lock);
> > -	xfs_cui_release(cuip);
> > -	spin_lock(&ailp->ail_lock);
> > -}
> > -
> >  /* Recover the BUI if necessary. */
> >  STATIC int
> >  xlog_recover_process_bui(
> > @@ -2758,10 +2718,8 @@ xlog_recover_process_intents(
> >  		switch (lip->li_type) {
> >  		case XFS_LI_EFI:
> >  		case XFS_LI_RUI:
> > -			error = lip->li_ops->iop_recover(lip, parent_tp);
> > -			break;
> >  		case XFS_LI_CUI:
> > -			error = xlog_recover_process_cui(parent_tp, ailp, lip);
> > +			error = lip->li_ops->iop_recover(lip, parent_tp);
> >  			break;
> >  		case XFS_LI_BUI:
> >  			error = xlog_recover_process_bui(parent_tp, ailp, lip);
> > @@ -2812,13 +2770,11 @@ xlog_recover_cancel_intents(
> >  		switch (lip->li_type) {
> >  		case XFS_LI_EFI:
> >  		case XFS_LI_RUI:
> > +		case XFS_LI_CUI:
> >  			spin_unlock(&ailp->ail_lock);
> >  			lip->li_ops->iop_release(lip);
> >  			spin_lock(&ailp->ail_lock);
> >  			break;
> > -		case XFS_LI_CUI:
> > -			xlog_recover_cancel_cui(log->l_mp, ailp, lip);
> > -			break;
> >  		case XFS_LI_BUI:
> >  			xlog_recover_cancel_bui(log->l_mp, ailp, lip);
> >  			break;
> > diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> > index 28b41f5dd6bc..5b72eebd8764 100644
> > --- a/fs/xfs/xfs_refcount_item.c
> > +++ b/fs/xfs/xfs_refcount_item.c
> > @@ -24,6 +24,8 @@
> >  kmem_zone_t	*xfs_cui_zone;
> >  kmem_zone_t	*xfs_cud_zone;
> >  
> > +static const struct xfs_item_ops xfs_cui_item_ops;
> > +
> >  static inline struct xfs_cui_log_item *CUI_ITEM(struct xfs_log_item *lip)
> >  {
> >  	return container_of(lip, struct xfs_cui_log_item, cui_item);
> > @@ -46,7 +48,7 @@ xfs_cui_item_free(
> >   * committed vs unpin operations in bulk insert operations. Hence the reference
> >   * count to ensure only the last caller frees the CUI.
> >   */
> > -void
> > +STATIC void
> >  xfs_cui_release(
> >  	struct xfs_cui_log_item	*cuip)
> >  {
> > @@ -125,13 +127,6 @@ xfs_cui_item_release(
> >  	xfs_cui_release(CUI_ITEM(lip));
> >  }
> >  
> > -static const struct xfs_item_ops xfs_cui_item_ops = {
> > -	.iop_size	= xfs_cui_item_size,
> > -	.iop_format	= xfs_cui_item_format,
> > -	.iop_unpin	= xfs_cui_item_unpin,
> > -	.iop_release	= xfs_cui_item_release,
> > -};
> > -
> >  /*
> >   * Allocate and initialize an cui item with the given number of extents.
> >   */
> > @@ -425,7 +420,7 @@ const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
> >   * Process a refcount update intent item that was recovered from the log.
> >   * We need to update the refcountbt.
> >   */
> > -int
> > +STATIC int
> >  xfs_cui_recover(
> >  	struct xfs_trans		*parent_tp,
> >  	struct xfs_cui_log_item		*cuip)
> > @@ -573,6 +568,37 @@ xfs_cui_recover(
> >  	return error;
> >  }
> >  
> > +/* Recover the CUI if necessary. */
> > +STATIC int
> > +xfs_cui_item_recover(
> > +	struct xfs_log_item		*lip,
> > +	struct xfs_trans		*tp)
> > +{
> > +	struct xfs_ail			*ailp = lip->li_ailp;
> > +	struct xfs_cui_log_item		*cuip = CUI_ITEM(lip);
> > +	int				error;
> > +
> > +	/*
> > +	 * Skip CUIs that we've already processed.
> > +	 */
> > +	if (test_bit(XFS_CUI_RECOVERED, &cuip->cui_flags))
> > +		return 0;
> > +
> > +	spin_unlock(&ailp->ail_lock);
> > +	error = xfs_cui_recover(tp, cuip);
> > +	spin_lock(&ailp->ail_lock);
> > +
> > +	return error;
> > +}
> > +
> > +static const struct xfs_item_ops xfs_cui_item_ops = {
> > +	.iop_size	= xfs_cui_item_size,
> > +	.iop_format	= xfs_cui_item_format,
> > +	.iop_unpin	= xfs_cui_item_unpin,
> > +	.iop_release	= xfs_cui_item_release,
> > +	.iop_recover	= xfs_cui_item_recover,
> > +};
> > +
> >  /*
> >   * Copy an CUI format buffer from the given buf, and into the destination
> >   * CUI format structure.  The CUI/CUD items were designed not to need any
> > diff --git a/fs/xfs/xfs_refcount_item.h b/fs/xfs/xfs_refcount_item.h
> > index ebe12779eaac..cfaa857673a6 100644
> > --- a/fs/xfs/xfs_refcount_item.h
> > +++ b/fs/xfs/xfs_refcount_item.h
> > @@ -77,7 +77,4 @@ struct xfs_cud_log_item {
> >  extern struct kmem_zone	*xfs_cui_zone;
> >  extern struct kmem_zone	*xfs_cud_zone;
> >  
> > -void xfs_cui_release(struct xfs_cui_log_item *);
> > -int xfs_cui_recover(struct xfs_trans *parent_tp, struct xfs_cui_log_item *cuip);
> > -
> >  #endif	/* __XFS_REFCOUNT_ITEM_H__ */
> > 
> > 
> 
> 
> 


-- 
chandan



