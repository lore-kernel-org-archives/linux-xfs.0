Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D25938AC6A;
	Wed, 29 Jul 2026 15:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785340177; cv=none; b=uRgzn/YK3OL3XcZr/ErWx98G4sfnQ5b8anMlpd1YHYZwq/d2D4TH+QkL8lY2Z9P6pfqEhcWoa/v6gTtt0UgmwJnElCyxt3YoqTv7Xf6hP6K1ziIQitTyye59uEZHizQ6tytD9qsaZiubmiT4P7WND/ZUViRV7FR88RYnlR7lHsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785340177; c=relaxed/simple;
	bh=A8M12EZLGn8QGvbVkgpXM7sNpkljvf2WZ9JNF79bBe8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cr03zxKAX8adoNbzktg11IxWPTPF0+ko6IXSzp1Sxx98FRIBTX6bGJd3d+T+ZNefHuHk8MQOGtCxMFn7ONMmlZS5HfxROdj5JUKa+RmrurZtEilANTP6tlFTmnu2ynEaPXwPCfXeEoNx3GJJoLQr2HBWS0GAHGQ6aBLC5IucPvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2336C68AFE; Wed, 29 Jul 2026 17:49:31 +0200 (CEST)
Date: Wed, 29 Jul 2026 17:49:30 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, zlang@kernel.org,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs/507: use mount -t xfs
Message-ID: <20260729154930.GA18075@lst.de>
References: <20260729125955.2281762-1-hch@lst.de> <20260729154650.GC7371@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260729154650.GC7371@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jul 29, 2026 at 08:46:50AM -0700, Darrick J. Wong wrote:
> On Wed, Jul 29, 2026 at 02:59:55PM +0200, Christoph Hellwig wrote:
> > Sometimes mount wants to try every other file system but XFS when
> > mounting the loop image, making this test fail.  Force mounting as XFS
> > to make it reliably pass.
> 
> Weird.  Do you know why it does that?  Did the kernel really skip xfs or
> were the sb verifiers simply running in quiet mode?

Not really.  I also happens in weird patches, I can reproduce it a few
times in a row, but just when I get ready to investigate the problem,
it goes away.
