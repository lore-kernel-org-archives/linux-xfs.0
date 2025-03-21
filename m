Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D752322652E;
	Fri, 21 Mar 2025 21:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742592142; cv=none; b=d3eQk7hVA9WQ07qJRgcOCja69lMQQjpbNP4cG0dKR6Dk3OEfR6U4kyQ6ThOc5m8sjIvmWFBrGHuTA+pPUF7n6URQQMXTsaOqYRsRnDUJDf8P4jrJCfc7t934vObHu0d+csIM4c81K0bddQT5qEPso7R4eF23Z1r4u6W75DlsbTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742592142; c=relaxed/simple;
	bh=mXGPLPumpkoZ+j7hLFSFWTi+zo2Pjb7i2QrU1EgFOZM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HuQkL4fL+sjm/kQovSmJZrOX0b19i7/EWKXRfz3cku+02DqvvoofCp3S+RN4ZG/eIMDisLSrcPBZrRW99CF1F1yirTh/xNtLICN7aqdlvMPzZpayJrpcO5bhO8LupPAr7DIZJ8bmxnRcf0LYHN18zvEU/smh7spS2wf1gC+46Ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kzYrUmht; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kzYrUmht"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36FA2C4CEE3;
	Fri, 21 Mar 2025 21:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742592142;
	bh=mXGPLPumpkoZ+j7hLFSFWTi+zo2Pjb7i2QrU1EgFOZM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kzYrUmhtg5Zu3tmGwi9jui/2IjosYd5EaVv4Mz7U3pb67SWLkOnanJTQX13zzsOm5
	 Jpho5LzooS9kHdjy3sR/9agonwhngINGUyfFfAp3RdPcVUSzvCLyzRQEP8tsWoJPL9
	 7EBO3T+DJkXcC+kyx+N2XuMvI7EtqIu6JKIwXdSXrAnIsY3vvV2yOEdmTUBoHaDAgp
	 D3QPyKFe6VERV3tHTLQipiEUyJHltdQkBUrLsWMWEPcd7E7wrknlQ4g2/xupbUgqMR
	 qRvjjMLYHYqA2PrdBkbGAd6xwRGtS9OwXFOUHKSkSPITSng/AbMyiirGyreOjOiLNG
	 DSmN7RaYj/Qrg==
Date: Fri, 21 Mar 2025 14:22:21 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 3/3] check: don't allow TEST_DIR/SCRATCH_MNT to be in /tmp
Message-ID: <20250321212221.GG4001511@frogsfrogsfrogs>
References: <174182089094.1400713.5283745853237966823.stgit@frogsfrogsfrogs>
 <174182089161.1400713.6024925682002640886.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <174182089161.1400713.6024925682002640886.stgit@frogsfrogsfrogs>

On Wed, Mar 12, 2025 at 04:12:04PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If we're running in a private mount namespace, /tmp is a private tmpfs

Since we're dropping privatens for ./check, there's no need for this
patch anymore.  I'll roll up and resend this series without this patch
and with the rvbs that have trickled in since then.

--D

> mount.  Using TEST_DIR/SCRATCH_MNT that point there is a bad idea
> because anyone can write to there.  Let's just stop that.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  check |   14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> 
> diff --git a/check b/check
> index 33eb3e0859e578..09134ee63e41e2 100755
> --- a/check
> +++ b/check
> @@ -815,6 +815,20 @@ function run_section()
>  		echo "SECTION       -- $section"
>  	fi
>  
> +	# If we're running in a private mount namespace, /tmp is a private
> +	# directory.  We /could/ just mkdir it, but we'd rather have people
> +	# set those paths elsewhere.
> +	if [ "$HAVE_PRIVATENS" = yes ] && [[ $TEST_DIR =~ ^\/tmp ]]; then
> +		echo "$TEST_DIR: TEST_DIR must not be in /tmp"
> +		status=1
> +		exit
> +	fi
> +	if [ "$HAVE_PRIVATENS" = yes ] && [[ $SCRATCH_MNT =~ ^\/tmp ]]; then
> +		echo "$SCRATCH_MNT: SCRATCH_MNT must not be in /tmp"
> +		status=1
> +		exit
> +	fi
> +
>  	sect_start=`_wallclock`
>  	if $RECREATE_TEST_DEV || [ "$OLD_FSTYP" != "$FSTYP" ]; then
>  		echo "RECREATING    -- $FSTYP on $TEST_DEV"
> 
> 
