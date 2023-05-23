Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3804DC7EE26
	for <linux-xfs@archiver.kernel.org>; Tue, 23 May 2023 17:35:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237742AbjEWRfa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 May 2023 13:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237777AbjEWRf3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 May 2023 13:35:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3811E79
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 10:35:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9D436243B
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 17:34:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FF9CC433D2;
        Tue, 23 May 2023 17:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684863276;
        bh=HEpZCXLxN+o9JMjWzyXfVSavEEOs976MMb8iKqTMef4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vMB8khMpybv6/nIr6jP4oeHSu/YG2SBjxu4RZY2XQj8y5PRS+wDTM2qQZh5KSP7T0
         +Q4GJNdLJytw+RN3VvZVqmvDop2HnijepE/uULHoP3PNGcjzByB9IdTY64oRIkaeri
         a04QNde1C+QiTOreyP3o7l04EHGY2h29OVyVz3MapSQD43r4ynCqqePQD/PT4Xw6MY
         JezEPfj7TFH4Qy1rKLTSDGN75hANSoQdKa6NNi15iNXVToDHm5Xua+kbMahEnFpooB
         XNHUCZj/0LerS+iNwXKi1UpiZW3gVX/FzpHPKJ5fNRnj5mOW+hkYLdC5xYMNf7kWCm
         KAx6ADEWnB2Aw==
Date:   Tue, 23 May 2023 10:34:35 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/24] metadump: Define metadump v2 ondisk format
 structures and macros
Message-ID: <20230523173435.GR11620@frogsfrogsfrogs>
References: <20230523090050.373545-1-chandan.babu@oracle.com>
 <20230523090050.373545-12-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230523090050.373545-12-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 23, 2023 at 02:30:37PM +0530, Chandan Babu R wrote:
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
>  include/xfs_metadump.h | 32 ++++++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
> 
> diff --git a/include/xfs_metadump.h b/include/xfs_metadump.h
> index a4dca25cb..1d8d7008c 100644
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
> @@ -23,4 +25,34 @@ typedef struct xfs_metablock {
>  #define XFS_METADUMP_FULLBLOCKS	(1 << 2)
>  #define XFS_METADUMP_DIRTYLOG	(1 << 3)
>  
> +/* Metadump v2 */
> +struct xfs_metadump_header {
> +	__be32 xmh_magic;
> +	__be32 xmh_version;
> +	__be32 xmh_compat_flags;
> +	__be32 xmh_incompat_flags;
> +	__be64 xmh_reserved;

__be32 xmh_crc; ?

Otherwise there's nothing to check for bitflips in the index blocks
themselves.

> +} __packed;

Does an array of xfs_meta_extent come immediately after
xfs_metadump_header, or do they go in a separate block after the header?
How big is the index block supposed to be?

> +
> +#define XFS_MD2_INCOMPAT_OBFUSCATED	(1 << 0)
> +#define XFS_MD2_INCOMPAT_FULLBLOCKS	(1 << 1)
> +#define XFS_MD2_INCOMPAT_DIRTYLOG	(1 << 2)

Should the header declare when some of the xfs_meta_extents will have
XME_ADDR_LOG_DEVICE set?

> +
> +struct xfs_meta_extent {
> +        /*

Tabs not spaces.

> +	 * Lowest 54 bits are used to store 512 byte addresses.
> +	 * Next 2 bits is used for indicating the device.
> +	 * 00 - Data device
> +	 * 01 - External log

So if you were to (say) add the realtime device, would that be bit 56,
or would you define 0xC0000000000000 (aka DATA|LOG) to mean realtime?

> +	 */
> +        __be64 xme_addr;
> +        /* In units of 512 byte blocks */
> +        __be32 xme_len;
> +} __packed;
> +
> +#define XME_ADDR_DATA_DEVICE	(1UL << 54)
> +#define XME_ADDR_LOG_DEVICE	(1UL << 55)

1ULL, because "UL" means unsigned long, which is 32-bits on i386.

--D

> +
> +#define XME_ADDR_DEVICE_MASK (~(XME_ADDR_DATA_DEVICE | XME_ADDR_LOG_DEVICE))
> +
>  #endif /* _XFS_METADUMP_H_ */
> -- 
> 2.39.1
> 
