Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 403CF17333A;
	Thu, 21 Nov 2024 15:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732204322; cv=none; b=AzqOIzKg8JBvKL48ynFscz2+H1Fy7PrpN7DMMZSpV9AKqcbPJZsiIw66R4iZh+Cix5IAA1shmrKNI/zAbE0azcELPw5cIkbv8zGp57oGhmk+Hy9+Ah9dGGfg1rpqknbElYfkhwgZxRJi9hnCbV8btot/f6h6xQ/NyWPg0YgL3so=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732204322; c=relaxed/simple;
	bh=TiXvXG7lIoFy+EoAE4P+PK0MuH1doboxw/kNlbcxhVU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z4wsZlSTJ0enH8o6xjJLhdEFbYLcAygMTjdiQmWzABilSAZYB/AgcKTrLyUNukp2n0AZsgKwBiXaB++AWbCuzPxwRSH71EWkJlvDvVHouQJSahacwTN/iSUahMzogK//RkvK4QAb1ZPKu78i+9qn4mNa5Kf1P8OOWhsrDbg6UOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O53wXV9F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O53wXV9F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1E83C4CECC;
	Thu, 21 Nov 2024 15:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732204321;
	bh=TiXvXG7lIoFy+EoAE4P+PK0MuH1doboxw/kNlbcxhVU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=O53wXV9F54NaeYUQZjgJaGxGvpakFlhHNfMaVl79E3xSaofxZ/g8jBM8GUATG5Zlj
	 Iik4H9P5bO/nwniejyaXTlrOcfn8myJeQGoHbFIWWyGsOYWJkXH177JnfLAcBD/VHB
	 U9/5hUVw+yvZtx5zV0wDV+nVxqheK/Y8tcZ2JSm4HUZqur+nCQeWDu6LXdETC5EIQZ
	 dnVjc2pqiXBcjxmUUOQ4Z83ghjCHU6AH58QjPxAjs571Q0EJx+qc5+fWi7yBWttl/h
	 fvLbvcyRBJyvVSDdUhkECFkgd32WAetSjLceA3P2ZY0Bk98uQkjAe+pzdYUHeBBulf
	 5H6SNmow1DQFQ==
Date: Thu, 21 Nov 2024 07:52:01 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs/157: do not drop necessary mkfs options
Message-ID: <20241121155201.GS9425@frogsfrogsfrogs>
References: <20241116190800.1870975-1-zlang@kernel.org>
 <20241116190800.1870975-3-zlang@kernel.org>
 <20241118222614.GK9425@frogsfrogsfrogs>
 <20241121093537.ae74gwbzl53yvsn2@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241121093537.ae74gwbzl53yvsn2@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Thu, Nov 21, 2024 at 05:35:37PM +0800, Zorro Lang wrote:
> On Mon, Nov 18, 2024 at 02:26:14PM -0800, Darrick J. Wong wrote:
> > On Sun, Nov 17, 2024 at 03:08:00AM +0800, Zorro Lang wrote:
> > > To give the test option "-L oldlabel" to _scratch_mkfs_sized, xfs/157
> > > does:
> > > 
> > >   MKFS_OPTIONS="-L oldlabel $MKFS_OPTIONS" _scratch_mkfs_sized $fs_size
> > > 
> > > but the _scratch_mkfs_sized trys to keep the $fs_size, when mkfs
> > > fails with incompatible $MKFS_OPTIONS options, likes this:
> > > 
> > >   ** mkfs failed with extra mkfs options added to "-L oldlabel -m rmapbt=1" by test 157 **
> > >   ** attempting to mkfs using only test 157 options: -d size=524288000 -b size=4096 **
> > > 
> > > but the "-L oldlabel" is necessary, we shouldn't drop it. To avoid
> > > that, we give the "-L oldlabel" to _scratch_mkfs_sized through
> > > function parameters, not through global MKFS_OPTIONS.
> > > 
> > > Signed-off-by: Zorro Lang <zlang@kernel.org>
> > > ---
> > >  tests/xfs/157 | 3 +--
> > >  1 file changed, 1 insertion(+), 2 deletions(-)
> > > 
> > > diff --git a/tests/xfs/157 b/tests/xfs/157
> > > index 9b5badbae..f8f102d78 100755
> > > --- a/tests/xfs/157
> > > +++ b/tests/xfs/157
> > > @@ -66,8 +66,7 @@ scenario() {
> > >  }
> > >  
> > >  check_label() {
> > > -	MKFS_OPTIONS="-L oldlabel $MKFS_OPTIONS" _scratch_mkfs_sized $fs_size \
> > > -		>> $seqres.full
> > > +	_scratch_mkfs_sized "$fs_size" "" "-L oldlabel" >> $seqres.full 2>&1
> > 
> > Don't quote the "-L" and "oldlabel" within the same string unless you
> > want them passed as a single string to _scratch_mkfs.  Right now that
> > works because although you have _scratch_mkfs_sized using "$@"
> 
> I use "$@" just for _scratch_mkfs_sized can give an empty argument to
> _try_scratch_mkfs_sized to be its second argument.
> 
> how about:
> _scratch_mkfs_sized "$fs_size" "" -L oldlabel
> 
> > (doublequote-dollarsign-atsign-doublequote) to pass its arguments intact
> > to _scratch_mkfs, it turns out that _scratch_mkfs just brazely passes $*
> > (with no quoting) to the actual MKFS_PROG which results in any space in
> > any single argument being treated as an argument separator and the
> > string is broken into multiple arguments.
> > 
> > This is why you *can't* do _scratch_mkfs -L "moo cow".
> > 
> > This is also part of why everyone hates bash.
> 
> Hmm... do you need to change the $* of _scratch_mkfs to $@ too?

Yeah, that's something that needs to be done treewide.  The trouble is,
I bet there's other tests out there that have come to rely on the bad
splitting behavior and do things like

_scratch_fubar "-x 555"

becoming

execve("foobar", "-x" "555");

and will break if we try to fix it now.

--D

> > 
> > --D
> > 
> > >  	_scratch_xfs_db -c label
> > >  	_scratch_xfs_admin -L newlabel "$@" >> $seqres.full
> > >  	_scratch_xfs_db -c label
> > > -- 
> > > 2.45.2
> > > 
> > > 
> > 
> 
> 
