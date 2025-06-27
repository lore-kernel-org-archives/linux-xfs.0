Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A751DFE1
	for <linux-xfs@vger.kernel.org>; Fri, 27 Jun 2025 13:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751030039; cv=none; b=XCwIg+aaL1eghxyGGUR8kyFMpSF0S944RbYd5JY91rwO7Lb6lX8xoKUEFw8xlzjsalW5lrna0HCm+fTQAK5XA1OMkeiDqWQFjqmzluCunq7RYg6O0vykQrHwvsv9Lpc0YYNFZPLs+AoWZXnFl1e+hbouj0DHHnYB6cK1icxBt9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751030039; c=relaxed/simple;
	bh=8u/wxlnqTmiZQ5j8bvXe03fr6vY35UW8uGYyZqlDKQE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lbrT/PLWmn+dDqZYchzoeiDYci5AjmYM+5kmXhyCHlAbaATLPW+yT5CMwYrLlLHhA9EJ6JQcH6tMZ+pL1ApNWsIg/qVq0GDJAQot4fepYL2RpMpx/INZffNZu6PSVrTMOmjReUZ8u2ZqJhURx/pPkKP0IVUUIsDsZ/B1Gurp1Fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dsTlUZn8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dsTlUZn8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E2BBC4CEE3;
	Fri, 27 Jun 2025 13:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751030038;
	bh=8u/wxlnqTmiZQ5j8bvXe03fr6vY35UW8uGYyZqlDKQE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dsTlUZn8kBFeG6setw0eKw3pzbzjkWX3uW7Lm2DSUwnexdlmYoHTegZCG3ldiyPl5
	 +Uh80wnCJamsVt3nt6ygUo+EzzWbgBHIio0lLkLsayfJqNPtdg0lkcMuWsy0eR2ja+
	 froQjDc2QOHUz1zceOcjLtzJ5lfln/3156n7sZmBTcIjpRtuPXomju3K8VkOVanCqY
	 hMKBCHcZHAqSNPqPexJ7U2ZnDtGDJnAAI0nUiz+AYc54is/HlyBVhbVWgyHdVHaZET
	 CGY2PB2G2OB46QKCngDab2vPoqta/GqZz7AE9GDDWn1Flbzr/dYb266POuIpE+YcsW
	 sAsgHLFMd1dlQ==
Date: Fri, 27 Jun 2025 15:13:55 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [ANNOUNCE] xfs-linux: for-next updated to f259584cb40c
Message-ID: <k2jkeacuav6orgxae3sflzgeszc2wfmffjhhu5okjulkglcnvn@2gyui2k6htql>
References: <hyw5332gxstbro2j5lswrypary3h2snvozqw5tszboku4trals@3x3wntciy3bi>
 <_qWWont5Uiw8o6UT-bt1v6DA5p1jvtb_2N4kdjoRU7zexNFw_ubgNBvkKhS-wEMgOVbyhl_2qrHucLqn6RRJNg==@protonmail.internalid>
 <aF6VYKOp4JutnLme@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aF6VYKOp4JutnLme@infradead.org>

On Fri, Jun 27, 2025 at 05:58:08AM -0700, Christoph Hellwig wrote:
> Btw, I assumed you'd send my fixes from three weeks ago to Linus for
> 6.16.   Do you plan to wait for 6.17 or did you just not get around
> sending a pull request?  At least for the zone allocator shutdown
> check that would be annoying as it causes hangs during testing.
> 

You meant the ones we already have in for-next? Or did I miss something
else?

I'll send them for 6.16, I was just really busy past couple weeks to
actually prepare a Pull request.

I'm planning to send everything we have now in for-next to Linus on next
week. I can send a pull tomorrow with things already staged for a few
days (i.e. without the patches from today) if you need it urgently, but
I'd rather wait to send it to -rc5 if that's ok with you.
