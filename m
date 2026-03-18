Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE6BF38F954;
	Wed, 18 Mar 2026 10:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773828757; cv=none; b=PzgCshxnnP1MP6/uNNnSHaZh1EMzenDxSTK1/yp88p5Qbg4HUJFh81jtb1uQLxDh4IPcmLaGfycObKEAbkcqpJjh+WlFhNHZHsJ1PT6VdywOgxBlIBt8wrt9VlRWiAOjVyQ5GS/IDOG79pt56I4cDqXs3eD+p3QVpCHVX7L5erk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773828757; c=relaxed/simple;
	bh=vqyYNQz81OhV1PTAWO2DkoNq5ekX/bUcyGNmChLNlC0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=WW0X/Rkngkn4NUxwRQzbBzRg69R7JEIrW3E2iOyOBx/UTj5aDO55CafqNtM3ynfD2qV1SFHl3kiWDwoVrqEDjwqdCX8zQmugSdP+M/1VuI1NXKkXdm1R2wwBUAp2ZknIGPuT48ulKrzT/TxtFliLvZli7T0XzoZui6YkdXvxqfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uDi0KUSG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uDi0KUSG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87DFCC19421;
	Wed, 18 Mar 2026 10:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773828756;
	bh=vqyYNQz81OhV1PTAWO2DkoNq5ekX/bUcyGNmChLNlC0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=uDi0KUSG7b0Cd/vve3/trPttp4bRtclTfG/Y3ZKZGlpDDwwjwfumaZGlAk8Me0+od
	 efnLoS/VXyvyN4Qr+DLab4Ggr6YlXVYWlk8S96w5i55Vryd6De6D69ZtykM/AIElyv
	 v7RngAtEcTe+bkjk0g+mHvFjLlPIBHpOmAoviwxJ3mwT/eSjw9xT5j/R/iRo5Zb8ul
	 oO2KEbM2Zj9/DsRvgV04kXQqSbHlmwIP013LbR8SzeavWLx55uLJMrzKRZ7e3BWU6I
	 ENcP3vJAXMVDwtHAAr5KayENHdLggeFstaKhAZ0GrFA/3mM/TBBGFh61umxzwxL6+U
	 8+eXg1KiVN4Ug==
From: Carlos Maiolino <cem@kernel.org>
To: djwong@kernel.org, hongao <hongao@uniontech.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1C42C3A2C8CD80B0+20260312121026.23660-1-hongao@uniontech.com>
References: <1C42C3A2C8CD80B0+20260312121026.23660-1-hongao@uniontech.com>
Subject: Re: [PATCH] xfs: scrub: unlock dquot before early return in quota
 scrub
Message-Id: <177382875527.271956.884582374757726119.b4-ty@kernel.org>
Date: Wed, 18 Mar 2026 11:12:35 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Thu, 12 Mar 2026 20:10:26 +0800, hongao wrote:
> xchk_quota_item can return early after calling xchk_fblock_process_error.
> When that helper returns false, the function returned immediately without
> dropping dq->q_qlock, which can leave the dquot lock held and risk lock
> leaks or deadlocks in later quota operations.
> 
> Fix this by unlocking dq->q_qlock before the early return.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: scrub: unlock dquot before early return in quota scrub
      commit: 268378b6ad20569af0d1957992de1c8b16c6e900

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

