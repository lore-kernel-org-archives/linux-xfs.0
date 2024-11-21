Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AAA11537C9;
	Thu, 21 Nov 2024 17:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732209594; cv=none; b=qBoQdD0RHo05RLw1otLH6a2fEjt4/ipyRLML1J3oGwsmozS5NBcuDOp7LtOlx712nU2e5c6w6hHuZcrE9m9Yewu9d9lbUuoI1sNvBiqzngXEFxanZ8SMFWUg0EeUXoA8jrKohkqmQk0I23DN/pBAt9hqiGIFs7dWqm5dh4EBEFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732209594; c=relaxed/simple;
	bh=lTdiQqOK+WtFHblWwIp8BhgXZKjPUtfmawnXRv6VOW8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n4NiDorYQrXw1/aaD/K4jnk9b+J7RfkwwojuMLmWevP0YPlvPML2ykEweqqfiXu7q2kxD8M6MtBP7J97NEVYTR/KBAjNmvs0mtwUMng1FqljWI8LKvtnOwUSHFwFHIYcVccDSASUd39jEJbczlwsZKTEgb8YXKOOEsgq9STOQhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qnTkX9r8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qnTkX9r8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D831EC4CECC;
	Thu, 21 Nov 2024 17:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732209593;
	bh=lTdiQqOK+WtFHblWwIp8BhgXZKjPUtfmawnXRv6VOW8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qnTkX9r8r4qtZSwwNJHIKQJKzQg+jDNOjg3Fe8ns8PQ4aPprJY0nmwEoAteTIPWzV
	 5q0pqadDOOWgT+qW7YuiRvSgVlGalY75nhPPTmiXDwti1j2x55LlCD0HOgB4Eukgo4
	 j5aQ8DGsQCekxdlA1+2bwMMgZydR0m+0L7Gv/HKXaaHqObA5wROjb9FPtUeaF8FqNJ
	 0OjchiHvzWl/k5oB1/PDjEhutha7hdBd035Ep/K+G7HMHxL+rSGypPZ2WyvqnZwg9L
	 k9namfA0WWeb1CIiyKKuLyduwFgUVM8azZvLok7cmD4ZM2jiKHcfl7zO+Lg5ZIY2PN
	 iSNwt/yJHzo9Q==
Date: Thu, 21 Nov 2024 09:19:53 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/12] xfs/157: fix test failures when MKFS_OPTIONS has
 -L options
Message-ID: <20241121171953.GW9425@frogsfrogsfrogs>
References: <173197064408.904310.6784273927814845381.stgit@frogsfrogsfrogs>
 <173197064609.904310.7896567442225446738.stgit@frogsfrogsfrogs>
 <20241121101712.qdtdk63aq6kp4pdm@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241121101712.qdtdk63aq6kp4pdm@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Thu, Nov 21, 2024 at 06:17:12PM +0800, Zorro Lang wrote:
> On Mon, Nov 18, 2024 at 03:04:31PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Zorro reports that this test fails if the test runner set an -L (label)
> > option in MKFS_OPTIONS.  Fix the test to work around this with a bunch
> 
> I didn't hit the xfs/157 failure by setting "-L label" in MKFS_OPTIONS,
> I set MKFS_OPTIONS="-m rmapbt=1" in local.config, then "-m rmapbt=1" is
> conflict with rtdev, that cause the "-L oldlabel" be dropped by
> _scratch_mkfs_sized.
> 
> I don't mind having this "xfs/157 enhancement" patch. But as we've talked,
> I don't think any testers would like to write MKFS_OPTIONS="-L label" in
> local.config. So this patch might not be necessary. What do you think?

Yeah, I guess I will drop it then.

--D

> Thanks,
> Zorro
> 
> > of horrid sed filtering magic.  It's probably not *critical* to make
> > this test test work with random labels, but it'd be nice not to lose
> > them.
> > 
> > Cc: <fstests@vger.kernel.org> # v2024.10.14
> > Fixes: 2f7e1b8a6f09b6 ("xfs/157,xfs/547,xfs/548: switch to using _scratch_mkfs_sized")
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  tests/xfs/157 |   29 +++++++++++++++++++++++++++--
> >  1 file changed, 27 insertions(+), 2 deletions(-)
> > 
> > 
> > diff --git a/tests/xfs/157 b/tests/xfs/157
> > index e102a5a10abe4b..0c21786e389695 100755
> > --- a/tests/xfs/157
> > +++ b/tests/xfs/157
> > @@ -65,9 +65,34 @@ scenario() {
> >  	SCRATCH_RTDEV=$orig_rtdev
> >  }
> >  
> > +extract_mkfs_label() {
> > +	set -- $MKFS_OPTIONS
> > +	local in_l
> > +
> > +	for arg in "$@"; do
> > +		if [ "$in_l" = "1" ]; then
> > +			echo "$arg"
> > +			return 0
> > +		elif [ "$arg" = "-L" ]; then
> > +			in_l=1
> > +		fi
> > +	done
> > +	return 1
> > +}
> > +
> >  check_label() {
> > -	_scratch_mkfs_sized "$fs_size" "" -L oldlabel >> $seqres.full 2>&1
> > -	_scratch_xfs_db -c label
> > +	local existing_label
> > +	local filter
> > +
> > +	# Handle -L somelabel being set in MKFS_OPTIONS
> > +	if existing_label="$(extract_mkfs_label)"; then
> > +		filter=(sed -e "s|$existing_label|oldlabel|g")
> > +		_scratch_mkfs_sized $fs_size >> $seqres.full
> > +	else
> > +		filter=(cat)
> > +		_scratch_mkfs_sized "$fs_size" "" -L oldlabel >> $seqres.full 2>&1
> > +	fi
> > +	_scratch_xfs_db -c label | "${filter[@]}"
> >  	_scratch_xfs_admin -L newlabel "$@" >> $seqres.full
> >  	_scratch_xfs_db -c label
> >  	_scratch_xfs_repair -n &>> $seqres.full || echo "Check failed?"
> > 
> 
> 
