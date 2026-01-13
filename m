Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F0D315790;
	Tue, 13 Jan 2026 18:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768329129; cv=none; b=LtxvhP406dIbc7T8OAVQrSZOLd7ygh95iqY0JpNYqXNhJK3VMAAUeLv9Varx1c9RsF8LdQi07VnKp4pwprwaxL731/+x1swoyiT9x6AtdCUt4wsTTPjQUbEufnAVFG/7U+59ezdf4c4c+7mnlLahx5MaAHmn3/VYYDpcv1UU6v0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768329129; c=relaxed/simple;
	bh=juNE3yLMVVgfAG5JRJuyczpVJrTqx5nppNzu2gtl7bM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DnhjmyxplquYPJ4+RjQ3xZFnXCOylKcvxeckQo1xl/4PsEW4PJBQ2OOlacHpBIolk81ao5yTY9Uj60/e3yZphRHtUXtSjugDGXJMgq0hFGO3wyAw3kvKvO1oM8eW81zBWCxBkBAuAarJNkkj6r64YQkN3EHI56HzejmPgLOVuhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OskUa8yZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OskUa8yZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEAD4C116C6;
	Tue, 13 Jan 2026 18:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768329129;
	bh=juNE3yLMVVgfAG5JRJuyczpVJrTqx5nppNzu2gtl7bM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OskUa8yZOFfn0LQCOowkM+l1Hvnu3u8Vr5CuSc47pEMw08YpfbTU8Du67ykc2E6Yk
	 oV2OzMW6JH/UenfmYNvnAQ/z6nu0GigiawE63ql2fr0kFGThgWjoectXTUiBcBp09L
	 oK3Bfqenmd5wgMcIhYtNdQh+2/ZoUt+gk10Bz78MrR7c5y0aLXwyMUT6zvMHez1+GE
	 VAWQAJ8WduURDmdN/L23h1ggMfn7FqJcIhQrKV+FAvZR+WoemoonycDWodeOEbUuiO
	 xtNyuh93B40S9XXRg3TSWv0Lwnr/N3B2j0l2J+0jURAFDuWSGlJxaI5i5bDrv4d8al
	 lpwfkdEQ5CAsg==
Date: Tue, 13 Jan 2026 10:32:08 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 2/3] xfs: use bio_reuse in the zone GC code
Message-ID: <20260113183208.GA15551@frogsfrogsfrogs>
References: <20260113071912.3158268-1-hch@lst.de>
 <20260113071912.3158268-3-hch@lst.de>
 <aWaOW-mjk7uuEcyW@kbusch-mbp>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWaOW-mjk7uuEcyW@kbusch-mbp>

On Tue, Jan 13, 2026 at 11:26:35AM -0700, Keith Busch wrote:
> On Tue, Jan 13, 2026 at 08:19:02AM +0100, Christoph Hellwig wrote:
> > @@ -825,10 +823,7 @@ xfs_zone_gc_write_chunk(
> >  	WRITE_ONCE(chunk->state, XFS_GC_BIO_NEW);
> >  	list_move_tail(&chunk->entry, &data->writing);
> >  
> > -	bio_reset(&chunk->bio, mp->m_rtdev_targp->bt_bdev, REQ_OP_WRITE);
> > -	bio_add_folio_nofail(&chunk->bio, chunk->scratch->folio, chunk->len,
> > -			offset_in_folio(chunk->scratch->folio, bvec_paddr));
> > -
> > +	bio_reuse(&chunk->bio);
> 
> bio_reuse() uses the previous bio->bi_opf value, so don't you need to
> explicitly override it to REQ_OP_WRITE here? Or maybe bio_reuse() should
> take the desired op as a parameter so it doesn't get doubly initialized
> by the caller.

xfs_zone_gc_submit_write changes bi_opf to REQ_OP_ZONE_APPEND, so I
don't think it's necessary to reset it in bio_reuse.

--D
