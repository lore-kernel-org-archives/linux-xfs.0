Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 723522F1FD7;
	Thu,  4 Jun 2026 14:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780584876; cv=none; b=PF6/dHl53o1wCEcJT/vgRa7dVV8bbRtk21QL+RomVjCksfboX6bIQLeyPXAMSgXP7pAnh4SzWXJ/aRMBd3FUQJ/FAYQg5YyG/dColpxUNez2xRg7zNbHDak/3tOtLQI82sx3qYwwhC/q01ra9LkTOu+k0d7BkF9pbZBilpGUPpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780584876; c=relaxed/simple;
	bh=eZQRnc2hngZ8wZTdYUmztz3eLlRj5DpKU3KAT1prh34=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZwOMqTiWVx3rRO6Bt5VLs4fexIhDOdYCSxfJWepllHhCxqv68cb1CJv+/oPzDyDJWP/2TmK1S68SDrm+BQOfv27b6bZ9tYDaR2ukYaOb+GjokEBjtfpXwygWnd63CZqbmRj6GQkrAnM+F4J+Yew0TUWAgZLRe/bpC8qLAy+EFRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oA8lYKdm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oA8lYKdm"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 2AF7F1F00893;
	Thu,  4 Jun 2026 14:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780584875;
	bh=IAsgpmL47mR1epNw0yHyfkb7zo+DMc2V/DOQZzwoZys=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oA8lYKdmVj4O8OKPmDRk/Gel34yIO6a/0WjHpmUbNTnUSm5Mz/9UhQx4QlTuWfTBh
	 gY2qUwSd+LZNPNofF51uJx+0CUImWBzktq47Y0/Bc5mHLiR1pxFDjqpW0mtu8lmQY/
	 ZxP7JlGTK4m8NY2gv1AhflL6h8LTBYKa4JI+E3w7sWvI7aR1sact44eInzGva3b12i
	 VcJxSCP9Vypyo88XrkvVP7rlHgGc26cEr7fUhG2jaYSvKcXDsG5sVPa6jJ6etuQEbQ
	 Hxb5/e78epCZiS7qJto1RWsLIsjk1RVyyKns6AKvDqPggK8Uj9i+QsE5Pr2HIlbI1k
	 EBgeFcQibgMng==
Date: Thu, 4 Jun 2026 07:54:34 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Disha Goel <disgoel@linux.ibm.com>
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	ritesh.list@gmail.com, ojaswin@linux.ibm.com
Subject: Re: [PATCH v2] common/defrag: skip defrag tests on DAX-enabled
 filesystems
Message-ID: <20260604145434.GG6095@frogsfrogsfrogs>
References: <20260604122305.39805-1-disgoel@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260604122305.39805-1-disgoel@linux.ibm.com>

On Thu, Jun 04, 2026 at 05:53:05PM +0530, Disha Goel wrote:
> Online defragmentation is not supported on ext4 DAX-enabled filesystems.
> The ext4 defrag ioctl (EXT4_IOC_MOVE_EXT) returns EOPNOTSUPP when used
> on DAX files.
> 
> Add an ext4-specific check in _require_defrag() to skip tests when DAX
> is enabled, avoiding false failures on ext4/301-304, ext4/308, and
> generic/018.
> 
> XFS defrag works with DAX, so this check is ext4-specific.
> 
> Signed-off-by: Disha Goel <disgoel@linux.ibm.com>
> Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> ---
> Changes in v2:
> - Made the check ext4-specific as XFS defrag works with DAX
>   (feedback from Darrick)
> - Use __scratch_uses_fsdax() instead of grepping MOUNT_OPTIONS
> - Removed unnecessary comment as _notrun message is self-explanatory
> 
>  common/defrag | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/common/defrag b/common/defrag
> index 055d0d0e..f17271cd 100644
> --- a/common/defrag
> +++ b/common/defrag
> @@ -6,6 +6,10 @@
>  
>  _require_defrag()
>  {
> +    if [ "$FSTYP" = "ext4" ] && __scratch_uses_fsdax; then

Shouldn't this be:

	ext4)
		__scratch_uses_fsdax && _notrun "..."
		;;

in the case statement below?

--D

> +        _notrun "ext4 online defrag not supported with DAX"
> +    fi
> +
>      case "$FSTYP" in
>      xfs)
>          # xfs_fsr does preallocates, require "falloc"
> -- 
> 2.45.1
> 
