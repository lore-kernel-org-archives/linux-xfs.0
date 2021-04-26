Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E644BC433ED
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Apr 2021 15:06:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A780D6135A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Apr 2021 15:06:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233573AbhDZPG4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Apr 2021 11:06:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60759 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233825AbhDZPGx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Apr 2021 11:06:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619449570;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DdImOAQNZvs2zCYnk8a4U+TRNBz+bpAQygGJxQayc1E=;
        b=DgAKfIk7+EX9Movb8zsy1ucjyxNzvy05psW7ygGEJskuVoj8ZrF25VHNfpAzD0rJse2vgT
        fiPbe9slmyUaYZslkEF+oQzOftrw7ne/nzGO3u4rcspk0UiSDS1w8QPh2I1kotg2eXAfjo
        1ERnOPbRYMoDMvoV67iJ5USveUDNENE=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-576-F1F81c0FOSaeJxMkur2SHQ-1; Mon, 26 Apr 2021 11:06:08 -0400
X-MC-Unique: F1F81c0FOSaeJxMkur2SHQ-1
Received: by mail-qt1-f198.google.com with SMTP id w10-20020ac86b0a0000b02901ba74ac38c9so9648616qts.22
        for <linux-xfs@vger.kernel.org>; Mon, 26 Apr 2021 08:06:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DdImOAQNZvs2zCYnk8a4U+TRNBz+bpAQygGJxQayc1E=;
        b=dk5EzBiN4Ls7HuIS+NH5ENrOEaxI3ftXu4kDBC2YrloLaWrjbapkDr2mVx8qlK453U
         vpAlrQiwhfddyL5EPUytH16aT0YBOGE4KQWs70aks3a0fxH41+Kv0nMhDB+z22O1k7Rp
         YnNslFDkpqIUmKjNTUD5x3b8rdwDekxDPseRv9/GX0z4CKoXeMxTjMilBV4rl6nX8l62
         DA08eXFMZPsNOZeZOoFDaFfNCEO8ARJTYlGbuwG+jQyhNnVol/tnuuZpx+BezotsRanW
         3K3xHpmZbCbewGIHc1FzcwF4I8zBIrGhPID1o4XB7r0S+8A7T1SuifmC6MWVGRMi4AYV
         of+g==
X-Gm-Message-State: AOAM532iucbOKi5cZhxwm7L5nPRQH/fK3nKQAxcSRfX21A6xTViKMgyD
        HQdOxvGyKEBwf04yyy1ngdoqVdMgrpLk3jTMxHcubAxVVhrFoUj7Am0jp44LCmeBkY/y0tUUhOj
        b+BmXzu6sFsGjB6F7iIpP
X-Received: by 2002:a05:622a:1301:: with SMTP id v1mr7687047qtk.384.1619449567779;
        Mon, 26 Apr 2021 08:06:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxum5Un2eeYlrIceOBgR3KyVq+eODvcU/cMdQtEkQzAOxbnnjStEW/hfivDRg2lm0t8ZUZwTQ==
X-Received: by 2002:a05:622a:1301:: with SMTP id v1mr7687027qtk.384.1619449567505;
        Mon, 26 Apr 2021 08:06:07 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id o23sm11796806qtp.55.2021.04.26.08.06.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 08:06:07 -0700 (PDT)
Date:   Mon, 26 Apr 2021 11:06:05 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: remove support for disabling quota accounting
 on a mounted file system
Message-ID: <YIbW3QAB1VaLeHMP@bfoster>
References: <20210420072256.2326268-1-hch@lst.de>
 <20210420072256.2326268-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210420072256.2326268-2-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 20, 2021 at 09:22:55AM +0200, Christoph Hellwig wrote:
