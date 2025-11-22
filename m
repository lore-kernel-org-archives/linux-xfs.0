Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A721E1A05
	for <linux-xfs@vger.kernel.org>; Sat, 22 Nov 2025 10:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763806151; cv=none; b=kzn08UpRADUpTSV77wSUpypFzAn7L5FIqTfSlnlPuH2x/hjzwHnmbuc0tCbQ1YtuVgeuwQ2xCJ3g7XPPQBEM5Z+V22Gm4yW4AhOkczzaLWRv0H1a8Vm5WAddmWQiCexOuBnlTq/3bX4AvPy4VcprILFZVfohvG5C66izJD+l7G8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763806151; c=relaxed/simple;
	bh=grLQ59/dAmfKJ+VKWlIiOkCuS0OMBOs4gzlKEHo4p8U=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=vDdM0g1dWdp++aBT/PfW4Pl54qNBRBHiumV6GXfLQHjphA9wtRvCSPRZO1u0Fy/DzN2ZjM/K5wSqCBlOhgmuVpOks5HZrEaDv23jaU3A17x8hCEGvsDHM2NdBKnb/8pOy6tD1dikcHRkB77+PzDs6dX1fDavr7MqINdTseUqJFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JDfuNgMu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JDfuNgMu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32F73C16AAE;
	Sat, 22 Nov 2025 10:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763806150;
	bh=grLQ59/dAmfKJ+VKWlIiOkCuS0OMBOs4gzlKEHo4p8U=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=JDfuNgMuPfoeuLOOfp9W4VZL4mXkLMiYCHX/x8dMng6oIOBEHoyREhw2ODV2nrR1O
	 8tTi9fZ6JB+nKm8gRu+IiHN2y+KrqWhkW5c+c2w66SdOtSB7GONB3MEpEfreqoFFqY
	 4BejZs3pKkH2AvPG+NxF9mY4EEHAOl3WTgH7UJVxRcUq4la8/JWTEnKRoHc/qKzW9U
	 7egB4/MOL+yU42ep2vCEFbxYU19POac++d1lpK+EbbKxdkRUK74YwR1woFDJs/b9D9
	 u4B/7LRlFu+18VJ6qj74uXT+B6eT+hjys8BR5oAav69gIUU6YhLdEkPEfRdARoDQGt
	 xXA6kOBl2XPTQ==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
In-Reply-To: <20251118064942.2365324-1-hch@lst.de>
References: <20251118064942.2365324-1-hch@lst.de>
Subject: Re: [PATCH] xfs: use zi more in xfs_zone_gc_mount
Message-Id: <176380614992.104488.5199521488783182557.b4-ty@kernel.org>
Date: Sat, 22 Nov 2025 11:09:09 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Tue, 18 Nov 2025 07:49:42 +0100, Christoph Hellwig wrote:
> Use the local variable instead of the extra pointer dereference when
> starting the GC thread.
> 
> 

Applied to for-next, thanks!

[1/1] xfs: use zi more in xfs_zone_gc_mount
      commit: 1cfe3795c152c7415a9f49fc1e7f623c855d14ab

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

