Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F04933CEB87;
	Mon, 27 Apr 2026 13:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777296387; cv=none; b=H7oF371xEYdEPd/WJSc4F54wFo8T99EIDkPz/l6Yz5y4/qzEHA5l0B02w+3DUJRnFbp/UBBaT8RrcRGA3wkNsxpxAmfIIe3HJsATGrdJFuTaKoyUoAFFkaFGNJNPRPXXFyurWiSlxjNrxtvS2/oWVecbxYe6WlvTUsuzkCT/g78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777296387; c=relaxed/simple;
	bh=aOGZmztr1G52FkWcSBPGADWK9xX1xoetQoW9AOkW8j4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=f6UhV1jffWMFaxG5YX6PO4GIiK9T9a+yRQCr2LA8Otwjbg8aZBuunGr2bcTpVgK/Zh/95L2+SlL7ZyH7l5QjW9754qFDFzH01+zNpeCiGZhC0B6HJKukYoIByayUYa4CoI9Q3zCIJRIzGf0hfU11BN7YB30miys+aEWMrM3vZZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JLE9DFeL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JLE9DFeL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E1ADC2BCB4;
	Mon, 27 Apr 2026 13:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777296386;
	bh=aOGZmztr1G52FkWcSBPGADWK9xX1xoetQoW9AOkW8j4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=JLE9DFeL7dR4lmv2V1pmvaG5bOuxDN6TUEx8o12+L5CSypU6l0FsgT2MwcbKkf2De
	 LgAp/5lAlVl01FLIgY9Src0lVk+bUAMUup4Mn3tYxb9a95UZ/j8JpK/ifAVggVMV37
	 GPxc803NCXfNm5AFno76N+xkG0dd4wCcV4pm5bBpqG+wiOClQvWEJf3x6TxE8bvOyB
	 P7pkj5UEwK0TpCEY1TDqEmeCgfKs6VEeR7Yl+XxFoejv1Oe5ZCDhBpkqa6/LTE8aP9
	 17uRhie1fghvp0aUlxGGCXKEetKrQWZYZaCcYLJXjcc+C639/O9l8TQiUyHHBZ2zve
	 mWA/6+PFUDdSQ==
From: Carlos Maiolino <cem@kernel.org>
To: Yuto Ohnuki <ytohnuki@amazon.com>
Cc: "Darrick J . Wong" <djwong@kernel.org>, Dave Chinner <dgc@kernel.org>, 
 linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260410170614.8075-2-ytohnuki@amazon.com>
References: <20260410170614.8075-2-ytohnuki@amazon.com>
Subject: Re: [PATCH v3] xfs: check da node block pad field during scrub
Message-Id: <177729638529.100803.10648263498277349494.b4-ty@kernel.org>
Date: Mon, 27 Apr 2026 15:26:25 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Fri, 10 Apr 2026 18:06:15 +0100, Yuto Ohnuki wrote:
> The da node block header (xfs_da3_node_hdr) contains a __pad32 field
> that should always be zero. Add a check for this during directory and
> attribute btree scrubbing.
> 
> Since old kernels may have written non-zero padding without issues, flag
> this as an optimization opportunity (preen) rather than corruption.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: check da node block pad field during scrub
      commit: fca20fcb76a20655daf18738f4a88c638a6bb64c

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

