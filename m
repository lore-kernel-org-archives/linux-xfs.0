Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD1E5314B6D
	for <linux-xfs@vger.kernel.org>; Mon, 29 Jun 2026 07:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782718265; cv=none; b=ec6m6hFrG6QKNl5Hn+YqCUGb7yxkcvvhKe8oCiOsMBlzNUpO7HVsUQ1phdes3FQy4NLlK/DhPOC7rQjmJsfPByMzKnP03cqlZkDhtISuz6O7aAbYnbAvtVnUoIxRlpBiLks1WnStIQ7DsD4hPLkDYjHcmE99XsI4H0VWe5aegwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782718265; c=relaxed/simple;
	bh=0DN3r5rPojwkodHXjsTb+IEUT3/odartBcPMpuZUCg0=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ZKFgPbKweJ2WccboiYAgfY7LvSCORIjIIXwByb01cHtf4VetGksEOqkjAtI4xaWjCGkKBd+cfDUYzxsRfqueAmwA2rQuKX2zESAJG6/hkeAwvFTdB/epODjh2DA9fqANf15eV9yyZ2DTepBMyE3oeVOQC7Jxok6f7z/XLo+tx0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HEOloADv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HEOloADv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB7101F000E9
	for <linux-xfs@vger.kernel.org>; Mon, 29 Jun 2026 07:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782718264;
	bh=VrcsOXpkQvdoB/nO5aqaj1Sm5v2euDfI3cxkjLslPbw=;
	h=Date:From:To:Subject;
	b=HEOloADvGR/6OpcLp8PZ5Bj7pG5WJvwK+QbA1Y/I87ImMeVQxazYuT/qTpvSFZdyi
	 Ne3UIy6ATzEJz8TWbkXitC4FKb3ufiDkidnLi4AzCw54OWzACNGPnbYdACshN5ag25
	 CUnHNjJ0whrpM2hjKqJKjLEjAaeUC8OqM1oJ1p26jKLQW+Pbupyny0ty6JdZnQDT75
	 mXLi/PrUgHSgHsCRViAOyH4ra3GR0lPb4NNVX7i/cyB/mMckgcwlRGTdrwAkGgf9vn
	 rUqaRbaDHSPF+uV0XQu4Qc1WtZdVdUAWbtbaycuvv36mouDzrXVomYSPkT3o3w3tE/
	 tJ9/iH0Yst0jA==
Date: Mon, 29 Jun 2026 09:31:00 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to dc59e4fea9d8
Message-ID: <akIe5Cseojp7Tp40@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

This just resets for-next to the -rc1 release to start aggregating
patches for this version.

The new head of the for-next branch is commit:

dc59e4fea9d8 Linux 7.2-rc1
