Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7B801B0F0C;
	Thu, 21 Nov 2024 13:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732194766; cv=none; b=SlN201cqi3YQ/nT5fR1Wu2+TOz722C24Dz07DKWTO4yNCZ2+iXq7wfyA2/hUagAWquGqSL7Z+3yHDq13G+imsZr9STTCD5OonSztHPArghdA7aQC8JGBqIF1r809rlZaJff0cjEC+QQ0xVvyqOOSH49W+eAl0opQwlPpBoykZUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732194766; c=relaxed/simple;
	bh=FQGJvoWrbSR2v8YRXWKc6weOSxteUbIEqn0nR+1ez8w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cPJFz/+s51aN9zC8s1MyAVu/6kvZFgGgAfjtnvuBPggue/x3kFAU3HNIh33RNKyrtATGpxhnfUkFArqzKlw9hXNpBGJEarx15l53/jfTHUZ+pMGn9uYkZpWDMT3BiE/9U7risRpkUbS2PyLHgNVBUTiBwf0wmRy5aEZsVvKliZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8054768D0D; Thu, 21 Nov 2024 14:12:39 +0100 (CET)
Date: Thu, 21 Nov 2024 14:12:39 +0100
From: Christoph Hellwig <hch@lst.de>
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH 01/12] generic/757: fix various bugs in this test
Message-ID: <20241121131239.GA28064@lst.de>
References: <173197064408.904310.6784273927814845381.stgit@frogsfrogsfrogs> <173197064441.904310.18406008193922603782.stgit@frogsfrogsfrogs> <20241121095624.ecpo67lxtrqqdkyh@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com> <20241121100555.GA4176@lst.de> <Zz8nWa1xGm7c2FHt@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zz8nWa1xGm7c2FHt@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Nov 21, 2024 at 07:28:09AM -0500, Brian Foster wrote:
> IIRC it was to accommodate the test program, which presumably used
> discard for efficiency reasons because it did a lot of context switching
> to different point-in-time variations of the fs. If the discard didn't
> actually zero the range (depending on the underlying test dev), then at
> least on XFS, we'd see odd recovery issues and whatnot from the fs going
> forward/back in time.

But the fundamental problem is that discard does not actually zero
data.  It sometimes might, but also often doesn't because it's not
part of the contract.  That's why my patch two switch to the zeroing
ioctl is the right thing.  Note that this doesn't mean explicitly
writing zeroes, it still uses zeroing offloads available in the drivers.

> I don't recall all the specifics, but I thought part of the reason for
> using discard over explicit zeroing was the latter made the test
> impractically slow. I could be misremembering, but if you want to change
> it I'd suggest to at least verify runtimes on some of the preexisting
> logwrites tests as well.

I'm all for speeding up tests.  But relying on a unspecified side effect
of an operation and then requiring a driver that implements that side
effect without documenting that isn't really good practice.

