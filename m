Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B75F53C415E
	for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2026 06:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788415569; cv=none; b=b4SAoVyUHntoqDmMRSjBEl0nfvrmRz6XMUImX6AOupGNQvgu+B/BxdMZnrOiQFE2UJHBYe0/7rrySZzhxYGK6yKd88mXW1GPYYDT4PGg4+O1hljBA/20nKgnXDhZVPcqbaTnm5E1BnxthJ9fUSanH16sbTTQAkOmWukYu+QCLlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788415569; c=relaxed/simple;
	bh=XcQhXDGOLGHhd0XZXk/ukukQFWYSiL0gw+UF+Mhvtqw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=BIWSOW7hbHihw0ugBCs/LshV2uL8m1SYmtEmdOkDZphrGa5J7zBqyq8R7KOTOuKxItgWEqwER3wTMNXN3cMoOfuXXdqJF29xTi3jMdq/LB7vpkURFoh+D2JeFkpTAcBkMf8VRJjZwDfAIeg4n8JgHlfo+o3pujRJNFuxGSUstkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R3x7WAzr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R3x7WAzr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 912371F00A3A;
	Thu,  3 Sep 2026 06:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788415568;
	bh=EinoQ56btjSyDHb98ZiJFzSIFkllXfStsk4po4nUZQY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=R3x7WAzrVKGVY+rVcF6loglWo5zDj+wFYC6gfKctBMrRXzIpTJam8gnom+rp6pYam
	 zY2PRfVC7yTS0gNQHenEW2gTxxvXWOpdx2M1x+dXGSNJ+10tVQ/oq4JRaXSVrgK4e4
	 Sn8ZhDwS8v7GkOS53qVok2bfz4QuI6J0PQ9chlDlxdONEBRJgRb/Kag9GAikJQhq8A
	 6XrkjEjZFFdF524c9VUVjx62ajVgMEKG9lIV3R0qRYsF5KAZVx2hJA7P+WqcasqdLJ
	 ESd5Ga0zt1Oh67BspzVxVMQh/584diGJWr3nkjz9W7ZR/Yoyk08G6an4mKPS2jebbk
	 aX0jONUNTkH5Q==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
In-Reply-To: <bf0a3369-f788-4519-9883-8d01d42631e5@redhat.com>
References: <bf0a3369-f788-4519-9883-8d01d42631e5@redhat.com>
Subject: Re: [PATCH] xfs: fix reclaimed page accounting in xfs_buf_free
Message-Id: <178841556724.1198521.11640293528861134087.b4-ty@kernel.org>
Date: Thu, 03 Sep 2026 08:06:07 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Fri, 21 Aug 2026 17:03:37 -0500, Eric Sandeen wrote:
> To obtain nr. of pages in "size" bytes, we need howmany(size, PAGE_SIZE)
> not howmany(size, PAGE_SHIFT). This over-reports reclaim by orders of
> magnitude, up to 4096x on a 64k page system.
> 
> 

Applied to for-next, thanks!

[1/1] xfs: fix reclaimed page accounting in xfs_buf_free
      commit: c1a54ce86def84b4bf82b94a89f1b83eb6c2a71c

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

