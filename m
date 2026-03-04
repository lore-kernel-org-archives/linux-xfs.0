Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38FD325B2FA
	for <linux-xfs@vger.kernel.org>; Wed,  4 Mar 2026 13:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772629461; cv=none; b=VzY2NBAYCJshWtTGBjcsS/oO7mWL6P2C4bLGSGPHLgnUevzHwEXGoycW+YQoDT121DzOcJu9st/6Z9OMde+rfoXqXpkKRSEKCf1V9RTuSGTPLfLmco/INOa6MqipaSQ/32zaPdNbcgs1EMPar3H84xlxj8teE4O83js8dCQ9TcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772629461; c=relaxed/simple;
	bh=ofZ3n2V6DAo6H/lDJTOAv6EUQ6r/sayx+kX2pi0vaAY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HVUMcWkKck4t97OwofKYmD4aWOwu2Blx6F/bXKwxoF1v9k8qdQpCFLfqUw5r5ew4FAFxKKq9sheKGFiXX7W8Olstkv6vyWPAVHGkdSv8gbrW0ystJo360ImmXBFHd0MEP8D1HsesEWs00BAY2ORYLt4AYah4SrtGsh6tS1WJn9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=L9tKQEok; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="L9tKQEok"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Qye9npUba5LHOCcVQs7VGO85im5EI/Z/qQRMyipVM7M=; b=L9tKQEokOBzrY5iBdOk3hf1J1w
	q/rhvNmMZP0gR02dq1qoQOkXxyszO6yPj3a5N9rn5QSi29D5lGgpOPMKw1FlBghfOAdUHVPPWv24q
	HZ9WvozxuIhLQJFo6TUZLh2OHCU+/xr7dqSzBj0py0k2Ops0TMOzbhMQOeOv8qOetOeSXGSRUAdUO
	jk/OmfFKyKj0SZxl5poVoxBlZFs8jKTwl9Iqy7AeEcxLL7VLaSOxlxWoJ/+zhVoCqui94Et5h/BFX
	oL3elUBw+IyBzEv5GbGp3zvdb0VBHEDfsBaS5T5wOAnSsyNKZRUbAAQAEdfvoab4qcckesP48jvHC
	LTojE9ag==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxlti-0000000HDd5-2YPM;
	Wed, 04 Mar 2026 13:04:18 +0000
Date: Wed, 4 Mar 2026 05:04:18 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, aalbersh@kernel.org, hch@lst.de,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 23/26] xfs_io: print systemd service names
Message-ID: <aagt0pZTkqysyjQJ@infradead.org>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
 <177249783711.482027.11261039889156364110.stgit@frogsfrogsfrogs>
 <aacE3gW9j6pKrspy@infradead.org>
 <20260303172916.GR57948@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303172916.GR57948@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 03, 2026 at 09:29:16AM -0800, Darrick J. Wong wrote:
> (That was a long way of saying "can't we just keep using xfs_io as a
> dumping ground for QA-related xfs stuff?" ;))

I really hate messing it up with things that are no I/O at all,
and not related to issuing I/O or related syscalls.  Maybe just add
a new little binary for it?

