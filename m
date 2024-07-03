Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDDB418654
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jul 2024 04:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719982253; cv=none; b=CoSdAmClnXXb2dz9X1cJOBxH8Wh2pWw526/p6J8GPFFJ80KHaX8QVS3jhPFaAb7Nxf8MW4Y3nf0yst+YpJqWJaxnEuYPHp5kmG8r9eClJV/26B7ObZ+qG8HYyPWCL7FLj/wO7gpeWK4WsI66qcTuyb53h6iO+OJvxQmJVUhhhu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719982253; c=relaxed/simple;
	bh=3KK41Vtt1rBiwwUeuJgkX55icdk9kRql8SML06SmbKk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q+RzcygcSwKosVBKxLpiwFMRsx4t0FOXqgEuoS+MZoatzrfXHjpTMTo3W6yCH7INpTBELNDeyhsrmhHDkHP33/TW6fmM9I4Gfj9CPfxmaDyjQ5X4ZdANOh3apf4/h8TeuTFw+SAJey/3ga9W5jdSqcgB7rbHUHBkoCOdfpyJ/zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DpQKLeRh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DpQKLeRh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E9A6C32781;
	Wed,  3 Jul 2024 04:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719982253;
	bh=3KK41Vtt1rBiwwUeuJgkX55icdk9kRql8SML06SmbKk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DpQKLeRhrkvETM0wCbXUZpV9leaaMHFrUrsYfcRV+4F7LnjIr2TqMIhqUQi+/yLGg
	 BkuXEymovw5Ks6+OcX6iBFkLrZw74eUGW/uhgFegKkgfE4tRSD+mw3tQejPxJrkPzs
	 1baQD30sOvpohQ4RKYkta0yMuwmzLcameIkKorEj3Z8C3kRNUU/IwupDUsrWcCHlgG
	 H1iaFKb1C3UNaDKgurEMY53PokSU8XjLGkH633cU1oYkrnR0NekDJd8rxrw6V5Qm4R
	 oafCYtM7EoWTYrnyWthxM3uaarD4bPQoe8WjAOb12GcGNJ/VE+nbetTfZk7b6+LaOn
	 4RoJPbgZYY+AQ==
Date: Tue, 2 Jul 2024 21:50:52 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH v30.7.1 7/8] xfs_scrub: improve responsiveness while
 trimming the filesystem
Message-ID: <20240703045052.GY612460@frogsfrogsfrogs>
References: <171988118118.2007602.12196117098152792537.stgit@frogsfrogsfrogs>
 <171988118237.2007602.9576505614542313879.stgit@frogsfrogsfrogs>
 <20240703035227.GX612460@frogsfrogsfrogs>
 <20240703043345.GE24160@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240703043345.GE24160@lst.de>

On Wed, Jul 03, 2024 at 06:33:45AM +0200, Christoph Hellwig wrote:
> On Tue, Jul 02, 2024 at 08:52:27PM -0700, Darrick J. Wong wrote:
> > I then had the idea to limit the length parameter of each call to a
> > smallish amount (~11GB) so that we could report progress relatively
> > quickly, but much to my surprise, each FITRIM call still took ~68
> > seconds!
> 
> Where do those magic 11GB come from?
> 
> > +/*
> > + * Limit the amount of fstrim scanning that we let the kernel do in a single
> > + * call so that we can implement decent progress reporting and CPU resource
> > + * control.  Pick a prime number of gigabytes for interest.
> 
> ... this explains it somehow, but not really :)

It's entirely arbitrary -- big enough to exceed MAXEXTLEN*4k, rounded up
to the next prime number of gigabytes.

> The code itself looks fine, so with a better explanation or more
> round number:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
