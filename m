Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B338037DAA2;
	Thu, 27 Aug 2026 17:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787850255; cv=none; b=iB4H56pFVZ8OtReGUATSGLp3jE6SRX4ymnfEP9VBvCvxi9bMHmdejiVCoQQWY18WxbLVd3XFiLIRJlQBqU91OulBmQZXp6aB6gaaXfHnIfc0NSpKjxpHJNSmmUSeRlQCeSQLRTIeAEDscHE7QvNkx6YAnVi3qg35y+SX+n6JdHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787850255; c=relaxed/simple;
	bh=8bYadG4FPItoSQIZfDXmgSiVVp48vksxylqWE8vC8Ec=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DaDBXva5mc1SXZcXJUeDO/65nc70Saxke3BhvsaoaWJ77u4W4txJz6ZODxPsnfcCoHhY6m7XkMsn24disAhm7a+RGtulZc8X/IeNttnLi/H7iEGW/8kap9D9gLqfClCp2POUX3HzLik33A0Tacnj8ETLvnmih/jkExePq9BW9Tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U234qU+q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U234qU+q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B28201F000E9;
	Thu, 27 Aug 2026 17:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787850254;
	bh=9nQCcoh/iWa3ZmG4gxWpr3xCFPvBh871HY8x5Es9S6c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=U234qU+qdWLjSKb2qa12pXPlaAvZp+GB4Vm4FahO45n8vwUXxVKTpdoLfLgIxX4EM
	 EnvdBNNo5fsVLeTGHbIQa6uE5RH1TG0dOgZqAXSzID5mDck+Q41q4buZs0U3RVfWLu
	 jia95z5PiUHe3XfzrMfV7GqOpOqU/dCrEIqNadbllIwUDH0mk+QwjEzD7EFTpZfE8P
	 VG99N4JL7EL1sUtJ6OglsKEVX9uNVib5Ef+yiN6MBmfbi7nmcIPYJg+mHQ7nUGpEU0
	 BElk6UlgNDWAf5cQOSckkpXM4nUN8aUW+TvRPeVH8nkpnFyfhn+dmIQW8g1t/cSTgH
	 caQYcgzxxZVmg==
Date: Fri, 28 Aug 2026 01:04:09 +0800
From: Zorro Lang <zlang@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs/030: skip this test if metadir gets enabled anyway
Message-ID: <apBt4bXTmE9nDKGn@zlang-mailbox>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>, 
	fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>
References: <20260826183026.GW839663@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260826183026.GW839663@frogsfrogsfrogs>

On Wed, Aug 26, 2026 at 11:30:26AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This test requires metadir not to be enabled, but under certain
> circumstances (aka _scratch_mkfs_xfs trying to be helpful and dropping
> MKFS_OPTIONS) it can get enabled anyway if mkfs.xfs defaults to enabling
> metadir.  Check the fs feature set after formatting and skip the test if
> metadir gets enabled.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  tests/xfs/030 |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tests/xfs/030 b/tests/xfs/030
> index 22fbdb2fdbc999..d0b8f413bb9afd 100755
> --- a/tests/xfs/030
> +++ b/tests/xfs/030
> @@ -72,6 +72,7 @@ else
>  		_notrun "PQuota are enabled, test needs controlled sb recovery"
>  	_scratch_unmount
>  fi
> +_xfs_has_feature "$SCRATCH_DEV" metadir && _notrun "metadir enabled anyway"

Reviewed-by: Zorro Lang <zlang@kernel.org>

>  clear=""
>  eval `_scratch_xfs_db -r -c "sb 1" -c stack | perl -ne '
>  	if (/byte offset (\d+), length (\d+)/) {
