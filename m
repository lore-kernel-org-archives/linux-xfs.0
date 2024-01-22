Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033015BAE1;
	Mon, 22 Jan 2024 16:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705942678; cv=none; b=oh7Myyu/aYJIN1lBYZQyOdWi32OEueVY8V5QuMkhNA5/nH4Ubtd36HcISiV3Kfq/gxLYHQt+4yvJZdZMJPdP7tKjfCQfmz2tgnokNYKg9sOA2jyS6wCZUuf6+r7zhDk1NUbBYCYtK3xDyPAI6eB7fht+Zb9dxNt7YoRYMayBvwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705942678; c=relaxed/simple;
	bh=+0qL4g2PD6NgklavA2+8vHOMVLqgGK3BZjSbk8sJnDU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MOCSg/EuYiAS6epdDeh3XLCPNIlDA4SG+fjNraqj+DCOswY8evUP1zza00h9+mc/G8dtw/rX9Q45zsIxNUhslRTCBvwYInJh9QNLZngUTadC/XpJmQ/XAdDx7GD10zriUVp2TQflClXbpjKixkanLmktGRWBu4TcwzPkfqgBENQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BPcPVVha; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BPcPVVha"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AC42C433C7;
	Mon, 22 Jan 2024 16:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705942677;
	bh=+0qL4g2PD6NgklavA2+8vHOMVLqgGK3BZjSbk8sJnDU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BPcPVVhats8WkLkWp8Pud1RSSu6P/VMpcckV/LB+4UXG36gy8UUeloUA3KGINxWD6
	 yq+u1Uw/GnDMYYRdsWc9Dss9b4Shk78ddth/ozbcz/jA8t5m0qxWDhCrnTv5NeQQY/
	 gc/5vhMyWVr0XEf3q9/FlWZVai7NwUJuHMrBsz3DxadtcfhqDxQeB5eWv29huqoJnS
	 GO3yCrIxTAsmF1ELdeMho7q9SwFCZjGdD3ERjQZQmKqhrw0YSn0XXtFaM9OAECBrMZ
	 7Vd23TNxSpaVOAVPFkA54Rq4j4fcw9C1fL9GBFcdyjCfQR6yKM+tflNWeGV+h961xW
	 nSCj8Sk4IFy1w==
Date: Mon, 22 Jan 2024 08:57:56 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
Cc: zlang@redhat.com, fstests@vger.kernel.org, p.raghav@samsung.com,
	mcgrof@kernel.org, gost.dev@samsung.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs/161: adapt the test case for LBS filesystem
Message-ID: <20240122165756.GB6188@frogsfrogsfrogs>
References: <20240122111751.449762-1-kernel@pankajraghav.com>
 <20240122111751.449762-3-kernel@pankajraghav.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240122111751.449762-3-kernel@pankajraghav.com>

On Mon, Jan 22, 2024 at 12:17:51PM +0100, Pankaj Raghav (Samsung) wrote:
> From: Pankaj Raghav <p.raghav@samsung.com>
> 
> This test fails for >= 64k filesystem block size on a 4k PAGE_SIZE
> system(see LBS efforts[1]). Adapt the blksz so that we create more than
> one block for the testcase.

How does this fail, specifically?  And, uh, what block sizes > 64k were
tested?

--D

> Cap the blksz to be at least 64k to retain the same behaviour as before
> for smaller filesystem blocksizes.
> 
> [1] LBS effort: https://lore.kernel.org/lkml/20230915183848.1018717-1-kernel@pankajraghav.com/
> 
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---
>  tests/xfs/161 | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/tests/xfs/161 b/tests/xfs/161
> index 486fa6ca..f7b03f0e 100755
> --- a/tests/xfs/161
> +++ b/tests/xfs/161
> @@ -38,9 +38,14 @@ _qmount_option "usrquota"
>  _scratch_xfs_db -c 'version' -c 'sb 0' -c 'p' >> $seqres.full
>  _scratch_mount >> $seqres.full
>  
> +min_blksz=65536
> +file_blksz=$(_get_file_block_size "$SCRATCH_MNT")
> +blksz=$(( 2 * $file_blksz))
> +
> +blksz=$(( blksz > min_blksz ? blksz : min_blksz ))
>  # Force the block counters for uid 1 and 2 above zero
> -_pwrite_byte 0x61 0 64k $SCRATCH_MNT/a >> $seqres.full
> -_pwrite_byte 0x61 0 64k $SCRATCH_MNT/b >> $seqres.full
> +_pwrite_byte 0x61 0 $blksz $SCRATCH_MNT/a >> $seqres.full
> +_pwrite_byte 0x61 0 $blksz $SCRATCH_MNT/b >> $seqres.full
>  sync
>  chown 1 $SCRATCH_MNT/a
>  chown 2 $SCRATCH_MNT/b
> -- 
> 2.43.0
> 
> 
