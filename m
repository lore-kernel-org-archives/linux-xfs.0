Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7CF1531C2;
	Wed, 22 Jan 2025 03:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737516468; cv=none; b=WTXSJIFwUtca9p13eKsdmEMGeOPomCxmfcibYahiAGmvggyOYRCqQIhbiQYxOtPtA79hPV8kSU3UKD8BvVBzOOCsqL1CxMhJZf7fl0tC7yT74FwXftXyrvnaL3ltAh8U9W6Dec9DlLiuoLI9y3HNSdHvvPG6hOCQqjXiR1SJfRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737516468; c=relaxed/simple;
	bh=mCNwGSuD42XTFxEwrlOchb0Qi/FDrvmjW88jWLsVW+0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M7CYKPZspRG5tbO0m8caKGKb6j/9iSQh7CRqDbvaNvJTH84Mdyvx4E/EiRd9EeoA2Vjg2NNMpkj6dclcqC1sX8LaCm26N24haCBn3CSwlNbN+/8a6q4R9xGZa+GkWZ4S1idSxH16Mf3fQ+2BjpTz/9GJbjjV+dCM3DoKZRVgBJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UCR02pg3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UCR02pg3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED6C9C4CED6;
	Wed, 22 Jan 2025 03:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737516468;
	bh=mCNwGSuD42XTFxEwrlOchb0Qi/FDrvmjW88jWLsVW+0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UCR02pg3qelLhtDUSmDyhzi4Dply0KdUquUNEOhp4B3PjQeZLVofnQ2BaZSwiu7Ar
	 1eXPCJclLjWHx2KbD95fkMpU/bhlMxlZbj8paJgjLF6ZX0MYXSicUR50zF0/xfMhAp
	 TsJhuQd9WwhTNWAVAG861nCXgh5EdWT6QtBPHnjcUd4kFa3OGkQx8fBxFsnZm4zATn
	 w5gXGaq/onUkQ4VnKit9OKJQJYcX30wSuL45rZp9gK+mZNHRH3/w4C/Hur8RbtV1v1
	 yr6CHzOUK5X3PMWTL/UcFQjt9uqbcJdKvDlEZAuY31MDf0Tvo6ch/YUktRcZP3MnxN
	 TNR74CVyef5Gg==
Date: Tue, 21 Jan 2025 19:27:47 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: zlang@redhat.com, hch@lst.de, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/23] generic/482: _run_fsstress needs the test
 filesystem
Message-ID: <20250122032747.GN1611770@frogsfrogsfrogs>
References: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
 <173706974137.1927324.11572571998972107262.stgit@frogsfrogsfrogs>
 <Z48QhXVLqwCO0KIQ@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z48QhXVLqwCO0KIQ@dread.disaster.area>

On Tue, Jan 21, 2025 at 02:12:05PM +1100, Dave Chinner wrote:
> On Thu, Jan 16, 2025 at 03:26:13PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > The test filesystem is now a hard dependency of _run_fsstress because
> > the latter copies the fsstress binary to a different name on the test
> > filesystem:
> > 
> > generic/482       - output mismatch (see /var/tmp/fstests/generic/482.out.bad)
> >     --- tests/generic/482.out   2024-02-28 16:20:24.262888854 -0800
> >     +++ /var/tmp/fstests/generic/482.out.bad    2025-01-03 15:00:43.107625116 -0800
> >     @@ -1,2 +1,3 @@
> >      QA output created by 482
> >     +cp: cannot create regular file '/mnt/482.fsstress': Read-only file system
> >      Silence is golden
> >     ...
> >     (Run 'diff -u /tmp/fstests/tests/generic/482.out /var/tmp/fstests/generic/482.out.bad'  to see the entire diff)
> 
> Ah, because I hadn't added dm-logwrite support to check-parallel
> this test wasn't being run....
> 
> However, this patch doesn't need to exist - this dependency is
> removed  later in the series by using the changes to use a unique
> session ID for each test and so the fsstress binary doesn't need to
> be rename. The change in this patch is then reverted....
> 
> I'd just drop this patch (and the later revert).

Done, thanks for reviewing.

--D

> -Dave.
> 
> > 
> > Cc: <fstests@vger.kernel.org> # v2024.12.08
> > Fixes: 8973af00ec212f ("fstests: cleanup fsstress process management")
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > ---
> >  tests/generic/482 |    1 -
> >  1 file changed, 1 deletion(-)
> > 
> > 
> > diff --git a/tests/generic/482 b/tests/generic/482
> > index 8c114ee03058c6..0efc026a160040 100755
> > --- a/tests/generic/482
> > +++ b/tests/generic/482
> > @@ -68,7 +68,6 @@ lowspace=$((1024*1024 / 512))		# 1m low space threshold
> >  
> >  # Use a thin device to provide deterministic discard behavior. Discards are used
> >  # by the log replay tool for fast zeroing to prevent out-of-order replay issues.
> > -_test_unmount
> >  _dmthin_init $devsize $devsize $csize $lowspace
> >  _log_writes_init $DMTHIN_VOL_DEV
> >  _log_writes_mkfs >> $seqres.full 2>&1
> > 
> > 
> > 
> 
> -- 
> Dave Chinner
> david@fromorbit.com
> 
