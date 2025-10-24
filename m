Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 196E91C7009;
	Fri, 24 Oct 2025 22:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761343848; cv=none; b=PP+bcl/+FV0bfqp8SA8UtZalY4Eb7hNw/mife/BJLRQj0SLG10Rg1LXhc7SviU+3jfiVxog6lIVxFbUccq3EOvelIcuwJQrMiVMiPKnLpTL1u0TmvT2UXp81fQgxEno9XMfNiMrx0cRF8xjw1t7m+1YOxa3bSzbqzL4F409G81A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761343848; c=relaxed/simple;
	bh=pgRcMBSW6ONY32gE1tHG8PhMlKVK9ONUFhPe/3NR7AQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pCETf7aM3vVj+2vZZw/Pu33zznKhg2PiiKIudzhSzVB+pI+h/10Q9QZrE5VfVJ780ZIvW7R81PQvSl481QvdeeUwK2JafaCwYirm4RPBqU0e1zBlGVfMRtEKFXw/rSeqbHQKh/H25e1ZtyQr2CFsXPErNQ6IrrZUOOx1hpuvp/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f2MWjTlR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f2MWjTlR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E523BC4CEF1;
	Fri, 24 Oct 2025 22:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761343848;
	bh=pgRcMBSW6ONY32gE1tHG8PhMlKVK9ONUFhPe/3NR7AQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f2MWjTlRVmSVkHIRNCdKf5NQ3drr5x+/02RUkR1Of25NlG0HMvSAULmN7oUjwR/hM
	 fQ5f6GDzIzmZrJvLEw+Obn5kyT6xejQGd0mDkmbTTzq7yrp6cQbyV/q9OQ+FBT20C9
	 VDyJ9aZuIKioA8DNy8kK4RQqJFheqH0oK+yoyj8ZPlGM84VM3qI7V/K35cz2vkqnIa
	 2wRq+k0vgdI/3LMT/0PAkjq+I/l87DFE/RKtSl1rPhVAbB1F07IdCVTV26X4Un/O6y
	 A3xwJgoodwxsUe4wT9sO2/9lN6GJUaenkxoZT7UGcXD+bM4kSbVDF1l+CiK+cog6vZ
	 TKfTDLhVu66Hw==
Date: Fri, 24 Oct 2025 15:10:47 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/8] generic/772: actually check for file_getattr special
 file support
Message-ID: <20251024221047.GU6178@frogsfrogsfrogs>
References: <176054617853.2391029.10911105763476647916.stgit@frogsfrogsfrogs>
 <176054617988.2391029.18130416327249525205.stgit@frogsfrogsfrogs>
 <68e2839c0a7848a95fa5b2b8f6107b1e941636a4.camel@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68e2839c0a7848a95fa5b2b8f6107b1e941636a4.camel@gmail.com>

On Fri, Oct 24, 2025 at 01:14:29PM +0530, Nirjhar Roy (IBM) wrote:
> On Wed, 2025-10-15 at 09:38 -0700, Darrick J. Wong wrote:
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
> > +
> Shouldn't we use $here/src/file_attr like we have done later (maybe just for consistency)?

Probably, but this test has (for now) a wrapper so I used that.

> Also, I am wondering if we can have something like
> _require_get_attr_for_special_files() helper kind of a thing?

Andrey's working on that.

--D

> --NR
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
