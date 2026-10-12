Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A382A2DB7BE;
	Mon, 12 Oct 2026 12:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791806547; cv=none; b=k2rwWXnl32OR85EfCW/6Sw6Eel5fjpdM1lQ9gEzrCobbPXxPSyYo3svs52PdftkAZN2lxBN/hgynrJPPZPas+bkUFry2BsL8IDuhuMRLA/qHswbPIoDFmIKcQgOWbwV84rs3K36ul1NZnlOdZa9FBtc4kKMABuhE085tWaET9HU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791806547; c=relaxed/simple;
	bh=N6KXo5qLFqY1ZI6eKy5OyjDsX13vdHPPSlu+eIhsFzI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pRRC/abDx1RYLAfRssxp1PuYCst9kZFq3tBowxOWdHGU4/aInJG+JK/PP21NGnyOP44fVT0zfg+jSOAoxXJspHmvO4j0NVD5pSty2rIg73ZGqmYYHyDeGCmJku0vGlObnig2/YyMfjQRGu7RG4tnY+caKQYg5fAiWa78dz6SbL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 91C736732A; Mon, 12 Oct 2026 14:02:13 +0200 (CEST)
Date: Mon, 12 Oct 2026 14:02:13 +0200
From: Christoph Hellwig <hch@lst.de>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Hannes Reinecke <hare@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	John Garry <john.garry@linux.dev>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH v6 0/9] block device fixes for large block sizes,
 IOCB_NOWAIT, and direct I/O
Message-ID: <20261012120212.GA29154@lst.de>
References: <20261009-blkdev-fixes-v6-0-307939c387df@columbia.edu>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261009-blkdev-fixes-v6-0-307939c387df@columbia.edu>
User-Agent: Mutt/1.5.17 (2007-11-01)

Still looks good to me in the rebased version.

