Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FFEC446BA
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 05:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711432261; cv=none; b=soGU1fTbJDgpoujbSLwBlVvRVXWwv+xkW9nErQmWJMbePQCfiFcTUcQL3G7YMfOH5ZZow4XINcmGmmRDQ6YlFPGnUi+2CsO0Hwzgtp9c1SrwEks/PbJGwDIo1ofFbGjZbquKXq/kR7X5Si0uR2whztI/Fq6SgFBTsymY34fCtOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711432261; c=relaxed/simple;
	bh=KMP188u2x4203nk19H7e64ZFFse6FMhREC1EOpelTjg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lGXc44icSCK0T5blhAlKMkeSMxKhoPPDQnUBrxg6XfNWTJG08zblY6iugA0WaoNcAVSKKNWEMsqPdPbAND4prAEOp09mCAonXSsaLPdWRkdpk4KUwWU6qDLgeUM42P782kIthq/7ZJWMjpxfSqwmdd4EqBbZ8cl+oPeRWfE/iio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C8CDB68D37; Tue, 26 Mar 2024 06:50:47 +0100 (CET)
Date: Tue, 26 Mar 2024 06:50:47 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, chandan.babu@oracle.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: compile out v4 support if disabled
Message-ID: <20240326055047.GA6808@lst.de>
References: <20240325031318.2052017-1-hch@lst.de> <20240326000237.GG6414@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240326000237.GG6414@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Mar 25, 2024 at 05:02:37PM -0700, Darrick J. Wong wrote:
> > +/*
> > + * Some features are always on for v5 file systems, allow the compiler to
> > + * eliminiate dead code when building without v4 support.
> > + */
> > +#define __XFS_HAS_V4_FEAT(name, NAME) \
> 
> Shouldn't this be called __XFS_HAS_V5_FEAT?

They are features for v4 and unconditional for v5.  Given that Dave
came up with the same names independently they can't be all bad,
although I don't really care very strongly.

