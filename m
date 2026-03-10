Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770D43101C0
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 15:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773156407; cv=none; b=DJh0AHFq/ZRDKBJHOPsJBtM4rxKBTW49jYOBbC6h6Vkdc1TONyDguRgsWIC1FvS70mN5Y8raXiG3KQNtSBEYBF5CMS1L5ap/TTxzcQZkdNi+y41WzZEcZZZSIE2cNOESWATsnsq7CMr+0cypBIuLSho74JUlG4bRBzFk4Ybk5JA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773156407; c=relaxed/simple;
	bh=AX0ctPz83qSLOzLpPxIYTaFxSNZV6mAVpxGRzddvK4k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JdRVeyD5nlStQVBowDJYQo90pCeK8E3DoAU9ms6pjZ1KlzAZPbg730NCNCQh3i5oZ40OBGQK5q/bxinvUfHwUcFc4TpXS5hVppYRosDZ91YQmD/V/cCZ65AynEHxwp8aCQNTa00gsJUEI8cZQmmcjvhCi1x12zpp3Z0XtYsZ5vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a/LMcL23; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=W7ASdYye; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a/LMcL23";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="W7ASdYye"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773156405;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=x1gPBnL3nFJNBIyIa1yav05jeafDePL0up3MPLKVYLI=;
	b=a/LMcL23Po8bwC6vocNuIls3kl97sFLFfnI7bdvdjSqdJizYROxCqCzOOVkx89sKu4tmpb
	5+rPZskYeEx/BS8XftSwHwSVS+VqFVJgBzesQplq3Pm0iHSnjobzmb5oHulmQwUoGH0j5C
	QX5d9Xmu2gtRazkbuflyeg60cMuzR4g=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-111-CBR4tZ30OXKsZBRrBfE8WA-1; Tue, 10 Mar 2026 11:26:44 -0400
X-MC-Unique: CBR4tZ30OXKsZBRrBfE8WA-1
X-Mimecast-MFC-AGG-ID: CBR4tZ30OXKsZBRrBfE8WA_1773156403
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4836abfc742so109153875e9.0
        for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 08:26:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1773156403; x=1773761203; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=x1gPBnL3nFJNBIyIa1yav05jeafDePL0up3MPLKVYLI=;
        b=W7ASdYyeCPp6vZKAK5+QPjDcLsz1v+DpV4q9bjSyCgS99vxgTaK9pb4t3V9U/ndo0Y
         wGI9iC+fLOGbjd1KHA3XAxsyBNkKMKX7G5oyVVVtzu/ngSMD/VqfEg/oEUlEvk6KN06t
         tpPogzbw8PTyGiVIM6kmFVVQJl6d0jcm2S2n7qqQuRoF8DxkL2e+QQbvUczltUGfgNUf
         X3AbgQOPxC4tHv5ABdPspcKesA287EnGTV20RzPMJxSJigo2W1LXiBxa3GAJ7RdB4UsM
         EHSp2CrGaCJC2/Dmcvrh6JyhXPemxlN4+HKJA74gYLsfr8beA2osqRkhbxt2ry9g+Zh1
         PcLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773156403; x=1773761203;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x1gPBnL3nFJNBIyIa1yav05jeafDePL0up3MPLKVYLI=;
        b=P0uGC8XvaJCuQ56YzqhyRMbyiyMnTGp/1G2af1MPvGbh693SAtnILAoQklDx/QMWyE
         JhxB4UVFSTGJoLpY0NBRk4X0vrol5OFbeZb7ND0AHtJKWz+thjLDhpLFkzmxSt7d3AKx
         5wqp4UKi8PCiT7eWuUajqjINVrpUCsRh7tCKT2c+GuxZWjBOD31KGO1gXiAVybzH6D1f
         5vuVrttOJoS5MT7q943p6rx2NA6FKwNzCCILmT5VYJghP4TiFLm/gPqOCWcOCjXZsjwF
         SZ+13t5MVp+YP0gB6raYoXkivT7UjECbL++B5T/ns/HKX5wnGlgKZmrSi8bOZMtN1Bw7
         VbzA==
