Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 108D122615
	for <linux-xfs@vger.kernel.org>; Tue, 15 Apr 2025 17:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744736878; cv=none; b=F3vtWOXixPVhZSNIlyJSkpiUQdkUjNsICIx7KuuYBt7c7dTCkcIeJXilivCsMQ+PTLqgI0y+sTE0c9IrzhLcyF2v0a9Med2aUQ4VaqjUoCuCDH4/fEzKC/C4hwgr8B6krxPiw/+qLjkVYwjdkXE7lcDZS1KGvdDMUkF0kU7zQEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744736878; c=relaxed/simple;
	bh=jLOwrvpm6BlYvcV0FvwSm0WSLnz9abs6G0c56k2mHsE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fffjezJTpKHna/QeDapN+PpOg73Vs6yEz9CiBWQ3bXmioxg5sTOeMwIEl1WHm7WeC+G7kGsOJm46IyTBvxf8Lpe/n/TZ64iIPrWRF2and1e/3GVLZzTMAjmgLMFvV2D4xuKBBPWiszm2ba8PXEzyUIpu5sfAZu9eSXF16kVjWno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k0Pk/YNc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k0Pk/YNc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA9E5C4CEE9;
	Tue, 15 Apr 2025 17:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744736877;
	bh=jLOwrvpm6BlYvcV0FvwSm0WSLnz9abs6G0c56k2mHsE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=k0Pk/YNcNiQwG/kRVL2j/XAV+O/CDrdMM9CF8dRUliP9MS0nI9tsax9JiU3Mc8og3
	 Isl3eoe3+hrSFVuzb0QW2P0ybPpSpGR94+Mp3so/85E6VR6uywpGw67g3cCiV0TAmX
	 ndc5n+APZ5eCAtP8iL6RfEM1LO41JL+SYPU7u9RHm5E0f3m2q5rEi6OhBflXh5cxaJ
	 QDM5icaB/Oc+z14QaQmCjQLG6zC2I0NHhqt+x3SvVzW7vk1KwfVaw5/MN8jISk9SVX
	 dF3SGySnQ+jYY5ElphjGJLZZYjDhvqIZkAJ1P5ZLzu4+okDwejQcIWN+/PC/LMXe+Z
	 /GoOBc+T3njig==
Date: Tue, 15 Apr 2025 10:07:57 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: bodonnel@redhat.com
Cc: linux-xfs@vger.kernel.org, sandeen@sandeen.net
Subject: Re: [PATCH v2] xfs_repair: fix link counts update following repair
 of a bad block
Message-ID: <20250415170757.GT25675@frogsfrogsfrogs>
References: <20250415150103.63316-2-bodonnel@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250415150103.63316-2-bodonnel@redhat.com>

On Tue, Apr 15, 2025 at 10:01:04AM -0500, bodonnel@redhat.com wrote:
> From: Bill O'Donnell <bodonnel@redhat.com>
> 
> Updating nlinks, following repair of a bad block needs a bit of work.
> In unique cases, 2 runs of xfs_repair is needed to adjust the count to
> the proper value. This patch modifies location of longform_dir2_entry_check,
> moving longform_dir2_entry_check_data to run after the check_dir3_header
> error check. This results in the hashtab to be correctly filled and those
> entries don't end up in lost+found, and nlinks is properly adjusted on the
> first xfs_repair pass.
> 
> Suggested-by: Eric Sandeen <sandeen@sandeen.net>
> 
> Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>
> ---
> v2: add logic to cover shortform directory.
> 
> 
>  repair/phase6.c | 20 +++++++++++++++++---
>  1 file changed, 17 insertions(+), 3 deletions(-)
> 
> diff --git a/repair/phase6.c b/repair/phase6.c
> index dbc090a54139..8fc1c3896d2b 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -2426,6 +2426,23 @@ longform_dir2_entry_check(
>  
>  		/* check v5 metadata */
>  		if (xfs_has_crc(mp)) {
> +			longform_dir2_entry_check_data(mp, ip, num_illegal,
> +				need_dot,
> +				irec, ino_offset, bp, hashtab,
> +				&freetab, da_bno, fmt == XFS_DIR2_FMT_BLOCK);
> +			error = check_dir3_header(mp, bp, ino);
> +			if (error) {
> +				fixit++;

I think what you're trying to do here is to get
longform_dir2_entry_check_data to try to find directory entries in the
directory block (no matter how damaged it is).  Then if the dir3 header
fields are wrong, we bump fixit so that the directory gets rebuilt from
the salvaged directory entries.  Right?

So I think you could structure this more like:

		/* salvage any dirents that look ok */
		longform_dir2_entry_check_data(...);

		/* check v5 metadata */
		if (xfs_has_crc(mp)) {
			error = check_dir3_header(mp, bp, ino);
			if (error) {
				fixit++;
				if (fmt == XFS_DIR2_FMT_BLOCK)
					goto out_fix;

				libxfs_buf_relse(bp);
				bp = NULL;
				continue;
			}
		}

		if (fmt == XFS_DIR2_FMT_BLOCK)
			break;

		libxfs_buf_relse(bp);
		bp = NULL;
	}

> +				if (fmt == XFS_DIR2_FMT_BLOCK)
> +					goto out_fix;
> +
> +				libxfs_buf_relse(bp);
> +				bp = NULL;
> +				continue;
> +			}
> +		}
> +		else {
> +			/* No crc. Directory appears to be shortform. */
>  			error = check_dir3_header(mp, bp, ino);

dir3 headers (as opposed to dir2 headers) are a crc-only feature, so
this isn't correct either.

>  			if (error) {
>  				fixit++;
> @@ -2438,9 +2455,6 @@ longform_dir2_entry_check(
>  			}
>  		}
>  
> -		longform_dir2_entry_check_data(mp, ip, num_illegal, need_dot,
> -				irec, ino_offset, bp, hashtab,
> -				&freetab, da_bno, fmt == XFS_DIR2_FMT_BLOCK);

and removing this call means that we never scan a V4 directory at all.

--D

>  		if (fmt == XFS_DIR2_FMT_BLOCK)
>  			break;
>  
> -- 
> 2.49.0
> 
> 
