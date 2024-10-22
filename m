Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A402D1E495;
	Tue, 22 Oct 2024 05:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729576341; cv=none; b=OPxTjEpoC8dDG7v9SNW08rKdK7dKNd3RgMBR4jT0Zi3oITI9ernZp4NrCbFh17mB+G+PK6Zc2yNG5Pj0+kPgsR33AfT37gpvOTF5LvXW8cNuoZ+t6UbzvYZnWGe7pNN0aym/v2tRbkSLcUKyKHs1bgrX29CeW4fL4w6Aidc2NfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729576341; c=relaxed/simple;
	bh=A3oB3JzmuvqBX87swbO8OJKXhCsMhCJ5kD3CthhbZvQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TevK1Rf6Ei0S9+h+RmwHh+3lUGywjX286rJWYG94aIE4wW2ukiAYNH8E3VeGpmffUzSRSAUJlOf9cUU6FefAdTPE3kbsc2/bjBymWg6liWemlHGBz1no6tS8Qy0c9r4KqR4qeOmyxyTxLV+E2ziatCBfWffB43AP519Vgq4QE+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 177A0227AA8; Tue, 22 Oct 2024 07:52:09 +0200 (CEST)
Date: Tue, 22 Oct 2024 07:52:08 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/2] fstests/xfs: a couple growfs log recovery tests
Message-ID: <20241022055208.GA10163@lst.de>
References: <20241017163405.173062-1-bfoster@redhat.com> <20241018050909.GA19831@lst.de> <ZxJGknETDaJg9to5@bfoster> <20241021164150.GG2578692@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241021164150.GG2578692@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Oct 21, 2024 at 09:41:50AM -0700, Darrick J. Wong wrote:
> Perplexingly, I tried this out on the test fleet last night and got zero
> failures except for torvalds TOT.
> 
> Oh, I don't have any recoveryloop VMs that also have rt enabled, maybe
> that's why 610 didn't pop anywhere.

Note that your trees already contain the fixes for AGs and RTGs, so
they are not expected to fail.  To Linus' tree fail is expected for
AGs, and we'd need an older version of your rtgroup branch to fail
for RTGs.

As far as I can tell the result is expected.
