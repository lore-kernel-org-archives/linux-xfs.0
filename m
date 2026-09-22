Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEBEF550DC0
	for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2026 14:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790085711; cv=none; b=oyoCHpOB9AIVjo7b6CqLaWOnhusTWvEBMiJo8zkzCj/vPGy6TZnTnFVLGbJXh+ndpp6jlePesHNnUQ1Jv5iWZdZfwOXMaFPp+Lf4iFICZP1A+JwZm0s9ZXC65UAaaXcp6h0YtoE5DfaBHtziNo5SKVjRW9h8lYFrpEDwxZdjq8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790085711; c=relaxed/simple;
	bh=LSK3tJwXrrKuZpfefwEJe4/N8pz//lJpmOU7HGEfQ9M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QID2n8bbOUv6rfId3t9ahItWUUidvTe0iBNXB6cpGDjRH0SNk8Qmr/MUmSOXZwTY6YUY1J/vJ0UWNpya0mPFAOs9fXBM0u9mDmLQzA75vi344gGbRN346dyujD0GfjcY7rc5aiaw9zKkpAZiAJApTgwQs64IlQqM8FEFjiIcn0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=leZ3UBFa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="leZ3UBFa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53D071F000FF;
	Tue, 22 Sep 2026 14:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790085710;
	bh=yFiXhUGmD/hMVH+zi+Vqs4kumDaU7s3lTv6qzMjuU+o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=leZ3UBFaSl2Y5EtQlmH7kVB1KnMndpO1IxL1B+7yZ+MjzQ6aF+/8MWO+osrpXBed1
	 rWFZ6xdKsAyi8cP8ueHlYj9/4SM4Ke0Y1CfuJIgd64ICC7OWRUkenMix+fxDF7oial
	 D3xZTLF18kqIKMepK0w9/rBY27YG0ZkfL2JCnrOVErzP8hvQxlhztMZt1MAHfvIeXD
	 foiNT/wb6kChv5T39m8AV+pCTyqNZFnPT0LjcIqbAAw8jK0I9aDrqIj1GBBDqi8uyJ
	 2pZ6FFYOBLEy84l9WXdD+uj4IVgBVJq3i2slRLTpAdL2oQqOO4Y/STVNLGNFgFA7hz
	 iCmGdRM8Uj+jQ==
Date: Tue, 22 Sep 2026 16:01:45 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, 
	Wilfred Mallawa <wilfred.opensource@gmail.com>, "Darrick J . Wong" <djwong@kernel.org>, 
	Christoph Hellwig <hch@lst.de>, Alistair Francis <alistair.francis@wdc.com>, 
	Damien Le'Moal <dlemoal@kernel.org>, linux-xfs@vger.kernel.org, 
	Wilfred Mallawa <wilfred.mallawa@wdc.com>
Subject: Re: [PATCH 1/3] xfs: add write pointer to xfs_rtgroup_geometry
Message-ID: <arKKC1bGOMvI2Z2K@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20260313002456.3823811-1-wilfred.opensource@gmail.com>
 <arJ5oJeAOezhOGsP@infradead.org>
 <arKFdAhuxSq32e-P@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arKFdAhuxSq32e-P@nidhogg.toxiclabs.cc>

On 2026-09-22 15:41:59, Carlos Maiolino wrote:
> On Tue, Sep 22, 2026 at 05:50:40AM -0700, Christoph Hellwig wrote:
> > It looks like patches 2 and 3 in this series never made it into
> > the xfsprogs repository despite being fully reviewed.  Can we get them
> > picked up?
> 
> Cc'ing Andrey here.

Thanks, I will pull this, I've missed it

-- 
- Andrey
