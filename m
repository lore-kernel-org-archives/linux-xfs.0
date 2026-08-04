Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D4612367DF;
	Tue,  4 Aug 2026 13:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785848496; cv=none; b=f0FwkgDMO/YDFqHQseDYL0SV3PK5wUnDMfMq/8Uuz4JKKtKiA6VCv/egLeL2PQNw26KxybIA4+osQmwvxzKUHe7Qez+tLj+mzyNvsVTeRMUoXbS7+NHv/n7S839ll2+JcC5Ec/jDJtzW/63Dij2J24D9gVLa+qb2C6DQa2q34n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785848496; c=relaxed/simple;
	bh=L8HuKQtOVrQQqAhBSraG51yNoHzvOdEdj8OOiTtOvrk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G9rdP/rrPW8hkbphow5M/6LuJjdyAUNxxrAX5vOg8oN6crVkhgClpAXSsKJZtM8F9mQYhFGxxGaSJcd8X9TqEwdhFf/vvhQ4n5dqgd26xhubuTgrfDTEJomDklNSpu/uKgI/74drVF/KiGgGUUOcmElAgBVoldFaKuLk7NkDYMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=cA3la578; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cA3la578"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=bATTpGrkdNjmFdAaaqg/9o2W6V3JE2zhxK/EKUEvGM4=; b=cA3la5788wyBi4QH22ppdSw4Ou
	JJEk3/9tkiM6wdInLyDKML+uUxLEVHCId+9TjAdLnz9vXv17AnASnLZ0pRzhSuiquuOJtsMg0K1bF
	jc138A+nSiqBvugTIaRG0V0yo/VWbikCOrw7aR9GrKKMT+28KB7vXRm+55lxs/95ZjP1RBTISgRWw
	acjXr2k0hYa6z7GuXfb7nPPY7RhMsGuBKoI4ROwCbuIyhNez3JcaHbULdrnaKUbFAKlUrDhOJt9qM
	RLKyCaDErPoRfGTHgYVaSYjSELWQBtLDXcqfMtT82yy3JB8f4+A/XQ4hVL68JulhQHulWxyns9kyX
	ddTRhvWw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wrEly-00000001s9N-49iy;
	Tue, 04 Aug 2026 13:01:34 +0000
Date: Tue, 4 Aug 2026 06:01:34 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3] iomap: follow the alignment requirement for
 iomap_dio_hole_iter()
Message-ID: <anHirnemstkJksXp@infradead.org>
References: <596ee3b5d0d23c42eefac651d24fae914fa16312.1785534430.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <596ee3b5d0d23c42eefac651d24fae914fa16312.1785534430.git.wqu@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sat, Aug 01, 2026 at 07:17:26AM +0930, Qu Wenruo wrote:
> +++ b/fs/iomap/direct-io.c
> @@ -409,7 +409,10 @@ static inline unsigned int iomap_dio_alignment(struct inode *inode,
>  {
>  	if (dio_flags & IOMAP_DIO_FSBLOCK_ALIGNED)
>  		return i_blocksize(inode);
> -	return bdev_logical_block_size(bdev);
> +	/* @bdev can be NULL for hole cases. */
> +	if (bdev)
> +		return bdev_logical_block_size(bdev);
> +	return SECTOR_SIZE;

No.  As said for previous versions you should not use
iomap_dio_alignment.  There is no such things as sub-fsblock alignment
for holes.  All mappings need to be aligned on fs blocks, you can do
sub-mapping granularity I/O in it, but not align on it.  So don't
call iomap_dio_alignment, but instead align down the shortened range
from the fault to a fs block boundary.

And really sort out the btrfs locking that we can't get rid of this
premature faulting as it keeps messing up core code way too much.

