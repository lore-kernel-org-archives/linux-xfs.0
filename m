Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D47F921D3F3;
	Fri, 13 Feb 2026 06:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770962813; cv=none; b=CITSHZ/2uEFgv9mtpdW3dJ/mk8y2u9vCE8KWcCSQ3fzZ8cEa77aVn9Xih2dY/BGGujYztGmOqsvoadPFHT/8QV5UWwTLlVnAHN7MwkaAbp0hm2hZmTk8YYC5yn7Tz+aWX/vjFi8XZVSI1TjWZqE63RslcobKSFBqRqkdVho+AlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770962813; c=relaxed/simple;
	bh=4VJciUQLsAJnVVYGBaz4YsGOhEY67mRItsVdBCJbpBg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lYkVRR1HLS/bIsckqzxonv0cpsOS+IP/IatdnHqOSu8jwUk7Ie5QOPVPjnamy0Xyufp+tKZHTFgDygNqKdO99rucvH41Y8LIsQedU/SCR3p3IoaPIouuYZZY5I/fQDSPoBfTh1TSfs/ScpYIXRp2YhL7LhiGbUvHOXXUjGzGVKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=z/ZPiMY7; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="z/ZPiMY7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=4VJciUQLsAJnVVYGBaz4YsGOhEY67mRItsVdBCJbpBg=; b=z/ZPiMY7dI9RWFF4otrrhpNhuz
	1a2z2hYNpdQRkiTgNtlB+GmKKVRGeRebmCo+VoqelOAXkL0RxtSWv7kEuzTeSa2y6PxiWFYELv/aW
	mAla+be25e1ezVLugQb0ktvMKiic7ffKf21NlmybcF1oChbPPx6qh2BYWHjQtEk8VCepV2XUOg0U4
	YED8ubxoxMiBKzZwjQ7VFWRVZNyu1IeMxPgiuXvklUZhxn5YG5PtxKUl66KO18IFXCDgEDM9wghR9
	XpjXur3+Dw6doQrwZWGhwk0owFjKdXHehOcS384ETylanoZCwYfMHrTRLnel9TSF/TZWNc/+k7M1s
	LUJUs6Xw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vqmKI-000000033In-2oVM;
	Fri, 13 Feb 2026 06:06:50 +0000
Date: Thu, 12 Feb 2026 22:06:50 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 1/5] iomap, xfs: lift zero range hole mapping flush
 into xfs
Message-ID: <aY6_eqkIrMkOr039@infradead.org>
References: <20260129155028.141110-1-bfoster@redhat.com>
 <20260129155028.141110-2-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260129155028.141110-2-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This patch makes generic/363 and xfs/131 fail on zoned XFS file systems.
A later patch also makes generic/127, but I haven't fully bisected
the cause yet.

I'll see if I can make sense of it, but unfortunately I've got a fair
amount of travel coming up, so it might take a while.

If you want to give it a spin yourself, you can just add '-r zoned=1'
to the mkfs arguments for the test and scratch device.

