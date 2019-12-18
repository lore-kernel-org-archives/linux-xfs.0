Return-Path: <SRS0=QbY/=2I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17E48C43603
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 21:00:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA4F721582
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 21:00:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbfLRVAQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Dec 2019 16:00:16 -0500
Received: from sandeen.net ([63.231.237.45]:43820 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726092AbfLRVAQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 18 Dec 2019 16:00:16 -0500
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 8F359F8BEA;
        Wed, 18 Dec 2019 15:00:00 -0600 (CST)
Subject: Re: [PATCH] libxfs: make resync with the userspace libxfs easier
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>
References: <20191217023535.GA12765@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <b570b661-f516-f0e8-3317-5bd879fffb45@sandeen.net>
Date:   Wed, 18 Dec 2019 15:00:14 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20191217023535.GA12765@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 12/16/19 8:35 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Prepare to resync the userspace libxfs with the kernel libxfs.  There
> were a few things I missed -- a couple of static inline directory
> functions that have to be exported for xfs_repair; a couple of directory
> naming functions that make porting much easier if they're /not/ static
> inline; and a u16 usage that should have been uint16_t.
> 
> None of these things are bugs in their own right; this just makes
> porting xfsprogs easier.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

This all seems fine - I'm wondering about prototypes in xfs_dir2_priv.h
vs xfs_dir2.h - at this point I'm not sure why we have the two,
help?

But whatevs, if that needs cleanup it can come later.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/xfs/libxfs/xfs_bmap.c      |    2 +-
>  fs/xfs/libxfs/xfs_dir2.c      |   21 +++++++++++++++++++++
>  fs/xfs/libxfs/xfs_dir2_priv.h |   29 +++++++++--------------------
>  fs/xfs/libxfs/xfs_dir2_sf.c   |    6 +++---
>  4 files changed, 34 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 4a802b3abe77..4c2e046fbfad 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4561,7 +4561,7 @@ xfs_bmapi_convert_delalloc(
>  	struct xfs_mount	*mp = ip->i_mount;
>  	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
>  	struct xfs_bmalloca	bma = { NULL };
> -	u16			flags = 0;
> +	uint16_t		flags = 0;
>  	struct xfs_trans	*tp;
>  	int			error;
>  
> diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
> index 0aa87cbde49e..dd6fcaaea318 100644
> --- a/fs/xfs/libxfs/xfs_dir2.c
> +++ b/fs/xfs/libxfs/xfs_dir2.c
> @@ -724,3 +724,24 @@ xfs_dir2_namecheck(
>  	/* There shouldn't be any slashes or nulls here */
>  	return !memchr(name, '/', length) && !memchr(name, 0, length);
>  }
> +
> +xfs_dahash_t
> +xfs_dir2_hashname(
> +	struct xfs_mount	*mp,
> +	struct xfs_name		*name)
> +{
> +	if (unlikely(xfs_sb_version_hasasciici(&mp->m_sb)))
> +		return xfs_ascii_ci_hashname(name);
> +	return xfs_da_hashname(name->name, name->len);
> +}
> +
> +enum xfs_dacmp
> +xfs_dir2_compname(
> +	struct xfs_da_args	*args,
> +	const unsigned char	*name,
> +	int			len)
> +{
> +	if (unlikely(xfs_sb_version_hasasciici(&args->dp->i_mount->m_sb)))
> +		return xfs_ascii_ci_compname(args, name, len);
> +	return xfs_da_compname(args, name, len);
> +}
> diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
> index c031c53d0f0d..01ee0b926572 100644
> --- a/fs/xfs/libxfs/xfs_dir2_priv.h
> +++ b/fs/xfs/libxfs/xfs_dir2_priv.h
> @@ -175,6 +175,12 @@ extern int xfs_dir2_sf_lookup(struct xfs_da_args *args);
>  extern int xfs_dir2_sf_removename(struct xfs_da_args *args);
>  extern int xfs_dir2_sf_replace(struct xfs_da_args *args);
>  extern xfs_failaddr_t xfs_dir2_sf_verify(struct xfs_inode *ip);
> +int xfs_dir2_sf_entsize(struct xfs_mount *mp,
> +		struct xfs_dir2_sf_hdr *hdr, int len);
> +void xfs_dir2_sf_put_ino(struct xfs_mount *mp, struct xfs_dir2_sf_hdr *hdr,
> +		struct xfs_dir2_sf_entry *sfep, xfs_ino_t ino);
> +void xfs_dir2_sf_put_ftype(struct xfs_mount *mp,
> +		struct xfs_dir2_sf_entry *sfep, uint8_t ftype);
>  
>  /* xfs_dir2_readdir.c */
>  extern int xfs_readdir(struct xfs_trans *tp, struct xfs_inode *dp,
> @@ -194,25 +200,8 @@ xfs_dir2_data_entsize(
>  	return round_up(len, XFS_DIR2_DATA_ALIGN);
>  }
>  
> -static inline xfs_dahash_t
> -xfs_dir2_hashname(
> -	struct xfs_mount	*mp,
> -	struct xfs_name		*name)
> -{
> -	if (unlikely(xfs_sb_version_hasasciici(&mp->m_sb)))
> -		return xfs_ascii_ci_hashname(name);
> -	return xfs_da_hashname(name->name, name->len);
> -}
> -
> -static inline enum xfs_dacmp
> -xfs_dir2_compname(
> -	struct xfs_da_args	*args,
> -	const unsigned char	*name,
> -	int			len)
> -{
> -	if (unlikely(xfs_sb_version_hasasciici(&args->dp->i_mount->m_sb)))
> -		return xfs_ascii_ci_compname(args, name, len);
> -	return xfs_da_compname(args, name, len);
> -}
> +xfs_dahash_t xfs_dir2_hashname(struct xfs_mount *mp, struct xfs_name *name);
> +enum xfs_dacmp xfs_dir2_compname(struct xfs_da_args *args,
> +		const unsigned char *name, int len);
>  
>  #endif /* __XFS_DIR2_PRIV_H__ */
> diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
> index 8b94d33d232f..7b7f6fb2ea3b 100644
> --- a/fs/xfs/libxfs/xfs_dir2_sf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
> @@ -37,7 +37,7 @@ static void xfs_dir2_sf_check(xfs_da_args_t *args);
>  static void xfs_dir2_sf_toino4(xfs_da_args_t *args);
>  static void xfs_dir2_sf_toino8(xfs_da_args_t *args);
>  
> -static int
> +int
>  xfs_dir2_sf_entsize(
>  	struct xfs_mount	*mp,
>  	struct xfs_dir2_sf_hdr	*hdr,
> @@ -84,7 +84,7 @@ xfs_dir2_sf_get_ino(
>  	return get_unaligned_be64(from) & XFS_MAXINUMBER;
>  }
>  
> -static void
> +void
>  xfs_dir2_sf_put_ino(
>  	struct xfs_mount		*mp,
>  	struct xfs_dir2_sf_hdr		*hdr,
> @@ -145,7 +145,7 @@ xfs_dir2_sf_get_ftype(
>  	return XFS_DIR3_FT_UNKNOWN;
>  }
>  
> -static void
> +void
>  xfs_dir2_sf_put_ftype(
>  	struct xfs_mount	*mp,
>  	struct xfs_dir2_sf_entry *sfep,
> 
