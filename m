Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D621319D074
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 06:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790316812; cv=none; b=u1v2C0HAjNoNnoiTJx9WdewLFlu7onFqVvvkvMMRmfSfmGTJw92BAbPW+3qxNVHF4nrsPsRl0PKKNOHDPN9izXHsi7u95QRUQFwaQDMYYCv9SEwzcchPv1P1pYHWhg2kKp57xNRjubKuNcnevh4IZbzPG6A/k7dU9cfabE6qJ3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790316812; c=relaxed/simple;
	bh=ku28J/ZAsFL5aHruJtxU5Cew3TRL/5i8yRgH4VGTTvY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S6SJo6skk4rK+1sAzOHTudp2CyXhzdYdREZMh4FmuLS5YenxU9QrdfI3OR8oIWcOgme5ZvLhgWgde2XtUvvgJNXCVgoRZ1X0Odzkfo+w9WXFt4HKxMFbcy2xMiZspoylvq7iSlCfYB8dbPLl7EZSZHBLBcrQO2G39QhLUZtiBJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 74A7168BFE; Fri, 25 Sep 2026 08:13:27 +0200 (CEST)
Date: Fri, 25 Sep 2026 08:13:27 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/32] libxfs: add DIV_ROUND_UP_ULL
Message-ID: <20260925061327.GB3637@lst.de>
References: <20260924100512.2733748-1-hch@lst.de> <20260924100512.2733748-5-hch@lst.de> <20260924204437.GC2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924204437.GC2705364@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Sep 24, 2026 at 01:44:37PM -0700, Darrick J. Wong wrote:
> >  #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
> > +#define DIV_ROUND_UP_ULL(n,d) DIV_ROUND_UP(n,d)
> 
> Er... shouldn't there be some sort of u64 cast here?

I think the only reason it exists in the kernel is to add the do_div
for 64-bit divisions on 32-bit.  It also is a macro in the kernel, so
there is no type-promotion there either.

