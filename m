Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB1253FF882
	for <linux-xfs@vger.kernel.org>; Mon, 29 Jun 2026 12:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782735966; cv=none; b=krzvj4cI0c7NIB/Zl4RAeqxgDGUIF93SgY18aIyktZzDYYqPy0LV4ivTLQdAFubWFwNWYT/W3VoxkfTh6O423+26Ublqn0UP4ICjFVaGAtBV2d8cGRuZQ/TpPzHmtQGB1Wp8IMNLvk8PtnuReTQQKSikWJPRLx5JmUdsjfe4DI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782735966; c=relaxed/simple;
	bh=pCA9PoxL7peuP6eC+Ahdt73ztKpMwf0QvoVLPueVrz4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SHI5LZ4sJ7RT27ckYXVf0UCp5Zo/T2/epCX+RArM2TDE+kgCP6ZIqQDCRzidgHqxn1g2aTceNACLOhJLOD4K6GzpgVIcKpawue5pFSciN9Sz2DpN5R81cHoZDlazYODmmonqhyNPc5oJkgQDzI+o5m+aG0j26lifQWWVpuSFTgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 43CB468B05; Mon, 29 Jun 2026 14:26:03 +0200 (CEST)
Date: Mon, 29 Jun 2026 14:26:03 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, aalbersh@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/8] xfs_scrub: fix spacemap external log device scan
 dev key
Message-ID: <20260629122603.GC21344@lst.de>
References: <178242801268.1981574.8079691316092703702.stgit@frogsfrogsfrogs> <178242801378.1981574.12871573702305819173.stgit@frogsfrogsfrogs> <20260626050345.GD8786@lst.de> <20260626170914.GZ6078@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260626170914.GZ6078@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jun 26, 2026 at 10:09:14AM -0700, Darrick J. Wong wrote:
> 
> > scan_rt_rmaps seems to have similar issues.
> 
> I don't agree with that since it's only used for pre-rtgroups rt volumes
> which can't be internal, but it's trivial to clean it up along with the
> other callsites so in it goes.

Ah, right - that's why I'm not seeing any errors.  Having the conversion
next to the ioctl call is still good, and I really should have done that
from the beginning...
