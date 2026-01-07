Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39BCE332EBB
	for <linux-xfs@vger.kernel.org>; Wed,  7 Jan 2026 17:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767806549; cv=none; b=tzyJ1Wc5G2HMrCUJUq3A+/uc+GAxZzv37Bagua8KFhKnbDFKc03BNom0QjfQSduZO/CVavnNVr6E03gcn64Wig4fvPjPx5LJjlHDJv6FKjLMnvafqUfTND/kRSKny2SDWPeYOeOQHyfKzgJvDhk4voIzb3sWH5QqvLQydvAMnrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767806549; c=relaxed/simple;
	bh=u9IS1Pvu6E8pY4bIebXJItQXovXREjibnjdHilX8itA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k9mU32NR29JBBJKOz5mhfk7ljoMPG2HIRqCFhn7ZRlMfhJyPkW6uVCOM5UsSVnTe1gi38M7gvzRo5Q36vns4qTLlhsO93VqB/ZUEY3enpK43Prvk4UrOa0wQPWauFeBVwNYVKNaIJMQRFj2Yy1I4s+GAt0kmXi8eXs2FALARWg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KoA9xVYM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KoA9xVYM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DA64C4CEF1;
	Wed,  7 Jan 2026 17:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767806546;
	bh=u9IS1Pvu6E8pY4bIebXJItQXovXREjibnjdHilX8itA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KoA9xVYMmMw3h6wjXbbU7FQmpU8pznU4OVl+L+owrSd7YeiJjtxNQY8rW1HNf/Gxd
	 4D2HxzM7AT3FGjznXfeUkoi2Qm8Ok8PYvy5Ome0IplvobpnrmHS7ATCumfS5i6bsQY
	 q/WlMA2WV1bTWGchpMjFBBKdZ9mah4tASPLEtQv4nE6+AHRedN4W/ZhF8/SqTRVHU1
	 09hTt6Drxtm+68tKp8O28jRMuDtBr6ltJteL5NOE3WOYkBQltd+hNN5OBc+X9WcqAl
	 qr+rIL4yhYZ6Jn2hM/St+eJqMFltVz+3Wx05PT2EEWQZKkjV+UKDI5GuDDkSTwzbwQ
	 D582z2sgIZpyw==
Date: Wed, 7 Jan 2026 09:22:25 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_mdrestore: fix restoration on filesystems with 4k
 sectors
Message-ID: <20260107172225.GD15551@frogsfrogsfrogs>
References: <20260106184827.GI191501@frogsfrogsfrogs>
 <aV35OUeSf-g99rbY@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aV35OUeSf-g99rbY@infradead.org>

On Tue, Jan 06, 2026 at 10:12:09PM -0800, Christoph Hellwig wrote:
> On Tue, Jan 06, 2026 at 10:48:27AM -0800, Darrick J. Wong wrote:
> > +	/*
> > +	 * The first block must be the primary super, which is at the start of
> > +	 * the data device, which is device 0.
> > +	 */
> > +	if (xme.xme_addr != 0)
> > +		fatal("Invalid superblock disk address 0x%llx\n",
> > +				be64_to_cpu(xme.xme_addr));
> >  
> >  	len = BBTOB(be32_to_cpu(xme.xme_len));
> >  
> > +	/* The primary superblock is always a single filesystem sector. */
> > +	if (len < BBTOB(1) || len > 1U << XFS_MAX_SECTORSIZE_LOG)
> 
> I'd use XFS_MAX_SECTORSIZE here instead of open coding the shift.
> 
> Otherwise looks good.

Fixed, thanks for reading! :)

--D
