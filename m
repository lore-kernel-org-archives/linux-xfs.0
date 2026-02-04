Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4D038E5C5
	for <linux-xfs@vger.kernel.org>; Wed,  4 Feb 2026 07:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770190655; cv=none; b=h5hTdpOGfQlkJGE6u/3BUgpgEO131M2zlTPra/3ZR/GDFtLvE8RdKHF7WdR0EQVolTgPPsr88FiAzd3OZqFbdM6xL+Y/G1V+PhPw6zLFoxYXOKgSBsBK72YNaLbCrwK+DIfDD9Jg0Nhor+jLETmKjKxq4T6ns1DIMM47sh+xp1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770190655; c=relaxed/simple;
	bh=3vD2v8ghz50UyVzLCs0ItxZ4n09cD5uGcNPjMaFsbBY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Mime-Version; b=fmepmwxjtnjtjOXmA8wCN8Dv8ePcmeUin0wuNVAmRYvLjeqr9o3Bo22hAn9K238qu6gqRlrMGtCDubgnBFHyx8+4OBBWYHr2vhMKMmjrUssMCPBiYdXBVIGC5jejfjW4Neu+EjGvzvfPR5b1u+d1lmmCycEnhss787Z+DH7kzWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d2jQkx3u; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d2jQkx3u"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-82361bcbd8fso3811675b3a.0
        for <linux-xfs@vger.kernel.org>; Tue, 03 Feb 2026 23:37:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770190655; x=1770795455; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6xKiGXhAf0POKtC5HLVPhalwQmNgPksjY3TFJBTsNxc=;
        b=d2jQkx3uRXrOlrBfrU8H7EA41jwi4Q+uIEDFMrePyh+65QU5k5v33zP/l961k4NVPV
         xUbgKOpmtY3o09SHAlq//in71B9fFwISYizek2Him588NMhDDJyGf6EfRCCXu3JiZHEr
         dH+sv+lLhWvhsDzNF8sDo6zxkWb9PVfxOEQSB7YAaGhTuyDdPHzQhwghVVdkHPHKbakh
         HwYGo2UwlGSOJsAJMC6sZyEQSxvDvRswW9W/w2qJcDzO+3VZ8E4M3T166O0eTLB5ErrV
         EAXBaUQGKUD1vYnuSPNFbboxDaDvD/cOYdDUp5RgEdRvlWNyDDsar+EuYhPJ7tYxj1qI
         zNDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770190655; x=1770795455;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6xKiGXhAf0POKtC5HLVPhalwQmNgPksjY3TFJBTsNxc=;
        b=TTgddFPwSPG3e5cn0u8TznJMJGn9vLZCAimdYqW+SyHEndP/xRiqXZQEdLgQYOkUr+
         7ZYaxFnaeVX/7yFdubjvRZbkbBqOLb523LuKNR3qC4xOR/5KOsc0WfbZJfTMuRjDUjuh
         KVTslh9eOzoJ4C4iPOpJolLPn97OqWtiYYw/un1EVZjSaxdwyHWoVcl2R2WrbabiCw2o
         6HMvhAzBRauPVVD7ysoBKvqqN8ZrmD6u2hbA67cC0/KMcrEAXEsn1bK0DDcnpm6SzvL9
         0SvOdowS6/RUgB5fqMRGxc8ysT3u4k5rXAXRd4U6exv5wWzNpVWEx5o7RI18xNG8rVgd
         NxXQ==
X-Forwarded-Encrypted: i=1; AJvYcCVZa0+0BasAArLnpT+nTxnltj/x2u7txflaiDFmdHph44XFYT0nEpPxrFjW3tyQZqB0zR2twmxFy3A=@vger.kernel.org
X-Gm-Message-State: AOJu0YzPSso3JrSM/PYKEuUkE8iH0mkaMDfjebIuNjKBKdEwITimOWDm
	9jpufAciwVg+8RmakHZqF7faBf/un893WqwpSh6OcNM5H13e0e/gqSlj
X-Gm-Gg: AZuq6aL754/7BVqKFWEuHcrZQl3huUw428qmwvRTBwvz+C4EOeY5JfHyxqsBv3HHhi3
	GcnhEu1/N4TX75Fy5ScqnUgs/rcBiVfXkHQAhJXH1VUiGwRas79AzjoolMPI06LsSlwYnocebSF
	yhXVUEsVPvEr5TnYhqxmUzMbM/WR2Uc7xfBjk1G2YqmQNGVfGYBlHMzoON4qZe2FXyiB/LuMtUW
	b3Df9yl4mTavQjcopPfHLWsfeAnJi9cclXpmeKCVug5kekV3tITQ724EocttIdq0Wav6qxNdQFB
	Mz6xCU4fyZoTf2fP624cfja9nvA/iwZCVCpHb9jhTz9EBl1n+7Unw2F2ER858L9MxMkaga9arJ6
	4n+d9QZxZtHLEbo2rRiFI6jhryH/sdFXQY49YYTzTMDDTwhvzyXA56eGgezOVpQR4XEwAe/ISE1
	pR72K02umuVm0oRWXUAlBoAY9zF5kY8Tbc/FTyblRX/AhE+n4xtpDA7+x7gsFv
