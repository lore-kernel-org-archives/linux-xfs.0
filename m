Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3345F3914F0;
	Thu, 27 Aug 2026 17:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787850195; cv=none; b=IxgVlkt4giyWcKG6HRiYsKwBXGR7rV/tqzvH+LsmMpjMgD7/eI9j/TqwhlxZUPI5RxVQZzPH7rw9S/0zpGDCi9BJPfsxQOUBn5neUJKj7vik6KqU1/UaInYQxfthdmelwcTLeHqaABeAJnuw7LlsEUCbW00dN2XkqIZ8NPaXaxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787850195; c=relaxed/simple;
	bh=stN08rwFtkqU9g+G++9WKQdF6/2XvbLNNvfaXig2PsY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qGDSHMbQ2ZBpxJ1qQVPIZdaJE7E8uIomUUKCmMHX68iR2syhCpW1A16UP32DcdVGmixUO5ZvGNJq0viBuZ0FYQZiwATFlX4AQOnRFPmDijO6N9/g2ynudJTYmM0Iwr0SK0Zuya+I0+e2Z7VI3I9RUHrWit6yLa04FmUB4TGGG3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XQd7uO22; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XQd7uO22"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C30F1F000E9;
	Thu, 27 Aug 2026 17:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787850193;
	bh=0wRSGHeu9SxbyPztkBKd6kryRKeaOEetZ2dGpR3OtaU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XQd7uO22uJgA7dDTbZho/ldQOKmKptJ6cr7Q8NLSCDKrN1KhUnaIudLJPJ+L3l3Ez
	 5+01wSeZoSJiSRwsUuGoTO3pfu6OmgugJmwgUSjCTuI0qMufTz6OZ/OqbrdHXwVRWT
	 SG9odWDOuCLtOlO78TRgJT2KF1RJMupMjHLbB3WiKiPtaKDA3Kg2lV7b8zvEgEyreQ
	 6/M3pHlg/2PNNd5Xc8tIvOFg8Tkv+7ZLdCS2P2kMcLB3d3Cbod42FaTg+qx63SAcj1
	 U6aEHj4AQgEDfoX3KKM74NomAHtumt27woQVBf9IBWO2LQ/U9ajLpXoh7avgxGBfZJ
	 y8PSqajIKxSCQ==
Date: Fri, 28 Aug 2026 01:03:08 +0800
From: Zorro Lang <zlang@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>, 
	Hans.Holmberg@wdc.com
Subject: Re: [PATCH] xfs/837: set rtinherit on the root directory
 programmatically
Message-ID: <apBtZzqbq3USafoH@zlang-mailbox>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>, 
	fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>, Hans.Holmberg@wdc.com
References: <20260826183001.GV839663@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260826183001.GV839663@frogsfrogsfrogs>

On Wed, Aug 26, 2026 at 11:30:01AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> I patched mkfs to enable metadir by default, but then this test
> regressed on the "-m metadir=0 -d rtinherit=1..." configuration.  Upon
> digging into the test results, I observed that the scratch filesystem
> actually had metadir enabled despite the intended configuration.  That
> in turn revealed that _scratch_mkfs was failing because -d rtinherit was
> being respecified, so it did that obnoxious thing it does and reformats
> with only the caller's mkfs options.
> 
> As a result, the scratch filesystem is configured incorrectly -- metadir
> is enabled when we don't want it to be, so we pick the wrong output file
> and fail.
> 
> Instead of passing -drtinherit and potentially conflicting with the test
> configuration options, let's use _xfs_force_bdev to set rtinherit
> programmatically.
> 
> Cc: <Hans.Holmberg@wdc.com>
> Cc: <fstests@vger.kernel.org> # v2025.06.22
> Fixes: e225772353e212 ("xfs: add mount test for read only rt devices")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---

Makes sense to me,

Reviewed-by: Zorro Lang <zlang@kernel.org>

>  tests/xfs/837 |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/tests/xfs/837 b/tests/xfs/837
> index 2fe195a009f10f..33ec37ae3dbde3 100755
> --- a/tests/xfs/837
> +++ b/tests/xfs/837
> @@ -35,7 +35,11 @@ fi
>  
>  _register_cleanup "_cleanup_setrw"
>  
> -_scratch_mkfs "-d rtinherit" > /dev/null 2>&1
> +_scratch_mkfs > /dev/null 2>&1
> +
> +_scratch_mount
> +_xfs_force_bdev realtime $SCRATCH_MNT
> +_scratch_unmount
>  
>  # Select appropriate output file
>  features=""
