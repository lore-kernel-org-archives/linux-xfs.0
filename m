Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B898631AAAF;
	Fri, 20 Feb 2026 14:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771596430; cv=none; b=KGyDqHBx04YZOYclCqbF4F+dp5m29rR8p1tHyXs3EXByGvp697pyzWlfxy9cIHrbOqqv35yVaXcwrNJVZ2jXnxVUO9zvKp/ghzWMHy3ayQHD5l4NstWqBU5NHvipUyZtHAf2jvIubNalDInEzDW0BIkJ5ddtJN3Zesj8DVAU3Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771596430; c=relaxed/simple;
	bh=ojuKm6Au6ZZIwCgEbQ0zHOLqQKNYsYgnNu5Vq2ujkFc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WFWkIZRdw1OOEb6nYrGlpQQb60qvudbXSRLgTzNmh99Bon070TiPAjsqpkpqacnE2tg4KUwYURfZBTO0eZSyId4AyGfMq1Uj9gk2AQngPtP8OP9ZuKsHeHPLmtdjNO55ecOjWxfdkYUf6J2C4ndk+qNT9XQDl+Ynf29afQ56kv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eEZjtLZS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eEZjtLZS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2534CC116C6;
	Fri, 20 Feb 2026 14:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771596430;
	bh=ojuKm6Au6ZZIwCgEbQ0zHOLqQKNYsYgnNu5Vq2ujkFc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eEZjtLZSlEF5cWpjd8E4/r/J6LihihShAdDJrP1Bwm+uAVzYCvFLJ6aO1v5l0DDH/
	 BQGKAH3EFZYIX2kkUN7W9kAoG5kn2gbDMKDkMIiC++Ri+lAFucVRt+pPF0PfqWG4CX
	 IpGXfhbyuANume1AEn76pn5xccAZSvUPd0VCBEaETNnvp5/P+V6VQjzDY7REP+MCtB
	 drWH7U0Ax7Oq204Gu6afN2fyq9a52eqjkvTqdcTEE1rUikxRDMFypE1HEYJCSi1LYS
	 bsu3DqFLpS46OAfMYWmly/pWEq/fVawVHsjOoXDu8xv7wk1L/5/oOmJ1+6FEw1dD7w
	 M5ZFD+ntqN4QA==
Date: Fri, 20 Feb 2026 09:07:06 -0500
From: Konstantin Ryabitsev <mricon@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Nirjhar Roy (IBM)" <nirjhar@linux.ibm.com>, djwong@kernel.org, 
	hch@infradead.org, david@fromorbit.com, zlang@kernel.org, linux-xfs@vger.kernel.org, 
	fstests@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com, 
	nirjhar.roy.lists@gmail.com, hsiangkao@linux.alibaba.com
Subject: Re: [PATCH v1 0/7] Add multi rtgroup grow and shrink tests
Message-ID: <20260220-perky-stork-of-glee-e8e4f9@lemur>
References: <20260219055737.769860-1-nirjhar@linux.ibm.com>
 <cover.1771425357.git.nirjhar.roy.lists@gmail.com>
 <aZcIEd9DY_bQGJ9L@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aZcIEd9DY_bQGJ9L@nidhogg.toxiclabs.cc>

On Thu, Feb 19, 2026 at 01:55:51PM +0100, Carlos Maiolino wrote:
> > This series adds several tests to validate the XFS realtime fs growth and
> > shrink functionality.
> > It begins with the introduction of some preconditions and helper
> > functions, then some tests that validate realtime group growth, followed
> > by realtime group shrink/removal tests and ends with a test that
> > validates both growth and shrink functionality together.
> > Individual patches have the details.
> 
> Please don't send new versions in reply to the old one, it just make
> hard to pull patches from the list. b4 usually doesn't handle it
> gracefully.

I'd like to hear more of this or see some examples. The workflow of replying
as follow-ups is adopted in many other projects (e.g. git) and they haven't
reported any difficulties. The only time I'm aware of complications is when
follow-up series are not properly versioned.

Regards,
-- 
KR
