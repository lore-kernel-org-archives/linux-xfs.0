Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0346CEB64DA
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Jul 2023 17:18:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbjGLRSq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Jul 2023 13:18:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbjGLRSo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jul 2023 13:18:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C9831BD
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 10:18:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9DDF061874
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 17:18:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDF41C433C8;
        Wed, 12 Jul 2023 17:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689182323;
        bh=KXMQmtXuJS0wvD5YZf9gMVYvhykxJtIkqgX9CheBvUs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YJY46207HxR/9rGj6SRomB7Nyu6o4g2bXRqqlAd3TQ+UN/ofwopTbpiN5nRy+K3Ta
         AKszp6qL4/85zwf4OTjhxpjeIVLAD5AYEtJOjxudf1fweoIV5eIpNWR4NQbK2W1LFb
         b4BPJiMurJkjrz8qNylMWVn3aSQaFbzGg6HUNoIdQWg3vk7kJyHKSLFVjHU5jM15pQ
         SjfTbXRafXSA6DTDp5Fv2jG2QewIPu3e0tv2VXlnqBSRFm6tv0UYC6caEsLC7iX/ru
         N8Gdxd5gkNNAoLhJ5nLSE2/+jqmQzBh7aXrRCn+tlVfc30JJqSIkP93VJTwqC/CMxa
         /KKb7tGAvbMSA==
Date:   Wed, 12 Jul 2023 10:18:42 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH V2 10/23] metadump: Define metadump v2 ondisk format
 structures and macros
Message-ID: <20230712171842.GI108251@frogsfrogsfrogs>
References: <20230606092806.1604491-1-chandan.babu@oracle.com>
 <20230606092806.1604491-11-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230606092806.1604491-11-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 06, 2023 at 02:57:53PM +0530, Chandan Babu R wrote:
> The corresponding metadump file's disk layout is as shown below,
> 
>      |------------------------------|
>      | struct xfs_metadump_header   |
>      |------------------------------|
>      | struct xfs_meta_extent 0     |
>      | Extent 0's data              |
>      | struct xfs_meta_extent 1     |
>      | Extent 1's data              |
>      | ...                          |
>      | struct xfs_meta_extent (n-1) |
>      | Extent (n-1)'s data          |
>      |------------------------------|
> 
> The "struct xfs_metadump_header" is followed by alternating series of "struct
> xfs_meta_extent" and the extent itself.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
>  include/xfs_metadump.h | 58 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 58 insertions(+)
> 
> diff --git a/include/xfs_metadump.h b/include/xfs_metadump.h
> index a4dca25c..518cb302 100644
> --- a/include/xfs_metadump.h
> +++ b/include/xfs_metadump.h
> @@ -8,7 +8,9 @@
>  #define _XFS_METADUMP_H_
>  
>  #define	XFS_MD_MAGIC_V1		0x5846534d	/* 'XFSM' */
> +#define	XFS_MD_MAGIC_V2		0x584D4432	/* 'XMD2' */
>  
> +/* Metadump v1 */
>  typedef struct xfs_metablock {
>  	__be32		mb_magic;
>  	__be16		mb_count;
> @@ -23,4 +25,60 @@ typedef struct xfs_metablock {
>  #define XFS_METADUMP_FULLBLOCKS	(1 << 2)
>  #define XFS_METADUMP_DIRTYLOG	(1 << 3)
>  
> +/*
> + * Metadump v2
> + *
> + * The following diagram depicts the ondisk layout of the metadump v2 format.
> + *
> + * |------------------------------|
> + * | struct xfs_metadump_header   |
> + * |------------------------------|
> + * | struct xfs_meta_extent 0     |
> + * | Extent 0's data              |
> + * | struct xfs_meta_extent 1     |
> + * | Extent 1's data              |
> + * | ...                          |
> + * | struct xfs_meta_extent (n-1) |
> + * | Extent (n-1)'s data          |
> + * |------------------------------|
> + *
> + * The "struct xfs_metadump_header" is followed by alternating series of "struct
> + * xfs_meta_extent" and the extent itself.
> + */
> +struct xfs_metadump_header {
> +	__be32		xmh_magic;
> +	__be32		xmh_version;
> +	__be32		xmh_compat_flags;
> +	__be32		xmh_incompat_flags;
> +	__be64		xmh_reserved;
> +} __packed;
> +
> +#define XFS_MD2_INCOMPAT_OBFUSCATED	(1 << 0)
> +#define XFS_MD2_INCOMPAT_FULLBLOCKS	(1 << 1)
> +#define XFS_MD2_INCOMPAT_DIRTYLOG	(1 << 2)
> +#define XFS_MD2_INCOMPAT_EXTERNALLOG	(1 << 3)

Please document the meaning of these four flags.

/*
 * User-supplied directory entry and extended attribute names have been
 * obscured, and extended attribute values are zeroed to protect privacy.
 */
#define XFS_MD2_INCOMPAT_OBFUSCATED	(1 << 0)

/* Full blocks have been dumped. */
#define XFS_MD2_INCOMPAT_FULLBLOCKS	(1 << 1)

/* Log was dirty. */
#define XFS_MD2_INCOMPAT_DIRTYLOG	(1 << 2)

/* Dump contains external log contents. */
#define XFS_MD2_INCOMPAT_EXTERNALLOG	(1 << 3)

Otherwise looks fine to me.

--D

> +
> +struct xfs_meta_extent {
> +	/*
> +	 * Lowest 54 bits are used to store 512 byte addresses.
> +	 * Next 2 bits is used for indicating the device.
> +	 * 00 - Data device
> +	 * 01 - External log
> +	 */
> +	__be64 xme_addr;
> +	/* In units of 512 byte blocks */
> +	__be32 xme_len;
> +} __packed;
> +
> +#define XME_ADDR_DEVICE_SHIFT	54
> +
> +#define XME_ADDR_DADDR_MASK	((1ULL << XME_ADDR_DEVICE_SHIFT) - 1)
> +
> +/* Extent was copied from the data device */
> +#define XME_ADDR_DATA_DEVICE	(0ULL << XME_ADDR_DEVICE_SHIFT)
> +/* Extent was copied from the log device */
> +#define XME_ADDR_LOG_DEVICE	(1ULL << XME_ADDR_DEVICE_SHIFT)
> +
> +#define XME_ADDR_DEVICE_MASK	(3ULL << XME_ADDR_DEVICE_SHIFT)
> +
>  #endif /* _XFS_METADUMP_H_ */
> -- 
> 2.39.1
> 
