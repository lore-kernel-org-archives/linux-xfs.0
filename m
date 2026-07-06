Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700A53D891A
	for <linux-xfs@vger.kernel.org>; Mon,  6 Jul 2026 06:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783320843; cv=none; b=OUovLZz9euLQgu6DmSIZqM4yrjbPl7YslYby0+RHMG/nf3NctfJD/1rrnCWS9gMIYdFkHsnD4TJ4pjfgNstQEybh+7IDiBwhWziqMeFiqfvBt7VHrkWqdklOV9Ri5dVBZhBBnD6iq7IGdGKoATV8iyT/aFoldjE4Tv63+wkOCvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783320843; c=relaxed/simple;
	bh=1xz4zl7EMQjTOMVQUtggdkR+WHxfEjBNsoJtgvzCawE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OyMnADe5vYZuvttdUCltpZk1zQUUXurCl6RSSseaKOQEGR9faeKW7gjy5t2Ly/gvyz8WfhKs39HQ8+NAp+IVCsbC3F83jnyWpYxQSkU2MNBmlqxJxzH8C3dLFVtmL6wJGsj7phsyb/bQa2vHBIbH1pIby0s6hRwG07I4RNIHPjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nfDTZB2R; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nfDTZB2R"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=1xz4zl7EMQjTOMVQUtggdkR+WHxfEjBNsoJtgvzCawE=; b=nfDTZB2RUwoVgaBE+I1BJlK/AX
	rTHMOmqNBuZjkvTiwYLRzKRDcYMlPZxxSbDkIvDuCmjEYbyKv2SLZxc9UJzm/yJxjNrJ5Cqy1vNt4
	2buDvFN1eIrYXkCsuY6pXKlzftM0BmANAyhksc5OXzkkMSw/BIkmREFPNucLqpezLCZ4scloPwLzz
	hkpIitLeGKAz0IjggpnSGOWcA3ahLsRsxU3xTD8RPQ5jkwQrqJOSjYfLtL4fMzFheM9ftxZOmPSQg
	PNWSwL1Ym7yM5ZgclKbXLvroe+nr+APMWVZzBIiOxV5PhQO0K6+/WZYhi0VLJCsaxSbaMxdjC9pgm
	CcwFDxDA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wgdDF-0000000BfR1-0lJP;
	Mon, 06 Jul 2026 06:53:53 +0000
Date: Sun, 5 Jul 2026 23:53:53 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, chuck.lever@oracle.com, roland.mainz@nrubsig.org,
	cmaiolino@redhat.com, cem@kernel.org, hch@lst.de,
	brauner@kernel.org, gaoyingjie@uniontech.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET 2/2] xfsprogs: new libxfs code from kernel 7.2
Message-ID: <aktRAQc4jHLz0CAd@infradead.org>
References: <178302226213.845537.4378925114415707650.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178302226213.845537.4378925114415707650.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The resync looks good, module the minor nitpick on the last patch:

Reviewed-by: Christoph Hellwig <hch@lst.de>

