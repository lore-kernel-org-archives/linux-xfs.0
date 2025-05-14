Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2ADB1D63C3
	for <linux-xfs@vger.kernel.org>; Wed, 14 May 2025 05:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747200060; cv=none; b=olOMFIvS+npIXE0bOe7IbQ/mOVEPeu/JxIno3IQ/2Uu5cCZDfOTchbXjMmgYu1pAondIisZ+olNgKoVwmCXHZfbAkDJHJoqTvzPQ9RveEYWXD/doAuAxrvi4tcUyRTDAmwBkQwDSPhGwH2PuVcLswMvEfmCd+GvSy4NOmEhsBK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747200060; c=relaxed/simple;
	bh=MXRwoPyttkud3960o0oNPSAtabY5L2ZCu1dw1PuAdyg=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=io89ysx3HUl7eQiOKyi5viqv28TFb5CtL31sUZJELxuABVU58hKyXgc1ZVXXCsoV4vmeidvuIXXZ1vhF/lHluP4xIv1FSuvQZAmJ3cnBbISkGtL9JQWs4IoMb/5znUO9SYfuPmn4dN2fRsmMTOJ9crpypzx6Zus/sL27AoWvXxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HUbYwdWC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HUbYwdWC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A817CC4CEEB;
	Wed, 14 May 2025 05:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747200060;
	bh=MXRwoPyttkud3960o0oNPSAtabY5L2ZCu1dw1PuAdyg=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:From;
	b=HUbYwdWCOx/8TvLBMF1Mz1jCkY+LIvLCFP9c19IptM0dforui9YH8NGkmJvBWRgKe
	 eqC4KkflbZLedzZivTlv4BJ6aeVJMq9gr7qNRn75gxFatdMkjKLCGXX6OgrWyKTXbD
	 uGbD1ywB4qaf0hx4fUd0+mBLi7TuCuDQwvllrm85DhdDvo8EQJRvGAKfwARxwQpSYW
	 gW1kc6po9Qf4plTeFRMAyApgL0Iaj6FZHK6kiHLwYTNVbbegp02PA3vMl66Iu4e3np
	 zsiqn1DSYVpeA08+XdIVduQDvXjvzRI2f0GFg+k+ZxhtZZTjaypm1ZBN3Qy0GMHByQ
	 nUUZHtlW90RvQ==
References: <20250512114304.658473-1-cem@kernel.org>
User-agent: mu4e 1.10.8; emacs 29.2
From: Chandan Babu R <chandanbabu@kernel.org>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, djwong@kernel.org,
 david@fromorbit.com
Subject: Re: [PATCH V2 0/2] Fix a couple comments
Date: Wed, 14 May 2025 10:47:59 +0530
In-reply-to: <20250512114304.658473-1-cem@kernel.org>
Message-ID: <87tt5nn4y4.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Mon, May 12, 2025 at 01:42:54 PM +0200, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
>
> Fix a couple comments in the AIL code
>
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
>
> Carlos Maiolino (2):
>   xfs: Fix a comment on xfs_ail_delete
>   xfs: Fix comment on xfs_trans_ail_update_bulk()
>
>  fs/xfs/xfs_trans_ail.c | 34 ++++++++++++++++++----------------
>  1 file changed, 18 insertions(+), 16 deletions(-)

Both the patches look good to me,

Reviewed-by: Chandan Babu R <chandanbabu@kernel.org>

-- 
Chandan
