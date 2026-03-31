Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6070C39D6C5
	for <linux-xfs@vger.kernel.org>; Tue, 31 Mar 2026 19:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774985938; cv=none; b=VGVzUg0yxiZzq3JCADtnN/w1cetk6Auk6snJ2Sx2D4gPXxM2PlcJKfCVe3mUT+pIGH36LUs0vtMpgVTO1vvccyIEdPtA9OYzax2OPqZ2lNHz5AiVRcnChL/exSDI8l8mAGKdUGBBqUBQ/rzBCsdrxomL3v8Ha1ZLkZRGnaDsIIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774985938; c=relaxed/simple;
	bh=ckzEsdR3vjycu/CEYS4BEpse0KKMSWIRz20Pz67Bb2w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rvUaFoDDfil5fW9wV1SFp+w394hPy0+4dwRlsFnlonjvr5IkBcmqIKB+uVhbL5eDyJ6XtWxvXuO0sSAJ9J82yvZjKw229AGab7DtPL48JQGwFoasIupCoeW5/QAnjKq0BRvcoWCF7olZRdM9Y9VcX6y1mBxjgUqKYVuZ3iZWalk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gOFesJjR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gOFesJjR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43C8FC4AF09;
	Tue, 31 Mar 2026 19:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774985938;
	bh=ckzEsdR3vjycu/CEYS4BEpse0KKMSWIRz20Pz67Bb2w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gOFesJjRLrK8gX6TqKbLZCHJx7ZDvzA+Kl6M6JRjE8qOhxSfD0tjwM0uB2yFF3+av
	 J048kzrWPCzi+iOvjDxfDosSsTaQioCK5+G15ujXTuM4C0siBk8LWBAZVf+HssIIcK
	 Bf7OEOMjPvyULKutvRSfwnspZpFcTKOHvUjGgyxclb9UMQqyoosoo343wjiorwN5fp
	 tMx2Tkuf5qJghvAFqa8RU++9MgnY4Vw8MyM5gZIVmul+4f7mWY2ePIkD3s/PdGWCiD
	 ilmzre4HR5s3S7peJMdYOfMvk+uo4ZPEKl4XwOt1mjX6rKxFJtHPguyI+RqTysRf2g
	 V1ty83Nn1/3DQ==
Message-ID: <cf233e13-baff-4a7a-9e18-6ad2665f3f40@kernel.org>
Date: Wed, 1 Apr 2026 04:38:55 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] xfs: handle too many open zones when mounting
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
References: <20260331152617.4047908-1-hch@lst.de>
 <20260331152617.4047908-3-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260331152617.4047908-3-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/1/26 00:26, Christoph Hellwig wrote:
> When running on conventional zones or devices, the zoned allocator does
> not have a real write pointer, but instead fakes it up at mount time
> based on the last block recorded in the rmap.  This can create spurious
> "open" zones when the last written blocks in a conventional zone are
> invalidated.  Add a loop to the mount code to find the conventional zone
> with the highest used block in the rmap tree and "finish" it until we
> are below the open zones limit.
> 
> While we're at it, also error out if there are too many open sequential
> zones, which can only happen when the user overrode the max open zones
> limit (or with really buggy hardware reducing the limit, but not much
> we can do about that).
> 
> Fixes: 4e4d52075577 ("xfs: add the zoned space allocator")
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Hans Holmberg <hans.holmberg@wdc.com>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
