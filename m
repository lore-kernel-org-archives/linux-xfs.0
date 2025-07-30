Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E16D298CD5
	for <linux-xfs@vger.kernel.org>; Wed, 30 Jul 2025 15:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753889214; cv=none; b=A+bPpr2y5ak2qpJO8cps4x/EzDLCN02/xQrFttKoN3HhE+oWqhz4sqB5IpDjBH9YkYsD9piIQ7KATLP3OPFbPFykHS/chcLj17iezkBOoPbh5Z2wv+DcRnDeODP9Po98mlHVY7RF0yfb7NUDof7ffRvlv+Ta9zKd2Ee9AUlp04k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753889214; c=relaxed/simple;
	bh=vbTQS1E4odl34EGbB3haRKliN6kj2NGEppsp715/YJo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N9sNOKVUZyciAIcXNPfRvRaXXmpYrO+Dx8Ji04nekbsd/esZnGv642DfRfO7CGesWPs+QdEDP2XoOarSxi+5ph72nSIO0oTIQQYdvhi4hAmEPjlUJp77uz7/EyyedfIHb7T1f9w3HkzgSAGILCmWpCwtLDRNPzZAVpGekbsKDAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y2odx64p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y2odx64p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E56FC4CEE3;
	Wed, 30 Jul 2025 15:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753889213;
	bh=vbTQS1E4odl34EGbB3haRKliN6kj2NGEppsp715/YJo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y2odx64puhMZHH+Q7Ou0PzNf/vXTWxprVkt++oMrEwRijCVUX0ngboh0BmTjK1FcL
	 Tfx+vKN/Q8oH16NzA1PIrcbBCnRzS6m//GodicXhJ7S/ZfGTbUV77Y7WLcM8fwy0lN
	 fhf3nZ7dQdLvyl9pCoO0No8p5cH1w/bD6AUhwpC3c7G6P2qx2BPmJNXDz4XR/EXRT5
	 HewlS9wZmlkizqiSFzo7DVDRRI1f4S74YsR/pq8dO5eGDgcU+/eXY/9i8F6mrZnWrg
	 r3WKNFTKTcRXPTDqo3w37w6mIR1W2keU+0hjkiZnqjdQtQ6cDMyxVN8w1r4DFZk/VS
	 nS6THAnN8p9OQ==
Date: Wed, 30 Jul 2025 08:26:52 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Luca Di Maio <luca.dimaio1@gmail.com>
Cc: linux-xfs@vger.kernel.org, dimitri.ledkov@chainguard.dev,
	smoser@chainguard.dev, hch@infradead.org
Subject: Re: [PATCH v11 1/1] proto: add ability to populate a filesystem from
 a directory
Message-ID: <20250730152652.GS2672049@frogsfrogsfrogs>
References: <20250728152919.654513-2-luca.dimaio1@gmail.com>
 <20250728152919.654513-4-luca.dimaio1@gmail.com>
 <20250729214322.GH2672049@frogsfrogsfrogs>
 <bowzj7lobz6tv73swiauishctrryozcwqmqyeqck65o2qjyt5v@vufmu67nwlkc>
 <20250730150409.GG2672070@frogsfrogsfrogs>
 <an4uufrp4vk4bqs4zpvver7sodqn3i2gtx5rjp5336jlylmmhk@bchzcckwdlfr>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <an4uufrp4vk4bqs4zpvver7sodqn3i2gtx5rjp5336jlylmmhk@bchzcckwdlfr>

On Wed, Jul 30, 2025 at 05:20:42PM +0200, Luca Di Maio wrote:
> On Wed, Jul 30, 2025 at 08:04:09AM -0700, Darrick J. Wong wrote:
> > On Wed, Jul 30, 2025 at 04:40:39PM +0200, Luca Di Maio wrote:
> > > Thanks Darrick for the review!
> > > Sorry again for this indentation mess, I'm going to basically align all
> > > function arguments and all the top-function declarations
> > > I was a bit confused because elsewhere in the code is not like that so
> > > it's a bit difficult to infere
> > >
> > > Offtopic: maybe we could also introduce an editorconfig setup? so that
> > > all various editors will be correctly set to see the tabs/spaces as
> > > needed (https://editorconfig.org/)
> >
> > Hrmm, that /would/ be useful.
> >
> 
> Nice, will try to put something together for a future patch

Either that or a indent/clang-format wrapper?

The kernel has scripts/Lindent, maybe someone should try to write one
for xfs style if I don't get to it first.

<sigh>rustfmt<duck>

> > > Back on topic:
> > >
> > > On Tue, Jul 29, 2025 at 02:43:22PM -0700, Darrick J. Wong wrote:
> >
> > <snipping>
> >
> > > > > +	if (!S_ISSOCK(file_stat.st_mode) &&
> > > > > +	    !S_ISLNK(file_stat.st_mode)  &&
> > > > > +	    !S_ISFIFO(file_stat.st_mode)) {
> > > > > +		close(fd);
> > > > > +		fd = openat(pathfd, entry->d_name,
> > > > > +			    O_NOFOLLOW | O_RDONLY | O_NOATIME);
> > > >
> > > > Just out of curiosity, does O_NOATIME not work in the previous openat?
> >
> > [narrator: it doesn't]
> >
> > > Actually on my test setup (mainly using docker/podman to test), opening
> > > with and without O_NOATIME when using O_PATH, does not change accesstime
> > > checking with `stat`, but also it works if I add it.
> > > As a precautionary measure (not sure if podman/docker is messing with
> > > noatime) I'll add it, as it seems to work correctly.
> >
> > On second thought I think you might leave the double opens because
> > O_NOATIME is only allowed if the current user owns source file, or has
> > CAP_FOWNER.  If you're running mkfs as an unprivileged user trying to
> > capture a rootfs (with uid 0 files) then O_NOATIME won't be allowed.
> >
> > Maybe something along the lines of:
> >
> > 	/*
> > 	 * Try to open the source file noatime to avoid a flood of
> > 	 * writes to the source fs, but we can fall back to plain
> > 	 * readonly mode if we don't have enough permission.
> > 	 */
> > 	fd = openat(pathfd, entry->d_name, O_NOFOLLOW | O_RDONLY | O_NOATIME);
> > 	if (fd < 0)
> > 		fd = openat(pathfd, entry->d_name, O_NOFOLLOW | O_RDONLY);
> > 	if (fd < 0)
> > 		/* whine and exit */
> >
> > Just to see if you can open the source file without touching atime?
> >
> > --D
> 
> Right, will do like this, didn't think about rootless/unprivileged mkfs
> 
> L.
> 