X-Forwarded-Encrypted: i=1; AJvYcCWy/wzJMyaXw0GQ0A6yBmmAIdW6mHTp7Sk3G1LlRZVyXRvziYzPt41pKZ0UcEJSY+C0L24iNt+wZyA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwbiGeRZ80NG5xBFl2AP3+sxPg72GeujjVyjw7oUW0qIV2mrcdv
	rIzwyfV5tBioaHtwkRGXe6thQATnXS1xGZNqMnm4awb0a3gGs2302ato7mqeOQV4QwaSCiIIj1E
	pdcQZBr3TbtLNraNy8FMf2Ig9JVjPMuxOQVaT5DgWmDjwrDcukj1Uk0cnLy8/
X-Gm-Gg: ATEYQzw4WNoY9v2EG9//IjkE9dLzJVvN4AjhOniXD8nN31sJG3c1dOaKGLqso5b5OJT
	VEwT9hwHtg/VEuBUYh6y4Wjjs0dgSQmsjfuIufoAzx7m6pGYcZA9ybhcCpk32voskSdz9bLGgD7
	S4r39UcfvPHigMJ4Jdv547R/O4eUUSSjTLosaIZCt5FzV/nJ/bUNZ3zPUNMpqE/I02Akn4jR8IU
	qXedMrw/CejLK3/AOIgy+9BmIwuh7ltzw7I78+/D/8Hic/UuBXzpe1cr2EInd2unjqCI8J4pXp7
	3rr5CI+VG9OX6n/CpZLiv9sArKgxcCLHNc0SFweaONw9F8XigzxTzvRdA73p095oTed1jZ4rifT
	bMeKSHesOPvs=
X-Received: by 2002:a05:600c:3f19:b0:485:3e6c:aabc with SMTP id 5b1f17b1804b1-4853e6caf6emr96414915e9.19.1773156402818;
        Tue, 10 Mar 2026 08:26:42 -0700 (PDT)
X-Received: by 2002:a05:600c:3f19:b0:485:3e6c:aabc with SMTP id 5b1f17b1804b1-4853e6caf6emr96414285e9.19.1773156402225;
        Tue, 10 Mar 2026 08:26:42 -0700 (PDT)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4853ebab1a2sm153169175e9.1.2026.03.10.08.26.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 08:26:41 -0700 (PDT)
Date: Tue, 10 Mar 2026 16:26:41 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 18/25] xfs: add fs-verity support
Message-ID: <njszph4g2g63ijfyatukmgmfyafrhsrtja526gz4pjgn2edymh@l7aq2rpxnold>
References: <20260309192355.176980-1-aalbersh@kernel.org>
 <20260309192355.176980-19-aalbersh@kernel.org>
 <20260310012658.GF1105363@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310012658.GF1105363@frogsfrogsfrogs>

