Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBCBF3D1CC1;
	Fri,  5 Jun 2026 08:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780649880; cv=none; b=k4SuTcl2vqS8+c+YPkOCTypSc9GNaN6JyxAR7ZeehVQ5j9NjV4yxLRUrLhhz6T+mnA3YbGAn0/evMS2OCILdFvPbce+4fXjolToATAd4pl8iiQfS968250IsBLyTHQ78twH6P5MWbzIoc2E0WBV7rw+cWZtMQvDF8jhmdom5StY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780649880; c=relaxed/simple;
	bh=uw1LkM27zKaoloZC0zVs4P6NnuhIXBKZEKV5hr0E8Og=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FJCPxFZe1oV+gf0WSvIFLUMAuYcioSEYHspH4H2oXKz6mj7ytQRniYreMwFOeQ9n3NfiN2pJ5DePYQFHnF3x81aqyPp6xwUlf1trdmIgRcWgsKYjvzkasjOPn6cgaNPH92bwzugNGZhaG4qTgmLTSetBj9Zze1BlpPTCDO5fcWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OB0O9ehu; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OB0O9ehu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=2FlUBGYQFAXvh7XxkFkx4vlFKlAdOAT/e4bHw+CVC7Y=; b=OB0O9ehu11dvDMb7Pe/0OuVF55
	BBKJp7CeqiXE+7nK8+tg7I3dWqmgzrIC5aJmusL/ejM7QocbD373+mGlp4eSQkwtMX9Op5waXcE73
	SKcicrHykTt2rlNcgBIFa4d7Ko/iL6Y4AypyR/ibd084w0FjAPujgAvOwZVao7ZovwxdN3SjonhMV
	DjF82C8FjZ93pwC/LoUtUwE0ofp6UU/Fx0qwkLGXZsAYtNa4n1mMmP1PmXVGvCVVwgo1dKZE4FLlv
	UtTL31ZTW57hrBj4LxuZxPMR5Z/5yPdSQdAHSE5NYPuNKMZKyIA5vJYYcFnvLaYrYyCZ/HujpevEh
	Gfdz7MwA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wVQNK-00000000Luf-1zKI;
	Fri, 05 Jun 2026 08:57:58 +0000
Date: Fri, 5 Jun 2026 01:57:58 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Brandon Allard <brandon@redpanda.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: coalesce contiguous unwritten suffix into iomap for
 NOWAIT writes
Message-ID: <aiKPlrsTfD_nq7ze@infradead.org>
References: <20260529191100.4142371-1-brandon@redpanda.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260529191100.4142371-1-brandon@redpanda.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, May 29, 2026 at 03:11:00PM -0400, Brandon Allard wrote:
> In append-only direct-IO workloads with fallocate(with KEEP_SIZE +
> ZERO_RANGE) writes can span the written/unwritten boundary of the
> preallocated extent. This is from callers needing to overwrite the
> previously written block if the last write didn't completely fill it.
> 
> Prior to commit 883a790a8440 ("xfs: don't allow NOWAIT DIO across extent
> boundaries") these writes succeeded by issuing two bios: one against the
> NORM head, one against the UNWRITTEN tail. That commit closed off the
> two-bio path to prevent NOWAIT callers from observing short writes when
> one bio succeeded and another returned -EAGAIN. The side effect is that
> the workload above now returns -EAGAIN on the spanning write.
> 
> This patch restores the success path by coalescing the (NORM, UNWRITTEN)
> pair into a single in-memory iomap when the two records are physically
> contiguous on disk. The merged range is reported as UNWRITTEN so
> iomap_dio submits a single contiguous bio and the completion handler
> runs xfs_iomap_write_unwritten across the merged range.
> 
> Short writes are still prevented. The merged iomap describes a single
> contiguous physical extent, so iomap_dio still submits a single bio
> for the full range. The caller observes the same all-or-nothing
> behaviour as a write into a single UNWRITTEN extent.
> 
> The completion of the write also remains correct.
> xfs_bmapi_convert_unwritten returns early on the already-NORM prefix
> without dirtying the transaction, while the UNWRITTEN suffix flips to
> NORM and the two adjacent same-state records coalesce in the bmbt as a
> side effect of xfs_bmap_add_extent_unwritten_real.

I think the better way to do this would be a new XFS_BMAPI_ flag that
allows xfs_bmapi_read to merge maps with mismatching unwritten/written
state and just return your a single map.  The big benefits are that we
only need to do one search for the extent and can then iterate the
cursor, and I think it will also end up with less and more readable code.

We actually had such a flag until v4.19, so you might be able to just
look into a manual revert of commit c3a2f9fff1bb ("xfs: remove the now
unused XFS_BMAPI_IGSTATE flag") for a start, although for use case
you'd need to ensure that the unwritten flag is set on the output
map if it is set on any of the input maps.

