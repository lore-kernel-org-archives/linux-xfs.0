Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDFEE36308A;
	Wed, 12 Aug 2026 07:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786519445; cv=none; b=ri7MRynBGBf/HvQgJp74ls6q+wdRUa4PJUmdqicKj2NLZBBixZ0dAV5ZKr25Pbnviay7XOe/rmV4ABqIvxIc2puyOihXzxxve9QXfxVmN1rGyB2wiuAAR5ZOuwYx4stmbBEO6vQvFjjoxdF0QRecQas9ztlqj2rzFTi2wHz0Euc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786519445; c=relaxed/simple;
	bh=ePyGYXvMexAw1+RgCSMRwkRtOb4A0ZncJ5IIuWCq1HQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Qs0wkHxrGgG0EFvVVNVJi1jz306MrtIaW7EDzkl1QEJOwiLeE6B90Zb2tEZnfY9rOdpWOlFGlTF7S9j8d3XzTBLPXjJduVFUSujuiIthoQssyTd/cZRa2eWpogsIqd7lDQPTwm6SQQMuw44d4u2rtr+5G+NZ2Gygw4jzRZ9nFuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cfLmepCZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cfLmepCZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B73951F000E9;
	Wed, 12 Aug 2026 07:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786519443;
	bh=ANHmF7OQnt54kqaN4Y/em5xG9jmeZGZyEroXodry7Y4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=cfLmepCZj9n/PQ2/KFm8FaHV6du1giCPdv/tHnIyZRqrL+E6EuFIv/+YFMq/Rf+bw
	 hgXKwyxqEJ21OmRkm2opCKeJyMTREtbkO1SK0IDvh0BW7R7Zw/D/N8CkZuLDe/v4yY
	 iz2JFOpWWfcZPqGLCukLO+JIltBNstig/ZLLOlmbe23WtSqCfDhp8NvNYZ0Ix2Oul3
	 8JgzpFWYCrP9IOQsph/NV+dedQcAJS/738UvSzVv6gmAqunQKMlpgOzq6CAYSNmtYE
	 WBsnK3fu/libM2Krc0SFTF0cguCuB7r747NfB0gAVPqbWZqEYMx78VCYdM8WfX7Txk
	 UXEEemVV0wXUQ==
From: Christian Brauner <brauner@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
 Anuj Gupta <anuj20.g@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>, 
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20260804124404.737145-1-hch@lst.de>
References: <20260804124404.737145-1-hch@lst.de>
Subject: Re: fixes for iomap_bio_read_folio_range_sync
Message-Id: <20260812-eigne-jaguar-mimik-48b34250c612@brauner>
Date: Wed, 12 Aug 2026 09:22:50 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.17-dev-362b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1416; i=brauner@kernel.org;
 h=from:subject:message-id; bh=ePyGYXvMexAw1+RgCSMRwkRtOb4A0ZncJ5IIuWCq1HQ=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTVyE88F6mxJcZ1p93p5V1qH/I6kxbl+KySeJ31XuLW1
 QTLyqzijlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgImUOzH8U3x8PHyPYoFyp0PN
 vIbYC0qvq67Ly6QaPjfU5DrNETJ7D8NfsWNSz+tO1b9s2LJTxLz5aceZRueY53XK/k8Vz63bm8D
 LAwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

On Tue, 04 Aug 2026 05:43:56 -0700, Christoph Hellwig wrote:
> fixes for iomap_bio_read_folio_range_sync
> 
> Hi all,
> 
> two fixes for iomap_bio_read_folio_range_sync, a potential kernel
> crash when tweaking the device integrity behvavior using sysfs,
> and a missing bio_uninit that the Sashiko review of the first fix
> found.
> 
> [...]

Since the merge window is imminent I'm routing this through the iomap
branch and it's not really a fix for something in this merge window.

---

Applied to the vfs-7.3.iomap branch of the vfs/vfs.git tree.
Patches in the vfs-7.3.iomap branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.3.iomap

[1/2] iomap: don't free integrity payload that doesn't exist
      https://git.kernel.org/vfs/vfs/c/8a8685b32c07
[2/2] iomap: iomap_bio_read_folio_range_sync is missing a call to bio_uninit
      https://git.kernel.org/vfs/vfs/c/accb6624e383

