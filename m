Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F982248B5
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733809624; cv=none; b=WJEZjFf4Qx5gVBBaRQGJszeFEtQCzehWrUuv4Pl+nsupG5NOe9AJGFJOpGwSbIG65IVU6E10mc8HstVKA8ejdHkaichjcMwl/WmTjWX3ohsHZsPXUfm8YAaqtZNShrPKq8Kw8A1mkw7KbgZDgDm1zwtDFJ02WFSNeUUU9rngCoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733809624; c=relaxed/simple;
	bh=SjwdKLDvyXu19ICYaN1uH+x+qgEksHmW0IaJQC+hh3g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UdpIWxSF8edpTE5Yn9wyuXz3Yxs/qSUBf1keZSeHd9ZWc6AFGnH2umQBYPsdvKvoQyJrJBkz8QpuVAwVyYh5pufXdN2TMZ+6ajekqBcksrUBz2+qxtDhl2U2m0G7pQvBgQ4ktUYt068uxraiLOvObg8jUlDCWVH+2SA922J6vQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=o2YZl91k; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="o2YZl91k"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8kqnruRjC4HznJdykwmOZWmivzNGlMzDMzlaycSlfcU=; b=o2YZl91kWipgkJVg3fp0Nr48am
	3YTs8rCzEW/MdkeZIyc3GhDRUbR5vm5aT7EPB8CoS1aQgAG1GS6+K7UGK/6nAJyEbWjECnv2v9Max
	mFVNjt/gO/2FkQx3TM/bLJg+V6WfTo3qd9KJRO+QX3YB/pDxk2QA9sdmMNt5V8SgD7KHbPVoo2QAM
	9fbu6tRVsNL/ey40VPIqlVvT/ZR2QGuGkXBhsE2eLrMKxvNZdrU4b6KQOwy2eNNzMfMh2d2zJeCky
	MJweSSO6wxhwZPXQStRveLOTi00k5v8aV5Gecv7AO5lTsSLBH6evxxjj/bg91f9vVxy9SNBCOzHJN
	BLqFEazg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKt5K-0000000AJ3v-3lzD;
	Tue, 10 Dec 2024 05:47:02 +0000
Date: Mon, 9 Dec 2024 21:47:02 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 32/50] xfs_db: metadump realtime devices
Message-ID: <Z1fV1nKis3nsTsoB@infradead.org>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
 <173352752434.126362.4802798668828712862.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352752434.126362.4802798668828712862.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +	/* The realtime device only contains metadata if rtgroups is enabled. */
> +	if (mp->m_rtdev_targp->bt_bdev && xfs_has_rtgroups(mp))

As you pointed out when looking at my follow on series, this should be
xfs_has_rtsb instead of xfs_has_rtgroups (for cosmetic reasons).

> +		metadump.realtime_data = true;
> +
> +	if (metadump.realtime_data && !version_opt_set)
> +		metadump.version = 2;
> +
> +	if (metadump.version == 2 && xfs_has_realtime(mp) &&
> +	    xfs_has_rtgroups(mp) &&
> +	    !metadump.realtime_data) {
> +		print_warning("realtime device not loaded, use -R");
> +		return 1;
> +	}

Also this whole flow looks a bit weird.  This is what I ended up with
removing my later changes:

	/*
	 * The realtime device only contains metadata if the RT superblock is
	 * enabled.
	 */
	if (xfs_has_realtime(mp) && xfs_has_rtsb(mp)) {
		if (mp->m_rtdev_targp->bt_bdev) {
			metadump.realtime_data = true;
			if (!version_opt_set)
				metadump.version = 2;
		} else if (metadump.version == 2 && !metadump.realtime_data) {
			print_warning("realtime device not loaded, use -R")
			return 1;
		}
	}

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
