Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A344C4332F
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Nov 2023 16:28:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbjKHQ2Z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Nov 2023 11:28:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjKHQ2Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Nov 2023 11:28:25 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49A85131
        for <linux-xfs@vger.kernel.org>; Wed,  8 Nov 2023 08:28:23 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB3B4C433C8;
        Wed,  8 Nov 2023 16:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699460903;
        bh=mOR0OcNYT7fbVfTG8TEU4wv032hgT9JQzApVJ6c5ye4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Xtq+jkluV963+S+YERgxyJOlQQoHyOykhv3z6sldZ1eRyOvw3aVeqs1SulA4DDvvD
         FoS/8X//j+uz32A96fys0W6tLFmmQr/yrGc3U6wjR2rRLIzu9zWc9WDAitjfmcs/CY
         9Xgtclu/c2pKsQ3N6QPx6pmVUkFX5SRJwz2MRMN1TLdL0d4sbLpPZM4oNvQC2YTGKO
         Aj6KjmP1RgALXivROhukGIPkPAcuymhyQAcOamooNUKcdZmxMnhOILzW0Fp+TQcwCh
         7WD4WnOZRYtL35MeXPtiNHmClRjIMD0GvWm9fnicq/6CJURMTTRkVx8B+y0f+A/zsR
         V4ihho7NuIajw==
Date:   Wed, 8 Nov 2023 08:28:22 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH V2 2/2] metadump.asciidoc: Add description for metadump
 v2 ondisk format
Message-ID: <20231108162822.GV1205143@frogsfrogsfrogs>
References: <20231108083228.1278837-1-chandan.babu@oracle.com>
 <20231108083228.1278837-3-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231108083228.1278837-3-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 08, 2023 at 02:02:28PM +0530, Chandan Babu R wrote:
> Metadump v2 is the new metadata dump format introduced in upstream
> xfsprogs. This commit describes V2 format's ondisk structure.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>

This is consistent with the C structures in the metadump2 patchset, so
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

(But I'll wait until cem merges that patchset before taking this.)

((Assuming I'm still xfs-docs maintainer :P))

(((Ok I declare I still am)))

--D

> ---
>  .../metadump.asciidoc                         | 75 ++++++++++++++++++-
>  1 file changed, 74 insertions(+), 1 deletion(-)
> 
> diff --git a/design/XFS_Filesystem_Structure/metadump.asciidoc b/design/XFS_Filesystem_Structure/metadump.asciidoc
> index 2f35b7e..7ce993c 100644
> --- a/design/XFS_Filesystem_Structure/metadump.asciidoc
> +++ b/design/XFS_Filesystem_Structure/metadump.asciidoc
> @@ -13,7 +13,11 @@ must be the superblock from AG 0.  If the metadump has more blocks than
>  can be pointed to by the +xfs_metablock.mb_daddr+ area, the sequence
>  of +xfs_metablock+ followed by metadata blocks is repeated.
>  
> -.Metadata Dump Format
> +Two metadump file formats are supported: +V1+ and +V2+. In addition to
> +the features supported by the +V1+ format, the +V2+ format supports
> +capturing data from an external log device.
> +
> +== Metadata Dump v1 Format
>  
>  [source, c]
>  ----
> @@ -62,6 +66,75 @@ An array of disk addresses.  Each of the +mb_count+ blocks (of size +(1
>  << mb_blocklog+) following the +xfs_metablock+ should be written back to
>  the address pointed to by the corresponding +mb_daddr+ entry.
>  
> +== Metadata Dump v2 Format
> +
> +A Metadump Dump in the V2 format begins with a header represented by
> ++struct xfs_metadump_header+.
> +[source, c]
> +----
> +struct xfs_metadump_header {
> +        __be32          xmh_magic;
> +        __be32          xmh_version;
> +        __be32          xmh_compat_flags;
> +        __be32          xmh_incompat_flags;
> +        __be64          xmh_reserved;
> +} __packed;
> +----
> +*xmh_magic*::
> +The magic number, ``XMD2'' (0x584D4432)
> +
> +*xmh_version*::
> +The version number, i.e. 2.
> +
> +*xmh_compat flags*::
> +Compat flags describing a metadata dump.
> +
> +[options="header"]
> +|=====
> +| Flag				| Description
> +| +XFS_MD2_COMPAT_OBFUSCATED+ |
> +Directory entry and extended attribute names have been obscured and
> +extended attribute values are zeroed to protect privacy.
> +
> +| +XFS_MD2_COMPAT_FULLBLOCKS+ |
> +Full metadata blocks have been dumped.  Without this flag, unused areas
> +of metadata blocks are zeroed.
> +
> +| +XFS_MD2_COMPAT_DIRTYLOG+ |
> +Log was dirty.
> +
> +| +XFS_MD2_COMPAT_EXTERNALLOG+ |
> +Metadata dump contains contents from an external log.
> +|=====
> +
> +*xmh_incompat_flags*::
> +Incompat flags describing a metadata dump. At present, this field must
> +be set to zero.
> +
> +*xmh_reserved*::
> +Reserved. Should be zero.
> +
> +The header is followed by an alternating sequence of +struct
> +xfs_meta_extent+ and the contents from the corresponding variable
> +length extent.
> +
> +[source, c]
> +----
> +struct xfs_meta_extent {
> +        __be64 xme_addr;
> +        __be32 xme_len;
> +} __packed;
> +----
> +*xme_addr*::
> +
> +The lower 54 bits are used to store the disk address of a metadata dump
> +extent.  The next 2 bits are used for indicating the device.
> +. 00 - Data device
> +. 01 - External log
> +
> +*xme_len*::
> +Length of the metadata dump extent in units of 512 byte blocks.
> +
>  == Dump Obfuscation
>  
>  Unless explicitly disabled, the +xfs_metadump+ tool obfuscates empty block
> -- 
> 2.39.1
> 
