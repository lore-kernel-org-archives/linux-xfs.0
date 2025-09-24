Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5BC852F99
	for <linux-xfs@vger.kernel.org>; Wed, 24 Sep 2025 00:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758675235; cv=none; b=pqHU0nYqwgWI/hVUxkl3Y0asYsz2n54kzVPn9oNyv2v/AouvRb56zFeZnqjCjjfpbIW0MaLNrQp0pjPenNtfPCLZIHdOXX2dFtS21SOVbx+2HivnIQmFK8P/2wDQzyatAY+GYpBUQ++0JbyzF5g8aNbkIK6/fbbh2QFs+ACZl+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758675235; c=relaxed/simple;
	bh=Wg4O6CNMZoHlviaiO2bZ6Vbi9Bea5eKInpn+wXdxP80=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O1YWSO3ot6tLMnt7WF/TA3CfYKEvvVxwhZCRY2E7gvrhuWn+3eHOeJoet4V/wCeL0S4YFmJuorfnYyBxnB1O7CmEs6f3PW4n28hNamtNloXW3rNZS4vj2wBJ37xf060dkCvmVVHz3n5VXNgaI2Xh9l4NjXnZzIa/q55ny03PIK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XB8Q7Bsx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XB8Q7Bsx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D26EC4CEF5;
	Wed, 24 Sep 2025 00:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758675234;
	bh=Wg4O6CNMZoHlviaiO2bZ6Vbi9Bea5eKInpn+wXdxP80=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XB8Q7BsxGP7LCD2oFvm1hEFC0Wb5Xal8VOiRp3xttftH6XZq11nHmdLxJbybfSckw
	 mM9xq0Ns5U5IQtdAoJJBEMoC4ZN1HHZrdqRvTPJ2nwV7r85KMkl/aOMNe0BASdjDsc
	 rXv+U9CaYyN5xiOzdjbu2rHoIAOgquzIqlAOsDJ9eDTDoyKU/G1EuJsEgJZgXdXyjC
	 pC32rrtN1s90mwmVtIqpRlP1JhV5AYzGVugHfhTQy8SloPmiosYeIETaHLEEEhEmTU
	 hI26XvmTn4h2QbRePpO3qPT2A4zmhlrq4F3MdrGmgi1dbgB4jgFAcMgMkk2AlfDzQ7
	 iRJIBdmgXXIPQ==
Date: Tue, 23 Sep 2025 17:53:53 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	"A. Wilcox" <AWilcox@wilcox-tech.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs_scrub: fix strerror_r usage yet again
Message-ID: <20250924005353.GW8096@frogsfrogsfrogs>
References: <20250919161400.GO8096@frogsfrogsfrogs>
 <aNGA3WV3vO5PXhOH@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aNGA3WV3vO5PXhOH@infradead.org>

On Mon, Sep 22, 2025 at 10:01:17AM -0700, Christoph Hellwig wrote:
> The autoconf maigc looks good (as good as autoconf can look anyway),
> but why is this code using strerror_r to start with?  AFAIK on Linux
> strerror is using thread local storage since the damn of time, so
> just doing this as:
> 
> 	fprintf(stream, _("%s."), strerror(error));
> 
> should be perfectly fine, while also simpler and more portable.

But there's no guarantee that the implementation does this, is there?
The manpage doesn't say anything like that.

--D
