Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8BD0C47082
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Jun 2021 15:03:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA5DF6135A
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Jun 2021 15:03:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233538AbhFHPEz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Jun 2021 11:04:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40010 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233671AbhFHPEz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Jun 2021 11:04:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623164582;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=M3NRFfv7WIoDImJLvDpXyx+cDVYDJiSkrEQnlEylMAg=;
        b=H0Z+kenaAWtIfQf4lhNme9BqWAZqJxnYD1s8HqE/yUVbQ/UQHEoo97HgRl4kwnMhJUUADP
        7O/nY2Fn3xjaQDeVl01RMURllmltIhUw5jjLRx/r/ObcGOa0CdDn71Qfa2/onD6iXcwlHy
        frcgRMK3gZNL63J9lY/AHSaqoukWIQk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-210-Xvj8ZeOQN_eAEeaSnutRJA-1; Tue, 08 Jun 2021 11:03:00 -0400
X-MC-Unique: Xvj8ZeOQN_eAEeaSnutRJA-1
Received: by mail-wr1-f70.google.com with SMTP id h10-20020a5d688a0000b0290119c2ce2499so4628203wru.19
        for <linux-xfs@vger.kernel.org>; Tue, 08 Jun 2021 08:03:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=M3NRFfv7WIoDImJLvDpXyx+cDVYDJiSkrEQnlEylMAg=;
        b=c/x+oQl77GBkckTmM59iRxuUSX9i2aD4ruVziYq94fwKp9s/uiYZv0cX1BHMLzdvxW
         JhYf1EOug8YukachII9qvEzS7gYxWb/IVb76YszDl8dfk7SoyCm1dWMtXDmmsZNT2D2u
         cJcDwHpIHW9QyMr0Az0lg2n6DmgwA4005tD1A1hGDOpfmPPyTNQhlr+NVnyrJFDpX9Cr
         mpHgp6aadIn3/uuVZghw/10C/lYR++HplIxaVi+LHqxFxfsgXn1xRokp5pzkwdqfZ2Da
         xsFv2v7sKqnyZDI016f8BzBi6ySK9r2U/Yy4cLmNuTUrlpa3uxfY0FUPn8xyvZSrwZOp
         ccAg==
X-Gm-Message-State: AOAM530UwO24LC9UQsFUqAQMTfbDj5tUhcnam5cEJSg1DXasruaagVNt
        U4GfWqRk6YzWTzTs1gAVCCzPXY7I0vyWB6n7/+9sJ1rjKq8QCWHt8zBgUYxi++qNrxZBKAH1drK
        RsZ4jVF+twbGdd4Jr3iYB
X-Received: by 2002:adf:e485:: with SMTP id i5mr22975521wrm.214.1623164578844;
        Tue, 08 Jun 2021 08:02:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzbCA+mqGFbjYzeGorY9sXRqgvWuVB4WO+31bHu0tq7gffeCm8gtvhpPeEVJjlfXm4HKok5Pw==
X-Received: by 2002:adf:e485:: with SMTP id i5mr22975480wrm.214.1623164578482;
        Tue, 08 Jun 2021 08:02:58 -0700 (PDT)
Received: from omega.lan (ip4-46-39-172-19.cust.nbox.cz. [46.39.172.19])
        by smtp.gmail.com with ESMTPSA id x3sm3145878wmj.30.2021.06.08.08.02.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 08:02:58 -0700 (PDT)
Date:   Tue, 8 Jun 2021 17:02:56 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, bfoster@redhat.com
Subject: Re: [PATCH 3/3] xfs: selectively keep sick inodes in memory
Message-ID: <20210608150256.667olb6qg42fq4ve@omega.lan>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        linux-xfs@vger.kernel.org, david@fromorbit.com, bfoster@redhat.com
References: <162300204472.1202529.17352653046483745148.stgit@locust>
 <162300206247.1202529.5752085682714232410.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162300206247.1202529.5752085682714232410.stgit@locust>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jun 06, 2021 at 10:54:22AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> It's important that the filesystem retain its memory of sick inodes for
