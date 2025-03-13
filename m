Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 917F81DD9AB;
	Thu, 13 Mar 2025 17:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741886297; cv=none; b=Gb9dVXstHZvfuOfKxNSuD0BSZhaCDe8ZJJYps7HydlU5gfnquAYPB5woeTO2k5SGNejw/0+4yUJWs4yYbSQvQsVi/dGQqlSSDb6qZ6kVVZVIkRoQ2Qiys1kj38d9ZKSykEOvJ5xfGaYrqxxigIST5XPaTUq3XgJ/rKbMDIXaUhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741886297; c=relaxed/simple;
	bh=qIYBeXu2WsPtnRs1XkOXfO3XvTmpf4+K20dFy5llNBQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OMG7kKLQDyE9h0hbjQa7uVbwyI/crMFR0h44j9g7nqE4cZUIeHNPPi2f5bYaoOQtgH4O2avFxfXLV8i63B42wrc49X/k4wqOasM26fBcyGXon4u3i2JhaHhc62ZNwOcK1CWUWId9ltARYeP6aaMxJob00KYRj0wdr1KWZ+8up8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nQx1tGrR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nQx1tGrR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB43BC4CEDD;
	Thu, 13 Mar 2025 17:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741886297;
	bh=qIYBeXu2WsPtnRs1XkOXfO3XvTmpf4+K20dFy5llNBQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nQx1tGrRo+k6+WmG7KG++zftC5JNE4LpsvImJD+ZExnJtif6OuMr38hYGFpz6rqHa
	 16nZ517dLU6vsvg/+VgLcA7AwzhpRWk9WG2rXV3ayK8HVFrKHreI0P5o9vUXCJX1Zo
	 achVzZbRI7TaWzVbVwqEYIzLKwlBjeHAVJO9sNITVc9PZxDHObQmImf+pNuyNpWSLB
	 kkGCmpexRyaIwoc3P+grodk85A5n3rK3GWi0evkAP1fEWrcy9/DUb5jKk0GrhdKvHS
	 wqvSr6z2Q5cE82VjgJ4vv7l574WFDG65LoohI2o03fBU30BLEaCdz10RVSHHykcSeC
	 05UOk4W3YaiXA==
Date: Thu, 13 Mar 2025 10:18:16 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/17] xfs: handle zoned file systems in
 _scratch_xfs_force_no_metadir
Message-ID: <20250313171816.GV2803749@frogsfrogsfrogs>
References: <20250312064541.664334-1-hch@lst.de>
 <20250312064541.664334-12-hch@lst.de>
 <20250312202314.GL2803749@frogsfrogsfrogs>
 <20250313072809.GE11310@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250313072809.GE11310@lst.de>

On Thu, Mar 13, 2025 at 08:28:09AM +0100, Christoph Hellwig wrote:
> On Wed, Mar 12, 2025 at 01:23:14PM -0700, Darrick J. Wong wrote:
> > >  	for opt in uquota gquota pquota; do
> > > @@ -2074,6 +2080,11 @@ _scratch_xfs_force_no_metadir()
> > >  	if grep -q 'metadir=' $MKFS_XFS_PROG; then
> > >  		MKFS_OPTIONS="-m metadir=0 $MKFS_OPTIONS"
> > >  	fi
> > > +
> > > +	# zoned requires metadir
> > > +	if grep -q 'zoned=' $MKFS_XFS_PROG; then
> > > +		MKFS_OPTIONS="-m zoned=0 $MKFS_OPTIONS"
> > 
> > I think this cause mkfs to fail due to the respecification of -mzoned
> > if MKFS_OPTIONS originally had -mzoned= in it?
> 
> Hmm, don't we allow respecification to override earlier settings?

Nope:

$ mkfs.xfs -f -m rmapbt=0 -m rmapbt=1 /tmp/a
-m rmapbt option respecified
<snip>

You can't even override the options specified in a config file:

$ mkfs.xfs -f -c options=/usr/share/xfsprogs/mkfs/lts_5.4.conf -m rmapbt=1 /tmp/a
-m rmapbt option respecified

> Let me double check the _scratch_xfs_force_no_metadir tests on
> zoned on conventional runs.

--D
