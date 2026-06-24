Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC031EDA0F;
	Wed, 24 Jun 2026 17:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782323046; cv=none; b=rm2UIQsk8Z/JQtRs8kg4N3/VJT9mfIisZKuPOhyiFrAdiS16N0gsKF5b6Ueq+m9m+5+FI7/J05Tc1nAqqCtwCVSYkwxn6HJyWjJvOvWr87sDNyBFGTdVL6V8KyqyjAPSJSnswdToSArRdwuPPDaZMW94qzHq6gj/Dbk95p+opoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782323046; c=relaxed/simple;
	bh=ejFr/WxL7j84oEJrJ7vPadBIqFQuXa6rjbGKo8YgsDU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HXOu5ke7WprvcuCG8YDtHJ+hHWdQUI2F/Tui2cSPEJHyV8mZ9nWQvVdlISMVasYzj8GI74vadOIXccklGt5IirQ/lFnPOhtvEWWgsj1sneId6YaIT2foXsGK2xh5LImmpE1Q4R84fHnqVrJgCB264JgOHvWLYZB/ELCz7zCKDZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Oz6HVjQ8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Oz6HVjQ8"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A9FF11F00A3A;
	Wed, 24 Jun 2026 17:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782323044;
	bh=WfK2N2oJ3+2u8ky1p9lFxKQAgmuLNyiZ0yVYPK0yXjk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Oz6HVjQ8r33PR4253lkslWCPbsuyQsRTiWn1cXDwpUpN5s9QLMvANKg69hv0XWNKL
	 78+kf2Pg0prHjCCw9CuOR2IdGoDDqvspVUVvG+C2+HoxrKAQeddEXdKH2HRrleNwoz
	 oH0thQMjx1UFWYdBQQhX5fXb7deKweu7CFusp/TcrOCyK36wXvImoBk1B376ILi9XR
	 PX2FJFq/gvTuA6BMBcCBceIlzAx2NTLpjeOX0hahJOF/deCDniPAiaq/wxo1TcD5rS
	 Jrf+VcgTx7oZfTMaNEJsQBT7IG/PDL68taoul2Ar0BVfp/vTkKgic1OvKLc2F/Ebad
	 T4r38I5pm8bQg==
Date: Wed, 24 Jun 2026 10:44:04 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, Lukas Herbolt <lukas@herbolt.com>,
	Eric Sandeen <sandeen@sandeen.net>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs/216: disable all concurrency scaling
Message-ID: <20260624174404.GS6078@frogsfrogsfrogs>
References: <20260619050937.444488-1-hch@lst.de>
 <20260619050937.444488-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260619050937.444488-3-hch@lst.de>

On Fri, Jun 19, 2026 at 07:09:29AM +0200, Christoph Hellwig wrote:
> This test currently disables log concurrency scaling, but even the
> data device concurrency scaling can create mismatching output on
> systems with a large CPU count.
> 
> Reported-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Tested-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---
>  tests/xfs/216 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/xfs/216 b/tests/xfs/216
> index 1749647c11f7..ce8bb528410b 100755
> --- a/tests/xfs/216
> +++ b/tests/xfs/216
> @@ -23,7 +23,7 @@ _cleanup()
>  _require_scratch
>  _scratch_mkfs_xfs >/dev/null 2>&1
>  if _scratch_mkfs_xfs_supports_concurrency -l >> $seqres.full 2>&1; then
> -	loop_mkfs_opts="-l concurrency=0"
> +	loop_mkfs_opts="-d concurrency=0 -l concurrency=0 -r concurrency=0"

/me notes that -lconcurrency is not compatible with -llogdev and the
loopdev is not formatted with SCRATCH_MKFS_OPTIONS, so this won't work
to disable the concurrency= mkfs options if fstests is being run with
SCRATCH_LOGDEV set.

--D

>  else
>  	loop_mkfs_opts=""
>  fi
> -- 
> 2.53.0
> 
> 
