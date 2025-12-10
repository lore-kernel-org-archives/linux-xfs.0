Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 733691C3F36;
	Wed, 10 Dec 2025 16:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765385834; cv=none; b=WJWKUd8ROf76NVYCDcOgTtuZq6XqBHzVDa/8QyRIB0HyE8shHjvg1vVDLVIta3LRarOr8pIdVt6oclkQnPgAhiu8W0iMHQdLkwE/tCKWxW4DXpU4nSKh0/ityBC4sdsRKYKpuC5btnw2hDve4wwxyi9H2uVnM3k+Foo9zOEE5Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765385834; c=relaxed/simple;
	bh=z3lhCxdOR1PjvSfGDeco2TSonEBoyc0XHSq1oY2970E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bt94GMxTXAR6szoZldN4Uhi/52ivtcvyX83iOy9sVFN+WgjI7/URJHfR0YGY4e8Fm25Pf7h72+ZUvYkoO7Y3+ojJKduotZHoLEz3VZm6DCgWPumd9lB/mxP1+bEs+rlcvecTDrjxNp7Wsc1oSJLAVwbRbSqDQ8+TQZoNpRJlHxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D127768AA6; Wed, 10 Dec 2025 17:57:06 +0100 (CET)
Date: Wed, 10 Dec 2025 17:57:06 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, zlang@kernel.org,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: add a test that zoned file systems with rump RTG
 can't be mounted
Message-ID: <20251210165706.GB9489@lst.de>
References: <20251210142330.3660787-1-hch@lst.de> <20251210165028.GC7725@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251210165028.GC7725@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Dec 10, 2025 at 08:50:28AM -0800, Darrick J. Wong wrote:
> > +_scratch_mkfs > /dev/null 2>&1
> > +blocks=$(_scratch_xfs_db -c 'sb 0' -c 'print rblocks' | awk '{print $3}')
> 
> blocks="$(_scratch_xfs_get_metadata_field rblocks 'sb 0')"

Ah, I had a vague memory something like this existed but could not
find it.

> > +blocks=$((blocks - 4096))
> > +_scratch_xfs_db -x -c 'sb 0' -c "write -d rblocks $blocks" > /dev/null 2>&1
> > +_scratch_xfs_db -x -c 'sb 0' -c "write -d rextents $blocks" > /dev/null 2>&1
> > +_try_scratch_mount || _notrun "Can't mount rump RTG file system"
> 
> Doesn't the _notrun here cause the test to be "skipped" when in fact it
> actually exhibits the behavior that you want (i.e. it passes)?

Yes.  Which sort of does what's intended (fail on broken behavior) but
in a very odd way.  I'll do this in a nicer way.

