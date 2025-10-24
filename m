Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1EE829B776;
	Fri, 24 Oct 2025 22:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761344106; cv=none; b=McMnhglF+taT77UD8rPyCQEBtWyBV6snNa+AuAE5xiESCtMgURwoSSeUabe6GiD2s23WNs+B6Sqcatrc+zvm1MiRrIhbF5wxFg77at3tlBdMoCl7ryMB2jBnymcAGrSjHnWAEkaILr58AmKbElUm9rni7t87PWcpFvkg44QIjCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761344106; c=relaxed/simple;
	bh=xFdPTDpKTsCJU6LC5WQZwJBu2isElvNi7B5B4638O8c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dHDiw+KNxW85aIEd8fyWOBvw1ePQUfPvGfOXgR74TMRf8NQoWCQmbqOz8keASEwvLVBZ2tBTqkjnEVIn2iA5m9lSCZKVCxlJizWVYCtjdrKvDMZvF+Mb5Z/NVYkolxigwee0IQ8Q7ZpOm28dLYr1EGYHLeYLid8tq99wa90wp2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TyDRsd/D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TyDRsd/D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32127C4CEF1;
	Fri, 24 Oct 2025 22:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761344104;
	bh=xFdPTDpKTsCJU6LC5WQZwJBu2isElvNi7B5B4638O8c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TyDRsd/DWEIi3sgDloE5zn70VJq+2Wbu5JzGgIpICDJXJ1jdNZERjsQWsLWmbM44i
	 OopDCGuc/JRxa300YPA6WMqRk35ST93EVa6sNNztUvQKtQmpzW6RAkyekdQp6QEvLr
	 XBnKGUndfGKEm7C0mzw7sPHJ1a4HC8AZmPe/XuY+8FQ8jvCgiWmmcxuK2TDXYgsED7
	 m5REcq0065Xop0hlVdAlajxOtMw7/I8YVhox/J2BrKqIyEjXoHvuGf+y1ohbtCzGkm
	 C5N/KJiibHIV18Qjqyq7kvq98Ki6Y6CnXXiKUq4E/rrwRLja3hlrzs0IywM+sSnV3E
	 EO9mMI/mowg8A==
Date: Fri, 24 Oct 2025 15:15:03 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/8] common/attr: fix _require_noattr2
Message-ID: <20251024221503.GV6178@frogsfrogsfrogs>
References: <176054617853.2391029.10911105763476647916.stgit@frogsfrogsfrogs>
 <176054618026.2391029.1336336050566653412.stgit@frogsfrogsfrogs>
 <95366976c8fee19ab2901c4b11fe5925042fdc95.camel@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <95366976c8fee19ab2901c4b11fe5925042fdc95.camel@gmail.com>

On Fri, Oct 24, 2025 at 02:31:16PM +0530, Nirjhar Roy (IBM) wrote:
> On Wed, 2025-10-15 at 09:38 -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > attr2/noattr2 doesn't do anything anymore and aren't reported in
> > /proc/mounts, so we need to check /proc/mounts and _notrun as a result.
> > 
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > ---
> >  common/attr |    4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > 
> > diff --git a/common/attr b/common/attr
> > index 1c1de63e9d5465..35e0bee4e3aa53 100644
> > --- a/common/attr
> > +++ b/common/attr
> > @@ -241,7 +241,11 @@ _require_noattr2()
> >  		|| _fail "_try_scratch_mkfs_xfs failed on $SCRATCH_DEV"
> >  	_try_scratch_mount -o noattr2 > /dev/null 2>&1 \
> >  		|| _notrun "noattr2 mount option not supported on $SCRATCH_DEV"
> > +	grep -w "$SCRATCH_MNT" /proc/mounts | awk '{print $4}' | grep -q -w noattr2
> If noatrr2 doesn't do anything, then in that case _try_scratch_mount will ignore noattr2 and mount
> will succeed. With the above change, we are just checking if noattr2 appears in /proc/mounts(after
> the mount), if yes then the preconditions returns true, else the test using this precondition is
> notrun. Right?

Right.

On a pre-6.18 kernel where noattr2 did something, the following will
happen:

a) V4 filesystem, noattr2 actually matters for the mount, and it should
show up in /proc/mounts.  If it doesn't, then the test should not run.

b) V5 filesystem, noattr2 is impossible so the mount fails.  Test will
not run.

With 6.18 the behavior changes:

a) V4 filesystem, noattr2 doesn't do anything, the mount succeeds, but
noattr2 does not show up in /proc/mounts.  The test should not run.

b) V5 filesystem, noattr2 now no longer fails the mount but it doesn't
show up in /proc/mounts either.  The test still should not run.

> This looks okay to me.
> Reviewed-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>

Thanks!

--D

> --NR
> > +	local res=${PIPESTATUS[2]}
> >  	_scratch_unmount
> > +	test $res -eq 0 \
> > +		|| _notrun "noattr2 mount option no longer functional"
> >  }
> >  
> >  # getfattr -R returns info in readdir order which varies from fs to fs.
> > 
> 
> 
