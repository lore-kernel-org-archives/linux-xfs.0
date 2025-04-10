Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A14EF1CA84
	for <linux-xfs@vger.kernel.org>; Thu, 10 Apr 2025 06:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744267597; cv=none; b=OrggHO4E9D6mjJQ9pWSuWEM+YEsVMVrS+HVTVh7IhBnXhh30Rmvxv14+xIP99tM2uJW01uF4Ho70eMCxX8vuDk8YnPmSZmF7inOuI1OmaLTIiYQvCFN5cqKEnJv1kp17xFO/LSaaM5R+6OXQFF3chRkJouyKqb1rMfBfGDVXq1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744267597; c=relaxed/simple;
	bh=Z1lK2DK0STEOknxzqnb7C1FnyGaDhKqBpavZyCoQiwo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YUZlaPPtJWkh2DPpy/XsBSY11Vp3CdDFkfr/4qG1/0DXc7UpZ/WidPMGD9Y64apbIBsAdU9H1sLZBT9bnxdX8SDdG2aBPKNhP+58pe41bZ9JbhvWZqHEcVO+gMp0UZds3RREYX8dzP6vdKm0O8ySXloLVP8GXmDFzYU+KVggbT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D3CFB68BFE; Thu, 10 Apr 2025 08:46:31 +0200 (CEST)
Date: Thu, 10 Apr 2025 08:46:31 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 33/45] xfs_mkfs: reflink conflicts with zoned file
 systems for now
Message-ID: <20250410064631.GG31075@lst.de>
References: <20250409075557.3535745-1-hch@lst.de> <20250409075557.3535745-34-hch@lst.de> <20250409190000.GH6283@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250409190000.GH6283@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Apr 09, 2025 at 12:00:00PM -0700, Darrick J. Wong wrote:
> On Wed, Apr 09, 2025 at 09:55:36AM +0200, Christoph Hellwig wrote:
> > Until GC is enhanced to not unshared reflinked blocks we better prohibit
> > this combination.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> ...or gc figures out how to do reflinked moves.  Either way,

That's what I mean with not unsharing.  I can adjust the wording
if mine was too confusing, though.

