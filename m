Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0752288D0;
	Tue, 28 Jul 2026 04:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785214729; cv=none; b=nRIwyMR2XPurj3hpwDop8n9oDB8KdMASMa88HIKdPiRPN7KUffg5EPAQJps+lbnU+DgUdxnCu/mx60q20I9uiaPaqaZsZDvUfK1az6j7T998L0wmWsm9ON23I+/kPPz77Ch0Cpbkz+qIctIIWeePeLPj06OJRZ//OdvOjb2fZSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785214729; c=relaxed/simple;
	bh=mSbxho7dP23TDmwwubKDn/07RTm4idGjHa504gXo188=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r8hitQvjlHKVyT3prsOjYG8hV4DPUhEINWgZBtuiAa0HV0L1igpNepSNj6nmXYOB2drfzqSL0PF4vCdUqmXGKTHyJVQWYLLdu+4IRrWXlBU/LD176hcNTZKImMSPhxywsqQOOYtO7PGPuUBTRmFvdzzASE9729eDa/ze5iKbdp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id F273368AFE; Tue, 28 Jul 2026 06:58:44 +0200 (CEST)
Date: Tue, 28 Jul 2026 06:58:44 +0200
From: Christoph Hellwig <hch@lst.de>
To: Anuj Gupta/Anuj Gupta <anuj20.g@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Tal Zussman <tz2294@columbia.edu>,
	linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 20/22] xfs: add support for lazy direct read bounce
 buffering
Message-ID: <20260728045844.GA20331@lst.de>
References: <20260723145000.116419-1-hch@lst.de> <CGME20260723145144epcas5p4c78e8b6d81ed76935bff66479dff874e@epcas5p4.samsung.com> <20260723145000.116419-21-hch@lst.de> <65cd47a4-eef5-43c5-a336-0a5693e5e4f1@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65cd47a4-eef5-43c5-a336-0a5693e5e4f1@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jul 27, 2026 at 07:44:32PM +0530, Anuj Gupta/Anuj Gupta wrote:
> On 7/23/2026 8:19 PM, Christoph Hellwig wrote:
> > +static ssize_t
> > +read_bounce_store(
> > +	struct kobject	*kobj,
> > +	const char	*buf,
> > +	size_t		count)
> > +{
> > +	struct xfs_mount	*mp = csum_to_mp(kobj);
> > +
> > +	if (!strcmp(buf, "never"))
> > +		WRITE_ONCE(mp->m_read_bounce, XFS_READ_BOUNCE_NEVER);
> > +	else if (!strcmp(buf, "always"))
> > +		WRITE_ONCE(mp->m_read_bounce, XFS_READ_BOUNCE_ALWAYS);
> > +	else if (!strcmp(buf, "lazy"))
> > +		WRITE_ONCE(mp->m_read_bounce, XFS_READ_BOUNCE_LAZY);
> it returns a -EINVAL always.
> 
> # echo always > /sys/fs/xfs/nvme0n1/csum/read_bounce
> bash: echo: write error: Invalid argument

Use echo -n.

> 
> Maybe use sysfs_streq here?

I've already switched this to table matching in the current version.
