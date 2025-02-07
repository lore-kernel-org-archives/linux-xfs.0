Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 389ED63D
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 05:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738905577; cv=none; b=VyI45oFxW07FuybEW+RP9DRaNib60a0xQ3denaiz+Y+kSlA7jzgARDjj+R9K/w1TOvMFZAceyppFN0ZNw5hLpWnmXbiavywzXpXZPVGEqVMHT9Nptcsz/FfEkm62Ym4PjvbsvRTjo2WM/GEHCLZQgRXbMfL0+YCx+nWVtJ8EMkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738905577; c=relaxed/simple;
	bh=QivKUOuRuJqrRj+oxKfj48Ix+TmQUsFOe4+BYApfMfE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iOj6JVTS+P873vnBqkgewQCKd4hhcx07jmVgkXgJn9CLNWQae47Z+cDF72V+IrjJysF8lRp4IVsYl3YvfMjxRtfJkDMdbuL/Q4Gk3Ataa0OQIw1rdOW7W87akwmpFUGSEpYQugmmFIlEDX+/j4Jhh7VSIW4dN1FSOo4y0M0QCF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CMURoS/8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CMURoS/8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=tSUqgmWFcrZd7Efk39kfOSSRrqg+YbGn56CV5TaaNXY=; b=CMURoS/81R26G0HhsAuLT2jXmj
	DVWVs6WOEXZ71JSmGeQlMBiR7TbmYg8Te8xQw2bSDikO7JVaXqUwgdGB4i+YV2qu/6/YSp2JpeDmN
	b72D3hwRhqS0gJxF3DWIbgAZ8HyXZkT/In/f+oQqIxrYyvo9mNB+Pfdf919xy44g2ig0JAMhTo0MM
	IV/6hLfJEIccUiNVG6kcYPos/Z1bFP3OxsICQw6AFT/J6k2CcXoW1dxHiAe3PN9hXRy4ySpdGad/i
	7zCgG50dMb1wD7HaHvnaexi+Cl03OalzBGmmSGQbmATaT1GkjCcUlouzWJMjLv6g+Xx97oGs+j1aX
	q2uX94+Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tgGm7-00000008MFi-447l;
	Fri, 07 Feb 2025 05:19:35 +0000
Date: Thu, 6 Feb 2025 21:19:35 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/27] xfs_db: add an rgresv command
Message-ID: <Z6WX53R-pw979lxG@infradead.org>
References: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
 <173888088264.2741033.15457962498927616155.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888088264.2741033.15457962498927616155.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Feb 06, 2025 at 02:52:36PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create a command to dump rtgroup btree space reservations.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Btw, for rthinreit=1 file systems a command to dump the availale
freepace and the data device would also be really helpful.  But
I guess that's more a thing for the kernel as an ioctl that works
on the life file system.

