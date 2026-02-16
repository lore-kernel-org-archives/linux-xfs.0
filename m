Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC7027F00A
	for <linux-xfs@vger.kernel.org>; Mon, 16 Feb 2026 16:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771260146; cv=none; b=RCYUZMQu/frFcFJ4mmHIumMJNA2K+o611nEXMd+aNzijAWxL1nxGQQ4XD5smwPo2YtNN1VB6E3BtEKVKo/Lua9z5EluHVDf1uEuoZoJpy4BNSA992VwUVQQjxVFrvOnPdtcYf+rq4XNtUVychoHV5bZpKUn1KFMl02mcs2iD4CU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771260146; c=relaxed/simple;
	bh=Iys8j5N284mdP7TeKEP9As494LVamsr8qJoIc9CU5pI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=FqJCEvkCOao1f6OQLe5qK83ZRBi5OuHgLC8h5+nscHWmYU1VZp1faCQpXBwyV5t3zWU5f2EMOpJh4LROqCPzFWtesBI9OmZPYb32z5mJMAWqGDzxl4xdHQS2zQDR+1+ps7spX/QHaEeuQoX2XUtxyWR2BJGNkA3ltrCSN50ctWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q1HT9srU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q1HT9srU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10B8EC116C6;
	Mon, 16 Feb 2026 16:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771260146;
	bh=Iys8j5N284mdP7TeKEP9As494LVamsr8qJoIc9CU5pI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=Q1HT9srU0k2Trc5rTEz3NxFdslPckZn/vrbCRBS1CiD+Uub/N+dkgTfb9uqyALGDL
	 X6rGmGoAoER798BVsgtSUI5EmfWJMMmihUHi6wHgsfY7grPV4C4y0jhJ5kThOcCRXg
	 fzdS9fcI1uFEeKse3lGu6I02LvoIIc/bXW8nk8e5LFWIekIWm/+lW0mITcFlEJAE3c
	 P9Mp6AxQll4xLZQHZxguMezGWEyAGJDtiB+b3rZnE5H/JhjStLR5ftoqcXOCD0n20z
	 quP8q76oyIoNEM7SihZm3tp240+suWpJac4WvlOUb6KOwRmLsBafO4hgMKcSoceAV6
	 SDN7IFKV4BuRw==
From: Carlos Maiolino <cem@kernel.org>
To: djwong@kernel.org, hch@infradead.org, 
 "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com
In-Reply-To: <cover.1770133949.git.nirjhar.roy.lists@gmail.com>
References: <cover.1770133949.git.nirjhar.roy.lists@gmail.com>
Subject: Re: [patch v4 0/2] Misc fixes in XFS realtime
Message-Id: <177126014478.263147.12010029044009202804.b4-ty@kernel.org>
Date: Mon, 16 Feb 2026 17:42:24 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Wed, 04 Feb 2026 20:36:25 +0530, Nirjhar Roy (IBM) wrote:
> This patchset has 2 fixes in some XFS realtime code. Details are
> in the commit messages.
> 
> [v3] -> v4
> 
> 1.Patch 1/2 -> Replaced the ASSERT with an XFS_IS_CORRUPT
> 2.Patch 2/2 -> Removed an extra line between tags
> 
> [...]

Applied to for-next, thanks!

[1/2] xfs: Replace ASSERT with XFS_IS_CORRUPT in xfs_rtcopy_summary()
      commit: ce95c72c7f95b820ca124e4a2b0d2b84224d6971
[2/2] xfs: Fix in xfs_rtalloc_query_range()
      commit: 60cb35d383aa5d185685e301e27346b51bf48026

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

