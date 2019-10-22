Return-Path: <SRS0=PA6D=YP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C96CACA9EA0
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 11:32:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C7BF218AE
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 11:32:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=plexistor-com.20150623.gappssmtp.com header.i=@plexistor-com.20150623.gappssmtp.com header.b="nshfuIVH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731928AbfJVLcJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Oct 2019 07:32:09 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:44905 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730515AbfJVLcI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Oct 2019 07:32:08 -0400
Received: by mail-ed1-f68.google.com with SMTP id r16so12569689edq.11
        for <linux-xfs@vger.kernel.org>; Tue, 22 Oct 2019 04:32:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=plexistor-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IXdjAlYYb0/3BF9pQMCekdzHObGq7UqdMRAHLQJHvP0=;
        b=nshfuIVHMv5W1kTsmAFRMGY2vgtWD69hiQb7EqRiIky+siiGzKA8rT9H/CfogSpRWH
         ZzKKpiJII+11E/4bokPxJF9UeJdJJFXxET0FxY7Fny224N4pEngrgxbgQWpkSB/j7Pbn
         yhlbR9Y6w0Wujfqk41ZsLKXwAKZ5+/c46nnZSXt9j0X4GaelObZTCP/32nzyoA0eGKvJ
         EJrJ2D/qFHzNtezHZpQReKsjKU8Z2UcNRzQD+t2nObetnUDXlscLrsyXvG4/6VXG33QW
         RkNeTXbG4vW3EOIhy/oixEhvw+WDoPM5OFP1aGoYuZk451UWI2GmpxEwbsd+n8WpfONN
         5FnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IXdjAlYYb0/3BF9pQMCekdzHObGq7UqdMRAHLQJHvP0=;
        b=hhU4l+MEIjWm4ywL/o3IT94vU4bb/bLUAA63DXLgHDmh/bOQcMlS2C8o0W6Ugkc18k
         oMYGzBrbkVJE1Hz+CdGGzIvx1eJSRdKrlTqMQxw1RfK4H769Zf8PMksXapDXDKUnE5T8
         FEDF/CH/IXHjlShPmoLYcq001/e/RRn7XPjMx4VjLX357pxqYKGOXLWFDRDIg18ihuAi
         bjgbgd/3u/v9EfJQZNcwiE4clGnUulU0YT6vZYwarHkLQhM8qRw0p4vYagGYLem3gnNm
         ullz6Vkx2XzAoC4PDRHCSh83veXl/8gEmJ/dNg8kqAF2OMJxD81YzuJ7fzk9npuu2u4Y
         Gn/w==
X-Gm-Message-State: APjAAAVERc2X/5ZPmyd8qCWwOERIH5kCXQBVosMIvhQsPeBN4nF8iajs
        8yz158hk2SW+abMlNIaLy1ygOQ==
X-Google-Smtp-Source: APXvYqxQ+E/WTqukoI30ERPrEHKNbOYeg/geWj0e2Fz5zYm6mmeaHbKU07xRP3K0z7lNB1LlNNnNCw==
X-Received: by 2002:aa7:c595:: with SMTP id g21mr30006580edq.79.1571743927007;
        Tue, 22 Oct 2019 04:32:07 -0700 (PDT)
Received: from [10.68.217.182] ([217.70.210.43])
        by smtp.googlemail.com with ESMTPSA id g17sm97740ejx.75.2019.10.22.04.32.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Oct 2019 04:32:06 -0700 (PDT)
Subject: Re: [PATCH 1/5] fs/stat: Define DAX statx attribute
To:     ira.weiny@intel.com, linux-kernel@vger.kernel.org
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        "Theodore Y. Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
References: <20191020155935.12297-1-ira.weiny@intel.com>
 <20191020155935.12297-2-ira.weiny@intel.com>
From:   Boaz Harrosh <boaz@plexistor.com>
Message-ID: <119b57ed-2799-c499-00df-50da80d23612@plexistor.com>
Date:   Tue, 22 Oct 2019 14:32:04 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <20191020155935.12297-2-ira.weiny@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 20/10/2019 18:59, ira.weiny@intel.com wrote:
> From: Ira Weiny <ira.weiny@intel.com>
> 
> In order for users to determine if a file is currently operating in DAX
> mode (effective DAX).  Define a statx attribute value and set that
> attribute if the effective DAX flag is set.
> 
> To go along with this we propose the following addition to the statx man
> page:
> 
> STATX_ATTR_DAX
> 
> 	DAX (cpu direct access) is a file mode that attempts to minimize
> 	software cache effects for both I/O and memory mappings of this
> 	file.  It requires a capable device, a compatible filesystem
> 	block size, and filesystem opt-in. It generally assumes all
> 	accesses are via cpu load / store instructions which can
> 	minimize overhead for small accesses, but adversely affect cpu
> 	utilization for large transfers. File I/O is done directly
> 	to/from user-space buffers. While the DAX property tends to
> 	result in data being transferred synchronously it does not give
> 	the guarantees of synchronous I/O that data and necessary
> 	metadata are transferred. Memory mapped I/O may be performed
> 	with direct mappings that bypass system memory buffering. Again
> 	while memory-mapped I/O tends to result in data being
> 	transferred synchronously it does not guarantee synchronous
> 	metadata updates. A dax file may optionally support being mapped
> 	with the MAP_SYNC flag which does allow cpu store operations to
> 	be considered synchronous modulo cpu cache effects.
> 
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> ---
>  fs/stat.c                 | 3 +++
>  include/uapi/linux/stat.h | 1 +
>  2 files changed, 4 insertions(+)
> 
> diff --git a/fs/stat.c b/fs/stat.c
> index c38e4c2e1221..59ca360c1ffb 100644
> --- a/fs/stat.c
> +++ b/fs/stat.c
> @@ -77,6 +77,9 @@ int vfs_getattr_nosec(const struct path *path, struct kstat *stat,
>  	if (IS_AUTOMOUNT(inode))
>  		stat->attributes |= STATX_ATTR_AUTOMOUNT;
>  
> +	if (inode->i_flags & S_DAX)

Is there a reason not to use IS_DAX(inode) ?

> +		stat->attributes |= STATX_ATTR_DAX;
> +
>  	if (inode->i_op->getattr)
>  		return inode->i_op->getattr(path, stat, request_mask,
>  					    query_flags);
> diff --git a/include/uapi/linux/stat.h b/include/uapi/linux/stat.h
> index 7b35e98d3c58..5b0962121ef7 100644
> --- a/include/uapi/linux/stat.h
> +++ b/include/uapi/linux/stat.h
> @@ -169,6 +169,7 @@ struct statx {
>  #define STATX_ATTR_ENCRYPTED		0x00000800 /* [I] File requires key to decrypt in fs */
>  
>  #define STATX_ATTR_AUTOMOUNT		0x00001000 /* Dir: Automount trigger */
> +#define STATX_ATTR_DAX			0x00002000 /* [I] File is DAX */
>  
>  
>  #endif /* _UAPI_LINUX_STAT_H */
> 

