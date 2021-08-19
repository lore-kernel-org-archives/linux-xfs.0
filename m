Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 671DBC4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 12:32:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4AF056113B
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 12:32:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239655AbhHSMdF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Aug 2021 08:33:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29300 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239535AbhHSMdE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Aug 2021 08:33:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629376347;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=m3Iwu0rgpyatVuMdUHD673ySGW2I0+zk2jkHfi6IvNQ=;
        b=K1HgilpGD7N/0y65SzEeX+LBEOpc5YpcIYmhwPC4W6+U/1eN5as/dFCy5Ft95noodFsFb3
        IlcsdL2qm3wIrAEyo5HwFIgwNW/GeeoqSI41h0LlcuhUO7dhZba1IYTFO8QZWEOvi6ksGS
        RS8XclPUbhi9/ZO8GT+tq0lrbFNqei4=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-349-WuHKurfxOPKloTnXms2rNQ-1; Thu, 19 Aug 2021 08:32:25 -0400
X-MC-Unique: WuHKurfxOPKloTnXms2rNQ-1
Received: by mail-ej1-f71.google.com with SMTP id e1-20020a170906c001b02905b53c2f6542so2191320ejz.7
        for <linux-xfs@vger.kernel.org>; Thu, 19 Aug 2021 05:32:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=m3Iwu0rgpyatVuMdUHD673ySGW2I0+zk2jkHfi6IvNQ=;
        b=HHrK/0H5qYDWJS/N03JXZeIWpjkIvO++vX0Z67vuwArGujlHcoJYxCfrTiDn6Pct/Z
         rsTrLcdYI+pOLwDkudQraPwQFEoxslJVpeVfn+wU7ca4zjHDRgKWID3QaqqcDIb/9tAM
         hOW+9AVlRuXlMynHChKMVgAGy/7BT95V9hGaKzyjdZY07N1LAEaDkZWH67awf3Lcap4z
         KSDGJUIa3jPfPhJ+szrsAMDZOWDxrIsAUsOhLWy0VP5PS6Wsgun4yun4aY1Lh9IeZo1Z
         mqVaUjTIk/s9kCcHztI7zXs1qpQ8GkOdJD/AtebaQeT77WXxWZR8TOJNDMLZi0IfF/Hg
         IidA==
X-Gm-Message-State: AOAM533eVprv/u8P6JZlOj+oUO6qcN8JMrvTdWSebcsF0f2G9Q+4EyZO
        HWnJnqYKW/1n5dLcg4z2lmE/jWw+8jgXsYLy6+pzeZfZkFYrXpFgZC8wB91rUwBaqjMYolrD/X9
        pq7pMgJvhx1SAenBYZsb+
X-Received: by 2002:a17:907:393:: with SMTP id ss19mr16018682ejb.468.1629376344428;
        Thu, 19 Aug 2021 05:32:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwRHhk3M42cVUbm0mpkKjtgeWCjsSbI2BspZHW/KXG/mecof/DRW/xRgC1AzW9Md+fObXTRuA==
X-Received: by 2002:a17:907:393:: with SMTP id ss19mr16018658ejb.468.1629376344257;
        Thu, 19 Aug 2021 05:32:24 -0700 (PDT)
Received: from omega.lan (ip4-46-39-172-19.cust.nbox.cz. [46.39.172.19])
        by smtp.gmail.com with ESMTPSA id cr9sm1678067edb.17.2021.08.19.05.32.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 05:32:23 -0700 (PDT)
Date:   Thu, 19 Aug 2021 14:32:22 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     david@fromorbit.com, sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/15] xfs: rename i_disk_size fields in ftrace output
Message-ID: <20210819123222.3gkcpw5mef76b7ma@omega.lan>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        david@fromorbit.com, sandeen@sandeen.net, linux-xfs@vger.kernel.org
References: <162924373176.761813.10896002154570305865.stgit@magnolia>
 <162924379266.761813.11427424580864028418.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162924379266.761813.11427424580864028418.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 17, 2021 at 04:43:12PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Whenever we record i_disk_size (i.e. the ondisk file size), use the
> "disize" tag and hexadecimal format consistently.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_trace.h |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


> 
> 
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 07da753588d5..29bf5fbfa71b 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -1386,7 +1386,7 @@ DECLARE_EVENT_CLASS(xfs_file_class,
>  		__entry->offset = iocb->ki_pos;
>  		__entry->count = iov_iter_count(iter);
>  	),
> -	TP_printk("dev %d:%d ino 0x%llx size 0x%llx pos 0x%llx bytecount 0x%zx",
> +	TP_printk("dev %d:%d ino 0x%llx disize 0x%llx pos 0x%llx bytecount 0x%zx",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->ino,
>  		  __entry->size,
> @@ -1433,7 +1433,7 @@ DECLARE_EVENT_CLASS(xfs_imap_class,
>  		__entry->startblock = irec ? irec->br_startblock : 0;
>  		__entry->blockcount = irec ? irec->br_blockcount : 0;
>  	),
> -	TP_printk("dev %d:%d ino 0x%llx size 0x%llx pos 0x%llx bytecount 0x%zx "
> +	TP_printk("dev %d:%d ino 0x%llx disize 0x%llx pos 0x%llx bytecount 0x%zx "
>  		  "fork %s startoff 0x%llx startblock 0x%llx blockcount 0x%llx",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->ino,
> @@ -1512,7 +1512,7 @@ DECLARE_EVENT_CLASS(xfs_itrunc_class,
>  		__entry->size = ip->i_disk_size;
>  		__entry->new_size = new_size;
>  	),
> -	TP_printk("dev %d:%d ino 0x%llx size 0x%llx new_size 0x%llx",
> +	TP_printk("dev %d:%d ino 0x%llx disize 0x%llx new_size 0x%llx",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->ino,
>  		  __entry->size,
> @@ -1543,7 +1543,7 @@ TRACE_EVENT(xfs_pagecache_inval,
>  		__entry->start = start;
>  		__entry->finish = finish;
>  	),
> -	TP_printk("dev %d:%d ino 0x%llx size 0x%llx start 0x%llx finish 0x%llx",
> +	TP_printk("dev %d:%d ino 0x%llx disize 0x%llx start 0x%llx finish 0x%llx",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->ino,
>  		  __entry->size,
> @@ -1573,7 +1573,7 @@ TRACE_EVENT(xfs_bunmap,
>  		__entry->caller_ip = caller_ip;
>  		__entry->flags = flags;
>  	),
> -	TP_printk("dev %d:%d ino 0x%llx size 0x%llx fileoff 0x%llx blockcount 0x%llx"
> +	TP_printk("dev %d:%d ino 0x%llx disize 0x%llx fileoff 0x%llx blockcount 0x%llx"
>  		  "flags %s caller %pS",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->ino,
> 

-- 
Carlos

