Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2B93563FD
	for <linux-xfs@vger.kernel.org>; Tue, 27 Jan 2026 15:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769527524; cv=none; b=Nj369wx5TayHvMNRPVGUu1XpNnh/9Pa8Lh17uuQ1W5TzR18clWw055lbIfzNzSOvmZ86EOwvDXdXBHDjZdJrJ6r3OXDwM3cRD1QSbIBCjtRvAhP1gDAWc3KZnFGOBdSa+d5qrJFlK1GyBQJDK1hWj+4e0SRLvRTkkbR2c6/jOUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769527524; c=relaxed/simple;
	bh=liq94AI8EkksOnpd1jkRL4GMRcD3QFWOVjOep7JZs+U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vDtjd70v45LFwHa5OdINj+k1fZnaHSU7DjrR4fxTLFahqVBOiLAnyBtWR9HGp8ulvX12E5iPmXxrznJRZKBhKypPWGR9Bo88/zc2XarKWK+Pgh3HshMfaO1JPtVTWHVgNI6s8Usq0fYwd1mis/gz4OtAA/8/ZRgIJ+lyyB7gC/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YWs7b7cH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YWs7b7cH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84DB1C116C6;
	Tue, 27 Jan 2026 15:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769527523;
	bh=liq94AI8EkksOnpd1jkRL4GMRcD3QFWOVjOep7JZs+U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YWs7b7cHfaEItIv4ykPS7jeTq53iorWU9wiMafL64Iqtsn/sd44a2/oTAoG+W6rro
	 JzCz13B2Jk8ZvQe6LYIz5fhXi/dm9V9r0rB3Fyy2oLAwXh8j1ki0ibrPD8zrg6F1X3
	 ZiZOpqmeHSWUXZEjp3frlZsg5CmYBYQ4Go/4JiDsXtgMsG8vLyrRPWs/wFN/CK1qE5
	 6gynHd3QHGJLdsWQ8G/06+XRHB0Pj9PNIqGQv1p7UNqiIsFbJj7XZwN+1IPQE5UXZc
	 UaVSzuIqk8BEcMSv3/35pL4YWZJ/hUvx6v79LGhL/IjQGK5SaGHpOzVzYX4/7V09nC
	 o7KYDE4oYq4xg==
Date: Tue, 27 Jan 2026 08:25:21 -0700
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	"Darrick J. Wong" <djwong@kernel.org>, Chris Mason <clm@meta.com>,
	linux-xfs@vger.kernel.org
Subject: Re: zone GC ringbuffer fix and cleanup
Message-ID: <aXjY4ZECqTxTQhTF@kbusch-mbp>
References: <20260127151026.299341-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260127151026.299341-1-hch@lst.de>

On Tue, Jan 27, 2026 at 04:10:19PM +0100, Christoph Hellwig wrote:
> the first patch fixes the empty vs full condition detection in the ring
> buffer as noted by Chris.  Keith had an alternative version that uses
> overflowing unsigned integer arithmetics, but just having an addition
> counter as in this version feels even simpler.  The second one is a
> trivial cleanup in the same area.

I checked out these patches earlier directly from your tree, and these
look good to me.

Reviewed-by: Keith Busch <kbusch@kernel.org>
