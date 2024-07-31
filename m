Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF34D5A10B
	for <linux-xfs@vger.kernel.org>; Wed, 31 Jul 2024 15:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722440521; cv=none; b=VQ8omNO9bfAF0wkpBWoi9CATW/lwekqviVByPfmiy7sN4rOG5GBaVZaFQowRPq2i1YaE2R/O1Rksakebdm10wGJjmoe/Gz0Y2toz+bdzLpkOrqyrxtcWHeu2yxTuuK2wD9LG1hMw6IV9qV14A3X12/CFB0Och0KeG+crW+MP5Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722440521; c=relaxed/simple;
	bh=ebC84riPuJsw2JfXDr+JaHAzPw4Rgs0WLJprKnUaN74=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ues5mLIJK7i6yI+L/U7K0yeFidQp3nHQ7JMYjJofHwEBy+EyMZKuK+vWUCAjkwXykuQp/0zEau/Z7LCB0tEfjr0ZL+V2jBkwAdwp+tHLvxgEW6RSShJqF8OQ2vi/K2OdMmnTEsT2H4R8l76sVee7gzDaDypzcUjoysLyhAO4aeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OpJiR+Wb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OpJiR+Wb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=CIQi8tZdo2D78XRrwWgR2ohTjD2U5lQjdYIOYuu4qys=; b=OpJiR+Wb9RnDlE7vtJHMD6G+CP
	0JUIDPIksz75e0sclhKxIiB6Yx0Y+wkutuEDyieEvhWQUybBnqgUEMzExSPmHqhUqynN8lzE26Xk7
	x9+CueOI1t0ShpAthOgJLvAvbCUxG+gEfnw8KrCDF6k/UGURVgRp6nlSsAjc/h8F/ffQ9zCvS5E7b
	sxv5OwTv89tNlDVYcO2L9AGe0lUrKwpjgp6pODRLnfB9AdsK949fZ+o4ITHxrFAYVC85XSOlNN1Px
	Y9XihXAzkw8KTy+7zuHfLUAt+7eKpYdLyUMhB4Pf0xLfJvK2VD7umzsDCydg8vha8HQ6F85lx4COA
	bJRC6uKw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sZBSg-00000001kz1-42SX;
	Wed, 31 Jul 2024 15:41:58 +0000
Date: Wed, 31 Jul 2024 08:41:58 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, cem@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/7] xfs_spaceman: edit filesystem properties
Message-ID: <ZqpbRibHaNodChSt@infradead.org>
References: <172230940561.1543753.1129774775335002180.stgit@frogsfrogsfrogs>
 <172230940600.1543753.11770032596501355577.stgit@frogsfrogsfrogs>
 <ZqleFeJhCVee5ttL@infradead.org>
 <20240730223725.GL6352@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240730223725.GL6352@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Jul 30, 2024 at 03:37:25PM -0700, Darrick J. Wong wrote:
> On Tue, Jul 30, 2024 at 02:41:41PM -0700, Christoph Hellwig wrote:
> > Is this really a xfs_spaceman thingy?  The code itself looks fine,
> > but the association with space management is kinda weird.
> 
> I dunno.  It could just as easily go into xfs_io I suppose; the tiny
> advantage of putting it in spaceman is that spaceman grabs the
> fsgeometry structure on file open so we don't have to do that again.

For the online changes xfs_io seems ok, and for the offline ones xfs_db
seems like a perfevt fit anyway.

