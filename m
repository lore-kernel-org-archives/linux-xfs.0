Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9FEA390239
	for <linux-xfs@vger.kernel.org>; Thu,  5 Mar 2026 13:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772719082; cv=none; b=sfJToMLEwrt0rGxzmn4uz0Ap34fXJXtbAFPUesJ8qx9nBtmxcWDRletwH37TNsXXjv+V0uHlE8y2hokIslH1tNCb/azRk0RLPmAI/NyVT92JB3jaNyl2SKcSFpFideaFYYN5rY56nFRvVq/fTVd99YTMMJ2wqZZVh6e5QowqInk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772719082; c=relaxed/simple;
	bh=wDMwOePKzTdJeKYOVA40XZ2n7gYWAWfDBJVNen5jMHY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UhbTGeWdbHbujzllLgY0RR2j1B7vfPvOsQgw4tGQkn0Vm8/ZmSxbCIgN4P4dN8uMazkYg/MQOIoIJJRVF3LA0jFaDw/EHWpm9i7XMxTRqGyUGbH9zh3069kYH2szbt3GX47rnyrHQ2Bxzuo+qJz42L6DVGTYUztwnuAA/BOZtL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WvHYPR5+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WvHYPR5+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=n52lGP9PDJ/tFqde4M3vxRVkG+GcQHeL/mIVc5Vr9TQ=; b=WvHYPR5+K/DOL628gr09t48oud
	Cbzz+/ScFKhCSYqLsMW9XMX0blAHVilj46YDmhiMVkESKfugqG1aG82cW2Wgivben0AlQQ1yyRc6h
	y1pp400BOHRouWUUg9WBOTqS463/NhLYM/VpAQZlrqKwAWlF6IS3SR8KSiYp9DYmTZWtTq9O8i56l
	k0SxekhdI33iL8FzXqgGCbMzugRUPuCtsPxSqr6ZevxiUmVcKSnozf5vuxbzgyMYceUnXAN8hk+TZ
	KGN0RVhlcWbR5hl2A/bJJtzg+3FmfVH6Eg3zPiErbNkjEKbc8+HHNB6E3m9wWvoicnAa4aW7riDgp
	VJJ1bqrA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vy9DD-00000001ulu-0rWV;
	Thu, 05 Mar 2026 13:57:59 +0000
Date: Thu, 5 Mar 2026 05:57:59 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, aalbersh@kernel.org, hch@lst.de,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/26] libfrog: add support code for starting systemd
 services programmatically
Message-ID: <aamL59w0kI0uFBVp@infradead.org>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
 <177249783347.482027.18301046401680150712.stgit@frogsfrogsfrogs>
 <aacCIcRTI6aDECTQ@infradead.org>
 <20260303155915.GI13868@frogsfrogsfrogs>
 <20260305023904.GB57948@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260305023904.GB57948@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Mar 04, 2026 at 06:39:04PM -0800, Darrick J. Wong wrote:
> Interim update -- just from looking at what
> 'systemctl restart --no-block' does, there's quite a lot of complexity
> that the CLI hides.  If you ask it to start a service, it gives you back
> a job object, then you can sit and wait to see what the result of the
> job is, etc.  The above vibecoding was actually enough to start the
> service, but TBH I think the dangers of shelling out are <cough> roughly
> on the same level as all the crap you have to add to talk to systemd
> over libdbus.
> 
> I'll try their mailing list, but first I have to wait for them to
> approve my subscription, and only then can I ask...

Eh.  But yeah, I guess just sticking to the CLI might end up best.

