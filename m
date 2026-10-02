Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8373F468C39;
	Fri,  2 Oct 2026 23:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790983565; cv=none; b=OBRnt2iYps0yqIe7eEpkZ8olPGbBystMXxsSWbxoXgV3RVVW42AxPnqNF8puE6VFAQvzqUiviQxQS2aLN/sV3RSXG2JaCOWsqmCv1EvqEfaFDT9KE5GIcDdQux7bvvJyH70+y4Gy+9mp7y/bwxMN07w2qqmGhLW7spU6+nLpqfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790983565; c=relaxed/simple;
	bh=l1/FScIK/9rZdsqCKvI7Q95vwLWnixcQW4L2Xs6R/RQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R8XodvMAqrJVA1woR48KvF+nSNIltxtCP/YT7mvW1XKQlOXr9C79swllyQrXg2hyBhSVWMdknf41MRPBgTsEbPDM9QAYvdy8905qFp8Yy8/9kk2fveUDXx10wYKAs3NUcBEwNnIaBmMmE/MBim4ytCTvJ5Io+MSUY24O6eJEvII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RnE8nbDX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RnE8nbDX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69D121F000FF;
	Fri,  2 Oct 2026 23:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790983564;
	bh=dX8mjLok4UtQXnDkgexJ+xhshtPu80jfh72aVt20z/k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RnE8nbDXaHLywz+cDXAfB6ZsQGwhyS440PA8yoFOF3QYRE5zAVHnXZOmhfUeCep3u
	 a4wMpj9lCDH0ZrxcsQPIxE0o41ZkBkpkKwpM1mEQXH4IX8ybRNV71uD7PHiZm/NeOQ
	 w3BG7/4gB1mOS3sKLbIYVRO7GvON4tUQ1YF6IHpozPPMnv3osR6gslxP/ykpHPw7/I
	 TnFD7QONTnTEuozu6MuXDf4SKbQFytR/64idEu+bZ4Ts/kmQPDx5knPcSWSOGFq80t
	 2QIyXFqkkUc72IbxBIxqhkws/q2qCT8DtxyVoFh6iNeG7vlZN5Ap4EJ7hwQoUvRZ3T
	 IllQEwHSChcnQ==
Date: Fri, 2 Oct 2026 16:25:42 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: djwong@kernel.org, hch@lst.de, Carlos Maiolino <cem@kernel.org>,
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH v17 00/21] fs-verity support for XFS with post EOF merkle
 tree
Message-ID: <20261002232542.GA15366@quark>
References: <20261002223705.2175542-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261002223705.2175542-1-aalbersh@kernel.org>

On Sat, Oct 03, 2026 at 12:36:41AM +0200, Andrey Albershteyn wrote:
> Andrey Albershteyn (19):
>   fsverity: report validation errors through fserror to fsnotify
>   fsverity: expose ensure_fsverity_info()
>   fsverity: pass digest size and hash of the all-zeroes block to ->write
>   fsverity: hoist pagecache_read from f2fs/ext4 to fsverity
>   fsverity: don't allow setting DAX file attribute on fsverity files
>   fsverity: hoist statx reporting of fs-verity flag

Would it be helpful if I applied these six patches to fsverity/for-next
for 7.4, or do you want to wait for the full series to go in at once
(presumably through the XFS tree)?

- Eric
