Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 022AF32ABFB
	for <linux-xfs@vger.kernel.org>; Tue, 25 Nov 2025 17:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764090296; cv=none; b=tDHOt2shVcPcHhRpgFDo5dNVlOpkQ8bFHjmmY2ZNTI/MXAgXT2+297NaypsHqPcg0njuZbcoJ6HoFDuyE323boSZbzpq/cVhMC5QKN7mFQC+liT5YNKR/mR0s6dSAomnfHY2+VWafURjBlwoGZUT87lvtuMnOnJVM2WvVWdOVEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764090296; c=relaxed/simple;
	bh=6/f4G9+RECdFtNJA6wrAjn54LgIuzN+TwGZS6+/BrBU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e8M2gb3n4YmDtJvuXzz1a0K2e/MYLAC8D0mVMOtp0JUn9cKDy8yHE2rOLX2gZcAQMufHpfWmeLWTIY+6BvjE2CxBlk12Gnh7PixvK3xdJR/C2WqV3b/FNW+uCdE1a1hGkLwAFlmuS3yb+uQyC63fxsW7ibQXd4NlhIuRDpg4enk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=relhqnst; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="relhqnst"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 777F7C4CEF1;
	Tue, 25 Nov 2025 17:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764090295;
	bh=6/f4G9+RECdFtNJA6wrAjn54LgIuzN+TwGZS6+/BrBU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=relhqnstlEISlov0IgRJvLMvoZuug0DjOA51yEVNA4jmFmZZkGnCg+seW3CeE/yBp
	 +QDuNucwLnDUngu0MITKm5KuIZ9OyH5NQw1E7kqabNkSj8qKjF/vNiweIKcd4BC4t6
	 phpJd2huDnu73Y64fep4+K0fOWKPmMUe7CcqErVXBbe15THuo5U6DrFaWWc9YewtBF
	 z2FQ25LLU9l719QxCeHC/OOgTfKEf3tgyuq0Wsk72ZzURL7q/fXJLQnozMtPQ1IIkp
	 djhi1MpjbVJiv1FbNnmF0E0eD8x9C6SLya+S8m2rHDyFPr+2qBqZz3ycJpnrCGgJXa
	 Voxsw8eIlcHSA==
Date: Tue, 25 Nov 2025 09:04:54 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs : Fix potential null pointer dereference in
 xfs_exchmaps_dir_to_sf()
Message-ID: <20251125170454.GF23418@frogsfrogsfrogs>
References: <20251125142205.432890-1-chelsyratnawat2001@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251125142205.432890-1-chelsyratnawat2001@gmail.com>

On Tue, Nov 25, 2025 at 06:22:05AM -0800, Chelsy Ratnawat wrote:
> xfs_dir3_block_read() can return a NULL buffer with no error, but
> xfs_exchmaps_dir_to_sf() dereferences bp without checking it.
> Fix this by adding a check for NULL and returning -EFSCORRUPTED if bp is
> missing, since block-format directories must have a valid data block.

How did you encounter this bug?  Did you hit it in production?  syzbot
report?  Something else?

Also, are there similar functions in xfs_exchmaps.c that suffer from the
same problem?

> Signed-off-by: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>

Cc: <stable@vger.kernel.org> # v6.10
Fixes: da165fbde23b84 ("xfs: condense directories after a mapping exchange operation")

--D

> ---
>  fs/xfs/libxfs/xfs_exchmaps.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_exchmaps.c b/fs/xfs/libxfs/xfs_exchmaps.c
> index 932ee4619e9e..e33a401d9766 100644
> --- a/fs/xfs/libxfs/xfs_exchmaps.c
> +++ b/fs/xfs/libxfs/xfs_exchmaps.c
> @@ -475,6 +475,9 @@ xfs_exchmaps_dir_to_sf(
>  	if (error)
>  		return error;
>  
> +	if (!bp)
> +		return -EFSCORRUPTED;
> +
>  	size = xfs_dir2_block_sfsize(xmi->xmi_ip2, bp->b_addr, &sfh);
>  	if (size > xfs_inode_data_fork_size(xmi->xmi_ip2))
>  		return 0;
> -- 
> 2.47.3
> 
