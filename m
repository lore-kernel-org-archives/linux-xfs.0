Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D01832BEC22
	for <linux-xfs@vger.kernel.org>; Sat,  1 Nov 2025 09:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761988288; cv=none; b=BJZR3JngairMmUbsLqWXkvzp1ZwYbuqn6FYEryxLZOoV6uTUCdSbYk+bOKMKuHWmq3SBbyt84Z+MZtrqJqySS7SetplXZMeaj0EgMTQpJAJBJ766ZtuH3X0sdSStat6clcAS7MuIus8km1Rk+88E/UY5tmosDqVkolSfF1foIh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761988288; c=relaxed/simple;
	bh=54URsSgFHgy4NuL24nEbHm5DaT5R5aaXnivsCjBkgDk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t3mKlbH9cjEEawCngoKyBzG3dy85b3rYUyXRtC3mjIXviJycwBkf+WgJN2HuJ5MF0lFSmJDZMCe2Vx9G+xESDEPEK5V8VFzPh2jikSH4p/eMRCdrj8q1Ac3Qw/bLSk1swyxc52TlbV9fh0jOSx0ZR6YKNaXUdjvccKtSioODlaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NcA2+WJF; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=LWwZbBur; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NcA2+WJF";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="LWwZbBur"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761988284;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5u2h7nShUCXQ5DsnSoUxmGzyQUroZKYr/p8OeQCjO3o=;
	b=NcA2+WJF2J1Ah9mOZlWyRCDYnwgSJ85S7Lr4SyGR1+hGRVlV7mk/v6vC6XMaYGnlbSxfxw
	+hCboVLQ+lAnZOOCoJGa96d0048xkPCD4iEHPwcH//6QsYqDiPsKYuvaQ4b3s/li5d12DL
	pE/vTT5GiUWGH2vFXyWECqjdcVtzjow=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-554-8SsJ701lOfK7fJJ0VUOXZw-1; Sat, 01 Nov 2025 05:11:23 -0400
X-MC-Unique: 8SsJ701lOfK7fJJ0VUOXZw-1
X-Mimecast-MFC-AGG-ID: 8SsJ701lOfK7fJJ0VUOXZw_1761988282
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2956f09f382so226265ad.1
        for <linux-xfs@vger.kernel.org>; Sat, 01 Nov 2025 02:11:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1761988282; x=1762593082; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5u2h7nShUCXQ5DsnSoUxmGzyQUroZKYr/p8OeQCjO3o=;
        b=LWwZbBurtpyznAfHskrsfj1uedz2d17LnrLAndjSe6UnA0Z8ET/T40GBV5exEqIPDO
         XkZFfsRNufIMimhTxNfG6jNquhr2zpuYWdq+sxhFWuL4hml4QLA59jKdali1IhvGXY5T
         IWLedWPbrrfU3Qy5aKC0ytwJubGqOGj3c0mkTvUnARMxyQExw/dNkWPntfjSS/r94Zy6
         6LGM0LYVMppVWtZamd4VkI/4qHtdKJoArVd0i85ccE5xlPkb2CR2ApCbxeb+4S98gm2r
         BGIENaytODtLrzVMnum7F8HPVAYxYEuy/mJ8rEa+yPuz9FhXvrF0VLe+kL3HbR90Moxb
         8Lqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761988282; x=1762593082;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5u2h7nShUCXQ5DsnSoUxmGzyQUroZKYr/p8OeQCjO3o=;
        b=Ehv1F4ZgkB7qm4ZfWR4vjNTRWs1wfGhV0SD1BeG4gXO8jxhlRye4aGgL34aeW48nWb
         B/YkPbpcu1DM0PEymGWRnLFms8pCU7uYR7kcJGwXbJP1Y+8xYNs9pKG4IlNm4XzLWa+y
         4nwvEfpMAg8udjXyV7FNRJXgn0V/W9fRk1yRvEjZPVDQC1kRM6GGVwLTpPFAQnGKRLqv
         DiLVjb+4H81p6lhZ7nku8W0WtVbploxkw8eHERs7ECggFEkC5CyMIsZdyUGSdc8yE/48
         ABKO8ioo4rWG/ScCmL4tzcnGAjZrQnmfffQOY7XAmzi8ArqmaEWIWdrX4yJ57QTMXPnK
         BpKw==
X-Gm-Message-State: AOJu0YyN5Y6Sx7/qZ+QlNCbOE1XafGvajzbBvuoN5WWYqXJ+tvkm6rIR
	ARitFRetN60qJHcmCK+34aifoOEooy0UKK8DjyREus2qSPbAUIcql2M1h0C+kpnQR3SAlZEWnrH
	acMWGE85HQQ9nejZiSUFmqo6uAo05UU249TvteicG3KYiwNYwkgYfncYV/KVQpQ==
X-Gm-Gg: ASbGnctVZ3o4OUFRfyJ0etVUMBo5sU3ujv6oFZos8MfyhfKpDQZx5/KaOws5VpSp7Hp
	4+mYA6GN0LsQgBQwIhl7Og6cOWO8BkWEFTPguVuu/At42nquQ8XM32c9L02tIh3NGQL1k7cS5cd
	r/wxAwdkevoyw7c+9JIw+jpPY8A0/nerPXEZSCe6qHSGwqUyKOgQ0wqcK9A0ilFWMu7Fu6HpsGD
	wYtNC+Dds27z0TmqJpC0uSiAnhet7AKezKievehFFfpkNyup6YkExAXgdiiP9OkLkGSYlrHT0Ia
	4yyDzwUSsK89z1my6kYPoutH3wUiIbkc5rUz+efp+zwJwCOEkCEkyGIGZVSWMCncd7976aoJWP4
	sAtsvts47I4Kt+e8Uw/x2Vi9zrOkpYQrFZ+YH/NY=
