Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB6A3B667;
	Sat, 17 May 2025 04:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747454973; cv=none; b=gtsybh2WJs1+dfqccQS8Thtga0a611zemkccKt8FFnR0ucL3OIZENioCsb10UL9R5hhFmsI2ozybHqe0kC90hIj+GBRenh/e5xIdBJyP23o2Y7mg6ToJVxMHYRaiWAgt8ewuDCPSo5fswBcx0O38CLBUvDCkGWSUjNUP+VhmlFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747454973; c=relaxed/simple;
	bh=nOYpbFyFfguhjQkZXsOrL0sAdNhtF2JFF+bG1jHgN8A=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References; b=C4y8JcVpr/ClrSOnPKYhpaUWCNFkzhMMmqXy/wW+1PbVlzZj43oxGhHE0wGu4FYsKHkXGkfzADY+RngEO3GKSpK67fVBDN1mwev3yWKBuwkac+eIuqnf6ReLX1RGvLEKlRKTetAs7H9eqx+yH57K/QyZnRKhZkPaY0aduTFOkYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hvOR7EEQ; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hvOR7EEQ"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-30e8feb1830so896461a91.0;
        Fri, 16 May 2025 21:09:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747454971; x=1748059771; darn=vger.kernel.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/MoAOIru3NwxI+5SbSwYhOYJqiAcc6owuKq/r9ybc+I=;
        b=hvOR7EEQdQJAkPwtSPMBddsyHRIillskVg4BLHmEmm6NIMs/hFH5ib+KIWg2kGPa+u
         8WELIN45XBf4sa/RrTsL2n+kMgZbM86KWDXwHZmsYcB3XEfg5Nv+T7dYOhuboivIDmAQ
         zJL4OdORh7V+Fk6SGlQDkLW/oOOIcDHeduPF2dN9durgrjcUMz5igkxAMgla6qxLGEry
         4YeuqSph1GEmGc/ZHeT6/i5QgjFH73An7+AR6e6G2QJ4uMg3O2j6VglNp+QeuvKRRwdv
         Q7dYRnLXa6MLrYWCdH3cUEfzGNryDdOC9cF3Hk+XuTurI2QnlC3kZBdi+zhNrV4az3BL
         CMJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747454971; x=1748059771;
        h=references:message-id:date:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/MoAOIru3NwxI+5SbSwYhOYJqiAcc6owuKq/r9ybc+I=;
        b=NVTwMb5Hq8OSpyQCNjEcyH/OodCmeyoPsVkHAoPJ2vLcnFXItnQAAz6ElfM6p1nXFN
         Ox+AbYR6ghO3LWlVhs6AqV0xiDUWcwStDzUPjEg6u2mpzkLmSqZ7rX4CmC5jGVpaDkQ7
         BKRI57M2UIH/KcYtAAAFTV7Sxhw/a/+mdgbaw1L0xP+woHTYtVpj9NMLUsmdZLCy4PYp
         R0V6HDO5E7Bdvz/JMq5ysR3dGGO5alZio1wYOVfCnoR3Ywvgs0zSwCKGAnVmCgjm2wUx
         sYvp2XdzvmL0ACrdtO5OSTChFlsAdvxmd1VwL4sW65m7eQpFM+KJesMaiPXBnwSZbrii
         PuhA==
X-Forwarded-Encrypted: i=1; AJvYcCU+oBPTu2dD5HLxOd4+E4vB+/lXuBCvK1r6r2CFIfbi9Kci5vFdBZO1/dXxGQPX+84HuZGvZHmi@vger.kernel.org, AJvYcCUv1lDQmw2NKbMsAE8NkVWRb86zFYQCYD6e1YJC/YbVzRdF2Xy89WNaxW5PnJizTsRvs3UA/Q9X45C7@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6kFBgjS+s8TWlY+LiwRZ7SZooThDnT05EEnfy5wE3WOOJ4GRx
	hq9AgH6pKNilkrdspyNCc/dU0hZ/QY1EnZ+qEm28vBo5Xrp7YCdKm8JYefOfXg==
X-Gm-Gg: ASbGnctDpBDov2E/bGSObu63bWhAqUlTEsuca5k0onJjVu4Xb34bE6TmQZt4o1yylUF
	ihzpEaXvK8JctzUNUuOGrYn+D1DYCuAYtZWzAXRfC/MguuWbRgS6p5QVdWd3ShpVPZJSqf4gF7R
	AcuTepNSH2dffbY4gUFVSN6uKP3GaHuIGtwk05HQQQ8sJRGrLugDt+rZWVN3l+OZR40OcNadtC1
	IJOM0wikeMyzeE6aqyc1ist1OaP2i/4o+SykA+sHgZWeXZB3fL+o26uYIDdsTPIx74L1fOktE1k
	xTwTkaqxpxQV1k9YLaPUflWQckzGHvuNpo6sHVo1i8A=
