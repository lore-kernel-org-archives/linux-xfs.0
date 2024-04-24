Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E40BE4D
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713927767; cv=none; b=NEyOrSXh9aqimdZMc5XBFxffMqOxKqAGBiyuIt8VOouuscGeCR3PGs9fJmT7BMxSxn2Z1h6nYFevcpe+AahknNKevpdRAzLsy+UJT/M/DhUpBXZ9htoL0LPm03Cj93+lWrxjy/hjx6HFSwTIFMExCKgmLua0B9s52mxTcLpwSbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713927767; c=relaxed/simple;
	bh=YWJbhos5AslGizp6hPEUSH15vmZZcYDTY0cIdQxHVm4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=mne9HlzxbVsHYTAfb00eRZEgLAIs770IOZj5M9kxh/z4YoXsmcm0bzg3Uju7QaMDOUNhJ4FIizKS3/86ebtOTmLKIdWh/W0gfMyKJVgvi0DnVxCZ7iLYOocvsuCQwOFmgf4F5wuyxuM2FNk1HueL1VUlyqibk22/T6lrJ5If1Ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KVp1Drxs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KVp1Drxs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC810C116B1;
	Wed, 24 Apr 2024 03:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713927766;
	bh=YWJbhos5AslGizp6hPEUSH15vmZZcYDTY0cIdQxHVm4=;
	h=Date:From:To:Cc:Subject:From;
	b=KVp1DrxsUp4Ho69D7nGkAitq+lPA6NEXmIerm0Jpzs4reQW6vgaRPnUVAunR/vlQp
	 fQ9JUH33jEo2s0Mrb84XpsHm8zyBw1EyfOA6qdSIA7aEaYEWGnQQTz4B6T4tHjB7E5
	 J8UNZFApgIT2KYktYmFBKC5bpAqgrW+ejjgRSwZRgHdbBgq1TH+OAtF3i6hBCRrQcw
	 NedaTMPR9Z0LEhwSCWY6aXdkp27EMYbVVKwGcT2pjr5Hfhf+SD9VVGh9hI0JqkC0mR
	 2mTet0SyTqWMv37dilF1yRybzGfuVCIhE6WDSUcDuxqpuwkfPm3GoO2xO3sXflMkFs
	 xswKiO2afprmQ==
Date: Tue, 23 Apr 2024 20:02:46 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Chandan Babu R <chandanbabu@kernel.org>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: [PATCHBOMB v13.4] xfs: directory parent pointers
Message-ID: <20240424030246.GB360919@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi everyone,

Christoph and I have finished reviewing parent pointers and think it's
ready to be merged.  I'm resending the entire series so that the patches
are recorded in the list archives, and will follow it with a pile of
pull requests for actual merging.

--D
