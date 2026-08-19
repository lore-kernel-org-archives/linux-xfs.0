Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2000B3C0626;
	Wed, 19 Aug 2026 07:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787123503; cv=none; b=uFuDn6Tv2KJNUD3XALaVkZzD0cZ9cxZlaj+EqZyTOIVG9a0GCZIJ0wOgsdWZ7QcPHGvQwUMw15W7HNbFT4cBzSdpLuCIXtVluD8HyW9sOIqzYOm6sKP1wxtDI8NX1wtVH4QDNE1EKft4IAaysmi+Lis/ifybu0Wqs45clKigtyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787123503; c=relaxed/simple;
	bh=Sf2SWIoDqIADdrihBA5Fys8XjzUflE0C89DmtLSswQE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y6FF8OXI04w7JeHv+26x4TEF6v8nHWI4aQ0V7oDS81ILYGigiw5KI5lu8eZgRdPyakHSCm1B+U6Gqkk87WuKJKZsGVHhcuR9S/WHAdG+dAPfz6e9zCF5Fb2+GiJMaTAWZ8BG+siyDE2iyrpB7duHaW1sovis7rJeiyy03Tnqn+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 964DD68C7B; Wed, 19 Aug 2026 09:11:37 +0200 (CEST)
Date: Wed, 19 Aug 2026 09:11:37 +0200
From: Christoph Hellwig <hch@lst.de>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: brauner@kernel.org, hch@lst.de, djwong@kernel.org, dgc@kernel.org,
	jack@suse.cz, cem@kernel.org, axboe@kernel.dk, kbusch@kernel.org,
	ritesh.list@gmail.com, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH v4 1/6] fs: add write-stream management ioctls
Message-ID: <20260819071137.GD1541@lst.de>
References: <20260717125538.508925-1-joshi.k@samsung.com> <CGME20260717125627epcas5p3f5ad1cf917d563cc061e571b2f932319@epcas5p3.samsung.com> <20260717125538.508925-2-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260717125538.508925-2-joshi.k@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Beside the issue pointed out in the comment there is another one
that came to my mind:

Right now there is no control what application can use the write streams.
Tis means a user could monopolize them, negatively affecting others,
even more so when hardware write stream support is added later.

I see two ways out of this:

 1) require privileges to use write streams
 2) have a rlimit for the numebr of streams per user

2) is by far nicer, but 1) might be easier to get things going to then
move to 2).

