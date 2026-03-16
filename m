Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A116E29A32D;
	Mon, 16 Mar 2026 16:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773677733; cv=none; b=uOHo4+lEUJnbr/28Wb9hbZsW8HkEwgyJjo6zHZ5jk+uoAAj2JRDNoIuBQ2DVmS7CDv09hi79nH8ZYH6cvpxq8LIf+rYomtRPGmr401MLW/UTUJb7Om9jTRS3wpH7i2VOwmUd1Fk8fNescAxuJQ2Hovy5+Tuac9bAMIkQSV/ctX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773677733; c=relaxed/simple;
	bh=d7p6BWon1h2jMZB6hwlJKlMUy3q9gBc4n51ZppC61ws=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XMti5WcPAw3+BizAnvMRCxmShtMRUdnvgqQu+ZrLy4N6kI9DGTGM2Cf5TJ+OC/QcKEUVvJF9jiMSqrSErDXOCLMRohMNY9TbOVEJBLz5pI0VGhtmqmp1VVIbSjQtY9UwIhoHBXYrmqi/kUaevRmvRFimkYWHpdyDg9vXbBki7a8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=MTpbA5IT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MTpbA5IT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=d7p6BWon1h2jMZB6hwlJKlMUy3q9gBc4n51ZppC61ws=; b=MTpbA5ITDlDajlVSQpBpmGig6E
	Aa75iBnKypF3ASHx7xNPRbzbg1VlyBqEUKuJPb6X5mj0AK9f26hb/Ed1T5GR538Vkk3gXPQ+XAHA6
	eu0CbzbepTe7OCy9c95DjgC90K6zUhXh1VmyPkATjeufS2WoOtn/VKZjm8AEGcO1OjE20gq6K3iJC
	aPADbd9HyD/lq22yroIAZFbiHJER4/B9u5ePn9gEY9JcuBpgf98Fx2uAZb45LmRY7H22m67WKTnvc
	OLf4FyJNeg9/SAM+WJf80boKJJjyECQHpmSw5B2mqxDhsh2PjccFHg9ph385Z/4Rz8ZuB8flByxjV
	dgzP1I3A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w2AbK-00000004QZi-0fMq;
	Mon, 16 Mar 2026 16:15:30 +0000
Date: Mon, 16 Mar 2026 09:15:30 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Zorro Lang <zlang@redhat.com>
Cc: Anand Jain <anajain.sg@gmail.com>, Anand Jain <asj@kernel.org>,
	fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/9] fstests: add _mkfs_scratch_clone() helper
Message-ID: <abgsorUy3KM8KZV5@infradead.org>
References: <cover.1772095513.git.asj@kernel.org>
 <254fdd3e212f6618ea33207ef24db2b316d2d8fc.1772095513.git.asj@kernel.org>
 <20260309191317.vxcjvqfpoqdiycki@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <43710dd2-4282-4475-a29d-983295fab86f@gmail.com>
 <20260314170422.a62qqwqe6agom443@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260314170422.a62qqwqe6agom443@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Mar 15, 2026 at 01:04:22AM +0800, Zorro Lang wrote:
> I'm concerned that testers from other filesystems might not be familiar
> with SCRATCH_DEV_POOL, as it's typically not a requirement for their
> testing. I'm not sure if they would be willing to configure and switch
> to SCRATCH_DEV_POOL, just for these few test cases. If we can avoid making
> the pool to be a hard requirement, it might be more user-friendly for other
> fs list. Welcome feedback and review points from other filesystem mailing
> lists :)

Yes, doing this using loop devices or ramdisk is going to get us much
better coverage.