> Disabling quota accounting is hairy, racy code with all kinds of pitfalls.
> And it has a very strange mind set, as quota accounting (unlike
> enforcement) really is a propery of the on-disk format.  There is no good
> use case for supporting this.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_trans_resv.c |  30 ----
>  fs/xfs/libxfs/xfs_trans_resv.h |   2 -
>  fs/xfs/xfs_dquot_item.c        | 134 ---------------
>  fs/xfs/xfs_dquot_item.h        |  17 --
>  fs/xfs/xfs_qm.c                |   2 +-
>  fs/xfs/xfs_qm.h                |   4 -
>  fs/xfs/xfs_qm_syscalls.c       | 298 ---------------------------------
>  fs/xfs/xfs_quotaops.c          |  27 ++-
>  fs/xfs/xfs_trans_dquot.c       |  38 -----
>  9 files changed, 26 insertions(+), 526 deletions(-)
> 
...
> diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
> index 88d70c236a5445..775bbee907a4b3 100644
> --- a/fs/xfs/xfs_quotaops.c
> +++ b/fs/xfs/xfs_quotaops.c
...
> @@ -184,7 +185,29 @@ xfs_quota_disable(
>  	if (!XFS_IS_QUOTA_ON(mp))
>  		return -EINVAL;
>  
> -	return xfs_qm_scall_quotaoff(mp, xfs_quota_flags(uflags));

What happened to the xfs_quota_flags() call here? Is it unnecessary?

> +	/*
> +	 * No file system can have quotas enabled on disk but not in core.
> +	 * Note that quota utilities (like quotaoff) expect -EEXIST here.
> +	 */
> +	if ((mp->m_qflags & flags) == 0)
> +		return -EEXIST;
> +
> +	/*
> +	 * We do not support actually turning off quota accounting any more.
> +	 * Just log a warning and ignored the accounting related flags.
> +	 */
> +	if (flags & XFS_ALL_QUOTA_ACCT)
> +		xfs_info(mp, "disabling of quota accounting not supported.");
> +
> +	mutex_lock(&mp->m_quotainfo->qi_quotaofflock);
> +	mp->m_qflags &= ~(flags & XFS_ALL_QUOTA_ENFD);
> +	spin_lock(&mp->m_sb_lock);
> +	mp->m_sb.sb_qflags = mp->m_qflags;
> +	spin_unlock(&mp->m_sb_lock);
> +	mutex_unlock(&mp->m_quotainfo->qi_quotaofflock);
> +

One thing I notice from the old implementation is that it looks like we
effectively apply XFS_[UGP]QUOTA_ENFD to flags whenever the
corresponding XFS_[UGP]QUOTA_ACCT flag is passed. I don't know if that
is actually how flags are passed by userspace, but it looks like we'd
automatically disable enforcement if only a particular accounting flag
was passed. If that is the case, I wonder if we should preserve that
behavior one way or another..?

Otherwise the rest all looks pretty reasonable to me. Thanks for putting
this together.

Brian

> +	/* XXX what to do if error ? Revert back to old vals incore ? */
> +	return xfs_sync_sb(mp, false);
>  }
>  
>  STATIC int
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index 48e09ea30ee539..b7e4b05a559bdb 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -843,44 +843,6 @@ xfs_trans_reserve_quota_icreate(
>  			dblocks, 1, XFS_QMOPT_RES_REGBLKS);
>  }
>  
> -/*
> - * This routine is called to allocate a quotaoff log item.
> - */
> -struct xfs_qoff_logitem *
> -xfs_trans_get_qoff_item(
> -	struct xfs_trans	*tp,
> -	struct xfs_qoff_logitem	*startqoff,
> -	uint			flags)
> -{
> -	struct xfs_qoff_logitem	*q;
> -
> -	ASSERT(tp != NULL);
> -
> -	q = xfs_qm_qoff_logitem_init(tp->t_mountp, startqoff, flags);
> -	ASSERT(q != NULL);
> -
> -	/*
> -	 * Get a log_item_desc to point at the new item.
> -	 */
> -	xfs_trans_add_item(tp, &q->qql_item);
> -	return q;
> -}
> -
> -
> -/*
> - * This is called to mark the quotaoff logitem as needing
> - * to be logged when the transaction is committed.  The logitem must
> - * already be associated with the given transaction.
> - */
> -void
> -xfs_trans_log_quotaoff_item(
> -	struct xfs_trans	*tp,
> -	struct xfs_qoff_logitem	*qlp)
> -{
> -	tp->t_flags |= XFS_TRANS_DIRTY;
> -	set_bit(XFS_LI_DIRTY, &qlp->qql_item.li_flags);
> -}
> -
>  STATIC void
>  xfs_trans_alloc_dqinfo(
>  	xfs_trans_t	*tp)
> -- 
> 2.30.1
> 

