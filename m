Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5124341D628;
	Thu, 23 Jul 2026 09:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784798952; cv=none; b=a2WEAeyEElj6PyH6K1YLws0GGwlbsg83RL3BsiXyrTKweia3qm9EyAi1AU7rNVyyYcNWSxLkPr8xtkxPhUp2SxVUGr3M/oH5RKHVSqgoMLNPdZ6XNMrPlYlMuL6/chLo6Wgx5Qoy3f8R4+d/Nho9azGiS8P1yRGUAbGbqYdNkQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784798952; c=relaxed/simple;
	bh=ikndugzpjWuQRwSm8O5bp2QKwrgKM5AuKbQra2cD/ZQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=t4a9+l+7hjbKcCyBYLO7ddPCNwO9LlBhNfSicuyWSgOqFr0y0J+qpFewd2Od76sAiTMDWaji7k/o2BBAF/VEwJ/71ddpYRKRfYHycet5EJBI7/WwXMleePemCgr9d7u6b2WpWv6GMiCMRHNcjYl6ug2DgT8dRwLHOoqheZHIHfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B05BA1F000E9;
	Thu, 23 Jul 2026 09:29:01 +0000 (UTC)
From: Christian Brauner <brauner@kernel.org>
To: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, 
 Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, djwong@kernel.org, hch@infradead.org, 
 joannelkoong@gmail.com, yi.zhang@huawei.com, yizhang089@gmail.com, 
 chengzhihao1@huawei.com, yangerkun@huawei.com, yukuai@fnnas.com
In-Reply-To: <20260713074206.1768006-1-yi.zhang@huaweicloud.com>
References: <20260713074206.1768006-1-yi.zhang@huaweicloud.com>
Subject: Re: [PATCH] iomap: prevent ioend merge when io_private differs
Message-Id: <20260723-spinat-einverleiben-ruheraum-00bae5ad0527@brauner>
Date: Thu, 23 Jul 2026 11:28:53 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16-dev-0e65f
X-Developer-Signature: v=1; a=openpgp-sha256; l=872; i=brauner@kernel.org;
 h=from:subject:message-id; bh=ikndugzpjWuQRwSm8O5bp2QKwrgKM5AuKbQra2cD/ZQ=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQl3rvbm9Px8us29rmtB9fVPOq9a9P7wtKU6e/z0xknv
 VJ2V51811HKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCRr+sZ/teyX7Ne0313F+vr
 /2trHcV+eee5+Z7/+LpjRiP7W17zAFtGhvkLnyw3Y36nKVWW5vDsvVmRc/rqZoWLAp6rcqX5uCQ
 /cwMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

On Mon, 13 Jul 2026 15:42:06 +0800, Zhang Yi wrote:
> iomap: prevent ioend merge when io_private differs

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

[1/1] iomap: prevent ioend merge when io_private differs
      https://git.kernel.org/vfs/vfs/c/c46c369e942a

