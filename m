Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793801510;
	b=MNM20wjKR5jeQb2jb6GMF0cvQCbFDOOlfDBUwg2mWNY5oSLABLqf//dXflnjTO7dicDl
	 6j3m/ecUXmqEwSqPXAoAufy7Ffy8gySmArI5U0hBnPIRELujXgYLtlr4FYg1SdSpvj4Z0
	 UjtHvWCaHQ2fVqUmZOWL1JutgA06hV80WIe/onlqkn6LTg0m8q1pn3d1YHczIRhxRzkZG
	 Yq7FKzBurMvV8m7gAvQsI+43jaUTOHv4LI+70qhzhKztgf8WBx+JNC8LWRuTE/hdJuot0
	 yg0ftkar1+JrraSYOtyubKupns1c8pMbmbpa91/biwW/DbFczFMoeeDwvUBVw4+Va2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793801510;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=uYHcKOkL6ny5sFb7zNLKYx2A9amYOD48Z+WrQxgYmnI=;
	b=SAGpMxEvrpdk1inVGZC/8XfcHjaitSxtlNIfhborBPMr5LsztryquGInGBCbWSm4Ws02
	 tw5jDNnIFGuWsMG7kfHBzj55nrLAk2clceE0TzZSiXRnOOSaWj8pSpezKAu1DfT19U5Gk
	 MLRKtUgL9Df5/ZKOXt2YRt51UN/pzBOnQQXzbvw0KYpans04MNG7GzSVqRRdlkZPGVYtw
	 u97Ux2tJAwUzlJDFX3SarASsfqd7IQPBIvVKeNDy1ZP6ZH+TiV9+HTMVxAdbtwR3MpKin
	 LtmYO6iu4Gd7ur4nfuy0z1NlVj9Mf9+m3CtLE4r0LZ/eQR4U4yg8pmDO5BnKxhWlVew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="f0/pvRcv";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7476606D811
	for <linux-xfs@vger.kernel.org>; Wed,  4 Nov 2026 14:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f0/pvRcv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 058801F00919;
	Wed,  4 Nov 2026 14:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793801509;
	bh=uYHcKOkL6ny5sFb7zNLKYx2A9amYOD48Z+WrQxgYmnI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=f0/pvRcvVqWkM4AVu39EMs0SG9EoEv0MrUQ0HEO1KGpfwAyI+zsCsz1/bn5VXkcP7
	 1fQvYFh9USE7NY7YOMgpDL0ypHEsL15bY9xe+jJPyi4+ZffRlB5towWQEP/BD5DrZf
	 qx4rZ1VHi+ilI8qvJKMfHVZ19xOKmScBPlSZzSgrY9LGaOq8hG07wDbweN8z6Xq8ap
	 9kOdFMMQFAZGbl7eb1joL0Ay0RwUN8CDfB8AL4tuDpbIYT/NDar/TqojuAWzeuwIOw
	 mogqg4Ekg0EnTE5zMGiqqd9l1TooRXauXN0QXVjyi1klWLr/oJ9xGvL2Glqk+QavTG
	 gtVRrD6z8Mgrg==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
In-Reply-To: <20261028081125.2209827-1-hch@lst.de>
References: <20261028081125.2209827-1-hch@lst.de>
Subject: Re: [PATCH] xfs: fix recovery of partial attr removals
Message-Id: <179380150874.5728.7559812781586127945.b4-ty@kernel.org>
Date: Wed, 04 Nov 2026 15:11:48 +0100
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
X-Mailer: b4 0.14.3

On Wed, 28 Oct 2026 09:09:39 +0100, Christoph Hellwig wrote:
> When running xfs/753 on parent pointer-enabled file systems with DEBUG
> enabled, log recovery will eventually crash after a few dozen iterations
> due to an ASSERT that XFS_ATTR_INCOMPLETE is not already set when
> xfs_attr3_leaf_setflag is called:
> 
> XFS: Assertion failed: (entry->flags & XFS_ATTR_INCOMPLETE) == 0, file: fs/xfs/libxfs/xfs_attr_leaf.c, line: 3045
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: fix recovery of partial attr removals
      commit: 30bb61651d2da5a502cf504bcdad16c093c1bb08

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

