Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29FB13E928F;
	Tue, 17 Mar 2026 14:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773756776; cv=none; b=prAAfPzNB/4ZsHAdj6wCy4zwV6C3tbiFRZBq5/AxYtLI8fpHKxBPjGgyNGt50r2UCeL+R7NRTf7IRdVEMn2mmMA7PoJyq4Bxl3qExhsOUjxd8KjycUWNR1XFf6Zcc/QxG4Bcf7UhxeJq+ORdCPgzKuEEAD+8Mf13EKLAmidIlAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773756776; c=relaxed/simple;
	bh=jYs0vTmVRT6uOH1IjdjeoIB4Do10z6X+d+L46WIFxlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tZS7LPCImprP7dTO6IDEHggxn+lqTbWQ4YNe3w9J2P/xQM/Eyq9Z27f8pWMwgA6l9hmDmO+zFvHiiWe51nh0d2khqzJKSy8dFKSL0SrjB8ks/vbPKPaUbkt8dkgoPmV2CQlGMUZU/CChlnSabKiNsX6NEM+qr3TAEj+Yyt7o/aU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XdcgrmNq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XdcgrmNq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 391A5C2BCB0;
	Tue, 17 Mar 2026 14:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773756775;
	bh=jYs0vTmVRT6uOH1IjdjeoIB4Do10z6X+d+L46WIFxlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XdcgrmNqXXotlBDSjDf3kkrGFBoVvlpDG0HQsqbuV2G92ow7qVplsefjhkg3XzcmN
	 1cxFHfIMRmtcQh3qola6xwnJvhs81xGAHWuhPf0A+suAkyurtXLfOUF8QOPKGi0LgB
	 lL9vOF+P5EbHhYqoscjT1yzDICRMjnWUJbJlg+gfubEa8GOU/cIDkuoBy8rNNvmu6E
	 uGafW8gifPOxFYAgkGJOSZ2nBe5vn8scr6MXfjqn5a/itVFoqT7drbVazHsxGMtcwe
	 J7eTY3d9R9+LDNz5uPOVEdOzA5+ltvt+uMxqu6T41SfVuTUbnFWG9h3+VGPbV2Et2O
	 HqHxsJNxw3LvA==
From: Christian Brauner <brauner@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>,
	jack@suse.cz,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	viro@zeniv.linux.org.uk
Subject: Re: [PATCH] fs: clear I_DIRTY_TIME in sync_lazytime
Date: Tue, 17 Mar 2026 15:12:45 +0100
Message-ID: <20260317-weinreben-hofnarren-a6878daccca9@brauner>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260317134409.1691317-1-hch@lst.de>
References: <20260317134409.1691317-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1091; i=brauner@kernel.org; h=from:subject:message-id; bh=jYs0vTmVRT6uOH1IjdjeoIB4Do10z6X+d+L46WIFxlI=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTuTEx6MnGBYfYtrjQzj1e21uKN7NY2XTcevzrv+7xzA X+uwIXJHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABNJO83IsPJsaKV307+b35jm Tosr9Xr2etmpxnPb53ufMHdfkfqefRsjw8/Fvn2X/1fksrjPqt+iLtPpYsSZqn5n0u/a9qMZF2v ecQMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

On Tue, 17 Mar 2026 14:44:04 +0100, Christoph Hellwig wrote:
> For file systems implementing ->sync_lazytime, I_DIRTY_TIME fails to get
> cleared in sync_lazytime, and might cause additional calls to
> sync_lazytime during inode deactivation.  Use the same pattern as in
> __mark_inode_dirty to clear the flag under the inode lock.

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

[1/1] fs: clear I_DIRTY_TIME in sync_lazytime
      https://git.kernel.org/vfs/vfs/c/f8b8820a4a16
