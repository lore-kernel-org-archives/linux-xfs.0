Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A591EB64DD
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Aug 2023 23:48:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbjHAXr7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Aug 2023 19:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230212AbjHAXr4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Aug 2023 19:47:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 294ED1B1
        for <linux-xfs@vger.kernel.org>; Tue,  1 Aug 2023 16:47:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A19EF6176D
        for <linux-xfs@vger.kernel.org>; Tue,  1 Aug 2023 23:47:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02C1BC433C7;
        Tue,  1 Aug 2023 23:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690933674;
        bh=AAhZFGI7dPLKuj5buxLK4hIjd4hw4LnOu5k/jAMH8wQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=az9cZ7anrpjFTE9n4nPlGCINy/t1B34c5LnndmJOxGHk+bVU34QGv9d5NtMwEP86T
         Xwvwsou7CY7b0RCCnUd2JYEsmSe5dgABBfzrWHFKECas7/QM5Lsi9H3E3ize7DmhIR
         v5s6m8sZ59bSJ7wGVWVnhgAcHB+UYLyEYcd5V9bWoZPVwkrUnUd24e857P1NS2ejcL
         HaJZNNuh7WmcXFmhrp+lAlEIIKLOz/n9fw2dNuzz3MIbc54KKNheIgtnOEuSj+sVc0
         qso5RbvUOa8/Qk2yq3rXCQdCFJ7B/LqxbUMVg8x1PaOPPVhK4QcLdC5lTm8mM5Y7ay
         oO1pP6kG18w2g==
Date:   Tue, 1 Aug 2023 16:47:53 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH V3 10/23] metadump: Define metadump v2 ondisk format
 structures and macros
Message-ID: <20230801234753.GR11352@frogsfrogsfrogs>
References: <20230724043527.238600-1-chandan.babu@oracle.com>
 <20230724043527.238600-11-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230724043527.238600-11-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 24, 2023 at 10:05:14AM +0530, Chandan Babu R wrote:
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

Looks good,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Could you please post a patch describing the metadump2 file format for
https://git.kernel.org/pub/scm/fs/xfs/xfs-documentation.git/ ?

(Sorry I posted an earlier reply to the truncated submission.)

--D

> ---
>  include/xfs_metadump.h | 68 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 68 insertions(+)
> 
> diff --git a/include/xfs_metadump.h b/include/xfs_metadump.h
> index a4dca25c..50175ef0 100644
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
> @@ -23,4 +25,70 @@ typedef struct xfs_metablock {
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
> +/*
> + * User-supplied directory entry and extended attribute names have been
> + * obscured, and extended attribute values are zeroed to protect privacy.
> + */
> +#define XFS_MD2_INCOMPAT_OBFUSCATED (1 << 0)
> +
> +/* Full blocks have been dumped. */
> +#define XFS_MD2_INCOMPAT_FULLBLOCKS	(1 << 1)
> +
> +/* Log was dirty. */
> +#define XFS_MD2_INCOMPAT_DIRTYLOG (1 << 2)
> +
> +/* Dump contains external log contents. */
> +#define XFS_MD2_INCOMPAT_EXTERNALLOG	(1 << 3)
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
