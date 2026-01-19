Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC6AF35A93C
	for <linux-xfs@vger.kernel.org>; Mon, 19 Jan 2026 18:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768846448; cv=none; b=fB1CZwV45aawTI74DmjHnzZNxa43G997MebAfCcveKryveW5mqMpPNT+5ZUKhzRsfvQXa/0KMi7rFQFM8Fl+ujFWMGXFQMjli9k+rN8TiJzHhZd0xQQNIpugswCjVXKz2vKzPj4jAw0+tpqoTNJw2yWyN/NN3se25sbB2ilFRTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768846448; c=relaxed/simple;
	bh=B98AlSTGn+Z1Ls/G6rfXB92PLRR+0p49PqoZf8U0978=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mNEyt+89Wd37nDTBxoylg7dgVoPznMS2z0ul3R9qxXHTz1GFq2Ni8gEKKg9C9Ofl27mSDB3R2ISP7/0IjZwmpG3Rgzyy3yCyYqJkx83eoeZXVMe1zojeIs7T81WNPcAdcMsLf3hqqlflVK7U46pGiCl8Kb2qkiQMG142aCkkIbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jOiG76Cs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jOiG76Cs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DA3EC2BC86;
	Mon, 19 Jan 2026 18:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768846448;
	bh=B98AlSTGn+Z1Ls/G6rfXB92PLRR+0p49PqoZf8U0978=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jOiG76CsgT0ih2GqtAQg2xSoW/9jlBkDAqRYCLcU2fD+WW71yvgO+TH6VCXxAgUBC
	 9QCmwo9Elej8kLuGNhbkasDaUnfiiQy1DpSJXnc1kbp43UEGTy759E8X9LzjtHdH8D
	 p0G9YTdaIC4sYws103ay35Eve4UGAPUMWXfJ1lk3/XqKlGy7C+u5AoSal5ed6QsIjU
	 YGIPTMUwNJBJPDA3nIUbIWoeakjm6m0QU1GbwFZiF0z/+EOG6pOEml3n84MviNJecx
	 1USLMo4bFcGjS6FhiC+GfhgPsncvjDU+gITc7Y8Gu/8WJXxjQuXfmhFZmJAsl09Wzy
	 hDVi+q+fRQbTQ==
Date: Mon, 19 Jan 2026 10:14:07 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Wenwu Hou <hwenwur@gmail.com>, linux-xfs@vger.kernel.org,
	cem@kernel.org, dchinner@redhat.com
Subject: Re: [PATCH] xfs: fix incorrect context handling in xfs_trans_roll
Message-ID: <20260119181407.GF15551@frogsfrogsfrogs>
References: <20260116103807.109738-1-hwenwur@gmail.com>
 <aWpYhpNFTfMqdh-r@infradead.org>
 <20260116161133.GW15551@frogsfrogsfrogs>
 <aW3QmibHRf49gZYd@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aW3QmibHRf49gZYd@infradead.org>

On Sun, Jan 18, 2026 at 10:35:06PM -0800, Christoph Hellwig wrote:
> On Fri, Jan 16, 2026 at 08:11:33AM -0800, Darrick J. Wong wrote:
> > Also it might be a nice cleanup if we could avoid touching the PF_ flags
> > at all, at least if the transaction can be rolled successfully.
> 
> That would mean passing a flag to not clear them into __xfs_trans_commit
> and xfs_trans_free.  Which sounds pretty ugly to me, just to avoid to
> clear and reset a flag.

I was more thinking that xfs_trans_alloc would set PF_MEMALLOC_NOFS, and
that would be cleared at the end of xfs_trans_cancel or
__xfs_trans_commit if !regrant.

--D
