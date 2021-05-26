Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7695BC47088
	for <linux-xfs@archiver.kernel.org>; Wed, 26 May 2021 12:35:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4909F613D6
	for <linux-xfs@archiver.kernel.org>; Wed, 26 May 2021 12:35:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233472AbhEZMhZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 May 2021 08:37:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32066 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233513AbhEZMhX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 May 2021 08:37:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622032552;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bl09jjeoxoQZnHf9YiyESzyrUZxadKsjK25oBrk4g9A=;
        b=ePHQN0G22Tc+GwFpQr1SoKUsl0yRoDrbtHY6M2AptX4nhgPCUmzeqG+83ya9ssbSpmOOnN
        6iM7yrWtANmE3zfpyZ41VMXhJbBdskz/P+xpQTt2AragLhE6ki9oHPFDq3fSANBfYTApQw
        TasrEZtqg5+cCxhaG6S88OdIjFBHNpc=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-279-xJ55A4anP9OHvd1GINVDyQ-1; Wed, 26 May 2021 08:35:50 -0400
X-MC-Unique: xJ55A4anP9OHvd1GINVDyQ-1
Received: by mail-qt1-f198.google.com with SMTP id r1-20020ac85c810000b02901fa9798cdb5so580840qta.8
        for <linux-xfs@vger.kernel.org>; Wed, 26 May 2021 05:35:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bl09jjeoxoQZnHf9YiyESzyrUZxadKsjK25oBrk4g9A=;
        b=NBBIQWtstsiuROhGVDZxlbZ1n5SeZWuK0VhDhMJPQQ/FDw0a5gJDzArLaPWOa+fYUb
         xE4lOZCVvwpu+6EtOS/ugIv3j1pcF5qeQ8Inxi8lNdlxXDsAlxZTI3jfJCV/2iugJPqu
         F7zWvVtLJY7x3WcSWOPTvFvXsDuhH5TZOYBLWaxTipmY+05gH/cKal4EGZ+kfX+seOSj
         i9VNkVR0iEOI5nbgMp0cFltjfkkeC7nfK2L7jyiuS7d1e1IPXgrlIAD+uwTHB6nr9cAU
         P3mU2izWMoJ9ZknB+KB4o4mjMvpjAN4rJ6eiP7TtBYU74ouRQNi8EE6yRY6gyLhIoOfF
         rKlg==
X-Gm-Message-State: AOAM5333WAePnd0Cgj5oGAoN6cPyen2R1dFpaS3bEiLv8GceyohPBapu
        Ws265+Baf0AEbgSusEnIarlNXQgtTFe+mdGitKo4pKdr22gL+nGlxSBXVvVROz2v4+8xK4V1oPG
        h2mhJbLJ1mn5wvHSwFC3Y
X-Received: by 2002:a05:6214:934:: with SMTP id dk20mr43100573qvb.26.1622032550052;
        Wed, 26 May 2021 05:35:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyXV1mBmT0k4OLamMp4OGFRuXjFKHlhZoORJkjAkdsJqkaWEHtj4XV1KgemNkUHHpRSFYoBBQ==
X-Received: by 2002:a05:6214:934:: with SMTP id dk20mr43100555qvb.26.1622032549914;
        Wed, 26 May 2021 05:35:49 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id z17sm1424398qkb.59.2021.05.26.05.35.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 05:35:49 -0700 (PDT)
Date:   Wed, 26 May 2021 08:35:47 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: add new IRC channel to MAINTAINERS
Message-ID: <YK5Ao/tMNvDTKnit@bfoster>
References: <20210526052038.GX202121@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210526052038.GX202121@locust>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 25, 2021 at 10:20:38PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add our new OFTC channel to the MAINTAINERS list so everyone will know
> where to go.  Ignore the XFS wikis, we have no access to them.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  MAINTAINERS |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 008fcad7ac00..ceb146e9b506 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -19998,6 +19998,7 @@ F:	arch/x86/xen/*swiotlb*
>  F:	drivers/xen/*swiotlb*
>  
>  XFS FILESYSTEM
> +C:	irc://irc.oftc.net/xfs
>  M:	Darrick J. Wong <djwong@kernel.org>
>  M:	linux-xfs@vger.kernel.org
>  L:	linux-xfs@vger.kernel.org
> 