X-Google-Smtp-Source: AGHT+IHPfy56YGrLxUd9pQNm0q6msDpttbks91yWa34o7n2PDRV9/O5cewSo6j70fLA563oMXximAA==
X-Received: by 2002:a17:90b:1648:b0:2ff:698d:ef7c with SMTP id 98e67ed59e1d1-30e7d5bd935mr8691846a91.29.1747454970884;
        Fri, 16 May 2025 21:09:30 -0700 (PDT)
Received: from dw-tp ([171.76.82.96])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b26eaf5c6b0sm2347634a12.7.2025.05.16.21.09.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 May 2025 21:09:30 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Catherine Hoang <catherine.hoang@oracle.com>, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc: djwong@kernel.org, john.g.garry@oracle.com
Subject: Re: [PATCH 4/6] common/atomicwrites: adjust a few more things
In-Reply-To: <20250514002915.13794-5-catherine.hoang@oracle.com>
Date: Sat, 17 May 2025 09:29:13 +0530
Message-ID: <87ecwnx4z2.fsf@gmail.com>
References: <20250514002915.13794-1-catherine.hoang@oracle.com> <20250514002915.13794-5-catherine.hoang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

Catherine Hoang <catherine.hoang@oracle.com> writes:

> From: "Darrick J. Wong" <djwong@kernel.org>
>
> Always export STATX_WRITE_ATOMIC so anyone can use it, make the "cp
> reflink" logic work for any filesystem, not just xfs, and create a
> separate helper to check that the necessary xfs_io support is present.
>
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> ---
>  common/atomicwrites | 18 +++++++++++-------
>  tests/generic/765   |  2 +-
>  2 files changed, 12 insertions(+), 8 deletions(-)
>
> diff --git a/common/atomicwrites b/common/atomicwrites
> index fd3a9b71..9ec1ca68 100644
> --- a/common/atomicwrites
> +++ b/common/atomicwrites
> @@ -4,6 +4,8 @@
>  #
>  # Routines for testing atomic writes.
>  
> +export STATX_WRITE_ATOMIC=0x10000
> +

Finally we have this exported. Thanks for doing this :)

The changes looks good to me. Please feel free to add:
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

>  _get_atomic_write_unit_min()
>  {
>  	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
> @@ -26,8 +28,6 @@ _require_scratch_write_atomic()
>  {
>  	_require_scratch
>  
> -	export STATX_WRITE_ATOMIC=0x10000
> -
>  	awu_min_bdev=$(_get_atomic_write_unit_min $SCRATCH_DEV)
>  	awu_max_bdev=$(_get_atomic_write_unit_max $SCRATCH_DEV)
>  
> @@ -51,6 +51,14 @@ _require_scratch_write_atomic()
>  	fi
>  }
>  
> +# Check for xfs_io commands required to run _test_atomic_file_writes
> +_require_atomic_write_test_commands()
> +{
> +	_require_xfs_io_command "falloc"
> +	_require_xfs_io_command "fpunch"
> +	_require_xfs_io_command pwrite -A
> +}
> +
>  _test_atomic_file_writes()
>  {
>      local bsize="$1"
> @@ -64,11 +72,7 @@ _test_atomic_file_writes()
>      test $bytes_written -eq $bsize || echo "atomic write len=$bsize failed"
>  
>      # Check that we can perform an atomic single-block cow write
> -    if [ "$FSTYP" == "xfs" ]; then
> -        testfile_cp=$SCRATCH_MNT/testfile_copy
> -        if _xfs_has_feature $SCRATCH_MNT reflink; then
> -            cp --reflink $testfile $testfile_cp
> -        fi
> +    if cp --reflink=always $testfile $testfile_cp 2>> $seqres.full; then
>          bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile_cp | \
>              grep wrote | awk -F'[/ ]' '{print $2}')
>          test $bytes_written -eq $bsize || echo "atomic write on reflinked file failed"
> diff --git a/tests/generic/765 b/tests/generic/765
> index 09e9fa38..71604e5e 100755
> --- a/tests/generic/765
> +++ b/tests/generic/765
> @@ -12,7 +12,7 @@ _begin_fstest auto quick rw atomicwrites
>  . ./common/atomicwrites
>  
>  _require_scratch_write_atomic
> -_require_xfs_io_command pwrite -A
> +_require_atomic_write_test_commands
>  
>  get_supported_bsize()
>  {
> -- 
> 2.34.1
