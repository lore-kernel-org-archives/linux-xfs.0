Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B8C2EB10;
	Tue,  6 Aug 2024 16:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722960871; cv=none; b=K863u2vIhX1HN3s/Ied6K9FSSknS8Ud0ORiB/zSY3JBqVoNrvO4nO+LOfRdHg8YHbu+t5YPS8BtJMNoKtvC7sSIwMQgOdDxB3J4MD5PJQIVzprdLpKIBi8fycn/ShJLnOkfUcqZKrdUxUaSFRkbUYFSfSROZtWb/E33Ak8stNlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722960871; c=relaxed/simple;
	bh=zrGDtsaecnFiuLR+XY0YSs+F+adfLamn1Pp10kJ/a/Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vE8Sai6vuEz1UTi2Xa1jSg9SDEkiGh1+EunxI1bG2qyBMb+KJsyLtjwPzSrxbQMsQA2yWTdsxNDCaCySmW1GNopA0JknUDZuNcInGhY7FZL/+BCtEi8+olaz6YB6N4rjQ+JYciseXWqifWsMmgAceHDiB2+meD+GBOe7ZWwkwkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fKB0Tmxi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fKB0Tmxi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA9F5C32786;
	Tue,  6 Aug 2024 16:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722960871;
	bh=zrGDtsaecnFiuLR+XY0YSs+F+adfLamn1Pp10kJ/a/Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fKB0TmxiYUajD80Xcd5fWG4XsgBNv0bY/xHfzBMVJyoUEurFSeIHMUTNbUe4FHY1C
	 YtVVwZCm1k8c4h8ozaXqFhrq6dzReYoz1dVVuDJBanlj2BBClgJbbXfMXO1yO/SJkU
	 Bb8wagn8efICBP/5KSptuh+IiJ/p4YAK6hGTE9yvO5TClVFtbAiHj6RvMBR8uti6Gz
	 3n6Df0EChyVbl/GYXzibpxkhuJxO/HysGxjuMnD37/jPVK31m3Ft56yYd6LzuOoMka
	 6mjQdh/hsoJY0GyH+AE7XR9Jb7v2VJvERNnN875G76U3jb1ipQsn5kxq6ihTKD2EcL
	 chZe/FLtr/48g==
Date: Tue, 6 Aug 2024 09:14:30 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: Ma Xinjian <maxj.fnst@fujitsu.com>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] [PATCH] xfs/348: add _fixed_by tag
Message-ID: <20240806161430.GA623922@frogsfrogsfrogs>
References: <20240730075653.3473323-1-maxj.fnst@fujitsu.com>
 <20240730144751.GB6337@frogsfrogsfrogs>
 <20240806131903.h7ym2ktrzqjcqlzj@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240806131903.h7ym2ktrzqjcqlzj@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Tue, Aug 06, 2024 at 09:19:03PM +0800, Zorro Lang wrote:
> On Tue, Jul 30, 2024 at 07:47:51AM -0700, Darrick J. Wong wrote:
> > On Tue, Jul 30, 2024 at 03:56:53PM +0800, Ma Xinjian wrote:
> > > This test requires a kernel patch since 3bf963a6c6 ("xfs/348: partially revert
> > > dbcc549317"), so note that in the test.
> > > 
> > > Signed-off-by: Ma Xinjian <maxj.fnst@fujitsu.com>
> > > ---
> > >  tests/xfs/348 | 3 +++
> > >  1 file changed, 3 insertions(+)
> > > 
> > > diff --git a/tests/xfs/348 b/tests/xfs/348
> > > index 3502605c..e4bc1328 100755
> > > --- a/tests/xfs/348
> > > +++ b/tests/xfs/348
> > > @@ -12,6 +12,9 @@
> > >  . ./common/preamble
> > >  _begin_fstest auto quick fuzzers repair
> > >  
> > > +_fixed_by_git_commit kernel 38de567906d95 \
> > > +	"xfs: allow symlinks with short remote targets"
> > 
> > Considering that 38de567906d95 is itself a fix for 1eb70f54c445f, do we
> > want a _broken_by_git_commit to warn people not to apply 1eb70 without
> > also applying 38de5?
> 
> We already have _wants_xxxx_commit and _fixed_by_xxxx_commit, for now, I
> don't think we need a new one. Maybe:
> 
>   _fixed_by_kernel_commit 38de567906d95 ..............
>   _wants_kernel_commit 1eb70f54c445f .............
> 
> make sense? And use some comments to explain why 1eb70 is wanted?

Oh!  I didn't realize we had _wants_kernel_commit.  Yeah, that's fine.

--D

> Thanks,
> Zorro
> 
> > 
> > --D
> > 
> > > +
> > >  # Import common functions.
> > >  . ./common/filter
> > >  . ./common/repair
> > > -- 
> > > 2.42.0
> > > 
> > > 
> > 
> 
> 
