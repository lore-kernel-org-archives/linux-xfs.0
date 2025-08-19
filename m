Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 125FD23E32B
	for <linux-xfs@vger.kernel.org>; Tue, 19 Aug 2025 15:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755618068; cv=none; b=pCXC4W6sWFl5puZcMJ8O6qvjOXGcXfscGY/v2naaDLpjgVhnekC1edN3hH5e9Sz/n3mO8qJtPFUY5yb0uJbfLhRKzNXUEIfs9yJVEIGv0XMdRaRguhSXLI8yjw8CFGRfmdHEhwKXuSee25+vNmf+G3t8UvPGbnpE1HNXngJNJvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755618068; c=relaxed/simple;
	bh=ZpJu0heU+BsX0EYYMu7GG0HAPWqihMNb/6Dea1G1OIk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tlb4K3jkWXmiLyip0MXR2nAp23FwvYrD+NkljN2kMDNv6crqTeWoWwsbBrFKP2V8o5IeU6niv5bL3906ZklPu9HWrislynXiyWDJwij238TzkaHfb2GJ6WHIFSn1yQlT0nRebUsjKF6dsXcCfv92DRuVzj9E/2Ay4QoJSl8G9og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FtQ0+yNC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FtQ0+yNC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=DuGG+60g7wwIa8xTpcSvSddVPNwF+W3ZV36cyGACZ1g=; b=FtQ0+yNC6fHfVvkCSTx7CP1Qg9
	Xyin8XzQ2xTZBOE1HjyCrFEbhcb3aQIVKt2LYe9YBVU6PcyxF9s2A1MYfBXarK5JGJGosreDZpJfe
	EUxdASbnXIrbchDPZhoq5mKneXZZLa0MRQGZ89l5IEfSrGfiGZB2fMV6py4YRx0+UGI1pA+F9pO19
	xErMeKk+BRH3G5+Y73jo3YCC0iIagbWN399Wrw4H0EgP5O3cPdyb7BVT1+1CZsCXob5TmPf45V55Y
	44KJgThhpaWxaIaFUybasB9X3lzpwMtudfI+tOdZPmE8CO3BNODiFMkBaXi9dqHu4hZYdJXAeCGk8
	IunXA3eQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uoOSQ-0000000Auv8-2o2E;
	Tue, 19 Aug 2025 15:41:06 +0000
Date: Tue, 19 Aug 2025 08:41:06 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>,
	Eric Sandeen <sandeen@redhat.com>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Donald Douwsma <ddouwsma@redhat.com>
Subject: Re: [PATCH RFC] xfs: remap block layer ENODATA read errors to EIO
Message-ID: <aKSbEnTEhm7zOHOU@infradead.org>
References: <1bd13475-3154-4ab4-8930-2c8cdc295829@redhat.com>
 <aKQxD_txX68w4Tb-@infradead.org>
 <573177fd-202d-4853-b0d1-c7b7d9bbf2f2@sandeen.net>
 <aKSW1yC3yyR6anIM@infradead.org>
 <0d424258-e1ba-47c3-a0ae-60e241ca3c7c@sandeen.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d424258-e1ba-47c3-a0ae-60e241ca3c7c@sandeen.net>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Aug 19, 2025 at 10:38:54AM -0500, Eric Sandeen wrote:
> Ok, this is getting a little more complex. The ENODATA problem is
> very specific, and has (oddly) been reported by users/customers twice
> in recent days. Maybe I can send an acceptable fix for that specific,
> observed problem (also suitable for -stable etc), then another
> one that is more ambitious on top of that.

The summary of the above is that for xfs_buf concerns any error
leaking out of xfs_buf.c should be turned into -EIO.  We might
want to treat ENOSPC special inside of xfs_buf.c, but that would
be a separate enhancement.

