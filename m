Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A5F325491
	for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2026 00:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773188404; cv=none; b=o2BD2HyUH8eAn2zRlXQTO48tmBHOUmUBkKQHK2WvZGueL7VQHdncHqDTlz4B41RYjfiOSXR/gJf17FO5fI+xBaucQjQGfieHnvFOQ9yqbLzxEZs+7s8G3hqhR2qKbs7h5hOqKX6A18qnQ25j+YAJajKfcEn2VMTcpL9fffBnYa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773188404; c=relaxed/simple;
	bh=nyTBdDBZDMdBv5UTF9+K1VmhuSEZ/x4yuEEQShTTw+k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sIapPatgeyg0ZQmqNzxBr628zK/XNsLzyJWvZ5XaZf/aNdeipyGABJ4eZt68kAalHr4XToeunVsvJRWKWAFFtdr7XuUaHy57GB2P1qL17AxFMa4xr2pZ9ZmFH+QIkUoWtyl0sOUQ2jEgGxgU4WwJNnSjBOSc6RB6s358Xox6z2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lAvQkBxv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lAvQkBxv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EF1BC2BCB2;
	Wed, 11 Mar 2026 00:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773188404;
	bh=nyTBdDBZDMdBv5UTF9+K1VmhuSEZ/x4yuEEQShTTw+k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lAvQkBxvUuwslzLb3KgWP/F4OVqRweihfyCuFYlqZUSftqBzgFjkrm92a6N2fOIb5
	 2lrBl3CI/Uf/k9bfvFTz+oFac286ctDyotxg7JlALgBxKMhSPgAWPAzc4zAuJQB0Jd
	 p+NS/5ZWl4MgVVNOcfMQrR1N30716slXwt6KU0xnx65hIf8l7umfP53ATpWBx441lO
	 2j8Top3BIXLTLhe4p3dDLuo7enAwRlADzxon1SRLX3MUOzlxzE8DJFzkJtZTKBS5/M
	 fqiAJ4f4GIjDVxZGB9GwjerxPMJAX221gdJZLKBLy7Tu5knKdG8a94/y70bfEz6iCv
	 fd82DplX38fNw==
Date: Wed, 11 Mar 2026 11:19:58 +1100
From: Dave Chinner <dgc@kernel.org>
To: Lukas Herbolt <lukas@herbolt.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, hch@infradead.org,
	djwong@kernel.org, pankaj.raghav@linux.dev,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: Re: [PATCH v12 2/2] xfs: add FALLOC_FL_WRITE_ZEROES to XFS code base
Message-ID: <abC1LvRElctaHPe5@dread>
References: <20260310194245.848034-2-lukas@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310194245.848034-2-lukas@herbolt.com>

On Tue, Mar 10, 2026 at 08:42:46PM +0100, Lukas Herbolt wrote:
> Add support for FALLOC_FL_WRITE_ZEROES if the underlying device
> enable the unmap write zeroes operation.
> 
> Co-developed-by: Pankaj Raghav <p.raghav@samsung.com>
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
> ---
>  v12 changes:
> 	split from xfs_falloc_zero_range() into separate function
>  fs/xfs/xfs_file.c | 49 ++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 48 insertions(+), 1 deletion(-)

Ugh, I just reviewed v11 and pointed out how unnecessarily complex
this new "three phase" method is.  Please given people a chance to
review the code by waiting a couple of days before posting a new
version....

My comments against v11 are still relevant; working around low level
truncate issues when calling truncate to transactionally update the
file size is not necessary is less than ideal.

-Dave.
-- 
Dave Chinner
dgc@kernel.org
