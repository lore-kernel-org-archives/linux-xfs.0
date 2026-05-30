Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F6FE37DEB2
	for <linux-xfs@vger.kernel.org>; Sat, 30 May 2026 06:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780123244; cv=none; b=H8/TrsX0im9bMOPj04ROZmMzRsnRhQ+W/a5CGBl87K6AGrJwWiWRkGK69eIzFMohLIxzk4vBG162trAmIGu4Z+aJ2N6HObAaxkvCrWb/zuRrrliU7shMdfrPejn7Lhp8TiNHPLKYiMTa3X3mS0uWaTPS3nCFTKhti+zyAOejPE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780123244; c=relaxed/simple;
	bh=j6PgEeEhR2rC7AUD8z8gelBsJQ8TBCEM4Ouc3YsQKvY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=bon1clCQD3YuYHtbrhE3MiINLI6kw7T3OXFIWvVZytWlFThaBt9wCpQX7uiAKksRySQqpjseIxsG/CcIlYLx5h1/bQc2Rl6+jatiFD4prsYfZ+x7TS0ZX6vcOjwIRgw2bnk0f2am7qztMrWfHJtbA1LUoJCWIXmz8wG8cjb3cH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c8PmHkAB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c8PmHkAB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C3051F00898;
	Sat, 30 May 2026 06:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780123240;
	bh=Xi6AmngY8qYDKw6J8+PrWIZw0jnCNmuWOQbex9AVfKo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=c8PmHkABOTbn48aJJdq9+zfOJqdKmfXFaCf1O6pWFU7bqpSqvihjmI7I6JeH+UP2o
	 EshA/xXnWz638gXLYcpfyZDEGNKbaBqNVutiwY7xV3zbEFPs3O/tMjd7ykBqmeUXZK
	 7DNvTtw7KvA0KIUEc0Rnuu+Wzs1hdYejwEM4Rp8ZNWdTd2x3F9LtKFRD1nA4uiQt95
	 79ZcrhgPLbRrBtpnmfSRRoCvUBMhZDBe6Fj3W8wZNYh99kINFhgQz2bk0QQ8x8EhqZ
	 nNiO3XNcptYYoHOTVl9XNQk2FdQYxn1Aa5y4hfT0dQReOtvbbP7NvlycNC9DtUGvcH
	 O84S7YayPQJig==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Wilfred Mallawa <wilfred.mallawa@wdc.com>, 
 Damien Le Moal <dlemoal@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>, 
 linux-xfs@vger.kernel.org
In-Reply-To: <20260527123941.2319377-1-hch@lst.de>
References: <20260527123941.2319377-1-hch@lst.de>
Subject: Re: zoned xfs updates
Message-Id: <178012323934.23341.16633385147695017170.b4-ty@b4>
Date: Sat, 30 May 2026 08:40:39 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2

On Wed, 27 May 2026 14:39:27 +0200, Christoph Hellwig wrote:
> this series has a fix for an hamrless issue in a recent commit,
> a cleanup, and then drops the experimental tag for the zoned
> allocator now that it has been in an upstream release for a year.
> 
> Diffstat:
>  xfs_ioctl.c   |   47 +++++++++++++++++++++++++++--------------------
>  xfs_message.c |    4 ----
>  xfs_message.h |    1 -
>  xfs_mount.h   |    2 --
>  xfs_super.c   |    1 -
>  5 files changed, 27 insertions(+), 28 deletions(-)
> 
> [...]

Applied to for-next, thanks!

[1/3] xfs: drop the RTG reference later in xfs_ioc_rtgroup_geometry
      commit: c316bb56bf4dda9bd3456a163c3a3856ca1b9498
[2/3] xfs: factor rtgroup geom write pointer reporting into a helper
      commit: 2fa29c1a167739fdef0fda9742ddeb15d9a6c7e4
[3/3] xfs: drop the experimental warning for the zoned allocator
      (no commit info)

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

