Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 177593C4B63;
	Tue,  4 Aug 2026 17:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785865577; cv=none; b=UNL0jaDqLzx3fwQRm1UbNR6TM/NqEvBVoGfv093M20Nb0eGklkfsgdF03eexQU5oJ5M3qAyXoUhwhrOEu1jNrTBJaQGdt4V90EP2mUFiLmwxGvDo3NIuGRAnxsorrd/nq+tyPoqStmvWJOgk/sckieK94d8t9m7MRoAOWATNp5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785865577; c=relaxed/simple;
	bh=u2vXO4ino1w/gh9HCRjct8THORPdoU8579LxlRLUiU4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XD6W9K3ZdFd/cMe7ScMuDPL0HZZf/Pdve56xHUt7WWbGdP9h3ViiUTSS+Ob/kpQbJd0T3VmcNpmvNZY8vXLP3Lv7+u59AfwQ0gQHhZte9QAeb6cGQchunSV4kEWutN2G55FyXGt4VhFcWYuLIT1qhx7BcKXtk0u4rHuXq6FNNEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HZt5y+Pv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HZt5y+Pv"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D9E8F1F00A3D;
	Tue,  4 Aug 2026 17:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785865569;
	bh=K4cHcpbvkJp+C4fsUhABEua8YeBw9Nuv+CZMYDm3C8A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HZt5y+PvPT/b2DkcdfuGd1WCrUFgcDZ8YcwZTGqZ/SHbGhUA9qHT355o8QVUb4kOf
	 jWjl5bswTWHAHy0Yg0yzVtA6379+f+nOvrIxkXr+mg9yx22jfBHrF9zD94FXG502wu
	 i02HDw8EU88NV/DyoANaR2DzsUGWiaI3BQB2y8me+WeXUQE4lAWLUPtOes0ay83IV7
	 1GHK6ykqb1oQSZEcXeBb/3THbGOntelBLuqxjii6jeGz3034CXNe9lwerJzYJbVUNZ
	 V4FTeqW7ld5NDJBIUASX1uErUTTVSjqLejf/vxSRyYa4bt9dMPirPZjIEi+r6iEIl6
	 aqMb9Ip2EtfQg==
Date: Tue, 4 Aug 2026 10:46:09 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/2] iomap: iomap_bio_read_folio_range_sync is missing a
 call to bio_uninit
Message-ID: <20260804174609.GG3556460@frogsfrogsfrogs>
References: <20260804124404.737145-1-hch@lst.de>
 <20260804124404.737145-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260804124404.737145-3-hch@lst.de>

On Tue, Aug 04, 2026 at 05:43:58AM -0700, Christoph Hellwig wrote:
> Which could leak blkg references.
> 
> Fixes: c03cea42149d ("iomap: add initial support for writes without buffer heads")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Makes sense that we have to uninit that which we initted earlier;
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/iomap/bio.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/iomap/bio.c b/fs/iomap/bio.c
> index 30ef78a66b4f..48100c614431 100644
> --- a/fs/iomap/bio.c
> +++ b/fs/iomap/bio.c
> @@ -184,5 +184,6 @@ int iomap_bio_read_folio_range_sync(const struct iomap_iter *iter,
>  			error = fs_bio_integrity_verify(&bio, sector, len);
>  		fs_bio_integrity_free(&bio);
>  	}
> +	bio_uninit(&bio);
>  	return error;
>  }
> -- 
> 2.53.0
> 
> 
