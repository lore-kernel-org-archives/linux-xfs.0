Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D1BF9D9
	for <linux-xfs@vger.kernel.org>; Mon, 28 Apr 2025 13:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745845496; cv=none; b=VVJTKfO95uZOR7VzdWYamy+RSVnvHJlGa6170EPEnG2T9FdcGwy8MAtJKIuUMbpIRjGR5/C8rAohfuvqnyb/9q2eHYoSKl7QPyt/QJ3SN8Rnyi42TdXhtvqtLGg8uXXEVq4LVisLlJOncgrW0Fh82QgbCLuvdBcjefpt3E4IAeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745845496; c=relaxed/simple;
	bh=qC41jnW81sdk+Jd4cffCcY5MqkSAnsuN0r1SSlwX/WI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=smFOR5l8y3ftGaDDSl+qR8csrhkq1vrVg9ksWXv1fRdl0GjJtnV62ek0Hxv7BHoJjyA8NSs/tDzC65d8vNf43hGtZSacsI2yccVQhW9WwQqwNyxZUAZ6NWQ5+kIDcm9ZS2bFf7HjCO8Avpr3IqNqdUdnmNJuG+XLlLIPqXQQ7wQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 411B668C4E; Mon, 28 Apr 2025 15:04:50 +0200 (CEST)
Date: Mon, 28 Apr 2025 15:04:50 +0200
From: hch <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <Hans.Holmberg@wdc.com>,
	Dave Chinner <david@fromorbit.com>,
	"Darrick J . Wong" <djwong@kernel.org>, hch <hch@lst.de>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: allow ro mounts if rtdev or logdev are read-only
Message-ID: <20250428130450.GB29270@lst.de>
References: <M6FcYEJbADh29bAOdxfu6Qm-ktiyMPYZw39bsvsx-RJNJsTgTMpoahi2HA9UAqfEH9ueyBk3Kry5vydrxmxWrA==@protonmail.internalid> <20250425085217.9189-1-hans.holmberg@wdc.com> <iboil7qz4s76y53wlwvpnu2diypdv5bdryoqwhlh4duat5dtj2@lkptlw2z3pdq> <C4tcpc9KgtT1pkGmrFcEWdwZcHpOiA2vViIipXnQqeVEHXsRPRXdmhAyyFhgljCydyMMbHO_qeL3wgFD3FVEng==@protonmail.internalid> <8d4aa088-e59e-46bc-bc75-60eff2d49f4a@wdc.com> <rld7gaksnhm5r2dn65v2cxct3wtqvokbhxnw2zh6betey4jblc@6dvgavf47zle>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <rld7gaksnhm5r2dn65v2cxct3wtqvokbhxnw2zh6betey4jblc@6dvgavf47zle>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Apr 28, 2025 at 02:54:59PM +0200, Carlos Maiolino wrote:
> > BLK_OPEN_RESTRICT_WRITES disallows other writers to mounted devs, and I
> > presume we want this for read-only mounts as well?
> 
> Thanks, it wasn't really clear to me what the purpose of RESTRICT_WRITES was,
> thanks for the clarification, this looks good to me:

It also mastches what most other file systems are doing by using the
sb_open_mode helper.  Thinking about tht we should probably use it as
well as the superblock is available in mp->m_super here.

