Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F3BF2D7803;
	Fri, 17 Oct 2025 22:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760741690; cv=none; b=UMd5uEhn2JOvXqIxzajsEFZ5o601/4EYvkl/nrF8mHKxXQwWQQoKV8sjHQDT3FBBVO94k66vRpF+Jg4JnJ1NACXGpDe3Aq9hrqH6/cI1d/WMg3/J7LAS6G2jSMYMC+W289BJpo6pO3mx4X2P1yS+CMBX/AyYUUlpto/LDV3yyGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760741690; c=relaxed/simple;
	bh=wMygeHky2iODwLLpLrgEtKKDueEpSDWYn2TnHcM437Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RCaTsfI9YTdG5Te0RgsxqZdAJGFyq5v0iIiiUMT11eXLwyOg5FUeUSF/C88P1w3IAfRuAGIlwUcaYBLxe+57PMqdivNg8uURANwg0YGqGCTnM4ky98MAgdX2UILflfDdM9qqpu6rn0whq7v3/ZVA8/jAdKnCezwRsK22x/gKqG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o+5kGu8P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o+5kGu8P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEF95C4CEE7;
	Fri, 17 Oct 2025 22:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760741688;
	bh=wMygeHky2iODwLLpLrgEtKKDueEpSDWYn2TnHcM437Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=o+5kGu8PPiXxIw9V6ZeuI9aJdhZiXh/NZhp/BjMpvD1aiQAzkEeqWEGizsZyrJpYa
	 fBPhlzqGD0qHBhrZMkoJTma8cdjaTy0C91WNB+AP46b1bSNq4dF1aow0ydB1wEogqb
	 sMmV88I+KuzOGi+d/w3cVia9L1+LHmvFFhS/IR48ziq4ZtY4Cyt+evGm9rf19ZzWq0
	 vClMIlBXp93KGyX9PQ37NK3DeBXgZKaYJqeZ+/H0XSIiCqVQ3lGYeCdjOkNZw887kD
	 HfjxFnm6UTnMmlOfroNXXYEo8duW0fr92m68XUgG2anI08GVgA+Gqt4w8mszAmBPw5
	 QFkXRKivRUsqA==
Date: Fri, 17 Oct 2025 15:54:48 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/8] generic/772: actually check for file_getattr special
 file support
Message-ID: <20251017225448.GH6178@frogsfrogsfrogs>
References: <176054617853.2391029.10911105763476647916.stgit@frogsfrogsfrogs>
 <176054617988.2391029.18130416327249525205.stgit@frogsfrogsfrogs>
 <20251017174633.lvfvpv2zoauwo7s7@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251017174633.lvfvpv2zoauwo7s7@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Sat, Oct 18, 2025 at 01:46:33AM +0800, Zorro Lang wrote:
> On Wed, Oct 15, 2025 at 09:38:01AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > On XFS in 6.17, this test fails with:
> > 
> >  --- /run/fstests/bin/tests/generic/772.out	2025-10-06 08:27:10.834318149 -0700
> >  +++ /var/tmp/fstests/generic/772.out.bad	2025-10-08 18:00:34.713388178 -0700
> >  @@ -9,29 +9,34 @@ Can not get fsxattr on ./foo: Invalid ar
> >   Can not set fsxattr on ./foo: Invalid argument
> >   Initial attributes state
> >   ----------------- SCRATCH_MNT/prj
> >  ------------------ ./fifo
> >  ------------------ ./chardev
> >  ------------------ ./blockdev
> >  ------------------ ./socket
> >  ------------------ ./foo
> >  ------------------ ./symlink
> >  +Can not get fsxattr on ./fifo: Inappropriate ioctl for device
> >  +Can not get fsxattr on ./chardev: Inappropriate ioctl for device
> >  +Can not get fsxattr on ./blockdev: Inappropriate ioctl for device
> >  +Can not get fsxattr on ./socket: Inappropriate ioctl for device
> > 
> > This is a result of XFS' file_getattr implementation rejecting special
> > files prior to 6.18.  Therefore, skip this new test on old kernels.
> > 
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > ---
> >  tests/generic/772 |    3 +++
> >  tests/xfs/648     |    3 +++
> >  2 files changed, 6 insertions(+)
> > 
> > 
> > diff --git a/tests/generic/772 b/tests/generic/772
> > index cc1a1bb5bf655c..e68a6724654450 100755
> > --- a/tests/generic/772
> > +++ b/tests/generic/772
> > @@ -43,6 +43,9 @@ touch $projectdir/bar
> >  ln -s $projectdir/bar $projectdir/broken-symlink
> >  rm -f $projectdir/bar
> >  
> > +file_attr --get $projectdir ./fifo &>/dev/null || \
> > +	_notrun "file_getattr not supported on $FSTYP"
> 
> I'm wondering if a _require_file_attr() is better?

It's checking specifically that the new getattr syscall works on special
files.  I suppose you could wrap that in a helper, but I think this is a
lot more direct about what it's looking for.

--D

> Thanks,
> Zorro
> 
> > +
> >  echo "Error codes"
> >  # wrong AT_ flags
> >  file_attr --get --invalid-at $projectdir ./foo
> > diff --git a/tests/xfs/648 b/tests/xfs/648
> > index 215c809887b609..e3c2fbe00b666a 100755
> > --- a/tests/xfs/648
> > +++ b/tests/xfs/648
> > @@ -47,6 +47,9 @@ touch $projectdir/bar
> >  ln -s $projectdir/bar $projectdir/broken-symlink
> >  rm -f $projectdir/bar
> >  
> > +$here/src/file_attr --get $projectdir ./fifo &>/dev/null || \
> > +	_notrun "file_getattr not supported on $FSTYP"
> > +
> >  $XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
> >  	-c "project -sp $projectdir $id" $SCRATCH_DEV | filter_quota
> >  $XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
> > 
> 
> 
