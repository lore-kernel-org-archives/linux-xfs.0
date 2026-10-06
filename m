Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A282547072
	for <linux-xfs@vger.kernel.org>; Tue,  6 Oct 2026 04:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791261798; cv=none; b=BLuzwgemq7W/0eBMh4n/QpbyRQDNU3wrdRXKwgfdr0HDswJeBzTesnH4nOcKWSi/eIKan+0+BloFqUNkkHbwWer1HFon9zr/veu+AidjTalVsjsFpUvK/N8DNgI77iUkGWhmcPmYR750/S6QJ/9JGYTRHDFD9gVsJ77BGTQimTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791261798; c=relaxed/simple;
	bh=Xryjd13tVmj3CYvhMJsW7472I4HwfA9y0b+qWzv/QtU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N0vkL/elFX0w2Bzeg1R1I8s6fvQyan9yfypY9xXuZRfV17Mp53CiVIkH/suq14ABFVBEkQCxpwG5H7vx/JdTG5L2/8X+CT9o9lSWwyxsphvwhGtGVnsWZI3s1WYkug3Uzj9S843W29agaoFUsg1EK7ZfwgN7ZfDHfw+bDG2lbVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q0uP0yJU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q0uP0yJU"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A5C7A1F000FF;
	Tue,  6 Oct 2026 04:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791261796;
	bh=+wIiNS44XBC/huUuGy+i9H58Gtah9p63F8HMkifHoB8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Q0uP0yJULkKh/3bUN8TbxEmBpQAnzFoX7cyJ/91yDT8qsc/De2TUasKG/W2rvgOgW
	 3WTA2Z0nUCJ23iuNr5sIAzFhvBO34NqAZmUz+6XoUzPBQPwwbPfdvN1OeKOmYHl+BH
	 3GhemXSdTicNJQAEW9uKA+FrEB25Yr0+0rKgZ+88pntUXexScg9hOqjmDycjTWFZxT
	 mMIC5URP9UWGY0mWa/K8lLrWotpDodwG+MKrcEoSrrjWSckNFtEntplXb54P7wbGV+
	 rTdc+B/Utw9OxmY1RjWvkqpdO9D82GF3bYLCxvc6hpKEjWMHaEAZSPfrmbZSaIxoFj
	 pNrcKIrzd9hIg==
Date: Mon, 5 Oct 2026 21:43:16 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: bugzilla-daemon@kernel.org, sachse@gmx.net
Cc: linux-xfs@vger.kernel.org
Subject: Re: [Bug 222081] xfs stops if link count is to high
Message-ID: <20261006044316.GT2705364@frogsfrogsfrogs>
References: <bug-222081-201763@https.bugzilla.kernel.org/>
 <bug-222081-201763-wszw4NAn6Q@https.bugzilla.kernel.org/>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-222081-201763-wszw4NAn6Q@https.bugzilla.kernel.org/>

Could you capture a metadump of the affected filesystem, please?

I couldn't reproduce it on upstream 7.3-rc6 and nobody's responsible for
QA'ing 6.18 so there's little to work from, I'm afraid.

--D

On Wed, Sep 30, 2026 at 08:24:33PM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=222081
> 
> --- Comment #4 from sachse@gmx.net ---
> Note: Creating the the filesystem with "parent=0" the crash not occurs.
> 
> -- 
> You may reply to this email to add a comment.
> 
> You are receiving this mail because:
> You are watching the assignee of the bug.
