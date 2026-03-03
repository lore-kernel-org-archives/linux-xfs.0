Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E5063909B6
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 15:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772552739; cv=none; b=lsDgUEnTKOd3pqA0mhweS+RFLraMostx6F3+JovyPSufpzs3FgTuyAVZ5IVwj8EzZJMJpGSAQSHlyDLUpLBTnLmwIthy3k26JnYlBPLWcO01b84HU/mLC9E1OGMb/IzmFTLOpLiBSJEkow06KIq7n5IGSvLJFTn36sl5w/mxfAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772552739; c=relaxed/simple;
	bh=TEt0wD+6e5dTEqCIP7aehtBj+Ax0egxmuWX5MwPbm0I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nQphRORHVgzziAW/NQ8EQ00OEOqg+UFQBedMmxoferISj4ESeeWetc4/v3qWAUKHDLIPY3Rd4pRxOrvzhD06oujQrxMDpqzFsDh2wefsZ9iZbLomLOdeLSKCfx00MSQOnjEBSsmBBvCihL4/mVnuFiwgn6r7wDbm3hIs5BHRA/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=R5zJrB1Y; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="R5zJrB1Y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=fe6ESoKOEl13uT1bo08vBKQm5q7My78PNqlncvQVX1k=; b=R5zJrB1YPyU0Sut6gBHYvoT0RD
	spccbQP6gzc/yJr1R/htZX4c3BIkYJNbRywe6ERMZqMTaEh+4aXa41x/9imcvvbWVcxWoL1Vdjw5m
	paPbHssdKe44Tj5Zs+L9HxPz3kAVVCCpn2uZZ41bFrdATDEGXVhw0d+msvCkxGkpKZSdhVr47pdpV
	Ii868D4AZbFTqVvqOak/joE4u6vS3JQQlQSBoW7HMfs/vkSR/bLeTQKoPVTP6SB3Xrns5qriNltwZ
	CKNYYrJbZMmmOosSlm9B86sMTigyhKiMJQme40hkeiuL+t2jg/ZyVjLZAJ69taEp9QEF35lWjki/w
	hdPgLKSg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxRwH-0000000FS4B-48T4;
	Tue, 03 Mar 2026 15:45:38 +0000
Date: Tue, 3 Mar 2026 07:45:37 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/26] libfrog: add support code for starting systemd
 services programmatically
Message-ID: <aacCIcRTI6aDECTQ@infradead.org>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
 <177249783347.482027.18301046401680150712.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177249783347.482027.18301046401680150712.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Mar 02, 2026 at 04:34:36PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add some simple routines for computing the name of systemd service
> instances and starting systemd services.  These will be used by the
> xfs_healer_start service to start per-filesystem xfs_healer service
> instances.
> 
> Note that we run systemd helper programs as subprocesses for a couple of
> reasons.  First, the path-escaping functionality is not a part of any
> library-accessible API, which means it can only be accessed via
> systemd-escape(1).  Second, although the service startup functionality
> can be reached via dbus, doing so would introduce a new library
> dependency.  Systemd is also undergoing a dbus -> varlink RPC transition
> so we avoid that mess by calling the cli systemctl(1) program.

Just curious: did you run this past the systemd folks?  Shelling out
always feel a bit iffy, and they're usually happy to help on how to
integrate with their services, so just asking might result in a better
way.

