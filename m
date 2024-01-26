Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2CCC1BC28;
	Fri, 26 Jan 2024 13:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706275854; cv=none; b=Bxi19e4Cg7h5dMQS+tT/dtswcfSOj4vntzBE+NkR8aGzxeiNYJVvM8NYYxMez6wM4pgNOvmpCQD+k1dj4I/6Dj1dkFYsuH7+FazraaxT4AMsMJ1xCDbw4+4TsmSVSul4JfXBBrVEgNoXOXieIdPnItwzmKcOAugFEp6ofGgmg9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706275854; c=relaxed/simple;
	bh=lAK4qIn2clxXfOl9nJNFodWkoXgpUiPPP3J+tzi4Zcs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JLQCiIVDA2gQxK/OCFsmnntMP9BJ5k9vOMM/t52a68OsqJocuvWyMCduSGFkaRGjJGVnp+hi6Dg64rdSUp3Y8Yco9MYUOkTQ41+pvLM3troI3Qh7XORCMjQKmrhyIMaWZ6UijJgnMR/E4WB3UPPTOgQgLsG0Q3Oyz5nMYRHhNp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2IYVx9If; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2IYVx9If"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=p8/pVxLPe5qLRFLXslmEhDJCo6gxKYJXpOzDszN2/ek=; b=2IYVx9IfKTkydkK/pUs5oQI3o8
	ZPsRJeWEtGfi97feDa1ge1Au57DfjuHVzKHzLCAQiPkcyF5IbVQ4v/LUqe/CWx75txXdLSHkV1dHU
	9ym0qFYa/DEHnIUWA+MQ2XEE9T2NKrV4GxTCHnykiLK7o8m0qVY5sVddzFnN+WlYGDXR1My1EraUK
	UIxTECLCNCCWurmA51kYX4BUKNJYi4R3x1Y+kjGiPcC6bhe/BcBTK2eaveVV2NBPK2eEf10XBmDzu
	o3uhmdnhJJQ+dJHkYkR8fRoJ9VIzATkCxEL678x8FATG16UajFSqU4phzLwX55/Q9MBkXcRoefuWV
	uXbMteig==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rTMIF-00000004DA8-3uGH;
	Fri, 26 Jan 2024 13:30:51 +0000
Date: Fri, 26 Jan 2024 05:30:51 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, guan@eryu.me, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH 01/10] generic/256: constrain runtime with TIME_FACTOR
Message-ID: <ZbO0C7aeZNgR5nk9@infradead.org>
References: <170620924356.3283496.1996184171093691313.stgit@frogsfrogsfrogs>
 <170620924382.3283496.6995781268514337077.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170620924382.3283496.6995781268514337077.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Jan 25, 2024 at 11:04:14AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This test runs 500 iterations of a "fill the fs and try to punch" test.
> Hole punching can be particularly slow if, say, the filesystem is
> mounted with -odiscard and the DISCARD operation takes a very long time.
> In extreme cases, I can see test runtimes of 4+ hours.
> 
> Constrain the runtime of _test_full_fs_punch by establishing a deadline
> of (30 seconds * TIME_FACTOR) and breaking out of the for loop if the
> test goes beyond the time budget.  This keeps the runtime within the
> customary 30 seconds.

Sounds good, this is can one of the slower 'quick' tests for sure:

Reviewed-by: Christoph Hellwig <hch@lst.de>

