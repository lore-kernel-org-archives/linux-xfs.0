Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3257A159588
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 17:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709141162; cv=none; b=seP4tvCeXFy2l9YPaUWqj10U3eu5NFyE/cDEoFZenOvOib2iH990hR0KvKY3trK5bI2NO7P0GfLGi2kOOJaXRlA358OjmkVwAvpTIc+uAxfx23ZqS/L8pB+LMd2xILYr6kuyH46SWZZmALYLcmJl7JLL4QGATq2b6KVdloAx92k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709141162; c=relaxed/simple;
	bh=ZHWDoec4gQaGZSeXUR29Vcv5qu53mdzjYehya+VZDiE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O/k5XngbOBwmt7nx073EzgNicGovCKEHwZpJ09XItoeLyX8grl2NkanehJgyUS+i63hZy4hOfO5HLtLKCUYmQ4/oOjSTFn5O8b2vzxH4lKNsf/N3SFRDDBd5+uIpjD0rhNRKHg/V2jR8iPRUBjPAwOZwtY2CNrQkfPdB7+VqbaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WoJMeGi0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WoJMeGi0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=9wuuYwnShbU5Nr2tif9jDwAoGxVpWQf7vz0V8j1r1no=; b=WoJMeGi0IYRxElysldj0g8/oYQ
	7ISwaol9ilrKDxLYss3b9GWQZtDy7gM9LNjBvLJ8tP4F748/ORSOQBRtbcYEgUmw+1IzK+et4cB0p
	fj70m/96VZx3G/GlU+aHf3sGqfpGhSrgioyizDqlkjKGkvU5wfcyJplde+NG4MFB1HOTxGqHYTbyU
	4bVGLLTOElGeGKxGdUmQmIhVtivngeebh2cwLXPmDOOgd1N3ngS+GRUE4JC7Lbj3RvZD8iRI8/EwA
	u+5waeGB90xngGQ+er3OFuKR/e0wvZtldeD+qhpb9t69ZNRbdi8H+P0o/Mg5h2hjd4/JeQQjT27BD
	RMDrvHig==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfNgu-0000000AHtv-3V3n;
	Wed, 28 Feb 2024 17:26:00 +0000
Date: Wed, 28 Feb 2024 09:26:00 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: online repair of symbolic links
Message-ID: <Zd9sqALoZMOvHm8P@infradead.org>
References: <170900015254.939796.8033314539322473598.stgit@frogsfrogsfrogs>
 <170900015273.939796.12650929826491519393.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170900015273.939796.12650929826491519393.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Feb 26, 2024 at 06:32:51PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If a symbolic link target looks bad, try to sift through the rubble to
> find as much of the target buffer that we can, and stage a new target
> (short or remote format as needed) in a temporary file and use the
> atomic extent swapping mechanism to commit the results.

So this basically injects new link paths, which looks really dangerous
to me, as it creates odd attack vectors.  I'd much prefer to not
"repair" the path, but mark the link bad so that any access but unlike
returns -EIO.
