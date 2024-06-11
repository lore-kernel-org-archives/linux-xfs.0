Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4076C140E30
	for <linux-xfs@vger.kernel.org>; Tue, 11 Jun 2024 04:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718081435; cv=none; b=rRCJHVLtugzKX5JQRYTJH+3pjyKDDVMaIsz8h1vlQ92KUftG01VN/tZP2LuqjOUO2GHYcRTz+5RkEezDJGwgEU08HzfZ5ChJFfjmxl+mXFwapUeWmZyhw6gPsi2AouCmDgJDXv1/4eM+V3bkKfptIGfdbXD5BOidGLaIrf5lILk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718081435; c=relaxed/simple;
	bh=w3J7ftvzHIAIjswG7XFcbeRAdUE2qxbRxZ5o4snt8HY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TathOsJeeyb9mPONJEoSTRDnTY0poX3gJJO2F/kyJkuqfTJ2ex3eaRoXoXK0qvpWxDUMK+G9iGO7YTpLz4rk6tBmmlVPYNH1sJMa+dXqO6Ot+aoVUrwW9T+3niGxFMay+aUeIzgZVxHZ0B3iT38Mp3NbEYhICmheH6j5UEEK3L0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KRKrCGar; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KRKrCGar"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=yDhuPjAZ/8pkZLzks/NlSrLJKIPPUVemNdXiYTswsWI=; b=KRKrCGardHEU7QubCWbPxIKMYv
	8NtfkD0zTa6UBmTTCzopow5ht8uLH/TQ9EBnWJeJCrZ7mJKP26rlcp+jmw8CtIxs2oXR/Q6wc2evZ
	SMBZBgDQjRlHEfAPpBmGs6sJq6qVOoKLvmL0rjbG11V8oMXzYNmNqfv/ZoCrjQmRGnDhrfNMVQase
	hUHdfibG1v2v1YszKh5kP0EJyZ6VMxvfcxNzyQ6L6YIrH5km4gusGLPQYodYCpBmTyMfD7iI41doj
	5IZ6uh0sRjCDPjravKCPbka4W1qj9ovEjGFmiNdP7O+bEwhEEq837UbQyKFHi0JRaL+AFO3mUk9Sf
	+slfY7oA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sGtSr-00000007NyI-3BXN;
	Tue, 11 Jun 2024 04:50:33 +0000
Date: Mon, 10 Jun 2024 21:50:33 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: allow unlinked symlinks and dirs with zero size
Message-ID: <ZmfXmebrxnQy3OWI@infradead.org>
References: <20240607161217.GR52987@frogsfrogsfrogs>
 <ZmVMn3Gu-hP3AMEI@infradead.org>
 <20240610210723.GU52987@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240610210723.GU52987@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jun 10, 2024 at 02:07:23PM -0700, Darrick J. Wong wrote:
> It turns out that even this is still buggy because directories that are
> being inactivated (e.g. after repair has replaced the contents) can have
> zero isize.  Sooo I'll have a new patch in a day or two.

Isn't that what this patch checks for?  Or do you mean inactivated
with non-zero nlink?

Btw, it might make sense to add a helper or local variable to check
for an unlinked dinode instead of open coding the v1 check twice in
this function.
