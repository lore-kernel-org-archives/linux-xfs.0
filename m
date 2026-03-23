Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96AC7390CBF
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 10:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774262837; cv=none; b=C5GsVcaOiuJuyynrG8ATWhPUjrbQ5aq0w4iB1Ar2i6J7oLBKSPj7LgjwjsOXXddoUVTaxz3cfpb3izVOyI439sBSc7PnINS9AmeiyaArkSpp0xAgv8m47JdK3f9x+o+aK5Ix1wcusJbIlS2OmqV2dJTqbvWrLKOWCLSziZCluBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774262837; c=relaxed/simple;
	bh=+jZsqPeTbmVHcFfkv9JA7LSFDiQpciIRXsedVcey+ow=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=qFapx16D/4SMBPFj1yLGXSsBDcHSGikk2pE+8S3GL0fKlkj6vVk/WNEIUVylGzC/UUl2/eHFKPeUFa1B9IInIkFYZOzTMj8ACOjjQB5Dy3V5GVkaKDHx1J4C0Un4ky91B2SGUgejkaA0R25T8vDub3sv/YckdoXhGe+i5T66U6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uxAbkA7y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uxAbkA7y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AE76C2BC87;
	Mon, 23 Mar 2026 10:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774262837;
	bh=+jZsqPeTbmVHcFfkv9JA7LSFDiQpciIRXsedVcey+ow=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=uxAbkA7yqKFuzs8x+j7GwC/QElQCPScuMZ7+Xtd7+wtAREl7OD0UD2GuvMAUxJZNp
	 vWYb/v+vXogEqgenidTc/esBuE79/rihdnq8rto8RaiCK9AVwZim+I/BfyE1RS1PwD
	 6SUme3dOyU80BEOcOOJQBdVKOH4y1J53mWPfajsads3V7Xk5JUpyCSpNQlmHIt0RwU
	 A0OAxm93pobbMbT+0Yt7r1mauL+LJ+0es3SPVkgys+mLoy1C85X5E+5/3IVOV5mov8
	 rZSSDyTjBbNVc1Ez60JbA5YjMUMCC94DB3SZcfh3qSB2pJVJ7ALK2sFkF0QxpxKRKU
	 +AXjoUVuXK5Pg==
From: Carlos Maiolino <cem@kernel.org>
To: djwong@kernel.org, Long Li <leo.lilong@huawei.com>
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com, yi.zhang@huawei.com, 
 houtao1@huawei.com, yangerkun@huawei.com, lonuxli.64@gmail.com
In-Reply-To: <20260317015155.589955-1-leo.lilong@huawei.com>
References: <20260317015155.589955-1-leo.lilong@huawei.com>
Subject: Re: [PATCH v3 0/4] xfs: close crash window in attr dabtree
 inactivation
Message-Id: <177426283527.254917.6887717145238910027.b4-ty@kernel.org>
Date: Mon, 23 Mar 2026 11:47:15 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Tue, 17 Mar 2026 09:51:51 +0800, Long Li wrote:
> Problem
> -------
> 
> xfs_attr3_node_inactive() cancels all child blocks in the attr dabtree
> via xfs_trans_binval(), relying on a subsequent full attr bmap truncation
> in xfs_attr_inactive() to ensure log recovery never reaches the root
> node.  The child block cancellations and the bmap truncation are
> committed in separate transactions, creating a narrow but real crash
> window.
> 
> [...]

Applied to for-next, thanks!

[1/4] xfs: only assert new size for datafork during truncate extents
      commit: e942498385bf80f4d6d075b47174035545eb6a2e
[2/4] xfs: factor out xfs_attr3_node_entry_remove
      commit: ce4e789cf3561c9fac73cc24445bfed9ea0c514b
[3/4] xfs: factor out xfs_attr3_leaf_init
      commit: e65bb55d7f8c2041c8fdb73cd29b0b4cad4ed847
[4/4] xfs: close crash window in attr dabtree inactivation
      commit: b854e1c4eff3473b6d3a9ae74129ac5c48bc0b61

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

