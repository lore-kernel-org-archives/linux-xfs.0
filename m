Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 309207E792;
	Thu,  1 Oct 2026 12:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790857680; cv=none; b=cHZENRkD+Xr2mSjGmC04P+LFqcUJyoAf19wMI8laj9XllYFpP74Jrj8IhobZE+jwpL8CMNZ9idqwgqp7QlX26T+5wxP82GqNHUsiCNH7z0gkuCuZS5unoYlJEFxMkfbUYbdN6josxZT5I3Muh3LhAVGv5nxOxW2oGGYHWxX7seQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790857680; c=relaxed/simple;
	bh=l7P8PM1ivjFtGkAi2LYzbRsC26vZAC9uubroQKrMzk0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uIHFOvGUdWngxzwq8YzQcsqVE++a1QeS7f51nQn5bqf6kPC0SqoleH7ZMcqKce2L4Dm5ZkPV7g1opcmv9EdCfhHULKY4253HmAohiTRPhrvRTpqw3eS86IL2dHsEFrU70iMRmgTdG0kswZJ0IS1O/y2prAMoeGY1jAp6KYoRdGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bs2qSCTf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bs2qSCTf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F0A11F000FF;
	Thu,  1 Oct 2026 12:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790857678;
	bh=3p3tCW4PmhCB7hGT1QUfzMF+UpmbC3IGjKWTJ6yMQ38=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bs2qSCTfkmYN8Hz6JFvTtLqJ7v/eEqusV+EFtuDv2QdD0Y/iEOG60r3z9m/qIW9n6
	 OFKjbqPv8NhYg9RNKMUqNuEuz+Xw0OBLlbwcak7ZcQ1mJvY0JeJ49gRWB2FBhgkx2V
	 Qt7qO2Nam67KxsA17kS1KY0qKedQS05htUccRqHRzBSpamaA6s/Jq2V50UusCDuGaq
	 5VjqQ3R7A2h9MrwkqyiiDtAZYd+9w91LyiyqE2ChK8OQimRc0oJGYlk3YlNk+g4v/F
	 yrHOO8r39ydZKwbd7Af45mkqFP8yqf90ek7xpU/u7VdAXEIMJv28HRYOpozJs43uAZ
	 a+inehCYE7j1A==
Date: Thu, 1 Oct 2026 14:27:54 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@kernel.org, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/4] common/xfs: add zoned/rtstart info to mkfs filter
 output
Message-ID: <ar5RuwzCs_i9lLPu@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <179060965752.790984.3511820348115861306.stgit@frogsfrogsfrogs>
 <179060965805.790984.4333974916537243304.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179060965805.790984.4333974916537243304.stgit@frogsfrogsfrogs>

On 2026-09-28 08:36:27, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> A subsequent patch will want to be able to extract the start of an
> internal rt volume from the xfs_info output, so add the necessary lines
> to _xfs_filter_mkfs to transform the output into bash variables.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey
