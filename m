Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15EB438034
	for <linux-xfs@vger.kernel.org>; Thu,  8 Oct 2026 13:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791466370; cv=none; b=L6VNb+qOCa4fYxcX4p71/t0hyC8upKu1PhEhrOFNlS0Yiw1BSiOIx3FgUIBpViPcF3dU8mlxP+j2kVn7DQiFmzGpmNWJvRb/NJy6K8N2+J64IRVADP8BuxYwgBLVME7NNpZVGFVHLAyEiTonXAnR8cyHwSCRApyXMyXhqJWtKVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791466370; c=relaxed/simple;
	bh=0wt4swKDq1AciQW+208OO7oyv3b1CgoIpeDrpFH1XcE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=gxAkzqzZjW5aqPaN5MjvAT0BxWZioPa9WKYSb5p4zj4ctnrqhtFFBod87LVGmut6hpvn1a9c8rKvzzjG7LIMQndG1BzbQTZRYR9h0kqpcw/AfF1V2WnhQNAqVtZzS++gdMR+aA9S7dpuNXA/oRzgKK0QXooCHKeCEmPnkZ++oC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b66JsnUD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b66JsnUD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F2061F00893;
	Thu,  8 Oct 2026 13:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791466369;
	bh=9z/6glnARVAyVLIKh/TZpBXs3uGrcwOByBp/hUeeKQ4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=b66JsnUDTBALqRwRrE+k/kv6mVTS0i1MwIBjIkabUKiaSOYdZ8SL22E7iZ4yBE/mT
	 7UNk+i3kzdf2Ao43aNxXwIWa7uto7MQyNLTsreru6H6bZG9LLK4LhC+uPcRoUlz30g
	 XD9oAh+JO5dlwm0BvsL0FcHxFmCV9lcCYKenXsfV4ILBkBWUi5rH0ByyP75sRT/9lw
	 VtN7rD8RwbfRwot1955k2KPvNOqWPg8d76j4RGMP7APH5x0OWRuGJeQM63T7DhJdgG
	 MAF1y6dlp1SoSDyo/TO95/IymRuREnoTr9LssH4YU6dImLqH8QyP63voXn1/moEqGQ
	 uChxz4rKUe62g==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
In-Reply-To: <20260925151841.3385994-1-hch@lst.de>
References: <20260925151841.3385994-1-hch@lst.de>
Subject: Re: small cleanups to help code sharing with xfsprogs
Message-Id: <179146636820.378461.3177122289571282177.b4-ty@kernel.org>
Date: Thu, 08 Oct 2026 15:32:48 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Fri, 25 Sep 2026 17:18:25 +0200, Christoph Hellwig wrote:
> this series has a few trivial cleanups and code moves that help
> sharing more code with xfsprogs.
> 
> Diffstat:
>  libxfs/xfs_attr_item.h     |    2 --
>  libxfs/xfs_bmap_item.h     |    2 --
>  libxfs/xfs_buf_item.h      |    2 --
>  libxfs/xfs_defer.c         |    1 -
>  libxfs/xfs_exchmaps_item.h |    2 --
>  libxfs/xfs_extfree_item.h  |    2 --
>  libxfs/xfs_inode_buf.c     |    3 ---
>  libxfs/xfs_inode_item.h    |    2 --
>  libxfs/xfs_inode_util.c    |    1 -
>  libxfs/xfs_refcount.c      |    1 -
>  libxfs/xfs_refcount_item.h |    2 --
>  libxfs/xfs_rmap_item.h     |    2 --
>  libxfs/xfs_rtbitmap.c      |    1 -
>  libxfs/xfs_rtgroup.c       |    1 -
>  libxfs/xfs_sb.c            |    1 -
>  libxfs/xfs_trans.h         |    2 --
>  libxfs/xfs_trans_inode.c   |    2 --
>  xfs_platform.h             |    1 +
>  18 files changed, 1 insertion(+), 29 deletions(-)
> 
> [...]

Applied to for-next, thanks!

[1/4] xfs: remove various unused includes in libxfs/
      commit: 6fe0d151eaada4f3ea4947b19ac048b8894b9e88
[2/4] xfs: include <linux/iversion.h> in xfs_platform.h
      commit: 5e68008e9c0d5ec602582dd659d4d1c6f910ef4a
[3/4] xfs: move xfs_*_item.h to libxfs
      commit: 834a6a1e9633722df3bfde5f4fa830432faa360a
[4/4] xfs: move xfs_trans.h to libxfs
      commit: ce47e8aab95d6bd4f70b9cbc7308ca13b9d57660

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