On 2026-03-09 18:26:58, Darrick J. Wong wrote:
> > +/*
> > + * Retrieve the verity descriptor.
> > + */
> > +static int
> > +xfs_fsverity_get_descriptor(
> > +	struct inode		*inode,
> > +	void			*buf,
> > +	size_t			buf_size)
> > +{
> > +	struct xfs_inode	*ip = XFS_I(inode);
> > +	struct xfs_mount	*mp = ip->i_mount;
> > +	__be32			d_desc_size;
> > +	u32			desc_size;
> > +	u64			desc_size_pos;
> > +	int			error;
> > +	u64			desc_pos;
> > +	struct xfs_bmbt_irec	rec;
> > +	int			is_empty;
> > +	uint32_t		blocksize = i_blocksize(VFS_I(ip));
> > +	xfs_fileoff_t		last_block_offset;
> > +
> > +	ASSERT(inode->i_flags & S_VERITY);
> > +	error = xfs_bmap_last_extent(NULL, ip, XFS_DATA_FORK, &rec, &is_empty);
> > +	if (error)
> > +		return error;
> > +
> > +	if (is_empty)
> > +		return -ENODATA;
> > +
> > +	last_block_offset =
> > +		XFS_FSB_TO_B(mp, rec.br_startoff + rec.br_blockcount);
> > +	if (last_block_offset < xfs_fsverity_metadata_offset(ip))
> > +		return -ENODATA;
> > +
> > +	desc_size_pos = last_block_offset - sizeof(__be32);
> > +	error = fsverity_pagecache_read(inode, (char *)&d_desc_size,
> > +				  sizeof(d_desc_size), desc_size_pos);
> > +	if (error)
> > +		return error;
> > +
> > +	desc_size = be32_to_cpu(d_desc_size);
> > +	if (XFS_IS_CORRUPT(mp, desc_size > FS_VERITY_MAX_DESCRIPTOR_SIZE))
> > +		return -ERANGE;
> > +	if (XFS_IS_CORRUPT(mp, desc_size > desc_size_pos))
> > +		return -ERANGE;
> > +
> > +	if (!buf_size)
> > +		return desc_size;
> > +
> > +	if (XFS_IS_CORRUPT(mp, desc_size > buf_size))
> > +		return -ERANGE;
> > +
> > +	desc_pos = round_down(desc_size_pos - desc_size, blocksize);
> > +	error = fsverity_pagecache_read(inode, buf, desc_size, desc_pos);
> 
> Hmm so at this point ... the very last u32 mapped in the data fork
> contains the size of the fsverity descriptor; and the descriptor itself
> is in the bytes just before that u32 size field?

Yes. In common case this would be single block. But if descriptor
has signature it could be up to 16k over a few blocks. The u32 size
would be still the last mapped u32 of the data fork.

> 
> The merkle tree itself is in the bytes between
> xfs_fsverity_metadata_offset() and the block(s) consumed by the
> descriptor, right?

Yes. And there is space between merkle tree end and descriptor. The
descriptor is placed in the next 64k aligned block after last merkle
tree block (the same way merkle tree is spaced from the data). This
is different from ext4/f2fs.

This is done for merkle tree and descriptor to always get into
different pages. This requirement is due to merkle tree block
synthesis (iomap needs descriptor to synthesize these).

If iomap would read page with descriptor and merkle tree blocks
requiring to be synthesized but iomap is reading this page to get
fsverity descriptor, iomap don't know how to handle these blocks. It
can just skip/zero these blocks and continue. But then when fsverity
will want to read these blocks they are already uptodate (with
zeroes/random). This was solved by invalidating the page with
descriptor in v3. In this rev fsverity is limited by 64k page size
so if descriptor is far enough this won't be the case.

> 
> Eventually it'd be awful nice to see an update to the ondisk format
> docs, though it's probably more useful to have me guess at the format
> and have you confirm that I got the details right; then at least two
> people will know what the ondisk format is for fsverity stuff. :)
> 
> > +	if (error)
> > +		return error;
> > +
> > +	return desc_size;
> > +}
> > +
> > +static int
> > +xfs_fsverity_write_descriptor(
> > +	struct file		*file,
> > +	const void		*desc,
> > +	u32			desc_size,
> > +	u64			merkle_tree_size)
> > +{
> > +	int			error;
> > +	struct inode		*inode = file_inode(file);
> > +	struct xfs_inode	*ip = XFS_I(inode);
> > +	unsigned int		blksize = ip->i_mount->m_attr_geo->blksize;
> > +	u64			tree_last_block =
> > +		xfs_fsverity_metadata_offset(ip) + merkle_tree_size;
> > +	u64			desc_pos = round_up(tree_last_block, 65536);
> > +	u64			desc_end = desc_pos + desc_size;
> > +	__be32			desc_size_disk = cpu_to_be32(desc_size);
> > +	u64			desc_size_pos =
> > +			round_up(desc_end + sizeof(desc_size_disk), blksize) -
> > +			sizeof(desc_size_disk);
> > +
> > +	error = iomap_fsverity_write(file, desc_size_pos, sizeof(__be32),
> > +				     (const void *)&desc_size_disk,
> > +				     &xfs_buffered_write_iomap_ops,
> > +				     &xfs_iomap_write_ops);
> > +	if (error)
> > +		return error;
> > +
> > +	error = iomap_fsverity_write(file, desc_pos, desc_size, desc,
> > +				     &xfs_buffered_write_iomap_ops,
> > +				     &xfs_iomap_write_ops);
> > +
> > +	return error;
> 
> This could turn into the shorter "return iomap_fsverity_write()"

sure, thanks!

> I don't see anything objectionable here, but I would like confirmation
> that I've sniffed out the ondisk format correctly.

-- 
- Andrey

