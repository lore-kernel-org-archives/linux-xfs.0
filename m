Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BFF8179BC;
	Wed, 19 Feb 2025 07:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739949435; cv=none; b=BxT8JQSN4U3/fZrgqi3jsMmwi7QwIKCCl3AwtuZoyX0uUB/Pe4W3JuU/VzrN8M+IzhygvvXSQ9TOFOfilJNbUzzg/nILqnMatDiHRSX1x2fexwBQNWYyGgmiNVlAJUdMxDIXI1E+KTMoT7+2v8o5+cDWWM1CRO2cBMf5S98YAaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739949435; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JIsdIJSv6vWR879b8nFHtNVEYp91PPOyZjbONTO6Inlj1NiIMIRO6ol0/ElulVaniIt7wwzTjrfJKbodgUGa0qeMzPR+hHyrz3JyAQ0clMe8sMBgwTA4GhvH4yJewY6qCWlX8ew75V7T7wXqdQy355Phq/8pdeiTt4uxI4NToUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bjieSnW/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bjieSnW/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=bjieSnW/j0tA2A6YdcfciT+jGK
	RwKVtsMu8PoznTaB9gZggBZws3MAEID13NqIMXwv7y+0MWGTI1FVAzF80VqnmTC9wF6UCnJCgV1tZ
	uA7wZggADjIzx+u9xGU3w6EwgTIesiI3TUG1fb+b1GfLHMpm7UORyeWS17HZroIGeqbTtsyCbWE+0
	7XA/qC+nLDEZ6QxoJ10ORtDmuALSm9UbiSyWWYep2Y0cTK/E6Xrc+E3dOGO+Ij0tPuH/VzxtYLIMG
	0jvJsj697qwKUYCJBXbhrmLTgKHJZlfIKAp0XNUjMUqck/+hQvMlnnhyX5ikyXfZ0rpXdoLqpooZN
	5iskBwlw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkeKY-0000000BCMV-1MQP;
	Wed, 19 Feb 2025 07:17:14 +0000
Date: Tue, 18 Feb 2025 23:17:14 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 12/15] xfs/271,xfs/556: fix tests to deal with rtgroups
 output in bmap/fsmap commands
Message-ID: <Z7WFenIg2PmO5Qkn@infradead.org>
References: <173992589108.4079457.2534756062525120761.stgit@frogsfrogsfrogs>
 <173992589400.4079457.7456085852406287416.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992589400.4079457.7456085852406287416.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

