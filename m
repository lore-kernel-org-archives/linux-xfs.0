Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA6C19D062
	for <linux-xfs@vger.kernel.org>; Mon, 24 Jun 2024 16:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719245308; cv=none; b=SxiBufwbT58tddRx+Cq9Yx72E8mGB91qOVmcNmKR9CG8ie0Ot8NKy2KZGQouvyEPEd8Qsy4ukN3qTNiSEJsHjK6hAhj2vywu4re2+0qPjUmpQFc1H3WeEGzVzIcjL3rrKS1Sz63DjcprsL/lriUXAro+24DHIigCFQURVaJMBis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719245308; c=relaxed/simple;
	bh=8OZRbIdztKL8QUSsKX9JVHHyN7cS8s597ncFPuytVEs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B2jzIdvc/vv7MqWBbbnKUbKye9PnG6octwIpQ7PZaMf7sxVrNpLXGuBi0X3GovlvOOVnSKdRB53U24r51fC1g1VnC2zGTDOrdtTtJlNh6dE74WhA6q8+C8YDDtIHRnsjmQ+DHjSHsCFZ9giKnEgnMrSb5gH4OIESWzIw0SFe0oQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BA50068CFE; Mon, 24 Jun 2024 18:08:23 +0200 (CEST)
Date: Mon, 24 Jun 2024 18:08:23 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/10] xfs: only free posteof blocks on first close
Message-ID: <20240624160823.GB15941@lst.de>
References: <20240623053532.857496-1-hch@lst.de> <20240623053532.857496-8-hch@lst.de> <20240624154621.GK3058325@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240624154621.GK3058325@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jun 24, 2024 at 08:46:21AM -0700, Darrick J. Wong wrote:
> On Sun, Jun 23, 2024 at 07:34:52AM +0200, Christoph Hellwig wrote:
> > From: "Darrick J. Wong" <djwong@kernel.org>
> > 
> > Certain workloads fragment files on XFS very badly, such as a software
> > package that creates a number of threads, each of which repeatedly run
> > the sequence: open a file, perform a synchronous write, and close the
> > file, which defeats the speculative preallocation mechanism.  We work
> > around this problem by only deleting posteof blocks the /first/ time a
> > file is closed to preserve the behavior that unpacking a tarball lays
> > out files one after the other with no gaps.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > [hch: rebased, updated comment, renamed the flag]
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Someone please review this?  The last person to try was Dave, five years
> ago, and I do not know if he ever saw what it did to various workloads.
> 
> https://lore.kernel.org/linux-xfs/20190315034237.GL23020@dastard/

Well, the read-only check Dave suggested is in the previous patch,
and the tests he sent cover the relevant synthetic workloads.  What
else are you looking for?

