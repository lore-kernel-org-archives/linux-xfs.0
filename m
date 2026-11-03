Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.84
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793710016;
	b=DnMgAfkLLAuWibO51ZD9hJXuSu8Jx/Uk/aFw6F0FpdIbCA1xoMcAaWCASUP45gk5gPkD
	 M/yoH/wDOPEZr6wH9VtWTOB0gsDzEG+uDvie+gAlEk4uq+cBQ3hRlwvp//EPdtjrtSzk9
	 hyG+jhvBV5rxmOhUuvu3JO2ihoXexiczHE2SuvmQEHPIdxe3WJxRPM2c33frexEpPCapS
	 KX0Qu49gtl9pVoTZR0DcyDLAnw5jbWEwNQCRke6yCG9zAxwZ2UVQuPR+SG+WaUn7bmTbM
	 UYOQD8HJleEUPFNrwDIdrOMOD9K780iggv4G9Y+gGIikDtL65ewsvOf8bA0tUBjhWTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793710016;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=DASIdY7ozb8QRWdAKjgC8Qe8mgAnSZ4YQR5TtXOmDG8=;
	b=xI/dVsWK6FH/JIGwiUA+fCq3ijJDNjLSxOBbQ1HjQaomhtu3p2qge7DbKvRylW1LxIKs
	 Z2AbXFvSYxnRs0JiGlzF17P+UnMqmClZ7YFoUGdhSz0fjOMo7a+FILJgSs/oBvS2KbiUe
	 2IabeIWqPK6zo+FaUALOclQGeOPfEdSjXyfz/NV4Bq07Szejgj034qskYW/Mm39nycaqL
	 2a5DQ66OMAIDDze+37hUgVNzf747OCiQb7a+a2xYnG5+0jE3BozM7cseJEbyhBBU3GCC4
	 U8uCRblCGKg69UdkjO2z3FV7d8/oPAGp5JdeRPnjf1EDY+wpJhO7MQcyrOo28lWb+uw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=VVkgiP4x;
	arc=none smtp.remote-ip=91.218.175.84
Received: from mta0.migadu.com (out-84.mta0.migadu.com [91.218.175.84])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2221D606A324
	for <linux-xfs@vger.kernel.org>; Tue,  3 Nov 2026 12:46:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2221D606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=VVkgiP4x
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=1XWvcrbaywo/oaZGKtDEjEZr71lw+5bb33eZFqUboxI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793710013; v=1; x=1794314813;
 b=VVkgiP4xzRv9UgvySsIN6NNxQKs56Z51mdPRm6ffqkW/h++z6vTPj/11Q0HLqZxbxNnBGOC1
 L2OJ4kiSVEbTG6Z5l2P05qx5tmgAaQi9Z/CcZunI8n3YrP1mA6h6I2NM8sMx73xb2oFhIScUkYd
 DmNaW7ZLoyn5d1u7m/I/XvW0=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 458b8aa09961ad92;
	Tue, 03 Nov 2026 12:46:53 +0000
X-Mizu-Trace-ID: 458b8aa09961ad92
X-Migadu-Flow: FLOW_OUT
Date: Tue, 3 Nov 2026 12:46:41 +0000
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: Daejun Park <daejun7.park@samsung.com>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, 
	Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>, 
	Dave Chinner <dgc@kernel.org>, Pankaj Raghav <p.raghav@samsung.com>, 
	Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, Dai Ngo <Dai.Ngo@oracle.com>, 
	Sergey Bashirov <sergeybashirov@gmail.com>, Andrey Albershteyn <aalbersh@kernel.org>, 
	linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v5 5/9] xfs: cap the block count of
 xfs_iomap_write_direct() at one extent
Message-ID: <ap5wwux6rmzcq4uf4tj4nnsv7h3sdriolux5h4rqo4evy4tpdm@qj6gfmix4fu7>
References: <20261029-xfs-pnfs-batch-v5-0-ef8d2eafb7fa@samsung.com>
 <20261029-xfs-pnfs-batch-v5-5-ef8d2eafb7fa@samsung.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261029-xfs-pnfs-batch-v5-5-ef8d2eafb7fa@samsung.com>

On Thu, Oct 29, 2026 at 11:23:02AM +0900, Daejun Park wrote:
> xfs_iomap_write_direct() reserves blocks for the whole count in an
> unsigned int. For a pNFS layout the client chooses that count, and an
> RW LAYOUTGET for 16 TiB wraps the reservation and shuts XFS down.
> 
> xfs_bmapi_write() maps at most XFS_MAX_BMBT_EXTLEN blocks here, so cap
> the count at that. nfsd asks again for the rest. The other callers get
> the same mapping as before.
> 
> Suggested-by: Darrick J. Wong <djwong@kernel.org>
> Link: https://lore.kernel.org/r/20261008154017.GO2705364@frogsfrogsfrogs
> Suggested-by: Christoph Hellwig <hch@lst.de>
> Link: https://lore.kernel.org/r/20261015060932.GD14035@lst.de
> Suggested-by: Pankaj Raghav <p.raghav@samsung.com>
> Link: https://lore.kernel.org/r/atoImJxtg70XcIjS@quentin
> Fixes: 527851124d10 ("xfs: implement pNFS export operations")
> Cc: stable@vger.kernel.org
> Signed-off-by: Daejun Park <daejun7.park@samsung.com>
> ---

I know Carlos already merged it but:
Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>

-- 
Pankaj
