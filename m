Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E648269D1F;
	Thu, 13 Mar 2025 17:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741886086; cv=none; b=eOso6VUKcYhm8dqaDSbWoCCrl5iw7jArLDuf4uy6vSNkavki8s+MoO54mle/26cQ7tATAJpLlZFH0IX8tG1lF+0hVRNGOE9edKO3xBzDHnfxdmtAxhRA+1wGnHs7n6Tu3i3JxYc5zAHnjRNP1iS/833IQtk0z7lQtjfAzlXIgPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741886086; c=relaxed/simple;
	bh=MwG1bQasuONFnMmYq68plAfjG+7Q5It5cn/QHVyXxVk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WTvVaipCoUA+xXxcKBvgaVkytirMCFecR/jXMPRx4DuhrlhatdVRKao/fVqAND57MjUfpYC1DBPwbiXgwiOSQ9OfQfsZ+RHQHRPBfghsUm3/m+/XI4tzjMJvxjEQbwqzADHkYSCbQRh/NOrb+17d0i0ZN6IYWMDO2TBNoUnyzkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=enOXHHHw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="enOXHHHw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D81DBC4CEEA;
	Thu, 13 Mar 2025 17:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741886085;
	bh=MwG1bQasuONFnMmYq68plAfjG+7Q5It5cn/QHVyXxVk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=enOXHHHwAY7G0Gmv0yFr2lKXQLePtvyue+pHnDH3Eouo2ZLK7v7LTLQdHhryH+uhR
	 WWNMdKe2OqFYbwSsMQyzfBJYPvhQKY/kdgD7qfZ1jsTJy5p7WSLbzNTtNYHaVeKiPU
	 5byWsxmHyCVyeLFm5J3NDcfCFlpZsxaOZf9p7fOQkTUkEbyezfIOTAy5LvRASZXnXX
	 xjMFQytKSmMaeP8V/eqijSDzTrTr1jOxrovoAqRNrWOZVHc/HupJRYq0JpW5xcSKl1
	 yAZQlF8vks+uDo8DW6CMneQrenpA9SpLtR+FkZ5xhpeiMgEa/fl2tgS+KDtlQ9ajMP
	 pwCfLmLvoVeow==
Date: Thu, 13 Mar 2025 10:14:45 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/17] xfs: check for zoned-specific errors in
 _try_scratch_mkfs_xfs
Message-ID: <20250313171445.GU2803749@frogsfrogsfrogs>
References: <20250312064541.664334-1-hch@lst.de>
 <20250312064541.664334-9-hch@lst.de>
 <20250312201725.GH2803749@frogsfrogsfrogs>
 <20250313072637.GD11310@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250313072637.GD11310@lst.de>

On Thu, Mar 13, 2025 at 08:26:37AM +0100, Christoph Hellwig wrote:
> On Wed, Mar 12, 2025 at 01:17:25PM -0700, Darrick J. Wong wrote:
> > > +	grep -q "zoned file systems do not support" $tmp.mkfserr && \
> > > +		_notrun "Not supported on zoned file systems"
> > > +	grep -q "must be greater than the minimum" $tmp.mkfserr && \
> > 
> > Hmmm... this doesn't mention the word "zone" at all.
> > 
> > Maybe that error message in calculate_zone_geometry should read:
> > 
> > "realtime group count (%llu) must be greater than the minimum (%u) zone count" ?
> 
> Yeah.
> 
> > and I think you should post the xfsprogs zoned patches.
> 
> Still waiting for a baseline to post against, i.e. rtrmap and rtreflink
> being merged.

That's all in for-next now, though I don't think there's going to be a
xfsprogs release until the kernel does it.

--D
