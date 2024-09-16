Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD6645979
	for <linux-xfs@vger.kernel.org>; Mon, 16 Sep 2024 07:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726471173; cv=none; b=nIipnMJOF9ssSdy4frRKZkFCTYg0j1OTOVuWe8LcVekReUP5SCZrEx8OmTPH1bqxeLvAq7qZFpLEt+nxGMKa9x6qU9vcvzlG4wSF5604sHTxFLZc5Q8TZU2/m8okczo3/6j1bXQRTK5S4yGQPrhJjXXJQllCuCkE51x5UFfyGFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726471173; c=relaxed/simple;
	bh=RPVjtQMTdC0M0fasCkjZ1Bz005RgU2tTFSfLvLO3NpE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V1CX7xYhQtqd40vqkOH9Gt8Rz0ulrii0v/osKarTWay6hYRwOelrMW+6qsV8sarvHMBDl/uQKPzK5HZqCbgZNB1sH+6gKQpa1V6Sq4P03yHQjwpN5SLvZYc2CsQ18YRmczuYW7HIxU/OaBgulvV6Rcb/7M2faEccKfY07I5zkDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DDZBKYNW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DDZBKYNW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AC10C4CECE;
	Mon, 16 Sep 2024 07:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726471173;
	bh=RPVjtQMTdC0M0fasCkjZ1Bz005RgU2tTFSfLvLO3NpE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DDZBKYNW8AD8NQY5bfr5we9Ar80zlmazMtk1vXzgzXNto2veGPv2x0Z7f7R0IrDsY
	 xHnB7/JPciJH1Ko2q2JXcAs7hR48ws1ZO/QtdJgeQsEggT7NEQkx3V6+Y4uNHR0/Sc
	 3NRWIBtqR+Y4a9xe+tqhN2oyKTERXG4B7eHAzlIgs/Z+jpu9xjh8WgxCSz24AbhCIn
	 r/GdW1jdnzEAXQbuB+wGDvatSJpWHBtA933UTX+G1fkg2myVvIXmBZOl5Obd9Ak3qU
	 fRnzwyqZ9Bv+vHfF+8TOeCv9QANTmsziPBpFSKT/EVgbDW1v/q0UgLokq4rD4Bl5jm
	 cN0l7VcNlgJkQ==
Date: Mon, 16 Sep 2024 09:19:29 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Jakub Bogusz <qboosh@pld-linux.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] Polish translation update for xfsprogs 6.10.1
Message-ID: <qh24ibwuiwnz3sdlq3yr7sevfvyiqy3eox5rzdc5ckc3wnfzii@hwlo4h35rloo>
References: <20240909194355.GA10345@stranger.qboosh.pl>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240909194355.GA10345@stranger.qboosh.pl>

Hi,

On Mon, Sep 09, 2024 at 09:43:55PM GMT, Jakub Bogusz wrote:
> Hello,
> 
> I prepared an update of Polish translation of xfsprogs 6.10.1.
> As previously, because of size (whole file is ~628kB, diff is ~746kB),
> I'm sending just diff header to the list and whole file is available
> to download at:
> http://qboosh.pl/pl.po/xfsprogs-6.10.1.pl.po
> (sha256: 1fd88c1055d72f1836eff4871e056aea3c484e6a33d73cd3a28fe2709bb41853)

Could you please send a pull request instead of a file we should download from
somewhere?

Although we've been accepting it for a while, this breaks the process, so,
please create a pull request and we'll pull it into the tree.

Carlos

> 
> Whole diff is available at:
> http://qboosh.pl/pl.po/xfsprogs-6.10.1-pl.po-update.patch
> (sha256: 993b7aecd46ada0d277ce19a2b42351f2a1492efafd6d99879575b964ece72ec)
> 
> Please update.
> 
> Note that diff could be significantly smaller if files order is preserved
> between pot regenerations or merges - I strongly suggest adding "-F" option to
> xgettext and/or msgmerge commands.
> 
> 
> Diff header is:
> 
> Polish translation update for xfsprogs 6.10.1.
> 
> Signed-off-by: Jakub Bogusz <qboosh@pld-linux.org>
> 
>  pl.po |16343 +++++++++++++++++++++++++++++++++++-------------------------------
>  1 file changed, 8871 insertions(+), 7472 deletions(-)
> 
> 
> 
> -- 
> Jakub Bogusz    http://qboosh.pl/
> 
