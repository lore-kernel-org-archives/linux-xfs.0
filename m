Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A5212B9A4;
	Sat,  2 Nov 2024 07:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730533393; cv=none; b=L+A9eYMTCEUm2pOijTt52eh/yCix1M4ulpdRjhE8GfyiB/LO4f3NF2kt/uqfyWVxvdaTOFoRB1uZZKK4pfCEq/e1DTx0dt898P9yvAmjW3cYH+WVHzJd1Ub2J03Mmr5Vz+yLUT6YAyRx/IYjFexgd2Or8MbNK657f/ACCF3QFRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730533393; c=relaxed/simple;
	bh=vExPR1dHcv2mAq9ORfqXMWcxCRkvOxj1r6BzWBQo/3I=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=akkb1g3aGOkR6a9lwdEtKdzklzAsbg2daGIrBerWK5rNm7gGo81r/ZSqJv4nHf9Al71hXvVsuzmfgPgkRIVWGp3wI5TqyMv1CSPpXdzYIUKGi2PKDZZTH2w61iuidbGu9K7agtnD2JNhlPUOQa5hp0FZ91PapoDfIIJQB97OTrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ec0ycbUI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ec0ycbUI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E790C4CEC3;
	Sat,  2 Nov 2024 07:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730533391;
	bh=vExPR1dHcv2mAq9ORfqXMWcxCRkvOxj1r6BzWBQo/3I=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=Ec0ycbUIdhR/vSpX60e9E0i+ZK2QyRljP9i7+U83Uk0f/hVN9WfuFTX9lom6Q+W4b
	 VK/kEHnnpyKCJZstNugUar95iJso4JMJBW9R2tERTdWXgfc6niSMq9hZVSpssXMK3l
	 Lzi15Y3xvEc6/ehvL1lFZlSpDsuNDWxzP5ZoUuEVZ3LYXCQECPCh1dYPUtwUB3iBL8
	 s0wpZrVU4DNOUBUEZPNv8CTCo+CYqwleJnlRuLAcijCf9E+5LbqaSEOCf/3d+txUQs
	 qlfe/kjGp80jBCPOEowSqtAa7Lydk9TRGoi8nQ1U76+1rqkM+z1JaOlFVHLIrStusZ
	 swMkjVO+PBIsQ==
From: Carlos Maiolino <cem@kernel.org>
To: djwong@kernel.org, Chi Zhiling <chizhiling@163.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Chi Zhiling <chizhiling@kylinos.cn>
In-Reply-To: <20241025023320.591468-1-chizhiling@163.com>
References: <20241025023320.591468-1-chizhiling@163.com>
Subject: Re: [PATCH] xfs: Reduce unnecessary searches when searching for
 the best extents
Message-Id: <173053338963.1934091.14116776076321174850.b4-ty@kernel.org>
Date: Sat, 02 Nov 2024 08:43:09 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Fri, 25 Oct 2024 10:33:20 +0800, Chi Zhiling wrote:
> Recently, we found that the CPU spent a lot of time in
> xfs_alloc_ag_vextent_size when the filesystem has millions of fragmented
> spaces.
> 
> The reason is that we conducted much extra searching for extents that
> could not yield a better result, and these searches would cost a lot of
> time when there were millions of extents to search through. Even if we
> get the same result length, we don't switch our choice to the new one,
> so we can definitely terminate the search early.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: Reduce unnecessary searches when searching for the best extents
      commit: 3ef22684038aa577c10972ee9c6a2455f5fac941

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

