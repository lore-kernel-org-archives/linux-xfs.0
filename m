Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794347704;
	b=PEPeOXsmzvpSh9TljRpuqnzrEXs7/vBf7jff00w6K0B37a+7S+8llhIeCFzNCsuImWkU
	 t07ItaEQFIO8eYeiBpqoB6+37OvH5NUWawMralJG9tgGLy97L17Zfcy+8XXSsfdQTH/jt
	 BaQI1pN5vNOAoVym7LMacc3Y+0eIeT9qpbtkZ9FwA6LrpY5SXxWCVn8/xeRNLAbHLUjho
	 k1ggQ+jK80/G32Iwtkqu9N/wvG6nBSmq57tIhMLERfWxgJitTpvxz4w4iisb2zSzBv3Bq
	 qaT487HneACn7g98rBrSQva0xg2HK8DVTL3Xg0JJStwSA3vm4r67xI6GbG2fs9tmgpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794347704;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=Qo2+jRzUK6ef9hbeUahqrraMXl7IGJhVlYVAOScV8ZI=;
	b=FEr9OWS7uZ15PGbzfLI6Frsvq8qlK1CcRvxJ3t3JmxqB+DFhJrktIX5+aND+mCLzM0+t
	 A4DWc8IqDeV9naVG42rlj43PE4PbeCJ3+/J+HrgTX4Zr8mVooLYc7NWkC6ORWmk5+ZWXS
	 nwA7HPmJUu0j9HNkVvhoA9H7D8CnYTvtBi9sJART5NtFHMsvSrtqwXE/0zSbn50y9Nhlv
	 2tFBFbq15U6Baw66G4a4A/JdNKkbJLfF0R3OzPjdOZ7Ry8/lemsQlz0t9daOggJF/Pw2E
	 IGvZhOijR9um+DKckPBVe6xUaBmrBOiFgf7ZExGNnBX8xf5UtiHN8+9nFyh1zRvURmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j22Pvhyi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF8F606A320;
	Tue, 10 Nov 2026 21:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j22Pvhyi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 944791F0089F;
	Tue, 10 Nov 2026 21:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794347703;
	bh=Qo2+jRzUK6ef9hbeUahqrraMXl7IGJhVlYVAOScV8ZI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=j22PvhyilTKnM5nyfrsCHKDdMDuDUmUojoPgdFVX3mAQZV2Hd/EwIcKqe9WVrqR2c
	 MSzVoBQwUnPD6JzsOc+1o53n5QYkcA+nlbqm6dxtbnSJyl1ZOQIiHKoQnYZzRHBowa
	 e4X8dMoJr9bDyOXLzZ3FjgJiGislRrlSph8RedwX838BPRAKN2NO3x0D/Z2w9j2CW/
	 KQxt4VdILN3yV+fYs4w6/qhzADCZGiYz2e1iQFRwWJMpZ2iPogLQ1Bb6gF7gFEd0oy
	 GDOo3T8sD7nRxhmfhzFYGhDL0p+Q5hwG10KJ/zATsmnIkscFJ7zS+hlynFopD1R2yP
	 G8nJmfQnsF5QA==
Date: Tue, 10 Nov 2026 22:54:57 +0100
From: Christian Brauner <brauner@kernel.org>
To: Qu Wenruo <wqu@suse.com>, linux-fsdevel@vger.kernel.org, 
	Jan Kara <jack@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, linux-mm@kvack.org, ntfs@lists.linux.dev, 
	ocfs2-devel@lists.linux.dev, linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, 
	linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 23/34] btrfs: check BTRFS_FS_STATE_RO instead of
 SB_RDONLY at runtime
Message-ID: <20261110-kursniveau-zeltlager-quintessenz-36b26debabe3@brauner>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-23-2f44f64f0b66@kernel.org>
 <c88e4e9c-6b86-4fbb-94bf-909522badf83@suse.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c88e4e9c-6b86-4fbb-94bf-909522badf83@suse.com>

On Sun, Nov 01, 2026 at 01:26:22PM +1030, Qu Wenruo wrote:
> I love the idea. This reminds me exactly why for btrfs_force_shutdown(),
> we have to manually set the fs error without marking the fs RO, to avoid
> exactly the same problem.
>
> With that said, can you also a set_bit() call in btrfs_force_shutdown()
> to also set that flag instead of the exsting setting fs_info->fs_error?

I think so. I'd set BTRFS_FS_STATE_RO in addition to fs_error though.
start_transaction(), join_transaction() and btrfs_remount_rw() key off
BTRFS_FS_ERROR().

Note that this changes some error codes after a shutdown.
btrfs_permission() returns EROFS for MAY_WRITE once btrfs_fs_rdonly() is
true so opening a file for writing fails with EROFS instead of the EIO
from btrfs_file_open().
