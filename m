Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794410221;
	b=41NWh3GerEXZHeCeVl1NfvNlMsOkuJoTv6fkyGO5FsbDmxrEofhQ4GKJkpiKY3JiIqF1
	 Tp31f09yiveoHTcmYqQv+CjznLszbqAYA/G1lPSrqbJJXF5IkbW6sA7FAjs7HjP48v7ca
	 VzLKUuPbCeKpo09iVk1RapSy/XaOVVgf1oC2IqkCUnfP8qB8ggEJ049zLTz+eMSy7WPwF
	 jSqGePtl+rHOAewcyWkX9t9KyLcyPSPQy30eTVLnhFhyLoD1QnQzWe7YJvobL0/Y04FuN
	 alR3WxMfJN3U1ucP1qbBfms1HWQbrhmKpEdVDvrc4REOIlQ6fukyUo2mLUTcvCD6IRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794410221;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=ZyvjiUVTS0LNy/JPrAGB8jKMGYRt1C2Vqacsl8yy9CA=;
	b=Uzd1hmQ0+Jf1up7yQIsQZukzD+GBeQr90J5RxDi27NWjcpxTrEWu13ds7Msu3UBd0Tkp
	 eMnIZgMEjXF/FjIvjBWaKwJ0t2sUvbn6iQ7Z6l63L/JyHF2mxS2YjCkBkjcvLYhpaWeAm
	 glLX9RDxEhMP2vhz8NKX7IAUosdngW6mbiCNcgXndoaI6VYEqv9BQIKW++bddLp8hUdTW
	 ognTUHsou2liT5Shw0bboa42mJv0H0Fa35cqifnEKQVMToI8qzadVcQhse9PBHqfvJ0nL
	 AKg6eOVUgoSaPl3yZyXTRg6LswBhDjsN7ylbWQbvPFFuK4/Id1pjJT2edGzrk7zACXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=1H+hwwr4;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA2F606A32D;
	Wed, 11 Nov 2026 15:17:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CEA2F606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=1H+hwwr4
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ZyvjiUVTS0LNy/JPrAGB8jKMGYRt1C2Vqacsl8yy9CA=; b=1H+hwwr48v0e45F9+jd7s+bPDV
	M0O+Qvg4caqNE6ZcM27paTBQJmUa88BqEPiC6SHYScXaudA5gCBvcDcBZpZW4OULRIZ6ZDG01m7VN
	FB91ol0uR3DQsmF+ogTP+MSXEW7dns5F98KxMzOcqkfmc8ndDR+3Mo7sLbsos6dz9HPy4JX+kH7Yl
	Rh2wBMRemILuklmRUkWQidH7Syh4DYNhEGXhOcyaFbRBY0OV1b25hnWlN6kxyE3EPGImCmU7hyXEg
	kNJeyAT2Y8oPy6MEjyQwYo1/CdBm9NYgBp7YI2vquibhH4M7JVCMRSYOf4bACTIISptWAWhYIRLtw
	laVcldvw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xRA4J-0000000748L-2Dxs;
	Wed, 11 Nov 2026 15:16:59 +0000
Date: Wed, 11 Nov 2026 07:16:59 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Chris Mason <mason@kernel.org>
Cc: tytso@mit.edu, cem@kernel.org, david@fromorbit.com, jack@suse.cz,
	djwong@kernel.org, josef@toxicpanda.com, hch@lst.de,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, tz2294@columbia.edu, brauner@kernel.org
Subject: Re: [PATCH v7 11/11] xfs: restart faults racing with realtime flag
 changes
Message-ID: <avSG6wYENgEmN2e8@infradead.org>
References: <20261110190417.32650-1-mason@kernel.org>
 <20261110190417.32650-13-mason@kernel.org>
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
In-Reply-To: <20261110190417.32650-13-mason@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Nov 10, 2026 at 02:04:29PM -0500, Chris Mason wrote:
> The fix used here is to test again under the ILOCK, before blocks are
> reserved or allocated, and to return -EAGAIN if the flag has changed, so
> that the fault starts over.

But non-fault handlers can't really cope with this EAGAIN, and it seems
it could trigger for those as well?

