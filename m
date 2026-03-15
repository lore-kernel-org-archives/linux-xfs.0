Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB35C3594A;
	Sun, 15 Mar 2026 04:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773550295; cv=none; b=bb0k3bIDzigXomYQvp/PQuU4dJgtC3h60B5rxq/ZJgMgle91ms4dg09VGmMr3vTxUD+eSy0HXTyQv1s6JoHXRn50It6qEFb8B4CLwCumP0CHnTpLs1uanSl/py/VYIXfc5gDcKOrnrj689PnW9Wwddv4u0yYj0XePPBrGBWwkhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773550295; c=relaxed/simple;
	bh=2pctLpceaitcLftHd3fezaOyBKG0rKfvVCfN2qLPGS8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GhU0sRP/KwHNsoWcPQCLqA/xkruhrJFuClB64oInIcYVzMobCH0lsJgxbZA3BXGz12TM7boQcwnnPlpzaiQUQIV99kxDAmWoUxnPROL//urN81FICagRXLzPiArhoAaZAAfEdAey8YsZQ4POGEGuvi9VXXAUaWF+Tpl6KdyfOaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XJGR9Bx/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XJGR9Bx/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F754C4CEF7;
	Sun, 15 Mar 2026 04:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773550294;
	bh=2pctLpceaitcLftHd3fezaOyBKG0rKfvVCfN2qLPGS8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XJGR9Bx/t5OH689tskBJxk7huQxC/ns+8st+6IZyHGWLkUkDuYuCMHP1Qc1RI974r
	 xoKjOvaB3kT5upPXfXqr1Sf0aYlaQIc7qbdgV98JfJrIItGT9+569spCz5bGFicgw+
	 YdgcRpWRCkNQnUybGu2pyaN9pAUzyFosb52H1sjZ6sdla40Im1aREUM/w2kf6gUPk5
	 4JMcXgVTZzlTLQ4NI7ES/b7loWPRlYWe7c+VPSjsrtBns5Nb8DWQyeX4w5bZx8ftKz
	 Xe1jeSN+KkoQFWy/3x00H0Xnuquc37qaWG3yAfrY7eqSCOwDjukDKlAFapCHpr9hzM
	 eYPk+HLVuFhqA==
Date: Sat, 14 Mar 2026 21:51:33 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/14] xfs: set up common code for testing xfs_healer
Message-ID: <20260315045133.GG6069@frogsfrogsfrogs>
References: <177311403712.1186408.7032564474004561606.stgit@frogsfrogsfrogs>
 <177311403849.1186408.3223809492518597284.stgit@frogsfrogsfrogs>
 <20260314203759.nbt523d7dyuhr6um@doltdoltdolt>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260314203759.nbt523d7dyuhr6um@doltdoltdolt>

On Sun, Mar 15, 2026 at 04:37:59AM +0800, Zorro Lang wrote:
> On Mon, Mar 09, 2026 at 08:51:10PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Add a bunch of common code so that we can test the xfs_healer daemon.
> > Most of the changes here are to make it easier to manage the systemd
> > service units for xfs_healer and xfs_scrub.
> > 
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > ---
> >  common/config  |   14 ++++++++
> >  common/rc      |    5 +++
> >  common/systemd |   39 ++++++++++++++++++++++
> >  common/xfs     |   98 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/802  |    4 +-
> >  5 files changed, 158 insertions(+), 2 deletions(-)
> > 
> 
> [snip]
> 
> > +# Compute the xfs_scrub systemd service instance name for a given path.  This
> > +# is tricky because xfs_scrub only gained --svcname when xfs_healer was made.
> > +_xfs_scrub_svcname()
> > +{
> > +	local ret
> > +
> > +	if ret="$($XFS_SCRUB_PROG --svcname "$@")"; then
> 
> Better to be:
> 
> -       if ret="$($XFS_SCRUB_PROG --svcname "$@")"; then
> +       if ret="$($XFS_SCRUB_PROG --svcname "$@" 2>/dev/null)"; then
> 
> Or below xfs/802 will ...
> 
> > +		echo "$ret"
> > +		return 0
> > +	fi
> 
> [snip]
> 
> > diff --git a/tests/xfs/802 b/tests/xfs/802
> > index fc4767acb66a55..18312b15b645bd 100755
> > --- a/tests/xfs/802
> > +++ b/tests/xfs/802
> > @@ -105,8 +105,8 @@ run_scrub_service() {
> >  }
> >  
> >  echo "Scrub Scratch FS"
> > -scratch_path=$(systemd-escape --path "$SCRATCH_MNT")
> > -run_scrub_service xfs_scrub@$scratch_path
> > +svc="$(_xfs_scrub_svcname "$SCRATCH_MNT")"
> 
> ... fails on old xfsprogs as:
> 
>   --- /dev/fd/63	2026-03-13 19:16:15.217899866 -0400
>   +++ xfs/802.out.bad	2026-03-13 19:16:15.191834546 -0400
>   @@ -1,5 +1,21 @@
>    QA output created by 802
>    Format and populate
>    Scrub Scratch FS
>   +/usr/sbin/xfs_scrub: invalid option -- '-'
>   +Usage: xfs_scrub [OPTIONS] mountpoint
>   +
>   +Options:
>   +  -a count     Stop after this many errors are found.
>   +  -b           Background mode.
>   +  -C fd        Print progress information to this fd.
>   +  -e behavior  What to do if errors are found.
>   +  -k           Do not FITRIM the free space.
>   +  -m path      Path to /etc/mtab.
>   +  -n           Dry run.  Do not modify anything.
>   +  -p           Only optimize, do not fix corruptions.
>   +  -T           Display timing/usage information.
>   +  -v           Verbose output.
>   +  -V           Print version.
>   +  -x           Scrub file data too.
>    Scrub Everything
>    Scrub Done
> 
> If you don't have more suggestion, I'll help to change that :)

That seems the proper correction to make.  Thanks for your help!

--D

> Thanks,
> Zorro
> 
> > +run_scrub_service "$svc"
> >  find_scrub_trace "$SCRATCH_MNT"
> >  
> >  # Remove the xfs_scrub_all media scan stamp directory (if specified) because we
> > 
> 
