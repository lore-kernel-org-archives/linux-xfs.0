Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC8014D452
	for <linux-xfs@vger.kernel.org>; Mon, 14 Oct 2024 07:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728892526; cv=none; b=HrJ+ASq5+/ahZfXEqQsFtop/SIyixFH64cKSWr04mGIVAOEapN+z9yNbjsOSONm0kZp1uqFJTx5B+I2ibiyB7PXYIM4yLsOW0yXRdLHHgLrSnX8T5Vsm1uUkF9/G34SdaMhsFT0b5d3RJbBJSOeTt0e+UNluwciU4tN+mSaWerY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728892526; c=relaxed/simple;
	bh=/aSpQuxrFy1fjqUIDU/u6vE0NsZi7I3mqyhw50GqP/0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NveeIiSCAOIKcFY+zWQdzF3PiuoiShadqquMp38f/NWgD9qgjC1+H5X5Tki5Trob3mpp0PYc5HvBWAeub9c7OblRBxsqcF4GmzdBfsuh7te8+nfS83udx9nz2GtpGHYQWz5lGsD/Fi4hRwbEyI+15WKw5ikXcFMEbfCTqJ9GCww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UAW9HTcf; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UAW9HTcf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Vb04d9gBSdAe84BdDeJtplHKle3XwfMKJodiIgY3daE=; b=UAW9HTcfz7XViEr6GRrxYtxFS+
	ipSxzCCI1/AO/BOW5JvowlKs737rWmcEPJMtMXZtB53ScF7YLMLwHilPydvZ2BDhlJwUbbIUYRzGO
	FqNb3I278KaVyvqkYXfNb2taNcyIJjqVApuTwEOKo5crXAgXoHajW4C2Mhx66cAA0Qp59dHzYihaM
	KXahIF4qa8O7dr+kuL1P9Z1ewc1aFcsDyuTH7CKO6x5arX3aZqs6L4X3kyUzP3Sq7Pnsd/ztQupEL
	bEXgOOSurepkkNeb0pxiwiiqDRHV7pznuvZAWCEEtbxz6Nl7aEYw1R1gtAktshzvvTdZ2k65N5tDn
	Ejk4shzA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t0FvJ-000000049rJ-1209;
	Mon, 14 Oct 2024 07:55:25 +0000
Date: Mon, 14 Oct 2024 00:55:25 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/21] xfs: add a xfs_qm_unmount_rt helper
Message-ID: <ZwzObUb46IcTP1HD@infradead.org>
References: <172860642881.4177836.4401344305682380131.stgit@frogsfrogsfrogs>
 <172860643085.4177836.784622735507950940.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172860643085.4177836.784622735507950940.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Oct 10, 2024 at 05:57:46PM -0700, Darrick J. Wong wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> RT group enabled file systems fix the bug where we pointlessly attach
> quotas to the RT bitmap and summary files.  Split the code to detach the
> quotas into a helper, make it conditional and document the differing
> behavior for RT group and pre-RT group file systems.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

This should have your signof below mine if you pass on the patches.
Same for several more patches past this one.

