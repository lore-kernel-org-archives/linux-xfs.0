Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E40E23BD06;
	Fri, 17 Oct 2025 22:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760741748; cv=none; b=s5BRsJDlhXHVfoi8lpZgF7XupOuJGCSXbnu+0qv+e6q1T2Uj6ONq+9XT2wGzriPhYY62HXtz6ZnyD8nDYlJBpqOMG1BRtbtK1oS6ksvlhFsX8SD0DKbxl5aP14vXgwOvHJLHW8X8GfZYWv/xmc0nwdrA/iAlSfy7TBU2a+87MvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760741748; c=relaxed/simple;
	bh=FdkbWj1NrLWaTxffSIPD2JikMUyawQsYCKaiAx+HeVQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jb8Bst07ewEZiihsmLC4Nj0SvFO4ugh0fn8hTR+0pMkARopDrq1B/JGqH1AkG6EPQ3fy0MNm0jf6bNJ874upAL410MyGfGAUu0gx/jtt2G4mnZWaFfgwUAYR+yfSWQDlWH+RG15TKe5FOYkCQAcKiYywzNyUsaaCs9uQKdt64Mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=olesDrSv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="olesDrSv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BE5FC4CEE7;
	Fri, 17 Oct 2025 22:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760741747;
	bh=FdkbWj1NrLWaTxffSIPD2JikMUyawQsYCKaiAx+HeVQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=olesDrSvcoWUyqA8S4DG7KdFEBVYPWxZ5Ye60C4YifiPFYeKlAoCEkbl4nepG7nfP
	 MMBi8Kh7bn2T/G7F9GE5rxfTQqm4nmwYJPLbisdwy1IEojqPi5mlAqD/NnybY7s0lC
	 fxGi0E0hH60aN+JZnWSYn6C1mUiytADQJEfT/oIMOz5fkhpROvKx7l8QV6Upz5MkhY
	 kIXfXvnvyR4Lofh1WP3kVTeF+cm4AV837kvkP+SZFibhOLX1WxkLMzkWYw5WI89V5Z
	 ZJdSIF5Ez682fieEo04Y4aEt+qqRotQQ5u7Wl4Og4SulfvIiB6vOl2SGLO+WiflQGd
	 YuG+m/vxv7IJg==
Date: Fri, 17 Oct 2025 15:55:46 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/8] common/attr: fix _require_noattr2
Message-ID: <20251017225546.GI6178@frogsfrogsfrogs>
References: <176054617853.2391029.10911105763476647916.stgit@frogsfrogsfrogs>
 <176054618026.2391029.1336336050566653412.stgit@frogsfrogsfrogs>
 <20251017171325.b35z55fbubi3kxut@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251017171325.b35z55fbubi3kxut@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Sat, Oct 18, 2025 at 01:13:25AM +0800, Zorro Lang wrote:
> On Wed, Oct 15, 2025 at 09:38:32AM -0700, Darrick J. Wong wrote:
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
> 
> How about use findmnt? e.g.
> 
>     grep -qw noattr2 <(findmnt -rncv -M / -o OPTIONS)
> 
> > +	local res=${PIPESTATUS[2]}
> 
> Then the PIPESTATUS isn't needed either.
> 
> I can help to do this change if you agree.

Yes, that works!  Excellent suggestion.

--D

> Thanks,
> Zorro
> 
> >  	_scratch_unmount
> > +	test $res -eq 0 \
> > +		|| _notrun "noattr2 mount option no longer functional"
> >  }
> >  
> >  # getfattr -R returns info in readdir order which varies from fs to fs.
> > 
> 
> 
