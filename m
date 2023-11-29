Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB0477462
	for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2023 06:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uK9fiBRq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22B2EC433C8;
	Wed, 29 Nov 2023 06:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701238916;
	bh=DmIWPVjy1DkLRMG8ouLjJI4ZAYQI+RQKE8n/h1MA0HU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uK9fiBRqYGvzdK4Jn799NJrMh8dRQah62tIK+4MD89udFySuDocxJ/2yIIwaJHl4w
	 4dI1uas5BA2P36qZwRl5BByqCMaxq5R/ttnt8K0Dg6HHF/Yrpda5DK0uxE0uKUeMFy
	 4Nuz7yfnv3RVXMkrurWicLdElYSaxM9xM5UGWH+d0M5cphEpCFSow44FgBpYxA4GHl
	 aV8xDX/JNPsTlySQARmaVCgeBGbng1TdiADVNYb5WiFRDPO44kLWxoNlKmUdzY/eLr
	 SNkiL0a1BeBC+LTlu9CnPd8YcgiA/YWwN2B+veogC20TiA6fp2c3UQcL+eXUb7SKrf
	 /A82l7Z0AcQrw==
Date: Tue, 28 Nov 2023 22:21:55 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] xfs: check rt summary file geometry more thoroughly
Message-ID: <20231129062155.GC361584@frogsfrogsfrogs>
References: <170086928333.2771542.10506226721850199807.stgit@frogsfrogsfrogs>
 <170086928377.2771542.14818456920992275639.stgit@frogsfrogsfrogs>
 <ZWXzvNHCV6QWeikg@infradead.org>
 <20231128233008.GF4167244@frogsfrogsfrogs>
 <ZWbUvcVIBROrHVOh@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZWbUvcVIBROrHVOh@infradead.org>

On Tue, Nov 28, 2023 at 10:05:49PM -0800, Christoph Hellwig wrote:
> On Tue, Nov 28, 2023 at 03:30:09PM -0800, Darrick J. Wong wrote:
> > LOL so I just tried a 64k rt volume with a 1M rextsize and mkfs crashed.
> > I guess I'll go sort out what's going on there...
> 
> I think we should just reject rt device size < rtextsize configs in
> the kernel and all tools.

"But that could break old weirdass customer filesystems."

The design of rtgroups prohibits that, so we're ok going forward.

--D
