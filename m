Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEB3D15F3F9
	for <linux-xfs@vger.kernel.org>; Mon, 28 Oct 2024 08:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730105065; cv=none; b=kzyWvuWJWJNfEfxTrLDe+BG8svRWFFsBhoWSUfbos740jMTp+WJenfsIi9t4PbTdd41Ba31K0RDaXQadvSp+dEfy5HjbQm3H345KOIWrN3Ls6Oxs+ZPpjDgSrvqS9XQ4SRwv1GuZcSayXsokFbq/M8KoH+gBvn+iODo5V3vAP/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730105065; c=relaxed/simple;
	bh=mf/nrfGF0C4JN1V8D2TTOiOTWWcF9SDjBmvju14Jeks=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q11AJVVD+z9FDeuELD9OtHNLjHGNjsqw2RIoFy1CA+BrD12Q21E9ceYvYzR5um1HXB6eyX1/2DLoBS7F7xcYwQB+QVdFEnqAEBuFz3ucPLMH2x2klKZaP8zMUON15rDZ5jpxvE+1oCv3gKf4JdtXbv3Z65aeeRsvVImaVcJfScg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OHdG8ndY; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OHdG8ndY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=DCTbS+G5T9HhXy6VYG8TaRFT8Qcyhx+jqHFckfj/Hmc=; b=OHdG8ndYC6GbHgW0Gf8JaQIg0M
	CT7i+bYs9mwxQKgZbli6Ye2Y+k0UlDUHscJPfG0C2GLXrVNqwG4S+ceIv7COWn1Ck4b14p4oX5rab
	uZZG0wc2Qa18dGIfWAZ5dtRVTZFCWVjrKX5X3UNA+c9LMfaUAd1/QbIwn/TcwQRhU8ji9ZrrHBvfH
	bH5e77M5ZxHsr4vqaM8rE3zS0vIZhsQTYXjnXD0Q7LyBiLbtCO/BgBcy+HRG7T1Bx5gk1t9pBsQDe
	ssYlAq757LcOerckeB5KxV89/Zou6pfMrQGgdMaDN2XfDqd5NbmiEpU+Wh33yPW9ZNlh8nwknG5Ju
	CcE1q0Aw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t5LMN-0000000A8DY-2dk7;
	Mon, 28 Oct 2024 08:44:23 +0000
Date: Mon, 28 Oct 2024 01:44:23 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs_scrub_all: wait for services to start activating
Message-ID: <Zx9O53A6mhr2sF4b@infradead.org>
References: <172983774811.3041899.4175728441279480358.stgit@frogsfrogsfrogs>
 <172983774826.3041899.15350842942789677656.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172983774826.3041899.15350842942789677656.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Oct 24, 2024 at 11:38:27PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> It seems that the function call to start a systemd unit completes
> asynchronously from any change in that unit's active state.  On a
> lightly loaded system, a Start() call followed by an ActiveState()
> call actually sees the change in state from inactive to activating.
> 
> Unfortunately, on a heavily loaded system, the state change may take a
> few seconds.  If this is the case, the wait() call can see that the unit
> state is "inactive", decide that the service already finished, and exit
> early, when in reality it hasn't even gotten to 'activating'.
> 
> Fix this by adding a second method that watches either for the inactive
> -> activating state transition or for the last exit from inactivation
> timestamp to change before waiting for the unit to reach inactive state.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Cc: <linux-xfs@vger.kernel.org> # v6.10.0

What is this supposed to mean? 

The patch itself looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
