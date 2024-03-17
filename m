Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 736EC1EB36
	for <linux-xfs@vger.kernel.org>; Sun, 17 Mar 2024 21:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710709834; cv=none; b=RlSsbCQA714VsUjwtl6vJAxMhR3pUAA1GIFvxco0cKxTMua0WFBkLEtK+1EcY2c5C3Pq0UTBey76QpMoSkLjZTRqkaPBsoc09lr9W6wRldzmXlvsbMnm3BHki+kmuv09DEBMOhgXe/367hH6jUbF1QmcZwWAzZ4zY0IwZ9tVso0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710709834; c=relaxed/simple;
	bh=lkkdKSVBSRt42iB2hEkoQdf7gqKBSOyifcVCC9Epbwg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pkLHpCHuz7d1oIunnZFkdTp0GQiqI8EyOHS71B35F9OOfkePIsLhKsaGWybXiqwdlj+weh8LJHo4eAixPu7pysTEieALzQf4G8RCeMhPFGcEjwlhmPLVlWFWQKB2B4TtgZT+zTJsXBpZRBbdBpncH0p77jQl3Y2tXEfiHgq1qQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Uo1whJxg; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Uo1whJxg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=dG3MGlCqdROl43bXQSbInXGFPWP0yYtZXBB+Bdf57Ho=; b=Uo1whJxgltijpfKx0+8f6pzf0c
	6ybOl11VSvw8HFLhqCcbtfW9AMfilzS51HphxADcyVBsAe3MrOzcJfNN+WrbwcdENLncFsF0zFwwU
	DuBwjAzUByCjlixQUPDT3QI22nTgTWXuOSSTDpR6E7hxLw6terXmUGbLHfO9OnNB9I4DsGIStDoho
	tsZ2pidAjXmMGYIKRKjGbeYG5dtDUDIb/dnMUaVD5AIjTv5PymvO5/jI17uJXWPs25oh0EgzKgcBS
	mc3DWB7a49JsIFlYOhuIhsj2gn7tp5r8CrQ61gZUyKN9lY2BYcIMW73lkxiCwjEiVMDGsY10VrcFK
	U6mfHmhQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rlxm4-00000006SQF-2ocD;
	Sun, 17 Mar 2024 21:10:32 +0000
Date: Sun, 17 Mar 2024 14:10:32 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, cem@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs_repair: rebuild block mappings from rmapbt data
Message-ID: <ZfdcSAt7EO1qmXhi@infradead.org>
References: <171029434322.2065697.15834513610979167624.stgit@frogsfrogsfrogs>
 <171029434369.2065697.1871117227419755749.stgit@frogsfrogsfrogs>
 <ZfJaGhIgMvL2LBG6@infradead.org>
 <20240314235607.GT1927156@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240314235607.GT1927156@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Mar 14, 2024 at 04:56:07PM -0700, Darrick J. Wong wrote:
> On Wed, Mar 13, 2024 at 06:59:54PM -0700, Christoph Hellwig wrote:
> > > +#define min_t(type, x, y) ( ((type)(x)) > ((type)(y)) ? ((type)(y)) : ((type)(x)) )
> > 
> > Should this really be a hidden in a .c file in repair vs in a common
> > header where we can use it everywhere?
> 
> Eh, yeah, I'll move it to libfrog/util.h.  I'll even use the one that's
> in libxfs_priv.h.
> 
> #define min_t(type,x,y) \
> 	({ type __x = (x); type __y = (y); __x < __y ? __x: __y; })

Yes, that should already be included or easily includable.

