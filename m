Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 575BB1E9B0B;
	Fri, 13 Jun 2025 05:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749794389; cv=none; b=f6TkPBLQC5GF5dt0VtngGf/KzetPacfpex9LLoRcGqpV52qyN0UkKZYclkm05MQNUINJp75Cw/FyqAxaadgJByAECtHwz4Fie8CEElxDWwMSaCx+ob9d8JQb3r3hNcpyjn8g23M2YTan2cFk8qsw/Q5jmDhK7O+MMEfEst3Z4ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749794389; c=relaxed/simple;
	bh=erbT9uSMKTaeOK0cpylilOcElrflIs+o4M2IFkywQB0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uD5nthVr0Pc0g8y3+dtCf216lPlSgyg/elwbw05MVf11aJm8gq9jIhu3RNwmKvaa4rLs/hHN9k0vrWnYDiUzySXckrTxngUICSdszoVkn3Jd0NR6/6gpW24Jnli7I6biscZb3dsNWk3adjJAh8iiKfWWZokqAeLFevKha8BsdKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jhx5hv8u; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jhx5hv8u"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=fSxDPCdGlntjmeOpPX8gpHNIC/qPZhk7KI7rcRVTWXc=; b=jhx5hv8uTYMwE30aE19EvXHJXu
	HC9XhM+YDEoFJ596QCRgRHZ1j/jrHxdA9YtfSjLXDoLS+LQh6p7Z8GyQtco07h1nSxGXFhHBeWgfR
	YqjaA6tTvLTuuloxrx+19MAKTVueZkiAns+Js34bb9AGPtFe0VJq7UgHIwtit17Hno8bs1qnf5FUN
	4XPRBu6kHnU1bX10YkUDsPKIG4Qudk9kgLgD90yHkgzui4BIu4AoGiqOb4ZDfi5SkqTf4UfDYqfot
	dhVB+8yCvFZfQleki0nEP4MrM3OAOkyV9HH9OXm1sQRqsgClo+Pu3zZ9MTcs6CI+PvgJHRFmKrN6f
	dCoayLVQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uPxS7-0000000FRmO-1B8v;
	Fri, 13 Jun 2025 05:59:47 +0000
Date: Thu, 12 Jun 2025 22:59:47 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: Re: Unused event xfs_growfs_check_rtgeom
Message-ID: <aEu-U-va9q0QRuX0@infradead.org>
References: <20250612131021.114e6ec8@batman.local.home>
 <20250612131651.546936be@batman.local.home>
 <20250612174737.GM6179@frogsfrogsfrogs>
 <20250612144608.525860bc@batman.local.home>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250612144608.525860bc@batman.local.home>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Jun 12, 2025 at 02:46:08PM -0400, Steven Rostedt wrote:
> On Thu, 12 Jun 2025 10:47:37 -0700
> "Darrick J. Wong" <djwong@kernel.org> wrote:
> 
> > On Thu, Jun 12, 2025 at 01:16:51PM -0400, Steven Rostedt wrote:
> > > I also found events: xfs_metadir_link and xfs_metadir_start_link are
> > > defined in fs/xfs/libxfs/xfs_metadir.c in a #ifndef __KERNEL__ section.
> > > 
> > > Are these events ever used? Why are they called in !__KERNEL__ code?  
> > 
> > libxfs is shared with userspace, and xfs_repair uses them to relink old
> > quota files.
> >
> 
> Does this userspace use these trace events? If so, I think the events
> need to have an:

They have stubs for them.

