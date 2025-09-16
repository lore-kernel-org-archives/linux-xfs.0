Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 878692FFF91
	for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 16:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758041206; cv=none; b=WrFlTRmyM5HO+TjM3/qauDn/2UvlThUP1Nr6OhHDQUD1Kd+jgBe67R8oyhxQwUNsxmqRaqvvKIhHInMn9/KRYSYYOYqu3yO0k5E6yE4Tj/AXYoBCUWcHFpdvbVTyaQmaZCuat1zgXStCASWauQsDpp8xXYjgaBBT2ISt3qpQyUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758041206; c=relaxed/simple;
	bh=y2BLx8hO/Eh2CLZ0cMUTIsyIeSlfU8g/inQvjqaB/Lk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ii7hw0t+jricKgID6luri4hu9VLVUXhPtPNuC7AbzczNKH67KTyFEkkNhUwZpfRc57IFacxYREXOQQDrVeSLvNvgrHmv8p2dM6rhtlw2ENaXiZ/XNwvw5t8TOzJ3gy0FspidsrjS7VPZZNPwAXW4/MRs4Qsw1opsqv3YNYCXRBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lf5EtIor; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lf5EtIor"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22FC3C4CEEB;
	Tue, 16 Sep 2025 16:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758041206;
	bh=y2BLx8hO/Eh2CLZ0cMUTIsyIeSlfU8g/inQvjqaB/Lk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lf5EtIorVPp+3Oq6k8ohOzZ+cWd5gH/FmUCvEbQnUiJx174KCKwHHSJxZ7nO11SV2
	 +rWhF5HzAxYah6GpxHUcQuZANhqxdNa6CdgwqFkV8S/E4GgMybt37FCSERSVQQF4PS
	 OAtlxq5vX/4v96UTtu38f1aRvoTJMFgY5HNnbA2YLqaqbs7MpZpTS0M03n+iADVTsj
	 WbBi0Vit6IFouuNBtTn6IhhOB24n47uK9ApHzamUc+T+GYbJzRgoNARnbmUBIsss/q
	 McA/4FSbgS0n1pfjQgDXiWzgnQEa5Mw2OaD/NHaAJZuDYJohRIkeJzLxHKa61ppQjd
	 b/dpLnA5uFpwQ==
Date: Tue, 16 Sep 2025 09:46:45 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: centralize error tag definitions
Message-ID: <20250916164645.GW8117@frogsfrogsfrogs>
References: <20250916162843.258959-1-hch@lst.de>
 <20250916162843.258959-6-hch@lst.de>
 <20250916163831.GG8096@frogsfrogsfrogs>
 <20250916164057.GA4208@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250916164057.GA4208@lst.de>

On Tue, Sep 16, 2025 at 06:40:57PM +0200, Christoph Hellwig wrote:
> On Tue, Sep 16, 2025 at 09:38:31AM -0700, Darrick J. Wong wrote:
> > > + * an XFS_ERRTAGS macro that expands to the XFS_ERRTAG macro supplied by the
> > > + * source files that includes this header use for each defined error
> > > + * injection knob.
> > 
> > Hmm, that last sentence could be more concise, and describe what is
> > passed to the XFS_ERRTAG macro:
> > 
> > "...will define an XFS_ERRTAGS macro that expands to invoke that
> > XFS_ERRTAG macro for each defined error injection knob.  The parameters
> > to the XFS_ERRTAG macro are:
> > 
> > 1. The XFS_ERRTAG_ flag but without the prefix;
> > 2. The name of the sysfs knob; and
> > 3. The default value for the knob."
> 
> That feels a bit too verbose for my taste, but if it helps I can change
> it.
> 
> > I wonder if XFS_ERRTAG() should be supplied with the full XFS_ERRTAG_FOO
> > name, not just FOO?
> 
> I did this initially, but it means very long lines that make the table
> rather hard to read.  So while I'm not a huge fan of magic symbol
> shortening I think it's fine here because the places that need to know
> about it are very confined.

Eh, you're right, there aren't that many places that are going to use
XFS_ERRTAGS.  Want to just make the last sentence of the comment read:

"...will define an XFS_ERRTAGS macro that expands to invoke that
XFS_ERRTAG macro for each defined error injection knob."

and then attach
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

