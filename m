Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BAAF4D90A6;
	Tue, 14 Jul 2026 16:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784047331; cv=none; b=QiNL/c6fDsDFPoPYjgWClGDOut7crq6ntP137PO+FhQ4Kh4P9Lf/Xs7pVI5G+aGuTKIfPYxcStXOzVkXbN2grg4o62SCvyIM3mT/qzyMbU5U0tDdshOXF2MggO3c979p+TEMbfuhVvWHbEbzwuDMRAQFmdzjIBz3d3atJk/VQ4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784047331; c=relaxed/simple;
	bh=IVZqqqbKk3Pvs7pPmAHOufutOPK/M9DAVp2gqk9ibac=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tHESFaGKi3vrgQDe0rC3OtxohtylufHaXpIJrGUqmvk82JKURactl7mQ92HWwP7lDDLomj5pvq2kbVNJGoLZSKbl0uc6Oq6mEHhRzzMbfSWsOvFCvF/8LzBSnsuY/D0iHDHPGVi8zNeIXGWk1CjuuUJ6EgAu1qZHg6eG/4UFqXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z9UaWKmX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z9UaWKmX"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 91E3D1F000E9;
	Tue, 14 Jul 2026 16:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784047329;
	bh=7fK8AmZdS3XkyteViA4pHtIvyKygfQDkI+Fj0vrrJXI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Z9UaWKmXiYj6t5ehRiVCvD2lUuesMoriCvADbxDZX63HQtTakZp8PfaA5cTOrj675
	 Y1V9FlJDXUxZS+A8hZKlKL+6g0J/YVSGtxIaMIkgRtSowv00FfMcnLirOBVwm9uuuj
	 dB/3F3dKat24yOPabiQ2xpDy1VqfnySXptVFpaMvGHJ7288osw7sH9JyHJg8e904iY
	 LV/0VNYSaiznBUPsP1gdilp2IfXYw+1EQLTuAPI+x/sV0Ex/Ex1JFc5aDUdO4yzLlN
	 7RUqtcbiytbir9OalU2R5pjaSVrvgtGdfU4zKthY5Inm+JSWR9Jn07HvxHcAANbr1f
	 LgfCQQJO7fmuQ==
Date: Tue, 14 Jul 2026 09:42:09 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: set xfarray killable sort correctly
Message-ID: <20260714164209.GF7398@frogsfrogsfrogs>
References: <178400716782.268162.4846177784022689546.stgit@frogsfrogsfrogs>
 <178400716837.268162.4871292933498780753.stgit@frogsfrogsfrogs>
 <20260714061134.GB1072@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260714061134.GB1072@lst.de>

On Tue, Jul 14, 2026 at 08:11:34AM +0200, Christoph Hellwig wrote:
> On Mon, Jul 13, 2026 at 11:06:12PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > LOLLM noticed that we *disable* interruptible sorts when the KILLABLE
> > flag is set.  This is backwards.  Fix the incorrect logic, and rename
> > the variable to make the connection more obvious.
> 
> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Can we come up with a test that actually kills a sort somewhat reliably?

Userspace doesn't have good visibility into when a sort is running, and
I don't think we want to add XFS_TEST_ERROR() chunks where we inject a
SIGKILL into current... however that might be done.

--D
