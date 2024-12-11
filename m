Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FD7E1C4A25
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 21:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733952639; cv=none; b=f69DmfobDT3Utf/oaJ7IVBWKuojB4PmFYIckxvIEnVU0N8+BuK4LJZ9cVy15PpDxRBFWx3gbWsbBoWqnUUVjfllNOaha7AZlbAF0/iLyteGAIKp03NBbeZjaZu9tu93oIalWKHezpW7AWzgA2LnAVXkSPfuSrpz3I1IGMceHZV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733952639; c=relaxed/simple;
	bh=brNzjpO68wy2y63KW1sZUFvLwOR0lJvgHuaXe/ACU48=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dZSnU8l4nVXAoyVCD1ecSoIlkn7F1NYF+4wGusVdr+jfyOJLiQFzrRTNBsJw/QL6RYngpN8FsaYTEFEfVzojDFD8wlbrz/25rbhWfi0Ea7/rogsMZb9wDbqMZYGffr0b7Pgm/IBIGJh86CFJIR+gJZ5rzQ9/VA0bz+aQh5pz1u8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RnUow1ue; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RnUow1ue"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C67DC4CED2;
	Wed, 11 Dec 2024 21:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733952638;
	bh=brNzjpO68wy2y63KW1sZUFvLwOR0lJvgHuaXe/ACU48=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RnUow1ueGjVsiV9WdAJcC8aR7L7PKZelyXoJmXY9SN27NetxnZbDABBMrlbJflDcu
	 8lPBPgjD524Q293X6w88up6bDPNbnsJ4GoYDZuSZVGOuD4fNldx4c7ODa2+6YrXGvH
	 yKHLuevix420P4oIIumtrIqbc1PMHe6OgU2XAimi+nwUn4q837vXFuFpClXCAYu1/E
	 8DONlOE8kco8n+NAvXuSrHZvEXAQ9d53YByXJQHhhPSOtwqSihLvE78uetUpUBrREE
	 18svYWIfY/eeBXprP7s2ehQAB6+f84yj6F23+FATn4+0ZgTvGZNQaD3ThYh7QCxrTV
	 oQEGv6cAmEtUg==
Date: Wed, 11 Dec 2024 13:30:38 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 20/50] repair: use a separate bmaps array for real time
 groups
Message-ID: <20241211213038.GQ6678@frogsfrogsfrogs>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
 <173352752251.126362.2634382219651992049.stgit@frogsfrogsfrogs>
 <Z1fTjg9Bn72eM33a@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1fTjg9Bn72eM33a@infradead.org>

On Mon, Dec 09, 2024 at 09:37:18PM -0800, Christoph Hellwig wrote:
> On Fri, Dec 06, 2024 at 04:10:07PM -0800, Darrick J. Wong wrote:
> > From: Christoph Hellwig <hch@lst.de>
> > 
> > Stop pretending RTGs are high numbered AGs and just use separate
> > structures instead.
> 
> This should be folded into the previous patch.

Done.  I've cleaned up the commit message to read as follows:

xfs_repair: support realtime groups

Make repair aware of multiple rtgroups.  This now uses the same code as
the AG-based data device for block usage tracking instead of the less
optimal AVL trees and bitmaps used for the traditonal RT device.  This
is done by introducing similar per-rtgroup space tracking structures as
we have for the AGs.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

--D
