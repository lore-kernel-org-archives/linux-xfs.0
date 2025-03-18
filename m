Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D530B14D2B7
	for <linux-xfs@vger.kernel.org>; Tue, 18 Mar 2025 14:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742308269; cv=none; b=O8Lwt9R1Y0ufXYFz6S1NRqFZDm699W/EfiImNa3kdQLvbXx6rRYz8ddmmTYOEwz7jiAY5B4LB7v+WUKXY/3YZ786EeCX/25aiVO+ian55gaJ1XLPQUgfCopWnp5amE1TkEKa5T6845g9zpPtqSE6Wk5SocWNgDPJI4ScxcQSuxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742308269; c=relaxed/simple;
	bh=47xishN/2isx5VNrWBwAeQ55g8VPyOl0AmFHz/X/jeM=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=CaEQocgLYvpM+r122FXXQ9wqPdH+lYMcULbkl8ZTf2PdHcbk2VDJf9ub9OW4tOSueSfzwHyVKttuD3oszPsZOSDZb0DYbIauLWZa23rUoLrqVPx0hfPgDa8f2Kr5fSs24lHdhdfgQNgVDAyTBcw4woMACWH7sbC9v7aTKsW66+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FmKHBe6w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FmKHBe6w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAC60C4CEE3
	for <linux-xfs@vger.kernel.org>; Tue, 18 Mar 2025 14:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742308269;
	bh=47xishN/2isx5VNrWBwAeQ55g8VPyOl0AmFHz/X/jeM=;
	h=Date:From:To:Subject:From;
	b=FmKHBe6wKfwbqGqcR+5Lc3h1QG9jtSxyFlRPp9zqLQg5tK5DfUYb8hHDgNdH6BayM
	 zw0DxXlGq7Qa8QCvNIqRFwsSKTvElUC3xChE0g+Dnpz6LSTDZjmhLNl0rFBPUs6ZEk
	 TJnedbG4qLoDBuzqdQgg63dWAUuMy4HQ2lOuDaMKrqJbFw0oc5ioGn3N8W+X4ghDRt
	 J4KD3MdBpkvx5TmsqxE0kBz74h/ZKr8Q2zRQhvdeHDu7m4SSkw0hT0ePQ22MC/OCSP
	 d3kL5JJathoRFfRCipDSc+sLP2nkFollYkoXHgKxM/TFOPVKYRgjS6JksFVap+YIyi
	 9AZccJIKeVVIg==
Date: Tue, 18 Mar 2025 15:31:03 +0100
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to cdb809a573c4
Message-ID: <yy7l73guynwfsakgxknvodufxcse75wkygbyjpu7cdc23iamlx@ebmiw2qs7lf7>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

cdb809a573c4 Merge branch 'xfs-6.15-cleanups' into for-next

This brings for-next closer to Linus's/master, so I'm omitting the
regular list of patches due the amount of commits.

Follows a small summary of what xfs-specific commits this push contains.

cdb809a573c4 'xfs-6.15-cleanups' into for-next
1e4352ed7f6e Merge branch 'xfs-6.15-zoned_devices' into for-next
b3f8f2903b8c xfs: remove the flags argument to xfs_buf_get_uncached
8d54b48fef67 xfs: remove the flags argument to xfs_buf_read_uncached
44e1f90b1605 xfs: remove xfs_buf_free_maps
5abea7094bdf xfs: remove xfs_buf_get_maps
1ec1207722c8 xfs: call xfs_buf_alloc_backing_mem from _xfs_buf_alloc
34ba1fcd7456 xfs: remove unnecessary NULL check before kvfree()
c3a60b673a22 Merge branch 'xfs-6.15-folios_vmalloc' into XFS-for-linus-6.15-merge
8e6415460ff1 Merge branch 'xfs-6.15-zoned_devices' into XFS-for-linus-6.15-merge
f56f73ebf8bb xfs: don't wake zone space waiters without m_zone_info
9ec3f7977a32 xfs: don't increment m_generation for all errors in xfs_growfs_data
beba94871381 xfs: fix a missing unlock in xfs_growfs_data

-- 
Carlos
