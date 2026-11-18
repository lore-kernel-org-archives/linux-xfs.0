Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794990322;
	b=I5shrfh2fe2F501AYxLyIZbTb2Kh/BmwtRJjUXdYs8XdjeJX3re+TMTCuuYtRHWvBEgK
	 wNyyeFMaSTNEv+30Ts/nMxWAp54oH4llKVHZZP2a5vx2uFRl1/mlKWcbbVnS+GOLOYyjB
	 1omC64Zxu1B7AcbqDh5dvIJBA8mbkwisN0mmrpsQRj/ICnXqppZOxhNwaC37sPDWl+2Vu
	 UDRh6MLxWTMFZoTgFj8P0soqmuvXsuOz0jl0pHDOCgCUZ3KRk/p0rhh/T2nRQvGmroODX
	 +DsVsNpQpGOfCVUDKrtZAoxfd40Ue+5nmNdDHlEpu2diCo3tAhAsDlj5p9sMiha80lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794990322;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=/gnERf8/lwxTf/TKNkFmSTUOpGA31NOCSUWLUI8wwN8=;
	b=m67JDIHp0G2CRxXRiKu8Fv1MYRPEoUCIWhdqkQVohjaLt2LObdmLfRvwD3TYEobEhm/c
	 Wl7WNwiQr6eFejPJeXHxYJk0D5qPjivzjV2JZPD0Bjwu1CXAb2LNbhIP8tyc7MFlib5ne
	 kXBTaggcNPVVBIjYADKlGdeDMXS/NkkZ4fH+jqqJjDivIuJQEZ/Ndn3hxN73ZtydP4MHE
	 Gy+ZJchMtQbDQCKiIhWvBwNyNA9eEbwdqAV8QrpMd63grV6nIDohfLpVPkaA+xvygRV5O
	 EYhHlVXKct9Kdltq9sJN8qk0TMZs6dy+WB56zTaSTH1upHz6uyjCof+piEVSuVpZf3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UYuN29EH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5FA606A31C;
	Wed, 18 Nov 2026 08:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UYuN29EH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE48C1F000C5;
	Wed, 18 Nov 2026 08:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794990322;
	bh=/gnERf8/lwxTf/TKNkFmSTUOpGA31NOCSUWLUI8wwN8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=UYuN29EHougrxVA1zNLd7+h/5ohmwEiIWgH72ZI3TLkPcHCt3F2kTKibv2Y5Z0fG6
	 voFJE5vK4pYBzv5o2gcNlXMkbuINEp5Xu4YHs5xPStFZKJMbCNd2W0RaXU9zwtZT3R
	 FSXBAep0uczyb83cnA3Y2rUjbZrjk4j08j5yavdA9m++bauz5X2e03GUj8L0BL+un9
	 MYAhh/sFOwDlqiNHDgZ3XoXD2l7fuvveqjGlNHMbX3v7u6uzqvpj17YrntA5rZqEtG
	 4A81sePTm+4NeytNfWTwz2cLYmUQma9UN1PJ1lc6O0ZoXSyPyuNm3HHFvU92Z94vws
	 rOom2tv105R9w==
From: Christian Brauner <brauner@kernel.org>
To: Shashank Mohan Jain <jain.sm@gmail.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
 Matthew Wilcox <willy@infradead.org>, Brian Foster <bfoster@redhat.com>, 
 Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>, 
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20261117164756.97065-1-jain.sm@gmail.com>
References: <20261117164756.97065-1-jain.sm@gmail.com>
Subject: Re: [PATCH] iomap: fix offset truncation in
 iomap_fill_dirty_folios() on 32-bit
Message-Id: <20261118-irrfahrt-wesen-betroffen-ac375e276218@brauner>
Date: Wed, 18 Nov 2026 09:25:17 +0100
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.17-dev-04696

On Tue, 17 Nov 2026 22:17:56 +0530, Shashank Mohan Jain wrote:
> iomap_fill_dirty_folios() turns the page index at which the dirty
> folio lookup ended into the file offset it returns to the caller:
> 
> 	*start = (pstart << PAGE_SHIFT);
> 
> pstart is a pgoff_t. On a 32-bit kernel the shift is done in 32 bits
> and the upper bits are lost for every offset at or above 4 GiB.
> 
> [...]

Applied to the vfs.fixes branch of the vfs/vfs.git tree.
Patches in the vfs.fixes branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs.fixes

[1/1] iomap: fix offset truncation in iomap_fill_dirty_folios() on 32-bit
      https://git.kernel.org/vfs/vfs/c/4d841b11ce1d

