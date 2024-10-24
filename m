Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 836A9200C8C;
	Thu, 24 Oct 2024 18:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793953; cv=none; b=OwRSTdhNf5Qa9vazA3K1Ebu/PySsHKo+f4OJCbvIg+1dO8VIfb1e37uq/gfuZo9/vhknw+061KBejrWWJv86nfMtfsVj3V/MLmlEZ4+Of4sYbc1tGz+XU4JEeJidZP+BWL/JUX2dPExAfgn87os7b5zJYiHublHvdmGun8iDIG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793953; c=relaxed/simple;
	bh=XGl0bNbPhiJLxHiaSH/5RaSWMgNQ4ecVyXTscWaeH08=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ucGBg0aqLbS6SsQ51ltxFQsNReZUUx9VaAh00x90wxy8yxFpGwaWbw1qJ3BY2X0XcK+bE0IVC93VPN25yJ1LEjqU0VsVVNWpV0AE4NLsKSpRhHrOR9G0L3f5iad5oQqI5oJnK7SgvtBOWgnM4U4F2A/0sGkuDXao/Bp1TUuZ4e8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BrRtOFdR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BrRtOFdR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA6D2C4CEC7;
	Thu, 24 Oct 2024 18:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729793951;
	bh=XGl0bNbPhiJLxHiaSH/5RaSWMgNQ4ecVyXTscWaeH08=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BrRtOFdR6FqG+kQM21a5R48w45vYe2GW2vgpz7SfRNpoaTkDK8A9ATY3NevnDFjur
	 XP0G1r8cGClLWnF60Gxay8QomggzJYhltawLRXGNDqZdb14PhEeWHk4SQp4ZmS1e95
	 cB5hKo2crRwjyYBZ6euwA7dMI20iW536pqhymAe2vK3LD/jbBPaqUEAg5upuzStfLH
	 tClt4ZR8NaaCeJsbF3HvrMJiNCaQnIFq+6Ub+Q/WxUwOigXWxpG3sR2lZP5SLAuUzu
	 vGtEhdZ9mh9bpt8D7K4BNLIHzkvJpGQMofOszOVg1Q51sbQzKrvazeI+by/IpbjQ7t
	 nxDnVRchxNexw==
Date: Thu, 24 Oct 2024 11:19:10 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Pankaj Raghav <p.raghav@samsung.com>
Cc: fstests@vger.kernel.org, zlang@redhat.com, linux-xfs@vger.kernel.org,
	gost.dev@samsung.com, mcgrof@kernel.org, kernel@pankajraghav.com,
	david@fromorbit.com
Subject: Re: [PATCH 1/2] generic/219: use filesystem blocksize while
 calculating the file size
Message-ID: <20241024181910.GG2386201@frogsfrogsfrogs>
References: <20241024112311.615360-1-p.raghav@samsung.com>
 <20241024112311.615360-2-p.raghav@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241024112311.615360-2-p.raghav@samsung.com>

On Thu, Oct 24, 2024 at 01:23:10PM +0200, Pankaj Raghav wrote:
> generic/219 was failing for XFS with 32k and 64k blocksize. Even though
> we do only 48k IO, XFS will allocate blocks rounded to the nearest
> blocksize.
> 
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---
>  tests/generic/219 | 18 +++++++++++++++---
>  1 file changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/tests/generic/219 b/tests/generic/219
> index 940b902e..d72aa745 100755
> --- a/tests/generic/219
> +++ b/tests/generic/219
> @@ -49,12 +49,24 @@ check_usage()
>  	fi
>  }
>  
> +_round_up_to_fs_blksz()
> +{
> +	local n=$1
> +	local bs=$(_get_file_block_size "$SCRATCH_MNT")
> +	local bs_kb=$(( bs >> 10 ))
> +
> +	echo $(( (n + bs_kb - 1) & ~(bs_kb - 1) ))

Nit: you can divide here, right?

	echo $(( (n + bs_kb - 1) / bs_kb ))

The rest seems fine.

--D

> +}
> +
>  test_accounting()
>  {
> -	echo "### some controlled buffered, direct and mmapd IO (type=$type)"
> -	echo "--- initiating parallel IO..." >>$seqres.full
>  	# Small ios here because ext3 will account for indirect blocks too ...
>  	# 48k will fit w/o indirect for 4k blocks (default blocksize)
> +	io_sz=$(_round_up_to_fs_blksz 48)
> +	sz=$(( io_sz * 3 ))
> +
> +	echo "### some controlled buffered, direct and mmapd IO (type=$type)"
> +	echo "--- initiating parallel IO..." >>$seqres.full
>  	$XFS_IO_PROG -c 'pwrite 0 48k' -c 'fsync' \
>  					$SCRATCH_MNT/buffer >>$seqres.full 2>&1 &
>  	$XFS_IO_PROG -c 'pwrite 0 48k' -d \
> @@ -73,7 +85,7 @@ test_accounting()
>  	else
>  		id=$qa_group
>  	fi
> -	repquota -$type $SCRATCH_MNT | grep "^$id" | check_usage 144 3
> +	repquota -$type $SCRATCH_MNT | grep "^$id" | check_usage $sz 3
>  }
>  
>  
> -- 
> 2.44.1
> 
> 
