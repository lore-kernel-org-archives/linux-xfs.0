Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0C328E8;
	Wed, 27 Nov 2024 05:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732686224; cv=none; b=TliA/U4671C/qduUFeu2yZVUeE4b9fdf/4M7oiShnS+Wb/VsFMomwz3W3GthUv3zCFctNBEMe+ievZneGwMY5QyIwsjHEDMWAp40HtUhfGgdn2vEeZtBSKwgAIuuHiNEZL51svChSr/k5okyifDjJwZnFChKEucQj2qQMPmnLpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732686224; c=relaxed/simple;
	bh=i1YXJf+zohW1vQXm/B2jWTvXI1VIlQRP41kMGoS+p5g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i2UScKGxwsugq26O6jesLJ8Y+cn7F1diFOYhyZetFpGSevbp4Y7pD03bTs3DS62cYI1vYApk9KM4l/Np3OgeQk80lDqJupbxZgKcW5k+BPensrodk7csrnKkzcgzhbDz4IvhT2RRbaO8Q5edG2a4wniNes7h4GPASi2dCXr2zyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1WYEIMWz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1WYEIMWz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=4VDhEBhsjdZkxM0W7JISSdkMYX+4907G83obYId2tdU=; b=1WYEIMWzE6rq92uAxfeiYfvnUu
	XyQkCT112AIs966+QPG4ucrl6Kd2n+Ld23d0Ck6yBRQJy2/BK/uvx9pooR56nWbBi6F7HgFlE4muG
	i/iZ0L76rpziIjqxJCrYUxNnwIIFFsXzJDTHItzR6Cnb4drJE9rWV/eSptL9YwtdVgpDj1UFhq6RM
	zwvsDcFWz/qPW1r+pO+L/EF1rzT1ivt/EZK7O8F/+ysGjMPSMwRpEap4xrrOuhEQk/ehT8WcEyPHO
	ZBFkcPNKBKa6zjRG6o8A+7OwrKy1jf09T6ifMV7WtgW2EmKeIuBTgjXGXzGkFUKFMQn6oKxWDfg4+
	S3sFyrQg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tGApy-0000000CHAs-3Prb;
	Wed, 27 Nov 2024 05:43:42 +0000
Date: Tue, 26 Nov 2024 21:43:42 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, zlang@kernel.org, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 17/16] generic/459: prevent collisions between test VMs
 backed by a shared disk pool
Message-ID: <Z0axjgDuiC5m-xUO@infradead.org>
References: <20241126011838.GI9438@frogsfrogsfrogs>
 <173258395050.4031902.8257740212723106524.stgit@frogsfrogsfrogs>
 <20241126202729.GP9438@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241126202729.GP9438@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Nov 26, 2024 at 12:27:29PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If you happen to be running fstests on a bunch of VMs and the VMs all
> have access to a shared disk pool, then it's possible that two VMs could
> be running generic/459 at exactly the same time.  In that case, it's a
> VERY bad thing to have two nodes trying to create an LVM volume group
> named "vg_459" because one node will succeed, after which the other node
> will see the vg_459 volume group that it didn't create:
> 
>   A volume group called vg_459 already exists.
>   Logical volume pool_459 already exists in Volume group vg_459.
>   Logical Volume "lv_459" already exists in volume group "vg_459"
> 
> But then, because this is bash, we don't abort the test script and
> continue executing.  If we're lucky this fails when /dev/vg_459/lv_459
> disappears before mkfs can run:

How the F.. do the VG names leak out of the VM scope?

That being said, the unique names looks fine to me, so:

Reviewed-by: Christoph Hellwig <hch@lst.de>
