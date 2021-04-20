Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4222C433ED
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Apr 2021 22:15:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7154B61400
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Apr 2021 22:15:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233964AbhDTWQZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Apr 2021 18:16:25 -0400
Received: from gateway32.websitewelcome.com ([192.185.145.178]:11647 "EHLO
        gateway32.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234188AbhDTWQY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Apr 2021 18:16:24 -0400
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway32.websitewelcome.com (Postfix) with ESMTP id E60F4D5B5
        for <linux-xfs@vger.kernel.org>; Tue, 20 Apr 2021 17:15:51 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id YyetljszWb8LyYyetlldlm; Tue, 20 Apr 2021 17:15:51 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=5XXS4Lng4Hi2wx0XQvrpPcvwnFbInQsBCfVyWXKUeQE=; b=ietFcTROfyJ95Q/XZa1RUtzHh6
        HOnuhjIFUmkgbFDPtA61nCuo4xd4gYsdlqTOZNSXfJhjSYsg/uBT981wLAz59vAucwsFcDHYDTx4F
        1boTWzrFzNOmfmlLVrG6TDnk9C1LeEPyQtDQrnyB6aTfL/ZQvnLxhQeIuC36s/6pBOu5Vpt5X7YNw
        n3h5i4ZsUSEVh7ONFd0WgIOMiA8AwB7zyHJDxt8U+vbPILDVM1VRYtzxB/J58OqDNJ2G419M+pDtE
        WgWp/gj6A3jNmldwJ9Gh0DZXwqAv/qhUiQJDOkuYwzwk51cmsgXG76N+zQy5VuNpzAnI4d3k14wPt
        KPjM5zxg==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:50524 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <gustavo@embeddedor.com>)
        id 1lYyes-001idx-Ko; Tue, 20 Apr 2021 17:15:50 -0500
Subject: Re: [PATCH 7/7] xfs: Replace one-element arrays with flexible-array
 members
To:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Cc:     "Gustavo A . R . Silva" <gustavoars@kernel.org>
References: <20210419082804.2076124-1-hch@lst.de>
 <20210419082804.2076124-8-hch@lst.de>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <6a806a6d-e64f-c0f9-17f3-10402197d6c8@embeddedor.com>
Date:   Tue, 20 Apr 2021 17:16:08 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210419082804.2076124-8-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.162.31.110
X-Source-L: No
X-Exim-ID: 1lYyes-001idx-Ko
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:50524
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 2
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/19/21 03:28, Christoph Hellwig wrote:
> From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
> 
> There is a regular need in the kernel to provide a way to declare having
> a dynamically sized set of trailing elements in a structure. Kernel code
> should always use “flexible array members”[1] for these cases. The older
> style of one-element or zero-length arrays should no longer be used[2].
> 
> Refactor the code according to the use of flexible-array members in
> multiple structures, instead of one-element arrays. Also, make use of
> the new struct_size() helper to properly calculate the size of some
> structures that contain flexible-array members.
> 
> [1] https://en.wikipedia.org/wiki/Flexible_array_member
> [2] https://www.kernel.org/doc/html/v5.9/process/deprecated.html#zero-length-and-one-element-arrays
> 
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> [hch: rebased on top of the previous cleanups]
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Thanks, Christoph.
--
Gustavo

