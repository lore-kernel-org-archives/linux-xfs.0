Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1048418D640;
	Fri, 18 Oct 2024 21:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729287565; cv=none; b=cJFkpkKQYvBEv5VMb3Sk2z1NfWe/x+yuLUEketFvTf45eO2zuJ8hlptd8GO1CRnxyL6bVPaH2tAcYFW/RAF/7/8jGJtYvGk9/MITOYP3aI7cduIHmhVptJU/Quw16z8O1J+KS8ui8mOI1y+M0IB+WOArRQzFdNwlRM6NLa5pIGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729287565; c=relaxed/simple;
	bh=Q71K8evsP/A5HFRLE8KUlcbi4XuVUCPrcAAcGg8epPU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dy6XcZjHOMfAyuZnXRitf6TaiHJZ9oV0UB9baIsBH1crVhErxFE6geQbJVnHjvcE6raJzPbw7uikustsJRAgfb+UNGQtdd8ZeVmXsyt9p0LQ2lG9bHxGmOXzGT3QLYFmiD9yLr15/jluTfUR8S6OGCd0Nc9MrPqY144hhUTTiKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QkAWGJqd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QkAWGJqd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A6F5C4CEC3;
	Fri, 18 Oct 2024 21:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729287564;
	bh=Q71K8evsP/A5HFRLE8KUlcbi4XuVUCPrcAAcGg8epPU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QkAWGJqdXBhgqXX/IbKRmrRdESJ7kovBA9svh6/fk4ElW+XiMPseZvgPeC8uhSZWr
	 enSXJrrTAjeg8fB4mNGXHxETpZsA4clJoX0mYfpH7P6lF53joq4W9dCFQCHgm7bv18
	 tSLriZXhZ7rOHQydjfwCk/cp9Nhpzne0Y/frvjenkx1ybM4b5PSyN2Xc0QkKEl+DSx
	 KVO61AVEu85iFtuoo2Kk87qFehN5dIPTozW4ZbeumiJVdobjF57TvGeTpzSSjeYQco
	 pcZ0Jlwc5dyBBUoXSFb7dmlKaPPSbO6TvKQqU/myU97BhHnT1BQZsp0wN7eJ2+0h8x
	 WWBBlThsnFgFg==
Date: Fri, 18 Oct 2024 14:39:24 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/2] fstests/xfs: a couple growfs log recovery tests
Message-ID: <20241018213924.GX21853@frogsfrogsfrogs>
References: <20241017163405.173062-1-bfoster@redhat.com>
 <20241018050909.GA19831@lst.de>
 <ZxJGknETDaJg9to5@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZxJGknETDaJg9to5@bfoster>

On Fri, Oct 18, 2024 at 07:29:22AM -0400, Brian Foster wrote:
> On Fri, Oct 18, 2024 at 07:09:09AM +0200, Christoph Hellwig wrote:
> > On Thu, Oct 17, 2024 at 12:34:03PM -0400, Brian Foster wrote:
> > > I believe you reproduced a problem with your customized realtime variant
> > > of the initial test. I've not been able to reproduce any test failures
> > > with patch 2 here, though I have tried to streamline the test a bit to
> > > reduce unnecessary bits (patch 1 still reproduces the original
> > > problems). I also don't tend to test much with rt, so it's possible my
> > > config is off somehow or another. Otherwise I _think_ I've included the
> > > necessary changes for rt support in the test itself.
> > > 
> > > Thoughts? I'd like to figure out what might be going on there before
> > > this should land..
> > 
> > Darrick mentioned that was just with his rt group patchset, which
> > make sense as we don't have per-group metadata without that.
> > 
> 
> Ah, that would explain it then.

Yep.

> > Anyway, the series looks good to me, and I think it supersedes my
> > more targeted hand crafted reproducer.
> > 
> 
> Ok, thanks. It would be nice if anybody who knows more about the rt
> group stuff could give the rt test a quick whirl and just confirm it's
> at least still effective in that known broken case after my tweaks.
> Otherwise I'll wait on any feedback on the code/test itself... thanks.

Will do, now that I'm out of the mountains. :)

The tests look fine to me, but I guess we could wait to see what falls
out when I add bfoster's tests.

--D

> Brian
> 
> 
