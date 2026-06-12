Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAA7C36CDF8;
	Fri, 12 Jun 2026 08:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781253419; cv=none; b=gS1etCCkbU+ujWQVHbjtspQB4cMZC2XG2F9U53XhdPKPtNwI9nt/WSTr3OnCn8aOjHh6GPKWywNTXuCUJbvpyiH8PJkvjiDkrPPM2JY9gZgGDl7WiksvTza93aQVOYLzZFCe6mTCcx9vz76Ksz1KO3LsjWW+/yR5sQ9O5eeqswU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781253419; c=relaxed/simple;
	bh=IuGGseWOVCfoHXg2LbnaggGY5OaOW4hKPqDXnbTD1xQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=AgAPuvT13MHN/ODk9l+RIqGv09/vrT/6Jwn7/KkpwarBN34BIBxIsAOq1Sf0F8hOzztLsm7m0kJbh8EvL+bnIFRqJEgt/jkgaaCkSy232BHQX1ait6GHS5hzw3YJLvffWfOPDPuLH4Oar9uQVLCIpOl9MPT2Huf6BPEPCYEqrC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XAdBVqu7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XAdBVqu7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1E901F000E9;
	Fri, 12 Jun 2026 08:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781253418;
	bh=1k2/SQbUe+g1ODkDKUO7jS3+EmaqfuxLZY0hNXNtF3s=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=XAdBVqu7OXD4c8OOkBz4MuFgUGwTuPu1XaP7dRA/Y7idaiStq0I5ojmP8Ew+jD5ns
	 2KLWLRb5RHCgpOJUj/ZW2yImm9ZrmuVRU2wpgvvvItn2taJ4+4tYWv/BzjPO9XnmNt
	 yqJJsVLGnbJCspIq8LZK5DN2EWGAUatLKKz475JYFX69lTIoyI93beMx/UEE7fu/hB
	 gQ2HMh+cl2i9gjYU9+50RKv5mpZD96Q9wJxhtrXfglgKfCP8RAQGZargQNBhXv9gvF
	 xw4n+dGB/UKy9K/9lSKtPLsiG9XqzhXEIDateTsSMcyNDByJA4QvIl56sbm0k81fs/
	 aNlanUsLn/YpA==
From: Carlos Maiolino <cem@kernel.org>
To: Mikhail Lobanov <m.lobanov@rosa.ru>
Cc: djwong@kernel.org, david@fromorbit.com, hch@infradead.org, hch@lst.de, 
 linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 lvc-project@linuxtesting.org
In-Reply-To: <20260610191904.12533-1-m.lobanov@rosa.ru>
References: <20260610191904.12533-1-m.lobanov@rosa.ru>
Subject: Re: [PATCH v5 1/2] xfs: skip inode inactivation on a shut down
 mount
Message-Id: <178125341655.29986.6772692930873936274.b4-ty@b4>
Date: Fri, 12 Jun 2026 10:36:56 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2

On Wed, 10 Jun 2026 22:19:03 +0300, Mikhail Lobanov wrote:
> XFS already declines to inactivate inodes on a shut down mount, but only
> at queue time: xfs_inode_mark_reclaimable() calls
> xfs_inode_needs_inactive(), which returns false when the mount is shut
> down ("If the log isn't running, push inodes straight to reclaim"), and
> then drops the dquots and marks the inode reclaimable directly.
> 
> An inode that was queued for background inactivation while the mount was
> still live is not covered by that check: the inodegc worker still calls
> xfs_inactive() on it even after the mount has been shut down in the
> meantime.  Inactivation modifies persistent metadata and runs
> transactions that cannot complete on a shut down mount, and it relies on
> subsystems (e.g. quota) that a torn down, or never fully set up, mount
> may not have available.
> 
> [...]

Applied to for-next, thanks!

[1/2] xfs: skip inode inactivation on a shut down mount
      commit: 07e2939ddab876d68d661ebad6c4eedec98193b8
[2/2] xfs: shut down the filesystem on a failed mount
      commit: 804826eac53cff44f88f42989fcc601c2612c0ed

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

