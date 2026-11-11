Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794403455;
	b=QT2hQCHv/CuXl3BaT/8NcgSKbcRMbqSC4zFSJeK780gLgPJN8ct6dmzNg7Vv3GyoKZDM
	 DtTDOrqBiRHH8PoGnYxo4q1b8ar4oKtNdgZxpGAxxaRZirGXDuT+86iK5Jk7D3xk/yz/u
	 dEbpOB1QcgPsEuzP0HJgQhJhvS+gIc3ZM/PvK4cDmI6X0rcbC+LtrB7XaPpsClvcGkeGS
	 kf2SlEP70VeohO/7W17J63GHaXbK23yX1cnRqO0zembZDWsokHYOC6gvMwZWCdvm4gNFz
	 Vv2qP7RNe7udNVoxkGqUEG0Y4x6qzlpse/Jgbz19URYSe4ajlJg1shSdxLeREoJj2NA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794403455;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=WjqyAlJjan0qDs/Dphq96bKvjnIcY+Q4s9sNYN1sHWY=;
	b=P4bHpLI4TApUXXIw1MTfo4Rzuie+Cx6LXUOWaLbEx05e8Hi+Cyio4KhhXu0r0OTlHiTs
	 O9HYiBCX0ayxmbLY7JEYdsC1oMoGtqU2JrBR8LyKWxTMl8zuq6v1Uv1W90NdXmjbve/fx
	 cXX6XwhPpzIj2RMiWIJw5DpvnICpQzc8Ij3Yd/+X/DoeRlkomB669Ab3UkxdHr60Lavno
	 JgICwT02El5QbP72aXlbER0uhv1BGBcehLEDsp4btvlD07BqPZCxsizn7anvXj/1J5oWI
	 J6xga0NdCDbGP0lHci1peXjGyCDe/B1w+NR3FpTrcwQx3PJRdNsVxP8OInoW5Kcwr7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jQrUsOuf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD69606A332;
	Wed, 11 Nov 2026 13:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jQrUsOuf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B14251F00A09;
	Wed, 11 Nov 2026 13:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794403455;
	bh=WjqyAlJjan0qDs/Dphq96bKvjnIcY+Q4s9sNYN1sHWY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jQrUsOufcslpUY9mVcI9dWSfHj90GazFxzKJMEtlSCoh7PGQRGD7OXBXG+TdhlZMO
	 U/D/ifFc/dFsNrMXO1DLm6utPKFE7x66LJ359ckEm4Q6YzajhwUbffR5pZ0CGkSEdO
	 oVOjQpfGr0xgsZNkiQsCKKb1om0GfEZLPMVejOuf7PH+Nd8qaQ/1l5oJeS//JnajGx
	 C531T4pVpc5HUPysn+KyUI8DHexDRMRVm8WTaIap2hrRv54k/yj1dtg3XOf4+98yCT
	 ttEm7UgAT506rCn/FQbr9p2piRjSYE9L8FJvLwUnEpSldQxfnmSXm+2ioAu8TWF3Wq
	 8coq3N1YzcQSA==
Date: Wed, 11 Nov 2026 14:24:09 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christian Brauner <brauner@kernel.org>
Cc: Chris Mason <mason@kernel.org>, tytso@mit.edu, david@fromorbit.com, 
	jack@suse.cz, djwong@kernel.org, josef@toxicpanda.com, hch@lst.de, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v6 04/10] iomap: don't punch delalloc under a dirty EOF
 block
Message-ID: <avRsclSj-Es5AxCf@cronus.toxiclabs.cc>
References: <20261109235111.14129-1-mason@kernel.org>
 <20261109235111.14129-5-mason@kernel.org>
 <avLnAe4A6EB8Whyg@nidhogg.toxiclabs.cc>
 <20261111-esskultur-nahebringen-beiwerk-4a8a3b77bbf1@brauner>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261111-esskultur-nahebringen-beiwerk-4a8a3b77bbf1@brauner>

On Wed, Nov 11, 2026 at 12:21:35PM +0100, Christian Brauner wrote:
> On Tue, Nov 10, 2026 at 10:43:37AM +0100, Carlos Maiolino wrote:
> > Christian, is it ok with you if I pull this through xfs tree?
> 
> Sure,
> Acked-by: Christian Brauner <brauner@kernel.org>

Thanks!

> 
> -- 
> 
