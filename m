Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF1F217C21E
	for <linux-xfs@vger.kernel.org>; Wed, 30 Jul 2025 15:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753887851; cv=none; b=OlzA70fpuZ4mX3i1gu6IaHtnlWUOjrs/AsKCIAWtJd1sa7Gxm3V+s4i91PHNsKhxMFx2fkHZN3a3W2JvBZCZoqfMe8z3FWJp7k2Tf/mnnp9PkX9vFhIMCyR+9ZReRuxQ9FMog8gp7jTHfJUD6RxFGQvUmJaj+m/s5YQ4L+DyVWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753887851; c=relaxed/simple;
	bh=Sn1T+E9t//ymiad0N12BmI1IkFSKXPuD3CyYaGrrpsE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EVBA8Qe3ztaJA7h4Mr5ql0zuv7eDoh9UJqtrteMOQFcGXIzPHOSEdxbx4V0US4EzLq+/1xf3jTqkqbsrBCoNmieFz9kfP4BzPxq1Kq1v+a9kYuJRazNnTtFMN0d6kUZxtYtYTRAbzNZeh3qFJewkypVapWXorJTKHg5i+Li6I+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d+BmF6sG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d+BmF6sG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6958FC4CEE3;
	Wed, 30 Jul 2025 15:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753887850;
	bh=Sn1T+E9t//ymiad0N12BmI1IkFSKXPuD3CyYaGrrpsE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d+BmF6sGDuFMAgGpDPU+kFn4Rz/gyFKCMtA/B9XnL5OEKBfL1twS9yIAmg7ZH2dOr
	 Hh5ajL0pUpX7qdkID33QLtph+haGlGOFmTqMhgU2+Lvl1c4ky1ophvkHoiT8nRRxEQ
	 CjBPrHRiigCwIehc7MamNRdycIxs2rz9AME8eLEh1wm2vgjSKU/tBI3TIBp6ZLXJ4C
	 dUjnAdhJG0sPRs5Wi+xF3QiuxwCuE2+u015i6/Up9JKF6BkC4GevCqcP8Fq4HMnBXi
	 C9bYzHyv9dK8IRoY6pr9uFfUgB0arSrvTpufuA2FouNDR02JdkZjI7bCmfSfurcxYK
	 61TCpjThS33cA==
Date: Wed, 30 Jul 2025 08:04:09 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Luca Di Maio <luca.dimaio1@gmail.com>
Cc: linux-xfs@vger.kernel.org, dimitri.ledkov@chainguard.dev,
	smoser@chainguard.dev, hch@infradead.org
Subject: Re: [PATCH v11 1/1] proto: add ability to populate a filesystem from
 a directory
Message-ID: <20250730150409.GG2672070@frogsfrogsfrogs>
References: <20250728152919.654513-2-luca.dimaio1@gmail.com>
 <20250728152919.654513-4-luca.dimaio1@gmail.com>
 <20250729214322.GH2672049@frogsfrogsfrogs>
 <bowzj7lobz6tv73swiauishctrryozcwqmqyeqck65o2qjyt5v@vufmu67nwlkc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bowzj7lobz6tv73swiauishctrryozcwqmqyeqck65o2qjyt5v@vufmu67nwlkc>

On Wed, Jul 30, 2025 at 04:40:39PM +0200, Luca Di Maio wrote:
> Thanks Darrick for the review!
> Sorry again for this indentation mess, I'm going to basically align all
> function arguments and all the top-function declarations
> I was a bit confused because elsewhere in the code is not like that so
> it's a bit difficult to infere
> 
> Offtopic: maybe we could also introduce an editorconfig setup? so that
> all various editors will be correctly set to see the tabs/spaces as
> needed (https://editorconfig.org/)

Hrmm, that /would/ be useful.

> Back on topic:
> 
> On Tue, Jul 29, 2025 at 02:43:22PM -0700, Darrick J. Wong wrote:

<snipping>

> > > +	if (!S_ISSOCK(file_stat.st_mode) &&
> > > +	    !S_ISLNK(file_stat.st_mode)  &&
> > > +	    !S_ISFIFO(file_stat.st_mode)) {
> > > +		close(fd);
> > > +		fd = openat(pathfd, entry->d_name,
> > > +			    O_NOFOLLOW | O_RDONLY | O_NOATIME);
> >
> > Just out of curiosity, does O_NOATIME not work in the previous openat?

[narrator: it doesn't]

> Actually on my test setup (mainly using docker/podman to test), opening
> with and without O_NOATIME when using O_PATH, does not change accesstime
> checking with `stat`, but also it works if I add it.
> As a precautionary measure (not sure if podman/docker is messing with
> noatime) I'll add it, as it seems to work correctly.

On second thought I think you might leave the double opens because
O_NOATIME is only allowed if the current user owns source file, or has
CAP_FOWNER.  If you're running mkfs as an unprivileged user trying to
capture a rootfs (with uid 0 files) then O_NOATIME won't be allowed.

Maybe something along the lines of:

	/*
	 * Try to open the source file noatime to avoid a flood of
	 * writes to the source fs, but we can fall back to plain
	 * readonly mode if we don't have enough permission.
	 */
	fd = openat(pathfd, entry->d_name, O_NOFOLLOW | O_RDONLY | O_NOATIME);
	if (fd < 0)
		fd = openat(pathfd, entry->d_name, O_NOFOLLOW | O_RDONLY);
	if (fd < 0)
		/* whine and exit */

Just to see if you can open the source file without touching atime?

--D

> > > +		 * this will make flistxattr() and fgetxattr() fail wil EBADF,
> >
> > "fail with EBADF"...
> >
> 
> Ack.
> 
> > > +	/*
> > > +	 * Copy over attributes.
> > > +	 */
> > > +	writeattrs(ip, path_buf, fd);
> >
> > Nothing closes fd here; does it leak?
> >
> > --D
> >
> 
> Ack.
> 
> L.
