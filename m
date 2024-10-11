Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893FE209664
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 07:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728633435; cv=none; b=PnVAm6g1jxMrOLLcvzJQUxIL7o4fcIS0UimlI1bnq7h8OL+hOrNrHbUT+e7IpnLgzTC5PpPsqZ4RaGptVIerbHYwZWJj7HunulvivORNNkmcooR481l8mqRSl9CmLe7dM6JShlsD2x0H1q6ghi0v7wGOapQrfyclRJMB2yna7L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728633435; c=relaxed/simple;
	bh=6yyCNnSbPWK0ZSZWU2azYUrkSYLlli/8aKIN6/tQ6co=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hUI0aZ3wU/p0NpJJzrLOmORdrdJX4CqMR/kNCYY+9pCdFYQ3/hdrFijEWxCaVp739vAmeC9tX5Bjc9GjpNOUQGvjgcmZcR3vy7hGBvolgMqvyrKg8SbkTaoxCRuzIoJLV/ZHKIJEtvZSA2F1ZNzETuNsD/GQwerVB72S1NRy48Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E2F95227AB3; Fri, 11 Oct 2024 09:57:09 +0200 (CEST)
Date: Fri, 11 Oct 2024 09:57:09 +0200
From: Christoph Hellwig <hch@lst.de>
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/7] xfs: don't update file system geometry through
 transaction deltas
Message-ID: <20241011075709.GC2749@lst.de>
References: <20240930164211.2357358-1-hch@lst.de> <20240930164211.2357358-7-hch@lst.de> <ZwffQQuVx_CyVgLc@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZwffQQuVx_CyVgLc@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Oct 10, 2024 at 10:05:53AM -0400, Brian Foster wrote:
> Ok, so we don't want geometry changes transactions in the same CIL
> checkpoint as alloc related transactions that might depend on the
> geometry changes. That seems reasonable and on a first pass I have an
> idea of what this is doing, but the description is kind of vague.
> Obviously this fixes an issue on the recovery side (since I've tested
> it), but it's not quite clear to me from the description and/or logic
> changes how that issue manifests.
> 
> Could you elaborate please? For example, is this some kind of race
> situation between an allocation request and a growfs transaction, where
> the former perhaps sees a newly added AG between the time the growfs
> transaction commits (applying the sb deltas) and it actually commits to
> the log due to being a sync transaction, thus allowing an alloc on a new
> AG into the same checkpoint that adds the AG?

This is based on the feedback by Dave on the previous version:

https://lore.kernel.org/linux-xfs/Zut51Ftv%2F46Oj386@dread.disaster.area/

Just doing the perag/in-core sb updates earlier fixes all the issues
with my test case, so I'm not actually sure how to get more updates
into the check checkpoint.  I'll try your exercisers if it could hit
that.

