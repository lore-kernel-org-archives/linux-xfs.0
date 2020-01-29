Return-Path: <SRS0=zOuE=3S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23245C2D0DB
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jan 2020 18:46:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ECBEA20661
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jan 2020 18:46:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727303AbgA2SqP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jan 2020 13:46:15 -0500
Received: from sandeen.net ([63.231.237.45]:38552 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727024AbgA2SqP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 29 Jan 2020 13:46:15 -0500
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 9DC4222C5;
        Wed, 29 Jan 2020 12:46:14 -0600 (CST)
Subject: Re: [PATCH 1/2] xfs: don't take addresses of packed xfs_agfl_t member
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Eric Sandeen <sandeen@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
References: <65e48930-96ae-7307-ba65-6b7528bb2fb5@redhat.com>
 <09382ee9-8539-2f1d-bd4d-7256daf38a40@redhat.com>
 <20200129180954.GC14855@infradead.org>
 <1e0fada6-1a6f-6980-ab2c-85aa8b4998e7@sandeen.net>
 <20200129182837.GD14855@infradead.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <35465e24-e502-c73a-47b7-2a5988290152@sandeen.net>
Date:   Wed, 29 Jan 2020 12:46:13 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200129182837.GD14855@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/29/20 12:28 PM, Christoph Hellwig wrote:
> On Wed, Jan 29, 2020 at 12:18:16PM -0600, Eric Sandeen wrote:
>>>
>>> But I absolutely do not see the point.  If agfl_bno was unalgined
>>> so is adding the offsetoff.  The warnings makes no sense, and there is
>>> a good reason the kernel build turned it off.
>>
>> Why do the warnings make no sense?
> 
> Because taking the address of a member of a packed struct itself doesn't
> mean it is misaligned.  Taking the address of misaligned member does
> that.  And adding a non-aligned offset to a pointer will make it just
> as misaligned.
> 
>> TBH, the above construction actually makes a lot more intuitive sense to
>> me, alignment concerns or not.
> 
> Using offsetoff to take the address of a struct member is really
> strange.
> 
> If we want to stop taking the address of agfl_bno we should just remove
> the field entirely:
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index fc93fd88ec89..d91177c4a1e4 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -585,11 +585,12 @@ xfs_alloc_fixup_trees(
>  
>  static xfs_failaddr_t
>  xfs_agfl_verify(
> -	struct xfs_buf	*bp)
> +	struct xfs_buf		*bp)
>  {
> -	struct xfs_mount *mp = bp->b_mount;
> -	struct xfs_agfl	*agfl = XFS_BUF_TO_AGFL(bp);
> -	int		i;
> +	struct xfs_mount	*mp = bp->b_mount;
> +	struct xfs_agfl		*agfl = XFS_BUF_TO_AGFL(bp);
> +	__be32			*agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, bp);
> +	int			i;
>  
>  	/*
>  	 * There is no verification of non-crc AGFLs because mkfs does not
> @@ -614,8 +615,8 @@ xfs_agfl_verify(
>  		return __this_address;
>  
>  	for (i = 0; i < xfs_agfl_size(mp); i++) {
> -		if (be32_to_cpu(agfl->agfl_bno[i]) != NULLAGBLOCK &&
> -		    be32_to_cpu(agfl->agfl_bno[i]) >= mp->m_sb.sb_agblocks)
> +		if (be32_to_cpu(agfl_bno[i]) != NULLAGBLOCK &&
> +		    be32_to_cpu(agfl_bno[i]) >= mp->m_sb.sb_agblocks)
>  			return __this_address;
>  	}
>  
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 77e9fa385980..0d0a6616e129 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -783,21 +783,21 @@ typedef struct xfs_agi {
>   */
>  #define XFS_AGFL_DADDR(mp)	((xfs_daddr_t)(3 << (mp)->m_sectbb_log))
>  #define	XFS_AGFL_BLOCK(mp)	XFS_HDR_BLOCK(mp, XFS_AGFL_DADDR(mp))
> -#define	XFS_BUF_TO_AGFL(bp)	((xfs_agfl_t *)((bp)->b_addr))
> +#define	XFS_BUF_TO_AGFL(bp)	((struct xfs_agfl *)((bp)->b_addr))
>  
> -#define XFS_BUF_TO_AGFL_BNO(mp, bp) \
> -	(xfs_sb_version_hascrc(&((mp)->m_sb)) ? \
> -		&(XFS_BUF_TO_AGFL(bp)->agfl_bno[0]) : \
> -		(__be32 *)(bp)->b_addr)
> +#define XFS_BUF_TO_AGFL_BNO(mp, bp)			\
> +	((__be32 *)					\
> +	 (xfs_sb_version_hascrc(&((mp)->m_sb)) ?	\
> +	  (bp)->b_addr :				\
> +	  ((bp)->b_addr + sizeof(struct xfs_agfl))))

This is backwards

>  
> -typedef struct xfs_agfl {
> +struct xfs_agfl {
>  	__be32		agfl_magicnum;
>  	__be32		agfl_seqno;
>  	uuid_t		agfl_uuid;
>  	__be64		agfl_lsn;
>  	__be32		agfl_crc;
> -	__be32		agfl_bno[];	/* actually xfs_agfl_size(mp) */
> -} __attribute__((packed)) xfs_agfl_t;
> +} __attribute__((packed));
>  
>  #define XFS_AGFL_CRC_OFF	offsetof(struct xfs_agfl, agfl_crc)

<peers past whitespace changes> ;)

other than that, this approach seems reasonable too.

-Eric
 
