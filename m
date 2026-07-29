Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD9A645516A
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 15:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785338952; cv=none; b=qaDmdkQcz2aaG7wxc5dmepH5L4mjtyOjutCi4mZ5NoMQdpbmdkP5uwcUHyLUOVFgs+32RbzVkb068dF4mg3CmIZO8VIrrS7a1IaWHz0PMO2r87yF/1HfuVe36rJ7iHYmHQF8/dQyQxgeo7nNJc+r5WrT8hCiMEIEFC46wJn2NdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785338952; c=relaxed/simple;
	bh=CKQoo/Kg0/RHOCTC405W7mI5pA5PMHg05gVsE+WIBh4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lfhka/fRs6tEc3MhiphMwpEqA5lmZYs9dBfvAeCnMqf+XtG6+776wkz0/GROIVPEwLiFaW3cqGHJxBBtxNuXmmB4mOIlKUcNUVlOQK5C2vdTZt3KPM1R/mhtqBoSp1lfsS88SdeaPvzxNr8ceSyBzVqxT0A+AX/GFA0oFSeFSzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IA++6p0L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IA++6p0L"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 52A921F000E9;
	Wed, 29 Jul 2026 15:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785338951;
	bh=/RVTN3tfBw5nKUanRlfJKNLfxb4fSNagIi9zR795LKk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IA++6p0LFRzzY/MSkGi9bxoj9gTyqjFrn/20Nkc40efFNz17EG71yBkA+A2O3t6YI
	 SzeP/Uzh19zriP66u8NOVNQwIcm7rZ8EMnbTALO82XqLIoP421vsNzTBx816wp3y/F
	 aNvk0ygBXmIgirGQFcL/QsLZew4th6udt1OYrzXrg8JCf2irX763CU6e7rKg17NjgT
	 Uo5p4GaCrZmv3SiE5Z45uVrop5nnljcFMIg8tHsL1iiMtyh/05pWaQu+VD8Il0t6xJ
	 w5+j/FEOAckJVZhbH1C4tTtOZ8ZsGdgQz6QOoHMzV4f9QXfGjMAuT2KkYVxZsIEJyx
	 Ih9mu0CuFqc/Q==
Date: Wed, 29 Jul 2026 08:29:11 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: xfs ioctl handler cleanups
Message-ID: <20260729152911.GV2901224@frogsfrogsfrogs>
References: <20260729130320.2282183-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260729130320.2282183-1-hch@lst.de>

On Wed, Jul 29, 2026 at 03:02:59PM +0200, Christoph Hellwig wrote:
> Hi all,
> 
> I've been annoyed at the KASAN stack usage warnings in xfs_file_ioctl
> again recently, so let's sort this out properly by splitting each
> ioctl handler into a separate, well-named helper.  We already do that
> for most, but this series completes it.

The whole series looks fine to me:
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

