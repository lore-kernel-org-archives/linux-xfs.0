Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5F9485CC3;
	Mon,  5 Oct 2026 13:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791206809; cv=none; b=e2w/+YcDNeiptUhGtqYxlAQo0UNbnfU+lJ13Qq+2y6sRagxqrsWbiLfc9UWjLBzyjFpxB8mokD2uLmlM3YRAyeX6uTcfRlLnBSkhVveFbpmE3ppq9qFUne6nN1Uye9TGZLI29OmZHGltG1EcUU26byiIIdp70c0ZmDzZ6HSe37Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791206809; c=relaxed/simple;
	bh=1x9Fi73OGf2eibIhiGieBxt7Jpx4P8xIS2WRQb9sd7Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h2b62UOVUR10tvAIff3ikCi8Mueku/aHnKnhC6pBGnyT/vdaqAESXKEi4Qq8F+Dzo4lwGrJT0EXl3QJHiQnkT9dUeSDF1fCpZX2sCiZqEswGUQfq0LBI19HKK9A1DkG757UbKMoAC1X8cz/oa3l9XyT1hkHEhDPvw2Sc5Cc/jQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E00DA68BFE; Mon,  5 Oct 2026 15:25:43 +0200 (CEST)
Date: Mon, 5 Oct 2026 15:25:43 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/13] xfs/2305: version of generic/475 that run
 xfs_scrub -x for each iteration
Message-ID: <20261005132543.GO26805@lst.de>
References: <20260924100855.2734089-1-hch@lst.de> <20260924100855.2734089-11-hch@lst.de> <20260929015729.GM2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260929015729.GM2705364@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Sep 28, 2026 at 06:57:29PM -0700, Darrick J. Wong wrote:
> On Thu, Sep 24, 2026 at 12:07:51PM +0200, Christoph Hellwig wrote:
> > To check both the metadata integrity and file system checksums after
> > log replay.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  tests/xfs/2305     | 75 ++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/2305.out |  2 ++
> >  2 files changed, 77 insertions(+)
> >  create mode 100755 tests/xfs/2305
> >  create mode 100644 tests/xfs/2305.out
> > 
> > diff --git a/tests/xfs/2305 b/tests/xfs/2305
> > new file mode 100755
> > index 000000000000..277f81c13887
> > --- /dev/null
> > +++ b/tests/xfs/2305
> > @@ -0,0 +1,75 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2017 Oracle, Inc.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 2305
> > +#
> > +# Copied from generic/475, with added xfs_scrub -x calls for each iteration to
> > +# verify the integrity of all file data and metadata.
> 
> Same questions that I had for xfs/2304. :D

Same answer / ramblings here :)

