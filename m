Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6098258AA4
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 21:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710367180; cv=none; b=n0zydXEw9iNORFfvKk/z+4FeOQKCsiyNdl5PZScF8k3kgj2vLeqKawl05r0jFGa+hygHbUt9GsWqclPzoWmWGiWnKVNpOtvQl5J1Krz/XrGZhrB/c7d9fY8z30pvdMJmq9qi7Sz0QqMnWKqygIx27hjWAz4ppPNtWM3rlcuciz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710367180; c=relaxed/simple;
	bh=YI6b2Zq6CcBTcGKs0YSpSLaexzaqCGRNmlEqxakiLqo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t20ePSGbPKpohCvtJA4DFXZL9IMRailo9RDdM0zJs7gpdHPXJWED2BkCqt3teRZgMcJMrCvlyS5YfRiJv/0lrrR1dysdeHTFNMQ0LqzUUISA+UNAhcYfFcScqJ9eZkSenohfnwOQ8Vj/QcxAmj6/SLMEvQN3bM0S0Myw2hslTGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=V2vCzB9/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="V2vCzB9/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=VvMXVIts//jGdvjIaWOGGb4sHNOqMCIl62U5mRUsmtg=; b=V2vCzB9/zujEiTCFaNNiW5zKvQ
	stOcemtf7Xp4k29F5mEtN4+6xzMyMKtuOWs//Zzlx5zkRSUbHmDFF5qjs0ZCKaq/S0Oy8/XbBZXDs
	r4Ox8nX54OqlksqNRQj78ddRx/JGps53BUIk7j60miBupxQT+ZYW7KfPPCuqM7IDB4r0LBOSARfsn
	4fq/3npoQt8DEMczeOb15FAh6qJdPzKInWTHjodzlMAcuoLmIwG3SJ0DYNXhAJTq+jldUWbpt1hT6
	60r35oTorKsaCvPcL9ws29ky7gffR4blQEOvQtLwrxYxLlJzf2A9zDJEAKyasLhinvBBBIipT1tXj
	ojMKssEA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rkWdP-0000000C3hI-08Qm;
	Wed, 13 Mar 2024 21:59:39 +0000
Date: Wed, 13 Mar 2024 14:59:39 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/13] mkfs: fix log sunit rounding when external logs
 are in use
Message-ID: <ZfIhy9OapF4MKkQy@infradead.org>
References: <171029430538.2061422.12034783293720244471.stgit@frogsfrogsfrogs>
 <171029430586.2061422.6975814186247298641.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171029430586.2061422.6975814186247298641.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 12, 2024 at 06:50:10PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Due to my heinous nature, I set up an external log device with 4k LBAs
> using this command:
> 
> # losetup -b 4096 -o 4096 --sizelimit $(( (128 * 1048576) - 4096 )) -f /dev/sdb
> # blockdev --getsize64 /dev/loop0
> 134213632
> 
> This creates a log device that is slightly smaller than 128MB in size.
> Next I ran generic/054, which sets the log sunit to 256k and fails:

Can we wire this exact mkfs command line up as an xfstests instead of
requiring a very unused setup to trigger it with the existing test?

The xfstests patch itself looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
