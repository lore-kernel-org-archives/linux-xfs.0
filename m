Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0D319F42F
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jan 2025 10:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738061871; cv=none; b=Wpn23q+DZ6AjfKgXah5Zyqp0n0+5uT+kG+QlxYIH5MYBA1dJYFGNY0FH9FQkpISyhyITzjD6cY8kAPSUGup8tWJzhyJlh0wvNTqqv5/7o69KjygRj+dYNCf9WBZg1kXY3J9zKxHU4zuTteAcFYcGr3z1SpAu7IhxL2PpnIDWUmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738061871; c=relaxed/simple;
	bh=wQsKplMXpgAe7J5b6GIUpzuSaxdndrA8Ub758kgEF30=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=sNrm9JyaWfdRmf9KlJ3OYNkKVpDDx0eB+TKiYdnwfP5ZiewUHUNGmIFE8I6wx0FLjpRUchWDH1MJ8fTeuI9Ghjs+x4dELb7kYhKqTk6kmHdHN/+M9LUjOgXhdzpxXTIWTseECvtf4v/VVXFtnNvX9BCk1i/LR4z/wbnQJpS8Jhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dfU089Vu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dfU089Vu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AF41C4CED3;
	Tue, 28 Jan 2025 10:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738061871;
	bh=wQsKplMXpgAe7J5b6GIUpzuSaxdndrA8Ub758kgEF30=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=dfU089VumCjoGgzaClvd38iDuQ8naX+oZhb9Rdi6rfzQdGys05+dc24gfbZPvNFsz
	 ngujIYZzSzZv2J2mqHAzd360XwBv3/mw7Ut/HUPuxVaMNbZeItliYWC8VW14XsFTBf
	 3i2DoVfUTW2lyZq0M6TKUGj6HSTNjIw9Qx3RO5j8VQsHYLe73xWZew1MvxfyVCuP8J
	 fM16aHmCq49S59Ef80FEHfWYm47BKcNhVu24niGNy+m7ilFWRez345xA9uBM2qhOgb
	 RI1lDFdpwl5xPW3wIpC9l/cSczBGEzDYWv3tSlIs85mfChQAV7uJ88NtYdULkSDoPm
	 1IOWGxpDl+Syw==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: djwong@kernel.org, amir73il@gmail.com, linux-xfs@vger.kernel.org
In-Reply-To: <20250122054321.910578-1-hch@lst.de>
References: <20250122054321.910578-1-hch@lst.de>
Subject: Re: [PATCH] xfs: don't call remap_verify_area with sb write
 protection held
Message-Id: <173806187008.500545.17393932748309902750.b4-ty@kernel.org>
Date: Tue, 28 Jan 2025 11:57:50 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Wed, 22 Jan 2025 06:43:21 +0100, Christoph Hellwig wrote:
> The XFS_IOC_EXCHANGE_RANGE ioctl with the XFS_EXCHANGE_RANGE_TO_EOF flag
> operates on a range bounded by the end of the file.  This means the
> actual amount of blocks exchanged is derived from the inode size, which
> is only stable with the IOLOCK (i_rwsem) held.  Do that, it currently
> calls remap_verify_area from inside the sb write protection which nests
> outside the IOLOCK.  But this makes fsnotify_file_area_perm which is
> called from remap_verify_area unhappy when the kernel is built with
> lockdep and the recently added CONFIG_FANOTIFY_ACCESS_PERMISSIONS
> option.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: don't call remap_verify_area with sb write protection held
      commit: f5f0ed89f13e3e5246404a322ee85169a226bfb5

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

