Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F27E879C2
	for <linux-xfs@vger.kernel.org>; Tue, 11 Jun 2024 06:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718086046; cv=none; b=JqajOVrwkgelHBFkDH8in/yTenXtzHEOv91pkIqN/T62PJVyLtkJgBQeXdIqoQ4KtFC6z3xyaHwaoc7N7tiJlQck6HYvY/TJeAREfJBlsa7sUx7UFcZonrK4ZDtGUn2z6wRslEAAF9jMAnzO4brm4wpVce448GpLqBtO8m+BEUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718086046; c=relaxed/simple;
	bh=xpABPMdp/ipyX1U6DOB8tPbpOiXSXqJqR3xbZXZ7MhA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GiIo0nZwGjLPHgqzBdsoD7w7H1mcEJcFnagenT+ladqHOJLWpUaDV95chZAjZn+Iy2yx4a9ZRpiOyNMR6xpJGK2KYK9/qaKR4IsiePjXfnUdansoJmPEiEYIYsRd6zM0uGDFfH2h/k+Hp1Fx8G+s+2VrcBj5Ienj7vBHy6rfsLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ruIykhTO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ruIykhTO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51323C2BD10;
	Tue, 11 Jun 2024 06:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718086045;
	bh=xpABPMdp/ipyX1U6DOB8tPbpOiXSXqJqR3xbZXZ7MhA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ruIykhTObpeixz3gTDXVTykGxZ2cJwRteMq+quC2Hhycgxf2H6Qri1vuJVQzkE9OM
	 7R/XYAtENLP9gxTiobxFjLMKxH7zKxGbE5ooCWQowBkgpwaRf3zbS1GgqRQAqpZQjJ
	 M2fxw1Em1XyRJXtSwq2AR+JEKrfSRCH4XCieKAwMMRk/UNhVFMrrj6yKyh47EViY/T
	 1HM/EBDCF3xkd8BQxpGYaSdxihTYOavhXUqGW1OgYpAwD9wiVSuK4vbWXet6pcF3wd
	 6qhwE6yTRvwSXzNP/a+Ga6P+zJmMAewMpUkYSAfJWbAlMQjbaC9IyMFUXzjn6+ZNAb
	 YbzeDduY0W68Q==
Date: Mon, 10 Jun 2024 23:07:24 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Chandan Babu R <chandanbabu@kernel.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: allow unlinked symlinks and dirs with zero size
Message-ID: <20240611060724.GX52987@frogsfrogsfrogs>
References: <20240607161217.GR52987@frogsfrogsfrogs>
 <ZmVMn3Gu-hP3AMEI@infradead.org>
 <20240610210723.GU52987@frogsfrogsfrogs>
 <ZmfXmebrxnQy3OWI@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZmfXmebrxnQy3OWI@infradead.org>

On Mon, Jun 10, 2024 at 09:50:33PM -0700, Christoph Hellwig wrote:
> On Mon, Jun 10, 2024 at 02:07:23PM -0700, Darrick J. Wong wrote:
> > It turns out that even this is still buggy because directories that are
> > being inactivated (e.g. after repair has replaced the contents) can have
> > zero isize.  Sooo I'll have a new patch in a day or two.
> 
> Isn't that what this patch checks for?  Or do you mean inactivated
> with non-zero nlink?

Nah, there's another verifier check elsewhere that also trips when
di-size == 0.

> Btw, it might make sense to add a helper or local variable to check
> for an unlinked dinode instead of open coding the v1 check twice in
> this function.

Maybe?  But the logic is slightly different, isn't it?  I'll have a
look in the morning.

--D
