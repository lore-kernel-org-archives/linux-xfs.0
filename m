Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C20C283FDC
	for <linux-xfs@vger.kernel.org>; Mon,  3 Aug 2026 13:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785763388; cv=none; b=qfbLxL1Pyjz/UeycpiK8+jlQa7HxtmATiwcFUHd7v+CBGjG99JZa8Ky6wnwC2axKp/rLxYQIj8d3v82j3vr4/BdLYIdw83GCNX2iJUqv4YxiU1muDS/OQdZkE2GtyaQEg5WDJAy9UiTjwgh8Drz4BSkC4tD4RhcIxdnnO8mKAnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785763388; c=relaxed/simple;
	bh=EqxLCgMUCmBcWqfbvQB2TjHt0YrR4HDcHD0DczHFOYk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=CwwMS+AyCtUDSq7qgf0TE+NXnrMRO6icPryo6H0JNRgcBLs8V72EY4V701VRq3tn16jQdFy8qdmQ1cmW8FwLbd2gEOLfAkojVF+m3/CtJqBBlhzIMFItuNTahpsHYHL3Ah9lZX7P3Dcx7yQ/OKuYvtgN+Sp6v89XyKm16+/bA9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TNk2pPPL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TNk2pPPL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9CD91F00A3F;
	Mon,  3 Aug 2026 13:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785763377;
	bh=QWd1wZ0a9FToRaToip0cbva8TRUCgfASSPf7kOVJF3o=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=TNk2pPPLBL+vRxFLbccm7ILUPc7hASwLw1fcTsVXaNJGAmunfS6LQjtU5EkbwHXw3
	 ux4q2Oqh6UhK+A7aZsqrdIvHL5suJgkPGeJNs2KBb8XUuZHmKvXv18zN1hGGexMNrQ
	 UCKTAfNVU3wgJgkwx6uDg8F/0GpM5CKKi0revs8FmW+qL/NWj4b+JTDvV82uk1yCgs
	 /I/Y6NzMLe5Podrp4fk/sDPGBo9QGZB/F2IdgevwMULShkMsN4kY5+VOQUbqf6PI7C
	 JS/z7EsIs/r8mMU6dmrZwZvtLaIWGKq+Kz8JGzkgN4U+X5m9P2QduBoMWboXyiXfiP
	 XqFpuQrdxUHeQ==
From: Carlos Maiolino <cem@kernel.org>
To: djwong@kernel.org, Long Li <leo.lilong@huawei.com>
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com, yi.zhang@huawei.com, 
 houtao1@huawei.com, yangerkun@huawei.com, lonuxli.64@gmail.com
In-Reply-To: <20260727023849.3247961-1-leo.lilong@huawei.com>
References: <20260727023849.3247961-1-leo.lilong@huawei.com>
Subject: Re: [PATCH 1/2] xfs: fix ilock leak on error in xfs_dq_get_next_id
Message-Id: <178576337549.315832.9498033159549351533.b4-ty@kernel.org>
Date: Mon, 03 Aug 2026 15:22:55 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Mon, 27 Jul 2026 10:38:48 +0800, Long Li wrote:
> xfs_dq_get_next_id() takes the quota inode ILOCK before calling
> xfs_iread_extents().  If xfs_iread_extents() fails, the function returns
> immediately without releasing the lock, leaking the quota inode ILOCK.
> This can leave the quota inode locked and cause subsequent quota
> operations to hang.
> 
> Fix this by jumping to a common unlock path on error instead of returning
> directly.
> 
> [...]

Applied to for-next, thanks!

[1/2] xfs: fix ilock leak on error in xfs_dq_get_next_id
      commit: 63320a0f70f66f311f4bccff3af0719c2119f46c
[2/2] xfs: don't swallow dquot recovery verification errors
      commit: e2b4a856085e9bd939bde2dee0d08b1d41babde9

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

