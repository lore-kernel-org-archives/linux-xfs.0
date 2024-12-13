Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68C4C291E
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 05:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734066869; cv=none; b=u3dsTrVtm1FP+MMzomlHfRIqoWRX/0sfLcN9FVVFKczPVk/5ClzhNt/gC/5R0qhogPuLzPF+VRog+6kZMBiAXrS/ymCWwjIAYXBPGlD4CY9jqfXj2albeyf+N8PQeNlvu94f7rzeOaiUK4q6FXB9l/asRsohwzIrqT8W2Kkd5EM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734066869; c=relaxed/simple;
	bh=Ui/0LOT1XmKGvZ5ryN7eBnT0lVgngTvSz5/4Enz6m/Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GQzVetJN9/XGQFrtogovSRxhtTj+VytGnWkR4/M3EUomUqsUYUOD2OCbByIxweQNqD5hSGXAfvB2ZeBvUwGkHMO4O2HeOx6Lav6EkwNBuuZkC59GLiv6N+vnBkTyo8LMaI8KQdeUI76hs/fMz3cg7xbFS0KuxPWnbLco3W0HlTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 89A0068BEB; Fri, 13 Dec 2024 06:14:25 +0100 (CET)
Date: Fri, 13 Dec 2024 06:14:24 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/43] xfs: support XFS_BMAPI_REMAP in
 xfs_bmap_del_extent_delayOM
Message-ID: <20241213051424.GI5630@lst.de>
References: <20241211085636.1380516-1-hch@lst.de> <20241211085636.1380516-14-hch@lst.de> <20241212214720.GZ6678@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241212214720.GZ6678@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Dec 12, 2024 at 01:47:20PM -0800, Darrick J. Wong wrote:
> On Wed, Dec 11, 2024 at 09:54:38AM +0100, Christoph Hellwig wrote:
> > The zone allocator wants to be able to remove a delalloc mapping in the
> > COW fork while keeping the block reservation.  To support that pass the
> > blags argument down to xfs_bmap_del_extent_delay and support the
> 
>   bflags
> 
> > XFS_BMAPI_REMAP flag to keep the reservation.
> 
> Is REMAP the only bmapi flag that will be valid here?

Yes.  I'll add an assert.
