Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33E91C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Jan 2022 18:40:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241424AbiAJSkF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Jan 2022 13:40:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52203 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238734AbiAJSkE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Jan 2022 13:40:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641840004;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hBbHkEgb5Zv75lKnnp27ovWyW8+Y8z0ex3PlSXx4ZCM=;
        b=TmV2obwCMxT0lKOJxXI08OXJxVDt8VmmDwlHs7OeGWGnZYsk2YjtLTB8AL0TXHIf0LAksN
        fzTyplHmTzAEL03X0cX2KOlRvvJjWdzEpCd/hBVVqZF6/ADUMtQUY8S1ODzuzgtXug8Yfn
        gz+xndPaa//mFXJEtZ9ppA4Kv9Bc9q4=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-112-3yu_okJOM0aG-jdl5CUz1w-1; Mon, 10 Jan 2022 13:40:03 -0500
X-MC-Unique: 3yu_okJOM0aG-jdl5CUz1w-1
Received: by mail-io1-f69.google.com with SMTP id o189-20020a6bbec6000000b00604e5f63337so383638iof.15
        for <linux-xfs@vger.kernel.org>; Mon, 10 Jan 2022 10:40:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=hBbHkEgb5Zv75lKnnp27ovWyW8+Y8z0ex3PlSXx4ZCM=;
        b=PRXBwneFEPm/i+YgwuWkMzbHWJnatYSgegVjR+24P4gc9VAdazvTEvMtxsgqW/BVwj
         qrarD2bVjOctPWHvh2PwqnkbTYH5OmF6EF38E+hN8+qRLXnH7KF6dgz8TO+5Z6d8V57O
         oqYZwNxa+l9sMJNiVCGkkBp3bKgvFQZT6cm6awn5tLnEl/U1AtTiPXVdWtrIhbPfewIO
         NlLf9OE5x7xafeQ5ycOiWtIwHRdvKVEopq3kqav/vnbrVYNHT+JP0pDIKs08WvQHrsTl
         PNMYJ/CyCOdprk1VH0At0C61mENz2aqKbzBNo5HSnG1qT1+1maDqOTAolR/1daiVVI8D
         oC8w==
X-Gm-Message-State: AOAM532YFah3JrgYyCTPAoIG+1xwbRg2NfhYvRF/MBMGvWb+SNsrLU0Y
        9Vpn8e0rTBjkhVXec5ux97tqD766r6MAF/wq4H9Q58k028ojp1UNwpfgM4ESenP4QDkjDxPMYw7
        zQAj/A+PST/nc2A/SwgUt
X-Received: by 2002:a92:c261:: with SMTP id h1mr609771ild.320.1641840001861;
        Mon, 10 Jan 2022 10:40:01 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyVr2V+XBfeZB6pYq7A2XTv/BiYFxpoi3tSJcvY6NMf7msBdWWiuHDpZH/RFYR8buoO+v5C4w==
X-Received: by 2002:a92:c261:: with SMTP id h1mr609762ild.320.1641840001526;
        Mon, 10 Jan 2022 10:40:01 -0800 (PST)
Received: from [10.2.0.2] ([74.119.146.34])
        by smtp.gmail.com with ESMTPSA id e17sm4544007iow.30.2022.01.10.10.40.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Jan 2022 10:40:01 -0800 (PST)
From:   Eric Sandeen <esandeen@redhat.com>
X-Google-Original-From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <ea019905-ebbe-9082-0399-7ea0e6be553c@redhat.com>
Date:   Mon, 10 Jan 2022 12:39:59 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH 2/2] xfs: hide the XFS_IOC_{ALLOC,FREE}SP* definitions
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
References: <20220110174827.GW656707@magnolia>
 <20220110175154.GX656707@magnolia>
In-Reply-To: <20220110175154.GX656707@magnolia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/10/22 11:51 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Now that we've made these ioctls defunct, move them from xfs_fs.h to
> xfs_ioctl.c, which effectively removes them from the publicly supported
> ioctl interfaces for XFS.

You pointed out on IRC that you need to hide the 32-bit/compat ones too,
so I'll wait for a V2 on that?  (XFS_IOC_ALLOCSP_32 & friends).

But the approach seems fine.

Thanks,
-Eric

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>   fs/xfs/libxfs/xfs_fs.h |    8 ++++----
>   fs/xfs/xfs_ioctl.c     |    9 +++++++++
>   2 files changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index c43877c8a279..49c0e583d6bb 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -781,13 +781,13 @@ struct xfs_scrub_metadata {
>    * For 'documentation' purposed more than anything else,
>    * the "cmd #" field reflects the IRIX fcntl number.
>    */
> -#define XFS_IOC_ALLOCSP		_IOW ('X', 10, struct xfs_flock64)
> -#define XFS_IOC_FREESP		_IOW ('X', 11, struct xfs_flock64)
> +/*	XFS_IOC_ALLOCSP ------- deprecated 10	 */
> +/*	XFS_IOC_FREESP -------- deprecated 11	 */
>   #define XFS_IOC_DIOINFO		_IOR ('X', 30, struct dioattr)
>   #define XFS_IOC_FSGETXATTR	FS_IOC_FSGETXATTR
>   #define XFS_IOC_FSSETXATTR	FS_IOC_FSSETXATTR
> -#define XFS_IOC_ALLOCSP64	_IOW ('X', 36, struct xfs_flock64)
> -#define XFS_IOC_FREESP64	_IOW ('X', 37, struct xfs_flock64)
> +/*	XFS_IOC_ALLOCSP64 ----- deprecated 36	 */
> +/*	XFS_IOC_FREESP64 ------ deprecated 37	 */
>   #define XFS_IOC_GETBMAP		_IOWR('X', 38, struct getbmap)
>   #define XFS_IOC_FSSETDM		_IOW ('X', 39, struct fsdmidata)
>   #define XFS_IOC_RESVSP		_IOW ('X', 40, struct xfs_flock64)
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 38b2a1e881a6..15ec3d4a1516 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1854,6 +1854,15 @@ xfs_fs_eofblocks_from_user(
>   	return 0;
>   }
>   
> +/*
> + * These long-unused ioctls were removed from the official ioctl API in 5.17,
> + * but retain these definitions so that we can log warnings about them.
> + */
> +#define XFS_IOC_ALLOCSP		_IOW ('X', 10, struct xfs_flock64)
> +#define XFS_IOC_FREESP		_IOW ('X', 11, struct xfs_flock64)
> +#define XFS_IOC_ALLOCSP64	_IOW ('X', 36, struct xfs_flock64)
> +#define XFS_IOC_FREESP64	_IOW ('X', 37, struct xfs_flock64)
> +
>   /*
>    * Note: some of the ioctl's return positive numbers as a
>    * byte count indicating success, such as readlink_by_handle.
> 

