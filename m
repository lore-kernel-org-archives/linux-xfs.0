Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F140F3EB810;
	Mon, 11 May 2026 13:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778506359; cv=none; b=hziWxiHR4kmjgUj7qxlbY/oeYJI4bFu3xOC3a777asaJLqiAFuugDp6xooxT7QrYiqjk6pg8NxSj4T1TC/Ta7IHtFihRE9eQtHmfQ52O/CzVgQbxIohm6pyKRFxbkXUrNUiPiQefGF4QuJL8hGUextta727V3d8e1ZBnAPh4Xag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778506359; c=relaxed/simple;
	bh=sJoBRYVX6bOZsdoa19UgMBWwF9LWA3D8znwXdWe1B54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L3Zskfj3e2QnyRLe7mvMviHYBaYUCBmflRxYEC+qYfXdIOGNVq/iUanpcCtsBNGKqgjs0eak/o4Kls6vVnt/3xq+SnpLc/CCcukWZPrh3Kl+MlRjkCA2trB2e6gqDqRu/98yA+Tfg7uDSyisgSz6LmSRNrK9iTQDWjxIQirsVLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rIIrZ3Dq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rIIrZ3Dq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB252C2BCB0;
	Mon, 11 May 2026 13:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778506358;
	bh=sJoBRYVX6bOZsdoa19UgMBWwF9LWA3D8znwXdWe1B54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rIIrZ3DqQaNc+tbsov72hHaUh2NBuEIQBhsbBsPkKGgwpsT70PxKojzqx4FiMYMif
	 hyH5dsshvsvU/Hs0zHg8dzpvMegASszzCodE/FOnPLExJQav67wXJv8FJA+Rq9Z3zp
	 nTFuw3t/zSAdZaowcLGyNa/4tZi60Ohr3lHp5O07+A1DINb/KvWv9ig8LcFP6vJAGu
	 IbO9c2ixK3DaMEwDXf4h/y660nWAOLe1UIbnuX6I65nrJhYeEnJL/GrnxhIQct+ywq
	 dha17C1r3e5MdUEBHcY8Nj/iUGnj1Y7MIlCKkVOI4m88S6r1XzMEeis/FM85EVQCUB
	 i7Yrh9HFMjqBw==
From: Christian Brauner <brauner@kernel.org>
To: Pankaj Raghav <p.raghav@samsung.com>
Cc: Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org,
	Andres Freund <andres@anarazel.de>,
	Jeff Layton <jlayton@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org,
	hch@lst.de,
	linux-kernel@vger.kernel.org,
	pankaj.raghav@linux.dev,
	Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] fs: fix forced iversion increment on lazytime timestamp updates
Date: Mon, 11 May 2026 15:32:22 +0200
Message-ID: <20260511-entzaubern-jemals-2a6e61b051e3@brauner>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260511111918.1793689-1-p.raghav@samsung.com>
References: <20260511111918.1793689-1-p.raghav@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1511; i=brauner@kernel.org; h=from:subject:message-id; bh=sJoBRYVX6bOZsdoa19UgMBWwF9LWA3D8znwXdWe1B54=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQx3io4teWVfd/lL7/f3BE/t7Emvru2mj1l494upkWVJ trnr8yc0lHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjARvxhGhotW7zVTOw5ed+zW qtyZPWftLMX77AknvlxjN1Ga5uJ34izD/xo7hvUz/zRIl4g1rYmcoJ1bGS3xVHx631KvjUZ8Id7 CzAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

On Mon, 11 May 2026 13:19:18 +0200, Pankaj Raghav wrote:
> When updating timestamps with lazytime enabled, if only I_DIRTY_TIME is
> set (pure lazytime update), inode_maybe_inc_iversion() should not be
> forced to increment i_version. The force parameter should only be true
> when actual data or metadata changes require an iversion bump.
> 
> The current code uses "!!dirty" which evaluates to true whenever dirty
> has any bits set, including the I_DIRTY_TIME bit alone. This forces an
> iversion increment on every lazytime timestamp update, which then sets
> I_DIRTY_SYNC, triggering expensive log flushes on subsequent fdatasync
> calls. Andres reported this issue when he noticed a perf regression[1].
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

[1/1] fs: fix forced iversion increment on lazytime timestamp updates
      https://git.kernel.org/vfs/vfs/c/834e98acb748
