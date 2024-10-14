Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC9F83A14;
	Mon, 14 Oct 2024 15:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919469; cv=none; b=k8i7WA8Iqzsx8evY/0DDtBMlY+g6l1Aw0QLINQyBIFaLFvaTeZUrsDfnGXD5Dvfv2znSr2B9o4NG6AsM+mAIX0+bffsX4DVr08E1GhVnAvaQgUwNKAsjKhT4rBNm9fTf2szbiSLnJ5ifTJaT/iklF6/nSRPlrDHLhulwKiRB2K4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919469; c=relaxed/simple;
	bh=K2sQsnFfXafjk0V7DWZ9Rj/tGUiWrGGkJMTvuefJjDA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xe0eM6wV/Dq9qNywxHfPI/Wm6wgulq7ZTQcB3Tao3Arj0AqemR/+bPz7BMWFGc4BO77+6PfUviHzBANiQFE90aj1hzHXwB39w93EcJVoSSqE8PZu/kS0OkDXUrvvqsqKgiTWM7m6zOnHNKlD5oFzpzQsSF9EEJjXtxoqxGq4aEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lCgikkum; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lCgikkum"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7F43C4CEC7;
	Mon, 14 Oct 2024 15:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728919468;
	bh=K2sQsnFfXafjk0V7DWZ9Rj/tGUiWrGGkJMTvuefJjDA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lCgikkumI9w50mC8dI4PvqM7jR312j7EXQdDXvHt7E00FWR5MqdECo4C+JXLOQzwd
	 1ClJkm+cD8Owli+10Pa0jBKcSeLv7bU/l7jdoLcF/4vB9er00wMNgqytbT545DJt+f
	 XWMDpI4nIHS9Ji/OnheDx9cIaW1ybAitb17b3WQw5KYm2o5y5yMJJY5YlclEPd0JJA
	 bqB4EBX6j74sb1e2oSSNP1h1un+nQgureGE+KUJiUptbsD7cpLmzWQlYk7POA/ASGV
	 nUJRyszI43EpgiMP240T/7guATlrZRTvLlSRAh1Le/vEJYZvpupF4HInNmaidomG8x
	 geUjq0b3p8GZg==
Date: Mon, 14 Oct 2024 08:24:28 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@redhat.com>, Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] xfs: new EOF fragmentation tests
Message-ID: <20241014152428.GQ21840@frogsfrogsfrogs>
References: <20240924084551.1802795-1-hch@lst.de>
 <20240924084551.1802795-2-hch@lst.de>
 <20241001145944.GE21840@frogsfrogsfrogs>
 <20241013174936.og4m2yopfh26ygwm@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20241014060725.GA20751@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241014060725.GA20751@lst.de>

On Mon, Oct 14, 2024 at 08:07:25AM +0200, Christoph Hellwig wrote:
> On Mon, Oct 14, 2024 at 01:49:36AM +0800, Zorro Lang wrote:
> > Thanks for reworking this patch, it's been merged into fstests, named
> > xfs/629~632. But now these 4 cases always fail on upstream xfs, e.g
> > (diff output) [1][2][3][4]. Could you help to take a look at the
> > failure which Darick metioned above too :)
> 
> What do you mean with upstream xfs?  Any kernel before the eofblocks
> fixes will obviously fail.  Always_cow will also always fail and I'll
> send a patch for that.  Any other configuration you've seen?

fsdax, any config with an extent size hint set, and any time
sb_rextsize > 1 fsblock.

--D