> a little while after problems are found so that reports can be collected
> about what was wrong.  Don't let inode reclamation free sick inodes
> unless we're unmounting or the fs already went down.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/xfs_icache.c |   45 +++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 39 insertions(+), 6 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index c3f912a9231b..53dab8959e1d 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -71,10 +71,13 @@ static int xfs_icwalk_ag(struct xfs_perag *pag,
>  /* Stop scanning after icw_scan_limit inodes. */
>  #define XFS_ICWALK_FLAG_SCAN_LIMIT	(1U << 28)
>  
> +#define XFS_ICWALK_FLAG_RECLAIM_SICK	(1U << 27)
> +
>  #define XFS_ICWALK_PRIVATE_FLAGS	(XFS_ICWALK_FLAG_DROP_UDQUOT | \
>  					 XFS_ICWALK_FLAG_DROP_GDQUOT | \
>  					 XFS_ICWALK_FLAG_DROP_PDQUOT | \
> -					 XFS_ICWALK_FLAG_SCAN_LIMIT)
> +					 XFS_ICWALK_FLAG_SCAN_LIMIT | \
> +					 XFS_ICWALK_FLAG_RECLAIM_SICK)
>  
>  /*
>   * Allocate and initialise an xfs_inode.
> @@ -910,7 +913,8 @@ xfs_dqrele_all_inodes(
>   */
>  static bool
>  xfs_reclaim_igrab(
> -	struct xfs_inode	*ip)
> +	struct xfs_inode	*ip,
> +	struct xfs_eofblocks	*eofb)
>  {
>  	ASSERT(rcu_read_lock_held());
>  
> @@ -921,6 +925,14 @@ xfs_reclaim_igrab(
>  		spin_unlock(&ip->i_flags_lock);
>  		return false;
>  	}
> +
> +	/* Don't reclaim a sick inode unless the caller asked for it. */
> +	if (ip->i_sick &&
> +	    (!eofb || !(eofb->eof_flags & XFS_ICWALK_FLAG_RECLAIM_SICK))) {
> +		spin_unlock(&ip->i_flags_lock);
> +		return false;
> +	}
> +
>  	__xfs_iflags_set(ip, XFS_IRECLAIM);
>  	spin_unlock(&ip->i_flags_lock);
>  	return true;
> @@ -1021,13 +1033,30 @@ xfs_reclaim_inode(
>  	xfs_iflags_clear(ip, XFS_IRECLAIM);
>  }
>  
> +/* Reclaim sick inodes if we're unmounting or the fs went down. */
> +static inline bool
> +xfs_want_reclaim_sick(
> +	struct xfs_mount	*mp)
> +{
> +	return (mp->m_flags & XFS_MOUNT_UNMOUNTING) ||
> +	       (mp->m_flags & XFS_MOUNT_NORECOVERY) ||
> +	       XFS_FORCED_SHUTDOWN(mp);
> +}
> +
>  void
>  xfs_reclaim_inodes(
>  	struct xfs_mount	*mp)
>  {
> +	struct xfs_eofblocks	eofb = {
> +		.eof_flags	= 0,
> +	};
> +
> +	if (xfs_want_reclaim_sick(mp))
> +		eofb.eof_flags |= XFS_ICWALK_FLAG_RECLAIM_SICK;
> +
>  	while (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_RECLAIM_TAG)) {
>  		xfs_ail_push_all_sync(mp->m_ail);
> -		xfs_icwalk(mp, XFS_ICWALK_RECLAIM, NULL);
> +		xfs_icwalk(mp, XFS_ICWALK_RECLAIM, &eofb);
>  	}
>  }
>  
> @@ -1048,6 +1077,9 @@ xfs_reclaim_inodes_nr(
>  		.icw_scan_limit	= nr_to_scan,
>  	};
>  
> +	if (xfs_want_reclaim_sick(mp))
> +		eofb.eof_flags |= XFS_ICWALK_FLAG_RECLAIM_SICK;
> +
>  	/* kick background reclaimer and push the AIL */
>  	xfs_reclaim_work_queue(mp);
>  	xfs_ail_push_all(mp->m_ail);
> @@ -1605,7 +1637,8 @@ xfs_blockgc_free_quota(
>  static inline bool
>  xfs_icwalk_igrab(
>  	enum xfs_icwalk_goal	goal,
> -	struct xfs_inode	*ip)
> +	struct xfs_inode	*ip,
> +	struct xfs_eofblocks	*eofb)
>  {
>  	switch (goal) {
>  	case XFS_ICWALK_DQRELE:
> @@ -1613,7 +1646,7 @@ xfs_icwalk_igrab(
>  	case XFS_ICWALK_BLOCKGC:
>  		return xfs_blockgc_igrab(ip);
>  	case XFS_ICWALK_RECLAIM:
> -		return xfs_reclaim_igrab(ip);
> +		return xfs_reclaim_igrab(ip, eofb);
>  	default:
>  		return false;
>  	}
> @@ -1702,7 +1735,7 @@ xfs_icwalk_ag(
>  		for (i = 0; i < nr_found; i++) {
>  			struct xfs_inode *ip = batch[i];
>  
> -			if (done || !xfs_icwalk_igrab(goal, ip))
> +			if (done || !xfs_icwalk_igrab(goal, ip, eofb))
>  				batch[i] = NULL;
>  
>  			/*
> 

-- 
Carlos

