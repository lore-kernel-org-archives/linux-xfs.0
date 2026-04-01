Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D8C2F25F5;
	Wed,  1 Apr 2026 23:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775086594; cv=none; b=j2uIKrz0eq2W6L5wi0Xw0MHHw+vCzkddeyURUolN9NODn/i3NAEdATC6GwoRE+VM2ZHfknd2nFqpD0qzKmGlx2xWAeHs3JAGugEQqUkqdNAd8gJzjBGc5JnRj7fV9HzusjLny7bvF6Ejk3COZ95/QvOjX5FSI0yCMZO/XR56M14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775086594; c=relaxed/simple;
	bh=ycGJXVbkzn7fjheMc4OWJv/d8Qf8+icFTrjAGQu+PYY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BCzwa6vNJP2ovMy6n4GhUmE8+5UXLV9CZ1ocuX3MmRo2Wt91mLesdYGyMTst/YzXx6Qjkzhki/+WrP4cv+w09JyL9faNTbS5YrkwJJ7BhpAylWJbLT9BSaYCdLVlFPFiFBB6ycdoxmulPgRFTHkGk3z/zubUIJe0qftMbeyawhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BgKk0rA6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BgKk0rA6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B1D4C4CEF7;
	Wed,  1 Apr 2026 23:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775086593;
	bh=ycGJXVbkzn7fjheMc4OWJv/d8Qf8+icFTrjAGQu+PYY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BgKk0rA6/fxQhGIcKv8FeKkLx9QG1BOmW5LafU7rNPUStTaSQn12Xp8PXpvooraBj
	 VVDPsKmF/xPhrCMm3PYk5eL5mc953y+lTRa7hYSENFIKK5j7GrTMsA2S6+O+6mxXvL
	 25+bmqUU9f/9voJCxEfJ7dt5YJaAHIEkZrlTwl242SvCwYxN6LvHPBEK5DLynMTMZP
	 1bpXYt7i5KnQDbH69KIMmOVcco+RRfaPi6y1Q2e6QUk/JeNbmFJOJEx89QIe3e+DFr
	 1dlUSaYB1WTMcq22LgE4xJ48aor/7AHPOO2RKoo5K6B2dd+IsmDe7VubwMOaqkpmz5
	 txzsGK8QoS5WA==
Date: Wed, 1 Apr 2026 16:36:31 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v6 04/22] fsverity: pass digest size and hash of the
 empty block to ->write
Message-ID: <20260401233631.GA14247@quark>
References: <20260331212827.2631020-1-aalbersh@kernel.org>
 <20260331212827.2631020-5-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260331212827.2631020-5-aalbersh@kernel.org>

On Tue, Mar 31, 2026 at 11:28:05PM +0200, Andrey Albershteyn wrote:
> Let filesystem iterate over hashes in the block and check if these are
> hashes of zeroed data blocks. XFS will use this to decide if it want to
> store tree block full of these hashes.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Acked-by: Eric Biggers <ebiggers@kernel.org>

> pass digest size and hash of the empty block to ->write

"empty block" => "all-zeroes block"

(it's not empty, it's all-zeroes)

> + * @zero_digest:	the hash of a merkle block-sized buffer of zeroes

"a merkle block-sized buffer of zeroes" => "the all-zeroes block"

(to hopefully make it clear, as in patch 3, that it's the salted block
hash, not the value that fsverity_hash_buffer() gives)

> +	 * @zero_digest: the hash of a merkle block-sized buffer of zeroes

Likewise.

- Eric
