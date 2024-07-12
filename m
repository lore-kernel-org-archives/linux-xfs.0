Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD2F15E83;
	Fri, 12 Jul 2024 04:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720760180; cv=none; b=mw7G+v17MAntqxztlOCnUcR3lrCWJ5nIwF+2RR7sbr16IBOrsoTYUozvRQAX8/LMFXG0UzVObxqAfw45ouQ6z4eMynXybwsSPdF0P0FaSNbyGpTfnQ20asvlbQaq2slG92CXqryeL9pkDjUxJFK6beuTUutt6VPmpXiMg7u9B8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720760180; c=relaxed/simple;
	bh=B7Dk29Ys0uQcPtsQxtewPZL/bi1hAo/5rBuwkbgeV3o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T7qFfoKmhdBWOUVglO7N90UBYxiGISaN8DYzhveSKcnNreYS3AtiWwphS3NUxQJDCzZALbCIALcTAZZbk/slMWQmQL6+9Xs+ZNa240TBRGcTVRXZdfcZ121P/h7OxFp6HiFE0usKC869QjvlcrQvKVGzWfX1UhZnoQ2zgxVGtx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6B68868BEB; Fri, 12 Jul 2024 06:56:15 +0200 (CEST)
Date: Fri, 12 Jul 2024 06:56:15 +0200
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	John Garry <john.g.garry@oracle.com>, chandan.babu@oracle.com,
	dchinner@redhat.com, hch@lst.de, viro@zeniv.linux.org.uk,
	brauner@kernel.org, jack@suse.cz, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	catherine.hoang@oracle.com, martin.petersen@oracle.com
Subject: Re: [PATCH v2 07/13] xfs: Introduce FORCEALIGN inode flag
Message-ID: <20240712045615.GA4833@lst.de>
References: <20240705162450.3481169-1-john.g.garry@oracle.com> <20240705162450.3481169-8-john.g.garry@oracle.com> <20240711025958.GJ612460@frogsfrogsfrogs> <ZpBouoiUpMgZtqMk@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZpBouoiUpMgZtqMk@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jul 12, 2024 at 09:20:26AM +1000, Dave Chinner wrote:
> I don't think we should error out the mount because reflink and
> forcealign are enabled - that's going to be the common configuration
> for every user of forcealign, right? I also don't think we should
> throw a corruption error if both flags are set, either.
> 
> We're making an initial *implementation choice* not to implement the
> two features on the same inode at the same time. We are not making a
> an on-disk format design decision that says "these two on-disk flags
> are incompatible".

Oh, right forcealign is per-inode.  In that case we just need to
ensure it never happens.  Which honestly might be a bit confusing if
you can reflink for some files and not others, but that's a separate
discussion.

