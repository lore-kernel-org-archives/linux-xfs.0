Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BCA02D46B3;
	Tue, 12 Aug 2025 18:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022491; cv=none; b=EKJDWTmkt7RWiYCm0yuPv0iMFqjXf8lfGq+7Wikm1Z+42GSArJ/vrvbY9duNZzob3+g9ojg98ymU28S3ecUzECNKzZfMrlt/e+o8Up5lfqMhEmFC83JTJZTtBj8H7DIp36VmUIUP3xg/8RH8XaSu3SfxvFzBuYSlpZzHaN57dDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022491; c=relaxed/simple;
	bh=sAoBOEvWEdraurNeJ6nJyT0jLimlUA4fKcuuor4ohU4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uPF3nPhPx4YMfaC5xP0uAM7J8yjKqa1MKVsAITrOgRDkgTTLI6fnR2ZMZurD1GWmFB7K0FPCFFFbNc4W8/uiLGNr6lMCD85IjpLfpEedQMV4sUfZ/mDRaVao+8cdlRMwrd6lw+FFG8XX96d1stwxkbNULXCaLSUPpsB7Hp84p/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F7a/XaFl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F7a/XaFl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DC51C4CEF1;
	Tue, 12 Aug 2025 18:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755022491;
	bh=sAoBOEvWEdraurNeJ6nJyT0jLimlUA4fKcuuor4ohU4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=F7a/XaFlCiqR1gmEor9WBexHDJPCtr8af+UnnU1LSrUDZC0SFQd7WH7QwCXm3PCBn
	 vA1axi+e97ui535Q6PL6tp+TBspkynQWyaiUScTpy0xvA4BIkVKrN017sx+7m0BB/Q
	 GIt3sEfsaWizJZE1y4l3MGKzW3qflJozNtVvdq6YuKfF4rMLHZiHA3t10FJtpj0pKG
	 mDznCUwmuQYgEBRw6ksCfm77pCr3yYF8CPdMYBUytRtbvqXGQ3cbKT1+i+co+ZigzF
	 1EFa1cvj8WHeWpbsjQ+kMP4m5Y3dOcYcSRltyWrlyj5NHMN7nsVoiMTXdGZmlEAz/G
	 BmOzWBma6JnhA==
Date: Tue, 12 Aug 2025 11:14:50 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] check: collect core dumps from systemd-coredump
Message-ID: <20250812181450.GA7952@frogsfrogsfrogs>
References: <175381958396.3021194.15630936445319512317.stgit@frogsfrogsfrogs>
 <175381958439.3021194.17530499480231032752.stgit@frogsfrogsfrogs>
 <20250802134700.khtlw7thzqyclfnt@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250802134700.khtlw7thzqyclfnt@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Sat, Aug 02, 2025 at 09:47:00PM +0800, Zorro Lang wrote:
> On Tue, Jul 29, 2025 at 01:11:06PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > On modern RHEL (>=8) and Debian KDE systems, systemd-coredump can be
> > installed to capture core dumps from crashed programs.  If this is the
> > case, we would like to capture core dumps from programs that crash
> > during the test.  Set up an (admittedly overwrought) pipeline to extract
> > dumps created during the test and then capture them the same way that we
> > pick up "core" and "core.$pid" files.
> > 
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > ---
> >  check     |    2 ++
> >  common/rc |   44 ++++++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 46 insertions(+)
> > 
> > 
> > diff --git a/check b/check
> > index ce7eacb7c45d9e..77581e438c46b9 100755
> > --- a/check
> > +++ b/check
> > @@ -924,6 +924,7 @@ function run_section()
> >  		     $1 == "'$seqnum'" {lasttime=" " $2 "s ... "; exit} \
> >  		     END {printf "%s", lasttime}' "$check.time"
> >  		rm -f core $seqres.notrun
> > +		_start_coredumpctl_collection
> >  
> >  		start=`_wallclock`
> >  		$timestamp && _timestamp
> > @@ -957,6 +958,7 @@ function run_section()
> >  		# just "core".  Use globbing to find the most common patterns,
> >  		# assuming there are no other coredump capture packages set up.
> >  		local cores=0
> > +		_finish_coredumpctl_collection
> >  		for i in core core.*; do
> >  			test -f "$i" || continue
> >  			if ((cores++ == 0)); then
> > diff --git a/common/rc b/common/rc
> > index 04b721b7318a7e..e4c4d05387f44e 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -5034,6 +5034,50 @@ _check_kmemleak()
> >  	fi
> >  }
> >  
> > +# Current timestamp, in a format that systemd likes
> > +_systemd_now() {
> > +	timedatectl show --property=TimeUSec --value
> > +}
> > +
> > +# Do what we need to do to capture core dumps from coredumpctl
> > +_start_coredumpctl_collection() {
> > +	command -v coredumpctl &>/dev/null || return
> > +	command -v timedatectl &>/dev/null || return
> > +	command -v jq &>/dev/null || return
> > +
> > +	sysctl kernel.core_pattern | grep -q systemd-coredump || return
> 
> # rpm -qf `which coredumpctl`
> systemd-udev-252-53.el9.x86_64
> # rpm -qf `which timedatectl`
> systemd-252-53.el9.x86_64
> # rpm -qf `which jq`
> jq-1.6-17.el9.x86_64
> # rpm -qf /usr/lib/systemd/systemd-coredump 
> systemd-udev-252-53.el9.x86_64
> 
> So we have 3 optional running dependences, how about metion that in README?

Done.

--D

> Thanks,
> Zorro
> 
> > +	COREDUMPCTL_START_TIMESTAMP="$(_systemd_now)"
> > +}
> > +
> > +# Capture core dumps from coredumpctl.
> > +#
> > +# coredumpctl list only supports json output as a machine-readable format.  The
> > +# human-readable format intermingles spaces from the timestamp with actual
> > +# column separators, so we cannot parse that sanely.  The json output is an
> > +# array of:
> > +#        {
> > +#                "time" : 1749744847150926,
> > +#                "pid" : 2297,
> > +#                "uid" : 0,
> > +#                "gid" : 0,
> > +#                "sig" : 6,
> > +#                "corefile" : "present",
> > +#                "exe" : "/run/fstests/e2fsprogs/fuse2fs",
> > +#                "size" : 47245
> > +#        },
> > +# So we use jq to filter out lost corefiles, then print the pid and exe
> > +# separated by a pipe and hope that nobody ever puts a pipe in an executable
> > +# name.
> > +_finish_coredumpctl_collection() {
> > +	test -n "$COREDUMPCTL_START_TIMESTAMP" || return
> > +
> > +	coredumpctl list --since="$COREDUMPCTL_START_TIMESTAMP" --json=short 2>/dev/null | \
> > +	jq --raw-output 'map(select(.corefile == "present")) | map("\(.pid)|\(.exe)") | .[]' | while IFS='|' read pid exe; do
> > +		test -e "core.$pid" || coredumpctl dump --output="core.$pid" "$pid" "$exe" &>> $seqres.full
> > +	done
> > +	unset COREDUMPCTL_START_TIMESTAMP
> > +}
> > +
> >  # don't check dmesg log after test
> >  _disable_dmesg_check()
> >  {
> > 
> 
> 
