Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2560F481A84
	for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2026 12:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782910219; cv=none; b=pqbvlbiZ+rj0w1OVdJ53LeGivMlmOnFTcJSoUqXvKqwb0id/GtUvL+vLZeVSLak2X4R+QIkSNTWah2CPtIFAgfJNIYdiUttZdakwL3iCGWkD+qw+pHueBIe98toQVpFSDyoDl09a9VcXwOIZLYcEWgWwfG2+ZI+u7rNWWa0DaLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782910219; c=relaxed/simple;
	bh=UwIbXsl3zTzflhADvEeObzQVESyNum/W8iBAmY7Zrxc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=YbpiUpvgiLtL1KhGgg0OfvYGM7A7bAYc4FPF2EJSx8TMCT2ocJvLsoJqivcUhbJMVqPBckynTjhzVG3dzz/N56Z3/mtc2nPhWW/yzyI3EtGBlHEgNTx7neAHcebKURgce8Oi3cfHeW++5DBQbfrwu0IaUlg3/zB+VXDSFufHDr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ckpdMyQt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ckpdMyQt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A2291F000E9;
	Wed,  1 Jul 2026 12:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782910217;
	bh=vvfcjM47u1uHeGODziFNo83aSY1oBiIUgYtZIPP8CFE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=ckpdMyQteAOlX1Foqey0PleoWGeL3rW0MAm63SU8pxM20EYonHrAK8UKDbrAzw3en
	 iI3sYjK7PY+t/2u7DYILj73DHMukIG2FT2zLkds/X73qM+OOa+cCNSXwO89ZcSrUlV
	 urJI/9Y637K3wlACCePZsV6IVzdvLcffhEvGuir9adgyPt4dMnAJIn1lUJJxykaJDm
	 zi09i17RpRFPVOmPtrJCEdU+jrm0nelEDFoBuGfeMlj6kMpCOaKudIXQf67tfZP1f0
	 7synl6R9k4XasuscMdDMNFDloH2X1lAYa5GPf8U0XlpDSva0hW6DrdCcTQNbyOUrcF
	 4w/QAL7o1KWQA==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
In-Reply-To: <20260625135849.2494779-1-hch@lst.de>
References: <20260625135849.2494779-1-hch@lst.de>
Subject: Re: xfs_buf_submit error handling fix v2
Message-Id: <178291021512.353898.8108873850089394771.b4-ty@b4>
Date: Wed, 01 Jul 2026 14:50:15 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2

On Thu, 25 Jun 2026 15:58:30 +0200, Christoph Hellwig wrote:
> currently xfs_buf_submit can execute the endio handling twice when failing
> for a synchronous submission.  This series refactors the surrounding code
> a bit to allow for a non-hacky fix and then applies that.
> 
> Changes since v1:
>  - fix a commit message typo
> 
> [...]

Applied to for-next, thanks!

[1/6] xfs: open code xfs_buf_ioend_fail in xfs_buf_submit
      commit: 6769087fd856889a32caf09590703813e3763575
[2/6] xfs: also mark the buffer stale on verifier failure in xfs_buf_submit
      commit: 0b434b552ecd19f33e2f85ea8e55dbb65352810d
[3/6] xfs: improve the xfs_buf_ioend_fail calling convention
      commit: 4c8b46d832bd98eab914e2bbcd32447b584b03a7
[4/6] xfs: remove xfs_buf_ioend
      commit: b53177d418225b15d23b1817fac1b5c668e56c2f
[5/6] xfs: fix handling of synchronous errors in xfs_buf_submit
      commit: 93e21ef2a819348fce899bd1bd1303979bba3f1d
[6/6] xfs: simplify __xfs_buf_ioend
      commit: e4281086ae6caf006b6ef0670479eb5f96880fb9

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

