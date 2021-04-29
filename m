Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0AD8C433ED
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Apr 2021 13:49:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E9F461408
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Apr 2021 13:49:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233602AbhD2NuW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Apr 2021 09:50:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46497 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232867AbhD2NuV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Apr 2021 09:50:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619704175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6cCCPEAn/INJWTYMGD7N0G1dnO0SADzUbSzs0Kru5mg=;
        b=GhlNhXC9Mpik4yETW3BwSV6/J5pYDfKwKlVhCokdQ46+Y65hzuPHU/OvjJGCo39ZimwU3t
        qXV2jgKkhQ/7Ioklng/uIRooxftXBlfpg81KXFF4vvefzm8m0xBn6l/0ed67Ukriq2MjFT
        5PHB0NyRtZYwz9k2nMHxqpF5ub9+4W0=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-280-8djoNKNDM0iRG5P858a1Zw-1; Thu, 29 Apr 2021 09:49:33 -0400
X-MC-Unique: 8djoNKNDM0iRG5P858a1Zw-1
Received: by mail-qt1-f199.google.com with SMTP id h4-20020ac858440000b029019d657b9f21so27270173qth.9
        for <linux-xfs@vger.kernel.org>; Thu, 29 Apr 2021 06:49:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6cCCPEAn/INJWTYMGD7N0G1dnO0SADzUbSzs0Kru5mg=;
        b=W3j8kbgpuzZ604Tjtg/ZhxwVh4ngriS9JLJz/QfZFQnHCygE3FAJt/yq0UnOMpLwzk
         RQhRvCbviaSFoqzOyI415tRDOBh6g0sypMVv+SKyPnUnythYj2xskPt0dUOI7qanPLOv
         /rQ8TN6SXHFMRr8+UFZXIUkpPzi0ZtvuYw7s9nMEy2a3NMJjadk3CIN3YfjC/xLOvkif
         qqSIE1OcDiIOp8kzaLLUSJHPEF3hZVfT9/q41q+/EZKZUUbjgU2WzZto4v3vZ+fqQ6rQ
         NK1251KlwzZSnScDSuwSVEexaKZiOFCs4swj8lE102hgZ2HZtMsC8lgjca1AMAJH5P4z
         wJgA==
X-Gm-Message-State: AOAM5308+AUOdpP13GbouuTKIyo8pS6I2M1WWw/TXH4KPzJfS4UdxbBH
        UDtKlAEC1fA3PvBWusO67IZ4lPwe1ISt78YPE+UsN0W8XZT+B0rGR1H39mdWxyEi8jxfGWy4tta
        KXk4UP0FcLZ/ayrdN8iOP
X-Received: by 2002:ac8:5c0b:: with SMTP id i11mr32273517qti.368.1619704172831;
        Thu, 29 Apr 2021 06:49:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwQPvxcS7llkd/lZsIw7lA3PP4pAtqiU2ba+cywhapJqnjPk22C+o4rZGAm9gwoK1PVnXOFXA==
X-Received: by 2002:ac8:5c0b:: with SMTP id i11mr32273499qti.368.1619704172622;
        Thu, 29 Apr 2021 06:49:32 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id l16sm2001678qtr.65.2021.04.29.06.49.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Apr 2021 06:49:32 -0700 (PDT)
Date:   Thu, 29 Apr 2021 09:49:30 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>, chandanrlinux@gmail.com
Subject: Re: [PATCH] xfs: fix xfs_reflink_unshare usage of
 filemap_write_and_wait_range
Message-ID: <YIq5aunj3raAEXqG@bfoster>
References: <20210429054416.GJ1251862@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210429054416.GJ1251862@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 28, 2021 at 10:44:16PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The final parameter of filemap_write_and_wait_range is the end of the
> range to flush, not the length of the range to flush.
> 
> Fixes: 46afb0628b86 ("xfs: only flush the unshared range in xfs_reflink_unshare")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_reflink.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 4dd4af6ac2ef..060695d6d56a 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -1522,7 +1522,8 @@ xfs_reflink_unshare(
>  	if (error)
>  		goto out;
>  
> -	error = filemap_write_and_wait_range(inode->i_mapping, offset, len);
> +	error = filemap_write_and_wait_range(inode->i_mapping, offset,
> +			offset + len - 1);
>  	if (error)
>  		goto out;
>  
> 

