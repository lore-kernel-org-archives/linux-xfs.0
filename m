Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31F8F2877FC;
	Mon, 20 Oct 2025 16:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760977677; cv=none; b=k9OVr0HwoyGNSQok4Fe+H2VS29VYqA5v+kTSiO8wUdO5gQtbAAp/g8cnf/Aoac/AUOoge1NyrBNCvOdzMAYEGMdGVBPHbY+174UcmgUndjNAt8lA+hspSGyseaWYOGspwPRMGRenDGGCJUTGpgVtkurRr0HiitcLJBJLq0r1BgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760977677; c=relaxed/simple;
	bh=Bi1cui7wKMh3Kvt1gMVlMvASzxHMYZNUcnT4JaGKEro=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j1jrkYK7yXWCxcRdO6oQ5+aB7Flfc04UiGH7VIrA+Ydsbf3Y6b7W7X6I5bl0TG0zXum0o67PwEi+D+AbLc4CfT5CqUpbGMjK2ZG0UocB4HZgjglNS5NRFum/Xvo5SSBTQldD5ACqp+GcZ01NephExwoOcDrkIHhGTvtST8hX7j0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GIJGEnjB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GIJGEnjB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 027F6C4CEF9;
	Mon, 20 Oct 2025 16:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760977677;
	bh=Bi1cui7wKMh3Kvt1gMVlMvASzxHMYZNUcnT4JaGKEro=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GIJGEnjB22vaIw+WmGrUEfYoFhsnf7iLkIxGfzZzRqdBkMc3M0HC7S85pG98GWjUL
	 kkoMw11/KDIzP3jOboxrKd8LP3cHstb9GrZKBlDCjHJsxeIEgAMdN6lhxmgfZUu/VJ
	 Km9oNlqmOlhyaI/5SPty1937HY/D+i09QiA4esIZQ35ayifEC1RK871x8L4Ed2GYSH
	 xQjO+4yRHoPualRlmubQoMCfpJeR6RbJ5VO0N2/DzgFU47TyphJnAZh60tJxQ/FmcT
	 ZlFwDjIDH+Y5m2tU/wOHQU0yS+W8Hf8jHXEAeK08rffAii9UmssKMlOKVt/30EqGDW
	 fdcqA+k8A7ZNA==
Date: Mon, 20 Oct 2025 09:27:56 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/8] common/attr: fix _require_noattr2
Message-ID: <20251020162756.GL6178@frogsfrogsfrogs>
References: <176054617853.2391029.10911105763476647916.stgit@frogsfrogsfrogs>
 <176054618026.2391029.1336336050566653412.stgit@frogsfrogsfrogs>
 <20251017171325.b35z55fbubi3kxut@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20251017225546.GI6178@frogsfrogsfrogs>
 <20251018144318.owo63ppez7ormj5f@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251018144318.owo63ppez7ormj5f@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Sat, Oct 18, 2025 at 10:43:18PM +0800, Zorro Lang wrote:
> On Fri, Oct 17, 2025 at 03:55:46PM -0700, Darrick J. Wong wrote:
> > On Sat, Oct 18, 2025 at 01:13:25AM +0800, Zorro Lang wrote:
> > > On Wed, Oct 15, 2025 at 09:38:32AM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > attr2/noattr2 doesn't do anything anymore and aren't reported in
> > > > /proc/mounts, so we need to check /proc/mounts and _notrun as a result.
> > > > 
> > > > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > > > ---
> > > >  common/attr |    4 ++++
> > > >  1 file changed, 4 insertions(+)
> > > > 
> > > > 
> > > > diff --git a/common/attr b/common/attr
> > > > index 1c1de63e9d5465..35e0bee4e3aa53 100644
> > > > --- a/common/attr
> > > > +++ b/common/attr
> > > > @@ -241,7 +241,11 @@ _require_noattr2()
> > > >  		|| _fail "_try_scratch_mkfs_xfs failed on $SCRATCH_DEV"
> > > >  	_try_scratch_mount -o noattr2 > /dev/null 2>&1 \
> > > >  		|| _notrun "noattr2 mount option not supported on $SCRATCH_DEV"
> > > > +	grep -w "$SCRATCH_MNT" /proc/mounts | awk '{print $4}' | grep -q -w noattr2
> > > 
> > > How about use findmnt? e.g.
> > > 
> > >     grep -qw noattr2 <(findmnt -rncv -M / -o OPTIONS)
> 
> Sorry, the "/" should be $SCRATCH_MNT.
> 
> > > 
> > > > +	local res=${PIPESTATUS[2]}
> > > 
> > > Then the PIPESTATUS isn't needed either.
> > > 
> > > I can help to do this change if you agree.
> > 
> > Yes, that works!  Excellent suggestion.
> 
> The patch 1,2,3,5,7,8 has been acked/reviewed, do you need I merge these patches
> in the release of this weekend at first, as this's a random fixes patchset. Or
> I can wait your next version, then merge the whole patchset when it's all get
> reviewed ?

Well I guess you didn't take any of them yet, so I'll republish them in
a little bit.

--D

> Thanks,
> Zorro
> 
> > 
> > --D
> > 
> > > Thanks,
> > > Zorro
> > > 
> > > >  	_scratch_unmount
> > > > +	test $res -eq 0 \
> > > > +		|| _notrun "noattr2 mount option no longer functional"
> > > >  }
> > > >  
> > > >  # getfattr -R returns info in readdir order which varies from fs to fs.
> > > > 
> > > 
> > > 
> > 
> 
> 
