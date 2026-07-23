Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8CD73E8351;
	Thu, 23 Jul 2026 09:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784798818; cv=none; b=Gkyk3rEIq9WcPaoNedqPOEid4ePNpJGDES+3iyV0oDVh7j8eCTjwcjBvRkH1eicNNrpc9ZjTMlcs0uAYbFqeUvGglCJJR/FooOtQn2XPZtmJkghijA7fEDTI0QTnTXIguCf/e426TKdwwiliTHaP+oHPtIuWi5k42bmd5ZZdagk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784798818; c=relaxed/simple;
	bh=HEKfcw6nF/pqRAQU+NkoqeprFBy5Cg73LWMYHehTP/U=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=iCqpzK2Fmsvdw09lMpMKjrKIbcf210rH6P3kKuSu6nBdJ1LNzxiA88X0jFZw5WheweEUuUTq76B2ODUOwldaz2eYZicVELCR2+23XPiYRWIZtlEF9dskWkJWAWY/01UwYvUOo8gRX9IOssZiMN5PQXzQD46OD53suTRVcQLM9h0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D71E1F00A3A;
	Thu, 23 Jul 2026 09:26:53 +0000 (UTC)
From: Christian Brauner <brauner@kernel.org>
To: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, 
 Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, djwong@kernel.org, hch@infradead.org, 
 joannelkoong@gmail.com, yi.zhang@huawei.com, yizhang089@gmail.com, 
 chengzhihao1@huawei.com, yangerkun@huawei.com, yukuai@fnnas.com
In-Reply-To: <20260714082325.325163-1-yi.zhang@huaweicloud.com>
References: <20260714082325.325163-1-yi.zhang@huaweicloud.com>
Subject: Re: [PATCH v4 0/5] iomap: trivial fixes for ext4 conversion
Message-Id: <20260723-krone-voneinander-meilenstein-8bb10860f5f9@brauner>
Date: Thu, 23 Jul 2026 11:26:49 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16-dev-0e65f
X-Developer-Signature: v=1; a=openpgp-sha256; l=1518; i=brauner@kernel.org;
 h=from:subject:message-id; bh=HEKfcw6nF/pqRAQU+NkoqeprFBy5Cg73LWMYHehTP/U=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQl3os9H5dzd83arxsNqrxD733SvRd2f/uHvw+beVrfb
 urX/8P3uKOUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAix7cz/Hf77fFDm2Pn4mLJ
 U4rGZb7tuVOj1z85LbTQTizl7BSJTdWMDBtlam8qvRKzV/t70niOdD4Dd1Z0ytV9fyor9fRrfjS
 bMAAA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

On Tue, 14 Jul 2026 16:23:20 +0800, Zhang Yi wrote:
> iomap: trivial fixes for ext4 conversion
> 
> Hi,
> 
> This is v4 of the trivial iomap fixes for the ext4 conversion. There are
> no code changes relative to v3, the only update is the addition of a
> Fixes tag in patch 03.
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

[1/5] iomap: correct the range of a partial dirty clear
      https://git.kernel.org/vfs/vfs/c/a8d61f707f72
[2/5] iomap: support invalidating partial folios
      https://git.kernel.org/vfs/vfs/c/60eb51b9fbe4
[3/5] iomap: fix incorrect did_zero setting in iomap_zero_iter()
      https://git.kernel.org/vfs/vfs/c/b85d5446ca3f
[4/5] iomap: fix out-of-bounds bitmap_set() with zero-length range
      https://git.kernel.org/vfs/vfs/c/62a9223d3b01
[5/5] iomap: add comments for ifs_clear/set_range_dirty()
      https://git.kernel.org/vfs/vfs/c/2da2f909f8e6

