Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C7810F1
	for <linux-xfs@vger.kernel.org>; Mon,  4 Nov 2024 05:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730696987; cv=none; b=lmKa1VRBc9lR1UnpUzU2Fiutc8a2f4RwdEJLeSg2wGd+zNPEAy+YXaaYtoxcsTpGleDxArNEgxuyuN3fiOk3/uWNFw5PTxFwABLO9uhuGyUpeW+jUpC3VTrLmxPfqBXZkdWvPNbZwjtxVzgsuRF+t3qOxJxVnIbwtP1o+QmyD3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730696987; c=relaxed/simple;
	bh=A0zBjcUZGJsZ3ZsQtRj3lrL+Qbfwd0TlRc45nRO1IEw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ScKYJSn/+Yb1EtGj+Rolk3rPjzGAHy8fWNGU5gJ/FFa9hOKG5E8YBGPXTFzRkhiKGsyp9r8fOIz7b/0DFcJKzKo4q8JP/8epffogDj1GdqkJW1Zq1fa7XxR30+Od/eA1S5oyYp6D05dgufif+ubMD/fA9bn9Rinb1I9URKguLuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=teK8gnHp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="teK8gnHp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DA05C4CECE;
	Mon,  4 Nov 2024 05:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730696986;
	bh=A0zBjcUZGJsZ3ZsQtRj3lrL+Qbfwd0TlRc45nRO1IEw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=teK8gnHpbNHrO0y6PWM9gBkECBvBEiG84FvdtRO/2v79z37aAcBZ/3u6h7p0SxnTH
	 1wx/0rc8s+zMT3ZTiHz5dvusq2RKHY6gejCyrkRrV19tv3rE7tB+Ce2uYKZczUkU9b
	 hdZHCg4A74AyhTSei+Bk0N4jOJ9tOVQo0mJ97Z3llMok1Fdz7ycr3ZSp0TvS6wyh6H
	 0V0OCJ7cUIhlKY/VyzQronLjjSsXowy6NLjN73vQuZUPPbDcGhyAhHDPxoJi3Wsv1c
	 O9SMios8OviIMJHtkzZmcXReauUzJtQB5udHqbuvasw1xNd/HiNtA/yXc5CjTQSUPc
	 sKnVRzvNH/FoQ==
Date: Sun, 3 Nov 2024 21:09:45 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 3/3] xfs: port ondisk structure checks from xfs/122 to
 the kernel
Message-ID: <20241104050945.GH2386201@frogsfrogsfrogs>
References: <173049942744.1909552.870447088364319361.stgit@frogsfrogsfrogs>
 <173049942802.1909552.3233838341241015760.stgit@frogsfrogsfrogs>
 <20241104042904.GC17773@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241104042904.GC17773@lst.de>

On Mon, Nov 04, 2024 at 05:29:04AM +0100, Christoph Hellwig wrote:
> On Fri, Nov 01, 2024 at 03:19:05PM -0700, Darrick J. Wong wrote:
> > +#define XFS_CHECK_SB_OFFSET(field, offset) \
> > +	XFS_CHECK_OFFSET(struct xfs_dsb, field, offset); \
> > +	XFS_CHECK_OFFSET(struct xfs_sb, field, offset);
> 
> Despite comments to the contrary, xfs_sb is purely an in-memory structure
> and nothing cares about it having the same layout as xfs_dsb.  As we've
> kept them in sync so far I'm fine with adding this check under the
> expectation that I can remove it again when I finally start removing
> struct xfs_sb, which is long overdue.

Sounds good to me -- the only reason it's here is because the current
codebase requires it.  And that's only after years of djwong-wtf
actually having unsynchronized xfs_sb/xfs_dsb, so I think the codebase
doesn't even require it, but I've not done an exhaustive search.

> Otherwise:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
