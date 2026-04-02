Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB5AB37AA70
	for <linux-xfs@vger.kernel.org>; Thu,  2 Apr 2026 18:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775155802; cv=none; b=s2tuye42no7JmDISUQKvpMA3Q4/t2mkvIT3i/d6C1rwF5eL/mRQuQ8qDkjOUfboIAR0sfTRveIlLWf8CJBj3t9XJLhZx1Fjrb2Q6uqvVSt7Z15jkPB3mXZZtse/WXWyevFmGtZrPUyyLamo+p3vcwu3JPF4qCDrjaSb81+M4xg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775155802; c=relaxed/simple;
	bh=XMEH9JgQfcQK/0c0YUf3pX38X3t5ODWN4MJl5bfHCLQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qBIKGvizrkWa0o9iGWvnQVDeWCjvKEzFdYoKClodjOFVMxG0keDmWBGbSZ4kvYIiPFxI88R7c+jFZ8HeqTO6cJnQJqO5hjnEWI7Gp4p2qsAXfk1Tq4NLfr7MdIaDyVIDUTbcKScYml14mcIkQ/ELWY4Qo0tZLEaa7ValGPeUH2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hkOXNPkS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hkOXNPkS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EE89C116C6;
	Thu,  2 Apr 2026 18:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775155802;
	bh=XMEH9JgQfcQK/0c0YUf3pX38X3t5ODWN4MJl5bfHCLQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hkOXNPkST/Nvc1FEfkceAJeWOtL9H97lV8Wf4wqycPK1kTUQ+OLuvdn1iomZWKKqB
	 mg4qjUvqICkaoirx6mGbHdcc1PO8TpJzaHpM0ecWI3LJi+dIuYBGgdk6h0TZUnP8S0
	 c1FEhxaELhRWhmP7oCyI7z1WbUOphqXGg/ol4O798WKJmnNMkZ6XdlkOi2ZG0AgsIU
	 SlLYxjXHZHVGR8Ytvt9NFDT347nrL6hUJvfwLe0oXtbMM3gW0pBxxvSvsg2IBwcwKS
	 4W/xKF6VshRY6s/L978zVRFa+p8MaMTCwBMkZJK/tzZJzGUnuDIkvEgIqZkEJOGMpo
	 Wzv1x7BMaRE8Q==
Date: Thu, 2 Apr 2026 20:49:58 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix number of GC bvecs
Message-ID: <ac66VqtCGW89S6XN@ryzen>
References: <20260401135801.124987-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260401135801.124987-1-hch@lst.de>

Hello Christoph,

On Wed, Apr 01, 2026 at 03:58:01PM +0200, Christoph Hellwig wrote:
> GC scratch allocations can wrap around and use the same buffer twice, and
> the current code fails to account for that.  So far this worked due to
> rounding in the block layer, but changes to the bio allocator drop the

Which change in the bio allocator?

If it is a commit that has landed already, I think it would be nice to
mention the commit in the usual "commit + 12 character SHA1" format.

If it is a change in a series that has not landed yet, it would be nice
if you could provide a link to the series, e.g. after the commit log
(after the "---").


Kind regards,
Niklas
