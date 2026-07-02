Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F287E433E9D;
	Thu,  2 Jul 2026 15:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783005848; cv=none; b=FJP8yHT2tC5EDGVIWxIV929/qJEzBZ3FZPq+TwDBqorG2+UfM8AHEoRWekFOD0kDHAPW7b0v9hovlzyzWw0tVkPoYpPUDNdsSC4jLFerInZEmibCRFJfzy15J45k73TnWJxvy346x8M47h+9xnRZLRJlY80Km43gXKL0vJYBadQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783005848; c=relaxed/simple;
	bh=DdsLTR1pnhihuGWSPq5+GCORuY8k4cf5p+1Q9Fv68bM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hNrm+3iHduGRweT1qKfTsb7CRd4T8dUl2JreyYF4TeuRc3H0OHkrfz9j3LEQ/qcEddWNTXXndW1p9WVvIwoi3sk09am5TFWkxqn/Rzh446FVTcfScu5t3O4SpitOtscJQx4qtvu1BRYff9MGgAw6zKJRqNM2saFzSON2Y3stM6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aF5o4kXH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aF5o4kXH"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 72D8E1F00A3A;
	Thu,  2 Jul 2026 15:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783005847;
	bh=ubpN7GOshcvauTqF0LcoIBuTlEQ9RJeM7elj4vUwlc4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aF5o4kXH1clPVJbBCq4LP9zy7LTb5zrsrmanWyczOL+fe3zPVPJsr1u+GbKSRapcm
	 YLGlsgpu9N2YDIYmCCuEB+c4s2mhkns+XiXPyxZ9Y+EJn8hS6nal1fqPSy/j7yhLP6
	 FDURWA6Jfm7EejTWec/DUqC+BbLwUiq7R1dxVcpPsBA+i3tiqpMFIrlB7La2yzkR9F
	 +//Ob1fbFCFEeUBFGtrm1k11qzTk6whhQ2xjvfX7gWSqyMEMxJ8exFJq481332RpQ4
	 +SBmN/9r79V+TXOoKX3LE2dX08vNGh9mLnim2MMhEzYKbfw74qauKcMraDmV3F2e+o
	 v/16BIhMBqrTg==
Date: Thu, 2 Jul 2026 08:24:07 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: zlang@kernel.org, fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
	Yao Sang <sangyao@kylinos.cn>
Subject: Re: [PATCH 2/2] xfs/65[56]: don't unset SCRATCH_RTDEV here
Message-ID: <20260702152407.GE9381@frogsfrogsfrogs>
References: <20260702035523.GA9381@frogsfrogsfrogs>
 <20260702035759.GB9381@frogsfrogsfrogs>
 <20260702103633.GC6816@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702103633.GC6816@lst.de>

On Thu, Jul 02, 2026 at 12:36:33PM +0200, Christoph Hellwig wrote:
> On Wed, Jul 01, 2026 at 08:57:59PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Both of these tests claim that they have to unset SCRATCH_RTDEV to avoid
> > formatting failures due to the rt bitmap consuming all the space in the
> > "small" data device.  However, the format doesn't constrain the size of
> > the data device, so the justification doesn't apply.  Remove the whole
> > thing.
> 
> Looks good, but as-is clashes with my
> "formalize and fix disabling the RT subvolume" patch.  It might make
> sense to take these two patches first, and then modified version
> of
> 
> "formalize and fix disabling the RT subvolume"
> 
> and
> 
> "common: skip data write EIO survival tests on fatal configs"
> 
> on top of that.

Whatever order's most convenient for you is 100% ok with me.
That said, yes, let's remove the braindamage from xfs/65[56] first.

--D
