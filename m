Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA524372EED;
	Fri, 29 May 2026 04:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028915; cv=none; b=urZaJGxv2R9o1QBdEU69VOnsJCmPcFZPCWxJujRoVWCixeO+SCwYozTRUhGbEMGwHRYWMp+9Rf/EZfAAwJjRX8XjNgZYfuQFJhtgTgfwzSFVlMFuxtJMS067nlJNuDfKpF99KBjBwq3Th1KmsAmSl4bbO8777dnIGSquMDuwgJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028915; c=relaxed/simple;
	bh=EKeyW4AGrWob2re7R8DxVgJ5FGGbaTkvE1syjS/vu6M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jh/tJ1un43XBtaAyjE7KW5gm74seYeiInvv8ZaZhhr8Qpc70rlw7P6IPlTZwP5C6ceqSU502s6zbxG5LgY0T40vROOxYOGefa5a2hl2b1WyyjaO4nPd3iSuU6w53+EyNNOkyrn04LcGs+hatHwUctpmmihD0vpDs2ESzEhgiAAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ktoODV5N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ktoODV5N"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 864311F00893;
	Fri, 29 May 2026 04:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780028914;
	bh=wRctoKAgX9QtpEjOGF4s9Ij+G4pcLZbM0Ees5Bf9rm0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ktoODV5N3m38PfT8oqUGjKpftZHxx3Kb1FjInuJjh7HMS/LpoDMy/2F5ZJgoDGTWS
	 0deLsrOFBI1fXu1Lu5KRUTnhWPLNFvfP6F8hAcG0rXBTgL2TW2+XunxF/8SH2bZI4+
	 nELHYQmvNgtT7RyZabk4UsRKcDnYo/DqOoPeBuiwGnF0lG/f01QsPkq+Sqi2qBAdoI
	 H/tK/04yNDEbbzN02IaahoDwLZsoWyjo7dy/Fb1BdN45tjStgzZtriF6qc+6P1PDgR
	 u9EfRfwdpeaCyoE+ETX7Qnz3zV5nIva2L4ZQ5Pb8UPzoXfO0Co08sjaC7Y4G2/j9X/
	 eciXGRd0qiIiA==
Date: Thu, 28 May 2026 21:28:34 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, zlang@redhat.com,
	hch@infradead.org
Subject: Re: [PATCH v6 02/11] fstests: add _clone_mount_option() helper
Message-ID: <20260529042834.GC6070@frogsfrogsfrogs>
References: <cover.1779939330.git.asj@kernel.org>
 <4346c80089c61c8f0d62ea696f9d73f2a9669297.1779939330.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4346c80089c61c8f0d62ea696f9d73f2a9669297.1779939330.git.asj@kernel.org>

On Thu, May 28, 2026 at 12:05:33PM +0800, Anand Jain wrote:
> Adds _clone_mount_option() helper function to handle filesystem-specific
> requirements for mounting cloned devices. Abstract the need for -o nouuid
> on XFS.
> 
> Signed-off-by: Anand Jain <asj@kernel.org>
> ---
>  common/rc | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index d7e3e0bdfb1e..937f478963b4 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -414,6 +414,23 @@ _scratch_mount_options()
>  					$SCRATCH_DEV $SCRATCH_MNT
>  }
>  
> +# Return filesystem-specific mount options required for mounting clone/snapshot
> +# devices.
> +_clone_mount_option()
> +{
> +	local mount_opts=""
> +
> +	case "$FSTYP" in
> +	xfs)
> +		# Allow mounting a duplicate filesystem on the same host
> +		mount_opts="-o nouuid"
> +		;;
> +	*)
> +	esac
> +
> +	echo $mount_opts

I probably would've just echo'd straight from inside the case statement,
but this otherwise looks ok,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> +}
> +
>  _supports_filetype()
>  {
>  	local dir=$1
> -- 
> 2.43.0
> 
> 
