Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F972063E9
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 04:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739421768; cv=none; b=BQ2kQOhKp30mgCtW7DFGJTqqeNnuSfZ0kKxqBhuntj/kp9ozcs4gkENt9LQG9cJF2Uf41Qp1GqfMSgEDidsBVMLg3wEiNjC2F4DB1kCL3Tamr9ahnFKg7I9zmWSbch5V2oiTOcPtaUgCTR6GLJtyDN9l5Tiln+eY3DKK90N6I9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739421768; c=relaxed/simple;
	bh=eLVm69GxHTnCc1sbYQKNaMFNQ35O1pvos4zHtxlfu20=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gQVKfE2mtKab+cPMyUle5T9uv+4GzblXlINGGEIK016Ri/YZtbv2TYtyrLJciC+4iRGf+V7RGhc1V1+dxY8xkl0u6SzENf1xVYcdlEj0WqbUcaJK4AIxSprQ8Y/cRGtDzQ3eUN28d4TXUu597Y8Xa4mNbBd9thNu8CPquJLHd6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mUTrnVFO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mUTrnVFO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95174C4CEED;
	Thu, 13 Feb 2025 04:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739421767;
	bh=eLVm69GxHTnCc1sbYQKNaMFNQ35O1pvos4zHtxlfu20=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mUTrnVFO6qj6gnZjh5ZPRqwf1LyviRTi9EuBJ56tQRMefvVuPQhjTXyt5q6R27+c8
	 MmuC/YxLTgtPNyCoL3o7OUYS7oc3PazpRd+g9m2JPjVvf2T5u1Dn4vvnwb1XEf8Z8h
	 W9Qmh2dygg0pOS44iA+8zYi7czFVHyg2JUD8mWAionqvqhiGYQ43SuCCBtw02ksULr
	 tqkZ2dJ3Q3hZZzmIq/zcCYyEEmPvZA10Yb3+KejHVSpoBHHSOtqPp3vVu90IWfF69A
	 bmHGiRmSNSYErWsI4pfOjSHkT+rq/Tw04dzU0rtD0jpoqKAMgjyjieuJg3lAysUr6w
	 lHbbD3wMpleaw==
Date: Wed, 12 Feb 2025 20:42:47 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Hans Holmberg <Hans.Holmberg@wdc.com>
Cc: hch <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 39/43] xfs: support write life time based data placement
Message-ID: <20250213044247.GH3028674@frogsfrogsfrogs>
References: <20250206064511.2323878-1-hch@lst.de>
 <20250206064511.2323878-40-hch@lst.de>
 <20250212002726.GG21808@frogsfrogsfrogs>
 <c909769d-866d-46fe-98fd-951df055772f@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c909769d-866d-46fe-98fd-951df055772f@wdc.com>

On Wed, Feb 12, 2025 at 01:29:21PM +0000, Hans Holmberg wrote:
> On 12/02/2025 01:27, Darrick J. Wong wrote:
> > On Thu, Feb 06, 2025 at 07:44:55AM +0100, Christoph Hellwig wrote:
> >> From: Hans Holmberg <hans.holmberg@wdc.com>
> >>
> >> Add a file write life time data placement allocation scheme that aims to
> >> minimize fragmentation and thereby to do two things:
> >>
> >>  a) separate file data to different zones when possible.
> >>  b) colocate file data of similar life times when feasible.
> >>
> >> To get best results, average file sizes should align with the zone
> >> capacity that is reported through the XFS_IOC_FSGEOMETRY ioctl.
> >>
> >> For RocksDB using leveled compaction, the lifetime hints can improve
> >> throughput for overwrite workloads at 80% file system utilization by
> >> ~10%.
> > 
> > The code changes look mostly ok, but how does it do at 40% utilization?
> > 99%?  Does it reduce the amount of relocation work that the gc must do?
> 
> The improvement in data placement efficiency will always be there,
> reducing the number of blocks requiring relocation by GC, but the impact
> on performance varies depending on how full the file system is.
> 
> At 40% utilization there is almost no garbage collection going on, so the
> impact on throughput is not significant. At 99% the effects of better
> data placement should be higher.

<nod> Would you mind pasting that into the commit message?

--D

> Cheers,
> Hans
> 
