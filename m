Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2D1BC4332F
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Nov 2023 03:40:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbjKHDkZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Nov 2023 22:40:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbjKHDkY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Nov 2023 22:40:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E611101
        for <linux-xfs@vger.kernel.org>; Tue,  7 Nov 2023 19:40:22 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1C30C433C7;
        Wed,  8 Nov 2023 03:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699414821;
        bh=rm+GYAwf+IijF6lm17TN74jxXeZbEWD7tYXCO81Ymas=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QgR4qm97Go1cxNNXcxor9hwBEHm/OFNX74fZHwcBq2z0Ju8ijBKzoYQ6lVlbgVszF
         zobe4DdkKyUOw7ncwYn2WFx5R/ZyqJeoJZ8lGXpLhirAHsdJLRaHGwneuNCcwrZsMS
         v/n/DkzrQxF3MotGezk/0JwIZcCpizv63qXEss+NuQNLF98q80xrzjUJmkX/CESlfe
         oPyASEEE7Tjhgptzof25dl9MRGXinkWdZwMg11/Yjs8Cm6c2hrZHw6okgR1i7V3tMc
         jWO97T48TOAFNKJDnwFosfVwBhaoZTlB1fUxigNK2kJ4YqOJzHSvF6tpovVDUL6Em+
         uHGlE0JW1Qovg==
Date:   Tue, 7 Nov 2023 19:40:21 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH V1 2/2] metadump.asciidoc: Add description for metadump
 v2 ondisk format
Message-ID: <20231108034021.GQ1205143@frogsfrogsfrogs>
References: <20231106132158.183376-1-chandan.babu@oracle.com>
 <20231106132158.183376-3-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231106132158.183376-3-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 06, 2023 at 06:51:58PM +0530, Chandan Babu R wrote:
> Metadump v2 is the new metadata dump format introduced in upstream
> xfsprogs. This commit describes V2 format's ondisk structure.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
>  .../metadump.asciidoc                         | 75 ++++++++++++++++++-
>  1 file changed, 74 insertions(+), 1 deletion(-)
> 
> diff --git a/design/XFS_Filesystem_Structure/metadump.asciidoc b/design/XFS_Filesystem_Structure/metadump.asciidoc
> index 2f35b7e..782f194 100644
> --- a/design/XFS_Filesystem_Structure/metadump.asciidoc
> +++ b/design/XFS_Filesystem_Structure/metadump.asciidoc
> @@ -13,7 +13,11 @@ must be the superblock from AG 0.  If the metadump has more blocks than
>  can be pointed to by the +xfs_metablock.mb_daddr+ area, the sequence
>  of +xfs_metablock+ followed by metadata blocks is repeated.
>  
> -.Metadata Dump Format
> +Two metadump file formats are supported: +V1+ and +V2+. In addition to
> +the features supported by the +V1+ format, the +V2+ format supports
> +dumping data from an external log device.

"...supports capturing data from an external log device."

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
> +	__be32          xmh_incompat_flags;

   ^^^^^ spaces not tabs (yeah, I know...)

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
> +Full blocks have been dumped.

"Full metadata blocks have been dumped.  Without this flag, unused areas
of metadata blocks are zeroed."

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
> +	__be64 xme_addr;
> +        __be32 xme_len;

Inconsistent indenting here too.

> +} __packed;
> +----
> +*xme_addr*::
> +
> +
> +The lowest 54 bits are used to store 512 byte disk addresses of a
> +metadata extent . The next 2 bits are used for indicating the device.

                  ^ no space here.

"The lower 54 bits are used to store the disk address of a metadata dump
extent.  The next 2 bits..."

> +. 00 - Data device
> +. 01 - External log
> +
> +*xme_len*::
> +Length of the Metadata in units of 512 byte blocks.

"Length of the metadata dump extent in units of 512 byte blocks."

(Hey, uh, who's the xfs documentation maintainer?  Is it still me?)

--D

> +
>  == Dump Obfuscation
>  
>  Unless explicitly disabled, the +xfs_metadump+ tool obfuscates empty block
> -- 
> 2.39.1
> 
