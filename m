Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973F53D6CC4
	for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2026 16:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788193343; cv=none; b=AcOKrMOL1wNpP88hS91JShPDdTZAC1+GAu9EBI0ogHFgxMUSv7Fg/SX2Am+8bI/dZ5YqS1JHxYdWC1e+tuFU4BZ09sUa74TsZXMcOXS08U0m2J7Ser2OIxjB0NFfTPt7UOQ+REDYas+scm1R0xELEDMRmjQRjqkW9u5cvnvR0qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788193343; c=relaxed/simple;
	bh=V8A8BqoPUhmuQoxCf+ahYXHem1rmwOEjCnWJBIvmAcg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HtPc95nOy5sq3fFwTIEvroB6PQeO7C9TQsS7KzKlwJR3RNAWGQltwfq5uAz8xNsgVOd5xXsQMbCl1BM0RdppMqqIrG+Ma725S8+PwHk2R6kYyXfzsqtPHXeed2baYOJASU0/SU5Po+TYhBOFshLcYTUWTJGmkhCBCLZUSzBTho8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aDMWT5m3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aDMWT5m3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ED3E1F000E9;
	Mon, 31 Aug 2026 16:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788193342;
	bh=ZTq00v/k3RtojgLyyNovDrREjIrhqawB+y5cstjlbSY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aDMWT5m3MvEqBYF1EpJQe3Tm9qgYjy/fIrajhRtqDC6R+ESKZNyRLc3CWWPKnujIo
	 CVwl0RrU27Vg5eDjyxxaJ3vRoQTPupSSTyM86viV9NPRIkJlLjC4Gjhh59cgwvURNv
	 kHLrF/2U7aEob16V+aC62ZUclPUlab5BiCG5ZNNvo4bNzvE0cHSMbDZN+yVi2dJOFN
	 Ar8gdMmLS8pKBT+Dw05suH/6h6mkKer4bDv0YGdbOzuU7vHoyK6CE4/wMt7utN98lD
	 9W7lIjRlgo7HotrjaRjaa+o2t2b5KDv0vBTif+BS5jH5lAo7TJOzB9k6KS1AIvL4AC
	 WubvpOjxDGQBA==
Date: Mon, 31 Aug 2026 18:22:18 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [GIT PULL] XFS: Fixes for v7.3-rc2
Message-ID: <apWpubzAg8F4j8Xb@andromeda.toxiclabs.cc>
References: <apUSmA9aI8wpLyXf@andromeda.toxiclabs.cc>
 <CAHk-=wh+Rxk7kuzGMX5UzkwROsCsCuk-ZvGGnRCiU0T3fecsMQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wh+Rxk7kuzGMX5UzkwROsCsCuk-ZvGGnRCiU0T3fecsMQ@mail.gmail.com>

On Mon, Aug 31, 2026 at 08:52:50AM -0700, Linus Torvalds wrote:
> On Sun, 30 Aug 2026 at 22:53, Carlos Maiolino <cem@kernel.org> wrote:
> >
> > This contains a set of fixes for rc-2. I just want to highlight from
> > this series that it contains a couple patches for capabilities subsystem
> > and another for the quota subsystem. All three patches have been acked
> > by the respective maintainers and they agreed for these patches to go
> > through xfs tree as they are dependencies for a xfs bugfix.
> 
> I would really like *some* information about what the actual fixes are.

Fair enough.

> 
> As it is, I made some sh*t up myself. The end result could be better.
> Much better.

I'll update this PR then. I'm assuming (and checked current TOT) you didn't pull
it, so I'll send you a V2 in a few.

Carlos

> 
>             Linus
