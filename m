Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271F41C7009;
	Fri, 24 Oct 2025 22:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761343732; cv=none; b=FJsouNuACHLK0H4Dh/zv3mnvgTmir2kXOWvJMXPeywNqssqPaETaeRh2hU+CMVwzlYCoymgJ7VGXWuMwMmE1YrF0ma3s2nr8u5e9fGyegClvrmtFkB50DEKE9ZmswGNq5Le7ftngzQyAQYj8TKF85Lds+kMN8v8qbzZj4Nf5IkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761343732; c=relaxed/simple;
	bh=Picls1+Xijq5huTjGeJpVt5CxysQFo0zKMNGi41xCLY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lD8Cxq2A58YPBTzFwKEpESOSCMA/mwc+g1cp/+OIU3k6v2+CqzrOM/jCQ0dEQub26xJ1jNTmFn09Gaj9eSeR5kz/mbRGl4GYAcItxoEpioSTFVDoZB6X6Wfs2QpRtCpjL9UMjKDswPB9dE28EjHXzhoW2q3wICm+8dKCipKNeGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L0T9FRni; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L0T9FRni"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AC26C4CEF1;
	Fri, 24 Oct 2025 22:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761343729;
	bh=Picls1+Xijq5huTjGeJpVt5CxysQFo0zKMNGi41xCLY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=L0T9FRni+T2LZwvK1N6E+5H40oWfXVsobxlFgroj1piKI4soS5WAmSJF+9v5f24bX
	 iben5RaY8FgB/7ds/vp1h6XYR3UmgypT37DGiQrfm2dRr65M9rfJ3yaJ/C7Z9hmUKC
	 uBlSPVgimH1KhgcY7AO/tI/C2a+fDGIQh91V4qbKzSq7G4gj8Pgo8KnXH+YKB71ktA
	 T6haLOrOH54mNoHIeN+dov0szFmHKH9Ig1IopdltHhS/nb7HfiU0QwYyBwiRI3azR7
	 pXjTgm5tbXEWkQK+a6sXPYd8ntfJJ3JOx/6IAwK46ZZMLPWcmpPguu7V57wU3FbNAd
	 0aCrWvmVtOPvA==
Date: Fri, 24 Oct 2025 15:08:49 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/8] common/rc: fix _require_xfs_io_shutdown
Message-ID: <20251024220849.GM4015566@frogsfrogsfrogs>
References: <176054617853.2391029.10911105763476647916.stgit@frogsfrogsfrogs>
 <176054617932.2391029.3304833304093152893.stgit@frogsfrogsfrogs>
 <ee99fc234ccfc433662975d45f24c8900428e2ea.camel@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee99fc234ccfc433662975d45f24c8900428e2ea.camel@gmail.com>

On Fri, Oct 24, 2025 at 01:01:50PM +0530, Nirjhar Roy (IBM) wrote:
> On Wed, 2025-10-15 at 09:37 -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Capturing the output of _scratch_shutdown_handle requires one to enclose
> > the callsite with $(), otherwise you're comparing the literal string
> > "_scratch_shutdown_handle" to $SCRATCH_MNT, which always fails.
> > 
> > Also fix _require_xfs_io_command to handle testing the shutdown command
> > correctly.
> > 
> > Cc: <fstests@vger.kernel.org> # v2025.06.22
> > Fixes: 4b1cf3df009b22 ("fstests: add helper _require_xfs_io_shutdown")
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > ---
> >  common/rc |    7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> > 
> > 
> > diff --git a/common/rc b/common/rc
> > index 1ec84263c917c0..1b78cd0c358bb9 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -619,7 +619,7 @@ _scratch_shutdown_and_syncfs()
> >  # requirement down to _require_scratch_shutdown.
> >  _require_xfs_io_shutdown()
> >  {
> > -	if [ _scratch_shutdown_handle != $SCRATCH_MNT ]; then
> > +	if [ $(_scratch_shutdown_handle) != $SCRATCH_MNT ]; then
> Yeah, right. _scratch_shutdown_handle is a function call and should be placed in a $() or ``. 
> >  		# Most likely overlayfs
> >  		_notrun "xfs_io -c shutdown not supported on $FSTYP"
> >  	fi
> > @@ -3073,6 +3073,11 @@ _require_xfs_io_command()
> >  		rm -f $testfile.1
> >  		param_checked="$param"
> >  		;;
> > +	"shutdown")
> > +		testio=$($XFS_IO_PROG -f -x -c "$command $param" $testfile 2>&1)
> > +		param_checked="$param"
> > +		_test_cycle_mount
> > +		;;
> Looks good to me. Just curious, any reason why we are testing with TEST_DIR and not with
> SCRATCH_MNT? 

$TEST_DIR is always available and mounted, whereas SCRATCH_* are
optional.

> Reviewed-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>

Thanks!

--D

> >  	"utimes" )
> >  		testio=`$XFS_IO_PROG -f -c "utimes 0 0 0 0" $testfile 2>&1`
> >  		;;
> > 
> 
