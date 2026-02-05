Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5413024113C;
	Thu,  5 Feb 2026 16:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770309545; cv=none; b=fiqM67Y98aPumtSOAO83NBDulrIDI5orodg/dqZvIv8IVuen3i+s9kHcIuKNbLHEIg+rgm/kwfzHE6Exk6yU8wX2UhFMvsU9x1m7leuwaIy8L5SxYWG//owujndSZ7V4PY4PHB5v9yhc50LLQkDeZQsbXMf+w7zHFq884vGqFVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770309545; c=relaxed/simple;
	bh=UcmZwxtVevu/4LmJwiavf3o+e72PF0+okJOM508h4sM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VdApGXLYj9B/JpcLbkza4JSpTlFqWYgUyz1XVdkcBRW7Rcwz9FN/afqxvzphHUeFm9NvTpQUANE3QDf21flldZLghazFxsJ3vz0G0wE39H5OvxAlkcUNAKe/WuMD78gKLvloroNp/x38+1kLpqjIWnDRlrb8N49ATbiE8Sx0G4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t3WV8VyN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t3WV8VyN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC302C4CEF7;
	Thu,  5 Feb 2026 16:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770309545;
	bh=UcmZwxtVevu/4LmJwiavf3o+e72PF0+okJOM508h4sM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=t3WV8VyNUEUimcDIrcCkevC+zvskn8I+KSeQJ8GZh3XXaNxGxwSYR2WQf+ennWmXn
	 dvkfUYd1YrrGsqA+2BM5Tv3B6z9x22eie/5OSWmrENMSYHHWQ11DeR2WJ7qgC/xwXx
	 IC1yB3pRoG2UwGkUB+yWpHofXG/gU30SGWlRhi6DWHzF85+f75DLjBFZJYLJtS1JEi
	 64GbIbUBD4MQmLdeT9IrxClslHB8F8VFjNXp5RclMzo2Jxu3NCnaBXoUGM+iXfiqXH
	 ViCai7tvqJwdwOalzp5+rG4m+4ncbkGyzRM1pizXA5ERD7dTV0zLjq0KBQmOfGtwMG
	 t+8gPSPNR3piA==
Date: Thu, 5 Feb 2026 08:39:04 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Kundan Kumar <kundan.kumar@samsung.com>
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
	willy@infradead.org, mcgrof@kernel.org, clm@meta.com,
	david@fromorbit.com, amir73il@gmail.com, axboe@kernel.dk,
	hch@lst.de, ritesh.list@gmail.com, dave@stgolabs.net,
	cem@kernel.org, wangyufei@vivo.com, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-xfs@vger.kernel.org, gost.dev@samsung.com,
	anuj20.g@samsung.com, vishak.g@samsung.com, joshi.k@samsung.com
Subject: Re: [PATCH v3 2/6] xfs: add helpers to pack AG prediction info for
 per-folio tracking
Message-ID: <20260205163904.GR7712@frogsfrogsfrogs>
References: <20260116100818.7576-1-kundan.kumar@samsung.com>
 <CGME20260116101245epcas5p30269c6aa35784db67e6d6ca800a683a7@epcas5p3.samsung.com>
 <20260116100818.7576-3-kundan.kumar@samsung.com>
 <20260129004548.GB7712@frogsfrogsfrogs>
 <4a795b10-95ed-4bba-90c8-9fee57454948@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4a795b10-95ed-4bba-90c8-9fee57454948@samsung.com>

On Tue, Feb 03, 2026 at 12:45:33PM +0530, Kundan Kumar wrote:
> On 1/29/2026 6:15 AM, Darrick J. Wong wrote:
> > On Fri, Jan 16, 2026 at 03:38:14PM +0530, Kundan Kumar wrote:
> >> Introduce helper routines to pack and unpack AG prediction metadata
> >> for folios. This provides a compact and self-contained representation
> >> for AG tracking.
> >>
> >> The packed layout uses:
> >>   - bit 31	: valid
> >>   - bit 24-30	: iomap type
> >>   - bit 0-23	: AG number
> > 
> > There are only 5 iomap types, why do you need 7 bits for that?
> > 
> > Also, can you store more bits on a 64-bit system to avoid truncating the
> > AG number?
> > 
> > --D
> 
> I’ll reduce the type field to 3 bits (8 values).
> 
> For the AG number, I can drop the artificial 24-bit cap by packing into 
> an unsigned long and storing it via xa_mk_value(), which provides ~60 
> bits on 64-bit systems and ~28 bits on 32-bit systems.

<nod>

> > 
> >> Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
> >> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> >> ---
> >>   fs/xfs/xfs_iomap.h | 31 +++++++++++++++++++++++++++++++
> >>   1 file changed, 31 insertions(+)
> >>
> >> diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
> >> index ebcce7d49446..eaf4513f6759 100644
> >> --- a/fs/xfs/xfs_iomap.h
> >> +++ b/fs/xfs/xfs_iomap.h
> >> @@ -12,6 +12,37 @@ struct xfs_inode;
> >>   struct xfs_bmbt_irec;
> >>   struct xfs_zone_alloc_ctx;
> >>   
> >> +/* pack prediction in a u32 stored in xarray */
> >> +#define XFS_AGP_VALID_SHIFT 31
> >> +#define XFS_AGP_TYPE_SHIFT 24
> >> +#define XFS_AGP_TYPE_MASK 0x7fu
> >> +#define XFS_AGP_AGNO_MASK 0x00ffffffu
> >> +
> >> +static inline u32 xfs_agp_pack(u32 agno, u8 iomap_type, bool valid)
> >> +{
> >> +	u32 v = agno & XFS_AGP_AGNO_MASK;
> >> +
> >> +	v |= ((u32)iomap_type & XFS_AGP_TYPE_MASK) << XFS_AGP_TYPE_SHIFT;
> >> +	if (valid)
> >> +		v |= (1u << XFS_AGP_VALID_SHIFT);
> >> +	return v;
> >> +}
> >> +
> >> +static inline bool xfs_agp_valid(u32 v)
> >> +{
> >> +	return v >> XFS_AGP_VALID_SHIFT;

Isn't this just a mask?

	return v & (1U << XFS_AGP_VALID_SHIFT)

> >> +}
> >> +
> >> +static inline u32 xfs_agp_agno(u32 v)
> >> +{
> >> +	return v & XFS_AGP_AGNO_MASK;
> >> +}
> >> +
> >> +static inline u8 xfs_agp_type(u32 v)
> >> +{
> >> +	return (u8)((v >> XFS_AGP_TYPE_SHIFT) & XFS_AGP_TYPE_MASK);
> >> +}

And as Nirjhar noted, please try to use richer types when possible.
s/u32 agno/xfs_agnumber_t agno/

--D

> >> +
> >>   int xfs_iomap_write_direct(struct xfs_inode *ip, xfs_fileoff_t offset_fsb,
> >>   		xfs_fileoff_t count_fsb, unsigned int flags,
> >>   		struct xfs_bmbt_irec *imap, u64 *sequence);
> >> -- 
> >> 2.25.1
> >>
> >>
> > 
> 
> 
