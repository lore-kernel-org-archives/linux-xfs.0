Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E09D9481DD;
	Tue, 28 Jul 2026 10:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785234878; cv=none; b=m2zi1uTV0UiVzNWk0Y7qQCrmYWu8RQnUwobVYfnOmB6EopyOIYNkbXI2pZMr6C1p5Cn0RQvchoQzid4tHnzdIssTH73dZ1OUDJhfxswLo8PMWWx3cbDIR/XEM0PBaGlUqQ/NLvSB9c/wMQdIwzKlupu9O8EwfgNhZ9vBkKGS7DQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785234878; c=relaxed/simple;
	bh=jZEUv1OUvzT+qEAVg0m2W0DLpr5+VvIzAporctPuqP8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b6HdqFe3V+ZSNkDcN8FgR0XsFnl3tDq8OqbNJ2w7o+PIqgiIe5XqyrwP/KanU7i18K6ZajkaFgpl05C4+/hMsbcKxnago2EP7qwQjKG/EnP7iKK1fdtttRlgg+A1PF/eS80PgDUmw6gZE3Y8/SLsx1M2f4/EffqQ1KIii4NS6EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UMkzcNyn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UMkzcNyn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99BD31F000E9;
	Tue, 28 Jul 2026 10:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785234876;
	bh=O6TD6GrNUMFhmV1HYJLm5mGT3y555MsVZSFozAvC0FM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UMkzcNynnUgfStEOHggUoIxTflXbe5t2QGGbyHEd8mpoxb6TjBBNG4/kfusyL1/kP
	 PXHPyPpcPXCuUYsmj4ykYtBwkxB+DBLjlReMqnZyLQJs+Nro04DFquMaiE8tRAKhLI
	 KepUoL27pnit3ZVRzQR7XG7Tb9MuVTnUhDmTm1ESyvkAClBlqazsjEp1d966nW6gMq
	 K6B4is+345lCcdu/TlLIyEi6mMgVAE0BAfCGjjSbxNB2lC2r4Z0/tiMrsp98yZNMvI
	 2qkQc7tRM1WLnpURCgL+EvIbelj5MPadHsaGVPTCGa2ycixryG3HpwmrbRf3Ha96Pd
	 Rf9tbaAL8oucQ==
Date: Tue, 28 Jul 2026 18:34:31 +0800
From: Zorro Lang <zlang@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Donald Douwsma <ddouwsma@redhat.com>, linux-xfs@vger.kernel.org, 
	fstests@vger.kernel.org
Subject: Re: [PATCH v2] xfs: test xfsdump subtree restores
Message-ID: <amiFbjl9OBecwwwD@zlang-mailbox>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>, 
	Donald Douwsma <ddouwsma@redhat.com>, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
References: <20260723062617.424905-1-ddouwsma@redhat.com>
 <amghJgu6Xhhmjlkn@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amghJgu6Xhhmjlkn@infradead.org>

On Mon, Jul 27, 2026 at 08:25:26PM -0700, Christoph Hellwig wrote:
> On Thu, Jul 23, 2026 at 04:26:17PM +1000, Donald Douwsma wrote:
> > +
> > +_do "Creating l2 dump" "$XFSDUMP_PROG -L lab_l2.0 -M test -l2 -f $tmp.dump.l2.0 $SCRATCH_MNT"
> > +
> > +dir=$(mktemp -d $SCRATCH_MNT/restore_XXX)
> > +_do "Cumulative restore l0" "$XFSRESTORE_PROG -f $tmp.dump.l0 -r $dir"
> > +_do "Cumulative restore l2" "$XFSRESTORE_PROG -f $tmp.dump.l2.0 -r $dir"
> > +
> > +dir=$(mktemp -d $SCRATCH_MNT/restore_XXX)
> > +_do "Cumulative subtree restore l0" "$XFSRESTORE_PROG -f $tmp.dump.l0 -r -s restore_me $dir"
> > +# The next command core dumps prior to xfsdump v3.3.0 when noref_elim_recurse attempts to
> > +# rename directories outside of the subtree when their parent has not been created.
> > +_do "Cumulative subtree restore l2" "$XFSRESTORE_PROG -f $tmp.dump.l2.0 -r $dir"
> 
> Maybe break these lines up with \ after the description to make
> it a bit more readable?

Sure, I'll help to do this change when I merge it. Thanks Christoph!

> 
> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> 
