Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793890430;
	b=yfz3EKgPFuaAIPO5SXbUF014SOVr3z2NY/PRn+EFTqt8ejR9mLDVY1gvcgjI+qZcGUkq
	 DlXLIOK2WBrd7qr9cqUTjoT0ki+kEmabd9Vn68+fPenKGUi29tS1FonivW66Iw7zEqYsX
	 dKPrYSVQu8FvtrQXyeb1KgdyGmG6kFMFZGcfp1uUwglOeP5232mJJnjw1q+IO6EidOtNA
	 rXYQhVCbjvC3jzHAJAfytg8SXZ8qFl4qnior36BASQmwCqvmNya/gnco+D2wm0pM2W5BV
	 uFCKFPx/M4RUS1OSDZ1N1lJVcu0Bk06gh5n3cPIXKNtxxbTA0MRtToa6P7y47Wppuow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793890430;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=wPbepQK0nXa3d+APg5PI/tkZrq+GYAAdAwwH4WGsWbY=;
	b=Y9+CFhj/b9FpS8EFwqIkfFgVs2IS8hDWQM9YpoY0Z4ncz4HffuEPytODbAb6LEe8rG6k
	 2igOMz2gN8SZ2+XkD9p5xLOJzkQYF4lhTH3dhlBqwNey9q3M9JhyQjN/IjlS1hPS3lnLF
	 CJulxa93RyfFMkOuRh5UWmdXNxLzAdv2hs3o6XOqRdvR4ngU6IuMc7zL4IOzk0tgQrWPv
	 +M8cT2gaPLybbYd683MKdFqzV/ZJxdTwhaaSiqIvqAt+UoU9XRwsVNkwQpLjZLdfwbk/Q
	 10ATbX/sE0c+7O/Wtco2Czwf7vtf1qaXy/bDrPc6qo1rcZF5JGfq8QO9RObm5iYAzYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ut5GHx1c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68478606A31B;
	Thu,  5 Nov 2026 14:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ut5GHx1c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D97821F000C1;
	Thu,  5 Nov 2026 14:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793890430;
	bh=wPbepQK0nXa3d+APg5PI/tkZrq+GYAAdAwwH4WGsWbY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=Ut5GHx1crAV6ebP6MePvr8MXk/GyT0+FpLEitkajin2i4CdPw+Yrtsn4y98BfiUN1
	 N5M8uMplNy3HVs3tsDHiskLMCirCzDYJLH1YChJ873MiyF54lHZDXJpdC921S8r6UY
	 u3+OiCEt9QofdI3ELaU45FuLyS3AQsq9EKyKjBS49hNruPLkniq7Sn1gwN1Ijsp3ZE
	 k3HoSzSpTSJjYII5amdBqdc518vEianS+2iHu1aqzoSAlTADTeS/jb2r7Ox+BW6Q76
	 +A2NlXx48M50dddQdU7vSVLAFFZAmWxj3xeXuHK9T8tzNWep7+oKoJ4AB3z4vN9UXm
	 Pyt/6mjIDSpWA==
From: Christian Brauner <brauner@kernel.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, 
 "Darrick J . Wong" <djwong@kernel.org>, changfengnan@bytedance.com, 
 kbusch@kernel.org, Matthew Wilcox <willy@infradead.org>, 
 Jan Kara <jack@suse.cz>, Jonathan Corbet <corbet@lwn.net>, 
 David Sterba <dsterba@suse.com>, Gao Xiang <xiang@kernel.org>, 
 Namjae Jeon <linkinjeon@kernel.org>, Theodore Ts'o <tytso@mit.edu>, 
 Jaegeuk Kim <jaegeuk@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
 Andreas Gruenbacher <agruenba@redhat.com>, 
 Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>, 
 Hyunchul Lee <hyc.lee@gmail.com>, 
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
 Carlos Maiolino <cem@kernel.org>, Damien Le Moal <dlemoal@kernel.org>, 
 libaokun@linux.alibaba.com, bfoster@redhat.com, linux-ext4@vger.kernel.org, 
 linux-xfs@vger.kernel.org, Viacheslav Dubeyko <slava@dubeyko.com>, 
 Ryusuke Konishi <konishi.ryusuke@gmail.com>, linux-nilfs@vger.kernel.org, 
 fuse-devel@lists.linux.dev, Zhang Yi <yi.zhang@huawei.com>
In-Reply-To: <20261027215326.2693300-1-joannelkoong@gmail.com>
References: <20261027215326.2693300-1-joannelkoong@gmail.com>
Subject: Re: [PATCH 0/5] iomap: remaining patches for iomap_iter_next
 conversion
Message-Id: <20261105-tiefbau-gesurft-apokalypse-d83b3a572db4@brauner>
Date: Thu, 05 Nov 2026 15:53:41 +0100
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.17-dev-ce4c1

On Tue, 27 Oct 2026 14:53:21 -0700, Joanne Koong wrote:
> This is a resend of the last 3 patches from the "iomap: convert to in-iter
> iomap_next() model" patch series [1].
> 
> Those 3 patches are rebased on top of current mainline (commit 83f32c773255
> ("Merge tag 'erofs-for-7.4-rc1-2' ...")) in Linus's tree. They require two new
> preparatory patches (patches 1 and 2 in this series), which are trivial
> ->iomap_next() conversions of the nilfs2 and fuse iomap code that was added
> during this merge window. There were conflicts with "iomap: pass
> iomap_iter_next_fn directly instead of struct iomap_ops" (patch 4 in this
> series) during the rebase. These are resolved in the patch, which now also
> converts the iomap users added this merge window (ext4 iomap buffered I/O,
> exfat swap activation, nilfs2, and fuse ext_map). Jan's Acked-by and
> Christoph's Reviewed-by on it predate these changes.
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

[1/5] nilfs2: convert iomap ops to ->iomap_next()
      https://git.kernel.org/vfs/vfs/c/a210eb87cd3d
[2/5] fuse: convert ext_map iomap ops to ->iomap_next()
      https://git.kernel.org/vfs/vfs/c/f6c38b3d56c2
[3/5] iomap: remove ->iomap_begin()/->iomap_end() legacy path
      https://git.kernel.org/vfs/vfs/c/82f677376a90
[4/5] iomap: pass iomap_iter_next_fn directly instead of struct iomap_ops
      https://git.kernel.org/vfs/vfs/c/9e8fc16dc6b4
[5/5] Documentation: iomap: update docs to reflect iomap_iter_next model
      https://git.kernel.org/vfs/vfs/c/5612225809c7

