Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A64238C2A9
	for <linux-xfs@vger.kernel.org>; Tue, 26 May 2026 09:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779789417; cv=none; b=iXUBo9hpUn6kb3O53f5/vmKvR4Gg1zLl0JkrXH7441mDJ7lFYyDzguw6JkcqsnFk5R2wEmJrl8tI+wow1+SVWzXp68XPtCaC4KnHbhK5/4JankL6r5SS98XcA7Nw2lvKVW04ww8yDWn9KWPcVBta/rKsPO/O+o+aG0FmAH10kFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779789417; c=relaxed/simple;
	bh=6DNiYusiPgUa0tGC4zzIjpsnvgiLJpuYXPSGucfgApI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=a8q9kRAjmcWDuDTF9edUxgSC4jDQoJ2PXCtup2vNqkfdL5ZITm23HgwYPUXY7iJCFtGOztXvyxO69+ow6tQLibYFp5J6QTH5SIxyLs8edbm6Y0A7NLlxEKDffa0db9+JZNOSRWBfp8VkbH1jlcOeB003UWKcd+CfRRz3Ol2X0Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SpK55+nQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SpK55+nQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14B671F000E9;
	Tue, 26 May 2026 09:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779789416;
	bh=eUVQDjdOrWHl4twJJN9eUCBtZQNR8sD8UZZUNjkW89Q=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=SpK55+nQww5P4qVrLugMgCq2PcXGzuQW6uv+gxoQ1lf8zqFjYTMznZZHwqD83RcFw
	 /INfLbVBOV0kprKEqB5UI4zmYTFIJaPz+sEoq2np5AcAyyxQkFCX4+hIiLMpRSJZJB
	 y+uwr2ZFxbhYaCaY/FdNZ7d3UV6WYYytLLcZqHdZwOVmMe1C0E54gpvB4rCNzoi+/b
	 YM5FyeRBjRdLDmqfgorMdyM7BrO72tJjie+JJFv7tgqyjGvbr8obqoCjh4t3f6l9BP
	 h2MsriqWzvsEjY/4G0zDlYyDyU0VnqgwTQEoUqVqXMPfloOLwBwF4WX3vC4fmcpBC+
	 Kehqy/Ei9D0+Q==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@redhat.com>, Dave Chinner <dgc@kernel.org>, 
 linux-xfs@vger.kernel.org
In-Reply-To: <20260518060209.502179-2-hch@lst.de>
References: <20260518060209.502179-1-hch@lst.de>
 <20260518060209.502179-2-hch@lst.de>
Subject: Re: [PATCH] xfs: fix a buffer lookup against removal race
Message-Id: <177978941479.58275.15523992116589847341.b4-ty@kernel.org>
Date: Tue, 26 May 2026 11:56:54 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Mon, 18 May 2026 08:02:05 +0200, Christoph Hellwig wrote:
> When a buffer is freed either by LRU eviction or because it is unset,
> the lockref is marked as dead instantly, which prevents the buffer from
> being used after finding it in the buffer hash in xfs_buf_lookup and
> xfs_buf_find_insert.  But the latter will then not add the new buffer to
> the hash because it already found an existing buffer.
> 
> Fix this using in two places:  Remove the buffer from the hash before
> marking the lockref dead so that that no buffer with a dead lockref can
> be found in the hash, but if we find one in xfs_buf_find_insert due to
> store reordering, handle this case correctly instead of returning an
> unhashed buffer.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: fix a buffer lookup against removal race
      commit: c69439a891ccb37ede5d68539636337c6bd92fab

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

