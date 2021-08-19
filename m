Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0456C4320A
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 11:02:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D93B6109E
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 11:02:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238283AbhHSLDY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Aug 2021 07:03:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27793 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237843AbhHSLDY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Aug 2021 07:03:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629370967;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=P+sn6BHudmxXf3+xd6nzXvHqS/xiyGwX4qj31M7lhs0=;
        b=PgkLoursuzQbIxdZnR98T3eX9xMh6/V99Qc7vJhPTmVNpocTfMJJg1aZvZSIekB2pM62hc
        DQH0KKGKBxrHXjuoaUZ/2rvcYxQPBhTzcSoAR8ohFfpB91leUpLabhRf5riuuB2THZh0fW
        QJvAMpx1hmVrulK1ZZYdm2ak9GVDH+c=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-140-4TRZNEEDOpee0LuRY776fQ-1; Thu, 19 Aug 2021 07:02:46 -0400
X-MC-Unique: 4TRZNEEDOpee0LuRY776fQ-1
Received: by mail-ed1-f70.google.com with SMTP id x4-20020a50d9c4000000b003bed5199871so2619433edj.14
        for <linux-xfs@vger.kernel.org>; Thu, 19 Aug 2021 04:02:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=P+sn6BHudmxXf3+xd6nzXvHqS/xiyGwX4qj31M7lhs0=;
        b=MB5qjva7gGRGVQz8UP1ENzwZkSs7InsVjYLiZhZmPpWZyHAYi/ManwZ4INezH1Jmej
         0FngP5ZbjpYeW917haxxKDwzrb6XdmIkZo2Xx4SlMibTXW3YVhI1NiNi53pGrF2H55SS
         FIlQGHTXmOfyqoOYR2o/BYTxwSX5sVJXvErnnmFZe7RK/UAcMiJz1890tmf1Y/jIpSat
         S6eHPpPvYDiraufVDOwRm72LtWR1ZcjyuNNfGq+FOjXsPKiYC4YWqXkAW4B2AqU7zZEi
         1ZAzrh0bcDN82lf1SBRAOAk9C+N9fWJ54huIboQUh5rKM5eTRN22z33WqGExNz5B4+zC
         Bbvg==
X-Gm-Message-State: AOAM533kUDj43bXyqV4bPeNwVY13YQq514payGFTx8WOG3X1xxtCmnaJ
        PwNZBug8iiJ3Oc8Y/JtBnRWDbAamN3kqv6BxadBehcy+CVCu8wmxgDELodE0NIDPoG1iVlM44g2
        M01Rc9iBd7cSA4/eiQmfL
X-Received: by 2002:a17:906:6b0c:: with SMTP id q12mr15297116ejr.0.1629370965093;
        Thu, 19 Aug 2021 04:02:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzGYYgPM5MF6LACOTYNuVkjTV0fGIM0csbWniXG4sTF4KU8lMrCPfurq694JjNK+6bSCzDLjg==
X-Received: by 2002:a17:906:6b0c:: with SMTP id q12mr15297096ejr.0.1629370964889;
        Thu, 19 Aug 2021 04:02:44 -0700 (PDT)
Received: from omega.lan (ip4-46-39-172-19.cust.nbox.cz. [46.39.172.19])
        by smtp.gmail.com with ESMTPSA id m19sm1545874edd.38.2021.08.19.04.02.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 04:02:44 -0700 (PDT)
Date:   Thu, 19 Aug 2021 13:02:42 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     david@fromorbit.com, sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/15] xfs: standardize daddr formatting in ftrace output
Message-ID: <20210819110242.yggbbtq2qeklhfct@omega.lan>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        david@fromorbit.com, sandeen@sandeen.net, linux-xfs@vger.kernel.org
References: <162924373176.761813.10896002154570305865.stgit@magnolia>
 <162924376504.761813.17237311452402341703.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162924376504.761813.17237311452402341703.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 17, 2021 at 04:42:45PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Always print disk addr (i.e. 512 byte block) numbers in hexadecimal and
> preceded with the unit "daddr".
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/xfs_trace.h |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index d6365a0ee0ff..3944373ad2f6 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -397,7 +397,7 @@ DECLARE_EVENT_CLASS(xfs_buf_class,
>  		__entry->flags = bp->b_flags;
>  		__entry->caller_ip = caller_ip;
>  	),
> -	TP_printk("dev %d:%d bno 0x%llx nblks 0x%x hold %d pincount %d "
> +	TP_printk("dev %d:%d daddr 0x%llx nblks 0x%x hold %d pincount %d "
>  		  "lock %d flags %s caller %pS",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  (unsigned long long)__entry->bno,
> @@ -465,7 +465,7 @@ DECLARE_EVENT_CLASS(xfs_buf_flags_class,
>  		__entry->lockval = bp->b_sema.count;
>  		__entry->caller_ip = caller_ip;
>  	),
> -	TP_printk("dev %d:%d bno 0x%llx len 0x%zx hold %d pincount %d "
> +	TP_printk("dev %d:%d daddr 0x%llx len 0x%zx hold %d pincount %d "
>  		  "lock %d flags %s caller %pS",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  (unsigned long long)__entry->bno,
> @@ -510,7 +510,7 @@ TRACE_EVENT(xfs_buf_ioerror,
>  		__entry->flags = bp->b_flags;
>  		__entry->caller_ip = caller_ip;
>  	),
> -	TP_printk("dev %d:%d bno 0x%llx len 0x%zx hold %d pincount %d "
> +	TP_printk("dev %d:%d daddr 0x%llx len 0x%zx hold %d pincount %d "
>  		  "lock %d error %d flags %s caller %pS",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  (unsigned long long)__entry->bno,
> @@ -552,7 +552,7 @@ DECLARE_EVENT_CLASS(xfs_buf_item_class,
>  		__entry->buf_lockval = bip->bli_buf->b_sema.count;
>  		__entry->li_flags = bip->bli_item.li_flags;
>  	),
> -	TP_printk("dev %d:%d bno 0x%llx len 0x%zx hold %d pincount %d "
> +	TP_printk("dev %d:%d daddr 0x%llx len 0x%zx hold %d pincount %d "
>  		  "lock %d flags %s recur %d refcount %d bliflags %s "
>  		  "liflags %s",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
> 

-- 
Carlos

