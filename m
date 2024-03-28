Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DEBE1DDF6
	for <linux-xfs@vger.kernel.org>; Thu, 28 Mar 2024 13:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711634357; cv=none; b=Jbf4U6qA5fWOEKr4hdeu0/65eq13TDto/lv7DS7Z0nSSHWykwDSYVQQXKxtchDgqVHWHSIGoYIjMbK3A76d0y4VABYjMqLafwnFFztyQw+f72tV7VYlxn1RNiVs1ICg8KYhx9bSKQpSjUzvgOQX0SmDmrVzaduWwL82zAb0I3RU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711634357; c=relaxed/simple;
	bh=FrXhVwIxVzyq0ZgDLaBAuEeuitKdvqnpieGzNRdchsY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sl3iIcNv7MJJMS7QQH46QIaOO59sQrCI6EbwaNWe81x70xW27iroZganbI1ZUCJMGrhGa6wAYQI6q701moRfL8Bt3T6TKWNTtLAiwnKBk9eBf783dk/lOBapS6XppKxb9H6M05qeGyvPn/KlzPucwdyjGloiYmOP8lfNjidVToA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PJAO1MAW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PJAO1MAW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711634353;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ms2n2zlGo8TxvYk5zuAvnIiwfxjZ7Tedc1VFRaIbiLo=;
	b=PJAO1MAWXs/woXdxmSDokchqsSt04pcueOo0HL+on6LTEIOoPzMqLDjcmrMRdxday605I0
	pUNT2u8MyzGRT1Qf5yaf7E2cVfDK7OBEKzQ9Myr0f66no/mkKru/T5g8/F+0tIejbiKyje
	jXdGlfnogz527U6Yytq8k13rCSvMa7Q=
Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com
 [209.85.160.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-672-d6H5Q_cKMJG-7hLX3XqGGQ-1; Thu, 28 Mar 2024 09:59:12 -0400
X-MC-Unique: d6H5Q_cKMJG-7hLX3XqGGQ-1
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-229fd805944so793600fac.3
        for <linux-xfs@vger.kernel.org>; Thu, 28 Mar 2024 06:59:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711634351; x=1712239151;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ms2n2zlGo8TxvYk5zuAvnIiwfxjZ7Tedc1VFRaIbiLo=;
        b=KDXkBo/rqyv1F3RIJv53gmEPLzkGl1PWv+ropAgOp9PFBmTeXf/jpUuJ1D5bq/v6zR
         1S1cblwJNINTF46WK9UIDbzzZR6e386e4nDXmjqIZopkpZJXFB3XZ5MIn4lw2hRU2ZKU
         IrHpF9uba2auuPVv6OYjP7bu7bC4c/8iBEgJgyI3Tmcg28UynA5MLZ31Kv8lusqVpmYi
         CLu0MQYwt0NGz4sS6+SBupu0WB+Q/ViJ7U6tNOyEUaI6mY5IfqbJe9wWLi/09xE3/z0B
         UOGWR+a56qfIMUiV9alS6Q7AbsKxieGpUraknLM8N1Uicl4fd/Lp+yiIVT3jiKrywcL5
         K58Q==
X-Gm-Message-State: AOJu0Yzk52AQAeN/Rsqo8F6004ZZZE+BewhlAX4UI8wTXz37VFLEmHyH
	c7q/4zwRaL0EyTU/spIAquxA7AnRj0cz0O74avGHgoEKAFaVbUbawiNmegRKLwDGUGrx7u0khvI
	5jK2H6fkB0aZ3mhLT8k1fYG6epAuBVi4/da7iqq/Z6xebNdbq9lazPdO1rg==
X-Received: by 2002:a05:6871:7398:b0:21e:6b95:fb2d with SMTP id na24-20020a056871739800b0021e6b95fb2dmr2765104oac.18.1711634351086;
        Thu, 28 Mar 2024 06:59:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFuKCNVXQDlBgKOT9FwD6UhUOe1IVuWyY7G5vROdusuBrzMlQzfw7uq3JdWI6pJoZZPvspTmg==
X-Received: by 2002:a05:6871:7398:b0:21e:6b95:fb2d with SMTP id na24-20020a056871739800b0021e6b95fb2dmr2765069oac.18.1711634350467;
        Thu, 28 Mar 2024 06:59:10 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id v17-20020a056a00149100b006e631af9cefsm1386134pfu.62.2024.03.28.06.59.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Mar 2024 06:59:09 -0700 (PDT)
Date: Thu, 28 Mar 2024 21:59:05 +0800
From: Zorro Lang <zlang@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] xfs: don't run tests that require v4 file systems when
 not supported