X-Received: by 2002:a05:6a00:4b47:b0:821:807a:e427 with SMTP id d2e1a72fcca58-8241c1dfd96mr2358341b3a.21.1770190655016;
        Tue, 03 Feb 2026 23:37:35 -0800 (PST)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([129.41.58.6])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8241d163fb2sm1561632b3a.14.2026.02.03.23.37.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Feb 2026 23:37:34 -0800 (PST)
Message-ID: <abe69ec973a115015d998907e9f7fd4d3c45f38a.camel@gmail.com>
Subject: Re: [PATCH v3 2/6] xfs: add helpers to pack AG prediction info for
 per-folio tracking
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: Kundan Kumar <kundan.kumar@samsung.com>, viro@zeniv.linux.org.uk, 
 brauner@kernel.org, jack@suse.cz, willy@infradead.org, mcgrof@kernel.org, 
 clm@meta.com, david@fromorbit.com, amir73il@gmail.com, axboe@kernel.dk,
 hch@lst.de,  ritesh.list@gmail.com, djwong@kernel.org, dave@stgolabs.net,
 cem@kernel.org,  wangyufei@vivo.com
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-xfs@vger.kernel.org, gost.dev@samsung.com, anuj20.g@samsung.com, 
	vishak.g@samsung.com, joshi.k@samsung.com
Date: Wed, 04 Feb 2026 13:07:27 +0530
In-Reply-To: <20260116100818.7576-3-kundan.kumar@samsung.com>
References: <20260116100818.7576-1-kundan.kumar@samsung.com>
	 <CGME20260116101245epcas5p30269c6aa35784db67e6d6ca800a683a7@epcas5p3.samsung.com>
	 <20260116100818.7576-3-kundan.kumar@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-27.el8_10) 
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2026-01-16 at 15:38 +0530, Kundan Kumar wrote:
> Introduce helper routines to pack and unpack AG prediction metadata
> for folios. This provides a compact and self-contained representation
> for AG tracking.
> 
> The packed layout uses:
>  - bit 31	: valid
>  - bit 24-30	: iomap type
>  - bit 0-23	: AG number
# AG limited to 2^24 - is this a reasonable assumption?
> 
> Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> ---
>  fs/xfs/xfs_iomap.h | 31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
> 
> diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
> index ebcce7d49446..eaf4513f6759 100644
> --- a/fs/xfs/xfs_iomap.h
> +++ b/fs/xfs/xfs_iomap.h
> @@ -12,6 +12,37 @@ struct xfs_inode;
>  struct xfs_bmbt_irec;
>  struct xfs_zone_alloc_ctx;
>  
> +/* pack prediction in a u32 stored in xarray */
Nit: Maybe some brief comment about what these are doing and their significance?
> +#define XFS_AGP_VALID_SHIFT 31
> +#define XFS_AGP_TYPE_SHIFT 24
> +#define XFS_AGP_TYPE_MASK 0x7fu
> +#define XFS_AGP_AGNO_MASK 0x00ffffffu
> +
> +static inline u32 xfs_agp_pack(u32 agno, u8 iomap_type, bool valid)
Nit: Maybe use xfs_agnumber_t instead of u32 for agno?
Nit: I think xfs style is like 
static inline u32
<function name, parameters etc>
> +{
> +	u32 v = agno & XFS_AGP_AGNO_MASK;
> +
> +	v |= ((u32)iomap_type & XFS_AGP_TYPE_MASK) << XFS_AGP_TYPE_SHIFT;
> +	if (valid)
> +		v |= (1u << XFS_AGP_VALID_SHIFT);
> +	return v;
> +}
> +
> +static inline bool xfs_agp_valid(u32 v)
> +{
> +	return v >> XFS_AGP_VALID_SHIFT;
> +}
> +
> +static inline u32 xfs_agp_agno(u32 v)
> +{
> +	return v & XFS_AGP_AGNO_MASK;
> +}
> +
> +static inline u8 xfs_agp_type(u32 v)
> +{
> +	return (u8)((v >> XFS_AGP_TYPE_SHIFT) & XFS_AGP_TYPE_MASK);
> +}
Again Nit:
We are introducing functions here but using it in the upcoming patches, any reason why can't we
introduce and use the functions in the same patch? In that way we can also look into the definitions
and usages in the same patch instead of this where we have to switch between 2 patches - one to look
into the definitions and another to look into the usages/call-sites? Again no hard preferences here
- just a suggestion.
--NR
> +
>  int xfs_iomap_write_direct(struct xfs_inode *ip, xfs_fileoff_t offset_fsb,
>  		xfs_fileoff_t count_fsb, unsigned int flags,
>  		struct xfs_bmbt_irec *imap, u64 *sequence);

