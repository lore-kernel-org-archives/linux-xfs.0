Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BFA8459AEE;
	Tue,  1 Sep 2026 20:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788296004; cv=none; b=l4VrbkxD1lXPAETcT1kWYwnFWs7YcoQvEm1icyvhs0fTSJxKHrIft9w3Q0PGleHnQOReyUt2EDkEH5deTtSKXaoX5AT89VAGD+xysE1tY//7PSlWyky+rW7cHzXtUCi2ULrvlsmaLzH3pzz57o/1CO8cZJWiJI3Mx8ZWpOmqIeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788296004; c=relaxed/simple;
	bh=fsYlNc3aJtYU7njgkrPguDCirbhJxKrFstSWZUR8/eg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YIQobj6w3utp0rNnmPe2u7S1xJjktksfsDrdaRMfuYDR0atDyhjVjHENl128E1mFmLS6XdfdpNPOEKz2LFfMZGm568xCQ2oP+28Hvcjxv7iHukEcIqzAtQvXOOx2jmeHinLxDSXW2Ur66t1EisGG0KpQ6t9D8rVDXKmLaowBNd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LUKDwbUi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LUKDwbUi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFEE41F000E9;
	Tue,  1 Sep 2026 20:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788296003;
	bh=d+QoObKvn/jjIcgnDWLOeeDC/v3Jvf6TBEqFVZ09LX0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LUKDwbUi/br3OChyeR1SZJcm+9N0lq/0iaPuCV++ToeoebBS2gk1SZYTHU94UXAuo
	 ua9bSe3rXCyTRY/Jd5QmMJlfWlKtpo56meYjYh2i+/gpWdGexubauiw2CXjAJucEQZ
	 TzAYAj5YdP/iDSuxr3Mu4GeUF36pUcduUvXR8gChO5dMy8SN3p/M4FEG7m8olHV6rU
	 HuiXdDPG1jp97uw+ra7/Fb/swfdlaKnb0iS77S+cv7ROIOofFnX5v3i3RZZhl9sUq6
	 8diMDBY6/9GK76kX9pnmg4ad+ht42KGK8H2cVvQDt3tXQkwVnNRDA9oZzNDBq1iTvt
	 t9i+byvFmso2Q==
Date: Wed, 2 Sep 2026 04:53:17 +0800
From: Zorro Lang <zlang@kernel.org>
To: Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, djwong@kernel.org
Subject: Re: [PATCH v8 12/13] fstests: add _change_metadata_uuid helper
Message-ID: <apc6wRjPnQZNYfxV@zlang-mailbox>
Mail-Followup-To: Anand Jain <asj@kernel.org>, fstests@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, djwong@kernel.org
References: <cover.1784949154.git.asj@kernel.org>
 <8d69567fb5700c5a4075509bd7272d02ce9ba4f5.1784949155.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d69567fb5700c5a4075509bd7272d02ce9ba4f5.1784949155.git.asj@kernel.org>

On Sat, Jul 25, 2026 at 03:39:09PM +0800, Anand Jain wrote:
> _change_metadata_uuid changes the UUID of the golden filesystem before it
> is cloned.
> 
> Signed-off-by: Anand Jain <asj@kernel.org>
> ---
>  common/rc | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index f73251365a60..45cf9360ba73 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -1533,6 +1533,29 @@ _scratch_resvblks()
>  	esac
>  }
>  
> +# Change the metadata UUID of the given device to a newly generated one.
> +# Args:
> +#   $1: Block device path to modify.
> +_change_metadata_uuid()
> +{
> +	local temp_mnt=$TEST_DIR/${seq}_mnt
> +	local dev=$1
> +
> +	case $FSTYP in
> +	xfs)
> +		_require_command "$XFS_ADMIN_PROG" "xfs_admin"
> +		$XFS_ADMIN_PROG -U generate $dev >> $seqres.full
> +		;;
> +	btrfs)
> +		_require_command "$BTRFS_TUNE_PROG" "btrfstune"

How about split this function to _require_metadata_uuid_tool and
_chanage_metadata_uuid ?

> +		$BTRFS_TUNE_PROG -m $dev
> +		;;
> +	*)
> +		_notrun "Require filesystem with metadata_uuid feature"
> +		;;
> +	esac
> +}
> +
>  # Create a small loop image, run an optional tuning function ($2) on it,
>  # clone it, and attach both to loop devices, returned in ($1).
>  # Args:
> -- 
> 2.43.0
> 
