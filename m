Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 790BA136663
	for <linux-xfs@vger.kernel.org>; Fri, 27 Sep 2024 18:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727462734; cv=none; b=tTLJu/GT1Vyan3GpvAVx7R+3QjlCzx5cdRReG0UxZ9xQrcLtRaxMIjcxmiYk8KwgBqUrrJE3+j52LS7LxkLBCa3fBJaaalFO0U8qfHw2+m2MVroSVc9DfSbA/AGtspw+TmEqH4RC9i0c/Ybb9cQ08YTKgeK+gbyQqa0TfD7/jx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727462734; c=relaxed/simple;
	bh=yD3y2QYWqGV0PCTda/Folz5wFD7bj4HL8J7Znf4G6W8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=TThq1QzTr9JJtVAfZwbjU6UuyDoye1ORih2f6dA3N+D50h0BKPE2rQ4/dZYIzQkEWJ2d6h1H7fnP8PBQ35mWnU9hKwHL5J2nGEwOQqlBTLZ+S0asM8qUyk2rUvLn2Lp3Wj177ZcPD+1jSuEl/LLiXg8gy+esPZ3sb5Yz47uKGjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XsMQqZUm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XsMQqZUm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED6D5C4CEC4;
	Fri, 27 Sep 2024 18:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727462733;
	bh=yD3y2QYWqGV0PCTda/Folz5wFD7bj4HL8J7Znf4G6W8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=XsMQqZUmv86Psw5gPsUkFgGA5+01jWTNujXHo3nYD33hsPXnTOBxMEFz2AoHbRtd8
	 nLZ5tsJmFTpujAMReqEYBQH66+c/s+Q77osT/8wH1Hnv1WvlHQRCbYnWxMmEQ22ICm
	 ewR0dgNKZqdnuAaMJB7BeZ8aFVAOXCBFWKKTS96IhOqloMvJaU2x0AcQADPsE3waAo
	 pJiZpGapYvIJt0zsKMba/pbwK0athO0AOJv2jwKXI8Yo6EelyCWdlU2p6H7ey8Ne9Z
	 5wx8zi5xdOiPJId0c6VjKrnHxk6ZNlkouryjzCwNeCDZyr9gyKx0npmAQFrWPF8l8e
	 CLPKJMURAI9sA==
From: Carlos Maiolino <cem@kernel.org>
To: Chandan Babu R <chandan.babu@oracle.com>, 
 Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
In-Reply-To: <20240918053117.774001-1-hch@lst.de>
References: <20240918053117.774001-1-hch@lst.de>
Subject: Re: fix a DEBUG-only assert failure in xfs/538 v5
Message-Id: <172746273260.131348.1696133458546540348.b4-ty@kernel.org>
Date: Fri, 27 Sep 2024 20:45:32 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.1

On Wed, 18 Sep 2024 07:30:02 +0200, Christoph Hellwig wrote:
> when testing with very small rtgroups I've seen relatively frequent
> failures in xfs/538 where an assert about the da block type triggers
> that should be entirely impossible to trigger by the expected code
> flow.
> 
> It turns out for this two things had to come together:  a bug in the
> attr code to uses ENOSPC to signal a condition that is not related
> to run out free blocks, but which can also be triggered when we
> actually run out of free blocks, and a debug in the DEBUG only
> xfs_bmap_exact_minlen_extent_alloc allocator trigger only by the
> specific error injection used in this and a few other tests.
> 
> [...]

Applied to xfs-6.12-rc2, thanks!

[1/8] xfs: merge xfs_attr_leaf_try_add into xfs_attr_leaf_addname
      commit: 5e0213630ca21fa28d72731a0d2982382a7e5ddd
[2/8] xfs: return bool from xfs_attr3_leaf_add
      commit: be2a6813d74bcf509d1c2e114444899d068fd4cc
[3/8] xfs: distinguish extra split from real ENOSPC from xfs_attr3_leaf_split
      commit: 835d458fa866c7a0f62385f099a64e185e7eac0c
[4/8] xfs: distinguish extra split from real ENOSPC from xfs_attr_node_try_addname
      commit: 1ed79d6d6d939ff7e930d8ab2ca3c7a56a5b9df8
[5/8] xfs: fold xfs_bmap_alloc_userdata into xfs_bmapi_allocate
      commit: f5aa89bbab30305d09bc47cdf78c40dd3f8fec86
[6/8] xfs: don't ifdef around the exact minlen allocations
      commit: 1ac3384880176af2c6fbfc72a3dece8c65940e85
[7/8] xfs: call xfs_bmap_exact_minlen_extent_alloc from xfs_bmap_btalloc
      commit: 13de5fbeb24f9a038a3ed2e166e940c5c2189fa8
[8/8] xfs: support lowmode allocations in xfs_bmap_exact_minlen_extent_alloc
      commit: b6d38bcff02598735e382c3a7d774548fc652fce

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

