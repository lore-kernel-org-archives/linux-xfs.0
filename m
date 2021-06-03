Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04311C47096
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 12:22:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD558613DC
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 12:22:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbhFCMYG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Jun 2021 08:24:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23450 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229747AbhFCMYG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Jun 2021 08:24:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622722941;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jQH+7UTydZpM3kKD52Kaetm+/8c9Qmsv8RzkzyOUHu8=;
        b=IBqwLp0HJC2ZE/hqQMc7MEl8sYumXnje3EJIvC+htAyZuEDPHzRLzMUKx5A9RFWq6kHg91
        xinNhRCurjunq5Nbf/L6LYBTevIAOi4JL6rrheHhUoskYeZ60zQ1AF8MRxc6lm/5PW6EQs
        att4TkD0BzLD+G2UKxYvWSeKujF5O3g=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-212-HMbgZ_T1Mnu1QYyqZQjw_A-1; Thu, 03 Jun 2021 08:22:13 -0400
X-MC-Unique: HMbgZ_T1Mnu1QYyqZQjw_A-1
Received: by mail-qt1-f200.google.com with SMTP id f17-20020ac87f110000b02901e117339ea7so2974231qtk.16
        for <linux-xfs@vger.kernel.org>; Thu, 03 Jun 2021 05:22:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jQH+7UTydZpM3kKD52Kaetm+/8c9Qmsv8RzkzyOUHu8=;
        b=hT6Z961s4rEW9crISlPOZdyix14gfbrK+qrbIRtKVoE+4UdbCNQcNKNw+Mg91fE5fU
         sLtVkWsC2DNESRQd2XpUao3/krE8DqddlkMATabRaiwKiCdB9Jx3M4FIVzCLCBDVIQ/i
         LTJgs+c9fJRY//L6iDmveq+N1yI40E81HhB42ztDQEOsP4uS8zIhozsiNxy8qgsexnTm
         vKfll5mKHL9szSWnC4CqueurmbZCy1Ut+r8Nv3sTYZmUlMX9V1p/YBo63QFCVIZQmdbU
         QUTiGSBfczFx1x+tPI9+A2tCJUTU1wq7b3o1ofTO7hqpnY1eKqeY487ldqdJqwm8vnM+
         CFww==
X-Gm-Message-State: AOAM533HtzK663Bhvf7MxPHzSgFmNffT8KxT8Msibl6yy0tChDNn8o3f
        K3AodwGI/O56Q8BAIgf+IQxnlIF04D35d0TcfbGha/XZJVJYmNQQMAejDzTd/EEVz3WeR0Rpvlj
        edKrj8IQFD4XieuoIrkUr
X-Received: by 2002:a37:a3cc:: with SMTP id m195mr8892067qke.433.1622722932520;
        Thu, 03 Jun 2021 05:22:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx1w3k7u0o7F3EcMjjDClbFTQ4T7UmbbwCe75ogWpxPWaDyocYMIZFDTWCN+V8H+8E82qSuQw==
X-Received: by 2002:a37:a3cc:: with SMTP id m195mr8892052qke.433.1622722932298;
        Thu, 03 Jun 2021 05:22:12 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id v6sm1784531qkv.54.2021.06.03.05.22.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 05:22:12 -0700 (PDT)
Date:   Thu, 3 Jun 2021 08:22:10 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 1/3] xfs: only reset incore inode health state flags when
 reclaiming an inode
Message-ID: <YLjJcro1vhPTfGrv@bfoster>
References: <162268995567.2724138.15163777746481739089.stgit@locust>
 <162268996135.2724138.14276025100886638786.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162268996135.2724138.14276025100886638786.stgit@locust>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 02, 2021 at 08:12:41PM -0700, Darrick J. Wong wrote:
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
> Fixes: 6772c1f11206 ("xfs: track metadata health status")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

I think I reviewed this the last time around..

Reviewed-by: Brian Foster <bfoster@redhat.com>

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

