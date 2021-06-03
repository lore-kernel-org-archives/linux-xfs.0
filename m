Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF408C47082
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 12:23:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFF30613E6
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 12:23:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbhFCMZK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Jun 2021 08:25:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26084 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229747AbhFCMZJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Jun 2021 08:25:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622723005;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hsk+hTZIt7ptRoLzK1qaC8ocCwU9w6+dj8/HM+WHHaU=;
        b=T4GrwMn1B/FyIjU8Y6hd5pr+I5t45STATe3AA2ku8jm5BrFlQSbzxefTPBb/FW+uujrhGA
        ayvBQzb6sQPdWUE75aPe+dAPDysrsXopja285ndAA1RZ5i6D5wni4cDS1MELFvB0vKjhfd
        HFkLrZUbKbJDjm8j1syMWswOOgCXFEQ=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-54-Vowtupy-PnqB6cJFfrDhgg-1; Thu, 03 Jun 2021 08:23:24 -0400
X-MC-Unique: Vowtupy-PnqB6cJFfrDhgg-1
Received: by mail-qv1-f69.google.com with SMTP id k12-20020a0cfd6c0000b029020df9543019so1935972qvs.14
        for <linux-xfs@vger.kernel.org>; Thu, 03 Jun 2021 05:23:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hsk+hTZIt7ptRoLzK1qaC8ocCwU9w6+dj8/HM+WHHaU=;
        b=QUqBad/qXu7xrBvBjkmEFC1Bb5zj3+vk6IpGLZoLZY+xg4eYi14XrcdYX1/a/zL/ZA
         LIWjEsQLrhBT6fLvGA0ng4dgELBpMKnBnAWanpO4bV+cS+Ru0V6nWUt52rQI3J4SvhcM
         TBUMg4BV805LD/qB/qiYZTDEH7QFIcKNaDTBDzQALq8MBMxq5OLuRw2BPqEF+Jrv77Y0
         GOJ/cakTM6YC9scV5hP1xraXj3WfPbQXWvtv8I/jBEuuwyk4cv4ppxGuPhlDWOHkM5FD
         QvL1XgHf4ljGelyaddz30t1wJ0lm/2mvIHLFrDlau2RXvkNnS5GDGADKFeY88Nubvl+q
         NIcg==
X-Gm-Message-State: AOAM5310WuH5xOhQc3rw/N1hLuizYoCI5ohVtfB50Z1iyj297fdku9cO
        WIs7s/2rjNjAGm4WM5yWBgjMrLzWzvDwMbm4vf3BMbmINsN+Dew0zDB6zUGi9x9BMCF9MXsV1r7
        9UJPhVStu/cJbytyJ1wyq
X-Received: by 2002:ac8:5e0e:: with SMTP id h14mr28559986qtx.117.1622723003392;
        Thu, 03 Jun 2021 05:23:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzz/xnqENSRzaIpgXJOhU6Aw6xPAdy+fA7sOyapJta1i5WekEdo8GyTbyTl45GpazklFgOiNA==
X-Received: by 2002:ac8:5e0e:: with SMTP id h14mr28559977qtx.117.1622723003174;
        Thu, 03 Jun 2021 05:23:23 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id u14sm1887125qkp.80.2021.06.03.05.23.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 05:23:22 -0700 (PDT)
Date:   Thu, 3 Jun 2021 08:23:21 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 2/3] xfs: drop IDONTCACHE on inodes when we mark them sick
Message-ID: <YLjJuZQ0xVk17Dcg@bfoster>
References: <162268995567.2724138.15163777746481739089.stgit@locust>
 <162268996687.2724138.9307511745121153042.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162268996687.2724138.9307511745121153042.stgit@locust>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 02, 2021 at 08:12:46PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> When we decide to mark an inode sick, clear the DONTCACHE flag so that
> the incore inode will be kept around until memory pressure forces it out
> of memory.  This increases the chances that the sick status will be
> caught by someone compiling a health report later on.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_health.c |    5 +++++
>  fs/xfs/xfs_icache.c |    3 ++-
>  2 files changed, 7 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
> index 8e0cb05a7142..824e0b781290 100644
> --- a/fs/xfs/xfs_health.c
> +++ b/fs/xfs/xfs_health.c
> @@ -231,6 +231,11 @@ xfs_inode_mark_sick(
>  	ip->i_sick |= mask;
>  	ip->i_checked |= mask;
>  	spin_unlock(&ip->i_flags_lock);
> +
> +	/* Keep this inode around so we don't lose the sickness report. */
> +	spin_lock(&VFS_I(ip)->i_lock);
> +	VFS_I(ip)->i_state &= ~I_DONTCACHE;
> +	spin_unlock(&VFS_I(ip)->i_lock);

If I follow the scrub code correctly, it will grab a dontcache reference
on the inode, so presumably the intent here is to clear that status once
we've identified some problem to keep the inode around. Seems
reasonable.

>  }
>  
>  /* Mark parts of an inode healed. */
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index c3f912a9231b..0e2b6c05e604 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -23,6 +23,7 @@
>  #include "xfs_dquot.h"
>  #include "xfs_reflink.h"
>  #include "xfs_ialloc.h"
> +#include "xfs_health.h"
>  
>  #include <linux/iversion.h>
>  
> @@ -648,7 +649,7 @@ xfs_iget_cache_miss(
>  	 * time.
>  	 */
>  	iflags = XFS_INEW;
> -	if (flags & XFS_IGET_DONTCACHE)
> +	if ((flags & XFS_IGET_DONTCACHE) && xfs_inode_is_healthy(ip))
>  		d_mark_dontcache(VFS_I(ip));

This one I'm less clear on.. we've just allocated ip above and haven't
made it accessible yet. What's the use case for finding an unhealthy
inode here?

Brian

>  	ip->i_udquot = NULL;
>  	ip->i_gdquot = NULL;
> 

