Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D191FBEA2
	for <linux-xfs@vger.kernel.org>; Thu, 30 Oct 2025 08:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761811305; cv=none; b=JBKMIFwq4tpqj+JnUyZO/MKTGNZ/ZUadPjq4SVV5s3Aq+NLDQOnHwoDBH3oMxWD2cNRhZ5jyGWdOXwna0fS6Iyz6HQxH4WQOzZrSDyOyTqdbm7GsV4/iKdOJfWF4QVH4GPp5eRhNVVlWcGWqbkf+ZlwUzQg3gqykU48LyiDxUno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761811305; c=relaxed/simple;
	bh=XuBeZW4eArUlEuasZBMcz37qnsdoMriMLyFouID1C4A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mCeA+1rHr8MRF8VnsXIzDgdAISL5YJWnxOOBJ+TTayKlIuC6+J19ps7TOS3Uy9FVbTv1C7s7jN4yEZs1poKKP2iCNMsav9YlS5Y0/Vhybeqv7tW527W/M4diBnJ0TdrDcN3Voh/YgqfLUGtyE7Dqn1qRCvftxwZgkVaryGIWE7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hGowLY5a; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hGowLY5a"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=XuBeZW4eArUlEuasZBMcz37qnsdoMriMLyFouID1C4A=; b=hGowLY5avp8v5ID+N+fyFEYqm2
	7stLGdZxlT0b6sTfCxx6M94OqLjZOBlvoJ+E+M0CnE52QwMOZ7jru5gheO/GHJlAmdLKB/gzzymsK
	BUe3617P1EanJM8U6G41K8tlyS9DxsAdJQD7ktqzFZrubSGliVTjzbHQbo7mUWCL+bVMuZfKouqNq
	a0GzkF+12s1beKHEn7BG6agyqR56xD3l0e5o3sKbosRjM87a3zBx4M9h1s8b8f9qbNs1CipuqhyDF
	meotjQJP0OinXQirbYa7xeRmdP4RhEKuK/h4hbxsWhcOCz/GovyDmYgqaFfRHtueaz7J0Pdb9dKxt
	hZr9VRBQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vENbK-00000003fHT-3oet;
	Thu, 30 Oct 2025 08:01:42 +0000
Date: Thu, 30 Oct 2025 01:01:42 -0700
From: Christoph Hellwig <hch@infradead.org>
To: syzbot+0391d34e801643e2809b@syzkaller.appspotmail.com
Cc: linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] Monthly xfs report (Oct 2025)
Message-ID: <aQMbZoAAVWxxx6wc@infradead.org>
References: <6901e360.050a0220.32483.0208.GAE@google.com>
 <aQMPqDAxyM3i3pQk@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQMPqDAxyM3i3pQk@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

#syz test git://git.infradead.org/users/hch/misc.git xfs-buf-hash
