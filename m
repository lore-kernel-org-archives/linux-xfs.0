Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E732BD04;
	Wed, 12 Mar 2025 06:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741761964; cv=none; b=MbcMunKvIvI44kEFdm+rFzPam03y4l0g+RoTRjCLIYo4TIFQphblrIJH84bA32/1xR/7IZaNcOn0kw2MYrtZRbnlg56jfTh4VzsX12OfxOz4zWsu3tDEKvwzzfp46RfYK2E5OghhJiE/NZXof848oO14rRyP+oj/1BePZi7/sYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741761964; c=relaxed/simple;
	bh=AwESd08s1Ltgpo/klo6q9Cc8nnu8ZLOaoiY44fbEMgI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lrMo0gSrY6GDYi0LWk2iE92Dn2XhoTUVHzyMRpg2tlsY2ljsCo48Sy4/TXriQeCkx/52+x9B7BOfxXxacp3edbbpgTa5Pggn35g5XYcE2ZYJPfb21/5pDWKckzlBVMwvo5Id6roZA06We0jXw7Y67sCXlzuxvjUfd38m6EmnEyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0474668AA6; Wed, 12 Mar 2025 07:45:58 +0100 (CET)
Date: Wed, 12 Mar 2025 07:45:57 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, zlang@kernel.org, dchinner@redhat.com,
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] xfs: remove the post-EOF prealloc tests from the auto
 and quick groups
Message-ID: <20250312064557.GA13275@lst.de>
References: <20241023103930.432190-1-hch@lst.de> <20241023172351.GG21853@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241023172351.GG21853@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Oct 23, 2024 at 10:23:51AM -0700, Darrick J. Wong wrote:
> On Wed, Oct 23, 2024 at 12:39:30PM +0200, Christoph Hellwig wrote:
> > These fail for various non-default configs like DAX, alwayscow and
> > small block sizes.
> 
> Shouldn't we selectively _notrun these tests for configurations where
> speculative/delayed allocations don't work?
> 
> I had started on a helper to try to detect the situations where the
> tests cannot ever pass, but never quite finished it:

Did you ever finish this off?

