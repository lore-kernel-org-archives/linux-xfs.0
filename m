Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA39436B046;
	Mon, 11 May 2026 13:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778506523; cv=none; b=B/Vma0mbF8H9LKa+3qBCOWAkb7lYG6kRaiAwlTLRlCBLH9mPK260nl9jGuj8ekB7PhwKOFVuC/pFc0DOp+XxeInGanjOpVh2zD8ZWMrojbqQeB61iBHPJlr54K0LiacBjRI1j6K6GRw1jdYKZzIAxTAlYM92FBpj9hPdqaoqmks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778506523; c=relaxed/simple;
	bh=aVQNdzvXvNFffZHJzxyCbh2eAE0NctTMJtkHEBBuerY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VFONgW2oLOtp7To7aUX6+lm0WZGmmWyExU64cS+LdbJHEWtbZ0K/r/hrIwO4/93LkekmODqJhxdlp9HvktPSbEsMpxIrr8qUIe38rJgM34vd3UCUxxjE0VUTSgUcGEO7J6+JLo4nJU2wHU1dJoop5aVU3c++BVtoQ4BGCFN/IYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UPQU//Uk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UPQU//Uk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA1FFC2BCB0;
	Mon, 11 May 2026 13:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778506523;
	bh=aVQNdzvXvNFffZHJzxyCbh2eAE0NctTMJtkHEBBuerY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UPQU//UkmZQx2HQCZU1AQ1WtMIGBEx2hnoe+8Pl5Oxl06bNLBumegHGOUKwYQHCSK
	 X0xsPJHPPfZpgNsIyr8/CVLhBM3sgsWahN0rBRqnhC2b5+qMRbXrIYSJoQ3DlTTpd/
	 iPBOJehN/E7WrCDdPhMtEbxstqQuzxl87EBYg40K2h5oA9Pe4XGlnH/QC9Umw/s6hO
	 yBqdv7sI1SMtqEyfAtITiavxHbLmbnxShpoLe6jkq/Si9TtWlL/BhkUx9dt22HLMv2
	 xe04YPiimr3MQrGZ09bFq/Zb7Pq+OTWEKPRLIfpTQaoFOVPcXyZKksoC+M9BQdWM9+
	 6cKUGmvVxXdHA==
From: Christian Brauner <brauner@kernel.org>
To: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Chi Zhiling <chizhiling@163.com>
Cc: Christian Brauner <brauner@kernel.org>,
	chizhiling@kylinos.cn,
	djwong@kernel.org,
	hch@lst.de,
	linkinjeon@kernel.org,
	sj1557.seo@samsung.com,
	yuezhang.mo@sony.com
Subject: Re: [PATCH v2] iomap: add dirty page control to iomap_zero_iter
Date: Mon, 11 May 2026 15:35:16 +0200
Message-ID: <20260511-weilen-mitarbeit-556fe3cbd810@brauner>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260511094007.728011-1-chizhiling@163.com>
References: <20260511094007.728011-1-chizhiling@163.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1279; i=brauner@kernel.org; h=from:subject:message-id; bh=aVQNdzvXvNFffZHJzxyCbh2eAE0NctTMJtkHEBBuerY=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQx3hY18JhY8jFALPniTYsjyW9sw9aqP7WslXnhX/dNv NCkeWZ2RykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwERqwhkZZl9eY/KvxvK87JuD 69/u6W+bInFn3btgwfpbW3+umbEyiYnhn96pjyd8hF3tT121TVgy9+Ae2wULKifGR5QZvCv/dmb 5ai4A
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

On Mon, 11 May 2026 17:40:07 +0800, Chi Zhiling wrote:
> This patch prepares the iomap framework for exFAT's upcoming migration to
> iomap. During testing of the exFAT iomap branch with xfstests generic/299 on
> a VM with 8GB RAM and a 40GB disk, system unresponsiveness was observed.
> 
> iomap_zero_iter() lacked dirty page throttling, which could cause memory
> pressure when exFAT's valid_size mechanism triggers large-scale zeroing
> operations during writes beyond valid_size.
> 
> [...]

Applied to the vfs-7.2.iomap branch of the vfs/vfs.git tree.
Patches in the vfs-7.2.iomap branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.2.iomap

[1/1] iomap: add dirty page control to iomap_zero_iter
      https://git.kernel.org/vfs/vfs/c/ecf22101ba7a
