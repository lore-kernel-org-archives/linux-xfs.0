Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A757636CDFD;
	Wed, 24 Jun 2026 17:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782320908; cv=none; b=g4O/MnDsd+tOYbVPL23FaDwGyZBe16AFLYv6s+/U3vqgCKtwKM5714LPOG+72StXXwm1/hNrGCTjXO0O6yUTdlxOhEMSFFfzvGONKGr1j7uaHgooOJSCmmdc6kAC38F3d18Z9xspbZknoqR6nghqwG3QxLCgFJgkgc3NnQpgP6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782320908; c=relaxed/simple;
	bh=oHejPNwe9HpkBOdBTQGcMMf2CwjFe4A7smOEwV7WSiI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZyeKQjoTbcjDtu8mw/2KY07fLqUHCmwQ0jFKoJ1crOcAVOmaACIAJx7ekEV3vrxvKq7ULTWQYs3TNLckK8JXIBDbi8p2RDuZNZUCg7qeHZGyGA0d3Aknx3ntfG2A01r7H6syohQmbRRaJxrB4KBCRbYB8Atvshlh3dL5MaDBHnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W9kYgD/X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W9kYgD/X"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D15E51F000E9;
	Wed, 24 Jun 2026 17:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782320905;
	bh=M6aeKZPrj4kieNvRT6MCexXuBpOFvGbapKrWWqpq74o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=W9kYgD/XfP1Xl+tGkLPsZGUpp4w2iVRN6V4PkOLteUZAoITI4NJXjDca2G+ZrvkNq
	 6iu84aP7lxRm1hYhiJkqFhcumWJDvfpIm3eiSqRFA16kgfdE1V01n9yXqJ27ab5EgM
	 I2Z6JF4YfpNHUyCVHBwvD4Sffaygk0kBA9GpV6ssrvbTUM5C4ND4a1hHgs+8+TZ5Pa
	 N2+QmeF7oT6Y5tNOVR0LcSDwoEfiqPe+T1Y60WeC7AKN9qr2jESqdSTpYeroXO6tz3
	 Bq/HdVsOT9+JEJvPnDZAMVXb+shhItUZ5EY/Xv7ZXJVjCs1Yab8mzbgBLasaFZPTPG
	 jhKgKK0sI1arw==
Date: Wed, 24 Jun 2026 10:08:25 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: jiazhenyuan <jiazhenyuan@uniontech.com>
Cc: cem@kernel.org, kees@kernel.org, linux-xfs@vger.kernel.org,
	hch@infradead.org, linux-kernel@vger.kernel.org,
	kernel@uniontech.com
Subject: Re: [PATCH] xfs: fix AGFL extent count calculation in xrep_agfl_fill
Message-ID: <20260624170825.GM6078@frogsfrogsfrogs>
References: <20260623024153.835431-1-jiazhenyuan@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260623024153.835431-1-jiazhenyuan@uniontech.com>

On Tue, Jun 23, 2026 at 10:41:53AM +0800, jiazhenyuan wrote:
> In xrep_agfl_fill(), the call to xagb_bitmap_set() passes
> 'agbno - 1' as the length argument. However, xagb_bitmap_set()
> expects a length (number of blocks), not an end block number.
> Passing 'agbno - 1' causes used_extents to record an incorrect
> range.
> 
> Fix this by calculating the correct length as 'agbno - start',
> which represents the actual number of blocks filled into the AGFL.

I have a stack of bugfixes waiting for the 7.2-rc rebase, and this
is one of them.  But since you posted first, I no longer have to seek
approval for it. :)

With this added,

Cc: <stable@vger.kernel.org> # v6.6
Fixes: 014ad53732d2ba ("xfs: use per-AG bitmaps to reap unused AG metadata blocks during repair")

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D



> Signed-off-by: jiazhenyuan <jiazhenyuan@uniontech.com>
> ---
>  fs/xfs/scrub/agheader_repair.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
> index ae9ed5f280d0..b0ffd37afb45 100644
> --- a/fs/xfs/scrub/agheader_repair.c
> +++ b/fs/xfs/scrub/agheader_repair.c
> @@ -652,7 +652,7 @@ xrep_agfl_fill(
>  	while (agbno < start + len && af->fl_off < af->flcount)
>  		af->agfl_bno[af->fl_off++] = cpu_to_be32(agbno++);
>  
> -	error = xagb_bitmap_set(&af->used_extents, start, agbno - 1);
> +	error = xagb_bitmap_set(&af->used_extents, start, agbno - start);
>  	if (error)
>  		return error;
>  
> -- 
> 2.20.1
> 
> 
