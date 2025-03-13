Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7597C13AA3E;
	Thu, 13 Mar 2025 07:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741850895; cv=none; b=cCK5Sg4eZKg3ybPeeG6nZXnYyOOP2t82ShM+5rAg0iEPzjhRx2pbepFaOX+xHatmFe5qjqZ6eDDN1upziezF+CiujqIOoTsViqdLxThDn0Ql5u9977TpX6hdwjWGvHpu8n+u9clgLWq7yT0CsED8G2+jdX5zc6/x7JbbNNKltH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741850895; c=relaxed/simple;
	bh=T4w2GJKg4XoXRgXSNbAIs6E4ejsacW6g0U/fTK0Dg8Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SYgwy0sjeKS3FlcJtsSiuyz2U6xIOp+iBSao4w0PtQyYS1TYolgXIG1OVNdMHOQCHuIXo0cd5cIC3ZdTDKXWSL6hF2mLbWiBFCD5kK00JUjRLANB+Em4TCQ8HyAampOzvzVZgN+mzeLWYfzJY9X7nrTZ0vz2ckIOtTNU0o91Ae8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B0DBB68C4E; Thu, 13 Mar 2025 08:28:09 +0100 (CET)
Date: Thu, 13 Mar 2025 08:28:09 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/17] xfs: handle zoned file systems in
 _scratch_xfs_force_no_metadir
Message-ID: <20250313072809.GE11310@lst.de>
References: <20250312064541.664334-1-hch@lst.de> <20250312064541.664334-12-hch@lst.de> <20250312202314.GL2803749@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250312202314.GL2803749@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Mar 12, 2025 at 01:23:14PM -0700, Darrick J. Wong wrote:
> >  	for opt in uquota gquota pquota; do
> > @@ -2074,6 +2080,11 @@ _scratch_xfs_force_no_metadir()
> >  	if grep -q 'metadir=' $MKFS_XFS_PROG; then
> >  		MKFS_OPTIONS="-m metadir=0 $MKFS_OPTIONS"
> >  	fi
> > +
> > +	# zoned requires metadir
> > +	if grep -q 'zoned=' $MKFS_XFS_PROG; then
> > +		MKFS_OPTIONS="-m zoned=0 $MKFS_OPTIONS"
> 
> I think this cause mkfs to fail due to the respecification of -mzoned
> if MKFS_OPTIONS originally had -mzoned= in it?

Hmm, don't we allow respecification to override earlier settings?
Let me double check the _scratch_xfs_force_no_metadir tests on
zoned on conventional runs.

