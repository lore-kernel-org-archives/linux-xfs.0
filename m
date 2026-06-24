Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D4D34846A
	for <linux-xfs@vger.kernel.org>; Wed, 24 Jun 2026 17:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782322669; cv=none; b=uhT1uL04o1SEHSXSqw4EGYweeQxRTX0uyZiBfitwFtzNN47ktwUHR/h6oSIvi4k2r2yzVyNrGA+Xd3ZsswEBgYQ6/OP8nxXL5Xxn0mb4CwxntRKq5lQXBYGsms8FveBeng+NYnCD8gCY/Ou7+rJ5ERLg3Dg0wUSsHELG9D0iUfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782322669; c=relaxed/simple;
	bh=bRg4f64vWPbpNNX2XTTwDIL87qNLgOqGaUg1q0cgi3s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cpUX/e9DZoa+WB3Bk3nmmwpnQbH1w4FcHy/aDY3E6OhdLpvXmAuf7ouxrVxxW9kTvR82akbbl8k4Eathrm+TVAOiFtnNtPb9vvz7FtJ3pBUTpwzbjePcJtmAaT4xIP4kuI9RZTvJi95Iv9u/tqCZTvfQoe965IL6G7zENvnkpwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VIdQmgN1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VIdQmgN1"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C25E31F000E9;
	Wed, 24 Jun 2026 17:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782322667;
	bh=usgLuTqSyhVIg5XAZp8L4pIVhvFfvdphFCJh13WQDJY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VIdQmgN1/6PTuFl/OT4M9q1UlXA/2nS5SePbkF7ttEcKh/A046IacC3lrKOK0l97H
	 puWZK9tDtc2bOKeUP+E5FGP4/0XRKmHwPMoFhf8mjVZhDzDqswKMm9Ia8XZoruO9hE
	 T1YQg+QwGUsnk5lztgH5YUldcoeAjsVI5tX3sfFQ2gDIHwVsldSw0OQ2r8L7PGrfct
	 R3H36ymPsqrP44d/LF7O5HFYtzrzgAVsYUI4bFoOlJs/GXHrObCQxl4W2a150tI1xS
	 GIpaUpPSHBC/qWRBKRvy/mCGzCcr9eqoNUQuei0Ikz6AZLCx4HI7xMNMzIRZexohRA
	 oKbjrRKugAgvw==
Date: Wed, 24 Jun 2026 10:37:47 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: caina <caina@uniontech.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: clean up spelling and grammar errors in comments
Message-ID: <20260624173747.GR6078@frogsfrogsfrogs>
References: <20260616020912.11409-1-caina@uniontech.com>
 <20260617055052.7271-1-caina@uniontech.com>
 <ajve0YCxD_u62phh@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajve0YCxD_u62phh@infradead.org>

On Wed, Jun 24, 2026 at 06:42:41AM -0700, Christoph Hellwig wrote:
> On Wed, Jun 17, 2026 at 01:50:52PM +0800, caina wrote:
> >  /*
> >   * Set up an in-memory buffer cache so that we can use the xfbtree.  Allocating
> > - * a shmem file might take loks, so we cannot be in transaction context.  Park
> > + * a shmem file might take looks, so we cannot be in transaction context.  Park
> 
> I think this should be locks, not looks.

Yes.

The rest of the changes (aside from the "do so so that..." change) look
ok to me.

--D