> ---
>  fs/xfs/libxfs/xfs_log_format.h | 6 +++---
>  fs/xfs/xfs_extfree_item.c      | 9 +++------
>  fs/xfs/xfs_extfree_item.h      | 4 ++--
>  fs/xfs/xfs_ondisk.h            | 6 +++---
>  4 files changed, 11 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> index 639035052b4f65..9b218c30659ad7 100644
> --- a/fs/xfs/libxfs/xfs_log_format.h
> +++ b/fs/xfs/libxfs/xfs_log_format.h
> @@ -559,7 +559,7 @@ struct xfs_efi_log_format {
>  	uint16_t		efi_size;	/* size of this item */
>  	uint32_t		efi_nextents;	/* # extents to free */
>  	uint64_t		efi_id;		/* efi identifier */
> -	struct xfs_extent	efi_extents[1];	/* array of extents to free */
> +	struct xfs_extent	efi_extents[];	/* array of extents to free */
>  };
>  
>  /*
> @@ -577,7 +577,7 @@ struct xfs_efi_log_format_32 {
>  	uint16_t		efi_size;	/* size of this item */
>  	uint32_t		efi_nextents;	/* # extents to free */
>  	uint64_t		efi_id;		/* efi identifier */
> -	struct xfs_extent_32	efi_extents[1];	/* array of extents to free */
> +	struct xfs_extent_32	efi_extents[];	/* array of extents to free */
>  } __attribute__((packed));
>  
>  /*
> @@ -590,7 +590,7 @@ struct xfs_efd_log_format {
>  	uint16_t		efd_size;	/* size of this item */
>  	uint32_t		efd_nextents;	/* # of extents freed */
>  	uint64_t		efd_efi_id;	/* id of corresponding efi */
> -	struct xfs_extent	efd_extents[1];	/* array of extents freed */
> +	struct xfs_extent	efd_extents[];	/* array of extents freed */
>  };
>  
>  /*
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index a2abdfd3d076bf..8bea9c9ecf2042 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -73,8 +73,7 @@ static inline int
>  xfs_efi_log_item_sizeof(
>  	struct xfs_efi_log_format *elf)
>  {
> -	return sizeof(*elf) +
> -	       (elf->efi_nextents - 1) * sizeof(struct xfs_extent);
> +	return struct_size(elf, efi_extents, elf->efi_nextents);
>  }
>  
>  STATIC void
> @@ -194,8 +193,7 @@ static inline int
>  xfs_efd_log_item_sizeof(
>  	struct xfs_efd_log_format *elf)
>  {
> -	return sizeof(struct xfs_efd_log_format) +
> -	       (elf->efd_nextents - 1) * sizeof(struct xfs_extent);
> +	return struct_size(elf, efd_extents, elf->efd_nextents);
>  }
>  
>  STATIC void
> @@ -636,8 +634,7 @@ xfs_efi_copy_format_32(
>  	struct xfs_efi_log_format_32	*src = buf->i_addr;
>  	unsigned int			i;
>  
> -	if (buf->i_len != sizeof(*src) +
> -	    (src->efi_nextents - 1) * sizeof(struct xfs_extent_32)) {
> +	if (buf->i_len != struct_size(src, efi_extents, src->efi_nextents)) {
>  		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
>  		return -EFSCORRUPTED;
>  	}
> diff --git a/fs/xfs/xfs_extfree_item.h b/fs/xfs/xfs_extfree_item.h
> index 3bb62ef525f2e0..a01ce86145bb64 100644
> --- a/fs/xfs/xfs_extfree_item.h
> +++ b/fs/xfs/xfs_extfree_item.h
> @@ -55,7 +55,7 @@ struct xfs_efi_log_item {
>  static inline int xfs_efi_item_sizeof(unsigned int nextents)
>  {
>  	return sizeof(struct xfs_efi_log_item) +
> -		(nextents - 1) * sizeof(struct xfs_extent);
> +		nextents * sizeof(struct xfs_extent);
>  }
>  
>  /*
> @@ -73,7 +73,7 @@ struct xfs_efd_log_item {
>  static inline int xfs_efd_item_sizeof(unsigned int nextents)
>  {
>  	return sizeof(struct xfs_efd_log_item) +
> -		(nextents - 1) * sizeof(struct xfs_extent);
> +		nextents * sizeof(struct xfs_extent);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
> index 739476f7dffa21..fa4b590671bf58 100644
> --- a/fs/xfs/xfs_ondisk.h
> +++ b/fs/xfs/xfs_ondisk.h
> @@ -118,9 +118,9 @@ xfs_check_ondisk_structs(void)
>  	/* log structures */
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_buf_log_format,	88);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_dq_logformat,		24);
> -	XFS_CHECK_STRUCT_SIZE(struct xfs_efd_log_format,	32);
> -	XFS_CHECK_STRUCT_SIZE(struct xfs_efi_log_format,	32);
> -	XFS_CHECK_STRUCT_SIZE(struct xfs_efi_log_format_32,	28);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_efd_log_format,	16);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_efi_log_format,	16);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_efi_log_format_32,	16);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_extent,		16);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_extent_32,		12);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_log_dinode,		176);
> 
