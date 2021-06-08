Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75C59C47082
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Jun 2021 14:55:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5930761185
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Jun 2021 14:55:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233675AbhFHO5D (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Jun 2021 10:57:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24271 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233640AbhFHO5C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Jun 2021 10:57:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623164109;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=t0Q23iQlPwfOjnj1KkoNZAHYqwHYtgAztWr3Nh8ZjDA=;
        b=dUCQ21agBsesUh7Xc4J5rA2HTzgknxt78hnmDve3XdWLKyUsGSL/zVEz84mU5Lmqj5yLfM
        v4fb67sMtoPZ87spTc0IDIftSGyMh+R7294x859ESWgJS93J13UYXM3P53elsk/Bsv1JLP
        //aVSS0qQ6HKamksA3rgdrCgfLRzHb4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-263-IAtOTcj9M_u-zShpAUXwXw-1; Tue, 08 Jun 2021 10:55:05 -0400
X-MC-Unique: IAtOTcj9M_u-zShpAUXwXw-1
Received: by mail-wr1-f70.google.com with SMTP id m27-20020a056000025bb0290114d19822edso9551726wrz.21
        for <linux-xfs@vger.kernel.org>; Tue, 08 Jun 2021 07:55:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=t0Q23iQlPwfOjnj1KkoNZAHYqwHYtgAztWr3Nh8ZjDA=;
        b=syQrEQ6EhPATePWN36cKLIrK3dHQM5lXXDYPWpRS2m/6AhfSaua2mV9Jxq8+BDG7Hh
         tUPDlGMTTi49oBfYcB7axku9Da3beWbC/EAcpvbmWPEImIxZ1niSfT948+T5LyOqrCtd
         TodoeieImQ+pRGv0nxhWuFGFkV/4H2EOJ42+0GaA3TG8gueC0s8a+Nl/wCvYXgnfk4I8
         mHWE8YyfpyKqt1SVnxALZzi9ypeu5PCTnmIX6oBCiNvR9lQiIY0e1VzGboLDlyFyM0k/
         VlDAAJ13VnOInXhoBhnExWJyf0GZ8KFUJhd5v9pamZ8MxH33qVY8Qc8rrLYEVNKRE8Bg
         E2BQ==
X-Gm-Message-State: AOAM531C10mVIrpu2Bz/HMEP/iCugU3HbVWN53dw8tx3AL3Zspk3lQzI
        vVjh2WZrVrL/5O0a7zncpttG0oSP1LuMXOVG/+KpBosa2J5/7/PydXRhNnbOeTAlOyVWNeAdRfe
        jgy+KlZ7qR6ZlxuvjDtni
X-Received: by 2002:a1c:7313:: with SMTP id d19mr22340037wmb.14.1623164104673;
        Tue, 08 Jun 2021 07:55:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyGj+SuM2TysctjBIwYW94SIotUmHPbirKwwqHos4bXAubD2WS8jQ6Xzru5hw7KUNDtzg25cg==
X-Received: by 2002:a1c:7313:: with SMTP id d19mr22340009wmb.14.1623164104390;
        Tue, 08 Jun 2021 07:55:04 -0700 (PDT)
Received: from omega.lan (ip4-46-39-172-19.cust.nbox.cz. [46.39.172.19])
        by smtp.gmail.com with ESMTPSA id h9sm3420368wmm.33.2021.06.08.07.55.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 07:55:03 -0700 (PDT)
Date:   Tue, 8 Jun 2021 16:55:01 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        david@fromorbit.com
Subject: Re: [PATCH 1/3] xfs: only reset incore inode health state flags when
 reclaiming an inode
Message-ID: <20210608145501.l4ba547rn72v2p5x@omega.lan>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        david@fromorbit.com
References: <162300204472.1202529.17352653046483745148.stgit@locust>
 <162300205146.1202529.12989228054689182888.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162300205146.1202529.12989228054689182888.stgit@locust>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jun 06, 2021 at 10:54:11AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> While running some fuzz tests on inode metadata, I noticed that the
> filesystem health report (as provided by xfs_spaceman) failed to report
> the file corruption even when spaceman was run immediately after running
> xfs_scrub to detect the corruption.  That isn't the intended behavior;
> one ought to be able to run scrub to detect errors in the ondisk
> metadata and be able to access to those reports for some time after the
> scrub.
> 
> After running the same sequence through an instrumented kernel, I
> discovered the reason why -- scrub igets the file, scans it, marks it
> sick, and ireleases the inode.  When the VFS lets go of the incore
> inode, it moves to RECLAIMABLE state.  If spaceman igets the incore
> inode before it moves to RECLAIM state, iget reinitializes the VFS
> state, clears the sick and checked masks, and hands back the inode.  At
> this point, the caller has the exact same incore inode, but with all the
> health state erased.
> 
> In other words, we're erasing the incore inode's health state flags when
> we've decided NOT to sever the link between the incore inode and the
> ondisk inode.  This is wrong, so we need to remove the lines that zero
> the fields from xfs_iget_cache_hit.
> 
> As a precaution, we add the same lines into xfs_reclaim_inode just after
> we sever the link between incore and ondisk inode.  Strictly speaking
> this isn't necessary because once an inode has gone through reclaim it
> must go through xfs_inode_alloc (which also zeroes the state) and
> xfs_iget is careful to check for mismatches between the inode it pulls
> out of the radix tree and the one it wants.
> 
> ---

Looks good.
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

>  fs/xfs/xfs_icache.c |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 396cc54ca03f..c3f912a9231b 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -523,9 +523,6 @@ xfs_iget_cache_hit(
>  				XFS_INO_TO_AGINO(pag->pag_mount, ino),
>  				XFS_ICI_RECLAIM_TAG);
>  		inode->i_state = I_NEW;
> -		ip->i_sick = 0;
> -		ip->i_checked = 0;
> -
>  		spin_unlock(&ip->i_flags_lock);
>  		spin_unlock(&pag->pag_ici_lock);
>  	} else {
> @@ -979,6 +976,8 @@ xfs_reclaim_inode(
>  	spin_lock(&ip->i_flags_lock);
>  	ip->i_flags = XFS_IRECLAIM;
>  	ip->i_ino = 0;
> +	ip->i_sick = 0;
> +	ip->i_checked = 0;
>  	spin_unlock(&ip->i_flags_lock);
>  
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> 

-- 
Carlos