X-Received: by 2002:a17:903:18e:b0:269:aba9:ffd7 with SMTP id d9443c01a7336-294ed2c3b0amr121216425ad.25.1761988282166;
        Sat, 01 Nov 2025 02:11:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFH+DIOhp13qqsUAXmoawC3bB+CBlbnWT0maLvrAkQgeWP2EVykWByZcpcQrB5QYMOe7R7PHQ==
X-Received: by 2002:a17:903:18e:b0:269:aba9:ffd7 with SMTP id d9443c01a7336-294ed2c3b0amr121216255ad.25.1761988281681;
        Sat, 01 Nov 2025 02:11:21 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-295269bdfb9sm49534635ad.103.2025.11.01.02.11.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Nov 2025 02:11:20 -0700 (PDT)
Date: Sat, 1 Nov 2025 17:11:15 +0800
From: Zorro Lang <zlang@redhat.com>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, djwong@kernel.org,
	aalbersh@kernel.org
Subject: Re: [PATCH v2 1/2] generic/772: require filesystem to support
 file_[g|s]etattr
Message-ID: <20251101091115.xhdtoaq6erv3hzpt@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <cover.1761838171.patch-series@thinky>
 <lwdr5ntyyszcvqe75ljcqtpcrtjioopoa3abm4fjrdupfmrmx7@2jebme2cchx7>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <lwdr5ntyyszcvqe75ljcqtpcrtjioopoa3abm4fjrdupfmrmx7@2jebme2cchx7>

On Thu, Oct 30, 2025 at 04:30:20PM +0100, Andrey Albershteyn wrote:
> Add _require_* function to check that filesystem support these syscalls
> on regular and special files.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> ---

Thanks for doing this, that's more clear for me now:) I think this patch bases
on another patch from Darrick. I'll merge his patch at first, then merge this
one.

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  common/rc         | 32 ++++++++++++++++++++++++++++++++
>  tests/generic/772 |  4 +---
>  tests/xfs/648     |  6 ++----
>  3 files changed, 35 insertions(+), 7 deletions(-)
> 
> diff --git a/common/rc b/common/rc
> index 462f433197..be3cdd8d64 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -6032,6 +6032,38 @@
>  	esac
>  }
>  
> +# Require filesystem to support file_getattr()/file_setattr() syscalls on
> +# regular files
> +_require_file_attr()
> +{
> +	local test_file="$TEST_DIR/foo"
> +	touch $test_file
> +
> +	$here/src/file_attr --set --set-nodump $TEST_DIR ./foo &>/dev/null
> +	rc=$?
> +	rm -f "$test_file"
> +
> +	if [ $rc -ne 0 ]; then
> +		_notrun "file_getattr not supported for regular files on $FSTYP"
> +	fi
> +}
> +
> +# Require filesystem to support file_getattr()/file_setattr() syscalls on
> +# special files (chardev, fifo...)
> +_require_file_attr_special()
> +{
> +	local test_file="$TEST_DIR/fifo"
> +	mkfifo $test_file
> +
> +	$here/src/file_attr --set --set-nodump $TEST_DIR ./fifo &>/dev/null
> +	rc=$?
> +	rm -f "$test_file"
> +
> +	if [ $rc -ne 0 ]; then
> +		_notrun "file_getattr not supported for special files on $FSTYP"
> +	fi
> +}
> +
>  ################################################################################
>  # make sure this script returns success
>  /bin/true
> diff --git a/tests/generic/772 b/tests/generic/772
> index cdadf09ff2..dba1ee7f50 100755
> --- a/tests/generic/772
> +++ b/tests/generic/772
> @@ -17,6 +17,7 @@
>  _require_test_program "file_attr"
>  _require_symlinks
>  _require_mknod
> +_require_file_attr
>  
>  _scratch_mkfs >>$seqres.full 2>&1
>  _scratch_mount
> @@ -43,9 +44,6 @@
>  ln -s $projectdir/bar $projectdir/broken-symlink
>  rm -f $projectdir/bar
>  
> -file_attr --get $projectdir ./fifo &>/dev/null || \
> -	_notrun "file_getattr not supported on $FSTYP"
> -
>  echo "Error codes"
>  # wrong AT_ flags
>  file_attr --get --invalid-at $projectdir ./foo
> diff --git a/tests/xfs/648 b/tests/xfs/648
> index e3c2fbe00b..58e5aa8c5b 100755
> --- a/tests/xfs/648
> +++ b/tests/xfs/648
> @@ -20,7 +20,8 @@
>  _require_test_program "file_attr"
>  _require_symlinks
>  _require_mknod
> -
> +_require_file_attr
> +_require_file_attr_special
>  _scratch_mkfs >>$seqres.full 2>&1
>  _qmount_option "pquota"
>  _scratch_mount
> @@ -47,9 +48,6 @@
>  ln -s $projectdir/bar $projectdir/broken-symlink
>  rm -f $projectdir/bar
>  
> -$here/src/file_attr --get $projectdir ./fifo &>/dev/null || \
> -	_notrun "file_getattr not supported on $FSTYP"
> -
>  $XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
>  	-c "project -sp $projectdir $id" $SCRATCH_DEV | filter_quota
>  $XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
> 
> -- 
> - Andrey
> 
> 

