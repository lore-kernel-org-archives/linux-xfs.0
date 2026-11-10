Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794350128;
	b=hjSce7eea/dN/bFMY6nJn5DNxxIxPvJRYFTpeOsw2BQn++iRBgqE9oyzdemQgCwiu2Ke
	 TVUV9azTKkynRzUpi21eJGb9xomxXpekBvYIFzjR6yihVXnttuObmfb4bVy1YujdyfbR7
	 JG84WzO1cGEuhzoXqCS98lNkAY5E8CqABEvijRNzMEQ1v1mKr6FEGS2XCBXB+RE5AOQ+3
	 8Md/bYWg2Yh+mpBAoCxohC2Q64Gw3f7tMNKmrRiCkw73NzMxYy7nzDCR15eoJ082IXooj
	 IltWNKfyfU33E1XMUYf+MhEPWXhGavObskPzbybUV21WmCeYKutMy5fDYdo2W5ecFog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794350128;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=Ym20+7Wv/4wi7Ep6FbeFDDNft2D0SHfj7IADfm8Ryp4=;
	b=x7q7YFJARMujJHkHWOOxo/vb0XV31m5hFO0tjaiH3l9gipJjg9Ju/vHXAsbQTQe/PQkn
	 AozC+z5gs7MP2C2t/tW/cTYxP+2cFLiOZ1g4Gty2eV/J6b/EdQmjEjYg/WjY4nJahRHHQ
	 wsrHIUrNBDAPlMJd9NNu2z7Ho9FH04Bi/fakSeYlYxDNDV6Sfrq2NCGTtlXrUtYEQKOKN
	 frNBHtkId84IJeadN0nAioQMaP6AicVEY4F64Hqmrlqs3VyA6wR4qCriPwqrvmqKOzmB+
	 m2LhzJQcFZoFIVUIt9aM6keZ3b9AddltTQlnF6EFz4QEbDjmF2d5tbckp3/3e1E/OaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=opyKExCr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 614AB606A31C;
	Tue, 10 Nov 2026 22:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=opyKExCr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ED9C1F008A2;
	Tue, 10 Nov 2026 22:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794350128;
	bh=Ym20+7Wv/4wi7Ep6FbeFDDNft2D0SHfj7IADfm8Ryp4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=opyKExCr5bYGHhFaW47e6loGVMMkBUzHRHaWRXIs3Sa0HtTR3Xn9AKilhTpNDjhto
	 oFsxxKG/KoJfP3RmQR5MBL79mRo/ei3ewFv893ASanogpgi7b2RFz5mgHgG6zdMxOY
	 YR0MlRSD038sPylWG2DBpdTEPx3URt0uOWLAnxDPkh6CjE0X4jZr/dPIdkVAxBBIJM
	 w2VK8mMZTff08FVCq+psm4FfyQz5Mt27WIb95r6xeP6FCaJdgdbTIEjQ0sQ0MzgAfM
	 7xAA/NMtxOqNxcBHLQEA7yZ+io7L5v+VGrE0M6VRBmE9bDVgWBdTCMoy3M5yKUEalj
	 Q2nqqeL1HZISA==
Date: Tue, 10 Nov 2026 14:35:26 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: hch@lst.de, fsverity@lists.linux.dev, dsterba@suse.com,
	linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, brauner@kernel.org,
	viro@zeniv.linux.org.uk, jaegeuk@kernel.org, chao@kernel.org,
	tytso@mit.edu
Subject: Re: [PATCH v2 2/5] fsverity: add I_VERITY_BUILDING inode state flag
Message-ID: <20261110223526.GD1907@quark>
References: <20261105115532.613467-1-aalbersh@kernel.org>
 <20261105115532.613467-3-aalbersh@kernel.org>
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
In-Reply-To: <20261105115532.613467-3-aalbersh@kernel.org>

On Thu, Nov 05, 2026 at 12:55:27PM +0100, Andrey Albershteyn wrote:
> +	} else if (inode_state_read_once(inode) & I_VERITY_BUILDING) {

fsverity_is_building()?

> +static inline bool fsverity_is_building(const struct inode *inode)
> +{
> +	return inode_state_read_once((struct inode *)inode) & I_VERITY_BUILDING;
> +}

It would make more sense for inode_state_read_once() itself to take
'const struct inode *'.  Then the cast wouldn't be needed.

- Eric
