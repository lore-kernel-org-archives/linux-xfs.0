Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B48637B407;
	Wed,  2 Sep 2026 07:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788333908; cv=none; b=OjryRgMn0KP7tsBGwoCqbEdXwxlXmZ+Ywd0j8+qKNiFyfke2vOjShVzO0YC7DFO1IzMJ8WcqRowbU7afZWjzmtaTBIyrCcVtJzkXhvHOklcTZlzYazv4pZ6vNgnJv0pqSVSWExxq0MWoHAMpGr5ZTvoejRiYPYa6kC+O8p1sJb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788333908; c=relaxed/simple;
	bh=YZTcTPmGeyN2N8w61UwaTiNOINZSjezlQsVzEpgB0yc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WEUR44pp6+dbbdvqTFO2VzhVFApRNxg1DanQIB1ttvEVSeaJyje96ub3BBr7gd4FyK+KKD5cclp+kjSQfPM24ir7AWXc/1DP8nvzbR6eN8HWz7AAMghvQXAo2tEyXBlKxiKCAP/QHnIn9tPRkXGklGMghNcdrIWm5sxfvm+BVTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7D34268B05; Wed,  2 Sep 2026 09:25:02 +0200 (CEST)
Date: Wed, 2 Sep 2026 09:25:02 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, hch@lst.de, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: fix backwards mergeability logic in refcount
 scrubber
Message-ID: <20260902072502.GE26173@lst.de>
References: <178832750681.3508131.6009513367948627110.stgit@frogsfrogsfrogs> <178832750815.3508131.4005702119407893700.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178832750815.3508131.4005702119407893700.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Sep 01, 2026 at 10:49:47PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> When we start the refcount or rtrefcount btree scanners, prev_rec is
> initialized to all zeroes.  This is done so that the record mergeability
> checks skip the first record because you must have two records to
> compare.  Unfortunately, I got the logic backwards, so scrub has never
> complained about mergeable refcountbt records.  Fix this bug that LOLLM
> noticed.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

