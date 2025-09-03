Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 633F02D5938;
	Wed,  3 Sep 2025 06:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756879713; cv=none; b=udQqxrwRjXsGpUBPV1BE4+8CFYhuDI4ylj0Lh9eysCe9qRo22OuzsJw0qqijGuhiLuAB86l4At2ZNIH6dOz3y7rYc2amtPC0AW/2UpDSmPBkCxU/0O1sGr/qBguGTt5cA2zPbcl3X7tdHaxd6jvPqLD52mlS827jQe6Z+gZagBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756879713; c=relaxed/simple;
	bh=xoXZ8fI6UslXlNQFkGXP2ovZvb7oU9JUnj0hhiY1+q4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m7xkFbRrzvJoZEclbMk+865VkPvV85P0hgsEtJ43qcKVfzl40MDkwCTUMvZqi7AvPXF8hAvstJjE+ohME6nHTc82qopaVoymDYPiLPjuUrz3hgnxhoGlS4Qjlr/Hpje0P4i/tUBqOW07jKgaQz/aJzhO7iTIcJi6FOSYEPn4STA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vB0ywPsi; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vB0ywPsi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=L851IHbqrVpIrG6uFeEojRb7BABVfLuDX9yKbnxc82M=; b=vB0ywPsi0BiQ0RcWLFCg4b9CXM
	8tfr/Yz9TErvtAmM90+NrYZsMZpdOe5SGTMu4slh80l/mmthTGXCrW8G5Gp4wCnPh9kB2wlptISfP
	Bc1OwxOzR6Z8fklu+6YKwonvY7CxxD7/SU/Nm4wocgKLdYA3IYrP59xOFDgneKbDyerNCsyxN/rLs
	W8A54YkMxXQt61lsuEr5TTemAOKc7pkiiuWH6aHcyX6VnJICvu0YHlRy/07zZf9zOFiMIVApAVKIW
	v0A0j8tl2GP062oziB2w0j76xrP5OhDLrvO5/5aQaGSsSn5zRZXEvHSoG8rWpXmO5h0VZ0bovgy4m
	Q6ceWpug==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1utgfX-00000004Tjn-3wiY;
	Wed, 03 Sep 2025 06:08:31 +0000
Date: Tue, 2 Sep 2025 23:08:31 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: syzbot <syzbot+0391d34e801643e2809b@syzkaller.appspotmail.com>,
	cem@kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [xfs?] KASAN: slab-use-after-free Read in xfs_buf_rele
 (4)
Message-ID: <aLfbXzRIXsRYibF3@infradead.org>
References: <68b6d7b3.050a0220.3db4df.01cf.GAE@google.com>
 <aLeUdemAZ5wmtZel@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLeUdemAZ5wmtZel@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Sep 03, 2025 at 11:05:57AM +1000, Dave Chinner wrote:
> I think that the buftarg rhashtable needs to initialised before the
> shrinker is registered, then freed from xfs_destroy_buftarg() after
> the shrinker has been shut down as it must live longer than the
> buftarg shrinker instance. i.e. the buftarg rhashtable needs to have
> the same life cycle as the buftarg LRU list....

My RFC patch to switch back to a per-buftarg hashtable would do that:

https://git.infradead.org/?p=users/hch/xfs.git;a=commitdiff;h=e3cc537864a7ab980abfa18a3efe01a111aad1d7

I still haven't gotten around doing serious performance testing on it,
and I'm busy right now.  But in about two weeks I'll probably have
both a bit of time and access to a big enough system to do serious
scalability testing on it.

