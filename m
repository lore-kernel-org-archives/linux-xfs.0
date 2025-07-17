Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF0B27A904
	for <linux-xfs@vger.kernel.org>; Thu, 17 Jul 2025 08:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752739918; cv=none; b=ih9CiU/fdMvaZJROUS7WB4G2got6umy4Dj7gP5KEeOzis7eP4vBPQGPa7ljk2t/9IcjeYQqwRblSJYyjHoOaKudIYyUuJ4PbC5Isa1tIb3QUH+BvCKbHo5a6xjoNOkBj89Sh7N8l/1TKM9nIqh2S7cJ3VmIcQJ+Ofv0CdTq9Zvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752739918; c=relaxed/simple;
	bh=Ov3uKYwZcT1Knyiz43n2JwBNx9XUwpPI6TDGuElrg8Q=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=QfSNzAZpWPwPW8nQ1CNnKLqgumQNa8NygPg3tJAjK1nTOtC1vR6pvv/m6tZmN5FFSyxuh5RCeU3FRxepjjCewKTUiyC4b+yfW4jEviG4Mgb0+k2x5wpLnmcwRiUz38LrhQ0MfOpY/0cTWit1+QJqpIlyvkBVMZu670PHvTQJqLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HeHBMvqP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HeHBMvqP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7039C4CEEB;
	Thu, 17 Jul 2025 08:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752739918;
	bh=Ov3uKYwZcT1Knyiz43n2JwBNx9XUwpPI6TDGuElrg8Q=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=HeHBMvqPbPkx2sH8CqmfMUPPRpYQ+edUGPbXVDSX8nzhXl5CwbWn6gX/EOxoSNVUU
	 ot/VVJf8YAZIrdYJNlzsZWETuqe4tUfeb8Jh3hrbTve6QH/froiZ4vcLPCl4EfDeIN
	 mvfelbI1ICawO+X4hMTuBe2he1n7mYjsHYnas0x/TINaq+iL/UAFSU68foEvtYJQFY
	 5TmnzDa7hI9P/UHQJBZoVLkkIu1EfL5CDL2R7h8p2cqlE5yGCL503kCIQZ1QT+EPzK
	 NWpPUTxeT8NWOVpnfWfR3v8CMyLIdBv4WZJb7sXXpsxMhKnbzi9ovwKvuYj1oQYxOd
	 CqM4vfgGXY1tg==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
In-Reply-To: <20250716130322.2149165-1-hch@lst.de>
References: <20250716130322.2149165-1-hch@lst.de>
Subject: Re: [PATCH] xfs: improve the xg_active_ref check in xfs_group_free
Message-Id: <175273991740.1798976.12119597253064855944.b4-ty@kernel.org>
Date: Thu, 17 Jul 2025 10:11:57 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Wed, 16 Jul 2025 15:03:19 +0200, Christoph Hellwig wrote:
> Split up the XFS_IS_CORRUPT statement so that it immediately shows
> if the reference counter overflowed or underflowed.
> 
> I ran into this quite a bit when developing the zoned allocator, and had
> to reapply the patch for some work recently.  We might as well just apply
> it upstream given that freeing group is far removed from performance
> critical code.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: improve the xg_active_ref check in xfs_group_free
      commit: a10f18bc67785b947396ddd0529b3df7df3d5d6f

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

