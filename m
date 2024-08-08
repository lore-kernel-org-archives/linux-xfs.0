Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0858478C98
	for <linux-xfs@vger.kernel.org>; Thu,  8 Aug 2024 18:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723141715; cv=none; b=mRc/8m5MN2IHl8OsxCHmf0hGxQQ0Jo6HuJ4Fdtl94/URMCllUOYOroriCTcxqRRmLaLIHMh8eo43nzKzK1WBDXhLQ5abBODPMx7h7eg3NeGfC/vlYYd1vXV3uuq3rccW/ELpHOv723o2HwO15gQtlc1p6JsG4JBk55/XjJPBKEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723141715; c=relaxed/simple;
	bh=bYPUynvx1Lbld6kHuZmyJcDCFe18TpBgNA23Ai411EI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nmHLXGdVOYMzSS7x5qhRnbtA1HEkyLvbv1fUtxfzI/qEphjw1N6qpOWUw1TMuTRMzfNpBfLLY/t5OHVlJHJc7bXLu0Eeq5TguEAFgJc7Hnp39NgFT6ZFxv2L1SZjydlBuVFh6IwK78XeiXb7V0Di6Lx7W6/iRD4lu89I6cCJjvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VRWbShAZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VRWbShAZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B549C4AF12;
	Thu,  8 Aug 2024 18:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723141714;
	bh=bYPUynvx1Lbld6kHuZmyJcDCFe18TpBgNA23Ai411EI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VRWbShAZz+4nY1MTCo5VGKOXVaypxiD8BIkexgFNJJqjf9Wy5e9IMX420GEG7ED8F
	 pJDi+81jPiyzeuzu1r64C7ymSMZwSEVJcSXCeAmL60cHXdB3+arvNOc13JNR7LpHMV
	 sSOzeDLhHjTi8xVGa2jieF6zjUXlaJKemcIUWaovqfrijdVEygrBObhM2roSKPzfPH
	 j7pwYbbHt1hTULnybxWM9TEBXGRmiCESpdkxWAWc5gSceTojMIU+5a/qP9WEqDyCY7
	 TE/hHqlMjeOdwIZxxGga2vkjSrJL0e8T3RI0R9K0fV+ZiEyVCq7okRqQHmBs2VkmTe
	 4EYHBTemtDpkg==
Date: Thu, 8 Aug 2024 11:28:33 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Bill O'Donnell <bodonnel@redhat.com>
Cc: linux-xfs@vger.kernel.org, sandeen@sandeen.net, cem@kernel.org
Subject: Re: [PATCH v3] xfs_db: release ip resource before returning from
 get_next_unlinked()
Message-ID: <20240808182833.GR6051@frogsfrogsfrogs>
References: <20240807193801.248101-3-bodonnel@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240807193801.248101-3-bodonnel@redhat.com>

On Wed, Aug 07, 2024 at 02:38:03PM -0500, Bill O'Donnell wrote:
> Fix potential memory leak in function get_next_unlinked(). Call
> libxfs_irele(ip) before exiting.
> 
> Details:
> Error: RESOURCE_LEAK (CWE-772):
> xfsprogs-6.5.0/db/iunlink.c:51:2: alloc_arg: "libxfs_iget" allocates memory that is stored into "ip".
> xfsprogs-6.5.0/db/iunlink.c:68:2: noescape: Resource "&ip->i_imap" is not freed or pointed-to in "libxfs_imap_to_bp".
> xfsprogs-6.5.0/db/iunlink.c:76:2: leaked_storage: Variable "ip" going out of scope leaks the storage it points to.
> #   74|   	libxfs_buf_relse(ino_bp);
> #   75|
> #   76|-> 	return ret;
> #   77|   bad:
> #   78|   	dbprintf(_("AG %u agino %u: %s\n"), agno, agino, strerror(error));
> 
> Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>
> ---
> v2: cover error case.
> v3: fix coverage to not release unitialized variable.
> ---
>  db/iunlink.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/db/iunlink.c b/db/iunlink.c
> index d87562e3..57e51140 100644
> --- a/db/iunlink.c
> +++ b/db/iunlink.c
> @@ -66,15 +66,18 @@ get_next_unlinked(
>  	}
>  
>  	error = -libxfs_imap_to_bp(mp, NULL, &ip->i_imap, &ino_bp);
> -	if (error)
> +	if (error) {
> +		libxfs_buf_relse(ino_bp);

Sorry, I think I've led you astray -- it's not necessary to
libxfs_buf_relse in any of the bailouts.

--D

>  		goto bad;
> -
> +	}
>  	dip = xfs_buf_offset(ino_bp, ip->i_imap.im_boffset);
>  	ret = be32_to_cpu(dip->di_next_unlinked);
>  	libxfs_buf_relse(ino_bp);
> +	libxfs_irele(ip);
>  
>  	return ret;
>  bad:
> +	libxfs_irele(ip);
>  	dbprintf(_("AG %u agino %u: %s\n"), agno, agino, strerror(error));
>  	return NULLAGINO;
>  }
> -- 
> 2.45.2
> 
> 
