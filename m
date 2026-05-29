Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9050F35B62C;
	Fri, 29 May 2026 04:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780029057; cv=none; b=PhPRbR734kji5UzXnfvn4l2Bn+FffVozJa8OSlmpCxmr70Qf1yLLAL+oIkbPxJeUQKrN08dr/8gnyyBI4LahDyLMWs4jbuciHn2y4kvKF038IaVQNQRcP1zDgnx2ZIb/8AyeGXesWGGO+mxh6ppsQz5pAg452CFucUHuaDgFzus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780029057; c=relaxed/simple;
	bh=nR0sNMeomPmRDTFjnJZawaXlH/LQGYr4CP1PtlY1C5I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZUwHevO1SIN+UEezbzP9SBfW2fgFqzcvhIY5jEM3YWx53JQhQAgQnMIdX7sC681tvLnAF9icu0g1w1i7a/KJZ9fhm9AeMJTCuSsYczkvZodDweV/7kJLwCOpB0q2hGDZ/Yh6yRF2zMxLa3sqD6thggbA+DHFDZtcPjPOa1pDNGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HUZJMAQ4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HUZJMAQ4"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 616A81F00893;
	Fri, 29 May 2026 04:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780029056;
	bh=Y9i3D99952aoMze26KNO+B5RKcPVXLOJ/Le5dJq03VQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HUZJMAQ4JW93nEK7Ak/B7yekzr0L9gilaId6xBXrCVUiqg92v5fqrUBFr8h0m5Oog
	 iA+F1hNKwTjPIft3PnmQJLznIaw3uwRhlW/yO7iC6nc8mrwKxZ11Spi1tT+/ltMTpz
	 7IQPG4fRwkqsLrp7gsjSrEflI1XB+p7SzvOC1/uWggWjXTk/JblEv4qBAS+YJQcAmv
	 1m5mUzzgTHR4ortXnd/whkXqrlJYQ7+pU1pNwuXhBj+kA2rpGXRvx+mxNzirF6cAF+
	 mbVFiwiesQ8295To0Sx1dqDr+Q3kddrBX2CkGYiqz8GDTn65esC1eMNj51RB/Q+2I1
	 Iler0emvl6uXw==
Date: Thu, 28 May 2026 21:30:56 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, zlang@redhat.com,
	hch@infradead.org
Subject: Re: [PATCH v6 04/11] fstests: add _require_unique_f_fsid() helper
Message-ID: <20260529043056.GE6070@frogsfrogsfrogs>
References: <cover.1779939330.git.asj@kernel.org>
 <983ed0f63318c930379ee74220f23aa558c16d51.1779939330.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <983ed0f63318c930379ee74220f23aa558c16d51.1779939330.git.asj@kernel.org>

On Thu, May 28, 2026 at 12:05:35PM +0800, Anand Jain wrote:
> Add a helper to check if the target filesystem supports unique f_fsid
> tracking across cloned or snapshot instances.
> 
> Certain filesystems like XFS, Btrfs, and F2FS ensure unique f_fsid
> identifiers per filesystem instance. However, Ext4 derives its f_fsid
> directly from its superblock UUID, which leads to identical f_fsid
> values on cloned images until the UUID is manually modified by userspace.
> 
> Introduce _require_unique_f_fsid() to allow test cases requiring strict
> f_fsid uniqueness to skip gracefully on unsupported filesystems.
> 
> Signed-off-by: Anand Jain <asj@kernel.org>
> ---
>  common/rc | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index 937f478963b4..5446552aed92 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -6314,6 +6314,27 @@ _require_fanotify_ioerrors()
>  	_notrun "$FSTYP does not support fanotify ioerrors"
>  }
>  
> +# Ext4 derives f_fsid from the superblock UUID, meaning clones share the
> +# same f_fsid until their UUIDs diverge. Conversely, XFS, Btrfs,
> +# and F2FS ensure f_fsid remains unique per filesystem instance (often by
> +# deriving it from the UUID and underlying block device.)
> +#
> +# Across all filesystems, a UUID collision causes libblkid tools to return
> +# non-deterministic device mappings. It is ultimately the responsibility

"device mappings", as in /dev/disk/by-id/$UUID ?

> +# of the userspace utility or use-case to enforce uniqueness when a clone
> +# diverges. For details, see mailing list thread discussions titled:
> +#      "ext4: derive f_fsid from block device to avoid collisions".

How about providing a direct lore link?

--D

> +_require_unique_f_fsid()
> +{
> +	# Skip the test if the filesystem does not enforce unique f_fsids
> +	# natively. Checking this dynamically requires recreating a clone
> +	# layout, so we use a static lookup based on FSTYP.
> +	if [ "$FSTYP" == "ext4" ]; then
> +		_notrun "Target filesystem ($FSTYP) does not guarantee unique f_fsid on clones."
> +	fi
> +}
> +
> +
>  # Computes a percentage of the available space in a filesystem and
>  # returns that quantity in MB. The percentage must not contain a percent
>  # sign ("%").
> -- 
> 2.43.0
> 
> 
