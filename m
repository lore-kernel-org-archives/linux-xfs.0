Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296E1472F9D;
	Tue,  1 Sep 2026 08:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788252360; cv=none; b=OxhA9K9GrI/95ysrij2jqIgjVm77P9/8v6rLoOnqQRhPSQvvUHwcF5JVayDUO8VDJGeqtRkX7iAUqf4PYygHdZZ9N38a3ntireH6CejnQhe4/qMsOUPYhHBPCnQCvPHVTick0gl9t7GKtrP2w1yWD9gLDN3tHUwpHr4VJwSw9iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788252360; c=relaxed/simple;
	bh=BjxTg4IhfudplV8SnkGQzXcV6YRzaCCnbAGFtyzyvCc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OpsbWDwypCjElOukvxj7LX6e14Y5a652IZi+2W51BeIwaUB4iyRrfWGSgrPPUjX+4huTll0i3rTPiSxzD/ZyzyP+QYWR/kUk9HQKvke1JCf5bTzS+AuJZ7F2K5r2WFxZeE4Bdiwso61XsU8z1Q4c177l/EbpLG3ESj/9Lhj5HTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IeXmwpOr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IeXmwpOr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD2EF1F00A3D;
	Tue,  1 Sep 2026 08:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788252358;
	bh=lFIS6lGqKCvC7eYLV0AotPkHS4uLqWAdlegsz5UR5sU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IeXmwpOrurjG+/bNYLfPOYqrrQ4BJ4CwOfkd66+pT/Ia7hWgCVoMHUcR8KZkFSOZ1
	 1uvBk5EHWBFeXEY4tTTacWPCSpJqvam8dgFRP1rsMiCzylsEczdaTe+r3jnh2schJH
	 s3hZ3XCK9uX8cQUeOrRnt6AAyjIMaVw2q49lQVE0+DxTUpqjD4J/paBDl8QuZZb8op
	 ho4CFld9flIxaqzNgMGUFXsY08hR2aMu5ByHMNIc0TjO5DqJEl4h6nHMYPkyboO7Bb
	 FBpRxKwnp8AlahF88WvVc1j12s2zoAA5K2q4bpBaBuNnfBGm7ldhUxwLsLN+BiSrZW
	 cqU7iiDglqoRQ==
Date: Tue, 1 Sep 2026 20:39:57 +0800
From: Zorro Lang <zlang@kernel.org>
To: Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, djwong@kernel.org
Subject: Re: [PATCH v8 02/13] fstests: add _clone_mount_option() helper
Message-ID: <apbGwZODzZIvOyi0@zlang-mailbox>
Mail-Followup-To: Anand Jain <asj@kernel.org>, fstests@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, djwong@kernel.org
References: <cover.1784949154.git.asj@kernel.org>
 <75ceae4b427ab53c921af395854794b78d7e07a9.1784949154.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75ceae4b427ab53c921af395854794b78d7e07a9.1784949154.git.asj@kernel.org>

On Sat, Jul 25, 2026 at 03:38:59PM +0800, Anand Jain wrote:
> Adds _clone_mount_option() helper function to handle filesystem-specific
> requirements for mounting cloned devices. Abstract the need for -o nouuid
> on XFS.
> 
> Signed-off-by: Anand Jain <asj@kernel.org>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  common/rc | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index e8ff5be0c547..53e5d9d43af6 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -414,6 +414,19 @@ _scratch_mount_options()
>  					$SCRATCH_DEV $SCRATCH_MNT
>  }
>  
> +# Return filesystem-specific mount options required for mounting clone/snapshot
> +# devices.
> +_clone_mount_option()

Just a minor nitpick :) For consistency with other *_mount_options functions
(in common/rc), I suggest using "options" instead of "option" -- _clone_mount_options

> +{
> +	case "$FSTYP" in
> +	xfs)
> +		# Allow mounting a duplicate filesystem on the same host
> +		echo "-o nouuid"
> +		;;
> +	*)
> +	esac
> +}
> +
>  _supports_filetype()
>  {
>  	local dir=$1
> -- 
> 2.43.0
> 
