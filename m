Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C6F155301
	for <linux-xfs@vger.kernel.org>; Wed, 19 Jun 2024 16:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718812835; cv=none; b=sXXCNejKU9wvv2b+s8nSaKCFso8ziMdSsNSbW40DS/G3LJcj9Isur/8uvp+4wUAZfNW6cQRYb7rAA1Z4Qk0Dw5WWf8aZZRjk4Jy8YT8o7DJNhV8Zk9i7z4lnsvnu7oHrRCCe+MVEfCYWo2Ca+SIT6ziXAvU6bXVmJjdOqumAC7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718812835; c=relaxed/simple;
	bh=ezkbV/bYDx9Q8+D0YISX7dryd0gdBuXI4cFDJVtKPJ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PCvBjE7WoWcESFPJk6i3H9JUG/gwsmh9dFiAPziF8ULnR97QRnCJpvigJyqgRXgVE7+sLy8zSQkTvkILjqExDkEq9Zz+lGF30XbtyHSH20+a4GD9jfb2ZUJeN2e5gA3hdIsTagFjOVZ2VE9A4rk4W5aGc+CYV3TpzcmrmYhqVbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pWdquBwF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pWdquBwF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 864CAC2BBFC;
	Wed, 19 Jun 2024 16:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718812834;
	bh=ezkbV/bYDx9Q8+D0YISX7dryd0gdBuXI4cFDJVtKPJ4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pWdquBwFDpE2DonAO0fh9LEYnrcMZ/ZHZOClvUQiJCyS40FMBIm8+zGzZoUHHN20/
	 KcokPFjEfkFzF3oUylJ1nVjjBRx0PowCRAcW6mRifrtzIVY0B2/jDCIEwJDMWEfGP7
	 PBobqvA0ohTdWwKI+zYn+kwxVZFhdqEBZMKv2rcG/nvWBumDUHCSn6IPPm4b9Kl6LQ
	 kg7Oncv/PcZIWApe8OME5WhFNWF4zy2Oh5MW5Nt+xonjn3M8IaadYd2Cl31D5OZwIG
	 QneUIApIcdghQ1mFru+ploSjE4+gcdwm+PQABpofyXyC4qbjfLJKyCKSvuuIsEnfyK
	 H2tB0Y02OYMsg==
Date: Wed, 19 Jun 2024 09:00:33 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Chandan Babu R <chandanbabu@kernel.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: honor init_xattrs in xfs_init_new_inode for !attr
 && attr2 fs
Message-ID: <20240619160033.GK103034@frogsfrogsfrogs>
References: <20240618232112.GF103034@frogsfrogsfrogs>
 <20240619010622.GI103034@frogsfrogsfrogs>
 <ZnJr3fKw42EP9gPW@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZnJr3fKw42EP9gPW@infradead.org>

On Tue, Jun 18, 2024 at 10:25:49PM -0700, Christoph Hellwig wrote:
> On Tue, Jun 18, 2024 at 06:06:22PM -0700, Darrick J. Wong wrote:
> > NAK, this patch is still not correct -- if we add an attr fork here, we
> > also have to xfs_add_attr().  ATTR protects attr forks in general,
> > whereas ATTR2 only protects dynamic fork sizes.
> 
> Yes.  Note that I was kinda surprised we wouldn't always set the attr
> bit by default in mkfs, but indeed we can create a file system without
> attrs, which felt odd.

Yeah.  If you turn on parent pointers but don't use a protofile or turn
on metadir in mkfs, then the fs you get actually won't have /any/ parent
pointers in it at all.  One of Allison's mkfs patches actually would
turn on ATTR at format time, but the V5 sb verifier only requires ATTR2
(dynamic forkoff), not ATTR (a file has/had an attr fork).

I guess I should document that in xfs_format.h, eh? :)

--D
