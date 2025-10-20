Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E876D18871F;
	Mon, 20 Oct 2025 18:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760985336; cv=none; b=JcJ6zyOW4PAAVMElDe8WO4eu3Xaxo1ck8YIv2REa/snuuBt/Fw4SWnVwnZdYiAF1lTOoH0s8ONK3mPLvK5oDGpxapKVyp7woiO4kIgTIWnUHScMVk+riWgEKEA9Dkmgbe7JbNnPSMP5baQ5Igjk0nGZgy4sUoTkVQp3O/CxDeis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760985336; c=relaxed/simple;
	bh=99hfqNSWGiE+UJKPFvJ1RnObE07V33P9DYJ2jHkckpY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t2b1nIny6YuhBUK2Sbuy9nY5TVC27xLbYcFHDc7+KFX/cudvmrQhGY3a6nxg4Pp2QJWYIJBtylGGoB1QRJyYwg5dWADCuZ32tRNo/wh6ULsj26MOohkFi/uFAdoVTmHAxOnW7optsCoGDWDPlhdt6u1ivSp4pLjH0plyfYPSyRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E00h+Ngd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E00h+Ngd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 850DBC113D0;
	Mon, 20 Oct 2025 18:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760985335;
	bh=99hfqNSWGiE+UJKPFvJ1RnObE07V33P9DYJ2jHkckpY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=E00h+Ngd2cmBhj7jbyfTIOVcXiu8EjCUJl0hsfzAGHzDmI2QSdtGO5RfGQOjkrM1S
	 13AOZCNHhE2VpCvJ5LkLu8D6KZapj3uEioBx7J9rdYTrezop8J5P55NJqQqs+JuMP0
	 wRH2UkoHjuLVHS5Cb90WUAkScFgmjbPo8u0141rOY4BV/JsXQnKve9pW1Qlqk+NSqo
	 R1hAX5UglHwvc4r5adTJ93MIaaDQYIduSGqHHdI80VyNxh+k4VlGBGC1UT+N2NUBfB
	 mDl99BcDdzye8Hn+6A5bOsScKROrcLENVvcItXnbTNmLXInDVtsQvP9XgLeD245gcX
	 h5FR7RhLokotw==
Date: Mon, 20 Oct 2025 11:35:34 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/8] generic/427: try to ensure there's some free space
 before we do the aio test
Message-ID: <20251020183534.GF3356773@frogsfrogsfrogs>
References: <176054617853.2391029.10911105763476647916.stgit@frogsfrogsfrogs>
 <176054617913.2391029.5774423816009069866.stgit@frogsfrogsfrogs>
 <20251020141639.ekbpgtfjdyybd3wz@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251020141639.ekbpgtfjdyybd3wz@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Mon, Oct 20, 2025 at 10:16:39PM +0800, Zorro Lang wrote:
> On Wed, Oct 15, 2025 at 09:36:58AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > On a filesystem configured like this:
> > MKFS_OPTIONS="-m metadir=1,autofsck=1,uquota,gquota,pquota -d rtinherit=1 -r zoned=1"
> > 
> > This test fails like this:
> > 
> > --- a/tests/generic/427.out      2025-04-30 16:20:44.584246582 -0700
> > +++ b/tests/generic/427.out.bad        2025-07-14 10:47:07.605377287 -0700
> > @@ -1,2 +1,2 @@
> >  QA output created by 427
> > -Success, all done.
> > +pwrite: No space left on device
> 
> Hahah, I just felt weird, why g/427 failed as:
> 
>    QA output created by 427
>   -pwrite: No space left on device
>   +Success, all done.
> 
> then I found `git am` treats above commit log as part of the patch :-D Please add
> some blanks to above fail messages.
> 
> BTW, I decided not to merge this patchset in today's release, due to I haven't gotten
> time to give it enough test. I'll try to merge it (or part of it) in next release .
> Sorry for the late.

Will clean up and push out.  Though now that there's an xfsprogs 6.17
release I guess I'll rerun everything with that and push out the
bugfixes tomorrow instead of today.

--D

> Thanks,
> Zorro
> 
> > 
> > The pwrite failure comes from the aio-dio-eof-race.c program because the
> > filesystem ran out of space.  There are no speculative posteof
> > preallocations on a zoned filesystem, so let's skip this test on those
> > setups.
> > 
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > ---
> >  tests/generic/427 |    3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > 
> > diff --git a/tests/generic/427 b/tests/generic/427
> > index bddfdb8714e9a7..bb20d9f44a2b5a 100755
> > --- a/tests/generic/427
> > +++ b/tests/generic/427
> > @@ -28,6 +28,9 @@ _require_no_compress
> >  _scratch_mkfs_sized $((256 * 1024 * 1024)) >>$seqres.full 2>&1
> >  _scratch_mount
> >  
> > +# Zoned filesystems don't support speculative preallocations
> > +_require_inplace_writes $SCRATCH_MNT
> > +
> >  # try to write more bytes than filesystem size to fill the filesystem,
> >  # then remove all these data. If we still can find these stale data in
> >  # a file' eofblock, then it's a bug
> > 
> 
