Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FADEC4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 12:26:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 432B0610FF
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 12:26:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232676AbhHSM1U (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Aug 2021 08:27:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34611 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230292AbhHSM1U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Aug 2021 08:27:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629376003;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ClEJvTzj2MRdW9qoSPtO6B0cxqQzr37/djc+GK/w+S4=;
        b=P8lsaMD9lk/kCllStqfjPpfVx9+m4eVNutYU8P8isloPKTTJ9bneMQHPStTcG5BJMBBRgm
        M5QtjYfV+CEAABsgbQfCf4CSAPgZUum2scnSCIUIDRg2filsjvD/c5rIN4Oen/z95h8FZb
        1nNlkBsMkRxsvB1D3xgGs/afSYWILW0=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-332-e3_xn8i4NK2lOvnE79vzEg-1; Thu, 19 Aug 2021 08:26:40 -0400
X-MC-Unique: e3_xn8i4NK2lOvnE79vzEg-1
Received: by mail-ed1-f70.google.com with SMTP id v20-20020aa7d9d40000b02903be68450bf3so2737446eds.23
        for <linux-xfs@vger.kernel.org>; Thu, 19 Aug 2021 05:26:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=ClEJvTzj2MRdW9qoSPtO6B0cxqQzr37/djc+GK/w+S4=;
        b=tX7nZp3j6DDn8fXX593aW/T0o/ST7rwOnxs6eg/hohdADkUJE7IbZEWIaoKdsq5rtI
         4mr4krvHjn2WLxphilMzc6ZzA/JoSiHon5cGQO7N/Qyu66AkoVxDL1leODMQdr3W6itW
         wNHb+/KOPmjytRXbk4b6VvLbyTFe9B1e0b9lKZFEBhQQwb7Z9H2QB211yl+sW17FmM8H
         Z4jzem37Ma4IXiKOgXRoQpmKRA8OFXW4elij9FnJN2c46A6wB1vn9pA3HrxgpCuRwaLH
         V/0N1NTJmw67UdPVLf7c6oU0sjLxHNjApimWJEYDIRsyybW5ZWyPGyEf64MmKjTzXact
         1reA==
X-Gm-Message-State: AOAM533iTFZBcXK+ykCfk/1SfquhQ4EU+j6oiMh32rPPUkZuER7s9h2W
        bmFRHWcNgvKOYIl5RwMboTp6jFVrlFSUGQV1rCyXcrr3zOBDaEkcXOcrvF5AD3UEKdhL7KaBjwr
        eKuTJPpNIQY6tMyk0KTmz
X-Received: by 2002:a05:6402:54a:: with SMTP id i10mr8700257edx.172.1629375999179;
        Thu, 19 Aug 2021 05:26:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwJv57F4G0GHXZd36hdpaxeYCQ7QQdiyCS1e69l4oWLprLY32bQGvYsXa27UJvEQZAZipbrVA==
X-Received: by 2002:a05:6402:54a:: with SMTP id i10mr8700245edx.172.1629375999013;
        Thu, 19 Aug 2021 05:26:39 -0700 (PDT)
Received: from omega.lan (ip4-46-39-172-19.cust.nbox.cz. [46.39.172.19])
        by smtp.gmail.com with ESMTPSA id f20sm1208008ejz.30.2021.08.19.05.26.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 05:26:38 -0700 (PDT)
Date:   Thu, 19 Aug 2021 14:26:36 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     david@fromorbit.com, sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 10/15] xfs: disambiguate units for ftrace fields
 tagged "count"
Message-ID: <20210819122636.vmckwp7s2dfu6xhn@omega.lan>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        david@fromorbit.com, sandeen@sandeen.net, linux-xfs@vger.kernel.org
References: <162924373176.761813.10896002154570305865.stgit@magnolia>
 <162924378705.761813.11309968953103960937.stgit@magnolia>
 <20210819034536.GQ12640@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210819034536.GQ12640@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 18, 2021 at 08:45:36PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Some of our tracepoints have a field known as "count".  That name
> doesn't describe any units, which makes the fields not very useful.
> Rename the fields to capture units and ensure the format is hexadecimal
> when we're referring to blocks, extents, or IO operations.
> 
> "fsbcount" are in units of fs blocks
> "bytecount" are in units of bytes
> "ireccount" are in units of inode records
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
> v2: rename the count units
> ---

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

>  fs/xfs/xfs_trace.h |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 4169dc6cb5b9..cc479caffd55 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -346,7 +346,7 @@ DECLARE_EVENT_CLASS(xfs_bmap_class,
>  		__entry->caller_ip = caller_ip;
>  	),
>  	TP_printk("dev %d:%d ino 0x%llx state %s cur %p/%d "
> -		  "fileoff 0x%llx startblock 0x%llx count %lld flag %d caller %pS",
> +		  "fileoff 0x%llx startblock 0x%llx fsbcount 0x%llx flag %d caller %pS",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->ino,
>  		  __print_flags(__entry->bmap_state, "|", XFS_BMAP_EXT_FLAGS),
> @@ -1392,7 +1392,7 @@ DECLARE_EVENT_CLASS(xfs_file_class,
>  		__entry->offset = iocb->ki_pos;
>  		__entry->count = iov_iter_count(iter);
>  	),
> -	TP_printk("dev %d:%d ino 0x%llx size 0x%llx pos 0x%llx count 0x%zx",
> +	TP_printk("dev %d:%d ino 0x%llx size 0x%llx pos 0x%llx bytecount 0x%zx",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->ino,
>  		  __entry->size,
> @@ -1439,7 +1439,7 @@ DECLARE_EVENT_CLASS(xfs_imap_class,
>  		__entry->startblock = irec ? irec->br_startblock : 0;
>  		__entry->blockcount = irec ? irec->br_blockcount : 0;
>  	),
> -	TP_printk("dev %d:%d ino 0x%llx size 0x%llx pos 0x%llx count %zd "
> +	TP_printk("dev %d:%d ino 0x%llx size 0x%llx pos 0x%llx bytecount 0x%zx "
>  		  "fork %s startoff 0x%llx startblock 0x%llx fsbcount 0x%llx",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->ino,
> @@ -1482,7 +1482,7 @@ DECLARE_EVENT_CLASS(xfs_simple_io_class,
>  		__entry->count = count;
>  	),
>  	TP_printk("dev %d:%d ino 0x%llx isize 0x%llx disize 0x%llx "
> -		  "pos 0x%llx count %zd",
> +		  "pos 0x%llx bytecount 0x%zx",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->ino,
>  		  __entry->isize,
> @@ -3227,7 +3227,7 @@ DECLARE_EVENT_CLASS(xfs_double_io_class,
>  		__field(loff_t, src_isize)
>  		__field(loff_t, src_disize)
>  		__field(loff_t, src_offset)
> -		__field(size_t, len)
> +		__field(long long, len)
>  		__field(xfs_ino_t, dest_ino)
>  		__field(loff_t, dest_isize)
>  		__field(loff_t, dest_disize)
> @@ -3245,7 +3245,7 @@ DECLARE_EVENT_CLASS(xfs_double_io_class,
>  		__entry->dest_disize = dest->i_disk_size;
>  		__entry->dest_offset = doffset;
>  	),
> -	TP_printk("dev %d:%d count %zd "
> +	TP_printk("dev %d:%d bytecount 0x%llx "
>  		  "ino 0x%llx isize 0x%llx disize 0x%llx pos 0x%llx -> "
>  		  "ino 0x%llx isize 0x%llx disize 0x%llx pos 0x%llx",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
> 

-- 
Carlos

