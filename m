Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51D2384247
	for <linux-xfs@vger.kernel.org>; Tue, 17 Mar 2026 20:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773778551; cv=none; b=G79Uf3x3qayl1SynYMjFifHWy849Ed2w0o6+Ja5u35RkXYLn7gpsPbHLUd5CONKJlU+ZZsTkatmpXTvQgaRVwbU0vYf1i97NxwOIPof9tfjO1olYEVUBxKy6KnsuHngnkK9thBRjvnQp+cJ355p3nOEO9B37EvA5Ub9wppTPx9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773778551; c=relaxed/simple;
	bh=0wd7vKOE0t6CMmgbfdwLj1fpOjVB1xI1gxIduHac10E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UhRdBB4nICLDw0qkmUfmw4CxZQFCF7uxhr0drlr+8Q9AdNJVR1hPxCzq2FquZ8EWvhBEWi34beruWP2JnFPzRpm+fx4t2upJV9oqWQj9zQqnwu/OQGeK9D/5amLjRRWB57fPogE1RdZDq3ZbOISPDZjJ7kOCoQD25HcY9xsWs5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=thXXMtqk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="thXXMtqk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D901C4CEF7;
	Tue, 17 Mar 2026 20:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773778551;
	bh=0wd7vKOE0t6CMmgbfdwLj1fpOjVB1xI1gxIduHac10E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=thXXMtqkHHE0/PjKMyZeRlQu+hdQO3ENhgR9XRlZYgvQafyPQZ4t6jl78rHusKCNy
	 jbM2GDHk4rjwGAxYC6Vb2czg+toRBJGKljXROeQCO4hWpA41anOfJ9+w/YkYlULD6N
	 UP9AixBjwn9ylBJXJpaace2PKzD6i2PnCu50bnY18hu/5PQkOtj9TCSLujIZY3WUdX
	 Ra9KTkjJ+zc7cQXeTk+mfZqrEzzsGtHMaHGpC9x41MW6vNPw8jB05lbEFen28ElVFt
	 CtBeN7z9S35iKNa0y8EgOZJYTMTAS/qB4SIFhrJ/aFUb5wnm1kpU8FhDqu/lE2t9eE
	 Ssd87eFInH2ag==
Date: Tue, 17 Mar 2026 13:15:50 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	xfs <linux-xfs@vger.kernel.org>, ravising@redhat.com,
	leo.lilong@huawei.com
Subject: Re: [PATCH] xfs_repair: don't fail on INCOMPLETE attrs in leaf blocks
Message-ID: <20260317201550.GI1770774@frogsfrogsfrogs>
References: <20260316225033.GP6069@frogsfrogsfrogs>
 <abkbbpJ9sI_SDhfP@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abkbbpJ9sI_SDhfP@infradead.org>

On Tue, Mar 17, 2026 at 02:14:22AM -0700, Christoph Hellwig wrote:
> On Mon, Mar 16, 2026 at 03:50:33PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > It's far too drastic to delete the entire attr fork because doing that
> > destroys things like security labels.  The kernel won't show incomplete
> > attrs so it's not a big deal.
> 
> This sounds a bit lax.  Incomplete attributes are very much expected
> given how the non-logged attr code works.  Maybe reword this a bit to
> not make it sound like we just ignore a problem?

Ok will do.

--D
