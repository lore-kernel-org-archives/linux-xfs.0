Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B65643F54AE;
	Wed, 17 Jun 2026 13:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781702267; cv=none; b=hJ/zX+Aw+4vQjDW+PwZMvDbQNq49qAdT41+LrnMun9Ok34yaD4lpsvczSVSBW4eC+bm1QXf0zjfxtVJu6MnvMNY3mtd/EdL2+bAR7T7Yh39DswB2nZjL9vZaCOSHZDwUM9jEOHYqYo4dB3jxEm1wlYn6BeWrUfT19/MOPh5VDVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781702267; c=relaxed/simple;
	bh=YQeax/jw/6gyy/zMrMRBgesBAxyAFZRrHD/WGCSD4N0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=thopv280K4p1TMgkWC9SWZCMYRKuw74TxTjAeMOgd1mQqzeHWmwKoxRvFy2GapZuzPv7YJ4FyR5rJi8GFqnYIvBeD+3sXBUbCyCfXL8Tt1k3xBTZU7qfT/HcvACiFMkKxWNfSqxGwUi63WNtB399Iqv1NHV7iI9Q95pKq0zZDQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kcseBwJV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kcseBwJV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2A711F00A3A;
	Wed, 17 Jun 2026 13:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781702266;
	bh=h6YWwZA+K4Pgd1tTW/ZkwrOBGEJ3MGr76cKv503XNyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kcseBwJV5sSdm5n0TMibN3g0OeFoi5zDELTFkLsIgFqLwrtX12B2o4ulvI9p4HlFt
	 odwPiRVeOs93mkK2ijAbSNHBgmLGWrJlMWpxDP/6wQzNpuGe2CbpYCPpoETpuf9ees
	 f6gfy/z9wTEXUkvLTGiX5AT/7KUr/SbyZfSEkf4laEciO2xHAyjhORUqgeAi3BDyb6
	 I7Wph4hRWzyHbrmgYWAW68B1dQPJQaqZ1q2k4vQOoQN4Up1uXTUw+YUGkT+odSblpX
	 YKlZRvCVX8nqtViDLl8B+xg6HComcVdFqW0Ua4Y+iUIYfSAo5aJGTKMCEouzZCLmmb
	 3mW20vhz5y4nw==
From: Christian Brauner <brauner@kernel.org>
To: djwong@kernel.org,
	hch@lst.de,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Fengnan Chang <changfengnan@bytedance.com>
Cc: Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH v1] iomap: release pages on atomic dio size mismatch
Date: Wed, 17 Jun 2026 15:17:40 +0200
Message-ID: <20260617-anrief-spinat-gockel-d6afafd0a725@brauner>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260612044041.10677-1-changfengnan@bytedance.com>
References: <20260612044041.10677-1-changfengnan@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1192; i=brauner@kernel.org; h=from:subject:message-id; bh=YQeax/jw/6gyy/zMrMRBgesBAxyAFZRrHD/WGCSD4N0=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQZzSv1mLeHw1bmWvky/YNhGTJfvi28XBcqIynTE7J+5 VuzeialjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIl4/Gb4nxMn8/sL69eMS0+M Tebd7/8/661wNdPha+2f1rYfzHLius3IcNxv4/oH7HdYog/dcmw9n3g86rBwoGPYoi3b9l7jacp xYwcA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

On Fri, 12 Jun 2026 12:40:41 +0800, Fengnan Chang wrote:
> If bio_iov_iter_get_pages() or the bounce helper succeeds but builds a
> short bio, the REQ_ATOMIC size check rejects it before submission.  The
> old error path only dropped the bio reference, leaving any pages already
> attached to the bio unreleased.
> 
> Release or unbounce the pages before falling through to out_put_bio on
> this error path.
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

[1/1] iomap: release pages on atomic dio size mismatch
      https://git.kernel.org/vfs/vfs/c/7d9491184bf7
