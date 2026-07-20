Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D1CB3B71B1
	for <linux-xfs@vger.kernel.org>; Mon, 20 Jul 2026 08:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784537873; cv=none; b=WCLLZAZyUjdGzRZXHqfKPhv1VkGy6OFpyVCGLFT4moMSxFEwt7Fu05o0XoQTK8q6jP9TsgiwlVfrzAEaY/dfvMeFSZBVkimUU4mrkVBhOlsqjKj15uX65pT6rbx2jqRdNd9O2IenqtHTZWwKTPGB0kCYyM/7L6y73d4rRMl7uSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784537873; c=relaxed/simple;
	bh=tA7RLrtXvF7J0OV/TPinvgC9eT36xYu703DNI6jUW/A=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=q7fkwRZXo/+gGKY1g/wvOYYMhYT2MtrJG9DEBcrwl9bnrbgqOqkiZY03FceM9eTYr+JqWpnifJGsXja6Cm3ZBqtei4wkYHxONYH/5qKvONdK2Nt/d2W9fk3enZHvlCiZA0IeiE21FSFkCRhcMD6fe79zKQakaPbHSlaRtpvolIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gA/lctTM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gA/lctTM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E0F41F000E9;
	Mon, 20 Jul 2026 08:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784537872;
	bh=E77qhrmWkLXouvVAZuHTqnj+3NW+9uVlnqdLNRKu820=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=gA/lctTMOfV2ul5swvqydXiK7emp1ScowYPxhGyC2ZcyUWKUYKG0QA/lQ06BTK30+
	 oob3kAjFZ3UmJc7pSX+6nbe8Pckii30VZ74xfOtalkCFVEEiZoDeVI8seJQjknlL07
	 8ChHaoSXkApJRo8X+R0ulcmjxLT4DV2fpg74+wFSpO/xT/OIsDpm+IFR4EB1vsKeIn
	 sJg6zL1azyml/J+qCHI8xAH4t1pL0MVXGq7u1JcUYQw4xY5C/Brdx7dDlnrg37sNoJ
	 CoNBxkZAtSZqpAKgoqDhyjsUPgLjtTpK+/pEfw+GCa+yWtKZMCVnDDoG8O8Vmy7NaS
	 DhuI9b8j4/01g==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@infradead.org>, 
 "Darrick J. Wong" <djwong@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>
In-Reply-To: <20260714060344.GA7380@frogsfrogsfrogs>
References: <20260714060344.GA7380@frogsfrogsfrogs>
Subject: Re: [PATCH] xfs: resample the data fork mapping after cycling
 ILOCK
Message-Id: <178453787122.7428.13518644933049488575.b4-ty@b4>
Date: Mon, 20 Jul 2026 10:57:51 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2

On Mon, 13 Jul 2026 23:03:44 -0700, Darrick J. Wong wrote:
> xfs_reflink_fill_{cow_hole,delalloc} are both presented with an inode,
> a data fork mapping, and a cow fork mapping.  Unfortunately, these two
> helpers cycle the ILOCK to grab a transaction, which means that the
> mappings are stale as soon as we reacquire the ILOCK.  Currently we
> refresh the cow fork mapping by re-calling xfs_find_trim_cow_extent, but
> we don't refresh the data fork mapping beforehand, which means that the
> xfs_bmap_trim_cow in that function queries the refcount btree about the
> wrong physical blocks and returns an inaccurate value in *shared.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: resample the data fork mapping after cycling ILOCK
      commit: 2f4acd0fcd862e22eab45690ec2c08c80b6ef2e7

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

