Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B834192D7E;
	Wed, 19 Feb 2025 06:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739945287; cv=none; b=oP/FBq8gx6hE+tTKHcqupb3AXmbN4nhJblZs3swyI7FK2Pc/v499vN1q2uW3U6rE9ycAlhxx/9bwbdzWfh6nDoQK3jr7h8JBHVmN5RDivmeIKPAtF/UjPPlF5plhamdwkNH19jY8t9VRsm6tVKjlgaam8f7iIrmPiC4qJA62ve4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739945287; c=relaxed/simple;
	bh=chk+gC7IJtMMXcusKi8oesrxVZ4nK2Mw0UpztOn9Cyc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SAdvZUBzirbczrjuFSr2oGPSUciuFvdnbKkcLxNWq5Ymoo+qUcWWLELPyPvxZa7Ex6m0v8ZP+0OnGOG0GjoyRdXT72aCF4derYz9pIIw3v09vNUCQ7i79AT58qSio4GfKwWlpTUnWpGDmMIrn0hi9z5BOSivdEWVWtcHJO9xbWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hxc+LW6s; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hxc+LW6s"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=CP/tiaIB9IAURTSFRLiIttERGHtI4/5repPydnIcWis=; b=hxc+LW6sHqixvWxVSXAEd+jdm3
	1h5chCjGLs0btyL4aIELEM0ubuZmAWWk4WNCjJR3QZlSV7NKIDHgR1IfnKGu4HQ7qOZu0VExt8LiZ
	C7rJgB2veE+h98LIwo0oo4AGYkbGZo2jzfaio+t6PI2Yx6LkbaMNtHPIO/LfWwr3Fre2PTkAk7Ghn
	caYoYamPi9lYm3Z935xHllbRpYm2qMTDO+/5UThLvnsCHy6Yz0Gyds2iOXeTOfeK/eqL7696mKYt3
	9kv3jXd4zhH0JRSnXnQbTuSewW+ivVrQhEXuOWnIqesqXZG4bNsTGA1FEYj4YOPklvMZ55u4Jotqo
	eeWYAZ+A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkdFe-0000000B074-1ZzP;
	Wed, 19 Feb 2025 06:08:06 +0000
Date: Tue, 18 Feb 2025 22:08:06 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 11/12] xfs/28[56],xfs/56[56]: add to the auto group
Message-ID: <Z7V1Ru-05o2iFgzw@infradead.org>
References: <173992587345.4078254.10329522794097667782.stgit@frogsfrogsfrogs>
 <173992587607.4078254.10572528213509901449.stgit@frogsfrogsfrogs>
 <Z7VzmdxUtQcNcgzS@infradead.org>
 <20250219060504.GW3028674@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250219060504.GW3028674@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Feb 18, 2025 at 10:05:04PM -0800, Darrick J. Wong wrote:
> > Can you explain why only these four?
> 
> The rest of the stress tests pick /one/ metadata type and race
> scrub/repair of it against fsstress by invoking xfs_io repeatedly.
> xfs/28[56] runs the whole xfs_scrub program repeatedly so we get to
> exercise all of them in a single test.
> 
> (The more specific ones make it a lot easier to debug problems.)

Can you add this to the commit log?  With that:

Reviewed-by: Christoph Hellwig <hch@lst.de>

