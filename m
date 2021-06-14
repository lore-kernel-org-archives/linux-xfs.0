Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 590ADC2B9F4
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Jun 2021 16:14:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42EC1613CC
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Jun 2021 16:14:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234617AbhFNQQk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Jun 2021 12:16:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50361 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234550AbhFNQQj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Jun 2021 12:16:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623687276;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kpAe4GmOWQS4vxy8wZu4yLPO8n0M8JjIGIoxG6MbiQI=;
        b=T9HJLGdaidNHCm7oynA0jNSC2kAr1TtB28fnFcBP4VAcld2EM0XDx+IDgEi1oPVzIpevMO
        vPO6aOmbe75Hg1eAa4xCdO5muwdrRRIGnqt/zJxCEOWqnm011W2/SlukskKVVa1ddN764h
        CyKzaRoRthuSOLDLDc6aEWjSgbiKzoc=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-301-gPCBlPGKPbm2mUetCycW1g-1; Mon, 14 Jun 2021 12:14:35 -0400
X-MC-Unique: gPCBlPGKPbm2mUetCycW1g-1
Received: by mail-oi1-f198.google.com with SMTP id l189-20020acabbc60000b02901f566a77bb8so5839391oif.7
        for <linux-xfs@vger.kernel.org>; Mon, 14 Jun 2021 09:14:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kpAe4GmOWQS4vxy8wZu4yLPO8n0M8JjIGIoxG6MbiQI=;
        b=s8mA1qGnm6yiLmfNAHt1Cs9OATOnF96PdzI0L9cPU4vbUIHZpdC8h3d/IPVASvwkSu
         eOMLMzLOCSPwInALqfLQm6OpHIkjlvSNd38TzRqp/Ryz94dkz3Lhmcp/KEb4YjgkGGL9
         F62hDREPGUaK5E3AG/yA+3U+J/bHKGPU5qY8IQ025BfRfPLhFmuiVTx2OYXq3B/1uyHQ
         cskaEu49C8uUZEiihALHBumdz2ijkM54Nu2UBk4eYpKYLfhNdMXvatlIEAORxydxT1LD
         vaHinI/3E5aeZFgF02YwbLymSDJ142xW4sK8XpLZ/zv6HXmIZWfkaKpkvH6vXaN6fVcU
         vGZw==
X-Gm-Message-State: AOAM5334i11Ji55SusQe0QF6QFMwgW1SFTKEIu/zmv2E9hzu228iHy2k
        xSkpBXi1HHIIA7rRxNw3Ep3ciXI9eAM6jt0LAlfexkKwIuaFZCvK2RrIWVflDQqWOharp5hApZJ
        os51KW1C3iv7E4h/Gs5oB
X-Received: by 2002:aca:c60c:: with SMTP id w12mr22603980oif.46.1623687274469;
        Mon, 14 Jun 2021 09:14:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxZm51xWkV1TMr5Mhv0Y1OZyXZ1cgvYg/PPOKUGO0Y1i3jTF5Eebw8930nbAjo0kY6V1hnKhg==
X-Received: by 2002:aca:c60c:: with SMTP id w12mr22603970oif.46.1623687274326;
        Mon, 14 Jun 2021 09:14:34 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id m66sm3030617oia.28.2021.06.14.09.14.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 09:14:34 -0700 (PDT)
Date:   Mon, 14 Jun 2021 12:14:31 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Subject: Re: [PATCH 04/16] xfs: clean up xfs_inactive a little bit
Message-ID: <YMeAZ0IMnNTCgPQp@bfoster>
References: <162360479631.1530792.17147217854887531696.stgit@locust>
 <162360481889.1530792.8153660904394768299.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162360481889.1530792.8153660904394768299.stgit@locust>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jun 13, 2021 at 10:20:18AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Move the dqattach further up in xfs_inactive.  In theory we should
> always have dquots attached if there are CoW blocks, but this makes the
> usage pattern more consistent with the rest of xfs (attach dquots, then
> start making changes).
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Something like "xfs: attach dquots earlier in xfs_inactive()" might be a
more appropriate patch title..?

Otherwise seems reasonable:

Reviewed-by: Brian Foster <bfoster@redhat.com>

(It also seems like this could be a standalone patch, merged
independently instead of carrying it around with this series.)

>  fs/xfs/xfs_inode.c |   11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 85b2b11b5217..67786814997c 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1717,7 +1717,7 @@ xfs_inode_needs_inactive(
>   */
>  void
>  xfs_inactive(
> -	xfs_inode_t	*ip)
> +	struct xfs_inode	*ip)
>  {
>  	struct xfs_mount	*mp;
>  	int			error;
> @@ -1743,6 +1743,11 @@ xfs_inactive(
>  	if (xfs_is_metadata_inode(ip))
>  		goto out;
>  
> +	/* Ensure dquots are attached prior to making changes to this file. */
> +	error = xfs_qm_dqattach(ip);
> +	if (error)
> +		goto out;
> +
>  	/* Try to clean out the cow blocks if there are any. */
>  	if (xfs_inode_has_cow_data(ip))
>  		xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF, true);
> @@ -1768,10 +1773,6 @@ xfs_inactive(
>  	     ip->i_df.if_nextents > 0 || ip->i_delayed_blks > 0))
>  		truncate = 1;
>  
> -	error = xfs_qm_dqattach(ip);
> -	if (error)
> -		goto out;
> -
>  	if (S_ISLNK(VFS_I(ip)->i_mode))
>  		error = xfs_inactive_symlink(ip);
>  	else if (truncate)
> 

