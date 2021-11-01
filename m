Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13C04C433FE
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Nov 2021 16:28:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFF9D610D2
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Nov 2021 16:28:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232627AbhKAQbQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Nov 2021 12:31:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:46304 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232588AbhKAQbQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Nov 2021 12:31:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635784122;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vSSeiEsgy4ZRAwPPYMh123Zf4LHs8XHr2NNVii6Qq7o=;
        b=AvCPbg1FTPfLMjWc7ypl3iG98diUCbhNwGIK33qkzkphpEsehtLzuq/IYpiYpQgrCy2L7+
        c3v1KDixloqG3Ng3ccyy3cjQGIe8vA5LCddSAnMrItTSCPBgIsoibsijzZcddq7PkRalMS
        2V2TvGAHoAUFgWvumnraXAfhel7N1zI=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-35-tEquYEKgPfWzmivl0q9_sg-1; Mon, 01 Nov 2021 12:28:41 -0400
X-MC-Unique: tEquYEKgPfWzmivl0q9_sg-1
Received: by mail-qk1-f198.google.com with SMTP id g1-20020a05620a108100b00462bc91f9ffso10187631qkk.12
        for <linux-xfs@vger.kernel.org>; Mon, 01 Nov 2021 09:28:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vSSeiEsgy4ZRAwPPYMh123Zf4LHs8XHr2NNVii6Qq7o=;
        b=6fJPGS052PzhEwdp42BCc+EIFQnhd89jEg3KRbOwL8BbnJPIXOCAagQKj/Ach8/UpV
         ucua8KcGULi/2emfEy2jPQicMkxWdSrZukksXZslUmj30liGKizhpILcA4ym6hrrKOSI
         PLxT+qgVmatUqUi9w96EfQSQiiHdXcEE/Sgupn6GG4fsjNIAQ/+y7a1T8CZ6bog5eok9
         WOO9RoLB94ViyGG+H/wIYk4UL2EdqiFBeuR0FDqLxIy+Qzu9egKTRX5ux5MzVaUPBMCA
         jukvafTQdGyUDF6zXBNDzh2bzEgo/zXdqEYHBBQIVoWCbtGFxyQ3iDHthFhcfH6lnW3j
         JCXg==
X-Gm-Message-State: AOAM531MfFWgLgsKGL+ECT3Gj8H5R6KKWIQjSg5kDVbVhD1d+f+G6Qkl
        CEn3NQ6QRr36MhQ0wzz9IJ4ZNzPENC0DZXFY7OG0TNLK0Sz9UyuLlzkzxT5zxNFvG7QxM8HPdip
        VHpzrL7B7K9HggkdyY7M=
X-Received: by 2002:a05:6214:e4a:: with SMTP id o10mr29863858qvc.58.1635784120279;
        Mon, 01 Nov 2021 09:28:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwnnToYfIdlwewHO/8stJwOwIrIwZDJizj1Vl7BOinzg8bNzbcfCyJ9R9K4APUV9a9jX59VOw==
X-Received: by 2002:a05:6214:e4a:: with SMTP id o10mr29863844qvc.58.1635784120140;
        Mon, 01 Nov 2021 09:28:40 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net. [68.160.176.52])
        by smtp.gmail.com with ESMTPSA id u185sm10250817qkd.48.2021.11.01.09.28.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 09:28:39 -0700 (PDT)
Date:   Mon, 1 Nov 2021 12:28:38 -0400
From:   Mike Snitzer <snitzer@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        Ira Weiny <ira.weiny@intel.com>, dm-devel@redhat.com,
        linux-xfs@vger.kernel.org, nvdimm@lists.linux.dev,
        linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 03/11] dax: simplify the dax_device <-> gendisk
 association
Message-ID: <YYAVtv6kiqVHDjQH@redhat.com>
References: <20211018044054.1779424-1-hch@lst.de>
 <20211018044054.1779424-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211018044054.1779424-4-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 18 2021 at 12:40P -0400,
Christoph Hellwig <hch@lst.de> wrote:

> Replace the dax_host_hash with an xarray indexed by the pointer value
> of the gendisk, and require explicitl calls from the block drivers that
> want to associate their gendisk with a dax_device.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

...

> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 79737aee516b1..a0a4703620650 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1683,6 +1683,7 @@ static void cleanup_mapped_device(struct mapped_device *md)
>  	bioset_exit(&md->io_bs);
>  
>  	if (md->dax_dev) {
> +		dax_remove_host(md->disk);
>  		kill_dax(md->dax_dev);
>  		put_dax(md->dax_dev);
>  		md->dax_dev = NULL;
> @@ -1784,10 +1785,11 @@ static struct mapped_device *alloc_dev(int minor)
>  	sprintf(md->disk->disk_name, "dm-%d", minor);
>  
>  	if (IS_ENABLED(CONFIG_FS_DAX)) {
> -		md->dax_dev = alloc_dax(md, md->disk->disk_name,
> -					&dm_dax_ops, 0);
> +		md->dax_dev = alloc_dax(md, &dm_dax_ops, 0);
>  		if (IS_ERR(md->dax_dev))
>  			goto bad;
> +		if (dax_add_host(md->dax_dev, md->disk))
> +			goto bad;
>  	}
>  
>  	format_dev_t(md->name, MKDEV(_major, minor));

Acked-by: Mike Snitzer <snitzer@redhat.com>

