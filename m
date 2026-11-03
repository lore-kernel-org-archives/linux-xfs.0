Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793695487;
	b=sOmB1m0O8gyMefDwyRwALi5vT2dPQXumnh7myyJwQ1XkNSjXIXBbOc2RwRCjbHRMaSX3
	 by/3NvSlbbnZCt01CuqrbFk0IxAkv0UQ7uomAPPXTSTVdH1SezNfzOI2mpbHDtIsmr8P0
	 m9N1MJb+G8XLPwD6PhaZgvGhDxqQbiPKK9fT70lR0Ub5/z5ZnKttRdn5nbV3RFa71prdY
	 Ajj+miw0cW0ahh+ti02s7IbH6IgRsUVBktR0VHmTypS2EDVsT4UqWlxL0KrmlkH2oyd8w
	 Kp+ktddqtEEuWntkGy+zxzj+mriifOiLHO0tQ9XMWF5yrIaVLU+nLA5h/LhkAhaeKsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793695487;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=tBx0/BzAOlR+EPAUcAIIe3m2Wrzw4dHycFyhOBGYJ2w=;
	b=vZC9cfltLScEMvpWxKDSPHiJx/r8+dVGAHQP7QRJMckJo3qW5XoaBoD/4snR6gfTXVeZ
	 bZ/LepIfL6TuvFsDHsB6isOwcetl6zhaBWU1n34uL9HNWwi181fZkpKuO9HQs7iSrkHT6
	 /cVOaN+WIqfsgEkDmeJzmYDiY4oc0h1cZeDob5JLbdSoAeKXX8Hr/9Uap8peclxMtxKHj
	 K4EUzm9/BYyHFvl154BpOacg8+7jBfUW90bw0Uk9VbgnWfg8T2lajUXnVqz4uNPbXjA+W
	 v2Q5KWnqCI6k//UTbPTplfBfGHs0gR969Qw5uNf9Z6sRYyW1Vp8U0AzBGKWuBFWgi4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SmpPBe+R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB0C3606A32F;
	Tue,  3 Nov 2026 08:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SmpPBe+R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82C2F1F000C1;
	Tue,  3 Nov 2026 08:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793695486;
	bh=tBx0/BzAOlR+EPAUcAIIe3m2Wrzw4dHycFyhOBGYJ2w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SmpPBe+RK5lPWyCBnMddR7FCskcx6kKGYhAa2mA8qGT7qGClBAMmwt1yCdl8FNBO/
	 tF5eYCFOZyop6KcyrcUZtTsQsEl0ARLsu+qlebv/nYcWIqvtyK+jTPqfgtJqb+SUPA
	 HyliR1Jj66mImbZLMU3ZdFHkBDohneaf7UculBU5k58tWl7B3F8HpI8f/SQ7XiDAzK
	 4Jr5G2L1dR/uHak3WEfeACFI4hEEf+cep2z3xyA8AGsylayGfe8c27C1wVamFm9MYi
	 peKs1z1Ayp+zpxixAOpBj4OSUU0Bzqboyx7lMvr7cV39s/9jNH7MwAC7HtDrIIhCii
	 ftSDHgzKIbpuQ==
Date: Tue, 3 Nov 2026 09:44:40 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: daejun7.park@samsung.com, linux-xfs@vger.kernel.org, 
	"Darrick J. Wong" <djwong@kernel.org>, Dave Chinner <dgc@kernel.org>, 
	Pankaj Raghav <p.raghav@samsung.com>, Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
	Dai Ngo <Dai.Ngo@oracle.com>, Sergey Bashirov <sergeybashirov@gmail.com>, 
	Andrey Albershteyn <aalbersh@kernel.org>, linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH v5 5/9] xfs: cap the block count of
 xfs_iomap_write_direct() at one extent
Message-ID: <aumezw2WGZUnI2nO@nidhogg.toxiclabs.cc>
References: <20261029-xfs-pnfs-batch-v5-0-ef8d2eafb7fa@samsung.com>
 <20261029-xfs-pnfs-batch-v5-5-ef8d2eafb7fa@samsung.com>
 <20261103054922.GA1721@lst.de>
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
In-Reply-To: <20261103054922.GA1721@lst.de>

On Tue, Nov 03, 2026 at 06:49:22AM +0100, Christoph Hellwig wrote:
> On Thu, Oct 29, 2026 at 11:23:02AM +0900, Daejun Park via B4 Relay wrote:
> > From: Daejun Park <daejun7.park@samsung.com>
> > 
> > xfs_iomap_write_direct() reserves blocks for the whole count in an
> > unsigned int. For a pNFS layout the client chooses that count, and an
> > RW LAYOUTGET for 16 TiB wraps the reservation and shuts XFS down.
> > 
> > xfs_bmapi_write() maps at most XFS_MAX_BMBT_EXTLEN blocks here, so cap
> > the count at that. nfsd asks again for the rest. The other callers get
> > the same mapping as before.
> > 
> > Suggested-by: Darrick J. Wong <djwong@kernel.org>
> > Link: https://lore.kernel.org/r/20261008154017.GO2705364@frogsfrogsfrogs
> > Suggested-by: Christoph Hellwig <hch@lst.de>
> > Link: https://lore.kernel.org/r/20261015060932.GD14035@lst.de
> > Suggested-by: Pankaj Raghav <p.raghav@samsung.com>
> > Link: https://lore.kernel.org/r/atoImJxtg70XcIjS@quentin
> 
> I think this is overdoing it a bit with the Link tags.
> 
> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> 

Yeah, I agree. I'll just rip off the Links when applying