Message-ID: <20240328135905.fw27fzpixofpp4v7@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20240328121749.15274-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240328121749.15274-1-hch@lst.de>

On Thu, Mar 28, 2024 at 01:17:49PM +0100, Christoph Hellwig wrote:
> Add a _require_xfs_nocrc helper that checks that we can mkfs and mount
> a crc=0 file systems before running tests that rely on it to avoid failures
> on kernels with CONFIG_XFS_SUPPORT_V4 disabled.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

This change makes sense to me, thanks for this update.
By searching "crc=0" in tests/xfs, I got x/096, x/078 and x/300 which
are not in this patch. Is there any reason about why they don't need it?

Thanks,
Zorro

>  common/xfs    | 10 ++++++++++
>  tests/xfs/002 |  4 +---
>  tests/xfs/045 |  1 +
>  tests/xfs/095 |  1 +
>  tests/xfs/132 |  3 ++-
>  tests/xfs/148 |  2 +-
>  tests/xfs/158 |  1 +
>  tests/xfs/160 |  1 +
>  tests/xfs/194 |  2 ++
>  tests/xfs/199 |  1 +
>  tests/xfs/263 |  1 +
>  tests/xfs/513 |  1 +
>  tests/xfs/522 |  1 +
>  tests/xfs/526 |  1 +
>  14 files changed, 25 insertions(+), 5 deletions(-)
> 
> diff --git a/common/xfs b/common/xfs
> index 65b509691..5da6987b2 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -1887,3 +1887,13 @@ _xfs_discard_max_offset_kb()
>  	$XFS_IO_PROG -c 'statfs' "$1" | \
>  		awk '{g[$1] = $3} END {print (g["geom.bsize"] * g["geom.datablocks"] / 1024)}'
>  }
> +
> +# check if mkfs and the kernel support nocrc (v4) file systems
> +_require_xfs_nocrc()
> +{
> +	_scratch_mkfs_xfs -m crc=0 > /dev/null 2>&1 || \
> +		_notrun "v4 file systems not supported"
> +	_try_scratch_mount > /dev/null 2>&1 || \
> +		_notrun "v4 file systems not supported"
> +	_scratch_unmount
> +}
> diff --git a/tests/xfs/002 b/tests/xfs/002
> index 6c0bb4d04..26d0cd6e4 100755
> --- a/tests/xfs/002
> +++ b/tests/xfs/002
> @@ -23,9 +23,7 @@ _begin_fstest auto quick growfs
>  _supported_fs xfs
>  _require_scratch_nocheck
>  _require_no_large_scratch_dev
> -
> -# So we can explicitly turn it _off_:
> -_require_xfs_mkfs_crc
> +_require_xfs_nocrc
>  
>  _scratch_mkfs_xfs -m crc=0 -d size=128m >> $seqres.full 2>&1 || _fail "mkfs failed"
>  
> diff --git a/tests/xfs/045 b/tests/xfs/045
> index d8cc9ac29..69531ba71 100755
> --- a/tests/xfs/045
> +++ b/tests/xfs/045
> @@ -22,6 +22,7 @@ _supported_fs xfs
>  
>  _require_test
>  _require_scratch_nocheck
> +_require_xfs_nocrc
>  
>  echo "*** get uuid"
>  uuid=`_get_existing_uuid`
> diff --git a/tests/xfs/095 b/tests/xfs/095
> index a3891c85e..e7dc3e9f4 100755
> --- a/tests/xfs/095
> +++ b/tests/xfs/095
> @@ -19,6 +19,7 @@ _begin_fstest log v2log auto
>  _supported_fs xfs
>  _require_scratch
>  _require_v2log
> +_require_xfs_nocrc
>  
>  if [ "$(blockdev --getss $SCRATCH_DEV)" != "512" ]; then
>  	_notrun "need 512b sector size"
> diff --git a/tests/xfs/132 b/tests/xfs/132
> index fa36c09c2..1b8de82f5 100755
> --- a/tests/xfs/132
> +++ b/tests/xfs/132
> @@ -19,12 +19,13 @@ _supported_fs xfs
>  
>  # we intentionally corrupt the filesystem, so don't check it after the test
>  _require_scratch_nocheck
> +_require_xfs_nocrc
>  
>  # on success, we'll get a shutdown filesystem with a really noisy log message
>  # due to transaction cancellation.  Hence we don't want to check dmesg here.
>  _disable_dmesg_check
>  
> -_require_xfs_mkfs_crc
> +
>  _scratch_mkfs -m crc=0 > $seqres.full 2>&1
>  
>  # The files that EIO in the golden output changes if we have quotas enabled
> diff --git a/tests/xfs/148 b/tests/xfs/148
> index 5d0a0bf42..789b8d0a4 100755
> --- a/tests/xfs/148
> +++ b/tests/xfs/148
> @@ -27,7 +27,7 @@ _cleanup()
>  _supported_fs xfs
>  _require_test
>  _require_attrs
> -_require_xfs_mkfs_crc
> +_require_xfs_nocrc
>  _disable_dmesg_check
>  
>  imgfile=$TEST_DIR/img-$seq
> diff --git a/tests/xfs/158 b/tests/xfs/158
> index 4440adf6e..0107fa3d6 100755
> --- a/tests/xfs/158
> +++ b/tests/xfs/158
> @@ -18,6 +18,7 @@ _supported_fs xfs
>  _require_scratch_xfs_inobtcount
>  _require_command "$XFS_ADMIN_PROG" "xfs_admin"
>  _require_xfs_repair_upgrade inobtcount
> +_require_xfs_nocrc
>  
>  # Make sure we can't format a filesystem with inobtcount and not finobt.
>  _scratch_mkfs -m crc=1,inobtcount=1,finobt=0 &> $seqres.full && \
> diff --git a/tests/xfs/160 b/tests/xfs/160
> index 399fe4bcf..134b38a18 100755
> --- a/tests/xfs/160
> +++ b/tests/xfs/160
> @@ -18,6 +18,7 @@ _supported_fs xfs
>  _require_command "$XFS_ADMIN_PROG" "xfs_admin"
>  _require_scratch_xfs_bigtime
>  _require_xfs_repair_upgrade bigtime
> +_require_xfs_nocrc
>  
>  date --date='Jan 1 00:00:00 UTC 2040' > /dev/null 2>&1 || \
>  	_notrun "Userspace does not support dates past 2038."
> diff --git a/tests/xfs/194 b/tests/xfs/194
> index 5a1dff5d2..2ef9403bb 100755
> --- a/tests/xfs/194
> +++ b/tests/xfs/194
> @@ -30,6 +30,8 @@ _supported_fs xfs
>  # real QA test starts here
>  
>  _require_scratch
> +_require_xfs_nocrc
> +
>  _scratch_mkfs_xfs >/dev/null 2>&1
>  
>  # For this test we use block size = 1/8 page size
> diff --git a/tests/xfs/199 b/tests/xfs/199
> index 4669f2c3e..f99b04db3 100755
> --- a/tests/xfs/199
> +++ b/tests/xfs/199
> @@ -26,6 +26,7 @@ _cleanup()
>  _supported_fs xfs
>  
>  _require_scratch
> +_require_xfs_nocrc
>  
>  # clear any mkfs options so that we can directly specify the options we need to
>  # be able to test the features bitmask behaviour correctly.
> diff --git a/tests/xfs/263 b/tests/xfs/263
> index bce4e13f9..99c97a104 100755
> --- a/tests/xfs/263
> +++ b/tests/xfs/263
> @@ -25,6 +25,7 @@ _require_xfs_quota
>  # Only test crc and beyond (but we will test with and without the feature)
>  _require_xfs_mkfs_crc
>  _require_xfs_crc
> +_require_xfs_nocrc
>  
>  function option_string()
>  {
> diff --git a/tests/xfs/513 b/tests/xfs/513
> index ce2bb3491..42eceeb90 100755
> --- a/tests/xfs/513
> +++ b/tests/xfs/513
> @@ -37,6 +37,7 @@ _fixed_by_kernel_commit 237d7887ae72 \
>  _require_test
>  _require_loop
>  _require_xfs_io_command "falloc"
> +_require_xfs_nocrc
>  
>  LOOP_IMG=$TEST_DIR/$seq.dev
>  LOOP_SPARE_IMG=$TEST_DIR/$seq.logdev
> diff --git a/tests/xfs/522 b/tests/xfs/522
> index 2475d5844..7db3bb9fc 100755
> --- a/tests/xfs/522
> +++ b/tests/xfs/522
> @@ -27,6 +27,7 @@ _supported_fs xfs
>  _require_test
>  _require_scratch_nocheck
>  _require_xfs_mkfs_cfgfile
> +_require_xfs_nocrc
>  
>  def_cfgfile=$TEST_DIR/a
>  fsimg=$TEST_DIR/a.img
> diff --git a/tests/xfs/526 b/tests/xfs/526
> index 4261e8497..188d0d514 100755
> --- a/tests/xfs/526
> +++ b/tests/xfs/526
> @@ -26,6 +26,7 @@ _supported_fs xfs
>  _require_test
>  _require_scratch_nocheck
>  _require_xfs_mkfs_cfgfile
> +_require_xfs_nocrc
>  
>  cfgfile=$TEST_DIR/a
>  rm -rf $cfgfile
> -- 
> 2.39.2
> 
> 

