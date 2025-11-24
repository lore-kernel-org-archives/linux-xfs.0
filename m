Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 449DC296BBE
	for <linux-xfs@vger.kernel.org>; Mon, 24 Nov 2025 15:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763996757; cv=none; b=GXMPpvjy27wNPoQNNHxlNFJQjP8qWAkL2XvRxdvyYwXE5QoAc/bbOTtKN2iOzXBJ7kO4q+01R02DwoPRk2pNTkLuEYMH5QO9+FOHh9+Dml9JsEnZI4ALxFWmHVj2hE7P05Y1rlewKcNeNfqEYxpu+Mr0O2RGdB07gxadHZ2txlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763996757; c=relaxed/simple;
	bh=jqdT7e8k7OOlsarTEqa0iEqMpf92NGKP9OrjzgnMP9Y=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=lFHV+TrRVov2ZEpSZp0X634GXJEVBr3+5rQH3sr561W4jFh/KqPxN1PpDSTJMB0bkl/+Wocs3aj82X2dODy9P5D4dG8EO7QLgA85hMaSbGx9rhhCnzSglOXgGF5JTNdcPzMgpfpDQuqXJkA5kERDpSc3HV78meqpOnPYsdEHBew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A/QeSlTT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A/QeSlTT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF81FC116D0;
	Mon, 24 Nov 2025 15:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763996756;
	bh=jqdT7e8k7OOlsarTEqa0iEqMpf92NGKP9OrjzgnMP9Y=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=A/QeSlTT7DJwHZgtBlvYsquuSUIoJosS9sJmp4CFTZpikPeTbon+n7ng8Eb4sCj4G
	 TG6x/y2F4xbxVopjKxZA/BOYRRku2dH5vQ5lijUbyOUqFvPOWuYeLDm4QWS8a+YS35
	 7kOI6XmO6zXypXOYujE4THdLLnOeOpK7NpDOnP5/2H/jDMYGH8xLupatYeymM3AdWp
	 tZlsBLeGr2ZXhp64mb8odF+2uj6MwlV/SosFN3jVJBBNVJGyYaK3HZ5PcspNqIW2Ei
	 GCxvpakjIuZ8WmoNmVTb4ddgGP2jMis1cgyGK2mnciweGl5ibRWHgP0PTl27IiDyls
	 WBx2esMKg47zA==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>
In-Reply-To: <20251124135439.899060-1-hch@lst.de>
References: <20251124135439.899060-1-hch@lst.de>
Subject: Re: [PATCH, resend] xfs: move some code out of xfs_iget_recycle
Message-Id: <176399675562.124952.6059863689586932017.b4-ty@kernel.org>
Date: Mon, 24 Nov 2025 16:05:55 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Mon, 24 Nov 2025 14:54:14 +0100, Christoph Hellwig wrote:
> Having a function drop locks, reacquire them and release them again
> seems to confuse the clang lock analysis even more than it confuses
> humans.  Keep the humans and machines sanity by moving a chunk of
> code into the caller to simplify the lock tracking.
> 
> 

Applied to for-next, thanks!

[1/1] xfs: move some code out of xfs_iget_recycle
      commit: 64f73000bb3c3577c3534677d0b9cf00e740cd67

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

